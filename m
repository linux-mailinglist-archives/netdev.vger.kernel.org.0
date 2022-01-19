Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30817493D74
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 16:43:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355855AbiASPmg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 10:42:36 -0500
Received: from www62.your-server.de ([213.133.104.62]:52166 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355832AbiASPmf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 10:42:35 -0500
Received: from [78.46.152.42] (helo=sslproxy04.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1nAD6S-000FUR-0G; Wed, 19 Jan 2022 16:42:28 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy04.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1nAD6R-000O1M-Iy; Wed, 19 Jan 2022 16:42:27 +0100
Subject: Re: [PATCH riscv-next] riscv: bpf: Fix eBPF's exception tables
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        Jisheng Zhang <jszhang@kernel.org>,
        Palmer Dabbelt <palmer@dabbelt.com>, palmer@rivosinc.com
Cc:     Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Netdev <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        linux-riscv <linux-riscv@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Tong Tiangen <tongtiangen@huawei.com>
References: <20220110165208.1826-1-jszhang@kernel.org>
 <Ydxljv2Q4YNDYRTx@xhacker>
 <CAJ+HfNiS7Ss0FJowPUrrKvuC+1Kn9gXb=VqNoqh3eWJDu=m4Mg@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <1b104397-8cb7-c5c2-92cb-11ce56c9a8de@iogearbox.net>
Date:   Wed, 19 Jan 2022 16:42:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAJ+HfNiS7Ss0FJowPUrrKvuC+1Kn9gXb=VqNoqh3eWJDu=m4Mg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.3/26427/Wed Jan 19 11:42:43 2022)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/19/22 11:24 AM, Björn Töpel wrote:
> On Mon, 10 Jan 2022 at 18:05, Jisheng Zhang <jszhang@kernel.org> wrote:
>> On Tue, Jan 11, 2022 at 12:52:08AM +0800, Jisheng Zhang wrote:
>>> eBPF's exception tables needs to be modified to relative synchronously.
>>>
>>> Suggested-by: Tong Tiangen <tongtiangen@huawei.com>
>>> Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
> 
> Nice catch, and apologies for the slow response.
> 
> Acked-by: Björn Töpel <bjorn@kernel.org>
> 
>>> ---
>>>   arch/riscv/net/bpf_jit_comp64.c | 2 +-
>>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/arch/riscv/net/bpf_jit_comp64.c b/arch/riscv/net/bpf_jit_comp64.c
>>> index 69bab7e28f91..44c97535bc15 100644
>>> --- a/arch/riscv/net/bpf_jit_comp64.c
>>> +++ b/arch/riscv/net/bpf_jit_comp64.c
>>> @@ -498,7 +498,7 @@ static int add_exception_handler(const struct bpf_insn *insn,
>>>        offset = pc - (long)&ex->insn;
>>>        if (WARN_ON_ONCE(offset >= 0 || offset < INT_MIN))
>>>                return -ERANGE;
>>> -     ex->insn = pc;
>>> +     ex->insn = offset;
>>
>> Hi Palmer,
>>
>> Tong pointed out this issue but there was something wrong with my email
>> forwarding address, so I didn't get his reply. Today, I searched on
>> lore.kernel.org just found his reply, sorry for inconvenience.
> 
> AFAIK, Jisheng's extable work is still in Palmer's for-next tree.
> 
> Daniel/Alexei: This eBPF must follow commit 1f77ed9422cb ("riscv:
> switch to relative extable and other improvements"), which is in
> Palmer's tree. It cannot go via bpf-next.

Thanks for letting us know, then lets route this fix via Palmer. Maybe he could
also add Fixes tags when applying, so stable can pick it up later on.

Cheers,
Daniel
