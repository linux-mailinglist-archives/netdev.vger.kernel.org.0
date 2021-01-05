Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 277972EA714
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 10:13:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727895AbhAEJM4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 04:12:56 -0500
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:52590 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727225AbhAEJMa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 04:12:30 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=alimailimapcm10staff010182156082;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=22;SR=0;TI=SMTPD_---0UKoYpcb_1609837905;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0UKoYpcb_1609837905)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 05 Jan 2021 17:11:45 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     netdev@vger.kernel.org
Cc:     dust.li@linux.alibaba.com, tonylu@linux.alibaba.com,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
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
        virtualization@lists.linux-foundation.org (open list:VIRTIO CORE AND
        NET DRIVERS), linux-kernel@vger.kernel.org (open list),
        bpf@vger.kernel.org (open list:XDP SOCKETS (AF_XDP))
Subject: [PATCH netdev 1/5] xsk: support get page for drv
Date:   Tue,  5 Jan 2021 17:11:39 +0800
Message-Id: <e60669f8a573bed3b6a33bc18878f3496be5c2f5.1609837120.git.xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <cover.1609837120.git.xuanzhuo@linux.alibaba.com>
References: <cover.1609837120.git.xuanzhuo@linux.alibaba.com>
In-Reply-To: <cover.1609837120.git.xuanzhuo@linux.alibaba.com>
References: <cover.1609837120.git.xuanzhuo@linux.alibaba.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For some drivers, such as virtio-net, we do not configure dma when
binding xsk. We will get the page when sending.

This patch participates in a field need_dma during the setup pool. If
the device does not use dma, this value should be set to false.

And a function xsk_buff_raw_get_page is added to get the page based on
addr in drv.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 include/linux/netdevice.h   |  1 +
 include/net/xdp_sock_drv.h  | 10 ++++++++++
 include/net/xsk_buff_pool.h |  1 +
 net/xdp/xsk_buff_pool.c     | 10 +++++++++-
 4 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 7bf1679..b8baef9 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -915,6 +915,7 @@ struct netdev_bpf {
 		struct {
 			struct xsk_buff_pool *pool;
 			u16 queue_id;
+			bool need_dma;
 		} xsk;
 	};
 };
diff --git a/include/net/xdp_sock_drv.h b/include/net/xdp_sock_drv.h
index 4e295541..e9c7e25 100644
--- a/include/net/xdp_sock_drv.h
+++ b/include/net/xdp_sock_drv.h
@@ -100,6 +100,11 @@ static inline void *xsk_buff_raw_get_data(struct xsk_buff_pool *pool, u64 addr)
 	return xp_raw_get_data(pool, addr);
 }
 
+static inline struct page *xsk_buff_raw_get_page(struct xsk_buff_pool *pool, u64 addr)
+{
+	return xp_raw_get_page(pool, addr);
+}
+
 static inline void xsk_buff_dma_sync_for_cpu(struct xdp_buff *xdp, struct xsk_buff_pool *pool)
 {
 	struct xdp_buff_xsk *xskb = container_of(xdp, struct xdp_buff_xsk, xdp);
@@ -232,6 +237,11 @@ static inline void *xsk_buff_raw_get_data(struct xsk_buff_pool *pool, u64 addr)
 	return NULL;
 }
 
+static inline struct page *xsk_buff_raw_get_page(struct xsk_buff_pool *pool, u64 addr)
+{
+	return NULL;
+}
+
 static inline void xsk_buff_dma_sync_for_cpu(struct xdp_buff *xdp, struct xsk_buff_pool *pool)
 {
 }
diff --git a/include/net/xsk_buff_pool.h b/include/net/xsk_buff_pool.h
index 01755b8..54e461d 100644
--- a/include/net/xsk_buff_pool.h
+++ b/include/net/xsk_buff_pool.h
@@ -103,6 +103,7 @@ int xp_dma_map(struct xsk_buff_pool *pool, struct device *dev,
 bool xp_can_alloc(struct xsk_buff_pool *pool, u32 count);
 void *xp_raw_get_data(struct xsk_buff_pool *pool, u64 addr);
 dma_addr_t xp_raw_get_dma(struct xsk_buff_pool *pool, u64 addr);
+struct page *xp_raw_get_page(struct xsk_buff_pool *pool, u64 addr);
 static inline dma_addr_t xp_get_dma(struct xdp_buff_xsk *xskb)
 {
 	return xskb->dma;
diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
index 67a4494..9bb058f 100644
--- a/net/xdp/xsk_buff_pool.c
+++ b/net/xdp/xsk_buff_pool.c
@@ -167,12 +167,13 @@ static int __xp_assign_dev(struct xsk_buff_pool *pool,
 	bpf.command = XDP_SETUP_XSK_POOL;
 	bpf.xsk.pool = pool;
 	bpf.xsk.queue_id = queue_id;
+	bpf.xsk.need_dma = true;
 
 	err = netdev->netdev_ops->ndo_bpf(netdev, &bpf);
 	if (err)
 		goto err_unreg_pool;
 
-	if (!pool->dma_pages) {
+	if (bpf.xsk.need_dma && !pool->dma_pages) {
 		WARN(1, "Driver did not DMA map zero-copy buffers");
 		err = -EINVAL;
 		goto err_unreg_xsk;
@@ -536,6 +537,13 @@ void *xp_raw_get_data(struct xsk_buff_pool *pool, u64 addr)
 }
 EXPORT_SYMBOL(xp_raw_get_data);
 
+struct page *xp_raw_get_page(struct xsk_buff_pool *pool, u64 addr)
+{
+	addr = pool->unaligned ? xp_unaligned_add_offset_to_addr(addr) : addr;
+	return pool->umem->pgs[addr >> PAGE_SHIFT];
+}
+EXPORT_SYMBOL(xp_raw_get_page);
+
 dma_addr_t xp_raw_get_dma(struct xsk_buff_pool *pool, u64 addr)
 {
 	addr = pool->unaligned ? xp_unaligned_add_offset_to_addr(addr) : addr;
-- 
1.8.3.1

