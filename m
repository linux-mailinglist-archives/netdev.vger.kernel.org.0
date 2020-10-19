Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAA2D2920FB
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 03:54:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730604AbgJSByQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Oct 2020 21:54:16 -0400
Received: from mail-eopbgr760077.outbound.protection.outlook.com ([40.107.76.77]:20452
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727019AbgJSByP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 18 Oct 2020 21:54:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L/Lvkld6dy4jm/fdJVK8jRZMgNgicZbcfaOIUPlL3cYxE0bTQWFDK596th2jAYdBuKRqGE4/5HDemaMrvkIyqmSfufDotY0M/Yxuevr9mrF/6F0gmirzQI83Wtubx9ZXfHe9hMMldbhK6oY+UYq0Lw3i+iftr+12wuwq08ZTx+CBbssoe1KtsMrq45jlBtYnf8FkPfOi1gwsnCe4DqHz26dT/lUZGaLrieJ9fQFojs4uEy1DXdrlNqwVlYx2NX3Wa05kUdlQdPXV5bUP7ADUOyEN1OWrcGFdIFcmbbOVKx6xwZn75tO7H9Khso//xR+UTju43/mAhOo7Cxxl7YMtTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OLiGG3MgiZOF6Tsu8uoPXzuiny36KiHlEWTePXcVvhQ=;
 b=RiCwPMd8cokjWWa+VLo72dwOKxcjK8n/MKag8TLEKOJQfOhevm7o/ySDdgsdYHXoEb82IR4vhMYPkYwMaMnGj0Js06vf+rM542Xfz4MFsCQaxh9VwKzdoYvVYYLhZdEJXs+iNYQpeuUt/5avkoKPxTsoQFzKuHLxRj50yL1mPgpyo/jhVqAq0/wxGtPcfPvBqdPwGZZjPM5MJ6cuFCrzd2EYXjE6aL01jlqQAns/2o26OIeejBf2q6+5ki0LuWsgAJnmrfNOO+Xw0n9oa9JNE4s9sjApyUYNQZIE/39LsoR7RrDzqQoWbSqINMG/UaNU+OCjRmk/8HxC2mg2TFC2/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=windriversystems.onmicrosoft.com;
 s=selector2-windriversystems-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OLiGG3MgiZOF6Tsu8uoPXzuiny36KiHlEWTePXcVvhQ=;
 b=qEDCawoeNSQl7GDBB0LY8CsIGjgZP+sUvXdckR3o6BL6ogaOUdnATuXaudB51U9lNdZ7prawwCSPcToDzSCmmFo3Tui0m4moPJc1SDijBJBG8vMj8nFpVOiwQLE7DpdIuQFc7y1udoltshRhWaep5pjAWlF6Bc/RXlKLfkV3xdY=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from BY5PR11MB4241.namprd11.prod.outlook.com (2603:10b6:a03:1ca::13)
 by BYAPR11MB2904.namprd11.prod.outlook.com (2603:10b6:a03:87::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.28; Mon, 19 Oct
 2020 01:54:10 +0000
Received: from BY5PR11MB4241.namprd11.prod.outlook.com
 ([fe80::adbd:559a:4a78:f09b]) by BY5PR11MB4241.namprd11.prod.outlook.com
 ([fe80::adbd:559a:4a78:f09b%6]) with mapi id 15.20.3477.028; Mon, 19 Oct 2020
 01:54:10 +0000
Subject: Re: [PATCH] Bluetooth: Use lock_sock() when acquiring lock in
 sco_conn_del
To:     Hillf Danton <hdanton@sina.com>
Cc:     marcel@holtmann.org, johan.hedberg@gmail.com, davem@davemloft.net,
        kuba@kernel.org, linux-bluetooth@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20201014071731.34279-1-yanfei.xu@windriver.com>
 <20201014123113.21888-1-hdanton@sina.com>
 <20201016041028.601-1-hdanton@sina.com>
From:   "Xu, Yanfei" <yanfei.xu@windriver.com>
Message-ID: <66fa69e5-a184-7924-229b-0dd7067989ee@windriver.com>
Date:   Mon, 19 Oct 2020 09:54:01 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
In-Reply-To: <20201016041028.601-1-hdanton@sina.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [60.247.85.82]
X-ClientProxiedBy: HK2PR02CA0205.apcprd02.prod.outlook.com
 (2603:1096:201:20::17) To BY5PR11MB4241.namprd11.prod.outlook.com
 (2603:10b6:a03:1ca::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [128.224.162.160] (60.247.85.82) by HK2PR02CA0205.apcprd02.prod.outlook.com (2603:1096:201:20::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.20 via Frontend Transport; Mon, 19 Oct 2020 01:54:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2b00a232-86f3-48c8-e845-08d873d1df56
X-MS-TrafficTypeDiagnostic: BYAPR11MB2904:
X-Microsoft-Antispam-PRVS: <BYAPR11MB29040CC8C8922C10DF7D48C5E41E0@BYAPR11MB2904.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FYjGP5qDaS4OJ5uibuQNuRgKzIjqRuQQajKqzqvtKafeeKK9HGE/KBsS+N7Dpf/0WDDfJS10Dg31ijBF/X87nqGJv5+8VeZ0TWDVAp3JQxJ7zm7sbxU00OrziZThc2Ty8rJnr5ujOCka1GVrYh31qW+ayW7DQP+xlnrMntaeyud7nJHce4Qa5/ylJwzk3WsXIdywPLjCwKC3VdI4lh2E/tscxArC8yOMHoDVD1PPMRDptuBM2jfO2+iWzdHDbe6veHki1HyJVuuqGTi8kCZM0BJbVsFTr69e9Si0xFC/8zTGHMLuq+7vWMfr+AqrIR+Nb+IrqlnJmQOM9/4fh2vJ1PMIJB0ESTIZJrbi+g/DzQKbYlovEg5qsba/PA2+YT70o0LZGclC/hOTeEk4vUyrJw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB4241.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(366004)(376002)(396003)(39840400004)(53546011)(2906002)(86362001)(5660300002)(36756003)(478600001)(6916009)(31686004)(16526019)(26005)(6706004)(31696002)(8676002)(956004)(2616005)(52116002)(8936002)(6486002)(186003)(83380400001)(16576012)(66556008)(66946007)(316002)(4326008)(66476007)(6666004)(78286007)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: w+i2LHNZWtrGjPOVTFLZMg5UQrRCOo0rublM2jXagNLi94rajXBafobToN75IdeYtVEOSqhnub9Zr1KJMA31FalY7ccufD3goKbVXkXrdY8jS2pc1Fd/AHcdOiYmw8/LqykdFMuqOHVpLdoEfVc/2J7pIineDxkIKNmKk6SsSnQicqGZUrUrBuuORxSctmlprdllsn/Q26rh4FidEdBIdGVzMMbdU/9PYZIY4xCQ14J3cwajpLBZWYbjVudeJaV7+jf5bAyyT4fnOTEOa7k1QaWjXlFuIoq4sZ+H8iqeNQvT/S2G5DtL6YEubCIVG06LttFti3mgHPlBB/xAdvyk2twuMXjLrqR9NfwzkXUbPl6ieQ3mOy3YcQIWgWYaMxd/7ndGnLGgKZApR0qQ2eMMLvTk9Dtb96G5bkveQ6xaoFsdANCILOjcPFkLlluIUgeLscxVS8zwpCCxc5UeO5jntZ+qHdJE1Z+4uqd6IX0DOc/L/x+xqEavdhhVDkPcIWiTKFvdrebGPrDY7d8s+6RTgNk5qc98HiHGI4J4p5CSn/9krMas00uwYb+eFN3c+dWNBr4We4ujUZ7yDhosuic7DYx8X/CxcoQU6a7mV2H/GyC0JIyEZf+Bd+mg+HSa6wefRJvP+6vg+Xm9XQSsqZ412g==
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b00a232-86f3-48c8-e845-08d873d1df56
X-MS-Exchange-CrossTenant-AuthSource: BY5PR11MB4241.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2020 01:54:10.7557
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EKcODLnNOHz6gVBaKo9dVjAPVEEHGfv6we2jADAgK4SGwKfrFWcJQLKN5d5BZWDxszlLoMFDuGrEOgDVqgAIPA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2904
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/16/20 12:10 PM, Hillf Danton wrote:
> On Fri, 16 Oct 2020 11:15:27 +0800 Yanfei Xu wrote:
>> On 10/14/20 8:31 PM, Hillf Danton wrote:
>>>
>>> On Wed, 14 Oct 2020 15:17:31 +0800
>>>> From: Yanfei Xu <yanfei.xu@windriver.com>
>>>>
>>>> Locking slock-AF_BLUETOOTH-BTPROTO_SCO may happen in process context or
>>>> BH context. If in process context, we should use lock_sock(). As blow
>>>> warning, sco_conn_del() is called in process context, so let's use
>>>> lock_sock() instead of bh_lock_sock().
>>>>
>>> Sounds opposite because blocking BH in BH context provides no extra
>>> protection while it makes sense in the less critical context particularly
>>> wrt sock lock.
>>>
>>>> ================================
>>>> WARNING: inconsistent lock state
>>>> 5.9.0-rc4-syzkaller #0 Not tainted
>>>> --------------------------------
>>>> inconsistent {IN-SOFTIRQ-W} -> {SOFTIRQ-ON-W} usage.
>>>> syz-executor675/31233 [HC0[0]:SC0[0]:HE1:SE1] takes:
>>>> ffff8880a75c50a0 (slock-AF_BLUETOOTH-BTPROTO_SCO){+.?.}-{2:2}, at:
>>>> spin_lock include/linux/spinlock.h:354 [inline]
>>>> ffff8880a75c50a0 (slock-AF_BLUETOOTH-BTPROTO_SCO){+.?.}-{2:2}, at:
>>>> sco_conn_del+0x128/0x270 net/bluetooth/sco.c:176
>>>> {IN-SOFTIRQ-W} state was registered at:
>>>>     lock_acquire+0x1f3/0xae0 kernel/locking/lockdep.c:5006
>>>>     __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
>>>>     _raw_spin_lock+0x2a/0x40 kernel/locking/spinlock.c:151
>>>>     spin_lock include/linux/spinlock.h:354 [inline]
>>>>     sco_sock_timeout+0x24/0x140 net/bluetooth/sco.c:83
>>>>     call_timer_fn+0x1ac/0x760 kernel/time/timer.c:1413
>>>>     expire_timers kernel/time/timer.c:1458 [inline]
>>>>     __run_timers.part.0+0x67c/0xaa0 kernel/time/timer.c:1755
>>>>     __run_timers kernel/time/timer.c:1736 [inline]
>>>>     run_timer_softirq+0xae/0x1a0 kernel/time/timer.c:1768
>>>>     __do_softirq+0x1f7/0xa91 kernel/softirq.c:298
>>>>     asm_call_on_stack+0xf/0x20 arch/x86/entry/entry_64.S:706
>>>>     __run_on_irqstack arch/x86/include/asm/irq_stack.h:22 [inline]
>>>>     run_on_irqstack_cond arch/x86/include/asm/irq_stack.h:48 [inline]
>>>>     do_softirq_own_stack+0x9d/0xd0 arch/x86/kernel/irq_64.c:77
>>>>     invoke_softirq kernel/softirq.c:393 [inline]
>>>>     __irq_exit_rcu kernel/softirq.c:423 [inline]
>>>>     irq_exit_rcu+0x235/0x280 kernel/softirq.c:435
>>>>     sysvec_apic_timer_interrupt+0x51/0xf0 arch/x86/kernel/apic/apic.c:1091
>>>>     asm_sysvec_apic_timer_interrupt+0x12/0x20
>>>>     arch/x86/include/asm/idtentry.h:581
>>>>     unwind_next_frame+0x139a/0x1f90 arch/x86/kernel/unwind_orc.c:607
>>>>     arch_stack_walk+0x81/0xf0 arch/x86/kernel/stacktrace.c:25
>>>>     stack_trace_save+0x8c/0xc0 kernel/stacktrace.c:123
>>>>     kasan_save_stack+0x1b/0x40 mm/kasan/common.c:48
>>>>     kasan_set_track mm/kasan/common.c:56 [inline]
>>>>     __kasan_kmalloc.constprop.0+0xbf/0xd0 mm/kasan/common.c:461
>>>>     slab_post_alloc_hook mm/slab.h:518 [inline]
>>>>     slab_alloc mm/slab.c:3312 [inline]
>>>>     kmem_cache_alloc+0x13a/0x3a0 mm/slab.c:3482
>>>>     __d_alloc+0x2a/0x950 fs/dcache.c:1709
>>>>     d_alloc+0x4a/0x230 fs/dcache.c:1788
>>>>     d_alloc_parallel+0xe9/0x18e0 fs/dcache.c:2540
>>>>     lookup_open.isra.0+0x9ac/0x1350 fs/namei.c:3030
>>>>     open_last_lookups fs/namei.c:3177 [inline]
>>>>     path_openat+0x96d/0x2730 fs/namei.c:3365
>>>>     do_filp_open+0x17e/0x3c0 fs/namei.c:3395
>>>>     do_sys_openat2+0x16d/0x420 fs/open.c:1168
>>>>     do_sys_open fs/open.c:1184 [inline]
>>>>     __do_sys_open fs/open.c:1192 [inline]
>>>>     __se_sys_open fs/open.c:1188 [inline]
>>>>     __x64_sys_open+0x119/0x1c0 fs/open.c:1188
>>>>     do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>>>>     entry_SYSCALL_64_after_hwframe+0x44/0xa9
>>>> irq event stamp: 853
>>>> hardirqs last  enabled at (853): [<ffffffff87f733af>]
>>>> __raw_spin_unlock_irq include/linux/spinlock_api_smp.h:168 [inline]
>>>> hardirqs last  enabled at (853): [<ffffffff87f733af>]
>>>> _raw_spin_unlock_irq+0x1f/0x80 kernel/locking/spinlock.c:199
>>>> hardirqs last disabled at (852): [<ffffffff87f73764>]
>>>> __raw_spin_lock_irq include/linux/spinlock_api_smp.h:126 [inline]
>>>> hardirqs last disabled at (852): [<ffffffff87f73764>]
>>>> _raw_spin_lock_irq+0xa4/0xd0 kernel/locking/spinlock.c:167
>>>> softirqs last  enabled at (0): [<ffffffff8144c929>]
>>>> copy_process+0x1a99/0x6920 kernel/fork.c:2018
>>>> softirqs last disabled at (0): [<0000000000000000>] 0x0
>>>>
>>>> other info that might help us debug this:
>>>>    Possible unsafe locking scenario:
>>>>
>>>>          CPU0
>>>>          ----
>>>>     lock(slock-AF_BLUETOOTH-BTPROTO_SCO);
>>>>     <Interrupt>
>>>>       lock(slock-AF_BLUETOOTH-BTPROTO_SCO);
>>>>
>>>>    *** DEADLOCK ***
>>>>
>>>> 3 locks held by syz-executor675/31233:
>>>>    #0: ffff88809f104f40 (&hdev->req_lock){+.+.}-{3:3}, at:
>>>> hci_dev_do_close+0xf5/0x1080 net/bluetooth/hci_core.c:1720
>>>>    #1: ffff88809f104078 (&hdev->lock){+.+.}-{3:3}, at:
>>>> hci_dev_do_close+0x253/0x1080 net/bluetooth/hci_core.c:1757
>>>>    #2: ffffffff8a9188c8 (hci_cb_list_lock){+.+.}-{3:3}, at:
>>>> hci_disconn_cfm include/net/bluetooth/hci_core.h:1435 [inline]
>>>>    #2: ffffffff8a9188c8 (hci_cb_list_lock){+.+.}-{3:3}, at:
>>>> hci_conn_hash_flush+0xc7/0x220 net/bluetooth/hci_conn.c:1557
>>>>
>>>> stack backtrace:
>>>> CPU: 1 PID: 31233 Comm: syz-executor675 Not tainted 5.9.0-rc4-syzkaller
>>>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
>>>> Google 01/01/2011
>>>> Call Trace:
>>>>    __dump_stack lib/dump_stack.c:77 [inline]
>>>>    dump_stack+0x198/0x1fd lib/dump_stack.c:118
>>>>    print_usage_bug kernel/locking/lockdep.c:4020 [inline]
>>>>    valid_state kernel/locking/lockdep.c:3361 [inline]
>>>>    mark_lock_irq kernel/locking/lockdep.c:3560 [inline]
>>>>    mark_lock.cold+0x7a/0x7f kernel/locking/lockdep.c:4006
>>>>    mark_usage kernel/locking/lockdep.c:3923 [inline]
>>>>    __lock_acquire+0x876/0x5570 kernel/locking/lockdep.c:4380
>>>>    lock_acquire+0x1f3/0xae0 kernel/locking/lockdep.c:5006
>>>>    __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
>>>>    _raw_spin_lock+0x2a/0x40 kernel/locking/spinlock.c:151
>>>>    spin_lock include/linux/spinlock.h:354 [inline]
>>>>    sco_conn_del+0x128/0x270 net/bluetooth/sco.c:176
>>>>    sco_disconn_cfm net/bluetooth/sco.c:1178 [inline]
>>>>    sco_disconn_cfm+0x62/0x80 net/bluetooth/sco.c:1171
>>>>    hci_disconn_cfm include/net/bluetooth/hci_core.h:1438 [inline]
>>>>    hci_conn_hash_flush+0x114/0x220 net/bluetooth/hci_conn.c:1557
>>>>    hci_dev_do_close+0x5c6/0x1080 net/bluetooth/hci_core.c:1770
>>>>    hci_unregister_dev+0x1bd/0xe30 net/bluetooth/hci_core.c:3790
>>>>    vhci_release+0x70/0xe0 drivers/bluetooth/hci_vhci.c:340
>>>>    __f put+0x285/0x920 fs/file_table.c:281
>>>>    task_work_run+0xdd/0x190 kernel/task_work.c:141
>>>>    exit_task_work include/linux/task_work.h:25 [inline]
>>>>    do_exit+0xb7d/0x29f0 kernel/exit.c:806
>>>>    do_group_exit+0x125/0x310 kernel/exit.c:903
>>>>    get_signal+0x428/0x1f00 kernel/signal.c:2757
>>>>    arch_do_signal+0x82/0x2520 arch/x86/kernel/signal.c:811
>>>>    exit_to_user_mode_loop kernel/entry/common.c:159 [inline]
>>>>    exit_to_user_mode_prepare+0x1ae/0x200 kernel/entry/common.c:190
>>>>    syscall_exit_to_user_mode+0x7e/0x2e0 kernel/entry/common.c:265
>>>>    entry_SYSCALL_64_after_hwframe+0x44/0xa9
>>>> RIP: 0033:0x447279
>>>>
>>>> Reported-by: syzbot+65684128cd7c35bc66a1@syzkaller.appspotmail.com
>>>> Signed-off-by: Yanfei Xu <yanfei.xu@windriver.com>
>>>> ---
>>>>    net/bluetooth/sco.c | 4 ++--
>>>>    1 file changed, 2 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/net/bluetooth/sco.c b/net/bluetooth/sco.c
>>>> index dcf7f96ff417..559b883c815f 100644
>>>> --- a/net/bluetooth/sco.c
>>>> +++ b/net/bluetooth/sco.c
>>>> @@ -173,10 +173,10 @@ static void sco_conn_del(struct hci_conn *hcon, int err)
>>>>    
>>>>    	if (sk) {
>>>>    		sock_hold(sk);
>>>> -		bh_lock_sock(sk);
>>>> +		lock_sock(sk);
>>>>    		sco_sock_clear_timer(sk);
>>>>    		sco_chan_del(sk, err);
>>>> -		bh_unlock_sock(sk);
>>>> +		release_sock(sk);
>>>>    		sco_sock_kill(sk);
>>>>    		sock_put(sk);
>>>>    	}
>>>> -- 
>>>> 2.18.2
>>>
>>>
>>> --- a/net/bluetooth/sco.c
>>> +++ b/net/bluetooth/sco.c
>>> @@ -80,10 +80,10 @@ static void sco_sock_timeout(struct time
>>>    
>>>    	BT_DBG("sock %p state %d", sk, sk->sk_state);
>>>    
>>> -	bh_lock_sock(sk);
>>> +	lock_sock(sk);
>>>    	sk->sk_err = ETIMEDOUT;
>>>    	sk->sk_state_change(sk);
>>> -	bh_unlock_sock(sk);
>>> +	unlock_sock(sk);
>>>    
>>>    	sco_sock_kill(sk);
>>>    	sock_put(sk);
>>>
>> Hi Hillf,
>>
>> Thanks for your reply! But I don't clearly understand what you mean.
>>
>> After your change, If sco_conn_del（） have got the lock and then run into
>> sco_sock_timeout which is in BH, the potential deadlock is still exsit.
> 
> My change is incorrect. Thanks for your reply.
> 
>>
>> As the function define, use bh_lock_sock in sco_sock_timeout(BH context)
>> is right. The root cause is prevent from locking in BH after we've got
>> the lock in sco_conn_del, isn't it?
>>
>> /* BH context may only use the following locking interface. */
>> #define bh_lock_sock(__sk)      spin_lock(&((__sk)->sk_lock.slock))
> 
> Then replacing bh_lock_sock() with lock_sock() in sco_conn_del() seems
> not to work because bh is enabled after lock_sock(). What we want instead
> is block bh here until we release sock, something like the diff below.
> 
> --- a/net/bluetooth/sco.c
> +++ b/net/bluetooth/sco.c
> @@ -173,10 +173,12 @@ static void sco_conn_del(struct hci_conn
>   
>   	if (sk) {
>   		sock_hold(sk);
> +		local_bh_disable();
>   		bh_lock_sock(sk);
>   		sco_sock_clear_timer(sk);
>   		sco_chan_del(sk, err);
>   		bh_unlock_sock(sk);
> +		local_bh_enable();
>   		sco_sock_kill(sk);
>   		sock_put(sk);
>   	}
> 

Anyone else have any suggestion? :)

Thanks,
Yanfei
