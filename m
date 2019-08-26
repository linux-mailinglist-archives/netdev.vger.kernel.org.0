Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F8BA9D891
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 23:34:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729097AbfHZVdy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 17:33:54 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:43313 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728793AbfHZVdx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Aug 2019 17:33:53 -0400
Received: by mail-pl1-f193.google.com with SMTP id 4so10652068pld.10
        for <netdev@vger.kernel.org>; Mon, 26 Aug 2019 14:33:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=4vSAx3Qi6RRaN5ZXjpekMJ9nEhFWapKOiOrFEnTd+ys=;
        b=yJK7K7MQUwP152PGHI6u24zNy443HfRuZhyR+C3NupMYTUqG+wRBLLVjIW2L3rDqEb
         nJBKXmsxrrihWJe+10QNWDmH40JvX3+Fu6JR7NjtT5hTFdCFEutQiPuC+pXvQYBruE+Q
         wL7oTQgZCYUw8cgjNcUxZHx4QPO4dKQJ2rLdePp3lrm3kx6mFDnJgSoQ64DkTKdsPzU+
         17xkrmA12KLpwFPoidpHb1M4HqLIsC3KwkWGf3XG1a3vCKKmxhvwLINQq+rrwdDrW46k
         xP/FEwIDq9uBQRJclIcKw4rxMs7Ht9KmF6PaDdCgNUIQcbFxCa7Oe2ui/wyhMdX8WUBq
         J8Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=4vSAx3Qi6RRaN5ZXjpekMJ9nEhFWapKOiOrFEnTd+ys=;
        b=El9ZrbP/f+h/CBwiDAENb5K2lau485Ck20vi3zB3HGxVXdPt/AF0MaIe/7N3nEEF4N
         sF/eXUyU92BRWQ4dWkbnuVGl4ES6r1S5PXdKT2xOjnULsP0hr0aexHEdpyni9L4jw1p5
         594IwnNx8R25v0fyLsYY/MjgEkgV7Ptafhq6bw2h0KsfEkgzuulZiXbtoGoYOF21Jdxl
         CdAtpzHQs1x8uA+b8PxO0lq7eQz10N1LdB/AEvzF64KJRzA7CnrN2+akToTOR/Yikyzl
         5TfOwTAPM9LoaC9Svh+nFzL/U+4wUf8zPLoXKSwQhwhmZTgmZwtsz0bE1Wfn4OGJXynz
         bmVA==
X-Gm-Message-State: APjAAAXyfTzV+ua8VWXreIGsYGYMNCVakitmOutgsNEH1klAAr0OPWR/
        9ObmEnzNwvSjVSCPzpDrNdIbKg==
X-Google-Smtp-Source: APXvYqxRw01tiI4SBPHyXuzNXjGT3KHoIM7t0Ruhfs6MJLsQFZTrs2X88W4hg3f83sFL+DrklGlhYA==
X-Received: by 2002:a17:902:8484:: with SMTP id c4mr20920394plo.223.1566855232334;
        Mon, 26 Aug 2019 14:33:52 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id j9sm5876905pfi.128.2019.08.26.14.33.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Aug 2019 14:33:51 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     snelson@pensando.io, netdev@vger.kernel.org, davem@davemloft.net
Subject: [PATCH v5 net-next 03/18] ionic: Add port management commands
Date:   Mon, 26 Aug 2019 14:33:24 -0700
Message-Id: <20190826213339.56909-4-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190826213339.56909-1-snelson@pensando.io>
References: <20190826213339.56909-1-snelson@pensando.io>
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
 .../net/ethernet/pensando/ionic/ionic_main.c  |  86 +++++++++++++
 5 files changed, 237 insertions(+)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic.h b/drivers/net/ethernet/pensando/ionic/ionic.h
index 1f3c4a916849..db2ad14899d3 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic.h
@@ -44,4 +44,8 @@ int ionic_identify(struct ionic *ionic);
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
index 0bf1bd6bd7b1..cddd41a43550 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
@@ -134,3 +134,119 @@ void ionic_dev_cmd_reset(struct ionic_dev *idev)
 
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
+void ionic_dev_cmd_port_mtu(struct ionic_dev *idev, u32 mtu)
+{
+	union ionic_dev_cmd cmd = {
+		.port_setattr.opcode = IONIC_CMD_PORT_SETATTR,
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
+
+void ionic_dev_cmd_port_loopback(struct ionic_dev *idev, u8 loopback_mode)
+{
+	union ionic_dev_cmd cmd = {
+		.port_setattr.opcode = IONIC_CMD_PORT_SETATTR,
+		.port_setattr.index = 0,
+		.port_setattr.attr = IONIC_PORT_ATTR_LOOPBACK,
+		.port_setattr.loopback_mode = loopback_mode,
+	};
+
+	ionic_dev_cmd_go(idev, &cmd);
+}
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.h b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
index 30a5206bba4e..5b83f21af18a 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
@@ -122,6 +122,10 @@ struct ionic_dev {
 	struct ionic_intr __iomem *intr_ctrl;
 	u64 __iomem *intr_status;
 
+	u32 port_info_sz;
+	struct ionic_port_info *port_info;
+	dma_addr_t port_info_pa;
+
 	struct ionic_devinfo dev_info;
 };
 
@@ -140,4 +144,15 @@ void ionic_dev_cmd_identify(struct ionic_dev *idev, u8 ver);
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
index f52eb6c50358..47928f184230 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_main.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_main.c
@@ -309,6 +309,92 @@ int ionic_reset(struct ionic *ionic)
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
+	err = ionic_dev_cmd_wait(ionic, devcmd_timeout);
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
+	err = ionic_dev_cmd_wait(ionic, devcmd_timeout);
+
+	ionic_dev_cmd_port_state(&ionic->idev, IONIC_PORT_ADMIN_STATE_UP);
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
 	pr_info("%s %s, ver %s\n",
-- 
2.17.1

