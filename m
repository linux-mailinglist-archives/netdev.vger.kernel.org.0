Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C8FE4FDD3B
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 13:08:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235134AbiDLLCI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 07:02:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233157AbiDLLAA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 07:00:00 -0400
X-Greylist: delayed 1140 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 12 Apr 2022 02:50:58 PDT
Received: from mxout012.mail.hostpoint.ch (mxout012.mail.hostpoint.ch [IPv6:2a00:d70:0:e::312])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E270165163;
        Tue, 12 Apr 2022 02:50:56 -0700 (PDT)
Received: from [10.0.2.44] (helo=asmtp014.mail.hostpoint.ch)
        by mxout012.mail.hostpoint.ch with esmtps  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.95 (FreeBSD))
        (envelope-from <dev@pschenker.ch>)
        id 1neCSD-000OOB-IK;
        Tue, 12 Apr 2022 11:04:53 +0200
Received: from 31-10-206-124.static.upc.ch ([31.10.206.124] helo=localhost.localdomain)
        by asmtp014.mail.hostpoint.ch with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.95 (FreeBSD))
        (envelope-from <dev@pschenker.ch>)
        id 1neCSD-000CGw-Ce;
        Tue, 12 Apr 2022 11:04:53 +0200
X-Authenticated-Sender-Id: dev@pschenker.ch
From:   Philippe Schenker <dev@pschenker.ch>
To:     linux-wireless@vger.kernel.org, Felix Fietkau <nbd@nbd.name>
Cc:     linux@leemhuis.info, Philippe Schenker <dev@pschenker.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Deren Wu <deren.wu@mediatek.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Kalle Valo <kvalo@kernel.org>,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Shayne Chen <shayne.chen@mediatek.com>,
        YN Chen <YN.Chen@mediatek.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mediatek@lists.infradead.org, netdev@vger.kernel.org
Subject: [PATCH] Revert "mt76: mt7921: enable aspm by default"
Date:   Tue, 12 Apr 2022 11:04:14 +0200
Message-Id: <20220412090415.17541-1-dev@pschenker.ch>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit bf3747ae2e25dda6a9e6c464a717c66118c588c8.

This commit introduces a regression on some systems where the kernel is
crashing in different locations after a reboot was issued.

This issue was bisected on a Thinkpad P14s Gen2 (AMD) with latest firmware.

Link: https://lore.kernel.org/linux-wireless/5077a953487275837e81bdf1808ded00b9676f9f.camel@pschenker.ch/
Signed-off-by: Philippe Schenker <dev@pschenker.ch>
---

 drivers/net/wireless/mediatek/mt76/mt7921/pci.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/pci.c b/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
index 1a01d025bbe5..59f9ee089389 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
@@ -20,10 +20,6 @@ static const struct pci_device_id mt7921_pci_device_table[] = {
 	{ },
 };
 
-static bool mt7921_disable_aspm;
-module_param_named(disable_aspm, mt7921_disable_aspm, bool, 0644);
-MODULE_PARM_DESC(disable_aspm, "disable PCI ASPM support");
-
 static void
 mt7921_rx_poll_complete(struct mt76_dev *mdev, enum mt76_rxq_id q)
 {
@@ -280,8 +276,7 @@ static int mt7921_pci_probe(struct pci_dev *pdev,
 	if (ret)
 		goto err_free_pci_vec;
 
-	if (mt7921_disable_aspm)
-		mt76_pci_disable_aspm(pdev);
+	mt76_pci_disable_aspm(pdev);
 
 	mdev = mt76_alloc_device(&pdev->dev, sizeof(*dev), &mt7921_ops,
 				 &drv_ops);
-- 
2.35.1

