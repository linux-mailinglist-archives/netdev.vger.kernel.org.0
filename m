Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84268537AE0
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 14:57:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236234AbiE3M5P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 08:57:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236224AbiE3M5O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 08:57:14 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01A0EDE97;
        Mon, 30 May 2022 05:57:12 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24UB4KFc012162;
        Mon, 30 May 2022 05:57:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=oYO13XbBYLyDLrEfDsgv1ohh53H8w+Fz/FYNKcSq9yI=;
 b=GjjA1ziOnzt4ur10Gfq2c15BMHazksFMSOLtWRFAU8Uqloc+LQNWaKQCE9z2ESbYQTeF
 skVtDEXsYfetN0FTT1TwzS8FWPBCph+ttf3YQV6Q+3KGVLtpcHTK2gTM1FiUZlk71r7x
 zh8H8RA6bnzLLv6q4/oHk4ks6HcKtnd+j8YDW+oSIUObECXE0RpD4RPT8BpxFF2F7qNs
 jEqixAONjgW64ssNcH+uTd5YBKuH8QsIk5OKQj3OKYVGMxLyFPllaQmEVEhQpJj82qf8
 gtauRmH6Eh014coZqGher0UdSMandON5UP7D3omDUFjFim/t5I8wuYI9niIVCV07IP1s kg== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3gbk8n5fc5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 30 May 2022 05:57:03 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 30 May
 2022 05:57:01 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Mon, 30 May 2022 05:57:01 -0700
Received: from localhost.localdomain (unknown [10.110.150.250])
        by maili.marvell.com (Postfix) with ESMTP id B3C863F7048;
        Mon, 30 May 2022 05:57:00 -0700 (PDT)
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
Subject: [PATCH v2 1/3] net: mdio: mdio-thunder: stop toggling SMI clock on idle
Date:   Mon, 30 May 2022 05:53:26 -0700
Message-ID: <20220530125329.30717-2-pmalgujar@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220530125329.30717-1-pmalgujar@marvell.com>
References: <20220530125329.30717-1-pmalgujar@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: gq0OF6O3plAHcXdXigZaoxn07hpx5dE7
X-Proofpoint-GUID: gq0OF6O3plAHcXdXigZaoxn07hpx5dE7
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

SMI clock should be running only for the time when there are transactions
on the bus.

Signed-off-by: Damian Eppel <deppel@marvell.com>
Signed-off-by: Piyush Malgujar <pmalgujar@marvell.com>
---
 drivers/net/mdio/mdio-thunder.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/mdio/mdio-thunder.c b/drivers/net/mdio/mdio-thunder.c
index 822d2cdd2f3599025f3e79d4243337c18114c951..715c835ace785da345ac037177b0f291678e4c47 100644
--- a/drivers/net/mdio/mdio-thunder.c
+++ b/drivers/net/mdio/mdio-thunder.c
@@ -58,6 +58,7 @@ static int thunder_mdiobus_pci_probe(struct pci_dev *pdev,
 		struct resource r;
 		struct mii_bus *mii_bus;
 		struct cavium_mdiobus *bus;
+		union cvmx_smix_clk smi_clk;
 		union cvmx_smix_en smi_en;
 
 		/* If it is not an OF node we cannot handle it yet, so
@@ -87,6 +88,10 @@ static int thunder_mdiobus_pci_probe(struct pci_dev *pdev,
 		bus->register_base = nexus->bar0 +
 			r.start - pci_resource_start(pdev, 0);
 
+		smi_clk.u64 = oct_mdio_readq(bus->register_base + SMI_CLK);
+		smi_clk.s.clk_idle = 1;
+		oct_mdio_writeq(smi_clk.u64, bus->register_base + SMI_CLK);
+
 		smi_en.u64 = 0;
 		smi_en.s.en = 1;
 		oct_mdio_writeq(smi_en.u64, bus->register_base + SMI_EN);
-- 
2.17.1

