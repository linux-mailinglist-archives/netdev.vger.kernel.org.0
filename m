Return-Path: <netdev+bounces-2190-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B1C1700B61
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 17:22:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D58DD281BB0
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 15:22:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96B4914290;
	Fri, 12 May 2023 15:20:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78E4D1428F;
	Fri, 12 May 2023 15:20:19 +0000 (UTC)
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA34D65A4;
	Fri, 12 May 2023 08:20:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683904816; x=1715440816;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5Hcz+nrahtGksGo46j3Eum/Gwzp1mNWWe+cvm9dkHi8=;
  b=CHOPWXkF1++kxK+vov8o0yoauUUKIytP6jE2tivbT4qW3Ugmab36KFf2
   aXr/72o0zj46EKtt+PACckA+jWPqczl7slhh/BgNoCFafQAHqgjoHMbHI
   7gZQrPfdZIBalvbK/6IPB1SP/lWHSzFlUu0e3jUM6E41Z6rBg9f/ImZLU
   0mxM0ib3QnmOoZBTM7r2X5vnQqoUVF7sWOO16+wAQkucwReKmZP5aegqa
   naEwL7HJAvsuNgb/iNCnDEKLOXuzHscLkxU4SEp17WuXMIqvI8K1lDqj6
   r0Y2CAPJO/msB0bJF/iU4IS3mOyZZ3RJEzAiz7N+NVL0nK1vafkCxLUcu
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10708"; a="331173832"
X-IronPort-AV: E=Sophos;i="5.99,269,1677571200"; 
   d="scan'208";a="331173832"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2023 08:20:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10708"; a="765196692"
X-IronPort-AV: E=Sophos;i="5.99,269,1677571200"; 
   d="scan'208";a="765196692"
Received: from irvmail002.ir.intel.com ([10.43.11.120])
  by fmsmga008.fm.intel.com with ESMTP; 12 May 2023 08:20:09 -0700
Received: from lincoln.igk.intel.com (lincoln.igk.intel.com [10.102.21.235])
	by irvmail002.ir.intel.com (Postfix) with ESMTP id 4EBEA36351;
	Fri, 12 May 2023 16:20:07 +0100 (IST)
From: Larysa Zaremba <larysa.zaremba@intel.com>
To: bpf@vger.kernel.org
Cc: Larysa Zaremba <larysa.zaremba@intel.com>,
	Stanislav Fomichev <sdf@google.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Song Liu <song@kernel.org>,
	Yonghong Song <yhs@fb.com>,
	John Fastabend <john.fastabend@gmail.com>,
	KP Singh <kpsingh@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Jesse Brandeburg <jesse.brandeburg@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Anatoly Burakov <anatoly.burakov@intel.com>,
	Jesper Dangaard Brouer <brouer@redhat.com>,
	Alexander Lobakin <alexandr.lobakin@intel.com>,
	Magnus Karlsson <magnus.karlsson@gmail.com>,
	Maryam Tahhan <mtahhan@redhat.com>,
	xdp-hints@xdp-project.net,
	netdev@vger.kernel.org,
	intel-wired-lan@lists.osuosl.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 05/15] ice: Introduce ice_xdp_buff
Date: Fri, 12 May 2023 17:16:29 +0200
Message-Id: <20230512151639.992033-6-larysa.zaremba@intel.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20230512151639.992033-1-larysa.zaremba@intel.com>
References: <20230512151639.992033-1-larysa.zaremba@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

In order to use XDP hints via kfuncs we need to put
RX descriptor and ring pointers just next to xdp_buff.
Same as in hints implementations in other drivers, we archieve
this through putting xdp_buff into a child structure.

Currently, xdp_buff is stored in the ring structure,
so replace it with union that includes child structure.
This way enough memory is available while existing XDP code
remains isolated from hints.

Size of the new child structure (ice_xdp_buff) is 72 bytes,
therefore it does not fit into a single cache line.
To at least place union at the start of cache line, move 'next'
field from CL3 to CL1, as it isn't used often.

Placing union at the start of cache line makes at least xdp_buff
and descriptor fit into a single CL,
ring pointer is used less often, so it can spill into the next CL.

Signed-off-by: Larysa Zaremba <larysa.zaremba@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_txrx.c     |  7 ++++--
 drivers/net/ethernet/intel/ice/ice_txrx.h     | 23 ++++++++++++++++---
 drivers/net/ethernet/intel/ice/ice_txrx_lib.h | 11 +++++++++
 3 files changed, 36 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index c9bb77da0861..ca21a71749b6 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -557,13 +557,14 @@ ice_rx_frame_truesize(struct ice_rx_ring *rx_ring, const unsigned int size)
  * @xdp_prog: XDP program to run
  * @xdp_ring: ring to be used for XDP_TX action
  * @rx_buf: Rx buffer to store the XDP action
+ * @eop_desc: Last descriptor in packet to read metadata from
  *
  * Returns any of ICE_XDP_{PASS, CONSUMED, TX, REDIR}
  */
 static void
 ice_run_xdp(struct ice_rx_ring *rx_ring, struct xdp_buff *xdp,
 	    struct bpf_prog *xdp_prog, struct ice_tx_ring *xdp_ring,
-	    struct ice_rx_buf *rx_buf)
+	    struct ice_rx_buf *rx_buf, union ice_32b_rx_flex_desc *eop_desc)
 {
 	unsigned int ret = ICE_XDP_PASS;
 	u32 act;
@@ -571,6 +572,8 @@ ice_run_xdp(struct ice_rx_ring *rx_ring, struct xdp_buff *xdp,
 	if (!xdp_prog)
 		goto exit;
 
+	ice_xdp_set_meta_srcs(xdp, eop_desc, rx_ring);
+
 	act = bpf_prog_run_xdp(xdp_prog, xdp);
 	switch (act) {
 	case XDP_PASS:
@@ -1240,7 +1243,7 @@ int ice_clean_rx_irq(struct ice_rx_ring *rx_ring, int budget)
 		if (ice_is_non_eop(rx_ring, rx_desc))
 			continue;
 
-		ice_run_xdp(rx_ring, xdp, xdp_prog, xdp_ring, rx_buf);
+		ice_run_xdp(rx_ring, xdp, xdp_prog, xdp_ring, rx_buf, rx_desc);
 		if (rx_buf->act == ICE_XDP_PASS)
 			goto construct_skb;
 		total_rx_bytes += xdp_get_buff_len(xdp);
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.h b/drivers/net/ethernet/intel/ice/ice_txrx.h
index fff0efe28373..f1ac2eb974f1 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.h
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.h
@@ -260,6 +260,15 @@ enum ice_rx_dtype {
 	ICE_RX_DTYPE_SPLIT_ALWAYS	= 2,
 };
 
+struct ice_xdp_buff {
+	struct xdp_buff xdp_buff;
+	union ice_32b_rx_flex_desc *eop_desc;	/* Required for all metadata */
+	/* End of the 1st cache line */
+	struct ice_rx_ring *rx_ring;
+};
+
+static_assert(offsetof(struct ice_xdp_buff, xdp_buff) == 0);
+
 /* indices into GLINT_ITR registers */
 #define ICE_RX_ITR	ICE_IDX_ITR0
 #define ICE_TX_ITR	ICE_IDX_ITR1
@@ -301,7 +310,6 @@ enum ice_dynamic_itr {
 /* descriptor ring, associated with a VSI */
 struct ice_rx_ring {
 	/* CL1 - 1st cacheline starts here */
-	struct ice_rx_ring *next;	/* pointer to next ring in q_vector */
 	void *desc;			/* Descriptor ring memory */
 	struct device *dev;		/* Used for DMA mapping */
 	struct net_device *netdev;	/* netdev ring maps to */
@@ -313,12 +321,19 @@ struct ice_rx_ring {
 	u16 count;			/* Number of descriptors */
 	u16 reg_idx;			/* HW register index of the ring */
 	u16 next_to_alloc;
-	/* CL2 - 2nd cacheline starts here */
+
 	union {
 		struct ice_rx_buf *rx_buf;
 		struct xdp_buff **xdp_buf;
 	};
-	struct xdp_buff xdp;
+	/* CL2 - 2nd cacheline starts here
+	 * Size of ice_xdp_buff is 72 bytes,
+	 * so it spills into CL3
+	 */
+	union {
+		struct ice_xdp_buff xdp_ext;
+		struct xdp_buff xdp;
+	};
 	/* CL3 - 3rd cacheline starts here */
 	struct bpf_prog *xdp_prog;
 	u16 rx_offset;
@@ -328,6 +343,8 @@ struct ice_rx_ring {
 	u16 next_to_clean;
 	u16 first_desc;
 
+	struct ice_rx_ring *next;	/* pointer to next ring in q_vector */
+
 	/* stats structs */
 	struct ice_ring_stats *ring_stats;
 
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx_lib.h b/drivers/net/ethernet/intel/ice/ice_txrx_lib.h
index e1d49e1235b3..2835a8348237 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_txrx_lib.h
@@ -151,4 +151,15 @@ ice_process_skb_fields(struct ice_rx_ring *rx_ring,
 		       struct sk_buff *skb);
 void
 ice_receive_skb(struct ice_rx_ring *rx_ring, struct sk_buff *skb, u16 vlan_tag);
+
+static inline void
+ice_xdp_set_meta_srcs(struct xdp_buff *xdp,
+		      union ice_32b_rx_flex_desc *eop_desc,
+		      struct ice_rx_ring *rx_ring)
+{
+	struct ice_xdp_buff *xdp_ext = (struct ice_xdp_buff *)xdp;
+
+	xdp_ext->eop_desc = eop_desc;
+	xdp_ext->rx_ring = rx_ring;
+}
 #endif /* !_ICE_TXRX_LIB_H_ */
-- 
2.35.3


