Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA95D40391A
	for <lists+netdev@lfdr.de>; Wed,  8 Sep 2021 13:46:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351561AbhIHLr7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Sep 2021 07:47:59 -0400
Received: from www62.your-server.de ([213.133.104.62]:53424 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235453AbhIHLr6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Sep 2021 07:47:58 -0400
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1mNw2N-000G2T-3I; Wed, 08 Sep 2021 13:46:43 +0200
Received: from [85.5.47.65] (helo=linux.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1mNw2M-000OMW-RR; Wed, 08 Sep 2021 13:46:42 +0200
Subject: Re: [PATCH bpf-next v2 13/13] bpf/tests: Add tail call limit test
 with external function call
To:     Johan Almbladh <johan.almbladh@anyfinetworks.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
References: <20210907222339.4130924-1-johan.almbladh@anyfinetworks.com>
 <20210907222339.4130924-14-johan.almbladh@anyfinetworks.com>
 <fe04c10b5991a5fb0656fe272c137a73ec7d2472.camel@linux.ibm.com>
 <CAM1=_QTC077YiaJ_7x=ooq2HyKhYFEPt_C04y1uo4tNEyGioFA@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <b464eff1-4cdf-47f7-07f7-d1343e8dd2f7@iogearbox.net>
Date:   Wed, 8 Sep 2021 13:46:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAM1=_QTC077YiaJ_7x=ooq2HyKhYFEPt_C04y1uo4tNEyGioFA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.2/26288/Wed Sep  8 10:22:21 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/8/21 12:53 PM, Johan Almbladh wrote:
> On Wed, Sep 8, 2021 at 12:10 PM Ilya Leoshkevich <iii@linux.ibm.com> wrote:
>> On Wed, 2021-09-08 at 00:23 +0200, Johan Almbladh wrote:
>>> This patch adds a tail call limit test where the program also emits
>>> a BPF_CALL to an external function prior to the tail call. Mainly
>>> testing that JITed programs preserve its internal register state, for
>>> example tail call count, across such external calls.
>>>
>>> Signed-off-by: Johan Almbladh <johan.almbladh@anyfinetworks.com>
>>> ---
>>>   lib/test_bpf.c | 51 +++++++++++++++++++++++++++++++++++++++++++++++---
>>>   1 file changed, 48 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/lib/test_bpf.c b/lib/test_bpf.c
>>> index 7475abfd2186..6e45b4da9841 100644
>>> --- a/lib/test_bpf.c
>>> +++ b/lib/test_bpf.c
>>> @@ -12259,6 +12259,20 @@ static struct tail_call_test tail_call_tests[]
>>> = {
>>>                  },
>>>                  .result = MAX_TAIL_CALL_CNT + 1,
>>>          },
>>> +       {
>>> +               "Tail call count preserved across function calls",
>>> +               .insns = {
>>> +                       BPF_ALU64_IMM(BPF_ADD, R1, 1),
>>> +                       BPF_STX_MEM(BPF_DW, R10, R1, -8),
>>> +                       BPF_CALL_REL(0),
>>> +                       BPF_LDX_MEM(BPF_DW, R1, R10, -8),
>>> +                       BPF_ALU32_REG(BPF_MOV, R0, R1),
>>> +                       TAIL_CALL(0),
>>> +                       BPF_EXIT_INSN(),
>>> +               },
>>> +               .stack_depth = 8,
>>> +               .result = MAX_TAIL_CALL_CNT + 1,
>>> +       },
>>>          {
>>>                  "Tail call error path, NULL target",
>>>                  .insns = {
>>
>> There seems to be a problem with BPF_CALL_REL(0) on s390, since it
>> assumes that test_bpf_func and __bpf_call_base are within +-2G of
>> each other, which is not (yet) the case.
> 
> The idea with this test is to mess up a JITed program's internal state
> if it does not properly save/restore those regs. I would like to keep
> the test in some form, but I do see the problem here.
> 
> Another option could perhaps be to skip this test at runtime if the
> computed offset is outside +-2G. If the offset is greater than that it
> does not fit into the 32-bit BPF immediate field, and must therefore
> be skipped. This would work for other archs too.

Sounds reasonable as a work-around/to move forward.

> Yet another solution would be call one or several bpf helpers instead.
> As I understand it, they should always be located within this range,
> otherwise they would not be callable from a BPF program. The reason I
> did not do this was because I found helpers that don't require any
> context to be too simple. Ideally one would want to call something
> that uses pretty much all available caller-saved CPU registers. I
> figured snprintf would be complex/nasty enough for this purpose.

Potentially bpf_csum_diff() could also be a candidate, and fairly
straight forward to set up from raw asm.

>> I can't think of a good fix, so how about something like this?
>>
>> --- a/lib/test_bpf.c
>> +++ b/lib/test_bpf.c
>> @@ -12257,6 +12257,7 @@ static struct tail_call_test tail_call_tests[]
>> = {
>>                  },
>>                  .result = MAX_TAIL_CALL_CNT + 1,
>>          },
>> +#ifndef __s390__
>>          {
>>                  "Tail call count preserved across function calls",
>>                  .insns = {
>> @@ -12271,6 +12272,7 @@ static struct tail_call_test tail_call_tests[]
>> = {
>>                  .stack_depth = 8,
>>                  .result = MAX_TAIL_CALL_CNT + 1,
>>          },
>> +#endif
>>          {
>>                  "Tail call error path, NULL target",
>>                  .insns = {
>>
>> [...]
>>

