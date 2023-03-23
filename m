Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 475206C5FB2
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 07:26:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbjCWG0M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 02:26:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230463AbjCWGZy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 02:25:54 -0400
Received: from lelv0142.ext.ti.com (lelv0142.ext.ti.com [198.47.23.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE2D62F077;
        Wed, 22 Mar 2023 23:25:27 -0700 (PDT)
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 32N6PBNU129959;
        Thu, 23 Mar 2023 01:25:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1679552711;
        bh=nrfoCKK8RkKsr2VsSgAu+fvT7nKaHhII3hpyj37/D8A=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=j3jsvoPw6F5F+pPQ8k6vqI5b967jG8zJIHmQ6jCs4kA0+CEDUzyl6PeRIm5ievWGX
         MTOG4BZXN4NZD2bu5ZF6WXXRIGVOMcvLJKYT2WBoQEuK7lyEE6PaFdHusQ3dxTKxbK
         A/+ll2uTmGmT89pUa5CYW0F6yZZFPut2fCtgECtk=
Received: from DFLE107.ent.ti.com (dfle107.ent.ti.com [10.64.6.28])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 32N6PBIJ030591
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 23 Mar 2023 01:25:11 -0500
Received: from DFLE100.ent.ti.com (10.64.6.21) by DFLE107.ent.ti.com
 (10.64.6.28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Thu, 23
 Mar 2023 01:25:11 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE100.ent.ti.com
 (10.64.6.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Thu, 23 Mar 2023 01:25:10 -0500
Received: from lelv0854.itg.ti.com (lelv0854.itg.ti.com [10.181.64.140])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 32N6P6Gr070181;
        Thu, 23 Mar 2023 01:25:11 -0500
Received: from localhost (a0501179-pc.dhcp.ti.com [10.24.69.114])
        by lelv0854.itg.ti.com (8.14.7/8.14.7) with ESMTP id 32N6P4Ph010597;
        Thu, 23 Mar 2023 01:25:05 -0500
From:   MD Danish Anwar <danishanwar@ti.com>
To:     "Andrew F. Davis" <afd@ti.com>, Suman Anna <s-anna@ti.com>,
        Roger Quadros <rogerq@kernel.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Tero Kristo <kristo@kernel.org>,
        MD Danish Anwar <danishanwar@ti.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Santosh Shilimkar <ssantosh@kernel.org>,
        Nishanth Menon <nm@ti.com>
CC:     <linux-remoteproc@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <srk@ti.com>, <devicetree@vger.kernel.org>,
        <netdev@vger.kernel.org>
Subject: [PATCH v5 5/5] soc: ti: pruss: Add helper functions to get/set PRUSS_CFG_GPMUX
Date:   Thu, 23 Mar 2023 11:54:51 +0530
Message-ID: <20230323062451.2925996-6-danishanwar@ti.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230323062451.2925996-1-danishanwar@ti.com>
References: <20230323062451.2925996-1-danishanwar@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tero Kristo <t-kristo@ti.com>

Add two new helper functions pruss_cfg_get_gpmux() & pruss_cfg_set_gpmux()
to get and set the GP MUX mode for programming the PRUSS internal wrapper
mux functionality as needed by usecases.

Co-developed-by: Suman Anna <s-anna@ti.com>
Signed-off-by: Suman Anna <s-anna@ti.com>
Signed-off-by: Tero Kristo <t-kristo@ti.com>
Co-developed-by: Grzegorz Jaszczyk <grzegorz.jaszczyk@linaro.org>
Signed-off-by: Grzegorz Jaszczyk <grzegorz.jaszczyk@linaro.org>
Signed-off-by: Puranjay Mohan <p-mohan@ti.com>
Signed-off-by: MD Danish Anwar <danishanwar@ti.com>
Reviewed-by: Roger Quadros <rogerq@kernel.org>
---
 drivers/soc/ti/pruss.c           | 44 ++++++++++++++++++++++++++++++++
 include/linux/remoteproc/pruss.h | 30 ++++++++++++++++++++++
 2 files changed, 74 insertions(+)

diff --git a/drivers/soc/ti/pruss.c b/drivers/soc/ti/pruss.c
index ac415442e85b..3aa3c38c6c79 100644
--- a/drivers/soc/ti/pruss.c
+++ b/drivers/soc/ti/pruss.c
@@ -239,6 +239,50 @@ int pruss_cfg_xfr_enable(struct pruss *pruss, enum pru_type pru_type,
 }
 EXPORT_SYMBOL_GPL(pruss_cfg_xfr_enable);
 
+/**
+ * pruss_cfg_get_gpmux() - get the current GPMUX value for a PRU device
+ * @pruss: pruss instance
+ * @pru_id: PRU identifier (0-1)
+ * @mux: pointer to store the current mux value into
+ *
+ * Return: 0 on success, or an error code otherwise
+ */
+int pruss_cfg_get_gpmux(struct pruss *pruss, enum pruss_pru_id pru_id, u8 *mux)
+{
+	int ret = 0;
+	u32 val;
+
+	if (pru_id < 0 || pru_id >= PRUSS_NUM_PRUS)
+		return -EINVAL;
+
+	ret = pruss_cfg_read(pruss, PRUSS_CFG_GPCFG(pru_id), &val);
+	if (!ret)
+		*mux = (u8)((val & PRUSS_GPCFG_PRU_MUX_SEL_MASK) >>
+			    PRUSS_GPCFG_PRU_MUX_SEL_SHIFT);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(pruss_cfg_get_gpmux);
+
+/**
+ * pruss_cfg_set_gpmux() - set the GPMUX value for a PRU device
+ * @pruss: pruss instance
+ * @pru_id: PRU identifier (0-1)
+ * @mux: new mux value for PRU
+ *
+ * Return: 0 on success, or an error code otherwise
+ */
+int pruss_cfg_set_gpmux(struct pruss *pruss, enum pruss_pru_id pru_id, u8 mux)
+{
+	if (mux >= PRUSS_GP_MUX_SEL_MAX ||
+	    pru_id < 0 || pru_id >= PRUSS_NUM_PRUS)
+		return -EINVAL;
+
+	return pruss_cfg_update(pruss, PRUSS_CFG_GPCFG(pru_id),
+				PRUSS_GPCFG_PRU_MUX_SEL_MASK,
+				(u32)mux << PRUSS_GPCFG_PRU_MUX_SEL_SHIFT);
+}
+EXPORT_SYMBOL_GPL(pruss_cfg_set_gpmux);
+
 static void pruss_of_free_clk_provider(void *data)
 {
 	struct device_node *clk_mux_np = data;
diff --git a/include/linux/remoteproc/pruss.h b/include/linux/remoteproc/pruss.h
index bb001f712980..42f1586c62ac 100644
--- a/include/linux/remoteproc/pruss.h
+++ b/include/linux/remoteproc/pruss.h
@@ -16,6 +16,24 @@
 
 #define PRU_RPROC_DRVNAME "pru-rproc"
 
+/*
+ * enum pruss_gp_mux_sel - PRUSS GPI/O Mux modes for the
+ * PRUSS_GPCFG0/1 registers
+ *
+ * NOTE: The below defines are the most common values, but there
+ * are some exceptions like on 66AK2G, where the RESERVED and MII2
+ * values are interchanged. Also, this bit-field does not exist on
+ * AM335x SoCs
+ */
+enum pruss_gp_mux_sel {
+	PRUSS_GP_MUX_SEL_GP = 0,
+	PRUSS_GP_MUX_SEL_ENDAT,
+	PRUSS_GP_MUX_SEL_RESERVED,
+	PRUSS_GP_MUX_SEL_SD,
+	PRUSS_GP_MUX_SEL_MII2,
+	PRUSS_GP_MUX_SEL_MAX,
+};
+
 /*
  * enum pruss_gpi_mode - PRUSS GPI configuration modes, used
  *			 to program the PRUSS_GPCFG0/1 registers
@@ -110,6 +128,8 @@ int pruss_cfg_gpimode(struct pruss *pruss, enum pruss_pru_id pru_id,
 int pruss_cfg_miirt_enable(struct pruss *pruss, bool enable);
 int pruss_cfg_xfr_enable(struct pruss *pruss, enum pru_type pru_type,
 			 bool enable);
+int pruss_cfg_get_gpmux(struct pruss *pruss, enum pruss_pru_id pru_id, u8 *mux);
+int pruss_cfg_set_gpmux(struct pruss *pruss, enum pruss_pru_id pru_id, u8 mux);
 
 #else
 
@@ -152,6 +172,16 @@ static inline int pruss_cfg_xfr_enable(struct pruss *pruss,
 	return ERR_PTR(-EOPNOTSUPP);
 }
 
+static inline int pruss_cfg_get_gpmux(struct pruss *pruss, enum pruss_pru_id pru_id, u8 *mux)
+{
+	return ERR_PTR(-EOPNOTSUPP);
+}
+
+static inline int pruss_cfg_set_gpmux(struct pruss *pruss, enum pruss_pru_id pru_id, u8 mux)
+{
+	return ERR_PTR(-EOPNOTSUPP);
+}
+
 #endif /* CONFIG_TI_PRUSS */
 
 #if IS_ENABLED(CONFIG_PRU_REMOTEPROC)
-- 
2.25.1

