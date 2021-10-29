Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E748440454
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 22:47:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231561AbhJ2UuH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 16:50:07 -0400
Received: from mga06.intel.com ([134.134.136.31]:9536 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230397AbhJ2Utt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Oct 2021 16:49:49 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10152"; a="291587516"
X-IronPort-AV: E=Sophos;i="5.87,193,1631602800"; 
   d="scan'208";a="291587516"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2021 13:47:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,193,1631602800"; 
   d="scan'208";a="448483295"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga003.jf.intel.com with ESMTP; 29 Oct 2021 13:47:17 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Marcin Szycik <marcin.szycik@linux.intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Sandeep Penigalapati <sandeep.penigalapati@intel.com>
Subject: [PATCH net-next 3/7] ice: Hide bus-info in ethtool for PRs in switchdev mode
Date:   Fri, 29 Oct 2021 13:45:36 -0700
Message-Id: <20211029204540.3390007-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211029204540.3390007-1-anthony.l.nguyen@intel.com>
References: <20211029204540.3390007-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marcin Szycik <marcin.szycik@linux.intel.com>

Disable showing bus-info information for port representors in switchdev
mode. This fixes a bug that caused displaying wrong netdev descriptions in
lshw tool - one port representor displayed PF branding string, and in turn
one PF displayed a "generic" description. The bug occurs when many devices
show the same bus-info in ethtool, which was the case in switchdev mode (PF
and its port representors displayed the same bus-info). The bug occurs only
if a port representor netdev appears before PF netdev in /proc/net/dev.

In the examples below:
ens6fX is PF
ens6fXvY is VF
ethX is port representor
One irrelevant column was removed from output

Before:
$ sudo lshw -c net -businfo
Bus info          Device      Description
=========================================
pci@0000:02:00.0  eth102       Ethernet Controller E810-XXV for SFP
pci@0000:02:00.1  ens6f1       Ethernet Controller E810-XXV for SFP
pci@0000:02:01.0  ens6f0v0     Ethernet Adaptive Virtual Function
pci@0000:02:01.1  ens6f0v1     Ethernet Adaptive Virtual Function
pci@0000:02:01.2  ens6f0v2     Ethernet Adaptive Virtual Function
pci@0000:02:00.0  ens6f0       Ethernet interface

Notice that eth102 and ens6f0 have the same bus-info and their descriptions
are swapped.

After:
$ sudo lshw -c net -businfo
Bus info          Device      Description
=========================================
pci@0000:02:00.0  ens6f0      Ethernet Controller E810-XXV for SFP
pci@0000:02:00.1  ens6f1      Ethernet Controller E810-XXV for SFP
pci@0000:02:01.0  ens6f0v0    Ethernet Adaptive Virtual Function
pci@0000:02:01.1  ens6f0v1    Ethernet Adaptive Virtual Function
pci@0000:02:01.2  ens6f0v2    Ethernet Adaptive Virtual Function

Fixes: 7aae80cef7ba ("ice: add port representor ethtool ops and stats")
Signed-off-by: Marcin Szycik <marcin.szycik@linux.intel.com>
Tested-by: Sandeep Penigalapati <sandeep.penigalapati@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_ethtool.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index cfe96a127ed4..572519e402f4 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -189,18 +189,19 @@ __ice_get_drvinfo(struct net_device *netdev, struct ethtool_drvinfo *drvinfo,
 	snprintf(drvinfo->fw_version, sizeof(drvinfo->fw_version),
 		 "%x.%02x 0x%x %d.%d.%d", nvm->major, nvm->minor,
 		 nvm->eetrack, orom->major, orom->build, orom->patch);
-
-	strscpy(drvinfo->bus_info, pci_name(pf->pdev),
-		sizeof(drvinfo->bus_info));
 }
 
 static void
 ice_get_drvinfo(struct net_device *netdev, struct ethtool_drvinfo *drvinfo)
 {
 	struct ice_netdev_priv *np = netdev_priv(netdev);
+	struct ice_pf *pf = np->vsi->back;
 
 	__ice_get_drvinfo(netdev, drvinfo, np->vsi);
 
+	strscpy(drvinfo->bus_info, pci_name(pf->pdev),
+		sizeof(drvinfo->bus_info));
+
 	drvinfo->n_priv_flags = ICE_PRIV_FLAG_ARRAY_SIZE;
 }
 
-- 
2.31.1

