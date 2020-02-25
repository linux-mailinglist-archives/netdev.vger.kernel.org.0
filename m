Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3349916F255
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 22:58:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728978AbgBYV63 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 16:58:29 -0500
Received: from www62.your-server.de ([213.133.104.62]:54070 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726421AbgBYV63 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 16:58:29 -0500
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1j6iDi-0003cv-KN; Tue, 25 Feb 2020 22:58:26 +0100
Received: from [85.7.42.192] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1j6iDi-000JoD-Bn; Tue, 25 Feb 2020 22:58:26 +0100
Subject: Re: [PATCH v2 bpf-next] selftests/bpf: print backtrace on SIGSEGV in
 test_progs
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com
References: <20200225000847.3965188-1-andriin@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <f4ae621b-a783-1a77-3a06-b7eb5afdfc4e@iogearbox.net>
Date:   Tue, 25 Feb 2020 22:58:25 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200225000847.3965188-1-andriin@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25734/Tue Feb 25 15:06:17 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/25/20 1:08 AM, Andrii Nakryiko wrote:
> Due to various bugs in tests clean up code (usually), if host system is
> misconfigured, it happens that test_progs will just crash in the middle of
> running a test with little to no indication of where and why the crash
> happened. For cases where coredump is not readily available (e.g., inside
> a CI), it's very helpful to have a stack trace, which lead to crash, to be
> printed out. This change adds a signal handler that will capture and print out
> symbolized backtrace:
> 
>    $ sudo ./test_progs -t mmap
>    test_mmap:PASS:skel_open_and_load 0 nsec
>    test_mmap:PASS:bss_mmap 0 nsec
>    test_mmap:PASS:data_mmap 0 nsec
>    Caught signal #11!
>    Stack trace:
>    ./test_progs(crash_handler+0x18)[0x42a888]
>    /lib64/libpthread.so.0(+0xf5d0)[0x7f2aab5175d0]
>    ./test_progs(test_mmap+0x3c0)[0x41f0a0]
>    ./test_progs(main+0x160)[0x407d10]
>    /lib64/libc.so.6(__libc_start_main+0xf5)[0x7f2aab15d3d5]
>    ./test_progs[0x407ebc]
>    [1]    1988412 segmentation fault (core dumped)  sudo ./test_progs -t mmap
> 
> Unfortunately, glibc's symbolization support is unable to symbolize static
> functions, only global ones will be present in stack trace. But it's still a
> step forward without adding extra libraries to get a better symbolization.
> 
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Applied, thanks!
