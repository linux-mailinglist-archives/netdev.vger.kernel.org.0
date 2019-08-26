Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FEF39D882
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 23:34:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729197AbfHZVeD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 17:34:03 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:38297 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729167AbfHZVeA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Aug 2019 17:34:00 -0400
Received: by mail-pg1-f194.google.com with SMTP id e11so11360244pga.5
        for <netdev@vger.kernel.org>; Mon, 26 Aug 2019 14:33:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=S9PCezNjZmg9ubw88G02+dHx6qDDW1Px8okzDz+UK9k=;
        b=1mK8y3CWtCQAw6CV8DFPW5V+e13R1VD/ed9Us9aSzuUuphetJ5ahXwt7A0UIZABHYX
         516puUVkAjz4unuv7woWl7aDNOvZNs1HYOJNyz9tNLyejvd6T2yup9JaDp67cBWH5KAU
         6OdVKD90ZCShHVt4SWGjnEImrG7g2y/yhjHpyzBfxtuFUndgHaq6idMsiaWfU+KrjAbG
         Ur/cu5Yq87hXnb8AcT96avXMGUGBKd6IRbp0Mz4RO5w+6z1BEgk4RqtSM8UlL/Jhe5Lg
         tro2WvQrSBefTDp9DFpTgFp8HfD6gGOM2t5MbYYKBrZqXTzj1Ot5GmYith3HwdCyqQbM
         WuJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=S9PCezNjZmg9ubw88G02+dHx6qDDW1Px8okzDz+UK9k=;
        b=eaY2oMakJhOXU83kvX9IE01nqAho0zOIGnUGpdUt311wDGq67qtAlBackTQv/MEWC7
         l2JJia6TDetat6SU49w7EX1ipOB/YF3nhwOne08RGtbmVaAR/Pwkdy9+3D3Kzi587YIL
         bX58A33IgPuIAfX2lskwjdYy4kI7jFIeyI1Vj5fOxycq5kGvVyXC1z91BcDWqLCN+UYf
         Ea3RB2KBt0xk2f8g+YI2RQIL8ZW8mdq0Bk2rwD+ZPLA2ign7uqGyq8U4Aic2kzrrkwLu
         OAozo5bURSiDK9r7cugmF9MrEjwaLCsZUF+pHwvRdlMcDGpNJRJkScT6pDwjCX66kp0P
         vpbQ==
X-Gm-Message-State: APjAAAXlatA6W8DQK9++xjWcINxMUlAO8Krj/e0HiPEIrmlpbifEMYbi
        ejsmmFri7a5iX67iK3umSeNXcQ==
X-Google-Smtp-Source: APXvYqwGv5U094fcsCgftmHEne7YSBGO1hsnSmi0Z9J20m7f6GREaKmYrXQE7ElHTxj9l1Kpv4FpTw==
X-Received: by 2002:a62:f247:: with SMTP id y7mr22471593pfl.236.1566855239129;
        Mon, 26 Aug 2019 14:33:59 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id j9sm5876905pfi.128.2019.08.26.14.33.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Aug 2019 14:33:58 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     snelson@pensando.io, netdev@vger.kernel.org, davem@davemloft.net
Subject: [PATCH v5 net-next 09/18] ionic: Add the basic NDO callbacks for netdev support
Date:   Mon, 26 Aug 2019 14:33:30 -0700
Message-Id: <20190826213339.56909-10-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190826213339.56909-1-snelson@pensando.io>
References: <20190826213339.56909-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Set up the initial NDO structure and callbacks for netdev
to use, and register the netdev.  This will allow us to do
a few basic operations on the device, but no traffic yet.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic.h   |   1 +
 .../ethernet/pensando/ionic/ionic_bus_pci.c   |  15 +-
 .../net/ethernet/pensando/ionic/ionic_dev.h   |   2 +
 .../ethernet/pensando/ionic/ionic_devlink.c   |  15 +-
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 335 ++++++++++++++++++
 .../net/ethernet/pensando/ionic/ionic_lif.h   |  20 ++
 6 files changed, 386 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic.h b/drivers/net/ethernet/pensando/ionic/ionic.h
index 5a705233449a..82b45e3384c3 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic.h
@@ -37,6 +37,7 @@ struct ionic {
 	unsigned int num_bars;
 	struct ionic_identity ident;
 	struct list_head lifs;
+	struct ionic_lif *master_lif;
 	unsigned int nnqs_per_lif;
 	unsigned int neqs_per_lif;
 	unsigned int ntxqs_per_lif;
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
index 7b6190b96a46..9a9ab8cb2cb3 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
@@ -206,12 +206,24 @@ static int ionic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto err_out_free_lifs;
 	}
 
+	err = ionic_lifs_register(ionic);
+	if (err) {
+		dev_err(dev, "Cannot register LIFs: %d, aborting\n", err);
+		goto err_out_deinit_lifs;
+	}
+
 	err = ionic_devlink_register(ionic);
-	if (err)
+	if (err) {
 		dev_err(dev, "Cannot register devlink: %d\n", err);
+		goto err_out_deregister_lifs;
+	}
 
 	return 0;
 
+err_out_deregister_lifs:
+	ionic_lifs_unregister(ionic);
+err_out_deinit_lifs:
+	ionic_lifs_deinit(ionic);
 err_out_free_lifs:
 	ionic_lifs_free(ionic);
 err_out_free_irqs:
@@ -246,6 +258,7 @@ static void ionic_remove(struct pci_dev *pdev)
 		return;
 
 	ionic_devlink_unregister(ionic);
+	ionic_lifs_unregister(ionic);
 	ionic_lifs_deinit(ionic);
 	ionic_lifs_free(ionic);
 	ionic_bus_free_irq_vectors(ionic);
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.h b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
index d7bc6f1f6019..f6cce42f0228 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
@@ -10,6 +10,8 @@
 #include "ionic_if.h"
 #include "ionic_regs.h"
 
+#define IONIC_MIN_MTU			ETH_MIN_MTU
+#define IONIC_MAX_MTU			9194
 #define IONIC_LIFS_MAX			1024
 
 struct ionic_dev_bar {
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_devlink.c b/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
index 1ca1e33cca04..a93df132f17b 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
@@ -6,6 +6,7 @@
 
 #include "ionic.h"
 #include "ionic_bus.h"
+#include "ionic_lif.h"
 #include "ionic_devlink.h"
 
 static int ionic_dl_info_get(struct devlink *dl, struct devlink_info_req *req,
@@ -67,8 +68,19 @@ int ionic_devlink_register(struct ionic *ionic)
 	int err;
 
 	err = devlink_register(ionic->dl, ionic->dev);
-	if (err)
+	if (err) {
 		dev_warn(ionic->dev, "devlink_register failed: %d\n", err);
+		return err;
+	}
+
+	devlink_port_attrs_set(&ionic->dl_port, DEVLINK_PORT_FLAVOUR_PHYSICAL,
+			       0, false, 0, NULL, 0);
+	err = devlink_port_register(ionic->dl, &ionic->dl_port, 0);
+	if (err)
+		dev_err(ionic->dev, "devlink_port_register failed: %d\n", err);
+	else
+		devlink_port_type_eth_set(&ionic->dl_port,
+					  ionic->master_lif->netdev);
 
 	return err;
 }
@@ -78,5 +90,6 @@ void ionic_devlink_unregister(struct ionic *ionic)
 	if (!ionic || !ionic->dl)
 		return;
 
+	devlink_port_unregister(&ionic->dl_port);
 	devlink_unregister(ionic->dl);
 }
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 56831fb7b3e3..f1c152dd4559 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -400,6 +400,305 @@ static int ionic_adminq_napi(struct napi_struct *napi, int budget)
 	return max(n_work, a_work);
 }
 
+static __le64 ionic_netdev_features_to_nic(netdev_features_t features)
+{
+	u64 wanted = 0;
+
+	if (features & NETIF_F_HW_VLAN_CTAG_TX)
+		wanted |= IONIC_ETH_HW_VLAN_TX_TAG;
+	if (features & NETIF_F_HW_VLAN_CTAG_RX)
+		wanted |= IONIC_ETH_HW_VLAN_RX_STRIP;
+	if (features & NETIF_F_HW_VLAN_CTAG_FILTER)
+		wanted |= IONIC_ETH_HW_VLAN_RX_FILTER;
+	if (features & NETIF_F_RXHASH)
+		wanted |= IONIC_ETH_HW_RX_HASH;
+	if (features & NETIF_F_RXCSUM)
+		wanted |= IONIC_ETH_HW_RX_CSUM;
+	if (features & NETIF_F_SG)
+		wanted |= IONIC_ETH_HW_TX_SG;
+	if (features & NETIF_F_HW_CSUM)
+		wanted |= IONIC_ETH_HW_TX_CSUM;
+	if (features & NETIF_F_TSO)
+		wanted |= IONIC_ETH_HW_TSO;
+	if (features & NETIF_F_TSO6)
+		wanted |= IONIC_ETH_HW_TSO_IPV6;
+	if (features & NETIF_F_TSO_ECN)
+		wanted |= IONIC_ETH_HW_TSO_ECN;
+	if (features & NETIF_F_GSO_GRE)
+		wanted |= IONIC_ETH_HW_TSO_GRE;
+	if (features & NETIF_F_GSO_GRE_CSUM)
+		wanted |= IONIC_ETH_HW_TSO_GRE_CSUM;
+	if (features & NETIF_F_GSO_IPXIP4)
+		wanted |= IONIC_ETH_HW_TSO_IPXIP4;
+	if (features & NETIF_F_GSO_IPXIP6)
+		wanted |= IONIC_ETH_HW_TSO_IPXIP6;
+	if (features & NETIF_F_GSO_UDP_TUNNEL)
+		wanted |= IONIC_ETH_HW_TSO_UDP;
+	if (features & NETIF_F_GSO_UDP_TUNNEL_CSUM)
+		wanted |= IONIC_ETH_HW_TSO_UDP_CSUM;
+
+	return cpu_to_le64(wanted);
+}
+
+static int ionic_set_nic_features(struct ionic_lif *lif,
+				  netdev_features_t features)
+{
+	struct device *dev = lif->ionic->dev;
+	struct ionic_admin_ctx ctx = {
+		.work = COMPLETION_INITIALIZER_ONSTACK(ctx.work),
+		.cmd.lif_setattr = {
+			.opcode = IONIC_CMD_LIF_SETATTR,
+			.index = cpu_to_le16(lif->index),
+			.attr = IONIC_LIF_ATTR_FEATURES,
+		},
+	};
+	u64 vlan_flags = IONIC_ETH_HW_VLAN_TX_TAG |
+			 IONIC_ETH_HW_VLAN_RX_STRIP |
+			 IONIC_ETH_HW_VLAN_RX_FILTER;
+	int err;
+
+	ctx.cmd.lif_setattr.features = ionic_netdev_features_to_nic(features);
+	err = ionic_adminq_post_wait(lif, &ctx);
+	if (err)
+		return err;
+
+	lif->hw_features = le64_to_cpu(ctx.cmd.lif_setattr.features &
+				       ctx.comp.lif_setattr.features);
+
+	if ((vlan_flags & features) &&
+	    !(vlan_flags & le64_to_cpu(ctx.comp.lif_setattr.features)))
+		dev_info_once(lif->ionic->dev, "NIC is not supporting vlan offload, likely in SmartNIC mode\n");
+
+	if (lif->hw_features & IONIC_ETH_HW_VLAN_TX_TAG)
+		dev_dbg(dev, "feature ETH_HW_VLAN_TX_TAG\n");
+	if (lif->hw_features & IONIC_ETH_HW_VLAN_RX_STRIP)
+		dev_dbg(dev, "feature ETH_HW_VLAN_RX_STRIP\n");
+	if (lif->hw_features & IONIC_ETH_HW_VLAN_RX_FILTER)
+		dev_dbg(dev, "feature ETH_HW_VLAN_RX_FILTER\n");
+	if (lif->hw_features & IONIC_ETH_HW_RX_HASH)
+		dev_dbg(dev, "feature ETH_HW_RX_HASH\n");
+	if (lif->hw_features & IONIC_ETH_HW_TX_SG)
+		dev_dbg(dev, "feature ETH_HW_TX_SG\n");
+	if (lif->hw_features & IONIC_ETH_HW_TX_CSUM)
+		dev_dbg(dev, "feature ETH_HW_TX_CSUM\n");
+	if (lif->hw_features & IONIC_ETH_HW_RX_CSUM)
+		dev_dbg(dev, "feature ETH_HW_RX_CSUM\n");
+	if (lif->hw_features & IONIC_ETH_HW_TSO)
+		dev_dbg(dev, "feature ETH_HW_TSO\n");
+	if (lif->hw_features & IONIC_ETH_HW_TSO_IPV6)
+		dev_dbg(dev, "feature ETH_HW_TSO_IPV6\n");
+	if (lif->hw_features & IONIC_ETH_HW_TSO_ECN)
+		dev_dbg(dev, "feature ETH_HW_TSO_ECN\n");
+	if (lif->hw_features & IONIC_ETH_HW_TSO_GRE)
+		dev_dbg(dev, "feature ETH_HW_TSO_GRE\n");
+	if (lif->hw_features & IONIC_ETH_HW_TSO_GRE_CSUM)
+		dev_dbg(dev, "feature ETH_HW_TSO_GRE_CSUM\n");
+	if (lif->hw_features & IONIC_ETH_HW_TSO_IPXIP4)
+		dev_dbg(dev, "feature ETH_HW_TSO_IPXIP4\n");
+	if (lif->hw_features & IONIC_ETH_HW_TSO_IPXIP6)
+		dev_dbg(dev, "feature ETH_HW_TSO_IPXIP6\n");
+	if (lif->hw_features & IONIC_ETH_HW_TSO_UDP)
+		dev_dbg(dev, "feature ETH_HW_TSO_UDP\n");
+	if (lif->hw_features & IONIC_ETH_HW_TSO_UDP_CSUM)
+		dev_dbg(dev, "feature ETH_HW_TSO_UDP_CSUM\n");
+
+	return 0;
+}
+
+static int ionic_init_nic_features(struct ionic_lif *lif)
+{
+	struct net_device *netdev = lif->netdev;
+	netdev_features_t features;
+	int err;
+
+	/* set up what we expect to support by default */
+	features = NETIF_F_HW_VLAN_CTAG_TX |
+		   NETIF_F_HW_VLAN_CTAG_RX |
+		   NETIF_F_HW_VLAN_CTAG_FILTER |
+		   NETIF_F_RXHASH |
+		   NETIF_F_SG |
+		   NETIF_F_HW_CSUM |
+		   NETIF_F_RXCSUM |
+		   NETIF_F_TSO |
+		   NETIF_F_TSO6 |
+		   NETIF_F_TSO_ECN;
+
+	err = ionic_set_nic_features(lif, features);
+	if (err)
+		return err;
+
+	/* tell the netdev what we actually can support */
+	netdev->features |= NETIF_F_HIGHDMA;
+
+	if (lif->hw_features & IONIC_ETH_HW_VLAN_TX_TAG)
+		netdev->hw_features |= NETIF_F_HW_VLAN_CTAG_TX;
+	if (lif->hw_features & IONIC_ETH_HW_VLAN_RX_STRIP)
+		netdev->hw_features |= NETIF_F_HW_VLAN_CTAG_RX;
+	if (lif->hw_features & IONIC_ETH_HW_VLAN_RX_FILTER)
+		netdev->hw_features |= NETIF_F_HW_VLAN_CTAG_FILTER;
+	if (lif->hw_features & IONIC_ETH_HW_RX_HASH)
+		netdev->hw_features |= NETIF_F_RXHASH;
+	if (lif->hw_features & IONIC_ETH_HW_TX_SG)
+		netdev->hw_features |= NETIF_F_SG;
+
+	if (lif->hw_features & IONIC_ETH_HW_TX_CSUM)
+		netdev->hw_enc_features |= NETIF_F_HW_CSUM;
+	if (lif->hw_features & IONIC_ETH_HW_RX_CSUM)
+		netdev->hw_enc_features |= NETIF_F_RXCSUM;
+	if (lif->hw_features & IONIC_ETH_HW_TSO)
+		netdev->hw_enc_features |= NETIF_F_TSO;
+	if (lif->hw_features & IONIC_ETH_HW_TSO_IPV6)
+		netdev->hw_enc_features |= NETIF_F_TSO6;
+	if (lif->hw_features & IONIC_ETH_HW_TSO_ECN)
+		netdev->hw_enc_features |= NETIF_F_TSO_ECN;
+	if (lif->hw_features & IONIC_ETH_HW_TSO_GRE)
+		netdev->hw_enc_features |= NETIF_F_GSO_GRE;
+	if (lif->hw_features & IONIC_ETH_HW_TSO_GRE_CSUM)
+		netdev->hw_enc_features |= NETIF_F_GSO_GRE_CSUM;
+	if (lif->hw_features & IONIC_ETH_HW_TSO_IPXIP4)
+		netdev->hw_enc_features |= NETIF_F_GSO_IPXIP4;
+	if (lif->hw_features & IONIC_ETH_HW_TSO_IPXIP6)
+		netdev->hw_enc_features |= NETIF_F_GSO_IPXIP6;
+	if (lif->hw_features & IONIC_ETH_HW_TSO_UDP)
+		netdev->hw_enc_features |= NETIF_F_GSO_UDP_TUNNEL;
+	if (lif->hw_features & IONIC_ETH_HW_TSO_UDP_CSUM)
+		netdev->hw_enc_features |= NETIF_F_GSO_UDP_TUNNEL_CSUM;
+
+	netdev->hw_features |= netdev->hw_enc_features;
+	netdev->features |= netdev->hw_features;
+
+	netdev->priv_flags |= IFF_UNICAST_FLT;
+
+	return 0;
+}
+
+static int ionic_set_features(struct net_device *netdev,
+			      netdev_features_t features)
+{
+	struct ionic_lif *lif = netdev_priv(netdev);
+	int err;
+
+	netdev_dbg(netdev, "%s: lif->features=0x%08llx new_features=0x%08llx\n",
+		   __func__, (u64)lif->netdev->features, (u64)features);
+
+	err = ionic_set_nic_features(lif, features);
+
+	return err;
+}
+
+static int ionic_set_mac_address(struct net_device *netdev, void *sa)
+{
+	netdev_info(netdev, "%s: stubbed\n", __func__);
+	return 0;
+}
+
+static int ionic_change_mtu(struct net_device *netdev, int new_mtu)
+{
+	struct ionic_lif *lif = netdev_priv(netdev);
+	struct ionic_admin_ctx ctx = {
+		.work = COMPLETION_INITIALIZER_ONSTACK(ctx.work),
+		.cmd.lif_setattr = {
+			.opcode = IONIC_CMD_LIF_SETATTR,
+			.index = cpu_to_le16(lif->index),
+			.attr = IONIC_LIF_ATTR_MTU,
+			.mtu = cpu_to_le32(new_mtu),
+		},
+	};
+	int err;
+
+	err = ionic_adminq_post_wait(lif, &ctx);
+	if (err)
+		return err;
+
+	netdev->mtu = new_mtu;
+	err = ionic_reset_queues(lif);
+
+	return err;
+}
+
+static void ionic_tx_timeout(struct net_device *netdev)
+{
+	netdev_info(netdev, "%s: stubbed\n", __func__);
+}
+
+static int ionic_vlan_rx_add_vid(struct net_device *netdev, __be16 proto,
+				 u16 vid)
+{
+	netdev_info(netdev, "%s: stubbed\n", __func__);
+	return 0;
+}
+
+static int ionic_vlan_rx_kill_vid(struct net_device *netdev, __be16 proto,
+				  u16 vid)
+{
+	netdev_info(netdev, "%s: stubbed\n", __func__);
+	return 0;
+}
+
+int ionic_open(struct net_device *netdev)
+{
+	struct ionic_lif *lif = netdev_priv(netdev);
+
+	netif_carrier_off(netdev);
+
+	set_bit(IONIC_LIF_UP, lif->state);
+
+	return 0;
+}
+
+int ionic_stop(struct net_device *netdev)
+{
+	struct ionic_lif *lif = netdev_priv(netdev);
+	int err = 0;
+
+	if (!test_bit(IONIC_LIF_UP, lif->state)) {
+		dev_dbg(lif->ionic->dev, "%s: %s state=DOWN\n",
+			__func__, lif->name);
+		return 0;
+	}
+	dev_dbg(lif->ionic->dev, "%s: %s state=UP\n", __func__, lif->name);
+	clear_bit(IONIC_LIF_UP, lif->state);
+
+	/* carrier off before disabling queues to avoid watchdog timeout */
+	netif_carrier_off(netdev);
+
+	return err;
+}
+
+static const struct net_device_ops ionic_netdev_ops = {
+	.ndo_open               = ionic_open,
+	.ndo_stop               = ionic_stop,
+	.ndo_set_features	= ionic_set_features,
+	.ndo_set_mac_address	= ionic_set_mac_address,
+	.ndo_validate_addr	= eth_validate_addr,
+	.ndo_tx_timeout         = ionic_tx_timeout,
+	.ndo_change_mtu         = ionic_change_mtu,
+	.ndo_vlan_rx_add_vid    = ionic_vlan_rx_add_vid,
+	.ndo_vlan_rx_kill_vid   = ionic_vlan_rx_kill_vid,
+};
+
+int ionic_reset_queues(struct ionic_lif *lif)
+{
+	bool running;
+	int err = 0;
+
+	/* Put off the next watchdog timeout */
+	netif_trans_update(lif->netdev);
+
+	if (!ionic_wait_for_bit(lif, IONIC_LIF_QUEUE_RESET))
+		return -EBUSY;
+
+	running = netif_running(lif->netdev);
+	if (running)
+		err = ionic_stop(lif->netdev);
+	if (!err && running)
+		ionic_open(lif->netdev);
+
+	clear_bit(IONIC_LIF_QUEUE_RESET, lif->state);
+
+	return err;
+}
+
 static struct ionic_lif *ionic_lif_alloc(struct ionic *ionic, unsigned int index)
 {
 	struct device *dev = ionic->dev;
@@ -418,6 +717,12 @@ static struct ionic_lif *ionic_lif_alloc(struct ionic *ionic, unsigned int index
 
 	lif = netdev_priv(netdev);
 	lif->netdev = netdev;
+	ionic->master_lif = lif;
+	netdev->netdev_ops = &ionic_netdev_ops;
+
+	netdev->watchdog_timeo = 2 * HZ;
+	netdev->min_mtu = IONIC_MIN_MTU;
+	netdev->max_mtu = IONIC_MAX_MTU;
 
 	lif->neqs = ionic->neqs_per_lif;
 	lif->nxqs = ionic->ntxqs_per_lif;
@@ -701,6 +1006,10 @@ static int ionic_lif_init(struct ionic_lif *lif)
 			goto err_out_notifyq_deinit;
 	}
 
+	err = ionic_init_nic_features(lif);
+	if (err)
+		goto err_out_notifyq_deinit;
+
 	set_bit(IONIC_LIF_INITED, lif->state);
 
 	return 0;
@@ -735,6 +1044,32 @@ int ionic_lifs_init(struct ionic *ionic)
 	return 0;
 }
 
+int ionic_lifs_register(struct ionic *ionic)
+{
+	int err;
+
+	/* only register LIF0 for now */
+	err = register_netdev(ionic->master_lif->netdev);
+	if (err) {
+		dev_err(ionic->dev, "Cannot register net device, aborting\n");
+		return err;
+	}
+
+	ionic->master_lif->registered = true;
+
+	return 0;
+}
+
+void ionic_lifs_unregister(struct ionic *ionic)
+{
+	/* There is only one lif ever registered in the
+	 * current model, so don't bother searching the
+	 * ionic->lif for candidates to unregister
+	 */
+	if (ionic->master_lif->netdev->reg_state == NETREG_REGISTERED)
+		unregister_netdev(ionic->master_lif->netdev);
+}
+
 int ionic_lif_identify(struct ionic *ionic, u8 lif_type,
 		       union ionic_lif_identity *lid)
 {
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.h b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
index 397a4d388df1..866411a7a1fe 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
@@ -59,6 +59,8 @@ struct ionic_qcq {
 
 enum ionic_lif_state_flags {
 	IONIC_LIF_INITED,
+	IONIC_LIF_UP,
+	IONIC_LIF_QUEUE_RESET,
 
 	/* leave this as last */
 	IONIC_LIF_STATE_SIZE
@@ -82,6 +84,7 @@ struct ionic_lif {
 	u64 last_eid;
 	unsigned int neqs;
 	unsigned int nxqs;
+	u64 hw_features;
 
 	struct ionic_lif_info *info;
 	dma_addr_t info_pa;
@@ -93,6 +96,17 @@ struct ionic_lif {
 	u32 flags;
 };
 
+static inline int ionic_wait_for_bit(struct ionic_lif *lif, int bitname)
+{
+	unsigned long tlimit = jiffies + HZ;
+
+	while (test_and_set_bit(bitname, lif->state) &&
+	       time_before(jiffies, tlimit))
+		usleep_range(100, 200);
+
+	return test_bit(bitname, lif->state);
+}
+
 static inline bool ionic_is_pf(struct ionic *ionic)
 {
 	return ionic->pdev &&
@@ -122,10 +136,16 @@ int ionic_lifs_alloc(struct ionic *ionic);
 void ionic_lifs_free(struct ionic *ionic);
 void ionic_lifs_deinit(struct ionic *ionic);
 int ionic_lifs_init(struct ionic *ionic);
+int ionic_lifs_register(struct ionic *ionic);
+void ionic_lifs_unregister(struct ionic *ionic);
 int ionic_lif_identify(struct ionic *ionic, u8 lif_type,
 		       union ionic_lif_identity *lif_ident);
 int ionic_lifs_size(struct ionic *ionic);
 
+int ionic_open(struct net_device *netdev);
+int ionic_stop(struct net_device *netdev);
+int ionic_reset_queues(struct ionic_lif *lif);
+
 static inline void debug_stats_napi_poll(struct ionic_qcq *qcq,
 					 unsigned int work_done)
 {
-- 
2.17.1

