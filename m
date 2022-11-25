Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 207C6638B25
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 14:28:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229693AbiKYN2n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 08:28:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbiKYN2n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 08:28:43 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5005222B3;
        Fri, 25 Nov 2022 05:28:40 -0800 (PST)
Received: from dggpeml500021.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4NJbK00KBfzmWCs;
        Fri, 25 Nov 2022 21:28:04 +0800 (CST)
Received: from dggpeml500006.china.huawei.com (7.185.36.76) by
 dggpeml500021.china.huawei.com (7.185.36.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 25 Nov 2022 21:28:38 +0800
Received: from localhost.localdomain (10.175.112.70) by
 dggpeml500006.china.huawei.com (7.185.36.76) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 25 Nov 2022 21:28:37 +0800
From:   Zhang Changzhong <zhangchangzhong@huawei.com>
To:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Julia Lawall <julia@diku.dk>,
        Pavel Cheblakov <P.B.Cheblakov@inp.nsk.su>
CC:     Zhang Changzhong <zhangchangzhong@huawei.com>,
        <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] can: sja1000: plx_pci: fix error handling path in plx_pci_add_card()
Date:   Fri, 25 Nov 2022 21:46:14 +0800
Message-ID: <1669383975-17332-1-git-send-email-zhangchangzhong@huawei.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.112.70]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500006.china.huawei.com (7.185.36.76)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If pci_iomap() or register_sja1000dev() fails, netdev will not be
registered, but plx_pci_del_card() still deregisters the netdev.

To avoid this, let's free the netdev and clear card->net_dev[i] before
calling plx_pci_del_card(). In addition, add the missing pci_iounmap()
when the channel does not exist.

Compile tested only.

Fixes: 951f2f960e5b ("drivers/net/can/sja1000/plx_pci.c: eliminate double free")
Fixes: 24c4a3b29255 ("can: add support for CAN interface cards based on the PLX90xx PCI bridge")
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
---
v1->v2: switch to goto style fix.

 drivers/net/can/sja1000/plx_pci.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/sja1000/plx_pci.c b/drivers/net/can/sja1000/plx_pci.c
index 5de1ebb..134a8cb 100644
--- a/drivers/net/can/sja1000/plx_pci.c
+++ b/drivers/net/can/sja1000/plx_pci.c
@@ -678,7 +678,7 @@ static int plx_pci_add_card(struct pci_dev *pdev,
 		if (!addr) {
 			err = -ENOMEM;
 			dev_err(&pdev->dev, "Failed to remap BAR%d\n", cm->bar);
-			goto failure_cleanup;
+			goto failure_free_dev;
 		}
 
 		priv->reg_base = addr + cm->offset;
@@ -699,7 +699,7 @@ static int plx_pci_add_card(struct pci_dev *pdev,
 			if (err) {
 				dev_err(&pdev->dev, "Registering device failed "
 					"(err=%d)\n", err);
-				goto failure_cleanup;
+				goto failure_iounmap;
 			}
 
 			card->channels++;
@@ -710,6 +710,7 @@ static int plx_pci_add_card(struct pci_dev *pdev,
 		} else {
 			dev_err(&pdev->dev, "Channel #%d not detected\n",
 				i + 1);
+			pci_iounmap(pdev, priv->reg_base);
 			free_sja1000dev(dev);
 			card->net_dev[i] = NULL;
 		}
@@ -738,6 +739,11 @@ static int plx_pci_add_card(struct pci_dev *pdev,
 	}
 	return 0;
 
+failure_iounmap:
+	pci_iounmap(pdev, priv->reg_base);
+failure_free_dev:
+	free_sja1000dev(dev);
+	card->net_dev[i] = NULL;
 failure_cleanup:
 	dev_err(&pdev->dev, "Error: %d. Cleaning Up.\n", err);
 
-- 
2.9.5

