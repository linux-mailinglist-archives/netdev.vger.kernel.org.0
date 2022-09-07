Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90CE25B090E
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 17:46:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229785AbiIGPqX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 11:46:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbiIGPqN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 11:46:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91FED6CF7C
        for <netdev@vger.kernel.org>; Wed,  7 Sep 2022 08:46:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662565571;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=A559hgNhNxZLa/lcKgd8/J/9OLu6thHW1dOCvPXH/Cw=;
        b=TONa26D2EjRJX/xIeh1JnArf1O+1lXVKSXXp8QEOqW5Nobiz5xK2OsWpD92GQU9wzFTHSS
        ICGWEfvUtHRoO9qf6A51ikaptb8CejL/s+YPIEb6WN0fgqzxfjVaaiTFb0cOSPB+P0D5MI
        2LksLa2bvyKwkI2bOnbjb+zZSulDUEI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-620-Y5EFfDaTN2euBjOXU9qFmA-1; Wed, 07 Sep 2022 11:46:08 -0400
X-MC-Unique: Y5EFfDaTN2euBjOXU9qFmA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CA63D811E87;
        Wed,  7 Sep 2022 15:46:07 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 66F4D945D2;
        Wed,  7 Sep 2022 15:46:07 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 5EA5530721A6C;
        Wed,  7 Sep 2022 17:46:06 +0200 (CEST)
Subject: [PATCH RFCv2 bpf-next 13/18] mvneta: add XDP-hints support
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     bpf@vger.kernel.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        xdp-hints@xdp-project.net, larysa.zaremba@intel.com,
        memxor@gmail.com, Lorenzo Bianconi <lorenzo@kernel.org>,
        mtahhan@redhat.com,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        dave@dtucker.co.uk, Magnus Karlsson <magnus.karlsson@intel.com>,
        bjorn@kernel.org
Date:   Wed, 07 Sep 2022 17:46:06 +0200
Message-ID: <166256556634.1434226.5193053845415014583.stgit@firesoul>
In-Reply-To: <166256538687.1434226.15760041133601409770.stgit@firesoul>
References: <166256538687.1434226.15760041133601409770.stgit@firesoul>
User-Agent: StGit/1.4
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

In mvneta_rx_swbm() code path this driver already builds the SKB based
on the xdp_buff. The natural next step is to use XDP-hints to populate
the SKB fields, even when sending packets to normal netstack.

The hardware/driver only support RX checksum offloading, which is stored
as XDP-hints. Still the generic function xdp_hint2skb() that applies all
common hints is called.  This makes sense as an XDP bpf_prog have the
opportunity to add some of these common hints prior to SKB creation.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 drivers/net/ethernet/marvell/mvneta.c |   59 ++++++++++++++++++++++++++++-----
 1 file changed, 50 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 0caa2df87c04..7d0055488a86 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -40,6 +40,7 @@
 #include <net/page_pool.h>
 #include <net/pkt_cls.h>
 #include <linux/bpf_trace.h>
+#include <linux/btf.h>
 
 /* Registers */
 #define MVNETA_RXQ_CONFIG_REG(q)                (0x1400 + ((q) << 2))
@@ -371,6 +372,9 @@
 #define MVNETA_RX_GET_BM_POOL_ID(rxd) \
 	(((rxd)->status & MVNETA_RXD_BM_POOL_MASK) >> MVNETA_RXD_BM_POOL_SHIFT)
 
+static struct btf *mvneta_btf;
+static u64 btf_id_xdp_hints;
+
 enum {
 	ETHTOOL_STAT_EEE_WAKEUP,
 	ETHTOOL_STAT_SKB_ALLOC_ERR,
@@ -2308,12 +2312,15 @@ mvneta_swbm_rx_frame(struct mvneta_port *pp,
 		     struct mvneta_rx_desc *rx_desc,
 		     struct mvneta_rx_queue *rxq,
 		     struct xdp_buff *xdp, int *size,
-		     struct page *page)
+		     struct page *page, u32 status)
 {
 	unsigned char *data = page_address(page);
 	int data_len = -MVNETA_MH_SIZE, len;
+	struct xdp_hints_common *xdp_hints;
 	struct net_device *dev = pp->dev;
 	enum dma_data_direction dma_dir;
+	u32 xdp_hints_flags;
+	u16 cksum;
 
 	if (*size > MVNETA_MAX_RX_BUF_SIZE) {
 		len = MVNETA_MAX_RX_BUF_SIZE;
@@ -2336,6 +2343,20 @@ mvneta_swbm_rx_frame(struct mvneta_port *pp,
 	xdp_buff_clear_frags_flag(xdp);
 	xdp_prepare_buff(xdp, data, pp->rx_offset_correction + MVNETA_MH_SIZE,
 			 data_len, false);
+
+	if (unlikely(!(pp->dev->features & NETIF_F_XDP_HINTS))) {
+		xdp_buff_clear_hints_flags(xdp);
+		return;
+	}
+
+	xdp_hints = xdp->data - sizeof(*xdp_hints);
+	cksum = mvneta_rx_csum(pp, status);
+	xdp_hints_flags = xdp_hints_set_rx_csum(xdp_hints, cksum, 0);
+	xdp_hints_set_flags(xdp_hints, xdp_hints_flags);
+	xdp_hints->btf_full_id = btf_id_xdp_hints;
+	xdp->data_meta = xdp->data - sizeof(*xdp_hints);
+
+	xdp_buff_set_hints_flags(xdp, true);
 }
 
 static void
@@ -2385,9 +2406,25 @@ mvneta_swbm_add_rx_fragment(struct mvneta_port *pp,
 	*size -= len;
 }
 
+static void
+mvneta_set_skb_hints_from_xdp(struct xdp_buff *xdp, struct sk_buff *skb)
+{
+	struct xdp_hints_common *xdp_hints;
+
+	if (!(xdp_buff_has_hints_compat(xdp)))
+		return;
+
+	if (xdp->data - xdp->data_meta < sizeof(*xdp_hints))
+		return;
+
+	xdp_hints = xdp->data - sizeof(*xdp_hints);
+	xdp_hint2skb(skb, xdp_hints);
+}
+
+
 static struct sk_buff *
 mvneta_swbm_build_skb(struct mvneta_port *pp, struct page_pool *pool,
-		      struct xdp_buff *xdp, u32 desc_status)
+		      struct xdp_buff *xdp)
 {
 	struct skb_shared_info *sinfo = xdp_get_shared_info_from_buff(xdp);
 	struct sk_buff *skb;
@@ -2404,7 +2441,7 @@ mvneta_swbm_build_skb(struct mvneta_port *pp, struct page_pool *pool,
 
 	skb_reserve(skb, xdp->data - xdp->data_hard_start);
 	skb_put(skb, xdp->data_end - xdp->data);
-	skb->ip_summed = mvneta_rx_csum(pp, desc_status);
+	mvneta_set_skb_hints_from_xdp(xdp, skb);
 
 	if (unlikely(xdp_buff_has_frags(xdp)))
 		xdp_update_skb_shared_info(skb, num_frags,
@@ -2424,8 +2461,8 @@ static int mvneta_rx_swbm(struct napi_struct *napi,
 	struct net_device *dev = pp->dev;
 	struct mvneta_stats ps = {};
 	struct bpf_prog *xdp_prog;
-	u32 desc_status, frame_sz;
 	struct xdp_buff xdp_buf;
+	u32 frame_sz;
 
 	xdp_init_buff(&xdp_buf, PAGE_SIZE, &rxq->xdp_rxq);
 	xdp_buf.data_hard_start = NULL;
@@ -2458,10 +2495,8 @@ static int mvneta_rx_swbm(struct napi_struct *napi,
 
 			size = rx_desc->data_size;
 			frame_sz = size - ETH_FCS_LEN;
-			desc_status = rx_status;
-
 			mvneta_swbm_rx_frame(pp, rx_desc, rxq, &xdp_buf,
-					     &size, page);
+					     &size, page, rx_status);
 		} else {
 			if (unlikely(!xdp_buf.data_hard_start)) {
 				rx_desc->buf_phys_addr = 0;
@@ -2487,7 +2522,7 @@ static int mvneta_rx_swbm(struct napi_struct *napi,
 		    mvneta_run_xdp(pp, rxq, xdp_prog, &xdp_buf, frame_sz, &ps))
 			goto next;
 
-		skb = mvneta_swbm_build_skb(pp, rxq->page_pool, &xdp_buf, desc_status);
+		skb = mvneta_swbm_build_skb(pp, rxq->page_pool, &xdp_buf);
 		if (IS_ERR(skb)) {
 			struct mvneta_pcpu_stats *stats = this_cpu_ptr(pp->stats);
 
@@ -5613,7 +5648,7 @@ static int mvneta_probe(struct platform_device *pdev)
 	}
 
 	dev->features = NETIF_F_SG | NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
-			NETIF_F_TSO | NETIF_F_RXCSUM;
+			NETIF_F_TSO | NETIF_F_RXCSUM | NETIF_F_XDP_HINTS;
 	dev->hw_features |= dev->features;
 	dev->vlan_features |= dev->features;
 	dev->priv_flags |= IFF_LIVE_ADDR_CHANGE;
@@ -5817,6 +5852,11 @@ static int __init mvneta_driver_init(void)
 {
 	int ret;
 
+	mvneta_btf = btf_get_module_btf(THIS_MODULE);
+	if (mvneta_btf)
+		btf_id_xdp_hints = btf_get_module_btf_full_id(mvneta_btf,
+							      "xdp_hints_common");
+
 	ret = cpuhp_setup_state_multi(CPUHP_AP_ONLINE_DYN, "net/mvneta:online",
 				      mvneta_cpu_online,
 				      mvneta_cpu_down_prepare);
@@ -5844,6 +5884,7 @@ module_init(mvneta_driver_init);
 
 static void __exit mvneta_driver_exit(void)
 {
+	btf_put_module_btf(mvneta_btf);
 	platform_driver_unregister(&mvneta_driver);
 	cpuhp_remove_multi_state(CPUHP_NET_MVNETA_DEAD);
 	cpuhp_remove_multi_state(online_hpstate);


