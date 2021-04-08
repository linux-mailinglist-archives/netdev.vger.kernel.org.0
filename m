Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1D1535895E
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 18:12:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232295AbhDHQMM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 12:12:12 -0400
Received: from mga04.intel.com ([192.55.52.120]:26217 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232123AbhDHQLz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Apr 2021 12:11:55 -0400
IronPort-SDR: i2n4Sl4J1gahttYSH+ZTSCdKpVYgk2e08GXuHw/KDC0+l5OFNpLxsOcKtjBMb4Ga95Q8EF76gs
 j2cNxVX+Yj8g==
X-IronPort-AV: E=McAfee;i="6000,8403,9948"; a="191424036"
X-IronPort-AV: E=Sophos;i="5.82,206,1613462400"; 
   d="scan'208";a="191424036"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2021 09:11:43 -0700
IronPort-SDR: 8w+qyE5DDQRQGZ/PMfl3Ms64cx9UpHVWhWZjw1r7s7FBDk7BU7IpMmtcOeerxMsYfgk1y+meXC
 IIQor0PDhJ4Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,206,1613462400"; 
   d="scan'208";a="415841453"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga008.fm.intel.com with ESMTP; 08 Apr 2021 09:11:42 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Brett Creeley <brett.creeley@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net-next 14/15] ice: Remove unnecessary checks in add/kill_vid ndo ops
Date:   Thu,  8 Apr 2021 09:13:20 -0700
Message-Id: <20210408161321.3218024-15-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210408161321.3218024-1-anthony.l.nguyen@intel.com>
References: <20210408161321.3218024-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brett Creeley <brett.creeley@intel.com>

Currently the driver is doing two unnecessary checks. First both ops are
checking if the VLAN ID passed in is less than VLAN_N_VID and second
both ops are checking to see if a port VLAN is configured on the VSI.

The first check is already handled by the 8021q driver so this is an
unnecessary check. The second check is unnecessary because the PF VSI is
never put into a port VLAN.

Remove these checks.

Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 3c73ee4a6c0c..5ab35c1d6121 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -3078,15 +3078,6 @@ ice_vlan_rx_add_vid(struct net_device *netdev, __always_unused __be16 proto,
 	struct ice_vsi *vsi = np->vsi;
 	int ret;
 
-	if (vid >= VLAN_N_VID) {
-		netdev_err(netdev, "VLAN id requested %d is out of range %d\n",
-			   vid, VLAN_N_VID);
-		return -EINVAL;
-	}
-
-	if (vsi->info.pvid)
-		return -EINVAL;
-
 	/* VLAN 0 is added by default during load/reset */
 	if (!vid)
 		return 0;
@@ -3124,9 +3115,6 @@ ice_vlan_rx_kill_vid(struct net_device *netdev, __always_unused __be16 proto,
 	struct ice_vsi *vsi = np->vsi;
 	int ret;
 
-	if (vsi->info.pvid)
-		return -EINVAL;
-
 	/* don't allow removal of VLAN 0 */
 	if (!vid)
 		return 0;
-- 
2.26.2

