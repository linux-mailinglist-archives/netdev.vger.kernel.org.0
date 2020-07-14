Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 249E221FD2B
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 21:19:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729983AbgGNTTD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 15:19:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:43602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729783AbgGNTSs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Jul 2020 15:18:48 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 43CE322B30;
        Tue, 14 Jul 2020 19:18:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594754328;
        bh=UoWkh3/faaSlINAZYPf6ZRYIUNpFUk4PesxkOQk21uI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QrCI0pbITJYD21gbnwux2B2gFCInKDk6CHWwioJrkIwLamF4jbYifSpRRSLefeIlc
         MKPpItSJ16LB2FhH5eLu+a+II5bZBRfjr3nFAwWbEgOTO1a1X7qs3XDkZ/nWgg4T3C
         FC7O7jmBNm6ifFGK8kWnPEP7IW/duUmuoXnQil5E=
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
Subject: [PATCH net-next v3 09/12] liquidio_vf: convert to new udp_tunnel_nic infra
Date:   Tue, 14 Jul 2020 12:18:27 -0700
Message-Id: <20200714191830.694674-10-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200714191830.694674-1-kuba@kernel.org>
References: <20200714191830.694674-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Carbon copy of the previous change.

This driver is just a super thin FW interface, but Derek let us
know the table has 1024 entries.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 .../ethernet/cavium/liquidio/lio_vf_main.c    | 59 +++++++++++--------
 1 file changed, 33 insertions(+), 26 deletions(-)

diff --git a/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c b/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
index bbd9bfa4a989..90ef21086f27 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
@@ -1767,6 +1767,35 @@ static int liquidio_vxlan_port_command(struct net_device *netdev, int command,
 	return ret;
 }
 
+static int liquidio_udp_tunnel_set_port(struct net_device *netdev,
+					unsigned int table, unsigned int entry,
+					struct udp_tunnel_info *ti)
+{
+	return liquidio_vxlan_port_command(netdev,
+					   OCTNET_CMD_VXLAN_PORT_CONFIG,
+					   htons(ti->port),
+					   OCTNET_CMD_VXLAN_PORT_ADD);
+}
+
+static int liquidio_udp_tunnel_unset_port(struct net_device *netdev,
+					  unsigned int table,
+					  unsigned int entry,
+					  struct udp_tunnel_info *ti)
+{
+	return liquidio_vxlan_port_command(netdev,
+					   OCTNET_CMD_VXLAN_PORT_CONFIG,
+					   htons(ti->port),
+					   OCTNET_CMD_VXLAN_PORT_DEL);
+}
+
+static const struct udp_tunnel_nic_info liquidio_udp_tunnels = {
+	.set_port	= liquidio_udp_tunnel_set_port,
+	.unset_port	= liquidio_udp_tunnel_unset_port,
+	.tables		= {
+		{ .n_entries = 1024, .tunnel_types = UDP_TUNNEL_TYPE_VXLAN, },
+	},
+};
+
 /** \brief Net device fix features
  * @param netdev  pointer to network device
  * @param request features requested
@@ -1835,30 +1864,6 @@ static int liquidio_set_features(struct net_device *netdev,
 	return 0;
 }
 
-static void liquidio_add_vxlan_port(struct net_device *netdev,
-				    struct udp_tunnel_info *ti)
-{
-	if (ti->type != UDP_TUNNEL_TYPE_VXLAN)
-		return;
-
-	liquidio_vxlan_port_command(netdev,
-				    OCTNET_CMD_VXLAN_PORT_CONFIG,
-				    htons(ti->port),
-				    OCTNET_CMD_VXLAN_PORT_ADD);
-}
-
-static void liquidio_del_vxlan_port(struct net_device *netdev,
-				    struct udp_tunnel_info *ti)
-{
-	if (ti->type != UDP_TUNNEL_TYPE_VXLAN)
-		return;
-
-	liquidio_vxlan_port_command(netdev,
-				    OCTNET_CMD_VXLAN_PORT_CONFIG,
-				    htons(ti->port),
-				    OCTNET_CMD_VXLAN_PORT_DEL);
-}
-
 static const struct net_device_ops lionetdevops = {
 	.ndo_open		= liquidio_open,
 	.ndo_stop		= liquidio_stop,
@@ -1873,8 +1878,8 @@ static const struct net_device_ops lionetdevops = {
 	.ndo_do_ioctl		= liquidio_ioctl,
 	.ndo_fix_features	= liquidio_fix_features,
 	.ndo_set_features	= liquidio_set_features,
-	.ndo_udp_tunnel_add     = liquidio_add_vxlan_port,
-	.ndo_udp_tunnel_del     = liquidio_del_vxlan_port,
+	.ndo_udp_tunnel_add	= udp_tunnel_nic_add_port,
+	.ndo_udp_tunnel_del	= udp_tunnel_nic_del_port,
 };
 
 static int lio_nic_info(struct octeon_recv_info *recv_info, void *buf)
@@ -2095,6 +2100,8 @@ static int setup_nic_devices(struct octeon_device *octeon_dev)
 
 		netdev->hw_enc_features =
 		    (lio->enc_dev_capability & ~NETIF_F_LRO);
+		netdev->udp_tunnel_nic_info = &liquidio_udp_tunnels;
+
 		netdev->vlan_features = lio->dev_capability;
 		/* Add any unchangeable hw features */
 		lio->dev_capability |= NETIF_F_HW_VLAN_CTAG_FILTER |
-- 
2.26.2

