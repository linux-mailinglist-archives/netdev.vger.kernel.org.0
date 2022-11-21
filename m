Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53420631EC1
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 11:50:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbiKUKuq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 05:50:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbiKUKup (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 05:50:45 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCE861055C;
        Mon, 21 Nov 2022 02:50:44 -0800 (PST)
Received: from dggpeml500025.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4NG40k2RmXzmW4Y;
        Mon, 21 Nov 2022 18:50:14 +0800 (CST)
Received: from dggpeml500006.china.huawei.com (7.185.36.76) by
 dggpeml500025.china.huawei.com (7.185.36.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 21 Nov 2022 18:50:43 +0800
Received: from localhost.localdomain (10.175.112.70) by
 dggpeml500006.china.huawei.com (7.185.36.76) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 21 Nov 2022 18:50:42 +0800
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
Subject: [PATCH] can: sja1000: plx_pci: fix error handling path in plx_pci_add_card()
Date:   Mon, 21 Nov 2022 19:10:30 +0800
Message-ID: <1669029031-7743-1-git-send-email-zhangchangzhong@huawei.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.112.70]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
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
 drivers/net/can/sja1000/plx_pci.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/can/sja1000/plx_pci.c b/drivers/net/can/sja1000/plx_pci.c
index 5de1ebb..1158f5a 100644
--- a/drivers/net/can/sja1000/plx_pci.c
+++ b/drivers/net/can/sja1000/plx_pci.c
@@ -678,6 +678,8 @@ static int plx_pci_add_card(struct pci_dev *pdev,
 		if (!addr) {
 			err = -ENOMEM;
 			dev_err(&pdev->dev, "Failed to remap BAR%d\n", cm->bar);
+			free_sja1000dev(dev);
+			card->net_dev[i] = NULL;
 			goto failure_cleanup;
 		}
 
@@ -699,6 +701,9 @@ static int plx_pci_add_card(struct pci_dev *pdev,
 			if (err) {
 				dev_err(&pdev->dev, "Registering device failed "
 					"(err=%d)\n", err);
+				pci_iounmap(pdev, priv->reg_base);
+				free_sja1000dev(dev);
+				card->net_dev[i] = NULL;
 				goto failure_cleanup;
 			}
 
@@ -710,6 +715,7 @@ static int plx_pci_add_card(struct pci_dev *pdev,
 		} else {
 			dev_err(&pdev->dev, "Channel #%d not detected\n",
 				i + 1);
+			pci_iounmap(pdev, priv->reg_base);
 			free_sja1000dev(dev);
 			card->net_dev[i] = NULL;
 		}
-- 
2.9.5

