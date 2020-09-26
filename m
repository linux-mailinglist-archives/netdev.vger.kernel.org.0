Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FB5B2795BC
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 02:57:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729886AbgIZA5H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 20:57:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:47384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729858AbgIZA46 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Sep 2020 20:56:58 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5D5802371F;
        Sat, 26 Sep 2020 00:56:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601081817;
        bh=0XjUL6jXUVlpRQ2BUbGW9fdlUwsA7IVIESuUb9GD+UA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Uh6aUeJkEDO1kXD74tzwV8AelQoVeUs8q4NQ6i+9S3tjbTLr38hpwWWWUaCSr16/y
         6wdbI6cljJnwPI711IXz16DjM9xq92c9WzaVles0mT32OJBHQ/nvSMtam1L4E2DDTP
         AzIV27F1MrvZV0EWgBKUTOV/RzBP22Jhini4NkjU=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Jakub Kicinski <kuba@kernel.org>,
        Aaron Brown <aaron.f.brown@intel.com>
Subject: [PATCH net-next v2 05/10] i40e: convert to new udp_tunnel infrastructure
Date:   Fri, 25 Sep 2020 17:56:44 -0700
Message-Id: <20200926005649.3285089-6-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200926005649.3285089-1-kuba@kernel.org>
References: <20200926005649.3285089-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make use of the "shared port table" to convert i40e to the new
infra.

i40e did not have any reference tracking, locking is also dodgy
because rtnl gets released while talking to FW, so port may get
removed from the table while it's getting added etc.

On the good side i40e does not seem to be using the ports for
TX so we can remove the table from the driver state completely.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e.h      |   6 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c | 264 ++++----------------
 2 files changed, 51 insertions(+), 219 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e.h b/drivers/net/ethernet/intel/i40e/i40e.h
index ada0e93c38f0..537300e762f0 100644
--- a/drivers/net/ethernet/intel/i40e/i40e.h
+++ b/drivers/net/ethernet/intel/i40e/i40e.h
@@ -35,6 +35,7 @@
 #include <net/pkt_cls.h>
 #include <net/tc_act/tc_gact.h>
 #include <net/tc_act/tc_mirred.h>
+#include <net/udp_tunnel.h>
 #include <net/xdp_sock.h>
 #include "i40e_type.h"
 #include "i40e_prototype.h"
@@ -133,7 +134,6 @@ enum i40e_state_t {
 	__I40E_PORT_SUSPENDED,
 	__I40E_VF_DISABLE,
 	__I40E_MACVLAN_SYNC_PENDING,
-	__I40E_UDP_FILTER_SYNC_PENDING,
 	__I40E_TEMP_LINK_POLLING,
 	__I40E_CLIENT_SERVICE_REQUESTED,
 	__I40E_CLIENT_L2_CHANGE,
@@ -478,8 +478,8 @@ struct i40e_pf {
 	struct list_head l3_flex_pit_list;
 	struct list_head l4_flex_pit_list;
 
-	struct i40e_udp_port_config udp_ports[I40E_MAX_PF_UDP_OFFLOAD_PORTS];
-	u16 pending_udp_bitmap;
+	struct udp_tunnel_nic_shared udp_tunnel_shared;
+	struct udp_tunnel_nic_info udp_tunnel_nic;
 
 	struct hlist_head cloud_filter_list;
 	u16 num_cloud_filters;
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index cb366daa1ad7..70bd3f47e43a 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -10386,106 +10386,6 @@ static void i40e_handle_mdd_event(struct i40e_pf *pf)
 	i40e_flush(hw);
 }
 
-static const char *i40e_tunnel_name(u8 type)
-{
-	switch (type) {
-	case UDP_TUNNEL_TYPE_VXLAN:
-		return "vxlan";
-	case UDP_TUNNEL_TYPE_GENEVE:
-		return "geneve";
-	default:
-		return "unknown";
-	}
-}
-
-/**
- * i40e_sync_udp_filters - Trigger a sync event for existing UDP filters
- * @pf: board private structure
- **/
-static void i40e_sync_udp_filters(struct i40e_pf *pf)
-{
-	int i;
-
-	/* loop through and set pending bit for all active UDP filters */
-	for (i = 0; i < I40E_MAX_PF_UDP_OFFLOAD_PORTS; i++) {
-		if (pf->udp_ports[i].port)
-			pf->pending_udp_bitmap |= BIT_ULL(i);
-	}
-
-	set_bit(__I40E_UDP_FILTER_SYNC_PENDING, pf->state);
-}
-
-/**
- * i40e_sync_udp_filters_subtask - Sync the VSI filter list with HW
- * @pf: board private structure
- **/
-static void i40e_sync_udp_filters_subtask(struct i40e_pf *pf)
-{
-	struct i40e_hw *hw = &pf->hw;
-	u8 filter_index, type;
-	u16 port;
-	int i;
-
-	if (!test_and_clear_bit(__I40E_UDP_FILTER_SYNC_PENDING, pf->state))
-		return;
-
-	/* acquire RTNL to maintain state of flags and port requests */
-	rtnl_lock();
-
-	for (i = 0; i < I40E_MAX_PF_UDP_OFFLOAD_PORTS; i++) {
-		if (pf->pending_udp_bitmap & BIT_ULL(i)) {
-			struct i40e_udp_port_config *udp_port;
-			i40e_status ret = 0;
-
-			udp_port = &pf->udp_ports[i];
-			pf->pending_udp_bitmap &= ~BIT_ULL(i);
-
-			port = READ_ONCE(udp_port->port);
-			type = READ_ONCE(udp_port->type);
-			filter_index = READ_ONCE(udp_port->filter_index);
-
-			/* release RTNL while we wait on AQ command */
-			rtnl_unlock();
-
-			if (port)
-				ret = i40e_aq_add_udp_tunnel(hw, port,
-							     type,
-							     &filter_index,
-							     NULL);
-			else if (filter_index != I40E_UDP_PORT_INDEX_UNUSED)
-				ret = i40e_aq_del_udp_tunnel(hw, filter_index,
-							     NULL);
-
-			/* reacquire RTNL so we can update filter_index */
-			rtnl_lock();
-
-			if (ret) {
-				dev_info(&pf->pdev->dev,
-					 "%s %s port %d, index %d failed, err %s aq_err %s\n",
-					 i40e_tunnel_name(type),
-					 port ? "add" : "delete",
-					 port,
-					 filter_index,
-					 i40e_stat_str(&pf->hw, ret),
-					 i40e_aq_str(&pf->hw,
-						     pf->hw.aq.asq_last_status));
-				if (port) {
-					/* failed to add, just reset port,
-					 * drop pending bit for any deletion
-					 */
-					udp_port->port = 0;
-					pf->pending_udp_bitmap &= ~BIT_ULL(i);
-				}
-			} else if (port) {
-				/* record filter index on success */
-				udp_port->filter_index = filter_index;
-			}
-		}
-	}
-
-	rtnl_unlock();
-}
-
 /**
  * i40e_service_task - Run the driver's async subtasks
  * @work: pointer to work_struct containing our data
@@ -10525,7 +10425,6 @@ static void i40e_service_task(struct work_struct *work)
 								pf->vsi[pf->lan_vsi]);
 		}
 		i40e_sync_filters_subtask(pf);
-		i40e_sync_udp_filters_subtask(pf);
 	} else {
 		i40e_reset_subtask(pf);
 	}
@@ -12225,131 +12124,48 @@ static int i40e_set_features(struct net_device *netdev,
 	return 0;
 }
 
-/**
- * i40e_get_udp_port_idx - Lookup a possibly offloaded for Rx UDP port
- * @pf: board private structure
- * @port: The UDP port to look up
- *
- * Returns the index number or I40E_MAX_PF_UDP_OFFLOAD_PORTS if port not found
- **/
-static u8 i40e_get_udp_port_idx(struct i40e_pf *pf, u16 port)
-{
-	u8 i;
-
-	for (i = 0; i < I40E_MAX_PF_UDP_OFFLOAD_PORTS; i++) {
-		/* Do not report ports with pending deletions as
-		 * being available.
-		 */
-		if (!port && (pf->pending_udp_bitmap & BIT_ULL(i)))
-			continue;
-		if (pf->udp_ports[i].port == port)
-			return i;
-	}
-
-	return i;
-}
-
-/**
- * i40e_udp_tunnel_add - Get notifications about UDP tunnel ports that come up
- * @netdev: This physical port's netdev
- * @ti: Tunnel endpoint information
- **/
-static void i40e_udp_tunnel_add(struct net_device *netdev,
-				struct udp_tunnel_info *ti)
+static int i40e_udp_tunnel_set_port(struct net_device *netdev,
+				    unsigned int table, unsigned int idx,
+				    struct udp_tunnel_info *ti)
 {
 	struct i40e_netdev_priv *np = netdev_priv(netdev);
-	struct i40e_vsi *vsi = np->vsi;
-	struct i40e_pf *pf = vsi->back;
-	u16 port = ntohs(ti->port);
-	u8 next_idx;
-	u8 idx;
-
-	idx = i40e_get_udp_port_idx(pf, port);
-
-	/* Check if port already exists */
-	if (idx < I40E_MAX_PF_UDP_OFFLOAD_PORTS) {
-		netdev_info(netdev, "port %d already offloaded\n", port);
-		return;
-	}
-
-	/* Now check if there is space to add the new port */
-	next_idx = i40e_get_udp_port_idx(pf, 0);
+	struct i40e_hw *hw = &np->vsi->back->hw;
+	u8 type, filter_index;
+	i40e_status ret;
 
-	if (next_idx == I40E_MAX_PF_UDP_OFFLOAD_PORTS) {
-		netdev_info(netdev, "maximum number of offloaded UDP ports reached, not adding port %d\n",
-			    port);
-		return;
-	}
+	type = ti->type == UDP_TUNNEL_TYPE_VXLAN ? I40E_AQC_TUNNEL_TYPE_VXLAN :
+						   I40E_AQC_TUNNEL_TYPE_NGE;
 
-	switch (ti->type) {
-	case UDP_TUNNEL_TYPE_VXLAN:
-		pf->udp_ports[next_idx].type = I40E_AQC_TUNNEL_TYPE_VXLAN;
-		break;
-	case UDP_TUNNEL_TYPE_GENEVE:
-		if (!(pf->hw_features & I40E_HW_GENEVE_OFFLOAD_CAPABLE))
-			return;
-		pf->udp_ports[next_idx].type = I40E_AQC_TUNNEL_TYPE_NGE;
-		break;
-	default:
-		return;
+	ret = i40e_aq_add_udp_tunnel(hw, ntohs(ti->port), type, &filter_index,
+				     NULL);
+	if (ret) {
+		netdev_info(netdev, "add UDP port failed, err %s aq_err %s\n",
+			    i40e_stat_str(hw, ret),
+			    i40e_aq_str(hw, hw->aq.asq_last_status));
+		return -EIO;
 	}
 
-	/* New port: add it and mark its index in the bitmap */
-	pf->udp_ports[next_idx].port = port;
-	pf->udp_ports[next_idx].filter_index = I40E_UDP_PORT_INDEX_UNUSED;
-	pf->pending_udp_bitmap |= BIT_ULL(next_idx);
-	set_bit(__I40E_UDP_FILTER_SYNC_PENDING, pf->state);
+	udp_tunnel_nic_set_port_priv(netdev, table, idx, filter_index);
+	return 0;
 }
 
-/**
- * i40e_udp_tunnel_del - Get notifications about UDP tunnel ports that go away
- * @netdev: This physical port's netdev
- * @ti: Tunnel endpoint information
- **/
-static void i40e_udp_tunnel_del(struct net_device *netdev,
-				struct udp_tunnel_info *ti)
+static int i40e_udp_tunnel_unset_port(struct net_device *netdev,
+				      unsigned int table, unsigned int idx,
+				      struct udp_tunnel_info *ti)
 {
 	struct i40e_netdev_priv *np = netdev_priv(netdev);
-	struct i40e_vsi *vsi = np->vsi;
-	struct i40e_pf *pf = vsi->back;
-	u16 port = ntohs(ti->port);
-	u8 idx;
-
-	idx = i40e_get_udp_port_idx(pf, port);
-
-	/* Check if port already exists */
-	if (idx >= I40E_MAX_PF_UDP_OFFLOAD_PORTS)
-		goto not_found;
+	struct i40e_hw *hw = &np->vsi->back->hw;
+	i40e_status ret;
 
-	switch (ti->type) {
-	case UDP_TUNNEL_TYPE_VXLAN:
-		if (pf->udp_ports[idx].type != I40E_AQC_TUNNEL_TYPE_VXLAN)
-			goto not_found;
-		break;
-	case UDP_TUNNEL_TYPE_GENEVE:
-		if (pf->udp_ports[idx].type != I40E_AQC_TUNNEL_TYPE_NGE)
-			goto not_found;
-		break;
-	default:
-		goto not_found;
+	ret = i40e_aq_del_udp_tunnel(hw, ti->hw_priv, NULL);
+	if (ret) {
+		netdev_info(netdev, "delete UDP port failed, err %s aq_err %s\n",
+			    i40e_stat_str(hw, ret),
+			    i40e_aq_str(hw, hw->aq.asq_last_status));
+		return -EIO;
 	}
 
-	/* if port exists, set it to 0 (mark for deletion)
-	 * and make it pending
-	 */
-	pf->udp_ports[idx].port = 0;
-
-	/* Toggle pending bit instead of setting it. This way if we are
-	 * deleting a port that has yet to be added we just clear the pending
-	 * bit and don't have to worry about it.
-	 */
-	pf->pending_udp_bitmap ^= BIT_ULL(idx);
-	set_bit(__I40E_UDP_FILTER_SYNC_PENDING, pf->state);
-
-	return;
-not_found:
-	netdev_warn(netdev, "UDP port %d was not found, not deleting\n",
-		    port);
+	return 0;
 }
 
 static int i40e_get_phys_port_id(struct net_device *netdev,
@@ -12955,8 +12771,8 @@ static const struct net_device_ops i40e_netdev_ops = {
 	.ndo_set_vf_link_state	= i40e_ndo_set_vf_link_state,
 	.ndo_set_vf_spoofchk	= i40e_ndo_set_vf_spoofchk,
 	.ndo_set_vf_trust	= i40e_ndo_set_vf_trust,
-	.ndo_udp_tunnel_add	= i40e_udp_tunnel_add,
-	.ndo_udp_tunnel_del	= i40e_udp_tunnel_del,
+	.ndo_udp_tunnel_add	= udp_tunnel_nic_add_port,
+	.ndo_udp_tunnel_del	= udp_tunnel_nic_del_port,
 	.ndo_get_phys_port_id	= i40e_get_phys_port_id,
 	.ndo_fdb_add		= i40e_ndo_fdb_add,
 	.ndo_features_check	= i40e_features_check,
@@ -13020,6 +12836,8 @@ static int i40e_config_netdev(struct i40e_vsi *vsi)
 	if (!(pf->hw_features & I40E_HW_OUTER_UDP_CSUM_CAPABLE))
 		netdev->gso_partial_features |= NETIF_F_GSO_UDP_TUNNEL_CSUM;
 
+	netdev->udp_tunnel_nic_info = &pf->udp_tunnel_nic;
+
 	netdev->gso_partial_features |= NETIF_F_GSO_GRE_CSUM;
 
 	netdev->hw_enc_features |= hw_enc_features;
@@ -14420,7 +14238,7 @@ static int i40e_setup_pf_switch(struct i40e_pf *pf, bool reinit)
 	i40e_ptp_init(pf);
 
 	/* repopulate tunnel port filters */
-	i40e_sync_udp_filters(pf);
+	udp_tunnel_nic_reset_ntf(pf->vsi[pf->lan_vsi]->netdev);
 
 	return ret;
 }
@@ -15149,6 +14967,14 @@ static int i40e_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (err)
 		goto err_switch_setup;
 
+	pf->udp_tunnel_nic.set_port = i40e_udp_tunnel_set_port;
+	pf->udp_tunnel_nic.unset_port = i40e_udp_tunnel_unset_port;
+	pf->udp_tunnel_nic.flags = UDP_TUNNEL_NIC_INFO_MAY_SLEEP;
+	pf->udp_tunnel_nic.shared = &pf->udp_tunnel_shared;
+	pf->udp_tunnel_nic.tables[0].n_entries = I40E_MAX_PF_UDP_OFFLOAD_PORTS;
+	pf->udp_tunnel_nic.tables[0].tunnel_types = UDP_TUNNEL_TYPE_VXLAN |
+						    UDP_TUNNEL_TYPE_GENEVE;
+
 	/* The number of VSIs reported by the FW is the minimum guaranteed
 	 * to us; HW supports far more and we share the remaining pool with
 	 * the other PFs. We allocate space for more than the guarantee with
@@ -15158,6 +14984,12 @@ static int i40e_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		pf->num_alloc_vsi = I40E_MIN_VSI_ALLOC;
 	else
 		pf->num_alloc_vsi = pf->hw.func_caps.num_vsis;
+	if (pf->num_alloc_vsi > UDP_TUNNEL_NIC_MAX_SHARING_DEVICES) {
+		dev_warn(&pf->pdev->dev,
+			 "limiting the VSI count due to UDP tunnel limitation %d > %d\n",
+			 pf->num_alloc_vsi, UDP_TUNNEL_NIC_MAX_SHARING_DEVICES);
+		pf->num_alloc_vsi = UDP_TUNNEL_NIC_MAX_SHARING_DEVICES;
+	}
 
 	/* Set up the *vsi struct and our local tracking of the MAIN PF vsi. */
 	pf->vsi = kcalloc(pf->num_alloc_vsi, sizeof(struct i40e_vsi *),
-- 
2.26.2

