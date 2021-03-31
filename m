Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22C7E34F989
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 09:12:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234024AbhCaHMT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 03:12:19 -0400
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:57785 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233912AbhCaHLp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 03:11:45 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=20;SR=0;TI=SMTPD_---0UTvslU-_1617174702;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0UTvslU-_1617174702)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 31 Mar 2021 15:11:42 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     netdev@vger.kernel.org
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org,
        Dust Li <dust.li@linux.alibaba.com>
Subject: [PATCH net-next v3 6/8] virtio-net: xsk zero copy xmit kick by threshold
Date:   Wed, 31 Mar 2021 15:11:37 +0800
Message-Id: <20210331071139.15473-7-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210331071139.15473-1-xuanzhuo@linux.alibaba.com>
References: <20210331071139.15473-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After testing, the performance of calling kick every time is not stable.
And if all the packets are sent and kicked again, the performance is not
good. So add a module parameter to specify how many packets are sent to
call a kick.

8 is a relatively stable value with the best performance.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Reviewed-by: Dust Li <dust.li@linux.alibaba.com>
---
 drivers/net/virtio_net.c | 23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 259fafcf6028..d7e95f55478d 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -29,10 +29,12 @@ module_param(napi_weight, int, 0444);
 
 static bool csum = true, gso = true, napi_tx = true;
 static int xsk_budget = 32;
+static int xsk_kick_thr = 8;
 module_param(csum, bool, 0444);
 module_param(gso, bool, 0444);
 module_param(napi_tx, bool, 0644);
 module_param(xsk_budget, int, 0644);
+module_param(xsk_kick_thr, int, 0644);
 
 /* FIXME: MTU in config. */
 #define GOOD_PACKET_LEN (ETH_HLEN + VLAN_HLEN + ETH_DATA_LEN)
@@ -2612,6 +2614,8 @@ static int virtnet_xsk_xmit_batch(struct send_queue *sq,
 	struct xdp_desc desc;
 	int err, packet = 0;
 	int ret = -EAGAIN;
+	int need_kick = 0;
+	int kicks = 0;
 
 	if (sq->xsk.last_desc.addr) {
 		err = virtnet_xsk_xmit(sq, pool, &sq->xsk.last_desc);
@@ -2619,6 +2623,7 @@ static int virtnet_xsk_xmit_batch(struct send_queue *sq,
 			return -EBUSY;
 
 		++packet;
+		++need_kick;
 		--budget;
 		sq->xsk.last_desc.addr = 0;
 	}
@@ -2642,13 +2647,25 @@ static int virtnet_xsk_xmit_batch(struct send_queue *sq,
 		}
 
 		++packet;
+		++need_kick;
+		if (need_kick > xsk_kick_thr) {
+			if (virtqueue_kick_prepare(sq->vq) &&
+			    virtqueue_notify(sq->vq))
+				++kicks;
+
+			need_kick = 0;
+		}
 	}
 
 	if (packet) {
-		if (virtqueue_kick_prepare(sq->vq) &&
-		    virtqueue_notify(sq->vq)) {
+		if (need_kick) {
+			if (virtqueue_kick_prepare(sq->vq) &&
+			    virtqueue_notify(sq->vq))
+				++kicks;
+		}
+		if (kicks) {
 			u64_stats_update_begin(&sq->stats.syncp);
-			sq->stats.kicks += 1;
+			sq->stats.kicks += kicks;
 			u64_stats_update_end(&sq->stats.syncp);
 		}
 
-- 
2.31.0

