Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02DD0449738
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 15:55:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240646AbhKHO4q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 09:56:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236586AbhKHO4q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Nov 2021 09:56:46 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2F84C061570
        for <netdev@vger.kernel.org>; Mon,  8 Nov 2021 06:54:01 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id m26so16279662pff.3
        for <netdev@vger.kernel.org>; Mon, 08 Nov 2021 06:54:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=/CFtYOOaFrI66rCv71FkVgP16ER/53djaTup8EHjfxg=;
        b=TFyw/9GkhXDlYJiwbhCKYqejl3TDzla5Jylb8z1VK5/OKuGssnHY7dipQGSQZa9m0M
         psyMJ//slCKBa7BCuGs5/nBnFNL7//c5PNnrJrVIkkZ0iOLv3HF8JnVcSuc7y3lszHxw
         fR48SWOlXaywWvzeD4tiD77WmJJnlTPuMH37Q+7CVfJQK7XZjt9053J2Bo//FhTYDj1T
         0xecI6XX9wGd3BY2CBpMgNJmWn7fLGr/aj0PLCsE/NAgNoxGuFbx4X7Ka9C6jxQMIgkd
         PI15/jrH14HYTF+vVsSTGMapuruKNf6bOqaVqn0edd/cPBh+ES90yy635ma9Gp27BWk+
         TCow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=/CFtYOOaFrI66rCv71FkVgP16ER/53djaTup8EHjfxg=;
        b=S7pnxVyCbN5M3o+RSCFHGzEa1CRTNgfzeNeoSpeQyKXMs8utD0ZF70T/8vi2wvu1Z7
         gdqBTu1Av9kmA6aoRLiQEC/rZDUaUeAuwlr0Sfl/zgz8sVCQIbdPMkuurAOVFOtRQHb+
         ORlNBkQDdOcAfCZiGN2fIMzvnH06P/ZC1bOi87naYMsfrEoNeP0TwzH5PfHP3fxHiHk1
         rrHam0TT4W5WUigDm47e9loD9EPTSWkd/5iFwwnEyPakf0pmRNvQpvxEBOHGV/RuLOXA
         jyC9T5MHOydk2tXAzD3ntgm0wCbTvfkOAeseWwJt8Xn3Huc8RPNiZEcB9aerAxaS73Mk
         a3hA==
X-Gm-Message-State: AOAM530lkj6nWAly+Dx3CCS8dqH3uBzGDR6GujbrwBZ+w8yGZn4xqFi9
        bBpJxYlXykVihFhYNYUO9N3hbCtWVkg=
X-Google-Smtp-Source: ABdhPJzydd/Eo3acQVJLZK80zztBaF2IdeL+eBlHjpXFOfNroZA3IlcFYrzOVYEAgMEzZTODjP3cHQ==
X-Received: by 2002:a63:6302:: with SMTP id x2mr19312pgb.5.1636383241321;
        Mon, 08 Nov 2021 06:54:01 -0800 (PST)
Received: from localhost.localdomain ([49.173.165.50])
        by smtp.gmail.com with ESMTPSA id mi3sm14405338pjb.35.2021.11.08.06.53.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Nov 2021 06:54:00 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net] amt: use cancel_delayed_work() instead of flush_delayed_work() in amt_fini()
Date:   Mon,  8 Nov 2021 14:53:40 +0000
Message-Id: <20211108145340.17208-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the amt module is being removed, it calls flush_delayed_work() to exit
source_gc_wq. But it wouldn't be exited properly because the
amt_source_gc_work(), which is the callback function of source_gc_wq
internally calls mod_delayed_work() again.
So, amt_source_gc_work() would be called after the amt module is removed.
Therefore kernel panic would occur.
In order to avoid it, cancel_delayed_work() should be used instead of
flush_delayed_work().

Test commands:
   modprobe amt
   modprobe -rv amt

Splat looks like:
 BUG: unable to handle page fault for address: fffffbfff80f50db
 #PF: supervisor read access in kernel mode
 #PF: error_code(0x0000) - not-present page
 PGD 1237ee067 P4D 1237ee067 PUD 1237b2067 PMD 100c11067 PTE 0
 Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC KASAN PTI
 CPU: 1 PID: 0 Comm: swapper/1 Not tainted 5.15.0+ #27
 5a0ebebc29fe5c40c68bea90197606c3a832b09f
 RIP: 0010:run_timer_softirq+0x221/0xfc0
 Code: 00 00 4c 89 e1 4c 8b 30 48 c1 e9 03 80 3c 29 00 0f 85 ed 0b 00 00
 4d 89 34 24 4d 85 f6 74 19 49 8d 7e 08 48 89 f9 48 c1 e9 03 <80> 3c 29 00
 0f 85 fa 0b 00 00 4d 89 66 08 83 04 24 01 49 89 d4 48
 RSP: 0018:ffff888119009e50 EFLAGS: 00010806
 RAX: ffff8881191f8a80 RBX: 00000000007ffe2a RCX: 1ffffffff80f50db
 RDX: ffff888119009ed0 RSI: 0000000000000008 RDI: ffffffffc07a86d8
 RBP: dffffc0000000000 R08: ffff8881191f8280 R09: ffffed102323f061
 R10: ffff8881191f8307 R11: ffffed102323f060 R12: ffff888119009ec8
 R13: 00000000000000c0 R14: ffffffffc07a86d0 R15: ffff8881191f82e8
 FS:  0000000000000000(0000) GS:ffff888119000000(0000)
 knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: fffffbfff80f50db CR3: 00000001062dc002 CR4: 00000000003706e0
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
 Call Trace:
  <IRQ>
  ? add_timer+0x650/0x650
  ? kvm_clock_read+0x14/0x30
  ? ktime_get+0xb9/0x180
  ? rcu_read_lock_held_common+0xe/0xa0
  ? rcu_read_lock_sched_held+0x56/0xc0
  ? rcu_read_lock_bh_held+0xa0/0xa0
  ? hrtimer_interrupt+0x271/0x790
  __do_softirq+0x1d0/0x88f
  irq_exit_rcu+0xe7/0x120
  sysvec_apic_timer_interrupt+0x8a/0xb0
  </IRQ>
  <TASK>
[ ... ]

Fixes: bc54e49c140b ("amt: add multicast(IGMP) report message handler")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/amt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/amt.c b/drivers/net/amt.c
index c384b2694f9e..47a04c330885 100644
--- a/drivers/net/amt.c
+++ b/drivers/net/amt.c
@@ -3286,7 +3286,7 @@ static void __exit amt_fini(void)
 {
 	rtnl_link_unregister(&amt_link_ops);
 	unregister_netdevice_notifier(&amt_notifier_block);
-	flush_delayed_work(&source_gc_wq);
+	cancel_delayed_work(&source_gc_wq);
 	__amt_source_gc_work();
 	destroy_workqueue(amt_wq);
 }
-- 
2.17.1

