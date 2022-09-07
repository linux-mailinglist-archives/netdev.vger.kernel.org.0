Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02E085B0914
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 17:46:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229833AbiIGPqc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 11:46:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229794AbiIGPqX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 11:46:23 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B1876FA0F
        for <netdev@vger.kernel.org>; Wed,  7 Sep 2022 08:46:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662565581;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/bHwryhcgQVyZoWewHxFzRoF7IbOXIWIyWvvNF2T2D4=;
        b=RDA2GP3g6WhGynJb96XpXvQqCl6++IsvRg7mDoOwqMxuOhPiR8t5IS8XOMzPib/iiHaCr8
        vCb895sNeoRXiHrpTnW0MgujIM6BNChv0gxj58GnKxrPQPvVi+o24kPeuLWTviwPX4ltR0
        w3WfNBU7qElMyh3d1pyxkEebINIBOuI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-460-YoCiClzfN6O4QuPx259pag-1; Wed, 07 Sep 2022 11:46:18 -0400
X-MC-Unique: YoCiClzfN6O4QuPx259pag-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EAF4885A585;
        Wed,  7 Sep 2022 15:46:17 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7EC5D1121314;
        Wed,  7 Sep 2022 15:46:17 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 7913930721A6C;
        Wed,  7 Sep 2022 17:46:16 +0200 (CEST)
Subject: [PATCH RFCv2 bpf-next 15/18] ixgbe: enable xdp-hints
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
Date:   Wed, 07 Sep 2022 17:46:16 +0200
Message-ID: <166256557645.1434226.13205220368236323814.stgit@firesoul>
In-Reply-To: <166256538687.1434226.15760041133601409770.stgit@firesoul>
References: <166256538687.1434226.15760041133601409770.stgit@firesoul>
User-Agent: StGit/1.4
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maryam Tahhan <mtahhan@redhat.com>

Similar to i40e driver, add xdp hw-hints support for ixgbe driver in
order to report rx csum offload for xdp_redirect.

Signed-off-by: Maryam Tahhan <mtahhan@redhat.com>
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |  180 ++++++++++++++++++++++---
 1 file changed, 155 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index d1e430b8c8aa..0c8ee19e6d44 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -25,6 +25,7 @@
 #include <linux/if_bridge.h>
 #include <linux/prefetch.h>
 #include <linux/bpf.h>
+#include <linux/btf.h>
 #include <linux/bpf_trace.h>
 #include <linux/atomic.h>
 #include <linux/numa.h>
@@ -60,6 +61,15 @@ static char ixgbe_default_device_descr[] =
 static const char ixgbe_copyright[] =
 				"Copyright (c) 1999-2016 Intel Corporation.";
 
+static struct btf *ixgbe_btf;
+
+struct xdp_hints_ixgbe {
+	u32 rss_type;
+	struct xdp_hints_common common;
+};
+
+u64 btf_id_xdp_hints_ixgbe;
+
 static const char ixgbe_overheat_msg[] = "Network adapter has been stopped because it has over heated. Restart the computer. If the problem persists, power off the system and replace the adapter";
 
 static const struct ixgbe_info *ixgbe_info_tbl[] = {
@@ -1460,40 +1470,42 @@ static inline bool ixgbe_rx_is_fcoe(struct ixgbe_ring *ring,
 }
 
 #endif /* IXGBE_FCOE */
-/**
- * ixgbe_rx_checksum - indicate in skb if hw indicated a good cksum
- * @ring: structure containing ring specific data
- * @rx_desc: current Rx descriptor being processed
- * @skb: skb currently being received and modified
- **/
-static inline void ixgbe_rx_checksum(struct ixgbe_ring *ring,
-				     union ixgbe_adv_rx_desc *rx_desc,
-				     struct sk_buff *skb)
+
+struct ixgbe_rx_checksum_ret {
+	u16 ip_summed;
+	u16 csum_level;
+	u8 encapsulation;
+};
+
+static inline struct ixgbe_rx_checksum_ret
+_ixgbe_rx_checksum(struct ixgbe_ring *ring,
+		   union ixgbe_adv_rx_desc *rx_desc,
+		   __le16 pkt_info)
 {
-	__le16 pkt_info = rx_desc->wb.lower.lo_dword.hs_rss.pkt_info;
 	bool encap_pkt = false;
+	struct ixgbe_rx_checksum_ret ret = {};
 
-	skb_checksum_none_assert(skb);
+	ret.ip_summed = CHECKSUM_NONE;
 
 	/* Rx csum disabled */
 	if (!(ring->netdev->features & NETIF_F_RXCSUM))
-		return;
+		return ret;
 
 	/* check for VXLAN and Geneve packets */
 	if (pkt_info & cpu_to_le16(IXGBE_RXDADV_PKTTYPE_VXLAN)) {
 		encap_pkt = true;
-		skb->encapsulation = 1;
+		ret.encapsulation = 1;
 	}
 
 	/* if IP and error */
 	if (ixgbe_test_staterr(rx_desc, IXGBE_RXD_STAT_IPCS) &&
 	    ixgbe_test_staterr(rx_desc, IXGBE_RXDADV_ERR_IPE)) {
 		ring->rx_stats.csum_err++;
-		return;
+		return ret;
 	}
 
 	if (!ixgbe_test_staterr(rx_desc, IXGBE_RXD_STAT_L4CS))
-		return;
+		return ret;
 
 	if (ixgbe_test_staterr(rx_desc, IXGBE_RXDADV_ERR_TCPE)) {
 		/*
@@ -1501,26 +1513,49 @@ static inline void ixgbe_rx_checksum(struct ixgbe_ring *ring,
 		 * checksum errors.
 		 */
 		if ((pkt_info & cpu_to_le16(IXGBE_RXDADV_PKTTYPE_UDP)) &&
-		    test_bit(__IXGBE_RX_CSUM_UDP_ZERO_ERR, &ring->state))
-			return;
+			test_bit(__IXGBE_RX_CSUM_UDP_ZERO_ERR, &ring->state))
+			return ret;
 
 		ring->rx_stats.csum_err++;
-		return;
+		return ret;
 	}
 
 	/* It must be a TCP or UDP packet with a valid checksum */
-	skb->ip_summed = CHECKSUM_UNNECESSARY;
+	ret.ip_summed = CHECKSUM_UNNECESSARY;
 	if (encap_pkt) {
 		if (!ixgbe_test_staterr(rx_desc, IXGBE_RXD_STAT_OUTERIPCS))
-			return;
+			return ret;
 
 		if (ixgbe_test_staterr(rx_desc, IXGBE_RXDADV_ERR_OUTERIPER)) {
-			skb->ip_summed = CHECKSUM_NONE;
-			return;
+			ret.ip_summed = CHECKSUM_NONE;
+			return ret;
 		}
 		/* If we checked the outer header let the stack know */
-		skb->csum_level = 1;
+		ret.csum_level = 1;
 	}
+
+	return ret;
+}
+
+/**
+ * ixgbe_rx_checksum - indicate in skb if hw indicated a good cksum
+ * @ring: structure containing ring specific data
+ * @rx_desc: current Rx descriptor being processed
+ * @skb: skb currently being received and modified
+ **/
+static inline void ixgbe_rx_checksum(struct ixgbe_ring *ring,
+					union ixgbe_adv_rx_desc *rx_desc,
+					struct sk_buff *skb)
+{
+	struct ixgbe_rx_checksum_ret ret;
+	__le16 pkt_info = rx_desc->wb.lower.lo_dword.hs_rss.pkt_info;
+
+	skb_checksum_none_assert(skb);
+
+	ret = _ixgbe_rx_checksum(ring, rx_desc, pkt_info);
+	skb->ip_summed  = ret.ip_summed;
+	skb->csum_level = ret.csum_level;
+	skb->encapsulation = ret.encapsulation;
 }
 
 static unsigned int ixgbe_rx_offset(struct ixgbe_ring *rx_ring)
@@ -1714,6 +1749,85 @@ void ixgbe_process_skb_fields(struct ixgbe_ring *rx_ring,
 	skb->protocol = eth_type_trans(skb, dev);
 }
 
+static inline u32
+ixgbe_rx_checksum_xdp(struct ixgbe_ring *ring,
+			union ixgbe_adv_rx_desc *rx_desc,
+			struct xdp_hints_ixgbe *xdp_hints,
+			__le16 pkt_info)
+{
+	struct ixgbe_rx_checksum_ret ret = {};
+
+	ret = _ixgbe_rx_checksum(ring, rx_desc, pkt_info);
+	return xdp_hints_set_rx_csum(&xdp_hints->common, ret.ip_summed, ret.csum_level);
+}
+
+static inline u32 ixgbe_rx_hash_xdp(struct ixgbe_ring *ring,
+						   union ixgbe_adv_rx_desc *rx_desc,
+						   struct xdp_hints_ixgbe *xdp_hints,
+						   __le16 pkt_info)
+{
+	u32 flags = 0, hash, htype = PKT_HASH_TYPE_L2;
+
+	xdp_hints->rss_type = 0;
+
+	if (unlikely(!(ring->netdev->features & NETIF_F_RXHASH)))
+		return 0;
+
+	xdp_hints->rss_type = le16_to_cpu(rx_desc->wb.lower.lo_dword.hs_rss.pkt_info) &
+		   IXGBE_RXDADV_RSSTYPE_MASK;
+
+	if (unlikely(!xdp_hints->rss_type))
+		return 0;
+
+	hash = le32_to_cpu(rx_desc->wb.lower.hi_dword.rss);
+	htype = (IXGBE_RSS_L4_TYPES_MASK & (1ul << xdp_hints->rss_type)) ?
+				PKT_HASH_TYPE_L4 : PKT_HASH_TYPE_L3;
+	flags = xdp_hints_set_rx_hash(&xdp_hints->common, hash, htype);
+
+	return flags;
+}
+
+static inline void ixgbe_process_xdp_hints(struct ixgbe_ring *ring,
+						union ixgbe_adv_rx_desc *rx_desc,
+						struct xdp_buff *xdp)
+{
+	__le16 pkt_info = rx_desc->wb.lower.lo_dword.hs_rss.pkt_info;
+	struct xdp_hints_ixgbe *xdp_hints;
+	struct xdp_hints_common *common;
+	u32 btf_id = btf_id_xdp_hints_ixgbe;
+	u32 btf_sz = sizeof(*xdp_hints);
+	u32 f1 = 0, f2, f3, f4, f5 = 0;
+
+	if (!(ring->netdev->features & NETIF_F_XDP_HINTS)) {
+		xdp_buff_clear_hints_flags(xdp);
+		return;
+	}
+
+	/* Driver have xdp headroom when using build_skb */
+	if (unlikely(!ring_uses_build_skb(ring)))
+		return;
+
+	xdp_hints = xdp->data - btf_sz;
+	common = &xdp_hints->common;
+
+	f2 = ixgbe_rx_hash_xdp(ring, rx_desc, xdp_hints, pkt_info);
+	f3 = ixgbe_rx_checksum_xdp(ring, rx_desc, xdp_hints, pkt_info);
+	f4 = xdp_hints_set_rxq(common, ring->queue_index);
+
+	if ((ring->netdev->features & NETIF_F_HW_VLAN_CTAG_RX) &&
+	    ixgbe_test_staterr(rx_desc, IXGBE_RXD_STAT_VP)) {
+		u16 vid = le16_to_cpu(rx_desc->wb.upper.vlan);
+
+		f5 = xdp_hints_set_vlan(common, vid, htons(ETH_P_8021Q));
+	}
+
+	xdp_hints_set_flags(common, (f1 | f2 | f3 | f4 | f5));
+	common->btf_full_id = btf_id;
+	xdp->data_meta = xdp->data - btf_sz;
+
+	xdp_buff_set_hints_flags(xdp, true);
+}
+
 void ixgbe_rx_skb(struct ixgbe_q_vector *q_vector,
 		  struct sk_buff *skb)
 {
@@ -2344,6 +2458,8 @@ static int ixgbe_clean_rx_irq(struct ixgbe_q_vector *q_vector,
 			hard_start = page_address(rx_buffer->page) +
 				     rx_buffer->page_offset - offset;
 			xdp_prepare_buff(&xdp, hard_start, offset, size, true);
+			prefetchw(xdp.data - 8); /* xdp.data_meta cacheline */
+			ixgbe_process_xdp_hints(rx_ring, rx_desc, &xdp);
 			xdp_buff_clear_frags_flag(&xdp);
 #if (PAGE_SIZE > 4096)
 			/* At larger PAGE_SIZE, frame_sz depend on len size */
@@ -10963,7 +11079,8 @@ static int ixgbe_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 			   NETIF_F_TSO6 |
 			   NETIF_F_RXHASH |
 			   NETIF_F_RXCSUM |
-			   NETIF_F_HW_CSUM;
+			   NETIF_F_HW_CSUM |
+			   NETIF_F_XDP_HINTS;
 
 #define IXGBE_GSO_PARTIAL_FEATURES (NETIF_F_GSO_GRE | \
 				    NETIF_F_GSO_GRE_CSUM | \
@@ -11002,7 +11119,7 @@ static int ixgbe_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	netdev->features |= NETIF_F_HIGHDMA;
 
 	netdev->vlan_features |= netdev->features | NETIF_F_TSO_MANGLEID;
-	netdev->hw_enc_features |= netdev->vlan_features;
+	netdev->hw_enc_features |= netdev->vlan_features | NETIF_F_XDP_HINTS;
 	netdev->mpls_features |= NETIF_F_SG |
 				 NETIF_F_TSO |
 				 NETIF_F_TSO6 |
@@ -11546,6 +11663,11 @@ static struct pci_driver ixgbe_driver = {
 	.err_handler = &ixgbe_err_handler
 };
 
+static void ixgbe_this_module_btf_lookups(struct btf *btf)
+{
+	btf_id_xdp_hints_ixgbe = btf_get_module_btf_full_id(btf, "xdp_hints_ixgbe");
+}
+
 /**
  * ixgbe_init_module - Driver Registration Routine
  *
@@ -11555,6 +11677,7 @@ static struct pci_driver ixgbe_driver = {
 static int __init ixgbe_init_module(void)
 {
 	int ret;
+
 	pr_info("%s\n", ixgbe_driver_string);
 	pr_info("%s\n", ixgbe_copyright);
 
@@ -11573,6 +11696,10 @@ static int __init ixgbe_init_module(void)
 		return ret;
 	}
 
+	ixgbe_btf = btf_get_module_btf(THIS_MODULE);
+	if (ixgbe_btf)
+		ixgbe_this_module_btf_lookups(ixgbe_btf);
+
 #ifdef CONFIG_IXGBE_DCA
 	dca_register_notify(&dca_notifier);
 #endif
@@ -11600,6 +11727,9 @@ static void __exit ixgbe_exit_module(void)
 		destroy_workqueue(ixgbe_wq);
 		ixgbe_wq = NULL;
 	}
+
+	if (!IS_ERR_OR_NULL(ixgbe_btf))
+		btf_put_module_btf(ixgbe_btf);
 }
 
 #ifdef CONFIG_IXGBE_DCA


