Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5590304DB3
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 01:48:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387807AbhAZXN6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 18:13:58 -0500
Received: from mga14.intel.com ([192.55.52.115]:62468 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728368AbhAZWOw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Jan 2021 17:14:52 -0500
IronPort-SDR: wJVvaIqTFc1/f7CMSUU5hLdKUfnI76bX0c7ZmpdkFwBl0KyiORLctj6hFJDnWo0jS8TuNHg370
 cLW8EUbzokhA==
X-IronPort-AV: E=McAfee;i="6000,8403,9876"; a="179198684"
X-IronPort-AV: E=Sophos;i="5.79,377,1602572400"; 
   d="scan'208";a="179198684"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2021 14:10:02 -0800
IronPort-SDR: Z+erQJWFo85FkxhJn91C8sRUEzJboxiJSkLKQ8sUR//rZjn6OxN+bFCoAaxijqEsU4mx0CMLJG
 cvgoTjOds6eg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,377,1602572400"; 
   d="scan'208";a="472908336"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga001.fm.intel.com with ESMTP; 26 Jan 2021 14:10:02 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Corinna Vinschen <vinschen@redhat.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com
Subject: [PATCH net v2 7/7] igc: fix link speed advertising
Date:   Tue, 26 Jan 2021 14:10:35 -0800
Message-Id: <20210126221035.658124-8-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210126221035.658124-1-anthony.l.nguyen@intel.com>
References: <20210126221035.658124-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Corinna Vinschen <vinschen@redhat.com>

Link speed advertising in igc has two problems:

- When setting the advertisement via ethtool, the link speed is converted
  to the legacy 32 bit representation for the intel PHY code.
  This inadvertently drops ETHTOOL_LINK_MODE_2500baseT_Full_BIT (being
  beyond bit 31).  As a result, any call to `ethtool -s ...' drops the
  2500Mbit/s link speed from the PHY settings.  Only reloading the driver
  alleviates that problem.

  Fix this by converting the ETHTOOL_LINK_MODE_2500baseT_Full_BIT to the
  Intel PHY ADVERTISE_2500_FULL bit explicitly.

- Rather than checking the actual PHY setting, the .get_link_ksettings
  function always fills link_modes.advertising with all link speeds
  the device is capable of.

  Fix this by checking the PHY autoneg_advertised settings and report
  only the actually advertised speeds up to ethtool.

Fixes: 8c5ad0dae93c ("igc: Add ethtool support")
Signed-off-by: Corinna Vinschen <vinschen@redhat.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_ethtool.c | 24 +++++++++++++++-----
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_ethtool.c b/drivers/net/ethernet/intel/igc/igc_ethtool.c
index 61d331ce38cd..831f2f09de5f 100644
--- a/drivers/net/ethernet/intel/igc/igc_ethtool.c
+++ b/drivers/net/ethernet/intel/igc/igc_ethtool.c
@@ -1675,12 +1675,18 @@ static int igc_ethtool_get_link_ksettings(struct net_device *netdev,
 	cmd->base.phy_address = hw->phy.addr;
 
 	/* advertising link modes */
-	ethtool_link_ksettings_add_link_mode(cmd, advertising, 10baseT_Half);
-	ethtool_link_ksettings_add_link_mode(cmd, advertising, 10baseT_Full);
-	ethtool_link_ksettings_add_link_mode(cmd, advertising, 100baseT_Half);
-	ethtool_link_ksettings_add_link_mode(cmd, advertising, 100baseT_Full);
-	ethtool_link_ksettings_add_link_mode(cmd, advertising, 1000baseT_Full);
-	ethtool_link_ksettings_add_link_mode(cmd, advertising, 2500baseT_Full);
+	if (hw->phy.autoneg_advertised & ADVERTISE_10_HALF)
+		ethtool_link_ksettings_add_link_mode(cmd, advertising, 10baseT_Half);
+	if (hw->phy.autoneg_advertised & ADVERTISE_10_FULL)
+		ethtool_link_ksettings_add_link_mode(cmd, advertising, 10baseT_Full);
+	if (hw->phy.autoneg_advertised & ADVERTISE_100_HALF)
+		ethtool_link_ksettings_add_link_mode(cmd, advertising, 100baseT_Half);
+	if (hw->phy.autoneg_advertised & ADVERTISE_100_FULL)
+		ethtool_link_ksettings_add_link_mode(cmd, advertising, 100baseT_Full);
+	if (hw->phy.autoneg_advertised & ADVERTISE_1000_FULL)
+		ethtool_link_ksettings_add_link_mode(cmd, advertising, 1000baseT_Full);
+	if (hw->phy.autoneg_advertised & ADVERTISE_2500_FULL)
+		ethtool_link_ksettings_add_link_mode(cmd, advertising, 2500baseT_Full);
 
 	/* set autoneg settings */
 	if (hw->mac.autoneg == 1) {
@@ -1792,6 +1798,12 @@ igc_ethtool_set_link_ksettings(struct net_device *netdev,
 
 	ethtool_convert_link_mode_to_legacy_u32(&advertising,
 						cmd->link_modes.advertising);
+	/* Converting to legacy u32 drops ETHTOOL_LINK_MODE_2500baseT_Full_BIT.
+	 * We have to check this and convert it to ADVERTISE_2500_FULL
+	 * (aka ETHTOOL_LINK_MODE_2500baseX_Full_BIT) explicitly.
+	 */
+	if (ethtool_link_ksettings_test_link_mode(cmd, advertising, 2500baseT_Full))
+		advertising |= ADVERTISE_2500_FULL;
 
 	if (cmd->base.autoneg == AUTONEG_ENABLE) {
 		hw->mac.autoneg = 1;
-- 
2.26.2

