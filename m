Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4646A6F7BB
	for <lists+netdev@lfdr.de>; Mon, 22 Jul 2019 05:05:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726675AbfGVDFf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Jul 2019 23:05:35 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:38672 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726106AbfGVDFf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Jul 2019 23:05:35 -0400
Received: by mail-io1-f68.google.com with SMTP id j6so38443856ioa.5;
        Sun, 21 Jul 2019 20:05:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3d0TsmehIUmq0qA3N9Vz5YuFrjv8Qaa0x6G/JzdD5+Q=;
        b=PIdr/rGhuR3gElVXXEdhqxyDoPfQRzGzlzRsAzSQday/+3+zU5J3I9qZT6yMlM2fxC
         A2ZisZVGcn44iTC+0t6mQPvcI95y5XP/aEe+4LQvNeGv1J+HYwuOdYmEqJOav62y++gS
         zxOGTc3oSX5cc/upKn85TCm5IR5jvT3jGwbumY2ub48cdTQ6MmGd+YdDmBtSK5M6eFuB
         Xrb8xZXXQHQ/NO/TeEABtAaz8tXI11OQrfCGbCzW0vjI7DrAO9YtPFvjkM1XFP/FeKOe
         /dU0yTmQNTSoACdXOIIVGickG3YEmqPsuPg0aRctVXiHaOEol9vOSvh1Z+qtpOWddo68
         H9qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3d0TsmehIUmq0qA3N9Vz5YuFrjv8Qaa0x6G/JzdD5+Q=;
        b=OwwPwM93o/gfSctgktG8lwfCT87n1DiHahFe5ridOYPLMMznTKkTjMXcO7VpQRn59T
         cJOciGpSfcRRRc1g85/FTmOpxrZsI+2Ioda7Ktm/0QWVYCdzK3KNhLx/xz6VMFk4oMV5
         2hRTIWA+S16I6EVi1cbeeKvA4BvbxobIhKHLw6cusB/GN30IswoxrzaIp2G7q+MW/Q2o
         vD2x3FaUEHVK6C5XU1DDX17p/g9ZxEXVjywG0YXpaU7Un1MkiTddvMC2PdZrsvV/zKei
         jn4yADlGz3JSH+jSnfghpHvSucROHS75upLF1ikTafl/YP6yVIxeW3lmKo5EXKzFHT+j
         uO1Q==
X-Gm-Message-State: APjAAAVI+lVIVLo5l0J33KHmY8U0p4Us+nA8DJNSc69BCyZxcVlIAT1B
        FPDZGs8T6N6geZxR2poZlZHvrIzGCgneQQ==
X-Google-Smtp-Source: APXvYqzwrHss0BMfmADs2MwmQrZARNdK6NgwhQ1YV7GWuJj8TMtVG8AWad93ZKewi4L8d+CLLcB06Q==
X-Received: by 2002:a6b:6f06:: with SMTP id k6mr53829059ioc.32.1563764734329;
        Sun, 21 Jul 2019 20:05:34 -0700 (PDT)
Received: from localhost.localdomain (c-73-243-191-173.hsd1.co.comcast.net. [73.243.191.173])
        by smtp.gmail.com with ESMTPSA id i23sm27928326ioj.24.2019.07.21.20.05.32
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 21 Jul 2019 20:05:33 -0700 (PDT)
From:   Kelsey Skunberg <skunberg.kelsey@gmail.com>
To:     iyappan@os.amperecomputing.com, keyur@os.amperecomputing.com,
        quan@os.amperecomputing.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     bjorn@helgaas.com, rjw@rjwysocki.net, skhan@linuxfoundation.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        skunberg.kelsey@gmail.com
Subject: [PATCH] drivers: net: xgene: Remove acpi_has_method() calls
Date:   Sun, 21 Jul 2019 21:04:01 -0600
Message-Id: <20190722030401.69563-1-skunberg.kelsey@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

acpi_evaluate_object will already return an error if the needed method
does not exist. Remove unnecessary acpi_has_method() calls and check the
returned acpi_status for failure instead.

Signed-off-by: Kelsey Skunberg <skunberg.kelsey@gmail.com>
---
 drivers/net/ethernet/apm/xgene/xgene_enet_hw.c    |  7 +++----
 drivers/net/ethernet/apm/xgene/xgene_enet_sgmac.c | 10 +++++-----
 drivers/net/ethernet/apm/xgene/xgene_enet_xgmac.c |  9 ++++-----
 3 files changed, 12 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/apm/xgene/xgene_enet_hw.c b/drivers/net/ethernet/apm/xgene/xgene_enet_hw.c
index 61a465097cb8..ef75a09069a8 100644
--- a/drivers/net/ethernet/apm/xgene/xgene_enet_hw.c
+++ b/drivers/net/ethernet/apm/xgene/xgene_enet_hw.c
@@ -694,6 +694,7 @@ bool xgene_ring_mgr_init(struct xgene_enet_pdata *p)
 static int xgene_enet_reset(struct xgene_enet_pdata *pdata)
 {
 	struct device *dev = &pdata->pdev->dev;
+	acpi_status status;
 
 	if (!xgene_ring_mgr_init(pdata))
 		return -ENODEV;
@@ -712,11 +713,9 @@ static int xgene_enet_reset(struct xgene_enet_pdata *pdata)
 		udelay(5);
 	} else {
 #ifdef CONFIG_ACPI
-		if (acpi_has_method(ACPI_HANDLE(&pdata->pdev->dev), "_RST")) {
-			acpi_evaluate_object(ACPI_HANDLE(&pdata->pdev->dev),
+		status = acpi_evaluate_object(ACPI_HANDLE(&pdata->pdev->dev),
 					     "_RST", NULL, NULL);
-		} else if (acpi_has_method(ACPI_HANDLE(&pdata->pdev->dev),
-					 "_INI")) {
+		if (ACPI_FAILURE(status)) {
 			acpi_evaluate_object(ACPI_HANDLE(&pdata->pdev->dev),
 					     "_INI", NULL, NULL);
 		}
diff --git a/drivers/net/ethernet/apm/xgene/xgene_enet_sgmac.c b/drivers/net/ethernet/apm/xgene/xgene_enet_sgmac.c
index 6453fc2ebb1f..6237a2cfd703 100644
--- a/drivers/net/ethernet/apm/xgene/xgene_enet_sgmac.c
+++ b/drivers/net/ethernet/apm/xgene/xgene_enet_sgmac.c
@@ -437,6 +437,7 @@ static void xgene_sgmac_tx_disable(struct xgene_enet_pdata *p)
 static int xgene_enet_reset(struct xgene_enet_pdata *p)
 {
 	struct device *dev = &p->pdev->dev;
+	acpi_status status;
 
 	if (!xgene_ring_mgr_init(p))
 		return -ENODEV;
@@ -460,14 +461,13 @@ static int xgene_enet_reset(struct xgene_enet_pdata *p)
 		}
 	} else {
 #ifdef CONFIG_ACPI
-		if (acpi_has_method(ACPI_HANDLE(&p->pdev->dev), "_RST"))
-			acpi_evaluate_object(ACPI_HANDLE(&p->pdev->dev),
-					     "_RST", NULL, NULL);
-		else if (acpi_has_method(ACPI_HANDLE(&p->pdev->dev), "_INI"))
+		status = acpi_evaluate_object(ACPI_HANDLE(&p->pdev->dev),
+			 		      "_RST", NULL, NULL);
+		if (ACPI_FAILURE(status)) {
 			acpi_evaluate_object(ACPI_HANDLE(&p->pdev->dev),
 					     "_INI", NULL, NULL);
+		}
 #endif
-	}
 
 	if (!p->port_id) {
 		xgene_enet_ecc_init(p);
diff --git a/drivers/net/ethernet/apm/xgene/xgene_enet_xgmac.c b/drivers/net/ethernet/apm/xgene/xgene_enet_xgmac.c
index 133eb91c542e..fede3bfe4d68 100644
--- a/drivers/net/ethernet/apm/xgene/xgene_enet_xgmac.c
+++ b/drivers/net/ethernet/apm/xgene/xgene_enet_xgmac.c
@@ -380,6 +380,7 @@ static void xgene_xgmac_tx_disable(struct xgene_enet_pdata *pdata)
 static int xgene_enet_reset(struct xgene_enet_pdata *pdata)
 {
 	struct device *dev = &pdata->pdev->dev;
+	acpi_status status;
 
 	if (!xgene_ring_mgr_init(pdata))
 		return -ENODEV;
@@ -393,11 +394,9 @@ static int xgene_enet_reset(struct xgene_enet_pdata *pdata)
 		udelay(5);
 	} else {
 #ifdef CONFIG_ACPI
-		if (acpi_has_method(ACPI_HANDLE(&pdata->pdev->dev), "_RST")) {
-			acpi_evaluate_object(ACPI_HANDLE(&pdata->pdev->dev),
-					     "_RST", NULL, NULL);
-		} else if (acpi_has_method(ACPI_HANDLE(&pdata->pdev->dev),
-					   "_INI")) {
+		status = acpi_evaluate_object(ACPI_HANDLE(&pdata->pdev->dev),
+				 	      "_RST", NULL, NULL);
+		if (ACPI_FAILURE(status)) {
 			acpi_evaluate_object(ACPI_HANDLE(&pdata->pdev->dev),
 					     "_INI", NULL, NULL);
 		}
-- 
2.20.1

