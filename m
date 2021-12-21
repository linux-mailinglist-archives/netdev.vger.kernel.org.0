Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E8AF47BF93
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 13:19:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234594AbhLUMTC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 07:19:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234571AbhLUMTC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 07:19:02 -0500
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E60A6C061574
        for <netdev@vger.kernel.org>; Tue, 21 Dec 2021 04:19:01 -0800 (PST)
Received: by mail-io1-xd2d.google.com with SMTP id q5so826089ioj.7
        for <netdev@vger.kernel.org>; Tue, 21 Dec 2021 04:19:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=n9UvHtsPCw4g1IHd6W/+M8/Jvrv4Uhx0/q3UAUV+Tn8=;
        b=J7T9Yx+qCGhTt+kltq5SMWG62eJ4HM3WY8r21d5oqX10u/y2DdIlduA3OXIyVfUcMk
         +MDW1B1gO1olHNqbhhvrljnNSJiwpEkHZJO3fp2+l0tzIbmjIj0+GCbh1MFeVRxMZHNg
         b1oW9tbn1RcLPInil4jaFtc5EcCkNoCSaSK2w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=n9UvHtsPCw4g1IHd6W/+M8/Jvrv4Uhx0/q3UAUV+Tn8=;
        b=04zUSMePASRKUZA2uPz2G1COw7sGXYnLILLrJw3XC3+TZG+4bjzelD2X8h72t8Kt4A
         gcW4t671fZJ8Ibi1mmoR5njyRGAaxhf1Wtl1/bUU9F7l9IlGZh0RIZydtZ1I2qa9DgCn
         +E/XxiEv/unopTDYcXOa67DvlSErUroAOXkeJUyHFBYCpOunkpnw4S2BEcwfXjwDTKaI
         7FDa2uIsk931YPpLdlHtYbSHzlSrVBojK8w3EkIhct0aJD/vvg5QAk9eW8aESZoJQLZm
         Lsn7t6P6CIUeR3czxU46ZfDSoKTKNdzbOFuI87JcM4BCRnQEDMiy7GDILQ6V9oc6XbsQ
         zAog==
X-Gm-Message-State: AOAM531rgDj1IllvGF9s43kvj/Rh8mn5ZuHGbXIVLaS4utRHjZbaI3Od
        iey/AUDjypV1RAo7WS4L2Qk9RmCowZM985HHgero+SDAtJYs6A==
X-Google-Smtp-Source: ABdhPJymJodQosaTM6UcLFoDAK+XmwmOq2Epk6dojyiWoTmzq8OsbHlYp7Mm11XiFQAE2UmyHeUJhPxtA3a7C6m39Lc=
X-Received: by 2002:a05:6638:2501:: with SMTP id v1mr1636675jat.252.1640089141006;
 Tue, 21 Dec 2021 04:19:01 -0800 (PST)
MIME-Version: 1.0
From:   Ignat Korchagin <ignat@cloudflare.com>
Date:   Tue, 21 Dec 2021 12:18:50 +0000
Message-ID: <CALrw=nGtZbuQWdwh26qJA6HbbLsCNZjU4jaY78acbKfAAan+5w@mail.gmail.com>
Subject: tcp: kernel BUG at net/core/skbuff.c:3574!
To:     netdev@vger.kernel.org, edumazet@google.com,
        "David S. Miller" <davem@davemloft.net>, dsahern@kernel.org,
        kuba@kernel.org
Cc:     kernel-team <kernel-team@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi netdev,

While trying to reproduce a different rare bug we're seeing in
production I've triggered below on 5.15.9 kernel and confirmed on the
latest netdev master tree:

[   53.970529][    C1] kernel BUG at net/core/skbuff.c:3574!
[   53.981755][    C1] invalid opcode: 0000 [#1] PREEMPT SMP KASAN PTI
[   53.982634][    C1] CPU: 1 PID: 19 Comm: ksoftirqd/1 Not tainted
5.16.0-rc5+ #25
[   53.982634][    C1] Hardware name: QEMU Standard PC (Q35 + ICH9,
2009), BIOS 0.0.0 02/06/2015
[   53.982634][    C1] RIP: 0010:skb_shift+0x13ef/0x23b0
[   53.982634][    C1] Code: ea 03 0f b6 04 02 48 89 fa 83 e2 07 38 d0
7f 08 84 c0 0f 85 41 0c 00 00 41 80 7f 02 00 4d 8d b5 d0 00 00 00 0f
85 74 f5 ff ff <0f> 0b 4d 8d 77 20 be 04 00 00 00 4c 89 44 24 78 4c 89
f7 4c 89 8c
[   53.982634][    C1] RSP: 0018:ffff8881008f7008 EFLAGS: 00010246
[   53.982634][    C1] RAX: 0000000000000000 RBX: ffff8881180b4c80
RCX: 0000000000000000
[   53.982634][    C1] RDX: 0000000000000002 RSI: ffff8881180b4d3c
RDI: ffff88810bc9cac2
[   53.982634][    C1] RBP: ffff8881008f70b8 R08: ffff8881180b4cf4
R09: ffff8881180b4cf0
[   53.982634][    C1] R10: ffffed1022999e5c R11: 0000000000000002
R12: 0000000000000590
[   53.982634][    C1] R13: ffff88810f940c80 R14: ffff88810f940d50
R15: ffff88810bc9cac0
[   53.982634][    C1] FS:  0000000000000000(0000)
GS:ffff888235880000(0000) knlGS:0000000000000000
[   53.982634][    C1] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   53.982634][    C1] CR2: 00007ff5f9b86680 CR3: 0000000108ce8004
CR4: 0000000000170ee0
[   53.982634][    C1] Call Trace:
[   53.982634][    C1]  <TASK>
[   53.982634][    C1]  tcp_sacktag_walk+0xaba/0x18e0
[   53.982634][    C1]  ? kasan_set_free_info+0x20/0x30
[   53.982634][    C1]  ? __kasan_slab_free+0x10b/0x140
[   53.982634][    C1]  ? slab_free_freelist_hook+0xb9/0x1d0
[   53.982634][    C1]  ? kmem_cache_free+0x12f/0x350
[   53.982634][    C1]  tcp_sacktag_write_queue+0xe7b/0x3460
[   53.982634][    C1]  ? kasan_quarantine_put+0x87/0x1e0
[   53.982634][    C1]  ? tcp_sacktag_walk+0x18e0/0x18e0
[   53.982634][    C1]  ? slab_free_freelist_hook+0xb9/0x1d0
[   53.982634][    C1]  ? sk_reset_timer+0x15/0x70
[   53.982634][    C1]  ? kasan_quarantine_put+0x87/0x1e0
[   53.982634][    C1]  tcp_ack+0x2666/0x54b0
[   53.982634][    C1]  ? trace_hardirqs_on+0x1c/0x130
[   53.982634][    C1]  ? asm_sysvec_apic_timer_interrupt+0x12/0x20
[   53.982634][    C1]  ? tcp_fastretrans_alert+0x3260/0x3260
[   53.982634][    C1]  ? tcp_validate_incoming+0x128/0x1c40
[   53.982634][    C1]  ? tcp_reset+0x340/0x340
[   53.982634][    C1]  ? rcu_read_lock_sched_held+0xc/0x70
[   53.982634][    C1]  ? ktime_get+0x13c/0x160
[   53.982634][    C1]  ? trace_hardirqs_on+0x1c/0x130
[   53.982634][    C1]  ? ktime_get+0x9c/0x160
[   53.982634][    C1]  tcp_rcv_established+0x4d9/0x20f0
[   53.982634][    C1]  ? lock_release+0x700/0x700
[   53.982634][    C1]  ? tcp_data_queue+0x5160/0x5160
[   53.982634][    C1]  ? do_raw_spin_lock+0x12b/0x270
[   53.982634][    C1]  ? rwlock_bug.part.0+0x90/0x90
[   53.982634][    C1]  tcp_v4_do_rcv+0x551/0x810
[   53.982634][    C1]  tcp_v4_rcv+0x22ed/0x2ed0
[   53.982634][    C1]  ? lock_acquire+0x42a/0x4e0
[   53.982634][    C1]  ? tcp_v4_early_demux+0x8d0/0x8d0
[   53.982634][    C1]  ? lock_release+0x700/0x700
[   53.982634][    C1]  ? inet_del_offload+0x50/0x50
[   53.982634][    C1]  ? ip_local_deliver_finish+0x1e9/0x2f0
[   53.982634][    C1]  ? lock_downgrade+0x6d0/0x6d0
[   53.982634][    C1]  ip_protocol_deliver_rcu+0x96/0xaf0
[   53.982634][    C1]  ip_local_deliver_finish+0x1e0/0x2f0
[   53.982634][    C1]  ip_sublist_rcv_finish+0x211/0x440
[   53.982634][    C1]  ip_list_rcv_finish.constprop.0+0x424/0x660
[   53.982634][    C1]  ? ip_sublist_rcv_finish+0x440/0x440
[   53.982634][    C1]  ? ip_rcv_core+0x5f6/0xc10
[   53.982634][    C1]  ip_list_rcv+0x2c8/0x410
[   53.982634][    C1]  ? ip_rcv+0x480/0x480
[   53.982634][    C1]  ? ip_rcv+0x480/0x480
[   53.982634][    C1]  __netif_receive_skb_list_core+0x65c/0x910
[   53.982634][    C1]  ? process_backlog+0x710/0x710
[   53.982634][    C1]  ? rcu_read_lock_sched_held+0xc/0x70
[   53.982634][    C1]  ? rcu_read_lock_sched_held+0xc/0x70
[   53.982634][    C1]  netif_receive_skb_list_internal+0x5f9/0xcb0
[   53.982634][    C1]  ? __netif_receive_skb_list_core+0x910/0x910
[   53.982634][    C1]  ? dev_gro_receive+0x700/0x2960
[   53.982634][    C1]  ? do_raw_spin_lock+0x12b/0x270
[   53.982634][    C1]  napi_complete_done+0x188/0x6e0
[   53.982634][    C1]  gro_cell_poll+0x10c/0x1d0
[   53.982634][    C1]  ? lock_downgrade+0x6d0/0x6d0
[   53.982634][    C1]  __napi_poll+0xa1/0x530
[   53.982634][    C1]  net_rx_action+0x567/0x1270
[   53.982634][    C1]  ? napi_threaded_poll+0x470/0x470
[   53.982634][    C1]  ? try_to_wake_up+0x101/0x1500
[   53.982634][    C1]  ? migrate_swap_stop+0x7f0/0x7f0
[   53.982634][    C1]  __do_softirq+0x28a/0x9ba
[   53.982634][    C1]  ? do_softirq.part.0+0x110/0x110
[   53.982634][    C1]  ? smpboot_thread_fn+0x6b/0x8c0
[   53.982634][    C1]  run_ksoftirqd+0x32/0x60
[   53.982634][    C1]  smpboot_thread_fn+0x559/0x8c0
[   53.982634][    C1]  ? smpboot_register_percpu_thread+0x350/0x350
[   53.982634][    C1]  kthread+0x3b9/0x490
[   53.982634][    C1]  ? _raw_spin_unlock_irq+0x24/0x50
[   53.982634][    C1]  ? set_kthread_struct+0x100/0x100
[   53.982634][    C1]  ret_from_fork+0x22/0x30
[   53.982634][    C1]  </TASK>
[   53.982634][    C1] Modules linked in:
[   54.939907][    C1] ---[ end trace f6c264574763a26f ]---
[   64.620726][    C1] RIP: 0010:skb_shift+0x13ef/0x23b0
[   64.630955][    C1] Code: ea 03 0f b6 04 02 48 89 fa 83 e2 07 38 d0
7f 08 84 c0 0f 85 41 0c 00 00 41 80 7f 02 00 4d 8d b5 d0 00 00 00 0f
85 74 f5 ff ff <0f> 0b 4d 8d 77 20 be 04 00 00 00 4c 89 44 24 78 4c 89
f7 4c 89 8c
[   64.664945][    C1] RSP: 0018:ffff8881008f7008 EFLAGS: 00010246
[   64.675965][    C1] RAX: 0000000000000000 RBX: ffff8881180b4c80
RCX: 0000000000000000
[   64.689670][    C1] RDX: 0000000000000002 RSI: ffff8881180b4d3c
RDI: ffff88810bc9cac2
[   64.703383][    C1] RBP: ffff8881008f70b8 R08: ffff8881180b4cf4
R09: ffff8881180b4cf0
[   64.717729][    C1] R10: ffffed1022999e5c R11: 0000000000000002
R12: 0000000000000590
[   64.731377][    C1] R13: ffff88810f940c80 R14: ffff88810f940d50
R15: ffff88810bc9cac0
[   64.744691][    C1] FS:  0000000000000000(0000)
GS:ffff888235880000(0000) knlGS:0000000000000000
[   64.761003][    C1] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   64.773726][    C1] CR2: 00007ff5f9b86680 CR3: 0000000108ce8005
CR4: 0000000000170ee0
[   64.789673][    C1] Kernel panic - not syncing: Fatal exception in interrupt
[   64.794751][    C1] Kernel Offset: 0x26000000 from
0xffffffff81000000 (relocation range:
0xffffffff80000000-0xffffffffbfffffff)
[   64.794751][    C1] ---[ end Kernel panic - not syncing: Fatal
exception in interrupt ]---

We are somehow triggering the BUG_ON directive in skbuff.c. Here is a
bash script which triggers this in QEMU (may need to run it couple of
times in a row):

#!/bin/bash -xe

ip netns delete left 2>/dev/null || true
ip netns delete right 2>/dev/null || true

ip netns add left
ip netns add right

ip link add veth-left netns left type veth peer veth-right netns right

ip -n left link set lo up
ip -n left link set veth-left up

ip -n right link set lo up
ip -n right link set veth-right up

ip -n left addr add 192.168.13.5/24 dev veth-left
ip -n right addr add 192.168.13.7/24 dev veth-right

ip -n left tunnel add gre-left mode gre remote 192.168.13.7 local
192.168.13.5 ttl 255
ip -n left link set gre-left up
ip -n left addr add 10.10.10.5/24 dev gre-left

ip -n right tunnel add gre-right mode gre remote 192.168.13.5 local
192.168.13.7 ttl 255
ip -n right link set gre-right up
ip -n right addr add 10.10.10.7/24 dev gre-right

ip netns exec left ethtool -K veth-left gro on tso off
ip netns exec right ethtool -K veth-right gro on tso off

(ip netns exec right iperf3 -s -D && ip netns exec left iperf3 -c
10.10.10.7 -P 16 -b 100M) &

sleep 5

ip netns delete left
ip netns delete right

# end of script

QEMU command line:
qemu-system-x86_64 -nographic -cpu host \
                   -enable-kvm \
                   -machine q35 \
                   -smp 8 \
                   -m 8G \
                   -drive
if=pflash,format=raw,readonly=on,file=/usr/share/OVMF/OVMF_CODE.fd \
                   -drive
if=pflash,format=raw,file=/usr/share/OVMF/OVMF_VARS.fd \
                   -drive file=/work/rootfs.img,format=qcow2 \
                   -nic user,model=virtio-net-pci,hostfwd=tcp::22-:22 \
                   -kernel vmlinuz \
                   -append "console=ttyS0 root=/dev/sda rw
systemd.unified_cgroup_hierarchy=0"

Userspace: vanilla Debian Bullseye

I didn't look deeply into it myself yet, but I think I don't even have
enough knowledge about this code yet, so asking here for help.

Thanks,
Ignat
