Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D00254989AE
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 19:57:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344005AbiAXS5p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 13:57:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344550AbiAXSyr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 13:54:47 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31A3DC061346
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 10:53:38 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id u11so16647683plh.13
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 10:53:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=OI4rP+JeoPyWCXhhETrKLDuIMO3CdQ/C4uCwN/0EkCU=;
        b=Zma79X3V+rd6IkhvnfCqY4knZiYYeFYpb5XjJPJVjbXbuDhk/5HK8jzXlokOstDqYe
         IK/OVVu8lLlANqzx7LizJnsxArex3M1rf4iOQcSTdDXOIZq+lm31SebxuxGtCn3ypHHe
         TpCXKyEDlAMgJ7/Ubldh05C4a2Lk/HMrLq9xhQTwsTq9jrHyw8wC0lrchN62A79KZWHw
         Y3IE5Smxv4w6Aen1QgS/HLg0L4aOKGS2GWfveCSfH18PpoS05zq2s/JNFHVpUkWA7JyE
         2Vwti5Iy9Nmc0cyaaYhZNxFFAaa5DJHWgwx6sGKul4bepbEGWoMie1bQyKBpY7wp6R1J
         3gzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=OI4rP+JeoPyWCXhhETrKLDuIMO3CdQ/C4uCwN/0EkCU=;
        b=LBqV1+kuKMOLs4CfRj36bcATVBlenuilRLF5C3oDyDXQaOsVIWa+ioOnMQZfH9vZw6
         DLkzZGJonHQ6BC+ZWTHvraFm08pq+M7hrN40ZPW7nKK07+bBkGnngkc5L33wy2b9U5Lx
         UTjOwnxmtpOahCXd8LjOc3u0Vd2aAvLbIOEzLtdtyE6dMmoO8jiJErkXlFfXtKCv34fl
         oKbVRJfHSbdKkURDl2oKq2R9pPWlQknmTtroyupB15yTqyGaQIzpNdEPtzqv+NC7c4q2
         ZNUTRU0SzdQ1Svi6YXsk5AFGd7VENEBX+tcxvpJ/k/ledJQHUvqlnAqT4hvkdGyHNUeU
         Q92g==
X-Gm-Message-State: AOAM5318B1wf2MTmayucS8WLrGROjX+771IiyapblUIP10f36rVZgfOY
        2OEZYlJHws4qhx09KZq/AUtf1A==
X-Google-Smtp-Source: ABdhPJy8AuyQNxb4whKNCctkbA1azs0IZhY9O9LytlnZ5z+TbqJPk5olaevBrzC2skG27x8KfcXmRQ==
X-Received: by 2002:a17:90b:1648:: with SMTP id il8mr3197315pjb.227.1643050417648;
        Mon, 24 Jan 2022 10:53:37 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id cq14sm85177pjb.33.2022.01.24.10.53.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 10:53:37 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Cc:     drivers@pensando.io, Brett Creeley <brett@pensando.io>,
        Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net 10/16] ionic: Query FW when getting VF info via ndo_get_vf_config
Date:   Mon, 24 Jan 2022 10:53:06 -0800
Message-Id: <20220124185312.72646-11-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220124185312.72646-1-snelson@pensando.io>
References: <20220124185312.72646-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brett Creeley <brett@pensando.io>

Currently when an administrator configures a VF via ndo_set_vf*,
the driver will send the set command to FW and then update the
cached value.  The cached value is then used when reporting
VF info via ndo_get_vf_config.

A problem is that the VF info may have been updated between
the last ndo_set_vf* and ndo_get_vf_info commands via some
other method, i.e. a VF changes its MAC address (assuming it's
allowed to do so) and since this is all managed by the FW,
this new value won't be reflected in the PF's cache of values.

To fix this, update the driver to always get the latest VF
information by making use of the IONIC_CMD_VF_GETATTR dev
command. The FW may not support getting all the attributes for
IONIC_CMD_VF_GETATTR, so the driver will only update the cached
VF config members if their associated IONIC_CMD_VF_GETATTR
was successful. Otherwise the cached VF config members will
remain the same as what was set in ndo_set_vf*.

Fixes: fbb39807e9ae ("ionic: support sr-iov operations")
Signed-off-by: Brett Creeley <brett@pensando.io>
Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic.h   |  2 +
 .../net/ethernet/pensando/ionic/ionic_dev.c   | 40 +++++++++
 .../net/ethernet/pensando/ionic/ionic_dev.h   |  2 +
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 90 +++++++++++++++++--
 .../net/ethernet/pensando/ionic/ionic_main.c  | 22 +++++
 5 files changed, 148 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic.h b/drivers/net/ethernet/pensando/ionic/ionic.h
index 6783c0e6ba4f..04fdaf5c1a02 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic.h
@@ -92,4 +92,6 @@ int ionic_port_identify(struct ionic *ionic);
 int ionic_port_init(struct ionic *ionic);
 int ionic_port_reset(struct ionic *ionic);
 
+const char *ionic_vf_attr_to_str(enum ionic_vf_attr attr);
+
 #endif /* _IONIC_H_ */
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.c b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
index 35581cabbae3..1535a40a5fab 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
@@ -472,6 +472,46 @@ int ionic_set_vf_config(struct ionic *ionic, int vf, u8 attr, u8 *data)
 	return err;
 }
 
+int ionic_dev_cmd_vf_getattr(struct ionic *ionic, int vf, u8 attr,
+			     struct ionic_vf_getattr_comp *comp)
+{
+	union ionic_dev_cmd cmd = {
+		.vf_getattr.opcode = IONIC_CMD_VF_GETATTR,
+		.vf_getattr.attr = attr,
+		.vf_getattr.vf_index = cpu_to_le16(vf),
+	};
+	int err;
+
+	if (vf >= ionic->num_vfs)
+		return -EINVAL;
+
+	switch (attr) {
+	case IONIC_VF_ATTR_SPOOFCHK:
+	case IONIC_VF_ATTR_TRUST:
+	case IONIC_VF_ATTR_LINKSTATE:
+	case IONIC_VF_ATTR_MAC:
+	case IONIC_VF_ATTR_VLAN:
+	case IONIC_VF_ATTR_RATE:
+		break;
+	case IONIC_VF_ATTR_STATSADDR:
+	default:
+		return -EINVAL;
+	}
+
+	mutex_lock(&ionic->dev_cmd_lock);
+	ionic_dev_cmd_go(&ionic->idev, &cmd);
+	err = ionic_dev_cmd_wait_nomsg(ionic, DEVCMD_TIMEOUT);
+	memcpy_fromio(comp, &ionic->idev.dev_cmd_regs->comp.vf_getattr,
+		      sizeof(*comp));
+	mutex_unlock(&ionic->dev_cmd_lock);
+
+	if (err && comp->status != IONIC_RC_ENOSUPP)
+		ionic_dev_cmd_dev_err_print(ionic, cmd.vf_getattr.opcode,
+					    comp->status, err);
+
+	return err;
+}
+
 /* LIF commands */
 void ionic_dev_cmd_queue_identify(struct ionic_dev *idev,
 				  u16 lif_type, u8 qtype, u8 qver)
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.h b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
index 73b950ac1272..564c148f5fb4 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
@@ -319,6 +319,8 @@ void ionic_dev_cmd_port_fec(struct ionic_dev *idev, u8 fec_type);
 void ionic_dev_cmd_port_pause(struct ionic_dev *idev, u8 pause_type);
 
 int ionic_set_vf_config(struct ionic *ionic, int vf, u8 attr, u8 *data);
+int ionic_dev_cmd_vf_getattr(struct ionic *ionic, int vf, u8 attr,
+			     struct ionic_vf_getattr_comp *comp);
 void ionic_dev_cmd_queue_identify(struct ionic_dev *idev,
 				  u16 lif_type, u8 qtype, u8 qver);
 void ionic_dev_cmd_lif_identify(struct ionic_dev *idev, u8 type, u8 ver);
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 13c00466023f..adee1b129e92 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -2157,6 +2157,76 @@ static int ionic_eth_ioctl(struct net_device *netdev, struct ifreq *ifr, int cmd
 	}
 }
 
+static int ionic_update_cached_vf_config(struct ionic *ionic, int vf)
+{
+	struct ionic_vf_getattr_comp comp = { 0 };
+	int err;
+	u8 attr;
+
+	attr = IONIC_VF_ATTR_VLAN;
+	err = ionic_dev_cmd_vf_getattr(ionic, vf, attr, &comp);
+	if (err && comp.status != IONIC_RC_ENOSUPP)
+		goto err_out;
+	if (!err)
+		ionic->vfs[vf].vlanid = comp.vlanid;
+
+	attr = IONIC_VF_ATTR_SPOOFCHK;
+	err = ionic_dev_cmd_vf_getattr(ionic, vf, attr, &comp);
+	if (err && comp.status != IONIC_RC_ENOSUPP)
+		goto err_out;
+	if (!err)
+		ionic->vfs[vf].spoofchk = comp.spoofchk;
+
+	attr = IONIC_VF_ATTR_LINKSTATE;
+	err = ionic_dev_cmd_vf_getattr(ionic, vf, attr, &comp);
+	if (err && comp.status != IONIC_RC_ENOSUPP)
+		goto err_out;
+	if (!err) {
+		switch (comp.linkstate) {
+		case IONIC_VF_LINK_STATUS_UP:
+			ionic->vfs[vf].linkstate = IFLA_VF_LINK_STATE_ENABLE;
+			break;
+		case IONIC_VF_LINK_STATUS_DOWN:
+			ionic->vfs[vf].linkstate = IFLA_VF_LINK_STATE_DISABLE;
+			break;
+		case IONIC_VF_LINK_STATUS_AUTO:
+			ionic->vfs[vf].linkstate = IFLA_VF_LINK_STATE_AUTO;
+			break;
+		default:
+			dev_warn(ionic->dev, "Unexpected link state %u\n", comp.linkstate);
+			break;
+		}
+	}
+
+	attr = IONIC_VF_ATTR_RATE;
+	err = ionic_dev_cmd_vf_getattr(ionic, vf, attr, &comp);
+	if (err && comp.status != IONIC_RC_ENOSUPP)
+		goto err_out;
+	if (!err)
+		ionic->vfs[vf].maxrate = comp.maxrate;
+
+	attr = IONIC_VF_ATTR_TRUST;
+	err = ionic_dev_cmd_vf_getattr(ionic, vf, attr, &comp);
+	if (err && comp.status != IONIC_RC_ENOSUPP)
+		goto err_out;
+	if (!err)
+		ionic->vfs[vf].trusted = comp.trust;
+
+	attr = IONIC_VF_ATTR_MAC;
+	err = ionic_dev_cmd_vf_getattr(ionic, vf, attr, &comp);
+	if (err && comp.status != IONIC_RC_ENOSUPP)
+		goto err_out;
+	if (!err)
+		ether_addr_copy(ionic->vfs[vf].macaddr, comp.macaddr);
+
+err_out:
+	if (err)
+		dev_err(ionic->dev, "Failed to get %s for VF %d\n",
+			ionic_vf_attr_to_str(attr), vf);
+
+	return err;
+}
+
 static int ionic_get_vf_config(struct net_device *netdev,
 			       int vf, struct ifla_vf_info *ivf)
 {
@@ -2172,14 +2242,18 @@ static int ionic_get_vf_config(struct net_device *netdev,
 	if (vf >= pci_num_vf(ionic->pdev) || !ionic->vfs) {
 		ret = -EINVAL;
 	} else {
-		ivf->vf           = vf;
-		ivf->vlan         = le16_to_cpu(ionic->vfs[vf].vlanid);
-		ivf->qos	  = 0;
-		ivf->spoofchk     = ionic->vfs[vf].spoofchk;
-		ivf->linkstate    = ionic->vfs[vf].linkstate;
-		ivf->max_tx_rate  = le32_to_cpu(ionic->vfs[vf].maxrate);
-		ivf->trusted      = ionic->vfs[vf].trusted;
-		ether_addr_copy(ivf->mac, ionic->vfs[vf].macaddr);
+		ivf->vf = vf;
+		ivf->qos = 0;
+
+		ret = ionic_update_cached_vf_config(ionic, vf);
+		if (!ret) {
+			ivf->vlan         = le16_to_cpu(ionic->vfs[vf].vlanid);
+			ivf->spoofchk     = ionic->vfs[vf].spoofchk;
+			ivf->linkstate    = ionic->vfs[vf].linkstate;
+			ivf->max_tx_rate  = le32_to_cpu(ionic->vfs[vf].maxrate);
+			ivf->trusted      = ionic->vfs[vf].trusted;
+			ether_addr_copy(ivf->mac, ionic->vfs[vf].macaddr);
+		}
 	}
 
 	up_read(&ionic->vf_op_lock);
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_main.c b/drivers/net/ethernet/pensando/ionic/ionic_main.c
index 163174f07ed7..78771663808a 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_main.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_main.c
@@ -188,6 +188,28 @@ static const char *ionic_opcode_to_str(enum ionic_cmd_opcode opcode)
 	}
 }
 
+const char *ionic_vf_attr_to_str(enum ionic_vf_attr attr)
+{
+	switch (attr) {
+	case IONIC_VF_ATTR_SPOOFCHK:
+		return "IONIC_VF_ATTR_SPOOFCHK";
+	case IONIC_VF_ATTR_TRUST:
+		return "IONIC_VF_ATTR_TRUST";
+	case IONIC_VF_ATTR_LINKSTATE:
+		return "IONIC_VF_ATTR_LINKSTATE";
+	case IONIC_VF_ATTR_MAC:
+		return "IONIC_VF_ATTR_MAC";
+	case IONIC_VF_ATTR_VLAN:
+		return "IONIC_VF_ATTR_VLAN";
+	case IONIC_VF_ATTR_RATE:
+		return "IONIC_VF_ATTR_RATE";
+	case IONIC_VF_ATTR_STATSADDR:
+		return "IONIC_VF_ATTR_STATSADDR";
+	default:
+		return "IONIC_VF_ATTR_UNKNOWN";
+	}
+}
+
 static void ionic_adminq_flush(struct ionic_lif *lif)
 {
 	struct ionic_desc_info *desc_info;
-- 
2.17.1

