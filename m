Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E72274CBE51
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 14:00:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233471AbiCCNBa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 08:01:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbiCCNBa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 08:01:30 -0500
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E281218640F;
        Thu,  3 Mar 2022 05:00:41 -0800 (PST)
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1nPl4Q-000A2h-Pp; Thu, 03 Mar 2022 14:00:38 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1nPl4Q-0000aM-GP; Thu, 03 Mar 2022 14:00:38 +0100
Subject: Re: [PATCH v6 net-next 11/13] bpf: Keep the (rcv) timestamp behavior
 for the existing tc-bpf@ingress
To:     Martin KaFai Lau <kafai@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, kernel-team@fb.com,
        Willem de Bruijn <willemb@google.com>
References: <20220302195519.3479274-1-kafai@fb.com>
 <20220302195628.3484598-1-kafai@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <9cfeb60e-5d72-8e5e-2e34-5239edc3c09d@iogearbox.net>
Date:   Thu, 3 Mar 2022 14:00:37 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20220302195628.3484598-1-kafai@fb.com>
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

On 3/2/22 8:56 PM, Martin KaFai Lau wrote:
> The current tc-bpf@ingress reads and writes the __sk_buff->tstamp
> as a (rcv) timestamp which currently could either be 0 (not available)
> or ktime_get_real().  This patch is to backward compatible with the
> (rcv) timestamp expectation at ingress.  If the skb->tstamp has
> the delivery_time, the bpf insn rewrite will read 0 for tc-bpf
> running at ingress as it is not available.  When writing at ingress,
> it will also clear the skb->mono_delivery_time bit.
> 
> /* BPF_READ: a = __sk_buff->tstamp */
> if (!skb->tc_at_ingress || !skb->mono_delivery_time)
> 	a = skb->tstamp;
> else
> 	a = 0
> 
> /* BPF_WRITE: __sk_buff->tstamp = a */
> if (skb->tc_at_ingress)
> 	skb->mono_delivery_time = 0;
> skb->tstamp = a;
> 
> [ A note on the BPF_CGROUP_INET_INGRESS which can also access
>    skb->tstamp.  At that point, the skb is delivered locally
>    and skb_clear_delivery_time() has already been done,
>    so the skb->tstamp will only have the (rcv) timestamp. ]
> 
> If the tc-bpf@egress writes 0 to skb->tstamp, the skb->mono_delivery_time
> has to be cleared also.  It could be done together during
> convert_ctx_access().  However, the latter patch will also expose
> the skb->mono_delivery_time bit as __sk_buff->delivery_time_type.
> Changing the delivery_time_type in the background may surprise
> the user, e.g. the 2nd read on __sk_buff->delivery_time_type
> may need a READ_ONCE() to avoid compiler optimization.  Thus,
> in expecting the needs in the latter patch, this patch does a
> check on !skb->tstamp after running the tc-bpf and clears the
> skb->mono_delivery_time bit if needed.  The earlier discussion
> on v4 [0].
> 
> The bpf insn rewrite requires the skb's mono_delivery_time bit and
> tc_at_ingress bit.  They are moved up in sk_buff so that bpf rewrite
> can be done at a fixed offset.  tc_skip_classify is moved together with
> tc_at_ingress.  To get one bit for mono_delivery_time, csum_not_inet is
> moved down and this bit is currently used by sctp.
> 
> [0]: https://lore.kernel.org/bpf/20220217015043.khqwqklx45c4m4se@kafai-mbp.dhcp.thefacebook.com/
> 
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> ---
>   include/linux/skbuff.h | 18 +++++++----
>   net/core/filter.c      | 71 ++++++++++++++++++++++++++++++++++++------
>   net/sched/act_bpf.c    |  2 ++
>   net/sched/cls_bpf.c    |  2 ++
>   4 files changed, 77 insertions(+), 16 deletions(-)
> 
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index 4b5b926a81f2..5445860e1ba6 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -941,8 +941,12 @@ struct sk_buff {
>   	__u8			vlan_present:1;	/* See PKT_VLAN_PRESENT_BIT */
>   	__u8			csum_complete_sw:1;
>   	__u8			csum_level:2;
> -	__u8			csum_not_inet:1;
>   	__u8			dst_pending_confirm:1;
> +	__u8			mono_delivery_time:1;
> +#ifdef CONFIG_NET_CLS_ACT
> +	__u8			tc_skip_classify:1;
> +	__u8			tc_at_ingress:1;
> +#endif
>   #ifdef CONFIG_IPV6_NDISC_NODETYPE
>   	__u8			ndisc_nodetype:2;
>   #endif
> @@ -953,10 +957,6 @@ struct sk_buff {
>   #ifdef CONFIG_NET_SWITCHDEV
>   	__u8			offload_fwd_mark:1;
>   	__u8			offload_l3_fwd_mark:1;
> -#endif
> -#ifdef CONFIG_NET_CLS_ACT
> -	__u8			tc_skip_classify:1;
> -	__u8			tc_at_ingress:1;
>   #endif
>   	__u8			redirected:1;
>   #ifdef CONFIG_NET_REDIRECT
> @@ -969,7 +969,7 @@ struct sk_buff {
>   	__u8			decrypted:1;
>   #endif
>   	__u8			slow_gro:1;
> -	__u8			mono_delivery_time:1;
> +	__u8			csum_not_inet:1;
>   
>   #ifdef CONFIG_NET_SCHED
>   	__u16			tc_index;	/* traffic control index */
> @@ -1047,10 +1047,16 @@ struct sk_buff {
>   /* if you move pkt_vlan_present around you also must adapt these constants */
>   #ifdef __BIG_ENDIAN_BITFIELD
>   #define PKT_VLAN_PRESENT_BIT	7
> +#define TC_AT_INGRESS_MASK		(1 << 0)
> +#define SKB_MONO_DELIVERY_TIME_MASK	(1 << 2)
>   #else
>   #define PKT_VLAN_PRESENT_BIT	0
> +#define TC_AT_INGRESS_MASK		(1 << 7)
> +#define SKB_MONO_DELIVERY_TIME_MASK	(1 << 5)
>   #endif
>   #define PKT_VLAN_PRESENT_OFFSET	offsetof(struct sk_buff, __pkt_vlan_present_offset)
> +#define TC_AT_INGRESS_OFFSET offsetof(struct sk_buff, __pkt_vlan_present_offset)
> +#define SKB_MONO_DELIVERY_TIME_OFFSET offsetof(struct sk_buff, __pkt_vlan_present_offset)

Just nit, but given PKT_VLAN_PRESENT_OFFSET, TC_AT_INGRESS_OFFSET and SKB_MONO_DELIVERY_TIME_OFFSET
are all the same offsetof(struct sk_buff, __pkt_vlan_present_offset), maybe lets use just one single
define? If anyone moves them out, they would have to adopt as per comment.

>   #ifdef __KERNEL__
>   /*
> diff --git a/net/core/filter.c b/net/core/filter.c
> index cfcf9b4d1ec2..5072733743e9 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -8859,6 +8859,65 @@ static struct bpf_insn *bpf_convert_shinfo_access(const struct bpf_insn *si,
>   	return insn;
>   }
>   
> +static struct bpf_insn *bpf_convert_tstamp_read(const struct bpf_insn *si,
> +						struct bpf_insn *insn)
> +{
> +	__u8 value_reg = si->dst_reg;
> +	__u8 skb_reg = si->src_reg;
> +
> +#ifdef CONFIG_NET_CLS_ACT
> +	__u8 tmp_reg = BPF_REG_AX;
> +
> +	*insn++ = BPF_LDX_MEM(BPF_B, tmp_reg, skb_reg, TC_AT_INGRESS_OFFSET);
> +	*insn++ = BPF_ALU32_IMM(BPF_AND, tmp_reg, TC_AT_INGRESS_MASK);

nit: As far as I can see, can't si->dst_reg be used instead of AX?

> +	*insn++ = BPF_JMP32_IMM(BPF_JEQ, tmp_reg, 0, 5);
> +	/* @ingress, read __sk_buff->tstamp as the (rcv) timestamp,
> +	 * so check the skb->mono_delivery_time.
> +	 */
> +	*insn++ = BPF_LDX_MEM(BPF_B, tmp_reg, skb_reg,
> +			      SKB_MONO_DELIVERY_TIME_OFFSET);
> +	*insn++ = BPF_ALU32_IMM(BPF_AND, tmp_reg,
> +				SKB_MONO_DELIVERY_TIME_MASK);
> +	*insn++ = BPF_JMP32_IMM(BPF_JEQ, tmp_reg, 0, 2);
> +	/* skb->mono_delivery_time is set, read 0 as the (rcv) timestamp. */
> +	*insn++ = BPF_MOV64_IMM(value_reg, 0);
> +	*insn++ = BPF_JMP_A(1);
> +#endif
> +
> +	*insn++ = BPF_LDX_MEM(BPF_DW, value_reg, skb_reg,
> +			      offsetof(struct sk_buff, tstamp));
> +	return insn;
> +}
> +
> +static struct bpf_insn *bpf_convert_tstamp_write(const struct bpf_insn *si,
> +						 struct bpf_insn *insn)
> +{
> +	__u8 value_reg = si->src_reg;
> +	__u8 skb_reg = si->dst_reg;
> +
> +#ifdef CONFIG_NET_CLS_ACT
> +	__u8 tmp_reg = BPF_REG_AX;
> +
> +	*insn++ = BPF_LDX_MEM(BPF_B, tmp_reg, skb_reg, TC_AT_INGRESS_OFFSET);
> +	*insn++ = BPF_ALU32_IMM(BPF_AND, tmp_reg, TC_AT_INGRESS_MASK);

Can't we get rid of tcf_bpf_act() and cls_bpf_classify() changes altogether by just doing:

   /* BPF_WRITE: __sk_buff->tstamp = a */
   skb->mono_delivery_time = !skb->tc_at_ingress && a;
   skb->tstamp = a;

(Untested) pseudo code:

   // or see comment on common SKB_FLAGS_OFFSET define or such
   BUILD_BUG_ON(TC_AT_INGRESS_OFFSET != SKB_MONO_DELIVERY_TIME_OFFSET)

   BPF_LDX_MEM(BPF_B, tmp_reg, skb_reg, SKB_MONO_DELIVERY_TIME_OFFSET)
   BPF_ALU32_IMM(BPF_OR, tmp_reg, SKB_MONO_DELIVERY_TIME_MASK)
   BPF_JMP32_IMM(BPF_JSET, tmp_reg, TC_AT_INGRESS_MASK, <clear>)
   BPF_JMP32_REG(BPF_JGE, value_reg, tmp_reg, <store>)
<clear>:
   BPF_ALU32_IMM(BPF_AND, tmp_reg, ~SKB_MONO_DELIVERY_TIME_MASK)
<store>:
   BPF_STX_MEM(BPF_B, skb_reg, tmp_reg, SKB_MONO_DELIVERY_TIME_OFFSET)
   BPF_STX_MEM(BPF_DW, skb_reg, value_reg, offsetof(struct sk_buff, tstamp))

(There's a small hack with the BPF_JGE for tmp_reg, so constant blinding for AX doesn't
get into our way.)

> +	*insn++ = BPF_JMP32_IMM(BPF_JEQ, tmp_reg, 0, 3);
> +	/* Writing __sk_buff->tstamp at ingress as the (rcv) timestamp.
> +	 * Clear the skb->mono_delivery_time.
> +	 */
> +	*insn++ = BPF_LDX_MEM(BPF_B, tmp_reg, skb_reg,
> +			      SKB_MONO_DELIVERY_TIME_OFFSET);
> +	*insn++ = BPF_ALU32_IMM(BPF_AND, tmp_reg,
> +				~SKB_MONO_DELIVERY_TIME_MASK);
> +	*insn++ = BPF_STX_MEM(BPF_B, skb_reg, tmp_reg,
> +			      SKB_MONO_DELIVERY_TIME_OFFSET);
> +#endif
> +
> +	/* skb->tstamp = tstamp */
> +	*insn++ = BPF_STX_MEM(BPF_DW, skb_reg, value_reg,
> +			      offsetof(struct sk_buff, tstamp));
> +	return insn;
> +}
> +
>   static u32 bpf_convert_ctx_access(enum bpf_access_type type,
>   				  const struct bpf_insn *si,
>   				  struct bpf_insn *insn_buf,
> @@ -9167,17 +9226,9 @@ static u32 bpf_convert_ctx_access(enum bpf_access_type type,
>   		BUILD_BUG_ON(sizeof_field(struct sk_buff, tstamp) != 8);
>   
>   		if (type == BPF_WRITE)
> -			*insn++ = BPF_STX_MEM(BPF_DW,
> -					      si->dst_reg, si->src_reg,
> -					      bpf_target_off(struct sk_buff,
> -							     tstamp, 8,
> -							     target_size));
> +			insn = bpf_convert_tstamp_write(si, insn);
>   		else
> -			*insn++ = BPF_LDX_MEM(BPF_DW,
> -					      si->dst_reg, si->src_reg,
> -					      bpf_target_off(struct sk_buff,
> -							     tstamp, 8,
> -							     target_size));
> +			insn = bpf_convert_tstamp_read(si, insn);
>   		break;
>   
>   	case offsetof(struct __sk_buff, gso_segs):
> diff --git a/net/sched/act_bpf.c b/net/sched/act_bpf.c
> index a77d8908e737..fea2d78b9ddc 100644
> --- a/net/sched/act_bpf.c
> +++ b/net/sched/act_bpf.c
> @@ -53,6 +53,8 @@ static int tcf_bpf_act(struct sk_buff *skb, const struct tc_action *act,
>   		bpf_compute_data_pointers(skb);
>   		filter_res = bpf_prog_run(filter, skb);
>   	}
> +	if (unlikely(!skb->tstamp && skb->mono_delivery_time))
> +		skb->mono_delivery_time = 0;
>   	if (skb_sk_is_prefetched(skb) && filter_res != TC_ACT_OK)
>   		skb_orphan(skb);
>   
> diff --git a/net/sched/cls_bpf.c b/net/sched/cls_bpf.c
> index df19a847829e..c85b85a192bf 100644
> --- a/net/sched/cls_bpf.c
> +++ b/net/sched/cls_bpf.c
> @@ -102,6 +102,8 @@ static int cls_bpf_classify(struct sk_buff *skb, const struct tcf_proto *tp,
>   			bpf_compute_data_pointers(skb);
>   			filter_res = bpf_prog_run(prog->filter, skb);
>   		}
> +		if (unlikely(!skb->tstamp && skb->mono_delivery_time))
> +			skb->mono_delivery_time = 0;
>   
>   		if (prog->exts_integrated) {
>   			res->class   = 0;
> 

