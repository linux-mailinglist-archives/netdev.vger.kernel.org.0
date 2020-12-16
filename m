Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65E552DC1DD
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 15:11:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726449AbgLPOKG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 09:10:06 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59190 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726447AbgLPOKG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 09:10:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608127718;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wRoSZi6fR3FWf7EobiBv24WyjO+E0Lq6vHMOy7Mxc8E=;
        b=cpvPFtnSjhGVdofhQFyLhBo4pWAYItS5GADEASr4WdOWrw+d56NmHqhEWfBniy9IAS0TDI
        ICo69AfbrDL8PnZ9GOahk75a2QkeXafZN/8lKMabV8pRUgBUDtthsiNg/MbKGL0ltrXWvI
        WJsDJ0/XFEozIsjXdlTpyIJ4OxxnV3Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-577-MjI08-UiO6Sl03FRPOyjdw-1; Wed, 16 Dec 2020 09:08:33 -0500
X-MC-Unique: MjI08-UiO6Sl03FRPOyjdw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1B82259;
        Wed, 16 Dec 2020 14:08:32 +0000 (UTC)
Received: from [10.36.113.62] (ovpn-113-62.ams2.redhat.com [10.36.113.62])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2218B10023B9;
        Wed, 16 Dec 2020 14:08:30 +0000 (UTC)
From:   "Eelco Chaudron" <echaudro@redhat.com>
To:     "Maciej Fijalkowski" <maciej.fijalkowski@intel.com>
Cc:     "Lorenzo Bianconi" <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v5 bpf-next 13/14] bpf: add new frame_length field to the
 XDP ctx
Date:   Wed, 16 Dec 2020 15:08:28 +0100
Message-ID: <54E66B9D-4677-436F-92A1-E70977E869FA@redhat.com>
In-Reply-To: <20201215180638.GB23785@ranger.igk.intel.com>
References: <cover.1607349924.git.lorenzo@kernel.org>
 <0547d6f752e325f56a8e5f6466b50e81ff29d65f.1607349924.git.lorenzo@kernel.org>
 <20201208221746.GA33399@ranger.igk.intel.com>
 <96C89134-A747-4E05-AA11-CB6EA1420900@redhat.com>
 <20201209111047.GB36812@ranger.igk.intel.com>
 <170BF39B-894D-495F-93E0-820EC7880328@redhat.com>
 <38C60760-4F8C-43AC-A5DE-7FAECB65C310@redhat.com>
 <20201215180638.GB23785@ranger.igk.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 15 Dec 2020, at 19:06, Maciej Fijalkowski wrote:

> On Tue, Dec 15, 2020 at 02:28:39PM +0100, Eelco Chaudron wrote:
>>
>>
>> On 9 Dec 2020, at 13:07, Eelco Chaudron wrote:
>>
>>> On 9 Dec 2020, at 12:10, Maciej Fijalkowski wrote:
>>
>> <SNIP>
>>
>>>>>>> +
>>>>>>> +		ctx_reg = (si->src_reg == si->dst_reg) ? scratch_reg - 1 :
>>>>>>> si->src_reg;
>>>>>>> +		while (dst_reg == ctx_reg || scratch_reg == ctx_reg)
>>>>>>> +			ctx_reg--;
>>>>>>> +
>>>>>>> +		/* Save scratch registers */
>>>>>>> +		if (ctx_reg != si->src_reg) {
>>>>>>> +			*insn++ = BPF_STX_MEM(BPF_DW, si->src_reg, ctx_reg,
>>>>>>> +					      offsetof(struct xdp_buff,
>>>>>>> +						       tmp_reg[1]));
>>>>>>> +
>>>>>>> +			*insn++ = BPF_MOV64_REG(ctx_reg, si->src_reg);
>>>>>>> +		}
>>>>>>> +
>>>>>>> +		*insn++ = BPF_STX_MEM(BPF_DW, ctx_reg, scratch_reg,
>>>>>>> +				      offsetof(struct xdp_buff, tmp_reg[0]));
>>>>>>
>>>>>> Why don't you push regs to stack, use it and then pop it
>>>>>> back? That way
>>>>>> I
>>>>>> suppose you could avoid polluting xdp_buff with tmp_reg[2].
>>>>>
>>>>> There is no “real” stack in eBPF, only a read-only frame
>>>>> pointer, and as we
>>>>> are replacing a single instruction, we have no info on what we
>>>>> can use as
>>>>> scratch space.
>>>>
>>>> Uhm, what? You use R10 for stack operations. Verifier tracks the
>>>> stack
>>>> depth used by programs and then it is passed down to JIT so that
>>>> native
>>>> asm will create a properly sized stack frame.
>>>>
>>>> From the top of my head I would let know xdp_convert_ctx_access of a
>>>> current stack depth and use it for R10 stores, so your scratch space
>>>> would
>>>> be R10 + (stack depth + 8), R10 + (stack_depth + 16).
>>>
>>> Other instances do exactly the same, i.e. put some scratch registers in
>>> the underlying data structure, so I reused this approach. From the
>>> current information in the callback, I was not able to determine the
>>> current stack_depth. With "real" stack above, I meant having a pop/push
>>> like instruction.
>>>
>>> I do not know the verifier code well enough, but are you suggesting I
>>> can get the current stack_depth from the verifier in the
>>> xdp_convert_ctx_access() callback? If so any pointers?
>>
>> Maciej any feedback on the above, i.e. getting the stack_depth in
>> xdp_convert_ctx_access()?
>
> Sorry. I'll try to get my head around it. If i recall correctly stack
> depth is tracked per subprogram whereas convert_ctx_accesses is iterating
> through *all* insns (so a prog that is not chunked onto subprogs), but
> maybe we could dig up the subprog based on insn idx.
>
> But at first, you mentioned that you took the approach from other
> instances, can you point me to them?

Quick search found the following two (sure there is one more with two regs):

https://elixir.bootlin.com/linux/v5.10.1/source/kernel/bpf/cgroup.c#L1718
https://elixir.bootlin.com/linux/v5.10.1/source/net/core/filter.c#L8977

> I'd also like to hear from Daniel/Alexei/John and others their thoughts.

Please keep me in the loop…

>>
>>>> Problem with that would be the fact that convert_ctx_accesses()
>>>> happens to
>>>> be called after the check_max_stack_depth(), so probably stack_depth
>>>> of a
>>>> prog that has frame_length accesses would have to be adjusted
>>>> earlier.
>>>
>>> Ack, need to learn more on the verifier part…
>>
>> <SNIP>
>>

