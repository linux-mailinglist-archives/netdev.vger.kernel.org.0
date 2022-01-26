Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 174ED49D5F4
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 00:12:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232462AbiAZXMg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 18:12:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231251AbiAZXMf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 18:12:35 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D625C06161C
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 15:12:35 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id f12-20020a056902038c00b006116df1190aso2248535ybs.20
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 15:12:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=Xc+wVuU4u92zzTS+kBTgjt6C26R6QBrvsHtfaBQUYGE=;
        b=dsiMnx3ArW/MW7RYAEmWLfFChhAoQjclf8ApMpykFC01a01klO1G3grNziGu5CjsJW
         whsuS8BesWXAJeZ5VEmzopIfnoXyvr2B3FGRAXjDdNcHqXAS8XrQF7YZCtfHlATU2zzq
         vzbzM4PeJpmptI5ChErLpZvnq3nmw+EX1RrPlaOQ3q1CFxjPyqITIFX1xy4o0y5/M9w/
         T/FrfIAdnwyGUIoCWf19Xl0DL0ru7GpxjuHF5WhKHn+djLb3VBvW0xzl+L8tzzRxthEr
         sJSFbTigyFTZ5PBWIU4YP3qMX9M9FXEPCBXsx9r4lHeDWhSXUJ5XYPsW/nA98VUx4BSI
         tshQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=Xc+wVuU4u92zzTS+kBTgjt6C26R6QBrvsHtfaBQUYGE=;
        b=M2fezpOE1iqiCcZc5m1vfskXYb+lTLm1/SSnI2+E0lHc3iqgZToupxr/HD/8a6pBAo
         1EdBXKfVjY9qCTyr5TJ/jWJ0IhDw/nSI7S4EPbVpFLUDc5ls7okbSparMfMatEpdrhAZ
         g8KBMUgTQQkcsJwzp58DHvZQdZs32esdx0CcjAoZ+Q6c7XKh13QqPMYn9J+84dYDtBi4
         CSLIf5BvdKNcjGQUhemI/iaEt32yQWzCnNBCv7mm+lYxK7iTdS8ILnuQlGNRghjrM1nb
         1hi259JOqpZQ6hedUrOlPSRp3FPRH7br4q4yBe0B5KCrvME+7Jp8AQkTaeifhHXDE51G
         fA9g==
X-Gm-Message-State: AOAM533uaiXUdrGBQBvGdou7Xc96QaDOkTHTouMquUQnHq+lYqscsl8m
        K6EhezjOT2UTK9DCVZ3H4aUB92Q3il91LpIOt6etjlgN35CfXbMucfPx4jmRdk0VpYBw7yoUREy
        So0IvWK/iSEWNwOxljj8+gbR7aCQitj1fz4CnFoON2b48oHCjNkEIePWh/JIoiTbG
X-Google-Smtp-Source: ABdhPJzr2SpImfniDlPblh/OPlVY/TakbSzyUT+UjKGhdbF2fjfjr/V1UgBOquNbK1LkKdYwt73J6/XE1DgN
X-Received: from coldfire2.svl.corp.google.com ([2620:15c:2c4:201:1f33:2e3:631:77d6])
 (user=maheshb job=sendgmr) by 2002:a25:a562:: with SMTP id
 h89mr1968866ybi.374.1643238754670; Wed, 26 Jan 2022 15:12:34 -0800 (PST)
Date:   Wed, 26 Jan 2022 15:12:29 -0800
Message-Id: <20220126231229.4028998-1-maheshb@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
Subject: [PATCH] bonding: rate-limit printing a warning message
From:   Mahesh Bandewar <maheshb@google.com>
To:     Netdev <netdev@vger.kernel.org>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Veaceslav Falico <vfalico@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mahesh Bandewar <mahesh@bandewar.net>,
        Mahesh Bandewar <maheshb@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

dev.c:get_link_speed() schedules a work-queue aggressively when it
fails to get the speed. If the link n question is a bond device which
may have multiple links to iterate through to get the link
speed. If the underlying link(s) has/have issues, bonding driver prints
a link-status message and this doesn't go well with the aggressive
work-queue scheduling and results in a rcu stall. This fix just
adds a ratelimiter to the message printing to avoid the stall.

Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:17 [inline]
 dump_stack+0x14d/0x20b lib/dump_stack.c:53
 nmi_cpu_backtrace.cold+0x19/0x98 lib/nmi_backtrace.c:103
 nmi_trigger_cpumask_backtrace+0x16a/0x17e lib/nmi_backtrace.c:62
 arch_trigger_cpumask_backtrace+0x14/0x20 arch/x86/kernel/apic/hw_nmi.c:38
 trigger_single_cpu_backtrace include/linux/nmi.h:161 [inline]
 rcu_dump_cpu_stacks+0x183/0x1cf kernel/rcu/tree.c:1210
 print_cpu_stall kernel/rcu/tree.c:1349 [inline]
 check_cpu_stall kernel/rcu/tree.c:1423 [inline]
 rcu_pending kernel/rcu/tree.c:3010 [inline]
 rcu_check_callbacks.cold+0x494/0x7d3 kernel/rcu/tree.c:2551
 update_process_times+0x32/0x80 kernel/time/timer.c:1641
 tick_sched_handle+0xa0/0x180 kernel/time/tick-sched.c:161
 tick_sched_timer+0x44/0x130 kernel/time/tick-sched.c:1193
 __run_hrtimer kernel/time/hrtimer.c:1396 [inline]
 __hrtimer_run_queues+0x304/0xd80 kernel/time/hrtimer.c:1458
 hrtimer_interrupt+0x2ea/0x730 kernel/time/hrtimer.c:1516
 local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1031 [inline]
 smp_apic_timer_interrupt+0x150/0x5e0 arch/x86/kernel/apic/apic.c:1056
 apic_timer_interrupt+0x93/0xa0 arch/x86/entry/entry_64.S:780
 </IRQ>
RIP: 0010:arch_local_irq_restore arch/x86/include/asm/paravirt.h:783 [inline]
RIP: 0010:console_unlock+0x82b/0xcc0 kernel/printk/printk.c:2302
 RSP: 0018:ffff8801966cb9e8 EFLAGS: 00000293 ORIG_RAX: ffffffffffffff12
RAX: ffff8801968d0040 RBX: 0000000000000000 RCX: 0000000000000006
RDX: 0000000000000000 RSI: ffffffff815a6515 RDI: 0000000000000293
RBP: ffff8801966cba70 R08: ffff8801968d0040 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: ffffffff82cc61b0 R14: dffffc0000000000 R15: 0000000000000001
 vprintk_emit+0x593/0x610 kernel/printk/printk.c:1836
 vprintk_default+0x28/0x30 kernel/printk/printk.c:1876
 vprintk_func+0x7a/0xed kernel/printk/printk_safe.c:379
 printk+0xba/0xed kernel/printk/printk.c:1909
 get_link_speed.cold+0x43/0x144 net/core/dev.c:1493
 get_link_speed_work+0x1e/0x30 net/core/dev.c:1515
 process_one_work+0x881/0x1560 kernel/workqueue.c:2147
 worker_thread+0x653/0x1150 kernel/workqueue.c:2281
 kthread+0x345/0x410 kernel/kthread.c:246
 ret_from_fork+0x3f/0x50 arch/x86/entry/entry_64.S:393

Signed-off-by: Mahesh Bandewar <maheshb@google.com>
---
 drivers/net/bonding/bond_main.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 238b56d77c36..98b37af3fb6b 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -2538,9 +2538,12 @@ static int bond_miimon_inspect(struct bonding *bond)
 				/* recovered before downdelay expired */
 				bond_propose_link_state(slave, BOND_LINK_UP);
 				slave->last_link_up = jiffies;
-				slave_info(bond->dev, slave->dev, "link status up again after %d ms\n",
-					   (bond->params.downdelay - slave->delay) *
-					   bond->params.miimon);
+				if (net_ratelimit())
+					slave_info(bond->dev, slave->dev,
+						   "link status up again after %d ms\n",
+						   (bond->params.downdelay -
+						    slave->delay) *
+						   bond->params.miimon);
 				commit++;
 				continue;
 			}
-- 
2.35.0.rc0.227.g00780c9af4-goog

