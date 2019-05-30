Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E7CD3023D
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 20:50:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726748AbfE3Sul (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 14:50:41 -0400
Received: from mga04.intel.com ([192.55.52.120]:30432 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726693AbfE3Suk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 May 2019 14:50:40 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 May 2019 11:50:36 -0700
X-ExtLoop1: 1
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga007.fm.intel.com with ESMTP; 30 May 2019 11:50:36 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 10/15] ice: Align to updated AQ command formats
Date:   Thu, 30 May 2019 11:50:40 -0700
Message-Id: <20190530185045.3886-11-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530185045.3886-1-jeffrey.t.kirsher@intel.com>
References: <20190530185045.3886-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>

The current specification has updates to the command formats for
manage MAC opcodes (opcodes 0x0107 and 0x0108) and get PHY caps
(opcode 0x0600). Update the code to reflect this.

Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_adminq_cmd.h | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
index b233f6ca8f0f..b1efe55e4d7e 100644
--- a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
+++ b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
@@ -120,11 +120,9 @@ struct ice_aqc_manage_mac_read {
 #define ICE_AQC_MAN_MAC_WOL_ADDR_VALID		BIT(7)
 #define ICE_AQC_MAN_MAC_READ_S			4
 #define ICE_AQC_MAN_MAC_READ_M			(0xF << ICE_AQC_MAN_MAC_READ_S)
-	u8 lport_num;
-	u8 lport_num_valid;
-#define ICE_AQC_MAN_MAC_PORT_NUM_IS_VALID	BIT(0)
+	u8 rsvd[2];
 	u8 num_addr; /* Used in response */
-	u8 reserved[3];
+	u8 rsvd1[3];
 	__le32 addr_high;
 	__le32 addr_low;
 };
@@ -140,7 +138,7 @@ struct ice_aqc_manage_mac_read_resp {
 
 /* Manage MAC address, write command - direct (0x0108) */
 struct ice_aqc_manage_mac_write {
-	u8 port_num;
+	u8 rsvd;
 	u8 flags;
 #define ICE_AQC_MAN_MAC_WR_MC_MAG_EN		BIT(0)
 #define ICE_AQC_MAN_MAC_WR_WOL_LAA_PFR_KEEP	BIT(1)
@@ -934,6 +932,7 @@ struct ice_aqc_get_phy_caps_data {
 #define ICE_AQC_PHY_EEE_EN_40GBASE_KR4			BIT(6)
 	__le16 eeer_value;
 	u8 phy_id_oui[4]; /* PHY/Module ID connected on the port */
+	u8 phy_fw_ver[8];
 	u8 link_fec_options;
 #define ICE_AQC_PHY_FEC_10G_KR_40G_KR4_EN		BIT(0)
 #define ICE_AQC_PHY_FEC_10G_KR_40G_KR4_REQ		BIT(1)
@@ -943,6 +942,7 @@ struct ice_aqc_get_phy_caps_data {
 #define ICE_AQC_PHY_FEC_25G_RS_CLAUSE91_EN		BIT(6)
 #define ICE_AQC_PHY_FEC_25G_KR_CLAUSE74_EN		BIT(7)
 #define ICE_AQC_PHY_FEC_MASK				ICE_M(0xdf, 0)
+	u8 rsvd1;	/* Byte 35 reserved */
 	u8 extended_compliance_code;
 #define ICE_MODULE_TYPE_TOTAL_BYTE			3
 	u8 module_type[ICE_MODULE_TYPE_TOTAL_BYTE];
@@ -957,13 +957,14 @@ struct ice_aqc_get_phy_caps_data {
 #define ICE_AQC_MOD_TYPE_BYTE2_SFP_PLUS			0xA0
 #define ICE_AQC_MOD_TYPE_BYTE2_QSFP_PLUS		0x86
 	u8 qualified_module_count;
+	u8 rsvd2[7];	/* Bytes 47:41 reserved */
 #define ICE_AQC_QUAL_MOD_COUNT_MAX			16
 	struct {
 		u8 v_oui[3];
-		u8 rsvd1;
+		u8 rsvd3;
 		u8 v_part[16];
 		__le32 v_rev;
-		__le64 rsvd8;
+		__le64 rsvd4;
 	} qual_modules[ICE_AQC_QUAL_MOD_COUNT_MAX];
 };
 
-- 
2.21.0

