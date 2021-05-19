Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5056A3887CA
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 08:50:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236544AbhESGvL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 02:51:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230430AbhESGvK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 02:51:10 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C75DC06175F;
        Tue, 18 May 2021 23:49:50 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id b13-20020a17090a8c8db029015cd97baea9so3039097pjo.0;
        Tue, 18 May 2021 23:49:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Ke3rCeopQC48N/sAApf8Z/wYgsgJDBopJ4PY/hN3Do0=;
        b=ilo4LRoA2zSTUfzZjMyP/gVqfsIWoLxJ2xnWTU3ej5w1z8fFcEAW1D3PC3najpt8Er
         u+kBwUx6q9QMHWu1II+KKX8iY6cfiSKklFdT/n+ebpwB5y29mUOMTId3oDlKqpReIW+T
         iEA6ITTCrSlxdwtAJEbSY+hpxpXbJe3fGgz5KQyYiuFpKahiw9YccviXUAvbuFJDhQ87
         1TbBJLPKNCdHGBdI3kLhr4pXO/L+fpyrXrfbB4taqdELYDUFHRTsNWVs4ZYRVyO2MkTa
         +ZdKdv923DPwN94PNSxrrV0Nmm+XsiXwbN3BTuo7iPrgr3HZlvCWQ7u52zm6DLzBN6BL
         LKKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Ke3rCeopQC48N/sAApf8Z/wYgsgJDBopJ4PY/hN3Do0=;
        b=HKt4+X2uk/otKbaFZAVXnGhVwcSjMWj51RBiKocPimiHMErH3V7P+bvyeSE0IpugKC
         KsXeqyIDqQXqp9SIWLvNCDO58CYoEANFlnZrKxGGCqVp13ekRHZPI6mPerzQ1NdQjjVR
         LCAFFBCt0p7kOSkLy0WLhgmcRs8Vti03xBPp8FvLjRcdM6wj/dXS3B4zN63Sp4+wak3w
         TEHSvsuLldoFgGO2Hld2wLD1TJz2pHAKUYaAeXehfRsxYmkY9xTOLTRVByPZuP+0vdld
         TtUNhv2hRr1bIbNVKTWKkq5sxcmeqbZ+kOiAvwaR4viWhAiPZ/KNfQkFcUCK495ccjKK
         TqZw==
X-Gm-Message-State: AOAM530N57+irL/VHZDEiarbB0m969KoTo8DHw5nsjC9YolNmL2MMzN6
        UWgu/Dd0D98JRLWjpZlhiJPQWuCQzrrW
X-Google-Smtp-Source: ABdhPJx60bfODL43YkLSnhi2dbJP4gxz6I0sG5Kt3jkTqhPrwy23//ZKbuJik5bbpM4Lm4JvoikPCw==
X-Received: by 2002:a17:902:cec5:b029:f0:b123:44b2 with SMTP id d5-20020a170902cec5b02900f0b12344b2mr9101513plg.55.1621406989792;
        Tue, 18 May 2021 23:49:49 -0700 (PDT)
Received: from vultr.guest ([107.191.53.97])
        by smtp.gmail.com with ESMTPSA id v24sm10618667pfn.101.2021.05.18.23.49.48
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 May 2021 23:49:49 -0700 (PDT)
From:   Zheyu Ma <zheyuma97@gmail.com>
To:     GR-Linux-NIC-Dev@marvell.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        zheyuma97@gmail.com
Subject: [PATCH] net/qla3xxx: fix schedule while atomic in ql_sem_spinlock
Date:   Wed, 19 May 2021 06:49:14 +0000
Message-Id: <1621406954-1130-1-git-send-email-zheyuma97@gmail.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When calling the 'ql_sem_spinlock', the driver has already acquired the
spin lock, so the driver should not call 'ssleep' in atomic context.

This bug can be fixed by unlocking before calling 'ssleep'.

The KASAN's log reveals it:

[    3.238124] BUG: scheduling while atomic: swapper/0/1/0x00000002
[    3.238748] 2 locks held by swapper/0/1:
[    3.239151]  #0: ffff88810177b240 (&dev->mutex){....}-{3:3}, at:
__device_driver_lock+0x41/0x60
[    3.240026]  #1: ffff888107c60e28 (&qdev->hw_lock){....}-{2:2}, at:
ql3xxx_probe+0x2aa/0xea0
[    3.240873] Modules linked in:
[    3.241187] irq event stamp: 460854
[    3.241541] hardirqs last  enabled at (460853): [<ffffffff843051bf>]
_raw_spin_unlock_irqrestore+0x4f/0x70
[    3.242245] hardirqs last disabled at (460854): [<ffffffff843058ca>]
_raw_spin_lock_irqsave+0x2a/0x70
[    3.242245] softirqs last  enabled at (446076): [<ffffffff846002e4>]
__do_softirq+0x2e4/0x4b1
[    3.242245] softirqs last disabled at (446069): [<ffffffff811ba5e0>]
irq_exit_rcu+0x100/0x110
[    3.242245] Preemption disabled at:
[    3.242245] [<ffffffff828ca5ba>] ql3xxx_probe+0x2aa/0xea0
[    3.242245] Kernel panic - not syncing: scheduling while atomic
[    3.242245] CPU: 2 PID: 1 Comm: swapper/0 Not tainted 5.13.0-rc1-00145
-gee7dc339169-dirty #16
[    3.242245] Call Trace:
[    3.242245]  dump_stack+0xba/0xf5
[    3.242245]  ? ql3xxx_probe+0x1f0/0xea0
[    3.242245]  panic+0x15a/0x3f2
[    3.242245]  ? vprintk+0x76/0x150
[    3.242245]  ? ql3xxx_probe+0x2aa/0xea0
[    3.242245]  __schedule_bug+0xae/0xe0
[    3.242245]  __schedule+0x72e/0xa00
[    3.242245]  schedule+0x43/0xf0
[    3.242245]  schedule_timeout+0x28b/0x500
[    3.242245]  ? del_timer_sync+0xf0/0xf0
[    3.242245]  ? msleep+0x2f/0x70
[    3.242245]  msleep+0x59/0x70
[    3.242245]  ql3xxx_probe+0x307/0xea0
[    3.242245]  ? _raw_spin_unlock_irqrestore+0x3a/0x70
[    3.242245]  ? pci_device_remove+0x110/0x110
[    3.242245]  local_pci_probe+0x45/0xa0
[    3.242245]  pci_device_probe+0x12b/0x1d0
[    3.242245]  really_probe+0x2a9/0x610
[    3.242245]  driver_probe_device+0x90/0x1d0
[    3.242245]  ? mutex_lock_nested+0x1b/0x20
[    3.242245]  device_driver_attach+0x68/0x70
[    3.242245]  __driver_attach+0x124/0x1b0
[    3.242245]  ? device_driver_attach+0x70/0x70
[    3.242245]  bus_for_each_dev+0xbb/0x110
[    3.242245]  ? rdinit_setup+0x45/0x45
[    3.242245]  driver_attach+0x27/0x30
[    3.242245]  bus_add_driver+0x1eb/0x2a0
[    3.242245]  driver_register+0xa9/0x180
[    3.242245]  __pci_register_driver+0x82/0x90
[    3.242245]  ? yellowfin_init+0x25/0x25
[    3.242245]  ql3xxx_driver_init+0x23/0x25
[    3.242245]  do_one_initcall+0x7f/0x3d0
[    3.242245]  ? rdinit_setup+0x45/0x45
[    3.242245]  ? rcu_read_lock_sched_held+0x4f/0x80
[    3.242245]  kernel_init_freeable+0x2aa/0x301
[    3.242245]  ? rest_init+0x2c0/0x2c0
[    3.242245]  kernel_init+0x18/0x190
[    3.242245]  ? rest_init+0x2c0/0x2c0
[    3.242245]  ? rest_init+0x2c0/0x2c0
[    3.242245]  ret_from_fork+0x1f/0x30
[    3.242245] Dumping ftrace buffer:
[    3.242245]    (ftrace buffer empty)
[    3.242245] Kernel Offset: disabled
[    3.242245] Rebooting in 1 seconds.

Reported-by: Zheyu Ma <zheyuma97@gmail.com>
Signed-off-by: Zheyu Ma <zheyuma97@gmail.com>
---
 drivers/net/ethernet/qlogic/qla3xxx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/qlogic/qla3xxx.c b/drivers/net/ethernet/qlogic/qla3xxx.c
index 214e347097a7..af7c142a066f 100644
--- a/drivers/net/ethernet/qlogic/qla3xxx.c
+++ b/drivers/net/ethernet/qlogic/qla3xxx.c
@@ -114,7 +114,9 @@ static int ql_sem_spinlock(struct ql3_adapter *qdev,
 		value = readl(&port_regs->CommonRegs.semaphoreReg);
 		if ((value & (sem_mask >> 16)) == sem_bits)
 			return 0;
+		spin_unlock_irq(&qdev->hw_lock);
 		ssleep(1);
+		spin_lock_irq(&qdev->hw_lock);
 	} while (--seconds);
 	return -1;
 }
-- 
2.17.1

