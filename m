Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F27728DA62
	for <lists+netdev@lfdr.de>; Wed, 14 Oct 2020 09:18:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728184AbgJNHSM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 03:18:12 -0400
Received: from mail-mw2nam12on2079.outbound.protection.outlook.com ([40.107.244.79]:24289
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728036AbgJNHSM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Oct 2020 03:18:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N+WjKE+D6p7R2xot61N5fx4I67+WH6R/ojdqrQ8fXrkguV/A1NKNj207hqiv1JV6gwzmcgYonDMcpSyiKxS892Aibd1n7hcETYGnfrJm3zZLDfSeyZg8rzPY8sh/fcChKl9jH5WPUCoAWegxRDydKQrx+dqyNuwMgd+EfYfrTS/obQfykVp/T4s5SYwLTwAOK//kc5yKYqHvVcoQKuhu7MGtguwNhJ5ZdX+r0ZdsKYicZ8ezH3JUpjmXeSlC+k20mSNtWsa+puYMWCW8N6Lp1O1qGLgZgJnOepQ/651yVmvqJhVpoT7TJFxujeZfaNhHBb10sD677fJ56uFE/lY1ZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VBvay2xQUnK/FGalhuY8gsp8TfeBgO6gJ+rVKa5doC0=;
 b=VCk0+ssBZvaqf3EXut796jd/+8X0guc2II6R2PNcBgNkFpVNNIzwY/tMrajZcU6DzNFDQxF7i0S5ZK4FXW2BviDn09rHVE4g5RyTqDeUGEsmaAjmeEUEQKkGskWCqVTP0zksN7xLY0qsrsKlnn6Ud9HenqLVH9Km27bGOfFUoEYyYj7iFrz3W7YR1JwjGAPC3yPIIndqLlEUK/wyq6KFnYNUbAToqGJo0QT6TrMGV9gp1GaZSOrdL5oWJNE6IGy8rhAZjlJ6/pjHXHe+SXl78Li19hz2g2ugBKPZl/cg8OCUX5sVZ8xGCykJ3Cp94RNjabvA8mDLkI/TxmZm0qvA1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=windriversystems.onmicrosoft.com;
 s=selector2-windriversystems-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VBvay2xQUnK/FGalhuY8gsp8TfeBgO6gJ+rVKa5doC0=;
 b=EfwZQKfwAzQtuJVlv295R0TaiuqtjvDrwAgrRSA3NRAHyc69o/1SAHx1de8e+PsPFJXGe1oYEZ5nWRvGsykBWYASPTtbMEYdsCbSrulwwCTtkBTJiUZP7c6m7HZikF6UpMzio6n9Rr7EPbX5UF9NK+qN1//aiihTVr+a50TEfRk=
Authentication-Results: holtmann.org; dkim=none (message not signed)
 header.d=none;holtmann.org; dmarc=none action=none header.from=windriver.com;
Received: from BY5PR11MB4241.namprd11.prod.outlook.com (2603:10b6:a03:1ca::13)
 by BYAPR11MB2917.namprd11.prod.outlook.com (2603:10b6:a03:89::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.28; Wed, 14 Oct
 2020 07:18:08 +0000
Received: from BY5PR11MB4241.namprd11.prod.outlook.com
 ([fe80::3581:4d13:b613:eb81]) by BY5PR11MB4241.namprd11.prod.outlook.com
 ([fe80::3581:4d13:b613:eb81%7]) with mapi id 15.20.3455.030; Wed, 14 Oct 2020
 07:18:07 +0000
From:   yanfei.xu@windriver.com
To:     marcel@holtmann.org, johan.hedberg@gmail.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Bluetooth: Use lock_sock() when acquiring lock in sco_conn_del
Date:   Wed, 14 Oct 2020 15:17:31 +0800
Message-Id: <20201014071731.34279-1-yanfei.xu@windriver.com>
X-Mailer: git-send-email 2.18.2
Content-Type: text/plain
X-Originating-IP: [60.247.85.82]
X-ClientProxiedBy: HK2PR0401CA0001.apcprd04.prod.outlook.com
 (2603:1096:202:2::11) To BY5PR11MB4241.namprd11.prod.outlook.com
 (2603:10b6:a03:1ca::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pek-lpggp1.wrs.com (60.247.85.82) by HK2PR0401CA0001.apcprd04.prod.outlook.com (2603:1096:202:2::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.21 via Frontend Transport; Wed, 14 Oct 2020 07:18:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 36dd21f6-659a-4197-13e9-08d870114c94
X-MS-TrafficTypeDiagnostic: BYAPR11MB2917:
X-Microsoft-Antispam-PRVS: <BYAPR11MB2917452805C91691164A7432E4050@BYAPR11MB2917.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:248;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: m0FuZhFw1a5S03ZsOZsqH4uyeNtPgmJziFzXz050SdmYeYMD4pdMhYjA78Zv0fMGNJ8V8vdY80Kqa6dgH/fcvbb83VlqXsQ2JcyTODrNviaH6ZS7JfdeFc5tNPueEVa5wO403QTwyuwASrlwF6ks9hLAw0QNaGE3HMSTD3T1lRRWtU+S1BlLQ44iiura/EZc8qA3uWUjuu2XrZPQkww3m8kOHaTwMYPl/3DOXvK6D92z9N3ncU+Rp51tELbMZzuNkNa7BiEo41f4xFTGdY5oEzyS2naQGeEXQ4J7nAW0efC27mFMmajn38LtYOuo6FbGOTkc1azI3+T9IcEWhr2lTQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB4241.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(39850400004)(136003)(346002)(376002)(4326008)(478600001)(2616005)(956004)(6506007)(36756003)(9686003)(2906002)(8676002)(186003)(6666004)(16526019)(52116002)(83380400001)(8936002)(316002)(66946007)(66556008)(66476007)(6486002)(86362001)(26005)(5660300002)(1076003)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: NlAxKmPhmQk6ZrIrGVlHYoFMbWujCvoe82YvoyhoNrRe3RcQwifVY4DQAgqY3A1js1l0viXWK5EWE6VnZJeiWUCOEsGqGCFJJO5vKI3yaK0AsMUSuDY07MN+1R+X9EWz3l181bO1R4Hh8XiHzsq1BwQ/ZuTwVZ76Ia71uD7KoHldnOtoI/h0b/pQX91/vrrZVCMxjzEG+2MnKJt6p1nA9rb3o2fpwVBhtf+91hwKq1A+FXDx96S5YYwjOUeMY0rAsKyh2g3JmAzK4sFG++yEpf6vwE1pGL1R5qYwaMP2NpSXVhlthJzPYj6Rkj9p7BA4DXHAoKnzdDTkhYVdH3fwHAwZ9+L1YvYDHSUhn0AcKeAAdcq0Y3XjDMuQ6+XdSvOX+EjcDdp9pixozKiSmaXyYyQaotZwwj+E/rZYO2R8b5LVzAfn4MvlHrx7V9+yot4B1LPSOQbDF+ojs769EU9F7m99Me27HxutjOAK20gutUrZXsgYDsExzLJG46mZAilM/QcpA6/xiWorMp6hNmUN3XHn0VKn8WfPraKDOTLeMSxYyOY3/ZQxQDnVEPwEC8yt1HZmgaQ4VvRQYOi8hkbKNhEWoty6LhHJU4BrtKFk0uJPk+mgy8/ZjdhjY0I+wryYGUZ0/evxrKdrXFpvMA1IAg==
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36dd21f6-659a-4197-13e9-08d870114c94
X-MS-Exchange-CrossTenant-AuthSource: BY5PR11MB4241.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2020 07:18:07.7921
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MeNI4lx7c1VpqQXeGWXm2TK5w7u3WWVvLa+DVptj0ZRSuGFbqXM1o+Rt8GxMpEoQTSAYUs7ui/5s84pDRD0ceQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2917
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yanfei Xu <yanfei.xu@windriver.com>

Locking slock-AF_BLUETOOTH-BTPROTO_SCO may happen in process context or
BH context. If in process context, we should use lock_sock(). As blow
warning, sco_conn_del() is called in process context, so let's use
lock_sock() instead of bh_lock_sock().

================================
WARNING: inconsistent lock state
5.9.0-rc4-syzkaller #0 Not tainted
--------------------------------
inconsistent {IN-SOFTIRQ-W} -> {SOFTIRQ-ON-W} usage.
syz-executor675/31233 [HC0[0]:SC0[0]:HE1:SE1] takes:
ffff8880a75c50a0 (slock-AF_BLUETOOTH-BTPROTO_SCO){+.?.}-{2:2}, at:
spin_lock include/linux/spinlock.h:354 [inline]
ffff8880a75c50a0 (slock-AF_BLUETOOTH-BTPROTO_SCO){+.?.}-{2:2}, at:
sco_conn_del+0x128/0x270 net/bluetooth/sco.c:176
{IN-SOFTIRQ-W} state was registered at:
  lock_acquire+0x1f3/0xae0 kernel/locking/lockdep.c:5006
  __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
  _raw_spin_lock+0x2a/0x40 kernel/locking/spinlock.c:151
  spin_lock include/linux/spinlock.h:354 [inline]
  sco_sock_timeout+0x24/0x140 net/bluetooth/sco.c:83
  call_timer_fn+0x1ac/0x760 kernel/time/timer.c:1413
  expire_timers kernel/time/timer.c:1458 [inline]
  __run_timers.part.0+0x67c/0xaa0 kernel/time/timer.c:1755
  __run_timers kernel/time/timer.c:1736 [inline]
  run_timer_softirq+0xae/0x1a0 kernel/time/timer.c:1768
  __do_softirq+0x1f7/0xa91 kernel/softirq.c:298
  asm_call_on_stack+0xf/0x20 arch/x86/entry/entry_64.S:706
  __run_on_irqstack arch/x86/include/asm/irq_stack.h:22 [inline]
  run_on_irqstack_cond arch/x86/include/asm/irq_stack.h:48 [inline]
  do_softirq_own_stack+0x9d/0xd0 arch/x86/kernel/irq_64.c:77
  invoke_softirq kernel/softirq.c:393 [inline]
  __irq_exit_rcu kernel/softirq.c:423 [inline]
  irq_exit_rcu+0x235/0x280 kernel/softirq.c:435
  sysvec_apic_timer_interrupt+0x51/0xf0 arch/x86/kernel/apic/apic.c:1091
  asm_sysvec_apic_timer_interrupt+0x12/0x20
  arch/x86/include/asm/idtentry.h:581
  unwind_next_frame+0x139a/0x1f90 arch/x86/kernel/unwind_orc.c:607
  arch_stack_walk+0x81/0xf0 arch/x86/kernel/stacktrace.c:25
  stack_trace_save+0x8c/0xc0 kernel/stacktrace.c:123
  kasan_save_stack+0x1b/0x40 mm/kasan/common.c:48
  kasan_set_track mm/kasan/common.c:56 [inline]
  __kasan_kmalloc.constprop.0+0xbf/0xd0 mm/kasan/common.c:461
  slab_post_alloc_hook mm/slab.h:518 [inline]
  slab_alloc mm/slab.c:3312 [inline]
  kmem_cache_alloc+0x13a/0x3a0 mm/slab.c:3482
  __d_alloc+0x2a/0x950 fs/dcache.c:1709
  d_alloc+0x4a/0x230 fs/dcache.c:1788
  d_alloc_parallel+0xe9/0x18e0 fs/dcache.c:2540
  lookup_open.isra.0+0x9ac/0x1350 fs/namei.c:3030
  open_last_lookups fs/namei.c:3177 [inline]
  path_openat+0x96d/0x2730 fs/namei.c:3365
  do_filp_open+0x17e/0x3c0 fs/namei.c:3395
  do_sys_openat2+0x16d/0x420 fs/open.c:1168
  do_sys_open fs/open.c:1184 [inline]
  __do_sys_open fs/open.c:1192 [inline]
  __se_sys_open fs/open.c:1188 [inline]
  __x64_sys_open+0x119/0x1c0 fs/open.c:1188
  do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
  entry_SYSCALL_64_after_hwframe+0x44/0xa9
irq event stamp: 853
hardirqs last  enabled at (853): [<ffffffff87f733af>]
__raw_spin_unlock_irq include/linux/spinlock_api_smp.h:168 [inline]
hardirqs last  enabled at (853): [<ffffffff87f733af>]
_raw_spin_unlock_irq+0x1f/0x80 kernel/locking/spinlock.c:199
hardirqs last disabled at (852): [<ffffffff87f73764>]
__raw_spin_lock_irq include/linux/spinlock_api_smp.h:126 [inline]
hardirqs last disabled at (852): [<ffffffff87f73764>]
_raw_spin_lock_irq+0xa4/0xd0 kernel/locking/spinlock.c:167
softirqs last  enabled at (0): [<ffffffff8144c929>]
copy_process+0x1a99/0x6920 kernel/fork.c:2018
softirqs last disabled at (0): [<0000000000000000>] 0x0

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(slock-AF_BLUETOOTH-BTPROTO_SCO);
  <Interrupt>
    lock(slock-AF_BLUETOOTH-BTPROTO_SCO);

 *** DEADLOCK ***

3 locks held by syz-executor675/31233:
 #0: ffff88809f104f40 (&hdev->req_lock){+.+.}-{3:3}, at:
hci_dev_do_close+0xf5/0x1080 net/bluetooth/hci_core.c:1720
 #1: ffff88809f104078 (&hdev->lock){+.+.}-{3:3}, at:
hci_dev_do_close+0x253/0x1080 net/bluetooth/hci_core.c:1757
 #2: ffffffff8a9188c8 (hci_cb_list_lock){+.+.}-{3:3}, at:
hci_disconn_cfm include/net/bluetooth/hci_core.h:1435 [inline]
 #2: ffffffff8a9188c8 (hci_cb_list_lock){+.+.}-{3:3}, at:
hci_conn_hash_flush+0xc7/0x220 net/bluetooth/hci_conn.c:1557

stack backtrace:
CPU: 1 PID: 31233 Comm: syz-executor675 Not tainted 5.9.0-rc4-syzkaller
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x198/0x1fd lib/dump_stack.c:118
 print_usage_bug kernel/locking/lockdep.c:4020 [inline]
 valid_state kernel/locking/lockdep.c:3361 [inline]
 mark_lock_irq kernel/locking/lockdep.c:3560 [inline]
 mark_lock.cold+0x7a/0x7f kernel/locking/lockdep.c:4006
 mark_usage kernel/locking/lockdep.c:3923 [inline]
 __lock_acquire+0x876/0x5570 kernel/locking/lockdep.c:4380
 lock_acquire+0x1f3/0xae0 kernel/locking/lockdep.c:5006
 __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
 _raw_spin_lock+0x2a/0x40 kernel/locking/spinlock.c:151
 spin_lock include/linux/spinlock.h:354 [inline]
 sco_conn_del+0x128/0x270 net/bluetooth/sco.c:176
 sco_disconn_cfm net/bluetooth/sco.c:1178 [inline]
 sco_disconn_cfm+0x62/0x80 net/bluetooth/sco.c:1171
 hci_disconn_cfm include/net/bluetooth/hci_core.h:1438 [inline]
 hci_conn_hash_flush+0x114/0x220 net/bluetooth/hci_conn.c:1557
 hci_dev_do_close+0x5c6/0x1080 net/bluetooth/hci_core.c:1770
 hci_unregister_dev+0x1bd/0xe30 net/bluetooth/hci_core.c:3790
 vhci_release+0x70/0xe0 drivers/bluetooth/hci_vhci.c:340
 __fput+0x285/0x920 fs/file_table.c:281
 task_work_run+0xdd/0x190 kernel/task_work.c:141
 exit_task_work include/linux/task_work.h:25 [inline]
 do_exit+0xb7d/0x29f0 kernel/exit.c:806
 do_group_exit+0x125/0x310 kernel/exit.c:903
 get_signal+0x428/0x1f00 kernel/signal.c:2757
 arch_do_signal+0x82/0x2520 arch/x86/kernel/signal.c:811
 exit_to_user_mode_loop kernel/entry/common.c:159 [inline]
 exit_to_user_mode_prepare+0x1ae/0x200 kernel/entry/common.c:190
 syscall_exit_to_user_mode+0x7e/0x2e0 kernel/entry/common.c:265
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x447279

Reported-by: syzbot+65684128cd7c35bc66a1@syzkaller.appspotmail.com
Signed-off-by: Yanfei Xu <yanfei.xu@windriver.com>
---
 net/bluetooth/sco.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/sco.c b/net/bluetooth/sco.c
index dcf7f96ff417..559b883c815f 100644
--- a/net/bluetooth/sco.c
+++ b/net/bluetooth/sco.c
@@ -173,10 +173,10 @@ static void sco_conn_del(struct hci_conn *hcon, int err)
 
 	if (sk) {
 		sock_hold(sk);
-		bh_lock_sock(sk);
+		lock_sock(sk);
 		sco_sock_clear_timer(sk);
 		sco_chan_del(sk, err);
-		bh_unlock_sock(sk);
+		release_sock(sk);
 		sco_sock_kill(sk);
 		sock_put(sk);
 	}
-- 
2.18.2

