Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD69E2516D
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 16:02:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728628AbfEUOC5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 10:02:57 -0400
Received: from www62.your-server.de ([213.133.104.62]:41750 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728589AbfEUOC4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 May 2019 10:02:56 -0400
Received: from [78.46.172.2] (helo=sslproxy05.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hT5Ly-0006DJ-9f; Tue, 21 May 2019 16:02:54 +0200
Received: from [178.197.249.20] (helo=linux.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hT5Ly-000IeH-3T; Tue, 21 May 2019 16:02:54 +0200
Subject: Re: [PATCH bpf] bpf, riscv: clear target register high 32-bits for
 and/or/xor on ALU32
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        ast@kernel.org, netdev@vger.kernel.org
Cc:     linux-riscv@lists.infradead.org, bpf@vger.kernel.org,
        Jiong Wang <jiong.wang@netronome.com>
References: <20190521134622.18358-1-bjorn.topel@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <49999b2d-f025-894a-be61-a52d13b24678@iogearbox.net>
Date:   Tue, 21 May 2019 16:02:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <20190521134622.18358-1-bjorn.topel@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25456/Tue May 21 09:56:54 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/21/2019 03:46 PM, Björn Töpel wrote:
> When using 32-bit subregisters (ALU32), the RISC-V JIT would not clear
> the high 32-bits of the target register and therefore generate
> incorrect code.
> 
> E.g., in the following code:
> 
>   $ cat test.c
>   unsigned int f(unsigned long long a,
>   	       unsigned int b)
>   {
>   	return (unsigned int)a & b;
>   }
> 
>   $ clang-9 -target bpf -O2 -emit-llvm -S test.c -o - | \
>   	llc-9 -mattr=+alu32 -mcpu=v3
>   	.text
>   	.file	"test.c"
>   	.globl	f
>   	.p2align	3
>   	.type	f,@function
>   f:
>   	r0 = r1
>   	w0 &= w2
>   	exit
>   .Lfunc_end0:
>   	.size	f, .Lfunc_end0-f
> 
> The JIT would not clear the high 32-bits of r0 after the
> and-operation, which in this case might give an incorrect return
> value.
> 
> After this patch, that is not the case, and the upper 32-bits are
> cleared.
> 
> Reported-by: Jiong Wang <jiong.wang@netronome.com>
> Fixes: 2353ecc6f91f ("bpf, riscv: add BPF JIT for RV64G")
> Signed-off-by: Björn Töpel <bjorn.topel@gmail.com>

Was this missed because test_verifier did not have test coverage?
If so, could you follow-up with alu32 test cases for it, so other
JITs can be tracked for these kind of issue as well. We should
probably have one for every alu32 alu op to make sure it's not
forgotten anywhere.

Thanks,
Daniel
