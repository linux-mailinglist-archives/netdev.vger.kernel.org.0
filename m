Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7E7A5A66A
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 23:39:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726789AbfF1Vjs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 17:39:48 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:44321 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726752AbfF1Vjr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 17:39:47 -0400
Received: by mail-pf1-f196.google.com with SMTP id t16so3610923pfe.11
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 14:39:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=p1sBuoWxuL8jBkY5i/ELmrrh5MEQ5h52IdHvVhwgFx4=;
        b=HY0+VrCBydZ1xE4pDeB8Xd8iG4Sj3LBjvm8vx/kLesOe5XrNJpAK3fnUE8YWx1+HP+
         6EuodbpoPmUPOOpizy4rGYzZsDUKgHPztTT1uE9aUY1ubhTQ69T94qfhldh0G9w4GczF
         Wk/vL6GNMC8qgKiQqqm+AGp4b2LgEVNs9DFVd/C8DRwSGrAfYQptO2UP01xtpj6piOXR
         N54aKSPUDKbhI8QKF3fEf98sb0r471KxkSqrllbhH648doZGXOAL3Gaox67w/mCyX3CV
         xGDROmX6QvBw82M+1kcEukkhzBLswkEHisG5zFJI0i4QbH1Sj+XAKfolOiZpKYC+hva3
         owFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=p1sBuoWxuL8jBkY5i/ELmrrh5MEQ5h52IdHvVhwgFx4=;
        b=n0VbUnlKpP5v3bP/PeQrr+cTRuoZ6GtPekeuvZ68w/M2CwbHsNvH5Nm9EpbEoTd6lU
         Cw6VkQ7FJblFbAQfTMj9ajWOl231/cAxVYVMNV9NCwhgDh38c4Zaej0LXnj2s0qaTZ/1
         I2ttVC5W1vC9n2Pg0Xht0+nuvpFs6qAkXI5NIKbnUAZky4EV5dMtqymSP7yn9KCqnJNL
         hw9VHGc+FUnHC5AdT3hwVIqMfRMIFDN9+IZPKtoGm8JS2EdY0DhC1VHmYEHV6u6gx7pU
         mczinu3BBwy6iMEY9R6WsNNuZT7LLsgH+O5ZL8meicNMsGOnCIKioSkKGloMAwViv0oC
         zU7g==
X-Gm-Message-State: APjAAAXjbOUSh+XIijq0OP9ZjonEbMifwXOT0bR/LZHfs17X+smN+SiT
        54eph8WB8ZGyRYB2J+QRgClWoQR3NY4=
X-Google-Smtp-Source: APXvYqxtm113qrUk/xZnV7MNd2v3guhkho4NZoMgyPXyuKQTfOOjXbpbuolH+4be/X0o6edfXMjN9w==
X-Received: by 2002:a65:6241:: with SMTP id q1mr11162849pgv.24.1561757986079;
        Fri, 28 Jun 2019 14:39:46 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id 135sm3516920pfb.137.2019.06.28.14.39.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 28 Jun 2019 14:39:45 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     snelson@pensando.io, netdev@vger.kernel.org
Subject: [PATCH v2 net-next 03/19] ionic: Add port management commands
Date:   Fri, 28 Jun 2019 14:39:18 -0700
Message-Id: <20190628213934.8810-4-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190628213934.8810-1-snelson@pensando.io>
References: <20190628213934.8810-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The port management commands apply to the physical port
associated with the PCI device, which might be shared among
several logical interfaces.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic.h   |   4 +
 .../ethernet/pensando/ionic/ionic_bus_pci.c   |  16 +++
 .../net/ethernet/pensando/ionic/ionic_dev.c   | 116 ++++++++++++++++++
 .../net/ethernet/pensando/ionic/ionic_dev.h   |  15 +++
 .../net/ethernet/pensando/ionic/ionic_main.c  |  95 ++++++++++++++
 5 files changed, 246 insertions(+)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic.h b/drivers/net/ethernet/pensando/ionic/ionic.h
index 4fd0ae86556a..f77712feef5c 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic.h
@@ -42,4 +42,8 @@ int ionic_identify(struct ionic *ionic);
 int ionic_init(struct ionic *ionic);
 int ionic_reset(struct ionic *ionic);
 
+int ionic_port_identify(struct ionic *ionic);
+int ionic_port_init(struct ionic *ionic);
+int ionic_port_reset(struct ionic *ionic);
+
 #endif /* _IONIC_H_ */
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
index 7eb23f0e87ac..7a41f8995c35 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
@@ -137,8 +137,23 @@ static int ionic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto err_out_teardown;
 	}
 
+	/* Configure the ports */
+	err = ionic_port_identify(ionic);
+	if (err) {
+		dev_err(dev, "Cannot identify port: %d, aborting\n", err);
+		goto err_out_reset;
+	}
+
+	err = ionic_port_init(ionic);
+	if (err) {
+		dev_err(dev, "Cannot init port: %d, aborting\n", err);
+		goto err_out_reset;
+	}
+
 	return 0;
 
+err_out_reset:
+	ionic_reset(ionic);
 err_out_teardown:
 	ionic_dev_teardown(ionic);
 err_out_unmap_bars:
@@ -162,6 +177,7 @@ static void ionic_remove(struct pci_dev *pdev)
 	struct ionic *ionic = pci_get_drvdata(pdev);
 
 	if (ionic) {
+		ionic_port_reset(ionic);
 		ionic_reset(ionic);
 		ionic_dev_teardown(ionic);
 		ionic_unmap_bars(ionic);
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.c b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
index ca2ef0a1f620..e2eda2bedac6 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
@@ -130,3 +130,119 @@ void ionic_dev_cmd_reset(struct ionic_dev *idev)
 
 	ionic_dev_cmd_go(idev, &cmd);
 }
+
+/* Port commands */
+void ionic_dev_cmd_port_identify(struct ionic_dev *idev)
+{
+	union dev_cmd cmd = {
+		.port_init.opcode = CMD_OPCODE_PORT_IDENTIFY,
+		.port_init.index = 0,
+	};
+
+	ionic_dev_cmd_go(idev, &cmd);
+}
+
+void ionic_dev_cmd_port_init(struct ionic_dev *idev)
+{
+	union dev_cmd cmd = {
+		.port_init.opcode = CMD_OPCODE_PORT_INIT,
+		.port_init.index = 0,
+		.port_init.info_pa = cpu_to_le64(idev->port_info_pa),
+	};
+
+	ionic_dev_cmd_go(idev, &cmd);
+}
+
+void ionic_dev_cmd_port_reset(struct ionic_dev *idev)
+{
+	union dev_cmd cmd = {
+		.port_reset.opcode = CMD_OPCODE_PORT_RESET,
+		.port_reset.index = 0,
+	};
+
+	ionic_dev_cmd_go(idev, &cmd);
+}
+
+void ionic_dev_cmd_port_state(struct ionic_dev *idev, u8 state)
+{
+	union dev_cmd cmd = {
+		.port_setattr.opcode = CMD_OPCODE_PORT_SETATTR,
+		.port_setattr.index = 0,
+		.port_setattr.attr = IONIC_PORT_ATTR_STATE,
+		.port_setattr.state = state,
+	};
+
+	ionic_dev_cmd_go(idev, &cmd);
+}
+
+void ionic_dev_cmd_port_speed(struct ionic_dev *idev, u32 speed)
+{
+	union dev_cmd cmd = {
+		.port_setattr.opcode = CMD_OPCODE_PORT_SETATTR,
+		.port_setattr.index = 0,
+		.port_setattr.attr = IONIC_PORT_ATTR_SPEED,
+		.port_setattr.speed = cpu_to_le32(speed),
+	};
+
+	ionic_dev_cmd_go(idev, &cmd);
+}
+
+void ionic_dev_cmd_port_mtu(struct ionic_dev *idev, u32 mtu)
+{
+	union dev_cmd cmd = {
+		.port_setattr.opcode = CMD_OPCODE_PORT_SETATTR,
+		.port_setattr.index = 0,
+		.port_setattr.attr = IONIC_PORT_ATTR_MTU,
+		.port_setattr.mtu = cpu_to_le32(mtu),
+	};
+
+	ionic_dev_cmd_go(idev, &cmd);
+}
+
+void ionic_dev_cmd_port_autoneg(struct ionic_dev *idev, u8 an_enable)
+{
+	union dev_cmd cmd = {
+		.port_setattr.opcode = CMD_OPCODE_PORT_SETATTR,
+		.port_setattr.index = 0,
+		.port_setattr.attr = IONIC_PORT_ATTR_AUTONEG,
+		.port_setattr.an_enable = an_enable,
+	};
+
+	ionic_dev_cmd_go(idev, &cmd);
+}
+
+void ionic_dev_cmd_port_fec(struct ionic_dev *idev, u8 fec_type)
+{
+	union dev_cmd cmd = {
+		.port_setattr.opcode = CMD_OPCODE_PORT_SETATTR,
+		.port_setattr.index = 0,
+		.port_setattr.attr = IONIC_PORT_ATTR_FEC,
+		.port_setattr.fec_type = fec_type,
+	};
+
+	ionic_dev_cmd_go(idev, &cmd);
+}
+
+void ionic_dev_cmd_port_pause(struct ionic_dev *idev, u8 pause_type)
+{
+	union dev_cmd cmd = {
+		.port_setattr.opcode = CMD_OPCODE_PORT_SETATTR,
+		.port_setattr.index = 0,
+		.port_setattr.attr = IONIC_PORT_ATTR_PAUSE,
+		.port_setattr.pause_type = pause_type,
+	};
+
+	ionic_dev_cmd_go(idev, &cmd);
+}
+
+void ionic_dev_cmd_port_loopback(struct ionic_dev *idev, u8 loopback_mode)
+{
+	union dev_cmd cmd = {
+		.port_setattr.opcode = CMD_OPCODE_PORT_SETATTR,
+		.port_setattr.index = 0,
+		.port_setattr.attr = IONIC_PORT_ATTR_LOOPBACK,
+		.port_setattr.loopback_mode = loopback_mode,
+	};
+
+	ionic_dev_cmd_go(idev, &cmd);
+}
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.h b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
index 66afab3ee396..fe5e1b0e8d55 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
@@ -123,6 +123,10 @@ struct ionic_dev {
 	struct ionic_intr __iomem *intr_ctrl;
 	u64 __iomem *intr_status;
 
+	struct port_info *port_info;
+	dma_addr_t port_info_pa;
+	u32 port_info_sz;
+
 	struct ionic_devinfo dev_info;
 };
 
@@ -141,4 +145,15 @@ void ionic_dev_cmd_identify(struct ionic_dev *idev, u8 ver);
 void ionic_dev_cmd_init(struct ionic_dev *idev);
 void ionic_dev_cmd_reset(struct ionic_dev *idev);
 
+void ionic_dev_cmd_port_identify(struct ionic_dev *idev);
+void ionic_dev_cmd_port_init(struct ionic_dev *idev);
+void ionic_dev_cmd_port_reset(struct ionic_dev *idev);
+void ionic_dev_cmd_port_state(struct ionic_dev *idev, u8 state);
+void ionic_dev_cmd_port_speed(struct ionic_dev *idev, u32 speed);
+void ionic_dev_cmd_port_mtu(struct ionic_dev *idev, u32 mtu);
+void ionic_dev_cmd_port_autoneg(struct ionic_dev *idev, u8 an_enable);
+void ionic_dev_cmd_port_fec(struct ionic_dev *idev, u8 fec_type);
+void ionic_dev_cmd_port_pause(struct ionic_dev *idev, u8 pause_type);
+void ionic_dev_cmd_port_loopback(struct ionic_dev *idev, u8 loopback_mode);
+
 #endif /* _IONIC_DEV_H_ */
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_main.c b/drivers/net/ethernet/pensando/ionic/ionic_main.c
index 567ed259b398..78eab326b067 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_main.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_main.c
@@ -307,6 +307,101 @@ int ionic_reset(struct ionic *ionic)
 	return err;
 }
 
+int ionic_port_identify(struct ionic *ionic)
+{
+	struct identity *ident = &ionic->ident;
+	struct ionic_dev *idev = &ionic->idev;
+	struct device *dev = ionic->dev;
+	size_t sz;
+	int err;
+
+	mutex_lock(&ionic->dev_cmd_lock);
+
+	ionic_dev_cmd_port_identify(idev);
+	err = ionic_dev_cmd_wait(ionic, devcmd_timeout);
+	if (!err) {
+		sz = min(sizeof(ident->port), sizeof(idev->dev_cmd_regs->data));
+		memcpy_fromio(&ident->port, &idev->dev_cmd_regs->data, sz);
+	}
+
+	mutex_unlock(&ionic->dev_cmd_lock);
+
+	dev_dbg(dev, "speed %d\n", ident->port.config.speed);
+	dev_dbg(dev, "mtu %d\n", ident->port.config.mtu);
+	dev_dbg(dev, "state %d\n", ident->port.config.state);
+	dev_dbg(dev, "an_enable %d\n", ident->port.config.an_enable);
+	dev_dbg(dev, "fec_type %d\n", ident->port.config.fec_type);
+	dev_dbg(dev, "pause_type %d\n", ident->port.config.pause_type);
+	dev_dbg(dev, "loopback_mode %d\n", ident->port.config.loopback_mode);
+
+	return err;
+}
+
+int ionic_port_init(struct ionic *ionic)
+{
+	struct identity *ident = &ionic->ident;
+	struct ionic_dev *idev = &ionic->idev;
+	size_t sz;
+	int err;
+
+	if (idev->port_info)
+		return 0;
+
+	idev->port_info_sz = ALIGN(sizeof(*idev->port_info), PAGE_SIZE);
+	idev->port_info = dma_alloc_coherent(ionic->dev, idev->port_info_sz,
+					     &idev->port_info_pa,
+					     GFP_KERNEL);
+	if (!idev->port_info) {
+		dev_err(ionic->dev, "Failed to allocate port info, aborting\n");
+		return -ENOMEM;
+	}
+
+	sz = min(sizeof(ident->port.config), sizeof(idev->dev_cmd_regs->data));
+
+	mutex_lock(&ionic->dev_cmd_lock);
+
+	memcpy_toio(&idev->dev_cmd_regs->data, &ident->port.config, sz);
+	ionic_dev_cmd_port_init(idev);
+	err = ionic_dev_cmd_wait(ionic, devcmd_timeout);
+
+	ionic_dev_cmd_port_state(&ionic->idev, PORT_ADMIN_STATE_UP);
+	(void)ionic_dev_cmd_wait(ionic, devcmd_timeout);
+
+	mutex_unlock(&ionic->dev_cmd_lock);
+	if (err) {
+		dev_err(ionic->dev, "Failed to init port\n");
+		return err;
+	}
+
+	return 0;
+}
+
+int ionic_port_reset(struct ionic *ionic)
+{
+	struct ionic_dev *idev = &ionic->idev;
+	int err;
+
+	if (!idev->port_info)
+		return 0;
+
+	mutex_lock(&ionic->dev_cmd_lock);
+	ionic_dev_cmd_port_reset(idev);
+	err = ionic_dev_cmd_wait(ionic, devcmd_timeout);
+	mutex_unlock(&ionic->dev_cmd_lock);
+	if (err) {
+		dev_err(ionic->dev, "Failed to reset port\n");
+		return err;
+	}
+
+	dma_free_coherent(ionic->dev, idev->port_info_sz,
+			  idev->port_info, idev->port_info_pa);
+
+	idev->port_info = NULL;
+	idev->port_info_pa = 0;
+
+	return err;
+}
+
 static int __init ionic_init_module(void)
 {
 	ionic_struct_size_checks();
-- 
2.17.1

