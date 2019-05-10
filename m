Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB90A19ACB
	for <lists+netdev@lfdr.de>; Fri, 10 May 2019 11:36:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727333AbfEJJfs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 May 2019 05:35:48 -0400
Received: from smtp-out.xnet.cz ([178.217.244.18]:32964 "EHLO smtp-out.xnet.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727097AbfEJJfr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 May 2019 05:35:47 -0400
Received: from meh.true.cz (meh.true.cz [108.61.167.218])
        (Authenticated sender: petr@true.cz)
        by smtp-out.xnet.cz (Postfix) with ESMTPSA id 01B2D4347;
        Fri, 10 May 2019 11:35:43 +0200 (CEST)
Received: by meh.true.cz (OpenSMTPD) with ESMTP id 9913a3c0;
        Fri, 10 May 2019 11:35:42 +0200 (CEST)
From:   =?UTF-8?q?Petr=20=C5=A0tetiar?= <ynezz@true.cz>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>
Cc:     Rob Herring <robh@kernel.org>,
        =?UTF-8?q?Petr=20=C5=A0tetiar?= <ynezz@true.cz>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net 1/5] of_net: remove nvmem-mac-address property
Date:   Fri, 10 May 2019 11:35:14 +0200
Message-Id: <1557480918-9627-2-git-send-email-ynezz@true.cz>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1557480918-9627-1-git-send-email-ynezz@true.cz>
References: <1557480918-9627-1-git-send-email-ynezz@true.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In commit d01f449c008a ("of_net: add NVMEM support to
of_get_mac_address") I've added `nvmem-mac-address` property which was
wrong idea as I've allocated the property with devm_kzalloc and then
added it to DT, so then 2 entities would be refcounting the allocation.
So if the driver unbinds, the buffer is freed, but DT code would be
still referencing that memory.

I'm removing this property completely instead of fixing it, as it's not
needed to have it.

Fixes: d01f449c008a ("of_net: add NVMEM support to of_get_mac_address")
Suggested-by: Rob Herring <robh@kernel.org>
Signed-off-by: Petr Štetiar <ynezz@true.cz>
---
 drivers/of/of_net.c | 29 ++++++-----------------------
 1 file changed, 6 insertions(+), 23 deletions(-)

diff --git a/drivers/of/of_net.c b/drivers/of/of_net.c
index 9649cd53e955..a4b392a5406b 100644
--- a/drivers/of/of_net.c
+++ b/drivers/of/of_net.c
@@ -52,39 +52,22 @@ static const void *of_get_mac_addr(struct device_node *np, const char *name)
 static const void *of_get_mac_addr_nvmem(struct device_node *np)
 {
 	int ret;
-	u8 mac[ETH_ALEN];
-	struct property *pp;
+	const void *mac;
+	u8 nvmem_mac[ETH_ALEN];
 	struct platform_device *pdev = of_find_device_by_node(np);
 
 	if (!pdev)
 		return ERR_PTR(-ENODEV);
 
-	ret = nvmem_get_mac_address(&pdev->dev, &mac);
+	ret = nvmem_get_mac_address(&pdev->dev, &nvmem_mac);
 	if (ret)
 		return ERR_PTR(ret);
 
-	pp = devm_kzalloc(&pdev->dev, sizeof(*pp), GFP_KERNEL);
-	if (!pp)
+	mac = devm_kmemdup(&pdev->dev, nvmem_mac, ETH_ALEN, GFP_KERNEL);
+	if (!mac)
 		return ERR_PTR(-ENOMEM);
 
-	pp->name = "nvmem-mac-address";
-	pp->length = ETH_ALEN;
-	pp->value = devm_kmemdup(&pdev->dev, mac, ETH_ALEN, GFP_KERNEL);
-	if (!pp->value) {
-		ret = -ENOMEM;
-		goto free;
-	}
-
-	ret = of_add_property(np, pp);
-	if (ret)
-		goto free;
-
-	return pp->value;
-free:
-	devm_kfree(&pdev->dev, pp->value);
-	devm_kfree(&pdev->dev, pp);
-
-	return ERR_PTR(ret);
+	return mac;
 }
 
 /**
-- 
1.9.1

