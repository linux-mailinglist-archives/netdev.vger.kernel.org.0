Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 433516ABDC7
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 12:10:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230236AbjCFLKD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 06:10:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230093AbjCFLJz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 06:09:55 -0500
Received: from fllv0016.ext.ti.com (fllv0016.ext.ti.com [198.47.19.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEB5B11170;
        Mon,  6 Mar 2023 03:09:53 -0800 (PST)
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 326B9dHa096295;
        Mon, 6 Mar 2023 05:09:39 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1678100979;
        bh=+z/n1p4AQ5+RCdeqgNgdJjvdQuqkWKD1BcAtisYLHls=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=FVBRgfqa6lMJOmLVuSsnYnzY5MDBrp8esn8K0LHHm4N7dEcHSII/8MiKMTUjjthq2
         tmmJtX+shr24O/Fi6o5qK1Jr92OpbZ0rqmD2ELJciNRjFRFb60XsVi/ZE0PNUHi7O/
         LEXL+GUyrKoVg4K247YDifRv7AmsqXyg9tXONofo=
Received: from DFLE114.ent.ti.com (dfle114.ent.ti.com [10.64.6.35])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 326B9d0o030173
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 6 Mar 2023 05:09:39 -0600
Received: from DFLE105.ent.ti.com (10.64.6.26) by DFLE114.ent.ti.com
 (10.64.6.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Mon, 6
 Mar 2023 05:09:39 -0600
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE105.ent.ti.com
 (10.64.6.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Mon, 6 Mar 2023 05:09:39 -0600
Received: from lelv0854.itg.ti.com (lelv0854.itg.ti.com [10.181.64.140])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 326B9dUe090165;
        Mon, 6 Mar 2023 05:09:39 -0600
Received: from localhost (a0501179-pc.dhcp.ti.com [10.24.69.114])
        by lelv0854.itg.ti.com (8.14.7/8.14.7) with ESMTP id 326B9bCu029571;
        Mon, 6 Mar 2023 05:09:38 -0600
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
Subject: [PATCH v3 1/6] soc: ti: pruss: Add pruss_get()/put() API
Date:   Mon, 6 Mar 2023 16:39:29 +0530
Message-ID: <20230306110934.2736465-2-danishanwar@ti.com>
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

From: Tero Kristo <t-kristo@ti.com>

Add two new get and put API, pruss_get() and pruss_put() to the
PRUSS platform driver to allow client drivers to request a handle
to a PRUSS device. This handle will be used by client drivers to
request various operations of the PRUSS platform driver through
additional API that will be added in the following patches.

The pruss_get() function returns the pruss handle corresponding
to a PRUSS device referenced by a PRU remoteproc instance. The
pruss_put() is the complimentary function to pruss_get().

Co-developed-by: Suman Anna <s-anna@ti.com>
Signed-off-by: Suman Anna <s-anna@ti.com>
Signed-off-by: Tero Kristo <t-kristo@ti.com>
Co-developed-by: Grzegorz Jaszczyk <grzegorz.jaszczyk@linaro.org>
Signed-off-by: Grzegorz Jaszczyk <grzegorz.jaszczyk@linaro.org>
Signed-off-by: Puranjay Mohan <p-mohan@ti.com>
Signed-off-by: MD Danish Anwar <danishanwar@ti.com>
---
 drivers/soc/ti/pruss.c           | 58 ++++++++++++++++++++++++++++++++
 include/linux/pruss_driver.h     |  1 +
 include/linux/remoteproc/pruss.h | 19 +++++++++++
 3 files changed, 78 insertions(+)

diff --git a/drivers/soc/ti/pruss.c b/drivers/soc/ti/pruss.c
index 6882c86b3ce5..a169aa1ed044 100644
--- a/drivers/soc/ti/pruss.c
+++ b/drivers/soc/ti/pruss.c
@@ -6,6 +6,7 @@
  * Author(s):
  *	Suman Anna <s-anna@ti.com>
  *	Andrew F. Davis <afd@ti.com>
+ *	Tero Kristo <t-kristo@ti.com>
  */
 
 #include <linux/clk-provider.h>
@@ -18,6 +19,7 @@
 #include <linux/pm_runtime.h>
 #include <linux/pruss_driver.h>
 #include <linux/regmap.h>
+#include <linux/remoteproc.h>
 #include <linux/slab.h>
 
 /**
@@ -30,6 +32,62 @@ struct pruss_private_data {
 	bool has_core_mux_clock;
 };
 
+/**
+ * pruss_get() - get the pruss for a given PRU remoteproc
+ * @rproc: remoteproc handle of a PRU instance
+ *
+ * Finds the parent pruss device for a PRU given the @rproc handle of the
+ * PRU remote processor. This function increments the pruss device's refcount,
+ * so always use pruss_put() to decrement it back once pruss isn't needed
+ * anymore.
+ *
+ * Return: pruss handle on success, and an ERR_PTR on failure using one
+ * of the following error values
+ *    -EINVAL if invalid parameter
+ *    -ENODEV if PRU device or PRUSS device is not found
+ */
+struct pruss *pruss_get(struct rproc *rproc)
+{
+	struct pruss *pruss;
+	struct device *dev;
+	struct platform_device *ppdev;
+
+	if (IS_ERR_OR_NULL(rproc))
+		return ERR_PTR(-EINVAL);
+
+	dev = &rproc->dev;
+
+	/* make sure it is PRU rproc */
+	if (!dev->parent || !is_pru_rproc(dev->parent))
+		return ERR_PTR(-ENODEV);
+
+	ppdev = to_platform_device(dev->parent->parent);
+	pruss = platform_get_drvdata(ppdev);
+	if (!pruss)
+		return ERR_PTR(-ENODEV);
+
+	get_device(pruss->dev);
+
+	return pruss;
+}
+EXPORT_SYMBOL_GPL(pruss_get);
+
+/**
+ * pruss_put() - decrement pruss device's usecount
+ * @pruss: pruss handle
+ *
+ * Complimentary function for pruss_get(). Needs to be called
+ * after the PRUSS is used, and only if the pruss_get() succeeds.
+ */
+void pruss_put(struct pruss *pruss)
+{
+	if (IS_ERR_OR_NULL(pruss))
+		return;
+
+	put_device(pruss->dev);
+}
+EXPORT_SYMBOL_GPL(pruss_put);
+
 static void pruss_of_free_clk_provider(void *data)
 {
 	struct device_node *clk_mux_np = data;
diff --git a/include/linux/pruss_driver.h b/include/linux/pruss_driver.h
index ecfded30ed05..86242fb5a64a 100644
--- a/include/linux/pruss_driver.h
+++ b/include/linux/pruss_driver.h
@@ -9,6 +9,7 @@
 #ifndef _PRUSS_DRIVER_H_
 #define _PRUSS_DRIVER_H_
 
+#include <linux/remoteproc/pruss.h>
 #include <linux/types.h>
 
 /*
diff --git a/include/linux/remoteproc/pruss.h b/include/linux/remoteproc/pruss.h
index 039b50d58df2..93a98cac7829 100644
--- a/include/linux/remoteproc/pruss.h
+++ b/include/linux/remoteproc/pruss.h
@@ -4,12 +4,14 @@
  *
  * Copyright (C) 2015-2022 Texas Instruments Incorporated - http://www.ti.com
  *	Suman Anna <s-anna@ti.com>
+ *	Tero Kristo <t-kristo@ti.com>
  */
 
 #ifndef __LINUX_PRUSS_H
 #define __LINUX_PRUSS_H
 
 #include <linux/device.h>
+#include <linux/err.h>
 #include <linux/types.h>
 
 #define PRU_RPROC_DRVNAME "pru-rproc"
@@ -44,6 +46,23 @@ enum pru_ctable_idx {
 
 struct device_node;
 struct rproc;
+struct pruss;
+
+#if IS_ENABLED(CONFIG_TI_PRUSS)
+
+struct pruss *pruss_get(struct rproc *rproc);
+void pruss_put(struct pruss *pruss);
+
+#else
+
+static inline struct pruss *pruss_get(struct rproc *rproc)
+{
+	return ERR_PTR(-EOPNOTSUPP);
+}
+
+static inline void pruss_put(struct pruss *pruss) { }
+
+#endif /* CONFIG_TI_PRUSS */
 
 #if IS_ENABLED(CONFIG_PRU_REMOTEPROC)
 
-- 
2.25.1

