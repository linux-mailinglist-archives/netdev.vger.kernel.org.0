Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F27C9537AE7
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 14:58:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236257AbiE3M55 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 08:57:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236254AbiE3M54 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 08:57:56 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFC00DF0D;
        Mon, 30 May 2022 05:57:55 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24UC20jm010899;
        Mon, 30 May 2022 05:57:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=DHPwQM3EoZAYOMrTULFucAAFNaQSwNNJwNpzOvB+juM=;
 b=dMQJnJzQ5NQk1AeaWZCDa70gne3/2tOHUrOttxElRN+GsivJxkWokiwfV8d0UrUxOtwV
 o0vWWvc2XkhKyk8wcN3H81LCRfxDJz2pmhuWxQ+1HKYostRE5NyTuuJl36evzHDB4Jyp
 PGyUZ+g+ldPE3Dc7KZrCbMZM6YI43ALXcMiNo61SENP1lADoaFxywhgAul+fty4sNb2Q
 srZhdzKAbQ8J6NMsQPa3lto6DjBXlzq5IGf2oRj5LM16REAVJj3JYLwvvWhALgeoiCu9
 uttgaYDJQbp+gBCSrzVFMMJhqywZUSkTcBoCwW6iyYEREd6qhBjIO3OYMx2XsXkFd/qJ Wg== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3gbh3pdrrr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 30 May 2022 05:57:37 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 30 May
 2022 05:57:36 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 30 May 2022 05:57:36 -0700
Received: from localhost.localdomain (unknown [10.110.150.250])
        by maili.marvell.com (Postfix) with ESMTP id C82F23F7048;
        Mon, 30 May 2022 05:57:35 -0700 (PDT)
From:   Piyush Malgujar <pmalgujar@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <krzysztof.kozlowski+dt@linaro.org>, <devicetree@vger.kernel.org>,
        <cchavva@marvell.com>, <deppel@marvell.com>,
        Piyush Malgujar <pmalgujar@marvell.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH v2 3/3] net: mdio: mdio-thunder: support for clock-freq attribute
Date:   Mon, 30 May 2022 05:53:28 -0700
Message-ID: <20220530125329.30717-4-pmalgujar@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220530125329.30717-1-pmalgujar@marvell.com>
References: <20220530125329.30717-1-pmalgujar@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: RsXBWQOEP4gosMau-E17IVTLOcZiAxba
X-Proofpoint-ORIG-GUID: RsXBWQOEP4gosMau-E17IVTLOcZiAxba
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-30_04,2022-05-30_01,2022-02-23_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Added functionality to modify clock frequency via DTS entry.

Signed-off-by: Damian Eppel <deppel@marvell.com>
Signed-off-by: Piyush Malgujar <pmalgujar@marvell.com>
---
 drivers/net/mdio/mdio-cavium.h  |  1 +
 drivers/net/mdio/mdio-thunder.c | 63 +++++++++++++++++++++++++++++++++
 2 files changed, 64 insertions(+)

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
index 715c835ace785da345ac037177b0f291678e4c47..7ea6ef0a23f3f5d7df76e3a7aed007ed847f9140 100644
--- a/drivers/net/mdio/mdio-thunder.c
+++ b/drivers/net/mdio/mdio-thunder.c
@@ -14,11 +14,56 @@
 
 #include "mdio-cavium.h"
 
+#define PHASE_MIN 3
+#define PHASE_DFLT 16
+
 struct thunder_mdiobus_nexus {
 	void __iomem *bar0;
 	struct cavium_mdiobus *buses[4];
 };
 
+static inline u32 clk_freq(u32 phase)
+{
+	return (100000000U / (2 * (phase)));
+}
+
+static inline u32 calc_sample(u32 phase)
+{
+	return (2 * (phase) - 3);
+}
+
+static u32 _config_clk(u32 req_freq, u32 *phase, u32 *sample)
+{
+	unsigned int p;
+	u32 freq = 0, freq_prev;
+
+	for (p = PHASE_MIN; p < PHASE_DFLT; p++) {
+		freq_prev = freq;
+		freq = clk_freq(p);
+
+		if (req_freq >= freq)
+			break;
+	}
+
+	if (p == PHASE_DFLT)
+		freq = clk_freq(PHASE_DFLT);
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
+	*sample = calc_sample(p);
+	return freq;
+}
+
 static int thunder_mdiobus_pci_probe(struct pci_dev *pdev,
 				     const struct pci_device_id *ent)
 {
@@ -56,6 +101,7 @@ static int thunder_mdiobus_pci_probe(struct pci_dev *pdev,
 	i = 0;
 	device_for_each_child_node(&pdev->dev, fwn) {
 		struct resource r;
+		u32 req_clk_freq;
 		struct mii_bus *mii_bus;
 		struct cavium_mdiobus *bus;
 		union cvmx_smix_clk smi_clk;
@@ -90,6 +136,23 @@ static int thunder_mdiobus_pci_probe(struct pci_dev *pdev,
 
 		smi_clk.u64 = oct_mdio_readq(bus->register_base + SMI_CLK);
 		smi_clk.s.clk_idle = 1;
+
+		if (!of_property_read_u32(node, "clock-frequency", &req_clk_freq)) {
+			u32 phase, sample;
+
+			dev_dbg(&pdev->dev, "requested bus clock frequency=%d\n",
+				req_clk_freq);
+
+			bus->clk_freq = _config_clk(req_clk_freq,
+						    &phase, &sample);
+
+			smi_clk.s.phase = phase;
+			smi_clk.s.sample_hi = (sample >> 4) & 0x1f;
+			smi_clk.s.sample = sample & 0xf;
+		} else {
+			bus->clk_freq = clk_freq(PHASE_DFLT);
+		}
+
 		oct_mdio_writeq(smi_clk.u64, bus->register_base + SMI_CLK);
 
 		smi_en.u64 = 0;
-- 
2.17.1

