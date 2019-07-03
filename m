Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9EA35E15D
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 11:50:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726780AbfGCJuD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 05:50:03 -0400
Received: from www62.your-server.de ([213.133.104.62]:51416 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726434AbfGCJuD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 05:50:03 -0400
Received: from [88.198.220.130] (helo=sslproxy01.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hibtd-0006bp-Bc; Wed, 03 Jul 2019 11:49:49 +0200
Received: from [2a02:1205:5054:6d70:b45c:ec96:516a:e956] (helo=linux.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hibtd-0000Zx-1y; Wed, 03 Jul 2019 11:49:49 +0200
Subject: Re: [PATCH bpf 1/3] bpf, x32: Fix bug with ALU64 {LSH,RSH,ARSH} BPF_X
 shift by 0
To:     Luke Nelson <lukenels@cs.washington.edu>,
        linux-kernel@vger.kernel.org
Cc:     Luke Nelson <luke.r.nels@gmail.com>, Xi Wang <xi.wang@gmail.com>,
        Wang YanQing <udknight@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Shuah Khan <shuah@kernel.org>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jiong Wang <jiong.wang@netronome.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org
References: <20190629055759.28365-1-luke.r.nels@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <5c2080f4-532e-d239-13b1-4a5a620f6c33@iogearbox.net>
Date:   Wed, 3 Jul 2019 11:49:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <20190629055759.28365-1-luke.r.nels@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25499/Wed Jul  3 10:03:10 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/29/2019 07:57 AM, Luke Nelson wrote:
> The current x32 BPF JIT for shift operations is not correct when the
> shift amount in a register is 0. The expected behavior is a no-op, whereas
> the current implementation changes bits in the destination register.
> 
> The following example demonstrates the bug. The expected result of this
> program is 1, but the current JITed code returns 2.
> 
>   r0 = 1
>   r1 = 1
>   r2 = 0
>   r1 <<= r2
>   if r1 == 1 goto end
>   r0 = 2
> end:
>   exit
> 
> The bug is caused by an incorrect assumption by the JIT that a shift by
> 32 clear the register. On x32 however, shifts use the lower 5 bits of
> the source, making a shift by 32 equivalent to a shift by 0.
> 
> This patch fixes the bug using double-precision shifts, which also
> simplifies the code.
> 
> Fixes: 03f5781be2c7 ("bpf, x86_32: add eBPF JIT compiler for ia32")
> Co-developed-by: Xi Wang <xi.wang@gmail.com>
> Signed-off-by: Xi Wang <xi.wang@gmail.com>
> Signed-off-by: Luke Nelson <luke.r.nels@gmail.com>

Series applied, thanks!
