Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D727039A746
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 19:10:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232214AbhFCRKv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 13:10:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:42436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232093AbhFCRKl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 13:10:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2F548613F6;
        Thu,  3 Jun 2021 17:08:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622740136;
        bh=Fc+crT+MQ7uPWXUWq37Qz0Bxk9fUg9q6YScfSXTxNFs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IbEd0+L1+8qNh4Vv+GEBU7Bw9lDHwINzbEQi51x9W/M0hjs1zm/Nr1XqF3P9DAm5x
         T5YbO4lOUSyHyPn45sBhJvFgmD8MlNNaoCu3z5xJLnGMjKQrkmYCBRmaOUrZU9TYHE
         cDpdUgFbaSHNGEij3EErtsoUnB7zpEX7QLSjh5DeUOXrig4uUHFrmG0PmmQF2w6Kom
         qvIyKUpN2UkrqhKq5epIuK8MVbYVPBgV+1rTDnyBdhFWnGQZltPb9U8P8OdGv6AM/d
         f7uJKfpJpxCbucozlmWyh5NcoVWqG2m/2M28cTOeAbsWm3Sd1AmenGDP+Z4CzYf2pW
         blvg+B6RGHhgQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zheyu Ma <zheyuma97@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 22/39] net/qla3xxx: fix schedule while atomic in ql_sem_spinlock
Date:   Thu,  3 Jun 2021 13:08:12 -0400
Message-Id: <20210603170829.3168708-22-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210603170829.3168708-1-sashal@kernel.org>
References: <20210603170829.3168708-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zheyu Ma <zheyuma97@gmail.com>

[ Upstream commit 13a6f3153922391e90036ba2267d34eed63196fc ]

When calling the 'ql_sem_spinlock', the driver has already acquired the
spin lock, so the driver should not call 'ssleep' in atomic context.

This bug can be fixed by using 'mdelay' instead of 'ssleep'.

The KASAN's log reveals it:

[    3.238124 ] BUG: scheduling while atomic: swapper/0/1/0x00000002
[    3.238748 ] 2 locks held by swapper/0/1:
[    3.239151 ]  #0: ffff88810177b240 (&dev->mutex){....}-{3:3}, at:
__device_driver_lock+0x41/0x60
[    3.240026 ]  #1: ffff888107c60e28 (&qdev->hw_lock){....}-{2:2}, at:
ql3xxx_probe+0x2aa/0xea0
[    3.240873 ] Modules linked in:
[    3.241187 ] irq event stamp: 460854
[    3.241541 ] hardirqs last  enabled at (460853): [<ffffffff843051bf>]
_raw_spin_unlock_irqrestore+0x4f/0x70
[    3.242245 ] hardirqs last disabled at (460854): [<ffffffff843058ca>]
_raw_spin_lock_irqsave+0x2a/0x70
[    3.242245 ] softirqs last  enabled at (446076): [<ffffffff846002e4>]
__do_softirq+0x2e4/0x4b1
[    3.242245 ] softirqs last disabled at (446069): [<ffffffff811ba5e0>]
irq_exit_rcu+0x100/0x110
[    3.242245 ] Preemption disabled at:
[    3.242245 ] [<ffffffff828ca5ba>] ql3xxx_probe+0x2aa/0xea0
[    3.242245 ] Kernel panic - not syncing: scheduling while atomic
[    3.242245 ] CPU: 2 PID: 1 Comm: swapper/0 Not tainted
5.13.0-rc1-00145
-gee7dc339169-dirty #16
[    3.242245 ] Call Trace:
[    3.242245 ]  dump_stack+0xba/0xf5
[    3.242245 ]  ? ql3xxx_probe+0x1f0/0xea0
[    3.242245 ]  panic+0x15a/0x3f2
[    3.242245 ]  ? vprintk+0x76/0x150
[    3.242245 ]  ? ql3xxx_probe+0x2aa/0xea0
[    3.242245 ]  __schedule_bug+0xae/0xe0
[    3.242245 ]  __schedule+0x72e/0xa00
[    3.242245 ]  schedule+0x43/0xf0
[    3.242245 ]  schedule_timeout+0x28b/0x500
[    3.242245 ]  ? del_timer_sync+0xf0/0xf0
[    3.242245 ]  ? msleep+0x2f/0x70
[    3.242245 ]  msleep+0x59/0x70
[    3.242245 ]  ql3xxx_probe+0x307/0xea0
[    3.242245 ]  ? _raw_spin_unlock_irqrestore+0x3a/0x70
[    3.242245 ]  ? pci_device_remove+0x110/0x110
[    3.242245 ]  local_pci_probe+0x45/0xa0
[    3.242245 ]  pci_device_probe+0x12b/0x1d0
[    3.242245 ]  really_probe+0x2a9/0x610
[    3.242245 ]  driver_probe_device+0x90/0x1d0
[    3.242245 ]  ? mutex_lock_nested+0x1b/0x20
[    3.242245 ]  device_driver_attach+0x68/0x70
[    3.242245 ]  __driver_attach+0x124/0x1b0
[    3.242245 ]  ? device_driver_attach+0x70/0x70
[    3.242245 ]  bus_for_each_dev+0xbb/0x110
[    3.242245 ]  ? rdinit_setup+0x45/0x45
[    3.242245 ]  driver_attach+0x27/0x30
[    3.242245 ]  bus_add_driver+0x1eb/0x2a0
[    3.242245 ]  driver_register+0xa9/0x180
[    3.242245 ]  __pci_register_driver+0x82/0x90
[    3.242245 ]  ? yellowfin_init+0x25/0x25
[    3.242245 ]  ql3xxx_driver_init+0x23/0x25
[    3.242245 ]  do_one_initcall+0x7f/0x3d0
[    3.242245 ]  ? rdinit_setup+0x45/0x45
[    3.242245 ]  ? rcu_read_lock_sched_held+0x4f/0x80
[    3.242245 ]  kernel_init_freeable+0x2aa/0x301
[    3.242245 ]  ? rest_init+0x2c0/0x2c0
[    3.242245 ]  kernel_init+0x18/0x190
[    3.242245 ]  ? rest_init+0x2c0/0x2c0
[    3.242245 ]  ? rest_init+0x2c0/0x2c0
[    3.242245 ]  ret_from_fork+0x1f/0x30
[    3.242245 ] Dumping ftrace buffer:
[    3.242245 ]    (ftrace buffer empty)
[    3.242245 ] Kernel Offset: disabled
[    3.242245 ] Rebooting in 1 seconds.

Reported-by: Zheyu Ma <zheyuma97@gmail.com>
Signed-off-by: Zheyu Ma <zheyuma97@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qlogic/qla3xxx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qla3xxx.c b/drivers/net/ethernet/qlogic/qla3xxx.c
index 27740c027681..a83b3d69a656 100644
--- a/drivers/net/ethernet/qlogic/qla3xxx.c
+++ b/drivers/net/ethernet/qlogic/qla3xxx.c
@@ -114,7 +114,7 @@ static int ql_sem_spinlock(struct ql3_adapter *qdev,
 		value = readl(&port_regs->CommonRegs.semaphoreReg);
 		if ((value & (sem_mask >> 16)) == sem_bits)
 			return 0;
-		ssleep(1);
+		mdelay(1000);
 	} while (--seconds);
 	return -1;
 }
-- 
2.30.2

