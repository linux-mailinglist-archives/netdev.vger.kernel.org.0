Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 730F648383
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 15:07:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728093AbfFQNHu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 09:07:50 -0400
Received: from mail-lf1-f44.google.com ([209.85.167.44]:41355 "EHLO
        mail-lf1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728030AbfFQNHu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 09:07:50 -0400
Received: by mail-lf1-f44.google.com with SMTP id 136so6439243lfa.8
        for <netdev@vger.kernel.org>; Mon, 17 Jun 2019 06:07:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=9QomE5HxJLHYA0cczhFwTWQ/i7i5MtKnbZGvWTXLvdY=;
        b=Q/8SFCnre/j6rPGk+ytZQUGZhP0Zo8WOrGDVd+R7tRJXn7qzBBcwlnqPxIlMpuDlb4
         mvjBUfmO84UkTcdaJASKiIJiyzG41MgcDsKbyR3mjjVmKqtFA0Ta7CYborlc8ABn8nFA
         hz0zejQ7kMiXe3gMsYyhdqSGKIj7XDCLMrNoHGzEg61XRn6/7QUyvcd6K8u7NXwd9y4s
         Ia0Urpm8Tl0pLKqUic6uPzYcrqYAXoFE0sn5gXMzPUoielQ0a1MgLFu+bM2QNQEd0WnW
         MEy+Ei73X7kjuAWdH+bDdI14Dmf4P9pspcJ07/SdWczjPavgkfuS8UfkgueKlhn8JXE7
         XkOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=9QomE5HxJLHYA0cczhFwTWQ/i7i5MtKnbZGvWTXLvdY=;
        b=MswBGx1W2DIxcI+LEra7U+Y8BiThwgiveLKVFaBl1c0HePqAkpplVjuRgZIYeSbQ54
         tdK5N9eetPspK/TTBgnReknZcFRpnQgyb2iXTze0kN8vi8eLo8n3wOXmTHWYa/a7/vm4
         QYw5oPSScg8KKnfUtWV+HiTi2InBf/8ocZOBKrVyrmIc0hmjytntfeciifztkU3P0d0E
         4as3i1ai3MiqrmAos/5xCKKN2TRFO2yoP7CeSJREh2AvMvdHxP+shdUE94PS1oskm5xg
         C574vavYYxupqAfc4OADWwVgTa6uNXNOjswDrjyTcMSUuslAJzd5YlXl2mQBmKG8phOr
         Fhmg==
X-Gm-Message-State: APjAAAVKvVcqQy/xUDc3aSMihxoF0zCVu+p2lAvxMguO70zy42An/2aL
        43G++9qw7p0JsXH02WVni5vtxkVeV0OXOXtfNlmK+wT6d3E=
X-Google-Smtp-Source: APXvYqwrtOvgo6/Fr3B//hfm86kWLu2/xtPMvEVGK46twASJ9SFVxrQzPIeb4y1wCklq7XNDxrYO3AADr9hBUgjkdvw=
X-Received: by 2002:a05:6512:51c:: with SMTP id o28mr39197814lfb.67.1560776866720;
 Mon, 17 Jun 2019 06:07:46 -0700 (PDT)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 17 Jun 2019 18:37:35 +0530
Message-ID: <CA+G9fYt1pTgZriRB9tj==3dPqtvMXVtKKDnd4qh00aMW2H-now@mail.gmail.com>
Subject: BUG: kernel NULL pointer dereference, address: 00000000
To:     Netdev <netdev@vger.kernel.org>, bpf@vger.kernel.org,
        Linux-Next Mailing List <linux-next@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Stanislav Fomichev <sdf@google.com>,
        Yonghong Song <yhs@fb.com>, alan.maguire@oracle.com,
        alexei.starovoitov@gmail.com, edumazet@google.com,
        john.fastabend@gmail.com, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org, ast@kernel.org, kafai@fb.com,
        Song Liu <songliubraving@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While running selftest bpf: test_sockmap the kernel BUG found on i386 and arm
kernel running on Linux version 5.2.0-rc5-next-20190617

steps to reproduce,
 cd /opt/kselftests/default-in-kernel/bpf
 ./test_sockmap

[   33.666964] BUG: kernel NULL pointer dereference, address: 00000000
[   33.673246] #PF: supervisor read access in kernel mode
[   33.678392] #PF: error_code(0x0000) - not-present page
[   33.683539] *pde = 00000000
[   33.686435] Oops: 0000 [#1] SMP
[   33.689593] CPU: 1 PID: 619 Comm: test_sockmap Not tainted
5.2.0-rc5-next-20190617 #1
[   33.697431] Hardware name: Supermicro SYS-5019S-ML/X11SSH-F, BIOS
2.0b 07/27/2017
[   33.704914] EIP: memcpy+0x1d/0x30
[   33.708240] Code: 59 58 eb 85 90 90 90 90 90 90 90 90 90 3e 8d 74
26 00 55 89 e5 57 56 89 c7 53 89 d6 89 cb c1 e9 02 f3 a5 89 d9 83 e1
03 74 02 <f3> a4 5b 5e 5f 5d c3 8d b6 00 00 00 00 8d bf 00 00 00 00 3e
8d 74
[   33.726985] EAX: f1faf000 EBX: 00000001 ECX: 00000001 EDX: 00000000
[   33.733249] ESI: 00000000 EDI: f1faf000 EBP: f2e6d99c ESP: f2e6d990
[   33.739505] DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068 EFLAGS: 00010202
[   33.746283] CR0: 80050033 CR2: 00000000 CR3: 31fae000 CR4: 003406d0
[   33.752542] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[   33.758807] DR6: fffe0ff0 DR7: 00000400
[   33.762638] Call Trace:
[   33.765084]  bpf_msg_push_data+0x635/0x660
[   33.769183]  ? _raw_spin_unlock_irqrestore+0x2f/0x50
[   33.774150]  ? lockdep_hardirqs_on+0xec/0x1a0
[   33.778512]  ___bpf_prog_run+0xa0d/0x15a0
[   33.782523]  ? __lock_acquire+0x1fe/0x1ec0
[   33.786621]  __bpf_prog_run32+0x4b/0x70
[   33.790462]  ? sk_psock_msg_verdict+0x5/0x290
[   33.794819]  sk_psock_msg_verdict+0xad/0x290
[   33.799091]  ? sk_psock_msg_verdict+0xad/0x290
[   33.803537]  ? lockdep_hardirqs_on+0xec/0x1a0
[   33.807887]  ? __local_bh_enable_ip+0x78/0xf0
[   33.812238]  tcp_bpf_send_verdict+0x29c/0x3b0
[   33.816590]  tcp_bpf_sendpage+0x233/0x3d0
[   33.820603]  ? __lock_acquire+0x1fe/0x1ec0
[   33.824703]  ? __lock_acquire+0x1fe/0x1ec0
[   33.828801]  ? find_held_lock+0x27/0xa0
[   33.832640]  ? lock_release+0x92/0x290
[   33.836392]  ? find_get_entry+0x136/0x300
[   33.840397]  ? touch_atime+0x34/0xd0
[   33.843978]  ? copy_page_to_iter+0x245/0x400
[   33.848248]  ? lockdep_hardirqs_on+0xec/0x1a0
[   33.852600]  ? tcp_bpf_send_verdict+0x3b0/0x3b0
[   33.857132]  inet_sendpage+0x53/0x1f0
[   33.860789]  ? inet_recvmsg+0x1e0/0x1e0
[   33.864620]  ? kernel_sendpage+0x40/0x40
[   33.868536]  kernel_sendpage+0x1e/0x40
[   33.872282]  sock_sendpage+0x24/0x30
[   33.875861]  pipe_to_sendpage+0x59/0xa0
[   33.879692]  ? direct_splice_actor+0x40/0x40
[   33.883962]  __splice_from_pipe+0xde/0x1c0
[   33.888055]  ? direct_splice_actor+0x40/0x40
[   33.892342]  ? direct_splice_actor+0x40/0x40
[   33.896635]  splice_from_pipe+0x59/0x80
[   33.900466]  ? splice_from_pipe+0x80/0x80
[   33.904469]  ? generic_splice_sendpage+0x20/0x20
[   33.909080]  generic_splice_sendpage+0x18/0x20
[   33.913516]  ? direct_splice_actor+0x40/0x40
[   33.917782]  direct_splice_actor+0x2d/0x40
[   33.921880]  splice_direct_to_actor+0x127/0x240
[   33.926403]  ? generic_pipe_buf_nosteal+0x10/0x10
[   33.931105]  do_splice_direct+0x7e/0xc0
[   33.934944]  do_sendfile+0x20d/0x3e0
[   33.938522]  sys_sendfile+0xac/0xd0
[   33.942015]  do_fast_syscall_32+0x8e/0x320
[   33.946114]  entry_SYSENTER_32+0x70/0xc8
[   33.950039] EIP: 0xb7fa67a1
[   33.952830] Code: 8b 98 60 cd ff ff 85 d2 89 c8 74 02 89 0a 5b 5d
c3 8b 04 24 c3 8b 14 24 c3 8b 1c 24 c3 8b 3c 24 c3 51 52 55 89 e5 0f
34 cd 80 <5d> 5a 59 c3 90 90 90 90 8d 76 00 58 b8 77 00 00 00 cd 80 90
8d 76
[   33.971567] EAX: ffffffda EBX: 00000018 ECX: 0000001c EDX: 00000000
[   33.977823] ESI: 00000001 EDI: 00000018 EBP: 00000001 ESP: bfcaa6d4
[   33.984083] DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 007b EFLAGS: 00000206
[   33.990869] Modules linked in: x86_pkg_temp_thermal fuse
[   33.996181] CR2: 0000000000000000
[   33.999500] ---[ end trace 0ef7a1496c65bde8 ]---

- Naresh
