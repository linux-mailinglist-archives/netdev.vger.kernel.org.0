Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2157B3A8AA8
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 23:08:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231321AbhFOVKf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 17:10:35 -0400
Received: from www62.your-server.de ([213.133.104.62]:50068 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231284AbhFOVKd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 17:10:33 -0400
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1ltGIF-0004xO-Nz; Tue, 15 Jun 2021 23:08:19 +0200
Received: from [85.7.101.30] (helo=linux-3.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1ltGIF-000CCY-9W; Tue, 15 Jun 2021 23:08:19 +0200
Subject: Re: [PATCH v5] bpf: core: fix shift-out-of-bounds in ___bpf_prog_run
To:     Eric Biggers <ebiggers@kernel.org>,
        Edward Cree <ecree.xilinx@gmail.com>
Cc:     Kurt Manucredo <fuzzybritches0@gmail.com>,
        syzbot+bed360704c521841c85d@syzkaller.appspotmail.com,
        keescook@chromium.org, yhs@fb.com, dvyukov@google.com,
        andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        davem@davemloft.net, hawk@kernel.org, john.fastabend@gmail.com,
        kafai@fb.com, kpsingh@kernel.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com,
        nathan@kernel.org, ndesaulniers@google.com,
        clang-built-linux@googlegroups.com,
        kernel-hardening@lists.openwall.com, kasan-dev@googlegroups.com
References: <CAADnVQKexxZQw0yK_7rmFOdaYabaFpi2EmF6RGs5bXvFHtUQaA@mail.gmail.com>
 <CACT4Y+b=si6NCx=nRHKm_pziXnVMmLo-eSuRajsxmx5+Hy_ycg@mail.gmail.com>
 <202106091119.84A88B6FE7@keescook>
 <752cb1ad-a0b1-92b7-4c49-bbb42fdecdbe@fb.com>
 <CACT4Y+a592rxFmNgJgk2zwqBE8EqW1ey9SjF_-U3z6gt3Yc=oA@mail.gmail.com>
 <1aaa2408-94b9-a1e6-beff-7523b66fe73d@fb.com> <202106101002.DF8C7EF@keescook>
 <CAADnVQKMwKYgthoQV4RmGpZm9Hm-=wH3DoaNqs=UZRmJKefwGw@mail.gmail.com>
 <85536-177443-curtm@phaethon>
 <bac16d8d-c174-bdc4-91bd-bfa62b410190@gmail.com> <YMkAbNQiIBbhD7+P@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <dbcfb2d3-0054-3ee6-6e76-5bd78023a4f2@iogearbox.net>
Date:   Tue, 15 Jun 2021 23:08:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <YMkAbNQiIBbhD7+P@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.2/26202/Tue Jun 15 13:21:24 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/15/21 9:33 PM, Eric Biggers wrote:
> On Tue, Jun 15, 2021 at 07:51:07PM +0100, Edward Cree wrote:
>>
>> As I understand it, the UBSAN report is coming from the eBPF interpreter,
>>   which is the *slow path* and indeed on many production systems is
>>   compiled out for hardening reasons (CONFIG_BPF_JIT_ALWAYS_ON).
>> Perhaps a better approach to the fix would be to change the interpreter
>>   to compute "DST = DST << (SRC & 63);" (and similar for other shifts and
>>   bitnesses), thus matching the behaviour of most chips' shift opcodes.
>> This would shut up UBSAN, without affecting JIT code generation.
> 
> Yes, I suggested that last week
> (https://lkml.kernel.org/netdev/YMJvbGEz0xu9JU9D@gmail.com).  The AND will even
> get optimized out when compiling for most CPUs.

Did you check if the generated interpreter code for e.g. x86 is the same
before/after with that?

How does UBSAN detect this in general? I would assume generated code for
interpreter wrt DST = DST << SRC would not really change as otherwise all
valid cases would be broken as well, given compiler has not really room
to optimize or make any assumptions here, in other words, it's only
propagating potential quirks under such cases from underlying arch.

Thanks,
Daniel
