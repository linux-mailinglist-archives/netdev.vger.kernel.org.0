Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E35522473C
	for <lists+netdev@lfdr.de>; Sat, 18 Jul 2020 01:53:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727986AbgGQXxk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 19:53:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:48206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726851AbgGQXxj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Jul 2020 19:53:39 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1EEAC20717;
        Fri, 17 Jul 2020 23:53:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595030018;
        bh=bzB0lsU4zWLTZWfodcNN+J8G/1ykPRNY04HBbJuh97s=;
        h=From:To:Cc:Subject:Date:From;
        b=WI0cVguD1wn++/J6q8ImJ6Sp/vpu3JOsRSu9/qf6EqRW7HjUiu7N+AfFpd2M+Y+9K
         sSGueutB7fRREEslMr/NNg8tCrOJM9Ofxf+PKD6SrvkKO5QxxMkbtIUiHTHFvohuGm
         ApitmoomrYZpnIoR55EuHWyOHA1OEt1gXY1LnEn4=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-net-drivers@solarflare.com,
        ecree@solarflare.com, mhabets@solarflare.com,
        mslattery@solarflare.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next] efx: convert to new udp_tunnel infrastructure
Date:   Fri, 17 Jul 2020 16:53:36 -0700
Message-Id: <20200717235336.879264-1-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Check MC_CMD_DRV_ATTACH_EXT_OUT_FLAG_TRUSTED, before setting
the info, which will hopefully protect us from -EPERM errors
the previous code was gracefully ignoring. Shared code reports
the port information back to user space, so we really want
to know what was added and what failed.

The driver does not call udp_tunnel_get_rx_info(), so its own
management of table state is not really all that problematic,
we can leave it be. This allows the driver to continue with its
copious table syncing, and matching the ports to TX frames,
which it will reportedly do one day.

Leave the feature checking in the callbacks, as the device may
remove the capabilities on reset.

Inline the loop from __efx_ef10_udp_tnl_lookup_port() into
efx_ef10_udp_tnl_has_port(), since it's the only caller now.

With new infra this driver gains port replace - when space frees
up in a full table a new port will be selected for offload.
Plus efx will no longer sleep in an atomic context.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/sfc/ef10.c       | 155 +++++++++-----------------
 drivers/net/ethernet/sfc/efx.c        |  72 +-----------
 drivers/net/ethernet/sfc/net_driver.h |  10 --
 3 files changed, 55 insertions(+), 182 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
index cb7b634a1150..bb70b6405624 100644
--- a/drivers/net/ethernet/sfc/ef10.c
+++ b/drivers/net/ethernet/sfc/ef10.c
@@ -22,6 +22,7 @@
 #include <linux/jhash.h>
 #include <linux/wait.h>
 #include <linux/workqueue.h>
+#include <net/udp_tunnel.h>
 
 /* Hardware control for EF10 architecture including 'Huntington'. */
 
@@ -38,6 +39,7 @@ struct efx_ef10_vlan {
 };
 
 static int efx_ef10_set_udp_tnl_ports(struct efx_nic *efx, bool unloading);
+static const struct udp_tunnel_nic_info efx_ef10_udp_tunnels;
 
 static int efx_ef10_get_warm_boot_count(struct efx_nic *efx)
 {
@@ -665,6 +667,12 @@ static int efx_ef10_probe(struct efx_nic *efx)
 	if (rc)
 		goto fail_add_vid_0;
 
+	if (nic_data->datapath_caps &
+	    (1 << MC_CMD_GET_CAPABILITIES_OUT_VXLAN_NVGRE_LBN) &&
+	    efx->mcdi->fn_flags &
+	    (1 << MC_CMD_DRV_ATTACH_EXT_OUT_FLAG_TRUSTED))
+		efx->net_dev->udp_tunnel_nic_info = &efx_ef10_udp_tunnels;
+
 	return 0;
 
 fail_add_vid_0:
@@ -3702,8 +3710,7 @@ static int efx_ef10_set_udp_tnl_ports(struct efx_nic *efx, bool unloading)
 		     MC_CMD_SET_TUNNEL_ENCAP_UDP_PORTS_IN_ENTRIES_MAXNUM);
 
 	for (i = 0; i < ARRAY_SIZE(nic_data->udp_tunnels); ++i) {
-		if (nic_data->udp_tunnels[i].count &&
-		    nic_data->udp_tunnels[i].port) {
+		if (nic_data->udp_tunnels[i].port) {
 			efx_dword_t entry;
 
 			EFX_POPULATE_DWORD_2(entry,
@@ -3789,79 +3796,34 @@ static int efx_ef10_udp_tnl_push_ports(struct efx_nic *efx)
 	return rc;
 }
 
-static struct efx_udp_tunnel *__efx_ef10_udp_tnl_lookup_port(struct efx_nic *efx,
-							     __be16 port)
+static int efx_ef10_udp_tnl_set_port(struct net_device *dev,
+				     unsigned int table, unsigned int entry,
+				     struct udp_tunnel_info *ti)
 {
-	struct efx_ef10_nic_data *nic_data = efx->nic_data;
-	size_t i;
-
-	for (i = 0; i < ARRAY_SIZE(nic_data->udp_tunnels); ++i) {
-		if (!nic_data->udp_tunnels[i].count)
-			continue;
-		if (nic_data->udp_tunnels[i].port == port)
-			return &nic_data->udp_tunnels[i];
-	}
-	return NULL;
-}
+	struct efx_nic *efx = netdev_priv(dev);
+	struct efx_ef10_nic_data *nic_data;
+	int efx_tunnel_type, rc;
 
-static int efx_ef10_udp_tnl_add_port(struct efx_nic *efx,
-				     struct efx_udp_tunnel tnl)
-{
-	struct efx_ef10_nic_data *nic_data = efx->nic_data;
-	struct efx_udp_tunnel *match;
-	char typebuf[8];
-	size_t i;
-	int rc;
+	if (ti->type == UDP_TUNNEL_TYPE_VXLAN)
+		efx_tunnel_type = TUNNEL_ENCAP_UDP_PORT_ENTRY_VXLAN;
+	else
+		efx_tunnel_type = TUNNEL_ENCAP_UDP_PORT_ENTRY_GENEVE;
 
+	nic_data = efx->nic_data;
 	if (!(nic_data->datapath_caps &
 	      (1 << MC_CMD_GET_CAPABILITIES_OUT_VXLAN_NVGRE_LBN)))
-		return 0;
-
-	efx_get_udp_tunnel_type_name(tnl.type, typebuf, sizeof(typebuf));
-	netif_dbg(efx, drv, efx->net_dev, "Adding UDP tunnel (%s) port %d\n",
-		  typebuf, ntohs(tnl.port));
+		return -EOPNOTSUPP;
 
 	mutex_lock(&nic_data->udp_tunnels_lock);
 	/* Make sure all TX are stopped while we add to the table, else we
 	 * might race against an efx_features_check().
 	 */
 	efx_device_detach_sync(efx);
-
-	match = __efx_ef10_udp_tnl_lookup_port(efx, tnl.port);
-	if (match != NULL) {
-		if (match->type == tnl.type) {
-			netif_dbg(efx, drv, efx->net_dev,
-				  "Referencing existing tunnel entry\n");
-			match->count++;
-			/* No need to cause an MCDI update */
-			rc = 0;
-			goto unlock_out;
-		}
-		efx_get_udp_tunnel_type_name(match->type,
-					     typebuf, sizeof(typebuf));
-		netif_dbg(efx, drv, efx->net_dev,
-			  "UDP port %d is already in use by %s\n",
-			  ntohs(tnl.port), typebuf);
-		rc = -EEXIST;
-		goto unlock_out;
-	}
-
-	for (i = 0; i < ARRAY_SIZE(nic_data->udp_tunnels); ++i)
-		if (!nic_data->udp_tunnels[i].count) {
-			nic_data->udp_tunnels[i] = tnl;
-			nic_data->udp_tunnels[i].count = 1;
-			rc = efx_ef10_set_udp_tnl_ports(efx, false);
-			goto unlock_out;
-		}
-
-	netif_dbg(efx, drv, efx->net_dev,
-		  "Unable to add UDP tunnel (%s) port %d; insufficient resources.\n",
-		  typebuf, ntohs(tnl.port));
-
-	rc = -ENOMEM;
-
-unlock_out:
+	nic_data->udp_tunnels[entry].type = efx_tunnel_type;
+	nic_data->udp_tunnels[entry].port = ti->port;
+	rc = efx_ef10_set_udp_tnl_ports(efx, false);
 	mutex_unlock(&nic_data->udp_tunnels_lock);
+
 	return rc;
 }
 
@@ -3873,6 +3835,7 @@ static int efx_ef10_udp_tnl_add_port(struct efx_nic *efx,
 static bool efx_ef10_udp_tnl_has_port(struct efx_nic *efx, __be16 port)
 {
 	struct efx_ef10_nic_data *nic_data = efx->nic_data;
+	size_t i;
 
 	if (!(nic_data->datapath_caps &
 	      (1 << MC_CMD_GET_CAPABILITIES_OUT_VXLAN_NVGRE_LBN)))
@@ -3884,58 +3847,48 @@ static bool efx_ef10_udp_tnl_has_port(struct efx_nic *efx, __be16 port)
 		 */
 		return false;
 
-	return __efx_ef10_udp_tnl_lookup_port(efx, port) != NULL;
+	for (i = 0; i < ARRAY_SIZE(nic_data->udp_tunnels); ++i)
+		if (nic_data->udp_tunnels[i].port == port)
+			return true;
+
+	return false;
 }
 
-static int efx_ef10_udp_tnl_del_port(struct efx_nic *efx,
-				     struct efx_udp_tunnel tnl)
+static int efx_ef10_udp_tnl_unset_port(struct net_device *dev,
+				       unsigned int table, unsigned int entry,
+				       struct udp_tunnel_info *ti)
 {
-	struct efx_ef10_nic_data *nic_data = efx->nic_data;
-	struct efx_udp_tunnel *match;
-	char typebuf[8];
+	struct efx_nic *efx = netdev_priv(dev);
+	struct efx_ef10_nic_data *nic_data;
 	int rc;
 
-	if (!(nic_data->datapath_caps &
-	      (1 << MC_CMD_GET_CAPABILITIES_OUT_VXLAN_NVGRE_LBN)))
-		return 0;
-
-	efx_get_udp_tunnel_type_name(tnl.type, typebuf, sizeof(typebuf));
-	netif_dbg(efx, drv, efx->net_dev, "Removing UDP tunnel (%s) port %d\n",
-		  typebuf, ntohs(tnl.port));
+	nic_data = efx->nic_data;
 
 	mutex_lock(&nic_data->udp_tunnels_lock);
 	/* Make sure all TX are stopped while we remove from the table, else we
 	 * might race against an efx_features_check().
 	 */
 	efx_device_detach_sync(efx);
-
-	match = __efx_ef10_udp_tnl_lookup_port(efx, tnl.port);
-	if (match != NULL) {
-		if (match->type == tnl.type) {
-			if (--match->count) {
-				/* Port is still in use, so nothing to do */
-				netif_dbg(efx, drv, efx->net_dev,
-					  "UDP tunnel port %d remains active\n",
-					  ntohs(tnl.port));
-				rc = 0;
-				goto out_unlock;
-			}
-			rc = efx_ef10_set_udp_tnl_ports(efx, false);
-			goto out_unlock;
-		}
-		efx_get_udp_tunnel_type_name(match->type,
-					     typebuf, sizeof(typebuf));
-		netif_warn(efx, drv, efx->net_dev,
-			   "UDP port %d is actually in use by %s, not removing\n",
-			   ntohs(tnl.port), typebuf);
-	}
-	rc = -ENOENT;
-
-out_unlock:
+	nic_data->udp_tunnels[entry].port = 0;
+	rc = efx_ef10_set_udp_tnl_ports(efx, false);
 	mutex_unlock(&nic_data->udp_tunnels_lock);
+
 	return rc;
 }
 
+static const struct udp_tunnel_nic_info efx_ef10_udp_tunnels = {
+	.set_port	= efx_ef10_udp_tnl_set_port,
+	.unset_port	= efx_ef10_udp_tnl_unset_port,
+	.flags          = UDP_TUNNEL_NIC_INFO_MAY_SLEEP,
+	.tables         = {
+		{
+			.n_entries = 16,
+			.tunnel_types = UDP_TUNNEL_TYPE_VXLAN |
+					UDP_TUNNEL_TYPE_GENEVE,
+		},
+	},
+};
+
 /* EF10 may have multiple datapath firmware variants within a
  * single version.  Report which variants are running.
  */
@@ -4172,9 +4125,7 @@ const struct efx_nic_type efx_hunt_a0_nic_type = {
 	.vlan_rx_add_vid = efx_ef10_vlan_rx_add_vid,
 	.vlan_rx_kill_vid = efx_ef10_vlan_rx_kill_vid,
 	.udp_tnl_push_ports = efx_ef10_udp_tnl_push_ports,
-	.udp_tnl_add_port = efx_ef10_udp_tnl_add_port,
 	.udp_tnl_has_port = efx_ef10_udp_tnl_has_port,
-	.udp_tnl_del_port = efx_ef10_udp_tnl_del_port,
 #ifdef CONFIG_SFC_SRIOV
 	.sriov_configure = efx_ef10_sriov_configure,
 	.sriov_init = efx_ef10_sriov_init,
diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index befd253af918..f16b4f236031 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -36,28 +36,6 @@
 #include "mcdi_pcol.h"
 #include "workarounds.h"
 
-/**************************************************************************
- *
- * Type name strings
- *
- **************************************************************************
- */
-
-/* UDP tunnel type names */
-static const char *const efx_udp_tunnel_type_names[] = {
-	[TUNNEL_ENCAP_UDP_PORT_ENTRY_VXLAN] = "vxlan",
-	[TUNNEL_ENCAP_UDP_PORT_ENTRY_GENEVE] = "geneve",
-};
-
-void efx_get_udp_tunnel_type_name(u16 type, char *buf, size_t buflen)
-{
-	if (type < ARRAY_SIZE(efx_udp_tunnel_type_names) &&
-	    efx_udp_tunnel_type_names[type] != NULL)
-		snprintf(buf, buflen, "%s", efx_udp_tunnel_type_names[type]);
-	else
-		snprintf(buf, buflen, "type %d", type);
-}
-
 /**************************************************************************
  *
  * Configurable values
@@ -612,52 +590,6 @@ static int efx_vlan_rx_kill_vid(struct net_device *net_dev, __be16 proto, u16 vi
 		return -EOPNOTSUPP;
 }
 
-static int efx_udp_tunnel_type_map(enum udp_parsable_tunnel_type in)
-{
-	switch (in) {
-	case UDP_TUNNEL_TYPE_VXLAN:
-		return TUNNEL_ENCAP_UDP_PORT_ENTRY_VXLAN;
-	case UDP_TUNNEL_TYPE_GENEVE:
-		return TUNNEL_ENCAP_UDP_PORT_ENTRY_GENEVE;
-	default:
-		return -1;
-	}
-}
-
-static void efx_udp_tunnel_add(struct net_device *dev, struct udp_tunnel_info *ti)
-{
-	struct efx_nic *efx = netdev_priv(dev);
-	struct efx_udp_tunnel tnl;
-	int efx_tunnel_type;
-
-	efx_tunnel_type = efx_udp_tunnel_type_map(ti->type);
-	if (efx_tunnel_type < 0)
-		return;
-
-	tnl.type = (u16)efx_tunnel_type;
-	tnl.port = ti->port;
-
-	if (efx->type->udp_tnl_add_port)
-		(void)efx->type->udp_tnl_add_port(efx, tnl);
-}
-
-static void efx_udp_tunnel_del(struct net_device *dev, struct udp_tunnel_info *ti)
-{
-	struct efx_nic *efx = netdev_priv(dev);
-	struct efx_udp_tunnel tnl;
-	int efx_tunnel_type;
-
-	efx_tunnel_type = efx_udp_tunnel_type_map(ti->type);
-	if (efx_tunnel_type < 0)
-		return;
-
-	tnl.type = (u16)efx_tunnel_type;
-	tnl.port = ti->port;
-
-	if (efx->type->udp_tnl_del_port)
-		(void)efx->type->udp_tnl_del_port(efx, tnl);
-}
-
 static const struct net_device_ops efx_netdev_ops = {
 	.ndo_open		= efx_net_open,
 	.ndo_stop		= efx_net_stop,
@@ -685,8 +617,8 @@ static const struct net_device_ops efx_netdev_ops = {
 #ifdef CONFIG_RFS_ACCEL
 	.ndo_rx_flow_steer	= efx_filter_rfs,
 #endif
-	.ndo_udp_tunnel_add	= efx_udp_tunnel_add,
-	.ndo_udp_tunnel_del	= efx_udp_tunnel_del,
+	.ndo_udp_tunnel_add	= udp_tunnel_nic_add_port,
+	.ndo_udp_tunnel_del	= udp_tunnel_nic_del_port,
 	.ndo_xdp_xmit		= efx_xdp_xmit,
 	.ndo_bpf		= efx_xdp
 };
diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
index 0bf11ebb03cf..e415a23ade0b 100644
--- a/drivers/net/ethernet/sfc/net_driver.h
+++ b/drivers/net/ethernet/sfc/net_driver.h
@@ -609,8 +609,6 @@ extern const unsigned int efx_reset_type_max;
 #define RESET_TYPE(type) \
 	STRING_TABLE_LOOKUP(type, efx_reset_type)
 
-void efx_get_udp_tunnel_type_name(u16 type, char *buf, size_t buflen);
-
 enum efx_int_mode {
 	/* Be careful if altering to correct macro below */
 	EFX_INT_MODE_MSIX = 0,
@@ -1175,10 +1173,6 @@ struct efx_mtd_partition {
 struct efx_udp_tunnel {
 	u16 type; /* TUNNEL_ENCAP_UDP_PORT_ENTRY_foo, see mcdi_pcol.h */
 	__be16 port;
-	/* Count of repeated adds of the same port.  Used only inside the list,
-	 * not in request arguments.
-	 */
-	u16 count;
 };
 
 /**
@@ -1302,9 +1296,7 @@ struct efx_udp_tunnel {
  * @tso_versions: Returns mask of firmware-assisted TSO versions supported.
  *	If %NULL, then device does not support any TSO version.
  * @udp_tnl_push_ports: Push the list of UDP tunnel ports to the NIC if required.
- * @udp_tnl_add_port: Add a UDP tunnel port
  * @udp_tnl_has_port: Check if a port has been added as UDP tunnel
- * @udp_tnl_del_port: Remove a UDP tunnel port
  * @print_additional_fwver: Dump NIC-specific additional FW version info
  * @revision: Hardware architecture revision
  * @txd_ptr_tbl_base: TX descriptor ring base address
@@ -1474,9 +1466,7 @@ struct efx_nic_type {
 	int (*set_mac_address)(struct efx_nic *efx);
 	u32 (*tso_versions)(struct efx_nic *efx);
 	int (*udp_tnl_push_ports)(struct efx_nic *efx);
-	int (*udp_tnl_add_port)(struct efx_nic *efx, struct efx_udp_tunnel tnl);
 	bool (*udp_tnl_has_port)(struct efx_nic *efx, __be16 port);
-	int (*udp_tnl_del_port)(struct efx_nic *efx, struct efx_udp_tunnel tnl);
 	size_t (*print_additional_fwver)(struct efx_nic *efx, char *buf,
 					 size_t len);
 
-- 
2.26.2

