Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A6A134DA6D
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 00:23:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232183AbhC2WWk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 18:22:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:45850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231925AbhC2WVw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Mar 2021 18:21:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0F21561990;
        Mon, 29 Mar 2021 22:21:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617056507;
        bh=EdSlUYLEBDmMlJFm64a1sDClYYytMC2QMuq0nQQvbHY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gZ8GdtRqmPOraE+b5v1PiB44PZPSkJ8VEck7sFTvlOxRmSIErStH0F6WybuHeo03k
         H72M6qPZ6AUkBWPqBy3jz3FdupRoEDrNV+QYdgD3tBx12WoW3T2715aiboH3vmhJg8
         msPvld8ul3x7Aam5Jb4LNkEWoS/zCWvBW8Yf75E+9HJKHC74M7xUwPz+T+0FVAawKv
         3LjnxrJhppUEfuMO9M1cJHqnX8w+eE671PKCvgx5tWrWlLCs5YUy4ueKHq84LmMcEg
         o0gKT2bYTnWpJuBbUeaA6GnH0pMz/6N+K/+AQ5eWp6HHuH3Mj+gtEFoh3Ur0P5vDfY
         SjcSTzB0nJlSw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tong Zhang <ztong0001@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 11/38] net: arcnet: com20020 fix error handling
Date:   Mon, 29 Mar 2021 18:21:06 -0400
Message-Id: <20210329222133.2382393-11-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210329222133.2382393-1-sashal@kernel.org>
References: <20210329222133.2382393-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tong Zhang <ztong0001@gmail.com>

[ Upstream commit 6577b9a551aedb86bca6d4438c28386361845108 ]

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
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
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
2.30.1

