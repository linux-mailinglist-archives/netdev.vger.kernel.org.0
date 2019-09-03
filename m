Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12BBFA76F5
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 00:28:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727205AbfICW2y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 18:28:54 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:33355 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726813AbfICW2v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Sep 2019 18:28:51 -0400
Received: by mail-pg1-f194.google.com with SMTP id n190so10015495pgn.0
        for <netdev@vger.kernel.org>; Tue, 03 Sep 2019 15:28:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=NgV/jSFZSlF/mgJCx8nYYNy5qr0pHJgYsMYy7WAzv2E=;
        b=B4b6AVVlqWuA1QBiy58Tg7fkTh4+eiNmyKW3jMHCX5Ee14HIRc02UpSY6sjJ3o5NWL
         aHZ75pVIee3rV8cI2ptrKxfwLefIFLzIfCqlhvXx9s7+tlHxSTpFyUPn/Cp9kBmisEFP
         KDJ+Z6nxcHJjtyPY16FsHJDuACY0n0g1afq8uU1vmBaZpDhRDSfUki07tBYnBx38BUTH
         QSW8FKka6tg9+fpp4omUcV5hnZIZzVsTFE4yuxF5Xfs5nNc4s/GrDLwyDHyKKkfY+UGm
         D5jzXsixiYRRx0FW4fQ/hw2sY6ZPuX+cgNjj8yVEnyqahlyngg6EDdxzQK8RLq9phhy1
         HDnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=NgV/jSFZSlF/mgJCx8nYYNy5qr0pHJgYsMYy7WAzv2E=;
        b=uOH68PUauaZtGQyxy7PIMVMgfZ/n08qXDfz3dvMk99P5lWld0JF2uNon6DXKiF3r5B
         GR3Z0+a0WkWm2L3y9SUIP7M/mMrJ9GMVZ1oGG3DbyjBflCmmKdYJHb1JrL3yBx4s4Rn0
         3E2WRYMl9OdqtZC1A3JDy6oM7sJMDkxN8x8jM4XqaWjMBTAuO4bnzthA7AqGR4DnOsHR
         6FNZJvl+Y47MEI2I5pR+bo1tgpfjidnDRlNhMZEISv5AV84/HIFUlC9yFFPwGlV6n83+
         ChRNkeDtXMaQmpDiUhmCD1XYnWkqabLeuHUmv5VeheynS8wJijP+xdlufar+ezksF0zF
         esgQ==
X-Gm-Message-State: APjAAAWkdfJROAp5lcHSKCPgAH6e3zr8nqeE2irQPSXH3TaIMYUhQn3K
        VIti5UtXaYm1ODmAJ8ZWN78sQA==
X-Google-Smtp-Source: APXvYqzPWTZruuJ9/xj8z9dUewPJLwC55yJXxC2aXk/hV9iCSmwxuYMB48IgKgwS6F6XcveW+ZemXw==
X-Received: by 2002:a17:90a:c501:: with SMTP id k1mr1659185pjt.37.1567549731084;
        Tue, 03 Sep 2019 15:28:51 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id e17sm520520pjt.6.2019.09.03.15.28.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 03 Sep 2019 15:28:50 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     snelson@pensando.io, netdev@vger.kernel.org, davem@davemloft.net
Subject: [PATCH v7 net-next 04/19] ionic: Add port management commands
Date:   Tue,  3 Sep 2019 15:28:06 -0700
Message-Id: <20190903222821.46161-5-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190903222821.46161-1-snelson@pensando.io>
References: <20190903222821.46161-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The port management commands apply to the physical port
associated with the PCI device, which might be shared among
several logical interfaces.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic.h   |  4 +
 .../ethernet/pensando/ionic/ionic_bus_pci.c   | 16 ++++
 .../net/ethernet/pensando/ionic/ionic_dev.c   | 92 +++++++++++++++++++
 .../net/ethernet/pensando/ionic/ionic_dev.h   | 13 +++
 .../net/ethernet/pensando/ionic/ionic_main.c  | 88 ++++++++++++++++++
 5 files changed, 213 insertions(+)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic.h b/drivers/net/ethernet/pensando/ionic/ionic.h
index 89ad9c590736..4960effd2bcc 100644
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
index 286b4b450a73..804dd43e92a6 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
@@ -138,12 +138,27 @@ static int ionic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
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
 	err = ionic_devlink_register(ionic);
 	if (err)
 		dev_err(dev, "Cannot register devlink: %d\n", err);
 
 	return 0;
 
+err_out_reset:
+	ionic_reset(ionic);
 err_out_teardown:
 	ionic_dev_teardown(ionic);
 err_out_unmap_bars:
@@ -170,6 +185,7 @@ static void ionic_remove(struct pci_dev *pdev)
 		return;
 
 	ionic_devlink_unregister(ionic);
+	ionic_port_reset(ionic);
 	ionic_reset(ionic);
 	ionic_dev_teardown(ionic);
 	ionic_unmap_bars(ionic);
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.c b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
index 0bf1bd6bd7b1..3137776e9191 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
@@ -134,3 +134,95 @@ void ionic_dev_cmd_reset(struct ionic_dev *idev)
 
 	ionic_dev_cmd_go(idev, &cmd);
 }
+
+/* Port commands */
+void ionic_dev_cmd_port_identify(struct ionic_dev *idev)
+{
+	union ionic_dev_cmd cmd = {
+		.port_init.opcode = IONIC_CMD_PORT_IDENTIFY,
+		.port_init.index = 0,
+	};
+
+	ionic_dev_cmd_go(idev, &cmd);
+}
+
+void ionic_dev_cmd_port_init(struct ionic_dev *idev)
+{
+	union ionic_dev_cmd cmd = {
+		.port_init.opcode = IONIC_CMD_PORT_INIT,
+		.port_init.index = 0,
+		.port_init.info_pa = cpu_to_le64(idev->port_info_pa),
+	};
+
+	ionic_dev_cmd_go(idev, &cmd);
+}
+
+void ionic_dev_cmd_port_reset(struct ionic_dev *idev)
+{
+	union ionic_dev_cmd cmd = {
+		.port_reset.opcode = IONIC_CMD_PORT_RESET,
+		.port_reset.index = 0,
+	};
+
+	ionic_dev_cmd_go(idev, &cmd);
+}
+
+void ionic_dev_cmd_port_state(struct ionic_dev *idev, u8 state)
+{
+	union ionic_dev_cmd cmd = {
+		.port_setattr.opcode = IONIC_CMD_PORT_SETATTR,
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
+	union ionic_dev_cmd cmd = {
+		.port_setattr.opcode = IONIC_CMD_PORT_SETATTR,
+		.port_setattr.index = 0,
+		.port_setattr.attr = IONIC_PORT_ATTR_SPEED,
+		.port_setattr.speed = cpu_to_le32(speed),
+	};
+
+	ionic_dev_cmd_go(idev, &cmd);
+}
+
+void ionic_dev_cmd_port_autoneg(struct ionic_dev *idev, u8 an_enable)
+{
+	union ionic_dev_cmd cmd = {
+		.port_setattr.opcode = IONIC_CMD_PORT_SETATTR,
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
+	union ionic_dev_cmd cmd = {
+		.port_setattr.opcode = IONIC_CMD_PORT_SETATTR,
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
+	union ionic_dev_cmd cmd = {
+		.port_setattr.opcode = IONIC_CMD_PORT_SETATTR,
+		.port_setattr.index = 0,
+		.port_setattr.attr = IONIC_PORT_ATTR_PAUSE,
+		.port_setattr.pause_type = pause_type,
+	};
+
+	ionic_dev_cmd_go(idev, &cmd);
+}
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.h b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
index 7050545a83aa..81b6910aabc1 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
@@ -117,6 +117,10 @@ struct ionic_dev {
 	struct ionic_intr __iomem *intr_ctrl;
 	u64 __iomem *intr_status;
 
+	u32 port_info_sz;
+	struct ionic_port_info *port_info;
+	dma_addr_t port_info_pa;
+
 	struct ionic_devinfo dev_info;
 };
 
@@ -135,4 +139,13 @@ void ionic_dev_cmd_identify(struct ionic_dev *idev, u8 ver);
 void ionic_dev_cmd_init(struct ionic_dev *idev);
 void ionic_dev_cmd_reset(struct ionic_dev *idev);
 
+void ionic_dev_cmd_port_identify(struct ionic_dev *idev);
+void ionic_dev_cmd_port_init(struct ionic_dev *idev);
+void ionic_dev_cmd_port_reset(struct ionic_dev *idev);
+void ionic_dev_cmd_port_state(struct ionic_dev *idev, u8 state);
+void ionic_dev_cmd_port_speed(struct ionic_dev *idev, u32 speed);
+void ionic_dev_cmd_port_autoneg(struct ionic_dev *idev, u8 an_enable);
+void ionic_dev_cmd_port_fec(struct ionic_dev *idev, u8 fec_type);
+void ionic_dev_cmd_port_pause(struct ionic_dev *idev, u8 pause_type);
+
 #endif /* _IONIC_DEV_H_ */
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_main.c b/drivers/net/ethernet/pensando/ionic/ionic_main.c
index 45b83ba20305..d7e62d31bff0 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_main.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_main.c
@@ -303,6 +303,94 @@ int ionic_reset(struct ionic *ionic)
 	return err;
 }
 
+int ionic_port_identify(struct ionic *ionic)
+{
+	struct ionic_identity *ident = &ionic->ident;
+	struct ionic_dev *idev = &ionic->idev;
+	size_t sz;
+	int err;
+
+	mutex_lock(&ionic->dev_cmd_lock);
+
+	ionic_dev_cmd_port_identify(idev);
+	err = ionic_dev_cmd_wait(ionic, DEVCMD_TIMEOUT);
+	if (!err) {
+		sz = min(sizeof(ident->port), sizeof(idev->dev_cmd_regs->data));
+		memcpy_fromio(&ident->port, &idev->dev_cmd_regs->data, sz);
+	}
+
+	mutex_unlock(&ionic->dev_cmd_lock);
+
+	return err;
+}
+
+int ionic_port_init(struct ionic *ionic)
+{
+	struct ionic_identity *ident = &ionic->ident;
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
+	err = ionic_dev_cmd_wait(ionic, DEVCMD_TIMEOUT);
+
+	ionic_dev_cmd_port_state(&ionic->idev, IONIC_PORT_ADMIN_STATE_UP);
+	(void)ionic_dev_cmd_wait(ionic, DEVCMD_TIMEOUT);
+
+	mutex_unlock(&ionic->dev_cmd_lock);
+	if (err) {
+		dev_err(ionic->dev, "Failed to init port\n");
+		dma_free_coherent(ionic->dev, idev->port_info_sz,
+				  idev->port_info, idev->port_info_pa);
+		idev->port_info = NULL;
+		idev->port_info_pa = 0;
+	}
+
+	return err;
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
+	err = ionic_dev_cmd_wait(ionic, DEVCMD_TIMEOUT);
+	mutex_unlock(&ionic->dev_cmd_lock);
+
+	dma_free_coherent(ionic->dev, idev->port_info_sz,
+			  idev->port_info, idev->port_info_pa);
+
+	idev->port_info = NULL;
+	idev->port_info_pa = 0;
+
+	if (err)
+		dev_err(ionic->dev, "Failed to reset port\n");
+
+	return err;
+}
+
 static int __init ionic_init_module(void)
 {
 	pr_info("%s %s, ver %s\n",
-- 
2.17.1

