Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE0E45670E5
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 16:23:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233324AbiGEOXf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 10:23:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232279AbiGEOXa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 10:23:30 -0400
Received: from smtp-relay-canonical-1.canonical.com (smtp-relay-canonical-1.canonical.com [185.125.188.121])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D0C1D63;
        Tue,  5 Jul 2022 07:23:26 -0700 (PDT)
Received: from HP-EliteBook-840-G7.. (1-171-254-213.dynamic-ip.hinet.net [1.171.254.213])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id 537E63F389;
        Tue,  5 Jul 2022 14:23:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1657031003;
        bh=D7jfmHe4bt9PCua6BTFCgsjFghH+nyLn06Td3cD4oK0=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
        b=mgThJ7cNdLY5Y8uO22gtyzPoWHBPdbIyKVEe5tL57gyTtFkM3HLqaCUxBQcrm8SPf
         5H8SkP/ymS7Uh39mcIvA3Twa7bvBPqbhLYkzyCww5+1yOxD15YrkWW2H2S/6kbt20i
         7p4uOX3agWr+2BZAzlTC+2cYL2kJ7IbRp5n1Xo4bCvzPkDxfOByNJjjnImd1hH8q/r
         LbhI7JZLZXSyCZhyCBgFhKYTPNyKEUi3Pw+fla2/PenURmdAqoVHD/S6HO4G8ifwGV
         9mV6amqHocMSQPw6EJiH0VH2tQaR6fFbV6IGfDBOCgzUZwaslBqtw9342gKCjqcWx/
         TQ6Ls9APibIWQ==
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
To:     nbd@nbd.name, lorenzo@kernel.org, ryder.lee@mediatek.com,
        shayne.chen@mediatek.com, sean.wang@mediatek.com, kvalo@kernel.org
Cc:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Deren Wu <deren.wu@mediatek.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] mt76: mt7921: Let PCI core handle power state and use pm_sleep_ptr()
Date:   Tue,  5 Jul 2022 22:23:04 +0800
Message-Id: <20220705142305.50292-1-kai.heng.feng@canonical.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PCI power state and wakeup are already handled by PCI core, so it's not
necessary to handle them in the driver.

Also switch to use pm_sleep_ptr() to remove #ifdef guard.

Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
---
 .../net/wireless/mediatek/mt76/mt7921/pci.c   | 25 ++++++-------------
 1 file changed, 7 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/pci.c b/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
index b5fb22b8e0869..b73699f80533a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
@@ -359,9 +359,9 @@ static void mt7921_pci_remove(struct pci_dev *pdev)
 	pci_free_irq_vectors(pdev);
 }
 
-#ifdef CONFIG_PM
-static int mt7921_pci_suspend(struct pci_dev *pdev, pm_message_t state)
+static int mt7921_pci_suspend(struct device *device)
 {
+	struct pci_dev *pdev = to_pci_dev(device);
 	struct mt76_dev *mdev = pci_get_drvdata(pdev);
 	struct mt7921_dev *dev = container_of(mdev, struct mt7921_dev, mt76);
 	struct mt76_connac_pm *pm = &dev->pm;
@@ -391,8 +391,6 @@ static int mt7921_pci_suspend(struct pci_dev *pdev, pm_message_t state)
 		napi_disable(&mdev->napi[i]);
 	}
 
-	pci_enable_wake(pdev, pci_choose_state(pdev, state), true);
-
 	/* wait until dma is idle  */
 	mt76_poll(dev, MT_WFDMA0_GLO_CFG,
 		  MT_WFDMA0_GLO_CFG_TX_DMA_BUSY |
@@ -412,8 +410,6 @@ static int mt7921_pci_suspend(struct pci_dev *pdev, pm_message_t state)
 	if (err)
 		goto restore_napi;
 
-	pci_save_state(pdev);
-	err = pci_set_power_state(pdev, pci_choose_state(pdev, state));
 	if (err)
 		goto restore_napi;
 
@@ -436,19 +432,14 @@ static int mt7921_pci_suspend(struct pci_dev *pdev, pm_message_t state)
 	return err;
 }
 
-static int mt7921_pci_resume(struct pci_dev *pdev)
+static int mt7921_pci_resume(struct device *device)
 {
+	struct pci_dev *pdev = to_pci_dev(device);
 	struct mt76_dev *mdev = pci_get_drvdata(pdev);
 	struct mt7921_dev *dev = container_of(mdev, struct mt7921_dev, mt76);
 	struct mt76_connac_pm *pm = &dev->pm;
 	int i, err;
 
-	err = pci_set_power_state(pdev, PCI_D0);
-	if (err)
-		return err;
-
-	pci_restore_state(pdev);
-
 	err = mt7921_mcu_drv_pmctrl(dev);
 	if (err < 0)
 		return err;
@@ -488,17 +479,15 @@ static int mt7921_pci_resume(struct pci_dev *pdev)
 
 	return err;
 }
-#endif /* CONFIG_PM */
+
+static DEFINE_SIMPLE_DEV_PM_OPS(mt7921_pm_ops, mt7921_pci_suspend, mt7921_pci_resume);
 
 struct pci_driver mt7921_pci_driver = {
 	.name		= KBUILD_MODNAME,
 	.id_table	= mt7921_pci_device_table,
 	.probe		= mt7921_pci_probe,
 	.remove		= mt7921_pci_remove,
-#ifdef CONFIG_PM
-	.suspend	= mt7921_pci_suspend,
-	.resume		= mt7921_pci_resume,
-#endif /* CONFIG_PM */
+	.driver.pm	= pm_sleep_ptr(&mt7921_pm_ops),
 };
 
 module_pci_driver(mt7921_pci_driver);
-- 
2.36.1

