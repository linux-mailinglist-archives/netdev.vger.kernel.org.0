Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB5AC3337CA
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 09:49:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232363AbhCJIsr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 03:48:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232437AbhCJIse (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 03:48:34 -0500
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38C1CC06174A
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 00:48:30 -0800 (PST)
Received: by mail-lj1-x232.google.com with SMTP id 2so24547720ljr.5
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 00:48:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=waeQL39wOUXJMFOq+NQfRHNCicJzkmPkA1cywz6wwAU=;
        b=sfenkuNauElCvnPBOBq1vztHuSStQ0RZCUD5P/BWQXxUjpwq6f7NeSZ5/43ZsV2aH4
         Jpzj974G3w6hr8KlhM575fBYEP0x5AUi9hks6diOdjMJqKHBoksc4tkl/YmRNMPqRe/t
         FR+tDD3Gnnk7svFokVO3mu+kOemMMgafF4I1HEP5QLzYRpwBjtDRZO0kojNwT9iJEDxf
         jng4jX5pejV1JJJxSlp5fMoTuB1UOVWPJTfYFmT8KEn/RjMkERPUmiXRWhszvQNYvuRw
         qX5pdChCMap84r3HYtTnjp60Hc/YrPJblJ03na0UUo+j3wAudKC7tXI+cLREI6LVDhz/
         8oVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=waeQL39wOUXJMFOq+NQfRHNCicJzkmPkA1cywz6wwAU=;
        b=NuPLWmdHWkSSrfOdF1HCx2Pqe+2glxErYBGJ+G2AjwvMicB5ymMLWiMb7xlo4tvh9m
         K77WXwIY9wTK07TwjlQnR04tQmnzUrN0WngKx+jVRQZ6z4ILqlBNLtfvCTMDWXqEFAiG
         bNwoERTyUD724UId4hNDzCtjWEE97z+6kuAUL4uE/+4R0x4zIPtiTEG2tRNtl+eIr8/C
         OvN6jG6grRCkDy23+jxv8HpU89wmmGz6GLXBOW/S4TLZXLQOvlkLg+n6ghtdsBVPLfeK
         Q7gvppSr+G/dMbZMpGmfpGkerNcCgdCLsCVyRzK4a9gduWov/exC5aK895hFhJOYCGBU
         /Uxw==
X-Gm-Message-State: AOAM531lSKQM6wq0WVfxTlUXUzH1BLXlAcRgzhSG1pxqDReYs7SkHHyx
        A/c4Qi/7sgWyOCUZ4gBYCOTJKrTAxGg=
X-Google-Smtp-Source: ABdhPJzBXu2NBzkXek5nwe+4X8jg06PwAVnTnl5CdYFpxUN3+GqmgcywElURrMC2UYCZjgBmv03utw==
X-Received: by 2002:a05:651c:50f:: with SMTP id o15mr1190937ljp.389.1615366108628;
        Wed, 10 Mar 2021 00:48:28 -0800 (PST)
Received: from localhost.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.gmail.com with ESMTPSA id e11sm2664145lfc.141.2021.03.10.00.48.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 00:48:28 -0800 (PST)
From:   =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH net-next] net: broadcom: bcm4908_enet: read MAC from OF
Date:   Wed, 10 Mar 2021 09:48:13 +0100
Message-Id: <20210310084813.16743-1-zajec5@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

BCM4908 devices have MAC address accessible using NVMEM so it's needed
to use OF helper for reading it.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
 drivers/net/ethernet/broadcom/bcm4908_enet.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bcm4908_enet.c b/drivers/net/ethernet/broadcom/bcm4908_enet.c
index 50e3e7d8c723..0a04c0f83b76 100644
--- a/drivers/net/ethernet/broadcom/bcm4908_enet.c
+++ b/drivers/net/ethernet/broadcom/bcm4908_enet.c
@@ -9,6 +9,7 @@
 #include <linux/interrupt.h>
 #include <linux/module.h>
 #include <linux/of.h>
+#include <linux/of_net.h>
 #include <linux/platform_device.h>
 #include <linux/slab.h>
 #include <linux/string.h>
@@ -684,6 +685,7 @@ static int bcm4908_enet_probe(struct platform_device *pdev)
 	struct device *dev = &pdev->dev;
 	struct net_device *netdev;
 	struct bcm4908_enet *enet;
+	const u8 *mac;
 	int err;
 
 	netdev = devm_alloc_etherdev(dev, sizeof(*enet));
@@ -713,7 +715,11 @@ static int bcm4908_enet_probe(struct platform_device *pdev)
 		return err;
 
 	SET_NETDEV_DEV(netdev, &pdev->dev);
-	eth_hw_addr_random(netdev);
+	mac = of_get_mac_address(dev->of_node);
+	if (!IS_ERR(mac))
+		ether_addr_copy(netdev->dev_addr, mac);
+	else
+		eth_hw_addr_random(netdev);
 	netdev->netdev_ops = &bcm4908_enet_netdev_ops;
 	netdev->min_mtu = ETH_ZLEN;
 	netdev->mtu = ETH_DATA_LEN;
-- 
2.26.2

