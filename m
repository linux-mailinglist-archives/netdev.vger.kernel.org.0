Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6165463CA9C
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 22:46:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236789AbiK2Vqr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 16:46:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236611AbiK2Vqp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 16:46:45 -0500
Received: from novek.ru (unknown [213.148.174.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BDE56B3B9;
        Tue, 29 Nov 2022 13:46:44 -0800 (PST)
Received: from nat1.ooonet.ru (gw.zelenaya.net [91.207.137.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id 2DF63504F87;
        Wed, 30 Nov 2022 00:33:56 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru 2DF63504F87
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1669757638; bh=fcSY/EdhUZvRyDuXygfRL0ws7XmTP433EmDuD6s0mdM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QMRAnYGw6ynzeBwyyAVm/Bf0UIub+2eMMiauK4hcZKxr/huxkJgippPlZTldfGbcB
         5jpHOi4mtkr5OHaIEvoB009hhfTw4cUr1VvuHP6As2MJVOCupUlHxHOFEl3f26Dv+J
         hYK3y4RQ7oU2bfEAvOJb+EQSpwOigBy6SzK6KavM=
From:   Vadim Fedorenko <vfedorenko@novek.ru>
To:     Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@resnulli.us>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Vadim Fedorenko <vadfed@fb.com>,
        linux-arm-kernel@lists.infradead.org, linux-clk@vger.kernel.org
Subject: [RFC PATCH v4 4/4] ptp_ocp: implement DPLL ops
Date:   Wed, 30 Nov 2022 00:37:24 +0300
Message-Id: <20221129213724.10119-5-vfedorenko@novek.ru>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20221129213724.10119-1-vfedorenko@novek.ru>
References: <20221129213724.10119-1-vfedorenko@novek.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vadim Fedorenko <vadfed@fb.com>

Implement basic DPLL operations in ptp_ocp driver as the
simplest example of using new subsystem.

Signed-off-by: Vadim Fedorenko <vadfed@fb.com>
---
 drivers/ptp/Kconfig   |   1 +
 drivers/ptp/ptp_ocp.c | 123 +++++++++++++++++++++++++++++-------------
 2 files changed, 87 insertions(+), 37 deletions(-)

diff --git a/drivers/ptp/Kconfig b/drivers/ptp/Kconfig
index fe4971b65c64..8c4cfabc1bfa 100644
--- a/drivers/ptp/Kconfig
+++ b/drivers/ptp/Kconfig
@@ -177,6 +177,7 @@ config PTP_1588_CLOCK_OCP
 	depends on COMMON_CLK
 	select NET_DEVLINK
 	select CRC16
+	select DPLL
 	help
 	  This driver adds support for an OpenCompute time card.
 
diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index 154d58cbd9ce..605853ac4a12 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -23,6 +23,8 @@
 #include <linux/mtd/mtd.h>
 #include <linux/nvmem-consumer.h>
 #include <linux/crc16.h>
+#include <linux/dpll.h>
+#include <uapi/linux/dpll.h>
 
 #define PCI_VENDOR_ID_FACEBOOK			0x1d9b
 #define PCI_DEVICE_ID_FACEBOOK_TIMECARD		0x0400
@@ -353,6 +355,7 @@ struct ptp_ocp {
 	struct ptp_ocp_signal	signal[4];
 	struct ptp_ocp_sma_connector sma[4];
 	const struct ocp_sma_op *sma_op;
+	struct dpll_device *dpll;
 };
 
 #define OCP_REQ_TIMESTAMP	BIT(0)
@@ -835,18 +838,19 @@ static DEFINE_IDR(ptp_ocp_idr);
 struct ocp_selector {
 	const char *name;
 	int value;
+	int dpll_type;
 };
 
 static const struct ocp_selector ptp_ocp_clock[] = {
-	{ .name = "NONE",	.value = 0 },
-	{ .name = "TOD",	.value = 1 },
-	{ .name = "IRIG",	.value = 2 },
-	{ .name = "PPS",	.value = 3 },
-	{ .name = "PTP",	.value = 4 },
-	{ .name = "RTC",	.value = 5 },
-	{ .name = "DCF",	.value = 6 },
-	{ .name = "REGS",	.value = 0xfe },
-	{ .name = "EXT",	.value = 0xff },
+	{ .name = "NONE",	.value = 0,		.dpll_type = 0 },
+	{ .name = "TOD",	.value = 1,		.dpll_type = 0 },
+	{ .name = "IRIG",	.value = 2,		.dpll_type = 0 },
+	{ .name = "PPS",	.value = 3,		.dpll_type = 0 },
+	{ .name = "PTP",	.value = 4,		.dpll_type = 0 },
+	{ .name = "RTC",	.value = 5,		.dpll_type = 0 },
+	{ .name = "DCF",	.value = 6,		.dpll_type = 0 },
+	{ .name = "REGS",	.value = 0xfe,		.dpll_type = 0 },
+	{ .name = "EXT",	.value = 0xff,		.dpll_type = 0 },
 	{ }
 };
 
@@ -855,37 +859,37 @@ static const struct ocp_selector ptp_ocp_clock[] = {
 #define SMA_SELECT_MASK		GENMASK(14, 0)
 
 static const struct ocp_selector ptp_ocp_sma_in[] = {
-	{ .name = "10Mhz",	.value = 0x0000 },
-	{ .name = "PPS1",	.value = 0x0001 },
-	{ .name = "PPS2",	.value = 0x0002 },
-	{ .name = "TS1",	.value = 0x0004 },
-	{ .name = "TS2",	.value = 0x0008 },
-	{ .name = "IRIG",	.value = 0x0010 },
-	{ .name = "DCF",	.value = 0x0020 },
-	{ .name = "TS3",	.value = 0x0040 },
-	{ .name = "TS4",	.value = 0x0080 },
-	{ .name = "FREQ1",	.value = 0x0100 },
-	{ .name = "FREQ2",	.value = 0x0200 },
-	{ .name = "FREQ3",	.value = 0x0400 },
-	{ .name = "FREQ4",	.value = 0x0800 },
-	{ .name = "None",	.value = SMA_DISABLE },
+	{ .name = "10Mhz",	.value = 0x0000,	.dpll_type = DPLL_PIN_SIGNAL_TYPE_10_MHZ },
+	{ .name = "PPS1",	.value = 0x0001,	.dpll_type = DPLL_PIN_SIGNAL_TYPE_1_PPS },
+	{ .name = "PPS2",	.value = 0x0002,	.dpll_type = DPLL_PIN_SIGNAL_TYPE_1_PPS },
+	{ .name = "TS1",	.value = 0x0004,	.dpll_type = DPLL_PIN_SIGNAL_TYPE_CUSTOM_FREQ },
+	{ .name = "TS2",	.value = 0x0008,	.dpll_type = DPLL_PIN_SIGNAL_TYPE_CUSTOM_FREQ },
+	{ .name = "IRIG",	.value = 0x0010,	.dpll_type = DPLL_PIN_SIGNAL_TYPE_CUSTOM_FREQ },
+	{ .name = "DCF",	.value = 0x0020,	.dpll_type = DPLL_PIN_SIGNAL_TYPE_CUSTOM_FREQ },
+	{ .name = "TS3",	.value = 0x0040,	.dpll_type = DPLL_PIN_SIGNAL_TYPE_CUSTOM_FREQ },
+	{ .name = "TS4",	.value = 0x0080,	.dpll_type = DPLL_PIN_SIGNAL_TYPE_CUSTOM_FREQ },
+	{ .name = "FREQ1",	.value = 0x0100,	.dpll_type = DPLL_PIN_SIGNAL_TYPE_CUSTOM_FREQ },
+	{ .name = "FREQ2",	.value = 0x0200,	.dpll_type = DPLL_PIN_SIGNAL_TYPE_CUSTOM_FREQ },
+	{ .name = "FREQ3",	.value = 0x0400,	.dpll_type = DPLL_PIN_SIGNAL_TYPE_CUSTOM_FREQ },
+	{ .name = "FREQ4",	.value = 0x0800,	.dpll_type = DPLL_PIN_SIGNAL_TYPE_CUSTOM_FREQ },
+	{ .name = "None",	.value = SMA_DISABLE,	.dpll_type = 0 },
 	{ }
 };
 
 static const struct ocp_selector ptp_ocp_sma_out[] = {
-	{ .name = "10Mhz",	.value = 0x0000 },
-	{ .name = "PHC",	.value = 0x0001 },
-	{ .name = "MAC",	.value = 0x0002 },
-	{ .name = "GNSS1",	.value = 0x0004 },
-	{ .name = "GNSS2",	.value = 0x0008 },
-	{ .name = "IRIG",	.value = 0x0010 },
-	{ .name = "DCF",	.value = 0x0020 },
-	{ .name = "GEN1",	.value = 0x0040 },
-	{ .name = "GEN2",	.value = 0x0080 },
-	{ .name = "GEN3",	.value = 0x0100 },
-	{ .name = "GEN4",	.value = 0x0200 },
-	{ .name = "GND",	.value = 0x2000 },
-	{ .name = "VCC",	.value = 0x4000 },
+	{ .name = "10Mhz",	.value = 0x0000,	.dpll_type = DPLL_PIN_SIGNAL_TYPE_10_MHZ },
+	{ .name = "PHC",	.value = 0x0001,	.dpll_type = DPLL_PIN_SIGNAL_TYPE_CUSTOM_FREQ },
+	{ .name = "MAC",	.value = 0x0002,	.dpll_type = DPLL_PIN_SIGNAL_TYPE_CUSTOM_FREQ },
+	{ .name = "GNSS1",	.value = 0x0004,	.dpll_type = DPLL_PIN_SIGNAL_TYPE_1_PPS },
+	{ .name = "GNSS2",	.value = 0x0008,	.dpll_type = DPLL_PIN_SIGNAL_TYPE_1_PPS },
+	{ .name = "IRIG",	.value = 0x0010,	.dpll_type = DPLL_PIN_SIGNAL_TYPE_CUSTOM_FREQ },
+	{ .name = "DCF",	.value = 0x0020,	.dpll_type = DPLL_PIN_SIGNAL_TYPE_CUSTOM_FREQ },
+	{ .name = "GEN1",	.value = 0x0040,	.dpll_type = DPLL_PIN_SIGNAL_TYPE_CUSTOM_FREQ },
+	{ .name = "GEN2",	.value = 0x0080,	.dpll_type = DPLL_PIN_SIGNAL_TYPE_CUSTOM_FREQ },
+	{ .name = "GEN3",	.value = 0x0100,	.dpll_type = DPLL_PIN_SIGNAL_TYPE_CUSTOM_FREQ },
+	{ .name = "GEN4",	.value = 0x0200,	.dpll_type = DPLL_PIN_SIGNAL_TYPE_CUSTOM_FREQ },
+	{ .name = "GND",	.value = 0x2000,	.dpll_type = 0 },
+	{ .name = "VCC",	.value = 0x4000,	.dpll_type = 0 },
 	{ }
 };
 
@@ -4175,12 +4179,41 @@ ptp_ocp_detach(struct ptp_ocp *bp)
 	device_unregister(&bp->dev);
 }
 
+static int ptp_ocp_dpll_get_attr(struct dpll_device *dpll, struct dpll_attr *attr)
+{
+	struct ptp_ocp *bp = (struct ptp_ocp *)dpll_priv(dpll);
+	int sync;
+
+	sync = ioread32(&bp->reg->status) & OCP_STATUS_IN_SYNC;
+	dpll_attr_lock_status_set(attr, sync ? DPLL_LOCK_STATUS_LOCKED : DPLL_LOCK_STATUS_UNLOCKED);
+
+	return 0;
+}
+
+static int ptp_ocp_dpll_pin_get_attr(struct dpll_device *dpll, struct dpll_pin *pin,
+				     struct dpll_pin_attr *attr)
+{
+	dpll_pin_attr_type_set(attr, DPLL_PIN_TYPE_EXT);
+	return 0;
+}
+
+static struct dpll_device_ops dpll_ops = {
+	.get	= ptp_ocp_dpll_get_attr,
+};
+
+static struct dpll_pin_ops dpll_pin_ops = {
+	.get	= ptp_ocp_dpll_pin_get_attr,
+};
+
 static int
 ptp_ocp_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
+	const u8 dpll_cookie[DPLL_COOKIE_LEN] = { "OCP" };
+	char pin_desc[PIN_DESC_LEN];
 	struct devlink *devlink;
+	struct dpll_pin *pin;
 	struct ptp_ocp *bp;
-	int err;
+	int err, i;
 
 	devlink = devlink_alloc(&ptp_ocp_devlink_ops, sizeof(*bp), &pdev->dev);
 	if (!devlink) {
@@ -4230,6 +4263,20 @@ ptp_ocp_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	ptp_ocp_info(bp);
 	devlink_register(devlink);
+
+	bp->dpll = dpll_device_alloc(&dpll_ops, DPLL_TYPE_PPS, dpll_cookie, pdev->bus->number, bp, &pdev->dev);
+	if (!bp->dpll) {
+		dev_err(&pdev->dev, "dpll_device_alloc failed\n");
+		goto out;
+	}
+	dpll_device_register(bp->dpll);
+
+	for (i = 0; i < 4; i++) {
+		snprintf(pin_desc, PIN_DESC_LEN, "sma%d", i + 1);
+		pin = dpll_pin_alloc(pin_desc, PIN_DESC_LEN);
+		dpll_pin_register(bp->dpll, pin, &dpll_pin_ops, bp);
+	}
+
 	return 0;
 
 out:
@@ -4247,6 +4294,8 @@ ptp_ocp_remove(struct pci_dev *pdev)
 	struct ptp_ocp *bp = pci_get_drvdata(pdev);
 	struct devlink *devlink = priv_to_devlink(bp);
 
+	dpll_device_unregister(bp->dpll);
+	dpll_device_free(bp->dpll);
 	devlink_unregister(devlink);
 	ptp_ocp_detach(bp);
 	pci_disable_device(pdev);
-- 
2.27.0

