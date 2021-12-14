Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D7EE474B5B
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 20:00:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237263AbhLNTAK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 14:00:10 -0500
Received: from mga01.intel.com ([192.55.52.88]:50829 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229982AbhLNTAK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Dec 2021 14:00:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639508410; x=1671044410;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=P1w8aaDYTb8Q/9B2v0PLFEfCqlyLY+mE2trZB1suW+M=;
  b=H957Ew55/0lu2bTErlq1rBBiT4U7D0eTunRK7xdML8fZrZEZfUkXFFG0
   GVV5/PXm4aqPGyZXe3YUb4L8FLDtcvA+l8fSfSBoB5jQexshusi5tbMkL
   NlYcSDZeyRpHgP0/V/isIOQeaevUDHnKMbfZiFTV5yhpdKs7L4LmKz7wz
   Lzlaub+nMK7+dmqdf9vaafDTHo4CPNMZYcOhdynW2nqj6pspFl9J+PnJm
   NG3VnrCG2BhDlwAFXMuEFX+UvPKHW6oJgq8jWPGTWROZYBi6DvrXMfC2H
   jgXFRi8SKBf9Q/nUW00EHORcp6PZ4qOOK1tdPOwM6h2XjJJFGit0LlSbO
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10197"; a="263200020"
X-IronPort-AV: E=Sophos;i="5.88,205,1635231600"; 
   d="scan'208";a="263200020"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2021 10:30:07 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,205,1635231600"; 
   d="scan'208";a="583712726"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga004.fm.intel.com with ESMTP; 14 Dec 2021 10:30:06 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Haiyue Wang <haiyue.wang@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com,
        Tony Brelinski <tony.brelinski@intel.com>
Subject: [PATCH net-next 01/12] ice: Add package PTYPE enable information
Date:   Tue, 14 Dec 2021 10:28:57 -0800
Message-Id: <20211214182908.1513343-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211214182908.1513343-1-anthony.l.nguyen@intel.com>
References: <20211214182908.1513343-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Haiyue Wang <haiyue.wang@intel.com>

Scan the 'Marker Ptype TCAM' section to retrieve the Rx parser PTYPE
enable information from the current package.

Signed-off-by: Haiyue Wang <haiyue.wang@intel.com>
Tested-by: Tony Brelinski <tony.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 .../net/ethernet/intel/ice/ice_flex_pipe.c    | 73 +++++++++++++++++++
 .../net/ethernet/intel/ice/ice_flex_pipe.h    |  4 +
 .../net/ethernet/intel/ice/ice_flex_type.h    | 20 +++++
 drivers/net/ethernet/intel/ice/ice_type.h     |  1 +
 4 files changed, 98 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_flex_pipe.c b/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
index 6ad1c2559724..8b8209a76229 100644
--- a/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
+++ b/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
@@ -313,6 +313,78 @@ ice_pkg_enum_entry(struct ice_seg *ice_seg, struct ice_pkg_enum *state,
 	return entry;
 }
 
+/**
+ * ice_hw_ptype_ena - check if the PTYPE is enabled or not
+ * @hw: pointer to the HW structure
+ * @ptype: the hardware PTYPE
+ */
+bool ice_hw_ptype_ena(struct ice_hw *hw, u16 ptype)
+{
+	return ptype < ICE_FLOW_PTYPE_MAX &&
+	       test_bit(ptype, hw->hw_ptype);
+}
+
+/**
+ * ice_marker_ptype_tcam_handler
+ * @sect_type: section type
+ * @section: pointer to section
+ * @index: index of the Marker PType TCAM entry to be returned
+ * @offset: pointer to receive absolute offset, always 0 for ptype TCAM sections
+ *
+ * This is a callback function that can be passed to ice_pkg_enum_entry.
+ * Handles enumeration of individual Marker PType TCAM entries.
+ */
+static void *
+ice_marker_ptype_tcam_handler(u32 sect_type, void *section, u32 index,
+			      u32 *offset)
+{
+	struct ice_marker_ptype_tcam_section *marker_ptype;
+
+	if (sect_type != ICE_SID_RXPARSER_MARKER_PTYPE)
+		return NULL;
+
+	if (index > ICE_MAX_MARKER_PTYPE_TCAMS_IN_BUF)
+		return NULL;
+
+	if (offset)
+		*offset = 0;
+
+	marker_ptype = section;
+	if (index >= le16_to_cpu(marker_ptype->count))
+		return NULL;
+
+	return marker_ptype->tcam + index;
+}
+
+/**
+ * ice_fill_hw_ptype - fill the enabled PTYPE bit information
+ * @hw: pointer to the HW structure
+ */
+static void ice_fill_hw_ptype(struct ice_hw *hw)
+{
+	struct ice_marker_ptype_tcam_entry *tcam;
+	struct ice_seg *seg = hw->seg;
+	struct ice_pkg_enum state;
+
+	bitmap_zero(hw->hw_ptype, ICE_FLOW_PTYPE_MAX);
+	if (!seg)
+		return;
+
+	memset(&state, 0, sizeof(state));
+
+	do {
+		tcam = ice_pkg_enum_entry(seg, &state,
+					  ICE_SID_RXPARSER_MARKER_PTYPE, NULL,
+					  ice_marker_ptype_tcam_handler);
+		if (tcam &&
+		    le16_to_cpu(tcam->addr) < ICE_MARKER_PTYPE_TCAM_ADDR_MAX &&
+		    le16_to_cpu(tcam->ptype) < ICE_FLOW_PTYPE_MAX)
+			set_bit(le16_to_cpu(tcam->ptype), hw->hw_ptype);
+
+		seg = NULL;
+	} while (tcam);
+}
+
 /**
  * ice_boost_tcam_handler
  * @sect_type: section type
@@ -1488,6 +1560,7 @@ enum ice_status ice_init_pkg(struct ice_hw *hw, u8 *buf, u32 len)
 		 */
 		ice_init_pkg_regs(hw);
 		ice_fill_blk_tbls(hw);
+		ice_fill_hw_ptype(hw);
 		ice_get_prof_index_max(hw);
 	} else {
 		ice_debug(hw, ICE_DBG_INIT, "package load failed, %d\n",
diff --git a/drivers/net/ethernet/intel/ice/ice_flex_pipe.h b/drivers/net/ethernet/intel/ice/ice_flex_pipe.h
index a2863f38fd1f..863a3f546b82 100644
--- a/drivers/net/ethernet/intel/ice/ice_flex_pipe.h
+++ b/drivers/net/ethernet/intel/ice/ice_flex_pipe.h
@@ -40,6 +40,10 @@ int ice_udp_tunnel_set_port(struct net_device *netdev, unsigned int table,
 int ice_udp_tunnel_unset_port(struct net_device *netdev, unsigned int table,
 			      unsigned int idx, struct udp_tunnel_info *ti);
 
+/* Rx parser PTYPE functions */
+bool ice_hw_ptype_ena(struct ice_hw *hw, u16 ptype);
+
+/* XLT2/VSI group functions */
 enum ice_status
 ice_add_prof(struct ice_hw *hw, enum ice_block blk, u64 id, u8 ptypes[],
 	     const struct ice_ptype_attributes *attr, u16 attr_cnt,
diff --git a/drivers/net/ethernet/intel/ice/ice_flex_type.h b/drivers/net/ethernet/intel/ice/ice_flex_type.h
index 0f572a36d021..a8246fb039ca 100644
--- a/drivers/net/ethernet/intel/ice/ice_flex_type.h
+++ b/drivers/net/ethernet/intel/ice/ice_flex_type.h
@@ -160,6 +160,7 @@ struct ice_meta_sect {
 #define ICE_SID_CDID_KEY_BUILDER_RSS	47
 #define ICE_SID_CDID_REDIR_RSS		48
 
+#define ICE_SID_RXPARSER_MARKER_PTYPE	55
 #define ICE_SID_RXPARSER_BOOST_TCAM	56
 #define ICE_SID_TXPARSER_BOOST_TCAM	66
 
@@ -329,6 +330,25 @@ struct ice_boost_tcam_section {
 	sizeof(struct ice_boost_tcam_entry), \
 	sizeof(struct ice_boost_tcam_entry))
 
+/* package Marker Ptype TCAM entry */
+struct ice_marker_ptype_tcam_entry {
+#define ICE_MARKER_PTYPE_TCAM_ADDR_MAX	1024
+	__le16 addr;
+	__le16 ptype;
+	u8 keys[20];
+};
+
+struct ice_marker_ptype_tcam_section {
+	__le16 count;
+	__le16 reserved;
+	struct ice_marker_ptype_tcam_entry tcam[];
+};
+
+#define ICE_MAX_MARKER_PTYPE_TCAMS_IN_BUF	\
+	ICE_MAX_ENTRIES_IN_BUF(struct_size((struct ice_marker_ptype_tcam_section *)0, tcam, 1) - \
+	sizeof(struct ice_marker_ptype_tcam_entry), \
+	sizeof(struct ice_marker_ptype_tcam_entry))
+
 struct ice_xlt1_section {
 	__le16 count;
 	__le16 offset;
diff --git a/drivers/net/ethernet/intel/ice/ice_type.h b/drivers/net/ethernet/intel/ice/ice_type.h
index 9e0c2923c62e..1f3582197e60 100644
--- a/drivers/net/ethernet/intel/ice/ice_type.h
+++ b/drivers/net/ethernet/intel/ice/ice_type.h
@@ -919,6 +919,7 @@ struct ice_hw {
 	struct mutex rss_locks;	/* protect RSS configuration */
 	struct list_head rss_list_head;
 	struct ice_mbx_snapshot mbx_snapshot;
+	DECLARE_BITMAP(hw_ptype, ICE_FLOW_PTYPE_MAX);
 	u16 io_expander_handle;
 };
 
-- 
2.31.1

