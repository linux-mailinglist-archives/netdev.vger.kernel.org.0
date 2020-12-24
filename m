Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB8AB2E2720
	for <lists+netdev@lfdr.de>; Thu, 24 Dec 2020 14:14:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728617AbgLXNMn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Dec 2020 08:12:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728033AbgLXNMm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Dec 2020 08:12:42 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D607C06179C;
        Thu, 24 Dec 2020 05:12:02 -0800 (PST)
From:   "Ahmed S. Darwish" <a.darwish@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1608815520;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lBDOCKglDXmif54I2pfmPNcQyX8qyatSURp7VxqOhMk=;
        b=arEgpHKBs+L70LiTkUD12jqDDK1l23p4R1XS2q1cVYN4KDlXiidBIGdYcTAkmG/GG6zrJv
        GwIvdAFEsibvlk2y1dpjCwB2gdVXV27SfWUksZQ4RrNHusL4s0ap68NF5e3CFg2Wl3KEzm
        xT4j3tZclhVirJ5FXWuJuIICWub1L6j7J0wC8+Jf5jsXTYTivPNRt9jP6ct8Oj4zxJjTPM
        q6CH8mey93mckQ+CE5xy61SmeWlB66VIKescLMX9e0/1uuxjMVd3oHbJlBpZLSePSmbw7h
        8AHc23aZoSU5dAXFfUD5keLsNEoviNaUh6dXosRJZEJSeyYdpzfn3xGabu+dUA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1608815520;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lBDOCKglDXmif54I2pfmPNcQyX8qyatSURp7VxqOhMk=;
        b=HT89WNrzUhYXl+/Nof0Dmnl7S7COH+g/QbUVgnjrnhxv9s67uJLybKXjBKfrbsZkFloAUq
        L1pSXc9XCY4rfoDg==
To:     Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>,
        Rohit Maheshwari <rohitm@chelsio.com>,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>,
        Vishal Kulkarni <vishal@chelsio.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Sebastian A. Siewior" <bigeasy@linutronix.de>,
        "Ahmed S. Darwish" <a.darwish@linutronix.de>
Subject: [RFC PATCH 2/3] chelsio: cxgb: Move slow interrupt handling to threaded irqs
Date:   Thu, 24 Dec 2020 14:11:47 +0100
Message-Id: <20201224131148.300691-3-a.darwish@linutronix.de>
In-Reply-To: <20201224131148.300691-1-a.darwish@linutronix.de>
References: <20201224131148.300691-1-a.darwish@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The t1_interrupt() irq handler calls del_timer_sync() down the chain:

   sge.c: t1_interrupt()
     -> subr.c: t1_slow_intr_handler()
       -> asic_slow_intr() || fpga_slow_intr()
         -> t1_pci_intr_handler()
           -> cxgb2.c: t1_fatal_err()           # Cont. at [*]
       -> fpga_slow_intr()
         -> sge.c: t1_sge_intr_error_handler()
           -> cxgb2.c: t1_fatal_err()           # Cont. at [*]

[*] cxgb2.c: t1_fatal_err()
      -> sge.c: t1_sge_stop()
        -> timer.c: del_timer_sync()

This is invalid: if an irq handler calls del_timer_sync() on a timer it
has already interrupted, it will loop forever.

Move the slow t1 interrupt handling path, t1_slow_intr_handler(), to a
threaded-irq task context.

Signed-off-by: Ahmed S. Darwish <a.darwish@linutronix.de>
---
 drivers/net/ethernet/chelsio/cxgb/cxgb2.c |  6 +++---
 drivers/net/ethernet/chelsio/cxgb/sge.c   | 13 +++++++++++--
 drivers/net/ethernet/chelsio/cxgb/sge.h   |  3 ++-
 3 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb/cxgb2.c b/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
index 7b5a98330ef7..c96bdca4f270 100644
--- a/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
+++ b/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
@@ -211,9 +211,9 @@ static int cxgb_up(struct adapter *adapter)
 	t1_interrupts_clear(adapter);
 
 	adapter->params.has_msi = !disable_msi && !pci_enable_msi(adapter->pdev);
-	err = request_irq(adapter->pdev->irq, t1_interrupt,
-			  adapter->params.has_msi ? 0 : IRQF_SHARED,
-			  adapter->name, adapter);
+	err = request_threaded_irq(adapter->pdev->irq, t1_irq, t1_irq_thread,
+				   adapter->params.has_msi ? 0 : IRQF_SHARED,
+				   adapter->name, adapter);
 	if (err) {
 		if (adapter->params.has_msi)
 			pci_disable_msi(adapter->pdev);
diff --git a/drivers/net/ethernet/chelsio/cxgb/sge.c b/drivers/net/ethernet/chelsio/cxgb/sge.c
index d6df1a87db0b..f1c402f6b889 100644
--- a/drivers/net/ethernet/chelsio/cxgb/sge.c
+++ b/drivers/net/ethernet/chelsio/cxgb/sge.c
@@ -1626,11 +1626,10 @@ int t1_poll(struct napi_struct *napi, int budget)
 	return work_done;
 }
 
-irqreturn_t t1_interrupt(int irq, void *data)
+irqreturn_t t1_irq(int irq, void *data)
 {
 	struct adapter *adapter = data;
 	struct sge *sge = adapter->sge;
-	int handled;
 
 	if (likely(responses_pending(adapter))) {
 		writel(F_PL_INTR_SGE_DATA, adapter->regs + A_PL_CAUSE);
@@ -1645,9 +1644,19 @@ irqreturn_t t1_interrupt(int irq, void *data)
 				napi_enable(&adapter->napi);
 			}
 		}
+
 		return IRQ_HANDLED;
 	}
 
+	return IRQ_WAKE_THREAD;
+}
+
+irqreturn_t t1_irq_thread(int irq, void *data)
+{
+	struct adapter *adapter = data;
+	struct sge *sge = adapter->sge;
+	int handled;
+
 	spin_lock(&adapter->async_lock);
 	handled = t1_slow_intr_handler(adapter);
 	spin_unlock(&adapter->async_lock);
diff --git a/drivers/net/ethernet/chelsio/cxgb/sge.h b/drivers/net/ethernet/chelsio/cxgb/sge.h
index a1ba591b3431..4072b3fb312b 100644
--- a/drivers/net/ethernet/chelsio/cxgb/sge.h
+++ b/drivers/net/ethernet/chelsio/cxgb/sge.h
@@ -74,7 +74,8 @@ struct sge *t1_sge_create(struct adapter *, struct sge_params *);
 int t1_sge_configure(struct sge *, struct sge_params *);
 int t1_sge_set_coalesce_params(struct sge *, struct sge_params *);
 void t1_sge_destroy(struct sge *);
-irqreturn_t t1_interrupt(int irq, void *cookie);
+irqreturn_t t1_irq(int irq, void *cookie);
+irqreturn_t t1_irq_thread(int irq, void *cookie);
 int t1_poll(struct napi_struct *, int);
 
 netdev_tx_t t1_start_xmit(struct sk_buff *skb, struct net_device *dev);
-- 
2.29.2

