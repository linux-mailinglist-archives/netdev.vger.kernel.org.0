Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E7144CC988
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 23:56:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237122AbiCCW4w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 17:56:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237113AbiCCW4v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 17:56:51 -0500
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82966EC5F4;
        Thu,  3 Mar 2022 14:56:01 -0800 (PST)
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1nPuMW-00016K-5e; Thu, 03 Mar 2022 23:55:56 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1nPuMV-0005BI-TE; Thu, 03 Mar 2022 23:55:55 +0100
Subject: Re: [PATCH v6 net-next 11/13] bpf: Keep the (rcv) timestamp behavior
 for the existing tc-bpf@ingress
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, kernel-team@fb.com,
        Willem de Bruijn <willemb@google.com>
References: <20220302195519.3479274-1-kafai@fb.com>
 <20220302195628.3484598-1-kafai@fb.com>
 <9cfeb60e-5d72-8e5e-2e34-5239edc3c09d@iogearbox.net>
 <20220303204303.bpqlpbyylodpax5x@kafai-mbp>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <419d994e-ff61-7c11-0ec7-11fefcb0186e@iogearbox.net>
Date:   Thu, 3 Mar 2022 23:55:55 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20220303204303.bpqlpbyylodpax5x@kafai-mbp>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.5/26470/Thu Mar  3 10:49:16 2022)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/3/22 9:43 PM, Martin KaFai Lau wrote:
> On Thu, Mar 03, 2022 at 02:00:37PM +0100, Daniel Borkmann wrote:
>> On 3/2/22 8:56 PM, Martin KaFai Lau wrote:
>>> If the tc-bpf@egress writes 0 to skb->tstamp, the skb->mono_delivery_time
>>> has to be cleared also.  It could be done together during
>>> convert_ctx_access().  However, the latter patch will also expose
>>> the skb->mono_delivery_time bit as __sk_buff->delivery_time_type.
>>> Changing the delivery_time_type in the background may surprise
>>> the user, e.g. the 2nd read on __sk_buff->delivery_time_type
>>> may need a READ_ONCE() to avoid compiler optimization.  Thus,
>>> in expecting the needs in the latter patch, this patch does a
>>> check on !skb->tstamp after running the tc-bpf and clears the
>>> skb->mono_delivery_time bit if needed.  The earlier discussion
>>> on v4 [0].
> 
> [ ... ]
> 
>>> @@ -1047,10 +1047,16 @@ struct sk_buff {
>>>    /* if you move pkt_vlan_present around you also must adapt these constants */
>>>    #ifdef __BIG_ENDIAN_BITFIELD
>>>    #define PKT_VLAN_PRESENT_BIT	7
>>> +#define TC_AT_INGRESS_MASK		(1 << 0)
>>> +#define SKB_MONO_DELIVERY_TIME_MASK	(1 << 2)
>>>    #else
>>>    #define PKT_VLAN_PRESENT_BIT	0
>>> +#define TC_AT_INGRESS_MASK		(1 << 7)
>>> +#define SKB_MONO_DELIVERY_TIME_MASK	(1 << 5)
>>>    #endif
>>>    #define PKT_VLAN_PRESENT_OFFSET	offsetof(struct sk_buff, __pkt_vlan_present_offset)
>>> +#define TC_AT_INGRESS_OFFSET offsetof(struct sk_buff, __pkt_vlan_present_offset)
>>> +#define SKB_MONO_DELIVERY_TIME_OFFSET offsetof(struct sk_buff, __pkt_vlan_present_offset)
>>
>> Just nit, but given PKT_VLAN_PRESENT_OFFSET, TC_AT_INGRESS_OFFSET and SKB_MONO_DELIVERY_TIME_OFFSET
>> are all the same offsetof(struct sk_buff, __pkt_vlan_present_offset), maybe lets use just one single
>> define? If anyone moves them out, they would have to adopt as per comment.
> Make sense.  I will update the comment, remove these two defines
> and reuse the PKT_VLAN_PRESENT_OFFSET.  Considering it
> is more bpf insn rewrite specific, I will do a
> follow-up in filter.c and skbuff.h at bpf-next.

Ok, sounds good!

>>>    #ifdef __KERNEL__
>>>    /*
>>> diff --git a/net/core/filter.c b/net/core/filter.c
>>> index cfcf9b4d1ec2..5072733743e9 100644
>>> --- a/net/core/filter.c
>>> +++ b/net/core/filter.c
>>> @@ -8859,6 +8859,65 @@ static struct bpf_insn *bpf_convert_shinfo_access(const struct bpf_insn *si,
>>>    	return insn;
>>>    }
>>> +static struct bpf_insn *bpf_convert_tstamp_read(const struct bpf_insn *si,
>>> +						struct bpf_insn *insn)
>>> +{
>>> +	__u8 value_reg = si->dst_reg;
>>> +	__u8 skb_reg = si->src_reg;
>>> +
>>> +#ifdef CONFIG_NET_CLS_ACT
>>> +	__u8 tmp_reg = BPF_REG_AX;
>>> +
>>> +	*insn++ = BPF_LDX_MEM(BPF_B, tmp_reg, skb_reg, TC_AT_INGRESS_OFFSET);
>>> +	*insn++ = BPF_ALU32_IMM(BPF_AND, tmp_reg, TC_AT_INGRESS_MASK);
>>
>> nit: As far as I can see, can't si->dst_reg be used instead of AX?
> Ah.  This one got me also when using dst_reg as a tmp. dst_reg and src_reg
> can be the same:
> 
> ;           skb->tstamp == EGRESS_FWDNS_MAGIC)
>       169:       r1 = *(u64 *)(r1 + 152)

Ah true, good point. Probably makes sense to add a small comment explaining
the rationale for use of AX here.

>>> +	*insn++ = BPF_JMP32_IMM(BPF_JEQ, tmp_reg, 0, 5);
>>> +	/* @ingress, read __sk_buff->tstamp as the (rcv) timestamp,
>>> +	 * so check the skb->mono_delivery_time.
>>> +	 */
>>> +	*insn++ = BPF_LDX_MEM(BPF_B, tmp_reg, skb_reg,
>>> +			      SKB_MONO_DELIVERY_TIME_OFFSET);
>>> +	*insn++ = BPF_ALU32_IMM(BPF_AND, tmp_reg,
>>> +				SKB_MONO_DELIVERY_TIME_MASK);
>>> +	*insn++ = BPF_JMP32_IMM(BPF_JEQ, tmp_reg, 0, 2);
>>> +	/* skb->mono_delivery_time is set, read 0 as the (rcv) timestamp. */
>>> +	*insn++ = BPF_MOV64_IMM(value_reg, 0);
>>> +	*insn++ = BPF_JMP_A(1);
>>> +#endif
>>> +
>>> +	*insn++ = BPF_LDX_MEM(BPF_DW, value_reg, skb_reg,
>>> +			      offsetof(struct sk_buff, tstamp));
>>> +	return insn;
>>> +}
>>> +
>>> +static struct bpf_insn *bpf_convert_tstamp_write(const struct bpf_insn *si,
>>> +						 struct bpf_insn *insn)
>>> +{
>>> +	__u8 value_reg = si->src_reg;
>>> +	__u8 skb_reg = si->dst_reg;
>>> +
>>> +#ifdef CONFIG_NET_CLS_ACT
>>> +	__u8 tmp_reg = BPF_REG_AX;
>>> +
>>> +	*insn++ = BPF_LDX_MEM(BPF_B, tmp_reg, skb_reg, TC_AT_INGRESS_OFFSET);
>>> +	*insn++ = BPF_ALU32_IMM(BPF_AND, tmp_reg, TC_AT_INGRESS_MASK);
>>
>> Can't we get rid of tcf_bpf_act() and cls_bpf_classify() changes altogether by just doing:
>>
>>    /* BPF_WRITE: __sk_buff->tstamp = a */
>>    skb->mono_delivery_time = !skb->tc_at_ingress && a;
>>    skb->tstamp = a;
> It will then assume the bpf prog is writing a mono time.
> Although mono should always be the case now,  this assumption will be
> an issue in the future if we need to support non-mono.

Right, for that we should probably instrument verifier to track base based
on ktime helper call once we get to that point.

>> (Untested) pseudo code:
>>
>>    // or see comment on common SKB_FLAGS_OFFSET define or such
>>    BUILD_BUG_ON(TC_AT_INGRESS_OFFSET != SKB_MONO_DELIVERY_TIME_OFFSET)
>>
>>    BPF_LDX_MEM(BPF_B, tmp_reg, skb_reg, SKB_MONO_DELIVERY_TIME_OFFSET)
>>    BPF_ALU32_IMM(BPF_OR, tmp_reg, SKB_MONO_DELIVERY_TIME_MASK)
>>    BPF_JMP32_IMM(BPF_JSET, tmp_reg, TC_AT_INGRESS_MASK, <clear>)
> This can save a BPF_ALU32_IMM(BPF_AND).  I will do that
> together in the follow up. Thanks for the idea !

Yeah the JSET comes in handy here.

>>    BPF_JMP32_REG(BPF_JGE, value_reg, tmp_reg, <store>)
>> <clear>:
>>    BPF_ALU32_IMM(BPF_AND, tmp_reg, ~SKB_MONO_DELIVERY_TIME_MASK)
>> <store>:
>>    BPF_STX_MEM(BPF_B, skb_reg, tmp_reg, SKB_MONO_DELIVERY_TIME_OFFSET)
>>    BPF_STX_MEM(BPF_DW, skb_reg, value_reg, offsetof(struct sk_buff, tstamp))
>>
>> (There's a small hack with the BPF_JGE for tmp_reg, so constant blinding for AX doesn't
>> get into our way.)
>>
>>> +	*insn++ = BPF_JMP32_IMM(BPF_JEQ, tmp_reg, 0, 3);
>>> +	/* Writing __sk_buff->tstamp at ingress as the (rcv) timestamp.
>>> +	 * Clear the skb->mono_delivery_time.
>>> +	 */
>>> +	*insn++ = BPF_LDX_MEM(BPF_B, tmp_reg, skb_reg,
>>> +			      SKB_MONO_DELIVERY_TIME_OFFSET);
>>> +	*insn++ = BPF_ALU32_IMM(BPF_AND, tmp_reg,
>>> +				~SKB_MONO_DELIVERY_TIME_MASK);
>>> +	*insn++ = BPF_STX_MEM(BPF_B, skb_reg, tmp_reg,
>>> +			      SKB_MONO_DELIVERY_TIME_OFFSET);
>>> +#endif
>>> +
>>> +	/* skb->tstamp = tstamp */
>>> +	*insn++ = BPF_STX_MEM(BPF_DW, skb_reg, value_reg,
>>> +			      offsetof(struct sk_buff, tstamp));
>>> +	return insn;
>>> +}
>>> +

