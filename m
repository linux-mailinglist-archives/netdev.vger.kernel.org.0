Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F31725E404
	for <lists+netdev@lfdr.de>; Sat,  5 Sep 2020 01:10:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728390AbgIDXK3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 19:10:29 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:33088 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728378AbgIDXK1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Sep 2020 19:10:27 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 084NALJM051330;
        Fri, 4 Sep 2020 18:10:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1599261021;
        bh=HrZ4Mx/oHWVRRLQAVP1FDSf+iiLcOYDsomSCa4jZahw=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=rkxgIjaRdyDGoO5XYgqkVKX2KZZMbRWwlh566q19cwexP/o2oKyYksraXQMMy9xO+
         7Wk6ygIO37oN0fEw4uG9OrPCGuouFOZYyBeBxi8DIuuMgkRAm5+AmjHqZJbwSxWb1r
         GHJpczqVbJ1wIXZ/LMDMfEu51MmJUMbfpbd5AIIo=
Received: from DFLE114.ent.ti.com (dfle114.ent.ti.com [10.64.6.35])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 084NALrt091472
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 4 Sep 2020 18:10:21 -0500
Received: from DFLE105.ent.ti.com (10.64.6.26) by DFLE114.ent.ti.com
 (10.64.6.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Fri, 4 Sep
 2020 18:10:21 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE105.ent.ti.com
 (10.64.6.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Fri, 4 Sep 2020 18:10:21 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 084NAKD0008695;
        Fri, 4 Sep 2020 18:10:21 -0500
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Murali Karicheri <m-karicheri2@ti.com>
CC:     Sekhar Nori <nsekhar@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH net-next 7/9] net: ethernet: ti: am65-cpsw: enable hw auto ageing
Date:   Sat, 5 Sep 2020 02:09:22 +0300
Message-ID: <20200904230924.9971-8-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200904230924.9971-1-grygorii.strashko@ti.com>
References: <20200904230924.9971-1-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The AM65x ALE supports HW auto-ageing which can be enabled by programming
ageing interval in ALE_AGING_TIMER register. For this CPSW fck_clk
frequency has to be know by ALE.

This patch extends cpsw_ale_params with bus_freq field and enables ALE HW
auto ageing for AM65x CPSW2G ALE version.

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 13 +++++
 drivers/net/ethernet/ti/am65-cpsw-nuss.h |  1 +
 drivers/net/ethernet/ti/cpsw_ale.c       | 61 +++++++++++++++++++++---
 drivers/net/ethernet/ti/cpsw_ale.h       |  1 +
 4 files changed, 70 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index bec47e794359..501d676fd88b 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -5,6 +5,7 @@
  *
  */
 
+#include <linux/clk.h>
 #include <linux/etherdevice.h>
 #include <linux/if_vlan.h>
 #include <linux/interrupt.h>
@@ -2038,6 +2039,7 @@ static int am65_cpsw_nuss_probe(struct platform_device *pdev)
 	struct am65_cpsw_common *common;
 	struct device_node *node;
 	struct resource *res;
+	struct clk *clk;
 	int ret, i;
 
 	common = devm_kzalloc(dev, sizeof(struct am65_cpsw_common), GFP_KERNEL);
@@ -2086,6 +2088,16 @@ static int am65_cpsw_nuss_probe(struct platform_device *pdev)
 	if (!common->ports)
 		return -ENOMEM;
 
+	clk = devm_clk_get(dev, "fck");
+	if (IS_ERR(clk)) {
+		ret = PTR_ERR(clk);
+
+		if (ret != -EPROBE_DEFER)
+			dev_err(dev, "error getting fck clock %d\n", ret);
+		return ret;
+	}
+	common->bus_freq = clk_get_rate(clk);
+
 	pm_runtime_enable(dev);
 	ret = pm_runtime_get_sync(dev);
 	if (ret < 0) {
@@ -2134,6 +2146,7 @@ static int am65_cpsw_nuss_probe(struct platform_device *pdev)
 	ale_params.ale_ports = common->port_num + 1;
 	ale_params.ale_regs = common->cpsw_base + AM65_CPSW_NU_ALE_BASE;
 	ale_params.dev_id = "am65x-cpsw2g";
+	ale_params.bus_freq = common->bus_freq;
 
 	common->ale = cpsw_ale_create(&ale_params);
 	if (IS_ERR(common->ale)) {
diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.h b/drivers/net/ethernet/ti/am65-cpsw-nuss.h
index 94f666ea0e53..993e1d4d3222 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.h
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.h
@@ -106,6 +106,7 @@ struct am65_cpsw_common {
 
 	u32			nuss_ver;
 	u32			cpsw_ver;
+	unsigned long		bus_freq;
 	bool			pf_p0_rx_ptype_rrobin;
 	struct am65_cpts	*cpts;
 	int			est_enabled;
diff --git a/drivers/net/ethernet/ti/cpsw_ale.c b/drivers/net/ethernet/ti/cpsw_ale.c
index 524920a4bff0..7b54e9911b1e 100644
--- a/drivers/net/ethernet/ti/cpsw_ale.c
+++ b/drivers/net/ethernet/ti/cpsw_ale.c
@@ -32,6 +32,7 @@
 #define ALE_STATUS		0x04
 #define ALE_CONTROL		0x08
 #define ALE_PRESCALE		0x10
+#define ALE_AGING_TIMER		0x14
 #define ALE_UNKNOWNVLAN		0x18
 #define ALE_TABLE_CONTROL	0x20
 #define ALE_TABLE		0x34
@@ -46,6 +47,9 @@
 
 #define AM65_CPSW_ALE_THREAD_DEF_REG 0x134
 
+/* ALE_AGING_TIMER */
+#define ALE_AGING_TIMER_MASK	GENMASK(23, 0)
+
 enum {
 	CPSW_ALE_F_STATUS_REG = BIT(0), /* Status register present */
 	CPSW_ALE_F_HW_AUTOAGING = BIT(1), /* HW auto aging */
@@ -982,21 +986,66 @@ static void cpsw_ale_timer(struct timer_list *t)
 	}
 }
 
+static void cpsw_ale_hw_aging_timer_start(struct cpsw_ale *ale)
+{
+	u32 aging_timer;
+
+	aging_timer = ale->params.bus_freq / 1000000;
+	aging_timer *= ale->params.ale_ageout;
+
+	if (aging_timer & ~ALE_AGING_TIMER_MASK) {
+		aging_timer = ALE_AGING_TIMER_MASK;
+		dev_warn(ale->params.dev,
+			 "ALE aging timer overflow, set to max\n");
+	}
+
+	writel(aging_timer, ale->params.ale_regs + ALE_AGING_TIMER);
+}
+
+static void cpsw_ale_hw_aging_timer_stop(struct cpsw_ale *ale)
+{
+	writel(0, ale->params.ale_regs + ALE_AGING_TIMER);
+}
+
+static void cpsw_ale_aging_start(struct cpsw_ale *ale)
+{
+	if (!ale->params.ale_ageout)
+		return;
+
+	if (ale->features & CPSW_ALE_F_HW_AUTOAGING) {
+		cpsw_ale_hw_aging_timer_start(ale);
+		return;
+	}
+
+	timer_setup(&ale->timer, cpsw_ale_timer, 0);
+	ale->timer.expires = jiffies + ale->ageout;
+	add_timer(&ale->timer);
+}
+
+static void cpsw_ale_aging_stop(struct cpsw_ale *ale)
+{
+	if (!ale->params.ale_ageout)
+		return;
+
+	if (ale->features & CPSW_ALE_F_HW_AUTOAGING) {
+		cpsw_ale_hw_aging_timer_stop(ale);
+		return;
+	}
+
+	del_timer_sync(&ale->timer);
+}
+
 void cpsw_ale_start(struct cpsw_ale *ale)
 {
 	cpsw_ale_control_set(ale, 0, ALE_ENABLE, 1);
 	cpsw_ale_control_set(ale, 0, ALE_CLEAR, 1);
 
-	timer_setup(&ale->timer, cpsw_ale_timer, 0);
-	if (ale->ageout) {
-		ale->timer.expires = jiffies + ale->ageout;
-		add_timer(&ale->timer);
-	}
+	cpsw_ale_aging_start(ale);
 }
 
 void cpsw_ale_stop(struct cpsw_ale *ale)
 {
-	del_timer_sync(&ale->timer);
+	cpsw_ale_aging_stop(ale);
 	cpsw_ale_control_set(ale, 0, ALE_CLEAR, 1);
 	cpsw_ale_control_set(ale, 0, ALE_ENABLE, 0);
 }
diff --git a/drivers/net/ethernet/ti/cpsw_ale.h b/drivers/net/ethernet/ti/cpsw_ale.h
index 27b30802b384..9c6da58183c9 100644
--- a/drivers/net/ethernet/ti/cpsw_ale.h
+++ b/drivers/net/ethernet/ti/cpsw_ale.h
@@ -25,6 +25,7 @@ struct cpsw_ale_params {
 	 */
 	u32			major_ver_mask;
 	const char		*dev_id;
+	unsigned long		bus_freq;
 };
 
 struct cpsw_ale {
-- 
2.17.1

