Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BF9A2803CE
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 18:23:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732709AbgJAQXJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 12:23:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732529AbgJAQXD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 12:23:03 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 207EDC0613E3
        for <netdev@vger.kernel.org>; Thu,  1 Oct 2020 09:23:02 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id d6so4990507pfn.9
        for <netdev@vger.kernel.org>; Thu, 01 Oct 2020 09:23:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=9YOtY8kesgn2zGDhUYYJtsX4hPH7Y73W/wLF/LqVL8g=;
        b=4f5uT58mhEqQIURnyfJPUnO+OnzgndtcxBTmIKygeQh/FgGM2ru2/rSn/60wiPxWYv
         wVLgKNDgWZbJD6HQ1223XwgRuQ2bMAu3olpRWssGh3X18Ng4UWLNSf+3yRjIMEIpwn/c
         Lad3wOwKEVRjaLBwQob5ylIITSDdRF+dXNQ59xrjUJcMPve3XOAPCGHcb2xNoyUTitX9
         6u7ryxNE2POqgum5JsyBSiNbAiNA3cx9InHZeidNOyfDLis+LthdFp3zlYngRAO1B5bl
         H0kI3aYS4hmzf+X9FG69RQiL434O7bzAPkDFJ3SsJIPZP5zwbAR/w1+07M6dKAjPJhrF
         B1MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=9YOtY8kesgn2zGDhUYYJtsX4hPH7Y73W/wLF/LqVL8g=;
        b=l0Wy6G3+5trIOs0m3FBAZRSFeW60cmbv/O6DKThKSAcdBG88t4rybSnWdLMcShZ56D
         U64PHoaAku1pgiTT5PBztMLAv6wGFVh4ZFD4GDn/+ewbYhc3UrI3/76mQ0J789ddjxLe
         LXRMmBPdOJFQJSYeMri4WYs3PENbyqH1TNYZha0lrkNJVhrga8ZkCmFHJyyqrSU30nci
         p/gsaej80Rl8QpGrN/UGurAMzsvoTyseMnUNvxovbJV+T7eqhljk82bfECTeoFR8urg5
         mXg5JABs4sir//iWcAO5A8ke1Cw1LC5guyiEuq1cUwdhqruZus4L/YfwxGbEADX2ZrGi
         Cbqw==
X-Gm-Message-State: AOAM533NMgVDiZbHfpKeD9UwbYQHcND9bexI3Oc9+SJrpmJo12z+x5DJ
        QPtA3MTNB3zxfeRZcxBLB+ONdY+pNvddLg==
X-Google-Smtp-Source: ABdhPJznjGqKiujZhZb0efLn/GtihCA8P01cEsgIhpcVewLq4C+QrUXyFP6gJOXrMEDJt1f643aLCQ==
X-Received: by 2002:a17:902:a403:b029:d2:6379:a9a6 with SMTP id p3-20020a170902a403b02900d26379a9a6mr7895256plq.68.1601569381299;
        Thu, 01 Oct 2020 09:23:01 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id k2sm6380066pfi.169.2020.10.01.09.23.00
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Oct 2020 09:23:00 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 6/8] ionic: refill lif identity after fw_up
Date:   Thu,  1 Oct 2020 09:22:44 -0700
Message-Id: <20201001162246.18508-7-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201001162246.18508-1-snelson@pensando.io>
References: <20201001162246.18508-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After we do a fw upgrade and refill the ionic->ident.dev, we
also need to update the other identity info.  Since the lif
identity needs to be updated each time the ionic identity is
refreshed, we can pull it into ionic_identify().

The debugfs entry is moved so that it doesn't cause an
error message when the data is refreshed after the fw upgrade.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../net/ethernet/pensando/ionic/ionic_bus_pci.c  | 10 ++--------
 drivers/net/ethernet/pensando/ionic/ionic_lif.c  | 10 +++++++++-
 drivers/net/ethernet/pensando/ionic/ionic_main.c | 16 +++++++++++-----
 3 files changed, 22 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
index 2749ce009ebc..b0d8499d373b 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
@@ -266,6 +266,7 @@ static int ionic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		dev_err(dev, "Cannot identify device: %d, aborting\n", err);
 		goto err_out_teardown;
 	}
+	ionic_debugfs_add_ident(ionic);
 
 	err = ionic_init(ionic);
 	if (err) {
@@ -286,14 +287,7 @@ static int ionic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto err_out_reset;
 	}
 
-	/* Configure LIFs */
-	err = ionic_lif_identify(ionic, IONIC_LIF_TYPE_CLASSIC,
-				 &ionic->ident.lif);
-	if (err) {
-		dev_err(dev, "Cannot identify LIFs: %d, aborting\n", err);
-		goto err_out_port_reset;
-	}
-
+	/* Allocate and init the LIF */
 	err = ionic_lif_size(ionic);
 	if (err) {
 		dev_err(dev, "Cannot size LIF: %d, aborting\n", err);
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 2b6cd60095b1..fcf5b00d1c33 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -2556,7 +2556,15 @@ static void ionic_lif_handle_fw_up(struct ionic_lif *lif)
 	dev_info(ionic->dev, "FW Up: restarting LIFs\n");
 
 	ionic_init_devinfo(ionic);
-	ionic_port_init(ionic);
+	err = ionic_identify(ionic);
+	if (err)
+		goto err_out;
+	err = ionic_port_identify(ionic);
+	if (err)
+		goto err_out;
+	err = ionic_port_init(ionic);
+	if (err)
+		goto err_out;
 	err = ionic_qcqs_alloc(lif);
 	if (err)
 		goto err_out;
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_main.c b/drivers/net/ethernet/pensando/ionic/ionic_main.c
index c7a67c5cda42..c21195be59e1 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_main.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_main.c
@@ -429,17 +429,23 @@ int ionic_identify(struct ionic *ionic)
 		sz = min(sizeof(ident->dev), sizeof(idev->dev_cmd_regs->data));
 		memcpy_fromio(&ident->dev, &idev->dev_cmd_regs->data, sz);
 	}
-
 	mutex_unlock(&ionic->dev_cmd_lock);
 
-	if (err)
-		goto err_out_unmap;
+	if (err) {
+		dev_err(ionic->dev, "Cannot identify ionic: %dn", err);
+		goto err_out;
+	}
 
-	ionic_debugfs_add_ident(ionic);
+	err = ionic_lif_identify(ionic, IONIC_LIF_TYPE_CLASSIC,
+				 &ionic->ident.lif);
+	if (err) {
+		dev_err(ionic->dev, "Cannot identify LIFs: %d\n", err);
+		goto err_out;
+	}
 
 	return 0;
 
-err_out_unmap:
+err_out:
 	return err;
 }
 
-- 
2.17.1

