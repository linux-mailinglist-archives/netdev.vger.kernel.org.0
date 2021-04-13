Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53DAD35D5BE
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 05:15:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344353AbhDMDPz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 23:15:55 -0400
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:33126 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242050AbhDMDPq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 23:15:46 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R881e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=15;SR=0;TI=SMTPD_---0UVPZqgj_1618283724;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0UVPZqgj_1618283724)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 13 Apr 2021 11:15:25 +0800
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
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org,
        "dust . li" <dust.li@linux.alibaba.com>
Subject: [PATCH net-next v4 04/10] xsk: support get page by addr
Date:   Tue, 13 Apr 2021 11:15:17 +0800
Message-Id: <20210413031523.73507-5-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210413031523.73507-1-xuanzhuo@linux.alibaba.com>
References: <20210413031523.73507-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

xsk adds an interface and returns the page corresponding to
data. virtio-net does not initialize dma, so it needs page to construct
scatterlist to pass to vring.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Reviewed-by: Dust Li <dust.li@linux.alibaba.com>
---
 include/net/xdp_sock_drv.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/include/net/xdp_sock_drv.h b/include/net/xdp_sock_drv.h
index 4e295541e396..1d08b5d8d15f 100644
--- a/include/net/xdp_sock_drv.h
+++ b/include/net/xdp_sock_drv.h
@@ -72,6 +72,12 @@ static inline dma_addr_t xsk_buff_xdp_get_frame_dma(struct xdp_buff *xdp)
 	return xp_get_frame_dma(xskb);
 }
 
+static inline struct page *xsk_buff_xdp_get_page(struct xsk_buff_pool *pool, u64 addr)
+{
+	addr = pool->unaligned ? xp_unaligned_add_offset_to_addr(addr) : addr;
+	return pool->umem->pgs[addr >> PAGE_SHIFT];
+}
+
 static inline struct xdp_buff *xsk_buff_alloc(struct xsk_buff_pool *pool)
 {
 	return xp_alloc(pool);
@@ -207,6 +213,11 @@ static inline dma_addr_t xsk_buff_xdp_get_frame_dma(struct xdp_buff *xdp)
 	return 0;
 }
 
+static inline struct page *xsk_buff_xdp_get_page(struct xsk_buff_pool *pool, u64 addr)
+{
+	return NULL;
+}
+
 static inline struct xdp_buff *xsk_buff_alloc(struct xsk_buff_pool *pool)
 {
 	return NULL;
-- 
2.31.0

