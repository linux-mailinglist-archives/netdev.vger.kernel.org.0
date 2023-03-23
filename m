Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22B826C5FA3
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 07:25:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230233AbjCWGZN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 02:25:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230101AbjCWGZJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 02:25:09 -0400
Received: from lelv0143.ext.ti.com (lelv0143.ext.ti.com [198.47.23.248])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2A592A16B;
        Wed, 22 Mar 2023 23:25:06 -0700 (PDT)
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 32N6OuL2051489;
        Thu, 23 Mar 2023 01:24:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1679552697;
        bh=xE7d4K0rf6Th/xekias/+P1Z+5hBsGTg5MqTnAOKOGU=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=QVux5k4f8X6LnxszEWkTlTvVl/ZNc+bFqQZuhTp0jlu7XUP28aUfhGMqFszPSQRwm
         6DHpNXIkQ9Z/KFX7Sa80PPOAEiFCSSu6vSV25mm0Plea/Zlni9z9bcgkWOsGCbAerv
         s7jZsW10pbqEdsReg1wIQIv392i1BWCuFjy89iwg=
Received: from DFLE112.ent.ti.com (dfle112.ent.ti.com [10.64.6.33])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 32N6Ou3h110143
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 23 Mar 2023 01:24:56 -0500
Received: from DFLE106.ent.ti.com (10.64.6.27) by DFLE112.ent.ti.com
 (10.64.6.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Thu, 23
 Mar 2023 01:24:56 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE106.ent.ti.com
 (10.64.6.27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Thu, 23 Mar 2023 01:24:56 -0500
Received: from lelv0854.itg.ti.com (lelv0854.itg.ti.com [10.181.64.140])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 32N6OumP092564;
        Thu, 23 Mar 2023 01:24:56 -0500
Received: from localhost (a0501179-pc.dhcp.ti.com [10.24.69.114])
        by lelv0854.itg.ti.com (8.14.7/8.14.7) with ESMTP id 32N6Ot4M010555;
        Thu, 23 Mar 2023 01:24:56 -0500
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
Subject: [PATCH v5 1/5] soc: ti: pruss: Add pruss_get()/put() API
Date:   Thu, 23 Mar 2023 11:54:47 +0530
Message-ID: <20230323062451.2925996-2-danishanwar@ti.com>
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
Reviewed-by: Roger Quadros <rogerq@kernel.org>
---
 drivers/remoteproc/pru_rproc.c                |  2 +-
 drivers/soc/ti/pruss.c                        | 60 ++++++++++++++++++-
 .../{pruss_driver.h => pruss_internal.h}      |  7 ++-
 include/linux/remoteproc/pruss.h              | 19 ++++++
 4 files changed, 83 insertions(+), 5 deletions(-)
 rename include/linux/{pruss_driver.h => pruss_internal.h} (90%)

diff --git a/drivers/remoteproc/pru_rproc.c b/drivers/remoteproc/pru_rproc.c
index b76db7fa693d..4ddd5854d56e 100644
--- a/drivers/remoteproc/pru_rproc.c
+++ b/drivers/remoteproc/pru_rproc.c
@@ -19,7 +19,7 @@
 #include <linux/of_device.h>
 #include <linux/of_irq.h>
 #include <linux/remoteproc/pruss.h>
-#include <linux/pruss_driver.h>
+#include <linux/pruss_internal.h>
 #include <linux/remoteproc.h>
 
 #include "remoteproc_internal.h"
diff --git a/drivers/soc/ti/pruss.c b/drivers/soc/ti/pruss.c
index 6882c86b3ce5..6c2bb02a521d 100644
--- a/drivers/soc/ti/pruss.c
+++ b/drivers/soc/ti/pruss.c
@@ -6,6 +6,7 @@
  * Author(s):
  *	Suman Anna <s-anna@ti.com>
  *	Andrew F. Davis <afd@ti.com>
+ *	Tero Kristo <t-kristo@ti.com>
  */
 
 #include <linux/clk-provider.h>
@@ -16,8 +17,9 @@
 #include <linux/of_address.h>
 #include <linux/of_device.h>
 #include <linux/pm_runtime.h>
-#include <linux/pruss_driver.h>
+#include <linux/pruss_internal.h>
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
diff --git a/include/linux/pruss_driver.h b/include/linux/pruss_internal.h
similarity index 90%
rename from include/linux/pruss_driver.h
rename to include/linux/pruss_internal.h
index ecfded30ed05..8f91cb164054 100644
--- a/include/linux/pruss_driver.h
+++ b/include/linux/pruss_internal.h
@@ -6,9 +6,10 @@
  *	Suman Anna <s-anna@ti.com>
  */
 
-#ifndef _PRUSS_DRIVER_H_
-#define _PRUSS_DRIVER_H_
+#ifndef _PRUSS_INTERNAL_H_
+#define _PRUSS_INTERNAL_H_
 
+#include <linux/remoteproc/pruss.h>
 #include <linux/types.h>
 
 /*
@@ -51,4 +52,4 @@ struct pruss {
 	struct clk *iep_clk_mux;
 };
 
-#endif	/* _PRUSS_DRIVER_H_ */
+#endif	/* _PRUSS_INTERNAL_H_ */
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

