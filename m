Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85B662B137E
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 01:50:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726101AbgKMAuQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 19:50:16 -0500
Received: from www62.your-server.de ([213.133.104.62]:52690 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725929AbgKMAuP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 19:50:15 -0500
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1kdNI1-0000Zr-K6; Fri, 13 Nov 2020 01:50:09 +0100
Received: from [85.7.101.30] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kdNI1-0002t3-EX; Fri, 13 Nov 2020 01:50:09 +0100
Subject: Re: [PATCH v2 bpf-next 1/3] bpf: Support for pointers beyond pkt_end.
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     John Fastabend <john.fastabend@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com
References: <20201111031213.25109-1-alexei.starovoitov@gmail.com>
 <20201111031213.25109-2-alexei.starovoitov@gmail.com>
 <5fad89fb649af_2a612088e@john-XPS-13-9370.notmuch>
 <4f80439b-3251-f82b-be63-b398d5f73ac2@iogearbox.net>
 <20201113000941.azxyv523bl45z6s5@ast-mbp>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <99077ce7-8988-2a63-6663-c282e2007589@iogearbox.net>
Date:   Fri, 13 Nov 2020 01:50:08 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20201113000941.azxyv523bl45z6s5@ast-mbp>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25986/Thu Nov 12 14:18:25 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/13/20 1:09 AM, Alexei Starovoitov wrote:
> On Fri, Nov 13, 2020 at 12:56:52AM +0100, Daniel Borkmann wrote:
>> On 11/12/20 8:16 PM, John Fastabend wrote:
>>> Alexei Starovoitov wrote:
>>>> From: Alexei Starovoitov <ast@kernel.org>
>>>>
>>>> This patch adds the verifier support to recognize inlined branch conditions.
>>>> The LLVM knows that the branch evaluates to the same value, but the verifier
>>>> couldn't track it. Hence causing valid programs to be rejected.
>>>> The potential LLVM workaround: https://reviews.llvm.org/D87428
>>>> can have undesired side effects, since LLVM doesn't know that
>>>> skb->data/data_end are being compared. LLVM has to introduce extra boolean
>>>> variable and use inline_asm trick to force easier for the verifier assembly.
>>>>
>>>> Instead teach the verifier to recognize that
>>>> r1 = skb->data;
>>>> r1 += 10;
>>>> r2 = skb->data_end;
>>>> if (r1 > r2) {
>>>>     here r1 points beyond packet_end and
>>>>     subsequent
>>>>     if (r1 > r2) // always evaluates to "true".
>>>> }
>>>>
>>>> Tested-by: Jiri Olsa <jolsa@redhat.com>
>>>> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
>>>> ---
>>>>    include/linux/bpf_verifier.h |   2 +-
>>>>    kernel/bpf/verifier.c        | 129 +++++++++++++++++++++++++++++------
>>>>    2 files changed, 108 insertions(+), 23 deletions(-)
>>>
>>> Thanks, we can remove another set of inline asm logic.
>>>
>>> Acked-by: John Fastabend <john.fastabend@gmail.com>
>>>>    	if (pred >= 0) {
>>>> @@ -7517,7 +7601,8 @@ static int check_cond_jmp_op(struct bpf_verifier_env *env,
>>>>    		 */
>>>>    		if (!__is_pointer_value(false, dst_reg))
>>>>    			err = mark_chain_precision(env, insn->dst_reg);
>>>> -		if (BPF_SRC(insn->code) == BPF_X && !err)
>>>> +		if (BPF_SRC(insn->code) == BPF_X && !err &&
>>>> +		    !__is_pointer_value(false, src_reg))
>>>
>>> This could have been more specific with !type_is_pkt_pointer() correct? I
>>> think its fine as is though.
>>>
>>>>    			err = mark_chain_precision(env, insn->src_reg);
>>>>    		if (err)
>>>>    			return err;
>>
>> Given the reg->range could now be negative, I wonder whether for the regsafe()
>> pruning logic we should now better add a >=0 sanity check in there before we
>> attempt to test on rold->range > rcur->range?
> 
> I thought about it and specifically picked negative range value to keep
> regsafe() check as-is.
> The check is this:
>                  if (rold->range > rcur->range)
>                          return false;
> rold is the one that was safe in the past.
> If rold was positive and the current is negative we fail here
> which is ok. State pruning is conservative.
> 
> If rold was negative it means the previous state was safe even though that pointer
> was pointing beyond packet end. So it's ok for rcur->range to be anything.
> Whether rcur is positive or negative doesn't matter. Everything is still ok.
> If rold->range == -1 and rcur->range == -2 we fail here.
> It's minor annoyance. State pruning is tiny bit more conservative than necessary.
> 
> So I think no extra checks in regsafe() are neeeded.
> Does it make sense?

Yeah, same conclusion here. We still might want to add more BPF asm based tests
on this in general, but either way logic lgtm, so applied, thanks.
