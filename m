Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D513D1B5D9B
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 16:22:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728847AbgDWOVn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 10:21:43 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:60040 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728812AbgDWOVm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 10:21:42 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 03NELc6S078033;
        Thu, 23 Apr 2020 09:21:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1587651698;
        bh=+4w4UjF5UYOxBNm+FS+3KcQd/oG3m89+jaafC65RcjU=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=un9WVRXmzaPBdB8c8igpJE/gXW/1cVLfJVy4cTxJCVi6rgjtJXXUYo+59qFPXWylT
         kpAaCt4E2cAbxoZ9YgYjyH5Oxs5Q5KWBWaO8FkK+JNqlfsZIU93N1XBGebPvqEB1pI
         2mijXvEzfZxlhAugSQhD8MMAWoICxhNuPE/4Gth4=
Received: from DLEE108.ent.ti.com (dlee108.ent.ti.com [157.170.170.38])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 03NELchZ123391
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 23 Apr 2020 09:21:38 -0500
Received: from DLEE104.ent.ti.com (157.170.170.34) by DLEE108.ent.ti.com
 (157.170.170.38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Thu, 23
 Apr 2020 09:21:37 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE104.ent.ti.com
 (157.170.170.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Thu, 23 Apr 2020 09:21:37 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 03NELaCu097200;
        Thu, 23 Apr 2020 09:21:37 -0500
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
Subject: [PATCH net-next v5 08/10] net: ethernet: ti: cpts: add irq support
Date:   Thu, 23 Apr 2020 17:20:20 +0300
Message-ID: <20200423142022.10538-9-grygorii.strashko@ti.com>
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

Add CPTS IRQ support, but do not enable it. By default, the CPTS driver
will continue working using polling mode which is required for CPTS to
continue working on platforms other than CPSW, like Keystone 2.

The CPTS IRQ support is required to enable support for HW_TS_PUSH events.
The CPSW CPTS IRQ and HW_TS_PUSH events support will be enabled in follow
up patches.

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Acked-by: Richard Cochran <richardcochran@gmail.com>
---
 drivers/net/ethernet/ti/cpts.c | 23 ++++++++++++++++++++++-
 drivers/net/ethernet/ti/cpts.h | 16 ++++++++++++++++
 2 files changed, 38 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ti/cpts.c b/drivers/net/ethernet/ti/cpts.c
index 8db9efdf1708..339796c87bf6 100644
--- a/drivers/net/ethernet/ti/cpts.c
+++ b/drivers/net/ethernet/ti/cpts.c
@@ -99,6 +99,7 @@ static void cpts_purge_txq(struct cpts *cpts)
  */
 static int cpts_fifo_read(struct cpts *cpts, int match)
 {
+	bool need_schedule = false;
 	struct cpts_event *event;
 	unsigned long flags;
 	int i, type = -1;
@@ -131,6 +132,8 @@ static int cpts_fifo_read(struct cpts *cpts, int match)
 				cpts->cc.mult = cpts->mult_new;
 				cpts->mult_new = 0;
 			}
+			if (!cpts->irq_poll)
+				complete(&cpts->ts_push_complete);
 			break;
 		case CPTS_EV_TX:
 		case CPTS_EV_RX:
@@ -139,6 +142,7 @@ static int cpts_fifo_read(struct cpts *cpts, int match)
 
 			list_del_init(&event->list);
 			list_add_tail(&event->list, &cpts->events);
+			need_schedule = true;
 			break;
 		case CPTS_EV_ROLL:
 		case CPTS_EV_HALF:
@@ -154,9 +158,18 @@ static int cpts_fifo_read(struct cpts *cpts, int match)
 
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
+EXPORT_SYMBOL_GPL(cpts_misc_interrupt);
+
 static u64 cpts_systim_read(const struct cyclecounter *cc)
 {
 	struct cpts *cpts = container_of(cc, struct cpts, cc);
@@ -169,6 +182,8 @@ static void cpts_update_cur_time(struct cpts *cpts, int match,
 {
 	unsigned long flags;
 
+	reinit_completion(&cpts->ts_push_complete);
+
 	/* use spin_lock_irqsave() here as it has to run very fast */
 	spin_lock_irqsave(&cpts->lock, flags);
 	ptp_read_system_prets(sts);
@@ -177,8 +192,12 @@ static void cpts_update_cur_time(struct cpts *cpts, int match,
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
@@ -708,8 +727,10 @@ struct cpts *cpts_create(struct device *dev, void __iomem *regs,
 
 	cpts->dev = dev;
 	cpts->reg = (struct cpsw_cpts __iomem *)regs;
+	cpts->irq_poll = true;
 	spin_lock_init(&cpts->lock);
 	mutex_init(&cpts->ptp_clk_mutex);
+	init_completion(&cpts->ts_push_complete);
 
 	ret = cpts_of_parse(cpts, node);
 	if (ret)
diff --git a/drivers/net/ethernet/ti/cpts.h b/drivers/net/ethernet/ti/cpts.h
index f16e14d67f5f..473d0622e861 100644
--- a/drivers/net/ethernet/ti/cpts.h
+++ b/drivers/net/ethernet/ti/cpts.h
@@ -118,6 +118,8 @@ struct cpts {
 	u64 cur_timestamp;
 	u32 mult_new;
 	struct mutex ptp_clk_mutex; /* sync PTP interface and worker */
+	bool irq_poll;
+	struct completion	ts_push_complete;
 };
 
 void cpts_rx_timestamp(struct cpts *cpts, struct sk_buff *skb);
@@ -127,6 +129,7 @@ void cpts_unregister(struct cpts *cpts);
 struct cpts *cpts_create(struct device *dev, void __iomem *regs,
 			 struct device_node *node);
 void cpts_release(struct cpts *cpts);
+void cpts_misc_interrupt(struct cpts *cpts);
 
 static inline bool cpts_can_timestamp(struct cpts *cpts, struct sk_buff *skb)
 {
@@ -138,6 +141,11 @@ static inline bool cpts_can_timestamp(struct cpts *cpts, struct sk_buff *skb)
 	return true;
 }
 
+static inline void cpts_set_irqpoll(struct cpts *cpts, bool en)
+{
+	cpts->irq_poll = en;
+}
+
 #else
 struct cpts;
 
@@ -173,6 +181,14 @@ static inline bool cpts_can_timestamp(struct cpts *cpts, struct sk_buff *skb)
 {
 	return false;
 }
+
+static inline void cpts_misc_interrupt(struct cpts *cpts)
+{
+}
+
+static inline void cpts_set_irqpoll(struct cpts *cpts, bool en)
+{
+}
 #endif
 
 
-- 
2.17.1

