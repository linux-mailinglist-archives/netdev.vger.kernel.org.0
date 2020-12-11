Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E1202D7FC8
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 21:07:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390274AbgLKUGM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 15:06:12 -0500
Received: from www62.your-server.de ([213.133.104.62]:44502 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393916AbgLKUFw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 15:05:52 -0500
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1knof4-0005qA-CM; Fri, 11 Dec 2020 21:05:06 +0100
Received: from [85.7.101.30] (helo=pc-9.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1knof4-000WDG-60; Fri, 11 Dec 2020 21:05:06 +0100
Subject: Re: [PATCH] bpf,x64: pad NOPs to make images converge more easily
To:     Gary Lin <glin@suse.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        andreas.taschner@suse.com
References: <20201211081903.17857-1-glin@suse.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <61348cb4-6e61-6b76-28fa-1aff1c50912c@iogearbox.net>
Date:   Fri, 11 Dec 2020 21:05:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20201211081903.17857-1-glin@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/26014/Thu Dec 10 15:21:42 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/11/20 9:19 AM, Gary Lin wrote:
> The x64 bpf jit expects bpf images converge within the given passes, but
> it could fail to do so with some corner cases. For example:
> 
>        l0:     ldh [4]
>        l1:     jeq #0x537d, l2, l40
>        l2:     ld [0]
>        l3:     jeq #0xfa163e0d, l4, l40
>        l4:     ldh [12]
>        l5:     ldx #0xe
>        l6:     jeq #0x86dd, l41, l7
>        l8:     ld [x+16]
>        l9:     ja 41
> 
>          [... repeated ja 41 ]
> 
>        l40:    ja 41
>        l41:    ret #0
>        l42:    ld #len
>        l43:    ret a
> 
> This bpf program contains 32 "ja 41" instructions which are effectively
> NOPs and designed to be replaced with valid code dynamically. Ideally,
> bpf jit should optimize those "ja 41" instructions out when translating
> the bpf instructions into x86_64 machine code. However, do_jit() can
> only remove one "ja 41" for offset==0 on each pass, so it requires at
> least 32 runs to eliminate those JMPs and exceeds the current limit of
> passes (20). In the end, the program got rejected when BPF_JIT_ALWAYS_ON
> is set even though it's legit as a classic socket filter.
> 
> To make the image more likely converge within 20 passes, this commit
> pads some instructions with NOPs in the last 5 passes:
> 
> 1. conditional jumps
>    A possible size variance comes from the adoption of imm8 JMP. If the
>    offset is imm8, we calculate the size difference of this BPF instruction
>    between the previous pass and the current pass and fill the gap with NOPs.
>    To avoid the recalculation of jump offset, those NOPs are inserted before
>    the JMP code, so we have to subtract the 2 bytes of imm8 JMP when
>    calculating the NOP number.
> 
> 2. BPF_JA
>    There are two conditions for BPF_JA.
>    a.) nop jumps
>      If this instruction is not optimized out in the previous pass,
>      instead of removing it, we insert the equivalent size of NOPs.
>    b.) label jumps
>      Similar to condition jumps, we prepend NOPs right before the JMP
>      code.
> 
> To make the code concise, emit_nops() is modified to use the signed len and
> return the number of inserted NOPs.
> 
> To support bpf-to-bpf, a new flag, padded, is introduced to 'struct bpf_prog'
> so that bpf_int_jit_compile() could know if the program is padded or not.

Please also add multiple hand-crafted test cases e.g. for bpf-to-bpf calls into
test_verifier (which is part of bpf kselftests) that would exercise this corner
case in x86 jit where we would start to nop pad so that there is proper coverage,
too.
