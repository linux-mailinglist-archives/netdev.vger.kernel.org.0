Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06B5A34921
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 15:41:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727823AbfFDNlA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 09:41:00 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:39526 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727719AbfFDNky (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 09:40:54 -0400
Received: by mail-wm1-f66.google.com with SMTP id z23so93688wma.4
        for <netdev@vger.kernel.org>; Tue, 04 Jun 2019 06:40:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=BRhuSyE6UCohJUZ9s8GR3j6mbNNiDsPz+HkCnf+nWTs=;
        b=EF6MNtLY3VV78vC4G+/BKTITgNXMKOWu7mXJf2pOeZTHvwD8RScPpeJaLPvsDC1faA
         YBFomks1v8P0bUhVTnyL+CA7mA09MFAbIrjY+xHTGzqls22j+Yv1Jc2pA+jRkuXPbdmN
         bhxwVupfTrEvTG+8hVPUwBqNqBuPMqi8Hpmr/JjrvwhrS/2xyVCJSh0d1XmQ2gVCdXUz
         4Ktuv6oiMRkPy+4QpUxsYMwOHqxppm5dqojspeFcHkzxIts2IIZPLgwixqHnXf35C3YH
         thHwXJ4/HEFsZbzufvjRH/kKl4ceAbUqCm2HA6iMOcULv9vNghHT2ZDzw68sIUJxxA8z
         ALbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=BRhuSyE6UCohJUZ9s8GR3j6mbNNiDsPz+HkCnf+nWTs=;
        b=Qr0LnC5kzqOrdNJO/cnZHTudlPf6Z9+8b+xvAOyPOu9AIcNFwKyzpo98GQlz2f3YdG
         M5bO/FRoGqZ3b5LAXR2niPDaPxZo7EWjRaXOpMAxZelCVfbl/jQ7weZ7MfTo3bsYgO46
         9ROdZSPHuWwV2Ut5q+ddDlIjcN7LDzQzIMUx/7U8pRmkd9LwNaI3YBxOADQh6lylR5v/
         IngWlo5bJzKWiKrUnZXAlW6tBt8dh3ohS8kw/HLT3LWYFKQRaUvsSbLNVh/1FZ5zgiXL
         hQx+Bk+xi8SJlNbBjOmeQn1r+qIp1KBctCjJQJBLRsjHxPMgLVHuAsYp/hjLkQcyqZ4h
         7q3Q==
X-Gm-Message-State: APjAAAVSsDB9FQADSxXogyyUDIxKCpbl4g9QAuSB19DnFKo/n/gmNvfW
        4xg0zWR2GDSRnahLTiVd6rIqf8CYiXxkwsKm
X-Google-Smtp-Source: APXvYqzj+XWkhkVdl2TFkMRzXrNarWBsmDc5N8uI/F/TWMI4UDTSB7HUJ5SPEcyfte++//Sem7ixhQ==
X-Received: by 2002:a7b:c444:: with SMTP id l4mr6376089wmi.15.1559655653108;
        Tue, 04 Jun 2019 06:40:53 -0700 (PDT)
Received: from localhost (ip-62-245-91-87.net.upcbroadband.cz. [62.245.91.87])
        by smtp.gmail.com with ESMTPSA id c7sm8743137wrp.57.2019.06.04.06.40.52
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 04 Jun 2019 06:40:52 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, mlxsw@mellanox.com,
        jakub.kicinski@netronome.com, sthemmin@microsoft.com,
        dsahern@gmail.com, saeedm@mellanox.com, leon@kernel.org,
        f.fainelli@gmail.com
Subject: [patch net-next v3 7/8] netdevsim: implement fake flash updating with notifications
Date:   Tue,  4 Jun 2019 15:40:43 +0200
Message-Id: <20190604134044.2613-8-jiri@resnulli.us>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20190604134044.2613-1-jiri@resnulli.us>
References: <20190604134044.2613-1-jiri@resnulli.us>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
v1->v2:
- added debugfs toggle to enable/disable flash status notifications
---
 drivers/net/netdevsim/dev.c       | 44 +++++++++++++++++++++++++++++++
 drivers/net/netdevsim/netdevsim.h |  1 +
 2 files changed, 45 insertions(+)

diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index b509b941d5ca..c5c417a3c0ce 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -38,6 +38,8 @@ static int nsim_dev_debugfs_init(struct nsim_dev *nsim_dev)
 	nsim_dev->ports_ddir = debugfs_create_dir("ports", nsim_dev->ddir);
 	if (IS_ERR_OR_NULL(nsim_dev->ports_ddir))
 		return PTR_ERR_OR_ZERO(nsim_dev->ports_ddir) ?: -EINVAL;
+	debugfs_create_bool("fw_update_status", 0600, nsim_dev->ddir,
+			    &nsim_dev->fw_update_status);
 	return 0;
 }
 
@@ -220,8 +222,49 @@ static int nsim_dev_reload(struct devlink *devlink,
 	return 0;
 }
 
+#define NSIM_DEV_FLASH_SIZE 500000
+#define NSIM_DEV_FLASH_CHUNK_SIZE 1000
+#define NSIM_DEV_FLASH_CHUNK_TIME_MS 10
+
+static int nsim_dev_flash_update(struct devlink *devlink, const char *file_name,
+				 const char *component,
+				 struct netlink_ext_ack *extack)
+{
+	struct nsim_dev *nsim_dev = devlink_priv(devlink);
+	int i;
+
+	if (nsim_dev->fw_update_status) {
+		devlink_flash_update_begin_notify(devlink);
+		devlink_flash_update_status_notify(devlink,
+						   "Preparing to flash",
+						   component, 0, 0);
+	}
+
+	for (i = 0; i < NSIM_DEV_FLASH_SIZE / NSIM_DEV_FLASH_CHUNK_SIZE; i++) {
+		if (nsim_dev->fw_update_status)
+			devlink_flash_update_status_notify(devlink, "Flashing",
+							   component,
+							   i * NSIM_DEV_FLASH_CHUNK_SIZE,
+							   NSIM_DEV_FLASH_SIZE);
+		msleep(NSIM_DEV_FLASH_CHUNK_TIME_MS);
+	}
+
+	if (nsim_dev->fw_update_status) {
+		devlink_flash_update_status_notify(devlink, "Flashing",
+						   component,
+						   NSIM_DEV_FLASH_SIZE,
+						   NSIM_DEV_FLASH_SIZE);
+		devlink_flash_update_status_notify(devlink, "Flashing done",
+						   component, 0, 0);
+		devlink_flash_update_end_notify(devlink);
+	}
+
+	return 0;
+}
+
 static const struct devlink_ops nsim_dev_devlink_ops = {
 	.reload = nsim_dev_reload,
+	.flash_update = nsim_dev_flash_update,
 };
 
 static struct nsim_dev *
@@ -240,6 +283,7 @@ nsim_dev_create(struct nsim_bus_dev *nsim_bus_dev, unsigned int port_count)
 	get_random_bytes(nsim_dev->switch_id.id, nsim_dev->switch_id.id_len);
 	INIT_LIST_HEAD(&nsim_dev->port_list);
 	mutex_init(&nsim_dev->port_list_lock);
+	nsim_dev->fw_update_status = true;
 
 	nsim_dev->fib_data = nsim_fib_create();
 	if (IS_ERR(nsim_dev->fib_data)) {
diff --git a/drivers/net/netdevsim/netdevsim.h b/drivers/net/netdevsim/netdevsim.h
index 3f398797c2bc..79c05af2a7c0 100644
--- a/drivers/net/netdevsim/netdevsim.h
+++ b/drivers/net/netdevsim/netdevsim.h
@@ -157,6 +157,7 @@ struct nsim_dev {
 	struct netdev_phys_item_id switch_id;
 	struct list_head port_list;
 	struct mutex port_list_lock; /* protects port list */
+	bool fw_update_status;
 };
 
 int nsim_dev_init(void);
-- 
2.17.2

