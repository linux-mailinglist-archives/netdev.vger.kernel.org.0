Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49D386E9248
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 13:20:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234703AbjDTLUR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 07:20:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234673AbjDTLT6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 07:19:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99CCB4ED4;
        Thu, 20 Apr 2023 04:17:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EE5C7617E4;
        Thu, 20 Apr 2023 11:16:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09204C433D2;
        Thu, 20 Apr 2023 11:16:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681989407;
        bh=pOMDMa6JjIw/9qNkfrOhT0++9NHUZznsO4iKbNgctV8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cs9bgB54WEBdwP8kiWRRbA53flbz/yLuxz/vkgH2BYX5XzoyifrnucV4O/EhMtCLj
         QKSwpkkvyfTL1YGsf9ABkC3fm568ANeWsUHQncCJ+FauuJVCyzv2zSXqi7VaZ15ZcM
         fjsF2ub07FW1gLlJTzYcQgN1xfT0Nk79s/WE8F49z0HduDaioOvS/25IyWHCBLKm6S
         ffsuYgUjcxRKR5S10KBldginW3I0WNMwfIoE7iKQHmed0uoHISKYY8SDhxFmugC8jz
         kRIGK/a6PS6kb3NPau8eKcVzrQ9biNnEf+k8ilkMZH4H3SwUWrSejfL8h8qmuRzRY6
         uEYK729zf6nSg==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        toke@redhat.com, mtahhan@redhat.com, lorenzo.bianconi@redhat.com
Subject: [PATCH net-next 1/2] net: veth: add page_pool for page recycling
Date:   Thu, 20 Apr 2023 13:16:21 +0200
Message-Id: <b1c7efdc33221fdb588995b385415d68b149aa73.1681987376.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <cover.1681987376.git.lorenzo@kernel.org>
References: <cover.1681987376.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce page_pool support in veth driver in order to recycle pages
in veth_convert_skb_to_xdp_buff routine and avoid reallocating the skb
through the page allocator.
The patch has been sending tcp traffic to a veth pair where the remote
peer is running a simple xdp program just returing xdp_pass:

veth upstream codebase:
MTU 1500B: ~ 8Gbps
MTU 8000B: ~ 13.9Gbps

veth upstream codebase + pp support:
MTU 1500B: ~ 9.2Gbps
MTU 8000B: ~ 16.2Gbps

Tested-by: Maryam Tahhan <mtahhan@redhat.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/Kconfig |  1 +
 drivers/net/veth.c  | 54 ++++++++++++++++++++++++++++++++++++++++-----
 2 files changed, 50 insertions(+), 5 deletions(-)

diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index c34bd432da27..368c6f5b327e 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -402,6 +402,7 @@ config TUN_VNET_CROSS_LE
 
 config VETH
 	tristate "Virtual ethernet pair device"
+	select PAGE_POOL
 	help
 	  This device is a local ethernet tunnel. Devices are created in pairs.
 	  When one end receives the packet it appears on its pair and vice
diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index e1b38fbf1dd9..141b7745ba43 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -26,6 +26,7 @@
 #include <linux/ptr_ring.h>
 #include <linux/bpf_trace.h>
 #include <linux/net_tstamp.h>
+#include <net/page_pool.h>
 
 #define DRV_NAME	"veth"
 #define DRV_VERSION	"1.0"
@@ -65,6 +66,7 @@ struct veth_rq {
 	bool			rx_notify_masked;
 	struct ptr_ring		xdp_ring;
 	struct xdp_rxq_info	xdp_rxq;
+	struct page_pool	*page_pool;
 };
 
 struct veth_priv {
@@ -711,8 +713,8 @@ static int veth_convert_skb_to_xdp_buff(struct veth_rq *rq,
 	    skb_shinfo(skb)->nr_frags ||
 	    skb_headroom(skb) < XDP_PACKET_HEADROOM) {
 		u32 size, len, max_head_size, off;
+		struct page *page = NULL;
 		struct sk_buff *nskb;
-		struct page *page;
 		int i, head_off;
 
 		/* We need a private copy of the skb and data buffers since
@@ -727,17 +729,21 @@ static int veth_convert_skb_to_xdp_buff(struct veth_rq *rq,
 			goto drop;
 
 		/* Allocate skb head */
-		page = alloc_page(GFP_ATOMIC | __GFP_NOWARN);
+		if (rq->page_pool)
+			page = page_pool_dev_alloc_pages(rq->page_pool);
 		if (!page)
 			goto drop;
 
 		nskb = build_skb(page_address(page), PAGE_SIZE);
 		if (!nskb) {
-			put_page(page);
+			page_pool_put_full_page(rq->page_pool, page, false);
 			goto drop;
 		}
 
 		skb_reserve(nskb, VETH_XDP_HEADROOM);
+		skb_copy_header(nskb, skb);
+		skb_mark_for_recycle(nskb);
+
 		size = min_t(u32, skb->len, max_head_size);
 		if (skb_copy_bits(skb, 0, nskb->data, size)) {
 			consume_skb(nskb);
@@ -745,16 +751,17 @@ static int veth_convert_skb_to_xdp_buff(struct veth_rq *rq,
 		}
 		skb_put(nskb, size);
 
-		skb_copy_header(nskb, skb);
 		head_off = skb_headroom(nskb) - skb_headroom(skb);
 		skb_headers_offset_update(nskb, head_off);
 
 		/* Allocate paged area of new skb */
 		off = size;
 		len = skb->len - off;
+		page = NULL;
 
 		for (i = 0; i < MAX_SKB_FRAGS && off < skb->len; i++) {
-			page = alloc_page(GFP_ATOMIC | __GFP_NOWARN);
+			if (rq->page_pool)
+				page = page_pool_dev_alloc_pages(rq->page_pool);
 			if (!page) {
 				consume_skb(nskb);
 				goto drop;
@@ -770,6 +777,7 @@ static int veth_convert_skb_to_xdp_buff(struct veth_rq *rq,
 
 			len -= size;
 			off += size;
+			page = NULL;
 		}
 
 		consume_skb(skb);
@@ -1002,11 +1010,37 @@ static int veth_poll(struct napi_struct *napi, int budget)
 	return done;
 }
 
+static int veth_create_page_pool(struct veth_rq *rq)
+{
+	struct page_pool_params pp_params = {
+		.order = 0,
+		.pool_size = VETH_RING_SIZE,
+		.nid = NUMA_NO_NODE,
+		.dev = &rq->dev->dev,
+	};
+
+	rq->page_pool = page_pool_create(&pp_params);
+	if (IS_ERR(rq->page_pool)) {
+		int err = PTR_ERR(rq->page_pool);
+
+		rq->page_pool = NULL;
+		return err;
+	}
+
+	return 0;
+}
+
 static int __veth_napi_enable_range(struct net_device *dev, int start, int end)
 {
 	struct veth_priv *priv = netdev_priv(dev);
 	int err, i;
 
+	for (i = start; i < end; i++) {
+		err = veth_create_page_pool(&priv->rq[i]);
+		if (err)
+			goto err_page_pool;
+	}
+
 	for (i = start; i < end; i++) {
 		struct veth_rq *rq = &priv->rq[i];
 
@@ -1027,6 +1061,11 @@ static int __veth_napi_enable_range(struct net_device *dev, int start, int end)
 err_xdp_ring:
 	for (i--; i >= start; i--)
 		ptr_ring_cleanup(&priv->rq[i].xdp_ring, veth_ptr_free);
+err_page_pool:
+	for (i = start; i < end; i++) {
+		page_pool_destroy(priv->rq[i].page_pool);
+		priv->rq[i].page_pool = NULL;
+	}
 
 	return err;
 }
@@ -1056,6 +1095,11 @@ static void veth_napi_del_range(struct net_device *dev, int start, int end)
 		rq->rx_notify_masked = false;
 		ptr_ring_cleanup(&rq->xdp_ring, veth_ptr_free);
 	}
+
+	for (i = start; i < end; i++) {
+		page_pool_destroy(priv->rq[i].page_pool);
+		priv->rq[i].page_pool = NULL;
+	}
 }
 
 static void veth_napi_del(struct net_device *dev)
-- 
2.40.0

