Return-Path: <netdev+bounces-2187-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 48373700B4D
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 17:20:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 603CB1C21293
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 15:20:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C30A24155;
	Fri, 12 May 2023 15:20:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED5F124142;
	Fri, 12 May 2023 15:20:09 +0000 (UTC)
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ED76213B;
	Fri, 12 May 2023 08:20:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683904804; x=1715440804;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5vB/mCJq56GY8l9CoZRfoaHhODKmcFLlsw3E4ilHnDM=;
  b=nzbK6K2HXGD5Jag3b6BK/LVHhQM7qk79XdRlJoR9Ii3C96I2j194zBLe
   tLbUhVuUgs6t7AumbNcgjVy/c0wEcBByEjNQ+LbQWEDGpb1/d05AAXFms
   +aOdOsDQk3fTLXTfx3uxAIZbFYkLpc6g55Utd8dbAnU3xFMOV8gWMzszB
   GQyaXNk8BF9R8+e8Z31gZX7IdR5Yo7xp9w8hYK8zQYrfRjBJ23UzdUgat
   DJpLqRwazutLb713Zgy0Gg9W/DlBi1tDXh4habGUL0hbgXLO0Tm7vAiLC
   oVYuBuNXnA/f3+pJN+v+AQq+xhgoor7KYzjhvUAPR9nblG5IqbNuIv9N1
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10708"; a="331173771"
X-IronPort-AV: E=Sophos;i="5.99,269,1677571200"; 
   d="scan'208";a="331173771"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2023 08:20:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10708"; a="765196584"
X-IronPort-AV: E=Sophos;i="5.99,269,1677571200"; 
   d="scan'208";a="765196584"
Received: from irvmail002.ir.intel.com ([10.43.11.120])
  by fmsmga008.fm.intel.com with ESMTP; 12 May 2023 08:19:59 -0700
Received: from lincoln.igk.intel.com (lincoln.igk.intel.com [10.102.21.235])
	by irvmail002.ir.intel.com (Postfix) with ESMTP id 7679B35FB9;
	Fri, 12 May 2023 16:19:57 +0100 (IST)
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
Subject: [PATCH 02/15] ice: make RX HW timestamp reading code more reusable
Date: Fri, 12 May 2023 17:16:26 +0200
Message-Id: <20230512151639.992033-3-larysa.zaremba@intel.com>
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

Previously, we only needed RX HW timestamp in skb path,
hence all related code was written with skb in mind.
But with the addition of XDP hints via kfuncs to the ice driver,
the same logic will be needed in .xmo_() callbacks.

Put generic process of reading RX HW timestamp from a descriptor
into a separate function.
Move skb-related code into another source file.

Signed-off-by: Larysa Zaremba <larysa.zaremba@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_ptp.c      | 23 +++++++---------
 drivers/net/ethernet/intel/ice/ice_ptp.h      | 18 ++++++++-----
 drivers/net/ethernet/intel/ice/ice_txrx_lib.c | 27 ++++++++++++++++++-
 3 files changed, 48 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.c b/drivers/net/ethernet/intel/ice/ice_ptp.c
index ac6f06f9a2ed..c90ce91f11ab 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.c
@@ -2142,30 +2142,28 @@ int ice_ptp_set_ts_config(struct ice_pf *pf, struct ifreq *ifr)
 }
 
 /**
- * ice_ptp_rx_hwtstamp - Check for an Rx timestamp
+ * ice_ptp_copy_rx_hwts_from_desc - Check for an Rx timestamp
  * @rx_ring: Ring to get the VSI info
  * @rx_desc: Receive descriptor
- * @skb: Particular skb to send timestamp with
+ * @dst: Address to put RX timestamp to
  *
- * The driver receives a notification in the receive descriptor with timestamp.
- * The timestamp is in ns, so we must convert the result first.
+ * If function returns true, dst contains a valid RX timestamp in ns.
  */
-void
-ice_ptp_rx_hwtstamp(struct ice_rx_ring *rx_ring,
-		    union ice_32b_rx_flex_desc *rx_desc, struct sk_buff *skb)
+bool ice_ptp_copy_rx_hwts_from_desc(struct ice_rx_ring *rx_ring,
+				    union ice_32b_rx_flex_desc *rx_desc,
+				    u64 *dst)
 {
-	struct skb_shared_hwtstamps *hwtstamps;
 	u64 ts_ns, cached_time;
 	u32 ts_high;
 
 	if (!(rx_desc->wb.time_stamp_low & ICE_PTP_TS_VALID))
-		return;
+		return false;
 
 	cached_time = READ_ONCE(rx_ring->cached_phctime);
 
 	/* Do not report a timestamp if we don't have a cached PHC time */
 	if (!cached_time)
-		return;
+		return false;
 
 	/* Use ice_ptp_extend_32b_ts directly, using the ring-specific cached
 	 * PHC value, rather than accessing the PF. This also allows us to
@@ -2176,9 +2174,8 @@ ice_ptp_rx_hwtstamp(struct ice_rx_ring *rx_ring,
 	ts_high = le32_to_cpu(rx_desc->wb.flex_ts.ts_high);
 	ts_ns = ice_ptp_extend_32b_ts(cached_time, ts_high);
 
-	hwtstamps = skb_hwtstamps(skb);
-	memset(hwtstamps, 0, sizeof(*hwtstamps));
-	hwtstamps->hwtstamp = ns_to_ktime(ts_ns);
+	*dst = ts_ns;
+	return true;
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.h b/drivers/net/ethernet/intel/ice/ice_ptp.h
index 9cda2f43e0e5..509ea9570276 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.h
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.h
@@ -259,9 +259,9 @@ int ice_get_ptp_clock_index(struct ice_pf *pf);
 s8 ice_ptp_request_ts(struct ice_ptp_tx *tx, struct sk_buff *skb);
 bool ice_ptp_process_ts(struct ice_pf *pf);
 
-void
-ice_ptp_rx_hwtstamp(struct ice_rx_ring *rx_ring,
-		    union ice_32b_rx_flex_desc *rx_desc, struct sk_buff *skb);
+bool ice_ptp_copy_rx_hwts_from_desc(struct ice_rx_ring *rx_ring,
+				    union ice_32b_rx_flex_desc *rx_desc,
+				    u64 *dst);
 void ice_ptp_reset(struct ice_pf *pf);
 void ice_ptp_prepare_for_reset(struct ice_pf *pf);
 void ice_ptp_init(struct ice_pf *pf);
@@ -294,9 +294,15 @@ static inline bool ice_ptp_process_ts(struct ice_pf *pf)
 {
 	return true;
 }
-static inline void
-ice_ptp_rx_hwtstamp(struct ice_rx_ring *rx_ring,
-		    union ice_32b_rx_flex_desc *rx_desc, struct sk_buff *skb) { }
+
+static inline bool
+ice_ptp_copy_rx_hwts_from_desc(struct ice_rx_ring *rx_ring,
+			       union ice_32b_rx_flex_desc *rx_desc,
+			       u64 *dst)
+{
+	return false;
+}
+
 static inline void ice_ptp_reset(struct ice_pf *pf) { }
 static inline void ice_ptp_prepare_for_reset(struct ice_pf *pf) { }
 static inline void ice_ptp_init(struct ice_pf *pf) { }
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx_lib.c b/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
index fc67bbf600af..1aab79dc8915 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
@@ -186,6 +186,31 @@ ice_rx_csum(struct ice_rx_ring *ring, struct sk_buff *skb,
 	ring->vsi->back->hw_csum_rx_error++;
 }
 
+/**
+ * ice_ptp_rx_hwts_to_skb - Put RX timestamp into skb, if available
+ * @rx_ring: Ring to get the VSI info
+ * @rx_desc: Receive descriptor
+ * @skb: Particular skb to send timestamp with
+ *
+ * The driver receives a notification in the receive descriptor with timestamp.
+ * The timestamp is in ns, so we must convert the result first.
+ */
+static void
+ice_ptp_rx_hwts_to_skb(struct ice_rx_ring *rx_ring,
+		       union ice_32b_rx_flex_desc *rx_desc,
+		       struct sk_buff *skb)
+{
+	struct skb_shared_hwtstamps *hwtstamps;
+	u64 ts_ns;
+
+	if (!ice_ptp_copy_rx_hwts_from_desc(rx_ring, rx_desc, &ts_ns))
+		return;
+
+	hwtstamps = skb_hwtstamps(skb);
+	memset(hwtstamps, 0, sizeof(*hwtstamps));
+	hwtstamps->hwtstamp = ns_to_ktime(ts_ns);
+}
+
 /**
  * ice_process_skb_fields - Populate skb header fields from Rx descriptor
  * @rx_ring: Rx descriptor ring packet is being transacted on
@@ -210,7 +235,7 @@ ice_process_skb_fields(struct ice_rx_ring *rx_ring,
 	ice_rx_csum(rx_ring, skb, rx_desc, ptype);
 
 	if (rx_ring->ptp_rx)
-		ice_ptp_rx_hwtstamp(rx_ring, rx_desc, skb);
+		ice_ptp_rx_hwts_to_skb(rx_ring, rx_desc, skb);
 }
 
 /**
-- 
2.35.3


