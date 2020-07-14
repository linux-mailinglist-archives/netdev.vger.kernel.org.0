Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6846D21E48B
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 02:31:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727037AbgGNAbe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 20:31:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:44476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726934AbgGNAb0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Jul 2020 20:31:26 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2493F21582;
        Tue, 14 Jul 2020 00:31:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594686684;
        bh=5KhzHps90OZiW59uwgfQZrFRCK6z+iTQILci2HcCnGE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QWULv97Fnmrls5BBlcl2q0jj92T+Vod1LIl2zHzvNVhTKKM6W2ZD823otoJ9sUgWW
         FGjcqjBP8LJzcxczdV1IPmhf4FB5h7VNmmcFTkWw/BMntZJIoHDbCH1RdU6XukTOPA
         O8PM0JUdHga+4iyU8aF8n+FS8gOJ1pzNY3/+CqDU=
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
Subject: [PATCH net-next 06/12] cxgb4: convert to new udp_tunnel_nic infra
Date:   Mon, 13 Jul 2020 17:30:31 -0700
Message-Id: <20200714003037.669012-7-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200714003037.669012-1-kuba@kernel.org>
References: <20200714003037.669012-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert to new infra, this driver is very simple. The check of
adapter->rawf_cnt in cxgb_udp_tunnel_unset_port() is kept from
the old port deletion function but it's dodgy since nothing ever
updates that member once its set during init. Also .set_port
callback always adds the raw mac filter..

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h    |   2 -
 .../net/ethernet/chelsio/cxgb4/cxgb4_main.c   | 108 +++++-------------
 2 files changed, 31 insertions(+), 79 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h b/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
index ff53c78307c5..c59e9ccc2f18 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
@@ -1109,9 +1109,7 @@ struct adapter {
 
 	int msg_enable;
 	__be16 vxlan_port;
-	u8 vxlan_port_cnt;
 	__be16 geneve_port;
-	u8 geneve_port_cnt;
 
 	struct adapter_params params;
 	struct cxgb4_virt_res vres;
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index 0991631f3a91..de078a5bf23e 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -3732,129 +3732,71 @@ static int cxgb_setup_tc(struct net_device *dev, enum tc_setup_type type,
 	}
 }
 
-static void cxgb_del_udp_tunnel(struct net_device *netdev,
-				struct udp_tunnel_info *ti)
+static int cxgb_udp_tunnel_unset_port(struct net_device *netdev,
+				      unsigned int table, unsigned int entry,
+				      struct udp_tunnel_info *ti)
 {
 	struct port_info *pi = netdev_priv(netdev);
 	struct adapter *adapter = pi->adapter;
-	unsigned int chip_ver = CHELSIO_CHIP_VERSION(adapter->params.chip);
 	u8 match_all_mac[] = { 0, 0, 0, 0, 0, 0 };
 	int ret = 0, i;
 
-	if (chip_ver < CHELSIO_T6)
-		return;
-
 	switch (ti->type) {
 	case UDP_TUNNEL_TYPE_VXLAN:
-		if (!adapter->vxlan_port_cnt ||
-		    adapter->vxlan_port != ti->port)
-			return; /* Invalid VxLAN destination port */
-
-		adapter->vxlan_port_cnt--;
-		if (adapter->vxlan_port_cnt)
-			return;
-
 		adapter->vxlan_port = 0;
 		t4_write_reg(adapter, MPS_RX_VXLAN_TYPE_A, 0);
 		break;
 	case UDP_TUNNEL_TYPE_GENEVE:
-		if (!adapter->geneve_port_cnt ||
-		    adapter->geneve_port != ti->port)
-			return; /* Invalid GENEVE destination port */
-
-		adapter->geneve_port_cnt--;
-		if (adapter->geneve_port_cnt)
-			return;
-
 		adapter->geneve_port = 0;
 		t4_write_reg(adapter, MPS_RX_GENEVE_TYPE_A, 0);
 		break;
 	default:
-		return;
+		return -EINVAL;
 	}
 
 	/* Matchall mac entries can be deleted only after all tunnel ports
 	 * are brought down or removed.
 	 */
 	if (!adapter->rawf_cnt)
-		return;
+		return 0;
 	for_each_port(adapter, i) {
 		pi = adap2pinfo(adapter, i);
 		ret = t4_free_raw_mac_filt(adapter, pi->viid,
 					   match_all_mac, match_all_mac,
-					   adapter->rawf_start +
-					    pi->port_id,
+					   adapter->rawf_start + pi->port_id,
 					   1, pi->port_id, false);
 		if (ret < 0) {
 			netdev_info(netdev, "Failed to free mac filter entry, for port %d\n",
 				    i);
-			return;
+			return ret;
 		}
 	}
+
+	return 0;
 }
 
-static void cxgb_add_udp_tunnel(struct net_device *netdev,
-				struct udp_tunnel_info *ti)
+static int cxgb_udp_tunnel_set_port(struct net_device *netdev,
+				    unsigned int table, unsigned int entry,
+				    struct udp_tunnel_info *ti)
 {
 	struct port_info *pi = netdev_priv(netdev);
 	struct adapter *adapter = pi->adapter;
-	unsigned int chip_ver = CHELSIO_CHIP_VERSION(adapter->params.chip);
 	u8 match_all_mac[] = { 0, 0, 0, 0, 0, 0 };
 	int i, ret;
 
-	if (chip_ver < CHELSIO_T6 || !adapter->rawf_cnt)
-		return;
-
 	switch (ti->type) {
 	case UDP_TUNNEL_TYPE_VXLAN:
-		/* Callback for adding vxlan port can be called with the same
-		 * port for both IPv4 and IPv6. We should not disable the
-		 * offloading when the same port for both protocols is added
-		 * and later one of them is removed.
-		 */
-		if (adapter->vxlan_port_cnt &&
-		    adapter->vxlan_port == ti->port) {
-			adapter->vxlan_port_cnt++;
-			return;
-		}
-
-		/* We will support only one VxLAN port */
-		if (adapter->vxlan_port_cnt) {
-			netdev_info(netdev, "UDP port %d already offloaded, not adding port %d\n",
-				    be16_to_cpu(adapter->vxlan_port),
-				    be16_to_cpu(ti->port));
-			return;
-		}
-
 		adapter->vxlan_port = ti->port;
-		adapter->vxlan_port_cnt = 1;
-
 		t4_write_reg(adapter, MPS_RX_VXLAN_TYPE_A,
 			     VXLAN_V(be16_to_cpu(ti->port)) | VXLAN_EN_F);
 		break;
 	case UDP_TUNNEL_TYPE_GENEVE:
-		if (adapter->geneve_port_cnt &&
-		    adapter->geneve_port == ti->port) {
-			adapter->geneve_port_cnt++;
-			return;
-		}
-
-		/* We will support only one GENEVE port */
-		if (adapter->geneve_port_cnt) {
-			netdev_info(netdev, "UDP port %d already offloaded, not adding port %d\n",
-				    be16_to_cpu(adapter->geneve_port),
-				    be16_to_cpu(ti->port));
-			return;
-		}
-
 		adapter->geneve_port = ti->port;
-		adapter->geneve_port_cnt = 1;
-
 		t4_write_reg(adapter, MPS_RX_GENEVE_TYPE_A,
 			     GENEVE_V(be16_to_cpu(ti->port)) | GENEVE_EN_F);
 		break;
 	default:
-		return;
+		return -EINVAL;
 	}
 
 	/* Create a 'match all' mac filter entry for inner mac,
@@ -3869,18 +3811,27 @@ static void cxgb_add_udp_tunnel(struct net_device *netdev,
 		ret = t4_alloc_raw_mac_filt(adapter, pi->viid,
 					    match_all_mac,
 					    match_all_mac,
-					    adapter->rawf_start +
-					    pi->port_id,
+					    adapter->rawf_start + pi->port_id,
 					    1, pi->port_id, false);
 		if (ret < 0) {
 			netdev_info(netdev, "Failed to allocate a mac filter entry, not adding port %d\n",
 				    be16_to_cpu(ti->port));
-			cxgb_del_udp_tunnel(netdev, ti);
-			return;
+			return ret;
 		}
 	}
+
+	return 0;
 }
 
+static const struct udp_tunnel_nic_info cxgb_udp_tunnels = {
+	.set_port	= cxgb_udp_tunnel_set_port,
+	.unset_port	= cxgb_udp_tunnel_unset_port,
+	.tables		= {
+		{ .n_entries = 1, .tunnel_types = UDP_TUNNEL_TYPE_VXLAN,  },
+		{ .n_entries = 1, .tunnel_types = UDP_TUNNEL_TYPE_GENEVE, },
+	},
+};
+
 static netdev_features_t cxgb_features_check(struct sk_buff *skb,
 					     struct net_device *dev,
 					     netdev_features_t features)
@@ -3930,8 +3881,8 @@ static const struct net_device_ops cxgb4_netdev_ops = {
 #endif /* CONFIG_CHELSIO_T4_FCOE */
 	.ndo_set_tx_maxrate   = cxgb_set_tx_maxrate,
 	.ndo_setup_tc         = cxgb_setup_tc,
-	.ndo_udp_tunnel_add   = cxgb_add_udp_tunnel,
-	.ndo_udp_tunnel_del   = cxgb_del_udp_tunnel,
+	.ndo_udp_tunnel_add   = udp_tunnel_nic_add_port,
+	.ndo_udp_tunnel_del   = udp_tunnel_nic_del_port,
 	.ndo_features_check   = cxgb_features_check,
 	.ndo_fix_features     = cxgb_fix_features,
 };
@@ -6761,6 +6712,9 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 			netdev->hw_features |= NETIF_F_GSO_UDP_TUNNEL |
 					       NETIF_F_GSO_UDP_TUNNEL_CSUM |
 					       NETIF_F_HW_TLS_RECORD;
+
+			if (adapter->rawf_cnt)
+				netdev->udp_tunnel_nic_info = &cxgb_udp_tunnels;
 		}
 
 		if (highdma)
-- 
2.26.2

