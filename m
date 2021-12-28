Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B990480C8E
	for <lists+netdev@lfdr.de>; Tue, 28 Dec 2021 19:40:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237064AbhL1SkM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Dec 2021 13:40:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237060AbhL1SkL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Dec 2021 13:40:11 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E91BC061574;
        Tue, 28 Dec 2021 10:40:11 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1640716808;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XPuWFS2LRu0bJ7y/UPZbd1DHkOBoE3Cl/eUAuhfdAKU=;
        b=zYyRwapDcF+8airlB20kHJ5N1WQQRujSNdtUjgNpMkjwJEeZ6QrsvmtTrcrVm0Wg7rwt7B
        UEc5txeeOunIYHaHwIN0vjE0jQy1WmDMR5pQH76cjFNImCbNj1mKPFU/h7plVlN1Vg9x7f
        evKgt+a49P9OUK2NlqHGnwY52G+RNmQImPc0JQT3rC7MGjre6MbwIlpZImhDty1P71m5xS
        YSXvAQQHaHaxr3qUa7JGHHzskvzBuA6e4F7hqxJ58r10cqrt/xgxR7LfdTHWEhx9UfQ5xa
        TvweKcDkUGbyGJN9RZQ/BZjRH9oCRueAJqrhcSikI97OILWoB16H0w7m6ZaR+A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1640716808;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XPuWFS2LRu0bJ7y/UPZbd1DHkOBoE3Cl/eUAuhfdAKU=;
        b=LBeThSdJP5ohQmbtej/tAT1PCU/vl0dB8h/kqjQV53yWg5SBuHicbdIs4dXLonuwVcOuE1
        k0EB9jAMen3qnQAw==
To:     kernel test robot <oliver.sang@intel.com>
Cc:     Michael Kelley <mikelley@microsoft.com>,
        Nishanth Menon <nm@ti.com>, Jason Gunthorpe <jgg@nvidia.com>,
        LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        lkp@lists.01.org, lkp@intel.com,
        Heiner Kallweit <hkallweit1@gmail.com>, nic_swsd@realtek.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [genirq/msi]  495c66aca3:
 BUG:sleeping_function_called_from_invalid_context_at_kernel/locking/mutex.c
In-Reply-To: <20211227150535.GA16252@xsang-OptiPlex-9020>
References: <20211227150535.GA16252@xsang-OptiPlex-9020>
Date:   Tue, 28 Dec 2021 19:40:07 +0100
Message-ID: <87czlgd14o.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 27 2021 at 23:05, kernel test robot wrote:
>
> FYI, we noticed the following commit (built with gcc-9):
>
> commit: 495c66aca3da704e063fa373fdbe371e71d3f4ee ("genirq/msi: Convert to new functions")
> https://git.kernel.org/cgit/linux/kernel/git/tip/tip.git irq/msi
> kern  :err   : [  126.209306] BUG: sleeping function called from invalid context at kernel/locking/mutex.c:280
> kern  :err   : [  126.209308] in_atomic(): 1, irqs_disabled(): 1, non_block: 0, pid: 5183, name: ls
> kern  :err   : [  126.209311] preempt_count: 2, expected: 0
> kern  :warn  : [  126.209312] CPU: 2 PID: 5183 Comm: ls Not tainted 5.16.0-rc5-00091-g495c66aca3da #1
> kern  :warn  : [  126.209315] Hardware name: Hewlett-Packard HP Pro 3340 MT/17A1, BIOS 8.07 01/24/2013
> kern  :warn  : [  126.209316] Call Trace:
> kern  :warn  : [  126.209318]  <TASK>
> kern :warn : [  126.209319] dump_stack_lvl (lib/dump_stack.c:107) 
> kern :warn : [  126.209323] __might_resched.cold (kernel/sched/core.c:9539 kernel/sched/core.c:9492) 
> kern :warn : [  126.209326] ? kasan_unpoison (mm/kasan/shadow.c:108 mm/kasan/shadow.c:142) 
> kern :warn : [  126.209330] mutex_lock (kernel/locking/mutex.c:280) 
> kern :warn : [  126.209335] ? __mutex_lock_slowpath (kernel/locking/mutex.c:279) 
> kern :warn : [  126.209339] ? _raw_spin_lock_irqsave (arch/x86/include/asm/atomic.h:202 include/linux/atomic/atomic-instrumented.h:513 include/asm-generic/qspinlock.h:82 include/linux/spinlock.h:185 include/linux/spinlock_api_smp.h:111 kernel/locking/spinlock.c:162) 
> kern :warn : [  126.209342] ? _raw_read_unlock_irqrestore (kernel/locking/spinlock.c:161) 
> kern :warn : [  126.209344] msi_get_virq (kernel/irq/msi.c:332) 
> kern :warn : [  126.209349] pci_irq_vector (drivers/pci/msi/msi.c:1085 drivers/pci/msi/msi.c:1077) 
> kern :warn : [  126.209354] rtl8169_netpoll (drivers/net/ethernet/realtek/r8169_main.c:4722) 
> kern :warn : [  126.209358] netpoll_poll_dev (net/core/netpoll.c:166 net/core/netpoll.c:195) 
> kern :warn : [  126.209363] netpoll_send_skb (net/core/netpoll.c:350 net/core/netpoll.c:376) 
> kern :warn : [  126.209367] write_msg (drivers/net/netconsole.c:862 drivers/net/netconsole.c:836) netconsole

Fix below.

Thanks,

        tglx
---
 drivers/net/ethernet/realtek/r8169_main.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -615,6 +615,7 @@ struct rtl8169_private {
 	struct ring_info tx_skb[NUM_TX_DESC];	/* Tx data buffers */
 	u16 cp_cmd;
 	u32 irq_mask;
+	int irq;
 	struct clk *clk;
 
 	struct {
@@ -4698,7 +4699,7 @@ static int rtl8169_close(struct net_devi
 
 	cancel_work_sync(&tp->wk.work);
 
-	free_irq(pci_irq_vector(pdev, 0), tp);
+	free_irq(tp->irq, tp);
 
 	phy_disconnect(tp->phydev);
 
@@ -4719,7 +4720,7 @@ static void rtl8169_netpoll(struct net_d
 {
 	struct rtl8169_private *tp = netdev_priv(dev);
 
-	rtl8169_interrupt(pci_irq_vector(tp->pci_dev, 0), tp);
+	rtl8169_interrupt(tp->irq, tp);
 }
 #endif
 
@@ -4753,8 +4754,7 @@ static int rtl_open(struct net_device *d
 	rtl_request_firmware(tp);
 
 	irqflags = pci_dev_msi_enabled(pdev) ? IRQF_NO_THREAD : IRQF_SHARED;
-	retval = request_irq(pci_irq_vector(pdev, 0), rtl8169_interrupt,
-			     irqflags, dev->name, tp);
+	retval = request_irq(tp->irq, rtl8169_interrupt, irqflags, dev->name, tp);
 	if (retval < 0)
 		goto err_release_fw_2;
 
@@ -4771,7 +4771,7 @@ static int rtl_open(struct net_device *d
 	return retval;
 
 err_free_irq:
-	free_irq(pci_irq_vector(pdev, 0), tp);
+	free_irq(tp->irq, tp);
 err_release_fw_2:
 	rtl_release_firmware(tp);
 	rtl8169_rx_clear(tp);
@@ -5341,6 +5341,7 @@ static int rtl_init_one(struct pci_dev *
 		dev_err(&pdev->dev, "Can't allocate interrupt\n");
 		return rc;
 	}
+	tp->irq = pci_irq_vector(pdev, 0);
 
 	INIT_WORK(&tp->wk.work, rtl_task);
 
@@ -5416,8 +5417,7 @@ static int rtl_init_one(struct pci_dev *
 		return rc;
 
 	netdev_info(dev, "%s, %pM, XID %03x, IRQ %d\n",
-		    rtl_chip_infos[chipset].name, dev->dev_addr, xid,
-		    pci_irq_vector(pdev, 0));
+		    rtl_chip_infos[chipset].name, dev->dev_addr, xid, tp->irq);
 
 	if (jumbo_max)
 		netdev_info(dev, "jumbo features [frames: %d bytes, tx checksumming: %s]\n",
