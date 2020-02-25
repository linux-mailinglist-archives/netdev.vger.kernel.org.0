Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E379116B953
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 06:51:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726465AbgBYFv4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 00:51:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:38682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726019AbgBYFv4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Feb 2020 00:51:56 -0500
Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F9E6222C2;
        Tue, 25 Feb 2020 05:51:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582609915;
        bh=v6ipb68Urj4tjqGSvJRwViYPV6sz1GZOBDTa/NG2C28=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=RCgC517F/tDl8HzchtovG0IyS7Nk3uEleXIamg/+f7APRlKgK2HWMQte6IitNyXuO
         G/ZNEWdLEXWOpNE5lfww4MBcEogFxhIWCLnRqyXLs92ZLvYkfqFWu6bw85talsxu03
         yKTWXsdkBUzR5Kk3ipbZoPGjGC1OVtbTKWihjFP0=
Received: by mail-lj1-f175.google.com with SMTP id w1so12644853ljh.5;
        Mon, 24 Feb 2020 21:51:55 -0800 (PST)
X-Gm-Message-State: APjAAAW/pDnwBjR+h7wLo64TiuaHAZe4ncwcHBiP6rjE5JWUq4af0nfK
        /VXjLN+xTgVed2Pp6NHzJfE5sv+rBt/5TzfXYEA=
X-Google-Smtp-Source: APXvYqzti3alrQe5Eo9L6cr9m6xDBYdDv2k0isRnR3WckcGBkTaPG6SXhUNmGLd6W1z/++Gw+d3OYI9DbTCJNuATXrg=
X-Received: by 2002:a05:651c:239:: with SMTP id z25mr31241904ljn.48.1582609913515;
 Mon, 24 Feb 2020 21:51:53 -0800 (PST)
MIME-Version: 1.0
References: <20200225000847.3965188-1-andriin@fb.com>
In-Reply-To: <20200225000847.3965188-1-andriin@fb.com>
From:   Song Liu <song@kernel.org>
Date:   Mon, 24 Feb 2020 21:51:42 -0800
X-Gmail-Original-Message-ID: <CAPhsuW6xrw=5X-HzgQ++ZEJO-5VmbrzhEXvAOYnhc4bYG0B8PA@mail.gmail.com>
Message-ID: <CAPhsuW6xrw=5X-HzgQ++ZEJO-5VmbrzhEXvAOYnhc4bYG0B8PA@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next] selftests/bpf: print backtrace on SIGSEGV in test_progs
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 24, 2020 at 4:09 PM Andrii Nakryiko <andriin@fb.com> wrote:
>
> Due to various bugs in tests clean up code (usually), if host system is
> misconfigured, it happens that test_progs will just crash in the middle of
> running a test with little to no indication of where and why the crash
> happened. For cases where coredump is not readily available (e.g., inside
> a CI), it's very helpful to have a stack trace, which lead to crash, to be
> printed out. This change adds a signal handler that will capture and print out
> symbolized backtrace:
>
>   $ sudo ./test_progs -t mmap
>   test_mmap:PASS:skel_open_and_load 0 nsec
>   test_mmap:PASS:bss_mmap 0 nsec
>   test_mmap:PASS:data_mmap 0 nsec
>   Caught signal #11!
>   Stack trace:
>   ./test_progs(crash_handler+0x18)[0x42a888]
>   /lib64/libpthread.so.0(+0xf5d0)[0x7f2aab5175d0]
>   ./test_progs(test_mmap+0x3c0)[0x41f0a0]
>   ./test_progs(main+0x160)[0x407d10]
>   /lib64/libc.so.6(__libc_start_main+0xf5)[0x7f2aab15d3d5]
>   ./test_progs[0x407ebc]
>   [1]    1988412 segmentation fault (core dumped)  sudo ./test_progs -t mmap
>
> Unfortunately, glibc's symbolization support is unable to symbolize static
> functions, only global ones will be present in stack trace. But it's still a
> step forward without adding extra libraries to get a better symbolization.
>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Acked-by: Song Liu <songliubraving@fb.com>
