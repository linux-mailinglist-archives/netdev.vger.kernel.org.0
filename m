Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7175D2563BB
	for <lists+netdev@lfdr.de>; Sat, 29 Aug 2020 02:40:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726881AbgH2Akc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Aug 2020 20:40:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726584AbgH2Akb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Aug 2020 20:40:31 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE3CFC061264
        for <netdev@vger.kernel.org>; Fri, 28 Aug 2020 17:40:30 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id h10so827328ioq.6
        for <netdev@vger.kernel.org>; Fri, 28 Aug 2020 17:40:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=googlenew;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=+vIeUrUuAnWc8NN+BWmL8CfAuSbBkkCYFG9kSFmVy0c=;
        b=UUmXDt2wt1EqLvNs2ZUXnNBMFRfeYMamPiaNfOoAjPD1a5piD//6FjFOs82DWEUX8J
         Z3MUWP6tDec4vFk4gTCq2NclAvCWhyImQ/Mjzr+zSyaCDJyOOuEyqLhHbHMabAQq88sl
         oXUY2H030UPBc+lj8dzNyGKgr2sCadJsp5KCTIhv/8YdyBoqwMkMfVyz18pOYz9TzUG4
         FSDbJf8mBWjzvMWJrg2/AXmqKBz+gEapPXS6ppwqTq98rvipBzA66JoVrbdsqI8oGCC9
         lD0MbrfR4IHliyNql9Saiw4hWyjtQdPSOqtNeq2u/ZAZQf2ZBoL7xkhwttdvmGdTEQis
         TDUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=+vIeUrUuAnWc8NN+BWmL8CfAuSbBkkCYFG9kSFmVy0c=;
        b=Q08q4uOUAJaLaoiD0w/5s5llPDCdpH6NK3Z+68zf3yLwsL/ZbjKG24EMVbclhq6FfX
         p4DMxo4C1Via7lSp2O/O/5rbiDzsVRknShqwidiSfS9weWmP0s7BcJdMu4yzRw80l49K
         B/HI8Vkn/bMOGG0XZSrPDidX1P0Qq905xzIxVhjwrIVAMmGYu+KNKvSTn4viUAxbtR7j
         mLTLnmNaY2O+2mH9IUfyE9EEi8czubthNrRptDMJB492TED6Y8JjXvYYm+SkGiw0u3M8
         AaBoi+ybSim5h6LmfTeAd+NEW+FZhGGIIHU8npw1bCamQa6+2IH3Z5uUrsawrvLz6tl+
         jlUA==
X-Gm-Message-State: AOAM532xUX7Tq4EyRZasGWi99n+iT6RlTmsOTCAwvB0/Qcwx7+n8BMF7
        IPQCRGHIDCmYd5SkIgR4YFV+BdK7ab6xnNdmwKWTNw==
X-Google-Smtp-Source: ABdhPJxKOS/2xY0O22Xrze6sAJJgPRO2s7I3WoSZv4xVwVfmljuwjDMXzFWpbkrN2jtOX+UPHOqVDqO9bqOISdJI5Co=
X-Received: by 2002:a05:6638:16ca:: with SMTP id g10mr3489250jat.66.1598661630021;
 Fri, 28 Aug 2020 17:40:30 -0700 (PDT)
MIME-Version: 1.0
From:   Baptiste Covolato <baptiste@arista.com>
Date:   Fri, 28 Aug 2020 17:40:19 -0700
Message-ID: <CABb8VeGOUfXOjVcoHkMZhwOoafLH5L-cY_yvrYz1a+zMQPwLsg@mail.gmail.com>
Subject: rtnl_lock deadlock with tg3 driver
To:     drc@linux.vnet.ibm.com, mchan@broadcom.com
Cc:     siva.kallam@broadcom.com, prashant@broadcom.com,
        netdev@vger.kernel.org, Daniel Stodden <dns@arista.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, Michael,

I am contacting you because I'm experiencing an issue that seems to be
awfully close to what David attempted to fix related to the tg3 driver
infinite sleep while holding rtnl_lock
(https://lkml.org/lkml/2020/6/15/1122).

I have a system with a bunch of "Broadcom Limited NetXtreme BCM57762
Gigabit Ethernet PCIe" devices connected to a PLX switch. While doing
repeated power cycle sequences, I managed to reproduce this deadlock.
A power cycle sequence means: disable PCI port, wait for the port to
disappear, power off the card, enable PCI port and power on the card.
I'm currently using 4.19.67 (same behavior with .118). After applying
David's patch, I'm still able to reproduce the deadlock, albeit not as
frequently. I believe this is the second case mentioned in the email
thread about tx_transmit_timeout. Indeed, after the patch is applied
the deadlock always follows a transmit error:
[ 2609.145583] ------------[ cut here ]------------
[ 2609.145585] NETDEV WATCHDOG: lc5 (tg3): transmit queue 0 timed out
...
[ 2609.145706] tg3 0000:61:00.0 lc5: transmit timed out, resetting
...

Shortly after this I get:
[ 2618.206153] rcu: INFO: rcu_sched self-detected stall on CPU
[ 2618.206156] rcu:     5-....: (3813 ticks this GP)
idle=776/1/0x4000000000000002 softirq=216132/216132 fqs=1922
[ 2618.206156] rcu:      (t=5264 jiffies g=782593 q=27596)
[ 2618.206158] NMI backtrace for cpu 5
[ 2618.206161] CPU: 5 PID: 37 Comm: ksoftirqd/5 Kdump: loaded Tainted:
G        W  OE     4.19.0-6-amd64 #1 Debian 4.19.67-2+deb10u2
[ 2618.206162] Hardware name: Intel Camelback Mountain CRB/Camelback
Mountain CRB, BIOS Aboot-norcal7-7.1.4-14169220 11/09/2019
[ 2618.206162] Call Trace:
[ 2618.206164]  <IRQ>
[ 2618.206170]  dump_stack+0x5c/0x80
[ 2618.206172]  nmi_cpu_backtrace.cold.4+0x13/0x50
[ 2618.206175]  ? lapic_can_unplug_cpu.cold.29+0x3b/0x3b
[ 2618.206177]  nmi_trigger_cpumask_backtrace+0xf9/0xfb
[ 2618.206180]  rcu_dump_cpu_stacks+0x9b/0xcb
[ 2618.206182]  rcu_check_callbacks.cold.81+0x1db/0x335
[ 2618.206185]  ? tick_sched_do_timer+0x60/0x60
[ 2618.206188]  update_process_times+0x28/0x60
[ 2618.206189]  tick_sched_handle+0x22/0x60
[ 2618.206190]  tick_sched_timer+0x37/0x70
[ 2618.206192]  __hrtimer_run_queues+0x100/0x280
[ 2618.206195]  hrtimer_interrupt+0x100/0x220
[ 2618.206198]  ? handle_irq_event+0x47/0x5c
[ 2618.206201]  smp_apic_timer_interrupt+0x6a/0x140
[ 2618.206203]  apic_timer_interrupt+0xf/0x20
[ 2618.206220]  </IRQ>
[ 2618.206223] RIP: 0010:console_unlock+0x34c/0x510
[ 2618.206225] Code: e8 89 f9 ff ff 85 c0 0f 85 59 ff ff ff e8 3c f9
ff ff 85 c0 0f 85 fd fc ff ff e9 47 ff ff ff e8 aa 26 00 00 48 8b 3c
24 57 9d <0f> 1f 44 00 00 8b 54 24 10 85 d2 0f 84 20 fd ff ff e8 be 92
64 00
[ 2618.206225] RSP: 0018:ffffb01dc63c3ad0 EFLAGS: 00000247 ORIG_RAX:
ffffffffffffff13
[ 2618.206227] RAX: 0000000000000000 RBX: 0000000000000060 RCX: 0000000000000000
[ 2618.206228] RDX: 0000000000000000 RSI: 0000000000000046 RDI: 0000000000000247
[ 2618.206228] RBP: ffffffff887f32b0 R08: 0000000000000005 R09: 0000000000000004
[ 2618.206229] R10: 0000000000000000 R11: ffffffff887f26ad R12: ffffffff887f0688
[ 2618.206230] R13: 0000000000000000 R14: ffffffff8832e660 R15: ffffffff887f26a0
[ 2618.206232]  vprintk_emit+0x1f0/0x250
[ 2618.206236]  ? __irq_work_queue_local+0x50/0x60
[ 2618.206239]  dev_vprintk_emit+0xea/0x210
[ 2618.206241]  ? get_page_from_freelist+0x816/0x11b0
[ 2618.206243]  dev_printk_emit+0x4e/0x70
[ 2618.206246]  __netdev_printk+0xbb/0x150
[ 2618.206248]  netdev_err+0x6c/0x90
[ 2618.206253]  tg3_dump_state+0x97/0x190 [tg3]
[ 2618.206256]  tg3_tx_timeout+0x3c/0x60 [tg3]
[ 2618.206259]  dev_watchdog+0x1e4/0x220
[ 2618.206261]  ? pfifo_fast_enqueue+0x110/0x110
[ 2618.206263]  call_timer_fn+0x2b/0x130
[ 2618.206265]  run_timer_softirq+0x3d1/0x410
[ 2618.206266]  ? __switch_to_asm+0x35/0x70
[ 2618.206267]  ? __switch_to_asm+0x41/0x70
[ 2618.206268]  ? __switch_to_asm+0x35/0x70
[ 2618.206269]  ? __switch_to_asm+0x41/0x70
[ 2618.206271]  ? __switch_to+0x8c/0x440
[ 2618.206272]  ? __switch_to_asm+0x41/0x70
[ 2618.206273]  ? __switch_to_asm+0x35/0x70
[ 2618.206275]  __do_softirq+0xde/0x2d8
[ 2618.206277]  ? sort_range+0x20/0x20
[ 2618.206279]  run_ksoftirqd+0x26/0x40
[ 2618.206280]  smpboot_thread_fn+0xc5/0x160
[ 2618.206282]  kthread+0x112/0x130
[ 2618.206284]  ? kthread_bind+0x30/0x30
[ 2618.206285]  ret_from_fork+0x35/0x40

Finally when a task does something that needs the rtnl_lock:
[ 3747.634280] INFO: task dockerd:903 blocked for more than 120 seconds.
[ 3747.727904]       Tainted: G        W  OE     4.19.0-6-amd64 #1
Debian 4.19.67-2+deb10u2
[ 3747.841584] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 3747.935477] dockerd         D    0   903      1 0x00000000
[ 3747.935479] Call Trace:
[ 3747.935487]  ? __schedule+0x2a2/0x870
[ 3747.935488]  ? __switch_to_asm+0x35/0x70
[ 3747.935490]  ? __switch_to_asm+0x41/0x70
[ 3747.935491]  schedule+0x28/0x80
[ 3747.935493]  schedule_preempt_disabled+0xa/0x10
[ 3747.935495]  __mutex_lock.isra.8+0x2b5/0x4a0
[ 3747.935499]  ? intel_pstate_update_pstate+0x30/0x30
[ 3747.935503]  ? account_entity_enqueue+0xc5/0xf0
[ 3747.935506]  rtnetlink_rcv_msg+0x264/0x360
[ 3747.935509]  ? enqueue_task_fair+0x79/0x190
[ 3747.935516]  ? _cond_resched+0x15/0x30
[ 3747.935524]  ? rtnl_calcit.isra.32+0x100/0x100
[ 3747.935534]  netlink_rcv_skb+0x4c/0x120
[ 3747.935541]  netlink_unicast+0x181/0x210
[ 3747.935548]  netlink_sendmsg+0x204/0x3d0
[ 3747.935556]  sock_sendmsg+0x36/0x40
[ 3747.935564]  __sys_sendto+0xee/0x160
[ 3747.935573]  ? __x64_sys_futex+0x143/0x180
[ 3747.935586]  ? __x64_sys_epoll_pwait+0xff/0x120
[ 3747.935593]  __x64_sys_sendto+0x24/0x30
[ 3747.935599]  do_syscall_64+0x53/0x110
[ 3747.935602]  entry_SYSCALL_64_after_hwframe+0x44/0xa9

I was wondering if you had made any progress towards a fix for this
second issue?
I also tried to apply the v1 of David's patch, but it actually
resulted in a kernel panic:
[13194.569048]  tg3_stop+0x17d/0x250 [tg3]
[13194.614987]  tg3_close+0x27/0x80 [tg3]
[13194.659891]  __dev_close_many+0xa1/0x110
[13194.706876]  dev_close_many+0x9f/0x160
[13194.751771]  rollback_registered_many+0x10b/0x530
[13194.808127]  ? kmem_cache_free+0x1a7/0x1d0
[13194.857196]  rollback_registered+0x56/0x90
[13194.906261]  unregister_netdevice_queue+0x73/0xb0
[13194.962620]  unregister_netdev+0x18/0x20
[13195.009600]  tg3_remove_one+0x8a/0x130 [tg3]
[13195.060748]  pci_device_remove+0x3b/0xc0
[13195.107732]  device_release_driver_internal+0x183/0x250
[13195.170337]  pci_stop_bus_device+0x76/0xa0
[13195.219398]  pci_stop_bus_device+0x2f/0xa0
[13195.268462]  pci_stop_bus_device+0x2f/0xa0
[13195.317524]  pci_stop_and_remove_bus_device+0xe/0x20
[13195.377007]  pcielw_remove_bridge.isra.9+0x39/0x50
[13195.434410]  pcielw_datalink_change_work+0xcf/0x100
[13195.492856]  process_one_work+0x1a7/0x3a0
[13195.540882]  worker_thread+0x30/0x390
[13195.584742]  ? create_worker+0x1a0/0x1a0
[13195.631721]  kthread+0x112/0x130
[13195.670367]  ? kthread_bind+0x30/0x30
[13195.714222]  ret_from_fork+0x35/0x40

If you have a candidate patch for this second issue, I'd be happy to
help out testing it on my system to see if that solves the issue.

Let me know if you need more information or have any questions.

Thanks,

--
Baptiste Covolato
