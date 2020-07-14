Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C15221FD24
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 21:19:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729860AbgGNTSu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 15:18:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:43602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729753AbgGNTSq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Jul 2020 15:18:46 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 49EA622AAE;
        Tue, 14 Jul 2020 19:18:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594754326;
        bh=TGWoiBGSEmCjN0/5QgJnpG3hpTOlGDa0cg6LV5VFGG4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VNVeWi6Yn2UQEloQKG2AZ7I16lrcyadVyx3vdTDAqcxVRjitF+NPvLAgVcciAXA5a
         ReRjluSdxefOCXBjSH2MuktoPy4G1ccIy6Jj6jMa5VQJVG4xi0/tPwAyKxE6T0KgQY
         StRzqooLvk7jEJ3X4UhIjmU3EpkdmjrNAIZAx6V8=
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
Subject: [PATCH net-next v3 07/12] enic: convert to new udp_tunnel_nic infra
Date:   Tue, 14 Jul 2020 12:18:25 -0700
Message-Id: <20200714191830.694674-8-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200714191830.694674-1-kuba@kernel.org>
References: <20200714191830.694674-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert to new infra, now the refcounting will be correct,
and driver gets port replay of other ports when offloaded
port gets removed.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/cisco/enic/enic_main.c | 105 ++++++++------------
 1 file changed, 39 insertions(+), 66 deletions(-)

diff --git a/drivers/net/ethernet/cisco/enic/enic_main.c b/drivers/net/ethernet/cisco/enic/enic_main.c
index cd5fe4f6b54c..6bc7e7ba38c3 100644
--- a/drivers/net/ethernet/cisco/enic/enic_main.c
+++ b/drivers/net/ethernet/cisco/enic/enic_main.c
@@ -176,50 +176,18 @@ static void enic_unset_affinity_hint(struct enic *enic)
 		irq_set_affinity_hint(enic->msix_entry[i].vector, NULL);
 }
 
-static void enic_udp_tunnel_add(struct net_device *netdev,
-				struct udp_tunnel_info *ti)
+static int enic_udp_tunnel_set_port(struct net_device *netdev,
+				    unsigned int table, unsigned int entry,
+				    struct udp_tunnel_info *ti)
 {
 	struct enic *enic = netdev_priv(netdev);
-	__be16 port = ti->port;
 	int err;
 
 	spin_lock_bh(&enic->devcmd_lock);
 
-	if (ti->type != UDP_TUNNEL_TYPE_VXLAN) {
-		netdev_info(netdev, "udp_tnl: only vxlan tunnel offload supported");
-		goto error;
-	}
-
-	switch (ti->sa_family) {
-	case AF_INET6:
-		if (!(enic->vxlan.flags & ENIC_VXLAN_OUTER_IPV6)) {
-			netdev_info(netdev, "vxlan: only IPv4 offload supported");
-			goto error;
-		}
-		/* Fall through */
-	case AF_INET:
-		break;
-	default:
-		goto error;
-	}
-
-	if (enic->vxlan.vxlan_udp_port_number) {
-		if (ntohs(port) == enic->vxlan.vxlan_udp_port_number)
-			netdev_warn(netdev, "vxlan: udp port already offloaded");
-		else
-			netdev_info(netdev, "vxlan: offload supported for only one UDP port");
-
-		goto error;
-	}
-	if ((vnic_dev_get_res_count(enic->vdev, RES_TYPE_WQ) != 1) &&
-	    !(enic->vxlan.flags & ENIC_VXLAN_MULTI_WQ)) {
-		netdev_info(netdev, "vxlan: vxlan offload with multi wq not supported on this adapter");
-		goto error;
-	}
-
 	err = vnic_dev_overlay_offload_cfg(enic->vdev,
 					   OVERLAY_CFG_VXLAN_PORT_UPDATE,
-					   ntohs(port));
+					   ntohs(ti->port));
 	if (err)
 		goto error;
 
@@ -228,52 +196,50 @@ static void enic_udp_tunnel_add(struct net_device *netdev,
 	if (err)
 		goto error;
 
-	enic->vxlan.vxlan_udp_port_number = ntohs(port);
-
-	netdev_info(netdev, "vxlan fw-vers-%d: offload enabled for udp port: %d, sa_family: %d ",
-		    (int)enic->vxlan.patch_level, ntohs(port), ti->sa_family);
-
-	goto unlock;
-
+	enic->vxlan.vxlan_udp_port_number = ntohs(ti->port);
 error:
-	netdev_info(netdev, "failed to offload udp port: %d, sa_family: %d, type: %d",
-		    ntohs(port), ti->sa_family, ti->type);
-unlock:
 	spin_unlock_bh(&enic->devcmd_lock);
+
+	return err;
 }
 
-static void enic_udp_tunnel_del(struct net_device *netdev,
-				struct udp_tunnel_info *ti)
+static int enic_udp_tunnel_unset_port(struct net_device *netdev,
+				      unsigned int table, unsigned int entry,
+				      struct udp_tunnel_info *ti)
 {
 	struct enic *enic = netdev_priv(netdev);
 	int err;
 
 	spin_lock_bh(&enic->devcmd_lock);
 
-	if ((ntohs(ti->port) != enic->vxlan.vxlan_udp_port_number) ||
-	    ti->type != UDP_TUNNEL_TYPE_VXLAN) {
-		netdev_info(netdev, "udp_tnl: port:%d, sa_family: %d, type: %d not offloaded",
-			    ntohs(ti->port), ti->sa_family, ti->type);
-		goto unlock;
-	}
-
 	err = vnic_dev_overlay_offload_ctrl(enic->vdev, OVERLAY_FEATURE_VXLAN,
 					    OVERLAY_OFFLOAD_DISABLE);
-	if (err) {
-		netdev_err(netdev, "vxlan: del offload udp port: %d failed",
-			   ntohs(ti->port));
+	if (err)
 		goto unlock;
-	}
 
 	enic->vxlan.vxlan_udp_port_number = 0;
 
-	netdev_info(netdev, "vxlan: del offload udp port %d, family %d\n",
-		    ntohs(ti->port), ti->sa_family);
-
 unlock:
 	spin_unlock_bh(&enic->devcmd_lock);
+
+	return err;
 }
 
+static const struct udp_tunnel_nic_info enic_udp_tunnels = {
+	.set_port	= enic_udp_tunnel_set_port,
+	.unset_port	= enic_udp_tunnel_unset_port,
+	.tables		= {
+		{ .n_entries = 1, .tunnel_types = UDP_TUNNEL_TYPE_VXLAN, },
+	},
+}, enic_udp_tunnels_v4 = {
+	.set_port	= enic_udp_tunnel_set_port,
+	.unset_port	= enic_udp_tunnel_unset_port,
+	.flags		= UDP_TUNNEL_NIC_INFO_IPV4_ONLY,
+	.tables		= {
+		{ .n_entries = 1, .tunnel_types = UDP_TUNNEL_TYPE_VXLAN, },
+	},
+};
+
 static netdev_features_t enic_features_check(struct sk_buff *skb,
 					     struct net_device *dev,
 					     netdev_features_t features)
@@ -2526,8 +2492,8 @@ static const struct net_device_ops enic_netdev_dynamic_ops = {
 #ifdef CONFIG_RFS_ACCEL
 	.ndo_rx_flow_steer	= enic_rx_flow_steer,
 #endif
-	.ndo_udp_tunnel_add	= enic_udp_tunnel_add,
-	.ndo_udp_tunnel_del	= enic_udp_tunnel_del,
+	.ndo_udp_tunnel_add	= udp_tunnel_nic_add_port,
+	.ndo_udp_tunnel_del	= udp_tunnel_nic_del_port,
 	.ndo_features_check	= enic_features_check,
 };
 
@@ -2552,8 +2518,8 @@ static const struct net_device_ops enic_netdev_ops = {
 #ifdef CONFIG_RFS_ACCEL
 	.ndo_rx_flow_steer	= enic_rx_flow_steer,
 #endif
-	.ndo_udp_tunnel_add	= enic_udp_tunnel_add,
-	.ndo_udp_tunnel_del	= enic_udp_tunnel_del,
+	.ndo_udp_tunnel_add	= udp_tunnel_nic_add_port,
+	.ndo_udp_tunnel_del	= udp_tunnel_nic_del_port,
 	.ndo_features_check	= enic_features_check,
 };
 
@@ -2963,6 +2929,13 @@ static int enic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		patch_level = fls(patch_level);
 		patch_level = patch_level ? patch_level - 1 : 0;
 		enic->vxlan.patch_level = patch_level;
+
+		if (vnic_dev_get_res_count(enic->vdev, RES_TYPE_WQ) == 1 ||
+		    enic->vxlan.flags & ENIC_VXLAN_MULTI_WQ) {
+			netdev->udp_tunnel_nic_info = &enic_udp_tunnels_v4;
+			if (enic->vxlan.flags & ENIC_VXLAN_OUTER_IPV6)
+				netdev->udp_tunnel_nic_info = &enic_udp_tunnels;
+		}
 	}
 
 	netdev->features |= netdev->hw_features;
-- 
2.26.2

