Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4EC2502BEC
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 16:32:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354624AbiDOOeM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 10:34:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354759AbiDOOeI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 10:34:08 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 898A3D3AFE;
        Fri, 15 Apr 2022 07:31:28 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 23FATHme003966;
        Fri, 15 Apr 2022 07:31:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0220; bh=kQa1/fI8r7R7SSHsQpLYhMScAwHxIdb1Nb1bGo1gqx0=;
 b=Afq0MHl7Xpci6PQQ9l675E2A1zsFgbLddECZrB7QNaYhD02et4wtN9i9Ud7kuEbyR8HT
 TVepFMwmmGl1IPUFotfDA1pgy8OfGQERkECoA6fvxni4qS7kq1j3nGVJHmvvNZkEgxA0
 l41GotYQ6PlGPhGSnWoH67qFMDyb8hrmantjJWGvcDbu+mRNvwC1TLSNuwD+HgTy/TU2
 94j+aPPGsrmN82O2nqJd27PXzfHgHMDL72C37HyqhzRU6bVShweOKoeR/XtyvfGAeldc
 ko3e3t50mc3hXOK1uUBy2TYG3CptFcikZmLTZynM3WowE11XZA53XzT5usN8Z8hEvH1r nw== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3fdw7ej6kx-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 15 Apr 2022 07:31:03 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 15 Apr
 2022 07:31:01 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 15 Apr 2022 07:31:01 -0700
Received: from localhost.localdomain (unknown [10.110.150.250])
        by maili.marvell.com (Postfix) with ESMTP id 8EB5B3F706C;
        Fri, 15 Apr 2022 07:31:01 -0700 (PDT)
From:   Piyush Malgujar <pmalgujar@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <cchavva@marvell.com>, Piyush Malgujar <pmalgujar@marvell.com>,
        "Damian Eppel" <deppel@marvell.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH] Marvell MDIO clock related changes.
Date:   Fri, 15 Apr 2022 07:30:26 -0700
Message-ID: <20220415143026.11088-1-pmalgujar@marvell.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: bE6rxzjobvtJfhLz4qN_-LMDzm6fWtav
X-Proofpoint-ORIG-GUID: bE6rxzjobvtJfhLz4qN_-LMDzm6fWtav
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-15_05,2022-04-15_01,2022-02-23_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch includes following support related to MDIO Clock:

1) clock gating:
The purpose of this change is to apply clock gating for MDIO clock when there is no transaction happening.
This will stop the MDC clock toggling in idle scenario.

2) Marvell MDIO clock frequency attribute change:
This MDIO change provides an option for user to have the bus speed set to their needs which is otherwise set
to default(3.125 MHz). In case someone needs to use this attribute, they have to add an extra attribute clock-freq
in the mdio entry in their DTS and this driver will support the rest.

The changes are made in a way that the clock will set to the nearest possible value based on the clock calculation
and required frequency from DTS. Below are some possible values:
default:3.125 MHz
Max:16.67 MHz

These changes has been verified internally with Marvell SoCs 9x and 10x series.

Signed-off-by: Piyush Malgujar <pmalgujar@marvell.com>
Signed-off-by: Damian Eppel <deppel@marvell.com>
---
 drivers/net/mdio/mdio-cavium.h  |  1 +
 drivers/net/mdio/mdio-thunder.c | 65 +++++++++++++++++++++++++++++++++
 2 files changed, 66 insertions(+)

diff --git a/drivers/net/mdio/mdio-cavium.h b/drivers/net/mdio/mdio-cavium.h
index a2245d436f5dae4d6424b7c7bfca0aa969a3b3ad..ed4c48d8a38bd80e6a169f7a6d90c1f2a0daccfc 100644
--- a/drivers/net/mdio/mdio-cavium.h
+++ b/drivers/net/mdio/mdio-cavium.h
@@ -92,6 +92,7 @@ struct cavium_mdiobus {
 	struct mii_bus *mii_bus;
 	void __iomem *register_base;
 	enum cavium_mdiobus_mode mode;
+	u32 clk_freq;
 };
 
 #ifdef CONFIG_CAVIUM_OCTEON_SOC
diff --git a/drivers/net/mdio/mdio-thunder.c b/drivers/net/mdio/mdio-thunder.c
index 822d2cdd2f3599025f3e79d4243337c18114c951..642d08aff3f7f849102992a891790e900b111d5c 100644
--- a/drivers/net/mdio/mdio-thunder.c
+++ b/drivers/net/mdio/mdio-thunder.c
@@ -19,6 +19,46 @@ struct thunder_mdiobus_nexus {
 	struct cavium_mdiobus *buses[4];
 };
 
+#define _calc_clk_freq(_phase) (100000000U / (2 * (_phase)))
+#define _calc_sample(_phase) (2 * (_phase) - 3)
+
+#define PHASE_MIN 3
+#define PHASE_DFLT 16
+#define DFLT_CLK_FREQ _calc_clk_freq(PHASE_DFLT)
+#define MAX_CLK_FREQ _calc_clk_freq(PHASE_MIN)
+
+static inline u32 _config_clk(u32 req_freq, u32 *phase, u32 *sample)
+{
+	unsigned int p;
+	u32 freq = 0, freq_prev;
+
+	for (p = PHASE_MIN; p < PHASE_DFLT; p++) {
+		freq_prev = freq;
+		freq = _calc_clk_freq(p);
+
+		if (req_freq >= freq)
+			break;
+	}
+
+	if (p == PHASE_DFLT)
+		freq = DFLT_CLK_FREQ;
+
+	if (p == PHASE_MIN || p == PHASE_DFLT)
+		goto out;
+
+	/* Check which clock value from the identified range
+	 * is closer to the requested value
+	 */
+	if ((freq_prev - req_freq) < (req_freq - freq)) {
+		p = p - 1;
+		freq = freq_prev;
+	}
+out:
+	*phase = p;
+	*sample = _calc_sample(p);
+	return freq;
+}
+
 static int thunder_mdiobus_pci_probe(struct pci_dev *pdev,
 				     const struct pci_device_id *ent)
 {
@@ -59,6 +99,8 @@ static int thunder_mdiobus_pci_probe(struct pci_dev *pdev,
 		struct mii_bus *mii_bus;
 		struct cavium_mdiobus *bus;
 		union cvmx_smix_en smi_en;
+		union cvmx_smix_clk smi_clk;
+		u32 req_clk_freq;
 
 		/* If it is not an OF node we cannot handle it yet, so
 		 * exit the loop.
@@ -87,6 +129,29 @@ static int thunder_mdiobus_pci_probe(struct pci_dev *pdev,
 		bus->register_base = nexus->bar0 +
 			r.start - pci_resource_start(pdev, 0);
 
+		smi_clk.u64 = oct_mdio_readq(bus->register_base + SMI_CLK);
+		smi_clk.s.clk_idle = 1;
+
+		if (!of_property_read_u32(node, "clock-freq", &req_clk_freq)) {
+			u32 phase, sample;
+
+			dev_info(&pdev->dev, "requested bus clock frequency=%d\n",
+				 req_clk_freq);
+
+			 bus->clk_freq = _config_clk(req_clk_freq,
+						     &phase, &sample);
+
+			 smi_clk.s.phase = phase;
+			 smi_clk.s.sample_hi = (sample >> 4) & 0x1f;
+			 smi_clk.s.sample = sample & 0xf;
+		} else {
+			bus->clk_freq = DFLT_CLK_FREQ;
+		}
+
+		oct_mdio_writeq(smi_clk.u64, bus->register_base + SMI_CLK);
+		dev_info(&pdev->dev, "bus clock frequency set to %d\n",
+			 bus->clk_freq);
+
 		smi_en.u64 = 0;
 		smi_en.s.en = 1;
 		oct_mdio_writeq(smi_en.u64, bus->register_base + SMI_EN);
-- 
2.17.1

