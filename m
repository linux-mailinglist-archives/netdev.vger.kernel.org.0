Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83DFC3768F4
	for <lists+netdev@lfdr.de>; Fri,  7 May 2021 18:40:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238368AbhEGQlI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 12:41:08 -0400
Received: from mga04.intel.com ([192.55.52.120]:29745 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238328AbhEGQk5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 May 2021 12:40:57 -0400
IronPort-SDR: 18DPTRMUik6JGf0h7U2N8FUyugOKdv/XG5KpYk58MShqnrjqfsBhCUa0r5yKGC8UI49GxSqTbM
 ZaRBYUoZjuFg==
X-IronPort-AV: E=McAfee;i="6200,9189,9977"; a="196748701"
X-IronPort-AV: E=Sophos;i="5.82,281,1613462400"; 
   d="scan'208";a="196748701"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2021 09:39:55 -0700
IronPort-SDR: lZNer1XnlBqdeWza9zB3zRykWGvDrj7IeY9tGQUyeGQO5PdWTN1hN8l9oZ4Nsf9TTdlTev+2vR
 slbYjNhmNnBQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,281,1613462400"; 
   d="scan'208";a="620267980"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga006.fm.intel.com with ESMTP; 07 May 2021 09:39:54 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Mateusz Palczewski <mateusz.palczewski@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        anthony.l.nguyen@intel.com,
        Dawid Lukwinski <dawid.lukwinski@intel.com>,
        Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
        Dave Switzer <david.switzer@intel.com>
Subject: [PATCH net 4/5] i40e: Fix PHY type identifiers for 2.5G and 5G adapters
Date:   Fri,  7 May 2021 09:41:50 -0700
Message-Id: <20210507164151.2878147-5-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210507164151.2878147-1-anthony.l.nguyen@intel.com>
References: <20210507164151.2878147-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mateusz Palczewski <mateusz.palczewski@intel.com>

Unlike other supported adapters, 2.5G and 5G use different
PHY type identifiers for reading/writing PHY settings
and for reading link status. This commit introduces
separate PHY identifiers for these two operation types.

Fixes: 2e45d3f4677a ("i40e: Add support for X710 B/P & SFP+ cards")
Signed-off-by: Dawid Lukwinski <dawid.lukwinski@intel.com>
Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Tested-by: Dave Switzer <david.switzer@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_adminq_cmd.h | 6 ++++--
 drivers/net/ethernet/intel/i40e/i40e_common.c     | 4 ++--
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c    | 4 ++--
 drivers/net/ethernet/intel/i40e/i40e_type.h       | 7 ++-----
 4 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_adminq_cmd.h b/drivers/net/ethernet/intel/i40e/i40e_adminq_cmd.h
index ce626eace692..140b677f114d 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_adminq_cmd.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_adminq_cmd.h
@@ -1566,8 +1566,10 @@ enum i40e_aq_phy_type {
 	I40E_PHY_TYPE_25GBASE_LR		= 0x22,
 	I40E_PHY_TYPE_25GBASE_AOC		= 0x23,
 	I40E_PHY_TYPE_25GBASE_ACC		= 0x24,
-	I40E_PHY_TYPE_2_5GBASE_T		= 0x30,
-	I40E_PHY_TYPE_5GBASE_T			= 0x31,
+	I40E_PHY_TYPE_2_5GBASE_T		= 0x26,
+	I40E_PHY_TYPE_5GBASE_T			= 0x27,
+	I40E_PHY_TYPE_2_5GBASE_T_LINK_STATUS	= 0x30,
+	I40E_PHY_TYPE_5GBASE_T_LINK_STATUS	= 0x31,
 	I40E_PHY_TYPE_MAX,
 	I40E_PHY_TYPE_NOT_SUPPORTED_HIGH_TEMP	= 0xFD,
 	I40E_PHY_TYPE_EMPTY			= 0xFE,
diff --git a/drivers/net/ethernet/intel/i40e/i40e_common.c b/drivers/net/ethernet/intel/i40e/i40e_common.c
index 41b813fe07a5..67cb0b47416a 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_common.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_common.c
@@ -1154,8 +1154,8 @@ static enum i40e_media_type i40e_get_media_type(struct i40e_hw *hw)
 		break;
 	case I40E_PHY_TYPE_100BASE_TX:
 	case I40E_PHY_TYPE_1000BASE_T:
-	case I40E_PHY_TYPE_2_5GBASE_T:
-	case I40E_PHY_TYPE_5GBASE_T:
+	case I40E_PHY_TYPE_2_5GBASE_T_LINK_STATUS:
+	case I40E_PHY_TYPE_5GBASE_T_LINK_STATUS:
 	case I40E_PHY_TYPE_10GBASE_T:
 		media = I40E_MEDIA_TYPE_BASET;
 		break;
diff --git a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
index 53416787fb7b..bd527eab002b 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
@@ -841,8 +841,8 @@ static void i40e_get_settings_link_up(struct i40e_hw *hw,
 							     10000baseT_Full);
 		break;
 	case I40E_PHY_TYPE_10GBASE_T:
-	case I40E_PHY_TYPE_5GBASE_T:
-	case I40E_PHY_TYPE_2_5GBASE_T:
+	case I40E_PHY_TYPE_5GBASE_T_LINK_STATUS:
+	case I40E_PHY_TYPE_2_5GBASE_T_LINK_STATUS:
 	case I40E_PHY_TYPE_1000BASE_T:
 	case I40E_PHY_TYPE_100BASE_TX:
 		ethtool_link_ksettings_add_link_mode(ks, supported, Autoneg);
diff --git a/drivers/net/ethernet/intel/i40e/i40e_type.h b/drivers/net/ethernet/intel/i40e/i40e_type.h
index 5c10faaca790..c81109a63e90 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_type.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_type.h
@@ -239,11 +239,8 @@ struct i40e_phy_info {
 #define I40E_CAP_PHY_TYPE_25GBASE_ACC BIT_ULL(I40E_PHY_TYPE_25GBASE_ACC + \
 					     I40E_PHY_TYPE_OFFSET)
 /* Offset for 2.5G/5G PHY Types value to bit number conversion */
-#define I40E_PHY_TYPE_OFFSET2 (-10)
-#define I40E_CAP_PHY_TYPE_2_5GBASE_T BIT_ULL(I40E_PHY_TYPE_2_5GBASE_T + \
-					     I40E_PHY_TYPE_OFFSET2)
-#define I40E_CAP_PHY_TYPE_5GBASE_T BIT_ULL(I40E_PHY_TYPE_5GBASE_T + \
-					     I40E_PHY_TYPE_OFFSET2)
+#define I40E_CAP_PHY_TYPE_2_5GBASE_T BIT_ULL(I40E_PHY_TYPE_2_5GBASE_T)
+#define I40E_CAP_PHY_TYPE_5GBASE_T BIT_ULL(I40E_PHY_TYPE_5GBASE_T)
 #define I40E_HW_CAP_MAX_GPIO			30
 /* Capabilities of a PF or a VF or the whole device */
 struct i40e_hw_capabilities {
-- 
2.26.2

