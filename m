Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3A88489BA1
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 15:54:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235761AbiAJOye (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 09:54:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230426AbiAJOyd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 09:54:33 -0500
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7806CC06173F;
        Mon, 10 Jan 2022 06:54:33 -0800 (PST)
Received: by mail-yb1-xb31.google.com with SMTP id g14so10144154ybs.8;
        Mon, 10 Jan 2022 06:54:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qal2CCc/ypCVLgFanrL2Ijt2N1JQDQJXt0zzH2smX8U=;
        b=bfys7VfoZ2kYE4HvWhWS5QBhMLldlaZEkUrkA3joxoR7BZ7uDdFoe9balYP72kzA2g
         JREYMKhr8s9s3SV9WJZ3YS5regvuJTHo0wNbedfMo0rNE8HEQQDaNCrtZMtjGaEZD+Px
         e7kdPZPsAEOJCIidXDccN6RH98emPdC8ayeWMbIoYYqZeJYIX53IX8J7VzlOaMNeZQEj
         VLPAGv8isDbK/EX8AKKgdOUVCmnMOdfKRT4wBI1FHDwAUPmmVhqBQuj15lAkdc3vMNYj
         vWK0l4beovTjUmIWCBsNKgDsqSpTh6rsqYL9mzfDfwmEjIx4QukhNi6YoLF6ywx/BpPD
         QXsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qal2CCc/ypCVLgFanrL2Ijt2N1JQDQJXt0zzH2smX8U=;
        b=DsoZMR+CZ9mAx8kvVPc5RUEJfmHDNcgInbUmY2E60JtiSMFKE1T1DssRKqdUCKXjoZ
         ER8wYBh3e4jrkbi6QzK6JiofULwlpxtXHY7+SCMPlAxnluQX6PpMpniCZpYIAtq7sqRo
         esBnfJ5BJ4DaUA/+NUwCxT/YOivN+EGxuX9wXM5LHDf9+rmOgl8abBWX7+QCzvrtl42n
         A8BL3az1C+d7UHPm/+Q29kXhy+YzHJOuhM3QIPT8RDAkqTThMAyFyRGji63fW4UxAk4q
         ihlJhEzxYAlhnR4ZXl7Yq1o0i7DKDBl/M7UebPBR17DKHXejE28x6pPf9zzJyySCBbkk
         8Ykw==
X-Gm-Message-State: AOAM5332S1W5G/WGhaqI3G600mtdvM8DTJbE0XA13jMyQCt3UWuXA9nh
        ab7rkaQCjdZ//85Gk+4qv6jgj5IgSfGLQ7vJ/oM=
X-Google-Smtp-Source: ABdhPJwHL6r/hZbeRNWAhqgiNbgrT6Rb29y0thLUuqwEUUzfci0xWdErJIywfhnM0twqWyGEifwLuyUkDjCri07QK08=
X-Received: by 2002:a25:77ca:: with SMTP id s193mr1268164ybc.510.1641826472447;
 Mon, 10 Jan 2022 06:54:32 -0800 (PST)
MIME-Version: 1.0
References: <CAKXUXMzZkQvHJ35nwVhcJe+DrtEXGw+eKGVD04=xRJkVUC2sPA@mail.gmail.com>
 <20220109132038.38f8ae4f@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220109132038.38f8ae4f@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Lukas Bulwahn <lukas.bulwahn@gmail.com>
Date:   Mon, 10 Jan 2022 15:54:21 +0100
Message-ID: <CAKXUXMwr9NaJ4eN+eNWrD-Pkq4WLPzfVRPBJPCdwWE8C3-eMbg@mail.gmail.com>
Subject: Re: Observation of a memory leak with commit 314001f0bf92 ("af_unix:
 Add OOB support")
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Rao Shoaib <rao.shoaib@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>,
        regressions@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 9, 2022 at 10:20 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Fri, 7 Jan 2022 07:48:46 +0100 Lukas Bulwahn wrote:
> > Dear Rao and David,
> >
> >
> > In our syzkaller instance running on linux-next,
> > https://elisa-builder-00.iol.unh.edu/syzkaller-next/, we have been
> > observing a memory leak in prepare_creds,
> > https://elisa-builder-00.iol.unh.edu/syzkaller-next/report?id=1dcac8539d69ad9eb94ab2c8c0d99c11a0b516a3,
> > for quite some time.
> >
> > It is reproducible on v5.15-rc1, v5.15, v5.16-rc8 and next-20220104.
> > So, it is in mainline, was released and has not been fixed in
> > linux-next yet.
> >
> > As syzkaller also provides a reproducer, we bisected this memory leak
> > to be introduced with  commit 314001f0bf92 ("af_unix: Add OOB
> > support").
> >
> > We also tested that reverting this commit on torvalds' current tree
> > made the memory leak with the reproducer go away.
> >
> > Could you please have a look how your commit introduces this memory
> > leak? We will gladly support testing your fix in case help is needed.
>
> Let's test the regression/bug report tracking bot :)
>
> #regzbot introduced: 314001f0bf92

Here is all relevant information:

We have a reproducer program and this reproducer setup:


Kernel Build:

make mrproper && make defconfig && make kvm_guest.config &&
scripts/config -e KCOV -e KCOV_INSTRUMENT_ALL -e
KCOV_ENABLE_COMPARISONS -e DEBUG_FS -e DEBUG_KMEMLEAK -e DEBUG_INFO -e
KALLSYMS -e KALLSYMS_ALL -e NAMESPACES -e UTS_NS -e IPC_NS -e PID_NS
-e NET_NS -e CGROUP_PIDS -e MEMCG -e USER_NS -e CONFIGFS_FS -e
SECURITYFS -e FAULT_INJECTION -e FAULT_INJECTION_DEBUG_FS -e
FAULT_INJECTION_USERCOPY -e FAILSLAB -e FAIL_PAGE_ALLOC -e
FAIL_MAKE_REQUEST -e FAIL_IO_TIMEOUT -e FAIL_FUTEX -e LOCKDEP -e
PROVE_LOCKING -e DEBUG_ATOMIC_SLEEP -e PROVE_RCU -e DEBUG_VM -e
REFCOUNT_FULL -e FORTIFY_SOURCE -e HARDENED_USERCOPY -e
LOCKUP_DETECTOR -e SOFTLOCKUP_DETECTOR -e HARDLOCKUP_DETECTOR -e
BOOTPARAM_HARDLOCKUP_PANIC -e DETECT_HUNG_TASK -e WQ_WATCHDOG -e
USB_GADGET -e USB_RAW_GADGET -e TUN -e KCSAN -d RANDOMIZE_BASE -e
MAC80211_HWSIM -e IEEE802154 -e MAC802154 -e IEEE802154_DRIVERS -e
IEEE802154_HWSIM -e BT -e BT_HCIVHCI && make olddefconfig && make -j
24

(This is not a minimal config for the reproducer.)


QEMU Command:

qemu-system-x86_64 -m 2048 -smp 2 -chardev
socket,id=SOCKSYZ,server,nowait,host=localhost,port=46514 -mon
chardev=SOCKSYZ,mode=control -display none -serial stdio -no-reboot
-name VM-test -device virtio-rng-pci -enable-kvm -cpu
host,migratable=off -device e1000,netdev=net0 -netdev
user,id=net0,restrict=on,hostfwd=tcp:127.0.0.1:28993-:22 -hda
bullseye.img -snapshot -kernel bzImage -append "root=/dev/sda
console=ttyS0"

Reproducer: see C program at the bottom of
https://elisa-builder-00.iol.unh.edu/syzkaller-next/report?id=1dcac8539d69ad9eb94ab2c8c0d99c11a0b516a3

Trigger in QEMU: compile reproducer with gcc and run it

We observe the memory leak output below on next-20220110 with the setup above.
We do NOT observe the memory leak output below on next-20220110, when
disabling AF_UNIX_OOB.

So, no memory leak for a kernel build with this diff in the repository
and everything else same as above. That is also why the bisection
identified commit 314001f0bf92 to introduce this memory leak.

diff --git a/net/unix/Kconfig b/net/unix/Kconfig
index b7f811216820..e4175feb1809 100644
--- a/net/unix/Kconfig
+++ b/net/unix/Kconfig
@@ -28,7 +28,7 @@ config UNIX_SCM
 config AF_UNIX_OOB
        bool
        depends on UNIX
-       default y
+       default n

 config UNIX_DIAG
        tristate "UNIX: socket monitoring interface"



memory leak output:

BUG: memory leak
unreferenced object 0xffff888012fd0240 (size 192):
  comm "a.out", pid 250, jiffies 4294908743 (age 13.529s)
  hex dump (first 32 bytes):
    02 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<00000000a3bddd5a>] kmem_cache_alloc+0x133/0x2d0
    [<00000000587efbf5>] prepare_creds+0x27/0x420
    [<0000000095b9beb6>] copy_creds+0x3a/0x600
    [<000000004e59ddd9>] copy_process+0x830/0x2b80
    [<000000005840a46d>] kernel_clone+0x89/0xbf0
    [<0000000070c730ab>] __do_sys_clone+0x88/0xb0
    [<00000000f5b1c158>] do_syscall_64+0x3a/0x80
    [<000000004a0e7245>] entry_SYSCALL_64_after_hwframe+0x44/0xae

BUG: memory leak
unreferenced object 0xffff88800536dba0 (size 32):
  comm "a.out", pid 250, jiffies 4294908743 (age 13.529s)
  hex dump (first 32 bytes):
    01 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<00000000e0ec3d82>] __kmalloc+0x161/0x270
    [<000000006e2dab2d>] security_prepare_creds+0xa3/0xd0
    [<0000000090cfc7fd>] prepare_creds+0x2d6/0x420
    [<0000000095b9beb6>] copy_creds+0x3a/0x600
    [<000000004e59ddd9>] copy_process+0x830/0x2b80
    [<000000005840a46d>] kernel_clone+0x89/0xbf0
    [<0000000070c730ab>] __do_sys_clone+0x88/0xb0
    [<00000000f5b1c158>] do_syscall_64+0x3a/0x80
    [<000000004a0e7245>] entry_SYSCALL_64_after_hwframe+0x44/0xae

BUG: memory leak
unreferenced object 0xffff88800dba5c00 (size 232):
  comm "a.out", pid 250, jiffies 4294908743 (age 13.529s)
  hex dump (first 32 bytes):
    02 00 00 00 00 00 00 00 00 00 00 00 ad 4e ad de  .............N..
    ff ff ff ff 00 00 00 00 ff ff ff ff ff ff ff ff  ................
  backtrace:
    [<00000000a3bddd5a>] kmem_cache_alloc+0x133/0x2d0
    [<0000000069a36692>] alloc_pid+0x6d/0x670
    [<000000006f39f82c>] copy_process+0x1a95/0x2b80
    [<000000005840a46d>] kernel_clone+0x89/0xbf0
    [<0000000070c730ab>] __do_sys_clone+0x88/0xb0
    [<00000000f5b1c158>] do_syscall_64+0x3a/0x80
    [<000000004a0e7245>] entry_SYSCALL_64_after_hwframe+0x44/0xae

BUG: memory leak
unreferenced object 0xffff888014438e80 (size 1856):
  comm "a.out", pid 251, jiffies 4294908743 (age 13.529s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 58 01 00 00 00 00 00 00  ........X.......
    01 00 07 40 00 00 00 00 00 00 00 00 00 00 00 00  ...@............
  backtrace:
    [<00000000a3bddd5a>] kmem_cache_alloc+0x133/0x2d0
    [<000000004c97eff8>] sk_prot_alloc+0x3e/0x1b0
    [<0000000034d397b2>] sk_alloc+0x34/0x320
    [<0000000046549569>] unix_create1+0x84/0x260
    [<00000000e72cbd15>] unix_create+0x90/0x120
    [<000000000d82ff9e>] __sock_create+0x285/0x520
    [<00000000087d9b40>] __sys_socketpair+0x142/0x380
    [<00000000f7586b33>] __x64_sys_socketpair+0x1e/0x30
    [<00000000f5b1c158>] do_syscall_64+0x3a/0x80
    [<000000004a0e7245>] entry_SYSCALL_64_after_hwframe+0x44/0xae

BUG: memory leak
unreferenced object 0xffff8880135311c0 (size 32):
  comm "a.out", pid 251, jiffies 4294908743 (age 13.529s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    01 00 00 00 01 00 00 00 18 00 00 00 00 00 00 00  ................
  backtrace:
    [<00000000b535b6cd>] kmem_cache_alloc_trace+0x144/0x220
    [<000000008c20c9fd>] selinux_sk_alloc_security+0x52/0xf0
    [<00000000cdf964c1>] security_sk_alloc+0x39/0x70
    [<0000000005d51b11>] sk_prot_alloc+0x89/0x1b0
    [<0000000034d397b2>] sk_alloc+0x34/0x320
    [<0000000046549569>] unix_create1+0x84/0x260
    [<00000000e72cbd15>] unix_create+0x90/0x120
    [<000000000d82ff9e>] __sock_create+0x285/0x520
    [<00000000087d9b40>] __sys_socketpair+0x142/0x380
    [<00000000f7586b33>] __x64_sys_socketpair+0x1e/0x30
    [<00000000f5b1c158>] do_syscall_64+0x3a/0x80
    [<000000004a0e7245>] entry_SYSCALL_64_after_hwframe+0x44/0xae
