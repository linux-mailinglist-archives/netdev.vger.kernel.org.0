Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D69B932130E
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 10:28:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230206AbhBVJ0K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 04:26:10 -0500
Received: from mail-il1-f200.google.com ([209.85.166.200]:49500 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230189AbhBVJ0B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Feb 2021 04:26:01 -0500
Received: by mail-il1-f200.google.com with SMTP id q3so7179807ilv.16
        for <netdev@vger.kernel.org>; Mon, 22 Feb 2021 01:25:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=Zz2GXCbmKae7xI90H336tDtP8OczeNW1sDftu5vODDk=;
        b=BHhFlim4VQTKTbkpdSObvSKalb6oa059B1neFWgHh+EQMCNm0wLWijqnHvMQ2LK2YS
         x2PPBvsr6l9fzDOypJWwBjqNgZUEneiqlTbOmGmfFQgW9IDxqtOaVe3yANmPNd5U+fGq
         bwR7wJgxiEm5URTclFNF9i8xHVz8SKrNBrD7k+l/rnT+dSIh/+DW4TUP5YCftZXeJKu2
         RyfY4DkCwc2cZVNfIEGpbU7CxSnrv4gcgs/5M/Df9WA/FuTMCu/NmMMcyMx+g9sEmYw7
         CE5o440YvyE4MgNqO0klvgkEwdBKL0hEddKC1fq7q3YhLdmKLRsQuPRDtg73vh2W8KBR
         y8xw==
X-Gm-Message-State: AOAM532J7tQ3YLjq4ZQPOXAtyT4fKUpXe85qibBGRUiFHU7v+nBDhQck
        DkB+UHThw0dgVDere/Xo3m3tdJN1b2yTSf8w5J4hSoy095l8
X-Google-Smtp-Source: ABdhPJy/1xm26koxC+KDq53n1b8fthiDxlK3DOAR5PNh77nUGy6nSHivli3RQ1Ga0dW7+wfoDzCSth6su6DhTGq+cdCP+QQtKHvR
MIME-Version: 1.0
X-Received: by 2002:a05:6638:22c5:: with SMTP id j5mr21773627jat.89.1613985920017;
 Mon, 22 Feb 2021 01:25:20 -0800 (PST)
Date:   Mon, 22 Feb 2021 01:25:20 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000006f6d4205bbe96159@google.com>
Subject: memory leak in do_seccomp (2)
From:   syzbot <syzbot+ab17848fe269b573eb71@syzkaller.appspotmail.com>
To:     andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, john.fastabend@gmail.com, kafai@fb.com,
        keescook@chromium.org, kpsingh@kernel.org,
        linux-kernel@vger.kernel.org, luto@amacapital.net,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, wad@chromium.org, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    f40ddce8 Linux 5.11
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=13aa6d22d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5528e8db7fc481ae
dashboard link: https://syzkaller.appspot.com/bug?extid=ab17848fe269b573eb71
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1255579cd00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=121a374ad00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+ab17848fe269b573eb71@syzkaller.appspotmail.com

BUG: memory leak
unreferenced object 0xffff888118765f00 (size 256):
  comm "syz-executor670", pid 10148, jiffies 4294952981 (age 25.900s)
  hex dump (first 32 bytes):
    01 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<0000000021396b5e>] kmalloc include/linux/slab.h:552 [inline]
    [<0000000021396b5e>] kzalloc include/linux/slab.h:682 [inline]
    [<0000000021396b5e>] seccomp_prepare_filter kernel/seccomp.c:656 [inline]
    [<0000000021396b5e>] seccomp_prepare_user_filter kernel/seccomp.c:698 [inline]
    [<0000000021396b5e>] seccomp_set_mode_filter kernel/seccomp.c:1802 [inline]
    [<0000000021396b5e>] do_seccomp+0x3d2/0x11c0 kernel/seccomp.c:1922
    [<000000004b7de4b6>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<000000003adb0cc6>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffffc90000ebf000 (size 4096):
  comm "syz-executor670", pid 10148, jiffies 4294952981 (age 25.900s)
  hex dump (first 32 bytes):
    01 00 03 00 00 00 00 00 00 00 00 00 05 00 00 00  ................
    1e 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<00000000cbd981b5>] __vmalloc_node_range+0x3a5/0x410 mm/vmalloc.c:2587
    [<000000003278951f>] __vmalloc_node mm/vmalloc.c:2619 [inline]
    [<000000003278951f>] __vmalloc+0x49/0x50 mm/vmalloc.c:2633
    [<00000000cc2e0bf4>] bpf_prog_alloc_no_stats+0x32/0x160 kernel/bpf/core.c:85
    [<00000000b872251d>] bpf_prog_alloc+0x24/0xc0 kernel/bpf/core.c:113
    [<00000000bf2ace46>] bpf_prog_create_from_user+0x6e/0x2b0 net/core/filter.c:1413
    [<00000000e9cc9030>] seccomp_prepare_filter kernel/seccomp.c:661 [inline]
    [<00000000e9cc9030>] seccomp_prepare_user_filter kernel/seccomp.c:698 [inline]
    [<00000000e9cc9030>] seccomp_set_mode_filter kernel/seccomp.c:1802 [inline]
    [<00000000e9cc9030>] do_seccomp+0x41c/0x11c0 kernel/seccomp.c:1922
    [<000000004b7de4b6>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<000000003adb0cc6>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff888117212800 (size 1024):
  comm "syz-executor670", pid 10148, jiffies 4294952981 (age 25.900s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<000000003fd1055c>] kmalloc include/linux/slab.h:552 [inline]
    [<000000003fd1055c>] kzalloc include/linux/slab.h:682 [inline]
    [<000000003fd1055c>] bpf_prog_alloc_no_stats+0x7d/0x160 kernel/bpf/core.c:89
    [<00000000b872251d>] bpf_prog_alloc+0x24/0xc0 kernel/bpf/core.c:113
    [<00000000bf2ace46>] bpf_prog_create_from_user+0x6e/0x2b0 net/core/filter.c:1413
    [<00000000e9cc9030>] seccomp_prepare_filter kernel/seccomp.c:661 [inline]
    [<00000000e9cc9030>] seccomp_prepare_user_filter kernel/seccomp.c:698 [inline]
    [<00000000e9cc9030>] seccomp_set_mode_filter kernel/seccomp.c:1802 [inline]
    [<00000000e9cc9030>] do_seccomp+0x41c/0x11c0 kernel/seccomp.c:1922
    [<000000004b7de4b6>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<000000003adb0cc6>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff8881186046e0 (size 32):
  comm "syz-executor670", pid 10148, jiffies 4294952981 (age 25.900s)
  hex dump (first 32 bytes):
    01 00 00 00 00 00 00 00 a0 55 77 18 81 88 ff ff  .........Uw.....
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<000000002f7bb5fc>] kmalloc include/linux/slab.h:552 [inline]
    [<000000002f7bb5fc>] bpf_prog_store_orig_filter+0x33/0xa0 net/core/filter.c:1135
    [<00000000b2023fc7>] bpf_prog_create_from_user+0xfe/0x2b0 net/core/filter.c:1426
    [<00000000e9cc9030>] seccomp_prepare_filter kernel/seccomp.c:661 [inline]
    [<00000000e9cc9030>] seccomp_prepare_user_filter kernel/seccomp.c:698 [inline]
    [<00000000e9cc9030>] seccomp_set_mode_filter kernel/seccomp.c:1802 [inline]
    [<00000000e9cc9030>] do_seccomp+0x41c/0x11c0 kernel/seccomp.c:1922
    [<000000004b7de4b6>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<000000003adb0cc6>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff8881187755a0 (size 32):
  comm "syz-executor670", pid 10148, jiffies 4294952981 (age 25.900s)
  hex dump (first 32 bytes):
    06 00 00 00 ff ff ff 7f 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<000000002ba3f45d>] kmemdup+0x23/0x50 mm/util.c:128
    [<000000001aee1a49>] kmemdup include/linux/string.h:520 [inline]
    [<000000001aee1a49>] bpf_prog_store_orig_filter+0x5e/0xa0 net/core/filter.c:1142
    [<00000000b2023fc7>] bpf_prog_create_from_user+0xfe/0x2b0 net/core/filter.c:1426
    [<00000000e9cc9030>] seccomp_prepare_filter kernel/seccomp.c:661 [inline]
    [<00000000e9cc9030>] seccomp_prepare_user_filter kernel/seccomp.c:698 [inline]
    [<00000000e9cc9030>] seccomp_set_mode_filter kernel/seccomp.c:1802 [inline]
    [<00000000e9cc9030>] do_seccomp+0x41c/0x11c0 kernel/seccomp.c:1922
    [<000000004b7de4b6>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<000000003adb0cc6>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffffffffa0050000 (size 4096):
  comm "syz-executor670", pid 10148, jiffies 4294952981 (age 25.900s)
  hex dump (first 32 bytes):
    01 00 00 00 cc cc cc cc cc cc cc cc cc cc cc cc  ................
    cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc  ................
  backtrace:
    [<00000000cbd981b5>] __vmalloc_node_range+0x3a5/0x410 mm/vmalloc.c:2587
    [<00000000c67b690b>] module_alloc+0x4f/0x60 arch/x86/kernel/module.c:75
    [<00000000ee2a4550>] bpf_jit_binary_alloc+0xb9/0x180 kernel/bpf/core.c:868
    [<00000000c863a6a8>] bpf_int_jit_compile+0x1bb/0x6c0 arch/x86/net/bpf_jit_comp.c:2075
    [<00000000b342f60a>] bpf_prog_select_runtime+0x244/0x390 kernel/bpf/core.c:1809
    [<000000005f5008b0>] bpf_migrate_filter+0x188/0x1f0 net/core/filter.c:1294
    [<00000000fea53340>] bpf_prepare_filter net/core/filter.c:1342 [inline]
    [<00000000fea53340>] bpf_prog_create_from_user+0x24d/0x2b0 net/core/filter.c:1436
    [<00000000e9cc9030>] seccomp_prepare_filter kernel/seccomp.c:661 [inline]
    [<00000000e9cc9030>] seccomp_prepare_user_filter kernel/seccomp.c:698 [inline]
    [<00000000e9cc9030>] seccomp_set_mode_filter kernel/seccomp.c:1802 [inline]
    [<00000000e9cc9030>] do_seccomp+0x41c/0x11c0 kernel/seccomp.c:1922
    [<000000004b7de4b6>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<000000003adb0cc6>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff888118765f00 (size 256):
  comm "syz-executor670", pid 10148, jiffies 4294952981 (age 28.740s)
  hex dump (first 32 bytes):
    01 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<0000000021396b5e>] kmalloc include/linux/slab.h:552 [inline]
    [<0000000021396b5e>] kzalloc include/linux/slab.h:682 [inline]
    [<0000000021396b5e>] seccomp_prepare_filter kernel/seccomp.c:656 [inline]
    [<0000000021396b5e>] seccomp_prepare_user_filter kernel/seccomp.c:698 [inline]
    [<0000000021396b5e>] seccomp_set_mode_filter kernel/seccomp.c:1802 [inline]
    [<0000000021396b5e>] do_seccomp+0x3d2/0x11c0 kernel/seccomp.c:1922
    [<000000004b7de4b6>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<000000003adb0cc6>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffffc90000ebf000 (size 4096):
  comm "syz-executor670", pid 10148, jiffies 4294952981 (age 28.740s)
  hex dump (first 32 bytes):
    01 00 03 00 00 00 00 00 00 00 00 00 05 00 00 00  ................
    1e 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<00000000cbd981b5>] __vmalloc_node_range+0x3a5/0x410 mm/vmalloc.c:2587
    [<000000003278951f>] __vmalloc_node mm/vmalloc.c:2619 [inline]
    [<000000003278951f>] __vmalloc+0x49/0x50 mm/vmalloc.c:2633
    [<00000000cc2e0bf4>] bpf_prog_alloc_no_stats+0x32/0x160 kernel/bpf/core.c:85
    [<00000000b872251d>] bpf_prog_alloc+0x24/0xc0 kernel/bpf/core.c:113
    [<00000000bf2ace46>] bpf_prog_create_from_user+0x6e/0x2b0 net/core/filter.c:1413
    [<00000000e9cc9030>] seccomp_prepare_filter kernel/seccomp.c:661 [inline]
    [<00000000e9cc9030>] seccomp_prepare_user_filter kernel/seccomp.c:698 [inline]
    [<00000000e9cc9030>] seccomp_set_mode_filter kernel/seccomp.c:1802 [inline]
    [<00000000e9cc9030>] do_seccomp+0x41c/0x11c0 kernel/seccomp.c:1922
    [<000000004b7de4b6>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<000000003adb0cc6>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff888117212800 (size 1024):
  comm "syz-executor670", pid 10148, jiffies 4294952981 (age 28.740s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<000000003fd1055c>] kmalloc include/linux/slab.h:552 [inline]
    [<000000003fd1055c>] kzalloc include/linux/slab.h:682 [inline]
    [<000000003fd1055c>] bpf_prog_alloc_no_stats+0x7d/0x160 kernel/bpf/core.c:89
    [<00000000b872251d>] bpf_prog_alloc+0x24/0xc0 kernel/bpf/core.c:113
    [<00000000bf2ace46>] bpf_prog_create_from_user+0x6e/0x2b0 net/core/filter.c:1413
    [<00000000e9cc9030>] seccomp_prepare_filter kernel/seccomp.c:661 [inline]
    [<00000000e9cc9030>] seccomp_prepare_user_filter kernel/seccomp.c:698 [inline]
    [<00000000e9cc9030>] seccomp_set_mode_filter kernel/seccomp.c:1802 [inline]
    [<00000000e9cc9030>] do_seccomp+0x41c/0x11c0 kernel/seccomp.c:1922
    [<000000004b7de4b6>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<000000003adb0cc6>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff8881186046e0 (size 32):
  comm "syz-executor670", pid 10148, jiffies 4294952981 (age 28.740s)
  hex dump (first 32 bytes):
    01 00 00 00 00 00 00 00 a0 55 77 18 81 88 ff ff  .........Uw.....
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<000000002f7bb5fc>] kmalloc include/linux/slab.h:552 [inline]
    [<000000002f7bb5fc>] bpf_prog_store_orig_filter+0x33/0xa0 net/core/filter.c:1135
    [<00000000b2023fc7>] bpf_prog_create_from_user+0xfe/0x2b0 net/core/filter.c:1426
    [<00000000e9cc9030>] seccomp_prepare_filter kernel/seccomp.c:661 [inline]
    [<00000000e9cc9030>] seccomp_prepare_user_filter kernel/seccomp.c:698 [inline]
    [<00000000e9cc9030>] seccomp_set_mode_filter kernel/seccomp.c:1802 [inline]
    [<00000000e9cc9030>] do_seccomp+0x41c/0x11c0 kernel/seccomp.c:1922
    [<000000004b7de4b6>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<000000003adb0cc6>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff8881187755a0 (size 32):
  comm "syz-executor670", pid 10148, jiffies 4294952981 (age 28.740s)
  hex dump (first 32 bytes):
    06 00 00 00 ff ff ff 7f 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<000000002ba3f45d>] kmemdup+0x23/0x50 mm/util.c:128
    [<000000001aee1a49>] kmemdup include/linux/string.h:520 [inline]
    [<000000001aee1a49>] bpf_prog_store_orig_filter+0x5e/0xa0 net/core/filter.c:1142
    [<00000000b2023fc7>] bpf_prog_create_from_user+0xfe/0x2b0 net/core/filter.c:1426
    [<00000000e9cc9030>] seccomp_prepare_filter kernel/seccomp.c:661 [inline]
    [<00000000e9cc9030>] seccomp_prepare_user_filter kernel/seccomp.c:698 [inline]
    [<00000000e9cc9030>] seccomp_set_mode_filter kernel/seccomp.c:1802 [inline]
    [<00000000e9cc9030>] do_seccomp+0x41c/0x11c0 kernel/seccomp.c:1922
    [<000000004b7de4b6>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<000000003adb0cc6>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffffffffa0050000 (size 4096):
  comm "syz-executor670", pid 10148, jiffies 4294952981 (age 28.740s)
  hex dump (first 32 bytes):
    01 00 00 00 cc cc cc cc cc cc cc cc cc cc cc cc  ................
    cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc  ................
  backtrace:
    [<00000000cbd981b5>] __vmalloc_node_range+0x3a5/0x410 mm/vmalloc.c:2587
    [<00000000c67b690b>] module_alloc+0x4f/0x60 arch/x86/kernel/module.c:75
    [<00000000ee2a4550>] bpf_jit_binary_alloc+0xb9/0x180 kernel/bpf/core.c:868
    [<00000000c863a6a8>] bpf_int_jit_compile+0x1bb/0x6c0 arch/x86/net/bpf_jit_comp.c:2075
    [<00000000b342f60a>] bpf_prog_select_runtime+0x244/0x390 kernel/bpf/core.c:1809
    [<000000005f5008b0>] bpf_migrate_filter+0x188/0x1f0 net/core/filter.c:1294
    [<00000000fea53340>] bpf_prepare_filter net/core/filter.c:1342 [inline]
    [<00000000fea53340>] bpf_prog_create_from_user+0x24d/0x2b0 net/core/filter.c:1436
    [<00000000e9cc9030>] seccomp_prepare_filter kernel/seccomp.c:661 [inline]
    [<00000000e9cc9030>] seccomp_prepare_user_filter kernel/seccomp.c:698 [inline]
    [<00000000e9cc9030>] seccomp_set_mode_filter kernel/seccomp.c:1802 [inline]
    [<00000000e9cc9030>] do_seccomp+0x41c/0x11c0 kernel/seccomp.c:1922
    [<000000004b7de4b6>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<000000003adb0cc6>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff888118765f00 (size 256):
  comm "syz-executor670", pid 10148, jiffies 4294952981 (age 30.180s)
  hex dump (first 32 bytes):
    01 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<0000000021396b5e>] kmalloc include/linux/slab.h:552 [inline]
    [<0000000021396b5e>] kzalloc include/linux/slab.h:682 [inline]
    [<0000000021396b5e>] seccomp_prepare_filter kernel/seccomp.c:656 [inline]
    [<0000000021396b5e>] seccomp_prepare_user_filter kernel/seccomp.c:698 [inline]
    [<0000000021396b5e>] seccomp_set_mode_filter kernel/seccomp.c:1802 [inline]
    [<0000000021396b5e>] do_seccomp+0x3d2/0x11c0 kernel/seccomp.c:1922
    [<000000004b7de4b6>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<000000003adb0cc6>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffffc90000ebf000 (size 4096):
  comm "syz-executor670", pid 10148, jiffies 4294952981 (age 30.180s)
  hex dump (first 32 bytes):
    01 00 03 00 00 00 00 00 00 00 00 00 05 00 00 00  ................
    1e 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<00000000cbd981b5>] __vmalloc_node_range+0x3a5/0x410 mm/vmalloc.c:2587
    [<000000003278951f>] __vmalloc_node mm/vmalloc.c:2619 [inline]
    [<000000003278951f>] __vmalloc+0x49/0x50 mm/vmalloc.c:2633
    [<00000000cc2e0bf4>] bpf_prog_alloc_no_stats+0x32/0x160 kernel/bpf/core.c:85
    [<00000000b872251d>] bpf_prog_alloc+0x24/0xc0 kernel/bpf/core.c:113
    [<00000000bf2ace46>] bpf_prog_create_from_user+0x6e/0x2b0 net/core/filter.c:1413
    [<00000000e9cc9030>] seccomp_prepare_filter kernel/seccomp.c:661 [inline]
    [<00000000e9cc9030>] seccomp_prepare_user_filter kernel/seccomp.c:698 [inline]
    [<00000000e9cc9030>] seccomp_set_mode_filter kernel/seccomp.c:1802 [inline]
    [<00000000e9cc9030>] do_seccomp+0x41c/0x11c0 kernel/seccomp.c:1922
    [<000000004b7de4b6>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<000000003adb0cc6>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff888117212800 (size 1024):
  comm "syz-executor670", pid 10148, jiffies 4294952981 (age 30.180s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<000000003fd1055c>] kmalloc include/linux/slab.h:552 [inline]
    [<000000003fd1055c>] kzalloc include/linux/slab.h:682 [inline]
    [<000000003fd1055c>] bpf_prog_alloc_no_stats+0x7d/0x160 kernel/bpf/core.c:89
    [<00000000b872251d>] bpf_prog_alloc+0x24/0xc0 kernel/bpf/core.c:113
    [<00000000bf2ace46>] bpf_prog_create_from_user+0x6e/0x2b0 net/core/filter.c:1413
    [<00000000e9cc9030>] seccomp_prepare_filter kernel/seccomp.c:661 [inline]
    [<00000000e9cc9030>] seccomp_prepare_user_filter kernel/seccomp.c:698 [inline]
    [<00000000e9cc9030>] seccomp_set_mode_filter kernel/seccomp.c:1802 [inline]
    [<00000000e9cc9030>] do_seccomp+0x41c/0x11c0 kernel/seccomp.c:1922
    [<000000004b7de4b6>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<000000003adb0cc6>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff8881186046e0 (size 32):
  comm "syz-executor670", pid 10148, jiffies 4294952981 (age 30.180s)
  hex dump (first 32 bytes):
    01 00 00 00 00 00 00 00 a0 55 77 18 81 88 ff ff  .........Uw.....
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<000000002f7bb5fc>] kmalloc include/linux/slab.h:552 [inline]
    [<000000002f7bb5fc>] bpf_prog_store_orig_filter+0x33/0xa0 net/core/filter.c:1135
    [<00000000b2023fc7>] bpf_prog_create_from_user+0xfe/0x2b0 net/core/filter.c:1426
    [<00000000e9cc9030>] seccomp_prepare_filter kernel/seccomp.c:661 [inline]
    [<00000000e9cc9030>] seccomp_prepare_user_filter kernel/seccomp.c:698 [inline]
    [<00000000e9cc9030>] seccomp_set_mode_filter kernel/seccomp.c:1802 [inline]
    [<00000000e9cc9030>] do_seccomp+0x41c/0x11c0 kernel/seccomp.c:1922
    [<000000004b7de4b6>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<000000003adb0cc6>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff8881187755a0 (size 32):
  comm "syz-executor670", pid 10148, jiffies 4294952981 (age 30.180s)
  hex dump (first 32 bytes):
    06 00 00 00 ff ff ff 7f 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<000000002ba3f45d>] kmemdup+0x23/0x50 mm/util.c:128
    [<000000001aee1a49>] kmemdup include/linux/string.h:520 [inline]
    [<000000001aee1a49>] bpf_prog_store_orig_filter+0x5e/0xa0 net/core/filter.c:1142
    [<00000000b2023fc7>] bpf_prog_create_from_user+0xfe/0x2b0 net/core/filter.c:1426
    [<00000000e9cc9030>] seccomp_prepare_filter kernel/seccomp.c:661 [inline]
    [<00000000e9cc9030>] seccomp_prepare_user_filter kernel/seccomp.c:698 [inline]
    [<00000000e9cc9030>] seccomp_set_mode_filter kernel/seccomp.c:1802 [inline]
    [<00000000e9cc9030>] do_seccomp+0x41c/0x11c0 kernel/seccomp.c:1922
    [<000000004b7de4b6>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<000000003adb0cc6>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffffffffa0050000 (size 4096):
  comm "syz-executor670", pid 10148, jiffies 4294952981 (age 30.180s)
  hex dump (first 32 bytes):
    01 00 00 00 cc cc cc cc cc cc cc cc cc cc cc cc  ................
    cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc  ................
  backtrace:
    [<00000000cbd981b5>] __vmalloc_node_range+0x3a5/0x410 mm/vmalloc.c:2587
    [<00000000c67b690b>] module_alloc+0x4f/0x60 arch/x86/kernel/module.c:75
    [<00000000ee2a4550>] bpf_jit_binary_alloc+0xb9/0x180 kernel/bpf/core.c:868
    [<00000000c863a6a8>] bpf_int_jit_compile+0x1bb/0x6c0 arch/x86/net/bpf_jit_comp.c:2075
    [<00000000b342f60a>] bpf_prog_select_runtime+0x244/0x390 kernel/bpf/core.c:1809
    [<000000005f5008b0>] bpf_migrate_filter+0x188/0x1f0 net/core/filter.c:1294
    [<00000000fea53340>] bpf_prepare_filter net/core/filter.c:1342 [inline]
    [<00000000fea53340>] bpf_prog_create_from_user+0x24d/0x2b0 net/core/filter.c:1436
    [<00000000e9cc9030>] seccomp_prepare_filter kernel/seccomp.c:661 [inline]
    [<00000000e9cc9030>] seccomp_prepare_user_filter kernel/seccomp.c:698 [inline]
    [<00000000e9cc9030>] seccomp_set_mode_filter kernel/seccomp.c:1802 [inline]
    [<00000000e9cc9030>] do_seccomp+0x41c/0x11c0 kernel/seccomp.c:1922
    [<000000004b7de4b6>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<000000003adb0cc6>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff888118765f00 (size 256):
  comm "syz-executor670", pid 10148, jiffies 4294952981 (age 31.620s)
  hex dump (first 32 bytes):
    01 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<0000000021396b5e>] kmalloc include/linux/slab.h:552 [inline]
    [<0000000021396b5e>] kzalloc include/linux/slab.h:682 [inline]
    [<0000000021396b5e>] seccomp_prepare_filter kernel/seccomp.c:656 [inline]
    [<0000000021396b5e>] seccomp_prepare_user_filter kernel/seccomp.c:698 [inline]
    [<0000000021396b5e>] seccomp_set_mode_filter kernel/seccomp.c:1802 [inline]
    [<0000000021396b5e>] do_seccomp+0x3d2/0x11c0 kernel/seccomp.c:1922
    [<000000004b7de4b6>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<000000003adb0cc6>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffffc90000ebf000 (size 4096):
  comm "syz-executor670", pid 10148, jiffies 4294952981 (age 31.620s)
  hex dump (first 32 bytes):
    01 00 03 00 00 00 00 00 00 00 00 00 05 00 00 00  ................
    1e 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<00000000cbd981b5>] __vmalloc_node_range+0x3a5/0x410 mm/vmalloc.c:2587
    [<000000003278951f>] __vmalloc_node mm/vmalloc.c:2619 [inline]
    [<000000003278951f>] __vmalloc+0x49/0x50 mm/vmalloc.c:2633
    [<00000000cc2e0bf4>] bpf_prog_alloc_no_stats+0x32/0x160 kernel/bpf/core.c:85
    [<00000000b872251d>] bpf_prog_alloc+0x24/0xc0 kernel/bpf/core.c:113
    [<00000000bf2ace46>] bpf_prog_create_from_user+0x6e/0x2b0 net/core/filter.c:1413
    [<00000000e9cc9030>] seccomp_prepare_filter kernel/seccomp.c:661 [inline]
    [<00000000e9cc9030>] seccomp_prepare_user_filter kernel/seccomp.c:698 [inline]
    [<00000000e9cc9030>] seccomp_set_mode_filter kernel/seccomp.c:1802 [inline]
    [<00000000e9cc9030>] do_seccomp+0x41c/0x11c0 kernel/seccomp.c:1922
    [<000000004b7de4b6>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<000000003adb0cc6>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff888117212800 (size 1024):
  comm "syz-executor670", pid 10148, jiffies 4294952981 (age 31.620s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<000000003fd1055c>] kmalloc include/linux/slab.h:552 [inline]
    [<000000003fd1055c>] kzalloc include/linux/slab.h:682 [inline]
    [<000000003fd1055c>] bpf_prog_alloc_no_stats+0x7d/0x160 kernel/bpf/core.c:89
    [<00000000b872251d>] bpf_prog_alloc+0x24/0xc0 kernel/bpf/core.c:113
    [<00000000bf2ace46>] bpf_prog_create_from_user+0x6e/0x2b0 net/core/filter.c:1413
    [<00000000e9cc9030>] seccomp_prepare_filter kernel/seccomp.c:661 [inline]
    [<00000000e9cc9030>] seccomp_prepare_user_filter kernel/seccomp.c:698 [inline]
    [<00000000e9cc9030>] seccomp_set_mode_filter kernel/seccomp.c:1802 [inline]
    [<00000000e9cc9030>] do_seccomp+0x41c/0x11c0 kernel/seccomp.c:1922
    [<000000004b7de4b6>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<000000003adb0cc6>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff8881186046e0 (size 32):
  comm "syz-executor670", pid 10148, jiffies 4294952981 (age 31.620s)
  hex dump (first 32 bytes):
    01 00 00 00 00 00 00 00 a0 55 77 18 81 88 ff ff  .........Uw.....
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<000000002f7bb5fc>] kmalloc include/linux/slab.h:552 [inline]
    [<000000002f7bb5fc>] bpf_prog_store_orig_filter+0x33/0xa0 net/core/filter.c:1135
    [<00000000b2023fc7>] bpf_prog_create_from_user+0xfe/0x2b0 net/core/filter.c:1426
    [<00000000e9cc9030>] seccomp_prepare_filter kernel/seccomp.c:661 [inline]
    [<00000000e9cc9030>] seccomp_prepare_user_filter kernel/seccomp.c:698 [inline]
    [<00000000e9cc9030>] seccomp_set_mode_filter kernel/seccomp.c:1802 [inline]
    [<00000000e9cc9030>] do_seccomp+0x41c/0x11c0 kernel/seccomp.c:1922
    [<000000004b7de4b6>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<000000003adb0cc6>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff8881187755a0 (size 32):
  comm "syz-executor670", pid 10148, jiffies 4294952981 (age 31.620s)
  hex dump (first 32 bytes):
    06 00 00 00 ff ff ff 7f 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<000000002ba3f45d>] kmemdup+0x23/0x50 mm/util.c:128
    [<000000001aee1a49>] kmemdup include/linux/string.h:520 [inline]
    [<000000001aee1a49>] bpf_prog_store_orig_filter+0x5e/0xa0 net/core/filter.c:1142
    [<00000000b2023fc7>] bpf_prog_create_from_user+0xfe/0x2b0 net/core/filter.c:1426
    [<00000000e9cc9030>] seccomp_prepare_filter kernel/seccomp.c:661 [inline]
    [<00000000e9cc9030>] seccomp_prepare_user_filter kernel/seccomp.c:698 [inline]
    [<00000000e9cc9030>] seccomp_set_mode_filter kernel/seccomp.c:1802 [inline]
    [<00000000e9cc9030>] do_seccomp+0x41c/0x11c0 kernel/seccomp.c:1922
    [<000000004b7de4b6>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<000000003adb0cc6>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffffffffa0050000 (size 4096):
  comm "syz-executor670", pid 10148, jiffies 4294952981 (age 31.620s)
  hex dump (first 32 bytes):
    01 00 00 00 cc cc cc cc cc cc cc cc cc cc cc cc  ................
    cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc  ................
  backtrace:
    [<00000000cbd981b5>] __vmalloc_node_range+0x3a5/0x410 mm/vmalloc.c:2587
    [<00000000c67b690b>] module_alloc+0x4f/0x60 arch/x86/kernel/module.c:75
    [<00000000ee2a4550>] bpf_jit_binary_alloc+0xb9/0x180 kernel/bpf/core.c:868
    [<00000000c863a6a8>] bpf_int_jit_compile+0x1bb/0x6c0 arch/x86/net/bpf_jit_comp.c:2075
    [<00000000b342f60a>] bpf_prog_select_runtime+0x244/0x390 kernel/bpf/core.c:1809
    [<000000005f5008b0>] bpf_migrate_filter+0x188/0x1f0 net/core/filter.c:1294
    [<00000000fea53340>] bpf_prepare_filter net/core/filter.c:1342 [inline]
    [<00000000fea53340>] bpf_prog_create_from_user+0x24d/0x2b0 net/core/filter.c:1436
    [<00000000e9cc9030>] seccomp_prepare_filter kernel/seccomp.c:661 [inline]
    [<00000000e9cc9030>] seccomp_prepare_user_filter kernel/seccomp.c:698 [inline]
    [<00000000e9cc9030>] seccomp_set_mode_filter kernel/seccomp.c:1802 [inline]
    [<00000000e9cc9030>] do_seccomp+0x41c/0x11c0 kernel/seccomp.c:1922
    [<000000004b7de4b6>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<000000003adb0cc6>] entry_SYSCALL_64_after_hwframe+0x44/0xa9



---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
