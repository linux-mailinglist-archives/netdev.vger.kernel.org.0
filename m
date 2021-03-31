Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D453E350A88
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 01:08:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232827AbhCaXHs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 19:07:48 -0400
Received: from mga14.intel.com ([192.55.52.115]:62991 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230309AbhCaXHZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Mar 2021 19:07:25 -0400
IronPort-SDR: HiYM6OcA5CBW5qmQb2g906xq20USIE2iyff/rNTDMDdGm/QFDkscDwb3v6mlrcXtrECdxknr3J
 O28hIVazyLcw==
X-IronPort-AV: E=McAfee;i="6000,8403,9940"; a="191587980"
X-IronPort-AV: E=Sophos;i="5.81,295,1610438400"; 
   d="scan'208";a="191587980"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2021 16:07:24 -0700
IronPort-SDR: RtUOYJaHzsS2yzB/Osab3eGPYPIZC1kvgs+CxzaOvOxqvB0d+MXa5i6gz6zqnS/FL0P6pO0fj/
 Hqn4JRoDRMbA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,295,1610438400"; 
   d="scan'208";a="610680117"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga005.fm.intel.com with ESMTP; 31 Mar 2021 16:07:23 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        anthony.l.nguyen@intel.com,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net-next 07/15] ice: Check for bail out condition early
Date:   Wed, 31 Mar 2021 16:08:50 -0700
Message-Id: <20210331230858.782492-8-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210331230858.782492-1-anthony.l.nguyen@intel.com>
References: <20210331230858.782492-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>

Check for bail out condition before calling ice_aq_sff_eeprom

Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_ethtool.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index 4f738425fb44..109dd6962b1d 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -3926,14 +3926,14 @@ ice_get_module_eeprom(struct net_device *netdev,
 	u8 value = 0;
 	u8 page = 0;
 
-	status = ice_aq_sff_eeprom(hw, 0, addr, offset, page, 0,
-				   &value, 1, 0, NULL);
-	if (status)
-		return -EIO;
-
 	if (!ee || !ee->len || !data)
 		return -EINVAL;
 
+	status = ice_aq_sff_eeprom(hw, 0, addr, offset, page, 0, &value, 1, 0,
+				   NULL);
+	if (status)
+		return -EIO;
+
 	if (value == ICE_MODULE_TYPE_SFP)
 		is_sfp = true;
 
-- 
2.26.2

