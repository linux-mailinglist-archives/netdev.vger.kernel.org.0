Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 546F670B9F
	for <lists+netdev@lfdr.de>; Mon, 22 Jul 2019 23:40:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732790AbfGVVkk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 17:40:40 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:33339 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732740AbfGVVkj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jul 2019 17:40:39 -0400
Received: by mail-pg1-f194.google.com with SMTP id f20so9050905pgj.0
        for <netdev@vger.kernel.org>; Mon, 22 Jul 2019 14:40:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=kl1ID+eHLcCjLCcHkvwIWrSpCpVEa2rfjVNRXTNTRRY=;
        b=JkFl2LXMRdMbV8MD6EHq7tnJgx+jsECbTV7azne8gqgVEyB2cH9FKihjxye/nmCiOu
         Mkw7mW9/LPDHBRXoIZqIdSvqjP4wbt35EOj9C4MKYNLCVuHAFBqD9a+fZ8a+liHxN7te
         YigQ042HdengaY3DJYg3uxYejQrsIzT7OD0gFKg3fOtrRjToqBfXMgsq475OSct+ORU3
         TEkBlDsC+gl8n6tr0ur35ZaMDlHx5qMo16E2kKFl9HFkjlF0rhrLebIqUdf425ceQ5E0
         1yPmSze6gwwuAfnIU1iRtNMR4+suowEz1xdLE/fOOstX0yp4QAguvtuU6dN4VOyfXRaY
         rEfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=kl1ID+eHLcCjLCcHkvwIWrSpCpVEa2rfjVNRXTNTRRY=;
        b=VKf+DLT1nTSel26pot3IqwMZNtLj7s7XMytns+a+F1ZjvrpyB6NXihzTWEe8kKWrhF
         Rzf6Iu5Cbh1n6reK1EQ4O7KRQz7xJu5YJi5VvYFeXzcHKkw6V068Zl0654xH6EUjuCNf
         pPkroTV6z7SFrqxbzhkrvevEa7jBdyMCimgKNyFdjOhJl+W9q/eay4wwR/9yiEtLkezN
         6B8FXIhcF0ODyc9VvUbl/tNo4lG6Gx0/oR9a6zAwiRxtFIDERelNXIQ0MeMzd9wNwrdZ
         G+w5wHXMyPsH5fcYMsIrY1GLSvnttxTfqBdP65uLek7ZLaBr/PD21ObWtY7uADBSBQzl
         aipw==
X-Gm-Message-State: APjAAAXCMuCz/sHIY756MmigwJrKYLnFq5e9ULcaMMPGc8tiCHGGvMyk
        fZcJZRUcCD2e85w3H6X32GDdXJpKKQphNg==
X-Google-Smtp-Source: APXvYqwxyFGXois1/pilX7uERGNgxbycgESVG1JZ4vaNnRdG7Uj4FiP3VIofSwK7G02GcncsALWjQg==
X-Received: by 2002:a17:90b:28f:: with SMTP id az15mr77946379pjb.18.1563831638282;
        Mon, 22 Jul 2019 14:40:38 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id p65sm40593714pfp.58.2019.07.22.14.40.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 22 Jul 2019 14:40:37 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     snelson@pensando.io, netdev@vger.kernel.org, davem@davemloft.net
Subject: [PATCH v4 net-next 09/19] ionic: Add the basic NDO callbacks for netdev support
Date:   Mon, 22 Jul 2019 14:40:13 -0700
Message-Id: <20190722214023.9513-10-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190722214023.9513-1-snelson@pensando.io>
References: <20190722214023.9513-1-snelson@pensando.io>
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
 .../ethernet/pensando/ionic/ionic_bus_pci.c   |   9 +
 .../net/ethernet/pensando/ionic/ionic_dev.h   |   2 +
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 348 ++++++++++++++++++
 .../net/ethernet/pensando/ionic/ionic_lif.h   |   5 +
 5 files changed, 365 insertions(+)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic.h b/drivers/net/ethernet/pensando/ionic/ionic.h
index 87ab13aee89e..d7eee79b2a10 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic.h
@@ -34,6 +34,7 @@ struct ionic {
 	unsigned int num_bars;
 	struct identity ident;
 	struct list_head lifs;
+	struct lif *master_lif;
 	unsigned int nnqs_per_lif;
 	unsigned int neqs_per_lif;
 	unsigned int ntxqs_per_lif;
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
index 59d1ae7ce532..98c12b770c7f 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
@@ -206,8 +206,16 @@ static int ionic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto err_out_free_lifs;
 	}
 
+	err = ionic_lifs_register(ionic);
+	if (err) {
+		dev_err(dev, "Cannot register LIFs: %d, aborting\n", err);
+		goto err_out_deinit_lifs;
+	}
+
 	return 0;
 
+err_out_deinit_lifs:
+	ionic_lifs_deinit(ionic);
 err_out_free_lifs:
 	ionic_lifs_free(ionic);
 err_out_free_irqs:
@@ -239,6 +247,7 @@ static void ionic_remove(struct pci_dev *pdev)
 	struct ionic *ionic = pci_get_drvdata(pdev);
 
 	if (ionic) {
+		ionic_lifs_unregister(ionic);
 		ionic_lifs_deinit(ionic);
 		ionic_lifs_free(ionic);
 		ionic_bus_free_irq_vectors(ionic);
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.h b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
index 8bd1501dd639..523927566925 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
@@ -10,6 +10,8 @@
 #include "ionic_if.h"
 #include "ionic_regs.h"
 
+#define IONIC_MIN_MTU			ETH_MIN_MTU
+#define IONIC_MAX_MTU			9194
 #define IONIC_LIFS_MAX			1024
 
 struct ionic_dev_bar {
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 01f9665611d4..005b1d908fa1 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -12,8 +12,74 @@
 #include "ionic_lif.h"
 #include "ionic_debugfs.h"
 
+static int ionic_set_nic_features(struct lif *lif, netdev_features_t features);
 static int ionic_notifyq_clean(struct lif *lif, int budget);
 
+int ionic_open(struct net_device *netdev)
+{
+	struct lif *lif = netdev_priv(netdev);
+
+	netif_carrier_off(netdev);
+
+	set_bit(LIF_UP, lif->state);
+
+	if (netif_carrier_ok(netdev))
+		netif_tx_wake_all_queues(netdev);
+
+	return 0;
+}
+
+static int ionic_lif_stop(struct lif *lif)
+{
+	struct net_device *ndev = lif->netdev;
+	int err = 0;
+
+	if (!test_bit(LIF_UP, lif->state)) {
+		dev_dbg(lif->ionic->dev, "%s: %s state=DOWN\n",
+			__func__, lif->name);
+		return 0;
+	}
+	dev_dbg(lif->ionic->dev, "%s: %s state=UP\n", __func__, lif->name);
+	clear_bit(LIF_UP, lif->state);
+
+	/* carrier off before disabling queues to avoid watchdog timeout */
+	netif_carrier_off(ndev);
+	netif_tx_stop_all_queues(ndev);
+	netif_tx_disable(ndev);
+	synchronize_rcu();
+
+	return err;
+}
+
+int ionic_stop(struct net_device *netdev)
+{
+	struct lif *lif = netdev_priv(netdev);
+
+	return ionic_lif_stop(lif);
+}
+
+int ionic_reset_queues(struct lif *lif)
+{
+	bool running;
+	int err = 0;
+
+	/* Put off the next watchdog timeout */
+	netif_trans_update(lif->netdev);
+
+	while (test_and_set_bit(LIF_QUEUE_RESET, lif->state))
+		usleep_range(100, 200);
+
+	running = netif_running(lif->netdev);
+	if (running)
+		err = ionic_stop(lif->netdev);
+	if (!err && running)
+		ionic_open(lif->netdev);
+
+	clear_bit(LIF_QUEUE_RESET, lif->state);
+
+	return err;
+}
+
 static bool ionic_adminq_service(struct cq *cq, struct cq_info *cq_info)
 {
 	struct admin_comp *comp = cq_info->cq_desc;
@@ -114,6 +180,81 @@ static int ionic_notifyq_clean(struct lif *lif, int budget)
 	return work_done;
 }
 
+static int ionic_set_features(struct net_device *netdev,
+			      netdev_features_t features)
+{
+	struct lif *lif = netdev_priv(netdev);
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
+	struct lif *lif = netdev_priv(netdev);
+	struct ionic_admin_ctx ctx = {
+		.work = COMPLETION_INITIALIZER_ONSTACK(ctx.work),
+		.cmd.lif_setattr = {
+			.opcode = CMD_OPCODE_LIF_SETATTR,
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
 static irqreturn_t ionic_isr(int irq, void *data)
 {
 	struct napi_struct *napi = data;
@@ -388,6 +529,12 @@ static struct lif *ionic_lif_alloc(struct ionic *ionic, unsigned int index)
 
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
@@ -655,6 +802,177 @@ static int ionic_lif_notifyq_init(struct lif *lif)
 	return 0;
 }
 
+static __le64 ionic_netdev_features_to_nic(netdev_features_t features)
+{
+	u64 wanted = 0;
+
+	if (features & NETIF_F_HW_VLAN_CTAG_TX)
+		wanted |= ETH_HW_VLAN_TX_TAG;
+	if (features & NETIF_F_HW_VLAN_CTAG_RX)
+		wanted |= ETH_HW_VLAN_RX_STRIP;
+	if (features & NETIF_F_HW_VLAN_CTAG_FILTER)
+		wanted |= ETH_HW_VLAN_RX_FILTER;
+	if (features & NETIF_F_RXHASH)
+		wanted |= ETH_HW_RX_HASH;
+	if (features & NETIF_F_RXCSUM)
+		wanted |= ETH_HW_RX_CSUM;
+	if (features & NETIF_F_SG)
+		wanted |= ETH_HW_TX_SG;
+	if (features & NETIF_F_HW_CSUM)
+		wanted |= ETH_HW_TX_CSUM;
+	if (features & NETIF_F_TSO)
+		wanted |= ETH_HW_TSO;
+	if (features & NETIF_F_TSO6)
+		wanted |= ETH_HW_TSO_IPV6;
+	if (features & NETIF_F_TSO_ECN)
+		wanted |= ETH_HW_TSO_ECN;
+	if (features & NETIF_F_GSO_GRE)
+		wanted |= ETH_HW_TSO_GRE;
+	if (features & NETIF_F_GSO_GRE_CSUM)
+		wanted |= ETH_HW_TSO_GRE_CSUM;
+	if (features & NETIF_F_GSO_IPXIP4)
+		wanted |= ETH_HW_TSO_IPXIP4;
+	if (features & NETIF_F_GSO_IPXIP6)
+		wanted |= ETH_HW_TSO_IPXIP6;
+	if (features & NETIF_F_GSO_UDP_TUNNEL)
+		wanted |= ETH_HW_TSO_UDP;
+	if (features & NETIF_F_GSO_UDP_TUNNEL_CSUM)
+		wanted |= ETH_HW_TSO_UDP_CSUM;
+
+	return cpu_to_le64(wanted);
+}
+
+static int ionic_set_nic_features(struct lif *lif, netdev_features_t features)
+{
+	struct device *dev = lif->ionic->dev;
+	struct ionic_admin_ctx ctx = {
+		.work = COMPLETION_INITIALIZER_ONSTACK(ctx.work),
+		.cmd.lif_setattr = {
+			.opcode = CMD_OPCODE_LIF_SETATTR,
+			.index = cpu_to_le16(lif->index),
+			.attr = IONIC_LIF_ATTR_FEATURES,
+		},
+	};
+	u64 vlan_flags = ETH_HW_VLAN_TX_TAG |
+			 ETH_HW_VLAN_RX_STRIP |
+			 ETH_HW_VLAN_RX_FILTER;
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
+	if (lif->hw_features & ETH_HW_VLAN_TX_TAG)
+		dev_dbg(dev, "feature ETH_HW_VLAN_TX_TAG\n");
+	if (lif->hw_features & ETH_HW_VLAN_RX_STRIP)
+		dev_dbg(dev, "feature ETH_HW_VLAN_RX_STRIP\n");
+	if (lif->hw_features & ETH_HW_VLAN_RX_FILTER)
+		dev_dbg(dev, "feature ETH_HW_VLAN_RX_FILTER\n");
+	if (lif->hw_features & ETH_HW_RX_HASH)
+		dev_dbg(dev, "feature ETH_HW_RX_HASH\n");
+	if (lif->hw_features & ETH_HW_TX_SG)
+		dev_dbg(dev, "feature ETH_HW_TX_SG\n");
+	if (lif->hw_features & ETH_HW_TX_CSUM)
+		dev_dbg(dev, "feature ETH_HW_TX_CSUM\n");
+	if (lif->hw_features & ETH_HW_RX_CSUM)
+		dev_dbg(dev, "feature ETH_HW_RX_CSUM\n");
+	if (lif->hw_features & ETH_HW_TSO)
+		dev_dbg(dev, "feature ETH_HW_TSO\n");
+	if (lif->hw_features & ETH_HW_TSO_IPV6)
+		dev_dbg(dev, "feature ETH_HW_TSO_IPV6\n");
+	if (lif->hw_features & ETH_HW_TSO_ECN)
+		dev_dbg(dev, "feature ETH_HW_TSO_ECN\n");
+	if (lif->hw_features & ETH_HW_TSO_GRE)
+		dev_dbg(dev, "feature ETH_HW_TSO_GRE\n");
+	if (lif->hw_features & ETH_HW_TSO_GRE_CSUM)
+		dev_dbg(dev, "feature ETH_HW_TSO_GRE_CSUM\n");
+	if (lif->hw_features & ETH_HW_TSO_IPXIP4)
+		dev_dbg(dev, "feature ETH_HW_TSO_IPXIP4\n");
+	if (lif->hw_features & ETH_HW_TSO_IPXIP6)
+		dev_dbg(dev, "feature ETH_HW_TSO_IPXIP6\n");
+	if (lif->hw_features & ETH_HW_TSO_UDP)
+		dev_dbg(dev, "feature ETH_HW_TSO_UDP\n");
+	if (lif->hw_features & ETH_HW_TSO_UDP_CSUM)
+		dev_dbg(dev, "feature ETH_HW_TSO_UDP_CSUM\n");
+
+	return 0;
+}
+
+static int ionic_init_nic_features(struct lif *lif)
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
+	if (lif->hw_features & ETH_HW_VLAN_TX_TAG)
+		netdev->hw_features |= NETIF_F_HW_VLAN_CTAG_TX;
+	if (lif->hw_features & ETH_HW_VLAN_RX_STRIP)
+		netdev->hw_features |= NETIF_F_HW_VLAN_CTAG_RX;
+	if (lif->hw_features & ETH_HW_VLAN_RX_FILTER)
+		netdev->hw_features |= NETIF_F_HW_VLAN_CTAG_FILTER;
+	if (lif->hw_features & ETH_HW_RX_HASH)
+		netdev->hw_features |= NETIF_F_RXHASH;
+	if (lif->hw_features & ETH_HW_TX_SG)
+		netdev->hw_features |= NETIF_F_SG;
+
+	if (lif->hw_features & ETH_HW_TX_CSUM)
+		netdev->hw_enc_features |= NETIF_F_HW_CSUM;
+	if (lif->hw_features & ETH_HW_RX_CSUM)
+		netdev->hw_enc_features |= NETIF_F_RXCSUM;
+	if (lif->hw_features & ETH_HW_TSO)
+		netdev->hw_enc_features |= NETIF_F_TSO;
+	if (lif->hw_features & ETH_HW_TSO_IPV6)
+		netdev->hw_enc_features |= NETIF_F_TSO6;
+	if (lif->hw_features & ETH_HW_TSO_ECN)
+		netdev->hw_enc_features |= NETIF_F_TSO_ECN;
+	if (lif->hw_features & ETH_HW_TSO_GRE)
+		netdev->hw_enc_features |= NETIF_F_GSO_GRE;
+	if (lif->hw_features & ETH_HW_TSO_GRE_CSUM)
+		netdev->hw_enc_features |= NETIF_F_GSO_GRE_CSUM;
+	if (lif->hw_features & ETH_HW_TSO_IPXIP4)
+		netdev->hw_enc_features |= NETIF_F_GSO_IPXIP4;
+	if (lif->hw_features & ETH_HW_TSO_IPXIP6)
+		netdev->hw_enc_features |= NETIF_F_GSO_IPXIP6;
+	if (lif->hw_features & ETH_HW_TSO_UDP)
+		netdev->hw_enc_features |= NETIF_F_GSO_UDP_TUNNEL;
+	if (lif->hw_features & ETH_HW_TSO_UDP_CSUM)
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
 static int ionic_lif_init(struct lif *lif)
 {
 	struct ionic_dev *idev = &lif->ionic->idev;
@@ -711,6 +1029,10 @@ static int ionic_lif_init(struct lif *lif)
 			goto err_out_notifyq_deinit;
 	}
 
+	err = ionic_init_nic_features(lif);
+	if (err)
+		goto err_out_notifyq_deinit;
+
 	set_bit(LIF_INITED, lif->state);
 
 	return 0;
@@ -745,6 +1067,32 @@ int ionic_lifs_init(struct ionic *ionic)
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
 		       union lif_identity *lid)
 {
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.h b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
index 80eec0778f40..ef3f7340a277 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
@@ -61,6 +61,8 @@ struct qcq {
 
 enum lif_state_flags {
 	LIF_INITED,
+	LIF_UP,
+	LIF_QUEUE_RESET,
 
 	/* leave this as last */
 	LIF_STATE_SIZE
@@ -84,6 +86,7 @@ struct lif {
 	u64 last_eid;
 	unsigned int neqs;
 	unsigned int nxqs;
+	u64 hw_features;
 
 	struct lif_info *info;
 	dma_addr_t info_pa;
@@ -124,6 +127,8 @@ int ionic_lifs_alloc(struct ionic *ionic);
 void ionic_lifs_free(struct ionic *ionic);
 void ionic_lifs_deinit(struct ionic *ionic);
 int ionic_lifs_init(struct ionic *ionic);
+int ionic_lifs_register(struct ionic *ionic);
+void ionic_lifs_unregister(struct ionic *ionic);
 int ionic_lif_identify(struct ionic *ionic, u8 lif_type,
 		       union lif_identity *lif_ident);
 int ionic_lifs_size(struct ionic *ionic);
-- 
2.17.1

