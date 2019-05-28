Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C813B2C5AE
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 13:48:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726876AbfE1Ls4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 07:48:56 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:43596 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726787AbfE1Lsy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 07:48:54 -0400
Received: by mail-wr1-f68.google.com with SMTP id l17so11472485wrm.10
        for <netdev@vger.kernel.org>; Tue, 28 May 2019 04:48:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=laEK6SRS34rV66y1oEvCWlXw9mkeWlteG10hrt+z+Fo=;
        b=AujjrJIsfiVQX7pU3YUhpe5xEqxXP4x0j2H02mt3b2wDmtrFxFIuRJW4/f9aDJ1bb6
         1mx3+nEQSD2740x6PAQbJr0dHFrNJFSAk/jg13WgJNPWgy5B0A+TM/v0ls7ftWkHVBI2
         k5wcwhHp1Ztxi2vuwMzqvbJ0MckQRVVJvY+qIRagIJU/fpcZ4VD0/EV9Q80TmQrM+kqu
         B5DmOEzn0GRHEnVReTOOwO99eBlaiI5ADeycSPTILJmw/zQytLmeQ/UarQkN0yuoA2Oc
         VXPi23KI33KyDNvbVWAIbmaK6fDvI8ooeBLRdJBMCmcb1oz6YFR2gYJjuTVz387oJIUY
         A3Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=laEK6SRS34rV66y1oEvCWlXw9mkeWlteG10hrt+z+Fo=;
        b=mDi9hnWka3FCAcem2b+hF1pT+vX88nXNL3zk811t0zWgpEk4qrwMMSfNGwUIUxb6dj
         VeOErj3Q6v1TccHo1XmTDM+rTtLLDtQhp7NrRiVN3RiJvHoxtVPwBwEFphVzYuVSUgpD
         tU5VR7Bh9F2eF3NxQfuEJvjCnrp4ppEjl0OU+yGvjJYYTHCs8gP36WeDUTXQCEX0otV8
         DME3xNgZbrhcJYMOJuOQmK8TRNBr/SxXBtLsX6hSemk19CmDlL3WnPOqrdrGwchn/JIH
         MJMoAxFADGyhj0ImxuQuYDtJxq2hSj7PDL+ImJZYjW+nretM3FW5sBZMI5C1QrFr7sfn
         Ngyg==
X-Gm-Message-State: APjAAAXmgA5Jz7GLZw3R8P1hVRN2UztuxZUyw+R2h1jvGY1KijJ8ifHb
        KIxk8RxK9p6vDeyvJ+7G/O/fCqPURDk=
X-Google-Smtp-Source: APXvYqypHYGnqO68eb8d+2RU2Al0iLiy0cgf1l1omQ8CNsZ5PNxvjhyi8SBVVHgLmrEX6ZtYjAvhiA==
X-Received: by 2002:a05:6000:1285:: with SMTP id f5mr8109947wrx.112.1559044131883;
        Tue, 28 May 2019 04:48:51 -0700 (PDT)
Received: from localhost (ip-89-177-126-215.net.upcbroadband.cz. [89.177.126.215])
        by smtp.gmail.com with ESMTPSA id r2sm2934787wma.26.2019.05.28.04.48.51
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 28 May 2019 04:48:51 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, mlxsw@mellanox.com,
        jakub.kicinski@netronome.com, sthemmin@microsoft.com,
        dsahern@gmail.com, saeedm@mellanox.com, leon@kernel.org,
        f.fainelli@gmail.com
Subject: [patch net-next v2 5/7] mlxfw: Introduce status_notify op and call it to notify about the status
Date:   Tue, 28 May 2019 13:48:44 +0200
Message-Id: <20190528114846.1983-6-jiri@resnulli.us>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20190528114846.1983-1-jiri@resnulli.us>
References: <20190528114846.1983-1-jiri@resnulli.us>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Add new op status_notify which is called to update the user about
flashing status.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
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

