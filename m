Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B5266E1B4A
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 06:56:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbjDNE4d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 00:56:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229815AbjDNE4Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 00:56:25 -0400
Received: from fllv0015.ext.ti.com (fllv0015.ext.ti.com [198.47.19.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFF486A74;
        Thu, 13 Apr 2023 21:56:11 -0700 (PDT)
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 33E4u4hl074662;
        Thu, 13 Apr 2023 23:56:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1681448164;
        bh=8KKbxB55hALm8ZgFIikpy1VFLRiwS+xilXlkMGdOVMs=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=CwVcqkQIiSTNMn1N2w0foqkObPitoTtjyqS/yzkICEB4FjXeLd/pXNoTj8vYQbs7n
         no2x4NUIq27K4Y7F1URRjTAZEA10OvoehyCCgRNYHyTVMh62/mnJrnKczridn0IePi
         RZ7YsPSKn2MazCYLwOy0lLVXMjLFLx3GLUo/20pM=
Received: from DLEE115.ent.ti.com (dlee115.ent.ti.com [157.170.170.26])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 33E4u4Up044295
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 13 Apr 2023 23:56:04 -0500
Received: from DLEE113.ent.ti.com (157.170.170.24) by DLEE115.ent.ti.com
 (157.170.170.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Thu, 13
 Apr 2023 23:56:04 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Thu, 13 Apr 2023 23:56:03 -0500
Received: from fllv0122.itg.ti.com (fllv0122.itg.ti.com [10.247.120.72])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 33E4u31V019972;
        Thu, 13 Apr 2023 23:56:03 -0500
Received: from localhost (uda0501179.dhcp.ti.com [10.24.69.114])
        by fllv0122.itg.ti.com (8.14.7/8.14.7) with ESMTP id 33E4u2XB000785;
        Thu, 13 Apr 2023 23:56:03 -0500
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
Subject: [PATCH v9 2/4] soc: ti: pruss: Add pruss_{request,release}_mem_region() API
Date:   Fri, 14 Apr 2023 10:25:40 +0530
Message-ID: <20230414045542.3249939-3-danishanwar@ti.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230414045542.3249939-1-danishanwar@ti.com>
References: <20230414045542.3249939-1-danishanwar@ti.com>
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

From: "Andrew F. Davis" <afd@ti.com>

Add two new API - pruss_request_mem_region() & pruss_release_mem_region(),
to the PRUSS platform driver to allow client drivers to acquire and release
the common memory resources present within a PRU-ICSS subsystem. This
allows the client drivers to directly manipulate the respective memories,
as per their design contract with the associated firmware.

Co-developed-by: Suman Anna <s-anna@ti.com>
Signed-off-by: Suman Anna <s-anna@ti.com>
Signed-off-by: Andrew F. Davis <afd@ti.com>
Co-developed-by: Grzegorz Jaszczyk <grzegorz.jaszczyk@linaro.org>
Signed-off-by: Grzegorz Jaszczyk <grzegorz.jaszczyk@linaro.org>
Reviewed-by: Roger Quadros <rogerq@kernel.org>
Acked-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Reviewed-by: Tony Lindgren <tony@atomide.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: MD Danish Anwar <danishanwar@ti.com>
---
 drivers/soc/ti/pruss.c       | 77 ++++++++++++++++++++++++++++++++++++
 include/linux/pruss_driver.h | 22 +++++++++++
 2 files changed, 99 insertions(+)

diff --git a/drivers/soc/ti/pruss.c b/drivers/soc/ti/pruss.c
index 3fac92df8790..8ada3758b31a 100644
--- a/drivers/soc/ti/pruss.c
+++ b/drivers/soc/ti/pruss.c
@@ -92,6 +92,82 @@ void pruss_put(struct pruss *pruss)
 }
 EXPORT_SYMBOL_GPL(pruss_put);
 
+/**
+ * pruss_request_mem_region() - request a memory resource
+ * @pruss: the pruss instance
+ * @mem_id: the memory resource id
+ * @region: pointer to memory region structure to be filled in
+ *
+ * This function allows a client driver to request a memory resource,
+ * and if successful, will let the client driver own the particular
+ * memory region until released using the pruss_release_mem_region()
+ * API.
+ *
+ * Return: 0 if requested memory region is available (in such case pointer to
+ * memory region is returned via @region), an error otherwise
+ */
+int pruss_request_mem_region(struct pruss *pruss, enum pruss_mem mem_id,
+			     struct pruss_mem_region *region)
+{
+	if (!pruss || !region || mem_id >= PRUSS_MEM_MAX)
+		return -EINVAL;
+
+	mutex_lock(&pruss->lock);
+
+	if (pruss->mem_in_use[mem_id]) {
+		mutex_unlock(&pruss->lock);
+		return -EBUSY;
+	}
+
+	*region = pruss->mem_regions[mem_id];
+	pruss->mem_in_use[mem_id] = region;
+
+	mutex_unlock(&pruss->lock);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(pruss_request_mem_region);
+
+/**
+ * pruss_release_mem_region() - release a memory resource
+ * @pruss: the pruss instance
+ * @region: the memory region to release
+ *
+ * This function is the complimentary function to
+ * pruss_request_mem_region(), and allows the client drivers to
+ * release back a memory resource.
+ *
+ * Return: 0 on success, an error code otherwise
+ */
+int pruss_release_mem_region(struct pruss *pruss,
+			     struct pruss_mem_region *region)
+{
+	int id;
+
+	if (!pruss || !region)
+		return -EINVAL;
+
+	mutex_lock(&pruss->lock);
+
+	/* find out the memory region being released */
+	for (id = 0; id < PRUSS_MEM_MAX; id++) {
+		if (pruss->mem_in_use[id] == region)
+			break;
+	}
+
+	if (id == PRUSS_MEM_MAX) {
+		mutex_unlock(&pruss->lock);
+		return -EINVAL;
+	}
+
+	pruss->mem_in_use[id] = NULL;
+
+	mutex_unlock(&pruss->lock);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(pruss_release_mem_region);
+
 static void pruss_of_free_clk_provider(void *data)
 {
 	struct device_node *clk_mux_np = data;
@@ -294,6 +370,7 @@ static int pruss_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	pruss->dev = dev;
+	mutex_init(&pruss->lock);
 
 	child = of_get_child_by_name(np, "memories");
 	if (!child) {
diff --git a/include/linux/pruss_driver.h b/include/linux/pruss_driver.h
index cb40c2b31045..c8f2e53b911b 100644
--- a/include/linux/pruss_driver.h
+++ b/include/linux/pruss_driver.h
@@ -9,6 +9,7 @@
 #ifndef _PRUSS_DRIVER_H_
 #define _PRUSS_DRIVER_H_
 
+#include <linux/mutex.h>
 #include <linux/remoteproc/pruss.h>
 #include <linux/types.h>
 #include <linux/err.h>
@@ -41,6 +42,8 @@ struct pruss_mem_region {
  * @cfg_base: base iomap for CFG region
  * @cfg_regmap: regmap for config region
  * @mem_regions: data for each of the PRUSS memory regions
+ * @mem_in_use: to indicate if memory resource is in use
+ * @lock: mutex to serialize access to resources
  * @core_clk_mux: clk handle for PRUSS CORE_CLK_MUX
  * @iep_clk_mux: clk handle for PRUSS IEP_CLK_MUX
  */
@@ -49,6 +52,8 @@ struct pruss {
 	void __iomem *cfg_base;
 	struct regmap *cfg_regmap;
 	struct pruss_mem_region mem_regions[PRUSS_MEM_MAX];
+	struct pruss_mem_region *mem_in_use[PRUSS_MEM_MAX];
+	struct mutex lock; /* PRU resource lock */
 	struct clk *core_clk_mux;
 	struct clk *iep_clk_mux;
 };
@@ -57,6 +62,10 @@ struct pruss {
 
 struct pruss *pruss_get(struct rproc *rproc);
 void pruss_put(struct pruss *pruss);
+int pruss_request_mem_region(struct pruss *pruss, enum pruss_mem mem_id,
+			     struct pruss_mem_region *region);
+int pruss_release_mem_region(struct pruss *pruss,
+			     struct pruss_mem_region *region);
 
 #else
 
@@ -67,6 +76,19 @@ static inline struct pruss *pruss_get(struct rproc *rproc)
 
 static inline void pruss_put(struct pruss *pruss) { }
 
+static inline int pruss_request_mem_region(struct pruss *pruss,
+					   enum pruss_mem mem_id,
+					   struct pruss_mem_region *region)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline int pruss_release_mem_region(struct pruss *pruss,
+					   struct pruss_mem_region *region)
+{
+	return -EOPNOTSUPP;
+}
+
 #endif /* CONFIG_TI_PRUSS */
 
 #endif	/* _PRUSS_DRIVER_H_ */
-- 
2.34.1

