Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D557A21F965
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 20:29:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729157AbgGNS3c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 14:29:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:34838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725951AbgGNS33 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Jul 2020 14:29:29 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 19BE4229C4;
        Tue, 14 Jul 2020 18:29:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594751368;
        bh=7hcorMMdcx4gJx34Uv4LRSXrT+LMYkkStbKWfh/aQ3I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XRRTK/DbWcnsMRr3jSvCKVQF7sR4v1WiqnojtwOSGu61W7az2Br+wEdol0gA44PYY
         6dvhPpddndUIXgpCy0GB0Iju4EHfB0xy8ZYVdqwLglGOfuHgks1mynGcLNZSIZXjjn
         xb9oFec7VfKaU1gl1v/iLMunwq06hkwKEb6yhwTw=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        simon.horman@netronome.com, ajit.khaparde@broadcom.com,
        sriharsha.basavapatna@broadcom.com, somnath.kotur@broadcom.com,
        thomas.lendacky@amd.com, aelior@marvell.com, skalluru@marvell.com,
        vishal@chelsio.com, benve@cisco.com, _govind@gmx.com,
        dchickles@marvell.com, sburla@marvell.com, fmanlunas@marvell.com,
        jeffrey.t.kirsher@intel.com, anthony.l.nguyen@intel.com,
        GR-everest-linux-l2@marvell.com, shshaikh@marvell.com,
        manishc@marvell.com, GR-Linux-NIC-Dev@marvell.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 01/12] nfp: convert to new udp_tunnel_nic infra
Date:   Tue, 14 Jul 2020 11:28:57 -0700
Message-Id: <20200714182908.690108-2-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200714182908.690108-1-kuba@kernel.org>
References: <20200714182908.690108-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

NFP conversion is pretty straightforward. We want to be able
to sleep, and only get callbacks when the device is open.

NFP did not ask for port replay when ports were removed, now
new infra will provide this feature for free.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Simon Horman <simon.horman@netronome.com>
---
 drivers/net/ethernet/netronome/nfp/nfp_net.h  |   5 -
 .../ethernet/netronome/nfp/nfp_net_common.c   | 126 +++++-------------
 2 files changed, 34 insertions(+), 97 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net.h b/drivers/net/ethernet/netronome/nfp/nfp_net.h
index ff4438478ea9..df5b748be068 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net.h
@@ -575,8 +575,6 @@ struct nfp_net_dp {
  * @rx_coalesce_max_frames: RX interrupt moderation frame count parameter
  * @tx_coalesce_usecs:      TX interrupt moderation usecs delay parameter
  * @tx_coalesce_max_frames: TX interrupt moderation frame count parameter
- * @vxlan_ports:	VXLAN ports for RX inner csum offload communicated to HW
- * @vxlan_usecnt:	IPv4/IPv6 VXLAN port use counts
  * @qcp_cfg:            Pointer to QCP queue used for configuration notification
  * @tx_bar:             Pointer to mapped TX queues
  * @rx_bar:             Pointer to mapped FL/RX queues
@@ -661,9 +659,6 @@ struct nfp_net {
 	u32 tx_coalesce_usecs;
 	u32 tx_coalesce_max_frames;
 
-	__be16 vxlan_ports[NFP_NET_N_VXLAN_PORTS];
-	u8 vxlan_usecnt[NFP_NET_N_VXLAN_PORTS];
-
 	u8 __iomem *qcp_cfg;
 
 	u8 __iomem *tx_bar;
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index 83ff18140bfe..44608873d3d9 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -2867,15 +2867,6 @@ static int nfp_net_set_config_and_enable(struct nfp_net *nn)
 	for (r = 0; r < nn->dp.num_rx_rings; r++)
 		nfp_net_rx_ring_fill_freelist(&nn->dp, &nn->dp.rx_rings[r]);
 
-	/* Since reconfiguration requests while NFP is down are ignored we
-	 * have to wipe the entire VXLAN configuration and reinitialize it.
-	 */
-	if (nn->dp.ctrl & NFP_NET_CFG_CTRL_VXLAN) {
-		memset(&nn->vxlan_ports, 0, sizeof(nn->vxlan_ports));
-		memset(&nn->vxlan_usecnt, 0, sizeof(nn->vxlan_usecnt));
-		udp_tunnel_get_rx_info(nn->dp.netdev);
-	}
-
 	return 0;
 }
 
@@ -3566,87 +3557,6 @@ nfp_net_get_phys_port_name(struct net_device *netdev, char *name, size_t len)
 	return 0;
 }
 
-/**
- * nfp_net_set_vxlan_port() - set vxlan port in SW and reconfigure HW
- * @nn:   NFP Net device to reconfigure
- * @idx:  Index into the port table where new port should be written
- * @port: UDP port to configure (pass zero to remove VXLAN port)
- */
-static void nfp_net_set_vxlan_port(struct nfp_net *nn, int idx, __be16 port)
-{
-	int i;
-
-	nn->vxlan_ports[idx] = port;
-
-	if (!(nn->dp.ctrl & NFP_NET_CFG_CTRL_VXLAN))
-		return;
-
-	BUILD_BUG_ON(NFP_NET_N_VXLAN_PORTS & 1);
-	for (i = 0; i < NFP_NET_N_VXLAN_PORTS; i += 2)
-		nn_writel(nn, NFP_NET_CFG_VXLAN_PORT + i * sizeof(port),
-			  be16_to_cpu(nn->vxlan_ports[i + 1]) << 16 |
-			  be16_to_cpu(nn->vxlan_ports[i]));
-
-	nfp_net_reconfig_post(nn, NFP_NET_CFG_UPDATE_VXLAN);
-}
-
-/**
- * nfp_net_find_vxlan_idx() - find table entry of the port or a free one
- * @nn:   NFP Network structure
- * @port: UDP port to look for
- *
- * Return: if the port is already in the table -- it's position;
- *	   if the port is not in the table -- free position to use;
- *	   if the table is full -- -ENOSPC.
- */
-static int nfp_net_find_vxlan_idx(struct nfp_net *nn, __be16 port)
-{
-	int i, free_idx = -ENOSPC;
-
-	for (i = 0; i < NFP_NET_N_VXLAN_PORTS; i++) {
-		if (nn->vxlan_ports[i] == port)
-			return i;
-		if (!nn->vxlan_usecnt[i])
-			free_idx = i;
-	}
-
-	return free_idx;
-}
-
-static void nfp_net_add_vxlan_port(struct net_device *netdev,
-				   struct udp_tunnel_info *ti)
-{
-	struct nfp_net *nn = netdev_priv(netdev);
-	int idx;
-
-	if (ti->type != UDP_TUNNEL_TYPE_VXLAN)
-		return;
-
-	idx = nfp_net_find_vxlan_idx(nn, ti->port);
-	if (idx == -ENOSPC)
-		return;
-
-	if (!nn->vxlan_usecnt[idx]++)
-		nfp_net_set_vxlan_port(nn, idx, ti->port);
-}
-
-static void nfp_net_del_vxlan_port(struct net_device *netdev,
-				   struct udp_tunnel_info *ti)
-{
-	struct nfp_net *nn = netdev_priv(netdev);
-	int idx;
-
-	if (ti->type != UDP_TUNNEL_TYPE_VXLAN)
-		return;
-
-	idx = nfp_net_find_vxlan_idx(nn, ti->port);
-	if (idx == -ENOSPC || !nn->vxlan_usecnt[idx])
-		return;
-
-	if (!--nn->vxlan_usecnt[idx])
-		nfp_net_set_vxlan_port(nn, idx, 0);
-}
-
 static int nfp_net_xdp_setup_drv(struct nfp_net *nn, struct netdev_bpf *bpf)
 {
 	struct bpf_prog *prog = bpf->prog;
@@ -3757,12 +3667,43 @@ const struct net_device_ops nfp_net_netdev_ops = {
 	.ndo_set_features	= nfp_net_set_features,
 	.ndo_features_check	= nfp_net_features_check,
 	.ndo_get_phys_port_name	= nfp_net_get_phys_port_name,
-	.ndo_udp_tunnel_add	= nfp_net_add_vxlan_port,
-	.ndo_udp_tunnel_del	= nfp_net_del_vxlan_port,
+	.ndo_udp_tunnel_add	= udp_tunnel_nic_add_port,
+	.ndo_udp_tunnel_del	= udp_tunnel_nic_del_port,
 	.ndo_bpf		= nfp_net_xdp,
 	.ndo_get_devlink_port	= nfp_devlink_get_devlink_port,
 };
 
+static int nfp_udp_tunnel_sync(struct net_device *netdev, unsigned int table)
+{
+	struct nfp_net *nn = netdev_priv(netdev);
+	int i;
+
+	BUILD_BUG_ON(NFP_NET_N_VXLAN_PORTS & 1);
+	for (i = 0; i < NFP_NET_N_VXLAN_PORTS; i += 2) {
+		struct udp_tunnel_info ti0, ti1;
+
+		udp_tunnel_nic_get_port(netdev, table, i, &ti0);
+		udp_tunnel_nic_get_port(netdev, table, i + 1, &ti1);
+
+		nn_writel(nn, NFP_NET_CFG_VXLAN_PORT + i * sizeof(ti0.port),
+			  be16_to_cpu(ti1.port) << 16 | be16_to_cpu(ti0.port));
+	}
+
+	return nfp_net_reconfig(nn, NFP_NET_CFG_UPDATE_VXLAN);
+}
+
+static const struct udp_tunnel_nic_info nfp_udp_tunnels = {
+	.sync_table     = nfp_udp_tunnel_sync,
+	.flags          = UDP_TUNNEL_NIC_INFO_MAY_SLEEP |
+			  UDP_TUNNEL_NIC_INFO_OPEN_ONLY,
+	.tables         = {
+		{
+			.n_entries      = NFP_NET_N_VXLAN_PORTS,
+			.tunnel_types   = UDP_TUNNEL_TYPE_VXLAN,
+		},
+	},
+};
+
 /**
  * nfp_net_info() - Print general info about the NIC
  * @nn:      NFP Net device to reconfigure
@@ -4010,6 +3951,7 @@ static void nfp_net_netdev_init(struct nfp_net *nn)
 	if (nn->cap & NFP_NET_CFG_CTRL_VXLAN) {
 		if (nn->cap & NFP_NET_CFG_CTRL_LSO)
 			netdev->hw_features |= NETIF_F_GSO_UDP_TUNNEL;
+		netdev->udp_tunnel_nic_info = &nfp_udp_tunnels;
 		nn->dp.ctrl |= NFP_NET_CFG_CTRL_VXLAN;
 	}
 	if (nn->cap & NFP_NET_CFG_CTRL_NVGRE) {
-- 
2.26.2

