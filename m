Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 016B733A74C
	for <lists+netdev@lfdr.de>; Sun, 14 Mar 2021 19:11:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233486AbhCNSLG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Mar 2021 14:11:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231205AbhCNSKh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Mar 2021 14:10:37 -0400
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A212FC061574;
        Sun, 14 Mar 2021 11:10:36 -0700 (PDT)
Received: by mail-qk1-x732.google.com with SMTP id g185so29605597qkf.6;
        Sun, 14 Mar 2021 11:10:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zlRw+oTFLFxMJ39e8LJf1R9F2JNzpiEd+xBypwAOROU=;
        b=Cgw6Dj47t0K42UZuFek8uwO3X8YstxAqaVJkRyU4EDFqfxXzrltfQdWa+6lRv1ocSI
         WBPSZeLTTEl42aEgQ4iyPjPxu2Dlr+gY+lDEoiB9clN0dBUIGsUKT9JStrJcLDtlTrpR
         R1VNmQd3l9P+aRdD5n7W2HWH2SlUqODB7gcwRJ6kfdwBfulPWSLiIf5o4jYnVdaLY5VT
         j1f9VHgPg1OcAXBG7alGlZGugcSvXuTME6WHWdQQXeRzfOvckOAKcUbS7UFiprkL4gAv
         +obM80FxdND+tRvLsw7P6lIlWk1r1FcPnIx7eLWku2piO70k+JzxaJmiz0kEHExewmhC
         rW2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zlRw+oTFLFxMJ39e8LJf1R9F2JNzpiEd+xBypwAOROU=;
        b=NT1WGZo7ZnqoMzuuKB/3Kue1sHxI6LEi0tlDiOAfOAuJw4i5PjyK8n8dJ6KBORkmA+
         0OlY278BpdbvgoCRhcuRSBlla1CaCvTLS1ebiHbWpOeY760eHBpPjfpv1bM23+GV5s4x
         v59+zgr9mnwoT+5FdcrLbuqbNbHx2CdsbcP3HXvQ8O6DztIbwwnWG2SPFjLnazyuHs9w
         BFZ3MBBPFe/f2JdpCjOC/zTM0WDhRTq3aeuSySNBfWj47U1IJqNGqsBGUndg0ScyZ2t8
         o7M1dbZrcz1G+6F9txl42a8BrsoRt6EzqAQ7QXKS74eC+2fdu8MtjhqTRWS/6yn8S1GX
         MuTg==
X-Gm-Message-State: AOAM533ur3I5V6Qz3P5Nh5r5sy55FEaP/BxQCJvKq/RZRnqqzXySOWvL
        J7li+3V8zTX8I1+Qm8hPpX4=
X-Google-Smtp-Source: ABdhPJyt5W3i5jwljqEb8u5d5KzlELJQxuHG421a7/rUoeqK119HCRT03oRV4ie6mFSMBMOxpJu+Cw==
X-Received: by 2002:a37:a603:: with SMTP id p3mr21671722qke.362.1615745435658;
        Sun, 14 Mar 2021 11:10:35 -0700 (PDT)
Received: from tong-desktop.local ([2601:5c0:c200:27c6:4c0:b220:fc67:f404])
        by smtp.googlemail.com with ESMTPSA id 75sm9854279qkj.134.2021.03.14.11.10.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Mar 2021 11:10:35 -0700 (PDT)
From:   Tong Zhang <ztong0001@gmail.com>
To:     Michael Grzeschik <m.grzeschik@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     ztong0001@gmail.com
Subject: [PATCH] net: arcnet: com20020 fix error handling
Date:   Sun, 14 Mar 2021 14:08:36 -0400
Message-Id: <20210314180836.3105727-1-ztong0001@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are two issues when handling error case in com20020pci_probe()

1. priv might be not initialized yet when calling com20020pci_remove()
from com20020pci_probe(), since the priv is set at the very last but it
can jump to error handling in the middle and priv remains NULL.
2. memory leak - the net device is allocated in alloc_arcdev but not
properly released if error happens in the middle of the big for loop

[    1.529110] BUG: kernel NULL pointer dereference, address: 0000000000000008
[    1.531447] RIP: 0010:com20020pci_remove+0x15/0x60 [com20020_pci]
[    1.536805] Call Trace:
[    1.536939]  com20020pci_probe+0x3f2/0x48c [com20020_pci]
[    1.537226]  local_pci_probe+0x48/0x80
[    1.539918]  com20020pci_init+0x3f/0x1000 [com20020_pci]

Signed-off-by: Tong Zhang <ztong0001@gmail.com>
---
 drivers/net/arcnet/com20020-pci.c | 34 +++++++++++++++++--------------
 1 file changed, 19 insertions(+), 15 deletions(-)

diff --git a/drivers/net/arcnet/com20020-pci.c b/drivers/net/arcnet/com20020-pci.c
index 8bdc44b7e09a..3c8f665c1558 100644
--- a/drivers/net/arcnet/com20020-pci.c
+++ b/drivers/net/arcnet/com20020-pci.c
@@ -127,6 +127,8 @@ static int com20020pci_probe(struct pci_dev *pdev,
 	int i, ioaddr, ret;
 	struct resource *r;
 
+	ret = 0;
+
 	if (pci_enable_device(pdev))
 		return -EIO;
 
@@ -139,6 +141,8 @@ static int com20020pci_probe(struct pci_dev *pdev,
 	priv->ci = ci;
 	mm = &ci->misc_map;
 
+	pci_set_drvdata(pdev, priv);
+
 	INIT_LIST_HEAD(&priv->list_dev);
 
 	if (mm->size) {
@@ -161,7 +165,7 @@ static int com20020pci_probe(struct pci_dev *pdev,
 		dev = alloc_arcdev(device);
 		if (!dev) {
 			ret = -ENOMEM;
-			goto out_port;
+			break;
 		}
 		dev->dev_port = i;
 
@@ -178,7 +182,7 @@ static int com20020pci_probe(struct pci_dev *pdev,
 			pr_err("IO region %xh-%xh already allocated\n",
 			       ioaddr, ioaddr + cm->size - 1);
 			ret = -EBUSY;
-			goto out_port;
+			goto err_free_arcdev;
 		}
 
 		/* Dummy access after Reset
@@ -216,18 +220,18 @@ static int com20020pci_probe(struct pci_dev *pdev,
 		if (arcnet_inb(ioaddr, COM20020_REG_R_STATUS) == 0xFF) {
 			pr_err("IO address %Xh is empty!\n", ioaddr);
 			ret = -EIO;
-			goto out_port;
+			goto err_free_arcdev;
 		}
 		if (com20020_check(dev)) {
 			ret = -EIO;
-			goto out_port;
+			goto err_free_arcdev;
 		}
 
 		card = devm_kzalloc(&pdev->dev, sizeof(struct com20020_dev),
 				    GFP_KERNEL);
 		if (!card) {
 			ret = -ENOMEM;
-			goto out_port;
+			goto err_free_arcdev;
 		}
 
 		card->index = i;
@@ -253,29 +257,29 @@ static int com20020pci_probe(struct pci_dev *pdev,
 
 		ret = devm_led_classdev_register(&pdev->dev, &card->tx_led);
 		if (ret)
-			goto out_port;
+			goto err_free_arcdev;
 
 		ret = devm_led_classdev_register(&pdev->dev, &card->recon_led);
 		if (ret)
-			goto out_port;
+			goto err_free_arcdev;
 
 		dev_set_drvdata(&dev->dev, card);
 
 		ret = com20020_found(dev, IRQF_SHARED);
 		if (ret)
-			goto out_port;
+			goto err_free_arcdev;
 
 		devm_arcnet_led_init(dev, dev->dev_id, i);
 
 		list_add(&card->list, &priv->list_dev);
-	}
+		continue;
 
-	pci_set_drvdata(pdev, priv);
-
-	return 0;
-
-out_port:
-	com20020pci_remove(pdev);
+err_free_arcdev:
+		free_arcdev(dev);
+		break;
+	}
+	if (ret)
+		com20020pci_remove(pdev);
 	return ret;
 }
 
-- 
2.25.1

