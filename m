Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC98E1B5D9D
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 16:22:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728865AbgDWOVq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 10:21:46 -0400
Received: from lelv0143.ext.ti.com ([198.47.23.248]:58470 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728852AbgDWOVo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 10:21:44 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 03NELe7d076394;
        Thu, 23 Apr 2020 09:21:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1587651700;
        bh=dAdnOPU2PcjrJxKqJXajjpO5/UjoZnKPl6UBNqll2BM=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=T0AhKHOpFeJZXvbR6h+SloDpR2Efvsuu3O2Sy3ClK3bVFDlR0n/sj6GJcyO2fwqz5
         6uBtFts/ml1c9odRcq+PwziRaEp1grh4yisGnhS7P3QWxVCuvRvKvtyORwt5OcvoSw
         BTQ0hn0LOGGn8C0HeDxv9eQpuvAkbUZ81C0ZKSoU=
Received: from DFLE109.ent.ti.com (dfle109.ent.ti.com [10.64.6.30])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 03NELeHG040305
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 23 Apr 2020 09:21:40 -0500
Received: from DFLE106.ent.ti.com (10.64.6.27) by DFLE109.ent.ti.com
 (10.64.6.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Thu, 23
 Apr 2020 09:21:39 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE106.ent.ti.com
 (10.64.6.27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Thu, 23 Apr 2020 09:21:39 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 03NELcC5028337;
        Thu, 23 Apr 2020 09:21:39 -0500
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     Richard Cochran <richardcochran@gmail.com>,
        Lokesh Vutla <lokeshvutla@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        "David S. Miller" <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, Sekhar Nori <nsekhar@ti.com>,
        <linux-kernel@vger.kernel.org>,
        Murali Karicheri <m-karicheri2@ti.com>,
        <linux-omap@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH net-next v5 09/10] net: ethernet: ti: cpts: add support for HW_TS_PUSH events
Date:   Thu, 23 Apr 2020 17:20:21 +0300
Message-ID: <20200423142022.10538-10-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200423142022.10538-1-grygorii.strashko@ti.com>
References: <20200423142022.10538-1-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hence CPTS IRQ support is in place the W_TS_PUSH events can be added.
PWM capable DmTimers can be used to generete input signals for CPTS on TI
AM335x/AM437x/DRA7 SoCs to be timestamped:
AM335x/AM437x: timer4 - timer7
DRA7/AM57xx: timer13 - timer16

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Acked-by: Richard Cochran <richardcochran@gmail.com>
---
 drivers/net/ethernet/ti/cpsw_priv.c   |  5 ++-
 drivers/net/ethernet/ti/cpts.c        | 49 ++++++++++++++++++++++++++-
 drivers/net/ethernet/ti/cpts.h        |  5 +--
 drivers/net/ethernet/ti/netcp_ethss.c |  3 +-
 4 files changed, 57 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/ti/cpsw_priv.c b/drivers/net/ethernet/ti/cpsw_priv.c
index 97a058ca60ac..099208927400 100644
--- a/drivers/net/ethernet/ti/cpsw_priv.c
+++ b/drivers/net/ethernet/ti/cpsw_priv.c
@@ -28,6 +28,8 @@
 #include "cpsw_sl.h"
 #include "davinci_cpdma.h"
 
+#define CPTS_N_ETX_TS 4
+
 int (*cpsw_slave_index)(struct cpsw_common *cpsw, struct cpsw_priv *priv);
 
 void cpsw_intr_enable(struct cpsw_common *cpsw)
@@ -522,7 +524,8 @@ int cpsw_init_common(struct cpsw_common *cpsw, void __iomem *ss_regs,
 	if (!cpts_node)
 		cpts_node = cpsw->dev->of_node;
 
-	cpsw->cpts = cpts_create(cpsw->dev, cpts_regs, cpts_node);
+	cpsw->cpts = cpts_create(cpsw->dev, cpts_regs, cpts_node,
+				 CPTS_N_ETX_TS);
 	if (IS_ERR(cpsw->cpts)) {
 		ret = PTR_ERR(cpsw->cpts);
 		cpdma_ctlr_destroy(cpsw->dma);
diff --git a/drivers/net/ethernet/ti/cpts.c b/drivers/net/ethernet/ti/cpts.c
index 339796c87bf6..7c55d395de2c 100644
--- a/drivers/net/ethernet/ti/cpts.c
+++ b/drivers/net/ethernet/ti/cpts.c
@@ -32,6 +32,11 @@ struct cpts_skb_cb_data {
 #define cpts_read32(c, r)	readl_relaxed(&c->reg->r)
 #define cpts_write32(c, v, r)	writel_relaxed(v, &c->reg->r)
 
+static int cpts_event_port(struct cpts_event *event)
+{
+	return (event->high >> PORT_NUMBER_SHIFT) & PORT_NUMBER_MASK;
+}
+
 static int event_expired(struct cpts_event *event)
 {
 	return time_after(jiffies, event->tmo);
@@ -99,6 +104,7 @@ static void cpts_purge_txq(struct cpts *cpts)
  */
 static int cpts_fifo_read(struct cpts *cpts, int match)
 {
+	struct ptp_clock_event pevent;
 	bool need_schedule = false;
 	struct cpts_event *event;
 	unsigned long flags;
@@ -146,7 +152,12 @@ static int cpts_fifo_read(struct cpts *cpts, int match)
 			break;
 		case CPTS_EV_ROLL:
 		case CPTS_EV_HALF:
+			break;
 		case CPTS_EV_HW:
+			pevent.timestamp = event->timestamp;
+			pevent.type = PTP_CLOCK_EXTTS;
+			pevent.index = cpts_event_port(event) - 1;
+			ptp_clock_event(cpts->clock, &pevent);
 			break;
 		default:
 			dev_err(cpts->dev, "cpts: unknown event type\n");
@@ -273,9 +284,42 @@ static int cpts_ptp_settime(struct ptp_clock_info *ptp,
 	return 0;
 }
 
+static int cpts_extts_enable(struct cpts *cpts, u32 index, int on)
+{
+	u32 v;
+
+	if (((cpts->hw_ts_enable & BIT(index)) >> index) == on)
+		return 0;
+
+	mutex_lock(&cpts->ptp_clk_mutex);
+
+	v = cpts_read32(cpts, control);
+	if (on) {
+		v |= BIT(8 + index);
+		cpts->hw_ts_enable |= BIT(index);
+	} else {
+		v &= ~BIT(8 + index);
+		cpts->hw_ts_enable &= ~BIT(index);
+	}
+	cpts_write32(cpts, v, control);
+
+	mutex_unlock(&cpts->ptp_clk_mutex);
+
+	return 0;
+}
+
 static int cpts_ptp_enable(struct ptp_clock_info *ptp,
 			   struct ptp_clock_request *rq, int on)
 {
+	struct cpts *cpts = container_of(ptp, struct cpts, info);
+
+	switch (rq->type) {
+	case PTP_CLK_REQ_EXTTS:
+		return cpts_extts_enable(cpts, rq->extts.index, on);
+	default:
+		break;
+	}
+
 	return -EOPNOTSUPP;
 }
 
@@ -716,7 +760,7 @@ static int cpts_of_parse(struct cpts *cpts, struct device_node *node)
 }
 
 struct cpts *cpts_create(struct device *dev, void __iomem *regs,
-			 struct device_node *node)
+			 struct device_node *node, u32 n_ext_ts)
 {
 	struct cpts *cpts;
 	int ret;
@@ -755,6 +799,9 @@ struct cpts *cpts_create(struct device *dev, void __iomem *regs,
 	cpts->cc.mask = CLOCKSOURCE_MASK(32);
 	cpts->info = cpts_info;
 
+	if (n_ext_ts)
+		cpts->info.n_ext_ts = n_ext_ts;
+
 	cpts_calc_mult_shift(cpts);
 	/* save cc.mult original value as it can be modified
 	 * by cpts_ptp_adjfreq().
diff --git a/drivers/net/ethernet/ti/cpts.h b/drivers/net/ethernet/ti/cpts.h
index 473d0622e861..07222f651d2e 100644
--- a/drivers/net/ethernet/ti/cpts.h
+++ b/drivers/net/ethernet/ti/cpts.h
@@ -120,6 +120,7 @@ struct cpts {
 	struct mutex ptp_clk_mutex; /* sync PTP interface and worker */
 	bool irq_poll;
 	struct completion	ts_push_complete;
+	u32 hw_ts_enable;
 };
 
 void cpts_rx_timestamp(struct cpts *cpts, struct sk_buff *skb);
@@ -127,7 +128,7 @@ void cpts_tx_timestamp(struct cpts *cpts, struct sk_buff *skb);
 int cpts_register(struct cpts *cpts);
 void cpts_unregister(struct cpts *cpts);
 struct cpts *cpts_create(struct device *dev, void __iomem *regs,
-			 struct device_node *node);
+			 struct device_node *node, u32 n_ext_ts);
 void cpts_release(struct cpts *cpts);
 void cpts_misc_interrupt(struct cpts *cpts);
 
@@ -158,7 +159,7 @@ static inline void cpts_tx_timestamp(struct cpts *cpts, struct sk_buff *skb)
 
 static inline
 struct cpts *cpts_create(struct device *dev, void __iomem *regs,
-			 struct device_node *node)
+			 struct device_node *node, u32 n_ext_ts)
 {
 	return NULL;
 }
diff --git a/drivers/net/ethernet/ti/netcp_ethss.c b/drivers/net/ethernet/ti/netcp_ethss.c
index fb36115e9c51..9d6e27fb710e 100644
--- a/drivers/net/ethernet/ti/netcp_ethss.c
+++ b/drivers/net/ethernet/ti/netcp_ethss.c
@@ -3716,7 +3716,8 @@ static int gbe_probe(struct netcp_device *netcp_device, struct device *dev,
 	if (!cpts_node)
 		cpts_node = of_node_get(node);
 
-	gbe_dev->cpts = cpts_create(gbe_dev->dev, gbe_dev->cpts_reg, cpts_node);
+	gbe_dev->cpts = cpts_create(gbe_dev->dev, gbe_dev->cpts_reg,
+				    cpts_node, 0);
 	of_node_put(cpts_node);
 	if (IS_ENABLED(CONFIG_TI_CPTS) && IS_ERR(gbe_dev->cpts)) {
 		ret = PTR_ERR(gbe_dev->cpts);
-- 
2.17.1

