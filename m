Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 532666ABDDA
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 12:10:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229680AbjCFLKO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 06:10:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230219AbjCFLKC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 06:10:02 -0500
Received: from lelv0142.ext.ti.com (lelv0142.ext.ti.com [198.47.23.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6F3911EB0;
        Mon,  6 Mar 2023 03:10:00 -0800 (PST)
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 326B9nHB037161;
        Mon, 6 Mar 2023 05:09:49 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1678100989;
        bh=awe5/4UFQM2mc38YBfMHrLSWOB6NvU+i33a/Hadh9gQ=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=XZTF4hC+we5w3gB8MBCYy0O3PNzJZ+XE0I9bDEPH5qACqf2PqWOy67uanLwRGUoQR
         MPDtp+sda9xiqTOuFI8aop2fKZhfRWk/v49O32FaImjkcIY/hDXd8fXFriyv0zu5Fx
         TLAAuXOXGdy3U15Nh6pV6T06IjpfzwinkyjYTNp8=
Received: from DFLE114.ent.ti.com (dfle114.ent.ti.com [10.64.6.35])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 326B9n2k059200
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 6 Mar 2023 05:09:49 -0600
Received: from DFLE105.ent.ti.com (10.64.6.26) by DFLE114.ent.ti.com
 (10.64.6.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Mon, 6
 Mar 2023 05:09:48 -0600
Received: from lelv0326.itg.ti.com (10.180.67.84) by DFLE105.ent.ti.com
 (10.64.6.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Mon, 6 Mar 2023 05:09:48 -0600
Received: from fllv0122.itg.ti.com (fllv0122.itg.ti.com [10.247.120.72])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 326B9mA9010692;
        Mon, 6 Mar 2023 05:09:48 -0600
Received: from localhost (a0501179-pc.dhcp.ti.com [10.24.69.114])
        by fllv0122.itg.ti.com (8.14.7/8.14.7) with ESMTP id 326B9lge015728;
        Mon, 6 Mar 2023 05:09:48 -0600
From:   MD Danish Anwar <danishanwar@ti.com>
To:     "Andrew F. Davis" <afd@ti.com>, Suman Anna <s-anna@ti.com>,
        Roger Quadros <rogerq@kernel.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Tero Kristo <t-kristo@ti.com>,
        MD Danish Anwar <danishanwar@ti.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Bjorn Andersson <andersson@kernel.org>,
        "Santosh Shilimkar" <ssantosh@kernel.org>,
        Nishanth Menon <nm@ti.com>
CC:     <linux-remoteproc@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <srk@ti.com>, <devicetree@vger.kernel.org>,
        <netdev@vger.kernel.org>
Subject: [PATCH v3 5/6] soc: ti: pruss: Add helper function to enable OCP master ports
Date:   Mon, 6 Mar 2023 16:39:33 +0530
Message-ID: <20230306110934.2736465-6-danishanwar@ti.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230306110934.2736465-1-danishanwar@ti.com>
References: <20230306110934.2736465-1-danishanwar@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Suman Anna <s-anna@ti.com>

The PRU-ICSS subsystem on OMAP-architecture based SoCS (AM33xx, AM437x
and AM57xx SoCs) has a control bit STANDBY_INIT in the PRUSS_CFG register
to initiate a Standby sequence (when set) and trigger a MStandby request
to the SoC's PRCM module. This same bit is also used to enable the OCP
master ports (when cleared). The clearing of the STANDBY_INIT bit requires
an acknowledgment from PRCM and is done through the monitoring of the
PRUSS_SYSCFG.SUB_MWAIT bit.

Add a helper function pruss_cfg_ocp_master_ports() to allow the PRU
client drivers to control this bit and enable or disable the firmware
running on PRU cores access to any peripherals or memory to achieve
desired functionality. The access is disabled by default on power-up
and on any suspend (context is not maintained).

Signed-off-by: Suman Anna <s-anna@ti.com>
Co-developed-by: Grzegorz Jaszczyk <grzegorz.jaszczyk@linaro.org>
Signed-off-by: Grzegorz Jaszczyk <grzegorz.jaszczyk@linaro.org>
Signed-off-by: Puranjay Mohan <p-mohan@ti.com>
---
 drivers/soc/ti/pruss.c           | 81 +++++++++++++++++++++++++++++++-
 include/linux/remoteproc/pruss.h |  6 +++
 2 files changed, 85 insertions(+), 2 deletions(-)

diff --git a/drivers/soc/ti/pruss.c b/drivers/soc/ti/pruss.c
index 537a3910ffd8..dc3abda0b8c2 100644
--- a/drivers/soc/ti/pruss.c
+++ b/drivers/soc/ti/pruss.c
@@ -22,14 +22,19 @@
 #include <linux/remoteproc.h>
 #include <linux/slab.h>
 
+#define SYSCFG_STANDBY_INIT	BIT(4)
+#define SYSCFG_SUB_MWAIT_READY	BIT(5)
+
 /**
  * struct pruss_private_data - PRUSS driver private data
  * @has_no_sharedram: flag to indicate the absence of PRUSS Shared Data RAM
  * @has_core_mux_clock: flag to indicate the presence of PRUSS core clock
+ * @has_ocp_syscfg: flag to indicate if OCP SYSCFG is present
  */
 struct pruss_private_data {
 	bool has_no_sharedram;
 	bool has_core_mux_clock;
+	bool has_ocp_syscfg;
 };
 
 /**
@@ -205,6 +210,72 @@ int pruss_cfg_update(struct pruss *pruss, unsigned int reg,
 }
 EXPORT_SYMBOL_GPL(pruss_cfg_update);
 
+/**
+ * pruss_cfg_ocp_master_ports() - configure PRUSS OCP master ports
+ * @pruss: the pruss instance handle
+ * @enable: set to true for enabling or false for disabling the OCP master ports
+ *
+ * This function programs the PRUSS_SYSCFG.STANDBY_INIT bit either to enable or
+ * disable the OCP master ports (applicable only on SoCs using OCP interconnect
+ * like the OMAP family). Clearing the bit achieves dual functionalities - one
+ * is to deassert the MStandby signal to the device PRCM, and the other is to
+ * enable OCP master ports to allow accesses outside of the PRU-ICSS. The
+ * function has to wait for the PRCM to acknowledge through the monitoring of
+ * the PRUSS_SYSCFG.SUB_MWAIT bit when enabling master ports. Setting the bit
+ * disables the master access, and also signals the PRCM that the PRUSS is ready
+ * for Standby.
+ *
+ * Return: 0 on success, or an error code otherwise. ETIMEDOUT is returned
+ * when the ready-state fails.
+ */
+int pruss_cfg_ocp_master_ports(struct pruss *pruss, bool enable)
+{
+	int ret;
+	u32 syscfg_val, i;
+	const struct pruss_private_data *data;
+
+	if (IS_ERR_OR_NULL(pruss))
+		return -EINVAL;
+
+	data = of_device_get_match_data(pruss->dev);
+
+	/* nothing to do on non OMAP-SoCs */
+	if (!data || !data->has_ocp_syscfg)
+		return 0;
+
+	/* assert the MStandby signal during disable path */
+	if (!enable)
+		return pruss_cfg_update(pruss, PRUSS_CFG_SYSCFG,
+					SYSCFG_STANDBY_INIT,
+					SYSCFG_STANDBY_INIT);
+
+	/* enable the OCP master ports and disable MStandby */
+	ret = pruss_cfg_update(pruss, PRUSS_CFG_SYSCFG, SYSCFG_STANDBY_INIT, 0);
+	if (ret)
+		return ret;
+
+	/* wait till we are ready for transactions - delay is arbitrary */
+	for (i = 0; i < 10; i++) {
+		ret = pruss_cfg_read(pruss, PRUSS_CFG_SYSCFG, &syscfg_val);
+		if (ret)
+			goto disable;
+
+		if (!(syscfg_val & SYSCFG_SUB_MWAIT_READY))
+			return 0;
+
+		udelay(5);
+	}
+
+	dev_err(pruss->dev, "timeout waiting for SUB_MWAIT_READY\n");
+	ret = -ETIMEDOUT;
+
+disable:
+	pruss_cfg_update(pruss, PRUSS_CFG_SYSCFG, SYSCFG_STANDBY_INIT,
+			 SYSCFG_STANDBY_INIT);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(pruss_cfg_ocp_master_ports);
+
 static void pruss_of_free_clk_provider(void *data)
 {
 	struct device_node *clk_mux_np = data;
@@ -495,10 +566,16 @@ static int pruss_remove(struct platform_device *pdev)
 /* instance-specific driver private data */
 static const struct pruss_private_data am437x_pruss1_data = {
 	.has_no_sharedram = false,
+	.has_ocp_syscfg = true,
 };
 
 static const struct pruss_private_data am437x_pruss0_data = {
 	.has_no_sharedram = true,
+	.has_ocp_syscfg = false,
+};
+
+static const struct pruss_private_data am33xx_am57xx_data = {
+	.has_ocp_syscfg = true,
 };
 
 static const struct pruss_private_data am65x_j721e_pruss_data = {
@@ -506,10 +583,10 @@ static const struct pruss_private_data am65x_j721e_pruss_data = {
 };
 
 static const struct of_device_id pruss_of_match[] = {
-	{ .compatible = "ti,am3356-pruss" },
+	{ .compatible = "ti,am3356-pruss", .data = &am33xx_am57xx_data },
 	{ .compatible = "ti,am4376-pruss0", .data = &am437x_pruss0_data, },
 	{ .compatible = "ti,am4376-pruss1", .data = &am437x_pruss1_data, },
-	{ .compatible = "ti,am5728-pruss" },
+	{ .compatible = "ti,am5728-pruss", .data = &am33xx_am57xx_data },
 	{ .compatible = "ti,k2g-pruss" },
 	{ .compatible = "ti,am654-icssg", .data = &am65x_j721e_pruss_data, },
 	{ .compatible = "ti,j721e-icssg", .data = &am65x_j721e_pruss_data, },
diff --git a/include/linux/remoteproc/pruss.h b/include/linux/remoteproc/pruss.h
index 7952f250301a..8cb99d3cad0d 100644
--- a/include/linux/remoteproc/pruss.h
+++ b/include/linux/remoteproc/pruss.h
@@ -168,6 +168,7 @@ int pruss_release_mem_region(struct pruss *pruss,
 int pruss_cfg_read(struct pruss *pruss, unsigned int reg, unsigned int *val);
 int pruss_cfg_update(struct pruss *pruss, unsigned int reg,
 		     unsigned int mask, unsigned int val);
+int pruss_cfg_ocp_master_ports(struct pruss *pruss, bool enable);
 
 #else
 
@@ -203,6 +204,11 @@ static inline int pruss_cfg_update(struct pruss *pruss, unsigned int reg,
 	return -EOPNOTSUPP;
 }
 
+static inline int pruss_cfg_ocp_master_ports(struct pruss *pruss, bool enable)
+{
+	return -EOPNOTSUPP;
+}
+
 #endif /* CONFIG_TI_PRUSS */
 
 #if IS_ENABLED(CONFIG_PRU_REMOTEPROC)
-- 
2.25.1

