Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A9E4458E71
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 13:33:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239309AbhKVMgM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 07:36:12 -0500
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:38818 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239482AbhKVMgL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Nov 2021 07:36:11 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=guwen@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0Uxl5nz3_1637584373;
Received: from e02h04404.eu6sqa(mailfrom:guwen@linux.alibaba.com fp:SMTPD_---0Uxl5nz3_1637584373)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 22 Nov 2021 20:33:03 +0800
From:   Wen Gu <guwen@linux.alibaba.com>
To:     kgraul@linux.ibm.com, davem@davemloft.net, kuba@kernel.org
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, dust.li@linux.alibaba.com,
        tonylu@linux.alibaba.com, syzkaller-bugs@googlegroups.com
Subject: [PATCH net] net/smc: Avoid warning of possible recursive locking
Date:   Mon, 22 Nov 2021 20:32:53 +0800
Message-Id: <1637584373-49664-1-git-send-email-guwen@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Possible recursive locking is detected by lockdep when SMC
falls back to TCP. The corresponding warnings are as follows:

 ============================================
 WARNING: possible recursive locking detected
 5.16.0-rc1+ #18 Tainted: G            E
 --------------------------------------------
 wrk/1391 is trying to acquire lock:
 ffff975246c8e7d8 (&ei->socket.wq.wait){..-.}-{3:3}, at: smc_switch_to_fallback+0x109/0x250 [smc]

 but task is already holding lock:
 ffff975246c8f918 (&ei->socket.wq.wait){..-.}-{3:3}, at: smc_switch_to_fallback+0xfe/0x250 [smc]

 other info that might help us debug this:
  Possible unsafe locking scenario:

        CPU0
        ----
   lock(&ei->socket.wq.wait);
   lock(&ei->socket.wq.wait);

  *** DEADLOCK ***

  May be due to missing lock nesting notation

 2 locks held by wrk/1391:
  #0: ffff975246040130 (sk_lock-AF_SMC){+.+.}-{0:0}, at: smc_connect+0x43/0x150 [smc]
  #1: ffff975246c8f918 (&ei->socket.wq.wait){..-.}-{3:3}, at: smc_switch_to_fallback+0xfe/0x250 [smc]

 stack backtrace:
 Call Trace:
  <TASK>
  dump_stack_lvl+0x56/0x7b
  __lock_acquire+0x951/0x11f0
  lock_acquire+0x27a/0x320
  ? smc_switch_to_fallback+0x109/0x250 [smc]
  ? smc_switch_to_fallback+0xfe/0x250 [smc]
  _raw_spin_lock_irq+0x3b/0x80
  ? smc_switch_to_fallback+0x109/0x250 [smc]
  smc_switch_to_fallback+0x109/0x250 [smc]
  smc_connect_fallback+0xe/0x30 [smc]
  __smc_connect+0xcf/0x1090 [smc]
  ? mark_held_locks+0x61/0x80
  ? __local_bh_enable_ip+0x77/0xe0
  ? lockdep_hardirqs_on+0xbf/0x130
  ? smc_connect+0x12a/0x150 [smc]
  smc_connect+0x12a/0x150 [smc]
  __sys_connect+0x8a/0xc0
  ? syscall_enter_from_user_mode+0x20/0x70
  __x64_sys_connect+0x16/0x20
  do_syscall_64+0x34/0x90
  entry_SYSCALL_64_after_hwframe+0x44/0xae

The nested locking in smc_switch_to_fallback() is considered to
possibly cause a deadlock because smc_wait->lock and clc_wait->lock
are the same type of lock. But actually it is safe so far since
there is no other place trying to obtain smc_wait->lock when
clc_wait->lock is held. So the patch replaces spin_lock() with
spin_lock_nested() to avoid false report by lockdep.

Link: https://lkml.org/lkml/2021/11/19/962
Fixes: 2153bd1e3d3d ("Transfer remaining wait queue entries during fallback")
Reported-by: syzbot+e979d3597f48262cb4ee@syzkaller.appspotmail.com
Signed-off-by: Wen Gu <guwen@linux.alibaba.com>
---
 net/smc/af_smc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index b61c802..2692cba 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -585,7 +585,7 @@ static void smc_switch_to_fallback(struct smc_sock *smc, int reason_code)
 		 * to clcsocket->wq during the fallback.
 		 */
 		spin_lock_irqsave(&smc_wait->lock, flags);
-		spin_lock(&clc_wait->lock);
+		spin_lock_nested(&clc_wait->lock, SINGLE_DEPTH_NESTING);
 		list_splice_init(&smc_wait->head, &clc_wait->head);
 		spin_unlock(&clc_wait->lock);
 		spin_unlock_irqrestore(&smc_wait->lock, flags);
-- 
1.8.3.1

