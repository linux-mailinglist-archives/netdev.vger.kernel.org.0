Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93F7027EE8
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 15:58:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730756AbfEWN6E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 09:58:04 -0400
Received: from www62.your-server.de ([213.133.104.62]:53714 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730601AbfEWN6D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 09:58:03 -0400
Received: from [78.46.172.2] (helo=sslproxy05.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hToEL-0004D5-GO; Thu, 23 May 2019 15:58:01 +0200
Received: from [178.197.249.12] (helo=linux.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hToEL-000GTg-8B; Thu, 23 May 2019 15:58:01 +0200
Subject: Re: [PATCH bpf] bpf, riscv: clear target register high 32-bits for
 and/or/xor on ALU32
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Netdev <netdev@vger.kernel.org>, linux-riscv@lists.infradead.org,
        bpf <bpf@vger.kernel.org>, Jiong Wang <jiong.wang@netronome.com>
References: <20190521134622.18358-1-bjorn.topel@gmail.com>
 <49999b2d-f025-894a-be61-a52d13b24678@iogearbox.net>
 <CAJ+HfNifkxKz8df7gLBuqWA6+t6awrrRK6oW6m1nAYETJD+Vfg@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <412b2dda-7507-c291-9787-7a35a7e1bfd6@iogearbox.net>
Date:   Thu, 23 May 2019 15:58:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <CAJ+HfNifkxKz8df7gLBuqWA6+t6awrrRK6oW6m1nAYETJD+Vfg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25458/Thu May 23 09:58:32 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/21/2019 04:12 PM, Björn Töpel wrote:
> On Tue, 21 May 2019 at 16:02, Daniel Borkmann <daniel@iogearbox.net> wrote:
>> On 05/21/2019 03:46 PM, Björn Töpel wrote:
>>> When using 32-bit subregisters (ALU32), the RISC-V JIT would not clear
>>> the high 32-bits of the target register and therefore generate
>>> incorrect code.
>>>
>>> E.g., in the following code:
>>>
>>>   $ cat test.c
>>>   unsigned int f(unsigned long long a,
>>>              unsigned int b)
>>>   {
>>>       return (unsigned int)a & b;
>>>   }
>>>
>>>   $ clang-9 -target bpf -O2 -emit-llvm -S test.c -o - | \
>>>       llc-9 -mattr=+alu32 -mcpu=v3
>>>       .text
>>>       .file   "test.c"
>>>       .globl  f
>>>       .p2align        3
>>>       .type   f,@function
>>>   f:
>>>       r0 = r1
>>>       w0 &= w2
>>>       exit
>>>   .Lfunc_end0:
>>>       .size   f, .Lfunc_end0-f
>>>
>>> The JIT would not clear the high 32-bits of r0 after the
>>> and-operation, which in this case might give an incorrect return
>>> value.
>>>
>>> After this patch, that is not the case, and the upper 32-bits are
>>> cleared.
>>>
>>> Reported-by: Jiong Wang <jiong.wang@netronome.com>
>>> Fixes: 2353ecc6f91f ("bpf, riscv: add BPF JIT for RV64G")
>>> Signed-off-by: Björn Töpel <bjorn.topel@gmail.com>
>>
>> Was this missed because test_verifier did not have test coverage?
> 
> Yup, and Jiong noted it.

Applied, thanks!
