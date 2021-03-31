Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2299350A80
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 01:08:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232207AbhCaXHn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 19:07:43 -0400
Received: from mga14.intel.com ([192.55.52.115]:62994 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230073AbhCaXHZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Mar 2021 19:07:25 -0400
IronPort-SDR: 7DD832vAIitp6NUARaFzmiwSIOU93bizFUn8xWcnibjAEidie/l7DhV4nuVm8TsGUvatRcQNZF
 Fa0+tzQkF3cA==
X-IronPort-AV: E=McAfee;i="6000,8403,9940"; a="191587973"
X-IronPort-AV: E=Sophos;i="5.81,295,1610438400"; 
   d="scan'208";a="191587973"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2021 16:07:23 -0700
IronPort-SDR: ZHggBYG+7KgSpNHlzAvrQKDwzrz9OJKzDTg1AeVo/DATvtJEKnGa2gR6PIy9nMJEjpicRM0CFi
 6+kTdQKwjGfw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,295,1610438400"; 
   d="scan'208";a="610680097"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga005.fm.intel.com with ESMTP; 31 Mar 2021 16:07:23 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Dan Nowlin <dan.nowlin@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net-next 03/15] ice: Update to use package info from ice segment
Date:   Wed, 31 Mar 2021 16:08:46 -0700
Message-Id: <20210331230858.782492-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210331230858.782492-1-anthony.l.nguyen@intel.com>
References: <20210331230858.782492-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Nowlin <dan.nowlin@intel.com>

There are two package versions in the package binary. Today, these two
version numbers are the same. However, in the future that may change.

Update code to use the package info from the ice segment metadata
section, which is the package information that is actually downloaded to
the firmware during the download package process.

Signed-off-by: Dan Nowlin <dan.nowlin@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 .../net/ethernet/intel/ice/ice_adminq_cmd.h   |  1 +
 .../net/ethernet/intel/ice/ice_flex_pipe.c    | 40 ++++++++++---------
 .../net/ethernet/intel/ice/ice_flex_type.h    |  9 +++++
 drivers/net/ethernet/intel/ice/ice_type.h     |  8 ++--
 4 files changed, 36 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
index 80186589153b..5108046476f1 100644
--- a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
+++ b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
@@ -1790,6 +1790,7 @@ struct ice_pkg_ver {
 };
 
 #define ICE_PKG_NAME_SIZE	32
+#define ICE_SEG_ID_SIZE		28
 #define ICE_SEG_NAME_SIZE	28
 
 struct ice_aqc_get_pkg_info {
diff --git a/drivers/net/ethernet/intel/ice/ice_flex_pipe.c b/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
index afe77f7a3199..4b83960876f4 100644
--- a/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
+++ b/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
@@ -1063,32 +1063,36 @@ ice_download_pkg(struct ice_hw *hw, struct ice_seg *ice_seg)
 static enum ice_status
 ice_init_pkg_info(struct ice_hw *hw, struct ice_pkg_hdr *pkg_hdr)
 {
-	struct ice_global_metadata_seg *meta_seg;
 	struct ice_generic_seg_hdr *seg_hdr;
 
 	if (!pkg_hdr)
 		return ICE_ERR_PARAM;
 
-	meta_seg = (struct ice_global_metadata_seg *)
-		   ice_find_seg_in_pkg(hw, SEGMENT_TYPE_METADATA, pkg_hdr);
-	if (meta_seg) {
-		hw->pkg_ver = meta_seg->pkg_ver;
-		memcpy(hw->pkg_name, meta_seg->pkg_name, sizeof(hw->pkg_name));
+	seg_hdr = ice_find_seg_in_pkg(hw, SEGMENT_TYPE_ICE, pkg_hdr);
+	if (seg_hdr) {
+		struct ice_meta_sect *meta;
+		struct ice_pkg_enum state;
+
+		memset(&state, 0, sizeof(state));
+
+		/* Get package information from the Metadata Section */
+		meta = ice_pkg_enum_section((struct ice_seg *)seg_hdr, &state,
+					    ICE_SID_METADATA);
+		if (!meta) {
+			ice_debug(hw, ICE_DBG_INIT, "Did not find ice metadata section in package\n");
+			return ICE_ERR_CFG;
+		}
+
+		hw->pkg_ver = meta->ver;
+		memcpy(hw->pkg_name, meta->name, sizeof(meta->name));
 
 		ice_debug(hw, ICE_DBG_PKG, "Pkg: %d.%d.%d.%d, %s\n",
-			  meta_seg->pkg_ver.major, meta_seg->pkg_ver.minor,
-			  meta_seg->pkg_ver.update, meta_seg->pkg_ver.draft,
-			  meta_seg->pkg_name);
-	} else {
-		ice_debug(hw, ICE_DBG_INIT, "Did not find metadata segment in driver package\n");
-		return ICE_ERR_CFG;
-	}
+			  meta->ver.major, meta->ver.minor, meta->ver.update,
+			  meta->ver.draft, meta->name);
 
-	seg_hdr = ice_find_seg_in_pkg(hw, SEGMENT_TYPE_ICE, pkg_hdr);
-	if (seg_hdr) {
-		hw->ice_pkg_ver = seg_hdr->seg_format_ver;
-		memcpy(hw->ice_pkg_name, seg_hdr->seg_id,
-		       sizeof(hw->ice_pkg_name));
+		hw->ice_seg_fmt_ver = seg_hdr->seg_format_ver;
+		memcpy(hw->ice_seg_id, seg_hdr->seg_id,
+		       sizeof(hw->ice_seg_id));
 
 		ice_debug(hw, ICE_DBG_PKG, "Ice Seg: %d.%d.%d.%d, %s\n",
 			  seg_hdr->seg_format_ver.major,
diff --git a/drivers/net/ethernet/intel/ice/ice_flex_type.h b/drivers/net/ethernet/intel/ice/ice_flex_type.h
index abc156ce9d8c..9806183920de 100644
--- a/drivers/net/ethernet/intel/ice/ice_flex_type.h
+++ b/drivers/net/ethernet/intel/ice/ice_flex_type.h
@@ -109,6 +109,7 @@ struct ice_buf_hdr {
 	(ent_sz))
 
 /* ice package section IDs */
+#define ICE_SID_METADATA		1
 #define ICE_SID_XLT0_SW			10
 #define ICE_SID_XLT_KEY_BUILDER_SW	11
 #define ICE_SID_XLT1_SW			12
@@ -117,6 +118,14 @@ struct ice_buf_hdr {
 #define ICE_SID_PROFID_REDIR_SW		15
 #define ICE_SID_FLD_VEC_SW		16
 #define ICE_SID_CDID_KEY_BUILDER_SW	17
+
+struct ice_meta_sect {
+	struct ice_pkg_ver ver;
+#define ICE_META_SECT_NAME_SIZE	28
+	char name[ICE_META_SECT_NAME_SIZE];
+	__le32 track_id;
+};
+
 #define ICE_SID_CDID_REDIR_SW		18
 
 #define ICE_SID_XLT0_ACL		20
diff --git a/drivers/net/ethernet/intel/ice/ice_type.h b/drivers/net/ethernet/intel/ice/ice_type.h
index 2893143d9e62..ba157b383127 100644
--- a/drivers/net/ethernet/intel/ice/ice_type.h
+++ b/drivers/net/ethernet/intel/ice/ice_type.h
@@ -720,13 +720,13 @@ struct ice_hw {
 
 	enum ice_aq_err pkg_dwnld_status;
 
-	/* Driver's package ver - (from the Metadata seg) */
+	/* Driver's package ver - (from the Ice Metadata section) */
 	struct ice_pkg_ver pkg_ver;
 	u8 pkg_name[ICE_PKG_NAME_SIZE];
 
-	/* Driver's Ice package version (from the Ice seg) */
-	struct ice_pkg_ver ice_pkg_ver;
-	u8 ice_pkg_name[ICE_PKG_NAME_SIZE];
+	/* Driver's Ice segment format version and ID (from the Ice seg) */
+	struct ice_pkg_ver ice_seg_fmt_ver;
+	u8 ice_seg_id[ICE_SEG_ID_SIZE];
 
 	/* Pointer to the ice segment */
 	struct ice_seg *seg;
-- 
2.26.2

