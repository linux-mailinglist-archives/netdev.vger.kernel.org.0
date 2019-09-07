Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E40EAC94D
	for <lists+netdev@lfdr.de>; Sat,  7 Sep 2019 22:54:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406352AbfIGUyF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Sep 2019 16:54:05 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:46346 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406149AbfIGUyF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Sep 2019 16:54:05 -0400
Received: by mail-wr1-f67.google.com with SMTP id h7so9887915wrt.13
        for <netdev@vger.kernel.org>; Sat, 07 Sep 2019 13:54:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1Px85ccY1M6kZoHc1ORoE9W+AQDSyF7JrgRDIUEZJ9E=;
        b=RZYHZ2Tmt4NKbCwvL/qmT3N+ty9eFRmcLKJT06Jh6aHt70iNDTsL6U7ewGDnoAISKP
         +G2FS4PcHYJK/5QyiGDeef4G+bLAJXIQGkhIaCVFI14qFRicpL8mA1RybWh7arjHtVnp
         +DsZQWKADI/R5WlZx3VN7LdW/kggrkPeDTTt6AVVPcbbmbS0pDTPNOuFs0N2hcjNwP51
         7vY45XMDlU45ZSV788OWVUj7iJlpteY4hAIyvMgDOueRE1qWb0Tbx5HqYSf9a1OgCtPN
         Cdx9kyj5bqdbr8A9KzBWxvj8dsZv5iOMHXIaEVQZ6cQEkyDtnaSIrvHha5bbT/+d4708
         s4+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1Px85ccY1M6kZoHc1ORoE9W+AQDSyF7JrgRDIUEZJ9E=;
        b=ZEYirAdxU+yqJ+ZRZLvxUwlwtgZjcgwIKquuV2GcckUZL0x/keiga61LmYS2jwPnMp
         gu/wiV5rN/90DsnaPJHQsRIyA28YnTfGHSjSyFXrqhHW6+6LtAtQ5x3seRIIWuONEFFC
         /C7k8JFcirmXRO1xV2hdxMWlnQkh5YwEWmwijwxAY+e1kbouXj88et2RMchvxo4KnCDA
         202P9p/DUK6V6EW92Ah3k2G11Fn6jTRhfjPrx1yqMPSB4BCo8l+CZt+82t26mqm0bPek
         d/XCQAELG0jJ8EDvSAQoPe7qGBACedG5YaTZQPgVwFc7U9XxwvyySjoRT/q9Sqf+pg8h
         Gb9g==
X-Gm-Message-State: APjAAAVSzpTrPymuU8TeVS9yRqHvAxQzB0d4FHfQyD6huOKXFY02/x5K
        S46yYVIcFt6gm32umKhjrXWbX4IkKpc=
X-Google-Smtp-Source: APXvYqzMg+ihwkTw8SVCf0cqlSBjbXB2AiIk5mVY7OaetTiFUvT6bR57eARGjQY7w3eVDbsj1K2vPA==
X-Received: by 2002:a5d:5689:: with SMTP id f9mr11463661wrv.224.1567889642465;
        Sat, 07 Sep 2019 13:54:02 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id a190sm11022881wme.8.2019.09.07.13.54.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Sep 2019 13:54:02 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, idosch@mellanox.com, dsahern@gmail.com,
        jakub.kicinski@netronome.com, tariqt@mellanox.com,
        mlxsw@mellanox.com
Subject: [patch net-next v2 1/3] mlx4: Split restart_one into two functions
Date:   Sat,  7 Sep 2019 22:53:58 +0200
Message-Id: <20190907205400.14589-2-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190907205400.14589-1-jiri@resnulli.us>
References: <20190907205400.14589-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Split the function restart_one into two functions and separate teardown
and buildup.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx4/catas.c |  2 +-
 drivers/net/ethernet/mellanox/mlx4/main.c  | 25 ++++++++++++++++++----
 drivers/net/ethernet/mellanox/mlx4/mlx4.h  |  3 +--
 3 files changed, 23 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/catas.c b/drivers/net/ethernet/mellanox/mlx4/catas.c
index 87e90b5d4d7d..5b11557f1ae4 100644
--- a/drivers/net/ethernet/mellanox/mlx4/catas.c
+++ b/drivers/net/ethernet/mellanox/mlx4/catas.c
@@ -210,7 +210,7 @@ static void mlx4_handle_error_state(struct mlx4_dev_persistent *persist)
 	mutex_lock(&persist->interface_state_mutex);
 	if (persist->interface_state & MLX4_INTERFACE_STATE_UP &&
 	    !(persist->interface_state & MLX4_INTERFACE_STATE_DELETION)) {
-		err = mlx4_restart_one(persist->pdev, false, NULL);
+		err = mlx4_restart_one(persist->pdev);
 		mlx4_info(persist->dev, "mlx4_restart_one was ended, ret=%d\n",
 			  err);
 	}
diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
index 07c204bd3fc4..a39c647c12dc 100644
--- a/drivers/net/ethernet/mellanox/mlx4/main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/main.c
@@ -3931,6 +3931,10 @@ static void mlx4_devlink_param_load_driverinit_values(struct devlink *devlink)
 	}
 }
 
+static void mlx4_restart_one_down(struct pci_dev *pdev);
+static int mlx4_restart_one_up(struct pci_dev *pdev, bool reload,
+			       struct devlink *devlink);
+
 static int mlx4_devlink_reload(struct devlink *devlink,
 			       struct netlink_ext_ack *extack)
 {
@@ -3941,9 +3945,11 @@ static int mlx4_devlink_reload(struct devlink *devlink,
 
 	if (persist->num_vfs)
 		mlx4_warn(persist->dev, "Reload performed on PF, will cause reset on operating Virtual Functions\n");
-	err = mlx4_restart_one(persist->pdev, true, devlink);
+	mlx4_restart_one_down(persist->pdev);
+	err = mlx4_restart_one_up(persist->pdev, true, devlink);
 	if (err)
-		mlx4_err(persist->dev, "mlx4_restart_one failed, ret=%d\n", err);
+		mlx4_err(persist->dev, "mlx4_restart_one_up failed, ret=%d\n",
+			 err);
 
 	return err;
 }
@@ -4163,7 +4169,13 @@ static int restore_current_port_types(struct mlx4_dev *dev,
 	return err;
 }
 
-int mlx4_restart_one(struct pci_dev *pdev, bool reload, struct devlink *devlink)
+static void mlx4_restart_one_down(struct pci_dev *pdev)
+{
+	mlx4_unload_one(pdev);
+}
+
+static int mlx4_restart_one_up(struct pci_dev *pdev, bool reload,
+			       struct devlink *devlink)
 {
 	struct mlx4_dev_persistent *persist = pci_get_drvdata(pdev);
 	struct mlx4_dev	 *dev  = persist->dev;
@@ -4175,7 +4187,6 @@ int mlx4_restart_one(struct pci_dev *pdev, bool reload, struct devlink *devlink)
 	total_vfs = dev->persist->num_vfs;
 	memcpy(nvfs, dev->persist->nvfs, sizeof(dev->persist->nvfs));
 
-	mlx4_unload_one(pdev);
 	if (reload)
 		mlx4_devlink_param_load_driverinit_values(devlink);
 	err = mlx4_load_one(pdev, pci_dev_data, total_vfs, nvfs, priv, 1);
@@ -4194,6 +4205,12 @@ int mlx4_restart_one(struct pci_dev *pdev, bool reload, struct devlink *devlink)
 	return err;
 }
 
+int mlx4_restart_one(struct pci_dev *pdev)
+{
+	mlx4_restart_one_down(pdev);
+	return mlx4_restart_one_up(pdev, false, NULL);
+}
+
 #define MLX_SP(id) { PCI_VDEVICE(MELLANOX, id), MLX4_PCI_DEV_FORCE_SENSE_PORT }
 #define MLX_VF(id) { PCI_VDEVICE(MELLANOX, id), MLX4_PCI_DEV_IS_VF }
 #define MLX_GN(id) { PCI_VDEVICE(MELLANOX, id), 0 }
diff --git a/drivers/net/ethernet/mellanox/mlx4/mlx4.h b/drivers/net/ethernet/mellanox/mlx4/mlx4.h
index 23f1b5b512c2..527b52e48276 100644
--- a/drivers/net/ethernet/mellanox/mlx4/mlx4.h
+++ b/drivers/net/ethernet/mellanox/mlx4/mlx4.h
@@ -1043,8 +1043,7 @@ int mlx4_catas_init(struct mlx4_dev *dev);
 void mlx4_catas_end(struct mlx4_dev *dev);
 int mlx4_crdump_init(struct mlx4_dev *dev);
 void mlx4_crdump_end(struct mlx4_dev *dev);
-int mlx4_restart_one(struct pci_dev *pdev, bool reload,
-		     struct devlink *devlink);
+int mlx4_restart_one(struct pci_dev *pdev);
 int mlx4_register_device(struct mlx4_dev *dev);
 void mlx4_unregister_device(struct mlx4_dev *dev);
 void mlx4_dispatch_event(struct mlx4_dev *dev, enum mlx4_dev_event type,
-- 
2.21.0

