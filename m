Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E5A92DAE01
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 14:31:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727114AbgLONap (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 08:30:45 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:50735 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727038AbgLONaX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 08:30:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608038934;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6eeo8Ye6UfGjKYpt3nL8YdwOzf2ER5qXBUTuYett2vM=;
        b=T9xeyJYWcAfCKebQ3fBak3vXU6EhIAztMVo4+kr2sJ+XmAMRhLo28C8/pYSPE7bEyFusT8
        ip7vqB377rxWL4iNc4EnqyKcieVfKR6qA3UO8Kv0xiChfGsdxCfWEa7YxSrufnigzL6KbP
        BnxvREIp6KHaRKg5dv1870D8IwZxhZo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-264-755MRjIwN4uJoYE0aCEFpA-1; Tue, 15 Dec 2020 08:28:50 -0500
X-MC-Unique: 755MRjIwN4uJoYE0aCEFpA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9742D801817;
        Tue, 15 Dec 2020 13:28:49 +0000 (UTC)
Received: from [10.36.113.44] (ovpn-113-44.ams2.redhat.com [10.36.113.44])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id AACF560861;
        Tue, 15 Dec 2020 13:28:48 +0000 (UTC)
From:   "Eelco Chaudron" <echaudro@redhat.com>
To:     "Maciej Fijalkowski" <maciej.fijalkowski@intel.com>
Cc:     "Lorenzo Bianconi" <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v5 bpf-next 13/14] bpf: add new frame_length field to the
 XDP ctx
Date:   Tue, 15 Dec 2020 14:28:39 +0100
Message-ID: <38C60760-4F8C-43AC-A5DE-7FAECB65C310@redhat.com>
In-Reply-To: <170BF39B-894D-495F-93E0-820EC7880328@redhat.com>
References: <cover.1607349924.git.lorenzo@kernel.org>
 <0547d6f752e325f56a8e5f6466b50e81ff29d65f.1607349924.git.lorenzo@kernel.org>
 <20201208221746.GA33399@ranger.igk.intel.com>
 <96C89134-A747-4E05-AA11-CB6EA1420900@redhat.com>
 <20201209111047.GB36812@ranger.igk.intel.com>
 <170BF39B-894D-495F-93E0-820EC7880328@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9 Dec 2020, at 13:07, Eelco Chaudron wrote:

> On 9 Dec 2020, at 12:10, Maciej Fijalkowski wrote:

<SNIP>

>>>>> +
>>>>> +		ctx_reg = (si->src_reg == si->dst_reg) ? scratch_reg - 1 :
>>>>> si->src_reg;
>>>>> +		while (dst_reg == ctx_reg || scratch_reg == ctx_reg)
>>>>> +			ctx_reg--;
>>>>> +
>>>>> +		/* Save scratch registers */
>>>>> +		if (ctx_reg != si->src_reg) {
>>>>> +			*insn++ = BPF_STX_MEM(BPF_DW, si->src_reg, ctx_reg,
>>>>> +					      offsetof(struct xdp_buff,
>>>>> +						       tmp_reg[1]));
>>>>> +
>>>>> +			*insn++ = BPF_MOV64_REG(ctx_reg, si->src_reg);
>>>>> +		}
>>>>> +
>>>>> +		*insn++ = BPF_STX_MEM(BPF_DW, ctx_reg, scratch_reg,
>>>>> +				      offsetof(struct xdp_buff, tmp_reg[0]));
>>>>
>>>> Why don't you push regs to stack, use it and then pop it back? That 
>>>> way
>>>> I
>>>> suppose you could avoid polluting xdp_buff with tmp_reg[2].
>>>
>>> There is no “real” stack in eBPF, only a read-only frame 
>>> pointer, and as we
>>> are replacing a single instruction, we have no info on what we can 
>>> use as
>>> scratch space.
>>
>> Uhm, what? You use R10 for stack operations. Verifier tracks the 
>> stack
>> depth used by programs and then it is passed down to JIT so that 
>> native
>> asm will create a properly sized stack frame.
>>
>> From the top of my head I would let know xdp_convert_ctx_access of a
>> current stack depth and use it for R10 stores, so your scratch space 
>> would
>> be R10 + (stack depth + 8), R10 + (stack_depth + 16).
>
> Other instances do exactly the same, i.e. put some scratch registers 
> in the underlying data structure, so I reused this approach. From the 
> current information in the callback, I was not able to determine the 
> current stack_depth. With "real" stack above, I meant having a 
> pop/push like instruction.
>
> I do not know the verifier code well enough, but are you suggesting I 
> can get the current stack_depth from the verifier in the 
> xdp_convert_ctx_access() callback? If so any pointers?

Maciej any feedback on the above, i.e. getting the stack_depth in 
xdp_convert_ctx_access()?

>> Problem with that would be the fact that convert_ctx_accesses() 
>> happens to
>> be called after the check_max_stack_depth(), so probably stack_depth 
>> of a
>> prog that has frame_length accesses would have to be adjusted 
>> earlier.
>
> Ack, need to learn more on the verifier part…

<SNIP>

