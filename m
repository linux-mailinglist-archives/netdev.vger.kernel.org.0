Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1814A64C6D
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 20:56:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727476AbfGJS4o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 14:56:44 -0400
Received: from mail2.candelatech.com ([208.74.158.173]:46162 "EHLO
        mail3.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726245AbfGJS4o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 14:56:44 -0400
X-Greylist: delayed 301 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Jul 2019 14:56:43 EDT
Received: from [192.168.100.195] (50-251-239-81-static.hfc.comcastbusiness.net [50.251.239.81])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id 1285A279EC
        for <netdev@vger.kernel.org>; Wed, 10 Jul 2019 11:51:42 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 1285A279EC
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1562784702;
        bh=nToMntR7hzqTuNGLJxSMXuFLcCuwgrahtP2U1Yq/XjU=;
        h=To:From:Subject:Date:From;
        b=qEIAjjQui59U+JVKk++gxYmWtve8MdhOwad/LC4sX93BxLxWW1oPEtBmMz9Dz8HjK
         b+SSrCpuAwiRWK/bb+o4AFcVlCh9d0TGJ3zCftNe6LDUCMzdvaULtxINVz/nTKspkv
         xqAvjezKWrMTS4IxEc+63l3xDhsMS9YI2bxl0PAA=
To:     netdev <netdev@vger.kernel.org>
From:   Ben Greear <greearb@candelatech.com>
Subject: lockup in hacked 4.20.17+ kernel, maybe addrconf_verify_work related?
Organization: Candela Technologies
Message-ID: <85e1d1d2-076c-439e-6261-32394e2a8273@candelatech.com>
Date:   Wed, 10 Jul 2019 11:51:41 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

This is with my hacked-upon kernel, could be my mistake, etc.  But, curious
if anyone else has seen a similar deadlock?  I was running a complicated automated
wifi test, for what that is worth.

66707.212081] ath: regdomain 0x8348 dynamically updated by user
[67044.625948] INFO: task kworker/0:0:27387 blocked for more than 180 seconds.
[67044.631831]       Tainted: G        W  O      4.20.17+ #30
[67044.636180] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[67044.647424] kworker/0:0     D    0 27387      2 0x80000080
[67044.647447] Workqueue: ipv6_addrconf addrconf_verify_work [ipv6]
[67044.647448] Call Trace:
[67044.647455]  ? __schedule+0x29e/0x880
[67044.647457]  schedule+0x2a/0x80
[67044.647459]  schedule_preempt_disabled+0xc/0x20
[67044.647460]  __mutex_lock.isra.10+0x2e7/0x4f0
[67044.647468]  addrconf_verify_work+0x5/0x10 [ipv6]
[67044.647472]  process_one_work+0x1f3/0x420
[67044.647473]  worker_thread+0x28/0x3c0
[67044.647475]  ? process_one_work+0x420/0x420
[67044.647476]  kthread+0x10b/0x130
[67044.647478]  ? kthread_create_on_node+0x60/0x60
[67044.647480]  ret_from_fork+0x1f/0x30
[67044.647491] INFO: task DNS Resolver #6:19810 blocked for more than 180 seconds.
[67044.656865]       Tainted: G        W  O      4.20.17+ #30
[67044.661364] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[67044.670861] DNS Resolver #6 D    0 19810  19213 0x00000080
[67044.670863] Call Trace:
[67044.670870]  ? __schedule+0x29e/0x880
[67044.670872]  schedule+0x2a/0x80
[67044.670874]  schedule_preempt_disabled+0xc/0x20
[67044.670876]  __mutex_lock.isra.10+0x2e7/0x4f0
[67044.670879]  ? netlink_lookup+0x111/0x160
[67044.670881]  __netlink_dump_start+0x4f/0x1d0
[67044.670883]  ? rtnl_xdp_prog_skb+0x60/0x60
[67044.670885]  rtnetlink_rcv_msg+0x25c/0x390
[67044.670886]  ? rtnl_xdp_prog_skb+0x60/0x60
[67044.670888]  ? rtnl_calcit.isra.31+0x110/0x110
[67044.670889]  netlink_rcv_skb+0x44/0x120
[67044.670891]  netlink_unicast+0x18b/0x220
[67044.670893]  netlink_sendmsg+0x1ff/0x3d0
[67044.670896]  sock_sendmsg+0x2b/0x40
[67044.670898]  __sys_sendto+0xe9/0x150
[67044.670901]  ? __audit_syscall_exit+0x216/0x280
[67044.670903]  __x64_sys_sendto+0x1f/0x30
[67044.670906]  do_syscall_64+0x4a/0xf0
[67044.670909]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[67044.670911] RIP: 0033:0x7f94b119b6b0
[67044.670915] Code: Bad RIP value.
[67044.670915] RSP: 002b:00007f94817942e0 EFLAGS: 00000293 ORIG_RAX: 000000000000002c
[67044.670917] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f94b119b6b0
[67044.670917] RDX: 0000000000000014 RSI: 00007f9481795420 RDI: 000000000000004d
[67044.670918] RBP: 00007f9481795420 R08: 00007f94817953c4 R09: 000000000000000c
[67044.670919] R10: 0000000000000000 R11: 0000000000000293 R12: 0000000000000014
[67044.670919] R13: 00007f94817953c4 R14: 00007f947ff42208 R15: 000000000000004d
[67044.670933] INFO: task kworker/0:2:17500 blocked for more than 180 seconds.
[67044.678868]       Tainted: G        W  O      4.20.17+ #30
[67044.685860] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[67044.692746] kworker/0:2     D    0 17500      2 0x80000080
[67044.692787] Workqueue: events_power_efficient reg_check_chans_work [cfg80211]
[67044.692788] Call Trace:
[67044.692795]  ? __schedule+0x29e/0x880
[67044.692797]  schedule+0x2a/0x80
[67044.692799]  schedule_preempt_disabled+0xc/0x20
[67044.692800]  __mutex_lock.isra.10+0x2e7/0x4f0
[67044.692810]  reg_check_chans_work+0x28/0x350 [cfg80211]
[67044.692815]  process_one_work+0x1f3/0x420
[67044.692817]  worker_thread+0x28/0x3c0
[67044.692819]  ? process_one_work+0x420/0x420
[67044.692821]  kthread+0x10b/0x130
[67044.692822]  ? kthread_create_on_node+0x60/0x60
[67044.692825]  ret_from_fork+0x1f/0x30
[67044.692833] INFO: task iw:1488 blocked for more than 180 seconds.
[67044.700860]       Tainted: G        W  O      4.20.17+ #30
[67044.705216] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[67044.714862] iw              D    0  1488   1487 0x00000080
[67044.714864] Call Trace:
[67044.714871]  ? __schedule+0x29e/0x880
[67044.714874]  schedule+0x2a/0x80
[67044.714876]  schedule_preempt_disabled+0xc/0x20
[67044.714877]  __mutex_lock.isra.10+0x2e7/0x4f0
[67044.714915]  nl80211_dump_wiphy+0x1d/0x1b0 [cfg80211]
[67044.714919]  genl_lock_dumpit+0x23/0x40
[67044.714921]  netlink_dump+0x16d/0x360
[67044.714923]  __netlink_dump_start+0x168/0x1d0
[67044.714925]  genl_family_rcv_msg+0x25f/0x3a0
[67044.714927]  ? genl_lock_dumpit+0x40/0x40
[67044.714928]  ? genl_lock_done+0x40/0x40
[67044.714929]  ? genl_unlock+0x10/0x10
[67044.714931]  ? netlink_unicast+0x1ff/0x220
[67044.714932]  genl_rcv_msg+0x42/0x87
[67044.714934]  ? genl_family_rcv_msg+0x3a0/0x3a0
[67044.714935]  netlink_rcv_skb+0x44/0x120
[67044.714937]  genl_rcv+0x1f/0x30
[67044.714939]  netlink_unicast+0x18b/0x220
[67044.714940]  netlink_sendmsg+0x1ff/0x3d0
[67044.714944]  sock_sendmsg+0x2b/0x40
[67044.714946]  ___sys_sendmsg+0x28a/0x2f0
[67044.714947]  ? ___sys_recvmsg+0x156/0x1d0
[67044.714950]  ? __alloc_pages_nodemask+0x111/0x280
[67044.714954]  ? alloc_pages_vma+0x6f/0x1c0
[67044.714957]  ? page_add_new_anon_rmap+0x72/0xb0
[67044.714958]  ? __handle_mm_fault+0x7db/0x12c0
[67044.714961]  __sys_sendmsg+0x52/0xa0
[67044.714964]  do_syscall_64+0x4a/0xf0
[67044.714967]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[67044.714969] RIP: 0033:0x7fa9c4af15a7
[67044.714972] Code: Bad RIP value.
[67044.714973] RSP: 002b:00007fffdd7ac818 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
[67044.714974] RAX: ffffffffffffffda RBX: 00000000021ae990 RCX: 00007fa9c4af15a7
[67044.714975] RDX: 0000000000000000 RSI: 00007fffdd7ac8b0 RDI: 0000000000000008
[67044.714976] RBP: 00000000021b3d80 R08: 0000000000000004 R09: 00007fa9c4dabf20
[67044.714976] R10: 0000000000000170 R11: 0000000000000246 R12: 00000000021b3ec0
[67044.714977] R13: 00007fffdd7ac8b0 R14: 00000000021b3ec0 R15: 00007fffdd7acb18
[67044.714980] INFO: task sshd:1763 blocked for more than 180 seconds.
[67044.720810]       Tainted: G        W  O      4.20.17+ #30
[67044.725186] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[67044.732027] sshd            D    0  1763   1355 0x00000080
[67044.732029] Call Trace:
[67044.732038]  ? __schedule+0x29e/0x880
[67044.732040]  schedule+0x2a/0x80
[67044.732042]  schedule_preempt_disabled+0xc/0x20
[67044.732043]  __mutex_lock.isra.10+0x2e7/0x4f0
[67044.732046]  ? netlink_lookup+0x111/0x160
[67044.732048]  __netlink_dump_start+0x4f/0x1d0
[67044.732051]  ? rtnl_xdp_prog_skb+0x60/0x60
[67044.732052]  rtnetlink_rcv_msg+0x25c/0x390
[67044.732054]  ? rtnl_xdp_prog_skb+0x60/0x60
[67044.732055]  ? rtnl_calcit.isra.31+0x110/0x110
[67044.732057]  netlink_rcv_skb+0x44/0x120
[67044.732059]  netlink_unicast+0x18b/0x220
[67044.732060]  netlink_sendmsg+0x1ff/0x3d0
[67044.732064]  sock_sendmsg+0x2b/0x40
[67044.732066]  __sys_sendto+0xe9/0x150
[67044.732070]  ? __audit_syscall_exit+0x216/0x280
[67044.732071]  __x64_sys_sendto+0x1f/0x30
[67044.732075]  do_syscall_64+0x4a/0xf0
[67044.732077]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[67044.732079] RIP: 0033:0x7f16e29c765a
[67044.732082] Code: Bad RIP value.
[67044.732083] RSP: 002b:00007ffe57e52e88 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
[67044.732084] RAX: ffffffffffffffda RBX: 00007ffe57e53f80 RCX: 00007f16e29c765a
[67044.732085] RDX: 0000000000000014 RSI: 00007ffe57e53f80 RDI: 0000000000000003
[67044.732085] RBP: 00007ffe57e53fd0 R08: 00007ffe57e53f24 R09: 000000000000000c
[67044.732086] R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffe57e53f24
[67044.732087] R13: 00007ffe57e54160 R14: 0000000000000000 R15: 0000000000000003

Thanks,
Ben
-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

