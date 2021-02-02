Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10ACE30C6E5
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 18:06:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236994AbhBBRDp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 12:03:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237005AbhBBRBZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 12:01:25 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 831C2C061573
        for <netdev@vger.kernel.org>; Tue,  2 Feb 2021 09:01:10 -0800 (PST)
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1612285268;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=I/hW4eKh3LuQ1LGRV9oCAUHQ8lcOyoFwJEFURvd2bl8=;
        b=TI6BQ4zoyQkOELXNrAJ5dKq8Dfa32hK8bxeysmmh30mBw7KwntB6R6u+paaaNKcnJWbWq8
        IrbxNnEQvwzOUCfny3URCq+OzPO+bJJvfcW1+YGiGxwpGeeiBZH/+JeRQnS4Oic7uDV62h
        DdP3WTZFkXq9fj/g+i66l4YuAp33yRITtLwExSFiYMg4GxwGPX1BvRLcjW01OtDzIGj5aZ
        x3/npJXJgiSiejIP8HoAWnXSKwdikmAzeZl1adCY95PwB5orf7F/UdKIx9TsOJTyO6XIx9
        +2dLVb0BCfRt9a3FGQIMqkB5Q5OERdvLeiTVF0YIeBVcoD3z3oIqXLwLJICRMQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1612285268;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=I/hW4eKh3LuQ1LGRV9oCAUHQ8lcOyoFwJEFURvd2bl8=;
        b=LCKIuD+rpwYT5viYPOgs0z/pIeIc8XiZyry8Czh4YbmNEQBxwl4FI6g7oEcBdM4acRDuLv
        9/lRNw8rmGJIXuDw==
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Ahmed S. Darwish" <a.darwish@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 2/2] chelsio: cxgb: Disable the card on error in threaded interrupt
Date:   Tue,  2 Feb 2021 18:01:04 +0100
Message-Id: <20210202170104.1909200-3-bigeasy@linutronix.de>
In-Reply-To: <20210202170104.1909200-1-bigeasy@linutronix.de>
References: <20210202170104.1909200-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

t1_fatal_err() is invoked from the interrupt handler. The bad part is
that it invokes (via t1_sge_stop()) del_timer_sync() and tasklet_kill().
Both functions must not be called from an interrupt because it is
possible that it will wait for the completion of the timer/tasklet it
just interrupted.

In case of a fatal error, use t1_interrupts_disable() to disable all
interrupt sources and then wake the interrupt thread with
F_PL_INTR_SGE_ERR as pending flag. The threaded-interrupt will stop the
card via t1_sge_stop() and not re-enable the interrupts again.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/net/ethernet/chelsio/cxgb/common.h |  1 -
 drivers/net/ethernet/chelsio/cxgb/cxgb2.c  | 10 ------
 drivers/net/ethernet/chelsio/cxgb/sge.c    | 20 +++++++++---
 drivers/net/ethernet/chelsio/cxgb/sge.h    |  2 +-
 drivers/net/ethernet/chelsio/cxgb/subr.c   | 38 +++++++++++++++-------
 5 files changed, 44 insertions(+), 27 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb/common.h b/drivers/net/ether=
net/chelsio/cxgb/common.h
index e999a9b9fe6cc..0321be77366c4 100644
--- a/drivers/net/ethernet/chelsio/cxgb/common.h
+++ b/drivers/net/ethernet/chelsio/cxgb/common.h
@@ -346,7 +346,6 @@ int t1_get_board_rev(adapter_t *adapter, const struct b=
oard_info *bi,
 int t1_init_hw_modules(adapter_t *adapter);
 int t1_init_sw_modules(adapter_t *adapter, const struct board_info *bi);
 void t1_free_sw_modules(adapter_t *adapter);
-void t1_fatal_err(adapter_t *adapter);
 void t1_link_changed(adapter_t *adapter, int port_id);
 void t1_link_negotiated(adapter_t *adapter, int port_id, int link_stat,
 			    int speed, int duplex, int pause);
diff --git a/drivers/net/ethernet/chelsio/cxgb/cxgb2.c b/drivers/net/ethern=
et/chelsio/cxgb/cxgb2.c
index bd6f3c532d72e..512da98019c66 100644
--- a/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
+++ b/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
@@ -917,16 +917,6 @@ static void mac_stats_task(struct work_struct *work)
 	spin_unlock(&adapter->work_lock);
 }
=20
-void t1_fatal_err(struct adapter *adapter)
-{
-	if (adapter->flags & FULL_INIT_DONE) {
-		t1_sge_stop(adapter->sge);
-		t1_interrupts_disable(adapter);
-	}
-	pr_alert("%s: encountered fatal error, operation suspended\n",
-		 adapter->name);
-}
-
 static const struct net_device_ops cxgb_netdev_ops =3D {
 	.ndo_open		=3D cxgb_open,
 	.ndo_stop		=3D cxgb_close,
diff --git a/drivers/net/ethernet/chelsio/cxgb/sge.c b/drivers/net/ethernet=
/chelsio/cxgb/sge.c
index 5aef9ae1ecfed..cda01f22c71c8 100644
--- a/drivers/net/ethernet/chelsio/cxgb/sge.c
+++ b/drivers/net/ethernet/chelsio/cxgb/sge.c
@@ -940,10 +940,11 @@ void t1_sge_intr_clear(struct sge *sge)
 /*
  * SGE 'Error' interrupt handler
  */
-int t1_sge_intr_error_handler(struct sge *sge)
+bool t1_sge_intr_error_handler(struct sge *sge)
 {
 	struct adapter *adapter =3D sge->adapter;
 	u32 cause =3D readl(adapter->regs + A_SG_INT_CAUSE);
+	bool wake =3D false;
=20
 	if (adapter->port[0].dev->hw_features & NETIF_F_TSO)
 		cause &=3D ~F_PACKET_TOO_BIG;
@@ -967,11 +968,14 @@ int t1_sge_intr_error_handler(struct sge *sge)
 		sge->stats.pkt_mismatch++;
 		pr_alert("%s: SGE packet mismatch\n", adapter->name);
 	}
-	if (cause & SGE_INT_FATAL)
-		t1_fatal_err(adapter);
+	if (cause & SGE_INT_FATAL) {
+		t1_interrupts_disable(adapter);
+		adapter->pending_thread_intr |=3D F_PL_INTR_SGE_ERR;
+		wake =3D true;
+	}
=20
 	writel(cause, adapter->regs + A_SG_INT_CAUSE);
-	return 0;
+	return wake;
 }
=20
 const struct sge_intr_counts *t1_sge_get_intr_counts(const struct sge *sge)
@@ -1635,6 +1639,14 @@ irqreturn_t t1_interrupt_thread(int irq, void *data)
 	if (pending_thread_intr & F_PL_INTR_EXT)
 		t1_elmer0_ext_intr_handler(adapter);
=20
+	/* This error is fatal, interrupts remain off */
+	if (pending_thread_intr & F_PL_INTR_SGE_ERR) {
+		pr_alert("%s: encountered fatal error, operation suspended\n",
+			 adapter->name);
+		t1_sge_stop(adapter->sge);
+		return IRQ_HANDLED;
+	}
+
 	spin_lock_irq(&adapter->async_lock);
 	adapter->slow_intr_mask |=3D F_PL_INTR_EXT;
=20
diff --git a/drivers/net/ethernet/chelsio/cxgb/sge.h b/drivers/net/ethernet=
/chelsio/cxgb/sge.h
index 76516d2a8aa9e..716705b96f265 100644
--- a/drivers/net/ethernet/chelsio/cxgb/sge.h
+++ b/drivers/net/ethernet/chelsio/cxgb/sge.h
@@ -82,7 +82,7 @@ netdev_tx_t t1_start_xmit(struct sk_buff *skb, struct net=
_device *dev);
 void t1_vlan_mode(struct adapter *adapter, netdev_features_t features);
 void t1_sge_start(struct sge *);
 void t1_sge_stop(struct sge *);
-int t1_sge_intr_error_handler(struct sge *);
+bool t1_sge_intr_error_handler(struct sge *sge);
 void t1_sge_intr_enable(struct sge *);
 void t1_sge_intr_disable(struct sge *);
 void t1_sge_intr_clear(struct sge *);
diff --git a/drivers/net/ethernet/chelsio/cxgb/subr.c b/drivers/net/etherne=
t/chelsio/cxgb/subr.c
index d90ad07ff1a40..310add28fcf59 100644
--- a/drivers/net/ethernet/chelsio/cxgb/subr.c
+++ b/drivers/net/ethernet/chelsio/cxgb/subr.c
@@ -170,7 +170,7 @@ void t1_link_changed(adapter_t *adapter, int port_id)
 	t1_link_negotiated(adapter, port_id, link_ok, speed, duplex, fc);
 }
=20
-static int t1_pci_intr_handler(adapter_t *adapter)
+static bool t1_pci_intr_handler(adapter_t *adapter)
 {
 	u32 pcix_cause;
=20
@@ -179,9 +179,13 @@ static int t1_pci_intr_handler(adapter_t *adapter)
 	if (pcix_cause) {
 		pci_write_config_dword(adapter->pdev, A_PCICFG_INTR_CAUSE,
 				       pcix_cause);
-		t1_fatal_err(adapter);    /* PCI errors are fatal */
+		/* PCI errors are fatal */
+		t1_interrupts_disable(adapter);
+		adapter->pending_thread_intr |=3D F_PL_INTR_SGE_ERR;
+		pr_alert("%s: PCI error encountered.\n", adapter->name);
+		return true;
 	}
-	return 0;
+	return false;
 }
=20
 #ifdef CONFIG_CHELSIO_T1_1G
@@ -213,10 +217,13 @@ static int fpga_phy_intr_handler(adapter_t *adapter)
 static irqreturn_t fpga_slow_intr(adapter_t *adapter)
 {
 	u32 cause =3D readl(adapter->regs + A_PL_CAUSE);
+	irqreturn_t ret =3D IRQ_NONE;
=20
 	cause &=3D ~F_PL_INTR_SGE_DATA;
-	if (cause & F_PL_INTR_SGE_ERR)
-		t1_sge_intr_error_handler(adapter->sge);
+	if (cause & F_PL_INTR_SGE_ERR) {
+		if (t1_sge_intr_error_handler(adapter->sge))
+			ret =3D IRQ_WAKE_THREAD;
+	}
=20
 	if (cause & FPGA_PCIX_INTERRUPT_GMAC)
 		fpga_phy_intr_handler(adapter);
@@ -231,13 +238,18 @@ static irqreturn_t fpga_slow_intr(adapter_t *adapter)
 		/* Clear TP interrupt */
 		writel(tp_cause, adapter->regs + FPGA_TP_ADDR_INTERRUPT_CAUSE);
 	}
-	if (cause & FPGA_PCIX_INTERRUPT_PCIX)
-		t1_pci_intr_handler(adapter);
+	if (cause & FPGA_PCIX_INTERRUPT_PCIX) {
+		if (t1_pci_intr_handler(adapter))
+			ret =3D IRQ_WAKE_THREAD;
+	}
=20
 	/* Clear the interrupts just processed. */
 	if (cause)
 		writel(cause, adapter->regs + A_PL_CAUSE);
=20
+	if (ret !=3D IRQ_NONE)
+		return ret;
+
 	return cause =3D=3D 0 ? IRQ_NONE : IRQ_HANDLED;
 }
 #endif
@@ -850,14 +862,18 @@ static irqreturn_t asic_slow_intr(adapter_t *adapter)
 	cause &=3D adapter->slow_intr_mask;
 	if (!cause)
 		return IRQ_NONE;
-	if (cause & F_PL_INTR_SGE_ERR)
-		t1_sge_intr_error_handler(adapter->sge);
+	if (cause & F_PL_INTR_SGE_ERR) {
+		if (t1_sge_intr_error_handler(adapter->sge))
+			ret =3D IRQ_WAKE_THREAD;
+	}
 	if (cause & F_PL_INTR_TP)
 		t1_tp_intr_handler(adapter->tp);
 	if (cause & F_PL_INTR_ESPI)
 		t1_espi_intr_handler(adapter->espi);
-	if (cause & F_PL_INTR_PCIX)
-		t1_pci_intr_handler(adapter);
+	if (cause & F_PL_INTR_PCIX) {
+		if (t1_pci_intr_handler(adapter))
+			ret =3D IRQ_WAKE_THREAD;
+	}
 	if (cause & F_PL_INTR_EXT) {
 		/* Wake the threaded interrupt to handle external interrupts as
 		 * we require a process context. We disable EXT interrupts in
--=20
2.30.0

