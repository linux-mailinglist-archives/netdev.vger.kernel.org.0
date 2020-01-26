Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2C461499B9
	for <lists+netdev@lfdr.de>; Sun, 26 Jan 2020 10:03:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729240AbgAZJDs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jan 2020 04:03:48 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:46660 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729199AbgAZJDr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jan 2020 04:03:47 -0500
Received: by mail-pg1-f193.google.com with SMTP id z124so3555537pgb.13
        for <netdev@vger.kernel.org>; Sun, 26 Jan 2020 01:03:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=t3ltzevlkl9BqbgNXchhp8oFpYeu3ZUTIFGc0Rvwg6c=;
        b=HIq/e6k6HSdAK7mtT5T3EVE5cWCK4TyrQAyg94zpKK20jCjSdACb4HwVB4ejYDGRRX
         XNtPZgWPGlz1QFDGKFLYSZTiapQeLeMwWPBfR+QzbCrdAYLnWZpy+/TpuXcJse9Cw9am
         ZJfxTTFuhLrD9AoETPWkVSXVKRn5DxXtNp3Bs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=t3ltzevlkl9BqbgNXchhp8oFpYeu3ZUTIFGc0Rvwg6c=;
        b=CaMESknlOH5quQvDP/ULRK+PvNEsvcy8M4UPLqJjANh/ZbXj2lRUcbUjI191w9/slA
         0cHfL8cd2VPVbHoW552lbOiMZeaEIP65spK3vhC7eNLSmo/5qdXz6feyDvD462Dv2lei
         y2HNJVpD+sVa6u6wQ6jllkHSCOdYUYpwG9wopyEbuoy5/7v2kgoOCoS4trpczQjqX4qV
         VTl+CTQqptHAMvNT/Unb6kVoBa71s4RJoiEhiJ9vmzMzM129IUW6d5Lov6cxcwtDVHZa
         H9FUMFAiI/80/lS40faZlJdvDeekq7wybLgE2cNwZ5LcrZFnyr1XWjovX72DiyHMAcoi
         rmPA==
X-Gm-Message-State: APjAAAWw8up8NH64reM7AgiruZ70eKFlJbOlGKg5iaZIsd7XX7hlbALF
        cAETGYMg9snl+nnjoNZvmd0tWw==
X-Google-Smtp-Source: APXvYqx0LJnbxUQ+onIm7PSEq/UJQrcdc8q/nY+mcsSusyv7i7r/Y3iKP7U77DXMsaINnnS20O4fUQ==
X-Received: by 2002:a63:554c:: with SMTP id f12mr13871745pgm.23.1580029426509;
        Sun, 26 Jan 2020 01:03:46 -0800 (PST)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id i17sm11856315pfr.67.2020.01.26.01.03.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 26 Jan 2020 01:03:46 -0800 (PST)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Jiri Pirko <jiri@mellanox.com>
Subject: [PATCH net-next 11/16] bnxt_en: Move devlink_register before registering netdev
Date:   Sun, 26 Jan 2020 04:03:05 -0500
Message-Id: <1580029390-32760-12-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1580029390-32760-1-git-send-email-michael.chan@broadcom.com>
References: <1580029390-32760-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

Latest kernels get the phys_port_name via devlink, if
ndo_get_phys_port_name is not defined. To provide the phys_port_name
correctly, register devlink before registering netdev.

Also call devlink_port_type_eth_set() after registering netdev as
devlink port updates the netdev structure and notifies user.

Cc: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c         | 12 ++++++++----
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c |  1 -
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 676f4da..8579415 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -11445,9 +11445,9 @@ static void bnxt_remove_one(struct pci_dev *pdev)
 		bnxt_sriov_disable(bp);
 
 	bnxt_dl_fw_reporters_destroy(bp, true);
-	bnxt_dl_unregister(bp);
 	pci_disable_pcie_error_reporting(pdev);
 	unregister_netdev(dev);
+	bnxt_dl_unregister(bp);
 	bnxt_shutdown_tc(bp);
 	bnxt_cancel_sp_work(bp);
 	bp->sp_event = 0;
@@ -11917,11 +11917,14 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		bnxt_init_tc(bp);
 	}
 
+	bnxt_dl_register(bp);
+
 	rc = register_netdev(dev);
 	if (rc)
-		goto init_err_cleanup_tc;
+		goto init_err_cleanup;
 
-	bnxt_dl_register(bp);
+	if (BNXT_PF(bp))
+		devlink_port_type_eth_set(&bp->dl_port, bp->dev);
 	bnxt_dl_fw_reporters_create(bp);
 
 	netdev_info(dev, "%s found at mem %lx, node addr %pM\n",
@@ -11931,7 +11934,8 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	return 0;
 
-init_err_cleanup_tc:
+init_err_cleanup:
+	bnxt_dl_unregister(bp);
 	bnxt_shutdown_tc(bp);
 	bnxt_clear_int_mode(bp);
 
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
index a8cdfbdd..f2d9cd6 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
@@ -561,7 +561,6 @@ int bnxt_dl_register(struct bnxt *bp)
 		netdev_err(bp->dev, "devlink_port_register failed");
 		goto err_dl_unreg;
 	}
-	devlink_port_type_eth_set(&bp->dl_port, bp->dev);
 
 	rc = bnxt_dl_params_register(bp);
 	if (rc)
-- 
2.5.1

