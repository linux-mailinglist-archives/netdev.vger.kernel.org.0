Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D791365E7DA
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 10:32:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232144AbjAEJb6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 04:31:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231853AbjAEJb4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 04:31:56 -0500
Received: from mail-ua1-x932.google.com (mail-ua1-x932.google.com [IPv6:2607:f8b0:4864:20::932])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C798F551E5
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 01:31:53 -0800 (PST)
Received: by mail-ua1-x932.google.com with SMTP id u3so4841476uae.0
        for <netdev@vger.kernel.org>; Thu, 05 Jan 2023 01:31:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=80K6ioLUd/T5tsif3DIv3hXmRfcKhL7M84P/RHLwBEc=;
        b=aKtmHD19AND37MCCaphfYEXHM5SgruFzwINK2lKD2CFLdr0ekeV74eEiH9L06mzOAv
         9uL3DGFrgaRhWl2hYBMx3JrlwFLVLkbw2y+kVGvzICo6sm+BDrDELbAtLt+0BThS42iR
         48+B2ubOESCFpnl3KYEY15wEzNeQLdke/U+5PONIwkh4aBO/7zpwN95bYV2tCaSf+EgY
         hNBjJQq+9Wd3u5H0RZ0bvK3QAx3dghGoxIE+BRiKSxIYh1wIaiQLV+dQVdjWehXPQ0Pk
         yZaQkebpE/XAp1eAtntpsLcOgVPZ+N4Xx7ludEqV0fnJR7osjXm5K+C2gGb8Yyqzy0LI
         u83w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=80K6ioLUd/T5tsif3DIv3hXmRfcKhL7M84P/RHLwBEc=;
        b=OOUJlZ4EqWHno1cIjXGYD0NQ7Rc4phTjao5FkOp68NI06pqY04fQE2g7pU7FR6iTjP
         g4RZW5l4WW5br2uXvXOHLIP45asiMwarXP5ZkBXkGys7uTogVlD/r4+9c0yAQWRzswbo
         QcKwbOARt5zIYSqhhVT8s8OzWayO8H9+adwhKxwa3Y1PbO0yYgA3eRu452HPWfBKDcai
         bddXS3nR8Q5OQnSl7sOrGbkCbuRs/d4MyA2JXB9mI+9nN2wVjrl6nw7IYMGF+U3hj0il
         nq1/ZoMiot/qD7/L1UgqwOCAg30jaZ8pB6otNcbV1Ve9xmgMxjvbUmO7M93RjIzZg4/T
         HYEg==
X-Gm-Message-State: AFqh2kpxf3P7aOQmjKAN1Dd3Or+OS6uDIic3YrJ400mBDPyk+n4s678Y
        aMiZ0QQtf0QdPJwd5dyi0w3BhCJ4/Ya6ZXNcD4Mgog==
X-Google-Smtp-Source: AMrXdXvROkQ7jgShQNPOAP7ZlolJXB6UDAie3dtZl2TlGaXvHBTVVfJE3SoOi77TKm0S+fI61VfAGEuSv/PIKLQeykY=
X-Received: by 2002:ab0:5a49:0:b0:424:e8b8:7bcb with SMTP id
 m9-20020ab05a49000000b00424e8b87bcbmr4729044uad.123.1672911112453; Thu, 05
 Jan 2023 01:31:52 -0800 (PST)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 5 Jan 2023 15:01:41 +0530
Message-ID: <CA+G9fYuCLiL_SPE_cPwBE45TPNRwL=WhD5Ui0vFRzoS7W4XsTQ@mail.gmail.com>
Subject: selftests: netfilter: nft_fib.sh - BUG: spinlock recursion on CPU#0, modprobe/762
To:     open list <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        linux-stable <stable@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, lkft-triage@lists.linaro.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Following kernel BUG noticed on qemu_arm and BeagleBoard x15 while running
selftests: netfilter: nft_fib.sh test case.

This is always reproducible on stable-rc 6.1 and 6.0 [1].
Build, config, vmlinux and System.map links provided.


   unwind: Unknown symbol address bf02e1c8
   BUG: spinlock recursion on CPU#0, modprobe/762
     lock: unwind_lock+0x0/0x24, .magic: dead4ead, .owner:
modprobe/762, .owner_cpu: 0

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

[   49.898742] kselftest: Running tests in netfilter
TAP version 13
1..14
# selftests: netfilter: nft_fib.sh
# /dev/stdin:4:10-28: Error: Could not process rule: No such file or directory
#         fib saddr . iif oif missing counter log prefix
\"nsrouter-L7wUUW2r nft_rpfilter: \" drop
#         ^^^^^^^^^^^^^^^^^^^
# /dev/stdin:4:10-28: Error: Could not process rule: No such file or directory
#         fib saddr . iif oif missing counter log prefix
\"ns1-L7wUUW2r nft_rpfilter: \" drop
#         ^^^^^^^^^^^^^^^^^^^
# /dev/stdin:4:10-28: Error: Could not process rule: No such file or directory
#         fib saddr . iif oif missing counter log prefix
\"ns2-L7wUUW2r nft_rpfilter: \" drop
#         ^^^^^^^^^^^^^^^^^^^
[   55.484253] IPv6: ADDRCONF(NETDEV_CHANGE): veth0: link becomes ready
[   55.569226] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   55.670281] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   55.674377] IPv6: ADDRCONF(NETDEV_CHANGE): veth1: link becomes ready
# PASS: fib expression did not cause unwanted packet drops
# Error: Could not process rule: No such file or directory
# flush table inet filter
#                  ^^^^^^
# /dev/stdin:4:20-38: Error: Could not process rule: No such file or directory
# ip daddr 1.1.1.1 fib saddr . iif oif missing counter drop
#                  ^^^^^^^^^^^^^^^^^^^
# /dev/stdin:5:23-41: Error: Could not process rule: No such file or directory
# ip6 daddr 1c3::c01d fib saddr . iif oif missing counter drop
#                     ^^^^^^^^^^^^^^^^^^^
# Error: No such file or directory
# list table inet filter
#                 ^^^^^^
# Netns nsrouter-L7wUUW2r fib counter doesn't match expected packet
count of 0 for 1.1.1.1
# Error: No such file or directory
# list table inet filter
#                 ^^^^^^
not ok 1 selftests: netfilter: nft_fib.sh # exit=1
# selftests: netfilter: nft_nat.sh
[   70.428411] IPv6: ADDRCONF(NETDEV_CHANGE): veth0: link becomes ready
[   70.961660] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   70.965547] IPv6: ADDRCONF(NETDEV_CHANGE): veth1: link becomes ready
[   71.027372] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
# /dev/stdin:52:16-40: Error: Could not process rule: No such file or directory
# counter name ip saddr map @nsincounter
#              ^^^^^^^^^^^^^^^^^^^^^^^^^
# /dev/stdin:53:61-87: Error: Could not process rule: No such file or directory
# icmpv6 type { \"echo-request\", \"echo-reply\" } counter name ip6
saddr map @nsincounter6
#
^^^^^^^^^^^^^^^^^^^^^^^^^^^
# /dev/stdin:57:16-41: Error: Could not process rule: No such file or directory
# counter name ip daddr map @nsoutcounter
#              ^^^^^^^^^^^^^^^^^^^^^^^^^^
# /dev/stdin:58:61-88: Error: Could not process rule: No such file or directory
# icmpv6 type { \"echo-request\", \"echo-reply\" } counter name ip6
daddr map @nsoutcounter6
#
^^^^^^^^^^^^^^^^^^^^^^^^^^^^
# /dev/stdin:52:16-40: Error: Could not process rule: No such file or directory
# counter name ip saddr map @nsincounter
#              ^^^^^^^^^^^^^^^^^^^^^^^^^
# /dev/stdin:53:61-87: Error: Could not process rule: No such file or directory
# icmpv6 type { \"echo-request\", \"echo-reply\" } counter name ip6
saddr map @nsincounter6
#
^^^^^^^^^^^^^^^^^^^^^^^^^^^
# /dev/stdin:57:16-41: Error: Could not process rule: No such file or directory
# counter name ip daddr map @nsoutcounter
#              ^^^^^^^^^^^^^^^^^^^^^^^^^^
# /dev/stdin:58:61-88: Error: Could not process rule: No such file or directory
# icmpv6 type { \"echo-request\", \"echo-reply\" } counter name ip6
daddr map @nsoutcounter6
#
^^^^^^^^^^^^^^^^^^^^^^^^^^^^
# /dev/stdin:52:16-40: Error: Could not process rule: No such file or directory
# counter name ip saddr map @nsincounter
#              ^^^^^^^^^^^^^^^^^^^^^^^^^
# /dev/stdin:53:61-87: Error: Could not process rule: No such file or directory
# icmpv6 type { \"echo-request\", \"echo-reply\" } counter name ip6
saddr map @nsincounter6
#
^^^^^^^^^^^^^^^^^^^^^^^^^^^
# /dev/stdin:57:16-41: Error: Could not process rule: No such file or directory
# counter name ip daddr map @nsoutcounter
#              ^^^^^^^^^^^^^^^^^^^^^^^^^^
# /dev/stdin:58:61-88: Error: Could not process rule: No such file or directory
# icmpv6 type { \"echo-request\", \"echo-reply\" } counter name ip6
daddr map @nsoutcounter6
#
^^^^^^^^^^^^^^^^^^^^^^^^^^^^
# /dev/stdin:6:34-42: Error: Could not process rule: No such file or directory
# ip saddr 10.0.2.2 counter name \"ns0insl\"
#                                ^^^^^^^^^
# Error: No such file or directory
# list counter inet filter ns0in
#                   ^^^^^^
# ERROR: ns0in counter in ns1-0Hc1Kf82 has unexpected value (expected
packets 1 bytes 84) at check_counters 1
# Error: No such file or directory
# list counter inet filter ns0in
#                   ^^^^^^
# Error: No such file or directory
# list counter inet filter ns0out
#                   ^^^^^^
# ERROR: ns0out counter in ns1-0Hc1Kf82 has unexpected value (expected
packets 1 bytes 84) at check_counters 2
# Error: No such file or directory
# list counter inet filter ns0out
#                   ^^^^^^
# Error: No such file or directory
# list counter inet filter ns0in6
#                   ^^^^^^
# ERROR: ns0in6 counter in ns1-0Hc1Kf82 has unexpected value (expected
packets 1 bytes 104) at check_counters 3
# Error: No such file or directory
# list counter inet filter ns0in6
#                   ^^^^^^
# Error: No such file or directory
# list counter inet filter ns0out6
#                   ^^^^^^
# ERROR: ns0out6 counter in ns1-0Hc1Kf82 has unexpected value
(expected packets 1 bytes 104) at check_counters 4
# Error: No such file or directory
# list counter inet filter ns0out6
#                   ^^^^^^
# Error: No such file or directory
# list counter inet filter ns0in
#                   ^^^^^^
# ERROR: ns0in counter in ns0-0Hc1Kf82 has unexpected value (expected
packets 0 bytes 0) at check_ns0_counters 1
# Error: No such file or directory
# list counter inet filter ns0in
#                   ^^^^^^
# Error: No such file or directory
# list counter inet filter ns0in6
#                   ^^^^^^
# ERROR: ns0in6 counter in ns0-0Hc1Kf82 has unexpected value (expected
packets 0 bytes 0) at
# Error: No such file or directory
# list counter inet filter ns0in6
#                   ^^^^^^
# Error: No such file or directory
# list counter inet filter ns0out
#                   ^^^^^^
# ERROR: ns0out counter in ns0-0Hc1Kf82 has unexpected value (expected
packets 0 bytes 0) at check_ns0_counters 2
# Error: No such file or directory
# list counter inet filter ns0out
#                   ^^^^^^
# Error: No such file or directory
# list counter inet filter ns0out6
#                   ^^^^^^
# ERROR: ns0out6 counter in ns0-0Hc1Kf82 has unexpected value
(expected packets 0 bytes 0) at check_ns0_counters3
# Error: No such file or directory
# list counter inet filter ns0out6
#                   ^^^^^^
# Error: No such file or directory
# list counter inet filter ns1in
#                   ^^^^^^
# ERROR: ns1in counter in ns0-0Hc1Kf82 has unexpected value (expected
packets 1 bytes 84) at check_ns0_counters 4
# Error: No such file or directory
# list counter inet filter ns1in
#                   ^^^^^^
# Error: No such file or directory
# list counter inet filter ns1in6
#                   ^^^^^^
# ERROR: ns1 counter in ns0-0Hc1Kf82 has unexpected value (expected
packets 1 bytes 104) at check_ns0_counters 5
# Error: No such file or directory
# list counter inet filter ns1
#                   ^^^^^^
# Error: No such file or directory
# list counter inet filter ns1out
#                   ^^^^^^
# ERROR: ns1out counter in ns0-0Hc1Kf82 has unexpected value (expected
packets 1 bytes 84) at check_ns0_counters 4
# Error: No such file or directory
# list counter inet filter ns1out
#                   ^^^^^^
# Error: No such file or directory
# list counter inet filter ns1out6
#                   ^^^^^^
# ERROR: ns1 counter in ns0-0Hc1Kf82 has unexpected value (expected
packets 1 bytes 104) at check_ns0_counters 5
# Error: No such file or directory
# list counter inet filter ns1
#                   ^^^^^^
# Error: No such file or directory
# list counter inet filter ns0in
#                   ^^^^^^
# ERROR: ns0in counter in ns2-0Hc1Kf82 has unexpected value (expected
packets 1 bytes 84) at check_counters 1
# Error: No such file or directory
# list counter inet filter ns0in
#                   ^^^^^^
# Error: No such file or directory
# list counter inet filter ns0out
#                   ^^^^^^
# ERROR: ns0out counter in ns2-0Hc1Kf82 has unexpected value (expected
packets 1 bytes 84) at check_counters 2
# Error: No such file or directory
# list counter inet filter ns0out
#                   ^^^^^^
# Error: No such file or directory
# list counter inet filter ns0in6
#                   ^^^^^^
# ERROR: ns0in6 counter in ns2-0Hc1Kf82 has unexpected value (expected
packets 1 bytes 104) at check_counters 3
# Error: No such file or directory
# list counter inet filter ns0in6
#                   ^^^^^^
# Error: No such file or directory
# list counter inet filter ns0out6
#                   ^^^^^^
# ERROR: ns0out6 counter in ns2-0Hc1Kf82 has unexpected value
(expected packets 1 bytes 104) at check_counters 4
# Error: No such file or directory
# list counter inet filter ns0out6
#                   ^^^^^^
# Error: No such file or directory
# list counter inet filter ns0in
#                   ^^^^^^
# ERROR: ns0in counter in ns0-0Hc1Kf82 has unexpected value (expected
packets 0 bytes 0) at check_ns0_counters 1
# Error: No such file or directory
# list counter inet filter ns0in
#                   ^^^^^^
# Error: No such file or directory
# list counter inet filter ns0in6
#                   ^^^^^^
# ERROR: ns0in6 counter in ns0-0Hc1Kf82 has unexpected value (expected
packets 0 bytes 0) at
# Error: No such file or directory
# list counter inet filter ns0in6
#                   ^^^^^^
# Error: No such file or directory
# list counter inet filter ns0out
#                   ^^^^^^
# ERROR: ns0out counter in ns0-0Hc1Kf82 has unexpected value (expected
packets 0 bytes 0) at check_ns0_counters 2
# Error: No such file or directory
# list counter inet filter ns0out
#                   ^^^^^^
# Error: No such file or directory
# list counter inet filter ns0out6
#                   ^^^^^^
# ERROR: ns0out6 counter in ns0-0Hc1Kf82 has unexpected value
(expected packets 0 bytes 0) at check_ns0_counters3
# Error: No such file or directory
# list counter inet filter ns0out6
#                   ^^^^^^
# Error: No such file or directory
# list counter inet filter ns2in
#                   ^^^^^^
# ERROR: ns2in counter in ns0-0Hc1Kf82 has unexpected value (expected
packets 1 bytes 84) at check_ns0_counters 4
# Error: No such file or directory
# list counter inet filter ns2in
#                   ^^^^^^
# Error: No such file or directory
# list counter inet filter ns2in6
#                   ^^^^^^
# ERROR: ns2 counter in ns0-0Hc1Kf82 has unexpected value (expected
packets 1 bytes 104) at check_ns0_counters 5
# Error: No such file or directory
# list counter inet filter ns2
#                   ^^^^^^
# Error: No such file or directory
# list counter inet filter ns2out
#                   ^^^^^^
# ERROR: ns2out counter in ns0-0Hc1Kf82 has unexpected value (expected
packets 1 bytes 84) at check_ns0_counters 4
# Error: No such file or directory
# list counter inet filter ns2out
#                   ^^^^^^
# Error: No such file or directory
# list counter inet filter ns2out6
#                   ^^^^^^
# ERROR: ns2 counter in ns0-0Hc1Kf82 has unexpected value (expected
packets 1 bytes 104) at check_ns0_counters 5
# Error: No such file or directory
# list counter inet filter ns2
#                   ^^^^^^
[   92.417219] unwind: Unknown symbol address bf02e1c8
[   92.417611] BUG: spinlock recursion on CPU#0, modprobe/762
[   92.417622]  lock: unwind_lock+0x0/0x24, .magic: dead4ead, .owner:
modprobe/762, .owner_cpu: 0
[   92.417649] CPU: 0 PID: 762 Comm: modprobe Not tainted 6.1.4-rc1 #1
[   92.417657] Hardware name: Generic DT based system
[   92.417662]  unwind_backtrace from show_stack+0x18/0x1c
[   92.417682]  show_stack from dump_stack_lvl+0x58/0x70
[   92.417703]  dump_stack_lvl from do_raw_spin_lock+0xcc/0xf0
[   92.417719]  do_raw_spin_lock from _raw_spin_lock_irqsave+0x60/0x74
[   92.417740]  _raw_spin_lock_irqsave from unwind_frame+0x470/0x840
[   92.417760]  unwind_frame from __save_stack_trace+0xa4/0xe0
[   92.417775]  __save_stack_trace from stack_trace_save+0x40/0x60
[   92.417792]  stack_trace_save from save_trace+0x50/0x410
[   92.417805]  save_trace from __lock_acquire+0x16dc/0x2a8c
[   92.417815]  __lock_acquire from lock_acquire+0x110/0x364
[   92.417826]  lock_acquire from _raw_spin_lock_irqsave+0x58/0x74
[   92.417847]  _raw_spin_lock_irqsave from down_trylock+0x14/0x34
[   92.417872]  down_trylock from __down_trylock_console_sem+0x30/0x98
[   92.417894]  __down_trylock_console_sem from vprintk_emit+0x98/0x35c
[   92.417914]  vprintk_emit from vprintk_default+0x28/0x30
[   92.417933]  vprintk_default from _printk+0x30/0x54
[   92.417954]  _printk from search_index+0xcc/0xd8
[   92.417974]  search_index from unwind_frame+0x630/0x840
[   92.417989]  unwind_frame from __save_stack_trace+0xa4/0xe0
[   92.417999]  __save_stack_trace from stack_trace_save+0x40/0x60
[   92.418021]  stack_trace_save from set_track_prepare+0x2c/0x58
[   92.418044]  set_track_prepare from free_debug_processing+0x380/0x61c
[   92.418063]  free_debug_processing from kmem_cache_free+0x270/0x45c
[   92.418077]  kmem_cache_free from rcu_core+0x3c8/0x1140
[   92.418093]  rcu_core from __do_softirq+0x130/0x538
[   92.418109]  __do_softirq from __irq_exit_rcu+0x14c/0x170
[   92.418122]  __irq_exit_rcu from irq_exit+0x10/0x30
[   92.418132]  irq_exit from call_with_stack+0x18/0x20
[   92.418146]  call_with_stack from __irq_svc+0x9c/0xb8
[   92.418160] Exception stack(0xf8f59cc0 to 0xf8f59d08)
[   92.418171] 9cc0: c634b108 f8f9e940 0000021c 00034068 00000028
c634b100 00000d01 f8fa7040
[   92.418180] 9ce0: c634b108 c634b100 c25e54d0 ffffffbf bf02e020
f8f59d10 bf02e304 bf02e1c8
[   92.418187] 9d00: 200d0113 ffffffff
[   92.418191]  __irq_svc from sha1_ce_transform+0x188/0x1bc [sha1_arm_ce]
[  118.427094] rcu: INFO: rcu_sched detected stalls on CPUs/tasks:
[  118.430231] (detected by 1, t=2602 jiffies, g=13749, q=213 ncpus=2)
[  118.433459] rcu: All QSes seen, last rcu_sched kthread activity
2602 (-18164--20766), jiffies_till_next_fqs=1, root ->qsmask 0x0
[  118.438830] rcu: rcu_sched kthread timer wakeup didn't happen for
2601 jiffies! g13749 f0x2 RCU_GP_WAIT_FQS(5) ->state=0x200
[  118.444321] rcu: Possible timer handling issue on cpu=0 timer-softirq=3501
[  118.447958] rcu: rcu_sched kthread starved for 2602 jiffies! g13749
f0x2 RCU_GP_WAIT_FQS(5) ->state=0x200 ->cpu=0
[  118.453202] rcu: Unless rcu_sched kthread gets sufficient CPU time,
OOM is now expected behavior.
[  118.457584] rcu: RCU grace-period kthread stack dump:
[  118.460282] task:rcu_sched       state:R stack:0     pid:14
ppid:2      flags:0x00000000
[  118.464277]  __schedule from schedule+0x60/0x100
[  118.466571]  schedule from schedule_timeout+0xbc/0x20c
[  118.469192]  schedule_timeout from rcu_gp_fqs_loop+0x180/0x8d0
[  118.472165]  rcu_gp_fqs_loop from rcu_gp_kthread+0x268/0x3c0
[  118.475096]  rcu_gp_kthread from kthread+0xfc/0x11c
[  118.477675]  kthread from ret_from_fork+0x14/0x2c
[  118.479938] Exception stack(0xf0871fb0 to 0xf0871ff8)
[  118.482620] 1fa0:                                     00000000
00000000 00000000 00000000
[  118.486777] 1fc0: 00000000 00000000 00000000 00000000 00000000
00000000 00000000 00000000
[  118.490778] 1fe0: 00000000 00000000 00000000 00000000 00000013 00000000
[  118.494227] rcu: Stack dump where RCU GP kthread last ran:
[  118.496920] Sending NMI from CPU 1 to CPUs 0:
[  196.487089] rcu: INFO: rcu_sched detected stalls on CPUs/tasks:
[  196.490069] (detected by 1, t=10408 jiffies, g=13749, q=291 ncpus=2)
[  196.493125] rcu: All QSes seen, last rcu_sched kthread activity
10408 (-10358--20766), jiffies_till_next_fqs=1, root ->qsmask 0x0
[  196.498543] rcu: rcu_sched kthread timer wakeup didn't happen for
10407 jiffies! g13749 f0x2 RCU_GP_WAIT_FQS(5) ->state=0x200
[  196.503820] rcu: Possible timer handling issue on cpu=0 timer-softirq=3501
[  196.507068] rcu: rcu_sched kthread starved for 10408 jiffies!
g13749 f0x2 RCU_GP_WAIT_FQS(5) ->state=0x200 ->cpu=0
[  196.511845] rcu: Unless rcu_sched kthread gets sufficient CPU time,
OOM is now expected behavior.
[  196.515998] rcu: RCU grace-period kthread stack dump:
[  196.518341] task:rcu_sched       state:R stack:0     pid:14
ppid:2      flags:0x00000000
[  196.522212]  __schedule from schedule+0x60/0x100
[  196.524392]  schedule from schedule_timeout+0xbc/0x20c
[  196.526793]  schedule_timeout from rcu_gp_fqs_loop+0x180/0x8d0
[  196.529554]  rcu_gp_fqs_loop from rcu_gp_kthread+0x268/0x3c0
[  196.532231]  rcu_gp_kthread from kthread+0xfc/0x11c
[  196.534515]  kthread from ret_from_fork+0x14/0x2c
[  196.536814] Exception stack(0xf0871fb0 to 0xf0871ff8)
[  196.539163] 1fa0:                                     00000000
00000000 00000000 00000000
[  196.542933] 1fc0: 00000000 00000000 00000000 00000000 00000000
00000000 00000000 00000000
[  196.546718] 1fe0: 00000000 00000000 00000000 00000000 00000013 00000000
[  196.549759] rcu: Stack dump where RCU GP kthread last ran:
[  196.552305] Sending NMI from CPU 1 to CPUs 0:
[  274.537090] rcu: INFO: rcu_sched detected stalls on CPUs/tasks:
[  274.539913] (detected by 1, t=18213 jiffies, g=13749, q=294 ncpus=2)
[  274.542844] rcu: All QSes seen, last rcu_sched kthread activity
18213 (-2553--20766), jiffies_till_next_fqs=1, root ->qsmask 0x0
[  274.548052] rcu: rcu_sched kthread timer wakeup didn't happen for
18212 jiffies! g13749 f0x2 RCU_GP_WAIT_FQS(5) ->state=0x200
[  274.553130] rcu: Possible timer handling issue on cpu=0 timer-softirq=3501
[  274.556276] rcu: rcu_sched kthread starved for 18213 jiffies!
g13749 f0x2 RCU_GP_WAIT_FQS(5) ->state=0x200 ->cpu=0
[  274.560932] rcu: Unless rcu_sched kthread gets sufficient CPU time,
OOM is now expected behavior.
[  274.564906] rcu: RCU grace-period kthread stack dump:
[  274.567183] task:rcu_sched       state:R stack:0     pid:14
ppid:2      flags:0x00000000
[  274.570945]  __schedule from schedule+0x60/0x100
[  274.573114]  schedule from schedule_timeout+0xbc/0x20c
[  274.575482]  schedule_timeout from rcu_gp_fqs_loop+0x180/0x8d0
[  274.578110]  rcu_gp_fqs_loop from rcu_gp_kthread+0x268/0x3c0
[  274.580685]  rcu_gp_kthread from kthread+0xfc/0x11c
[  274.582907]  kthread from ret_from_fork+0x14/0x2c
[  274.585072] Exception stack(0xf0871fb0 to 0xf0871ff8)
[  274.587375] 1fa0:                                     00000000
00000000 00000000 00000000
[  274.591035] 1fc0: 00000000 00000000 00000000 00000000 00000000
00000000 00000000 00000000
[  274.594733] 1fe0: 00000000 00000000 00000000 00000000 00000013 00000000
[  274.597716] rcu: Stack dump where RCU GP kthread last ran:
[  274.600211] Sending NMI from CPU 1 to CPUs 0:
[  352.587095] rcu: INFO: rcu_sched detected stalls on CPUs/tasks:
[  352.589951] (detected by 1, t=26018 jiffies, g=13749, q=302 ncpus=2)
[  352.592812] rcu: All QSes seen, last rcu_sched kthread activity
26018 (5252--20766), jiffies_till_next_fqs=1, root ->qsmask 0x0
[  352.597854] rcu: rcu_sched kthread timer wakeup didn't happen for
26017 jiffies! g13749 f0x2 RCU_GP_WAIT_FQS(5) ->state=0x200
[  352.603086] rcu: Possible timer handling issue on cpu=0 timer-softirq=3501
[  352.606120] rcu: rcu_sched kthread starved for 26018 jiffies!
g13749 f0x2 RCU_GP_WAIT_FQS(5) ->state=0x200 ->cpu=0
[  352.610625] rcu: Unless rcu_sched kthread gets sufficient CPU time,
OOM is now expected behavior.
[  352.614522] rcu: RCU grace-period kthread stack dump:
[  352.616787] task:rcu_sched       state:R stack:0     pid:14
ppid:2      flags:0x00000000
[  352.620470]  __schedule from schedule+0x60/0x100
[  352.622642]  schedule from schedule_timeout+0xbc/0x20c
[  352.625133]  schedule_timeout from rcu_gp_fqs_loop+0x180/0x8d0
[  352.627944]  rcu_gp_fqs_loop from rcu_gp_kthread+0x268/0x3c0
[  352.630522]  rcu_gp_kthread from kthread+0xfc/0x11c
[  352.632711]  kthread from ret_from_fork+0x14/0x2c
[  352.634870] Exception stack(0xf0871fb0 to 0xf0871ff8)
[  352.637127] 1fa0:                                     00000000
00000000 00000000 00000000
[  352.640687] 1fc0: 00000000 00000000 00000000 00000000 00000000
00000000 00000000 00000000
[  352.644262] 1fe0: 00000000 00000000 00000000 00000000 00000013 00000000
[  352.647148] rcu: Stack dump where RCU GP kthread last ran:
[  352.649559] Sending NMI from CPU 1 to CPUs 0:
[  430.637222] rcu: INFO: rcu_sched detected stalls on CPUs/tasks:
[  430.640203] (detected by 1, t=33823 jiffies, g=13749, q=314 ncpus=2)
[  430.643245] rcu: All QSes seen, last rcu_sched kthread activity
33823 (13057--20766), jiffies_till_next_fqs=1, root ->qsmask 0x0
[  430.648624] rcu: rcu_sched kthread timer wakeup didn't happen for
33822 jiffies! g13749 f0x2 RCU_GP_WAIT_FQS(5) ->state=0x200
[  430.653861] rcu: Possible timer handling issue on cpu=0 timer-softirq=3501
[  430.657085] rcu: rcu_sched kthread starved for 33823 jiffies!
g13749 f0x2 RCU_GP_WAIT_FQS(5) ->state=0x200 ->cpu=0
[  430.661780] rcu: Unless rcu_sched kthread gets sufficient CPU time,
OOM is now expected behavior.
[  430.665876] rcu: RCU grace-period kthread stack dump:
[  430.668225] task:rcu_sched       state:R stack:0     pid:14
ppid:2      flags:0x00000000
[  430.672089]  __schedule from schedule+0x60/0x100
[  430.674294]  schedule from schedule_timeout+0xbc/0x20c
[  430.676805]  schedule_timeout from rcu_gp_fqs_loop+0x180/0x8d0
[  430.679569]  rcu_gp_fqs_loop from rcu_gp_kthread+0x268/0x3c0
[  430.682281]  rcu_gp_kthread from kthread+0xfc/0x11c
[  430.684608]  kthread from ret_from_fork+0x14/0x2c
[  430.686809] Exception stack(0xf0871fb0 to 0xf0871ff8)
[  430.689211] 1fa0:                                     00000000
00000000 00000000 00000000
[  430.692951] 1fc0: 00000000 00000000 00000000 00000000 00000000
00000000 00000000 00000000
[  430.696735] 1fe0: 00000000 00000000 00000000 00000000 00000013 00000000
[  430.699829] rcu: Stack dump where RCU GP kthread last ran:
[  430.702415] Sending NMI from CPU 1 to CPUs 0:

[1]
https://lkft.validation.linaro.org/scheduler/job/6022385#L1224
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.3-208-ga31425cbf493/testrun/13974771/suite/log-parser-test/test/check-kernel-bug/log
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.3-208-ga31425cbf493/testrun/13974771/suite/log-parser-test/tests/

metadata:
  git_ref: linux-6.1.y
  git_repo: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
  git_sha: a31425cbf493ef8bc7f7ce775a1028b1e0612f32
  git_describe: v6.1.3-208-ga31425cbf493
  kernel_version: 6.1.4-rc1
  kernel-config:
https://storage.tuxsuite.com/public/linaro/lkft/builds/2JrzrHzfFQKu8CwO4A3HTPI51of/config
  build-url: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc/-/pipelines/738268273
  artifact-location:
https://storage.tuxsuite.com/public/linaro/lkft/builds/2JrzrHzfFQKu8CwO4A3HTPI51of
  toolchain: gcc-10
  vmlinux.xz: https://storage.tuxsuite.com/public/linaro/lkft/builds/2JrzrHzfFQKu8CwO4A3HTPI51of/vmlinux.xz
  System.map: https://storage.tuxsuite.com/public/linaro/lkft/builds/2JrzrHzfFQKu8CwO4A3HTPI51of/System.map

--
Linaro LKFT
https://lkft.linaro.org
