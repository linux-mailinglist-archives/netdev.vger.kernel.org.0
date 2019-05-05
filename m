Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFAC013C91
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 03:19:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727492AbfEEBTb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 21:19:31 -0400
Received: from mga18.intel.com ([134.134.136.126]:33074 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726443AbfEEBTM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 4 May 2019 21:19:12 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 May 2019 18:14:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,431,1549958400"; 
   d="scan'208";a="297102541"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga004.jf.intel.com with ESMTP; 04 May 2019 18:14:10 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Grzegorz Siwik <grzegorz.siwik@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 01/12] i40e: VF's promiscuous attribute is not kept
Date:   Sat,  4 May 2019 18:13:58 -0700
Message-Id: <20190505011409.6771-2-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190505011409.6771-1-jeffrey.t.kirsher@intel.com>
References: <20190505011409.6771-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Grzegorz Siwik <grzegorz.siwik@intel.com>

This patch fixes a bug where the promiscuous mode was not being
kept when the VF switched to a new VLAN.
Now we are config two times a promiscuous mode when we switch VLAN.
Without this change when we change VF VLAN we still receive
all the packets from previous VLAN and only unicast from new VLAN.

Signed-off-by: Grzegorz Siwik <grzegorz.siwik@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 .../ethernet/intel/i40e/i40e_virtchnl_pf.c    | 23 +++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
index 8a6fb9c03955..00345bbf68ec 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -4016,6 +4016,7 @@ int i40e_ndo_set_vf_port_vlan(struct net_device *netdev, int vf_id,
 {
 	u16 vlanprio = vlan_id | (qos << I40E_VLAN_PRIORITY_SHIFT);
 	struct i40e_netdev_priv *np = netdev_priv(netdev);
+	bool allmulti = false, alluni = false;
 	struct i40e_pf *pf = np->vsi->back;
 	struct i40e_vsi *vsi;
 	struct i40e_vf *vf;
@@ -4100,6 +4101,15 @@ int i40e_ndo_set_vf_port_vlan(struct net_device *netdev, int vf_id,
 	}
 
 	spin_unlock_bh(&vsi->mac_filter_hash_lock);
+
+	/* disable promisc modes in case they were enabled */
+	ret = i40e_config_vf_promiscuous_mode(vf, vf->lan_vsi_id,
+					      allmulti, alluni);
+	if (ret) {
+		dev_err(&pf->pdev->dev, "Unable to config VF promiscuous mode\n");
+		goto error_pvid;
+	}
+
 	if (vlan_id || qos)
 		ret = i40e_vsi_add_pvid(vsi, vlanprio);
 	else
@@ -4126,6 +4136,12 @@ int i40e_ndo_set_vf_port_vlan(struct net_device *netdev, int vf_id,
 
 	spin_unlock_bh(&vsi->mac_filter_hash_lock);
 
+	if (test_bit(I40E_VF_STATE_UC_PROMISC, &vf->vf_states))
+		alluni = true;
+
+	if (test_bit(I40E_VF_STATE_MC_PROMISC, &vf->vf_states))
+		allmulti = true;
+
 	/* Schedule the worker thread to take care of applying changes */
 	i40e_service_event_schedule(vsi->back);
 
@@ -4138,6 +4154,13 @@ int i40e_ndo_set_vf_port_vlan(struct net_device *netdev, int vf_id,
 	 * default LAN MAC address.
 	 */
 	vf->port_vlan_id = le16_to_cpu(vsi->info.pvid);
+
+	ret = i40e_config_vf_promiscuous_mode(vf, vsi->id, allmulti, alluni);
+	if (ret) {
+		dev_err(&pf->pdev->dev, "Unable to config vf promiscuous mode\n");
+		goto error_pvid;
+	}
+
 	ret = 0;
 
 error_pvid:
-- 
2.20.1

