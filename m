Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 568EE77D17
	for <lists+netdev@lfdr.de>; Sun, 28 Jul 2019 03:12:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388253AbfG1BMs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jul 2019 21:12:48 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:43158 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387841AbfG1BMs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jul 2019 21:12:48 -0400
Received: by mail-lj1-f194.google.com with SMTP id y17so30486416ljk.10;
        Sat, 27 Jul 2019 18:12:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HDEyW0lXYZwmkHfYIzu9aj/xkgFjzo3ZZTv9RaIiKcc=;
        b=MVAcW19SgGt3BHI0yqO+DljNmFbeYkQmDVNhJkOkckPliVwLv69Q/uOdx+l5kBw2ew
         AujvF60JV3awxDjwEExU2jt2JahaHhBs34K726sr213kqMPjGLSzLQnUz/XmHwPMvz4V
         8thk+P+5IdUbdBmlfdPK/+2nz0b2fzAhKseK8zI+1+Yjdd88VFvvhNVhvzcqi05zNGKi
         fxX216LUc+8Hc9ozaGu1W/5uvZG4N+EUiYlK9pHShIYK40m5jP14/R4mfG/HxYhlXhCr
         crFitc+GEtVITFVG9dKLN1cA1O4LQd+WlCSVudCb8Mssx+W5/lvWSSUPEFlq4JMKQ7u9
         y5PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HDEyW0lXYZwmkHfYIzu9aj/xkgFjzo3ZZTv9RaIiKcc=;
        b=K+oDRjZI8esq5o77bY2JJBBhTAwY5XmEG7hcafoRJapFEdzv1j6zyapn0shYJ3NsQe
         sBeqH+c1qFWQhEr91V47UzBKkb1ZlHINU9Tu7klSxgJWDhB+oUGhcPYZF4dGGyz+NuSz
         2zlvC33TMPZUb7LBJaKyDrPoKwshIav3CQ5GomeCXmy0ExiyBivA6C98FbcsXZI2gaMn
         6CbonnBnXvEOjbIsPSG327A1DvogD08M+dOKg134BfYCz3y+bTgTEFMbxKAUUjr0NkUm
         i9GmbAS6Qjlvv08i2ovpUFzh4k4kECqRR5czFfsmoaDmTuNHfqH78uz4nbO0C5RRCK5/
         XrTQ==
X-Gm-Message-State: APjAAAUjky+rxFGAm7KovPClgOVJIp542Y7AkzIkboo2mZahnxYVZbDG
        NEclaU3joZ4YvgFnadopTfMXAVdApI3eC38MTwk=
X-Google-Smtp-Source: APXvYqxPwzVGwS4uB9zij+/CCdUu4XnX8XXSJjvOKYDDe6X6L/WiEcf/POMdy/ZE3thrMclBQfJsg7wyo4OJjzuo1Z4=
X-Received: by 2002:a2e:a311:: with SMTP id l17mr52055237lje.214.1564276366094;
 Sat, 27 Jul 2019 18:12:46 -0700 (PDT)
MIME-Version: 1.0
References: <20190727190150.649137-1-andriin@fb.com>
In-Reply-To: <20190727190150.649137-1-andriin@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Sat, 27 Jul 2019 18:12:34 -0700
Message-ID: <CAADnVQJoS8Yjt-qFHg4XEkiF_3H8nRx15xZfJDSy8YcRT_UKrg@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 0/9] Revamp test_progs as a test running framework
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Stanislav Fomichev <sdf@fomichev.me>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 27, 2019 at 12:02 PM Andrii Nakryiko <andriin@fb.com> wrote:
>
> This patch set makes a number of changes to test_progs selftest, which is
> a collection of many other tests (and sometimes sub-tests as well), to provide
> better testing experience and allow to start convering many individual test
> programs under selftests/bpf into a single and convenient test runner.

I really like the patches, but something isn't right:
#16 raw_tp_writable_reject_nbd_invalid:OK
#17 raw_tp_writable_test_run:OK
#18 reference_tracking:OK
[   87.715996] test_progs[2200]: segfault at 2f ip 00007f56aeea347b sp
00007ffce9720980 error 4 in libc-2.23.so[7f56aee5b000+198000]
[   87.717316] Code: ff ff 44 89 8d 30 fb ff ff e8 01 74 fd ff 44 8b
8d 30 fb ff ff 4c 8b 85 28 fb ff ff e9 fd eb ff ff 31 c0 48 83 c9 ff
4c 89 df <f2> ae c7 85 28 fb ff ff 00 00 00 00 48 89 c8 48 f7 d0 4c 8f
[   87.719493] audit: type=1701 audit(1564276195.971:5): auid=0 uid=0
gid=0 ses=1 subj=kernel pid=2200 comm="test_progs"
exe="/data/users/ast/net-next/tools/testing/selftests/bpf/test_progs"
sig=11 res=1
Segmentation fault (core dumped)

Under gdb fault is different:
#23 stacktrace_build_id:OK
Detaching after fork from child process 2276.
Detaching after fork from child process 2278.
[  149.013116] perf: interrupt took too long (6799 > 6713), lowering
kernel.perf_event_max_sample_rate to 29000
[  149.014634] perf: interrupt took too long (8511 > 8498), lowering
kernel.perf_event_max_sample_rate to 23000
[  149.017038] perf: interrupt took too long (10649 > 10638), lowering
kernel.perf_event_max_sample_rate to 18000
[  149.021901] perf: interrupt took too long (13322 > 13311), lowering
kernel.perf_event_max_sample_rate to 15000
[  149.042946] perf: interrupt took too long (16660 > 16652), lowering
kernel.perf_event_max_sample_rate to 12000
Detaching after fork from child process 2279.
#24 stacktrace_build_id_nmi:OK
#25 stacktrace_map:OK
#26 stacktrace_map_raw_tp:OK

Program received signal SIGSEGV, Segmentation fault.
0x00007ffff723f47b in vfprintf () from /usr/lib/libc.so.6
(gdb) bt
#0  0x00007ffff723f47b in vfprintf () from /usr/lib/libc.so.6
#1  0x00007ffff72655a9 in vsnprintf () from /usr/lib/libc.so.6
#2  0x0000000000403100 in test__vprintf (fmt=0x426754 "%s:PASS:%s %d
nsec\n", args=0x7fffffffe878) at test_progs.c:114
#3  0x000000000040325c in test__printf (fmt=fmt@entry=0x426754
"%s:PASS:%s %d nsec\n") at test_progs.c:147
#4  0x000000000042222d in test_task_fd_query_rawtp () at
prog_tests/task_fd_query_rawtp.c:19
#5  0x0000000000402c76 in main (argc=<optimized out>, argv=<optimized
out>) at test_progs.c:501
(gdb) info threads
  Id   Target Id         Frame
* 1    Thread 0x7ffff7fea700 (LWP 2245) "test_progs"
0x00007ffff723f47b in vfprintf () from /usr/lib/libc.so.6
