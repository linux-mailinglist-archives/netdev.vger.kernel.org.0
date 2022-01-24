Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D94154989A3
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 19:57:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233167AbiAXS5d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 13:57:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344596AbiAXSyv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 13:54:51 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13894C061364
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 10:53:45 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id d18so3963386plg.2
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 10:53:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=atiah5p2M2X+8gNdWdE4V/GZ2Lqe02AcZhr/ftx73qc=;
        b=rls3E/gUZQhz22fb9GcMK+oXI8lITtRhlmq9ptuWWwF/PZ6Mmv9YOABDTpMiQCp9+w
         evP8GeTMc1lxzd37fOQbuCgLt1wM55ElS/fI+2LiWTLdp9r6cKsPUtI3hXPvpZT34fXT
         LORdcK7r+m2XVcSTUOEhPID+Cf4OIIxjY3s+kWE0gtHNGr/FUjdtnuo6cx8Fw+vQJDDh
         DxZB3IQQgS/7o+M1fuw2R+HhkG2rPelCoOHvUHorenMhR/UmX9yP5j/eBbuQA4n5xCYJ
         mXVcXIy8Kj5wX6zumRLZ4nQ2exX12+3nGhDnoHQO/eRoy1g7szrqV+GHOOfyeCAoXICd
         hjMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=atiah5p2M2X+8gNdWdE4V/GZ2Lqe02AcZhr/ftx73qc=;
        b=tCBpH/P0D1WLII9Mq77Yc93PD9jQLXE2SOOwJJmyvabX8H7m8Yl0NVTCbQ4i6taIk6
         nGlcOwZ2lNnpaZMKsa+aQvnRwXTikWhWPO6B+RnKWBrA9s8dbdNJd7z8f+6LZSvFrVqc
         lexpbLF5jDnpWCfnvX+WST4oG+TWDe1sBMBsNggdKc9wlv9vn+MbNfUT0YOSQYJXu+8c
         ojp/DUXL9qLgAiOWXGU0DUrnSwda6cN6L0WYPDwMiIaAhz6/7wlEIHMozD92DL2WmXT5
         xaaoH/f8Jbz3TLdcTGLf3Ks9lB21fcYxY3wP7DDwf7N0J+1HwiImYJKpN3r5TTI/2TWW
         nypA==
X-Gm-Message-State: AOAM530zLOhgJr4bfqQXIj4pQv1lHmqUzNzFx6Doj65PQWr9T7rWmf67
        LVbcVVJ0t1qzPuiHgiYG11HinQ==
X-Google-Smtp-Source: ABdhPJzOFlRLKWxnwKmRg/INMZMFCqEinSJg1GCrMru/7AG8PBChtz5jbKx2dec+b6vjA2Tc9a5Zrg==
X-Received: by 2002:a17:903:41c9:b0:14b:54e6:c6b7 with SMTP id u9-20020a17090341c900b0014b54e6c6b7mr5276536ple.36.1643050424573;
        Mon, 24 Jan 2022 10:53:44 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id cq14sm85177pjb.33.2022.01.24.10.53.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 10:53:44 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Cc:     drivers@pensando.io, Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net 16/16] ionic: replace set_vf data with union
Date:   Mon, 24 Jan 2022 10:53:12 -0800
Message-Id: <20220124185312.72646-17-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220124185312.72646-1-snelson@pensando.io>
References: <20220124185312.72646-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This (ab)use of a data buffer made some static code checkers
rather itchy, so we replace the a generic data buffer with
the union in the struct ionic_vf_setattr_cmd.

Fixes: fbb39807e9ae ("ionic: support sr-iov operations")
Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../ethernet/pensando/ionic/ionic_bus_pci.c   | 13 ++--
 .../net/ethernet/pensando/ionic/ionic_dev.c   | 45 ++------------
 .../net/ethernet/pensando/ionic/ionic_dev.h   |  3 +-
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 61 +++++++++++++------
 4 files changed, 55 insertions(+), 67 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
index 40fa5bce2ac2..6ffc62c41165 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
@@ -109,8 +109,8 @@ void ionic_bus_unmap_dbpage(struct ionic *ionic, void __iomem *page)
 
 static void ionic_vf_dealloc_locked(struct ionic *ionic)
 {
+	struct ionic_vf_setattr_cmd vfc = { .attr = IONIC_VF_ATTR_STATSADDR };
 	struct ionic_vf *v;
-	dma_addr_t dma = 0;
 	int i;
 
 	if (!ionic->vfs)
@@ -120,9 +120,8 @@ static void ionic_vf_dealloc_locked(struct ionic *ionic)
 		v = &ionic->vfs[i];
 
 		if (v->stats_pa) {
-			(void)ionic_set_vf_config(ionic, i,
-						  IONIC_VF_ATTR_STATSADDR,
-						  (u8 *)&dma);
+			vfc.stats_pa = 0;
+			(void)ionic_set_vf_config(ionic, i, &vfc);
 			dma_unmap_single(ionic->dev, v->stats_pa,
 					 sizeof(v->stats), DMA_FROM_DEVICE);
 			v->stats_pa = 0;
@@ -143,6 +142,7 @@ static void ionic_vf_dealloc(struct ionic *ionic)
 
 static int ionic_vf_alloc(struct ionic *ionic, int num_vfs)
 {
+	struct ionic_vf_setattr_cmd vfc = { .attr = IONIC_VF_ATTR_STATSADDR };
 	struct ionic_vf *v;
 	int err = 0;
 	int i;
@@ -166,9 +166,10 @@ static int ionic_vf_alloc(struct ionic *ionic, int num_vfs)
 		}
 
 		ionic->num_vfs++;
+
 		/* ignore failures from older FW, we just won't get stats */
-		(void)ionic_set_vf_config(ionic, i, IONIC_VF_ATTR_STATSADDR,
-					  (u8 *)&v->stats_pa);
+		vfc.stats_pa = cpu_to_le64(v->stats_pa);
+		(void)ionic_set_vf_config(ionic, i, &vfc);
 	}
 
 out:
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.c b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
index 51d36a549ef7..52a1b5cfd8e7 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
@@ -417,54 +417,17 @@ void ionic_dev_cmd_port_pause(struct ionic_dev *idev, u8 pause_type)
 }
 
 /* VF commands */
-int ionic_set_vf_config(struct ionic *ionic, int vf, u8 attr, u8 *data)
+int ionic_set_vf_config(struct ionic *ionic, int vf,
+			struct ionic_vf_setattr_cmd *vfc)
 {
 	union ionic_dev_cmd cmd = {
 		.vf_setattr.opcode = IONIC_CMD_VF_SETATTR,
-		.vf_setattr.attr = attr,
+		.vf_setattr.attr = vfc->attr,
 		.vf_setattr.vf_index = cpu_to_le16(vf),
 	};
 	int err;
 
-	switch (attr) {
-	case IONIC_VF_ATTR_SPOOFCHK:
-		cmd.vf_setattr.spoofchk = *data;
-		dev_dbg(ionic->dev, "%s: vf %d spoof %d\n",
-			__func__, vf, *data);
-		break;
-	case IONIC_VF_ATTR_TRUST:
-		cmd.vf_setattr.trust = *data;
-		dev_dbg(ionic->dev, "%s: vf %d trust %d\n",
-			__func__, vf, *data);
-		break;
-	case IONIC_VF_ATTR_LINKSTATE:
-		cmd.vf_setattr.linkstate = *data;
-		dev_dbg(ionic->dev, "%s: vf %d linkstate %d\n",
-			__func__, vf, *data);
-		break;
-	case IONIC_VF_ATTR_MAC:
-		ether_addr_copy(cmd.vf_setattr.macaddr, data);
-		dev_dbg(ionic->dev, "%s: vf %d macaddr %pM\n",
-			__func__, vf, data);
-		break;
-	case IONIC_VF_ATTR_VLAN:
-		cmd.vf_setattr.vlanid = cpu_to_le16(*(u16 *)data);
-		dev_dbg(ionic->dev, "%s: vf %d vlan %d\n",
-			__func__, vf, *(u16 *)data);
-		break;
-	case IONIC_VF_ATTR_RATE:
-		cmd.vf_setattr.maxrate = cpu_to_le32(*(u32 *)data);
-		dev_dbg(ionic->dev, "%s: vf %d maxrate %d\n",
-			__func__, vf, *(u32 *)data);
-		break;
-	case IONIC_VF_ATTR_STATSADDR:
-		cmd.vf_setattr.stats_pa = cpu_to_le64(*(u64 *)data);
-		dev_dbg(ionic->dev, "%s: vf %d stats_pa 0x%08llx\n",
-			__func__, vf, *(u64 *)data);
-		break;
-	default:
-		return -EINVAL;
-	}
+	memcpy(cmd.vf_setattr.pad, vfc->pad, sizeof(vfc->pad));
 
 	mutex_lock(&ionic->dev_cmd_lock);
 	ionic_dev_cmd_go(&ionic->idev, &cmd);
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.h b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
index 564c148f5fb4..563c302eb033 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
@@ -318,7 +318,8 @@ void ionic_dev_cmd_port_autoneg(struct ionic_dev *idev, u8 an_enable);
 void ionic_dev_cmd_port_fec(struct ionic_dev *idev, u8 fec_type);
 void ionic_dev_cmd_port_pause(struct ionic_dev *idev, u8 pause_type);
 
-int ionic_set_vf_config(struct ionic *ionic, int vf, u8 attr, u8 *data);
+int ionic_set_vf_config(struct ionic *ionic, int vf,
+			struct ionic_vf_setattr_cmd *vfc);
 int ionic_dev_cmd_vf_getattr(struct ionic *ionic, int vf, u8 attr,
 			     struct ionic_vf_getattr_comp *comp);
 void ionic_dev_cmd_queue_identify(struct ionic_dev *idev,
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 05dd8c4f5466..542e395fb037 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -2299,6 +2299,7 @@ static int ionic_get_vf_stats(struct net_device *netdev, int vf,
 
 static int ionic_set_vf_mac(struct net_device *netdev, int vf, u8 *mac)
 {
+	struct ionic_vf_setattr_cmd vfc = { .attr = IONIC_VF_ATTR_MAC };
 	struct ionic_lif *lif = netdev_priv(netdev);
 	struct ionic *ionic = lif->ionic;
 	int ret;
@@ -2314,7 +2315,11 @@ static int ionic_set_vf_mac(struct net_device *netdev, int vf, u8 *mac)
 	if (vf >= pci_num_vf(ionic->pdev) || !ionic->vfs) {
 		ret = -EINVAL;
 	} else {
-		ret = ionic_set_vf_config(ionic, vf, IONIC_VF_ATTR_MAC, mac);
+		ether_addr_copy(vfc.macaddr, mac);
+		dev_dbg(ionic->dev, "%s: vf %d macaddr %pM\n",
+			__func__, vf, vfc.macaddr);
+
+		ret = ionic_set_vf_config(ionic, vf, &vfc);
 		if (!ret)
 			ether_addr_copy(ionic->vfs[vf].macaddr, mac);
 	}
@@ -2326,6 +2331,7 @@ static int ionic_set_vf_mac(struct net_device *netdev, int vf, u8 *mac)
 static int ionic_set_vf_vlan(struct net_device *netdev, int vf, u16 vlan,
 			     u8 qos, __be16 proto)
 {
+	struct ionic_vf_setattr_cmd vfc = { .attr = IONIC_VF_ATTR_VLAN };
 	struct ionic_lif *lif = netdev_priv(netdev);
 	struct ionic *ionic = lif->ionic;
 	int ret;
@@ -2348,8 +2354,11 @@ static int ionic_set_vf_vlan(struct net_device *netdev, int vf, u16 vlan,
 	if (vf >= pci_num_vf(ionic->pdev) || !ionic->vfs) {
 		ret = -EINVAL;
 	} else {
-		ret = ionic_set_vf_config(ionic, vf,
-					  IONIC_VF_ATTR_VLAN, (u8 *)&vlan);
+		vfc.vlanid = cpu_to_le16(vlan);
+		dev_dbg(ionic->dev, "%s: vf %d vlan %d\n",
+			__func__, vf, le16_to_cpu(vfc.vlanid));
+
+		ret = ionic_set_vf_config(ionic, vf, &vfc);
 		if (!ret)
 			ionic->vfs[vf].vlanid = cpu_to_le16(vlan);
 	}
@@ -2361,6 +2370,7 @@ static int ionic_set_vf_vlan(struct net_device *netdev, int vf, u16 vlan,
 static int ionic_set_vf_rate(struct net_device *netdev, int vf,
 			     int tx_min, int tx_max)
 {
+	struct ionic_vf_setattr_cmd vfc = { .attr = IONIC_VF_ATTR_RATE };
 	struct ionic_lif *lif = netdev_priv(netdev);
 	struct ionic *ionic = lif->ionic;
 	int ret;
@@ -2377,8 +2387,11 @@ static int ionic_set_vf_rate(struct net_device *netdev, int vf,
 	if (vf >= pci_num_vf(ionic->pdev) || !ionic->vfs) {
 		ret = -EINVAL;
 	} else {
-		ret = ionic_set_vf_config(ionic, vf,
-					  IONIC_VF_ATTR_RATE, (u8 *)&tx_max);
+		vfc.maxrate = cpu_to_le32(tx_max);
+		dev_dbg(ionic->dev, "%s: vf %d maxrate %d\n",
+			__func__, vf, le32_to_cpu(vfc.maxrate));
+
+		ret = ionic_set_vf_config(ionic, vf, &vfc);
 		if (!ret)
 			lif->ionic->vfs[vf].maxrate = cpu_to_le32(tx_max);
 	}
@@ -2389,9 +2402,9 @@ static int ionic_set_vf_rate(struct net_device *netdev, int vf,
 
 static int ionic_set_vf_spoofchk(struct net_device *netdev, int vf, bool set)
 {
+	struct ionic_vf_setattr_cmd vfc = { .attr = IONIC_VF_ATTR_SPOOFCHK };
 	struct ionic_lif *lif = netdev_priv(netdev);
 	struct ionic *ionic = lif->ionic;
-	u8 data = set;  /* convert to u8 for config */
 	int ret;
 
 	if (!netif_device_present(netdev))
@@ -2402,10 +2415,13 @@ static int ionic_set_vf_spoofchk(struct net_device *netdev, int vf, bool set)
 	if (vf >= pci_num_vf(ionic->pdev) || !ionic->vfs) {
 		ret = -EINVAL;
 	} else {
-		ret = ionic_set_vf_config(ionic, vf,
-					  IONIC_VF_ATTR_SPOOFCHK, &data);
+		vfc.spoofchk = set;
+		dev_dbg(ionic->dev, "%s: vf %d spoof %d\n",
+			__func__, vf, vfc.spoofchk);
+
+		ret = ionic_set_vf_config(ionic, vf, &vfc);
 		if (!ret)
-			ionic->vfs[vf].spoofchk = data;
+			ionic->vfs[vf].spoofchk = set;
 	}
 
 	up_write(&ionic->vf_op_lock);
@@ -2414,9 +2430,9 @@ static int ionic_set_vf_spoofchk(struct net_device *netdev, int vf, bool set)
 
 static int ionic_set_vf_trust(struct net_device *netdev, int vf, bool set)
 {
+	struct ionic_vf_setattr_cmd vfc = { .attr = IONIC_VF_ATTR_TRUST };
 	struct ionic_lif *lif = netdev_priv(netdev);
 	struct ionic *ionic = lif->ionic;
-	u8 data = set;  /* convert to u8 for config */
 	int ret;
 
 	if (!netif_device_present(netdev))
@@ -2427,10 +2443,13 @@ static int ionic_set_vf_trust(struct net_device *netdev, int vf, bool set)
 	if (vf >= pci_num_vf(ionic->pdev) || !ionic->vfs) {
 		ret = -EINVAL;
 	} else {
-		ret = ionic_set_vf_config(ionic, vf,
-					  IONIC_VF_ATTR_TRUST, &data);
+		vfc.trust = set;
+		dev_dbg(ionic->dev, "%s: vf %d trust %d\n",
+			__func__, vf, vfc.trust);
+
+		ret = ionic_set_vf_config(ionic, vf, &vfc);
 		if (!ret)
-			ionic->vfs[vf].trusted = data;
+			ionic->vfs[vf].trusted = set;
 	}
 
 	up_write(&ionic->vf_op_lock);
@@ -2439,20 +2458,21 @@ static int ionic_set_vf_trust(struct net_device *netdev, int vf, bool set)
 
 static int ionic_set_vf_link_state(struct net_device *netdev, int vf, int set)
 {
+	struct ionic_vf_setattr_cmd vfc = { .attr = IONIC_VF_ATTR_LINKSTATE };
 	struct ionic_lif *lif = netdev_priv(netdev);
 	struct ionic *ionic = lif->ionic;
-	u8 data;
+	u8 vfls;
 	int ret;
 
 	switch (set) {
 	case IFLA_VF_LINK_STATE_ENABLE:
-		data = IONIC_VF_LINK_STATUS_UP;
+		vfls = IONIC_VF_LINK_STATUS_UP;
 		break;
 	case IFLA_VF_LINK_STATE_DISABLE:
-		data = IONIC_VF_LINK_STATUS_DOWN;
+		vfls = IONIC_VF_LINK_STATUS_DOWN;
 		break;
 	case IFLA_VF_LINK_STATE_AUTO:
-		data = IONIC_VF_LINK_STATUS_AUTO;
+		vfls = IONIC_VF_LINK_STATUS_AUTO;
 		break;
 	default:
 		return -EINVAL;
@@ -2466,8 +2486,11 @@ static int ionic_set_vf_link_state(struct net_device *netdev, int vf, int set)
 	if (vf >= pci_num_vf(ionic->pdev) || !ionic->vfs) {
 		ret = -EINVAL;
 	} else {
-		ret = ionic_set_vf_config(ionic, vf,
-					  IONIC_VF_ATTR_LINKSTATE, &data);
+		vfc.linkstate = vfls;
+		dev_dbg(ionic->dev, "%s: vf %d linkstate %d\n",
+			__func__, vf, vfc.linkstate);
+
+		ret = ionic_set_vf_config(ionic, vf, &vfc);
 		if (!ret)
 			ionic->vfs[vf].linkstate = set;
 	}
-- 
2.17.1

