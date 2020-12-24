Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09B6E2E271C
	for <lists+netdev@lfdr.de>; Thu, 24 Dec 2020 14:14:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727778AbgLXNMe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Dec 2020 08:12:34 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:34942 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726544AbgLXNMd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Dec 2020 08:12:33 -0500
From:   "Ahmed S. Darwish" <a.darwish@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1608815511;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=TvNobAOXgUaUxeUOktLm8nVfhFlqbD/7mmuwOekg2Ck=;
        b=V5fhsFabHjfhFvk1l/6VpGj62n4oHO63kDs1Djnqfju5XN/4Uv8nRaR+ZDZ0mu9pv7zxdG
        uBMroYfUXuSAoim5SjtYoDbxvZgPYIt6LRlKFldN1kuB0HGI7M9RDgBqRAboIaT5tif7or
        I7piWVOyXzPL7pMfepSZjJc07vofD8VH6HjD2s+SwSaWB8fCsOtnDUEy4IKFjrZNgIVqNl
        B/rN8YXo5apy6895rdhqmuQqh9g1s6zJ8clI/rwzW3dpJIoIy4DG6oc4HKT9QT0l1Rl+bw
        hBL030dxhbmK62piBPatfVSjk59PjLCl+swGtDAHNvUR/lCxMMlfsJU50mObhw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1608815511;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=TvNobAOXgUaUxeUOktLm8nVfhFlqbD/7mmuwOekg2Ck=;
        b=12iMUtFHUZVpbaWtCf92xXB0pzMfftm74gs82EBUJoizkVkCfFtPnVBxW5tbM4ttYI7pkJ
        iFtk3r6KgrqmzeBA==
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
Subject: [RFC PATCH 0/3] chelsio: cxgb: Use threaded irqs
Date:   Thu, 24 Dec 2020 14:11:45 +0100
Message-Id: <20201224131148.300691-1-a.darwish@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Folks,

The t1_interrupt() irq handler calls del_timer_sync() down the chain:

   sge.c: t1_interrupt()
     -> subr.c: t1_slow_intr_handler()
       -> asic_slow_intr() || fpga_slow_intr()
         -> t1_pci_intr_handler()
 	  -> cxgb2.c: t1_fatal_err()		# Cont. at [*]
       -> fpga_slow_intr()
         -> sge.c: t1_sge_intr_error_handler()
 	  -> cxgb2.c: t1_fatal_err()		# Cont. at [*]

[*] cxgb2.c: t1_fatal_err()
      -> sge.c: t1_sge_stop()
        -> timer.c: del_timer_sync()

This is invalid: if an irq handler calls del_timer_sync() on a timer
it has already interrupted, it will just loop forever.  That's why
del_timer_sync() also has a WARN_ON(in_irq()).

Included is an RFC patch series that runs the interrupt handler slow
path, t1_slow_intr_handler(), in a threaded-irq context.

This also leads to nice code savings across the driver, as some
workqueues and spinlocks are no longer needed.

Note: Only compile-tested. I do not have the hardware in question.

Thanks,

8<--------------

Ahmed S. Darwish (3):
  chelsio: cxgb: Remove ndo_poll_controller()
  chelsio: cxgb: Move slow interrupt handling to threaded irqs
  chelsio: cxgb: Do not schedule a workqueue for external interrupts

 drivers/net/ethernet/chelsio/cxgb/common.h |  2 -
 drivers/net/ethernet/chelsio/cxgb/cxgb2.c  | 58 ++--------------------
 drivers/net/ethernet/chelsio/cxgb/sge.c    | 25 +++++++---
 drivers/net/ethernet/chelsio/cxgb/sge.h    |  3 +-
 drivers/net/ethernet/chelsio/cxgb/subr.c   |  2 +-
 5 files changed, 25 insertions(+), 65 deletions(-)

base-commit: 2c85ebc57b3e1817b6ce1a6b703928e113a90442
-- 
2.29.2

