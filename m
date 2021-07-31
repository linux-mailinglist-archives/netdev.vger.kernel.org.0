Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7DAB3DC7F2
	for <lists+netdev@lfdr.de>; Sat, 31 Jul 2021 21:21:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229921AbhGaTVQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Jul 2021 15:21:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbhGaTVN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Jul 2021 15:21:13 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BDABC06175F;
        Sat, 31 Jul 2021 12:21:06 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id a93so3682887ybi.1;
        Sat, 31 Jul 2021 12:21:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=Ttmp4OOivBp9bZS6fgEbUJots40VMuPaq88U+9EAs3A=;
        b=vOX4n3f6QnsgC49BrfeAX587TM0A1e0Q+AYDW+MWGOTO9fWVRw0ZpONxeHDlgoL10n
         +xz/sYau3MVtrpB5eFInQsPNcwIXZy9BYGexD4/lASpJH6BBsU/zM33wNaQfrDG9XUBV
         M3C6Boe14r3y4CmYO6IvAfK83o/7xId7JtJG6b7Xb2wHxE5QHOX1oyCGCf5vy33QxCjM
         SZ8KRHlojJaxTDWY2ff0XFoI3uNEdDxovayAPqh8ybcpv3Gsfu7NLcDC9q8vF4FiiBfd
         KtQW+819FR7KkjwZKWrFFUrs/EVzSLifjSEGaFabJLug3lZCvuNoOwasEzkDXEngN6vH
         d+3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=Ttmp4OOivBp9bZS6fgEbUJots40VMuPaq88U+9EAs3A=;
        b=QdkqhlHZX5TQb42o85UqsiJwTQ5Fbf1qk0MQQX+oOtBTvfuQdSGK6I4QcnBz542vBj
         vp3OHsYaFX0ZuO3qJ0yblgYCaetkOpJR5gv0CyVCKi0O75WQgvcTLWREGaBXn0vQPz3S
         2PIu2CL0FLApZ/ZaTuKtrwhOoseMATPaTjtnw0s816uB5kztV30LjdBmN01+YPaP2Syo
         DBft67Yuquxu5KLlNe0xz98M9gql6Iavc+N/47bgEVAD0YlA4x3nFUvkKZqaxq9M+a5U
         Z8GY2ZlovOxXC7KCw0R8/rvJf5eKwBDh2zw1W5KKKbSwilUeBCQP9A2mTO/kHlpEqhi+
         lUhA==
X-Gm-Message-State: AOAM533CBu3mVHLD3heQ8hvsR7AWfvpya0z6bMn4LRahfLxAF3OE8U93
        7qvtTrysBBUmH+pprMFDKGJDwl2E4yrDHR6klrY=
X-Google-Smtp-Source: ABdhPJy9flxen+DNARdl8/1fuH8F9zg0Y9LdQ2nHrtYa+MtwS/YZKblzMVgYWnc75rz8iFATSxS+2NzoNxJ62+nn3aU=
X-Received: by 2002:a25:bc02:: with SMTP id i2mr10281079ybh.98.1627759265293;
 Sat, 31 Jul 2021 12:21:05 -0700 (PDT)
MIME-Version: 1.0
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Date:   Sat, 31 Jul 2021 20:20:29 +0100
Message-ID: <CADVatmPShADZ0F133eS3KjeKj1ZjTNAQfy_QOoJVBan02wuR+Q@mail.gmail.com>
Subject: memory leak in do_seccomp
To:     Kees Cook <keescook@chromium.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Will Drewry <wad@chromium.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi All,

We had been running syzkaller on v5.10.y and a "memory leak in
do_seccomp" was being reported on it. I got some time to check that
today and have managed to get a syzkaller
reproducer. I dont have a C reproducer which I can share but I can use
the syz-reproducer to reproduce this with next-20210730.
The old report on v5.10.y is at
https://elisa-builder-00.iol.unh.edu/syzkaller/report?id=f6ddd3b592f00e95f9cbd2e74f70a5b04b015c6f

BUG: memory leak
unreferenced object 0xffff888019282c00 (size 512):
  comm "syz-executor.1", pid 7389, jiffies 4294761829 (age 17.841s)
  hex dump (first 32 bytes):
    01 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<00000000762c0963>] do_seccomp+0x2d5/0x27d0
    [<0000000006e512d1>] do_syscall_64+0x3b/0x90
    [<0000000094ae9ff8>] entry_SYSCALL_64_after_hwframe+0x44/0xae

BUG: memory leak
unreferenced object 0xffffc900006b5000 (size 4096):
  comm "syz-executor.1", pid 7389, jiffies 4294761829 (age 17.841s)
  hex dump (first 32 bytes):
    01 00 00 00 00 00 00 00 00 00 00 00 05 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<00000000854901e5>] __vmalloc_node_range+0x550/0x9a0
    [<000000002686628f>] __vmalloc_node+0xb5/0x100
    [<0000000004cbd298>] bpf_prog_alloc_no_stats+0x38/0x350
    [<0000000009149728>] bpf_prog_alloc+0x24/0x170
    [<000000000fe7f1e7>] bpf_prog_create_from_user+0xad/0x2e0
    [<000000000c70eb02>] do_seccomp+0x325/0x27d0
    [<0000000006e512d1>] do_syscall_64+0x3b/0x90
    [<0000000094ae9ff8>] entry_SYSCALL_64_after_hwframe+0x44/0xae

BUG: memory leak
unreferenced object 0xffff888026eb1000 (size 2048):
  comm "syz-executor.1", pid 7389, jiffies 4294761829 (age 17.842s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<0000000072de7240>] bpf_prog_alloc_no_stats+0xeb/0x350
    [<0000000009149728>] bpf_prog_alloc+0x24/0x170
    [<000000000fe7f1e7>] bpf_prog_create_from_user+0xad/0x2e0
    [<000000000c70eb02>] do_seccomp+0x325/0x27d0
    [<0000000006e512d1>] do_syscall_64+0x3b/0x90
    [<0000000094ae9ff8>] entry_SYSCALL_64_after_hwframe+0x44/0xae

BUG: memory leak
unreferenced object 0xffff888014dddac0 (size 16):
  comm "syz-executor.1", pid 7389, jiffies 4294761829 (age 17.842s)
  hex dump (first 16 bytes):
    01 00 ca 08 80 88 ff ff c8 ef df 14 80 88 ff ff  ................
  backtrace:
    [<00000000c5d4ed93>] bpf_prog_store_orig_filter+0x7b/0x1e0
    [<000000007cb21c2a>] bpf_prog_create_from_user+0x1c6/0x2e0
    [<000000000c70eb02>] do_seccomp+0x325/0x27d0
    [<0000000006e512d1>] do_syscall_64+0x3b/0x90
    [<0000000094ae9ff8>] entry_SYSCALL_64_after_hwframe+0x44/0xae

BUG: memory leak
unreferenced object 0xffff888014dfefc8 (size 8):
  comm "syz-executor.1", pid 7389, jiffies 4294761829 (age 17.842s)
  hex dump (first 8 bytes):
    06 00 00 00 ff ff ff 7f                          ........
  backtrace:
    [<00000000ee5550f8>] kmemdup+0x23/0x50
    [<00000000f1acd067>] bpf_prog_store_orig_filter+0x103/0x1e0
    [<000000007cb21c2a>] bpf_prog_create_from_user+0x1c6/0x2e0
    [<000000000c70eb02>] do_seccomp+0x325/0x27d0
    [<0000000006e512d1>] do_syscall_64+0x3b/0x90
    [<0000000094ae9ff8>] entry_SYSCALL_64_after_hwframe+0x44/0xae

Not sure if this has been already reported or not, but I will be happy
to test if you have a fix for this.


-- 
Regards
Sudip
