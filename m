Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4C06118185
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 08:49:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726824AbfLJHtk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 02:49:40 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:44644 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726071AbfLJHtj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 02:49:39 -0500
Received: by mail-pl1-f196.google.com with SMTP id bh2so5833607plb.11
        for <netdev@vger.kernel.org>; Mon, 09 Dec 2019 23:49:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=hXU0A3iXDOB5ehPtKGZbXrGiv1e1qXAj9jLmXGkc9Do=;
        b=TKPwcHvpOzZN4uhNjKpP4GqwsT5KMINw0xwc/X81cs3XDU+ZR8DD7DFiqVN78947iv
         V8qzhuthY1II9xXE3FVTFlmsplTCJVTcsb8adBe3tQxuzif6VePGvDp5VKCN0CohNxxe
         ihK5TEtDSiXsr+pReGniZUxpOZ/rPYTjuY4Pg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=hXU0A3iXDOB5ehPtKGZbXrGiv1e1qXAj9jLmXGkc9Do=;
        b=T6Curn1RUk1UXy83z9RjjkMgJhBi8ULtolqeDlPGZYI+RmrzQTT7MSZwaC4LW45U/7
         91gNo+qdVWdG1dQ1otHQCc0dLfO1y0KelclRMcrvyjpejKZ+MSbXd8wHL304g18EO65C
         jZG+pWIZTL2o2ANP0WHlJcopw0jV3gWmEBj/ojX0Cv1LwoQ37v+mYfqEJ1EGSmtZUTTl
         X0X/g50LlzFQLWQuqMHirdLy0ZbTKG0vztizHFnSEYO6Cej4uQtvpNi4m6USwV0FSP1o
         VdVMhgW0kLZ3QKB1PSkW2ab/hVs7Ab6NtkwaWnxS9Zs1q8edGy+xbhVmslLwgG1hc/2E
         OsSw==
X-Gm-Message-State: APjAAAUglobpVworA/PYEGiH7P7bmCoZDm4PLG+n3D8njed8UB4lwNRR
        al8vLZfIOLjlrDK+ymSbq8kk6Q==
X-Google-Smtp-Source: APXvYqz77B37pUxNfmVYitfj4MbXcLi02oVEL55JcxBerYLX0APsmeC5lWGFVmNZK7TjecgJxMVcUw==
X-Received: by 2002:a17:902:7884:: with SMTP id q4mr32545654pll.285.1575964178754;
        Mon, 09 Dec 2019 23:49:38 -0800 (PST)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id z29sm2108101pge.21.2019.12.09.23.49.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 09 Dec 2019 23:49:38 -0800 (PST)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Subject: [PATCH net 6/7] bnxt_en: Fix the logic that creates the health reporters.
Date:   Tue, 10 Dec 2019 02:49:12 -0500
Message-Id: <1575964153-11299-7-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1575964153-11299-1-git-send-email-michael.chan@broadcom.com>
References: <1575964153-11299-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

Fix the logic to properly check the fw capabilities and create the
devlink health reporters only when needed.  The current code creates
the reporters unconditionally as long as bp->fw_health is valid, and
that's not correct.

Call bnxt_dl_fw_reporters_create() directly from the init and reset
code path instead of from bnxt_dl_register().  This allows the
reporters to be adjusted when capabilities change.  The same
applies to bnxt_dl_fw_reporters_destroy().

Fixes: 6763c779c2d8 ("bnxt_en: Add new FW devlink_health_reporter")
Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c         | 11 +++-
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c | 64 ++++++++++++++++-------
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h |  2 +
 3 files changed, 56 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 2a100ff..819b7d7 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -10625,6 +10625,12 @@ static int bnxt_fw_init_one(struct bnxt *bp)
 	rc = bnxt_approve_mac(bp, bp->dev->dev_addr, false);
 	if (rc)
 		return rc;
+
+	/* In case fw capabilities have changed, destroy the unneeded
+	 * reporters and create newly capable ones.
+	 */
+	bnxt_dl_fw_reporters_destroy(bp, false);
+	bnxt_dl_fw_reporters_create(bp);
 	bnxt_fw_init_one_p3(bp);
 	return 0;
 }
@@ -11413,6 +11419,7 @@ static void bnxt_remove_one(struct pci_dev *pdev)
 
 	if (BNXT_PF(bp)) {
 		bnxt_sriov_disable(bp);
+		bnxt_dl_fw_reporters_destroy(bp, true);
 		bnxt_dl_unregister(bp);
 	}
 
@@ -11892,8 +11899,10 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (rc)
 		goto init_err_cleanup_tc;
 
-	if (BNXT_PF(bp))
+	if (BNXT_PF(bp)) {
 		bnxt_dl_register(bp);
+		bnxt_dl_fw_reporters_create(bp);
+	}
 
 	netdev_info(dev, "%s found at mem %lx, node addr %pM\n",
 		    board_info[ent->driver_data].name,
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
index 1e7c7c3..136953a 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
@@ -125,21 +125,15 @@ struct devlink_health_reporter_ops bnxt_dl_fw_fatal_reporter_ops = {
 	.recover = bnxt_fw_fatal_recover,
 };
 
-static void bnxt_dl_fw_reporters_create(struct bnxt *bp)
+void bnxt_dl_fw_reporters_create(struct bnxt *bp)
 {
 	struct bnxt_fw_health *health = bp->fw_health;
 
-	if (!health)
+	if (!bp->dl || !health)
 		return;
 
-	health->fw_reporter =
-		devlink_health_reporter_create(bp->dl, &bnxt_dl_fw_reporter_ops,
-					       0, false, bp);
-	if (IS_ERR(health->fw_reporter)) {
-		netdev_warn(bp->dev, "Failed to create FW health reporter, rc = %ld\n",
-			    PTR_ERR(health->fw_reporter));
-		health->fw_reporter = NULL;
-	}
+	if (!(bp->fw_cap & BNXT_FW_CAP_HOT_RESET) || health->fw_reset_reporter)
+		goto err_recovery;
 
 	health->fw_reset_reporter =
 		devlink_health_reporter_create(bp->dl,
@@ -149,8 +143,30 @@ static void bnxt_dl_fw_reporters_create(struct bnxt *bp)
 		netdev_warn(bp->dev, "Failed to create FW fatal health reporter, rc = %ld\n",
 			    PTR_ERR(health->fw_reset_reporter));
 		health->fw_reset_reporter = NULL;
+		bp->fw_cap &= ~BNXT_FW_CAP_HOT_RESET;
 	}
 
+err_recovery:
+	if (!(bp->fw_cap & BNXT_FW_CAP_ERROR_RECOVERY))
+		return;
+
+	if (!health->fw_reporter) {
+		health->fw_reporter =
+			devlink_health_reporter_create(bp->dl,
+						       &bnxt_dl_fw_reporter_ops,
+						       0, false, bp);
+		if (IS_ERR(health->fw_reporter)) {
+			netdev_warn(bp->dev, "Failed to create FW health reporter, rc = %ld\n",
+				    PTR_ERR(health->fw_reporter));
+			health->fw_reporter = NULL;
+			bp->fw_cap &= ~BNXT_FW_CAP_ERROR_RECOVERY;
+			return;
+		}
+	}
+
+	if (health->fw_fatal_reporter)
+		return;
+
 	health->fw_fatal_reporter =
 		devlink_health_reporter_create(bp->dl,
 					       &bnxt_dl_fw_fatal_reporter_ops,
@@ -159,24 +175,35 @@ static void bnxt_dl_fw_reporters_create(struct bnxt *bp)
 		netdev_warn(bp->dev, "Failed to create FW fatal health reporter, rc = %ld\n",
 			    PTR_ERR(health->fw_fatal_reporter));
 		health->fw_fatal_reporter = NULL;
+		bp->fw_cap &= ~BNXT_FW_CAP_ERROR_RECOVERY;
 	}
 }
 
-static void bnxt_dl_fw_reporters_destroy(struct bnxt *bp)
+void bnxt_dl_fw_reporters_destroy(struct bnxt *bp, bool all)
 {
 	struct bnxt_fw_health *health = bp->fw_health;
 
-	if (!health)
+	if (!bp->dl || !health)
 		return;
 
-	if (health->fw_reporter)
-		devlink_health_reporter_destroy(health->fw_reporter);
-
-	if (health->fw_reset_reporter)
+	if ((all || !(bp->fw_cap & BNXT_FW_CAP_HOT_RESET)) &&
+	    health->fw_reset_reporter) {
 		devlink_health_reporter_destroy(health->fw_reset_reporter);
+		health->fw_reset_reporter = NULL;
+	}
 
-	if (health->fw_fatal_reporter)
+	if ((bp->fw_cap & BNXT_FW_CAP_ERROR_RECOVERY) && !all)
+		return;
+
+	if (health->fw_reporter) {
+		devlink_health_reporter_destroy(health->fw_reporter);
+		health->fw_reporter = NULL;
+	}
+
+	if (health->fw_fatal_reporter) {
 		devlink_health_reporter_destroy(health->fw_fatal_reporter);
+		health->fw_fatal_reporter = NULL;
+	}
 }
 
 void bnxt_devlink_health_report(struct bnxt *bp, unsigned long event)
@@ -502,8 +529,6 @@ int bnxt_dl_register(struct bnxt *bp)
 
 	devlink_params_publish(dl);
 
-	bnxt_dl_fw_reporters_create(bp);
-
 	return 0;
 
 err_dl_port_unreg:
@@ -526,7 +551,6 @@ void bnxt_dl_unregister(struct bnxt *bp)
 	if (!dl)
 		return;
 
-	bnxt_dl_fw_reporters_destroy(bp);
 	devlink_port_params_unregister(&bp->dl_port, bnxt_dl_port_params,
 				       ARRAY_SIZE(bnxt_dl_port_params));
 	devlink_port_unregister(&bp->dl_port);
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h
index 665d4bd..6db6c3d 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h
@@ -58,6 +58,8 @@ struct bnxt_dl_nvm_param {
 
 void bnxt_devlink_health_report(struct bnxt *bp, unsigned long event);
 void bnxt_dl_health_status_update(struct bnxt *bp, bool healthy);
+void bnxt_dl_fw_reporters_create(struct bnxt *bp);
+void bnxt_dl_fw_reporters_destroy(struct bnxt *bp, bool all);
 int bnxt_dl_register(struct bnxt *bp);
 void bnxt_dl_unregister(struct bnxt *bp);
 
-- 
2.5.1

