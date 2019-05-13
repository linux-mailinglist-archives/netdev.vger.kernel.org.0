Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B77F1AE80
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 02:02:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727196AbfEMABz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 May 2019 20:01:55 -0400
Received: from www62.your-server.de ([213.133.104.62]:35528 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727182AbfEMABz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 May 2019 20:01:55 -0400
Received: from [78.46.172.2] (helo=sslproxy05.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hPyPf-0006RU-Ki; Mon, 13 May 2019 02:01:51 +0200
Received: from [178.199.41.31] (helo=linux.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hPyPf-000MHZ-EX; Mon, 13 May 2019 02:01:51 +0200
Subject: Re: [PATCH bpf v1] bpf: Fix undefined behavior in narrow load
 handling
To:     Krzesimir Nowak <krzesimir@kinvolk.io>
Cc:     bpf@vger.kernel.org, Alban Crequy <alban@kinvolk.io>,
        =?UTF-8?Q?Iago_L=c3=b3pez_Galeiras?= <iago@kinvolk.io>,
        Yonghong Song <yhs@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20190508160859.4380-1-krzesimir@kinvolk.io>
 <46056c60-f106-e539-b614-498cb1e9e3d0@iogearbox.net>
 <CAGGp+cFVt_i29Sr07ZJC5zdxTuuwcc02yVy5y03=DXSB6NEr0g@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <8fd60de9-356a-656a-4acb-43ecab28e3da@iogearbox.net>
Date:   Mon, 13 May 2019 02:01:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <CAGGp+cFVt_i29Sr07ZJC5zdxTuuwcc02yVy5y03=DXSB6NEr0g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25447/Sun May 12 09:56:54 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/10/2019 12:16 PM, Krzesimir Nowak wrote:
> On Thu, May 9, 2019 at 11:30 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>> On 05/08/2019 06:08 PM, Krzesimir Nowak wrote:
>>> Commit 31fd85816dbe ("bpf: permits narrower load from bpf program
>>> context fields") made the verifier add AND instructions to clear the
>>> unwanted bits with a mask when doing a narrow load. The mask is
>>> computed with
>>>
>>> (1 << size * 8) - 1
>>>
>>> where "size" is the size of the narrow load. When doing a 4 byte load
>>> of a an 8 byte field the verifier shifts the literal 1 by 32 places to
>>> the left. This results in an overflow of a signed integer, which is an
>>> undefined behavior. Typically the computed mask was zero, so the
>>> result of the narrow load ended up being zero too.
>>>
>>> Cast the literal to long long to avoid overflows. Note that narrow
>>> load of the 4 byte fields does not have the undefined behavior,
>>> because the load size can only be either 1 or 2 bytes, so shifting 1
>>> by 8 or 16 places will not overflow it. And reading 4 bytes would not
>>> be a narrow load of a 4 bytes field.
>>>
>>> Reviewed-by: Alban Crequy <alban@kinvolk.io>
>>> Reviewed-by: Iago López Galeiras <iago@kinvolk.io>
>>> Fixes: 31fd85816dbe ("bpf: permits narrower load from bpf program context fields")
>>> Cc: Yonghong Song <yhs@fb.com>
>>> Signed-off-by: Krzesimir Nowak <krzesimir@kinvolk.io>
>>> ---
>>>  kernel/bpf/verifier.c | 2 +-
>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
>>> index 09d5d972c9ff..950fac024fbb 100644
>>> --- a/kernel/bpf/verifier.c
>>> +++ b/kernel/bpf/verifier.c
>>> @@ -7296,7 +7296,7 @@ static int convert_ctx_accesses(struct bpf_verifier_env *env)
>>>                                                                       insn->dst_reg,
>>>                                                                       shift);
>>>                               insn_buf[cnt++] = BPF_ALU64_IMM(BPF_AND, insn->dst_reg,
>>> -                                                             (1 << size * 8) - 1);
>>> +                                                             (1ULL << size * 8) - 1);
>>>                       }
>>
>> Makes sense, good catch & thanks for the fix!
>>
>> Could you also add a test case to test_verifier.c so we keep track of this?
>>
>> Thanks,
>> Daniel
> 
> Hi,
> 
> A test for it is a bit tricky. I only found two 64bit fields that can
> be loaded narrowly - `sample_period` and `addr` in `struct
> bpf_perf_event_data`, so in theory I could have a test like follows:
> 
> {
>     "32bit loads of a 64bit field (both least and most significant words)",
>     .insns = {
>     BPF_LDX_MEM(BPF_W, BPF_REG_4, BPF_REG_1, offsetof(struct
> bpf_perf_event_data, addr)),
>     BPF_LDX_MEM(BPF_W, BPF_REG_4, BPF_REG_1, offsetof(struct
> bpf_perf_event_data, addr) + 4),
>     BPF_MOV64_IMM(BPF_REG_0, 0),
>     BPF_EXIT_INSN(),
>     },
>     .result = ACCEPT,
>     .prog_type = BPF_PROG_TYPE_PERF_EVENT,
> },
> 
> The test like this would check that the program is not rejected, but
> it wasn't an issue. The test does not check if the verifier has
> transformed the narrow reads properly. Ideally the BPF program would
> do something like this:
> 
> /* let's assume that low and high variables get their values from narrow load */
> __u64 low = (__u32)perf_event->addr;
> __u64 high = (__u32)(perf_event->addr >> 32);
> __u64 addr = low | (high << 32);
> 
> return addr != perf_event->addr;
> 
> But the test_verifier.c won't be able to run this, because
> BPF_PROG_TYPE_PERF_EVENT programs are not supported by the
> bpf_test_run_prog function.
> 
> Any hints how to proceed here?

The test_verifier actually also runs the programs after successful verification,
so above C-like snippet should be converted to BPF asm. Search for ".retval" in
some of the test cases. (I've for now applied the fix itself to bpf, but still
expect such test case as follow-up for same tree. Thanks!)

> Cheers,
> Krzesimir
> 

