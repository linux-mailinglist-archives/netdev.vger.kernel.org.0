Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92BFC46B8EE
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 11:25:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235109AbhLGK2p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 05:28:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235113AbhLGK2e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 05:28:34 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CF40C061746
        for <netdev@vger.kernel.org>; Tue,  7 Dec 2021 02:24:56 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1muXeZ-0003Qm-14
        for netdev@vger.kernel.org; Tue, 07 Dec 2021 11:24:55 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 36C786BE8F8
        for <netdev@vger.kernel.org>; Tue,  7 Dec 2021 10:24:48 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 406B56BE8B5;
        Tue,  7 Dec 2021 10:24:44 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id ba47db34;
        Tue, 7 Dec 2021 10:24:27 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net 9/9] can: m_can: pci: use custom bit timings for Elkhart Lake
Date:   Tue,  7 Dec 2021 11:24:20 +0100
Message-Id: <20211207102420.120131-10-mkl@pengutronix.de>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211207102420.120131-1-mkl@pengutronix.de>
References: <20211207102420.120131-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>

The relevant datasheet [1] specifies nonstandard limits for the bit timing
parameters. While it is unclear what the exact effect of violating these
limits is, it seems like a good idea to adhere to the documentation.

[1] Intel Atom® x6000E Series, and Intel® Pentium® and Celeron® N and J
    Series Processors for IoT Applications Datasheet,
    Volume 2 (Book 3 of 3), July 2021, Revision 001

Fixes: cab7ffc0324f ("can: m_can: add PCI glue driver for Intel Elkhart Lake")
Link: https://lore.kernel.org/all/9eba5d7c05a48ead4024ffa6e5926f191d8c6b38.1636967198.git.matthias.schiffer@ew.tq-group.com
Signed-off-by: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/m_can/m_can_pci.c | 48 ++++++++++++++++++++++++++++---
 1 file changed, 44 insertions(+), 4 deletions(-)

diff --git a/drivers/net/can/m_can/m_can_pci.c b/drivers/net/can/m_can/m_can_pci.c
index 8f184a852a0a..b56a54d6c5a9 100644
--- a/drivers/net/can/m_can/m_can_pci.c
+++ b/drivers/net/can/m_can/m_can_pci.c
@@ -18,9 +18,14 @@
 
 #define M_CAN_PCI_MMIO_BAR		0
 
-#define M_CAN_CLOCK_FREQ_EHL		200000000
 #define CTL_CSR_INT_CTL_OFFSET		0x508
 
+struct m_can_pci_config {
+	const struct can_bittiming_const *bit_timing;
+	const struct can_bittiming_const *data_timing;
+	unsigned int clock_freq;
+};
+
 struct m_can_pci_priv {
 	struct m_can_classdev cdev;
 
@@ -84,9 +89,40 @@ static struct m_can_ops m_can_pci_ops = {
 	.read_fifo = iomap_read_fifo,
 };
 
+static const struct can_bittiming_const m_can_bittiming_const_ehl = {
+	.name = KBUILD_MODNAME,
+	.tseg1_min = 2,		/* Time segment 1 = prop_seg + phase_seg1 */
+	.tseg1_max = 64,
+	.tseg2_min = 1,		/* Time segment 2 = phase_seg2 */
+	.tseg2_max = 128,
+	.sjw_max = 128,
+	.brp_min = 1,
+	.brp_max = 512,
+	.brp_inc = 1,
+};
+
+static const struct can_bittiming_const m_can_data_bittiming_const_ehl = {
+	.name = KBUILD_MODNAME,
+	.tseg1_min = 2,		/* Time segment 1 = prop_seg + phase_seg1 */
+	.tseg1_max = 16,
+	.tseg2_min = 1,		/* Time segment 2 = phase_seg2 */
+	.tseg2_max = 8,
+	.sjw_max = 4,
+	.brp_min = 1,
+	.brp_max = 32,
+	.brp_inc = 1,
+};
+
+static const struct m_can_pci_config m_can_pci_ehl = {
+	.bit_timing = &m_can_bittiming_const_ehl,
+	.data_timing = &m_can_data_bittiming_const_ehl,
+	.clock_freq = 200000000,
+};
+
 static int m_can_pci_probe(struct pci_dev *pci, const struct pci_device_id *id)
 {
 	struct device *dev = &pci->dev;
+	const struct m_can_pci_config *cfg;
 	struct m_can_classdev *mcan_class;
 	struct m_can_pci_priv *priv;
 	void __iomem *base;
@@ -114,6 +150,8 @@ static int m_can_pci_probe(struct pci_dev *pci, const struct pci_device_id *id)
 	if (!mcan_class)
 		return -ENOMEM;
 
+	cfg = (const struct m_can_pci_config *)id->driver_data;
+
 	priv = cdev_to_priv(mcan_class);
 
 	priv->base = base;
@@ -125,7 +163,9 @@ static int m_can_pci_probe(struct pci_dev *pci, const struct pci_device_id *id)
 	mcan_class->dev = &pci->dev;
 	mcan_class->net->irq = pci_irq_vector(pci, 0);
 	mcan_class->pm_clock_support = 1;
-	mcan_class->can.clock.freq = id->driver_data;
+	mcan_class->bit_timing = cfg->bit_timing;
+	mcan_class->data_timing = cfg->data_timing;
+	mcan_class->can.clock.freq = cfg->clock_freq;
 	mcan_class->ops = &m_can_pci_ops;
 
 	pci_set_drvdata(pci, mcan_class);
@@ -178,8 +218,8 @@ static SIMPLE_DEV_PM_OPS(m_can_pci_pm_ops,
 			 m_can_pci_suspend, m_can_pci_resume);
 
 static const struct pci_device_id m_can_pci_id_table[] = {
-	{ PCI_VDEVICE(INTEL, 0x4bc1), M_CAN_CLOCK_FREQ_EHL, },
-	{ PCI_VDEVICE(INTEL, 0x4bc2), M_CAN_CLOCK_FREQ_EHL, },
+	{ PCI_VDEVICE(INTEL, 0x4bc1), (kernel_ulong_t)&m_can_pci_ehl, },
+	{ PCI_VDEVICE(INTEL, 0x4bc2), (kernel_ulong_t)&m_can_pci_ehl, },
 	{  }	/* Terminating Entry */
 };
 MODULE_DEVICE_TABLE(pci, m_can_pci_id_table);
-- 
2.33.0


