Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C43E95B0909
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 17:46:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbiIGPqT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 11:46:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229783AbiIGPqM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 11:46:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 814046FA0F
        for <netdev@vger.kernel.org>; Wed,  7 Sep 2022 08:46:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662565561;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RxXs7B8LQSH1QSFqxekwrMBinIO+X+jrbfvcwnHR9n0=;
        b=f+nMjHKAUkdJzZ0Jjkyt1c3bAK9FKqqXB1FPjDvnGNMLap12qzskQ68ZzReEb5nWN99SZz
        JsJ3z1j/6nKc7xrejqMyXTEirJjDjxgqGGscNOFU+7K3+KTVKhPFpv0ofEElEZTQDt3hNh
        gwW73RaWNECCg2uo3LyQ2NqAsU7kghs=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-198-Hi2NMbUKP-unt3JTnucn4w-1; Wed, 07 Sep 2022 11:45:58 -0400
X-MC-Unique: Hi2NMbUKP-unt3JTnucn4w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ACCA03800C2E;
        Wed,  7 Sep 2022 15:45:57 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4A6E24010D2A;
        Wed,  7 Sep 2022 15:45:57 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 45F9930721A6C;
        Wed,  7 Sep 2022 17:45:56 +0200 (CEST)
Subject: [PATCH RFCv2 bpf-next 11/18] i40e: add XDP-hints handling
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
Date:   Wed, 07 Sep 2022 17:45:56 +0200
Message-ID: <166256555623.1434226.18405044972840995177.stgit@firesoul>
In-Reply-To: <166256538687.1434226.15760041133601409770.stgit@firesoul>
References: <166256538687.1434226.15760041133601409770.stgit@firesoul>
User-Agent: StGit/1.4
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add two different XDP-hints named
 "xdp_hints_i40e" and "xdp_hints_i40e_timestamp".

The "xdp_hints_i40e" struct is compatible with common struct, and
extends with member i40e_hash_ptype (type struct i40e_rx_ptype_decoded)
what contains more details on what protocol the packet contains. Info on
IPv4 or IPv6, fragmented or not, L4 protocols UDP, TCP, SCTP, ICMP or
timesync.

The "xdp_hints_i40e_timestamp" struct is also compatible with common
struct, and extends on top of "xdp_hints_i40e" by adding a 64-bit
"rx_timestamp" provided by hardware.

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c |   22 ++++
 drivers/net/ethernet/intel/i40e/i40e_txrx.c |  155 ++++++++++++++++++++++++---
 2 files changed, 160 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index b36bf9c3e1e4..50deaa25099e 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -5,6 +5,7 @@
 #include <linux/of_net.h>
 #include <linux/pci.h>
 #include <linux/bpf.h>
+#include <linux/btf.h>
 #include <generated/utsrelease.h>
 #include <linux/crash_dump.h>
 
@@ -27,6 +28,10 @@ static const char i40e_driver_string[] =
 
 static const char i40e_copyright[] = "Copyright (c) 2013 - 2019 Intel Corporation.";
 
+static struct btf *this_module_btf;
+extern u64 btf_id_xdp_hints_i40e;
+extern u64 btf_id_xdp_hints_i40e_timestamp;
+
 /* a bit of forward declarations */
 static void i40e_vsi_reinit_locked(struct i40e_vsi *vsi);
 static void i40e_handle_reset_warning(struct i40e_pf *pf, bool lock_acquired);
@@ -13661,6 +13666,7 @@ static int i40e_config_netdev(struct i40e_vsi *vsi)
 			  NETIF_F_SCTP_CRC		|
 			  NETIF_F_RXHASH		|
 			  NETIF_F_RXCSUM		|
+			  NETIF_F_XDP_HINTS		|
 			  0;
 
 	if (!(pf->hw_features & I40E_HW_OUTER_UDP_CSUM_CAPABLE))
@@ -13705,6 +13711,7 @@ static int i40e_config_netdev(struct i40e_vsi *vsi)
 	netdev->hw_features |= hw_features;
 
 	netdev->features |= hw_features | NETIF_F_HW_VLAN_CTAG_FILTER;
+	netdev->features |= NETIF_F_XDP_HINTS;
 	netdev->hw_enc_features |= NETIF_F_TSO_MANGLEID;
 
 	netdev->features &= ~NETIF_F_HW_TC;
@@ -16617,6 +16624,15 @@ static struct pci_driver i40e_driver = {
 	.sriov_configure = i40e_pci_sriov_configure,
 };
 
+static void i40e_this_module_btf_lookups(struct btf *btf)
+{
+	btf_id_xdp_hints_i40e = btf_get_module_btf_full_id(btf,
+							   "xdp_hints_i40e");
+
+	btf_id_xdp_hints_i40e_timestamp = btf_get_module_btf_full_id(btf,
+						"xdp_hints_i40e_timestamp");
+}
+
 /**
  * i40e_init_module - Driver registration routine
  *
@@ -16628,6 +16644,10 @@ static int __init i40e_init_module(void)
 	pr_info("%s: %s\n", i40e_driver_name, i40e_driver_string);
 	pr_info("%s: %s\n", i40e_driver_name, i40e_copyright);
 
+	this_module_btf = btf_get_module_btf(THIS_MODULE);
+	if (this_module_btf)
+		i40e_this_module_btf_lookups(this_module_btf);
+
 	/* There is no need to throttle the number of active tasks because
 	 * each device limits its own task using a state bit for scheduling
 	 * the service task, and the device tasks do not interfere with each
@@ -16658,5 +16678,7 @@ static void __exit i40e_exit_module(void)
 	destroy_workqueue(i40e_wq);
 	ida_destroy(&i40e_client_ida);
 	i40e_dbg_exit();
+	if (!IS_ERR_OR_NULL(this_module_btf))
+		btf_put_module_btf(this_module_btf);
 }
 module_exit(i40e_exit_module);
diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index a7a896321880..d945ac122d4c 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -1819,15 +1819,10 @@ _i40e_rx_checksum(struct i40e_vsi *vsi,
 		ret.csum_level = 1;
 
 	/* Only report checksum unnecessary for TCP, UDP, or SCTP */
-	switch (decoded.inner_prot) {
-	case I40E_RX_PTYPE_INNER_PROT_TCP:
-	case I40E_RX_PTYPE_INNER_PROT_UDP:
-	case I40E_RX_PTYPE_INNER_PROT_SCTP:
+	if (likely(decoded.inner_prot == I40E_RX_PTYPE_INNER_PROT_TCP ||
+		   decoded.inner_prot == I40E_RX_PTYPE_INNER_PROT_UDP ||
+		   decoded.inner_prot == I40E_RX_PTYPE_INNER_PROT_SCTP))
 		ret.ip_summed = CHECKSUM_UNNECESSARY;
-		fallthrough;
-	default:
-		break;
-	}
 
 	return ret;
 
@@ -1858,19 +1853,17 @@ static inline void i40e_rx_checksum(struct i40e_vsi *vsi,
 
 /**
  * i40e_ptype_to_htype - get a hash type
- * @ptype: the ptype value from the descriptor
+ * @ptype: the decoded ptype value from the descriptor
  *
  * Returns a hash type to be used by skb_set_hash
  **/
-static inline int i40e_ptype_to_htype(u8 ptype)
+static inline int i40e_ptype_to_htype(struct i40e_rx_ptype_decoded decoded)
 {
-	struct i40e_rx_ptype_decoded decoded = decode_rx_desc_ptype(ptype);
-
-	if (!decoded.known)
+	if (unlikely(!decoded.known))
 		return PKT_HASH_TYPE_NONE;
 
-	if (decoded.outer_ip == I40E_RX_PTYPE_OUTER_IP &&
-	    decoded.payload_layer == I40E_RX_PTYPE_PAYLOAD_LAYER_PAY4)
+	if (likely(decoded.outer_ip == I40E_RX_PTYPE_OUTER_IP &&
+		   decoded.payload_layer == I40E_RX_PTYPE_PAYLOAD_LAYER_PAY4))
 		return PKT_HASH_TYPE_L4;
 	else if (decoded.outer_ip == I40E_RX_PTYPE_OUTER_IP &&
 		 decoded.payload_layer == I40E_RX_PTYPE_PAYLOAD_LAYER_PAY3)
@@ -1900,8 +1893,11 @@ static inline void i40e_rx_hash(struct i40e_ring *ring,
 		return;
 
 	if ((rx_desc->wb.qword1.status_error_len & rss_mask) == rss_mask) {
+		struct i40e_rx_ptype_decoded ptype;
+
+		ptype = decode_rx_desc_ptype(rx_ptype);
 		hash = le32_to_cpu(rx_desc->wb.qword0.hi_dword.rss);
-		skb_set_hash(skb, hash, i40e_ptype_to_htype(rx_ptype));
+		skb_set_hash(skb, hash, i40e_ptype_to_htype(ptype));
 	}
 }
 
@@ -1947,6 +1943,129 @@ void i40e_process_skb_fields(struct i40e_ring *rx_ring,
 	skb->protocol = eth_type_trans(skb, rx_ring->netdev);
 }
 
+struct xdp_hints_i40e {
+	struct i40e_rx_ptype_decoded i40e_hash_ptype;
+	struct xdp_hints_common common;
+};
+
+struct xdp_hints_i40e_timestamp {
+	u64 rx_timestamp;
+	struct xdp_hints_i40e base;
+};
+
+/* Extending xdp_hints_flags */
+enum xdp_hints_flags_driver {
+	HINT_FLAG_RX_TIMESTAMP = BIT(16),
+};
+
+/* BTF full IDs gets looked up on driver i40e_init_module */
+u64 btf_id_xdp_hints_i40e;
+u64 btf_id_xdp_hints_i40e_timestamp;
+
+static inline u32 i40e_rx_checksum_xdp(struct i40e_vsi *vsi, u64 qword1,
+				       struct xdp_hints_i40e *xdp_hints,
+				       struct i40e_rx_ptype_decoded ptype)
+{
+	struct i40e_rx_checksum_ret ret;
+
+	ret = _i40e_rx_checksum(vsi, qword1, ptype);
+	return xdp_hints_set_rx_csum(&xdp_hints->common, ret.ip_summed, ret.csum_level);
+}
+
+static inline u32 i40e_rx_hash_xdp(struct i40e_ring *ring,
+				   union i40e_rx_desc *rx_desc,
+				   struct xdp_buff *xdp,
+				   u64 rx_desc_qword1,
+				   struct xdp_hints_i40e *xdp_hints,
+				   struct i40e_rx_ptype_decoded ptype
+	)
+{
+	const u64 rss_mask = (u64)I40E_RX_DESC_FLTSTAT_RSS_HASH <<
+				I40E_RX_DESC_STATUS_FLTSTAT_SHIFT;
+	u32 flags = 0;
+
+	if (unlikely(!(ring->netdev->features & NETIF_F_RXHASH))) {
+		struct i40e_rx_ptype_decoded zero = {};
+
+		xdp_hints->i40e_hash_ptype = zero;
+		return 0;
+	}
+
+	if (likely((rx_desc_qword1 & rss_mask) == rss_mask)) {
+		u32 hash = le32_to_cpu(rx_desc->wb.qword0.hi_dword.rss);
+		u32 htype;
+
+		/* i40e provide extra information about protocol type  */
+		xdp_hints->i40e_hash_ptype = ptype;
+		htype = i40e_ptype_to_htype(ptype);
+		flags = xdp_hints_set_rx_hash(&xdp_hints->common, hash, htype);
+	}
+	return flags;
+}
+
+static inline void i40e_process_xdp_hints(struct i40e_ring *rx_ring,
+					  union i40e_rx_desc *rx_desc,
+					  struct xdp_buff *xdp,
+					  u64 qword)
+{
+	u32 rx_status = (qword & I40E_RXD_QW1_STATUS_MASK) >>
+			I40E_RXD_QW1_STATUS_SHIFT;
+	u32 tsynvalid = rx_status & I40E_RXD_QW1_STATUS_TSYNVALID_MASK;
+	u32 tsyn = (rx_status & I40E_RXD_QW1_STATUS_TSYNINDX_MASK) >>
+		   I40E_RXD_QW1_STATUS_TSYNINDX_SHIFT;
+	u64 tsyn_ts;
+
+	struct i40e_rx_ptype_decoded ptype;
+	struct xdp_hints_i40e *xdp_hints;
+	struct xdp_hints_common *common;
+	u32 btf_full_id = btf_id_xdp_hints_i40e;
+	u32 btf_sz = sizeof(*xdp_hints);
+	u32 f1 = 0, f2, f3, f4, f5 = 0;
+	u8 rx_ptype;
+
+	if (!(rx_ring->netdev->features & NETIF_F_XDP_HINTS))
+		return;
+
+	/* Driver have xdp headroom when using build_skb */
+	if (unlikely(!ring_uses_build_skb(rx_ring)))
+		return;
+
+	xdp_hints = xdp->data - btf_sz;
+	common = &xdp_hints->common;
+
+	if (unlikely(tsynvalid)) {
+		struct xdp_hints_i40e_timestamp *hints;
+
+		tsyn_ts = i40e_ptp_rx_hwtstamp_raw(rx_ring->vsi->back, tsyn);
+		btf_full_id = btf_id_xdp_hints_i40e_timestamp;
+		btf_sz = sizeof(*hints);
+		hints = xdp->data - btf_sz;
+		hints->rx_timestamp = ns_to_ktime(tsyn_ts);
+		f1 = HINT_FLAG_RX_TIMESTAMP;
+	}
+
+	/* ptype needed by both hash and checksum code */
+	rx_ptype = (qword & I40E_RXD_QW1_PTYPE_MASK) >> I40E_RXD_QW1_PTYPE_SHIFT;
+	ptype = decode_rx_desc_ptype(rx_ptype);
+
+	f2 = i40e_rx_hash_xdp(rx_ring, rx_desc, xdp, qword, xdp_hints, ptype);
+	f3 = i40e_rx_checksum_xdp(rx_ring->vsi, qword, xdp_hints, ptype);
+	f4 = xdp_hints_set_rxq(common, rx_ring->queue_index);
+
+	if (unlikely(qword & BIT(I40E_RX_DESC_STATUS_L2TAG1P_SHIFT))) {
+		__le16 vlan_tag = rx_desc->wb.qword0.lo_dword.l2tag1;
+
+		f5 = xdp_hints_set_vlan(common, le16_to_cpu(vlan_tag),
+					htons(ETH_P_8021Q));
+	}
+
+	xdp_hints_set_flags(common, (f1 | f2 | f3 | f4 | f5));
+	common->btf_full_id = btf_full_id;
+	xdp->data_meta = xdp->data - btf_sz;
+
+	xdp_buff_set_hints_flags(xdp, true);
+}
+
 /**
  * i40e_cleanup_headers - Correct empty headers
  * @rx_ring: rx descriptor ring packet is being transacted on
@@ -2495,7 +2614,7 @@ static int i40e_clean_rx_irq(struct i40e_ring *rx_ring, int budget)
 		 */
 		dma_rmb();
 
-		if (i40e_rx_is_programming_status(qword)) {
+		if (unlikely(i40e_rx_is_programming_status(qword))) {
 			i40e_clean_programming_status(rx_ring,
 						      rx_desc->raw.qword[0],
 						      qword);
@@ -2522,6 +2641,8 @@ static int i40e_clean_rx_irq(struct i40e_ring *rx_ring, int budget)
 				     rx_buffer->page_offset - offset;
 			xdp_prepare_buff(&xdp, hard_start, offset, size, true);
 			xdp_buff_clear_frags_flag(&xdp);
+			prefetchw(xdp.data - 8); /* xdp.data_meta cacheline */
+			i40e_process_xdp_hints(rx_ring, rx_desc, &xdp, qword);
 #if (PAGE_SIZE > 4096)
 			/* At larger PAGE_SIZE, frame_sz depend on len size */
 			xdp.frame_sz = i40e_rx_frame_truesize(rx_ring, size);


