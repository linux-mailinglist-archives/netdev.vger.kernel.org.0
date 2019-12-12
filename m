Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 160D411C17F
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 01:34:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727390AbfLLAd7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 19:33:59 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:34923 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727388AbfLLAd5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 19:33:57 -0500
Received: by mail-pf1-f193.google.com with SMTP id b19so166976pfo.2
        for <netdev@vger.kernel.org>; Wed, 11 Dec 2019 16:33:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=A3/YZCaX4WOW/gVwOXzLrnrJL5qYhb3Bw5Vz9Zd3P0s=;
        b=MpHYzkZyM2cokdm36/Ms47N6TG2/7K/sm16ZAezrhajoNjfudzvpt3oIFcO4fQBvkG
         yGDjZ0tF1fL6ZbKfXDwYQl0oMT+E1bSVLK6sfqZKutQ0c+Nv34ka9wtG3PyUHd17t9yL
         RDH5/gkXlgqJL2v62Opp1dgLqRaD4V1pzU2wKi1WnJ8TKtTqVZG6GEeG1PhZck4tKWH/
         WOjwCK2lh7So8cvU34pN668i//1WsAhs/5ybhdTjQHFeO7qlNr84sTa/XchqTKPp5l09
         Zdyp4Yk8AeO8v5HW5D/4eprUyS+Vf/PL1Dn2fGUfaPWdO2gXmtVS9NCAncWWcAqSMJHX
         dYhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=A3/YZCaX4WOW/gVwOXzLrnrJL5qYhb3Bw5Vz9Zd3P0s=;
        b=nC1odundnkCWRS5asG+0j9Yvz0LpasDkW6Caorw/AkO/IpkZAHquosDxzdQjUgUsDz
         jVd3EY5osuJX4MFICCOjauYwvZ/XspvQ3wkgAzJ+931Ro7idOFCPGVG+80sVnzjbO+2D
         RxlLW8MI7WBFPl+3YXWbIncCQsqn6ZctVeV0IN3qp2lz/xv4r+SeRZhq/anY13Nz5aFv
         BpZHglqH8B4yXQLJZaOMIf4RZPtXY6I9hHqnwOLSCTkbCWL4PadxoT0A2VTGO2SXoagr
         PFBk5w1CiuJFBKxRItwMuHNttSz7f7TtxJqcqK5Ok2aN1gy1IS+g31ckB6ZotxhpuVxJ
         UeHQ==
X-Gm-Message-State: APjAAAWVO2c7L5pipf9+3PPEtzt1BSS6AXAgi2yFsMM5V7ZObR3khovA
        xbb33kwlUuZaCze9xpUYVrhMjDH2IFk=
X-Google-Smtp-Source: APXvYqx5jUl3XB6C4LPem5bIOuwz6xYSL+GFDn2xMoUE7thGH+/s32Yfwa0MkZNhfz1wk/EgSmGpKQ==
X-Received: by 2002:a63:1e47:: with SMTP id p7mr7272317pgm.339.1576110836637;
        Wed, 11 Dec 2019 16:33:56 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id 16sm4343509pfh.182.2019.12.11.16.33.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 11 Dec 2019 16:33:56 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     parav@mellanox.com, Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v2 net-next 2/2] ionic: support sr-iov operations
Date:   Wed, 11 Dec 2019 16:33:44 -0800
Message-Id: <20191212003344.5571-3-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191212003344.5571-1-snelson@pensando.io>
References: <20191212003344.5571-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the netdev ops for managing VFs.  Since most of the
management work happens in the NIC firmware, the driver becomes
mostly a pass-through for the network stack commands that want
to control and configure the VFs.

We also tweak ionic_station_set() a little to allow for
the VFs that start off with a zero'd mac address.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic.h   |  15 +-
 .../ethernet/pensando/ionic/ionic_bus_pci.c   |  85 ++++++
 .../net/ethernet/pensando/ionic/ionic_dev.c   |  58 ++++
 .../net/ethernet/pensando/ionic/ionic_dev.h   |   7 +
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 254 +++++++++++++++++-
 .../net/ethernet/pensando/ionic/ionic_lif.h   |   7 +
 .../net/ethernet/pensando/ionic/ionic_main.c  |   4 +
 7 files changed, 422 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic.h b/drivers/net/ethernet/pensando/ionic/ionic.h
index 98e102af7756..e5c9e4b0450b 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic.h
@@ -12,7 +12,7 @@ struct ionic_lif;
 
 #define IONIC_DRV_NAME		"ionic"
 #define IONIC_DRV_DESCRIPTION	"Pensando Ethernet NIC Driver"
-#define IONIC_DRV_VERSION	"0.18.0-k"
+#define IONIC_DRV_VERSION	"0.20.0-k"
 
 #define PCI_VENDOR_ID_PENSANDO			0x1dd8
 
@@ -25,6 +25,18 @@ struct ionic_lif;
 
 #define DEVCMD_TIMEOUT  10
 
+struct ionic_vf {
+	u16	 index;
+	u8	 macaddr[6];
+	__le32	 maxrate;
+	__le16	 vlanid;
+	u8	 spoofchk;
+	u8	 trusted;
+	u8	 linkstate;
+	dma_addr_t       stats_pa;
+	struct ionic_lif_stats stats;
+};
+
 struct ionic {
 	struct pci_dev *pdev;
 	struct device *dev;
@@ -46,6 +58,7 @@ struct ionic {
 	DECLARE_BITMAP(intrs, IONIC_INTR_CTRL_REGS_MAX);
 	struct work_struct nb_work;
 	struct notifier_block nb;
+	struct ionic_vf **vf;
 	struct timer_list watchdog_timer;
 	int watchdog_period;
 };
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
index 9a9ab8cb2cb3..057eb453dd11 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
@@ -250,6 +250,87 @@ static int ionic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	return err;
 }
 
+static int ionic_sriov_configure(struct pci_dev *pdev, int num_vfs)
+{
+	struct ionic *ionic = pci_get_drvdata(pdev);
+	struct device *dev = ionic->dev;
+	int i, ret = 0;
+	int nvfs = 0;
+
+	if (test_and_set_bit(IONIC_LIF_VF_OP, ionic->master_lif->state)) {
+		dev_warn(&pdev->dev, "Unable to configure VFs, other operation is pending.\n");
+		return -EAGAIN;
+	}
+
+	if (num_vfs > 0) {
+		ret = pci_enable_sriov(pdev, num_vfs);
+		if (ret) {
+			dev_err(&pdev->dev, "Cannot enable SRIOV: %d\n", ret);
+			goto out;
+		}
+
+		ionic->vf = kcalloc(num_vfs, sizeof(struct ionic_vf *),
+				    GFP_KERNEL);
+		if (!ionic->vf) {
+			pci_disable_sriov(pdev);
+			ret = -ENOMEM;
+			goto out;
+		}
+
+		for (i = 0; i < num_vfs; i++) {
+			struct ionic_vf *v;
+
+			v = kzalloc(sizeof(*v), GFP_KERNEL);
+			if (!v) {
+				ret = -ENOMEM;
+				num_vfs = 0;
+				goto remove_vfs;
+			}
+
+			v->stats_pa = dma_map_single(dev, &v->stats,
+						     sizeof(v->stats),
+						     DMA_FROM_DEVICE);
+			if (dma_mapping_error(dev, v->stats_pa)) {
+				ret = -ENODEV;
+				kfree(v);
+				ionic->vf[i] = NULL;
+				num_vfs = 0;
+				goto remove_vfs;
+			}
+
+			ionic->vf[i] = v;
+			nvfs++;
+		}
+
+		ret = num_vfs;
+		goto out;
+	}
+
+remove_vfs:
+	if (num_vfs == 0) {
+		if (ret)
+			dev_err(&pdev->dev, "SRIOV setup failed: %d\n", ret);
+
+		pci_disable_sriov(pdev);
+
+		if (!nvfs)
+			nvfs = pci_num_vf(pdev);
+		for (i = 0; i < nvfs; i++) {
+			dma_unmap_single(dev, ionic->vf[i]->stats_pa,
+					 sizeof(struct ionic_lif_stats),
+					 DMA_FROM_DEVICE);
+			kfree(ionic->vf[i]);
+		}
+
+		kfree(ionic->vf);
+		ionic->vf = NULL;
+	}
+
+out:
+	clear_bit(IONIC_LIF_VF_OP, ionic->master_lif->state);
+	return ret;
+}
+
 static void ionic_remove(struct pci_dev *pdev)
 {
 	struct ionic *ionic = pci_get_drvdata(pdev);
@@ -257,6 +338,9 @@ static void ionic_remove(struct pci_dev *pdev)
 	if (!ionic)
 		return;
 
+	if (pci_num_vf(pdev))
+		ionic_sriov_configure(pdev, 0);
+
 	ionic_devlink_unregister(ionic);
 	ionic_lifs_unregister(ionic);
 	ionic_lifs_deinit(ionic);
@@ -279,6 +363,7 @@ static struct pci_driver ionic_driver = {
 	.id_table = ionic_id_table,
 	.probe = ionic_probe,
 	.remove = ionic_remove,
+	.sriov_configure = ionic_sriov_configure,
 };
 
 int ionic_bus_register_driver(void)
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.c b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
index 5f9d2ec70446..87f82f36812f 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
@@ -286,6 +286,64 @@ void ionic_dev_cmd_port_pause(struct ionic_dev *idev, u8 pause_type)
 	ionic_dev_cmd_go(idev, &cmd);
 }
 
+/* VF commands */
+int ionic_set_vf_config(struct ionic *ionic, int vf, u8 attr, u8 *data)
+{
+	union ionic_dev_cmd cmd = {
+		.vf_setattr.opcode = IONIC_CMD_VF_SETATTR,
+		.vf_setattr.attr = attr,
+		.vf_setattr.vf_index = vf,
+	};
+	int err;
+
+	switch (attr) {
+	case IONIC_VF_ATTR_SPOOFCHK:
+		cmd.vf_setattr.spoofchk = *data;
+		dev_dbg(ionic->dev, "%s: vf %d spoof %d\n",
+			__func__, vf, *data);
+		break;
+	case IONIC_VF_ATTR_TRUST:
+		cmd.vf_setattr.trust = *data;
+		dev_dbg(ionic->dev, "%s: vf %d trust %d\n",
+			__func__, vf, *data);
+		break;
+	case IONIC_VF_ATTR_LINKSTATE:
+		cmd.vf_setattr.linkstate = *data;
+		dev_dbg(ionic->dev, "%s: vf %d linkstate %d\n",
+			__func__, vf, *data);
+		break;
+	case IONIC_VF_ATTR_MAC:
+		ether_addr_copy(cmd.vf_setattr.macaddr, data);
+		dev_dbg(ionic->dev, "%s: vf %d macaddr %pM\n",
+			__func__, vf, data);
+		break;
+	case IONIC_VF_ATTR_VLAN:
+		cmd.vf_setattr.vlanid = cpu_to_le16(*(u16 *)data);
+		dev_dbg(ionic->dev, "%s: vf %d vlan %d\n",
+			__func__, vf, *(u16 *)data);
+		break;
+	case IONIC_VF_ATTR_RATE:
+		cmd.vf_setattr.maxrate = cpu_to_le32(*(u32 *)data);
+		dev_dbg(ionic->dev, "%s: vf %d maxrate %d\n",
+			__func__, vf, *(u32 *)data);
+		break;
+	case IONIC_VF_ATTR_STATSADDR:
+		cmd.vf_setattr.stats_pa = cpu_to_le64(*(u64 *)data);
+		dev_dbg(ionic->dev, "%s: vf %d stats_pa 0x%08llx\n",
+			__func__, vf, *(u64 *)data);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	mutex_lock(&ionic->dev_cmd_lock);
+	ionic_dev_cmd_go(&ionic->idev, &cmd);
+	err = ionic_dev_cmd_wait(ionic, DEVCMD_TIMEOUT);
+	mutex_unlock(&ionic->dev_cmd_lock);
+
+	return err;
+}
+
 /* LIF commands */
 void ionic_dev_cmd_lif_identify(struct ionic_dev *idev, u8 type, u8 ver)
 {
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.h b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
index 4665c5dc5324..7838e342c4fd 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
@@ -113,6 +113,12 @@ static_assert(sizeof(struct ionic_rxq_desc) == 16);
 static_assert(sizeof(struct ionic_rxq_sg_desc) == 128);
 static_assert(sizeof(struct ionic_rxq_comp) == 16);
 
+/* SR/IOV */
+static_assert(sizeof(struct ionic_vf_setattr_cmd) == 64);
+static_assert(sizeof(struct ionic_vf_setattr_comp) == 16);
+static_assert(sizeof(struct ionic_vf_getattr_cmd) == 64);
+static_assert(sizeof(struct ionic_vf_getattr_comp) == 16);
+
 struct ionic_devinfo {
 	u8 asic_type;
 	u8 asic_rev;
@@ -275,6 +281,7 @@ void ionic_dev_cmd_port_autoneg(struct ionic_dev *idev, u8 an_enable);
 void ionic_dev_cmd_port_fec(struct ionic_dev *idev, u8 fec_type);
 void ionic_dev_cmd_port_pause(struct ionic_dev *idev, u8 pause_type);
 
+int ionic_set_vf_config(struct ionic *ionic, int vf, u8 attr, u8 *data);
 void ionic_dev_cmd_lif_identify(struct ionic_dev *idev, u8 type, u8 ver);
 void ionic_dev_cmd_lif_init(struct ionic_dev *idev, u16 lif_index,
 			    dma_addr_t addr);
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 60fd14df49d7..4d75d6c40c43 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -1616,6 +1616,234 @@ int ionic_stop(struct net_device *netdev)
 	return err;
 }
 
+static int ionic_get_vf_config(struct net_device *netdev,
+			       int vf, struct ifla_vf_info *ivf)
+{
+	struct ionic_lif *lif = netdev_priv(netdev);
+	struct ionic *ionic = lif->ionic;
+
+	if (vf >= pci_num_vf(lif->ionic->pdev))
+		return -EINVAL;
+
+	if (test_and_set_bit(IONIC_LIF_VF_OP, lif->state)) {
+		netdev_warn(netdev, "Unable to configure VFs, other operation is pending.\n");
+		return -EAGAIN;
+	}
+
+	ivf->vf           = vf;
+	ivf->vlan         = ionic->vf[vf]->vlanid;
+	ivf->qos	  = 0;
+	ivf->spoofchk     = ionic->vf[vf]->spoofchk;
+	ivf->linkstate    = ionic->vf[vf]->linkstate;
+	ivf->max_tx_rate  = ionic->vf[vf]->maxrate;
+	ivf->trusted      = ionic->vf[vf]->trusted;
+	ether_addr_copy(ivf->mac, ionic->vf[vf]->macaddr);
+
+	clear_bit(IONIC_LIF_VF_OP, lif->state);
+	return 0;
+}
+
+static int ionic_get_vf_stats(struct net_device *netdev, int vf,
+			      struct ifla_vf_stats *vf_stats)
+{
+	struct ionic_lif *lif = netdev_priv(netdev);
+	struct ionic *ionic = lif->ionic;
+	struct ionic_lif_stats *vs;
+
+	if (vf >= pci_num_vf(lif->ionic->pdev))
+		return -EINVAL;
+
+	if (test_and_set_bit(IONIC_LIF_VF_OP, lif->state)) {
+		netdev_warn(netdev, "Unable to configure VFs, other operation is pending.\n");
+		return -EAGAIN;
+	}
+
+	memset(vf_stats, 0, sizeof(*vf_stats));
+	vs = &ionic->vf[vf]->stats;
+
+	vf_stats->rx_packets = le64_to_cpu(vs->rx_ucast_packets);
+	vf_stats->tx_packets = le64_to_cpu(vs->tx_ucast_packets);
+	vf_stats->rx_bytes   = le64_to_cpu(vs->rx_ucast_bytes);
+	vf_stats->tx_bytes   = le64_to_cpu(vs->tx_ucast_bytes);
+	vf_stats->broadcast  = le64_to_cpu(vs->rx_bcast_packets);
+	vf_stats->multicast  = le64_to_cpu(vs->rx_mcast_packets);
+	vf_stats->rx_dropped = le64_to_cpu(vs->rx_ucast_drop_packets) +
+			       le64_to_cpu(vs->rx_mcast_drop_packets) +
+			       le64_to_cpu(vs->rx_bcast_drop_packets);
+	vf_stats->tx_dropped = le64_to_cpu(vs->tx_ucast_drop_packets) +
+			       le64_to_cpu(vs->tx_mcast_drop_packets) +
+			       le64_to_cpu(vs->tx_bcast_drop_packets);
+
+	clear_bit(IONIC_LIF_VF_OP, lif->state);
+	return 0;
+}
+
+static int ionic_set_vf_mac(struct net_device *netdev, int vf, u8 *mac)
+{
+	struct ionic_lif *lif = netdev_priv(netdev);
+	int ret;
+
+	if (vf >= pci_num_vf(lif->ionic->pdev))
+		return -EINVAL;
+
+	if (!(is_zero_ether_addr(mac) || is_valid_ether_addr(mac)))
+		return -EINVAL;
+
+	if (test_and_set_bit(IONIC_LIF_VF_OP, lif->state)) {
+		netdev_warn(netdev, "Unable to configure VFs, other operation is pending.\n");
+		return -EAGAIN;
+	}
+
+	ret = ionic_set_vf_config(lif->ionic, vf,
+				  IONIC_VF_ATTR_MAC, mac);
+	if (!ret)
+		ether_addr_copy(lif->ionic->vf[vf]->macaddr, mac);
+
+	clear_bit(IONIC_LIF_VF_OP, lif->state);
+	return ret;
+}
+
+static int ionic_set_vf_vlan(struct net_device *netdev, int vf, u16 vlan,
+			     u8 qos, __be16 proto)
+{
+	struct ionic_lif *lif = netdev_priv(netdev);
+	int ret;
+
+	if (vf >= pci_num_vf(lif->ionic->pdev))
+		return -EINVAL;
+
+	/* until someday when we support qos */
+	if (qos)
+		return -EINVAL;
+
+	if (vlan > 4095)
+		return -EINVAL;
+
+	if (proto != htons(ETH_P_8021Q))
+		return -EPROTONOSUPPORT;
+
+	if (test_and_set_bit(IONIC_LIF_VF_OP, lif->state)) {
+		netdev_warn(netdev, "Unable to configure VFs, other operation is pending.\n");
+		return -EAGAIN;
+	}
+
+	ret = ionic_set_vf_config(lif->ionic, vf,
+				  IONIC_VF_ATTR_VLAN, (u8 *)&vlan);
+	if (!ret)
+		lif->ionic->vf[vf]->vlanid = vlan;
+
+	clear_bit(IONIC_LIF_VF_OP, lif->state);
+	return ret;
+}
+
+static int ionic_set_vf_rate(struct net_device *netdev, int vf,
+			     int tx_min, int tx_max)
+{
+	struct ionic_lif *lif = netdev_priv(netdev);
+	int ret;
+
+	if (vf >= pci_num_vf(lif->ionic->pdev))
+		return -EINVAL;
+
+	/* setting the min just seems silly */
+	if (tx_min)
+		return -EINVAL;
+
+	if (test_and_set_bit(IONIC_LIF_VF_OP, lif->state)) {
+		netdev_warn(netdev, "Unable to configure VFs, other operation is pending.\n");
+		return -EAGAIN;
+	}
+
+	ret = ionic_set_vf_config(lif->ionic, vf,
+				  IONIC_VF_ATTR_RATE, (u8 *)&tx_max);
+	if (!ret)
+		lif->ionic->vf[vf]->maxrate = tx_max;
+
+	clear_bit(IONIC_LIF_VF_OP, lif->state);
+	return ret;
+}
+
+static int ionic_set_vf_spoofchk(struct net_device *netdev, int vf, bool set)
+{
+	struct ionic_lif *lif = netdev_priv(netdev);
+	u8 data = set;  /* convert to u8 for config */
+	int ret;
+
+	if (vf >= pci_num_vf(lif->ionic->pdev))
+		return -EINVAL;
+
+	if (test_and_set_bit(IONIC_LIF_VF_OP, lif->state)) {
+		netdev_warn(netdev, "Unable to configure VFs, other operation is pending.\n");
+		return -EAGAIN;
+	}
+
+	ret = ionic_set_vf_config(lif->ionic, vf,
+				  IONIC_VF_ATTR_SPOOFCHK, &data);
+	if (!ret)
+		lif->ionic->vf[vf]->spoofchk = data;
+
+	clear_bit(IONIC_LIF_VF_OP, lif->state);
+	return ret;
+}
+
+static int ionic_set_vf_trust(struct net_device *netdev, int vf, bool set)
+{
+	struct ionic_lif *lif = netdev_priv(netdev);
+	u8 data = set;  /* convert to u8 for config */
+	int ret;
+
+	if (vf >= pci_num_vf(lif->ionic->pdev))
+		return -EINVAL;
+
+	if (test_and_set_bit(IONIC_LIF_VF_OP, lif->state)) {
+		netdev_warn(netdev, "Unable to configure VFs, other operation is pending.\n");
+		return -EAGAIN;
+	}
+
+	ret = ionic_set_vf_config(lif->ionic, vf,
+				  IONIC_VF_ATTR_TRUST, &data);
+	if (!ret)
+		lif->ionic->vf[vf]->trusted = data;
+
+	clear_bit(IONIC_LIF_VF_OP, lif->state);
+	return ret;
+}
+
+static int ionic_set_vf_link_state(struct net_device *netdev, int vf, int set)
+{
+	struct ionic_lif *lif = netdev_priv(netdev);
+	u8 data;
+	int ret;
+
+	if (vf >= pci_num_vf(lif->ionic->pdev))
+		return -EINVAL;
+
+	if (test_and_set_bit(IONIC_LIF_VF_OP, lif->state)) {
+		netdev_warn(netdev, "Unable to configure VFs, other operation is pending.\n");
+		return -EAGAIN;
+	}
+
+	switch (set) {
+	case IFLA_VF_LINK_STATE_AUTO:
+		data = IONIC_VF_LINK_STATUS_AUTO;
+		break;
+	case IFLA_VF_LINK_STATE_ENABLE:
+		data = IONIC_VF_LINK_STATUS_UP;
+		break;
+	case IFLA_VF_LINK_STATE_DISABLE:
+		data = IONIC_VF_LINK_STATUS_DOWN;
+		break;
+	}
+
+	ret = ionic_set_vf_config(lif->ionic, vf,
+				  IONIC_VF_ATTR_LINKSTATE, &data);
+	if (!ret)
+		lif->ionic->vf[vf]->linkstate = set;
+
+	clear_bit(IONIC_LIF_VF_OP, lif->state);
+	return ret;
+}
+
 static const struct net_device_ops ionic_netdev_ops = {
 	.ndo_open               = ionic_open,
 	.ndo_stop               = ionic_stop,
@@ -1629,6 +1857,14 @@ static const struct net_device_ops ionic_netdev_ops = {
 	.ndo_change_mtu         = ionic_change_mtu,
 	.ndo_vlan_rx_add_vid    = ionic_vlan_rx_add_vid,
 	.ndo_vlan_rx_kill_vid   = ionic_vlan_rx_kill_vid,
+	.ndo_set_vf_vlan	= ionic_set_vf_vlan,
+	.ndo_set_vf_trust	= ionic_set_vf_trust,
+	.ndo_set_vf_mac		= ionic_set_vf_mac,
+	.ndo_set_vf_rate	= ionic_set_vf_rate,
+	.ndo_set_vf_spoofchk	= ionic_set_vf_spoofchk,
+	.ndo_get_vf_config	= ionic_get_vf_config,
+	.ndo_set_vf_link_state	= ionic_set_vf_link_state,
+	.ndo_get_vf_stats       = ionic_get_vf_stats,
 };
 
 int ionic_reset_queues(struct ionic_lif *lif)
@@ -1961,18 +2197,22 @@ static int ionic_station_set(struct ionic_lif *lif)
 	if (err)
 		return err;
 
+	if (is_zero_ether_addr(ctx.comp.lif_getattr.mac))
+		return 0;
+
 	memcpy(addr.sa_data, ctx.comp.lif_getattr.mac, netdev->addr_len);
 	addr.sa_family = AF_INET;
 	err = eth_prepare_mac_addr_change(netdev, &addr);
-	if (err)
-		return err;
-
-	if (!is_zero_ether_addr(netdev->dev_addr)) {
-		netdev_dbg(lif->netdev, "deleting station MAC addr %pM\n",
-			   netdev->dev_addr);
-		ionic_lif_addr(lif, netdev->dev_addr, false);
+	if (err) {
+		netdev_warn(lif->netdev, "ignoring bad MAC addr from NIC %pM\n",
+			    addr.sa_data);
+		return 0;
 	}
 
+	netdev_dbg(lif->netdev, "deleting station MAC addr %pM\n",
+		   netdev->dev_addr);
+	ionic_lif_addr(lif, netdev->dev_addr, false);
+
 	eth_commit_mac_addr_change(netdev, &addr);
 	netdev_dbg(lif->netdev, "adding station MAC addr %pM\n",
 		   netdev->dev_addr);
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.h b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
index a55fd1f8c31b..0657e00ab85f 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
@@ -125,6 +125,7 @@ enum ionic_lif_state_flags {
 	IONIC_LIF_UP,
 	IONIC_LIF_LINK_CHECK_REQUESTED,
 	IONIC_LIF_QUEUE_RESET,
+	IONIC_LIF_VF_OP,
 
 	/* leave this as last */
 	IONIC_LIF_STATE_SIZE
@@ -195,6 +196,12 @@ static inline int ionic_wait_for_bit(struct ionic_lif *lif, int bitname)
 	return wait_on_bit_lock(lif->state, bitname, TASK_INTERRUPTIBLE);
 }
 
+static inline bool ionic_is_pf(struct ionic *ionic)
+{
+	return ionic->pdev &&
+	       ionic->pdev->device == PCI_DEVICE_ID_PENSANDO_IONIC_ETH_PF;
+}
+
 static inline u32 ionic_coal_usec_to_hw(struct ionic *ionic, u32 usecs)
 {
 	u32 mult = le32_to_cpu(ionic->ident.dev.intr_coal_mult);
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_main.c b/drivers/net/ethernet/pensando/ionic/ionic_main.c
index 3590ea7fd88a..837b85f2fed9 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_main.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_main.c
@@ -165,6 +165,10 @@ static const char *ionic_opcode_to_str(enum ionic_cmd_opcode opcode)
 		return "IONIC_CMD_FW_DOWNLOAD";
 	case IONIC_CMD_FW_CONTROL:
 		return "IONIC_CMD_FW_CONTROL";
+	case IONIC_CMD_VF_GETATTR:
+		return "IONIC_CMD_VF_GETATTR";
+	case IONIC_CMD_VF_SETATTR:
+		return "IONIC_CMD_VF_SETATTR";
 	default:
 		return "DEVCMD_UNKNOWN";
 	}
-- 
2.17.1

