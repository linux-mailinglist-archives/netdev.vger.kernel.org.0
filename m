Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 780EA30AC36
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 17:04:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230273AbhBAQCl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 11:02:41 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:34327 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229986AbhBAQCh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 11:02:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612195270;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fR+P+c8iSUOGDUXkG9JNoq+vdh7phkoDAoDy76IiraM=;
        b=APXKFWRaXfiRhtPJGIbWvprLK5wuhUYs3UZFr5m6HDm/vQiePK4G7I0RRV0dp0RcCD8KH4
        qgb6tL8OQl5d7wtF7WSm007SHKTUz7PsDW7FwGqxrKi/Os4kTjp4l0MtOIMRuSS6577w5m
        hRjOrRlxuPz5HGLyvgpIpTdF0bHGGB8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-456-I-zbDr48OIGxiM0HAItqaQ-1; Mon, 01 Feb 2021 11:01:05 -0500
X-MC-Unique: I-zbDr48OIGxiM0HAItqaQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2318C1017F41;
        Mon,  1 Feb 2021 16:00:35 +0000 (UTC)
Received: from [10.36.114.109] (ovpn-114-109.ams2.redhat.com [10.36.114.109])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6E4B55C23D;
        Mon,  1 Feb 2021 16:00:32 +0000 (UTC)
From:   "Eelco Chaudron" <echaudro@redhat.com>
To:     "Daniel Borkmann" <daniel@iogearbox.net>,
        "Alexei Starovoitov" <ast@kernel.org>
Cc:     "Maciej Fijalkowski" <maciej.fijalkowski@intel.com>,
        "Lorenzo Bianconi" <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, brouer@redhat.com, bjorn@kernel.org,
        toke@redhat.com, john.fastabend@gmail.com
Subject: Re: [PATCH v5 bpf-next 13/14] bpf: add new frame_length field to the
 XDP ctx
Date:   Mon, 01 Feb 2021 17:00:03 +0100
Message-ID: <ECA531EC-3A82-438F-B7B4-B660BF16FCCE@redhat.com>
In-Reply-To: <EEE789B9-CDEC-49F8-BDE7-9DE85D56C1BA@redhat.com>
References: <cover.1607349924.git.lorenzo@kernel.org>
 <0547d6f752e325f56a8e5f6466b50e81ff29d65f.1607349924.git.lorenzo@kernel.org>
 <20201208221746.GA33399@ranger.igk.intel.com>
 <96C89134-A747-4E05-AA11-CB6EA1420900@redhat.com>
 <20201209111047.GB36812@ranger.igk.intel.com>
 <170BF39B-894D-495F-93E0-820EC7880328@redhat.com>
 <38C60760-4F8C-43AC-A5DE-7FAECB65C310@redhat.com>
 <20201215180638.GB23785@ranger.igk.intel.com>
 <54E66B9D-4677-436F-92A1-E70977E869FA@redhat.com>
 <5A8FDDE5-3022-4FD7-BA71-9ACB4374BDB9@redhat.com>
 <20210118164855.GA12769@ranger.igk.intel.com>
 <EEE789B9-CDEC-49F8-BDE7-9DE85D56C1BA@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 20 Jan 2021, at 14:20, Eelco Chaudron wrote:

> On 18 Jan 2021, at 17:48, Maciej Fijalkowski wrote:
>
>> On Fri, Jan 15, 2021 at 05:36:23PM +0100, Eelco Chaudron wrote:
>>>
>>>
>>> On 16 Dec 2020, at 15:08, Eelco Chaudron wrote:
>>>
>>>> On 15 Dec 2020, at 19:06, Maciej Fijalkowski wrote:
>>>>
>>>>> On Tue, Dec 15, 2020 at 02:28:39PM +0100, Eelco Chaudron wrote:
>>>>>>
>>>>>>
>>>>>> On 9 Dec 2020, at 13:07, Eelco Chaudron wrote:
>>>>>>
>>>>>>> On 9 Dec 2020, at 12:10, Maciej Fijalkowski wrote:
>>>>>>
>>>>>> <SNIP>
>>>>>>
>>>>>>>>>>> +
>>>>>>>>>>> +		ctx_reg = (si->src_reg == si->dst_reg) ? scratch_reg - 1 
>>>>>>>>>>> :
>>>>>>>>>>> si->src_reg;
>>>>>>>>>>> +		while (dst_reg == ctx_reg || scratch_reg == ctx_reg)
>>>>>>>>>>> +			ctx_reg--;
>>>>>>>>>>> +
>>>>>>>>>>> +		/* Save scratch registers */
>>>>>>>>>>> +		if (ctx_reg != si->src_reg) {
>>>>>>>>>>> +			*insn++ = BPF_STX_MEM(BPF_DW, si->src_reg, ctx_reg,
>>>>>>>>>>> +					      offsetof(struct xdp_buff,
>>>>>>>>>>> +						       tmp_reg[1]));
>>>>>>>>>>> +
>>>>>>>>>>> +			*insn++ = BPF_MOV64_REG(ctx_reg, si->src_reg);
>>>>>>>>>>> +		}
>>>>>>>>>>> +
>>>>>>>>>>> +		*insn++ = BPF_STX_MEM(BPF_DW, ctx_reg, scratch_reg,
>>>>>>>>>>> +				      offsetof(struct xdp_buff, tmp_reg[0]));
>>>>>>>>>>
>>>>>>>>>> Why don't you push regs to stack, use it and then pop it
>>>>>>>>>> back? That way
>>>>>>>>>> I
>>>>>>>>>> suppose you could avoid polluting xdp_buff with tmp_reg[2].
>>>>>>>>>
>>>>>>>>> There is no “real” stack in eBPF, only a read-only frame
>>>>>>>>> pointer, and as we
>>>>>>>>> are replacing a single instruction, we have no info on what we
>>>>>>>>> can use as
>>>>>>>>> scratch space.
>>>>>>>>
>>>>>>>> Uhm, what? You use R10 for stack operations. Verifier tracks 
>>>>>>>> the
>>>>>>>> stack
>>>>>>>> depth used by programs and then it is passed down to JIT so 
>>>>>>>> that
>>>>>>>> native
>>>>>>>> asm will create a properly sized stack frame.
>>>>>>>>
>>>>>>>> From the top of my head I would let know
>>>>>>>> xdp_convert_ctx_access of a
>>>>>>>> current stack depth and use it for R10 stores, so your
>>>>>>>> scratch space
>>>>>>>> would
>>>>>>>> be R10 + (stack depth + 8), R10 + (stack_depth + 16).
>>>>>>>
>>>>>>> Other instances do exactly the same, i.e. put some scratch
>>>>>>> registers in
>>>>>>> the underlying data structure, so I reused this approach. From 
>>>>>>> the
>>>>>>> current information in the callback, I was not able to
>>>>>>> determine the
>>>>>>> current stack_depth. With "real" stack above, I meant having
>>>>>>> a pop/push
>>>>>>> like instruction.
>>>>>>>
>>>>>>> I do not know the verifier code well enough, but are you
>>>>>>> suggesting I
>>>>>>> can get the current stack_depth from the verifier in the
>>>>>>> xdp_convert_ctx_access() callback? If so any pointers?
>>>>>>
>>>>>> Maciej any feedback on the above, i.e. getting the stack_depth in
>>>>>> xdp_convert_ctx_access()?
>>>>>
>>>>> Sorry. I'll try to get my head around it. If i recall correctly 
>>>>> stack
>>>>> depth is tracked per subprogram whereas convert_ctx_accesses is
>>>>> iterating
>>>>> through *all* insns (so a prog that is not chunked onto subprogs),
>>>>> but
>>>>> maybe we could dig up the subprog based on insn idx.
>>>>>
>>>>> But at first, you mentioned that you took the approach from other
>>>>> instances, can you point me to them?
>>>>
>>>> Quick search found the following two (sure there is one more with 
>>>> two
>>>> regs):
>>>>
>>>> https://elixir.bootlin.com/linux/v5.10.1/source/kernel/bpf/cgroup.c#L1718
>>>> https://elixir.bootlin.com/linux/v5.10.1/source/net/core/filter.c#L8977
>>>>
>>>>> I'd also like to hear from Daniel/Alexei/John and others their
>>>>> thoughts.
>>>>
>>>> Please keep me in the loop…
>>>
>>> Any thoughts/update on the above so I can move this patchset 
>>> forward?
>>
>> Cc: John, Jesper, Bjorn
>>
>> I didn't spend time thinking about it, but I still am against 
>> xdp_buff
>> extension for the purpose that code within this patch has.
>
> Yes I agree, if we can not find an easy way to store the scratch 
> registers on the stack, I’ll rework this patch to just store the 
> total frame length in xdp_buff, as it will be less and still fit in 
> one cache line.
>
>> Daniel/Alexei/John/Jesper/Bjorn,

Daniel/Alexei and input on how to easily allocate two scratch registers 
on the stack from a function like xdp_convert_ctx_access() through the 
verifier state? See above for some more details.

If you are not the right persons, who might be the verifier guru to ask?

>> any objections for not having the scratch registers but rather use 
>> the
>> stack and update the stack depth to calculate the frame length?
>>
>> This seems not trivial so I really would like to have an input from 
>> better
>> BPF developers than me :)

