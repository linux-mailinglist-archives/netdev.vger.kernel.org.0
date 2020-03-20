Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2643118D8A3
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 20:44:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727453AbgCTTnv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 15:43:51 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:35520 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727152AbgCTTnu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 15:43:50 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 02KJhke0087110;
        Fri, 20 Mar 2020 14:43:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1584733426;
        bh=fzwuA7g8VxNtMy5dJexB4FjYoDjtVoLMp9r2PmfqFn0=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=Q8xsLfs+6ColkMMYV0dQ66vGpDpVTa14nLQ0Oya/DxPlMnO8j+k0HC+a9r+1nZD67
         tZnXxLU7+c4ny0yiqyFmtu7ki6UCXKVx2TWq5tzsJ6fomeRQabqLB9O/7I4xYItWf5
         BXyDlu3tV9p1osfqS9B48pUm2dNEDXkTaiTu7LeE=
Received: from DLEE113.ent.ti.com (dlee113.ent.ti.com [157.170.170.24])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 02KJhkRM117688
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 20 Mar 2020 14:43:46 -0500
Received: from DLEE103.ent.ti.com (157.170.170.33) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Fri, 20
 Mar 2020 14:43:46 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE103.ent.ti.com
 (157.170.170.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Fri, 20 Mar 2020 14:43:46 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 02KJhj5b043429;
        Fri, 20 Mar 2020 14:43:46 -0500
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
Subject: [PATCH net-next v3 09/11] net: ethernet: ti: cpts: add irq support
Date:   Fri, 20 Mar 2020 21:42:42 +0200
Message-ID: <20200320194244.4703-10-grygorii.strashko@ti.com>
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

Add CPTS IRQ support, but do not enable it. By default, the CPTS driver
will continue working using polling mode which is required for CPTS to
continue working on platforms other than CPSW, like Keystone 2.

The CPTS IRQ support is required to enable support for HW_TS_PUSH events.
The CPSW CPTS IRQ and HW_TS_PUSH events support will be enabled in follow
up patches.

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 drivers/net/ethernet/ti/cpts.c | 22 +++++++++++++++++++++-
 drivers/net/ethernet/ti/cpts.h | 16 ++++++++++++++++
 2 files changed, 37 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ti/cpts.c b/drivers/net/ethernet/ti/cpts.c
index fe70eb677b88..187fd1398b7e 100644
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
@@ -154,9 +158,17 @@ static int cpts_fifo_read(struct cpts *cpts, int match)
 
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
@@ -169,6 +181,8 @@ static void cpts_update_cur_time(struct cpts *cpts, int match,
 {
 	unsigned long flags;
 
+	reinit_completion(&cpts->ts_push_complete);
+
 	/* use spin_lock_irqsave() here as it has to run very fast */
 	spin_lock_irqsave(&cpts->lock, flags);
 	ptp_read_system_prets(sts);
@@ -177,8 +191,12 @@ static void cpts_update_cur_time(struct cpts *cpts, int match,
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
@@ -744,8 +762,10 @@ struct cpts *cpts_create(struct device *dev, void __iomem *regs,
 
 	cpts->dev = dev;
 	cpts->reg = (struct cpsw_cpts __iomem *)regs;
+	cpts->irq_poll = true;
 	spin_lock_init(&cpts->lock);
 	mutex_init(&cpts->ptp_clk_mutex);
+	init_completion(&cpts->ts_push_complete);
 
 	ret = cpts_of_parse(cpts, node);
 	if (ret)
diff --git a/drivers/net/ethernet/ti/cpts.h b/drivers/net/ethernet/ti/cpts.h
index d6069198e059..e18cb5e436fe 100644
--- a/drivers/net/ethernet/ti/cpts.h
+++ b/drivers/net/ethernet/ti/cpts.h
@@ -119,6 +119,8 @@ struct cpts {
 	u64 cur_timestamp;
 	u32 mult_new;
 	struct mutex ptp_clk_mutex; /* sync PTP interface and worker */
+	bool irq_poll;
+	struct completion	ts_push_complete;
 };
 
 int cpts_rx_timestamp(struct cpts *cpts, struct sk_buff *skb);
@@ -128,6 +130,7 @@ void cpts_unregister(struct cpts *cpts);
 struct cpts *cpts_create(struct device *dev, void __iomem *regs,
 			 struct device_node *node);
 void cpts_release(struct cpts *cpts);
+void cpts_misc_interrupt(struct cpts *cpts);
 
 static inline bool cpts_can_timestamp(struct cpts *cpts, struct sk_buff *skb)
 {
@@ -139,6 +142,11 @@ static inline bool cpts_can_timestamp(struct cpts *cpts, struct sk_buff *skb)
 	return true;
 }
 
+static inline void cpts_set_irqpoll(struct cpts *cpts, bool en)
+{
+	cpts->irq_poll = en;
+}
+
 #else
 struct cpts;
 
@@ -175,6 +183,14 @@ static inline bool cpts_can_timestamp(struct cpts *cpts, struct sk_buff *skb)
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

