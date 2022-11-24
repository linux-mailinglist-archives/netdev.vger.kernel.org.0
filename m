Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13B67637FEA
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 20:57:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229639AbiKXT5Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 14:57:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229644AbiKXT5T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 14:57:19 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED60491C31
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 11:57:16 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oyILT-0004fv-5U
        for netdev@vger.kernel.org; Thu, 24 Nov 2022 20:57:15 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 2503F128987
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 19:57:13 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 32B5112894A;
        Thu, 24 Nov 2022 19:57:10 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 9438c3de;
        Thu, 24 Nov 2022 19:57:09 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Zhang Changzhong <zhangchangzhong@huawei.com>,
        Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net 6/8] can: m_can: pci: add missing m_can_class_free_dev() in probe/remove methods
Date:   Thu, 24 Nov 2022 20:57:06 +0100
Message-Id: <20221124195708.1473369-7-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221124195708.1473369-1-mkl@pengutronix.de>
References: <20221124195708.1473369-1-mkl@pengutronix.de>
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

From: Zhang Changzhong <zhangchangzhong@huawei.com>

In m_can_pci_remove() and error handling path of m_can_pci_probe(),
m_can_class_free_dev() should be called to free resource allocated by
m_can_class_allocate_dev(), otherwise there will be memleak.

Fixes: cab7ffc0324f ("can: m_can: add PCI glue driver for Intel Elkhart Lake")
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
Reviewed-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Link: https://lore.kernel.org/all/1668168684-6390-1-git-send-email-zhangchangzhong@huawei.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/m_can/m_can_pci.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/can/m_can/m_can_pci.c b/drivers/net/can/m_can/m_can_pci.c
index 8f184a852a0a..f2219aa2824b 100644
--- a/drivers/net/can/m_can/m_can_pci.c
+++ b/drivers/net/can/m_can/m_can_pci.c
@@ -120,7 +120,7 @@ static int m_can_pci_probe(struct pci_dev *pci, const struct pci_device_id *id)
 
 	ret = pci_alloc_irq_vectors(pci, 1, 1, PCI_IRQ_ALL_TYPES);
 	if (ret < 0)
-		return ret;
+		goto err_free_dev;
 
 	mcan_class->dev = &pci->dev;
 	mcan_class->net->irq = pci_irq_vector(pci, 0);
@@ -132,7 +132,7 @@ static int m_can_pci_probe(struct pci_dev *pci, const struct pci_device_id *id)
 
 	ret = m_can_class_register(mcan_class);
 	if (ret)
-		goto err;
+		goto err_free_irq;
 
 	/* Enable interrupt control at CAN wrapper IP */
 	writel(0x1, base + CTL_CSR_INT_CTL_OFFSET);
@@ -144,8 +144,10 @@ static int m_can_pci_probe(struct pci_dev *pci, const struct pci_device_id *id)
 
 	return 0;
 
-err:
+err_free_irq:
 	pci_free_irq_vectors(pci);
+err_free_dev:
+	m_can_class_free_dev(mcan_class->net);
 	return ret;
 }
 
@@ -161,6 +163,7 @@ static void m_can_pci_remove(struct pci_dev *pci)
 	writel(0x0, priv->base + CTL_CSR_INT_CTL_OFFSET);
 
 	m_can_class_unregister(mcan_class);
+	m_can_class_free_dev(mcan_class->net);
 	pci_free_irq_vectors(pci);
 }
 
-- 
2.35.1


