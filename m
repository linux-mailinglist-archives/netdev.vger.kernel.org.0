Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59FCB1D14C0
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 15:26:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387766AbgEMN0U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 09:26:20 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:40716 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733066AbgEMN0U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 09:26:20 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 04DDQGoJ119000;
        Wed, 13 May 2020 08:26:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1589376376;
        bh=cxBD+KD45vnwqoUs82K7LDvkiIqJtdNT8WfOvbrNqbA=;
        h=From:To:Subject:Date:In-Reply-To:References;
        b=GS0/mZoD5xa3SEOo7Kxb1QnkvmZxXJEHTKo/6bdRZIeXYL5tU/cpX7Gp4vuci1FO+
         kdgcBxSklz/NWV0XzdkiSpRr6R33QeMhRt0eiHls9wRjSKXvblzqUeLwRylDXYt1+N
         +xea2B3tHYiVS1ANROpEzCjp7LmDzdRgn49KB6SE=
Received: from DLEE112.ent.ti.com (dlee112.ent.ti.com [157.170.170.23])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 04DDQGL5021946
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 13 May 2020 08:26:16 -0500
Received: from DLEE104.ent.ti.com (157.170.170.34) by DLEE112.ent.ti.com
 (157.170.170.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Wed, 13
 May 2020 08:26:16 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE104.ent.ti.com
 (157.170.170.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Wed, 13 May 2020 08:26:16 -0500
Received: from uda0868495.fios-router.home (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 04DDQF4I074601;
        Wed, 13 May 2020 08:26:16 -0500
From:   Murali Karicheri <m-karicheri2@ti.com>
To:     <davem@davemloft.net>, <grygorii.strashko@ti.com>,
        <ilias.apalodimas@linaro.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <nsekhar@ti.com>
Subject: [PATCH net-next 1/2] ethernet: ti: am65-cpts: add routines to support taprio offload
Date:   Wed, 13 May 2020 09:26:14 -0400
Message-ID: <20200513132615.16299-2-m-karicheri2@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200513132615.16299-1-m-karicheri2@ti.com>
References: <20200513132615.16299-1-m-karicheri2@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>

TAPRIO/EST offload support in CPSW2G requires EST scheduler
function enabled in CPTS. So this patch add a function to
set cycle time for EST scheduler.  It also add a function for
getting time in ns of PHC clock for taprio qdisc configuration.
Mostly to verify if timer update is needed or to get actual
state of oper/admin schedule.

Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
---
 drivers/net/ethernet/ti/am65-cpts.c | 48 +++++++++++++++++++++++++++++
 drivers/net/ethernet/ti/am65-cpts.h | 24 +++++++++++++++
 2 files changed, 72 insertions(+)

diff --git a/drivers/net/ethernet/ti/am65-cpts.c b/drivers/net/ethernet/ti/am65-cpts.c
index 51c94b2a77b1..c59a289e428c 100644
--- a/drivers/net/ethernet/ti/am65-cpts.c
+++ b/drivers/net/ethernet/ti/am65-cpts.c
@@ -450,6 +450,19 @@ static int am65_cpts_ptp_gettimex(struct ptp_clock_info *ptp,
 	return 0;
 }
 
+u64 am65_cpts_ns_gettime(struct am65_cpts *cpts)
+{
+	u64 ns;
+
+	/* reuse ptp_clk_lock as it serialize ts push */
+	mutex_lock(&cpts->ptp_clk_lock);
+	ns = am65_cpts_gettime(cpts, NULL);
+	mutex_unlock(&cpts->ptp_clk_lock);
+
+	return ns;
+}
+EXPORT_SYMBOL_GPL(am65_cpts_ns_gettime);
+
 static int am65_cpts_ptp_settime(struct ptp_clock_info *ptp,
 				 const struct timespec64 *ts)
 {
@@ -494,6 +507,41 @@ static int am65_cpts_extts_enable(struct am65_cpts *cpts, u32 index, int on)
 	return 0;
 }
 
+int am65_cpts_estf_enable(struct am65_cpts *cpts, int idx,
+			  struct am65_cpts_estf_cfg *cfg)
+{
+	u64 cycles;
+	u32 val;
+
+	cycles = cfg->ns_period * cpts->refclk_freq;
+	cycles = DIV_ROUND_UP(cycles, NSEC_PER_SEC);
+	if (cycles > U32_MAX)
+		return -EINVAL;
+
+	/* according to TRM should be zeroed */
+	am65_cpts_write32(cpts, 0, estf[idx].length);
+
+	val = upper_32_bits(cfg->ns_start);
+	am65_cpts_write32(cpts, val, estf[idx].comp_hi);
+	val = lower_32_bits(cfg->ns_start);
+	am65_cpts_write32(cpts, val, estf[idx].comp_lo);
+	val = lower_32_bits(cycles);
+	am65_cpts_write32(cpts, val, estf[idx].length);
+
+	dev_dbg(cpts->dev, "%s: ESTF:%u enabled\n", __func__, idx);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(am65_cpts_estf_enable);
+
+void am65_cpts_estf_disable(struct am65_cpts *cpts, int idx)
+{
+	am65_cpts_write32(cpts, 0, estf[idx].length);
+
+	dev_dbg(cpts->dev, "%s: ESTF:%u disabled\n", __func__, idx);
+}
+EXPORT_SYMBOL_GPL(am65_cpts_estf_disable);
+
 static void am65_cpts_perout_enable_hw(struct am65_cpts *cpts,
 				       struct ptp_perout_request *req, int on)
 {
diff --git a/drivers/net/ethernet/ti/am65-cpts.h b/drivers/net/ethernet/ti/am65-cpts.h
index 0b55dc12ba48..98c1960b20b9 100644
--- a/drivers/net/ethernet/ti/am65-cpts.h
+++ b/drivers/net/ethernet/ti/am65-cpts.h
@@ -12,6 +12,11 @@
 
 struct am65_cpts;
 
+struct am65_cpts_estf_cfg {
+	u64 ns_period;
+	u64 ns_start;
+};
+
 #if IS_ENABLED(CONFIG_TI_K3_AM65_CPTS)
 struct am65_cpts *am65_cpts_create(struct device *dev, void __iomem *regs,
 				   struct device_node *node);
@@ -19,6 +24,10 @@ int am65_cpts_phc_index(struct am65_cpts *cpts);
 void am65_cpts_tx_timestamp(struct am65_cpts *cpts, struct sk_buff *skb);
 void am65_cpts_prep_tx_timestamp(struct am65_cpts *cpts, struct sk_buff *skb);
 void am65_cpts_rx_enable(struct am65_cpts *cpts, bool en);
+u64 am65_cpts_ns_gettime(struct am65_cpts *cpts);
+int am65_cpts_estf_enable(struct am65_cpts *cpts, int idx,
+			  struct am65_cpts_estf_cfg *cfg);
+void am65_cpts_estf_disable(struct am65_cpts *cpts, int idx);
 #else
 static inline struct am65_cpts *am65_cpts_create(struct device *dev,
 						 void __iomem *regs,
@@ -45,6 +54,21 @@ static inline void am65_cpts_prep_tx_timestamp(struct am65_cpts *cpts,
 static inline void am65_cpts_rx_enable(struct am65_cpts *cpts, bool en)
 {
 }
+
+static s64 am65_cpts_ns_gettime(struct am65_cpts *cpts)
+{
+	return 0;
+}
+
+static int am65_cpts_estf_enable(struct am65_cpts *cpts,
+				 int idx, struct am65_cpts_estf_cfg *cfg)
+{
+	return 0;
+}
+
+static void am65_cpts_estf_disable(struct am65_cpts *cpts, int idx)
+{
+}
 #endif
 
 #endif /* K3_CPTS_H_ */
-- 
2.17.1

