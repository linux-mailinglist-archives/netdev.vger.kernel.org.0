Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87B922C0C21
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 14:57:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387478AbgKWNpv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 08:45:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:36720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729709AbgKWNpu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Nov 2020 08:45:50 -0500
Received: from mail-oo1-f51.google.com (mail-oo1-f51.google.com [209.85.161.51])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 166ED2080A;
        Mon, 23 Nov 2020 13:45:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606139149;
        bh=kjn7swa6fotytoiJA6cE+1G/MbbCkdW3yZcShPQ7+JE=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=BQOGGqjEpozGhP/L0gmMjslxhw/D8nilD2qQ785dKQRsvT+75nmoU8IPlvZ5beS18
         LzorvtWuWzk5MF7sNa//PQK4kMX8OeJCl03lI6CNK3Y4rr5iohgvQDwaMMvWus0vj5
         mO/ESIDL5YTxCYAuvqQVVdncmxHQgVov+lMeqZ2U=
Received: by mail-oo1-f51.google.com with SMTP id t142so3947922oot.7;
        Mon, 23 Nov 2020 05:45:49 -0800 (PST)
X-Gm-Message-State: AOAM533QXGRL6F//VWUCKSeLhs1/KQ4Mp4Y1fkVc+V9BVpOuvnfQ44yN
        HscC6nX7mT8ZFu+eCNr1VgVpHaTrgInenUGB0/Q=
X-Google-Smtp-Source: ABdhPJzczVmrFcxgPZdLBuXhrHnNj7F+3gH9f6U/W5Ic8vDBsgeFdFZlrQeSgsj9HFiayxfbTKufG8/qXI/z8fOWrb8=
X-Received: by 2002:a4a:7055:: with SMTP id b21mr22335925oof.66.1606139148251;
 Mon, 23 Nov 2020 05:45:48 -0800 (PST)
MIME-Version: 1.0
References: <CA+G9fYs9sg69JgmQNZhutQnbijb4GzcO03XF66EjkQ6CTpXXxA@mail.gmail.com>
In-Reply-To: <CA+G9fYs9sg69JgmQNZhutQnbijb4GzcO03XF66EjkQ6CTpXXxA@mail.gmail.com>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Mon, 23 Nov 2020 14:45:32 +0100
X-Gmail-Original-Message-ID: <CAK8P3a1Lx1MMQ3s1uWjevsi2wqFo2r=k1hhrxf1spUxEQX_Rag@mail.gmail.com>
Message-ID: <CAK8P3a1Lx1MMQ3s1uWjevsi2wqFo2r=k1hhrxf1spUxEQX_Rag@mail.gmail.com>
Subject: Re: [arm64] kernel BUG at kernel/seccomp.c:1309!
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        lkft-triage@lists.linaro.org,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kees Cook <keescook@chromium.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Jann Horn <jannh@google.com>,
        yifeifz2@illinois.edu,
        Gabriel Krisman Bertazi <krisman@collabora.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 23, 2020 at 12:15 PM Naresh Kamboju
<naresh.kamboju@linaro.org> wrote:
>
> While booting arm64 kernel the following kernel BUG noticed on several arm64
> devices running linux next 20201123 tag kernel.
>
>
> $ git log --oneline next-20201120..next-20201123 -- kernel/seccomp.c
> 5c5c5fa055ea Merge remote-tracking branch 'seccomp/for-next/seccomp'
> bce6a8cba7bf Merge branch 'linus'
> 7ef95e3dbcee Merge branch 'for-linus/seccomp' into for-next/seccomp
> fab686eb0307 seccomp: Remove bogus __user annotations
> 0d8315dddd28 seccomp/cache: Report cache data through /proc/pid/seccomp_cache
> 8e01b51a31a1 seccomp/cache: Add "emulator" to check if filter is constant allow
> f9d480b6ffbe seccomp/cache: Lookup syscall allowlist bitmap for fast path
> 23d67a54857a seccomp: Migrate to use SYSCALL_WORK flag
>
>
> Please find these easy steps to reproduce the kernel build and boot.

Adding Gabriel Krisman Bertazi to Cc, as the last patch (23d67a54857a) here
seems suspicious: it changes

diff --git a/include/linux/seccomp.h b/include/linux/seccomp.h
index 02aef2844c38..47763f3999f7 100644
--- a/include/linux/seccomp.h
+++ b/include/linux/seccomp.h
@@ -42,7 +42,7 @@ struct seccomp {
 extern int __secure_computing(const struct seccomp_data *sd);
 static inline int secure_computing(void)
 {
-       if (unlikely(test_thread_flag(TIF_SECCOMP)))
+       if (unlikely(test_syscall_work(SECCOMP)))
                return  __secure_computing(NULL);
        return 0;
 }

which is in the call chain directly before

int __secure_computing(const struct seccomp_data *sd)
{
       int mode = current->seccomp.mode;

...
        switch (mode) {
        case SECCOMP_MODE_STRICT:
                __secure_computing_strict(this_syscall);  /* may call do_exit */
                return 0;
        case SECCOMP_MODE_FILTER:
                return __seccomp_filter(this_syscall, sd, false);
        default:
                BUG();
        }
}

Clearly, current->seccomp.mode is set to something other
than SECCOMP_MODE_STRICT or SECCOMP_MODE_FILTER
while the test_syscall_work(SECCOMP) returns true, and this
must have not been the case earlier.

         Arnd

>
> step to reproduce:
> # please install tuxmake
> # sudo pip3 install -U tuxmake
> # cd linux-next
> # tuxmake --runtime docker --target-arch arm --toolchain gcc-9
> --kconfig defconfig --kconfig-add
> https://builds.tuxbuild.com/1kgWN61pS5M35vjnVfDSvOOPd38/config
>
> # Boot the arm64 on any arm64 devices.
> # you will notice the below BUG
>
> crash log details:
> -----------------------
> [    6.941012] ------------[ cut here ]------------
> Found device  /dev/ttyAMA3.
> [    6.947587] lima f4080000.gpu: mod rate = 500000000
> [    6.955422] kernel BUG at kernel/seccomp.c:1309!
> [    6.955430] Internal error: Oops - BUG: 0 [#1] PREEMPT SMP
> [    6.955437] Modules linked in: cec rfkill wlcore_sdio(+) kirin_drm
> dw_drm_dsi lima(+) drm_kms_helper gpu_sched drm fuse
> [    6.955481] CPU: 2 PID: 291 Comm: systemd-udevd Not tainted
> 5.10.0-rc4-next-20201123 #2
> [    6.955485] Hardware name: HiKey Development Board (DT)
> [    6.955493] pstate: 80000005 (Nzcv daif -PAN -UAO -TCO BTYPE=--)
> [    6.955510] pc : __secure_computing+0xe0/0xe8
> [    6.958171] mmc_host mmc2: Bus speed (slot 0) = 24800000Hz (slot
> req 400000Hz, actual 400000HZ div = 31)
> [    6.965975] [drm] Initialized lima 1.1.0 20191231 for f4080000.gpu on minor 0
> [    6.970176] lr : syscall_trace_enter+0x1cc/0x218
> [    6.970181] sp : ffff800012d8be10
> [    6.970185] x29: ffff800012d8be10 x28: ffff00000092cb00
> [    6.970195] x27: 0000000000000000 x26: 0000000000000000
> [    6.970203] x25: 0000000000000000 x24: 0000000000000000
> [    6.970210] x23: 0000000060000000 x22: 0000000000000202
> [    7.011614] mmc_host mmc2: Bus speed (slot 0) = 24800000Hz (slot
> req 25000000Hz, actual 24800000HZ div = 0)
> [    7.016457]
> [    7.016461] x21: 0000000000000200 x20: ffff00000092cb00
> [    7.016470] x19: ffff800012d8bec0 x18: 0000000000000000
> [    7.016478] x17: 0000000000000000 x16: 0000000000000000
> [    7.016485] x15: 0000000000000000 x14: 0000000000000000
> [    7.054116] mmc_host mmc2: Bus speed (slot 0) = 24800000Hz (slot
> req 400000Hz, actual 400000HZ div = 31)
> [    7.056715]
> [    7.103444] mmc_host mmc2: Bus speed (slot 0) = 24800000Hz (slot
> req 25000000Hz, actual 24800000HZ div = 0)
> [    7.105105] x13: 0000000000000000 x12: 0000000000000000
> [    7.125849] x11: 0000000000000000 x10: 0000000000000000
> [    7.125858] x9 : ffff80001001bcbc x8 : 0000000000000000
> [    7.125865] x7 : 0000000000000000 x6 : 0000000000000000
> [    7.125871] x5 : 0000000000000000 x4 : 0000000000000000
> [    7.125879] x3 : 0000000000000000 x2 : ffff00000092cb00
> [    7.125886] x1 : 0000000000000000 x0 : 0000000000000116
> [    7.125896] Call trace:
> ] Found device /dev/ttyAMA2.
> [    7.125908]  __secure_computing+0xe0/0xe8
> [    7.125918]  syscall_trace_enter+0x1cc/0x218
> [    7.125927]  el0_svc_common.constprop.0+0x19c/0x1b8
> [    7.125933]  do_el0_svc+0x2c/0x98
> [    7.125940]  el0_sync_handler+0x180/0x188
> [    7.125946]  el0_sync+0x174/0x180
> [    7.125958] Code: d2800121 97ffd9a9 d2800120 97fbf1a9 (d4210000)
> [    7.199584] ---[ end trace 463debbc21f0c7b5 ]---
> [    7.204205] note: systemd-udevd[291] exited with preempt_count 1
> [    7.210733] ------------[ cut here ]------------
> [    7.215451] WARNING: CPU: 2 PID: #
> 0 at kernel/rcu/tree.c:632 rcu_eqs_enter.isra.0+0x134/0x140
> [    7.223927] Modules linked in: cec rfkill wlcore_sdio kirin_drm
> dw_drm_dsi lima drm_kms_helper gpu_sched drm fuse
> [    7.234295] CPU: 2 PID: 0 Comm: swapper/2 Tainted: G      D
>   5.10.0-rc4-next-20201123 #2
> [    7.243252] Hardware name: HiKey Development Board (DT)
> [    7.248561] pstate: 200003c5 (nzCv DAIF -PAN -UAO -TCO BTYPE=--)
> [    7.254638] pc : rcu_eqs_enter.isra.0+0x134/0x140
> [    7.259350] lr : rcu_idle_enter+0x18/0x28
> [    7.263362] sp : ffff8000128e3e80
> [    7.266678] x29: ffff8000128e3e80 x28: 0000000000000000
> [    7.272001] x27: 0000000000000000 x26: ffff000001b79080
> [    7.277321] x25: 0000000000000000 x24: 00000001adc9b310
> [    7.282641] x23: 0000000000000000 x22: ffff000001b79080
> [    7.287970] x21: ffff000077b24b00 x20: ffff000001b79098
> [    7.287979] x19: ffff800011c7ab40 x18: 0000000000000010
> [    7.287986] x17: 0000000000000000 x16: 0000000000000000
> [    7.287993] x15: ffff00000092cf98 x14: 0720072007200720
> [    7.288001] x13: 0720072007200720 x12: 00000000000003c6
> [    7.288008] x11: 071c71c71c71c71c x10: 00000000000003c6
> [    7.288016] x9 : ffff800010df267c x8 : 000000000000048c
> [    7.288023] x7 : 0000000000000c6f x6 : 0000000000009c3f
> [    7.288030] x5 : 00000000ffffffff x4 : 0000000000000015
> [    7.288038] x3 : 000000000022b7f0 x2 : 4000000000000002
> [    7.288046] x1 : 4000000000000000 x0 : ffff000077b26b40
> [    7.288054] Call trace:
> [    7.288064]  rcu_eqs_enter.isra.0+0x134/0x140
> #
> [    7.288069]  rcu_idle_enter+0x18/0x28
> [    7.288078]  cpuidle_enter_state+0x34c/0x438
> [    7.288084]  cpuidle_enter+0x40/0x58
> [    7.288092]  call_cpuidle+0x24/0x50
> Reached target Sockets.
> [    7.288108]  do_idle+0x228/0x290
> [    7.375468]  cpu_startup_entry+0x30/0x78
> [    7.379397]  secondary_start_kernel+0x158/0x190
> [    7.383930] ---[ end trace 463debbc21f0c7b6 ]---
> [     OK      ] Reached target B#
>
> Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
>
> full test log,
> https://qa-reports.linaro.org/lkft/linux-next-master/build/next-20201123/testrun/3478150/suite/linux-log-parser/test/check-kernel-bug-1968549/log
> https://qa-reports.linaro.org/lkft/linux-next-master/build/next-20201123/testrun/3478177/suite/linux-log-parser/test/check-kernel-bug-1968583/log
> https://qa-reports.linaro.org/lkft/linux-next-master/build/next-20201123/testrun/3478197/suite/linux-log-parser/test/check-kernel-bug-147858/log
>
> metadata:
>   git branch: master
>   git repo: https://gitlab.com/Linaro/lkft/mirrors/next/linux-next
>   git commit: 62918e6fd7b5751c1285c7f8c6cbd27eb6600c02
>   git describe: next-20201123
>   make_kernelversion: 5.10.0-rc4
>   kernel-config: https://builds.tuxbuild.com/1kgWN61pS5M35vjnVfDSvOOPd38/config
>
>
> --
> Linaro LKFT
> https://lkft.linaro.org
