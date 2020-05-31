Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E52831E97A1
	for <lists+netdev@lfdr.de>; Sun, 31 May 2020 14:37:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728105AbgEaMgZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 May 2020 08:36:25 -0400
Received: from mga12.intel.com ([192.55.52.136]:12466 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726020AbgEaMgX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 31 May 2020 08:36:23 -0400
IronPort-SDR: m3iaghqAYX671uuJsy06Ikd59udb6q8V6I45j++56TXKNCnRPnPFJK5nv/JHB2DUm3xIi5f8YD
 yICjFtNjdSHQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2020 05:36:21 -0700
IronPort-SDR: z8MSmYWwq0n+EP9y1n2hGtfYqbUQjN47goIGbL7PIcksiGiVOVO1Mdj5ZngjXpaOjATLvkgFGK
 vMDdKHBjwpkQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,456,1583222400"; 
   d="scan'208";a="303345417"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga002.fm.intel.com with ESMTP; 31 May 2020 05:36:21 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Brett Creeley <brett.creeley@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 01/14] ice: allow host to clear administratively set VF MAC
Date:   Sun, 31 May 2020 05:36:06 -0700
Message-Id: <20200531123619.2887469-2-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200531123619.2887469-1-jeffrey.t.kirsher@intel.com>
References: <20200531123619.2887469-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brett Creeley <brett.creeley@intel.com>

Currently a user is not allowed to clear a VF's administratively set MAC
on the PF. Fix this by allowing an all zero MAC address via "ip link set
${pf_eth} vf ${vf_id} mac 00:00:00:00:00:00".

An example use case for this would be issuing a "virsh shutdown"
command on a VM. The call to iproute mentioned above is part of this flow.
Without this change the driver incorrectly rejects clearing the VF's
administratively set MAC and prints unhelpful log messages.

Also, improve the comments surrounding this change.

Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  | 22 ++++++++++++-------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index a126e7c7663d..9550501f9279 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -3904,7 +3904,7 @@ int ice_set_vf_mac(struct net_device *netdev, int vf_id, u8 *mac)
 	if (ice_validate_vf_id(pf, vf_id))
 		return -EINVAL;
 
-	if (is_zero_ether_addr(mac) || is_multicast_ether_addr(mac)) {
+	if (is_multicast_ether_addr(mac)) {
 		netdev_err(netdev, "%pM not a valid unicast address\n", mac);
 		return -EINVAL;
 	}
@@ -3924,15 +3924,21 @@ int ice_set_vf_mac(struct net_device *netdev, int vf_id, u8 *mac)
 		return -EINVAL;
 	}
 
-	/* copy MAC into dflt_lan_addr and trigger a VF reset. The reset
-	 * flow will use the updated dflt_lan_addr and add a MAC filter
-	 * using ice_add_mac. Also set pf_set_mac to indicate that the PF has
-	 * set the MAC address for this VF.
+	/* VF is notified of its new MAC via the PF's response to the
+	 * VIRTCHNL_OP_GET_VF_RESOURCES message after the VF has been reset
 	 */
 	ether_addr_copy(vf->dflt_lan_addr.addr, mac);
-	vf->pf_set_mac = true;
-	netdev_info(netdev, "MAC on VF %d set to %pM. VF driver will be reinitialized\n",
-		    vf_id, mac);
+	if (is_zero_ether_addr(mac)) {
+		/* VF will send VIRTCHNL_OP_ADD_ETH_ADDR message with its MAC */
+		vf->pf_set_mac = false;
+		netdev_info(netdev, "Removing MAC on VF %d. VF driver will be reinitialized\n",
+			    vf->vf_id);
+	} else {
+		/* PF will add MAC rule for the VF */
+		vf->pf_set_mac = true;
+		netdev_info(netdev, "Setting MAC %pM on VF %d. VF driver will be reinitialized\n",
+			    mac, vf_id);
+	}
 
 	ice_vc_reset_vf(vf);
 	return 0;
-- 
2.26.2

