Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A65E12FBDC
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 18:55:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728252AbgACRza (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 12:55:30 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:44341 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728110AbgACRz3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jan 2020 12:55:29 -0500
Received: by mail-pl1-f196.google.com with SMTP id az3so19283226plb.11
        for <netdev@vger.kernel.org>; Fri, 03 Jan 2020 09:55:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=5DC4WFcp9TVOk+JrQnrGMcoEU7fZPSv02otxVKkROd4=;
        b=2NQoXOvljbyEKC4qqKdUdy7+N+tOC5Kx7Wc4bam9OBAN9vxk0kpIT+ISarNj8zBuit
         5rOG7+iCjVhkP4Nb7IlzX6KxdXnKMWLxBq5r45D3EIOPUdMfm7bQTMOFa0+JD8TJx/lx
         uiy2K6T7mWn3mwycsvWCL/flok52Fr0ab7O+RcZY5ZZXGaIAZlqBwshnVaIy8uqv8fxv
         NQhtSv6/uO7ma7EYPNlc+afG6WuJeshv40pCHxjfOTwQX7wF72dBlGLDau6aAD5ZFo9d
         aUM8IYZ/J0mh2QMq+n3QwKRMKncFEJMrDR0OkDtfNh/5qV82llq8TI1R7kuGg8SNou4c
         O1jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=5DC4WFcp9TVOk+JrQnrGMcoEU7fZPSv02otxVKkROd4=;
        b=gfk9dmoVbCpDJd0Q36l6Q7JopX59CIWpk5ipwDoNyFnnwK3qiqHuPilmY3UjiAIx4u
         llJ+GEYzw/UzLC5zSgpgMaJCZnV1LfEYgB8GITRGf+Qji6jyY98/DsB3zgqfnZFR95Z2
         pfglANRsWx6fWcf7QdbfezQFg6qHmqmMHJeB8lwKTalkn6FHLFs/RctzAqC4foc4LhPY
         PsU7NG+P0efyS+TDi4Q3SBIUrlCApcPSGcDVPiDuxv3qApsuTBClo7QsUTcGfZ2Ujvc6
         sY6WdgwvVrB24mNN1fjf+D+SVgmClFP+dK6ksFSDjttUU2jr13fXfzjAoI8+hSciM0LK
         PelA==
X-Gm-Message-State: APjAAAVIDlA6F0C4akRLiKqWDB5ysadhA9k/aUSaX1uFtVGeXhRmcW1w
        fLm260YOn5/yEUoQW1RHM+NT540NKDickA==
X-Google-Smtp-Source: APXvYqweXmuUiJbx2bJfmu7OcC2Q9z4i8jBPPe/JGhlgHXZoUU6SoSYKBZ8fP2FsZAJkexoL7L+Zcw==
X-Received: by 2002:a17:90a:330f:: with SMTP id m15mr27610748pjb.24.1578074127247;
        Fri, 03 Jan 2020 09:55:27 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id u20sm61516655pgf.29.2020.01.03.09.55.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 03 Jan 2020 09:55:26 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     parav@mellanox.com, Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v4 net-next 2/2] ionic: support sr-iov operations
Date:   Fri,  3 Jan 2020 09:55:08 -0800
Message-Id: <20200103175508.32176-3-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200103175508.32176-1-snelson@pensando.io>
References: <20200103175508.32176-1-snelson@pensando.io>
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
 .../ethernet/pensando/ionic/ionic_bus_pci.c   | 113 ++++++++
 .../net/ethernet/pensando/ionic/ionic_dev.c   |  58 ++++
 .../net/ethernet/pensando/ionic/ionic_dev.h   |   7 +
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 247 +++++++++++++++++-
 .../net/ethernet/pensando/ionic/ionic_main.c  |   4 +
 6 files changed, 438 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic.h b/drivers/net/ethernet/pensando/ionic/ionic.h
index 98e102af7756..ca0b21911ad6 100644
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
@@ -46,6 +58,9 @@ struct ionic {
 	DECLARE_BITMAP(intrs, IONIC_INTR_CTRL_REGS_MAX);
 	struct work_struct nb_work;
 	struct notifier_block nb;
+	struct rw_semaphore vf_op_lock;	/* lock for VF operations */
+	struct ionic_vf *vfs;
+	int num_vfs;
 	struct timer_list watchdog_timer;
 	int watchdog_period;
 };
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
index 9a9ab8cb2cb3..448d7b23b2f7 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
@@ -104,10 +104,112 @@ void ionic_bus_unmap_dbpage(struct ionic *ionic, void __iomem *page)
 	iounmap(page);
 }
 
+static void ionic_vf_dealloc_locked(struct ionic *ionic)
+{
+	struct ionic_vf *v;
+	dma_addr_t dma = 0;
+	int i;
+
+	if (!ionic->vfs)
+		return;
+
+	for (i = ionic->num_vfs - 1; i >= 0; i--) {
+		v = &ionic->vfs[i];
+
+		if (v->stats_pa) {
+			(void)ionic_set_vf_config(ionic, i,
+						  IONIC_VF_ATTR_STATSADDR,
+						  (u8 *)&dma);
+			dma_unmap_single(ionic->dev, v->stats_pa,
+					 sizeof(v->stats), DMA_FROM_DEVICE);
+			v->stats_pa = 0;
+		}
+	}
+
+	kfree(ionic->vfs);
+	ionic->vfs = NULL;
+	ionic->num_vfs = 0;
+}
+
+static void ionic_vf_dealloc(struct ionic *ionic)
+{
+	down_write(&ionic->vf_op_lock);
+	ionic_vf_dealloc_locked(ionic);
+	up_write(&ionic->vf_op_lock);
+}
+
+static int ionic_vf_alloc(struct ionic *ionic, int num_vfs)
+{
+	struct ionic_vf *v;
+	int err = 0;
+	int i;
+
+	down_write(&ionic->vf_op_lock);
+
+	ionic->vfs = kcalloc(num_vfs, sizeof(struct ionic_vf), GFP_KERNEL);
+	if (!ionic->vfs) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	for (i = 0; i < num_vfs; i++) {
+		v = &ionic->vfs[i];
+		v->stats_pa = dma_map_single(ionic->dev, &v->stats,
+					     sizeof(v->stats), DMA_FROM_DEVICE);
+		if (dma_mapping_error(ionic->dev, v->stats_pa)) {
+			v->stats_pa = 0;
+			err = -ENODEV;
+			goto out;
+		}
+
+		/* ignore failures from older FW, we just won't get stats */
+		(void)ionic_set_vf_config(ionic, i, IONIC_VF_ATTR_STATSADDR,
+					  (u8 *)&v->stats_pa);
+		ionic->num_vfs++;
+	}
+
+out:
+	if (err)
+		ionic_vf_dealloc_locked(ionic);
+	up_write(&ionic->vf_op_lock);
+	return err;
+}
+
+static int ionic_sriov_configure(struct pci_dev *pdev, int num_vfs)
+{
+	struct ionic *ionic = pci_get_drvdata(pdev);
+	struct device *dev = ionic->dev;
+	int ret = 0;
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
+	} else {
+		pci_disable_sriov(pdev);
+		ionic_vf_dealloc(ionic);
+	}
+
+out:
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
@@ -206,6 +308,15 @@ static int ionic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto err_out_free_lifs;
 	}
 
+	init_rwsem(&ionic->vf_op_lock);
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
@@ -223,6 +334,7 @@ static int ionic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 err_out_deregister_lifs:
 	ionic_lifs_unregister(ionic);
 err_out_deinit_lifs:
+	ionic_vf_dealloc(ionic);
 	ionic_lifs_deinit(ionic);
 err_out_free_lifs:
 	ionic_lifs_free(ionic);
@@ -279,6 +391,7 @@ static struct pci_driver ionic_driver = {
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
index a76108a9c7db..191271f6260d 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -1619,6 +1619,227 @@ int ionic_stop(struct net_device *netdev)
 	return err;
 }
 
+static int ionic_get_vf_config(struct net_device *netdev,
+			       int vf, struct ifla_vf_info *ivf)
+{
+	struct ionic_lif *lif = netdev_priv(netdev);
+	struct ionic *ionic = lif->ionic;
+	int ret = 0;
+
+	down_read(&ionic->vf_op_lock);
+
+	if (vf >= pci_num_vf(ionic->pdev) || !ionic->vfs) {
+		ret = -EINVAL;
+	} else {
+		ivf->vf           = vf;
+		ivf->vlan         = ionic->vfs[vf].vlanid;
+		ivf->qos	  = 0;
+		ivf->spoofchk     = ionic->vfs[vf].spoofchk;
+		ivf->linkstate    = ionic->vfs[vf].linkstate;
+		ivf->max_tx_rate  = ionic->vfs[vf].maxrate;
+		ivf->trusted      = ionic->vfs[vf].trusted;
+		ether_addr_copy(ivf->mac, ionic->vfs[vf].macaddr);
+	}
+
+	up_read(&ionic->vf_op_lock);
+	return ret;
+}
+
+static int ionic_get_vf_stats(struct net_device *netdev, int vf,
+			      struct ifla_vf_stats *vf_stats)
+{
+	struct ionic_lif *lif = netdev_priv(netdev);
+	struct ionic *ionic = lif->ionic;
+	struct ionic_lif_stats *vs;
+	int ret = 0;
+
+	down_read(&ionic->vf_op_lock);
+
+	if (vf >= pci_num_vf(ionic->pdev) || !ionic->vfs) {
+		ret = -EINVAL;
+	} else {
+		memset(vf_stats, 0, sizeof(*vf_stats));
+		vs = &ionic->vfs[vf].stats;
+
+		vf_stats->rx_packets = le64_to_cpu(vs->rx_ucast_packets);
+		vf_stats->tx_packets = le64_to_cpu(vs->tx_ucast_packets);
+		vf_stats->rx_bytes   = le64_to_cpu(vs->rx_ucast_bytes);
+		vf_stats->tx_bytes   = le64_to_cpu(vs->tx_ucast_bytes);
+		vf_stats->broadcast  = le64_to_cpu(vs->rx_bcast_packets);
+		vf_stats->multicast  = le64_to_cpu(vs->rx_mcast_packets);
+		vf_stats->rx_dropped = le64_to_cpu(vs->rx_ucast_drop_packets) +
+				       le64_to_cpu(vs->rx_mcast_drop_packets) +
+				       le64_to_cpu(vs->rx_bcast_drop_packets);
+		vf_stats->tx_dropped = le64_to_cpu(vs->tx_ucast_drop_packets) +
+				       le64_to_cpu(vs->tx_mcast_drop_packets) +
+				       le64_to_cpu(vs->tx_bcast_drop_packets);
+	}
+
+	up_read(&ionic->vf_op_lock);
+	return ret;
+}
+
+static int ionic_set_vf_mac(struct net_device *netdev, int vf, u8 *mac)
+{
+	struct ionic_lif *lif = netdev_priv(netdev);
+	struct ionic *ionic = lif->ionic;
+	int ret;
+
+	if (!(is_zero_ether_addr(mac) || is_valid_ether_addr(mac)))
+		return -EINVAL;
+
+	down_read(&ionic->vf_op_lock);
+
+	if (vf >= pci_num_vf(ionic->pdev) || !ionic->vfs) {
+		ret = -EINVAL;
+	} else {
+		ret = ionic_set_vf_config(ionic, vf, IONIC_VF_ATTR_MAC, mac);
+		if (!ret)
+			ether_addr_copy(ionic->vfs[vf].macaddr, mac);
+	}
+
+	up_read(&ionic->vf_op_lock);
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
+	down_read(&ionic->vf_op_lock);
+
+	if (vf >= pci_num_vf(ionic->pdev) || !ionic->vfs) {
+		ret = -EINVAL;
+	} else {
+		ret = ionic_set_vf_config(ionic, vf,
+					  IONIC_VF_ATTR_VLAN, (u8 *)&vlan);
+		if (!ret)
+			ionic->vfs[vf].vlanid = vlan;
+	}
+
+	up_read(&ionic->vf_op_lock);
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
+	/* setting the min just seems silly */
+	if (tx_min)
+		return -EINVAL;
+
+	down_write(&ionic->vf_op_lock);
+
+	if (vf >= pci_num_vf(ionic->pdev) || !ionic->vfs) {
+		ret = -EINVAL;
+	} else {
+		ret = ionic_set_vf_config(ionic, vf,
+					  IONIC_VF_ATTR_RATE, (u8 *)&tx_max);
+		if (!ret)
+			lif->ionic->vfs[vf].maxrate = tx_max;
+	}
+
+	up_write(&ionic->vf_op_lock);
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
+	down_write(&ionic->vf_op_lock);
+
+	if (vf >= pci_num_vf(ionic->pdev) || !ionic->vfs) {
+		ret = -EINVAL;
+	} else {
+		ret = ionic_set_vf_config(ionic, vf,
+					  IONIC_VF_ATTR_SPOOFCHK, &data);
+		if (!ret)
+			ionic->vfs[vf].spoofchk = data;
+	}
+
+	up_write(&ionic->vf_op_lock);
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
+	down_write(&ionic->vf_op_lock);
+
+	if (vf >= pci_num_vf(ionic->pdev) || !ionic->vfs) {
+		ret = -EINVAL;
+	} else {
+		ret = ionic_set_vf_config(ionic, vf,
+					  IONIC_VF_ATTR_TRUST, &data);
+		if (!ret)
+			ionic->vfs[vf].trusted = data;
+	}
+
+	up_write(&ionic->vf_op_lock);
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
+	switch (set) {
+	case IFLA_VF_LINK_STATE_ENABLE:
+		data = IONIC_VF_LINK_STATUS_UP;
+		break;
+	case IFLA_VF_LINK_STATE_DISABLE:
+		data = IONIC_VF_LINK_STATUS_DOWN;
+		break;
+	case IFLA_VF_LINK_STATE_AUTO:
+		data = IONIC_VF_LINK_STATUS_AUTO;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	down_write(&ionic->vf_op_lock);
+
+	if (vf >= pci_num_vf(ionic->pdev) || !ionic->vfs) {
+		ret = -EINVAL;
+	} else {
+		ret = ionic_set_vf_config(ionic, vf,
+					  IONIC_VF_ATTR_LINKSTATE, &data);
+		if (!ret)
+			ionic->vfs[vf].linkstate = set;
+	}
+
+	up_write(&ionic->vf_op_lock);
+	return ret;
+}
+
 static const struct net_device_ops ionic_netdev_ops = {
 	.ndo_open               = ionic_open,
 	.ndo_stop               = ionic_stop,
@@ -1632,6 +1853,14 @@ static const struct net_device_ops ionic_netdev_ops = {
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
@@ -1965,18 +2194,22 @@ static int ionic_station_set(struct ionic_lif *lif)
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

