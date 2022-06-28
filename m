Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F02055EE87
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 22:00:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233301AbiF1Txv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 15:53:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232553AbiF1TvE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 15:51:04 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B59AC2D1FA;
        Tue, 28 Jun 2022 12:50:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656445802; x=1687981802;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mGtrmaLjPcZAooH9D0ihpXQHll3Ueacp1yT+KsPx7iI=;
  b=DsUaoryMmLzcorx3s1JVgNTjDVRHbUz4Xsm34EXveL4mnCd9iQoEXM1N
   qTWFQURxo4Ez5t+z13daV5w2OG7yhbaKVHrPQLXQQ+34XFX+6N/NBpasg
   eVKZ1xnZwBKO8mQ0k3bBmZnH3ZdQz679/p5+6yQYy0FOiKrRW3m6RFrqZ
   55jcnGNLQYT2wNe3nMbmMT/RYF7Nd5ecy5K4kQ+ZHw+nJoMUXk6BRebx9
   NnCJ/SZ19mthYbEmOLkVniE0ngX4KwhNvy8UiprU4swLYilViq6hgBEHb
   M6wdPxrZcaFsYOrOXwDsRbyh7zyc99Law+TCFwtswftLkiUg+VVT0d9Ew
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10392"; a="280596062"
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="280596062"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2022 12:50:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="594927683"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga007.fm.intel.com with ESMTP; 28 Jun 2022 12:49:58 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 25SJmr9l022013;
        Tue, 28 Jun 2022 20:49:56 +0100
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Larysa Zaremba <larysa.zaremba@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Toke Hoiland-Jorgensen <toke@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Yajun Deng <yajun.deng@linux.dev>,
        Willem de Bruijn <willemb@google.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        xdp-hints@xdp-project.net
Subject: [PATCH RFC bpf-next 47/52] net, ice: build XDP generic metadata
Date:   Tue, 28 Jun 2022 21:48:07 +0200
Message-Id: <20220628194812.1453059-48-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220628194812.1453059-1-alexandr.lobakin@intel.com>
References: <20220628194812.1453059-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that the driver builds skbs from an onstack generic meta
structure, add the ability to configure the actual metadata format
to be provided to BPF and XSK programs (and other consumers like
cpumap).
At first, it is being built on the stack and then synchronized with
the buffer in front of a frame; and vice versa after the program
returns back to the driver. In cases when meta is disabled or the
frame size is below the threshold, the driver populates it only on
%XDP_PASS and right before populating an skb, so no perf hits for
that.

Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h          |  8 +++
 drivers/net/ethernet/intel/ice/ice_main.c     | 18 ++++++-
 drivers/net/ethernet/intel/ice/ice_txrx.c     | 25 ++++++---
 drivers/net/ethernet/intel/ice/ice_txrx_lib.h | 53 +++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_xsk.c      | 17 ++++--
 5 files changed, 107 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 402b71ab48e4..bd929bb1a359 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -490,6 +490,14 @@ enum ice_pf_flags {
 	ICE_PF_FLAGS_NBITS		/* must be last */
 };
 
+enum {
+	ICE_MD_GENERIC,
+
+	/* Must be last */
+	ICE_MD_NONE,
+	__ICE_MD_NUM,
+};
+
 struct ice_switchdev_info {
 	struct ice_vsi *control_vsi;
 	struct ice_vsi *uplink_vsi;
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 7d049930a0a8..62bd0d316873 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -48,6 +48,11 @@ static DEFINE_IDA(ice_aux_ida);
 DEFINE_STATIC_KEY_FALSE(ice_xdp_locking_key);
 EXPORT_SYMBOL(ice_xdp_locking_key);
 
+/* List of XDP metadata formats supported by the driver */
+static const char * const ice_supported_md[__ICE_MD_NUM] = {
+	[ICE_MD_GENERIC]	= "struct xdp_meta_generic",
+};
+
 /**
  * ice_hw_to_dev - Get device pointer from the hardware structure
  * @hw: pointer to the device HW structure
@@ -2848,13 +2853,19 @@ ice_xdp_setup_prog(struct ice_vsi *vsi, struct netdev_bpf *xdp)
 	int frame_size = vsi->netdev->mtu + ICE_ETH_PKT_HDR_PAD;
 	struct netlink_ext_ack *extack = xdp->extack;
 	bool restart = false, prog = !!xdp->prog;
-	int ret = 0, xdp_ring_err = 0;
+	int pos, ret = 0, xdp_ring_err = 0;
 
 	if (frame_size > vsi->rx_buf_len) {
 		NL_SET_ERR_MSG_MOD(extack, "MTU too large for loading XDP");
 		return -EOPNOTSUPP;
 	}
 
+	pos = xdp_meta_match_id(ice_supported_md, xdp->btf_id);
+	if (pos < 0) {
+		NL_SET_ERR_MSG_MOD(extack, "Invalid or unsupported BTF ID");
+		return pos;
+	}
+
 	/* need to stop netdev while setting up the program for Rx rings */
 	if (ice_is_xdp_ena_vsi(vsi) != prog && netif_running(vsi->netdev) &&
 	    !test_and_set_bit(ICE_VSI_DOWN, vsi->state)) {
@@ -2867,6 +2878,9 @@ ice_xdp_setup_prog(struct ice_vsi *vsi, struct netdev_bpf *xdp)
 		restart = true;
 	}
 
+	/* Paired with the READ_ONCE()'s in ice_clean_rx_irq{,_zc}() */
+	WRITE_ONCE(vsi->xdp_info.drv_cookie, ICE_MD_NONE);
+
 	if (!ice_is_xdp_ena_vsi(vsi) && prog) {
 		xdp_ring_err = ice_vsi_determine_xdp_res(vsi);
 		if (xdp_ring_err) {
@@ -2889,6 +2903,8 @@ ice_xdp_setup_prog(struct ice_vsi *vsi, struct netdev_bpf *xdp)
 		xdp_attachment_setup_rcu(&vsi->xdp_info, xdp);
 	}
 
+	WRITE_ONCE(vsi->xdp_info.drv_cookie, pos);
+
 	if (restart)
 		ret = ice_up(vsi);
 
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index c679f7c30bdc..50de6d54e3b0 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -1103,10 +1103,10 @@ int ice_clean_rx_irq(struct ice_rx_ring *rx_ring, int budget)
 	unsigned int total_rx_bytes = 0, total_rx_pkts = 0, frame_sz = 0;
 	u16 cleaned_count = ICE_DESC_UNUSED(rx_ring);
 	unsigned int offset = rx_ring->rx_offset;
+	struct xdp_attachment_info xdp_info;
 	struct ice_tx_ring *xdp_ring = NULL;
 	unsigned int xdp_res, xdp_xmit = 0;
 	struct sk_buff *skb = rx_ring->skb;
-	struct bpf_prog *xdp_prog = NULL;
 	struct xdp_buff xdp;
 	bool failure;
 
@@ -1116,9 +1116,16 @@ int ice_clean_rx_irq(struct ice_rx_ring *rx_ring, int budget)
 #endif
 	xdp_init_buff(&xdp, frame_sz, &rx_ring->xdp_rxq);
 
-	xdp_prog = rcu_dereference(rx_ring->xdp_info->prog_rcu);
-	if (xdp_prog)
+	xdp_info.prog = rcu_dereference(rx_ring->xdp_info->prog_rcu);
+	if (xdp_info.prog) {
+		const struct xdp_attachment_info *info = rx_ring->xdp_info;
+
+		xdp_info.btf_id_le = cpu_to_le64(READ_ONCE(info->btf_id));
+		xdp_info.meta_thresh = READ_ONCE(info->meta_thresh);
+		xdp_info.drv_cookie = READ_ONCE(info->drv_cookie);
+
 		xdp_ring = rx_ring->xdp_ring;
+	}
 
 	/* start the loop to process Rx packets bounded by 'budget' */
 	while (likely(total_rx_pkts < (unsigned int)budget)) {
@@ -1182,10 +1189,12 @@ int ice_clean_rx_irq(struct ice_rx_ring *rx_ring, int budget)
 		xdp.frame_sz = ice_rx_frame_truesize(rx_ring, size);
 #endif
 
-		if (!xdp_prog)
+		if (!xdp_info.prog)
 			goto construct_skb;
 
-		xdp_res = ice_run_xdp(rx_ring, &xdp, xdp_prog, xdp_ring);
+		ice_xdp_handle_meta(&xdp, &md, &xdp_info, rx_desc, rx_ring);
+
+		xdp_res = ice_run_xdp(rx_ring, &xdp, xdp_info.prog, xdp_ring);
 		if (!xdp_res)
 			goto construct_skb;
 		if (xdp_res & (ICE_XDP_TX | ICE_XDP_REDIR)) {
@@ -1240,8 +1249,8 @@ int ice_clean_rx_irq(struct ice_rx_ring *rx_ring, int budget)
 		/* probably a little skewed due to removing CRC */
 		total_rx_bytes += skb->len;
 
-		ice_xdp_build_meta(&md, rx_desc, rx_ring, 0);
-		__xdp_populate_skb_meta_generic(skb, &md);
+		ice_xdp_meta_populate_skb(skb, &md, xdp.data, rx_desc,
+					  rx_ring);
 
 		ice_trace(clean_rx_irq_indicate, rx_ring, rx_desc, skb);
 		ice_receive_skb(rx_ring, skb);
@@ -1254,7 +1263,7 @@ int ice_clean_rx_irq(struct ice_rx_ring *rx_ring, int budget)
 	/* return up to cleaned_count buffers to hardware */
 	failure = ice_alloc_rx_bufs(rx_ring, cleaned_count);
 
-	if (xdp_prog)
+	if (xdp_info.prog)
 		ice_finalize_xdp_rx(xdp_ring, xdp_xmit);
 	rx_ring->skb = skb;
 
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx_lib.h b/drivers/net/ethernet/intel/ice/ice_txrx_lib.h
index b51e58b8e83d..a9d3f3adf86b 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_txrx_lib.h
@@ -98,7 +98,60 @@ void __ice_xdp_build_meta(struct xdp_meta_generic_rx *rx_md,
 			  const struct ice_rx_ring *rx_ring,
 			  __le64 full_id);
 
+static inline void
+__ice_xdp_handle_meta(struct xdp_buff *xdp, struct xdp_meta_generic_rx *rx_md,
+		      const struct xdp_attachment_info *info,
+		      const union ice_32b_rx_flex_desc *rx_desc,
+		      const struct ice_rx_ring *rx_ring)
+{
+	rx_md->rx_flags = 0;
+
+	if (xdp->data_end - xdp->data < info->meta_thresh)
+		return;
+
+	switch (info->drv_cookie) {
+	case ICE_MD_GENERIC:
+		__ice_xdp_build_meta(rx_md, rx_desc, rx_ring, info->btf_id_le);
+
+		xdp->data_meta = xdp_meta_generic_ptr(xdp->data);
+		memcpy(to_rx_md(xdp->data_meta), rx_md, sizeof(*rx_md));
+
+		/* Just zero Tx flags instead of zeroing the whole part */
+		to_gen_md(xdp->data_meta)->tx_flags = 0;
+		break;
+	default:
+		break;
+	}
+}
+
+static inline void
+__ice_xdp_meta_populate_skb(struct sk_buff *skb,
+			    struct xdp_meta_generic_rx *rx_md,
+			    const void *data,
+			    const union ice_32b_rx_flex_desc *rx_desc,
+			    const struct ice_rx_ring *rx_ring)
+{
+	/* __ice_xdp_build_meta() unconditionally sets Rx queue id. If it's
+	 * not here, it means that metadata for this frame hasn't been built
+	 * yet and we need to do this now. Otherwise, sync onstack metadata
+	 * copy and mark meta as nocomp to ignore it on GRO layer.
+	 */
+	if (rx_md->rx_flags && likely(xdp_meta_has_generic(data))) {
+		memcpy(rx_md, to_rx_md(xdp_meta_generic_ptr(data)),
+		       sizeof(*rx_md));
+		skb_metadata_nocomp_set(skb);
+	} else {
+		__ice_xdp_build_meta(rx_md, rx_desc, rx_ring, 0);
+	}
+
+	__xdp_populate_skb_meta_generic(skb, rx_md);
+}
+
 #define ice_xdp_build_meta(md, ...)					\
 	__ice_xdp_build_meta(to_rx_md(md), ##__VA_ARGS__)
+#define ice_xdp_handle_meta(xdp, md, ...)				\
+	__ice_xdp_handle_meta((xdp), to_rx_md(md), ##__VA_ARGS__)
+#define ice_xdp_meta_populate_skb(skb, md, ...)				\
+	__ice_xdp_meta_populate_skb((skb), to_rx_md(md), ##__VA_ARGS__)
 
 #endif /* !_ICE_TXRX_LIB_H_ */
diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
index eade918723eb..f5769f49e3c3 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -588,16 +588,20 @@ ice_run_xdp_zc(struct ice_rx_ring *rx_ring, struct xdp_buff *xdp,
 int ice_clean_rx_irq_zc(struct ice_rx_ring *rx_ring, int budget)
 {
 	unsigned int total_rx_bytes = 0, total_rx_packets = 0;
+	const struct xdp_attachment_info *rxi = rx_ring->xdp_info, xdp_info = {
+		.prog		= rcu_dereference(rxi->prog_rcu),
+		.btf_id_le	= cpu_to_le64(READ_ONCE(rxi->btf_id)),
+		.meta_thresh	= READ_ONCE(rxi->meta_thresh),
+		.drv_cookie	= READ_ONCE(rxi->drv_cookie),
+	};
 	struct ice_tx_ring *xdp_ring;
 	unsigned int xdp_xmit = 0;
-	struct bpf_prog *xdp_prog;
 	bool failure = false;
 	int entries_to_alloc;
 
 	/* ZC patch is enabled only when XDP program is set,
 	 * so here it can not be NULL
 	 */
-	xdp_prog = rcu_dereference(rx_ring->xdp_info->prog_rcu);
 	xdp_ring = rx_ring->xdp_ring;
 
 	while (likely(total_rx_packets < (unsigned int)budget)) {
@@ -638,7 +642,10 @@ int ice_clean_rx_irq_zc(struct ice_rx_ring *rx_ring, int budget)
 		xsk_buff_set_size(xdp, size);
 		xsk_buff_dma_sync_for_cpu(xdp, rx_ring->xsk_pool);
 
-		xdp_res = ice_run_xdp_zc(rx_ring, xdp, xdp_prog, xdp_ring);
+		ice_xdp_handle_meta(xdp, &md, &xdp_info, rx_desc, rx_ring);
+
+		xdp_res = ice_run_xdp_zc(rx_ring, xdp, xdp_info.prog,
+					 xdp_ring);
 		if (likely(xdp_res & (ICE_XDP_TX | ICE_XDP_REDIR))) {
 			xdp_xmit |= xdp_res;
 		} else if (xdp_res == ICE_XDP_EXIT) {
@@ -674,8 +681,8 @@ int ice_clean_rx_irq_zc(struct ice_rx_ring *rx_ring, int budget)
 		total_rx_bytes += skb->len;
 		total_rx_packets++;
 
-		ice_xdp_build_meta(&md, rx_desc, rx_ring, 0);
-		__xdp_populate_skb_meta_generic(skb, &md);
+		ice_xdp_meta_populate_skb(skb, &md, xdp->data, rx_desc,
+					  rx_ring);
 		ice_receive_skb(rx_ring, skb);
 	}
 
-- 
2.36.1

