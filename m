Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 643A64DB1A
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 22:24:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726809AbfFTUYe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 16:24:34 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:38186 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725907AbfFTUYd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jun 2019 16:24:33 -0400
Received: by mail-pf1-f196.google.com with SMTP id a186so2295226pfa.5
        for <netdev@vger.kernel.org>; Thu, 20 Jun 2019 13:24:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=HEVOoCLLh4bGiLpKf8TqVjsGFwu21RvWzipLge0NjKs=;
        b=eBmoJz1Zy4/s2ugsIJmnkwLqzvkbvEu++qskomx9Q3zc0R0cxOyn55KraUEmQpgU0I
         jl4tYI0Z6jnuf5Qwtne9yVten/QkenbKS+WZ7bbpVYcS9scYvSLwWkcW2BVGGChbNgSQ
         hnAPdGidE/cuB2zG5/z9l6C41hwNP8RVLizqJyvbBy+iO6GZYkjkV5OYNlqnmFOorj0Q
         H2Kv3ZsqyAmtalUu3xzCKAtxx3cj899Bmh71/roCy2KkqegzQRyhUItnBJiUmcHBly9H
         oLwTff9BryP2wJthtJDn0A6LvqsEwOm7yFuDZ/zo52SUzjqD6tLP384M/GBzu4A+0NBU
         Mhcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=HEVOoCLLh4bGiLpKf8TqVjsGFwu21RvWzipLge0NjKs=;
        b=ng/CFLGklQ+vbuXhkDqFOPkBqq5cQg/3J13iCk+CMOtrr8PzZwuxVDLDJxXfjcTLAQ
         0o2LsUWgCUPICrOuhg2qLWKjSLNHeQwkb6obxV88oAfd0Cg+sCPIakH+983I2qd6nhH6
         hwD4qQJ03Kw8xG89qa3ysD887HUhkDn352C3QX8oRbQX8dacPWlRy9FJ4W9uO8DN6NYE
         GhCv332e2dpKqtGG9D2ckxgxR/p/5K5jdExKKLg6fa38iRzDtPPHZVOp+vfnBEVeK4th
         hqfsuiVGBJYshiyQQSq+gmsllSVc5PZ6r2HY5d38Cw5k7CeF3nC+80CfUMn2FS6yI0el
         yzfw==
X-Gm-Message-State: APjAAAX+gKIJCHsweuwc87ObC5c0veU2xCGrr6t+BN9lD4I4rvhvStSM
        h4Li+LsaxexdhOdyQGRgNDMAng==
X-Google-Smtp-Source: APXvYqzjgShOp6RYeFSuJ3KoLIDq8BHGe5yFrzh901gTRxtCwYeo8bRyu356kRvTG+WdPDL1+1b0Hw==
X-Received: by 2002:a17:90a:480d:: with SMTP id a13mr1487564pjh.40.1561062272399;
        Thu, 20 Jun 2019 13:24:32 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id h26sm340537pfq.64.2019.06.20.13.24.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 20 Jun 2019 13:24:31 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     snelson@pensando.io, netdev@vger.kernel.org
Subject: [PATCH net-next 03/18] ionic: Add port management commands
Date:   Thu, 20 Jun 2019 13:24:09 -0700
Message-Id: <20190620202424.23215-4-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190620202424.23215-1-snelson@pensando.io>
References: <20190620202424.23215-1-snelson@pensando.io>
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
index f19503c5aca6..a1ed9bc486dd 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic.h
@@ -45,4 +45,8 @@ int ionic_identify(struct ionic *ionic);
 int ionic_init(struct ionic *ionic);
 int ionic_reset(struct ionic *ionic);
 
+int ionic_port_identify(struct ionic *ionic);
+int ionic_port_init(struct ionic *ionic);
+int ionic_port_reset(struct ionic *ionic);
+
 #endif /* _IONIC_H_ */
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
index 018ed00ff566..407988f17796 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
@@ -145,10 +145,25 @@ static int ionic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
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
 	dev_info(ionic->dev, "attached\n");
 
 	return 0;
 
+err_out_reset:
+	ionic_reset(ionic);
 err_out_teardown:
 	ionic_dev_teardown(ionic);
 err_out_unmap_bars:
@@ -172,6 +187,7 @@ static void ionic_remove(struct pci_dev *pdev)
 	struct ionic *ionic = pci_get_drvdata(pdev);
 
 	if (ionic) {
+		ionic_port_reset(ionic);
 		ionic_reset(ionic);
 		ionic_dev_teardown(ionic);
 		ionic_unmap_bars(ionic);
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.c b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
index f3e457853a5a..55fd2881aac3 100644
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
index 2ac1ed12a81d..36314f865b94 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_main.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_main.c
@@ -309,6 +309,101 @@ int ionic_reset(struct ionic *ionic)
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

