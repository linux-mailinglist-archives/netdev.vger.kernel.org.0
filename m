Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DDE1235342
	for <lists+netdev@lfdr.de>; Sat,  1 Aug 2020 18:18:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727788AbgHAQSX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Aug 2020 12:18:23 -0400
Received: from mga05.intel.com ([192.55.52.43]:19604 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727058AbgHAQSL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 1 Aug 2020 12:18:11 -0400
IronPort-SDR: HNH9uZBfR9gP6GuOM3jblYGn1F4Y8yCKgKFonkbVpPy+Ds3Yq++e9RxXxRaIB0W661TEu4UVN/
 5Z+k6NV8+BPw==
X-IronPort-AV: E=McAfee;i="6000,8403,9699"; a="236810859"
X-IronPort-AV: E=Sophos;i="5.75,422,1589266800"; 
   d="scan'208";a="236810859"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Aug 2020 09:18:08 -0700
IronPort-SDR: y8R5LHuCkH5I39dISojVWklHvY44XOM/bSKCbP6bzNH4Gmp0wW1+i+lIyrlEh/DhxqDQtbqLIz
 ka2lGHwigGwg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,422,1589266800"; 
   d="scan'208";a="331457722"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga007.jf.intel.com with ESMTP; 01 Aug 2020 09:18:07 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Nick Nunley <nicholas.d.nunley@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com, anthony.l.nguyen@intel.com,
        Andrew Bowers <andrewx.bowers@intel.com>
Subject: [net-next 11/14] ice: Disable VLAN pruning in promiscuous mode
Date:   Sat,  1 Aug 2020 09:17:59 -0700
Message-Id: <20200801161802.867645-12-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200801161802.867645-1-anthony.l.nguyen@intel.com>
References: <20200801161802.867645-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nick Nunley <nicholas.d.nunley@intel.com>

Disable VLAN pruning when entering promiscuous mode, and re-enable it
when exiting.

Without this VLAN-over-bridge topologies created on the device won't be
functional unless rx-vlan-filter is explicitly disabled with ethtool.

Signed-off-by: Nick Nunley <nicholas.d.nunley@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_lib.c  | 7 +++++++
 drivers/net/ethernet/intel/ice/ice_main.c | 3 +++
 2 files changed, 10 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 84202c814c3b..f2682776f8c8 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -2017,6 +2017,13 @@ int ice_cfg_vlan_pruning(struct ice_vsi *vsi, bool ena, bool vlan_promisc)
 	if (!vsi)
 		return -EINVAL;
 
+	/* Don't enable VLAN pruning if the netdev is currently in promiscuous
+	 * mode. VLAN pruning will be enabled when the interface exits
+	 * promiscuous mode if any VLAN filters are active.
+	 */
+	if (vsi->netdev && vsi->netdev->flags & IFF_PROMISC && ena)
+		return 0;
+
 	pf = vsi->back;
 	ctxt = kzalloc(sizeof(*ctxt), GFP_KERNEL);
 	if (!ctxt)
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 22bbd84eef64..22e3d32463f1 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -369,6 +369,7 @@ static int ice_vsi_sync_fltr(struct ice_vsi *vsi)
 						~IFF_PROMISC;
 					goto out_promisc;
 				}
+				ice_cfg_vlan_pruning(vsi, false, false);
 			}
 		} else {
 			/* Clear Rx filter to remove traffic from wire */
@@ -381,6 +382,8 @@ static int ice_vsi_sync_fltr(struct ice_vsi *vsi)
 						IFF_PROMISC;
 					goto out_promisc;
 				}
+				if (vsi->num_vlan > 1)
+					ice_cfg_vlan_pruning(vsi, true, false);
 			}
 		}
 	}
-- 
2.26.2

