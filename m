Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BEAF599099
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 00:36:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345633AbiHRWeN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 18:34:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344851AbiHRWeM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 18:34:12 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF3BBB69D2
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 15:34:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660862050; x=1692398050;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xkNkOEMJxkW5OimQLdkX/xTPzM6hNP25W8e5lM4uWGQ=;
  b=ZIK7309iHTzO5pDLXuu4hSt6OcYKgBuJDT5xNt4+nyOp5im7DJsLmiRa
   D4Y7w/slJ3/P6K9YLW6rq2IzoEg2A7pK27RA2rSm1Fu+QKadtwjRLdcVs
   XFULp+sCkW/xZjI0uDOCWZWtk1VYq7nUoZ0ezNacZ4dzPY1Ps7LB6QUIo
   HDibr2SHTOKNjMii5dYvWnGU7cI5IPtUlpKODs5EvBDE/fcX9z1YNL8fD
   YHKsnFaLadRYkiYutJwCFzoMwUXwYA9fLWY0ALILjddn/wVCJEMdHV9gy
   sSA/Zvxd2Q5ErJ9hao/rjroVoerz0Q33vjhnm/lNGtKrjU/pVorm1N5Ak
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10443"; a="379178803"
X-IronPort-AV: E=Sophos;i="5.93,247,1654585200"; 
   d="scan'208";a="379178803"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2022 15:34:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,247,1654585200"; 
   d="scan'208";a="558718713"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga003.jf.intel.com with ESMTP; 18 Aug 2022 15:34:09 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Jeff Daly <jeffd@silicom-usa.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, Dave Switzer <david.switzer@intel.com>
Subject: [PATCH net-next 2/2] ixgbe: Manual AN-37 for troublesome link partners for X550 SFI
Date:   Thu, 18 Aug 2022 15:34:02 -0700
Message-Id: <20220818223402.1294091-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220818223402.1294091-1-anthony.l.nguyen@intel.com>
References: <20220818223402.1294091-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeff Daly <jeffd@silicom-usa.com>

Some (Juniper MX5) SFP link partners exhibit a disinclination to
autonegotiate with X550 configured in SFI mode.  This patch enables
a manual AN-37 restart to work around the problem.

Signed-off-by: Jeff Daly <jeffd@silicom-usa.com>
Tested-by: Dave Switzer <david.switzer@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_type.h |  3 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_x550.c | 56 ++++++++++++++++++-
 2 files changed, 56 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_type.h b/drivers/net/ethernet/intel/ixgbe/ixgbe_type.h
index 7f7ea468ffa9..2b00db92b08f 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_type.h
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_type.h
@@ -3712,7 +3712,9 @@ struct ixgbe_info {
 #define IXGBE_KRM_LINK_S1(P)		((P) ? 0x8200 : 0x4200)
 #define IXGBE_KRM_LINK_CTRL_1(P)	((P) ? 0x820C : 0x420C)
 #define IXGBE_KRM_AN_CNTL_1(P)		((P) ? 0x822C : 0x422C)
+#define IXGBE_KRM_AN_CNTL_4(P)		((P) ? 0x8238 : 0x4238)
 #define IXGBE_KRM_AN_CNTL_8(P)		((P) ? 0x8248 : 0x4248)
+#define IXGBE_KRM_PCS_KX_AN(P)		((P) ? 0x9918 : 0x5918)
 #define IXGBE_KRM_SGMII_CTRL(P)		((P) ? 0x82A0 : 0x42A0)
 #define IXGBE_KRM_LP_BASE_PAGE_HIGH(P)	((P) ? 0x836C : 0x436C)
 #define IXGBE_KRM_DSP_TXFFE_STATE_4(P)	((P) ? 0x8634 : 0x4634)
@@ -3722,6 +3724,7 @@ struct ixgbe_info {
 #define IXGBE_KRM_PMD_FLX_MASK_ST20(P)	((P) ? 0x9054 : 0x5054)
 #define IXGBE_KRM_TX_COEFF_CTRL_1(P)	((P) ? 0x9520 : 0x5520)
 #define IXGBE_KRM_RX_ANA_CTL(P)		((P) ? 0x9A00 : 0x5A00)
+#define IXGBE_KRM_FLX_TMRS_CTRL_ST31(P)	((P) ? 0x9180 : 0x5180)
 
 #define IXGBE_KRM_PMD_FLX_MASK_ST20_SFI_10G_DA		~(0x3 << 20)
 #define IXGBE_KRM_PMD_FLX_MASK_ST20_SFI_10G_SR		BIT(20)
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_x550.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_x550.c
index 35c2b9b8bd19..aa4bf6c9a2f7 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_x550.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_x550.c
@@ -1721,9 +1721,59 @@ static s32 ixgbe_setup_sfi_x550a(struct ixgbe_hw *hw, ixgbe_link_speed *speed)
 		return IXGBE_ERR_LINK_SETUP;
 	}
 
-	status = mac->ops.write_iosf_sb_reg(hw,
-				IXGBE_KRM_PMD_FLX_MASK_ST20(hw->bus.lan_id),
-				IXGBE_SB_IOSF_TARGET_KR_PHY, reg_val);
+	(void)mac->ops.write_iosf_sb_reg(hw,
+			IXGBE_KRM_PMD_FLX_MASK_ST20(hw->bus.lan_id),
+			IXGBE_SB_IOSF_TARGET_KR_PHY, reg_val);
+
+	/* change mode enforcement rules to hybrid */
+	(void)mac->ops.read_iosf_sb_reg(hw,
+			IXGBE_KRM_FLX_TMRS_CTRL_ST31(hw->bus.lan_id),
+			IXGBE_SB_IOSF_TARGET_KR_PHY, &reg_val);
+	reg_val |= 0x0400;
+
+	(void)mac->ops.write_iosf_sb_reg(hw,
+			IXGBE_KRM_FLX_TMRS_CTRL_ST31(hw->bus.lan_id),
+			IXGBE_SB_IOSF_TARGET_KR_PHY, reg_val);
+
+	/* manually control the config */
+	(void)mac->ops.read_iosf_sb_reg(hw,
+			IXGBE_KRM_LINK_CTRL_1(hw->bus.lan_id),
+			IXGBE_SB_IOSF_TARGET_KR_PHY, &reg_val);
+	reg_val |= 0x20002240;
+
+	(void)mac->ops.write_iosf_sb_reg(hw,
+			IXGBE_KRM_LINK_CTRL_1(hw->bus.lan_id),
+			IXGBE_SB_IOSF_TARGET_KR_PHY, reg_val);
+
+	/* move the AN base page values */
+	(void)mac->ops.read_iosf_sb_reg(hw,
+			IXGBE_KRM_PCS_KX_AN(hw->bus.lan_id),
+			IXGBE_SB_IOSF_TARGET_KR_PHY, &reg_val);
+	reg_val |= 0x1;
+
+	(void)mac->ops.write_iosf_sb_reg(hw,
+			IXGBE_KRM_PCS_KX_AN(hw->bus.lan_id),
+			IXGBE_SB_IOSF_TARGET_KR_PHY, reg_val);
+
+	/* set the AN37 over CB mode */
+	(void)mac->ops.read_iosf_sb_reg(hw,
+			IXGBE_KRM_AN_CNTL_4(hw->bus.lan_id),
+			IXGBE_SB_IOSF_TARGET_KR_PHY, &reg_val);
+	reg_val |= 0x20000000;
+
+	(void)mac->ops.write_iosf_sb_reg(hw,
+			IXGBE_KRM_AN_CNTL_4(hw->bus.lan_id),
+			IXGBE_SB_IOSF_TARGET_KR_PHY, reg_val);
+
+	/* restart AN manually */
+	(void)mac->ops.read_iosf_sb_reg(hw,
+			IXGBE_KRM_LINK_CTRL_1(hw->bus.lan_id),
+			IXGBE_SB_IOSF_TARGET_KR_PHY, &reg_val);
+	reg_val |= IXGBE_KRM_LINK_CTRL_1_TETH_AN_RESTART;
+
+	(void)mac->ops.write_iosf_sb_reg(hw,
+			IXGBE_KRM_LINK_CTRL_1(hw->bus.lan_id),
+			IXGBE_SB_IOSF_TARGET_KR_PHY, reg_val);
 
 	/* Toggle port SW reset by AN reset. */
 	status = ixgbe_restart_an_internal_phy_x550em(hw);
-- 
2.35.1

