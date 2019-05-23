Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CBAF2799B
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 11:45:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730394AbfEWJp2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 05:45:28 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:36703 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730361AbfEWJp1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 05:45:27 -0400
Received: by mail-wr1-f65.google.com with SMTP id s17so5526377wru.3
        for <netdev@vger.kernel.org>; Thu, 23 May 2019 02:45:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=CgXZbizam1RnsDqM0Z4K0o38rQq4gyxPW0XYuQ/q6o0=;
        b=lVUnz8sPurINxV/HpZcT6lFAnjgv95kzQtPOLLp8p35ArOpcROrnP1kVNipUJpS1NY
         8Y61msQa6du2f8yRc2sE4VtiFCoggxt7CIm8Lz6vScSsNqNNVi5AZPbreScLzg1cEwXk
         1zkJnpHvAAVN5g02OIJ4EAjiYVGMEKprz9/Vf3SEdu/hUq6P+HV3rs6+umwipOncH7o3
         UZ1Tz/LrVrN5LikfcaJS6BORNW6rT2PWMPN6+E+SkVSAqS/VinjvJcl76wmB4owzgARe
         k1aNDNNGNJ3gm4AROdEAgptoBOjTz0UfG+fZTeifoc067OqTPX2xQv+O2pXyVfOOrjr1
         9qqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=CgXZbizam1RnsDqM0Z4K0o38rQq4gyxPW0XYuQ/q6o0=;
        b=Dr2AvXXYo3tDeAefhj9MGJpkpN2Uv33kVHi/YwPg/vrvojEPsBBnTdCTXdhsyWGgVY
         fw9suXCFxgtfZL5rmOVCEeB7IqCp21UaFJABpX7pmwWmR4xKbEdJl9ABtULTHIqzQTmC
         7c0im2fgKH+DngNcbhufHPdC2CR12FAYGwDLw2D8Pj1ShtXZREGi4rZlo7OZsZuSAFCl
         JIRwez8JDiTRx1ohExTMrM7LcdNJ5PttGDo6ze05y8zAApKlxTLubbPLZpTFmPqRlB6g
         kps2mWbMfGfCuQPYLH4skbg/A9gMU64qyTRN84XwtkkddIZ9m4GVfnZAM6ksQfNwpm2Z
         Ek/Q==
X-Gm-Message-State: APjAAAUHBgOeJY3G4atzagjUiUlyR+GucVb2zsrKOX8wI1qG6mRvZweL
        sIRSuspb2Be+pSHlvtkr+CewTibKuG4=
X-Google-Smtp-Source: APXvYqyDAJIAozMHtXGXQimxXrK+Bi+OO9MhP7ALrujKcq/5BVonmSF3xkqEgMrGr8QYTsOHSw24iA==
X-Received: by 2002:adf:e4d2:: with SMTP id v18mr18526769wrm.189.1558604725484;
        Thu, 23 May 2019 02:45:25 -0700 (PDT)
Received: from localhost (ip-89-176-222-123.net.upcbroadband.cz. [89.176.222.123])
        by smtp.gmail.com with ESMTPSA id f11sm24888118wrv.93.2019.05.23.02.45.24
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 23 May 2019 02:45:25 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, mlxsw@mellanox.com,
        jakub.kicinski@netronome.com, sthemmin@microsoft.com,
        dsahern@gmail.com, saeedm@mellanox.com, leon@kernel.org
Subject: [patch net-next 5/7] mlxfw: Introduce status_notify op and call it to notify about the status
Date:   Thu, 23 May 2019 11:45:08 +0200
Message-Id: <20190523094510.2317-6-jiri@resnulli.us>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20190523094510.2317-1-jiri@resnulli.us>
References: <20190523094510.2317-1-jiri@resnulli.us>
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
index 588d9a9c08c9..6a18ec05181a 100644
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

