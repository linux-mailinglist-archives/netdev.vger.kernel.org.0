Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5863414512
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 11:26:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234285AbhIVJ2Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 05:28:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233741AbhIVJ2P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Sep 2021 05:28:15 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9643AC061756
        for <netdev@vger.kernel.org>; Wed, 22 Sep 2021 02:26:44 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id t10so9284091lfd.8
        for <netdev@vger.kernel.org>; Wed, 22 Sep 2021 02:26:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lucidpixels.com; s=google;
        h=mime-version:from:date:message-id:subject:to;
        bh=QsNEHwy2d9In8nFXG4qbqOAGuxs9YqKoNyyMsOgWNj0=;
        b=HPMILGxuIfgnPqo22pit/ndPTxBrzlzzhciA9v9GitIV41+sHzBCAoOJjA7vWhRXFx
         SPxIjTDawNdSP6+d8FYaLKRSi4i/0n9Fsf4eT96oE41uHQDkxo0VqjBzAuAHnOzUHfHQ
         OdphlbIkTn5ksQqf/SMfpImo29N3ciVFuP1e4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=QsNEHwy2d9In8nFXG4qbqOAGuxs9YqKoNyyMsOgWNj0=;
        b=Oza4/cLLz0y5qFhYFtOi8tKtgCSCspPKEjzyxLbhWJgNMV4FmBf+K5Ve+HLAJgtxY3
         b9swYczjzm8ettLWanwPBebOPR0w0QulcvHuIR2as8phOJDt0izlSmXi1SHdSKb27ByI
         Z9f12/jrt3LIztB+btI7GCd56w0b8hBtYQrWOTxHY+7sXlaUzFSC44ARXk0obj9OkNZj
         3ba5syWYrlPkBl+WLLHFrUaJ6rGfMgu/2yqumCRsDHbtEa4j9zjcXdhOXHEOJtbDy2cD
         NNdLUHyuSxzxJ+mDeUFYm3TCTHDDV+auvjdN5tqoDV6FSF5OX5rf/4U7WDiSwP8z2WAo
         RQzg==
X-Gm-Message-State: AOAM5329V0+JuMj75MNJ5C6OfVHvjjFY3s29Ge8CuB+rYReoq0eVRjMc
        azurYBJ03DGtHrtCC16x7HFEczjd+FisggyghUGU0CGTNN5XoQ==
X-Google-Smtp-Source: ABdhPJzsVQBq42I7kHGa5wruWPOVVx1ymOgmQXBFbF/ydbf/K2UaPW9Z1Ngcv1qidYQXu1XgxuFp9JYkhWDJGnD622A=
X-Received: by 2002:a05:651c:206:: with SMTP id y6mr17908596ljn.98.1632302801701;
 Wed, 22 Sep 2021 02:26:41 -0700 (PDT)
MIME-Version: 1.0
From:   Justin Piszcz <jpiszcz@lucidpixels.com>
Date:   Wed, 22 Sep 2021 05:26:30 -0400
Message-ID: <CAO9zADxLTxeP8HTNs9LqanN2CiAOVTQ7x6GLcsNmJ8y9aeT7gg@mail.gmail.com>
Subject: 5.14.6: WARNING: CPU: 1 PID: 897 at include/linux/thread_info.h:200 ethtool_rxnfc_copy_to_user+0x11/0x20
To:     LKML <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

Arch: x86_64
Distribution: Debian testing
Kernel: 5.14.6

Recently I noticed this in dmesg after a reboot from 5.14.3, noticed
others ran into it as well from 2 days ago:
https://lkml.org/lkml/2021/9/20/475

[Wed Sep 22 05:14:33 2021] ------------[ cut here ]------------
[Wed Sep 22 05:14:33 2021] Buffer overflow detected (8 < 192)!
[Wed Sep 22 05:14:33 2021] WARNING: CPU: 1 PID: 897 at
include/linux/thread_info.h:200 ethtool_rxnfc_copy_to_user+0x11/0x20
[Wed Sep 22 05:14:33 2021] CPU: 1 PID: 897 Comm: nmbd Tainted: G
         T 5.14.6 #3 2312a638faa2fafaa8620a89d9c5a3692fbb0bb9
[Wed Sep 22 05:14:33 2021] Hardware name: Supermicro X9SRL-F/X9SRL-F,
BIOS 3.3 11/13/2018
[Wed Sep 22 05:14:33 2021] RIP: 0010:ethtool_rxnfc_copy_to_user+0x11/0x20
[Wed Sep 22 05:14:33 2021] Code: ff eb 94 b8 f4 ff ff ff eb 8d e8 2a
f2 22 00 66 2e 0f 1f 84 00 00 00 00 00 be 08 00 00 00 48 c7 c7 18 a6
b6 a4 e8 3f b5 19 00 <0f> 0b b8 f2 ff ff ff c3 0f 1f 80 00 00 00 00 41
56 41 55 41 54 55
[Wed Sep 22 05:14:33 2021] RSP: 0018:ffffa79bc1b57bd8 EFLAGS: 00010286
[Wed Sep 22 05:14:33 2021] RAX: 0000000000000000 RBX: 0000000000000000
RCX: ffffa174bfa575b8
[Wed Sep 22 05:14:33 2021] RDX: 00000000ffffffd8 RSI: 0000000000000027
RDI: ffffa174bfa575b0
[Wed Sep 22 05:14:33 2021] RBP: ffffa16585378000 R08: ffffffffa4e41aa0
R09: 0000000000000002
[Wed Sep 22 05:14:33 2021] R10: 0000000000000001 R11: ffffffffa56606f1
R12: 0000000000000000
[Wed Sep 22 05:14:33 2021] R13: 00007ffc52d108c0 R14: ffffa79bc1b57be8
R15: ffffffffa4984b00
[Wed Sep 22 05:14:33 2021] FS:  00007f2cc32a8a40(0000)
GS:ffffa174bfa40000(0000) knlGS:0000000000000000
[Wed Sep 22 05:14:33 2021] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[Wed Sep 22 05:14:33 2021] CR2: 000055cf41ae91c8 CR3: 0000000116be0005
CR4: 00000000[Wed Sep 22 05:14:33 2021] ------------[ cut here
]------------
[Wed Sep 22 05:14:33 2021] Buffer overflow detected (8 < 192)!
[Wed Sep 22 05:14:33 2021] WARNING: CPU: 1 PID: 897 at
include/linux/thread_info.h:200 ethtool_rxnfc_copy_to_user+0x11/0x20
[Wed Sep 22 05:14:33 2021] CPU: 1 PID: 897 Comm: nmbd Tainted: G
         T 5.14.6 #3 2312a638faa2fafaa8620a89d9c5a3692fbb0bb9
[Wed Sep 22 05:14:33 2021] Hardware name: Supermicro X9SRL-F/X9SRL-F,
BIOS 3.3 11/13/2018
[Wed Sep 22 05:14:33 2021] RIP: 0010:ethtool_rxnfc_copy_to_user+0x11/0x20
[Wed Sep 22 05:14:33 2021] Code: ff eb 94 b8 f4 ff ff ff eb 8d e8 2a
f2 22 00 66 2e 0f 1f 84 00 00 00 00 00 be 08 00 00 00 48 c7 c7 18 a6
b6 a4 e8 3f b5 19 00 <0f> 0b b8 f2 ff ff ff c3 0f 1f 80 00 00 00 00 41
56 41 55 41 54 55
[Wed Sep 22 05:14:33 2021] RSP: 0018:ffffa79bc1b57bd8 EFLAGS: 00010286
[Wed Sep 22 05:14:33 2021] RAX: 0000000000000000 RBX: 0000000000000000
RCX: ffffa174bfa575b8
[Wed Sep 22 05:14:33 2021] RDX: 00000000ffffffd8 RSI: 0000000000000027
RDI: ffffa174bfa575b0
[Wed Sep 22 05:14:33 2021] RBP: ffffa16585378000 R08: ffffffffa4e41aa0
R09: 0000000000000002
[Wed Sep 22 05:14:33 2021] R10: 0000000000000001 R11: ffffffffa56606f1
R12: 0000000000000000
[Wed Sep 22 05:14:33 2021] R13: 00007ffc52d108c0 R14: ffffa79bc1b57be8
R15: ffffffffa4984b00
[Wed Sep 22 05:14:33 2021] FS:  00007f2cc32a8a40(0000)
GS:ffffa174bfa40000(0000) knlGS:0000000000000000
[Wed Sep 22 05:14:33 2021] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[Wed Sep 22 05:14:33 2021] CR2: 000055cf41ae91c8 CR3: 0000000116be0005
CR4: 00000000001706e0
[Wed Sep 22 05:14:33 2021] Call Trace:
[Wed Sep 22 05:14:33 2021]  ethtool_get_rxnfc+0xec/0x1b0
[Wed Sep 22 05:14:33 2021]  dev_ethtool+0xb46/0x2870
[Wed Sep 22 05:14:33 2021]  ? kmem_cache_alloc+0x232/0x350
[Wed Sep 22 05:14:33 2021]  ? __alloc_file+0x94/0x100
[Wed Sep 22 05:14:33 2021]  ? kmem_cache_alloc+0x232/0x350
[Wed Sep 22 05:14:33 2021]  ? alloc_empty_file+0x5e/0xb0
[Wed Sep 22 05:14:33 2021]  dev_ioctl+0x151/0x480
[Wed Sep 22 05:14:33 2021]  sock_ioctl+0x248/0x360
[Wed Sep 22 05:14:33 2021]  __x64_sys_ioctl+0x425/0x980
[Wed Sep 22 05:14:33 2021]  ? syscall_exit_to_user_mode+0x1d/0x40
[Wed Sep 22 05:14:33 2021]  ? __x64_sys_socket+0x11/0x20
[Wed Sep 22 05:14:33 2021]  ? do_syscall_64+0x69/0x80
[Wed Sep 22 05:14:33 2021]  do_syscall_64+0x5c/0x80
[Wed Sep 22 05:14:33 2021]  ? __x64_sys_close+0x9/0x40
[Wed Sep 22 05:14:33 2021]  ? do_syscall_64+0x69/0x80
[Wed Sep 22 05:14:33 2021]  ? syscall_exit_to_user_mode+0x1d/0x40
[Wed Sep 22 05:14:33 2021]  ? __x64_sys_socket+0x11/0x20
[Wed Sep 22 05:14:33 2021]  ? do_syscall_64+0x69/0x80
[Wed Sep 22 05:14:33 2021]  ? asm_exc_page_fault+0x8/0x30
[Wed Sep 22 05:14:33 2021]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[Wed Sep 22 05:14:33 2021] RIP: 0033:0x7f2cc6c6d957
[Wed Sep 22 05:14:33 2021] Code: 3c 1c 48 f7 d8 4c 39 e0 77 b9 e8 24
ff ff ff 85 c0 78 be 4c 89 e0 5b 5d 41 5c c3 0f 1f 84 00 00 00 00 00
b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d e1 94 0c 00
f7 d8 64 89 01 48
[Wed Sep 22 05:14:33 2021] RSP: 002b:00007ffc52d10858 EFLAGS: 00000246
ORIG_RAX: 0000000000000010
[Wed Sep 22 05:14:33 2021] RAX: ffffffffffffffda RBX: 000055cf41ae51a0
RCX: 00007f2cc6c6d957
[Wed Sep 22 05:14:33 2021] RDX: 00007ffc52d10890 RSI: 0000000000008946
RDI: 000000000000000f
[Wed Sep 22 05:14:33 2021] RBP: 000000000000000f R08: 0000000000000000
R09: 000055cf41ae5368
[Wed Sep 22 05:14:33 2021] R10: 000055cf41ae89c4 R11: 0000000000000246
R12: 000055cf41ae5350
[Wed Sep 22 05:14:33 2021] R13: 00007ffc52d10890 R14: 000055cf41ae8960
R15: 000055cf41ae8a04
[Wed Sep 22 05:14:33 2021] ---[ end trace 2639f3b6af5e47b8 ]---
[Wed Sep 22 05:14:33 2021] ------------[ cut here ]------------
[Wed Sep 22 05:14:33 2021] Buffer overflow detected (8 < 192)!
[Wed Sep 22 05:14:33 2021] WARNING: CPU: 1 PID: 897 at
include/linux/thread_info.h:200 ethtool_rxnfc_copy_to_user+0x11/0x20
[Wed Sep 22 05:14:33 2021] CPU: 1 PID: 897 Comm: nmbd Tainted: G
 W       T 5.14.6 #3 2312a638faa2fafaa8620a89d9c5a3692fbb0bb9
[Wed Sep 22 05:14:33 2021] Hardware name: Supermicro X9SRL-F/X9SRL-F,
BIOS 3.3 11/13/2018
[Wed Sep 22 05:14:33 2021] RIP: 0010:ethtool_rxnfc_copy_to_user+0x11/0x20
[Wed Sep 22 05:14:33 2021] Code: ff eb 94 b8 f4 ff ff ff eb 8d e8 2a
f2 22 00 66 2e 0f 1f 84 00 00 00 00 00 be 08 00 00 00 48 c7 c7 18 a6
b6 a4 e8 3f b5 19 00 <0f> 0b b8 f2 ff ff ff c3 0f 1f 80 00 00 00 00 41
56 41 55 41 54 55
[Wed Sep 22 05:14:33 2021] RSP: 0018:ffffa79bc1b57b68 EFLAGS: 00010286
[Wed Sep 22 05:14:33 2021] RAX: 0000000000000000 RBX: 0000000000000000
RCX: ffffa174bfa575b8
[Wed Sep 22 05:14:33 2021] RDX: 00000000ffffffd8 RSI: 0000000000000027
RDI: ffffa174bfa575b0
[Wed Sep 22 05:14:33 2021] RBP: ffffa16585074000 R08: ffffffffa4e41aa0
R09: 0000000000000002
[Wed Sep 22 05:14:33 2021] R10: 0000000000000001 R11: ffffffffa56612b9
R12: 0000000000000000
[Wed Sep 22 05:14:33 2021] R13: 00007ffc52d108c0 R14: ffffa79bc1b57b78
R15: ffffffffa4986740
[Wed Sep 22 05:14:33 2021] FS:  00007f2cc32a8a40(0000)
GS:ffffa174bfa40000(0000) knlGS:0000000000000000
[Wed Sep 22 05:14:33 2021] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[Wed Sep 22 05:14:33 2021] CR2: 000055cf41ae91c8 CR3: 0000000116be0005
CR4: 00000000001706e0
[Wed Sep 22 05:14:33 2021] Call Trace:
[Wed Sep 22 05:14:33 2021]  ethtool_get_rxnfc+0xec/0x1b0
[Wed Sep 22 05:14:33 2021]  dev_ethtool+0xb46/0x2870
[Wed Sep 22 05:14:33 2021]  ? _copy_from_user+0x28/0x60
[Wed Sep 22 05:14:33 2021]  ? ethtool_get_sset_info+0x190/0x190
[Wed Sep 22 05:14:33 2021]  ? _copy_to_user+0x1c/0x30
[Wed Sep 22 05:14:33 2021]  ? dev_ethtool+0x154d/0x2870
[Wed Sep 22 05:14:33 2021]  ? __rtnl_unlock+0x1f/0x40
[Wed Sep 22 05:14:33 2021]  ? netdev_run_todo+0x5b/0x360
[Wed Sep 22 05:14:33 2021]  dev_ioctl+0x151/0x480
[Wed Sep 22 05:14:33 2021]  sock_ioctl+0x248/0x360
[Wed Sep 22 05:14:33 2021]  __x64_sys_ioctl+0x425/0x980
[Wed Sep 22 05:14:33 2021]  do_syscall_64+0x5c/0x80
[Wed Sep 22 05:14:33 2021]  ? syscall_exit_to_user_mode+0x1d/0x40
[Wed Sep 22 05:14:33 2021]  ? __x64_sys_socket+0x11/0x20
[Wed Sep 22 05:14:33 2021]  ? do_syscall_64+0x69/0x80
[Wed Sep 22 05:14:33 2021]  ? syscall_exit_to_user_mode+0x1d/0x40
[Wed Sep 22 05:14:33 2021]  ? __x64_sys_close+0x9/0x40
[Wed Sep 22 05:14:33 2021]  ? do_syscall_64+0x69/0x80
[Wed Sep 22 05:14:33 2021]  ? __sys_socket+0x93/0xe0
[Wed Sep 22 05:14:33 2021]  ? syscall_exit_to_user_mode+0x1d/0x40
[Wed Sep 22 05:14:33 2021]  ? __x64_sys_socket+0x11/0x20
[Wed Sep 22 05:14:33 2021]  ? do_syscall_64+0x69/0x80
[Wed Sep 22 05:14:33 2021]  ? asm_exc_page_fault+0x8/0x30
[Wed Sep 22 05:14:33 2021]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[Wed Sep 22 05:14:33 2021] RIP: 0033:0x7f2cc6c6d957
[Wed Sep 22 05:14:33 2021] Code: 3c 1c 48 f7 d8 4c 39 e0 77 b9 e8 24
ff ff ff 85 c0 78 be 4c 89 e0 5b 5d 41 5c c3 0f 1f 84 00 00 00 00 00
b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d e1 94 0c 00
f7 d8 64 89 01 48
[Wed Sep 22 05:14:33 2021] RSP: 002b:00007ffc52d10858 EFLAGS: 00000246
ORIG_RAX: 0000000000000010
[Wed Sep 22 05:14:33 2021] RAX: ffffffffffffffda RBX: 000055cf41ae51a0
RCX: 00007f2cc6c6d957
[Wed Sep 22 05:14:33 2021] RDX: 00007ffc52d10890 RSI: 0000000000008946
RDI: 000000000000000f
[Wed Sep 22 05:14:33 2021] RBP: 000000000000000f R08: 0000000000000000
R09: 000055cf41ae5518
[Wed Sep 22 05:14:33 2021] R10: 0000000000000015 R11: 0000000000000246
R12: 000055cf41ae5500
[Wed Sep 22 05:14:33 2021] R13: 00007ffc52d10890 R14: 000055cf41ae8a18
R15: 000055cf41ae8abc
[Wed Sep 22 05:14:33 2021] ---[ end trace 2639f3b6af5e47b9 ]---
[Wed Sep 22 05:14:33 2021] ------------[ cut here ]------------
[Wed Sep 22 05:14:33 2021] Buffer overflow detected (8 < 192)!
[Wed Sep 22 05:14:33 2021] WARNING: CPU: 1 PID: 897 at
include/linux/thread_info.h:200 ethtool_rxnfc_copy_to_user+0x11/0x20
[Wed Sep 22 05:14:33 2021] CPU: 1 PID: 897 Comm: nmbd Tainted: G
 W       T 5.14.6 #3 2312a638faa2fafaa8620a89d9c5a3692fbb0bb9
[Wed Sep 22 05:14:33 2021] Hardware name: Supermicro X9SRL-F/X9SRL-F,
BIOS 3.3 11/13/2018
[Wed Sep 22 05:14:33 2021] RIP: 0010:ethtool_rxnfc_copy_to_user+0x11/0x20
[Wed Sep 22 05:14:33 2021] Code: ff eb 94 b8 f4 ff ff ff eb 8d e8 2a
f2 22 00 66 2e 0f 1f 84 00 00 00 00 00 be 08 00 00 00 48 c7 c7 18 a6
b6 a4 e8 3f b5 19 00 <0f> 0b b8 f2 ff ff ff c3 0f 1f 80 00 00 00 00 41
56 41 55 41 54 55
[Wed Sep 22 05:14:33 2021] RSP: 0018:ffffa79bc1b57c08 EFLAGS: 00010286
[Wed Sep 22 05:14:33 2021] RAX: 0000000000000000 RBX: 0000000000000000
RCX: ffffa174bfa575b8
[Wed Sep 22 05:14:33 2021] RDX: 00000000ffffffd8 RSI: 0000000000000027
RDI: ffffa174bfa575b0
[Wed Sep 22 05:14:33 2021] RBP: ffffa16585074000 R08: ffffffffa4e41aa0
R09: 0000000000000002
[Wed Sep 22 05:14:33 2021] R10: 0000000000000001 R11: ffffffffa5661f21
R12: 0000000000000000
[Wed Sep 22 05:14:33 2021] R13: 00007ffc52d108c0 R14: ffffa79bc1b57c18
R15: ffffffffa4986740
[Wed Sep 22 05:14:33 2021] FS:  00007f2cc32a8a40(0000)
GS:ffffa174bfa40000(0000) knlGS:0000000000000000
[Wed Sep 22 05:14:33 2021] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[Wed Sep 22 05:14:33 2021] CR2: 000055cf41ae91c8 CR3: 0000000116be0005
CR4: 00000000001706e0
[Wed Sep 22 05:14:33 2021] Call Trace:
[Wed Sep 22 05:14:33 2021]  ethtool_get_rxnfc+0xec/0x1b0
[Wed Sep 22 05:14:33 2021]  dev_ethtool+0xb46/0x2870
[Wed Sep 22 05:14:33 2021]  ? __alloc_file+0x94/0x100
[Wed Sep 22 05:14:33 2021]  ? kmem_cache_alloc+0x232/0x350
[Wed Sep 22 05:14:33 2021]  ? alloc_empty_file+0x5e/0xb0
[Wed Sep 22 05:14:33 2021]  ? alloc_file+0x90/0x110
[Wed Sep 22 05:14:33 2021]  ? alloc_file_pseudo+0x9e/0x100
[Wed Sep 22 05:14:33 2021]  dev_ioctl+0x151/0x480
[Wed Sep 22 05:14:33 2021]  sock_ioctl+0x248/0x360
[Wed Sep 22 05:14:33 2021]  __x64_sys_ioctl+0x425/0x980
[Wed Sep 22 05:14:33 2021]  do_syscall_64+0x5c/0x80
[Wed Sep 22 05:14:33 2021]  ? asm_exc_page_fault+0x8/0x30
[Wed Sep 22 05:14:33 2021]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[Wed Sep 22 05:14:33 2021] RIP: 0033:0x7f2cc6c6d957
[Wed Sep 22 05:14:33 2021] Code: 3c 1c 48 f7 d8 4c 39 e0 77 b9 e8 24
ff ff ff 85 c0 78 be 4c 89 e0 5b 5d 41 5c c3 0f 1f 84 00 00 00 00 00
b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d e1 94 0c 00
f7 d8 64 89 01 48
[Wed Sep 22 05:14:33 2021] RSP: 002b:00007ffc52d10858 EFLAGS: 00000246
ORIG_RAX: 0000000000000010
[Wed Sep 22 05:14:33 2021] RAX: ffffffffffffffda RBX: 000055cf41ae51a0
RCX: 00007f2cc6c6d957
[Wed Sep 22 05:14:33 2021] RDX: 00007ffc52d10890 RSI: 0000000000008946
RDI: 000000000000000f
[Wed Sep 22 05:14:33 2021] RBP: 000000000000000f R08: 0000000000000000
R09: 000055cf41ae5a28
[Wed Sep 22 05:14:33 2021] R10: 000055cf41ae8ca4 R11: 0000000000000246
R12: 000055cf41ae5a10
[Wed Sep 22 05:14:33 2021] R13: 00007ffc52d10890 R14: 000055cf41ae8c40
R15: 000055cf41ae87dc
[Wed Sep 22 05:14:33 2021] ---[ end trace 2639f3b6af5e47ba ]---
[Wed Sep 22 05:14:33 2021] nf_conntrack: default automatic helper
assignment has been turned off for security reasons and CT-based
firewall rule not found. Use the iptables CT target to attach helpers
instead.
[Wed Sep 22 05:14:33 2021] ------------[ cut here ]------------
[Wed Sep 22 05:14:33 2021] Buffer overflow detected (8 < 192)!
[Wed Sep 22 05:14:33 2021] WARNING: CPU: 1 PID: 897 at
include/linux/thread_info.h:200 ethtool_rxnfc_copy_to_user+0x11/0x20
[Wed Sep 22 05:14:33 2021] CPU: 1 PID: 897 Comm: nmbd Tainted: G
 W       T 5.14.6 #3 2312a638faa2fafaa8620a89d9c5a3692fbb0bb9
[Wed Sep 22 05:14:33 2021] Hardware name: Supermicro X9SRL-F/X9SRL-F,
BIOS 3.3 11/13/2018
[Wed Sep 22 05:14:33 2021] RIP: 0010:ethtool_rxnfc_copy_to_user+0x11/0x20
[Wed Sep 22 05:14:33 2021] Code: ff eb 94 b8 f4 ff ff ff eb 8d e8 2a
f2 22 00 66 2e 0f 1f 84 00 00 00 00 00 be 08 00 00 00 48 c7 c7 18 a6
b6 a4 e8 3f b5 19 00 <0f> 0b b8 f2 ff ff ff c3 0f 1f 80 00 00 00 00 41
56 41 55 41 54 55
[Wed Sep 22 05:14:33 2021] RSP: 0018:ffffa79bc1b57bc0 EFLAGS: 00010282
[Wed Sep 22 05:14:33 2021] RAX: 0000000000000000 RBX: 0000000000000000
RCX: ffffa174bfa575b8
[Wed Sep 22 05:14:33 2021] RDX: 00000000ffffffd8 RSI: 0000000000000027
RDI: ffffa174bfa575b0
[Wed Sep 22 05:14:33 2021] RBP: ffffa16585378000 R08: ffffffffa4e41aa0
R09: 0000000000000002
[Wed Sep 22 05:14:33 2021] R10: 0000000000000001 R11: ffffffffa5662a89
R12: 0000000000000000
[Wed Sep 22 05:14:33 2021] R13: 00007ffc52d108c0 R14: ffffa79bc1b57bd0
R15: ffffffffa4984b00
[Wed Sep 22 05:14:33 2021] FS:  00007f2cc32a8a40(0000)
GS:ffffa174bfa40000(0000) knlGS:0000000000000000
[Wed Sep 22 05:14:33 2021] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[Wed Sep 22 05:14:33 2021] CR2: 000055cf41af0e98 CR3: 0000000116be0005
CR4: 00000000001706e0
[Wed Sep 22 05:14:33 2021] Call Trace:
[Wed Sep 22 05:14:33 2021]  ethtool_get_rxnfc+0xec/0x1b0
[Wed Sep 22 05:14:33 2021]  dev_ethtool+0xb46/0x2870
[Wed Sep 22 05:14:33 2021]  ? dev_ethtool+0x1b6/0x2870
[Wed Sep 22 05:14:33 2021]  ? __alloc_file+0x1e/0x100
[Wed Sep 22 05:14:33 2021]  ? kmem_cache_alloc+0x232/0x350
[Wed Sep 22 05:14:33 2021]  dev_ioctl+0x151/0x480
[Wed Sep 22 05:14:33 2021]  sock_ioctl+0x248/0x360
[Wed Sep 22 05:14:33 2021]  ? alloc_file_pseudo+0x9e/0x100
[Wed Sep 22 05:14:33 2021]  __x64_sys_ioctl+0x425/0x980
[Wed Sep 22 05:14:33 2021]  ? __sys_socket+0x93/0xe0
[Wed Sep 22 05:14:33 2021]  ? syscall_exit_to_user_mode+0x1d/0x40
[Wed Sep 22 05:14:33 2021]  do_syscall_64+0x5c/0x80
[Wed Sep 22 05:14:33 2021]  ? syscall_exit_to_user_mode+0x1d/0x40
[Wed Sep 22 05:14:33 2021]  ? __x64_sys_close+0x9/0x40
[Wed Sep 22 05:14:33 2021]  ? do_syscall_64+0x69/0x80
[Wed Sep 22 05:14:33 2021]  ? syscall_exit_to_user_mode+0x1d/0x40
[Wed Sep 22 05:14:33 2021]  ? asm_exc_page_fault+0x8/0x30
[Wed Sep 22 05:14:33 2021]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[Wed Sep 22 05:14:33 2021] RIP: 0033:0x7f2cc6c6d957
[Wed Sep 22 05:14:33 2021] Code: 3c 1c 48 f7 d8 4c 39 e0 77 b9 e8 24
ff ff ff 85 c0 78 be 4c 89 e0 5b 5d 41 5c c3 0f 1f 84 00 00 00 00 00
b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d e1 94 0c 00
f7 d8 64 89 01 48
[Wed Sep 22 05:14:33 2021] RSP: 002b:00007ffc52d10858 EFLAGS: 00000246
ORIG_RAX: 0000000000000010
[Wed Sep 22 05:14:33 2021] RAX: ffffffffffffffda RBX: 000055cf41aece70
RCX: 00007f2cc6c6d957
[Wed Sep 22 05:14:33 2021] RDX: 00007ffc52d10890 RSI: 0000000000008946
RDI: 0000000000000018
[Wed Sep 22 05:14:33 2021] RBP: 0000000000000018 R08: 0000000000000000
R09: 000055cf41aed038
[Wed Sep 22 05:14:33 2021] R10: 000055cf41af0694 R11: 0000000000000246
R12: 000055cf41aed020
[Wed Sep 22 05:14:33 2021] R13: 00007ffc52d10890 R14: 000055cf41af0630
R15: 000055cf41af06d4
[Wed Sep 22 05:14:33 2021] ---[ end trace 2639f3b6af5e47bb ]---
[Wed Sep 22 05:14:33 2021] ------------[ cut here ]------------
[Wed Sep 22 05:14:33 2021] Buffer overflow detected (8 < 192)!
[Wed Sep 22 05:14:33 2021] WARNING: CPU: 1 PID: 897 at
include/linux/thread_info.h:200 ethtool_rxnfc_copy_to_user+0x11/0x20
[Wed Sep 22 05:14:33 2021] CPU: 1 PID: 897 Comm: nmbd Tainted: G
 W       T 5.14.6 #3 2312a638faa2fafaa8620a89d9c5a3692fbb0bb9
[Wed Sep 22 05:14:33 2021] Hardware name: Supermicro X9SRL-F/X9SRL-F,
BIOS 3.3 11/13/2018
[Wed Sep 22 05:14:33 2021] RIP: 0010:ethtool_rxnfc_copy_to_user+0x11/0x20
[Wed Sep 22 05:14:33 2021] Code: ff eb 94 b8 f4 ff ff ff eb 8d e8 2a
f2 22 00 66 2e 0f 1f 84 00 00 00 00 00 be 08 00 00 00 48 c7 c7 18 a6
b6 a4 e8 3f b5 19 00 <0f> 0b b8 f2 ff ff ff c3 0f 1f 80 00 00 00 00 41
56 41 55 41 54 55
[Wed Sep 22 05:14:33 2021] RSP: 0018:ffffa79bc1b57b58 EFLAGS: 00010282
[Wed Sep 22 05:14:33 2021] RAX: 0000000000000000 RBX: 0000000000000000
RCX: ffffa174bfa575b8
[Wed Sep 22 05:14:33 2021] RDX: 00000000ffffffd8 RSI: 0000000000000027
RDI: ffffa174bfa575b0
[Wed Sep 22 05:14:33 2021] RBP: ffffa16585074000 R08: ffffffffa4e41aa0
R09: 0000000000000002
[Wed Sep 22 05:14:33 2021] R10: 0000000000000001 R11: ffffffffa5663609
R12: 0000000000000000
[Wed Sep 22 05:14:33 2021] R13: 00007ffc52d108c0 R14: ffffa79bc1b57b68
R15: ffffffffa4986740
[Wed Sep 22 05:14:33 2021] FS:  00007f2cc32a8a40(0000)
GS:ffffa174bfa40000(0000) knlGS:0000000000000000
[Wed Sep 22 05:14:33 2021] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[Wed Sep 22 05:14:33 2021] CR2: 000055cf41af0e98 CR3: 0000000116be0005
CR4: 00000000001706e0
[Wed Sep 22 05:14:33 2021] Call Trace:
[Wed Sep 22 05:14:33 2021]  ethtool_get_rxnfc+0xec/0x1b0
[Wed Sep 22 05:14:33 2021]  dev_ethtool+0xb46/0x2870
[Wed Sep 22 05:14:33 2021]  ? __rtnl_unlock+0x1f/0x40
[Wed Sep 22 05:14:33 2021]  ? netdev_run_todo+0x5b/0x360
[Wed Sep 22 05:14:33 2021]  ? unix_gc+0x232/0x460
[Wed Sep 22 05:14:33 2021]  ? dev_ioctl+0x159/0x480
[Wed Sep 22 05:14:33 2021]  dev_ioctl+0x151/0x480
[Wed Sep 22 05:14:33 2021]  sock_ioctl+0x248/0x360
[Wed Sep 22 05:14:33 2021]  __x64_sys_ioctl+0x425/0x980
[Wed Sep 22 05:14:33 2021]  ? __alloc_file+0x94/0x100
[Wed Sep 22 05:14:33 2021]  ? kmem_cache_alloc+0x232/0x350
[Wed Sep 22 05:14:33 2021]  ? alloc_empty_file+0x5e/0xb0
[Wed Sep 22 05:14:33 2021]  do_syscall_64+0x5c/0x80
[Wed Sep 22 05:14:33 2021]  ? sock_alloc_file+0x53/0x90
[Wed Sep 22 05:14:33 2021]  ? __sys_socket+0x93/0xe0
[Wed Sep 22 05:14:33 2021]  ? exit_to_user_mode_prepare+0xd7/0x110
[Wed Sep 22 05:14:33 2021]  ? syscall_exit_to_user_mode+0x1d/0x40
[Wed Sep 22 05:14:33 2021]  ? __x64_sys_socket+0x11/0x20
[Wed Sep 22 05:14:33 2021]  ? do_syscall_64+0x69/0x80
[Wed Sep 22 05:14:33 2021]  ? asm_exc_page_fault+0x8/0x30
[Wed Sep 22 05:14:33 2021]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[Wed Sep 22 05:14:33 2021] RIP: 0033:0x7f2cc6c6d957
[Wed Sep 22 05:14:33 2021] Code: 3c 1c 48 f7 d8 4c 39 e0 77 b9 e8 24
ff ff ff 85 c0 78 be 4c 89 e0 5b 5d 41 5c c3 0f 1f 84 00 00 00 00 00
b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d e1 94 0c 00
f7 d8 64 89 01 48
[Wed Sep 22 05:14:33 2021] RSP: 002b:00007ffc52d10858 EFLAGS: 00000246
ORIG_RAX: 0000000000000010
[Wed Sep 22 05:14:33 2021] RAX: ffffffffffffffda RBX: 000055cf41aece70
RCX: 00007f2cc6c6d957
[Wed Sep 22 05:14:33 2021] RDX: 00007ffc52d10890 RSI: 0000000000008946
RDI: 0000000000000018
[Wed Sep 22 05:14:33 2021] RBP: 0000000000000018 R08: 0000000000000000
R09: 000055cf41aed1e8
[Wed Sep 22 05:14:33 2021] R10: 000055cf41af074c R11: 0000000000000246
R12: 000055cf41aed1d0
[Wed Sep 22 05:14:33 2021] R13: 00007ffc52d10890 R14: 000055cf41af06e8
R15: 000055cf41af078c
[Wed Sep 22 05:14:33 2021] ---[ end trace 2639f3b6af5e47bc ]---
[Wed Sep 22 05:14:33 2021] ------------[ cut here ]------------
[Wed Sep 22 05:14:33 2021] Buffer overflow detected (8 < 192)!
[Wed Sep 22 05:14:33 2021] WARNING: CPU: 1 PID: 897 at
include/linux/thread_info.h:200 ethtool_rxnfc_copy_to_user+0x11/0x20
[Wed Sep 22 05:14:33 2021] CPU: 1 PID: 897 Comm: nmbd Tainted: G
 W       T 5.14.6 #3 2312a638faa2fafaa8620a89d9c5a3692fbb0bb9
[Wed Sep 22 05:14:33 2021] Hardware name: Supermicro X9SRL-F/X9SRL-F,
BIOS 3.3 11/13/2018
[Wed Sep 22 05:14:33 2021] RIP: 0010:ethtool_rxnfc_copy_to_user+0x11/0x20
[Wed Sep 22 05:14:33 2021] Code: ff eb 94 b8 f4 ff ff ff eb 8d e8 2a
f2 22 00 66 2e 0f 1f 84 00 00 00 00 00 be 08 00 00 00 48 c7 c7 18 a6
b6 a4 e8 3f b5 19 00 <0f> 0b b8 f2 ff ff ff c3 0f 1f 80 00 00 00 00 41
56 41 55 41 54 55
[Wed Sep 22 05:14:33 2021] RSP: 0018:ffffa79bc1b57b60 EFLAGS: 00010286
[Wed Sep 22 05:14:33 2021] RAX: 0000000000000000 RBX: 0000000000000000
RCX: ffffa174bfa575b8
[Wed Sep 22 05:14:33 2021] RDX: 00000000ffffffd8 RSI: 0000000000000027
RDI: ffffa174bfa575b0
[Wed Sep 22 05:14:33 2021] RBP: ffffa16585074000 R08: ffffffffa4e41aa0
R09: 0000000000000002
[Wed Sep 22 05:14:33 2021] R10: 0000000000000001 R11: ffffffffa56641f1
R12: 0000000000000000
[Wed Sep 22 05:14:33 2021] R13: 00007ffc52d108c0 R14: ffffa79bc1b57b70
R15: ffffffffa4986740
[Wed Sep 22 05:14:33 2021] FS:  00007f2cc32a8a40(0000)
GS:ffffa174bfa40000(0000) knlGS:0000000000000000
[Wed Sep 22 05:14:33 2021] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[Wed Sep 22 05:14:33 2021] CR2: 000055cf41af0e98 CR3: 0000000116be0005
CR4: 00000000001706e0
[Wed Sep 22 05:14:33 2021] Call Trace:
[Wed Sep 22 05:14:33 2021]  ethtool_get_rxnfc+0xec/0x1b0
[Wed Sep 22 05:14:33 2021]  dev_ethtool+0xb46/0x2870
[Wed Sep 22 05:14:33 2021]  ? _copy_to_user+0x1c/0x30
[Wed Sep 22 05:14:33 2021]  ? dev_ethtool+0x154d/0x2870
[Wed Sep 22 05:14:33 2021]  ? kmem_cache_alloc+0x232/0x350
[Wed Sep 22 05:14:33 2021]  ? __rtnl_unlock+0x1f/0x40
[Wed Sep 22 05:14:33 2021]  ? netdev_run_todo+0x5b/0x360
[Wed Sep 22 05:14:33 2021]  dev_ioctl+0x151/0x480
[Wed Sep 22 05:14:33 2021]  sock_ioctl+0x248/0x360
[Wed Sep 22 05:14:33 2021]  __x64_sys_ioctl+0x425/0x980
[Wed Sep 22 05:14:33 2021]  ? alloc_file_pseudo+0x9e/0x100
[Wed Sep 22 05:14:33 2021]  do_syscall_64+0x5c/0x80
[Wed Sep 22 05:14:33 2021]  ? __sys_socket+0x93/0xe0
[Wed Sep 22 05:14:33 2021]  ? syscall_exit_to_user_mode+0x1d/0x40
[Wed Sep 22 05:14:33 2021]  ? __x64_sys_socket+0x11/0x20
[Wed Sep 22 05:14:33 2021]  ? do_syscall_64+0x69/0x80
[Wed Sep 22 05:14:33 2021]  ? __sys_socket+0x93/0xe0
[Wed Sep 22 05:14:33 2021]  ? do_syscall_64+0x69/0x80
[Wed Sep 22 05:14:33 2021]  ? syscall_exit_to_user_mode+0x1d/0x40
[Wed Sep 22 05:14:33 2021]  ? __x64_sys_socket+0x11/0x20
[Wed Sep 22 05:14:33 2021]  ? do_syscall_64+0x69/0x80
[Wed Sep 22 05:14:33 2021]  ? asm_exc_page_fault+0x8/0x30
[Wed Sep 22 05:14:33 2021]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[Wed Sep 22 05:14:33 2021] RIP: 0033:0x7f2cc6c6d957
[Wed Sep 22 05:14:33 2021] Code: 3c 1c 48 f7 d8 4c 39 e0 77 b9 e8 24
ff ff ff 85 c0 78 be 4c 89 e0 5b 5d 41 5c c3 0f 1f 84 00 00 00 00 00
b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d e1 94 0c 00
f7 d8 64 89 01 48
[Wed Sep 22 05:14:33 2021] RSP: 002b:00007ffc52d10858 EFLAGS: 00000246
ORIG_RAX: 0000000000000010
[Wed Sep 22 05:14:33 2021] RAX: ffffffffffffffda RBX: 000055cf41aece70
RCX: 00007f2cc6c6d957
[Wed Sep 22 05:14:33 2021] RDX: 00007ffc52d10890 RSI: 0000000000008946
RDI: 0000000000000018
[Wed Sep 22 05:14:33 2021] RBP: 0000000000000018 R08: 0000000000000000
R09: 000055cf41aed6f8
[Wed Sep 22 05:14:33 2021] R10: 0000000000000015 R11: 0000000000000246
R12: 000055cf41aed6e0
[Wed Sep 22 05:14:33 2021] R13: 00007ffc52d10890 R14: 000055cf41af0910
R15: 000055cf41af04ac
[Wed Sep 22 05:14:33 2021] ---[ end trace 2639f3b6af5e47bd ]---
[Wed Sep 22 05:14:36 2021] igb 0000:08:00.0 enp8s0f3: igb: enp8s0f3
NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
[Wed Sep 22 05:14:37 2021] igb 0000:08:00.2 enp8s0f1: igb: enp8s0f1
NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
[Wed Sep 22 05:14:37 2021] IPv6: ADDRCONF(NETDEV_CHANGE): enp8s0f3:
link becomes ready
[Wed Sep 22 05:14:37 2021] IPv6: ADDRCONF(NETDEV_CHANGE): enp8s0f1:
link becomes ready
[Wed Sep 22 05:14:38 2021] ------------[ cut here ]------------
[Wed Sep 22 05:14:38 2021] Buffer overflow detected (8 < 192)!
[Wed Sep 22 05:14:38 2021] WARNING: CPU: 4 PID: 1174 at
include/linux/thread_info.h:200 ethtool_rxnfc_copy_to_user+0x11/0x20
[Wed Sep 22 05:14:38 2021] CPU: 4 PID: 1174 Comm: smbd Tainted: G
  W       T 5.14.6 #3 2312a638faa2fafaa8620a89d9c5a3692fbb0bb9
[Wed Sep 22 05:14:38 2021] Hardware name: Supermicro X9SRL-F/X9SRL-F,
BIOS 3.3 11/13/2018
[Wed Sep 22 05:14:38 2021] RIP: 0010:ethtool_rxnfc_copy_to_user+0x11/0x20
[Wed Sep 22 05:14:38 2021] Code: ff eb 94 b8 f4 ff ff ff eb 8d e8 2a
f2 22 00 66 2e 0f 1f 84 00 00 00 00 00 be 08 00 00 00 48 c7 c7 18 a6
b6 a4 e8 3f b5 19 00 <0f> 0b b8 f2 ff ff ff c3 0f 1f 80 00 00 00 00 41
56 41 55 41 54 55
[Wed Sep 22 05:14:38 2021] RSP: 0018:ffffa79bc1d0fc00 EFLAGS: 00010286
[Wed Sep 22 05:14:38 2021] RAX: 0000000000000000 RBX: 0000000000000000
RCX: ffffa174bfb175b8syslog
[Wed Sep 22 05:14:38 2021] RDX: 00000000ffffffd8 RSI: 0000000000000027
RDI: ffffa174bfb175b0
[Wed Sep 22 05:14:38 2021] RBP: ffffa16585378000 R08: ffffffffa4e41aa0
R09: 0000000000000002
[Wed Sep 22 05:14:38 2021] R10: 0000000000000001 R11: ffffffffa5664fa1
R12: 0000000000000000
[Wed Sep 22 05:14:38 2021] R13: 00007ffda8056cf0 R14: ffffa79bc1d0fc10
R15: ffffffffa4984b00
[Wed Sep 22 05:14:38 2021] FS:  00007ff352c3ca40(0000)
GS:ffffa174bfb00000(0000) knlGS:0000000000000000
[Wed Sep 22 05:14:38 2021] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[Wed Sep 22 05:14:38 2021] CR2: 00005644df1cad98 CR3: 0000000104c06003
CR4: 00000000001706e0
[Wed Sep 22 05:14:38 2021] Call Trace:
[Wed Sep 22 05:14:38 2021]  ethtool_get_rxnfc+0xec/0x1b0
[Wed Sep 22 05:14:38 2021]  dev_ethtool+0xb46/0x2870
[Wed Sep 22 05:14:38 2021]  ? kmem_cache_alloc+0x232/0x350
[Wed Sep 22 05:14:38 2021]  ? alloc_empty_file+0x5e/0xb0
[Wed Sep 22 05:14:38 2021]  ? alloc_file+0x90/0x110
[Wed Sep 22 05:14:38 2021]  ? alloc_file_pseudo+0x9e/0x100
[Wed Sep 22 05:14:38 2021]  dev_ioctl+0x151/0x480
[Wed Sep 22 05:14:38 2021]  sock_ioctl+0x248/0x360
[Wed Sep 22 05:14:38 2021]  ? syscall_exit_to_user_mode+0x1d/0x40
[Wed Sep 22 05:14:38 2021]  __x64_sys_ioctl+0x425/0x980
[Wed Sep 22 05:14:38 2021]  ? syscall_exit_to_user_mode+0x1d/0x40
[Wed Sep 22 05:14:38 2021]  ? __x64_sys_close+0x9/0x40
[Wed Sep 22 05:14:38 2021]  ? do_syscall_64+0x69/0x80
[Wed Sep 22 05:14:38 2021]  ? __x64_sys_socket+0x11/0x20
[Wed Sep 22 05:14:38 2021]  ? do_syscall_64+0x69/0x80
[Wed Sep 22 05:14:38 2021]  do_syscall_64+0x5c/0x80
[Wed Sep 22 05:14:38 2021]  ? asm_exc_page_fault+0x8/0x30
[Wed Sep 22 05:14:38 2021]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[Wed Sep 22 05:14:38 2021] RIP: 0033:0x7ff356da9957
[Wed Sep 22 05:14:38 2021] Code: 3c 1c 48 f7 d8 4c 39 e0 77 b9 e8 24
ff ff ff 85 c0 78 be 4c 89 e0 5b 5d 41 5c c3 0f 1f 84 00 00 00 00 00
b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d e1 94 0c 00
f7 d8 64 89 01 48
[Wed Sep 22 05:14:38 2021] RSP: 002b:00007ffda8056c88 EFLAGS: 00000246
ORIG_RAX: 0000000000000010
[Wed Sep 22 05:14:38 2021] RAX: ffffffffffffffda RBX: 00005644df1c7180
RCX: 00007ff356da9957
[Wed Sep 22 05:14:38 2021] RDX: 00007ffda8056cc0 RSI: 0000000000008946
RDI: 0000000000000004
[Wed Sep 22 05:14:38 2021] RBP: 0000000000000004 R08: 0000000000000000
R09: 00005644df1c7348
[Wed Sep 22 05:14:38 2021] R10: 000000000000000d R11: 0000000000000246
R12: 00005644df1c7330
[Wed Sep 22 05:14:38 2021] R13: 00007ffda8056cc0 R14: 00005644df1ca3c0
R15: 00005644df1ca464
[Wed Sep 22 05:14:38 2021] ---[ end trace 2639f3b6af5e47be ]---
[Wed Sep 22 05:14:38 2021] ------------[ cut here ]------------
[Wed Sep 22 05:14:38 2021] Buffer overflow detected (8 < 192)!
[Wed Sep 22 05:14:38 2021] WARNING: CPU: 4 PID: 1174 at
include/linux/thread_info.h:200 ethtool_rxnfc_copy_to_user+0x11/0x20
[Wed Sep 22 05:14:38 2021] CPU: 4 PID: 1174 Comm: smbd Tainted: G
  W       T 5.14.6 #3 2312a638faa2fafaa8620a89d9c5a3692fbb0bb9
[Wed Sep 22 05:14:38 2021] Hardware name: Supermicro X9SRL-F/X9SRL-F,
BIOS 3.3 11/13/2018
[Wed Sep 22 05:14:38 2021] RIP: 0010:ethtool_rxnfc_copy_to_user+0x11/0x20
[Wed Sep 22 05:14:38 2021] Code: ff eb 94 b8 f4 ff ff ff eb 8d e8 2a
f2 22 00 66 2e 0f 1f 84 00 00 00 00 00 be 08 00 00 00 48 c7 c7 18 a6
b6 a4 e8 3f b5 19 00 <0f> 0b b8 f2 ff ff ff c3 0f 1f 80 00 00 00 00 41
56 41 55 41 54 55
[Wed Sep 22 05:14:38 2021] RSP: 0018:ffffa79bc1d0fb48 EFLAGS: 00010286
[Wed Sep 22 05:14:38 2021] RAX: 0000000000000000 RBX: 0000000000000000
RCX: ffffa174bfb175b8
[Wed Sep 22 05:14:38 2021] RDX: 00000000ffffffd8 RSI: 0000000000000027
RDI: ffffa174bfb175b0
[Wed Sep 22 05:14:38 2021] RBP: ffffa16585074000 R08: ffffffffa4e41aa0
R09: 0000000000000002
[Wed Sep 22 05:14:38 2021] R10: 0000000000000001 R11: ffffffffa5665b19
R12: 0000000000000000
[Wed Sep 22 05:14:38 2021] R13: 00007ffda8056cf0 R14: ffffa79bc1d0fb58
R15: ffffffffa4986740
[Wed Sep 22 05:14:38 2021] FS:  00007ff352c3ca40(0000)
GS:ffffa174bfb00000(0000) knlGS:0000000000000000
[Wed Sep 22 05:14:38 2021] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[Wed Sep 22 05:14:38 2021] CR2: 00005644df1cad98 CR3: 0000000104c06003
CR4: 00000000001706e0
[Wed Sep 22 05:14:38 2021] Call Trace:
[Wed Sep 22 05:14:38 2021]  ethtool_get_rxnfc+0xec/0x1b0
[Wed Sep 22 05:14:38 2021]  dev_ethtool+0xb46/0x2870
[Wed Sep 22 05:14:38 2021]  ? __rtnl_unlock+0x1f/0x40
[Wed Sep 22 05:14:38 2021]  ? netdev_run_todo+0x5b/0x360
[Wed Sep 22 05:14:38 2021]  dev_ioctl+0x151/0x480
[Wed Sep 22 05:14:38 2021]  sock_ioctl+0x248/0x360
[Wed Sep 22 05:14:38 2021]  __x64_sys_ioctl+0x425/0x980
[Wed Sep 22 05:14:38 2021]  ? alloc_file+0x90/0x110
[Wed Sep 22 05:14:38 2021]  ? alloc_file_pseudo+0x9e/0x100
[Wed Sep 22 05:14:38 2021]  do_syscall_64+0x5c/0x80
[Wed Sep 22 05:14:38 2021]  ? sock_alloc_file+0x53/0x90
[Wed Sep 22 05:14:38 2021]  ? __sys_socket+0x93/0xe0
[Wed Sep 22 05:14:38 2021]  ? syscall_exit_to_user_mode+0x1d/0x40
[Wed Sep 22 05:14:38 2021]  ? __x64_sys_socket+0x11/0x20
[Wed Sep 22 05:14:38 2021]  ? do_syscall_64+0x69/0x80
[Wed Sep 22 05:14:38 2021]  ? exit_to_user_mode_prepare+0xd7/0x110
[Wed Sep 22 05:14:38 2021]  ? syscall_exit_to_user_mode+0x1d/0x40
[Wed Sep 22 05:14:38 2021]  ? __x64_sys_close+0x9/0x40
[Wed Sep 22 05:14:38 2021]  ? do_syscall_64+0x69/0x80
[Wed Sep 22 05:14:38 2021]  ? asm_exc_page_fault+0x8/0x30
[Wed Sep 22 05:14:38 2021]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[Wed Sep 22 05:14:38 2021] RIP: 0033:0x7ff356da9957
[Wed Sep 22 05:14:38 2021] Code: 3c 1c 48 f7 d8 4c 39 e0 77 b9 e8 24
ff ff ff 85 c0 78 be 4c 89 e0 5b 5d 41 5c c3 0f 1f 84 00 00 00 00 00
b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d e1 94 0c 00
f7 d8 64 89 01 48
[Wed Sep 22 05:14:38 2021] RSP: 002b:00007ffda8056c88 EFLAGS: 00000246
ORIG_RAX: 0000000000000010
[Wed Sep 22 05:14:38 2021] RAX: ffffffffffffffda RBX: 00005644df1c7180
RCX: 00007ff356da9957
[Wed Sep 22 05:14:38 2021] RDX: 00007ffda8056cc0 RSI: 0000000000008946
RDI: 0000000000000004
[Wed Sep 22 05:14:38 2021] RBP: 0000000000000004 R08: 0000000000000000
R09: 00005644df1c74f8
[Wed Sep 22 05:14:38 2021] R10: 00005644df1ca4dc R11: 0000000000000246
R12: 00005644df1c74e0
[Wed Sep 22 05:14:38 2021] R13: 00007ffda8056cc0 R14: 00005644df1ca478
R15: 00005644df1ca51c
[Wed Sep 22 05:14:38 2021] ---[ end trace 2639f3b6af5e47bf ]---
[Wed Sep 22 05:14:38 2021] ------------[ cut here ]------------
[Wed Sep 22 05:14:38 2021] Buffer overflow detected (8 < 192)!
[Wed Sep 22 05:14:38 2021] WARNING: CPU: 4 PID: 1174 at
include/linux/thread_info.h:200 ethtool_rxnfc_copy_to_user+0x11/0x20
[Wed Sep 22 05:14:38 2021] CPU: 4 PID: 1174 Comm: smbd Tainted: G
  W       T 5.14.6 #3 2312a638faa2fafaa8620a89d9c5a3692fbb0bb9
[Wed Sep 22 05:14:38 2021] Hardware name: Supermicro X9SRL-F/X9SRL-F,
BIOS 3.3 11/13/2018
[Wed Sep 22 05:14:38 2021] RIP: 0010:ethtool_rxnfc_copy_to_user+0x11/0x20
[Wed Sep 22 05:14:38 2021] Code: ff eb 94 b8 f4 ff ff ff eb 8d e8 2a
f2 22 00 66 2e 0f 1f 84 00 00 00 00 00 be 08 00 00 00 48 c7 c7 18 a6
b6 a4 e8 3f b5 19 00 <0f> 0b b8 f2 ff ff ff c3 0f 1f 80 00 00 00 00 41
56 41 55 41 54 55
[Wed Sep 22 05:14:38 2021] RSP: 0018:ffffa79bc1d0fb58 EFLAGS: 00010282
[Wed Sep 22 05:14:38 2021] RAX: 0000000000000000 RBX: 0000000000000000
RCX: ffffa174bfb175b8
[Wed Sep 22 05:14:38 2021] RDX: 00000000ffffffd8 RSI: 0000000000000027
RDI: ffffa174bfb175b0
[Wed Sep 22 05:14:38 2021] RBP: ffffa16585074000 R08: ffffffffa4e41aa0
R09: 0000000000000002
[Wed Sep 22 05:14:38 2021] R10: 0000000000000001 R11: ffffffffa5666711
R12: 0000000000000000
[Wed Sep 22 05:14:38 2021] R13: 00007ffda8056cf0 R14: ffffa79bc1d0fb68
R15: ffffffffa4986740
[Wed Sep 22 05:14:38 2021] FS:  00007ff352c3ca40(0000)
GS:ffffa174bfb00000(0000) knlGS:0000000000000000
[Wed Sep 22 05:14:38 2021] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[Wed Sep 22 05:14:38 2021] CR2: 00005644df1cad98 CR3: 0000000104c06003
CR4: 00000000001706e0
[Wed Sep 22 05:14:38 2021] Call Trace:
[Wed Sep 22 05:14:38 2021]  ethtool_get_rxnfc+0xec/0x1b0
[Wed Sep 22 05:14:38 2021]  dev_ethtool+0xb46/0x2870
[Wed Sep 22 05:14:38 2021]  ? ethtool_get_sset_info+0x190/0x190
[Wed Sep 22 05:14:38 2021]  ? _copy_to_user+0x1c/0x30
[Wed Sep 22 05:14:38 2021]  ? dev_ethtool+0x154d/0x2870
[Wed Sep 22 05:14:38 2021]  ? obj_cgroup_charge_pages+0xd2/0x190
[Wed Sep 22 05:14:38 2021]  dev_ioctl+0x151/0x480
[Wed Sep 22 05:14:38 2021]  sock_ioctl+0x248/0x360
[Wed Sep 22 05:14:38 2021]  ? alloc_empty_file+0xa1/0xb0
[Wed Sep 22 05:14:38 2021]  __x64_sys_ioctl+0x425/0x980
[Wed Sep 22 05:14:38 2021]  ? sock_alloc_file+0x53/0x90
[Wed Sep 22 05:14:38 2021]  ? __sys_socket+0x93/0xe0
[Wed Sep 22 05:14:38 2021]  do_syscall_64+0x5c/0x80
[Wed Sep 22 05:14:38 2021]  ? call_rcu+0x8a/0x250
[Wed Sep 22 05:14:38 2021]  ? exit_to_user_mode_prepare+0xd7/0x110
[Wed Sep 22 05:14:38 2021]  ? syscall_exit_to_user_mode+0x1d/0x40
[Wed Sep 22 05:14:38 2021]  ? __x64_sys_close+0x9/0x40
[Wed Sep 22 05:14:38 2021]  ? do_syscall_64+0x69/0x80
[Wed Sep 22 05:14:38 2021]  ? __x64_sys_socket+0x11/0x20
[Wed Sep 22 05:14:38 2021]  ? do_syscall_64+0x69/0x80
[Wed Sep 22 05:14:38 2021]  ? asm_exc_page_fault+0x8/0x30
[Wed Sep 22 05:14:38 2021]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[Wed Sep 22 05:14:38 2021] RIP: 0033:0x7ff356da9957
[Wed Sep 22 05:14:38 2021] Code: 3c 1c 48 f7 d8 4c 39 e0 77 b9 e8 24
ff ff ff 85 c0 78 be 4c 89 e0 5b 5d 41 5c c3 0f 1f 84 00 00 00 00 00
b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d e1 94 0c 00
f7 d8 64 89 01 48
[Wed Sep 22 05:14:38 2021] RSP: 002b:00007ffda8056c88 EFLAGS: 00000246
ORIG_RAX: 0000000000000010
[Wed Sep 22 05:14:38 2021] RAX: ffffffffffffffda RBX: 00005644df1c7180
RCX: 00007ff356da9957
[Wed Sep 22 05:14:38 2021] RDX: 00007ffda8056cc0 RSI: 0000000000008946
RDI: 0000000000000004
[Wed Sep 22 05:14:38 2021] RBP: 0000000000000004 R08: 0000000000000000
R09: 00005644df1c7a08
[Wed Sep 22 05:14:38 2021] R10: 0000000000000015 R11: 0000000000000246
R12: 00005644df1c79f0
[Wed Sep 22 05:14:38 2021] R13: 00007ffda8056cc0 R14: 00005644df1ca810
R15: 00005644df1ca23c
[Wed Sep 22 05:14:38 2021] ---[ end trace 2639f3b6af5e47c0 ]---
[Wed Sep 22 05:14:38 2021] ixgbe 0000:01:00.0 enp1s0: NIC Link is Up
10 Gbps, Flow Control: RX/TX
001706e0
[Wed Sep 22 05:14:33 2021] Call Trace:
[Wed Sep 22 05:14:33 2021]  ethtool_get_rxnfc+0xec/0x1b0
[Wed Sep 22 05:14:33 2021]  dev_ethtool+0xb46/0x2870
[Wed Sep 22 05:14:33 2021]  ? kmem_cache_alloc+0x232/0x350
[Wed Sep 22 05:14:33 2021]  ? __alloc_file+0x94/0x100
[Wed Sep 22 05:14:33 2021]  ? kmem_cache_alloc+0x232/0x350
[Wed Sep 22 05:14:33 2021]  ? alloc_empty_file+0x5e/0xb0
[Wed Sep 22 05:14:33 2021]  dev_ioctl+0x151/0x480
[Wed Sep 22 05:14:33 2021]  sock_ioctl+0x248/0x360
[Wed Sep 22 05:14:33 2021]  __x64_sys_ioctl+0x425/0x980
[Wed Sep 22 05:14:33 2021]  ? syscall_exit_to_user_mode+0x1d/0x40
[Wed Sep 22 05:14:33 2021]  ? __x64_sys_socket+0x11/0x20
[Wed Sep 22 05:14:33 2021]  ? do_syscall_64+0x69/0x80
[Wed Sep 22 05:14:33 2021]  do_syscall_64+0x5c/0x80
[Wed Sep 22 05:14:33 2021]  ? __x64_sys_close+0x9/0x40
[Wed Sep 22 05:14:33 2021]  ? do_syscall_64+0x69/0x80
[Wed Sep 22 05:14:33 2021]  ? syscall_exit_to_user_mode+0x1d/0x40
[Wed Sep 22 05:14:33 2021]  ? __x64_sys_socket+0x11/0x20
[Wed Sep 22 05:14:33 2021]  ? do_syscall_64+0x69/0x80
[Wed Sep 22 05:14:33 2021]  ? asm_exc_page_fault+0x8/0x30
[Wed Sep 22 05:14:33 2021]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[Wed Sep 22 05:14:33 2021] RIP: 0033:0x7f2cc6c6d957
[Wed Sep 22 05:14:33 2021] Code: 3c 1c 48 f7 d8 4c 39 e0 77 b9 e8 24
ff ff ff 85 c0 78 be 4c 89 e0 5b 5d 41 5c c3 0f 1f 84 00 00 00 00 00
b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d e1 94 0c 00
f7 d8 64 89 01 48
[Wed Sep 22 05:14:33 2021] RSP: 002b:00007ffc52d10858 EFLAGS: 00000246
ORIG_RAX: 0000000000000010
[Wed Sep 22 05:14:33 2021] RAX: ffffffffffffffda RBX: 000055cf41ae51a0
RCX: 00007f2cc6c6d957
[Wed Sep 22 05:14:33 2021] RDX: 00007ffc52d10890 RSI: 0000000000008946
RDI: 000000000000000f
[Wed Sep 22 05:14:33 2021] RBP: 000000000000000f R08: 0000000000000000
R09: 000055cf41ae5368
[Wed Sep 22 05:14:33 2021] R10: 000055cf41ae89c4 R11: 0000000000000246
R12: 000055cf41ae5350
[Wed Sep 22 05:14:33 2021] R13: 00007ffc52d10890 R14: 000055cf41ae8960
R15: 000055cf41ae8a04
[Wed Sep 22 05:14:33 2021] ---[ end trace 2639f3b6af5e47b8 ]---
[Wed Sep 22 05:14:33 2021] ------------[ cut here ]------------
[Wed Sep 22 05:14:33 2021] Buffer overflow detected (8 < 192)!
[Wed Sep 22 05:14:33 2021] WARNING: CPU: 1 PID: 897 at
include/linux/thread_info.h:200 ethtool_rxnfc_copy_to_user+0x11/0x20
[Wed Sep 22 05:14:33 2021] CPU: 1 PID: 897 Comm: nmbd Tainted: G
 W       T 5.14.6 #3 2312a638faa2fafaa8620a89d9c5a3692fbb0bb9
[Wed Sep 22 05:14:33 2021] Hardware name: Supermicro X9SRL-F/X9SRL-F,
BIOS 3.3 11/13/2018
[Wed Sep 22 05:14:33 2021] RIP: 0010:ethtool_rxnfc_copy_to_user+0x11/0x20
[Wed Sep 22 05:14:33 2021] Code: ff eb 94 b8 f4 ff ff ff eb 8d e8 2a
f2 22 00 66 2e 0f 1f 84 00 00 00 00 00 be 08 00 00 00 48 c7 c7 18 a6
b6 a4 e8 3f b5 19 00 <0f> 0b b8 f2 ff ff ff c3 0f 1f 80 00 00 00 00 41
56 41 55 41 54 55
[Wed Sep 22 05:14:33 2021] RSP: 0018:ffffa79bc1b57b68 EFLAGS: 00010286
[Wed Sep 22 05:14:33 2021] RAX: 0000000000000000 RBX: 0000000000000000
RCX: ffffa174bfa575b8
[Wed Sep 22 05:14:33 2021] RDX: 00000000ffffffd8 RSI: 0000000000000027
RDI: ffffa174bfa575b0
[Wed Sep 22 05:14:33 2021] RBP: ffffa16585074000 R08: ffffffffa4e41aa0
R09: 0000000000000002
[Wed Sep 22 05:14:33 2021] R10: 0000000000000001 R11: ffffffffa56612b9
R12: 0000000000000000
[Wed Sep 22 05:14:33 2021] R13: 00007ffc52d108c0 R14: ffffa79bc1b57b78
R15: ffffffffa4986740
[Wed Sep 22 05:14:33 2021] FS:  00007f2cc32a8a40(0000)
GS:ffffa174bfa40000(0000) knlGS:0000000000000000
[Wed Sep 22 05:14:33 2021] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[Wed Sep 22 05:14:33 2021] CR2: 000055cf41ae91c8 CR3: 0000000116be0005
CR4: 00000000001706e0
[Wed Sep 22 05:14:33 2021] Call Trace:
[Wed Sep 22 05:14:33 2021]  ethtool_get_rxnfc+0xec/0x1b0
[Wed Sep 22 05:14:33 2021]  dev_ethtool+0xb46/0x2870
[Wed Sep 22 05:14:33 2021]  ? _copy_from_user+0x28/0x60
[Wed Sep 22 05:14:33 2021]  ? ethtool_get_sset_info+0x190/0x190
[Wed Sep 22 05:14:33 2021]  ? _copy_to_user+0x1c/0x30
[Wed Sep 22 05:14:33 2021]  ? dev_ethtool+0x154d/0x2870
[Wed Sep 22 05:14:33 2021]  ? __rtnl_unlock+0x1f/0x40
[Wed Sep 22 05:14:33 2021]  ? netdev_run_todo+0x5b/0x360
[Wed Sep 22 05:14:33 2021]  dev_ioctl+0x151/0x480
[Wed Sep 22 05:14:33 2021]  sock_ioctl+0x248/0x360
[Wed Sep 22 05:14:33 2021]  __x64_sys_ioctl+0x425/0x980
[Wed Sep 22 05:14:33 2021]  do_syscall_64+0x5c/0x80
[Wed Sep 22 05:14:33 2021]  ? syscall_exit_to_user_mode+0x1d/0x40
[Wed Sep 22 05:14:33 2021]  ? __x64_sys_socket+0x11/0x20
[Wed Sep 22 05:14:33 2021]  ? do_syscall_64+0x69/0x80
[Wed Sep 22 05:14:33 2021]  ? syscall_exit_to_user_mode+0x1d/0x40
[Wed Sep 22 05:14:33 2021]  ? __x64_sys_close+0x9/0x40
[Wed Sep 22 05:14:33 2021]  ? do_syscall_64+0x69/0x80
[Wed Sep 22 05:14:33 2021]  ? __sys_socket+0x93/0xe0
[Wed Sep 22 05:14:33 2021]  ? syscall_exit_to_user_mode+0x1d/0x40
[Wed Sep 22 05:14:33 2021]  ? __x64_sys_socket+0x11/0x20
[Wed Sep 22 05:14:33 2021]  ? do_syscall_64+0x69/0x80
[Wed Sep 22 05:14:33 2021]  ? asm_exc_page_fault+0x8/0x30
[Wed Sep 22 05:14:33 2021]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[Wed Sep 22 05:14:33 2021] RIP: 0033:0x7f2cc6c6d957
[Wed Sep 22 05:14:33 2021] Code: 3c 1c 48 f7 d8 4c 39 e0 77 b9 e8 24
ff ff ff 85 c0 78 be 4c 89 e0 5b 5d 41 5c c3 0f 1f 84 00 00 00 00 00
b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d e1 94 0c 00
f7 d8 64 89 01 48
[Wed Sep 22 05:14:33 2021] RSP: 002b:00007ffc52d10858 EFLAGS: 00000246
ORIG_RAX: 0000000000000010
[Wed Sep 22 05:14:33 2021] RAX: ffffffffffffffda RBX: 000055cf41ae51a0
RCX: 00007f2cc6c6d957
[Wed Sep 22 05:14:33 2021] RDX: 00007ffc52d10890 RSI: 0000000000008946
RDI: 000000000000000f
[Wed Sep 22 05:14:33 2021] RBP: 000000000000000f R08: 0000000000000000
R09: 000055cf41ae5518
[Wed Sep 22 05:14:33 2021] R10: 0000000000000015 R11: 0000000000000246
R12: 000055cf41ae5500
[Wed Sep 22 05:14:33 2021] R13: 00007ffc52d10890 R14: 000055cf41ae8a18
R15: 000055cf41ae8abc
[Wed Sep 22 05:14:33 2021] ---[ end trace 2639f3b6af5e47b9 ]---
[Wed Sep 22 05:14:33 2021] ------------[ cut here ]------------
[Wed Sep 22 05:14:33 2021] Buffer overflow detected (8 < 192)!
[Wed Sep 22 05:14:33 2021] WARNING: CPU: 1 PID: 897 at
include/linux/thread_info.h:200 ethtool_rxnfc_copy_to_user+0x11/0x20
[Wed Sep 22 05:14:33 2021] CPU: 1 PID: 897 Comm: nmbd Tainted: G
 W       T 5.14.6 #3 2312a638faa2fafaa8620a89d9c5a3692fbb0bb9
[Wed Sep 22 05:14:33 2021] Hardware name: Supermicro X9SRL-F/X9SRL-F,
BIOS 3.3 11/13/2018
[Wed Sep 22 05:14:33 2021] RIP: 0010:ethtool_rxnfc_copy_to_user+0x11/0x20
[Wed Sep 22 05:14:33 2021] Code: ff eb 94 b8 f4 ff ff ff eb 8d e8 2a
f2 22 00 66 2e 0f 1f 84 00 00 00 00 00 be 08 00 00 00 48 c7 c7 18 a6
b6 a4 e8 3f b5 19 00 <0f> 0b b8 f2 ff ff ff c3 0f 1f 80 00 00 00 00 41
56 41 55 41 54 55
[Wed Sep 22 05:14:33 2021] RSP: 0018:ffffa79bc1b57c08 EFLAGS: 00010286
[Wed Sep 22 05:14:33 2021] RAX: 0000000000000000 RBX: 0000000000000000
RCX: ffffa174bfa575b8
[Wed Sep 22 05:14:33 2021] RDX: 00000000ffffffd8 RSI: 0000000000000027
RDI: ffffa174bfa575b0
[Wed Sep 22 05:14:33 2021] RBP: ffffa16585074000 R08: ffffffffa4e41aa0
R09: 0000000000000002
[Wed Sep 22 05:14:33 2021] R10: 0000000000000001 R11: ffffffffa5661f21
R12: 0000000000000000
[Wed Sep 22 05:14:33 2021] R13: 00007ffc52d108c0 R14: ffffa79bc1b57c18
R15: ffffffffa4986740
[Wed Sep 22 05:14:33 2021] FS:  00007f2cc32a8a40(0000)
GS:ffffa174bfa40000(0000) knlGS:0000000000000000
[Wed Sep 22 05:14:33 2021] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[Wed Sep 22 05:14:33 2021] CR2: 000055cf41ae91c8 CR3: 0000000116be0005
CR4: 00000000001706e0
[Wed Sep 22 05:14:33 2021] Call Trace:
[Wed Sep 22 05:14:33 2021]  ethtool_get_rxnfc+0xec/0x1b0
[Wed Sep 22 05:14:33 2021]  dev_ethtool+0xb46/0x2870
[Wed Sep 22 05:14:33 2021]  ? __alloc_file+0x94/0x100
[Wed Sep 22 05:14:33 2021]  ? kmem_cache_alloc+0x232/0x350
[Wed Sep 22 05:14:33 2021]  ? alloc_empty_file+0x5e/0xb0
[Wed Sep 22 05:14:33 2021]  ? alloc_file+0x90/0x110
[Wed Sep 22 05:14:33 2021]  ? alloc_file_pseudo+0x9e/0x100
[Wed Sep 22 05:14:33 2021]  dev_ioctl+0x151/0x480
[Wed Sep 22 05:14:33 2021]  sock_ioctl+0x248/0x360
[Wed Sep 22 05:14:33 2021]  __x64_sys_ioctl+0x425/0x980
[Wed Sep 22 05:14:33 2021]  do_syscall_64+0x5c/0x80
[Wed Sep 22 05:14:33 2021]  ? asm_exc_page_fault+0x8/0x30
[Wed Sep 22 05:14:33 2021]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[Wed Sep 22 05:14:33 2021] RIP: 0033:0x7f2cc6c6d957
[Wed Sep 22 05:14:33 2021] Code: 3c 1c 48 f7 d8 4c 39 e0 77 b9 e8 24
ff ff ff 85 c0 78 be 4c 89 e0 5b 5d 41 5c c3 0f 1f 84 00 00 00 00 00
b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d e1 94 0c 00
f7 d8 64 89 01 48
[Wed Sep 22 05:14:33 2021] RSP: 002b:00007ffc52d10858 EFLAGS: 00000246
ORIG_RAX: 0000000000000010
[Wed Sep 22 05:14:33 2021] RAX: ffffffffffffffda RBX: 000055cf41ae51a0
RCX: 00007f2cc6c6d957
[Wed Sep 22 05:14:33 2021] RDX: 00007ffc52d10890 RSI: 0000000000008946
RDI: 000000000000000f
[Wed Sep 22 05:14:33 2021] RBP: 000000000000000f R08: 0000000000000000
R09: 000055cf41ae5a28
[Wed Sep 22 05:14:33 2021] R10: 000055cf41ae8ca4 R11: 0000000000000246
R12: 000055cf41ae5a10
[Wed Sep 22 05:14:33 2021] R13: 00007ffc52d10890 R14: 000055cf41ae8c40
R15: 000055cf41ae87dc
[Wed Sep 22 05:14:33 2021] ---[ end trace 2639f3b6af5e47ba ]---
[Wed Sep 22 05:14:33 2021] nf_conntrack: default automatic helper
assignment has been turned off for security reasons and CT-based
firewall rule not found. Use the iptables CT target to attach helpers
instead.
[Wed Sep 22 05:14:33 2021] ------------[ cut here ]------------
[Wed Sep 22 05:14:33 2021] Buffer overflow detected (8 < 192)!
[Wed Sep 22 05:14:33 2021] WARNING: CPU: 1 PID: 897 at
include/linux/thread_info.h:200 ethtool_rxnfc_copy_to_user+0x11/0x20
[Wed Sep 22 05:14:33 2021] CPU: 1 PID: 897 Comm: nmbd Tainted: G
 W       T 5.14.6 #3 2312a638faa2fafaa8620a89d9c5a3692fbb0bb9
[Wed Sep 22 05:14:33 2021] Hardware name: Supermicro X9SRL-F/X9SRL-F,
BIOS 3.3 11/13/2018
[Wed Sep 22 05:14:33 2021] RIP: 0010:ethtool_rxnfc_copy_to_user+0x11/0x20
[Wed Sep 22 05:14:33 2021] Code: ff eb 94 b8 f4 ff ff ff eb 8d e8 2a
f2 22 00 66 2e 0f 1f 84 00 00 00 00 00 be 08 00 00 00 48 c7 c7 18 a6
b6 a4 e8 3f b5 19 00 <0f> 0b b8 f2 ff ff ff c3 0f 1f 80 00 00 00 00 41
56 41 55 41 54 55
[Wed Sep 22 05:14:33 2021] RSP: 0018:ffffa79bc1b57bc0 EFLAGS: 00010282
[Wed Sep 22 05:14:33 2021] RAX: 0000000000000000 RBX: 0000000000000000
RCX: ffffa174bfa575b8
[Wed Sep 22 05:14:33 2021] RDX: 00000000ffffffd8 RSI: 0000000000000027
RDI: ffffa174bfa575b0
[Wed Sep 22 05:14:33 2021] RBP: ffffa16585378000 R08: ffffffffa4e41aa0
R09: 0000000000000002
[Wed Sep 22 05:14:33 2021] R10: 0000000000000001 R11: ffffffffa5662a89
R12: 0000000000000000
[Wed Sep 22 05:14:33 2021] R13: 00007ffc52d108c0 R14: ffffa79bc1b57bd0
R15: ffffffffa4984b00
[Wed Sep 22 05:14:33 2021] FS:  00007f2cc32a8a40(0000)
GS:ffffa174bfa40000(0000) knlGS:0000000000000000
[Wed Sep 22 05:14:33 2021] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[Wed Sep 22 05:14:33 2021] CR2: 000055cf41af0e98 CR3: 0000000116be0005
CR4: 00000000001706e0
[Wed Sep 22 05:14:33 2021] Call Trace:
[Wed Sep 22 05:14:33 2021]  ethtool_get_rxnfc+0xec/0x1b0
[Wed Sep 22 05:14:33 2021]  dev_ethtool+0xb46/0x2870
[Wed Sep 22 05:14:33 2021]  ? dev_ethtool+0x1b6/0x2870
[Wed Sep 22 05:14:33 2021]  ? __alloc_file+0x1e/0x100
[Wed Sep 22 05:14:33 2021]  ? kmem_cache_alloc+0x232/0x350
[Wed Sep 22 05:14:33 2021]  dev_ioctl+0x151/0x480
[Wed Sep 22 05:14:33 2021]  sock_ioctl+0x248/0x360
[Wed Sep 22 05:14:33 2021]  ? alloc_file_pseudo+0x9e/0x100
[Wed Sep 22 05:14:33 2021]  __x64_sys_ioctl+0x425/0x980
[Wed Sep 22 05:14:33 2021]  ? __sys_socket+0x93/0xe0
[Wed Sep 22 05:14:33 2021]  ? syscall_exit_to_user_mode+0x1d/0x40
[Wed Sep 22 05:14:33 2021]  do_syscall_64+0x5c/0x80
[Wed Sep 22 05:14:33 2021]  ? syscall_exit_to_user_mode+0x1d/0x40
[Wed Sep 22 05:14:33 2021]  ? __x64_sys_close+0x9/0x40
[Wed Sep 22 05:14:33 2021]  ? do_syscall_64+0x69/0x80
[Wed Sep 22 05:14:33 2021]  ? syscall_exit_to_user_mode+0x1d/0x40
[Wed Sep 22 05:14:33 2021]  ? asm_exc_page_fault+0x8/0x30
[Wed Sep 22 05:14:33 2021]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[Wed Sep 22 05:14:33 2021] RIP: 0033:0x7f2cc6c6d957
[Wed Sep 22 05:14:33 2021] Code: 3c 1c 48 f7 d8 4c 39 e0 77 b9 e8 24
ff ff ff 85 c0 78 be 4c 89 e0 5b 5d 41 5c c3 0f 1f 84 00 00 00 00 00
b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d e1 94 0c 00
f7 d8 64 89 01 48
[Wed Sep 22 05:14:33 2021] RSP: 002b:00007ffc52d10858 EFLAGS: 00000246
ORIG_RAX: 0000000000000010
[Wed Sep 22 05:14:33 2021] RAX: ffffffffffffffda RBX: 000055cf41aece70
RCX: 00007f2cc6c6d957
[Wed Sep 22 05:14:33 2021] RDX: 00007ffc52d10890 RSI: 0000000000008946
RDI: 0000000000000018
[Wed Sep 22 05:14:33 2021] RBP: 0000000000000018 R08: 0000000000000000
R09: 000055cf41aed038
[Wed Sep 22 05:14:33 2021] R10: 000055cf41af0694 R11: 0000000000000246
R12: 000055cf41aed020
[Wed Sep 22 05:14:33 2021] R13: 00007ffc52d10890 R14: 000055cf41af0630
R15: 000055cf41af06d4
[Wed Sep 22 05:14:33 2021] ---[ end trace 2639f3b6af5e47bb ]---
[Wed Sep 22 05:14:33 2021] ------------[ cut here ]------------
[Wed Sep 22 05:14:33 2021] Buffer overflow detected (8 < 192)!
[Wed Sep 22 05:14:33 2021] WARNING: CPU: 1 PID: 897 at
include/linux/thread_info.h:200 ethtool_rxnfc_copy_to_user+0x11/0x20
[Wed Sep 22 05:14:33 2021] CPU: 1 PID: 897 Comm: nmbd Tainted: G
 W       T 5.14.6 #3 2312a638faa2fafaa8620a89d9c5a3692fbb0bb9
[Wed Sep 22 05:14:33 2021] Hardware name: Supermicro X9SRL-F/X9SRL-F,
BIOS 3.3 11/13/2018
[Wed Sep 22 05:14:33 2021] RIP: 0010:ethtool_rxnfc_copy_to_user+0x11/0x20
[Wed Sep 22 05:14:33 2021] Code: ff eb 94 b8 f4 ff ff ff eb 8d e8 2a
f2 22 00 66 2e 0f 1f 84 00 00 00 00 00 be 08 00 00 00 48 c7 c7 18 a6
b6 a4 e8 3f b5 19 00 <0f> 0b b8 f2 ff ff ff c3 0f 1f 80 00 00 00 00 41
56 41 55 41 54 55
[Wed Sep 22 05:14:33 2021] RSP: 0018:ffffa79bc1b57b58 EFLAGS: 00010282
[Wed Sep 22 05:14:33 2021] RAX: 0000000000000000 RBX: 0000000000000000
RCX: ffffa174bfa575b8
[Wed Sep 22 05:14:33 2021] RDX: 00000000ffffffd8 RSI: 0000000000000027
RDI: ffffa174bfa575b0
[Wed Sep 22 05:14:33 2021] RBP: ffffa16585074000 R08: ffffffffa4e41aa0
R09: 0000000000000002
[Wed Sep 22 05:14:33 2021] R10: 0000000000000001 R11: ffffffffa5663609
R12: 0000000000000000
[Wed Sep 22 05:14:33 2021] R13: 00007ffc52d108c0 R14: ffffa79bc1b57b68
R15: ffffffffa4986740
[Wed Sep 22 05:14:33 2021] FS:  00007f2cc32a8a40(0000)
GS:ffffa174bfa40000(0000) knlGS:0000000000000000
[Wed Sep 22 05:14:33 2021] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[Wed Sep 22 05:14:33 2021] CR2: 000055cf41af0e98 CR3: 0000000116be0005
CR4: 00000000001706e0
[Wed Sep 22 05:14:33 2021] Call Trace:
[Wed Sep 22 05:14:33 2021]  ethtool_get_rxnfc+0xec/0x1b0
[Wed Sep 22 05:14:33 2021]  dev_ethtool+0xb46/0x2870
[Wed Sep 22 05:14:33 2021]  ? __rtnl_unlock+0x1f/0x40
[Wed Sep 22 05:14:33 2021]  ? netdev_run_todo+0x5b/0x360
[Wed Sep 22 05:14:33 2021]  ? unix_gc+0x232/0x460
[Wed Sep 22 05:14:33 2021]  ? dev_ioctl+0x159/0x480
[Wed Sep 22 05:14:33 2021]  dev_ioctl+0x151/0x480
[Wed Sep 22 05:14:33 2021]  sock_ioctl+0x248/0x360
[Wed Sep 22 05:14:33 2021]  __x64_sys_ioctl+0x425/0x980
[Wed Sep 22 05:14:33 2021]  ? __alloc_file+0x94/0x100
[Wed Sep 22 05:14:33 2021]  ? kmem_cache_alloc+0x232/0x350
[Wed Sep 22 05:14:33 2021]  ? alloc_empty_file+0x5e/0xb0
[Wed Sep 22 05:14:33 2021]  do_syscall_64+0x5c/0x80
[Wed Sep 22 05:14:33 2021]  ? sock_alloc_file+0x53/0x90
[Wed Sep 22 05:14:33 2021]  ? __sys_socket+0x93/0xe0
[Wed Sep 22 05:14:33 2021]  ? exit_to_user_mode_prepare+0xd7/0x110
[Wed Sep 22 05:14:33 2021]  ? syscall_exit_to_user_mode+0x1d/0x40
[Wed Sep 22 05:14:33 2021]  ? __x64_sys_socket+0x11/0x20
[Wed Sep 22 05:14:33 2021]  ? do_syscall_64+0x69/0x80
[Wed Sep 22 05:14:33 2021]  ? asm_exc_page_fault+0x8/0x30
[Wed Sep 22 05:14:33 2021]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[Wed Sep 22 05:14:33 2021] RIP: 0033:0x7f2cc6c6d957
[Wed Sep 22 05:14:33 2021] Code: 3c 1c 48 f7 d8 4c 39 e0 77 b9 e8 24
ff ff ff 85 c0 78 be 4c 89 e0 5b 5d 41 5c c3 0f 1f 84 00 00 00 00 00
b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d e1 94 0c 00
f7 d8 64 89 01 48
[Wed Sep 22 05:14:33 2021] RSP: 002b:00007ffc52d10858 EFLAGS: 00000246
ORIG_RAX: 0000000000000010
[Wed Sep 22 05:14:33 2021] RAX: ffffffffffffffda RBX: 000055cf41aece70
RCX: 00007f2cc6c6d957
[Wed Sep 22 05:14:33 2021] RDX: 00007ffc52d10890 RSI: 0000000000008946
RDI: 0000000000000018
[Wed Sep 22 05:14:33 2021] RBP: 0000000000000018 R08: 0000000000000000
R09: 000055cf41aed1e8
[Wed Sep 22 05:14:33 2021] R10: 000055cf41af074c R11: 0000000000000246
R12: 000055cf41aed1d0
[Wed Sep 22 05:14:33 2021] R13: 00007ffc52d10890 R14: 000055cf41af06e8
R15: 000055cf41af078c
[Wed Sep 22 05:14:33 2021] ---[ end trace 2639f3b6af5e47bc ]---
[Wed Sep 22 05:14:33 2021] ------------[ cut here ]------------
[Wed Sep 22 05:14:33 2021] Buffer overflow detected (8 < 192)!
[Wed Sep 22 05:14:33 2021] WARNING: CPU: 1 PID: 897 at
include/linux/thread_info.h:200 ethtool_rxnfc_copy_to_user+0x11/0x20
[Wed Sep 22 05:14:33 2021] CPU: 1 PID: 897 Comm: nmbd Tainted: G
 W       T 5.14.6 #3 2312a638faa2fafaa8620a89d9c5a3692fbb0bb9
[Wed Sep 22 05:14:33 2021] Hardware name: Supermicro X9SRL-F/X9SRL-F,
BIOS 3.3 11/13/2018
[Wed Sep 22 05:14:33 2021] RIP: 0010:ethtool_rxnfc_copy_to_user+0x11/0x20
[Wed Sep 22 05:14:33 2021] Code: ff eb 94 b8 f4 ff ff ff eb 8d e8 2a
f2 22 00 66 2e 0f 1f 84 00 00 00 00 00 be 08 00 00 00 48 c7 c7 18 a6
b6 a4 e8 3f b5 19 00 <0f> 0b b8 f2 ff ff ff c3 0f 1f 80 00 00 00 00 41
56 41 55 41 54 55
[Wed Sep 22 05:14:33 2021] RSP: 0018:ffffa79bc1b57b60 EFLAGS: 00010286
[Wed Sep 22 05:14:33 2021] RAX: 0000000000000000 RBX: 0000000000000000
RCX: ffffa174bfa575b8
[Wed Sep 22 05:14:33 2021] RDX: 00000000ffffffd8 RSI: 0000000000000027
RDI: ffffa174bfa575b0
[Wed Sep 22 05:14:33 2021] RBP: ffffa16585074000 R08: ffffffffa4e41aa0
R09: 0000000000000002
[Wed Sep 22 05:14:33 2021] R10: 0000000000000001 R11: ffffffffa56641f1
R12: 0000000000000000
[Wed Sep 22 05:14:33 2021] R13: 00007ffc52d108c0 R14: ffffa79bc1b57b70
R15: ffffffffa4986740
[Wed Sep 22 05:14:33 2021] FS:  00007f2cc32a8a40(0000)
GS:ffffa174bfa40000(0000) knlGS:0000000000000000
[Wed Sep 22 05:14:33 2021] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[Wed Sep 22 05:14:33 2021] CR2: 000055cf41af0e98 CR3: 0000000116be0005
CR4: 00000000001706e0
[Wed Sep 22 05:14:33 2021] Call Trace:
[Wed Sep 22 05:14:33 2021]  ethtool_get_rxnfc+0xec/0x1b0
[Wed Sep 22 05:14:33 2021]  dev_ethtool+0xb46/0x2870
[Wed Sep 22 05:14:33 2021]  ? _copy_to_user+0x1c/0x30
[Wed Sep 22 05:14:33 2021]  ? dev_ethtool+0x154d/0x2870
[Wed Sep 22 05:14:33 2021]  ? kmem_cache_alloc+0x232/0x350
[Wed Sep 22 05:14:33 2021]  ? __rtnl_unlock+0x1f/0x40
[Wed Sep 22 05:14:33 2021]  ? netdev_run_todo+0x5b/0x360
[Wed Sep 22 05:14:33 2021]  dev_ioctl+0x151/0x480
[Wed Sep 22 05:14:33 2021]  sock_ioctl+0x248/0x360
[Wed Sep 22 05:14:33 2021]  __x64_sys_ioctl+0x425/0x980
[Wed Sep 22 05:14:33 2021]  ? alloc_file_pseudo+0x9e/0x100
[Wed Sep 22 05:14:33 2021]  do_syscall_64+0x5c/0x80
[Wed Sep 22 05:14:33 2021]  ? __sys_socket+0x93/0xe0
[Wed Sep 22 05:14:33 2021]  ? syscall_exit_to_user_mode+0x1d/0x40
[Wed Sep 22 05:14:33 2021]  ? __x64_sys_socket+0x11/0x20
[Wed Sep 22 05:14:33 2021]  ? do_syscall_64+0x69/0x80
[Wed Sep 22 05:14:33 2021]  ? __sys_socket+0x93/0xe0
[Wed Sep 22 05:14:33 2021]  ? do_syscall_64+0x69/0x80
[Wed Sep 22 05:14:33 2021]  ? syscall_exit_to_user_mode+0x1d/0x40
[Wed Sep 22 05:14:33 2021]  ? __x64_sys_socket+0x11/0x20
[Wed Sep 22 05:14:33 2021]  ? do_syscall_64+0x69/0x80
[Wed Sep 22 05:14:33 2021]  ? asm_exc_page_fault+0x8/0x30
[Wed Sep 22 05:14:33 2021]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[Wed Sep 22 05:14:33 2021] RIP: 0033:0x7f2cc6c6d957
[Wed Sep 22 05:14:33 2021] Code: 3c 1c 48 f7 d8 4c 39 e0 77 b9 e8 24
ff ff ff 85 c0 78 be 4c 89 e0 5b 5d 41 5c c3 0f 1f 84 00 00 00 00 00
b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d e1 94 0c 00
f7 d8 64 89 01 48
[Wed Sep 22 05:14:33 2021] RSP: 002b:00007ffc52d10858 EFLAGS: 00000246
ORIG_RAX: 0000000000000010
[Wed Sep 22 05:14:33 2021] RAX: ffffffffffffffda RBX: 000055cf41aece70
RCX: 00007f2cc6c6d957
[Wed Sep 22 05:14:33 2021] RDX: 00007ffc52d10890 RSI: 0000000000008946
RDI: 0000000000000018
[Wed Sep 22 05:14:33 2021] RBP: 0000000000000018 R08: 0000000000000000
R09: 000055cf41aed6f8
[Wed Sep 22 05:14:33 2021] R10: 0000000000000015 R11: 0000000000000246
R12: 000055cf41aed6e0
[Wed Sep 22 05:14:33 2021] R13: 00007ffc52d10890 R14: 000055cf41af0910
R15: 000055cf41af04ac
[Wed Sep 22 05:14:33 2021] ---[ end trace 2639f3b6af5e47bd ]---
[Wed Sep 22 05:14:36 2021] igb 0000:08:00.0 enp8s0f3: igb: enp8s0f3
NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
[Wed Sep 22 05:14:37 2021] igb 0000:08:00.2 enp8s0f1: igb: enp8s0f1
NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
[Wed Sep 22 05:14:37 2021] IPv6: ADDRCONF(NETDEV_CHANGE): enp8s0f3:
link becomes ready
[Wed Sep 22 05:14:37 2021] IPv6: ADDRCONF(NETDEV_CHANGE): enp8s0f1:
link becomes ready
[Wed Sep 22 05:14:38 2021] ------------[ cut here ]------------
[Wed Sep 22 05:14:38 2021] Buffer overflow detected (8 < 192)!
[Wed Sep 22 05:14:38 2021] WARNING: CPU: 4 PID: 1174 at
include/linux/thread_info.h:200 ethtool_rxnfc_copy_to_user+0x11/0x20
[Wed Sep 22 05:14:38 2021] CPU: 4 PID: 1174 Comm: smbd Tainted: G
  W       T 5.14.6 #3 2312a638faa2fafaa8620a89d9c5a3692fbb0bb9
[Wed Sep 22 05:14:38 2021] Hardware name: Supermicro X9SRL-F/X9SRL-F,
BIOS 3.3 11/13/2018
[Wed Sep 22 05:14:38 2021] RIP: 0010:ethtool_rxnfc_copy_to_user+0x11/0x20
[Wed Sep 22 05:14:38 2021] Code: ff eb 94 b8 f4 ff ff ff eb 8d e8 2a
f2 22 00 66 2e 0f 1f 84 00 00 00 00 00 be 08 00 00 00 48 c7 c7 18 a6
b6 a4 e8 3f b5 19 00 <0f> 0b b8 f2 ff ff ff c3 0f 1f 80 00 00 00 00 41
56 41 55 41 54 55
[Wed Sep 22 05:14:38 2021] RSP: 0018:ffffa79bc1d0fc00 EFLAGS: 00010286
[Wed Sep 22 05:14:38 2021] RAX: 0000000000000000 RBX: 0000000000000000
RCX: ffffa174bfb175b8
[Wed Sep 22 05:14:38 2021] RDX: 00000000ffffffd8 RSI: 0000000000000027
RDI: ffffa174bfb175b0
[Wed Sep 22 05:14:38 2021] RBP: ffffa16585378000 R08: ffffffffa4e41aa0
R09: 0000000000000002
[Wed Sep 22 05:14:38 2021] R10: 0000000000000001 R11: ffffffffa5664fa1
R12: 0000000000000000
[Wed Sep 22 05:14:38 2021] R13: 00007ffda8056cf0 R14: ffffa79bc1d0fc10
R15: ffffffffa4984b00
[Wed Sep 22 05:14:38 2021] FS:  00007ff352c3ca40(0000)
GS:ffffa174bfb00000(0000) knlGS:0000000000000000
[Wed Sep 22 05:14:38 2021] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[Wed Sep 22 05:14:38 2021] CR2: 00005644df1cad98 CR3: 0000000104c06003
CR4: 00000000001706e0
[Wed Sep 22 05:14:38 2021] Call Trace:
[Wed Sep 22 05:14:38 2021]  ethtool_get_rxnfc+0xec/0x1b0
[Wed Sep 22 05:14:38 2021]  dev_ethtool+0xb46/0x2870
[Wed Sep 22 05:14:38 2021]  ? kmem_cache_alloc+0x232/0x350
[Wed Sep 22 05:14:38 2021]  ? alloc_empty_file+0x5e/0xb0
[Wed Sep 22 05:14:38 2021]  ? alloc_file+0x90/0x110
[Wed Sep 22 05:14:38 2021]  ? alloc_file_pseudo+0x9e/0x100
[Wed Sep 22 05:14:38 2021]  dev_ioctl+0x151/0x480
[Wed Sep 22 05:14:38 2021]  sock_ioctl+0x248/0x360
[Wed Sep 22 05:14:38 2021]  ? syscall_exit_to_user_mode+0x1d/0x40
[Wed Sep 22 05:14:38 2021]  __x64_sys_ioctl+0x425/0x980
[Wed Sep 22 05:14:38 2021]  ? syscall_exit_to_user_mode+0x1d/0x40
[Wed Sep 22 05:14:38 2021]  ? __x64_sys_close+0x9/0x40
[Wed Sep 22 05:14:38 2021]  ? do_syscall_64+0x69/0x80
[Wed Sep 22 05:14:38 2021]  ? __x64_sys_socket+0x11/0x20
[Wed Sep 22 05:14:38 2021]  ? do_syscall_64+0x69/0x80
[Wed Sep 22 05:14:38 2021]  do_syscall_64+0x5c/0x80
[Wed Sep 22 05:14:38 2021]  ? asm_exc_page_fault+0x8/0x30
[Wed Sep 22 05:14:38 2021]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[Wed Sep 22 05:14:38 2021] RIP: 0033:0x7ff356da9957
[Wed Sep 22 05:14:38 2021] Code: 3c 1c 48 f7 d8 4c 39 e0 77 b9 e8 24
ff ff ff 85 c0 78 be 4c 89 e0 5b 5d 41 5c c3 0f 1f 84 00 00 00 00 00
b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d e1 94 0c 00
f7 d8 64 89 01 48
[Wed Sep 22 05:14:38 2021] RSP: 002b:00007ffda8056c88 EFLAGS: 00000246
ORIG_RAX: 0000000000000010
[Wed Sep 22 05:14:38 2021] RAX: ffffffffffffffda RBX: 00005644df1c7180
RCX: 00007ff356da9957
[Wed Sep 22 05:14:38 2021] RDX: 00007ffda8056cc0 RSI: 0000000000008946
RDI: 0000000000000004
[Wed Sep 22 05:14:38 2021] RBP: 0000000000000004 R08: 0000000000000000
R09: 00005644df1c7348
[Wed Sep 22 05:14:38 2021] R10: 000000000000000d R11: 0000000000000246
R12: 00005644df1c7330
[Wed Sep 22 05:14:38 2021] R13: 00007ffda8056cc0 R14: 00005644df1ca3c0
R15: 00005644df1ca464
[Wed Sep 22 05:14:38 2021] ---[ end trace 2639f3b6af5e47be ]---
[Wed Sep 22 05:14:38 2021] ------------[ cut here ]------------
[Wed Sep 22 05:14:38 2021] Buffer overflow detected (8 < 192)!
[Wed Sep 22 05:14:38 2021] WARNING: CPU: 4 PID: 1174 at
include/linux/thread_info.h:200 ethtool_rxnfc_copy_to_user+0x11/0x20
[Wed Sep 22 05:14:38 2021] CPU: 4 PID: 1174 Comm: smbd Tainted: G
  W       T 5.14.6 #3 2312a638faa2fafaa8620a89d9c5a3692fbb0bb9
[Wed Sep 22 05:14:38 2021] Hardware name: Supermicro X9SRL-F/X9SRL-F,
BIOS 3.3 11/13/2018
[Wed Sep 22 05:14:38 2021] RIP: 0010:ethtool_rxnfc_copy_to_user+0x11/0x20
[Wed Sep 22 05:14:38 2021] Code: ff eb 94 b8 f4 ff ff ff eb 8d e8 2a
f2 22 00 66 2e 0f 1f 84 00 00 00 00 00 be 08 00 00 00 48 c7 c7 18 a6
b6 a4 e8 3f b5 19 00 <0f> 0b b8 f2 ff ff ff c3 0f 1f 80 00 00 00 00 41
56 41 55 41 54 55
[Wed Sep 22 05:14:38 2021] RSP: 0018:ffffa79bc1d0fb48 EFLAGS: 00010286
[Wed Sep 22 05:14:38 2021] RAX: 0000000000000000 RBX: 0000000000000000
RCX: ffffa174bfb175b8
[Wed Sep 22 05:14:38 2021] RDX: 00000000ffffffd8 RSI: 0000000000000027
RDI: ffffa174bfb175b0
[Wed Sep 22 05:14:38 2021] RBP: ffffa16585074000 R08: ffffffffa4e41aa0
R09: 0000000000000002
[Wed Sep 22 05:14:38 2021] R10: 0000000000000001 R11: ffffffffa5665b19
R12: 0000000000000000
[Wed Sep 22 05:14:38 2021] R13: 00007ffda8056cf0 R14: ffffa79bc1d0fb58
R15: ffffffffa4986740
[Wed Sep 22 05:14:38 2021] FS:  00007ff352c3ca40(0000)
GS:ffffa174bfb00000(0000) knlGS:0000000000000000
[Wed Sep 22 05:14:38 2021] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[Wed Sep 22 05:14:38 2021] CR2: 00005644df1cad98 CR3: 0000000104c06003
CR4: 00000000001706e0
[Wed Sep 22 05:14:38 2021] Call Trace:
[Wed Sep 22 05:14:38 2021]  ethtool_get_rxnfc+0xec/0x1b0
[Wed Sep 22 05:14:38 2021]  dev_ethtool+0xb46/0x2870
[Wed Sep 22 05:14:38 2021]  ? __rtnl_unlock+0x1f/0x40
[Wed Sep 22 05:14:38 2021]  ? netdev_run_todo+0x5b/0x360
[Wed Sep 22 05:14:38 2021]  dev_ioctl+0x151/0x480
[Wed Sep 22 05:14:38 2021]  sock_ioctl+0x248/0x360
[Wed Sep 22 05:14:38 2021]  __x64_sys_ioctl+0x425/0x980
[Wed Sep 22 05:14:38 2021]  ? alloc_file+0x90/0x110
[Wed Sep 22 05:14:38 2021]  ? alloc_file_pseudo+0x9e/0x100
[Wed Sep 22 05:14:38 2021]  do_syscall_64+0x5c/0x80
[Wed Sep 22 05:14:38 2021]  ? sock_alloc_file+0x53/0x90
[Wed Sep 22 05:14:38 2021]  ? __sys_socket+0x93/0xe0
[Wed Sep 22 05:14:38 2021]  ? syscall_exit_to_user_mode+0x1d/0x40
[Wed Sep 22 05:14:38 2021]  ? __x64_sys_socket+0x11/0x20
[Wed Sep 22 05:14:38 2021]  ? do_syscall_64+0x69/0x80
[Wed Sep 22 05:14:38 2021]  ? exit_to_user_mode_prepare+0xd7/0x110
[Wed Sep 22 05:14:38 2021]  ? syscall_exit_to_user_mode+0x1d/0x40
[Wed Sep 22 05:14:38 2021]  ? __x64_sys_close+0x9/0x40
[Wed Sep 22 05:14:38 2021]  ? do_syscall_64+0x69/0x80
[Wed Sep 22 05:14:38 2021]  ? asm_exc_page_fault+0x8/0x30
[Wed Sep 22 05:14:38 2021]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[Wed Sep 22 05:14:38 2021] RIP: 0033:0x7ff356da9957
[Wed Sep 22 05:14:38 2021] Code: 3c 1c 48 f7 d8 4c 39 e0 77 b9 e8 24
ff ff ff 85 c0 78 be 4c 89 e0 5b 5d 41 5c c3 0f 1f 84 00 00 00 00 00
b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d e1 94 0c 00
f7 d8 64 89 01 48
[Wed Sep 22 05:14:38 2021] RSP: 002b:00007ffda8056c88 EFLAGS: 00000246
ORIG_RAX: 0000000000000010
[Wed Sep 22 05:14:38 2021] RAX: ffffffffffffffda RBX: 00005644df1c7180
RCX: 00007ff356da9957
[Wed Sep 22 05:14:38 2021] RDX: 00007ffda8056cc0 RSI: 0000000000008946
RDI: 0000000000000004
[Wed Sep 22 05:14:38 2021] RBP: 0000000000000004 R08: 0000000000000000
R09: 00005644df1c74f8
[Wed Sep 22 05:14:38 2021] R10: 00005644df1ca4dc R11: 0000000000000246
R12: 00005644df1c74e0
[Wed Sep 22 05:14:38 2021] R13: 00007ffda8056cc0 R14: 00005644df1ca478
R15: 00005644df1ca51c
[Wed Sep 22 05:14:38 2021] ---[ end trace 2639f3b6af5e47bf ]---
[Wed Sep 22 05:14:38 2021] ------------[ cut here ]------------
[Wed Sep 22 05:14:38 2021] Buffer overflow detected (8 < 192)!
[Wed Sep 22 05:14:38 2021] WARNING: CPU: 4 PID: 1174 at
include/linux/thread_info.h:200 ethtool_rxnfc_copy_to_user+0x11/0x20
[Wed Sep 22 05:14:38 2021] CPU: 4 PID: 1174 Comm: smbd Tainted: G
  W       T 5.14.6 #3 2312a638faa2fafaa8620a89d9c5a3692fbb0bb9
[Wed Sep 22 05:14:38 2021] Hardware name: Supermicro X9SRL-F/X9SRL-F,
BIOS 3.3 11/13/2018
[Wed Sep 22 05:14:38 2021] RIP: 0010:ethtool_rxnfc_copy_to_user+0x11/0x20
[Wed Sep 22 05:14:38 2021] Code: ff eb 94 b8 f4 ff ff ff eb 8d e8 2a
f2 22 00 66 2e 0f 1f 84 00 00 00 00 00 be 08 00 00 00 48 c7 c7 18 a6
b6 a4 e8 3f b5 19 00 <0f> 0b b8 f2 ff ff ff c3 0f 1f 80 00 00 00 00 41
56 41 55 41 54 55
[Wed Sep 22 05:14:38 2021] RSP: 0018:ffffa79bc1d0fb58 EFLAGS: 00010282
[Wed Sep 22 05:14:38 2021] RAX: 0000000000000000 RBX: 0000000000000000
RCX: ffffa174bfb175b8
[Wed Sep 22 05:14:38 2021] RDX: 00000000ffffffd8 RSI: 0000000000000027
RDI: ffffa174bfb175b0
[Wed Sep 22 05:14:38 2021] RBP: ffffa16585074000 R08: ffffffffa4e41aa0
R09: 0000000000000002
[Wed Sep 22 05:14:38 2021] R10: 0000000000000001 R11: ffffffffa5666711
R12: 0000000000000000
[Wed Sep 22 05:14:38 2021] R13: 00007ffda8056cf0 R14: ffffa79bc1d0fb68
R15: ffffffffa4986740
[Wed Sep 22 05:14:38 2021] FS:  00007ff352c3ca40(0000)
GS:ffffa174bfb00000(0000) knlGS:0000000000000000
[Wed Sep 22 05:14:38 2021] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[Wed Sep 22 05:14:38 2021] CR2: 00005644df1cad98 CR3: 0000000104c06003
CR4: 00000000001706e0
[Wed Sep 22 05:14:38 2021] Call Trace:
[Wed Sep 22 05:14:38 2021]  ethtool_get_rxnfc+0xec/0x1b0
[Wed Sep 22 05:14:38 2021]  dev_ethtool+0xb46/0x2870
[Wed Sep 22 05:14:38 2021]  ? ethtool_get_sset_info+0x190/0x190
[Wed Sep 22 05:14:38 2021]  ? _copy_to_user+0x1c/0x30
[Wed Sep 22 05:14:38 2021]  ? dev_ethtool+0x154d/0x2870
[Wed Sep 22 05:14:38 2021]  ? obj_cgroup_charge_pages+0xd2/0x190
[Wed Sep 22 05:14:38 2021]  dev_ioctl+0x151/0x480
[Wed Sep 22 05:14:38 2021]  sock_ioctl+0x248/0x360
[Wed Sep 22 05:14:38 2021]  ? alloc_empty_file+0xa1/0xb0
[Wed Sep 22 05:14:38 2021]  __x64_sys_ioctl+0x425/0x980
[Wed Sep 22 05:14:38 2021]  ? sock_alloc_file+0x53/0x90
[Wed Sep 22 05:14:38 2021]  ? __sys_socket+0x93/0xe0
[Wed Sep 22 05:14:38 2021]  do_syscall_64+0x5c/0x80
[Wed Sep 22 05:14:38 2021]  ? call_rcu+0x8a/0x250
[Wed Sep 22 05:14:38 2021]  ? exit_to_user_mode_prepare+0xd7/0x110
[Wed Sep 22 05:14:38 2021]  ? syscall_exit_to_user_mode+0x1d/0x40
[Wed Sep 22 05:14:38 2021]  ? __x64_sys_close+0x9/0x40
[Wed Sep 22 05:14:38 2021]  ? do_syscall_64+0x69/0x80
[Wed Sep 22 05:14:38 2021]  ? __x64_sys_socket+0x11/0x20
[Wed Sep 22 05:14:38 2021]  ? do_syscall_64+0x69/0x80
[Wed Sep 22 05:14:38 2021]  ? asm_exc_page_fault+0x8/0x30
[Wed Sep 22 05:14:38 2021]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[Wed Sep 22 05:14:38 2021] RIP: 0033:0x7ff356da9957
[Wed Sep 22 05:14:38 2021] Code: 3c 1c 48 f7 d8 4c 39 e0 77 b9 e8 24
ff ff ff 85 c0 78 be 4c 89 e0 5b 5d 41 5c c3 0f 1f 84 00 00 00 00 00
b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d e1 94 0c 00
f7 d8 64 89 01 48
[Wed Sep 22 05:14:38 2021] RSP: 002b:00007ffda8056c88 EFLAGS: 00000246
ORIG_RAX: 0000000000000010
[Wed Sep 22 05:14:38 2021] RAX: ffffffffffffffda RBX: 00005644df1c7180
RCX: 00007ff356da9957
[Wed Sep 22 05:14:38 2021] RDX: 00007ffda8056cc0 RSI: 0000000000008946
RDI: 0000000000000004
[Wed Sep 22 05:14:38 2021] RBP: 0000000000000004 R08: 0000000000000000
R09: 00005644df1c7a08
[Wed Sep 22 05:14:38 2021] R10: 0000000000000015 R11: 0000000000000246
R12: 00005644df1c79f0
[Wed Sep 22 05:14:38 2021] R13: 00007ffda8056cc0 R14: 00005644df1ca810
R15: 00005644df1ca23c
[Wed Sep 22 05:14:38 2021] ---[ end trace 2639f3b6af5e47c0 ]---
[Wed Sep 22 05:14:38 2021] ixgbe 0000:01:00.0 enp1s0: NIC Link is Up
10 Gbps, Flow Control: RX/TX

Justin.
