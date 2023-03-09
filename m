Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07C6F6B189B
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 02:16:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229900AbjCIBQw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 20:16:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229705AbjCIBQu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 20:16:50 -0500
Received: from out-41.mta0.migadu.com (out-41.mta0.migadu.com [91.218.175.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFD85CC320
        for <netdev@vger.kernel.org>; Wed,  8 Mar 2023 17:16:45 -0800 (PST)
Message-ID: <c3b8f7f1-486b-be53-5501-b35380bf238d@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1678324603;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=n/VqSdDwDxUJggwHjttxJoAar0Dhzdi2fjG4sO3x8kE=;
        b=U9minMslNMK0aA+GXjz7cVBzoGBIMAe1LnzDP1QSJteCbrRRtZjzmgIGkbWqB67wDSQf/R
        S+1vwUdR2Pk9k1rCvjIscjafdPKuXLL5uttBsoSYw9B8K3ma/w/2TMOK0r0v1bHkPsIlu4
        JWitWFxHj773k9GlixQt7aO1IA57gi0=
Date:   Wed, 8 Mar 2023 17:16:40 -0800
MIME-Version: 1.0
Subject: Re: [PATCH bpf-next 1/3] net: skbuff: rename
 __pkt_vlan_present_offset to __mono_tc_offset
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, bpf <bpf@vger.kernel.org>
References: <20230308003159.441580-1-kuba@kernel.org>
 <20230308003159.441580-2-kuba@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <20230308003159.441580-2-kuba@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/7/23 4:31 PM, Jakub Kicinski wrote:
> vlan_present is gone since
> commit 354259fa73e2 ("net: remove skb->vlan_present")
> rename the offset field to what BPF is currently looking
> for in this byte - mono_delivery_time and tc_at_ingress.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>   include/linux/skbuff.h                               | 4 ++--
>   net/core/filter.c                                    | 8 ++++----
>   tools/testing/selftests/bpf/prog_tests/ctx_rewrite.c | 6 +++---
>   3 files changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index ff7ad331fb82..004009b3930f 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -956,7 +956,7 @@ struct sk_buff {
>   	__u8			csum_valid:1;
>   
>   	/* private: */
> -	__u8			__pkt_vlan_present_offset[0];
> +	__u8			__mono_tc_offset[0];
>   	/* public: */
>   	__u8			remcsum_offload:1;
>   	__u8			csum_complete_sw:1;
> @@ -1080,7 +1080,7 @@ struct sk_buff {
>   #define TC_AT_INGRESS_MASK		(1 << 7)
>   #define SKB_MONO_DELIVERY_TIME_MASK	(1 << 5)
>   #endif
> -#define PKT_VLAN_PRESENT_OFFSET	offsetof(struct sk_buff, __pkt_vlan_present_offset)
> +#define SKB_BF_MONO_TC_OFFSET		offsetof(struct sk_buff, __mono_tc_offset)
>   
>   #ifdef __KERNEL__
>   /*
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 50f649f1b4a9..3370efad1dda 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -9185,7 +9185,7 @@ static struct bpf_insn *bpf_convert_tstamp_type_read(const struct bpf_insn *si,
>   	__u8 tmp_reg = BPF_REG_AX;
>   
>   	*insn++ = BPF_LDX_MEM(BPF_B, tmp_reg, skb_reg,
> -			      PKT_VLAN_PRESENT_OFFSET);
> +			      SKB_BF_MONO_TC_OFFSET);
>   	*insn++ = BPF_JMP32_IMM(BPF_JSET, tmp_reg,
>   				SKB_MONO_DELIVERY_TIME_MASK, 2);
>   	*insn++ = BPF_MOV32_IMM(value_reg, BPF_SKB_TSTAMP_UNSPEC);
> @@ -9232,7 +9232,7 @@ static struct bpf_insn *bpf_convert_tstamp_read(const struct bpf_prog *prog,
>   		/* AX is needed because src_reg and dst_reg could be the same */
>   		__u8 tmp_reg = BPF_REG_AX;
>   
> -		*insn++ = BPF_LDX_MEM(BPF_B, tmp_reg, skb_reg, PKT_VLAN_PRESENT_OFFSET);
> +		*insn++ = BPF_LDX_MEM(BPF_B, tmp_reg, skb_reg, SKB_BF_MONO_TC_OFFSET);
>   		*insn++ = BPF_ALU32_IMM(BPF_AND, tmp_reg,
>   					TC_AT_INGRESS_MASK | SKB_MONO_DELIVERY_TIME_MASK);
>   		*insn++ = BPF_JMP32_IMM(BPF_JNE, tmp_reg,
> @@ -9267,14 +9267,14 @@ static struct bpf_insn *bpf_convert_tstamp_write(const struct bpf_prog *prog,
>   	if (!prog->tstamp_type_access) {
>   		__u8 tmp_reg = BPF_REG_AX;
>   
> -		*insn++ = BPF_LDX_MEM(BPF_B, tmp_reg, skb_reg, PKT_VLAN_PRESENT_OFFSET);
> +		*insn++ = BPF_LDX_MEM(BPF_B, tmp_reg, skb_reg, SKB_BF_MONO_TC_OFFSET);
>   		/* Writing __sk_buff->tstamp as ingress, goto <clear> */
>   		*insn++ = BPF_JMP32_IMM(BPF_JSET, tmp_reg, TC_AT_INGRESS_MASK, 1);
>   		/* goto <store> */
>   		*insn++ = BPF_JMP_A(2);
>   		/* <clear>: mono_delivery_time */
>   		*insn++ = BPF_ALU32_IMM(BPF_AND, tmp_reg, ~SKB_MONO_DELIVERY_TIME_MASK);
> -		*insn++ = BPF_STX_MEM(BPF_B, skb_reg, tmp_reg, PKT_VLAN_PRESENT_OFFSET);
> +		*insn++ = BPF_STX_MEM(BPF_B, skb_reg, tmp_reg, SKB_BF_MONO_TC_OFFSET);
>   	}
>   #endif
>   
> diff --git a/tools/testing/selftests/bpf/prog_tests/ctx_rewrite.c b/tools/testing/selftests/bpf/prog_tests/ctx_rewrite.c
> index d5fe3d4b936c..ae7b6e50e405 100644
> --- a/tools/testing/selftests/bpf/prog_tests/ctx_rewrite.c
> +++ b/tools/testing/selftests/bpf/prog_tests/ctx_rewrite.c
> @@ -68,17 +68,17 @@ static struct test_case test_cases[] = {
>   #if defined(__x86_64__) || defined(__aarch64__)
>   	{
>   		N(SCHED_CLS, struct __sk_buff, tstamp),
> -		.read  = "r11 = *(u8 *)($ctx + sk_buff::__pkt_vlan_present_offset);"
> +		.read  = "r11 = *(u8 *)($ctx + sk_buff::__mono_tc_offset);"
>   			 "w11 &= 160;"

The mask needs to be adjusted also after patch 3. This selftest is failing: 
https://github.com/kernel-patches/bpf/actions/runs/4369844423/jobs/7644281598

>   			 "if w11 != 0xa0 goto pc+2;"
>   			 "$dst = 0;"
>   			 "goto pc+1;"
>   			 "$dst = *(u64 *)($ctx + sk_buff::tstamp);",
> -		.write = "r11 = *(u8 *)($ctx + sk_buff::__pkt_vlan_present_offset);"
> +		.write = "r11 = *(u8 *)($ctx + sk_buff::__mono_tc_offset);"
>   			 "if w11 & 0x80 goto pc+1;"

It probably needs to adjust here also

>   			 "goto pc+2;"
>   			 "w11 &= -33;"

and here.

> -			 "*(u8 *)($ctx + sk_buff::__pkt_vlan_present_offset) = r11;"
> +			 "*(u8 *)($ctx + sk_buff::__mono_tc_offset) = r11;"
>   			 "*(u64 *)($ctx + sk_buff::tstamp) = $src;",
>   	},
>   #endif

