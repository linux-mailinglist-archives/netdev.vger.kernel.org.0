Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37BF23491E
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 15:41:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727815AbfFDNk5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 09:40:57 -0400
Received: from mail-wm1-f52.google.com ([209.85.128.52]:40286 "EHLO
        mail-wm1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727517AbfFDNkx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 09:40:53 -0400
Received: by mail-wm1-f52.google.com with SMTP id u16so86563wmc.5
        for <netdev@vger.kernel.org>; Tue, 04 Jun 2019 06:40:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=v0L763+ny3R0v1ouRTjZ20JjUIEb0Fq0/Ed1cQzuAFU=;
        b=NMaBC9G/zyDYr5USb9oQMYSiwEQBuq03nNisZvG63YVEhZ2CaCGmB5SalZnbhGCIZx
         qzDrH2VUGlzp5Ygcgli5jPaYuMP8eUctqC60gH81sabptLtegRS38yXj1rbGrCIvKBh/
         UcanpIt5Uk0x9mRo5Eq3fR0p8kQo9LNANtrY4+/w8dY31bSEM6A5vaNjqQWheh2ilKyk
         w3cibaIU7SUjZ/oYxsoEO8wRWTKo27VvjbrYXDLkKbARuoYf7CTT/h9zULjrRG2+s6ce
         +2MDUvdBftFxCtu/qF4mOMTNfuK//mn4q5+vqnWulZNRuv1bpQLY9+sEKEAtE0pefax2
         Tn4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=v0L763+ny3R0v1ouRTjZ20JjUIEb0Fq0/Ed1cQzuAFU=;
        b=sEBBWDZ1COIblH+o32a/UH3ftsg7SIzJSeyxMlWe4tF/ioutXCKsKfUZ45Wvn4osMa
         5EWDTGGOcCNeWNtPvVcmFn6NZ6n7UmFLdxLtDG6D47/Z07GnvJVHGynOx7FEpEJctGBm
         S+15rFjKlSKgO3rvxwmGNr63EABL7MW7sTQtClUvSoza2c1+HZ6HcY5/LKjb8KwmhcMI
         ya590l0OV9LchslNuzG9PmM1JUlWGciz9aEMfBuyDRZuehhcUw0rpXBYzPd+8+K9+KLw
         g1cqvg3UGpWVEHwjGO+3JUTBrQo4VicTFbjJcaRqmVJm5b3Mrlhqie4XWUQ11o4rKS1c
         bedA==
X-Gm-Message-State: APjAAAWDIy7o/pmKzQ1iLTsbrOXipXS4Cm8demn/G/fxZTj99X2OVjso
        mOHZSFP1jjyUU9nCHjjWsLGEO6k1WoWkj1GI
X-Google-Smtp-Source: APXvYqxnsXoHKi5TwGlYZ5uB4Nwz2vaCjEQb6zmr1pvu4KqzkeBieZzD6YDPJx5D9yf9uNNBj/YrvQ==
X-Received: by 2002:a1c:c909:: with SMTP id f9mr6272360wmb.115.1559655650900;
        Tue, 04 Jun 2019 06:40:50 -0700 (PDT)
Received: from localhost (ip-62-245-91-87.net.upcbroadband.cz. [62.245.91.87])
        by smtp.gmail.com with ESMTPSA id t14sm19266987wrr.33.2019.06.04.06.40.50
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 04 Jun 2019 06:40:50 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, mlxsw@mellanox.com,
        jakub.kicinski@netronome.com, sthemmin@microsoft.com,
        dsahern@gmail.com, saeedm@mellanox.com, leon@kernel.org,
        f.fainelli@gmail.com
Subject: [patch net-next v3 5/8] mlxfw: Introduce status_notify op and call it to notify about the status
Date:   Tue,  4 Jun 2019 15:40:41 +0200
Message-Id: <20190604134044.2613-6-jiri@resnulli.us>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20190604134044.2613-1-jiri@resnulli.us>
References: <20190604134044.2613-1-jiri@resnulli.us>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Add new op status_notify which is called to update the user about
flashing status.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Reviewed-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxfw/mlxfw.h   |  4 ++++
 .../net/ethernet/mellanox/mlxfw/mlxfw_fsm.c   | 24 +++++++++++++++++++
 2 files changed, 28 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxfw/mlxfw.h b/drivers/net/ethernet/mellanox/mlxfw/mlxfw.h
index 83286b90593f..c50e74ab02c4 100644
--- a/drivers/net/ethernet/mellanox/mlxfw/mlxfw.h
+++ b/drivers/net/ethernet/mellanox/mlxfw/mlxfw.h
@@ -58,6 +58,10 @@ struct mlxfw_dev_ops {
 	void (*fsm_cancel)(struct mlxfw_dev *mlxfw_dev, u32 fwhandle);
 
 	void (*fsm_release)(struct mlxfw_dev *mlxfw_dev, u32 fwhandle);
+
+	void (*status_notify)(struct mlxfw_dev *mlxfw_dev,
+			      const char *msg, const char *comp_name,
+			      u32 done_bytes, u32 total_bytes);
 };
 
 struct mlxfw_dev {
diff --git a/drivers/net/ethernet/mellanox/mlxfw/mlxfw_fsm.c b/drivers/net/ethernet/mellanox/mlxfw/mlxfw_fsm.c
index 61c32c43a309..67990406cba2 100644
--- a/drivers/net/ethernet/mellanox/mlxfw/mlxfw_fsm.c
+++ b/drivers/net/ethernet/mellanox/mlxfw/mlxfw_fsm.c
@@ -39,6 +39,16 @@ static const char * const mlxfw_fsm_state_err_str[] = {
 		"unknown error"
 };
 
+static void mlxfw_status_notify(struct mlxfw_dev *mlxfw_dev,
+				const char *msg, const char *comp_name,
+				u32 done_bytes, u32 total_bytes)
+{
+	if (!mlxfw_dev->ops->status_notify)
+		return;
+	mlxfw_dev->ops->status_notify(mlxfw_dev, msg, comp_name,
+				      done_bytes, total_bytes);
+}
+
 static int mlxfw_fsm_state_wait(struct mlxfw_dev *mlxfw_dev, u32 fwhandle,
 				enum mlxfw_fsm_state fsm_state,
 				struct netlink_ext_ack *extack)
@@ -85,11 +95,14 @@ static int mlxfw_flash_component(struct mlxfw_dev *mlxfw_dev,
 	u16 comp_max_write_size;
 	u8 comp_align_bits;
 	u32 comp_max_size;
+	char comp_name[8];
 	u16 block_size;
 	u8 *block_ptr;
 	u32 offset;
 	int err;
 
+	sprintf(comp_name, "%u", comp->index);
+
 	err = mlxfw_dev->ops->component_query(mlxfw_dev, comp->index,
 					      &comp_max_size, &comp_align_bits,
 					      &comp_max_write_size);
@@ -108,6 +121,7 @@ static int mlxfw_flash_component(struct mlxfw_dev *mlxfw_dev,
 					       comp_align_bits);
 
 	pr_debug("Component update\n");
+	mlxfw_status_notify(mlxfw_dev, "Updating component", comp_name, 0, 0);
 	err = mlxfw_dev->ops->fsm_component_update(mlxfw_dev, fwhandle,
 						   comp->index,
 						   comp->data_size);
@@ -120,6 +134,8 @@ static int mlxfw_flash_component(struct mlxfw_dev *mlxfw_dev,
 		goto err_out;
 
 	pr_debug("Component download\n");
+	mlxfw_status_notify(mlxfw_dev, "Downloading component",
+			    comp_name, 0, comp->data_size);
 	for (offset = 0;
 	     offset < MLXFW_ALIGN_UP(comp->data_size, comp_align_bits);
 	     offset += comp_max_write_size) {
@@ -131,9 +147,13 @@ static int mlxfw_flash_component(struct mlxfw_dev *mlxfw_dev,
 							 offset);
 		if (err)
 			goto err_out;
+		mlxfw_status_notify(mlxfw_dev, "Downloading component",
+				    comp_name, offset + block_size,
+				    comp->data_size);
 	}
 
 	pr_debug("Component verify\n");
+	mlxfw_status_notify(mlxfw_dev, "Verifying component", comp_name, 0, 0);
 	err = mlxfw_dev->ops->fsm_component_verify(mlxfw_dev, fwhandle,
 						   comp->index);
 	if (err)
@@ -203,6 +223,8 @@ int mlxfw_firmware_flash(struct mlxfw_dev *mlxfw_dev,
 		return PTR_ERR(mfa2_file);
 
 	pr_info("Initialize firmware flash process\n");
+	mlxfw_status_notify(mlxfw_dev, "Initializing firmware flash process",
+			    NULL, 0, 0);
 	err = mlxfw_dev->ops->fsm_lock(mlxfw_dev, &fwhandle);
 	if (err) {
 		pr_err("Could not lock the firmware FSM\n");
@@ -220,6 +242,7 @@ int mlxfw_firmware_flash(struct mlxfw_dev *mlxfw_dev,
 		goto err_flash_components;
 
 	pr_debug("Activate image\n");
+	mlxfw_status_notify(mlxfw_dev, "Activating image", NULL, 0, 0);
 	err = mlxfw_dev->ops->fsm_activate(mlxfw_dev, fwhandle);
 	if (err) {
 		pr_err("Could not activate the downloaded image\n");
@@ -236,6 +259,7 @@ int mlxfw_firmware_flash(struct mlxfw_dev *mlxfw_dev,
 	mlxfw_dev->ops->fsm_release(mlxfw_dev, fwhandle);
 
 	pr_info("Firmware flash done.\n");
+	mlxfw_status_notify(mlxfw_dev, "Firmware flash done", NULL, 0, 0);
 	mlxfw_mfa2_file_fini(mfa2_file);
 	return 0;
 
-- 
2.17.2

