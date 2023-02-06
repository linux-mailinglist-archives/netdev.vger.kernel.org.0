Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45BD768BDD6
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 14:19:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230418AbjBFNS5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 08:18:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230332AbjBFNSR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 08:18:17 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA03424485
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 05:17:34 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1pP1NE-0007zv-W4
        for netdev@vger.kernel.org; Mon, 06 Feb 2023 14:17:33 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 9663717145D
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 13:16:27 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 8FA1F1712D1;
        Mon,  6 Feb 2023 13:16:23 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id cb881da8;
        Mon, 6 Feb 2023 13:16:22 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Gerhard Uttenthaler <uttenthaler@ems-wuensche.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 20/47] can: ems_pci: Add IRQ enable
Date:   Mon,  6 Feb 2023 14:15:53 +0100
Message-Id: <20230206131620.2758724-21-mkl@pengutronix.de>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230206131620.2758724-1-mkl@pengutronix.de>
References: <20230206131620.2758724-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Gerhard Uttenthaler <uttenthaler@ems-wuensche.com>

Add IRQ enable

Signed-off-by: Gerhard Uttenthaler <uttenthaler@ems-wuensche.com>
Link: https://lore.kernel.org/all/20230120112616.6071-7-uttenthaler@ems-wuensche.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/sja1000/ems_pci.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/sja1000/ems_pci.c b/drivers/net/can/sja1000/ems_pci.c
index d1e8758d8043..1f237acd7bd1 100644
--- a/drivers/net/can/sja1000/ems_pci.c
+++ b/drivers/net/can/sja1000/ems_pci.c
@@ -372,14 +372,21 @@ static int ems_pci_add_card(struct pci_dev *pdev,
 			SET_NETDEV_DEV(dev, &pdev->dev);
 			dev->dev_id = i;
 
-			if (card->version == 1)
+			if (card->version == 1) {
 				/* reset int flag of pita */
 				writel(PITA2_ICR_INT0_EN | PITA2_ICR_INT0,
 				       card->conf_addr + PITA2_ICR);
-			else
+			} else if (card->version == 2) {
 				/* enable IRQ in PLX 9030 */
 				writel(PLX_ICSR_ENA_CLR,
 				       card->conf_addr + PLX_ICSR);
+			} else {
+				/* Enable IRQ in AX99100 */
+				writel(ASIX_LINTSR_INT0AC, card->conf_addr + ASIX_LINTSR);
+				/* Enable local INT0 input enable */
+				writel(readl(card->conf_addr + ASIX_LIEMR) | ASIX_LIEMR_L0EINTEN,
+				       card->conf_addr + ASIX_LIEMR);
+			}
 
 			/* Register SJA1000 device */
 			err = register_sja1000dev(dev);
-- 
2.39.1


