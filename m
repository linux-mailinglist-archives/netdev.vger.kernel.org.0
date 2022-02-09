Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A63974AFFAF
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 23:00:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234826AbiBIV6G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 16:58:06 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:55790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234547AbiBIV5U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 16:57:20 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8AA3E010DB0
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 13:57:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644443838; x=1675979838;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=U+nYa0Zo4IQcK8QIdnLtl6T6r1UPSaPtfP3MMrfvwrI=;
  b=EM+6dr2hnNI9dIj8hoWeM9+seOGL/0nqeu1L3JfvtMxGDWnfqynOmAF6
   waHKzz6F9K7RJ9rISaE3FKakwHm3ccqhGKXgyc8NXcBh+OchdS2qJyL2C
   5gZJveFAGk/XLCngJAmIyFyK85xt0NLWTm+E8h7wspHSwHOzWoXm74fKh
   HjsfyzZmiMZR4ds+NL1pM5Ui1r3J1edrnMVXvEsK/sErk+k8lyNiHE1Y1
   EuFdeS9wNmAUTs4kkvhYuB6j6f+3vhOAvZ8VELxAzESAebR7c0IvQ0azm
   Yx4rleF0t9cghwcrnFcCTNqL8i+VSt5Qwx6sTfqubitvCm0crCzty/OQs
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10253"; a="249104099"
X-IronPort-AV: E=Sophos;i="5.88,356,1635231600"; 
   d="scan'208";a="249104099"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2022 13:57:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,356,1635231600"; 
   d="scan'208";a="601790495"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga004.fm.intel.com with ESMTP; 09 Feb 2022 13:57:16 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Brett Creeley <brett.creeley@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net-next 07/14] ice: Adjust naming for inner VLAN operations
Date:   Wed,  9 Feb 2022 13:56:59 -0800
Message-Id: <20220209215706.2468371-8-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220209215706.2468371-1-anthony.l.nguyen@intel.com>
References: <20220209215706.2468371-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brett Creeley <brett.creeley@intel.com>

Current operations act on inner VLAN fields. To support double VLAN, outer
VLAN operations and functions will be implemented. Add the "inner" naming
to existing VLAN operations to distinguish them from the upcoming outer
values and functions. Some spacing adjustments are made to align
values.

Note that the inner is not talking about a tunneled VLAN, but the second
VLAN in the packet. For SVM the driver uses inner or single VLAN
filtering and offloads and in Double VLAN Mode the driver uses the
inner filtering and offloads for SR-IOV VFs in port VLANs in order to
support offloading the guest VLAN while a port VLAN is configured.

Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 .../net/ethernet/intel/ice/ice_adminq_cmd.h   | 191 +++++++++---------
 drivers/net/ethernet/intel/ice/ice_lib.c      |   8 +-
 drivers/net/ethernet/intel/ice/ice_main.c     |   6 +-
 .../net/ethernet/intel/ice/ice_vsi_vlan_lib.c |  57 +++---
 .../net/ethernet/intel/ice/ice_vsi_vlan_lib.h |  10 +-
 .../net/ethernet/intel/ice/ice_vsi_vlan_ops.c |  10 +-
 6 files changed, 140 insertions(+), 142 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
index ad1dcfa5ff65..72214c609cf5 100644
--- a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
+++ b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
@@ -343,108 +343,113 @@ struct ice_aqc_vsi_props {
 #define ICE_AQ_VSI_SW_FLAG_SRC_PRUNE		BIT(7)
 	u8 sw_flags2;
 #define ICE_AQ_VSI_SW_FLAG_RX_PRUNE_EN_S	0
-#define ICE_AQ_VSI_SW_FLAG_RX_PRUNE_EN_M	\
-				(0xF << ICE_AQ_VSI_SW_FLAG_RX_PRUNE_EN_S)
+#define ICE_AQ_VSI_SW_FLAG_RX_PRUNE_EN_M	(0xF << ICE_AQ_VSI_SW_FLAG_RX_PRUNE_EN_S)
 #define ICE_AQ_VSI_SW_FLAG_RX_VLAN_PRUNE_ENA	BIT(0)
 #define ICE_AQ_VSI_SW_FLAG_LAN_ENA		BIT(4)
 	u8 veb_stat_id;
 #define ICE_AQ_VSI_SW_VEB_STAT_ID_S		0
-#define ICE_AQ_VSI_SW_VEB_STAT_ID_M	(0x1F << ICE_AQ_VSI_SW_VEB_STAT_ID_S)
+#define ICE_AQ_VSI_SW_VEB_STAT_ID_M		(0x1F << ICE_AQ_VSI_SW_VEB_STAT_ID_S)
 #define ICE_AQ_VSI_SW_VEB_STAT_ID_VALID		BIT(5)
 	/* security section */
 	u8 sec_flags;
 #define ICE_AQ_VSI_SEC_FLAG_ALLOW_DEST_OVRD	BIT(0)
 #define ICE_AQ_VSI_SEC_FLAG_ENA_MAC_ANTI_SPOOF	BIT(2)
-#define ICE_AQ_VSI_SEC_TX_PRUNE_ENA_S	4
-#define ICE_AQ_VSI_SEC_TX_PRUNE_ENA_M	(0xF << ICE_AQ_VSI_SEC_TX_PRUNE_ENA_S)
+#define ICE_AQ_VSI_SEC_TX_PRUNE_ENA_S		4
+#define ICE_AQ_VSI_SEC_TX_PRUNE_ENA_M		(0xF << ICE_AQ_VSI_SEC_TX_PRUNE_ENA_S)
 #define ICE_AQ_VSI_SEC_TX_VLAN_PRUNE_ENA	BIT(0)
 	u8 sec_reserved;
 	/* VLAN section */
-	__le16 pvid; /* VLANS include priority bits */
-	u8 pvlan_reserved[2];
-	u8 vlan_flags;
-#define ICE_AQ_VSI_VLAN_MODE_S	0
-#define ICE_AQ_VSI_VLAN_MODE_M	(0x3 << ICE_AQ_VSI_VLAN_MODE_S)
-#define ICE_AQ_VSI_VLAN_MODE_UNTAGGED	0x1
-#define ICE_AQ_VSI_VLAN_MODE_TAGGED	0x2
-#define ICE_AQ_VSI_VLAN_MODE_ALL	0x3
-#define ICE_AQ_VSI_PVLAN_INSERT_PVID	BIT(2)
-#define ICE_AQ_VSI_VLAN_EMOD_S		3
-#define ICE_AQ_VSI_VLAN_EMOD_M		(0x3 << ICE_AQ_VSI_VLAN_EMOD_S)
-#define ICE_AQ_VSI_VLAN_EMOD_STR_BOTH	(0x0 << ICE_AQ_VSI_VLAN_EMOD_S)
-#define ICE_AQ_VSI_VLAN_EMOD_STR_UP	(0x1 << ICE_AQ_VSI_VLAN_EMOD_S)
-#define ICE_AQ_VSI_VLAN_EMOD_STR	(0x2 << ICE_AQ_VSI_VLAN_EMOD_S)
-#define ICE_AQ_VSI_VLAN_EMOD_NOTHING	(0x3 << ICE_AQ_VSI_VLAN_EMOD_S)
-	u8 pvlan_reserved2[3];
+	__le16 port_based_inner_vlan; /* VLANS include priority bits */
+	u8 inner_vlan_reserved[2];
+	u8 inner_vlan_flags;
+#define ICE_AQ_VSI_INNER_VLAN_TX_MODE_S		0
+#define ICE_AQ_VSI_INNER_VLAN_TX_MODE_M		(0x3 << ICE_AQ_VSI_INNER_VLAN_TX_MODE_S)
+#define ICE_AQ_VSI_INNER_VLAN_TX_MODE_ACCEPTUNTAGGED	0x1
+#define ICE_AQ_VSI_INNER_VLAN_TX_MODE_ACCEPTTAGGED	0x2
+#define ICE_AQ_VSI_INNER_VLAN_TX_MODE_ALL	0x3
+#define ICE_AQ_VSI_INNER_VLAN_INSERT_PVID	BIT(2)
+#define ICE_AQ_VSI_INNER_VLAN_EMODE_S		3
+#define ICE_AQ_VSI_INNER_VLAN_EMODE_M		(0x3 << ICE_AQ_VSI_INNER_VLAN_EMODE_S)
+#define ICE_AQ_VSI_INNER_VLAN_EMODE_STR_BOTH	(0x0 << ICE_AQ_VSI_INNER_VLAN_EMODE_S)
+#define ICE_AQ_VSI_INNER_VLAN_EMODE_STR_UP	(0x1 << ICE_AQ_VSI_INNER_VLAN_EMODE_S)
+#define ICE_AQ_VSI_INNER_VLAN_EMODE_STR		(0x2 << ICE_AQ_VSI_INNER_VLAN_EMODE_S)
+#define ICE_AQ_VSI_INNER_VLAN_EMODE_NOTHING	(0x3 << ICE_AQ_VSI_INNER_VLAN_EMODE_S)
+	u8 inner_vlan_reserved2[3];
 	/* ingress egress up sections */
 	__le32 ingress_table; /* bitmap, 3 bits per up */
-#define ICE_AQ_VSI_UP_TABLE_UP0_S	0
-#define ICE_AQ_VSI_UP_TABLE_UP0_M	(0x7 << ICE_AQ_VSI_UP_TABLE_UP0_S)
-#define ICE_AQ_VSI_UP_TABLE_UP1_S	3
-#define ICE_AQ_VSI_UP_TABLE_UP1_M	(0x7 << ICE_AQ_VSI_UP_TABLE_UP1_S)
-#define ICE_AQ_VSI_UP_TABLE_UP2_S	6
-#define ICE_AQ_VSI_UP_TABLE_UP2_M	(0x7 << ICE_AQ_VSI_UP_TABLE_UP2_S)
-#define ICE_AQ_VSI_UP_TABLE_UP3_S	9
-#define ICE_AQ_VSI_UP_TABLE_UP3_M	(0x7 << ICE_AQ_VSI_UP_TABLE_UP3_S)
-#define ICE_AQ_VSI_UP_TABLE_UP4_S	12
-#define ICE_AQ_VSI_UP_TABLE_UP4_M	(0x7 << ICE_AQ_VSI_UP_TABLE_UP4_S)
-#define ICE_AQ_VSI_UP_TABLE_UP5_S	15
-#define ICE_AQ_VSI_UP_TABLE_UP5_M	(0x7 << ICE_AQ_VSI_UP_TABLE_UP5_S)
-#define ICE_AQ_VSI_UP_TABLE_UP6_S	18
-#define ICE_AQ_VSI_UP_TABLE_UP6_M	(0x7 << ICE_AQ_VSI_UP_TABLE_UP6_S)
-#define ICE_AQ_VSI_UP_TABLE_UP7_S	21
-#define ICE_AQ_VSI_UP_TABLE_UP7_M	(0x7 << ICE_AQ_VSI_UP_TABLE_UP7_S)
+#define ICE_AQ_VSI_UP_TABLE_UP0_S		0
+#define ICE_AQ_VSI_UP_TABLE_UP0_M		(0x7 << ICE_AQ_VSI_UP_TABLE_UP0_S)
+#define ICE_AQ_VSI_UP_TABLE_UP1_S		3
+#define ICE_AQ_VSI_UP_TABLE_UP1_M		(0x7 << ICE_AQ_VSI_UP_TABLE_UP1_S)
+#define ICE_AQ_VSI_UP_TABLE_UP2_S		6
+#define ICE_AQ_VSI_UP_TABLE_UP2_M		(0x7 << ICE_AQ_VSI_UP_TABLE_UP2_S)
+#define ICE_AQ_VSI_UP_TABLE_UP3_S		9
+#define ICE_AQ_VSI_UP_TABLE_UP3_M		(0x7 << ICE_AQ_VSI_UP_TABLE_UP3_S)
+#define ICE_AQ_VSI_UP_TABLE_UP4_S		12
+#define ICE_AQ_VSI_UP_TABLE_UP4_M		(0x7 << ICE_AQ_VSI_UP_TABLE_UP4_S)
+#define ICE_AQ_VSI_UP_TABLE_UP5_S		15
+#define ICE_AQ_VSI_UP_TABLE_UP5_M		(0x7 << ICE_AQ_VSI_UP_TABLE_UP5_S)
+#define ICE_AQ_VSI_UP_TABLE_UP6_S		18
+#define ICE_AQ_VSI_UP_TABLE_UP6_M		(0x7 << ICE_AQ_VSI_UP_TABLE_UP6_S)
+#define ICE_AQ_VSI_UP_TABLE_UP7_S		21
+#define ICE_AQ_VSI_UP_TABLE_UP7_M		(0x7 << ICE_AQ_VSI_UP_TABLE_UP7_S)
 	__le32 egress_table;   /* same defines as for ingress table */
 	/* outer tags section */
-	__le16 outer_tag;
-	u8 outer_tag_flags;
-#define ICE_AQ_VSI_OUTER_TAG_MODE_S	0
-#define ICE_AQ_VSI_OUTER_TAG_MODE_M	(0x3 << ICE_AQ_VSI_OUTER_TAG_MODE_S)
-#define ICE_AQ_VSI_OUTER_TAG_NOTHING	0x0
-#define ICE_AQ_VSI_OUTER_TAG_REMOVE	0x1
-#define ICE_AQ_VSI_OUTER_TAG_COPY	0x2
-#define ICE_AQ_VSI_OUTER_TAG_TYPE_S	2
-#define ICE_AQ_VSI_OUTER_TAG_TYPE_M	(0x3 << ICE_AQ_VSI_OUTER_TAG_TYPE_S)
-#define ICE_AQ_VSI_OUTER_TAG_NONE	0x0
-#define ICE_AQ_VSI_OUTER_TAG_STAG	0x1
-#define ICE_AQ_VSI_OUTER_TAG_VLAN_8100	0x2
-#define ICE_AQ_VSI_OUTER_TAG_VLAN_9100	0x3
-#define ICE_AQ_VSI_OUTER_TAG_INSERT	BIT(4)
-#define ICE_AQ_VSI_OUTER_TAG_ACCEPT_HOST BIT(6)
-	u8 outer_tag_reserved;
+	__le16 port_based_outer_vlan;
+	u8 outer_vlan_flags;
+#define ICE_AQ_VSI_OUTER_VLAN_EMODE_S		0
+#define ICE_AQ_VSI_OUTER_VLAN_EMODE_M		(0x3 << ICE_AQ_VSI_OUTER_VLAN_EMODE_S)
+#define ICE_AQ_VSI_OUTER_VLAN_EMODE_SHOW_BOTH	0x0
+#define ICE_AQ_VSI_OUTER_VLAN_EMODE_SHOW_UP	0x1
+#define ICE_AQ_VSI_OUTER_VLAN_EMODE_SHOW	0x2
+#define ICE_AQ_VSI_OUTER_VLAN_EMODE_NOTHING	0x3
+#define ICE_AQ_VSI_OUTER_TAG_TYPE_S		2
+#define ICE_AQ_VSI_OUTER_TAG_TYPE_M		(0x3 << ICE_AQ_VSI_OUTER_TAG_TYPE_S)
+#define ICE_AQ_VSI_OUTER_TAG_NONE		0x0
+#define ICE_AQ_VSI_OUTER_TAG_STAG		0x1
+#define ICE_AQ_VSI_OUTER_TAG_VLAN_8100		0x2
+#define ICE_AQ_VSI_OUTER_TAG_VLAN_9100		0x3
+#define ICE_AQ_VSI_OUTER_VLAN_PORT_BASED_INSERT		BIT(4)
+#define ICE_AQ_VSI_OUTER_VLAN_TX_MODE_S			5
+#define ICE_AQ_VSI_OUTER_VLAN_TX_MODE_M			(0x3 << ICE_AQ_VSI_OUTER_VLAN_TX_MODE_S)
+#define ICE_AQ_VSI_OUTER_VLAN_TX_MODE_ACCEPTUNTAGGED	0x1
+#define ICE_AQ_VSI_OUTER_VLAN_TX_MODE_ACCEPTTAGGED	0x2
+#define ICE_AQ_VSI_OUTER_VLAN_TX_MODE_ALL		0x3
+#define ICE_AQ_VSI_OUTER_VLAN_BLOCK_TX_DESC		BIT(7)
+	u8 outer_vlan_reserved;
 	/* queue mapping section */
 	__le16 mapping_flags;
-#define ICE_AQ_VSI_Q_MAP_CONTIG	0x0
-#define ICE_AQ_VSI_Q_MAP_NONCONTIG	BIT(0)
+#define ICE_AQ_VSI_Q_MAP_CONTIG			0x0
+#define ICE_AQ_VSI_Q_MAP_NONCONTIG		BIT(0)
 	__le16 q_mapping[16];
-#define ICE_AQ_VSI_Q_S		0
-#define ICE_AQ_VSI_Q_M		(0x7FF << ICE_AQ_VSI_Q_S)
+#define ICE_AQ_VSI_Q_S				0
+#define ICE_AQ_VSI_Q_M				(0x7FF << ICE_AQ_VSI_Q_S)
 	__le16 tc_mapping[8];
-#define ICE_AQ_VSI_TC_Q_OFFSET_S	0
-#define ICE_AQ_VSI_TC_Q_OFFSET_M	(0x7FF << ICE_AQ_VSI_TC_Q_OFFSET_S)
-#define ICE_AQ_VSI_TC_Q_NUM_S		11
-#define ICE_AQ_VSI_TC_Q_NUM_M		(0xF << ICE_AQ_VSI_TC_Q_NUM_S)
+#define ICE_AQ_VSI_TC_Q_OFFSET_S		0
+#define ICE_AQ_VSI_TC_Q_OFFSET_M		(0x7FF << ICE_AQ_VSI_TC_Q_OFFSET_S)
+#define ICE_AQ_VSI_TC_Q_NUM_S			11
+#define ICE_AQ_VSI_TC_Q_NUM_M			(0xF << ICE_AQ_VSI_TC_Q_NUM_S)
 	/* queueing option section */
 	u8 q_opt_rss;
-#define ICE_AQ_VSI_Q_OPT_RSS_LUT_S	0
-#define ICE_AQ_VSI_Q_OPT_RSS_LUT_M	(0x3 << ICE_AQ_VSI_Q_OPT_RSS_LUT_S)
-#define ICE_AQ_VSI_Q_OPT_RSS_LUT_VSI	0x0
-#define ICE_AQ_VSI_Q_OPT_RSS_LUT_PF	0x2
-#define ICE_AQ_VSI_Q_OPT_RSS_LUT_GBL	0x3
-#define ICE_AQ_VSI_Q_OPT_RSS_GBL_LUT_S	2
-#define ICE_AQ_VSI_Q_OPT_RSS_GBL_LUT_M	(0xF << ICE_AQ_VSI_Q_OPT_RSS_GBL_LUT_S)
-#define ICE_AQ_VSI_Q_OPT_RSS_HASH_S	6
-#define ICE_AQ_VSI_Q_OPT_RSS_HASH_M	(0x3 << ICE_AQ_VSI_Q_OPT_RSS_HASH_S)
-#define ICE_AQ_VSI_Q_OPT_RSS_TPLZ	(0x0 << ICE_AQ_VSI_Q_OPT_RSS_HASH_S)
-#define ICE_AQ_VSI_Q_OPT_RSS_SYM_TPLZ	(0x1 << ICE_AQ_VSI_Q_OPT_RSS_HASH_S)
-#define ICE_AQ_VSI_Q_OPT_RSS_XOR	(0x2 << ICE_AQ_VSI_Q_OPT_RSS_HASH_S)
-#define ICE_AQ_VSI_Q_OPT_RSS_JHASH	(0x3 << ICE_AQ_VSI_Q_OPT_RSS_HASH_S)
+#define ICE_AQ_VSI_Q_OPT_RSS_LUT_S		0
+#define ICE_AQ_VSI_Q_OPT_RSS_LUT_M		(0x3 << ICE_AQ_VSI_Q_OPT_RSS_LUT_S)
+#define ICE_AQ_VSI_Q_OPT_RSS_LUT_VSI		0x0
+#define ICE_AQ_VSI_Q_OPT_RSS_LUT_PF		0x2
+#define ICE_AQ_VSI_Q_OPT_RSS_LUT_GBL		0x3
+#define ICE_AQ_VSI_Q_OPT_RSS_GBL_LUT_S		2
+#define ICE_AQ_VSI_Q_OPT_RSS_GBL_LUT_M		(0xF << ICE_AQ_VSI_Q_OPT_RSS_GBL_LUT_S)
+#define ICE_AQ_VSI_Q_OPT_RSS_HASH_S		6
+#define ICE_AQ_VSI_Q_OPT_RSS_HASH_M		(0x3 << ICE_AQ_VSI_Q_OPT_RSS_HASH_S)
+#define ICE_AQ_VSI_Q_OPT_RSS_TPLZ		(0x0 << ICE_AQ_VSI_Q_OPT_RSS_HASH_S)
+#define ICE_AQ_VSI_Q_OPT_RSS_SYM_TPLZ		(0x1 << ICE_AQ_VSI_Q_OPT_RSS_HASH_S)
+#define ICE_AQ_VSI_Q_OPT_RSS_XOR		(0x2 << ICE_AQ_VSI_Q_OPT_RSS_HASH_S)
+#define ICE_AQ_VSI_Q_OPT_RSS_JHASH		(0x3 << ICE_AQ_VSI_Q_OPT_RSS_HASH_S)
 	u8 q_opt_tc;
-#define ICE_AQ_VSI_Q_OPT_TC_OVR_S	0
-#define ICE_AQ_VSI_Q_OPT_TC_OVR_M	(0x1F << ICE_AQ_VSI_Q_OPT_TC_OVR_S)
-#define ICE_AQ_VSI_Q_OPT_PROF_TC_OVR	BIT(7)
+#define ICE_AQ_VSI_Q_OPT_TC_OVR_S		0
+#define ICE_AQ_VSI_Q_OPT_TC_OVR_M		(0x1F << ICE_AQ_VSI_Q_OPT_TC_OVR_S)
+#define ICE_AQ_VSI_Q_OPT_PROF_TC_OVR		BIT(7)
 	u8 q_opt_flags;
-#define ICE_AQ_VSI_Q_OPT_PE_FLTR_EN	BIT(0)
+#define ICE_AQ_VSI_Q_OPT_PE_FLTR_EN		BIT(0)
 	u8 q_opt_reserved[3];
 	/* outer up section */
 	__le32 outer_up_table; /* same structure and defines as ingress tbl */
@@ -452,27 +457,27 @@ struct ice_aqc_vsi_props {
 	__le16 sect_10_reserved;
 	/* flow director section */
 	__le16 fd_options;
-#define ICE_AQ_VSI_FD_ENABLE		BIT(0)
-#define ICE_AQ_VSI_FD_TX_AUTO_ENABLE	BIT(1)
-#define ICE_AQ_VSI_FD_PROG_ENABLE	BIT(3)
+#define ICE_AQ_VSI_FD_ENABLE			BIT(0)
+#define ICE_AQ_VSI_FD_TX_AUTO_ENABLE		BIT(1)
+#define ICE_AQ_VSI_FD_PROG_ENABLE		BIT(3)
 	__le16 max_fd_fltr_dedicated;
 	__le16 max_fd_fltr_shared;
 	__le16 fd_def_q;
-#define ICE_AQ_VSI_FD_DEF_Q_S		0
-#define ICE_AQ_VSI_FD_DEF_Q_M		(0x7FF << ICE_AQ_VSI_FD_DEF_Q_S)
-#define ICE_AQ_VSI_FD_DEF_GRP_S	12
-#define ICE_AQ_VSI_FD_DEF_GRP_M	(0x7 << ICE_AQ_VSI_FD_DEF_GRP_S)
+#define ICE_AQ_VSI_FD_DEF_Q_S			0
+#define ICE_AQ_VSI_FD_DEF_Q_M			(0x7FF << ICE_AQ_VSI_FD_DEF_Q_S)
+#define ICE_AQ_VSI_FD_DEF_GRP_S			12
+#define ICE_AQ_VSI_FD_DEF_GRP_M			(0x7 << ICE_AQ_VSI_FD_DEF_GRP_S)
 	__le16 fd_report_opt;
-#define ICE_AQ_VSI_FD_REPORT_Q_S	0
-#define ICE_AQ_VSI_FD_REPORT_Q_M	(0x7FF << ICE_AQ_VSI_FD_REPORT_Q_S)
-#define ICE_AQ_VSI_FD_DEF_PRIORITY_S	12
-#define ICE_AQ_VSI_FD_DEF_PRIORITY_M	(0x7 << ICE_AQ_VSI_FD_DEF_PRIORITY_S)
-#define ICE_AQ_VSI_FD_DEF_DROP		BIT(15)
+#define ICE_AQ_VSI_FD_REPORT_Q_S		0
+#define ICE_AQ_VSI_FD_REPORT_Q_M		(0x7FF << ICE_AQ_VSI_FD_REPORT_Q_S)
+#define ICE_AQ_VSI_FD_DEF_PRIORITY_S		12
+#define ICE_AQ_VSI_FD_DEF_PRIORITY_M		(0x7 << ICE_AQ_VSI_FD_DEF_PRIORITY_S)
+#define ICE_AQ_VSI_FD_DEF_DROP			BIT(15)
 	/* PASID section */
 	__le32 pasid_id;
-#define ICE_AQ_VSI_PASID_ID_S		0
-#define ICE_AQ_VSI_PASID_ID_M		(0xFFFFF << ICE_AQ_VSI_PASID_ID_S)
-#define ICE_AQ_VSI_PASID_ID_VALID	BIT(31)
+#define ICE_AQ_VSI_PASID_ID_S			0
+#define ICE_AQ_VSI_PASID_ID_M			(0xFFFFF << ICE_AQ_VSI_PASID_ID_S)
+#define ICE_AQ_VSI_PASID_ID_VALID		BIT(31)
 	u8 reserved[24];
 };
 
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 08539c966b18..d6a1c10fa2b6 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -853,13 +853,13 @@ static void ice_set_dflt_vsi_ctx(struct ice_vsi_ctx *ctxt)
 	ctxt->info.sw_flags = ICE_AQ_VSI_SW_FLAG_SRC_PRUNE;
 	/* Traffic from VSI can be sent to LAN */
 	ctxt->info.sw_flags2 = ICE_AQ_VSI_SW_FLAG_LAN_ENA;
-	/* By default bits 3 and 4 in vlan_flags are 0's which results in legacy
+	/* By default bits 3 and 4 in inner_vlan_flags are 0's which results in legacy
 	 * behavior (show VLAN, DEI, and UP) in descriptor. Also, allow all
 	 * packets untagged/tagged.
 	 */
-	ctxt->info.vlan_flags = ((ICE_AQ_VSI_VLAN_MODE_ALL &
-				  ICE_AQ_VSI_VLAN_MODE_M) >>
-				 ICE_AQ_VSI_VLAN_MODE_S);
+	ctxt->info.inner_vlan_flags = ((ICE_AQ_VSI_INNER_VLAN_TX_MODE_ALL &
+				  ICE_AQ_VSI_INNER_VLAN_TX_MODE_M) >>
+				 ICE_AQ_VSI_INNER_VLAN_TX_MODE_S);
 	/* Have 1:1 UP mapping for both ingress/egress tables */
 	table |= ICE_UP_TABLE_TRANSLATE(0, 0);
 	table |= ICE_UP_TABLE_TRANSLATE(1, 1);
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 8ec36bd87a48..9b85498067b9 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -4066,8 +4066,8 @@ static void ice_set_safe_mode_vlan_cfg(struct ice_pf *pf)
 	ctxt->info.sw_flags2 &= ~ICE_AQ_VSI_SW_FLAG_RX_VLAN_PRUNE_ENA;
 
 	/* allow all VLANs on Tx and don't strip on Rx */
-	ctxt->info.vlan_flags = ICE_AQ_VSI_VLAN_MODE_ALL |
-		ICE_AQ_VSI_VLAN_EMOD_NOTHING;
+	ctxt->info.inner_vlan_flags = ICE_AQ_VSI_INNER_VLAN_TX_MODE_ALL |
+		ICE_AQ_VSI_INNER_VLAN_EMODE_NOTHING;
 
 	status = ice_update_vsi(hw, vsi->idx, ctxt, NULL);
 	if (status) {
@@ -4076,7 +4076,7 @@ static void ice_set_safe_mode_vlan_cfg(struct ice_pf *pf)
 	} else {
 		vsi->info.sec_flags = ctxt->info.sec_flags;
 		vsi->info.sw_flags2 = ctxt->info.sw_flags2;
-		vsi->info.vlan_flags = ctxt->info.vlan_flags;
+		vsi->info.inner_vlan_flags = ctxt->info.inner_vlan_flags;
 	}
 
 	kfree(ctxt);
diff --git a/drivers/net/ethernet/intel/ice/ice_vsi_vlan_lib.c b/drivers/net/ethernet/intel/ice/ice_vsi_vlan_lib.c
index 6b7feab0b2a1..0b130505b68a 100644
--- a/drivers/net/ethernet/intel/ice/ice_vsi_vlan_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_vsi_vlan_lib.c
@@ -100,14 +100,14 @@ static int ice_vsi_manage_vlan_insertion(struct ice_vsi *vsi)
 		return -ENOMEM;
 
 	/* Here we are configuring the VSI to let the driver add VLAN tags by
-	 * setting vlan_flags to ICE_AQ_VSI_VLAN_MODE_ALL. The actual VLAN tag
+	 * setting inner_vlan_flags to ICE_AQ_VSI_INNER_VLAN_TX_MODE_ALL. The actual VLAN tag
 	 * insertion happens in the Tx hot path, in ice_tx_map.
 	 */
-	ctxt->info.vlan_flags = ICE_AQ_VSI_VLAN_MODE_ALL;
+	ctxt->info.inner_vlan_flags = ICE_AQ_VSI_INNER_VLAN_TX_MODE_ALL;
 
 	/* Preserve existing VLAN strip setting */
-	ctxt->info.vlan_flags |= (vsi->info.vlan_flags &
-				  ICE_AQ_VSI_VLAN_EMOD_M);
+	ctxt->info.inner_vlan_flags |= (vsi->info.inner_vlan_flags &
+					ICE_AQ_VSI_INNER_VLAN_EMODE_M);
 
 	ctxt->info.valid_sections = cpu_to_le16(ICE_AQ_VSI_PROP_VLAN_VALID);
 
@@ -118,7 +118,7 @@ static int ice_vsi_manage_vlan_insertion(struct ice_vsi *vsi)
 		goto out;
 	}
 
-	vsi->info.vlan_flags = ctxt->info.vlan_flags;
+	vsi->info.inner_vlan_flags = ctxt->info.inner_vlan_flags;
 out:
 	kfree(ctxt);
 	return err;
@@ -138,7 +138,7 @@ static int ice_vsi_manage_vlan_stripping(struct ice_vsi *vsi, bool ena)
 	/* do not allow modifying VLAN stripping when a port VLAN is configured
 	 * on this VSI
 	 */
-	if (vsi->info.pvid)
+	if (vsi->info.port_based_inner_vlan)
 		return 0;
 
 	ctxt = kzalloc(sizeof(*ctxt), GFP_KERNEL);
@@ -151,13 +151,13 @@ static int ice_vsi_manage_vlan_stripping(struct ice_vsi *vsi, bool ena)
 	 */
 	if (ena)
 		/* Strip VLAN tag from Rx packet and put it in the desc */
-		ctxt->info.vlan_flags = ICE_AQ_VSI_VLAN_EMOD_STR_BOTH;
+		ctxt->info.inner_vlan_flags = ICE_AQ_VSI_INNER_VLAN_EMODE_STR_BOTH;
 	else
 		/* Disable stripping. Leave tag in packet */
-		ctxt->info.vlan_flags = ICE_AQ_VSI_VLAN_EMOD_NOTHING;
+		ctxt->info.inner_vlan_flags = ICE_AQ_VSI_INNER_VLAN_EMODE_NOTHING;
 
 	/* Allow all packets untagged/tagged */
-	ctxt->info.vlan_flags |= ICE_AQ_VSI_VLAN_MODE_ALL;
+	ctxt->info.inner_vlan_flags |= ICE_AQ_VSI_INNER_VLAN_TX_MODE_ALL;
 
 	ctxt->info.valid_sections = cpu_to_le16(ICE_AQ_VSI_PROP_VLAN_VALID);
 
@@ -168,13 +168,13 @@ static int ice_vsi_manage_vlan_stripping(struct ice_vsi *vsi, bool ena)
 		goto out;
 	}
 
-	vsi->info.vlan_flags = ctxt->info.vlan_flags;
+	vsi->info.inner_vlan_flags = ctxt->info.inner_vlan_flags;
 out:
 	kfree(ctxt);
 	return err;
 }
 
-int ice_vsi_ena_stripping(struct ice_vsi *vsi, const u16 tpid)
+int ice_vsi_ena_inner_stripping(struct ice_vsi *vsi, const u16 tpid)
 {
 	if (tpid != ETH_P_8021Q) {
 		print_invalid_tpid(vsi, tpid);
@@ -184,12 +184,12 @@ int ice_vsi_ena_stripping(struct ice_vsi *vsi, const u16 tpid)
 	return ice_vsi_manage_vlan_stripping(vsi, true);
 }
 
-int ice_vsi_dis_stripping(struct ice_vsi *vsi)
+int ice_vsi_dis_inner_stripping(struct ice_vsi *vsi)
 {
 	return ice_vsi_manage_vlan_stripping(vsi, false);
 }
 
-int ice_vsi_ena_insertion(struct ice_vsi *vsi, const u16 tpid)
+int ice_vsi_ena_inner_insertion(struct ice_vsi *vsi, const u16 tpid)
 {
 	if (tpid != ETH_P_8021Q) {
 		print_invalid_tpid(vsi, tpid);
@@ -199,18 +199,17 @@ int ice_vsi_ena_insertion(struct ice_vsi *vsi, const u16 tpid)
 	return ice_vsi_manage_vlan_insertion(vsi);
 }
 
-int ice_vsi_dis_insertion(struct ice_vsi *vsi)
+int ice_vsi_dis_inner_insertion(struct ice_vsi *vsi)
 {
 	return ice_vsi_manage_vlan_insertion(vsi);
 }
 
 /**
- * ice_vsi_manage_pvid - Enable or disable port VLAN for VSI
+ * __ice_vsi_set_inner_port_vlan - set port VLAN VSI context settings to enable a port VLAN
  * @vsi: the VSI to update
  * @pvid_info: VLAN ID and QoS used to set the PVID VSI context field
- * @enable: true for enable PVID false for disable
  */
-static int ice_vsi_manage_pvid(struct ice_vsi *vsi, u16 pvid_info, bool enable)
+static int __ice_vsi_set_inner_port_vlan(struct ice_vsi *vsi, u16 pvid_info)
 {
 	struct ice_hw *hw = &vsi->back->hw;
 	struct ice_aqc_vsi_props *info;
@@ -223,18 +222,12 @@ static int ice_vsi_manage_pvid(struct ice_vsi *vsi, u16 pvid_info, bool enable)
 
 	ctxt->info = vsi->info;
 	info = &ctxt->info;
-	if (enable) {
-		info->vlan_flags = ICE_AQ_VSI_VLAN_MODE_UNTAGGED |
-			ICE_AQ_VSI_PVLAN_INSERT_PVID |
-			ICE_AQ_VSI_VLAN_EMOD_STR;
-		info->sw_flags2 |= ICE_AQ_VSI_SW_FLAG_RX_VLAN_PRUNE_ENA;
-	} else {
-		info->vlan_flags = ICE_AQ_VSI_VLAN_EMOD_NOTHING |
-			ICE_AQ_VSI_VLAN_MODE_ALL;
-		info->sw_flags2 &= ~ICE_AQ_VSI_SW_FLAG_RX_VLAN_PRUNE_ENA;
-	}
+	info->inner_vlan_flags = ICE_AQ_VSI_INNER_VLAN_TX_MODE_ACCEPTUNTAGGED |
+		ICE_AQ_VSI_INNER_VLAN_INSERT_PVID |
+		ICE_AQ_VSI_INNER_VLAN_EMODE_STR;
+	info->sw_flags2 |= ICE_AQ_VSI_SW_FLAG_RX_VLAN_PRUNE_ENA;
 
-	info->pvid = cpu_to_le16(pvid_info);
+	info->port_based_inner_vlan = cpu_to_le16(pvid_info);
 	info->valid_sections = cpu_to_le16(ICE_AQ_VSI_PROP_VLAN_VALID |
 					   ICE_AQ_VSI_PROP_SW_VALID);
 
@@ -245,15 +238,15 @@ static int ice_vsi_manage_pvid(struct ice_vsi *vsi, u16 pvid_info, bool enable)
 		goto out;
 	}
 
-	vsi->info.vlan_flags = info->vlan_flags;
+	vsi->info.inner_vlan_flags = info->inner_vlan_flags;
 	vsi->info.sw_flags2 = info->sw_flags2;
-	vsi->info.pvid = info->pvid;
+	vsi->info.port_based_inner_vlan = info->port_based_inner_vlan;
 out:
 	kfree(ctxt);
 	return ret;
 }
 
-int ice_vsi_set_port_vlan(struct ice_vsi *vsi, struct ice_vlan *vlan)
+int ice_vsi_set_inner_port_vlan(struct ice_vsi *vsi, struct ice_vlan *vlan)
 {
 	u16 port_vlan_info;
 
@@ -265,7 +258,7 @@ int ice_vsi_set_port_vlan(struct ice_vsi *vsi, struct ice_vlan *vlan)
 
 	port_vlan_info = vlan->vid | (vlan->prio << VLAN_PRIO_SHIFT);
 
-	return ice_vsi_manage_pvid(vsi, port_vlan_info, true);
+	return __ice_vsi_set_inner_port_vlan(vsi, port_vlan_info);
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/ice/ice_vsi_vlan_lib.h b/drivers/net/ethernet/intel/ice/ice_vsi_vlan_lib.h
index 1bdbf585db7d..a10671133e36 100644
--- a/drivers/net/ethernet/intel/ice/ice_vsi_vlan_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_vsi_vlan_lib.h
@@ -12,11 +12,11 @@ struct ice_vsi;
 int ice_vsi_add_vlan(struct ice_vsi *vsi, struct ice_vlan *vlan);
 int ice_vsi_del_vlan(struct ice_vsi *vsi, struct ice_vlan *vlan);
 
-int ice_vsi_ena_stripping(struct ice_vsi *vsi, u16 tpid);
-int ice_vsi_dis_stripping(struct ice_vsi *vsi);
-int ice_vsi_ena_insertion(struct ice_vsi *vsi, u16 tpid);
-int ice_vsi_dis_insertion(struct ice_vsi *vsi);
-int ice_vsi_set_port_vlan(struct ice_vsi *vsi, struct ice_vlan *vlan);
+int ice_vsi_ena_inner_stripping(struct ice_vsi *vsi, u16 tpid);
+int ice_vsi_dis_inner_stripping(struct ice_vsi *vsi);
+int ice_vsi_ena_inner_insertion(struct ice_vsi *vsi, u16 tpid);
+int ice_vsi_dis_inner_insertion(struct ice_vsi *vsi);
+int ice_vsi_set_inner_port_vlan(struct ice_vsi *vsi, struct ice_vlan *vlan);
 
 int ice_vsi_ena_rx_vlan_filtering(struct ice_vsi *vsi);
 int ice_vsi_dis_rx_vlan_filtering(struct ice_vsi *vsi);
diff --git a/drivers/net/ethernet/intel/ice/ice_vsi_vlan_ops.c b/drivers/net/ethernet/intel/ice/ice_vsi_vlan_ops.c
index 3bab6c025856..6a6b49581c70 100644
--- a/drivers/net/ethernet/intel/ice/ice_vsi_vlan_ops.c
+++ b/drivers/net/ethernet/intel/ice/ice_vsi_vlan_ops.c
@@ -8,13 +8,13 @@ void ice_vsi_init_vlan_ops(struct ice_vsi *vsi)
 {
 	vsi->vlan_ops.add_vlan = ice_vsi_add_vlan;
 	vsi->vlan_ops.del_vlan = ice_vsi_del_vlan;
-	vsi->vlan_ops.ena_stripping = ice_vsi_ena_stripping;
-	vsi->vlan_ops.dis_stripping = ice_vsi_dis_stripping;
-	vsi->vlan_ops.ena_insertion = ice_vsi_ena_insertion;
-	vsi->vlan_ops.dis_insertion = ice_vsi_dis_insertion;
+	vsi->vlan_ops.ena_stripping = ice_vsi_ena_inner_stripping;
+	vsi->vlan_ops.dis_stripping = ice_vsi_dis_inner_stripping;
+	vsi->vlan_ops.ena_insertion = ice_vsi_ena_inner_insertion;
+	vsi->vlan_ops.dis_insertion = ice_vsi_dis_inner_insertion;
 	vsi->vlan_ops.ena_rx_filtering = ice_vsi_ena_rx_vlan_filtering;
 	vsi->vlan_ops.dis_rx_filtering = ice_vsi_dis_rx_vlan_filtering;
 	vsi->vlan_ops.ena_tx_filtering = ice_vsi_ena_tx_vlan_filtering;
 	vsi->vlan_ops.dis_tx_filtering = ice_vsi_dis_tx_vlan_filtering;
-	vsi->vlan_ops.set_port_vlan = ice_vsi_set_port_vlan;
+	vsi->vlan_ops.set_port_vlan = ice_vsi_set_inner_port_vlan;
 }
-- 
2.31.1

