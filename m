Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F66828A21C
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 00:55:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730423AbgJJWy6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Oct 2020 18:54:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731374AbgJJTO1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Oct 2020 15:14:27 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2062f.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8a::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96469C05BD32;
        Sat, 10 Oct 2020 09:05:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gXG+cNwLfyVSfC8gT1gv0Mx88x65a8tyreEZ+7vRGr+k4S97xkEIflkp0D5hk9VqcbaOr9OWik3gYVY4PQ/NNLsJ+raaNlngCC+WuOMfYn5UAgZx4hWMmpvVQNOGE4kBuJ1d7We/0WOXNsfYiKaN0ypy9fDg4DSuTx/XOAGJFwUAqoB/2WSzNrsPXuaXZH+HPA1INN3MNGESfThkaq+Wurce1/HT5KGggWFKixZUeN4L+1B/GC36qiyrzG0lDHfGPj+/NMhNzONvy6NS8b0i32XmvaOgCQ1u0uzS/CasLnDXEv0Zyjxpi+CI6Dq7eQHhKRv4V06SZ9p7zs2Gqben7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7Fokc3QKxUEYoY554QDyIqtEXA2X2sskN7Gg4ef3DFk=;
 b=gqSTmXpr9SLz1dJOLH1sam1JoY9eruXrVA1C+Uhny6IRnEr/x8lNd/zRA+IiMZOB4NOlhWLyhcdMrl5o3rYRkIwGL4DcgJGKZse+6iAxkj9JQE/wtB7xpMA3fG47OMq8zmaAKa0Z9shQj7bC6LKq6q19D518+jGEhEqfhhPfFVcsMmqJqDYNSgVfVcKZnASjorAsx2PnHEkaNPi/Z+atrFQJVkKhbjEvGtgQFJvHriUfXCCjioE7BR75+kC2rLq8q1JI0Mh2TfFaLP2iWoiR7bQGMyBvJa1lO602EADg4UjRd8tDF3JY686wIEzu00knPAevM95HnTDIoQdJvDQLiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=windriversystems.onmicrosoft.com;
 s=selector2-windriversystems-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7Fokc3QKxUEYoY554QDyIqtEXA2X2sskN7Gg4ef3DFk=;
 b=CTG0lx52DOdqs/rjUgX3oQokUjoeHGQWvA7hYlaU8gbNL+BEpx3b8jwN6OMnDf3u721s1FwCf2eX3N3DfN/sGHGFiWh9WO6WDNH4VdqAlBmIEME1OUPl0GZFmgARUG2Tlam67O0DfuXs1/TkQZCOVs61imNZ9E8usf3VSKqUOkE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from BY5PR11MB4241.namprd11.prod.outlook.com (2603:10b6:a03:1ca::13)
 by BYAPR11MB3766.namprd11.prod.outlook.com (2603:10b6:a03:b5::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.23; Sat, 10 Oct
 2020 09:14:34 +0000
Received: from BY5PR11MB4241.namprd11.prod.outlook.com
 ([fe80::3581:4d13:b613:eb81]) by BY5PR11MB4241.namprd11.prod.outlook.com
 ([fe80::3581:4d13:b613:eb81%7]) with mapi id 15.20.3455.028; Sat, 10 Oct 2020
 09:14:33 +0000
From:   "Xu, Yanfei" <yanfei.xu@windriver.com>
Subject: Re: inconsistent lock state in sco_conn_del
To:     marcel@holtmann.org, johan.hedberg@gmail.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-bluetooth@vger.kernel.org
Message-ID: <a54395a1-1c76-a0c3-431a-5bf9f4de1a39@windriver.com>
Date:   Sat, 10 Oct 2020 17:14:28 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [60.247.85.82]
X-ClientProxiedBy: BYAPR01CA0059.prod.exchangelabs.com (2603:10b6:a03:94::36)
 To BY5PR11MB4241.namprd11.prod.outlook.com (2603:10b6:a03:1ca::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [128.224.162.160] (60.247.85.82) by BYAPR01CA0059.prod.exchangelabs.com (2603:10b6:a03:94::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.24 via Frontend Transport; Sat, 10 Oct 2020 09:14:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d90b022b-895a-4da1-572d-08d86cfce702
X-MS-TrafficTypeDiagnostic: BYAPR11MB3766:
X-Microsoft-Antispam-PRVS: <BYAPR11MB376628EB7FAC00D44C0DBE08E4090@BYAPR11MB3766.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qTkDHa73BGxIKBEAeoB2f7hExmYVtMYXty7KhUNMQGhBY0gWBT5v+V37Dz+UdiOzerII7apfmpPQUxhIbRlLpdjpmn/8haLYcxMWUq+MpY+CYdz263VhAAoW6L66OupngxZ4gihEqoKRIzG5mUqMZoMvYtXD1fGRkywGlyYe3EUovX36AUGoUd5kpPOSAlcxDPP4qSJv4dfbf/G0PqQeNoCLcexLx8blBKttNjJCf7lLcJIqK4ywOUMKVL79efzXye9Btzp/4EiHlhHUy5E4xilSX20mn3+HmwAuAilzoExgm4c8MAsKE35eYhj85krWKDr0o5rZwl7N64Qm9K+Ww+nytJqNilMpYnF89MkH8A7u9lk5qOmf9shO97GYmBjQneGBbWOTj3SCRmpaLy/gudiD7gVFwmkYgmiLKbUHD1NAoyj8X+wecotcHS+FEDafFeamAftzdV/kOF8Ud14iDBGINt44EqbzPJiTA2Ay6Kw7NtBy4F9PJIqRf8opZqYu
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB4241.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(396003)(366004)(346002)(39850400004)(8676002)(83380400001)(83080400001)(478600001)(966005)(6666004)(8936002)(2616005)(52116002)(16526019)(26005)(16576012)(186003)(956004)(66556008)(4326008)(66476007)(316002)(86362001)(6706004)(6486002)(36756003)(83730400001)(31686004)(2906002)(31696002)(5660300002)(66946007)(99710200001)(78286007)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: wDhnjE3uyr8E+ZxrS4t5uraxS69wNhMRbhhv7QE0c7DhgH3piqXmV/v10kQiysUQJUiiao0L7l5/4nd9OUDlfnp0bvSHG9u30OFze0q7YSojtXaVg707Qaq9N7Rhy/i7Egl1kVxXNjP2akIVraI2i8j2hhdtvsMCf60dLd+TMeE/mbBbSKJNBWhOcvikuKlZ0rH1Mdf+PDaU8oarZ1vtILwMevv1WtfZJJKCYs5siWM6xDCMJvFyNufp4Z9/7Ers7qIlhNtp2raQTYkWWMQR1RUDlSj700D+N40pHWNEKRVaRujz79Qv122FaOSSthV8HIAQPLC2Vvi1oINQb3AdUqfpdy79xT0vEigYyY9eTpN5fDq6ovdp8AvbBWDOsfXJF0K5dbKVW9AXgGcZMhg/Lxwj9tn2Qqohpy9T8SUokqsm0JNTGVzOUyY3VNhGiqZZFQ+byXtuBmI277Mpg8YG4Yqmxl5f0jdwGVvhOw0eL8a80kkwON9WaWecOiZroi+i/y14JJ0IfNVw0g/2pkr/MH0yRhfmZbAQq8sNiOOILhkNLpTyi3wQCGlR/Fr3mvrPTdjRt3HXyeXYKS3Z8rriDHpdzDG5+6MZRUPO/fMK2qkOMTjdbTv71dxsOVr2XBb1oJrL+2MLDv3eYoz1Ukemfg==
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d90b022b-895a-4da1-572d-08d86cfce702
X-MS-Exchange-CrossTenant-AuthSource: BY5PR11MB4241.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2020 09:14:33.8432
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k6204H1H/NjvZlyb9LOCI1VDz5nfZEkPOZ6MPm45+ix8/UvURCLaUfn02YPxeSxi25fXAfmgk30v5VDXmH7Fng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3766
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

 > syzbot has found a reproducer for the following issue on:
 >
 > HEAD commit:    e8878ab8 Merge tag 'spi-fix-v5.9-rc4' of 
git://git.kernel...
 > git tree:       upstream
 > console output: https://syzkaller.appspot.com/x/log.txt?x=12130759900000
 > kernel config: 
https://syzkaller.appspot.com/x/.config?x=c61610091f4ca8c4
 > dashboard link: 
https://syzkaller.appspot.com/bug?extid=65684128cd7c35bc66a1
 > compiler:       gcc (GCC) 10.1.0-syz 20200507
 > syz repro: 
https://syzkaller.appspot.com/x/repro.syz?x=121ef0fd900000
 > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16c3a853900000
 >
 > IMPORTANT: if you fix the issue, please add the following tag to the 
commit:
 > Reported-by: syzbot+65684128cd7c35bc66a1@syzkaller.appspotmail.com
 >
 > ================================
 > WARNING: inconsistent lock state
 > 5.9.0-rc4-syzkaller #0 Not tainted
 > --------------------------------
 > inconsistent {IN-SOFTIRQ-W} -> {SOFTIRQ-ON-W} usage.
 > syz-executor675/31233 [HC0[0]:SC0[0]:HE1:SE1] takes:
 > ffff8880a75c50a0 (slock-AF_BLUETOOTH-BTPROTO_SCO){+.?.}-{2:2}, at: 
spin_lock include/linux/spinlock.h:354 [inline]
 > ffff8880a75c50a0 (slock-AF_BLUETOOTH-BTPROTO_SCO){+.?.}-{2:2}, at: 
sco_conn_del+0x128/0x270 net/bluetooth/sco.c:176
 > {IN-SOFTIRQ-W} state was registered at:
 >    lock_acquire+0x1f3/0xae0 kernel/locking/lockdep.c:5006
 >    __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
 >    _raw_spin_lock+0x2a/0x40 kernel/locking/spinlock.c:151
 >    spin_lock include/linux/spinlock.h:354 [inline]
 >    sco_sock_timeout+0x24/0x140 net/bluetooth/sco.c:83
 >    call_timer_fn+0x1ac/0x760 kernel/time/timer.c:1413
 >    expire_timers kernel/time/timer.c:1458 [inline]
 >    __run_timers.part.0+0x67c/0xaa0 kernel/time/timer.c:1755
 >    __run_timers kernel/time/timer.c:1736 [inline]
 >    run_timer_softirq+0xae/0x1a0 kernel/time/timer.c:1768
 >    __do_softirq+0x1f7/0xa91 kernel/softirq.c:298
 >    asm_call_on_stack+0xf/0x20 arch/x86/entry/entry_64.S:706
 >    __run_on_irqstack arch/x86/include/asm/irq_stack.h:22 [inline]
 >    run_on_irqstack_cond arch/x86/include/asm/irq_stack.h:48 [inline]
 >    do_softirq_own_stack+0x9d/0xd0 arch/x86/kernel/irq_64.c:77
 >    invoke_softirq kernel/softirq.c:393 [inline]
 >    __irq_exit_rcu kernel/softirq.c:423 [inline]
 >    irq_exit_rcu+0x235/0x280 kernel/softirq.c:435
 >    sysvec_apic_timer_interrupt+0x51/0xf0 arch/x86/kernel/apic/apic.c:1091
 >    asm_sysvec_apic_timer_interrupt+0x12/0x20 
arch/x86/include/asm/idtentry.h:581
 >    unwind_next_frame+0x139a/0x1f90 arch/x86/kernel/unwind_orc.c:607
 >    arch_stack_walk+0x81/0xf0 arch/x86/kernel/stacktrace.c:25
 >    stack_trace_save+0x8c/0xc0 kernel/stacktrace.c:123
 >    kasan_save_stack+0x1b/0x40 mm/kasan/common.c:48
 >    kasan_set_track mm/kasan/common.c:56 [inline]
 >    __kasan_kmalloc.constprop.0+0xbf/0xd0 mm/kasan/common.c:461
 >    slab_post_alloc_hook mm/slab.h:518 [inline]
 >    slab_alloc mm/slab.c:3312 [inline]
 >    kmem_cache_alloc+0x13a/0x3a0 mm/slab.c:3482
 >    __d_alloc+0x2a/0x950 fs/dcache.c:1709
 >    d_alloc+0x4a/0x230 fs/dcache.c:1788
 >    d_alloc_parallel+0xe9/0x18e0 fs/dcache.c:2540
 >    lookup_open.isra.0+0x9ac/0x1350 fs/namei.c:3030
 >    open_last_lookups fs/namei.c:3177 [inline]
 >    path_openat+0x96d/0x2730 fs/namei.c:3365
 >    do_filp_open+0x17e/0x3c0 fs/namei.c:3395
 >    do_sys_openat2+0x16d/0x420 fs/open.c:1168
 >    do_sys_open fs/open.c:1184 [inline]
 >    __do_sys_open fs/open.c:1192 [inline]
 >    __se_sys_open fs/open.c:1188 [inline]
 >    __x64_sys_open+0x119/0x1c0 fs/open.c:1188
 >    do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 >    entry_SYSCALL_64_after_hwframe+0x44/0xa9
 > irq event stamp: 853
 > hardirqs last  enabled at (853): [<ffffffff87f733af>] 
__raw_spin_unlock_irq include/linux/spinlock_api_smp.h:168 [inline]
 > hardirqs last  enabled at (853): [<ffffffff87f733af>] 
_raw_spin_unlock_irq+0x1f/0x80 kernel/locking/spinlock.c:199
 > hardirqs last disabled at (852): [<ffffffff87f73764>] 
__raw_spin_lock_irq include/linux/spinlock_api_smp.h:126 [inline]
 > hardirqs last disabled at (852): [<ffffffff87f73764>] 
_raw_spin_lock_irq+0xa4/0xd0 kernel/locking/spinlock.c:167
 > softirqs last  enabled at (0): [<ffffffff8144c929>] 
copy_process+0x1a99/0x6920 kernel/fork.c:2018
 > softirqs last disabled at (0): [<0000000000000000>] 0x0
 >
 > other info that might help us debug this:
 >   Possible unsafe locking scenario:
 >
 >         CPU0
 >         ----
 >    lock(slock-AF_BLUETOOTH-BTPROTO_SCO);
 >    <Interrupt>
 >      lock(slock-AF_BLUETOOTH-BTPROTO_SCO);
 >
 >   *** DEADLOCK ***
 >
 > 3 locks held by syz-executor675/31233:
 >   #0: ffff88809f104f40 (&hdev->req_lock){+.+.}-{3:3}, at: 
hci_dev_do_close+0xf5/0x1080 net/bluetooth/hci_core.c:1720
 >   #1: ffff88809f104078 (&hdev->lock){+.+.}-{3:3}, at: 
hci_dev_do_close+0x253/0x1080 net/bluetooth/hci_core.c:1757
 >   #2: ffffffff8a9188c8 (hci_cb_list_lock){+.+.}-{3:3}, at: 
hci_disconn_cfm include/net/bluetooth/hci_core.h:1435 [inline]
 >   #2: ffffffff8a9188c8 (hci_cb_list_lock){+.+.}-{3:3}, at: 
hci_conn_hash_flush+0xc7/0x220 net/bluetooth/hci_conn.c:1557
 >
 > stack backtrace:
 > CPU: 1 PID: 31233 Comm: syz-executor675 Not tainted 
5.9.0-rc4-syzkaller #0
 > Hardware name: Google Google Compute Engine/Google Compute Engine, 
BIOS Google 01/01/2011
 > Call Trace:
 >   __dump_stack lib/dump_stack.c:77 [inline]
 >   dump_stack+0x198/0x1fd lib/dump_stack.c:118
 >   print_usage_bug kernel/locking/lockdep.c:4020 [inline]
 >   valid_state kernel/locking/lockdep.c:3361 [inline]
 >   mark_lock_irq kernel/locking/lockdep.c:3560 [inline]
 >   mark_lock.cold+0x7a/0x7f kernel/locking/lockdep.c:4006
 >   mark_usage kernel/locking/lockdep.c:3923 [inline]
 >   __lock_acquire+0x876/0x5570 kernel/locking/lockdep.c:4380
 >   lock_acquire+0x1f3/0xae0 kernel/locking/lockdep.c:5006
 >   __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
 >   _raw_spin_lock+0x2a/0x40 kernel/locking/spinlock.c:151
 >   spin_lock include/linux/spinlock.h:354 [inline]
 >   sco_conn_del+0x128/0x270 net/bluetooth/sco.c:176

Locking slock-AF_BLUETOOTH-BTPROTO_SCO may happen in process context or 
BH context. If in process context, we should use lock_sock(). 
sco_conn_del() is called in process context here, so how about using
lock_sock() instead of bh_lock_sock()

changes as:
diff --git a/net/bluetooth/sco.c b/net/bluetooth/sco.c
index dcf7f96ff417..559b883c815f 100644
--- a/net/bluetooth/sco.c
+++ b/net/bluetooth/sco.c
@@ -173,10 +173,10 @@ static void sco_conn_del(struct hci_conn *hcon, 
int err)

         if (sk) {
                 sock_hold(sk);
-               bh_lock_sock(sk);
+               lock_sock(sk);
                 sco_sock_clear_timer(sk);
                 sco_chan_del(sk, err);
-               bh_unlock_sock(sk);
+               release_sock(sk);
                 sco_sock_kill(sk);
                 sock_put(sk);
         }
-- 

Regards,

Yanfei

 >   sco_disconn_cfm net/bluetooth/sco.c:1178 [inline]
 >   sco_disconn_cfm+0x62/0x80 net/bluetooth/sco.c:1171
 >   hci_disconn_cfm include/net/bluetooth/hci_core.h:1438 [inline]
 >   hci_conn_hash_flush+0x114/0x220 net/bluetooth/hci_conn.c:1557
 >   hci_dev_do_close+0x5c6/0x1080 net/bluetooth/hci_core.c:1770
 >   hci_unregister_dev+0x1bd/0xe30 net/bluetooth/hci_core.c:3790
 >   vhci_release+0x70/0xe0 drivers/bluetooth/hci_vhci.c:340
 >   __fput+0x285/0x920 fs/file_table.c:281
 >   task_work_run+0xdd/0x190 kernel/task_work.c:141
 >   exit_task_work include/linux/task_work.h:25 [inline]
 >   do_exit+0xb7d/0x29f0 kernel/exit.c:806
 >   do_group_exit+0x125/0x310 kernel/exit.c:903
 >   get_signal+0x428/0x1f00 kernel/signal.c:2757
 >   arch_do_signal+0x82/0x2520 arch/x86/kernel/signal.c:811
 >   exit_to_user_mode_loop kernel/entry/common.c:159 [inline]
 >   exit_to_user_mode_prepare+0x1ae/0x200 kernel/entry/common.c:190
 >   syscall_exit_to_user_mode+0x7e/0x2e0 kernel/entry/common.c:265
 >   entry_SYSCALL_64_after_hwframe+0x44/0xa9
 > RIP: 0033:0x447279
 > Code: Bad RIP value.
 > RSP: 002b:00007fd19f624d88 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
 > RAX: fffffffffffffe00 RBX: 00000000006dcc28 RCX: 0000000000447279
 > RDX: 0000000000000000 RSI: 0000000000000080 RDI: 00000000006dcc28
 > RBP: 00000000006dcc20 R08: 0000000000000000 R09: 0000000000000000
 > R10: 0000000000000000 R11: 0000000000000246 R12: 00000000006dcc2c
 > R13: 0000000000000004 R14: 0000000000000003 R15: 00007fd19f6256d0
 >
