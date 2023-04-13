Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A01D66E0A4A
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 11:31:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbjDMJbY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 05:31:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229764AbjDMJbW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 05:31:22 -0400
X-Greylist: delayed 308 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 13 Apr 2023 02:31:16 PDT
Received: from smtpout3.r2.mail-out.ovh.net (smtpout3.r2.mail-out.ovh.net [54.36.141.3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1B218A7B
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 02:31:16 -0700 (PDT)
Received: from ex4.mail.ovh.net (unknown [10.109.146.56])
        by mo511.mail-out.ovh.net (Postfix) with ESMTPS id EE39B268EC;
        Thu, 13 Apr 2023 09:26:03 +0000 (UTC)
Received: from [192.168.1.125] (93.21.160.242) by DAG10EX1.indiv4.local
 (172.16.2.91) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.23; Thu, 13 Apr
 2023 11:26:00 +0200
Message-ID: <53f85025-2516-d50a-c233-95ed273f46fd@naccy.de>
Date:   Thu, 13 Apr 2023 11:26:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH bpf-next 0/6] bpf: add netfilter program type
Content-Language: en-US
To:     Florian Westphal <fw@strlen.de>
CC:     <netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
        <bpf@vger.kernel.org>, <dxu@dxuuu.xyz>
References: <20230405161116.13565-1-fw@strlen.de>
 <7d97222a-36c1-ee77-4ad6-d8d2c6056d4c@naccy.de>
 <20230412094554.GD6670@breakpoint.cc>
From:   Quentin Deslandes <qde@naccy.de>
In-Reply-To: <20230412094554.GD6670@breakpoint.cc>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [93.21.160.242]
X-ClientProxiedBy: CAS9.indiv4.local (172.16.1.9) To DAG10EX1.indiv4.local
 (172.16.2.91)
X-Ovh-Tracer-Id: 14604329170700922478
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvhedrvdekkedgudeiucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepkfffgggfuffvvehfhfgjtgfgihesthejredttddvjeenucfhrhhomhepsfhuvghnthhinhcuffgvshhlrghnuggvshcuoehquggvsehnrggttgihrdguvgeqnecuggftrfgrthhtvghrnheptdfgveetgfetkeejvefhudeiueeufeeffeeitdffjeevudehveejveegffdvkeefnecukfhppeduvdejrddtrddtrddupdelfedrvddurdduiedtrddvgedvnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehinhgvthepuddvjedrtddrtddruddpmhgrihhlfhhrohhmpeeoqhguvgesnhgrtggthidruggvqedpnhgspghrtghpthhtohepuddprhgtphhtthhopehffiesshhtrhhlvghnrdguvgdpnhgvthguvghvsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhnvghtfhhilhhtvghrqdguvghvvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdgsphhfsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdgugihusegugihuuhhurdighiiipdfovfetjfhoshhtpehmohehuddupdhmohguvgepshhmthhpohhuth
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/04/2023 11:45, Florian Westphal wrote:
> Quentin Deslandes <qde@naccy.de> wrote:
>> On 05/04/2023 18:11, Florian Westphal wrote:
>>> Add minimal support to hook bpf programs to netfilter hooks, e.g.
>>> PREROUTING or FORWARD.
>>>
>>> For this the most relevant parts for registering a netfilter
>>> hook via the in-kernel api are exposed to userspace via bpf_link.
>>>
>>> The new program type is 'tracing style', i.e. there is no context
>>> access rewrite done by verifier, the function argument (struct bpf_nf_ctx)
>>> isn't stable.
>>> There is no support for direct packet access, dynptr api should be used
>>> instead.
>>
>> Does this mean the verifier will reject any program accessing ctx->skb
>> (e.g. ctx->skb + X)?
> 
> Do you mean access to ctx->skb->data + X?  If so, yes, that won't work.
> 
> Otherwise, then no, it just means that programs might have to be recompiled
> if they lack needed relocation information, but only if bpf_nf_ctx structure is
> changed.
> 
> Initial version used "__sk_buff *skb", like e.g. clsact.  I was told
> to not do that and expose the real kernel-side structure instead and to
> not bother with direct packet access (skb->data access) support.
> 

That's exactly what I meant, thanks.

>>>  #include "vmlinux.h"
>>> extern int bpf_dynptr_from_skb(struct __sk_buff *skb, __u64 flags,
>>>                                struct bpf_dynptr *ptr__uninit) __ksym;
>>> extern void *bpf_dynptr_slice(const struct bpf_dynptr *ptr, uint32_t offset,
>>>                                    void *buffer, uint32_t buffer__sz) __ksym;
>>> SEC("netfilter")
>>> int nf_test(struct bpf_nf_ctx *ctx)
>>> {
>>> 	struct nf_hook_state *state = ctx->state;
>>> 	struct sk_buff *skb = ctx->skb;
> 
> ctx->skb is dereferenced...
> 
>>> 	if (bpf_dynptr_from_skb(skb, 0, &ptr))
>>> 		return NF_DROP;
> 
> ... dynptr is created ...
> 
>>> 	iph = bpf_dynptr_slice(&ptr, 0, &_iph, sizeof(_iph));
>>> 	if (!iph)
>>> 		return NF_DROP;
>>> 	th = bpf_dynptr_slice(&ptr, iph->ihl << 2, &_th, sizeof(_th));
> 
> ip header access.

