Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07DBE43DF32
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 12:49:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230122AbhJ1Kvt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 06:51:49 -0400
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:54706 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229835AbhJ1Kvs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 06:51:48 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R521e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0Uu.SeFI_1635418159;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0Uu.SeFI_1635418159)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 28 Oct 2021 18:49:19 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH v2 0/3] virtio support cache indirect desc
Date:   Thu, 28 Oct 2021 18:49:16 +0800
Message-Id: <20211028104919.3393-1-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.31.0
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
   5.18%  [kernel]  [k] __kmalloc
   4.08%  [kernel]  [k] kfree
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
   0.41%  [kernel]  [k] kmalloc_slab

This patch adds a cache function to virtio to cache these allocated indirect
desc instead of constantly allocating and releasing desc.

v2:
  use struct list_head to cache the desc

Xuan Zhuo (3):
  virtio: cache indirect desc for split
  virtio: cache indirect desc for packed
  virtio-net: enable virtio indirect cache

 drivers/net/virtio_net.c     |  12 ++++
 drivers/virtio/virtio.c      |   6 ++
 drivers/virtio/virtio_ring.c | 104 +++++++++++++++++++++++++++++------
 include/linux/virtio.h       |  14 +++++
 4 files changed, 119 insertions(+), 17 deletions(-)

--
2.31.0

