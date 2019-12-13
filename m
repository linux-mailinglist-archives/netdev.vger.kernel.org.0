Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD72311EAC0
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 19:55:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728736AbfLMSz0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 13:55:26 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:37715 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728678AbfLMSz0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 13:55:26 -0500
Received: by mail-pf1-f194.google.com with SMTP id p14so172513pfn.4
        for <netdev@vger.kernel.org>; Fri, 13 Dec 2019 10:55:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=sSvXIRWqmDoFF4iciIq+7xuSQKjQHh+74qN4tpo0hlw=;
        b=nhsoyYelaXmBaz2BKnQ42hfz8mBc40MI3fJvin5b5MQnqwJoRmWuC2LeOrlPDLFe7P
         vXxFJKkxxLue1dM1WDa861fFsN+A5tbj+onv/OBC4jpUzsHv5rS0K6MeSkpSYxErqfTb
         4XV51vT72J55K08uEJWgS2ucP0UGRroS2A0b+4oebMVprOLmq6lIbBC1v7bJhXTA4RkP
         cZhr1h5pOZ3zslcqfryHxSSkbh+/jf3hIt+KV8jEJhNNsXNpx2WPdV8u+r7TFdL3j3Ww
         TAchoxG+KeNYmFpNOcJgYqfzIAA5xzb43moEkEHreCsYgV+aKoPUdDx52ZaMHGdaoAEd
         PnHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=sSvXIRWqmDoFF4iciIq+7xuSQKjQHh+74qN4tpo0hlw=;
        b=OV9PaHRK6PD0S30PbCdlC5G5jmifipp+vZua663JpyKRRDIBBS8bIOXnhEnh0cF/LK
         1l6kh5ddLHpnibHZNecYec6IVazV7dCBymaUBmdshW/D1mNvKvfiKD364V5Ui/xaOb7M
         pikRZMvBN4GN8AiErGEHwL+9aPLE+lieVUZYp2tvlOenujqWNL1VpxLkrn7JY+Kq74Yt
         bJAcN3vUv8DGKOFGdm2ELSJ+0Zg2HWS7gmoqL4vNViRZ0rR9U7lp8Ny0Cadv1J4LOxzi
         dEw7s6WOJLF2A/CBrLIhNAi2a7jEZ9N9yU9FQlT7iAIeAq2xQMsyhiBow21PPBoDz4hX
         KMmA==
X-Gm-Message-State: APjAAAX4CsEHq6q9jN1flFZ7YRB3jujjgQb+Y8m0CL5JL7rdhmQhZARZ
        KEsF1qKV9i1HqReU675UiVTRLGSGBdg=
X-Google-Smtp-Source: APXvYqxe0152LMlC89/IbHN4sxhqhGDqB2SbYUxWTTWbejc5fWm8J+MGeHDWV3b0iKEEU8/D+f+OVA==
X-Received: by 2002:a65:4381:: with SMTP id m1mr1042587pgp.68.1576263324888;
        Fri, 13 Dec 2019 10:55:24 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id n26sm12609003pgd.46.2019.12.13.10.55.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 13 Dec 2019 10:55:24 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     parav@mellanox.com, Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v3 net-next 2/2] ionic: support sr-iov operations
Date:   Fri, 13 Dec 2019 10:55:16 -0800
Message-Id: <20191213185516.52087-3-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191213185516.52087-1-snelson@pensando.io>
References: <20191213185516.52087-1-snelson@pensando.io>
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
 drivers/net/ethernet/pensando/ionic/ionic.h   |  17 +-
 .../ethernet/pensando/ionic/ionic_bus_pci.c   | 101 ++++++++
 .../net/ethernet/pensando/ionic/ionic_dev.c   |  58 +++++
 .../net/ethernet/pensando/ionic/ionic_dev.h   |   7 +
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 222 +++++++++++++++++-
 .../net/ethernet/pensando/ionic/ionic_main.c  |   4 +
 6 files changed, 401 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic.h b/drivers/net/ethernet/pensando/ionic/ionic.h
index 98e102af7756..74b358f03599 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic.h
@@ -12,7 +12,7 @@ struct ionic_lif;
 
 #define IONIC_DRV_NAME		"ionic"
 #define IONIC_DRV_DESCRIPTION	"Pensando Ethernet NIC Driver"
-#define IONIC_DRV_VERSION	"0.18.0-k"
+#define IONIC_DRV_VERSION	"0.20.0-k"
 
 #define PCI_VENDOR_ID_PENSANDO			0x1dd8
 
@@ -25,12 +25,25 @@ struct ionic_lif;
 
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
 	struct devlink_port dl_port;
 	struct ionic_dev idev;
 	struct mutex dev_cmd_lock;	/* lock for dev_cmd operations */
+	struct rw_semaphore vf_op_lock;	/* lock for VF operations */
 	struct dentry *dentry;
 	struct ionic_dev_bar bars[IONIC_BARS_MAX];
 	unsigned int num_bars;
@@ -46,6 +59,8 @@ struct ionic {
 	DECLARE_BITMAP(intrs, IONIC_INTR_CTRL_REGS_MAX);
 	struct work_struct nb_work;
 	struct notifier_block nb;
+	unsigned int num_vfs;
+	struct ionic_vf **vf;
 	struct timer_list watchdog_timer;
 	int watchdog_period;
 };
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
index 9a9ab8cb2cb3..b9a3e1e1d41e 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
@@ -104,10 +104,101 @@ void ionic_bus_unmap_dbpage(struct ionic *ionic, void __iomem *page)
 	iounmap(page);
 }
 
+static void ionic_vf_dealloc(struct ionic *ionic)
+{
+	struct ionic_vf *v;
+	int i;
+
+	for (i = ionic->num_vfs - 1; i >= 0; i--) {
+		v = ionic->vf[i];
+		dma_unmap_single(ionic->dev, v->stats_pa,
+				 sizeof(v->stats), DMA_FROM_DEVICE);
+		kfree(v);
+		ionic->vf[i] = NULL;
+	}
+
+	ionic->num_vfs = 0;
+	kfree(ionic->vf);
+	ionic->vf = NULL;
+}
+
+static int ionic_vf_alloc(struct ionic *ionic, int num_vfs)
+{
+	struct ionic_vf *v;
+	int err, i;
+
+	ionic->vf = kcalloc(num_vfs, sizeof(struct ionic_vf *), GFP_KERNEL);
+	if (!ionic->vf)
+		return -ENOMEM;
+
+	for (i = 0; i < num_vfs; i++) {
+		v = kzalloc(sizeof(*v), GFP_KERNEL);
+		if (!v) {
+			err = -ENOMEM;
+			goto err_out;
+		}
+
+		v->stats_pa = dma_map_single(ionic->dev, &v->stats,
+					     sizeof(v->stats), DMA_FROM_DEVICE);
+		if (dma_mapping_error(ionic->dev, v->stats_pa)) {
+			err = -ENODEV;
+			kfree(v);
+			ionic->vf[i] = NULL;
+			goto err_out;
+		}
+
+		ionic->vf[i] = v;
+		ionic->num_vfs++;
+	}
+
+	return 0;
+
+err_out:
+	ionic_vf_dealloc(ionic);
+	return err;
+}
+
+static int ionic_sriov_configure(struct pci_dev *pdev, int num_vfs)
+{
+	struct ionic *ionic = pci_get_drvdata(pdev);
+	struct device *dev = ionic->dev;
+	int ret = 0;
+
+	down_write(&ionic->vf_op_lock);
+
+	if (num_vfs > 0) {
+		ret = pci_enable_sriov(pdev, num_vfs);
+		if (ret) {
+			dev_err(dev, "Cannot enable SRIOV: %d\n", ret);
+			goto out;
+		}
+
+		ret = ionic_vf_alloc(ionic, num_vfs);
+		if (ret) {
+			dev_err(dev, "Cannot alloc VFs: %d\n", ret);
+			pci_disable_sriov(pdev);
+			goto out;
+		}
+
+		ret = num_vfs;
+		goto out;
+	}
+
+	if (num_vfs == 0) {
+		pci_disable_sriov(pdev);
+		ionic_vf_dealloc(ionic);
+	}
+
+out:
+	up_write(&ionic->vf_op_lock);
+	return ret;
+}
+
 static int ionic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	struct device *dev = &pdev->dev;
 	struct ionic *ionic;
+	int num_vfs;
 	int err;
 
 	ionic = ionic_devlink_alloc(dev);
@@ -118,6 +209,7 @@ static int ionic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	ionic->dev = dev;
 	pci_set_drvdata(pdev, ionic);
 	mutex_init(&ionic->dev_cmd_lock);
+	init_rwsem(&ionic->vf_op_lock);
 
 	/* Query system for DMA addressing limitation for the device. */
 	err = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(IONIC_ADDR_LEN));
@@ -206,6 +298,14 @@ static int ionic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto err_out_free_lifs;
 	}
 
+	num_vfs = pci_num_vf(pdev);
+	if (num_vfs) {
+		dev_info(dev, "%d VFs found already enabled\n", num_vfs);
+		err = ionic_vf_alloc(ionic, num_vfs);
+		if (err)
+			dev_err(dev, "Cannot enable existing VFs: %d\n", err);
+	}
+
 	err = ionic_lifs_register(ionic);
 	if (err) {
 		dev_err(dev, "Cannot register LIFs: %d, aborting\n", err);
@@ -279,6 +379,7 @@ static struct pci_driver ionic_driver = {
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
index 60fd14df49d7..6cd6ac1fff81 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -1616,6 +1616,202 @@ int ionic_stop(struct net_device *netdev)
 	return err;
 }
 
+static int ionic_get_vf_config(struct net_device *netdev,
+			       int vf, struct ifla_vf_info *ivf)
+{
+	struct ionic_lif *lif = netdev_priv(netdev);
+	struct ionic *ionic = lif->ionic;
+
+	if (vf >= ionic->num_vfs)
+		return -EINVAL;
+
+	down_read(&ionic->vf_op_lock);
+	ivf->vf           = vf;
+	ivf->vlan         = ionic->vf[vf]->vlanid;
+	ivf->qos	  = 0;
+	ivf->spoofchk     = ionic->vf[vf]->spoofchk;
+	ivf->linkstate    = ionic->vf[vf]->linkstate;
+	ivf->max_tx_rate  = ionic->vf[vf]->maxrate;
+	ivf->trusted      = ionic->vf[vf]->trusted;
+	ether_addr_copy(ivf->mac, ionic->vf[vf]->macaddr);
+	up_read(&ionic->vf_op_lock);
+
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
+	if (vf >= ionic->num_vfs)
+		return -EINVAL;
+
+	memset(vf_stats, 0, sizeof(*vf_stats));
+	vs = &ionic->vf[vf]->stats;
+
+	down_read(&ionic->vf_op_lock);
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
+	up_read(&ionic->vf_op_lock);
+
+	return 0;
+}
+
+static int ionic_set_vf_mac(struct net_device *netdev, int vf, u8 *mac)
+{
+	struct ionic_lif *lif = netdev_priv(netdev);
+	struct ionic *ionic = lif->ionic;
+	int ret;
+
+	if (vf >= ionic->num_vfs)
+		return -EINVAL;
+
+	if (!(is_zero_ether_addr(mac) || is_valid_ether_addr(mac)))
+		return -EINVAL;
+
+	down_write(&ionic->vf_op_lock);
+	ret = ionic_set_vf_config(ionic, vf, IONIC_VF_ATTR_MAC, mac);
+	if (!ret)
+		ether_addr_copy(ionic->vf[vf]->macaddr, mac);
+	up_write(&ionic->vf_op_lock);
+
+	return ret;
+}
+
+static int ionic_set_vf_vlan(struct net_device *netdev, int vf, u16 vlan,
+			     u8 qos, __be16 proto)
+{
+	struct ionic_lif *lif = netdev_priv(netdev);
+	struct ionic *ionic = lif->ionic;
+	int ret;
+
+	if (vf >= ionic->num_vfs)
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
+	down_write(&ionic->vf_op_lock);
+	ret = ionic_set_vf_config(ionic, vf, IONIC_VF_ATTR_VLAN, (u8 *)&vlan);
+	if (!ret)
+		ionic->vf[vf]->vlanid = vlan;
+	up_write(&ionic->vf_op_lock);
+
+	return ret;
+}
+
+static int ionic_set_vf_rate(struct net_device *netdev, int vf,
+			     int tx_min, int tx_max)
+{
+	struct ionic_lif *lif = netdev_priv(netdev);
+	struct ionic *ionic = lif->ionic;
+	int ret;
+
+	if (vf >= ionic->num_vfs)
+		return -EINVAL;
+
+	/* setting the min just seems silly */
+	if (tx_min)
+		return -EINVAL;
+
+	down_write(&ionic->vf_op_lock);
+	ret = ionic_set_vf_config(ionic, vf, IONIC_VF_ATTR_RATE, (u8 *)&tx_max);
+	if (!ret)
+		lif->ionic->vf[vf]->maxrate = tx_max;
+	up_write(&ionic->vf_op_lock);
+
+	return ret;
+}
+
+static int ionic_set_vf_spoofchk(struct net_device *netdev, int vf, bool set)
+{
+	struct ionic_lif *lif = netdev_priv(netdev);
+	struct ionic *ionic = lif->ionic;
+	u8 data = set;  /* convert to u8 for config */
+	int ret;
+
+	if (vf >= ionic->num_vfs)
+		return -EINVAL;
+
+	down_write(&ionic->vf_op_lock);
+	ret = ionic_set_vf_config(ionic, vf, IONIC_VF_ATTR_SPOOFCHK, &data);
+	if (!ret)
+		ionic->vf[vf]->spoofchk = data;
+	up_write(&ionic->vf_op_lock);
+
+	return ret;
+}
+
+static int ionic_set_vf_trust(struct net_device *netdev, int vf, bool set)
+{
+	struct ionic_lif *lif = netdev_priv(netdev);
+	struct ionic *ionic = lif->ionic;
+	u8 data = set;  /* convert to u8 for config */
+	int ret;
+
+	if (vf >= ionic->num_vfs)
+		return -EINVAL;
+
+	down_write(&ionic->vf_op_lock);
+	ret = ionic_set_vf_config(ionic, vf, IONIC_VF_ATTR_TRUST, &data);
+	if (!ret)
+		ionic->vf[vf]->trusted = data;
+	up_write(&ionic->vf_op_lock);
+
+	return ret;
+}
+
+static int ionic_set_vf_link_state(struct net_device *netdev, int vf, int set)
+{
+	struct ionic_lif *lif = netdev_priv(netdev);
+	struct ionic *ionic = lif->ionic;
+	u8 data;
+	int ret;
+
+	if (vf >= ionic->num_vfs)
+		return -EINVAL;
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
+	down_write(&ionic->vf_op_lock);
+	ret = ionic_set_vf_config(ionic, vf, IONIC_VF_ATTR_LINKSTATE, &data);
+	if (!ret)
+		ionic->vf[vf]->linkstate = set;
+	up_write(&ionic->vf_op_lock);
+
+	return ret;
+}
+
 static const struct net_device_ops ionic_netdev_ops = {
 	.ndo_open               = ionic_open,
 	.ndo_stop               = ionic_stop,
@@ -1629,6 +1825,14 @@ static const struct net_device_ops ionic_netdev_ops = {
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
@@ -1961,18 +2165,22 @@ static int ionic_station_set(struct ionic_lif *lif)
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

