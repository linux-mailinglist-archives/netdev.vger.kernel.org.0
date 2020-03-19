Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B704F18BD42
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 17:59:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727534AbgCSQ6e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 12:58:34 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:42354 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727431AbgCSQ6a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 12:58:30 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 02JGwPef095626;
        Thu, 19 Mar 2020 11:58:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1584637105;
        bh=jxG2bPVH3l0XS7W4xN8Iy/255UhOh6d1XRIIwkaFe3Y=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=NM8jDAp3WYu+5eqXz7IT7e0ylVQ39CN0oaU7i8CIch8zf0YLux8uEkLSZF60OTyGE
         7ORbfH0JnjdQGvfYcMn+uGgH0dGoX29HCqwD8bv0glqqpW3aJjKF2LNX+yD0/HcdwT
         8zlDRuDFk36BuYRUwAsXDX8MNnLudGdgK0EoD2oA=
Received: from DLEE105.ent.ti.com (dlee105.ent.ti.com [157.170.170.35])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id 02JGwOT3005364;
        Thu, 19 Mar 2020 11:58:25 -0500
Received: from DLEE103.ent.ti.com (157.170.170.33) by DLEE105.ent.ti.com
 (157.170.170.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Thu, 19
 Mar 2020 11:58:24 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE103.ent.ti.com
 (157.170.170.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Thu, 19 Mar 2020 11:58:24 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 02JGwNDa036509;
        Thu, 19 Mar 2020 11:58:24 -0500
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
Subject: [PATCH net-next v2 09/10] net: ethernet: ti: cpts: add irq support
Date:   Thu, 19 Mar 2020 18:58:01 +0200
Message-ID: <20200319165802.30898-10-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200319165802.30898-1-grygorii.strashko@ti.com>
References: <20200319165802.30898-1-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add CPTS IRQ support, but do not enable it. By default, the CPTS driver
will continue working using polling mode which is required for CPTS to
continue working on platforms other than CPSW, like Keystone 2.

The CPTS IRQ support is required to enable support for HW_TS_PUSH events.
The CPSW CPTS IRQ and HW_TS_PUSH events support will be enabled in follow
up patches.

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 drivers/net/ethernet/ti/cpsw_priv.c   |  5 +-
 drivers/net/ethernet/ti/cpts.c        | 74 ++++++++++++++++++++++++++-
 drivers/net/ethernet/ti/cpts.h        | 18 ++++++-
 drivers/net/ethernet/ti/netcp_ethss.c |  3 +-
 4 files changed, 94 insertions(+), 6 deletions(-)

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
index fe70eb677b88..403e1dbed673 100644
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
@@ -99,6 +104,8 @@ static void cpts_purge_txq(struct cpts *cpts)
  */
 static int cpts_fifo_read(struct cpts *cpts, int match)
 {
+	struct ptp_clock_event pevent;
+	bool need_schedule = false;
 	struct cpts_event *event;
 	unsigned long flags;
 	int i, type = -1;
@@ -131,6 +138,8 @@ static int cpts_fifo_read(struct cpts *cpts, int match)
 				cpts->cc.mult = cpts->mult_new;
 				cpts->mult_new = 0;
 			}
+			if (!cpts->irq_poll)
+				complete(&cpts->ts_push_complete);
 			break;
 		case CPTS_EV_TX:
 		case CPTS_EV_RX:
@@ -139,10 +148,16 @@ static int cpts_fifo_read(struct cpts *cpts, int match)
 
 			list_del_init(&event->list);
 			list_add_tail(&event->list, &cpts->events);
+			need_schedule = true;
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
@@ -154,9 +169,17 @@ static int cpts_fifo_read(struct cpts *cpts, int match)
 
 	spin_unlock_irqrestore(&cpts->lock, flags);
 
+	if (!cpts->irq_poll && need_schedule)
+		ptp_schedule_worker(cpts->clock, 0);
+
 	return type == match ? 0 : -1;
 }
 
+void cpts_misc_interrupt(struct cpts *cpts)
+{
+	cpts_fifo_read(cpts, -1);
+}
+
 static u64 cpts_systim_read(const struct cyclecounter *cc)
 {
 	struct cpts *cpts = container_of(cc, struct cpts, cc);
@@ -169,6 +192,8 @@ static void cpts_update_cur_time(struct cpts *cpts, int match,
 {
 	unsigned long flags;
 
+	reinit_completion(&cpts->ts_push_complete);
+
 	/* use spin_lock_irqsave() here as it has to run very fast */
 	spin_lock_irqsave(&cpts->lock, flags);
 	ptp_read_system_prets(sts);
@@ -177,8 +202,12 @@ static void cpts_update_cur_time(struct cpts *cpts, int match,
 	ptp_read_system_postts(sts);
 	spin_unlock_irqrestore(&cpts->lock, flags);
 
-	if (cpts_fifo_read(cpts, match) && match != -1)
+	if (cpts->irq_poll && cpts_fifo_read(cpts, match) && match != -1)
 		dev_err(cpts->dev, "cpts: unable to obtain a time stamp\n");
+
+	if (!cpts->irq_poll &&
+	    !wait_for_completion_timeout(&cpts->ts_push_complete, HZ))
+		dev_err(cpts->dev, "cpts: obtain a time stamp timeout\n");
 }
 
 /* PTP clock operations */
@@ -254,9 +283,45 @@ static int cpts_ptp_settime(struct ptp_clock_info *ptp,
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
 
@@ -733,7 +798,7 @@ static int cpts_of_parse(struct cpts *cpts, struct device_node *node)
 }
 
 struct cpts *cpts_create(struct device *dev, void __iomem *regs,
-			 struct device_node *node)
+			 struct device_node *node, u32 n_ext_ts)
 {
 	struct cpts *cpts;
 	int ret;
@@ -744,8 +809,10 @@ struct cpts *cpts_create(struct device *dev, void __iomem *regs,
 
 	cpts->dev = dev;
 	cpts->reg = (struct cpsw_cpts __iomem *)regs;
+	cpts->irq_poll = true;
 	spin_lock_init(&cpts->lock);
 	mutex_init(&cpts->ptp_clk_mutex);
+	init_completion(&cpts->ts_push_complete);
 
 	ret = cpts_of_parse(cpts, node);
 	if (ret)
@@ -770,6 +837,9 @@ struct cpts *cpts_create(struct device *dev, void __iomem *regs,
 	cpts->cc.mask = CLOCKSOURCE_MASK(32);
 	cpts->info = cpts_info;
 
+	if (n_ext_ts)
+		cpts->info.n_ext_ts = n_ext_ts;
+
 	cpts_calc_mult_shift(cpts);
 	/* save cc.mult original value as it can be modified
 	 * by cpts_ptp_adjfreq().
diff --git a/drivers/net/ethernet/ti/cpts.h b/drivers/net/ethernet/ti/cpts.h
index 993b4cfa4e86..97826e03b5d1 100644
--- a/drivers/net/ethernet/ti/cpts.h
+++ b/drivers/net/ethernet/ti/cpts.h
@@ -119,6 +119,9 @@ struct cpts {
 	u64 cur_timestamp;
 	u32 mult_new;
 	struct mutex ptp_clk_mutex; /* sync PTP interface and worker */
+	bool irq_poll;
+	struct completion	ts_push_complete;
+	u32 hw_ts_enable;
 };
 
 int cpts_rx_timestamp(struct cpts *cpts, struct sk_buff *skb);
@@ -126,8 +129,9 @@ void cpts_tx_timestamp(struct cpts *cpts, struct sk_buff *skb);
 int cpts_register(struct cpts *cpts);
 void cpts_unregister(struct cpts *cpts);
 struct cpts *cpts_create(struct device *dev, void __iomem *regs,
-			 struct device_node *node);
+			 struct device_node *node, u32 n_ext_ts);
 void cpts_release(struct cpts *cpts);
+void cpts_misc_interrupt(struct cpts *cpts);
 
 static inline bool cpts_can_timestamp(struct cpts *cpts, struct sk_buff *skb)
 {
@@ -139,6 +143,11 @@ static inline bool cpts_can_timestamp(struct cpts *cpts, struct sk_buff *skb)
 	return true;
 }
 
+static inline void cpts_set_irqpoll(struct cpts *cpts, bool en)
+{
+	cpts->irq_poll = en;
+}
+
 #else
 struct cpts;
 
@@ -151,7 +160,7 @@ static inline void cpts_tx_timestamp(struct cpts *cpts, struct sk_buff *skb)
 
 static inline
 struct cpts *cpts_create(struct device *dev, void __iomem *regs,
-			 struct device_node *node)
+			 struct device_node *node, u32 n_ext_ts)
 {
 	return NULL;
 }
@@ -174,6 +183,11 @@ static inline bool cpts_can_timestamp(struct cpts *cpts, struct sk_buff *skb)
 {
 	return false;
 }
+
+static inline void cpts_misc_interrupt(struct cpts *cpts)
+{
+}
+
 #endif
 
 
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

