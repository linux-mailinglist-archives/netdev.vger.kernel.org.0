Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E33717CA17
	for <lists+netdev@lfdr.de>; Sat,  7 Mar 2020 02:05:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726982AbgCGBE0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 20:04:26 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:43390 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726932AbgCGBEY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Mar 2020 20:04:24 -0500
Received: by mail-pl1-f193.google.com with SMTP id f8so1546638plt.10
        for <netdev@vger.kernel.org>; Fri, 06 Mar 2020 17:04:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=DussKDpL1QlCwfZAGAUsTjEL7FDMvlH3xmb1rgZ8W0A=;
        b=pUEVEcvzQk5thMfzJfTJtULGm+LmMS1nlpHpb8J11lhnbgmT0k3CpDOdw/T8NqQ8wt
         0b028Tqv1P53J7UbHABafFp+Jieks1MLAyHXarnHu6mhni6IV9D3FqX1PWmVrEc5HZ6K
         3ySoCGs2GVmZdrKGwi4yNZBdrFsT9P6gmJlI/tIjtv9NVsNhQ936kr4T8edVHrywdSPE
         WPsOjqlrztt9J7xH6YCsCvwJLSP+lrhKVKhhxyjoPxlLlc/XlF2aO17Pwd7I9lb+dQnl
         NsHTVrEybZaAzclDRNQGH60mDavQE4WLh/dtCyK3Sq25wcyvW8RYLkl5JZwcaz+MjyX7
         02cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=DussKDpL1QlCwfZAGAUsTjEL7FDMvlH3xmb1rgZ8W0A=;
        b=kuclGOqfHNWvGHPucoN0i4R4HFaUoSSwFpbj1LtH4wkAhOW5/nRVLSs6Q7XxIE3wX/
         pLllTeExyTlF7wspHkRd/Gg3K/NbZil705QklrPsgxkzrCVrbP9PpErYBZyAXoXfbdXf
         yMU2BzQloFD8OFFGtE/XWsdSSUoz+jiAPhmj9fXl+NAtecZ+Mynlm7o+WAOxlqH2IE4Y
         PLFA6aBzWiuu6H8GStHuxVTS6e5Cl1uEEdnMlPTMj52a0CFfLwayMxTtvurWUMIcYMB9
         fg8BJjdvztgTloLRbk5gw2tJg9nP1vssg6v0vhB8o/tKXPWbrfVtCy6VdAuFwEch5knx
         1kQw==
X-Gm-Message-State: ANhLgQ2zBwDyGAle+d2fr6SBGbXViyPrQNDakw8ki0VH5TMXJrvmrlLz
        9l1VqxXxGKgIe0dywquPJJ2ea8ia7VA=
X-Google-Smtp-Source: ADFU+vvxzaiW050AX+hv4HZupa/5g+45FYHYVI/GE61DPDesPXeFmp4W12MF+N/fkWbR5hjYBsqCjQ==
X-Received: by 2002:a17:902:768b:: with SMTP id m11mr5503190pll.118.1583543063620;
        Fri, 06 Mar 2020 17:04:23 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id o66sm23224949pfb.93.2020.03.06.17.04.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 06 Mar 2020 17:04:23 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v4 net-next 7/8] ionic: add support for device id 0x1004
Date:   Fri,  6 Mar 2020 17:04:07 -0800
Message-Id: <20200307010408.65704-8-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200307010408.65704-1-snelson@pensando.io>
References: <20200307010408.65704-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for the management port device id.  This is to
capture the device and set it up for devlink use, but not set
it up for network operations.  We still use a netdev object
in order to use the napi infrasucture for processing adminq
and notifyq messages, we just don't register the netdev.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic.h         |  2 ++
 drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c |  7 ++++++-
 drivers/net/ethernet/pensando/ionic/ionic_devlink.c |  2 +-
 drivers/net/ethernet/pensando/ionic/ionic_lif.c     | 10 ++++++++++
 4 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic.h b/drivers/net/ethernet/pensando/ionic/ionic.h
index bb106a32f416..59f8385d591f 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic.h
@@ -18,6 +18,7 @@ struct ionic_lif;
 
 #define PCI_DEVICE_ID_PENSANDO_IONIC_ETH_PF	0x1002
 #define PCI_DEVICE_ID_PENSANDO_IONIC_ETH_VF	0x1003
+#define PCI_DEVICE_ID_PENSANDO_IONIC_ETH_MGMT	0x1004
 
 #define DEVCMD_TIMEOUT  10
 
@@ -42,6 +43,7 @@ struct ionic {
 	struct dentry *dentry;
 	struct ionic_dev_bar bars[IONIC_BARS_MAX];
 	unsigned int num_bars;
+	bool is_mgmt_nic;
 	struct ionic_identity ident;
 	struct list_head lifs;
 	struct ionic_lif *master_lif;
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
index 2924cde440aa..60fc191a35e5 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
@@ -15,6 +15,7 @@
 static const struct pci_device_id ionic_id_table[] = {
 	{ PCI_VDEVICE(PENSANDO, PCI_DEVICE_ID_PENSANDO_IONIC_ETH_PF) },
 	{ PCI_VDEVICE(PENSANDO, PCI_DEVICE_ID_PENSANDO_IONIC_ETH_VF) },
+	{ PCI_VDEVICE(PENSANDO, PCI_DEVICE_ID_PENSANDO_IONIC_ETH_MGMT) },
 	{ 0, }	/* end of table */
 };
 MODULE_DEVICE_TABLE(pci, ionic_id_table);
@@ -224,6 +225,9 @@ static int ionic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	pci_set_drvdata(pdev, ionic);
 	mutex_init(&ionic->dev_cmd_lock);
 
+	ionic->is_mgmt_nic =
+		ent->device == PCI_DEVICE_ID_PENSANDO_IONIC_ETH_MGMT;
+
 	/* Query system for DMA addressing limitation for the device. */
 	err = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(IONIC_ADDR_LEN));
 	if (err) {
@@ -248,7 +252,8 @@ static int ionic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	}
 
 	pci_set_master(pdev);
-	pcie_print_link_status(pdev);
+	if (!ionic->is_mgmt_nic)
+		pcie_print_link_status(pdev);
 
 	err = ionic_map_bars(ionic);
 	if (err)
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_devlink.c b/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
index 6fb27dcc5787..ed14164468a1 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
@@ -82,7 +82,7 @@ int ionic_devlink_register(struct ionic *ionic)
 	err = devlink_port_register(dl, &ionic->dl_port, 0);
 	if (err)
 		dev_err(ionic->dev, "devlink_port_register failed: %d\n", err);
-	else
+	else if (!ionic->is_mgmt_nic)
 		devlink_port_type_eth_set(&ionic->dl_port,
 					  ionic->master_lif->netdev);
 
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 4b953f9e9084..aaf4a40fa98b 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -1155,6 +1155,10 @@ static int ionic_init_nic_features(struct ionic_lif *lif)
 	netdev_features_t features;
 	int err;
 
+	/* no netdev features on the management device */
+	if (lif->ionic->is_mgmt_nic)
+		return 0;
+
 	/* set up what we expect to support by default */
 	features = NETIF_F_HW_VLAN_CTAG_TX |
 		   NETIF_F_HW_VLAN_CTAG_RX |
@@ -2383,6 +2387,12 @@ int ionic_lifs_register(struct ionic *ionic)
 {
 	int err;
 
+	/* the netdev is not registered on the management device, it is
+	 * only used as a vehicle for napi operations on the adminq
+	 */
+	if (ionic->is_mgmt_nic)
+		return 0;
+
 	INIT_WORK(&ionic->nb_work, ionic_lif_notify_work);
 
 	ionic->nb.notifier_call = ionic_lif_notify;
-- 
2.17.1

