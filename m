Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 116F53E4A8B
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 19:10:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233842AbhHIRLI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 13:11:08 -0400
Received: from mga01.intel.com ([192.55.52.88]:27774 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233555AbhHIRLB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Aug 2021 13:11:01 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10070"; a="236736373"
X-IronPort-AV: E=Sophos;i="5.84,308,1620716400"; 
   d="scan'208";a="236736373"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Aug 2021 10:10:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,308,1620716400"; 
   d="scan'208";a="570519348"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga004.jf.intel.com with ESMTP; 09 Aug 2021 10:10:39 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Brett Creeley <brett.creeley@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, Liang Li <liali@redhat.com>,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net 3/4] ice: don't remove netdev->dev_addr from uc sync list
Date:   Mon,  9 Aug 2021 10:14:01 -0700
Message-Id: <20210809171402.17838-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210809171402.17838-1-anthony.l.nguyen@intel.com>
References: <20210809171402.17838-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brett Creeley <brett.creeley@intel.com>

In some circumstances, such as with bridging, it's possible that the
stack will add the device's own MAC address to its unicast address list.

If, later, the stack deletes this address, the driver will receive a
request to remove this address.

The driver stores its current MAC address as part of the VSI MAC filter
list instead of separately. So, this causes a problem when the device's
MAC address is deleted unexpectedly, which results in traffic failure in
some cases.

The following configuration steps will reproduce the previously
mentioned problem:

> ip link set eth0 up
> ip link add dev br0 type bridge
> ip link set br0 up
> ip addr flush dev eth0
> ip link set eth0 master br0
> echo 1 > /sys/class/net/br0/bridge/vlan_filtering
> modprobe -r veth
> modprobe -r bridge
> ip addr add 192.168.1.100/24 dev eth0

The following ping command fails due to the netdev->dev_addr being
deleted when removing the bridge module.
> ping <link partner>

Fix this by making sure to not delete the netdev->dev_addr during MAC
address sync. After fixing this issue it was noticed that the
netdev_warn() in .set_mac was overly verbose, so make it at
netdev_dbg().

Also, there is a possibility of a race condition between .set_mac and
.set_rx_mode. Fix this by calling netif_addr_lock_bh() and
netif_addr_unlock_bh() on the device's netdev when the netdev->dev_addr
is going to be updated in .set_mac.

Fixes: e94d44786693 ("ice: Implement filter sync, NDO operations and bump version")
Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Tested-by: Liang Li <liali@redhat.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index a9506041eb42..fe2ded775f25 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -191,6 +191,14 @@ static int ice_add_mac_to_unsync_list(struct net_device *netdev, const u8 *addr)
 	struct ice_netdev_priv *np = netdev_priv(netdev);
 	struct ice_vsi *vsi = np->vsi;
 
+	/* Under some circumstances, we might receive a request to delete our
+	 * own device address from our uc list. Because we store the device
+	 * address in the VSI's MAC filter list, we need to ignore such
+	 * requests and not delete our device address from this list.
+	 */
+	if (ether_addr_equal(addr, netdev->dev_addr))
+		return 0;
+
 	if (ice_fltr_add_mac_to_list(vsi, &vsi->tmp_unsync_list, addr,
 				     ICE_FWD_TO_VSI))
 		return -EINVAL;
@@ -5124,7 +5132,7 @@ static int ice_set_mac_address(struct net_device *netdev, void *pi)
 		return -EADDRNOTAVAIL;
 
 	if (ether_addr_equal(netdev->dev_addr, mac)) {
-		netdev_warn(netdev, "already using mac %pM\n", mac);
+		netdev_dbg(netdev, "already using mac %pM\n", mac);
 		return 0;
 	}
 
@@ -5135,6 +5143,7 @@ static int ice_set_mac_address(struct net_device *netdev, void *pi)
 		return -EBUSY;
 	}
 
+	netif_addr_lock_bh(netdev);
 	/* Clean up old MAC filter. Not an error if old filter doesn't exist */
 	status = ice_fltr_remove_mac(vsi, netdev->dev_addr, ICE_FWD_TO_VSI);
 	if (status && status != ICE_ERR_DOES_NOT_EXIST) {
@@ -5144,30 +5153,28 @@ static int ice_set_mac_address(struct net_device *netdev, void *pi)
 
 	/* Add filter for new MAC. If filter exists, return success */
 	status = ice_fltr_add_mac(vsi, mac, ICE_FWD_TO_VSI);
-	if (status == ICE_ERR_ALREADY_EXISTS) {
+	if (status == ICE_ERR_ALREADY_EXISTS)
 		/* Although this MAC filter is already present in hardware it's
 		 * possible in some cases (e.g. bonding) that dev_addr was
 		 * modified outside of the driver and needs to be restored back
 		 * to this value.
 		 */
-		memcpy(netdev->dev_addr, mac, netdev->addr_len);
 		netdev_dbg(netdev, "filter for MAC %pM already exists\n", mac);
-		return 0;
-	}
-
-	/* error if the new filter addition failed */
-	if (status)
+	else if (status)
+		/* error if the new filter addition failed */
 		err = -EADDRNOTAVAIL;
 
 err_update_filters:
 	if (err) {
 		netdev_err(netdev, "can't set MAC %pM. filter update failed\n",
 			   mac);
+		netif_addr_unlock_bh(netdev);
 		return err;
 	}
 
 	/* change the netdev's MAC address */
 	memcpy(netdev->dev_addr, mac, netdev->addr_len);
+	netif_addr_unlock_bh(netdev);
 	netdev_dbg(vsi->netdev, "updated MAC address to %pM\n",
 		   netdev->dev_addr);
 
-- 
2.26.2

