Return-Path: <netdev+bounces-2186-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CD69E700B40
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 17:20:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B3C3D1C21272
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 15:20:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C39A024148;
	Fri, 12 May 2023 15:20:05 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4D6424126;
	Fri, 12 May 2023 15:20:05 +0000 (UTC)
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6092CCC;
	Fri, 12 May 2023 08:19:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683904799; x=1715440799;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=13ozT9YozZElJj9JXKreIzUvD87aIPckZkK7jKB5PsY=;
  b=QQH9mY5FfpB43BNtjNQiyB/x/ESl8tiR04ZJnNYGFSTG2puy5YdMQ801
   SP5yYE3ug2Y6+KAqxSuyDftSOY+RY80G5NSGRvT6NbpOGTYOHRSKIhPw6
   C8kprG/+ZccoyWrT2RDvq3w+58biTKzZTvDJfDgAsk38iijS5TE5JJv1H
   e1Sok5DLOhx5OYKXjo/R88+J1R++Coaypr1tiB1sSG1izIqBsnl00noeK
   /GCiNdeRmkC38glokRs42NESI8ra0klgHajI7pfEmASv7uwdXZjF3U6Jh
   bdffx/qMOxX5LAV5c/woBKSY5ADLwC3AT5SXlXsKhBPeLPUICgUDWj8oB
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10708"; a="331173732"
X-IronPort-AV: E=Sophos;i="5.99,269,1677571200"; 
   d="scan'208";a="331173732"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2023 08:19:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10708"; a="765196498"
X-IronPort-AV: E=Sophos;i="5.99,269,1677571200"; 
   d="scan'208";a="765196498"
Received: from irvmail002.ir.intel.com ([10.43.11.120])
  by fmsmga008.fm.intel.com with ESMTP; 12 May 2023 08:19:54 -0700
Received: from lincoln.igk.intel.com (lincoln.igk.intel.com [10.102.21.235])
	by irvmail002.ir.intel.com (Postfix) with ESMTP id 2989635FB7;
	Fri, 12 May 2023 16:19:52 +0100 (IST)
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
Subject: [PATCH 01/15] ice: make RX hash reading code more reusable
Date: Fri, 12 May 2023 17:16:25 +0200
Message-Id: <20230512151639.992033-2-larysa.zaremba@intel.com>
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

Previously, we only needed RX hash in skb path,
hence all related code was written with skb in mind.
But with the addition of XDP hints via kfuncs to the ice driver,
the same logic will be needed in .xmo_() callbacks.

Separate generic process of reading RX hash from a descriptor
into a separate function.

Signed-off-by: Larysa Zaremba <larysa.zaremba@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_txrx_lib.c | 38 +++++++++++++------
 1 file changed, 27 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_txrx_lib.c b/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
index c8322fb6f2b3..fc67bbf600af 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
@@ -63,28 +63,44 @@ static enum pkt_hash_types ice_ptype_to_htype(u16 ptype)
 }
 
 /**
- * ice_rx_hash - set the hash value in the skb
+ * ice_copy_rx_hash_from_desc - copy hash value from descriptor to address
+ * @rx_desc: specific descriptor
+ * @dst: address to copy hash value to
+ *
+ * Returns true, if valid hash has been copied into the destination address.
+ */
+static bool
+ice_copy_rx_hash_from_desc(union ice_32b_rx_flex_desc *rx_desc, u32 *dst)
+{
+	struct ice_32b_rx_flex_desc_nic *nic_mdid;
+
+	if (rx_desc->wb.rxdid != ICE_RXDID_FLEX_NIC)
+		return false;
+
+	nic_mdid = (struct ice_32b_rx_flex_desc_nic *)rx_desc;
+	*dst = le32_to_cpu(nic_mdid->rss_hash);
+	return true;
+}
+
+/**
+ * ice_rx_hash_to_skb - set the hash value in the skb
  * @rx_ring: descriptor ring
  * @rx_desc: specific descriptor
  * @skb: pointer to current skb
  * @rx_ptype: the ptype value from the descriptor
  */
 static void
-ice_rx_hash(struct ice_rx_ring *rx_ring, union ice_32b_rx_flex_desc *rx_desc,
-	    struct sk_buff *skb, u16 rx_ptype)
+ice_rx_hash_to_skb(struct ice_rx_ring *rx_ring,
+		   union ice_32b_rx_flex_desc *rx_desc,
+		   struct sk_buff *skb, u16 rx_ptype)
 {
-	struct ice_32b_rx_flex_desc_nic *nic_mdid;
 	u32 hash;
 
 	if (!(rx_ring->netdev->features & NETIF_F_RXHASH))
 		return;
 
-	if (rx_desc->wb.rxdid != ICE_RXDID_FLEX_NIC)
-		return;
-
-	nic_mdid = (struct ice_32b_rx_flex_desc_nic *)rx_desc;
-	hash = le32_to_cpu(nic_mdid->rss_hash);
-	skb_set_hash(skb, hash, ice_ptype_to_htype(rx_ptype));
+	if (ice_copy_rx_hash_from_desc(rx_desc, &hash))
+		skb_set_hash(skb, hash, ice_ptype_to_htype(rx_ptype));
 }
 
 /**
@@ -186,7 +202,7 @@ ice_process_skb_fields(struct ice_rx_ring *rx_ring,
 		       union ice_32b_rx_flex_desc *rx_desc,
 		       struct sk_buff *skb, u16 ptype)
 {
-	ice_rx_hash(rx_ring, rx_desc, skb, ptype);
+	ice_rx_hash_to_skb(rx_ring, rx_desc, skb, ptype);
 
 	/* modifies the skb - consumes the enet header */
 	skb->protocol = eth_type_trans(skb, rx_ring->netdev);
-- 
2.35.3


