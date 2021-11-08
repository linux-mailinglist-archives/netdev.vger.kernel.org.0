Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F835447F24
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 12:50:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239336AbhKHLwl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 06:52:41 -0500
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:34867 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231401AbhKHLwj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Nov 2021 06:52:39 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R551e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0Uvb9Wd2_1636372192;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0Uvb9Wd2_1636372192)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 08 Nov 2021 19:49:53 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH v4 3/3] virtio-net: enable virtio desc cache
Date:   Mon,  8 Nov 2021 19:49:51 +0800
Message-Id: <20211108114951.92862-4-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20211108114951.92862-1-xuanzhuo@linux.alibaba.com>
References: <20211108114951.92862-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the VIRTIO_RING_F_INDIRECT_DESC negotiation succeeds, and the number
of sgs used for sending packets is greater than 1. We must constantly
call __kmalloc/kfree to allocate/release desc.

In the case of extremely fast package delivery, the overhead cannot be
ignored:

  27.46%  [kernel]  [k] virtqueue_add
  16.66%  [kernel]  [k] detach_buf_split
  16.51%  [kernel]  [k] virtnet_xsk_xmit
  14.04%  [kernel]  [k] virtqueue_add_outbuf
>  5.18%  [kernel]  [k] __kmalloc
>  4.08%  [kernel]  [k] kfree
   2.80%  [kernel]  [k] virtqueue_get_buf_ctx
   2.22%  [kernel]  [k] xsk_tx_peek_desc
   2.08%  [kernel]  [k] memset_erms
   0.83%  [kernel]  [k] virtqueue_kick_prepare
   0.76%  [kernel]  [k] virtnet_xsk_run
   0.62%  [kernel]  [k] __free_old_xmit_ptr
   0.60%  [kernel]  [k] vring_map_one_sg
   0.53%  [kernel]  [k] native_apic_mem_write
   0.46%  [kernel]  [k] sg_next
   0.43%  [kernel]  [k] sg_init_table
>  0.41%  [kernel]  [k] kmalloc_slab

Compared to not using virtio indirect cache, virtio-net can get a 16%
performance improvement when using virtio desc cache.

In the test case, the CPU where the package is sent has reached 100%.
The following are the PPS in two cases:

    indirect desc cache  | no cache
    3074658              | 2685132
    3111866              | 2666118
    3152527              | 2653632
    3125867              | 2669820
    3027147              | 2644464
    3069211              | 2669777
    3038522              | 2675645
    3034507              | 2671302
    3102257              | 2685504
    3083712              | 2692800
    3051771              | 2676928
    3080684              | 2695040
    3147816              | 2720876
    3123887              | 2705492
    3180963              | 2699520
    3191579              | 2676480
    3161670              | 2686272
    3189768              | 2692588
    3174272              | 2686692
    3143434              | 2682416

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/net/virtio_net.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 9ff2ef9dceca..193c8b38433e 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -42,6 +42,9 @@ module_param(csum, bool, 0444);
 module_param(gso, bool, 0444);
 module_param(napi_tx, bool, 0644);
 
+static u32 virtio_desc_cache_threshold = MAX_SKB_FRAGS + 2;
+module_param(virtio_desc_cache_threshold, uint, 0644);
+
 /* FIXME: MTU in config. */
 #define GOOD_PACKET_LEN (ETH_HLEN + VLAN_HLEN + ETH_DATA_LEN)
 #define GOOD_COPY_LEN	128
@@ -3350,10 +3353,10 @@ static unsigned int mergeable_min_buf_len(struct virtnet_info *vi, struct virtqu
 
 static int virtnet_find_vqs(struct virtnet_info *vi)
 {
+	int i, total_vqs, threshold;
 	vq_callback_t **callbacks;
 	struct virtqueue **vqs;
 	int ret = -ENOMEM;
-	int i, total_vqs;
 	const char **names;
 	bool *ctx;
 
@@ -3411,10 +3414,17 @@ static int virtnet_find_vqs(struct virtnet_info *vi)
 			vi->dev->features |= NETIF_F_HW_VLAN_CTAG_FILTER;
 	}
 
+	threshold = min_t(u32, virtio_desc_cache_threshold, 2 + MAX_SKB_FRAGS);
+
 	for (i = 0; i < vi->max_queue_pairs; i++) {
 		vi->rq[i].vq = vqs[rxq2vq(i)];
 		vi->rq[i].min_buf_len = mergeable_min_buf_len(vi, vi->rq[i].vq);
 		vi->sq[i].vq = vqs[txq2vq(i)];
+
+		if (!vi->mergeable_rx_bufs && vi->big_packets)
+			virtqueue_set_desc_cache(vi->rq[i].vq, MAX_SKB_FRAGS + 2);
+
+		virtqueue_set_desc_cache(vi->sq[i].vq, threshold);
 	}
 
 	/* run here: ret == 0. */
-- 
2.31.0

