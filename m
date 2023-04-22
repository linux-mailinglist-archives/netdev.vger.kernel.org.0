Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED2176EBAEF
	for <lists+netdev@lfdr.de>; Sat, 22 Apr 2023 20:54:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229661AbjDVSyc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Apr 2023 14:54:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbjDVSya (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Apr 2023 14:54:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E90E1BC2;
        Sat, 22 Apr 2023 11:54:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EA33260AB0;
        Sat, 22 Apr 2023 18:54:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A244C433A0;
        Sat, 22 Apr 2023 18:54:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682189668;
        bh=KLqx6yC12UXEYZg7o8SAz+6BT/21nAdnzTXc052m+uc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i4vvZ/Eo4SQpTd2/lJzqOheBs1ezefxyxgRAwtkXyFrQBWra0Z9L5ufBU8f0HlU6S
         N1jy+keGCG6LL0TfKVcUkIS03FYD+YeqbyTZkY2+qUqGJ1F37+yVWvVG0lDWy/mxbL
         J0p0K2R9bYklpEOoBYqtz3FFhDjxxAmr2/Ks9ITUpXSAZCHMTMLzQZhRe99P32slWX
         BTqFaL8K2uRHWfERiMFLOjoAofDoNRADufTVVSh00d0cQr4uT/cuwvdbRU16X+RppW
         UrQMRC1Ak9oZdLVpvfULDhdRkgdTH6Jo6zGayKyWephIwjlheeK+XcWcVYTUHrseII
         yY8YSQ9NDebDQ==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, lorenzo.bianconi@redhat.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, hawk@kernel.org, john.fastabend@gmail.com,
        ast@kernel.org, daniel@iogearbox.net
Subject: [PATCH v2 net-next 1/2] net: veth: add page_pool for page recycling
Date:   Sat, 22 Apr 2023 20:54:32 +0200
Message-Id: <6298f73f7cc7391c7c4a52a6a89b1ae21488bda1.1682188837.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <cover.1682188837.git.lorenzo@kernel.org>
References: <cover.1682188837.git.lorenzo@kernel.org>
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
The patch has been tested sending tcp traffic to a veth pair where the
remote peer is running a simple xdp program just returning xdp_pass:

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
 drivers/net/veth.c  | 48 +++++++++++++++++++++++++++++++++++++++++----
 2 files changed, 45 insertions(+), 4 deletions(-)

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
index 4b3c6647edc6..35d2285dec25 100644
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
@@ -727,17 +729,20 @@ static int veth_convert_skb_to_xdp_buff(struct veth_rq *rq,
 			goto drop;
 
 		/* Allocate skb head */
-		page = alloc_page(GFP_ATOMIC | __GFP_NOWARN);
+		page = page_pool_dev_alloc_pages(rq->page_pool);
 		if (!page)
 			goto drop;
 
 		nskb = build_skb(page_address(page), PAGE_SIZE);
 		if (!nskb) {
-			put_page(page);
+			page_pool_put_full_page(rq->page_pool, page, true);
 			goto drop;
 		}
 
 		skb_reserve(nskb, VETH_XDP_HEADROOM);
+		skb_copy_header(nskb, skb);
+		skb_mark_for_recycle(nskb);
+
 		size = min_t(u32, skb->len, max_head_size);
 		if (skb_copy_bits(skb, 0, nskb->data, size)) {
 			consume_skb(nskb);
@@ -745,7 +750,6 @@ static int veth_convert_skb_to_xdp_buff(struct veth_rq *rq,
 		}
 		skb_put(nskb, size);
 
-		skb_copy_header(nskb, skb);
 		head_off = skb_headroom(nskb) - skb_headroom(skb);
 		skb_headers_offset_update(nskb, head_off);
 
@@ -754,7 +758,7 @@ static int veth_convert_skb_to_xdp_buff(struct veth_rq *rq,
 		len = skb->len - off;
 
 		for (i = 0; i < MAX_SKB_FRAGS && off < skb->len; i++) {
-			page = alloc_page(GFP_ATOMIC | __GFP_NOWARN);
+			page = page_pool_dev_alloc_pages(rq->page_pool);
 			if (!page) {
 				consume_skb(nskb);
 				goto drop;
@@ -1002,11 +1006,37 @@ static int veth_poll(struct napi_struct *napi, int budget)
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
 
@@ -1027,6 +1057,11 @@ static int __veth_napi_enable_range(struct net_device *dev, int start, int end)
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
@@ -1056,6 +1091,11 @@ static void veth_napi_del_range(struct net_device *dev, int start, int end)
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

