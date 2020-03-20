Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A595C18D8A0
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 20:44:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727468AbgCTTny (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 15:43:54 -0400
Received: from lelv0143.ext.ti.com ([198.47.23.248]:44774 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727447AbgCTTnw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 15:43:52 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 02KJhmBW018674;
        Fri, 20 Mar 2020 14:43:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1584733428;
        bh=GPDfnTLXIFqL1TwhFk7bFb7bgEmGnFHMWKi6EbpWGnQ=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=yJhZTFK7bWrx6zwCM7papYKKLvnGKUq7n2u1ZgAywWMexQHlu0J1QekF8c4mTHJeQ
         OSBnPmfqkags1LWX8+R3GjarEyIzUxtax/bJitY2acKyWodHZb9HZ0LypyoaQhLSu6
         DscgwggvHrnI4Sb8bLwDqIvRIDaeX81x14qpZHs4=
Received: from DFLE112.ent.ti.com (dfle112.ent.ti.com [10.64.6.33])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id 02KJhmXf010759;
        Fri, 20 Mar 2020 14:43:48 -0500
Received: from DFLE108.ent.ti.com (10.64.6.29) by DFLE112.ent.ti.com
 (10.64.6.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Fri, 20
 Mar 2020 14:43:48 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE108.ent.ti.com
 (10.64.6.29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Fri, 20 Mar 2020 14:43:48 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 02KJhldn043440;
        Fri, 20 Mar 2020 14:43:47 -0500
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>,
        Lokesh Vutla <lokeshvutla@ti.com>,
        Tony Lindgren <tony@atomide.com>
CC:     Sekhar Nori <nsekhar@ti.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        netdev <netdev@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH net-next v3 10/11] net: ethernet: ti: cpts: add support for HW_TS_PUSH events
Date:   Fri, 20 Mar 2020 21:42:43 +0200
Message-ID: <20200320194244.4703-11-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200320194244.4703-1-grygorii.strashko@ti.com>
References: <20200320194244.4703-1-grygorii.strashko@ti.com>
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
---
 drivers/net/ethernet/ti/cpsw_priv.c   |  5 ++-
 drivers/net/ethernet/ti/cpts.c        | 52 ++++++++++++++++++++++++++-
 drivers/net/ethernet/ti/cpts.h        |  5 +--
 drivers/net/ethernet/ti/netcp_ethss.c |  3 +-
 4 files changed, 60 insertions(+), 5 deletions(-)

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
index 187fd1398b7e..403e1dbed673 100644
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
@@ -272,9 +283,45 @@ static int cpts_ptp_settime(struct ptp_clock_info *ptp,
 	return 0;
 }
 
+static int cpts_extts_enable(struct cpts *cpts, u32 index, int on)
+{
+	u32 v;
+
+	if (index >= cpts->info.n_ext_ts)
+		return -ENXIO;
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
 
@@ -751,7 +798,7 @@ static int cpts_of_parse(struct cpts *cpts, struct device_node *node)
 }
 
 struct cpts *cpts_create(struct device *dev, void __iomem *regs,
-			 struct device_node *node)
+			 struct device_node *node, u32 n_ext_ts)
 {
 	struct cpts *cpts;
 	int ret;
@@ -790,6 +837,9 @@ struct cpts *cpts_create(struct device *dev, void __iomem *regs,
 	cpts->cc.mask = CLOCKSOURCE_MASK(32);
 	cpts->info = cpts_info;
 
+	if (n_ext_ts)
+		cpts->info.n_ext_ts = n_ext_ts;
+
 	cpts_calc_mult_shift(cpts);
 	/* save cc.mult original value as it can be modified
 	 * by cpts_ptp_adjfreq().
diff --git a/drivers/net/ethernet/ti/cpts.h b/drivers/net/ethernet/ti/cpts.h
index e18cb5e436fe..acffe8a29b32 100644
--- a/drivers/net/ethernet/ti/cpts.h
+++ b/drivers/net/ethernet/ti/cpts.h
@@ -121,6 +121,7 @@ struct cpts {
 	struct mutex ptp_clk_mutex; /* sync PTP interface and worker */
 	bool irq_poll;
 	struct completion	ts_push_complete;
+	u32 hw_ts_enable;
 };
 
 int cpts_rx_timestamp(struct cpts *cpts, struct sk_buff *skb);
@@ -128,7 +129,7 @@ void cpts_tx_timestamp(struct cpts *cpts, struct sk_buff *skb);
 int cpts_register(struct cpts *cpts);
 void cpts_unregister(struct cpts *cpts);
 struct cpts *cpts_create(struct device *dev, void __iomem *regs,
-			 struct device_node *node);
+			 struct device_node *node, u32 n_ext_ts);
 void cpts_release(struct cpts *cpts);
 void cpts_misc_interrupt(struct cpts *cpts);
 
@@ -160,7 +161,7 @@ static inline void cpts_tx_timestamp(struct cpts *cpts, struct sk_buff *skb)
 
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

