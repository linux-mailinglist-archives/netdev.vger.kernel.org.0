Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B0C3182BF
	for <lists+netdev@lfdr.de>; Thu,  9 May 2019 01:38:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727397AbfEHXis (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 May 2019 19:38:48 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:34914 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727028AbfEHXis (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 May 2019 19:38:48 -0400
Received: by mail-wm1-f67.google.com with SMTP id y197so715856wmd.0
        for <netdev@vger.kernel.org>; Wed, 08 May 2019 16:38:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=C29KWd7+aYnjnacjksQG1K+XGA+6W0gIxYeYZLTSKhk=;
        b=Cu0f/0EpBfUfGqMhe1cqVKd6xFVLNDIgP7uP+9vc4C5Fu822orwddj/jQVfzH3tZ8s
         h52KIv3K+bjSzKzqZYqZ9JPK+AGBdXLVJ59CdSE63W8TFWJ8k43UBBooKOqE1ikcOnDk
         4+f67uVjOVMyaE1pojoyeRMnCddHsIK/3W34TmaX1unRZubcXwm+sqNZyDuBeCOncVVl
         OWj7HYzaC70wVtPUGyBv7NMRQ7nWGw+oSW6LcjS0/hGubp+4fQaiQRs0lixtRcj4wBXD
         jT0DU0Bw656qP6+5hrIKI4216sx1VIOMzG+Pr9U9G3n5VYdv5s7fabF5cIewVa+xvmuL
         IPog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=C29KWd7+aYnjnacjksQG1K+XGA+6W0gIxYeYZLTSKhk=;
        b=MuzfjPoY+1xHlsb9/ONHNiEjo7DPd61W+Ywbnk22FVQyhV1qq6KxUwNd212QZZpypN
         W42jffjKy4dR2XS1i7Vw4abZcPzwv8KGMTiHeq2UeJAqwHVlAe4e3EsWUn4JxW17d4WK
         WysyQgWxSC6Gku7NtvGj1B5N/gxoV2XxjU6I4QQqPyrKuMbtW/b8ajGSDBOEIYLIdfKa
         hesmFMAmsLteGsTEEeIS/hnmvtd9Xf/hgaGvxCdv1ywROu+FC2sjomaYoSy8thisitYR
         BbFGqBHXhHDqGU1c4tUysi2e+AGtg/pFmyQIu3S3KLMbrwqjTnTKe6suXo5T9RzjS5/0
         5RfQ==
X-Gm-Message-State: APjAAAW1/Nohk16Gdr4DTpR+zYFEj90eSdVPHo+bE2HKS9kowjaBpPhj
        XtnlA4DMlTrJXuewiUYzgPdRvdYGOiiW7lSMhNt3vkg5GAl66bBZ
X-Google-Smtp-Source: APXvYqzCYX2CWCwnrPXSbdmODbeJdzxezVGol37qh/nhK7Aq+yCni96t265OQEkXPSZzlb6CVoPCnpK5gc8pzXweBgE=
X-Received: by 2002:a1c:23d2:: with SMTP id j201mr486340wmj.139.1557358726119;
 Wed, 08 May 2019 16:38:46 -0700 (PDT)
MIME-Version: 1.0
From:   Unknown Unknown <jdtxs00@gmail.com>
Date:   Wed, 8 May 2019 18:38:36 -0500
Message-ID: <CAMnf+Ph-Bx=WzxTpXuc8H6vXtDf-7Z52ywDRt9Gm6WN0X14PFg@mail.gmail.com>
Subject: XFRM/IPsec memory leak
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello all,

I've been looking into a severe kernel memory leak (120MB per day)
with xfrm/ipsec for the past few weeks and I'm a bit stuck on it. Here
is my configuration/setup and a bit of background.

==== Affected kernels (only tested x86-64) ====
3.x
4.4.x
4.14.x
4.19.x
5.0
5.1

==== Setup/config ====
CentOS 7.6.1810 64bit
KVM virtualization (QEMU)
strongSwan U5.7.2 - IKEv2 in tunnel mode, IPv4 traffic only.

==== Some background ====
I have a few hundred IKEv2 tunnels established on a few virtual
machines, and I had noticed them running out of memory and triggering
OOMkiller.

These virtual machines are running the 4.14 series kernel. I looked at
userspace memory usage with various tools and /proc/meminfo, top/htop,
and saw nothing using the memory at all.

I reviewed slabtop & smem and saw the kernel uncached memory usage was
extremely high, and slabtop showed an excessive amount of objects
inside of the kmalloc-1024 slab.

~]# grep -w "kmalloc-1024" /proc/slabinfo  | tail -n1
kmalloc-1024       35552  35856   1024   16    4 : tunables    0    0
 0 : slabdata   2241   2241      0

~]# smem -tkw
Area                           Used      Cache   Noncache
firmware/hardware                 0          0          0
kernel image                      0          0          0
kernel dynamic memory          5.0G       3.8G       1.2G
userspace memory             637.3M      83.1M     554.2M
free memory                    2.2G       2.2G          0
----------------------------------------------------------
                               7.8G       6.1G       1.7G

~]# cat /proc/meminfo
MemTotal:        8170884 kB
MemFree:         2314448 kB
MemAvailable:    5655448 kB
Buffers:          297816 kB
Cached:          3501628 kB
SwapCached:            0 kB
Active:          2943096 kB
Inactive:        1427776 kB
Active(anon):     842004 kB
Inactive(anon):   160604 kB
Active(file):    2101092 kB
Inactive(file):  1267172 kB
Unevictable:           0 kB
Mlocked:               0 kB
SwapTotal:             0 kB
SwapFree:              0 kB
Dirty:                96 kB
Writeback:             0 kB
AnonPages:        563076 kB
Mapped:            88336 kB
Shmem:            431180 kB
Slab:             361640 kB
SReclaimable:     278508 kB
SUnreclaim:        83132 kB
KernelStack:        4928 kB
PageTables:        22036 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:     4085440 kB
Committed_AS:    1586480 kB
VmallocTotal:   34359738367 kB
VmallocUsed:           0 kB
VmallocChunk:          0 kB
HardwareCorrupted:     0 kB
AnonHugePages:    346112 kB
ShmemHugePages:        0 kB
ShmemPmdMapped:        0 kB
HugePages_Total:       0
HugePages_Free:        0
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:       2048 kB
DirectMap4k:      507772 kB
DirectMap2M:     7880704 kB


I tried stopping every piece of software on the entire machine, even
manually clearing out all xfrm policies/states. Nothing reclaimed the
memory back. Only fully rebooting the virtual machine gave us the
memory back.

==== Debugging it ====
From there, I decided to debug the issue further by building a 4.14
kernel with KMEMLEAK config options enabled. This got me some results
and a clue,

~]# grep "comm" /sys/kernel/debug/kmemleak | grep -v "softirq" | awk
'{print $2}' | cut -d '"' -f2 | sort | uniq -c | sort -n -r
16392 charon

Here's the backtrace for that, all of them look identical to this,
just with a different pointer address.

unreferenced object 0xffff8881b1185000 (size 1024):
comm "charon", pid 3878, jiffies 4703093548 (age 1220.692s)
hex dump (first 32 bytes):
80 50 1c 82 ff ff ff ff 00 00 00 00 00 00 00 00 .P..............
00 02 00 00 00 00 ad de 00 01 00 00 00 00 ad de ................
backtrace:
[<ffffffff817ed5da>] kmemleak_alloc+0x4a/0xa0
[<ffffffff8122f8de>] kmem_cache_alloc_trace+0xce/0x1d0
[<ffffffff81747530>] xfrm_policy_alloc+0x30/0x110
[<ffffffff81758395>] xfrm_policy_construct+0x25/0x230
[<ffffffff81758658>] xfrm_add_policy+0xb8/0x170
[<ffffffff81757894>] xfrm_user_rcv_msg+0x1b4/0x1e0
[<ffffffff816dae0f>] netlink_rcv_skb+0xdf/0x120
[<ffffffff81756a35>] xfrm_netlink_rcv+0x35/0x50
[<ffffffff816da55d>] netlink_unicast+0x18d/0x260
[<ffffffff816da90f>] netlink_sendmsg+0x2df/0x3d0
[<ffffffff8167916e>] sock_sendmsg+0x3e/0x50
[<ffffffff81679652>] SYSC_sendto+0x102/0x190
[<ffffffff8167b1ee>] SyS_sendto+0xe/0x10
[<ffffffff81003959>] do_syscall_64+0x79/0x1b0
[<ffffffff81800081>] entry_SYSCALL_64_after_hwframe+0x3d/0xa2
[<ffffffffffffffff>] 0xffffffffffffffff

So, I decided to upgrade to the 4.19 kernel to see if it was fixed.
While it appeared that kmemleak was not reporting anything, memory was
still being lost quickly on the machine.

I then upgraded to the 5.1 mainline kernel, but the kernel memory leak
was still happening, despite no reports from kmemleak.

==== Reproducing the problem ====

From my testing, the following can be done to reproduce the leak on
all kernel versions:
- Bring up multiple IKEv2 tunnels
- Pass IPv4 traffic through the tunnel(s) (if you simply bring up the
tunnel and pass no traffic, the leak does not seem to happen.)
- Observe kernel memory usage grow over time

With a load of ~100 IKEv2 tunnels, and 200Mbps traffic between all of
them, I saw a leak ~121MB per 24 hours.

I have tried all varieties of hardware (single CPU, dual cpu), NIC's
(bridging/SR-IOV), kernels, and it happens on every configuration I
tried.


Does anyone know what might be causing this or have any advice on
debugging this further?
