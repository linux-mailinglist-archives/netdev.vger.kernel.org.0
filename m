Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 359D53AA3ED
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 21:08:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232577AbhFPTKu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 15:10:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232400AbhFPTKf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 15:10:35 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 022CCC0617AE
        for <netdev@vger.kernel.org>; Wed, 16 Jun 2021 12:08:28 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id d13so5263659ljg.12
        for <netdev@vger.kernel.org>; Wed, 16 Jun 2021 12:08:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qO81kkLWUD7HwK1vfV7d3yspAdGdM3JErj+7upPHV+g=;
        b=QmAbiCMHeMzya8lnZc4yAdb2woDbST083wyuKhVvDyuBi2RSGgE1JYVF+wFuiZN/B0
         wUS7K8FLF6cshXEQohL+9eFigt7Hs5w55fe9iby0O3GLyM55FO+Hei/JdGIEo4qsB+OW
         2gE/P1DVJW6+I6LTiMD6d+JXAPQ516HWoDSXHE7unlIxIXacOIUBNmkslic2ywHhjdRj
         YPcCkLa0LG5x/POsA5/Wl/EqYIuJ9oz0lRHHZE91xmGzlMYhxQFPjWacVM8a2YLiSfZL
         MaSeO1jkPZyfq7SphxmlRawbC+gRSF/tUiw2e3fVq/PLrydRuWfEmf/tUjyhD4DihsRX
         qyqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qO81kkLWUD7HwK1vfV7d3yspAdGdM3JErj+7upPHV+g=;
        b=FPBa68zDkSe6SPo9NFSVw/uoalxbYzhd/wnesLBCm/iHr2SSxwOiNYwmI0TQby1COU
         oxSFumVtRJ3cTisheDXCjVSnL3nw1S+OOmHjJK2VjTB/j+hedGW7nkJGFHPzPNpUuJ0f
         8d8oLMWlWuz2tcLnpLYaJy+sgVM2wedXIUhIj1A0sfz/Qc1W2lgesgnpoR0C199iWxWu
         pHcrHUfkJS7Qci78a6dNrxJQieOdF6wHRabV+R4Lsaw2xOfCXPF1pnz9Kn+oJCsHIzt4
         Ln5AeibuZoOiEb4IxMhpF/n232A6VYziHE7LJUROHz1KpfhfaYjNnWKggIAiTNNeCOkU
         +iHA==
X-Gm-Message-State: AOAM533PshsaeIMQUGToTgN147Fyh6sZecS4eHu6UAIeTiAyKdiO6qHc
        Hf3Zifua5PDh8DTAXY7BpkgNGA==
X-Google-Smtp-Source: ABdhPJzKBQ3Du28z3i8T73CJT5Zh+7yMzCUomkZ/Un/m3Bp62Ul3Vcx6bIJQmRiYTAOspHCHD4wCKw==
X-Received: by 2002:a2e:8e7c:: with SMTP id t28mr1195277ljk.246.1623870506327;
        Wed, 16 Jun 2021 12:08:26 -0700 (PDT)
Received: from gilgamesh.lab.semihalf.net ([83.142.187.85])
        by smtp.gmail.com with ESMTPSA id h22sm406939ljl.126.2021.06.16.12.08.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Jun 2021 12:08:25 -0700 (PDT)
From:   Marcin Wojtas <mw@semihalf.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux@armlinux.org.uk,
        jaz@semihalf.com, gjb@semihalf.com, upstream@semihalf.com,
        Samer.El-Haj-Mahmoud@arm.com, jon@solid-run.com, tn@semihalf.com,
        rjw@rjwysocki.net, lenb@kernel.org, Marcin Wojtas <mw@semihalf.com>
Subject: [net-next: PATCH v2 5/7] net: mvmdio: add ACPI support
Date:   Wed, 16 Jun 2021 21:07:57 +0200
Message-Id: <20210616190759.2832033-6-mw@semihalf.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20210616190759.2832033-1-mw@semihalf.com>
References: <20210616190759.2832033-1-mw@semihalf.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch introducing ACPI support for the mvmdio driver by adding
acpi_match_table with two entries:

* "MRVL0100" for the SMI operation
* "MRVL0101" for the XSMI mode

Also clk enabling is skipped, because the tables do not contain
such data and clock maintenance relies on the firmware.

Signed-off-by: Marcin Wojtas <mw@semihalf.com>
---
 drivers/net/ethernet/marvell/mvmdio.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvmdio.c b/drivers/net/ethernet/marvell/mvmdio.c
index ce3ddc867898..4fe6428b8119 100644
--- a/drivers/net/ethernet/marvell/mvmdio.c
+++ b/drivers/net/ethernet/marvell/mvmdio.c
@@ -17,8 +17,10 @@
  * warranty of any kind, whether express or implied.
  */
 
+#include <linux/acpi.h>
 #include <linux/clk.h>
 #include <linux/delay.h>
+#include <linux/fwnode_mdio.h>
 #include <linux/interrupt.h>
 #include <linux/io.h>
 #include <linux/kernel.h>
@@ -283,7 +285,7 @@ static int orion_mdio_probe(struct platform_device *pdev)
 	struct orion_mdio_dev *dev;
 	int ret;
 
-	type = (enum orion_mdio_bus_type)of_device_get_match_data(&pdev->dev);
+	type = (enum orion_mdio_bus_type)device_get_match_data(&pdev->dev);
 
 	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!r) {
@@ -358,7 +360,7 @@ static int orion_mdio_probe(struct platform_device *pdev)
 		goto out_mdio;
 	}
 
-	ret = of_mdiobus_register(bus, pdev->dev.of_node);
+	ret = fwnode_mdiobus_register(bus, pdev->dev.fwnode);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "Cannot register MDIO bus (%d)\n", ret);
 		goto out_mdio;
@@ -396,12 +398,20 @@ static const struct of_device_id orion_mdio_match[] = {
 };
 MODULE_DEVICE_TABLE(of, orion_mdio_match);
 
+static const struct acpi_device_id orion_mdio_acpi_match[] = {
+	{ "MRVL0100", BUS_TYPE_SMI },
+	{ "MRVL0101", BUS_TYPE_XSMI },
+	{ },
+};
+MODULE_DEVICE_TABLE(acpi, orion_mdio_acpi_match);
+
 static struct platform_driver orion_mdio_driver = {
 	.probe = orion_mdio_probe,
 	.remove = orion_mdio_remove,
 	.driver = {
 		.name = "orion-mdio",
 		.of_match_table = orion_mdio_match,
+		.acpi_match_table = ACPI_PTR(orion_mdio_acpi_match),
 	},
 };
 
-- 
2.29.0

