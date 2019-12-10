Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1252119E9C
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 23:54:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727340AbfLJWyg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 17:54:36 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:44971 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727257AbfLJWyf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 17:54:35 -0500
Received: by mail-pf1-f196.google.com with SMTP id d199so590505pfd.11
        for <netdev@vger.kernel.org>; Tue, 10 Dec 2019 14:54:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=pIuo0Nt5J2qceraOgR1HpG3DPdFCHMFhqM+YS0Fe04o=;
        b=YZTXRtWs1vu3SCLrq2UXeJGwOKdZ2esZb6OuxLwCGdcbmxjLRZk4aiuDW9cVIJrV6Q
         LHBskeSINLiF332iM0BuCX6Oo5FNizwNSbZkj66KDR5v4CT24bN2NiaxqudxmNklXENg
         r4z2McptYS5+JQoZ5OOQ1QuRkHVTIbPFW/Edh2uZFFTptDroT3DxE+cMOIFa54xgvqoS
         P23de5HgrZWelJmU6IuqANizrLo+jyYq3Iim5ozD+OhDknAApRtYoyqkklHBj44iCB49
         xAT9EYj6GqSjfKiAlDetZ154d8zejU/ZP/hD/Cs10LnaCD2ddyq/4xHg7fKlicylzA8V
         Etfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=pIuo0Nt5J2qceraOgR1HpG3DPdFCHMFhqM+YS0Fe04o=;
        b=he3OcVFP+AdyJUqsCp3E+GxBqxVs8zpDj/iPUkKX3uecWa2CH0NXNkdrTkI4WI1Loo
         boeip+XDuxqAxzv1H/Dm9W46GfE6LE2Ye3xOSXZSQ3SS2tA4JzIHB2jqJ2C5MtAIzojY
         qn7InkrENJx7QlQ+GnxWPumQ/7c2sbYdprb9HIOKvIcGNqbEw0rNYPYVXGVFeVb/Idvz
         VoTHs9+mj4GyPApwgEsJ+lfnhUyJvrjlKCoxs0jBDNqOx48e/YBjDI7SntEnpc3feEBs
         HccDjPRxaBg5KQv0Txspih5ZBuI2s+Grw2j536+cDLefQIaHl/bcXKVS9pZ86f5EnSO7
         FEnQ==
X-Gm-Message-State: APjAAAXmw9STCnzUw0TenNCU2Jt9CwhVwRZCgYY5GFbPYku/NPBkAX9A
        eay9MWxdwdoRg8YZZK+3QCTmZssrc/U=
X-Google-Smtp-Source: APXvYqyHpHCiw+Q2QQwnR7zH1QgHnucIV0bAAx9Nw0hMcnmHvHqq3zqIXRdF9rmVxiCH6vje43XSiQ==
X-Received: by 2002:a63:1e5c:: with SMTP id p28mr549972pgm.235.1576018474314;
        Tue, 10 Dec 2019 14:54:34 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id e12sm46630pjs.3.2019.12.10.14.54.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 10 Dec 2019 14:54:33 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 2/2] ionic: support sr-iov operations
Date:   Tue, 10 Dec 2019 14:54:21 -0800
Message-Id: <20191210225421.35193-3-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191210225421.35193-1-snelson@pensando.io>
References: <20191210225421.35193-1-snelson@pensando.io>
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
 drivers/net/ethernet/pensando/ionic/ionic.h   |  16 +-
 .../ethernet/pensando/ionic/ionic_bus_pci.c   |  75 +++++++
 .../net/ethernet/pensando/ionic/ionic_dev.c   |  61 ++++++
 .../net/ethernet/pensando/ionic/ionic_dev.h   |   7 +
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 188 +++++++++++++++++-
 .../net/ethernet/pensando/ionic/ionic_lif.h   |   6 +
 .../net/ethernet/pensando/ionic/ionic_main.c  |   4 +
 7 files changed, 349 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic.h b/drivers/net/ethernet/pensando/ionic/ionic.h
index 98e102af7756..d4cf58da8d13 100644
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
@@ -46,6 +58,8 @@ struct ionic {
 	DECLARE_BITMAP(intrs, IONIC_INTR_CTRL_REGS_MAX);
 	struct work_struct nb_work;
 	struct notifier_block nb;
+	int num_vfs;
+	struct ionic_vf **vf;
 	struct timer_list watchdog_timer;
 	int watchdog_period;
 };
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
index 9a9ab8cb2cb3..fe4efe12b50b 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
@@ -274,11 +274,86 @@ static void ionic_remove(struct pci_dev *pdev)
 	ionic_devlink_free(ionic);
 }
 
+static int ionic_sriov_configure(struct pci_dev *pdev, int num_vfs)
+{
+	struct ionic *ionic = pci_get_drvdata(pdev);
+	struct device *dev = ionic->dev;
+	unsigned int size;
+	int i, err = 0;
+
+	if (!ionic_is_pf(ionic))
+		return -ENODEV;
+
+	if (num_vfs > 0) {
+		err = pci_enable_sriov(pdev, num_vfs);
+		if (err) {
+			dev_err(&pdev->dev, "Cannot enable SRIOV: %d\n", err);
+			return err;
+		}
+
+		size = sizeof(struct ionic_vf *) * num_vfs;
+		ionic->vf = kzalloc(size, GFP_KERNEL);
+		if (!ionic->vf) {
+			pci_disable_sriov(pdev);
+			return -ENOMEM;
+		}
+
+		for (i = 0; i < num_vfs; i++) {
+			struct ionic_vf *v;
+
+			v = kzalloc(sizeof(*v), GFP_KERNEL);
+			if (!v) {
+				err = -ENOMEM;
+				num_vfs = 0;
+				goto remove_vfs;
+			}
+
+			v->stats_pa = dma_map_single(dev, &v->stats,
+						     sizeof(v->stats),
+						     DMA_FROM_DEVICE);
+			if (dma_mapping_error(dev, v->stats_pa)) {
+				err = -ENODEV;
+				kfree(v);
+				ionic->vf[i] = NULL;
+				num_vfs = 0;
+				goto remove_vfs;
+			}
+
+			ionic->vf[i] = v;
+			ionic->num_vfs++;
+		}
+
+		return num_vfs;
+	}
+
+remove_vfs:
+	if (num_vfs == 0) {
+		if (err)
+			dev_err(&pdev->dev, "SRIOV setup failed: %d\n", err);
+
+		pci_disable_sriov(pdev);
+
+		for (i = 0; i < ionic->num_vfs; i++) {
+			dma_unmap_single(dev, ionic->vf[i]->stats_pa,
+					 sizeof(struct ionic_lif_stats),
+					 DMA_FROM_DEVICE);
+			kfree(ionic->vf[i]);
+		}
+
+		kfree(ionic->vf);
+		ionic->vf = NULL;
+		ionic->num_vfs = 0;
+	}
+
+	return err;
+}
+
 static struct pci_driver ionic_driver = {
 	.name = IONIC_DRV_NAME,
 	.id_table = ionic_id_table,
 	.probe = ionic_probe,
 	.remove = ionic_remove,
+	.sriov_configure = ionic_sriov_configure,
 };
 
 int ionic_bus_register_driver(void)
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.c b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
index 5f9d2ec70446..8f0ab5838667 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
@@ -286,6 +286,67 @@ void ionic_dev_cmd_port_pause(struct ionic_dev *idev, u8 pause_type)
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
+	if (vf >= ionic->num_vfs)
+		return -EINVAL;
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
index 60fd14df49d7..9eb3ce057aa8 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -1616,6 +1616,168 @@ int ionic_stop(struct net_device *netdev)
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
+	ivf->vf           = vf;
+	ivf->vlan         = ionic->vf[vf]->vlanid;
+	ivf->qos	  = 0;
+	ivf->spoofchk     = ionic->vf[vf]->spoofchk;
+	ivf->linkstate    = ionic->vf[vf]->linkstate;
+	ivf->max_tx_rate  = ionic->vf[vf]->maxrate;
+	ivf->trusted      = ionic->vf[vf]->trusted;
+	ether_addr_copy(ivf->mac, ionic->vf[vf]->macaddr);
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
+	return 0;
+}
+
+static int ionic_set_vf_mac(struct net_device *netdev, int vf, u8 *mac)
+{
+	struct ionic_lif *lif = netdev_priv(netdev);
+	int ret;
+
+	if (!(is_zero_ether_addr(mac) || is_valid_ether_addr(mac)))
+		return -EINVAL;
+
+	ret = ionic_set_vf_config(lif->ionic, vf,
+				  IONIC_VF_ATTR_MAC, mac);
+	if (!ret)
+		ether_addr_copy(lif->ionic->vf[vf]->macaddr, mac);
+
+	return ret;
+}
+
+static int ionic_set_vf_vlan(struct net_device *netdev, int vf, u16 vlan,
+			     u8 qos, __be16 proto)
+{
+	struct ionic_lif *lif = netdev_priv(netdev);
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
+	ret = ionic_set_vf_config(lif->ionic, vf,
+				  IONIC_VF_ATTR_VLAN, (u8 *)&vlan);
+	if (!ret)
+		lif->ionic->vf[vf]->vlanid = vlan;
+
+	return ret;
+}
+
+static int ionic_set_vf_rate(struct net_device *netdev, int vf,
+			     int tx_min, int tx_max)
+{
+	struct ionic_lif *lif = netdev_priv(netdev);
+	int ret;
+
+	/* setting the min just seems silly */
+	if (tx_min)
+		return -EINVAL;
+
+	ret = ionic_set_vf_config(lif->ionic, vf,
+				  IONIC_VF_ATTR_RATE, (u8 *)&tx_max);
+	if (!ret)
+		lif->ionic->vf[vf]->maxrate = tx_max;
+
+	return ret;
+}
+
+static int ionic_set_vf_spoofchk(struct net_device *netdev, int vf, bool set)
+{
+	struct ionic_lif *lif = netdev_priv(netdev);
+	u8 data = set;  /* convert to u8 for config */
+	int ret;
+
+	ret = ionic_set_vf_config(lif->ionic, vf,
+				  IONIC_VF_ATTR_SPOOFCHK, &data);
+	if (!ret)
+		lif->ionic->vf[vf]->spoofchk = data;
+
+	return ret;
+}
+
+static int ionic_set_vf_trust(struct net_device *netdev, int vf, bool set)
+{
+	struct ionic_lif *lif = netdev_priv(netdev);
+	u8 data = set;  /* convert to u8 for config */
+	int ret;
+
+	ret = ionic_set_vf_config(lif->ionic, vf,
+				  IONIC_VF_ATTR_TRUST, &data);
+	if (!ret)
+		lif->ionic->vf[vf]->trusted = data;
+
+	return ret;
+}
+
+static int ionic_set_vf_link_state(struct net_device *netdev, int vf, int set)
+{
+	struct ionic_lif *lif = netdev_priv(netdev);
+	u8 data;
+	int ret;
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
+	return ret;
+}
+
 static const struct net_device_ops ionic_netdev_ops = {
 	.ndo_open               = ionic_open,
 	.ndo_stop               = ionic_stop,
@@ -1629,6 +1791,14 @@ static const struct net_device_ops ionic_netdev_ops = {
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
@@ -1961,18 +2131,22 @@ static int ionic_station_set(struct ionic_lif *lif)
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
index a55fd1f8c31b..03b8bd7e3730 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
@@ -195,6 +195,12 @@ static inline int ionic_wait_for_bit(struct ionic_lif *lif, int bitname)
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

