Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45188553F57
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 02:07:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232282AbiFVAHH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 20:07:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231569AbiFVAHG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 20:07:06 -0400
Received: from novek.ru (unknown [213.148.174.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C4D41580D
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 17:07:05 -0700 (PDT)
Received: from nat1.ooonet.ru (gw.zelenaya.net [91.207.137.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id 560A3500593;
        Wed, 22 Jun 2022 03:05:33 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru 560A3500593
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1655856334; bh=ufbyJZN3WKSfAMdNgxGoEPKbZEhqEuE5NyNDOZFsKCc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QjrEeAyBPHZPDBJtIaODsoOMoqIJdCEMGVxJ+e76jAvaNzTOQEqUhGw8Cz0/CVbRc
         cJgYRR9xKwD8TKp0JhO5Sj6MUa3FgC9+54Lx5VxKF26mXKlbhca1suOsl8m+Bn9T/l
         U2XDUpVjWUCbT6ldCE5P4TqrZjG80ckIUhp57UeQ=
From:   Vadim Fedorenko <vfedorenko@novek.ru>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Vadim Fedorenko <vadfed@fb.com>, Aya Levin <ayal@nvidia.com>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        netdev@vger.kernel.org, linux-arm-kernel@vger.kernel.org
Subject: [RFC PATCH 3/3] ptp_ocp: implement DPLL ops
Date:   Wed, 22 Jun 2022 03:06:51 +0300
Message-Id: <20220622000651.27299-4-vfedorenko@novek.ru>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220622000651.27299-1-vfedorenko@novek.ru>
References: <20220622000651.27299-1-vfedorenko@novek.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vadim Fedorenko <vadfed@fb.com>

Implement DPLL operations in ptp_ocp driver.

Signed-off-by: Vadim Fedorenko <vadfed@fb.com>
---
 drivers/ptp/Kconfig   |  1 +
 drivers/ptp/ptp_ocp.c | 85 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 86 insertions(+)

diff --git a/drivers/ptp/Kconfig b/drivers/ptp/Kconfig
index 458218f88c5e..f74846ebc177 100644
--- a/drivers/ptp/Kconfig
+++ b/drivers/ptp/Kconfig
@@ -176,6 +176,7 @@ config PTP_1588_CLOCK_OCP
 	depends on !S390
 	depends on COMMON_CLK
 	select NET_DEVLINK
+	select DPLL
 	help
 	  This driver adds support for an OpenCompute time card.
 
diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index e59ea2173aac..b7bdb210514d 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -21,6 +21,7 @@
 #include <linux/mtd/mtd.h>
 #include <linux/nvmem-consumer.h>
 #include <linux/crc16.h>
+#include <uapi/linux/dpll.h>
 
 #define PCI_VENDOR_ID_FACEBOOK			0x1d9b
 #define PCI_DEVICE_ID_FACEBOOK_TIMECARD		0x0400
@@ -336,6 +337,7 @@ struct ptp_ocp {
 	struct ptp_ocp_signal	signal[4];
 	struct ptp_ocp_sma_connector sma[4];
 	const struct ocp_sma_op *sma_op;
+	struct dpll_device *dpll;
 };
 
 #define OCP_REQ_TIMESTAMP	BIT(0)
@@ -3713,6 +3715,81 @@ ptp_ocp_detach(struct ptp_ocp *bp)
 	device_unregister(&bp->dev);
 }
 
+static int ptp_ocp_dpll_get_status(struct dpll_device *dpll)
+{
+	struct ptp_ocp *bp = (struct ptp_ocp *)dpll->priv;
+	int sync;
+
+	sync = ioread32(&bp->reg->status) & OCP_STATUS_IN_SYNC;
+	return sync;
+}
+
+static int ptp_ocp_dpll_get_lock_status(struct dpll_device *dpll)
+{
+	struct ptp_ocp *bp = (struct ptp_ocp *)dpll->priv;
+	int sync;
+
+	sync = ioread32(&bp->reg->status) & OCP_STATUS_IN_SYNC;
+	return sync;
+}
+
+static int ptp_ocp_dpll_get_source_type(struct dpll_device *dpll, int sma)
+{
+	struct ptp_ocp *bp = (struct ptp_ocp *)dpll->priv;
+	int ret;
+
+	if (bp->sma[sma].mode != SMA_MODE_IN)
+		return -1;
+
+	switch (ptp_ocp_sma_get(bp, sma)) {
+	case 0:
+		ret = DPLL_TYPE_EXT_10MHZ;
+		break;
+	case 1:
+	case 2:
+		ret = DPLL_TYPE_EXT_1PPS;
+		break;
+	default:
+		ret = DPLL_TYPE_INT_OSCILLATOR;
+	}
+
+	return ret;
+}
+
+
+static int ptp_ocp_dpll_get_output_type(struct dpll_device *dpll, int sma)
+{
+	struct ptp_ocp *bp = (struct ptp_ocp *)dpll->priv;
+	int ret;
+
+	if (bp->sma[sma].mode != SMA_MODE_IN)
+		return -1;
+
+	switch (ptp_ocp_sma_get(bp, sma)) {
+	case 0:
+		ret = DPLL_TYPE_EXT_10MHZ;
+		break;
+	case 1:
+	case 2:
+		ret = DPLL_TYPE_INT_OSCILLATOR;
+	case 4:
+	case 8:
+		ret = DPLL_TYPE_GNSS;
+		break;
+	default:
+		ret = DPLL_TYPE_INT_OSCILLATOR;
+	}
+
+	return ret;
+}
+
+static struct dpll_device_ops ptp_ocp_dpll_ops {
+	.get_status			= ptp_ocp_dpll_get_status;
+	.get_lock_status	= ptp_ocp_dpll_get_lock_status;
+	.get_source_type	= ptp_ocp_dpll_get_source_type;
+	.get_output_type	= ptp_ocp_dpll_get_output_type;
+};
+
 static int
 ptp_ocp_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
@@ -3768,6 +3845,14 @@ ptp_ocp_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	ptp_ocp_info(bp);
 	devlink_register(devlink);
+
+	bp->dpll = dpll_device_alloc(&dpll_ops, ARRAY_SIZE(bp->sma), ARRAY_SIZE(bp->sma));
+	if (!bp->dpll) {
+		dev_err(&pdev->dev, "dpll_device_alloc failed\n");
+		return 0;
+	}
+	dpll_device_register(bp->dpll);
+
 	return 0;
 
 out:
-- 
2.27.0

