Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50CCB52629B
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 15:08:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380575AbiEMNI3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 09:08:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380583AbiEMNI1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 09:08:27 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14A9D369F7
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 06:08:25 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1npV1s-00026p-DQ
        for netdev@vger.kernel.org; Fri, 13 May 2022 15:08:24 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 33A017DA52
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 13:08:23 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 1B0887DA3C;
        Fri, 13 May 2022 13:08:22 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 1616f0b4;
        Fri, 13 May 2022 13:08:21 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        Chee Hou Ong <chee.houx.ong@intel.com>,
        Aman Kumar <aman.kumar@intel.com>,
        Pallavi Kumari <kumari.pallavi@intel.com>,
        stable@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net 1/2] Revert "can: m_can: pci: use custom bit timings for Elkhart Lake"
Date:   Fri, 13 May 2022 15:08:18 +0200
Message-Id: <20220513130819.386012-2-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220513130819.386012-1-mkl@pengutronix.de>
References: <20220513130819.386012-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jarkko Nikula <jarkko.nikula@linux.intel.com>

This reverts commit 0e8ffdf3b86dfd44b651f91b12fcae76c25c453b.

Commit 0e8ffdf3b86d ("can: m_can: pci: use custom bit timings for
Elkhart Lake") broke the test case using bitrate switching.

| ip link set can0 up type can bitrate 500000 dbitrate 4000000 fd on
| ip link set can1 up type can bitrate 500000 dbitrate 4000000 fd on
| candump can0 &
| cangen can1 -I 0x800 -L 64 -e -fb \
|     -D 11223344deadbeef55667788feedf00daabbccdd44332211 -n 1 -v -v

Above commit does everything correctly according to the datasheet.
However datasheet wasn't correct.

I got confirmation from hardware engineers that the actual CAN
hardware on Intel Elkhart Lake is based on M_CAN version v3.2.0.
Datasheet was mirroring values from an another specification which was
based on earlier M_CAN version leading to wrong bit timings.

Therefore revert the commit and switch back to common bit timings.

Fixes: 0e8ffdf3b86d ("can: m_can: pci: use custom bit timings for Elkhart Lake")
Link: https://lore.kernel.org/all/20220512124144.536850-1-jarkko.nikula@linux.intel.com
Signed-off-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Reported-by: Chee Hou Ong <chee.houx.ong@intel.com>
Reported-by: Aman Kumar <aman.kumar@intel.com>
Reported-by: Pallavi Kumari <kumari.pallavi@intel.com>
Cc: <stable@vger.kernel.org> # v5.16+
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/m_can/m_can_pci.c | 48 +++----------------------------
 1 file changed, 4 insertions(+), 44 deletions(-)

diff --git a/drivers/net/can/m_can/m_can_pci.c b/drivers/net/can/m_can/m_can_pci.c
index b56a54d6c5a9..8f184a852a0a 100644
--- a/drivers/net/can/m_can/m_can_pci.c
+++ b/drivers/net/can/m_can/m_can_pci.c
@@ -18,14 +18,9 @@
 
 #define M_CAN_PCI_MMIO_BAR		0
 
+#define M_CAN_CLOCK_FREQ_EHL		200000000
 #define CTL_CSR_INT_CTL_OFFSET		0x508
 
-struct m_can_pci_config {
-	const struct can_bittiming_const *bit_timing;
-	const struct can_bittiming_const *data_timing;
-	unsigned int clock_freq;
-};
-
 struct m_can_pci_priv {
 	struct m_can_classdev cdev;
 
@@ -89,40 +84,9 @@ static struct m_can_ops m_can_pci_ops = {
 	.read_fifo = iomap_read_fifo,
 };
 
-static const struct can_bittiming_const m_can_bittiming_const_ehl = {
-	.name = KBUILD_MODNAME,
-	.tseg1_min = 2,		/* Time segment 1 = prop_seg + phase_seg1 */
-	.tseg1_max = 64,
-	.tseg2_min = 1,		/* Time segment 2 = phase_seg2 */
-	.tseg2_max = 128,
-	.sjw_max = 128,
-	.brp_min = 1,
-	.brp_max = 512,
-	.brp_inc = 1,
-};
-
-static const struct can_bittiming_const m_can_data_bittiming_const_ehl = {
-	.name = KBUILD_MODNAME,
-	.tseg1_min = 2,		/* Time segment 1 = prop_seg + phase_seg1 */
-	.tseg1_max = 16,
-	.tseg2_min = 1,		/* Time segment 2 = phase_seg2 */
-	.tseg2_max = 8,
-	.sjw_max = 4,
-	.brp_min = 1,
-	.brp_max = 32,
-	.brp_inc = 1,
-};
-
-static const struct m_can_pci_config m_can_pci_ehl = {
-	.bit_timing = &m_can_bittiming_const_ehl,
-	.data_timing = &m_can_data_bittiming_const_ehl,
-	.clock_freq = 200000000,
-};
-
 static int m_can_pci_probe(struct pci_dev *pci, const struct pci_device_id *id)
 {
 	struct device *dev = &pci->dev;
-	const struct m_can_pci_config *cfg;
 	struct m_can_classdev *mcan_class;
 	struct m_can_pci_priv *priv;
 	void __iomem *base;
@@ -150,8 +114,6 @@ static int m_can_pci_probe(struct pci_dev *pci, const struct pci_device_id *id)
 	if (!mcan_class)
 		return -ENOMEM;
 
-	cfg = (const struct m_can_pci_config *)id->driver_data;
-
 	priv = cdev_to_priv(mcan_class);
 
 	priv->base = base;
@@ -163,9 +125,7 @@ static int m_can_pci_probe(struct pci_dev *pci, const struct pci_device_id *id)
 	mcan_class->dev = &pci->dev;
 	mcan_class->net->irq = pci_irq_vector(pci, 0);
 	mcan_class->pm_clock_support = 1;
-	mcan_class->bit_timing = cfg->bit_timing;
-	mcan_class->data_timing = cfg->data_timing;
-	mcan_class->can.clock.freq = cfg->clock_freq;
+	mcan_class->can.clock.freq = id->driver_data;
 	mcan_class->ops = &m_can_pci_ops;
 
 	pci_set_drvdata(pci, mcan_class);
@@ -218,8 +178,8 @@ static SIMPLE_DEV_PM_OPS(m_can_pci_pm_ops,
 			 m_can_pci_suspend, m_can_pci_resume);
 
 static const struct pci_device_id m_can_pci_id_table[] = {
-	{ PCI_VDEVICE(INTEL, 0x4bc1), (kernel_ulong_t)&m_can_pci_ehl, },
-	{ PCI_VDEVICE(INTEL, 0x4bc2), (kernel_ulong_t)&m_can_pci_ehl, },
+	{ PCI_VDEVICE(INTEL, 0x4bc1), M_CAN_CLOCK_FREQ_EHL, },
+	{ PCI_VDEVICE(INTEL, 0x4bc2), M_CAN_CLOCK_FREQ_EHL, },
 	{  }	/* Terminating Entry */
 };
 MODULE_DEVICE_TABLE(pci, m_can_pci_id_table);

base-commit: f3f19f939c11925dadd3f4776f99f8c278a7017b
-- 
2.35.1


