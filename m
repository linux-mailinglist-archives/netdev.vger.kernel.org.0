Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16AF73B3554
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 20:11:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232516AbhFXSOK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 14:14:10 -0400
Received: from mga07.intel.com ([134.134.136.100]:28682 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231878AbhFXSOJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Jun 2021 14:14:09 -0400
IronPort-SDR: Wz7UkOM7t7IqUUOFAW2t4Nzv2en8NmUmxpwT+r3TH3FV2nhp6zeCz9nEnQygj+OkzeUUyjX/Oc
 5gXmFSR2XkFQ==
X-IronPort-AV: E=McAfee;i="6200,9189,10025"; a="271382694"
X-IronPort-AV: E=Sophos;i="5.83,296,1616482800"; 
   d="scan'208";a="271382694"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2021 11:11:47 -0700
IronPort-SDR: cv9wBuCVmlFKa90tHI1AI3hytN9VXlq4PCvcSeayby6miBdDzNEvqeTmcTa+zTXRVimAHZgkZV
 UqE8Vp/RJk6Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,296,1616482800"; 
   d="scan'208";a="487866627"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga001.jf.intel.com with ESMTP; 24 Jun 2021 11:11:47 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Mateusz Palczewski <mateusz.palczewski@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        sassmann@redhat.com,
        Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
        Karen Sornek <karen.sornek@intel.com>,
        Dawid Lukwinski <dawid.lukwinski@intel.com>,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net 2/4] i40e: Fix autoneg disabling for non-10GBaseT links
Date:   Thu, 24 Jun 2021 11:14:32 -0700
Message-Id: <20210624181434.751511-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210624181434.751511-1-anthony.l.nguyen@intel.com>
References: <20210624181434.751511-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mateusz Palczewski <mateusz.palczewski@intel.com>

Disabling autonegotiation was allowed only for 10GBaseT PHY.
The condition was changed to check if link media type is BaseT.

Fixes: 3ce12ee9d8f9 ("i40e: Fix order of checks when enabling/disabling autoneg in ethtool")
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Reviewed-by: Karen Sornek <karen.sornek@intel.com>
Signed-off-by: Dawid Lukwinski <dawid.lukwinski@intel.com>
Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
index ccd5b9486ea9..3e822bad4851 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
@@ -1262,8 +1262,7 @@ static int i40e_set_link_ksettings(struct net_device *netdev,
 			if (ethtool_link_ksettings_test_link_mode(&safe_ks,
 								  supported,
 								  Autoneg) &&
-			    hw->phy.link_info.phy_type !=
-			    I40E_PHY_TYPE_10GBASE_T) {
+			    hw->phy.media_type != I40E_MEDIA_TYPE_BASET) {
 				netdev_info(netdev, "Autoneg cannot be disabled on this phy\n");
 				err = -EINVAL;
 				goto done;
-- 
2.26.2

