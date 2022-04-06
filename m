Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 035174F5FB3
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 15:30:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232678AbiDFNLI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 09:11:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232607AbiDFNK4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 09:10:56 -0400
Received: from lelv0142.ext.ti.com (lelv0142.ext.ti.com [198.47.23.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA3CE5F38EF;
        Wed,  6 Apr 2022 02:45:37 -0700 (PDT)
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 2369iDgo059261;
        Wed, 6 Apr 2022 04:44:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1649238253;
        bh=4Un21zBmAxDQIKEz1mlNtx5Yvx0CT5zaSYLpH3w3xBM=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=w/T4JeQgQ7PAq8kBQekPTdHy8jiMsCKxV4+p8NWG8hzbH+Lvz20YMsZsDWRuqNr2N
         VZyWzD025ybEKFDHMJzBIZh4/hxQ0e4sg4mYztKJl36/53TIieLlG1WtYd6JG4KZIL
         EWPMtMgfY9raSAukh8TIF95/Ghpxfnk8c84nYWJE=
Received: from DFLE108.ent.ti.com (dfle108.ent.ti.com [10.64.6.29])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 2369iDT4014756
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 6 Apr 2022 04:44:13 -0500
Received: from DFLE109.ent.ti.com (10.64.6.30) by DFLE108.ent.ti.com
 (10.64.6.29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Wed, 6
 Apr 2022 04:44:12 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DFLE109.ent.ti.com
 (10.64.6.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14 via
 Frontend Transport; Wed, 6 Apr 2022 04:44:12 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 2369iB2O021329;
        Wed, 6 Apr 2022 04:44:12 -0500
From:   Puranjay Mohan <p-mohan@ti.com>
To:     <linux-kernel@vger.kernel.org>
CC:     <bjorn.andersson@linaro.org>, <mathieu.poirier@linaro.org>,
        <krzysztof.kozlowski+dt@linaro.org>,
        <linux-remoteproc@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <nm@ti.com>, <ssantosh@kernel.org>, <s-anna@ti.com>,
        <p-mohan@ti.com>, <linux-arm-kernel@lists.infradead.org>,
        <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <vigneshr@ti.com>, <kishon@ti.com>
Subject: [RFC 04/13] remoteproc: pru: Add pru_rproc_set_ctable() function
Date:   Wed, 6 Apr 2022 15:13:49 +0530
Message-ID: <20220406094358.7895-5-p-mohan@ti.com>
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

From: Roger Quadros <rogerq@ti.com>

Some firmwares expect the OS drivers to configure the CTABLE
entries publishing dynamically allocated memory regions. For
example, the PRU Ethernet firmwares use the C28 and C30 entries
for retrieving the Shared RAM and System SRAM (OCMC) areas
allocated by the PRU Ethernet client driver.

Provide a way for users to do that through a new API,
pru_rproc_set_ctable(). The API returns 0 on success and
a negative value on error.

NOTE:
The programmable CTABLE entries are typically re-programmed by
the PRU firmwares when dealing with a certain block of memory
during block processing. This API provides an interface to the
PRU client drivers to publish a dynamically allocated memory
block with the PRU firmware using a CTABLE entry instead of a
negotiated address in shared memory. Additional synchronization
may be needed between the PRU client drivers and firmwares if
different addresses needs to be published at run-time reusing
the same CTABLE entry.

Co-developed-by: Andrew F. Davis <afd@ti.com>
Signed-off-by: Andrew F. Davis <afd@ti.com>
Co-developed-by: Suman Anna <s-anna@ti.com>
Signed-off-by: Suman Anna <s-anna@ti.com>
Signed-off-by: Roger Quadros <rogerq@ti.com>
Co-developed-by: Grzegorz Jaszczyk <grzegorz.jaszczyk@linaro.org>
Signed-off-by: Grzegorz Jaszczyk <grzegorz.jaszczyk@linaro.org>
Signed-off-by: Puranjay Mohan <p-mohan@ti.com>
---
 drivers/remoteproc/pru_rproc.c | 59 ++++++++++++++++++++++++++++++++++
 include/linux/pruss.h          | 22 +++++++++++++
 2 files changed, 81 insertions(+)

diff --git a/drivers/remoteproc/pru_rproc.c b/drivers/remoteproc/pru_rproc.c
index 9fed3e0372d3..d06b763e995e 100644
--- a/drivers/remoteproc/pru_rproc.c
+++ b/drivers/remoteproc/pru_rproc.c
@@ -119,6 +119,7 @@ struct pru_private_data {
  * @mapped_irq: virtual interrupt numbers of created fw specific mapping
  * @pru_interrupt_map: pointer to interrupt mapping description (firmware)
  * @pru_interrupt_map_sz: pru_interrupt_map size
+ * @rmw_lock: lock for read, modify, write operations on registers
  * @dbg_single_step: debug state variable to set PRU into single step mode
  * @dbg_continuous: debug state variable to restore PRU execution mode
  * @evt_count: number of mapped events
@@ -136,6 +137,7 @@ struct pru_rproc {
 	unsigned int *mapped_irq;
 	struct pru_irq_rsc *pru_interrupt_map;
 	size_t pru_interrupt_map_sz;
+	spinlock_t rmw_lock; /* register access lock */
 	u32 dbg_single_step;
 	u32 dbg_continuous;
 	u8 evt_count;
@@ -152,6 +154,23 @@ void pru_control_write_reg(struct pru_rproc *pru, unsigned int reg, u32 val)
 	writel_relaxed(val, pru->mem_regions[PRU_IOMEM_CTRL].va + reg);
 }
 
+static inline
+void pru_control_set_reg(struct pru_rproc *pru, unsigned int reg,
+			 u32 mask, u32 set)
+{
+	u32 val;
+	unsigned long flags;
+
+	spin_lock_irqsave(&pru->rmw_lock, flags);
+
+	val = pru_control_read_reg(pru, reg);
+	val &= ~mask;
+	val |= (set & mask);
+	pru_control_write_reg(pru, reg, val);
+
+	spin_unlock_irqrestore(&pru->rmw_lock, flags);
+}
+
 static struct rproc *__pru_rproc_get(struct device_node *np, int index)
 {
 	struct device_node *rproc_np = NULL;
@@ -273,6 +292,45 @@ void pru_rproc_put(struct rproc *rproc)
 }
 EXPORT_SYMBOL_GPL(pru_rproc_put);
 
+/**
+ * pru_rproc_set_ctable() - set the constant table index for the PRU
+ * @rproc: the rproc instance of the PRU
+ * @c: constant table index to set
+ * @addr: physical address to set it to
+ *
+ * Return: 0 on success, or errno in error case.
+ */
+int pru_rproc_set_ctable(struct rproc *rproc, enum pru_ctable_idx c, u32 addr)
+{
+	struct pru_rproc *pru = rproc->priv;
+	unsigned int reg;
+	u32 mask, set;
+	u16 idx;
+	u16 idx_mask;
+
+	if (IS_ERR_OR_NULL(rproc))
+		return -EINVAL;
+
+	if (!rproc->dev.parent || !is_pru_rproc(rproc->dev.parent))
+		return -ENODEV;
+
+	/* pointer is 16 bit and index is 8-bit so mask out the rest */
+	idx_mask = (c >= PRU_C28) ? 0xFFFF : 0xFF;
+
+	/* ctable uses bit 8 and upwards only */
+	idx = (addr >> 8) & idx_mask;
+
+	/* configurable ctable (i.e. C24) starts at PRU_CTRL_CTBIR0 */
+	reg = PRU_CTRL_CTBIR0 + 4 * (c >> 1);
+	mask = idx_mask << (16 * (c & 1));
+	set = idx << (16 * (c & 1));
+
+	pru_control_set_reg(pru, reg, mask, set);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(pru_rproc_set_ctable);
+
 static inline u32 pru_debug_read_reg(struct pru_rproc *pru, unsigned int reg)
 {
 	return readl_relaxed(pru->mem_regions[PRU_IOMEM_DEBUG].va + reg);
@@ -944,6 +1002,7 @@ static int pru_rproc_probe(struct platform_device *pdev)
 	pru->rproc = rproc;
 	pru->fw_name = fw_name;
 	pru->client_np = NULL;
+	spin_lock_init(&pru->rmw_lock);
 	mutex_init(&pru->lock);
 
 	for (i = 0; i < ARRAY_SIZE(mem_names); i++) {
diff --git a/include/linux/pruss.h b/include/linux/pruss.h
index fdc719b43db0..d830e20056c7 100644
--- a/include/linux/pruss.h
+++ b/include/linux/pruss.h
@@ -23,13 +23,29 @@ enum pruss_pru_id {
 	PRUSS_NUM_PRUS,
 };
 
+/*
+ * enum pru_ctable_idx - Configurable Constant table index identifiers
+ */
+enum pru_ctable_idx {
+	PRU_C24 = 0,
+	PRU_C25,
+	PRU_C26,
+	PRU_C27,
+	PRU_C28,
+	PRU_C29,
+	PRU_C30,
+	PRU_C31,
+};
+
 struct device_node;
+struct rproc;
 
 #if IS_ENABLED(CONFIG_PRU_REMOTEPROC)
 
 struct rproc *pru_rproc_get(struct device_node *np, int index,
 			    enum pruss_pru_id *pru_id);
 void pru_rproc_put(struct rproc *rproc);
+int pru_rproc_set_ctable(struct rproc *rproc, enum pru_ctable_idx c, u32 addr);
 
 #else
 
@@ -41,6 +57,12 @@ pru_rproc_get(struct device_node *np, int index, enum pruss_pru_id *pru_id)
 
 static inline void pru_rproc_put(struct rproc *rproc) { }
 
+static inline int pru_rproc_set_ctable(struct rproc *rproc,
+				       enum pru_ctable_idx c, u32 addr)
+{
+	return -EOPNOTSUPP;
+}
+
 #endif /* CONFIG_PRU_REMOTEPROC */
 
 static inline bool is_pru_rproc(struct device *dev)
-- 
2.17.1

