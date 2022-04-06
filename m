Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C346F4F62D6
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 17:18:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235766AbiDFPSa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 11:18:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236174AbiDFPRt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 11:17:49 -0400
Received: from fllv0016.ext.ti.com (fllv0016.ext.ti.com [198.47.19.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 826F0646645;
        Wed,  6 Apr 2022 05:18:20 -0700 (PDT)
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 2369iP48031124;
        Wed, 6 Apr 2022 04:44:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1649238266;
        bh=FttItEc/bCeQMaeGDWpIEf0Eh6tDrC3LzX+ZGvAr92A=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=IphJX97XCkJQQ8pgcnTn5kgjmSOxXfQQghEEa9HfRDhgxvWwX+g0eQFRd8UbHq9hW
         eduBdi1/3Avd3I9vkyxf2zAu+tj9G5YUd+PwUqgtWByX/gbBqsGGrrs/5QsGCQ4ol1
         YQSIfyP0MS++QpCA2e8mH9iVjgMbh3+wETgIqkUQ=
Received: from DFLE108.ent.ti.com (dfle108.ent.ti.com [10.64.6.29])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 2369iPcb030658
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 6 Apr 2022 04:44:25 -0500
Received: from DFLE106.ent.ti.com (10.64.6.27) by DFLE108.ent.ti.com
 (10.64.6.29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Wed, 6
 Apr 2022 04:44:25 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE106.ent.ti.com
 (10.64.6.27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14 via
 Frontend Transport; Wed, 6 Apr 2022 04:44:25 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 2369iNwk089753;
        Wed, 6 Apr 2022 04:44:24 -0500
From:   Puranjay Mohan <p-mohan@ti.com>
To:     <linux-kernel@vger.kernel.org>
CC:     <bjorn.andersson@linaro.org>, <mathieu.poirier@linaro.org>,
        <krzysztof.kozlowski+dt@linaro.org>,
        <linux-remoteproc@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <nm@ti.com>, <ssantosh@kernel.org>, <s-anna@ti.com>,
        <p-mohan@ti.com>, <linux-arm-kernel@lists.infradead.org>,
        <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <vigneshr@ti.com>, <kishon@ti.com>
Subject: [RFC 09/13] soc: ti: pruss: Add helper functions to set GPI mode, MII_RT_event and XFR
Date:   Wed, 6 Apr 2022 15:13:54 +0530
Message-ID: <20220406094358.7895-10-p-mohan@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220406094358.7895-1-p-mohan@ti.com>
References: <20220406094358.7895-1-p-mohan@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Suman Anna <s-anna@ti.com>

The PRUSS CFG module is represented as a syscon node and is currently
managed by the PRUSS platform driver. Add easy accessor functions to set
GPI mode, MII_RT event enable/disable and XFR (XIN XOUT) enable/disable
to enable the PRUSS Ethernet usecase. These functions reuse the generic
pruss_cfg_update() API function.

Signed-off-by: Suman Anna <s-anna@ti.com>
Co-developed-by: Grzegorz Jaszczyk <grzegorz.jaszczyk@linaro.org>
Signed-off-by: Grzegorz Jaszczyk <grzegorz.jaszczyk@linaro.org>
Signed-off-by: Puranjay Mohan <p-mohan@ti.com>
---
 include/linux/pruss.h | 55 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 55 insertions(+)

diff --git a/include/linux/pruss.h b/include/linux/pruss.h
index eb2f974eef9c..84e95eb884e9 100644
--- a/include/linux/pruss.h
+++ b/include/linux/pruss.h
@@ -235,4 +235,59 @@ static inline bool is_pru_rproc(struct device *dev)
 	return true;
 }
 
+/**
+ * pruss_cfg_gpimode() - set the GPI mode of the PRU
+ * @pruss: the pruss instance handle
+ * @pru_id: id of the PRU core within the PRUSS
+ * @mode: GPI mode to set
+ *
+ * Sets the GPI mode for a given PRU by programming the
+ * corresponding PRUSS_CFG_GPCFGx register
+ *
+ * Return: 0 on success, or an error code otherwise
+ */
+static inline int pruss_cfg_gpimode(struct pruss *pruss,
+				    enum pruss_pru_id pru_id,
+				    enum pruss_gpi_mode mode)
+{
+	if (pru_id < 0 || pru_id >= PRUSS_NUM_PRUS)
+		return -EINVAL;
+
+	return pruss_cfg_update(pruss, PRUSS_CFG_GPCFG(pru_id),
+				PRUSS_GPCFG_PRU_GPI_MODE_MASK,
+				mode << PRUSS_GPCFG_PRU_GPI_MODE_SHIFT);
+}
+
+/**
+ * pruss_cfg_miirt_enable() - Enable/disable MII RT Events
+ * @pruss: the pruss instance
+ * @enable: enable/disable
+ *
+ * Enable/disable the MII RT Events for the PRUSS.
+ *
+ * Return: 0 on success, or an error code otherwise
+ */
+static inline int pruss_cfg_miirt_enable(struct pruss *pruss, bool enable)
+{
+	u32 set = enable ? PRUSS_MII_RT_EVENT_EN : 0;
+
+	return pruss_cfg_update(pruss, PRUSS_CFG_MII_RT,
+				PRUSS_MII_RT_EVENT_EN, set);
+}
+
+/**
+ * pruss_cfg_xfr_enable() - Enable/disable XIN XOUT shift functionality
+ * @pruss: the pruss instance
+ * @enable: enable/disable
+ *
+ * Return: 0 on success, or an error code otherwise
+ */
+static inline int pruss_cfg_xfr_enable(struct pruss *pruss, bool enable)
+{
+	u32 set = enable ? PRUSS_SPP_XFER_SHIFT_EN : 0;
+
+	return pruss_cfg_update(pruss, PRUSS_CFG_SPP,
+				PRUSS_SPP_XFER_SHIFT_EN, set);
+}
+
 #endif /* __LINUX_PRUSS_H */
-- 
2.17.1

