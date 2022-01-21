Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7FB5496543
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 19:50:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229452AbiAUSut (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 13:50:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229705AbiAUSuX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 13:50:23 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EFAAC061401
        for <netdev@vger.kernel.org>; Fri, 21 Jan 2022 10:50:23 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id c76-20020a25c04f000000b00613e2c514e2so16974151ybf.21
        for <netdev@vger.kernel.org>; Fri, 21 Jan 2022 10:50:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=1H4meivw/loyKrsClb/KtN41lQLgtIBeTyTOmK+neXM=;
        b=qIeSx192yWlft4UZfkNhlHgQAabZL6NxhcgDjMt6426XQtbTInvnTsSEwKRnbe/Uak
         SkVKspo8tAAMGKY9LU6JHHiC5X0ByZfN26g4QsDHoGt/Y57dJKlcg2rKXWaUjn4Fkamn
         z9Ne1j+djpiwi25dCDHcZHIVdr5igqhetp0xRvgMmhxCF73YbdQKd47wO4s6TKX654n/
         A1/3XjnDIgmSLlblHCY7f0L+0NG75dBdxTUbKoZIuLJFziTOJXUTTNIItidA6P89ifVS
         8NXlIxxP8TfZX+4MnqUXJ4Ej2uAd/+XggRO76paBB7sf/EUD6IhUM92Ywo4CVY7Gekj1
         xghA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=1H4meivw/loyKrsClb/KtN41lQLgtIBeTyTOmK+neXM=;
        b=aUMwIw2RLCzB0NMWG5qeHkaap27IgS2zW7F7KTPqkGw80QXPyMoeLVS9vi+F3fVyNj
         rpVo57xgcI570qul/DHsVj3b7s9FM4i31pYXKtRBFEyutKn0lCVTtxhVVtuJigSKSUe7
         X3SGFPwTtTlogTgKbebQR61x59c88KiAz2NubETkQmSWJ5y6L6iMRirMSVD5YHQ5rzdu
         H7cxI7oXzq7j8I7ywzd5AxiXeBFmPW9iDfO3lfLI7OBOlTFEHMdMroZtCfPFvC2zLVe2
         3C/6kSv3rO7OiMEtFLaBZ807yqMGiER96uU7GlI+V4U/CYbFCo8WT5K45NqeKDVZB1Yu
         0Plg==
X-Gm-Message-State: AOAM5306QqPU8GpiftnPrnuCXj91Zg5TFLYMM2WsKZKGI3/9/PcrsUN0
        ly5ehS8QAElBgWzY31frpi2mNIU=
X-Google-Smtp-Source: ABdhPJwKOr3Rs+R/7DOdiGPkCkkMkDHRQ0bCr89pjPtZ2+F7WZu8evEqD5UGVoLgEN6V02Z4hw6jgRY=
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:201:a647:98e5:9f:3032])
 (user=sdf job=sendgmr) by 2002:a25:e78a:: with SMTP id e132mr8291840ybh.515.1642791022754;
 Fri, 21 Jan 2022 10:50:22 -0800 (PST)
Date:   Fri, 21 Jan 2022 10:50:20 -0800
In-Reply-To: <20220121073051.4180328-1-kafai@fb.com>
Message-Id: <YesAbHLRYBJ8FwiK@google.com>
Mime-Version: 1.0
References: <20220121073026.4173996-1-kafai@fb.com> <20220121073051.4180328-1-kafai@fb.com>
Subject: Re: [RFC PATCH v3 net-next 4/4] bpf: Add __sk_buff->mono_delivery_time
 and handle __sk_buff->tstamp based on tc_at_ingress
From:   sdf@google.com
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, kernel-team@fb.com,
        Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01/20, Martin KaFai Lau wrote:
> __sk_buff->mono_delivery_time:
> This patch adds __sk_buff->mono_delivery_time to
> read and write the mono delivery_time in skb->tstamp.

> The bpf rewrite is like:
> /* BPF_READ: __u64 a = __sk_buff->mono_delivery_time; */
> if (skb->mono_delivery_time)
> 	a = skb->tstamp;
> else
> 	a = 0;

> /* BPF_WRITE: __sk_buff->mono_delivery_time = a; */
> skb->tstamp = a;
> skb->mono_delivery_time = !!a;

> __sk_buff->tstamp:
> The bpf rewrite is like:
> /* BPF_READ: __u64 a = __sk_buff->tstamp; */
> if (skb->tc_at_ingress && skb->mono_delivery_time)
> 	a = 0;
> else
> 	a = skb->tstamp;

> /* BPF_WRITE: __sk_buff->tstamp = a; */
> skb->tstamp = a;
> if (skb->tc_at_ingress || !a)
> 	skb->mono_delivery_time = 0;

> At egress, reading is the same as before.  All skb->tstamp
> is the delivery_time.  Writing will not change the (kernel)
> skb->mono_delivery_time also unless 0 is being written.  This
> will be the same behavior as before.

> (#) At ingress, the current bpf prog can only expect the
> (rcv) timestamp.  Thus, both reading and writing are now treated as
> operating on the (rcv) timestamp for the existing bpf prog.

> During bpf load time, the verifier will learn if the
> bpf prog has accessed the new __sk_buff->mono_delivery_time.

> When reading at ingress, if the bpf prog does not access the
> new __sk_buff->mono_delivery_time, it will be treated as the
> existing behavior as mentioned in (#) above.  If the (kernel) skb->tstamp
> currently has a delivery_time,  it will temporary be saved first and then
> set the skb->tstamp to either the ktime_get_real() or zero.  After
> the bpf prog finished running, if the bpf prog did not change
> the skb->tstamp,  the saved delivery_time will be restored
> back to the skb->tstamp.

> When writing __sk_buff->tstamp at ingress, the
> skb->mono_delivery_time will be cleared because of
> the (#) mentioned above.

> If the bpf prog does access the new __sk_buff->mono_delivery_time
> at ingress, it indicates that the bpf prog is aware of this new
> kernel support:
> the (kernel) skb->tstamp can have the delivery_time or the
> (rcv) timestamp at ingress.  If the __sk_buff->mono_delivery_time
> is available, the __sk_buff->tstamp will not be available and
> it will be zero.

> The bpf rewrite needs to access the skb's mono_delivery_time
> and tc_at_ingress bit.  They are moved up in sk_buff so
> that bpf rewrite can be done at a fixed offset.  tc_skip_classify
> is moved together with tc_at_ingress.  To get one bit for
> mono_delivery_time, csum_not_inet is moved down and this bit
> is currently used by sctp.

> Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> ---
>   include/linux/filter.h         |  31 +++++++-
>   include/linux/skbuff.h         |  20 +++--
>   include/uapi/linux/bpf.h       |   1 +
>   net/core/filter.c              | 134 ++++++++++++++++++++++++++++++---
>   net/sched/act_bpf.c            |   5 +-
>   net/sched/cls_bpf.c            |   6 +-
>   tools/include/uapi/linux/bpf.h |   1 +
>   7 files changed, 171 insertions(+), 27 deletions(-)

> diff --git a/include/linux/filter.h b/include/linux/filter.h
> index 71fa57b88bfc..5cef695d6575 100644
> --- a/include/linux/filter.h
> +++ b/include/linux/filter.h
> @@ -572,7 +572,8 @@ struct bpf_prog {
>   				has_callchain_buf:1, /* callchain buffer allocated? */
>   				enforce_expected_attach_type:1, /* Enforce expected_attach_type  
> checking at attach time */
>   				call_get_stack:1, /* Do we call bpf_get_stack() or bpf_get_stackid()  
> */
> -				call_get_func_ip:1; /* Do we call get_func_ip() */
> +				call_get_func_ip:1, /* Do we call get_func_ip() */
> +				delivery_time_access:1; /* Accessed __sk_buff->mono_delivery_time */
>   	enum bpf_prog_type	type;		/* Type of BPF program */
>   	enum bpf_attach_type	expected_attach_type; /* For some prog types */
>   	u32			len;		/* Number of filter blocks */
> @@ -699,6 +700,34 @@ static inline void bpf_compute_data_pointers(struct  
> sk_buff *skb)
>   	cb->data_end  = skb->data + skb_headlen(skb);
>   }

> +static __always_inline u32 bpf_prog_run_at_ingress(const struct bpf_prog  
> *prog,
> +						   struct sk_buff *skb)
> +{
> +	ktime_t tstamp, delivery_time = 0;
> +	int filter_res;
> +
> +	if (unlikely(skb->mono_delivery_time) && !prog->delivery_time_access) {
> +		delivery_time = skb->tstamp;
> +		skb->mono_delivery_time = 0;
> +		if (static_branch_unlikely(&netstamp_needed_key))
> +			skb->tstamp = tstamp = ktime_get_real();
> +		else
> +			skb->tstamp = tstamp = 0;
> +	}
> +
> +	/* It is safe to push/pull even if skb_shared() */
> +	__skb_push(skb, skb->mac_len);
> +	bpf_compute_data_pointers(skb);
> +	filter_res = bpf_prog_run(prog, skb);
> +	__skb_pull(skb, skb->mac_len);
> +
> +	/* __sk_buff->tstamp was not changed, restore the delivery_time */
> +	if (unlikely(delivery_time) && skb_tstamp(skb) == tstamp)
> +		skb_set_delivery_time(skb, delivery_time, true);
> +
> +	return filter_res;
> +}
> +
>   /* Similar to bpf_compute_data_pointers(), except that save orginal
>    * data in cb->data and cb->meta_data for restore.
>    */
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index 4677bb6c7279..a14b04b86c13 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -866,22 +866,23 @@ struct sk_buff {
>   	__u8			vlan_present:1;	/* See PKT_VLAN_PRESENT_BIT */
>   	__u8			csum_complete_sw:1;
>   	__u8			csum_level:2;
> -	__u8			csum_not_inet:1;
>   	__u8			dst_pending_confirm:1;
> +	__u8			mono_delivery_time:1;
> +
> +#ifdef CONFIG_NET_CLS_ACT
> +	__u8			tc_skip_classify:1;
> +	__u8			tc_at_ingress:1;
> +#endif
>   #ifdef CONFIG_IPV6_NDISC_NODETYPE
>   	__u8			ndisc_nodetype:2;
>   #endif
> -
> +	__u8			csum_not_inet:1;
>   	__u8			ipvs_property:1;
>   	__u8			inner_protocol_type:1;
>   	__u8			remcsum_offload:1;
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
> @@ -894,7 +895,6 @@ struct sk_buff {
>   	__u8			decrypted:1;
>   #endif
>   	__u8			slow_gro:1;
> -	__u8			mono_delivery_time:1;

>   #ifdef CONFIG_NET_SCHED
>   	__u16			tc_index;	/* traffic control index */
> @@ -972,10 +972,16 @@ struct sk_buff {
>   /* if you move pkt_vlan_present around you also must adapt these  
> constants */
>   #ifdef __BIG_ENDIAN_BITFIELD
>   #define PKT_VLAN_PRESENT_BIT	7
> +#define TC_AT_INGRESS_SHIFT	0
> +#define SKB_MONO_DELIVERY_TIME_SHIFT 2
>   #else
>   #define PKT_VLAN_PRESENT_BIT	0
> +#define TC_AT_INGRESS_SHIFT	7
> +#define SKB_MONO_DELIVERY_TIME_SHIFT 5
>   #endif
>   #define PKT_VLAN_PRESENT_OFFSET	offsetof(struct sk_buff,  
> __pkt_vlan_present_offset)
> +#define TC_AT_INGRESS_OFFSET offsetof(struct sk_buff,  
> __pkt_vlan_present_offset)
> +#define SKB_MONO_DELIVERY_TIME_OFFSET offsetof(struct sk_buff,  
> __pkt_vlan_present_offset)

>   #ifdef __KERNEL__
>   /*
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index b0383d371b9a..83725c891f3c 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -5437,6 +5437,7 @@ struct __sk_buff {
>   	__u32 gso_size;
>   	__u32 :32;		/* Padding, future use. */
>   	__u64 hwtstamp;
> +	__u64 mono_delivery_time;
>   };

>   struct bpf_tunnel_key {
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 4fc53d645a01..db17812f0f8c 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -7832,6 +7832,7 @@ static bool bpf_skb_is_valid_access(int off, int  
> size, enum bpf_access_type type
>   			return false;
>   		break;
>   	case bpf_ctx_range(struct __sk_buff, tstamp):
> +	case bpf_ctx_range(struct __sk_buff, mono_delivery_time):
>   		if (size != sizeof(__u64))
>   			return false;
>   		break;
> @@ -7872,6 +7873,7 @@ static bool sk_filter_is_valid_access(int off, int  
> size,
>   	case bpf_ctx_range(struct __sk_buff, tstamp):
>   	case bpf_ctx_range(struct __sk_buff, wire_len):
>   	case bpf_ctx_range(struct __sk_buff, hwtstamp):
> +	case bpf_ctx_range(struct __sk_buff, mono_delivery_time):
>   		return false;
>   	}

> @@ -7911,6 +7913,7 @@ static bool cg_skb_is_valid_access(int off, int  
> size,
>   		case bpf_ctx_range_till(struct __sk_buff, cb[0], cb[4]):
>   			break;
>   		case bpf_ctx_range(struct __sk_buff, tstamp):
> +		case bpf_ctx_range(struct __sk_buff, mono_delivery_time):
>   			if (!bpf_capable())
>   				return false;
>   			break;
> @@ -7943,6 +7946,7 @@ static bool lwt_is_valid_access(int off, int size,
>   	case bpf_ctx_range(struct __sk_buff, tstamp):
>   	case bpf_ctx_range(struct __sk_buff, wire_len):
>   	case bpf_ctx_range(struct __sk_buff, hwtstamp):
> +	case bpf_ctx_range(struct __sk_buff, mono_delivery_time):
>   		return false;
>   	}

> @@ -8169,6 +8173,7 @@ static bool tc_cls_act_is_valid_access(int off, int  
> size,
>   		case bpf_ctx_range_till(struct __sk_buff, cb[0], cb[4]):
>   		case bpf_ctx_range(struct __sk_buff, tstamp):
>   		case bpf_ctx_range(struct __sk_buff, queue_mapping):
> +		case bpf_ctx_range(struct __sk_buff, mono_delivery_time):
>   			break;
>   		default:
>   			return false;
> @@ -8445,6 +8450,7 @@ static bool sk_skb_is_valid_access(int off, int  
> size,
>   	case bpf_ctx_range(struct __sk_buff, tstamp):
>   	case bpf_ctx_range(struct __sk_buff, wire_len):
>   	case bpf_ctx_range(struct __sk_buff, hwtstamp):
> +	case bpf_ctx_range(struct __sk_buff, mono_delivery_time):
>   		return false;
>   	}

> @@ -8603,6 +8609,114 @@ static struct bpf_insn  
> *bpf_convert_shinfo_access(const struct bpf_insn *si,
>   	return insn;
>   }


[..]

> +static struct bpf_insn *bpf_convert_tstamp_read(const struct bpf_insn  
> *si,
> +						struct bpf_insn *insn)
> +{
> +	__u8 value_reg = si->dst_reg;
> +	__u8 skb_reg = si->src_reg;
> +	__u8 tmp_reg = BPF_REG_AX;
> +
> +#ifdef CONFIG_NET_CLS_ACT
> +	*insn++ = BPF_LDX_MEM(BPF_B, tmp_reg, skb_reg, TC_AT_INGRESS_OFFSET);
> +	*insn++ = BPF_ALU32_IMM(BPF_AND, tmp_reg, 1 << TC_AT_INGRESS_SHIFT);
> +	*insn++ = BPF_JMP32_IMM(BPF_JEQ, tmp_reg, 0, 5);
> +	/* @ingress, read __sk_buff->tstamp as the (rcv) timestamp,
> +	 * so check the skb->mono_delivery_time.
> +	 */
> +	*insn++ = BPF_LDX_MEM(BPF_B, tmp_reg, skb_reg,
> +			      SKB_MONO_DELIVERY_TIME_OFFSET);
> +	*insn++ = BPF_ALU32_IMM(BPF_AND, tmp_reg,
> +				1 << SKB_MONO_DELIVERY_TIME_SHIFT);
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
> +static struct bpf_insn *bpf_convert_tstamp_write(const struct bpf_insn  
> *si,
> +						 struct bpf_insn *insn)
> +{
> +	__u8 value_reg = si->src_reg;
> +	__u8 skb_reg = si->dst_reg;
> +	__u8 tmp_reg = BPF_REG_AX;
> +
> +	/* skb->tstamp = tstamp */
> +	*insn++ = BPF_STX_MEM(BPF_DW, skb_reg, value_reg,
> +			      offsetof(struct sk_buff, tstamp));
> +
> +#ifdef CONFIG_NET_CLS_ACT
> +	*insn++ = BPF_LDX_MEM(BPF_B, tmp_reg, skb_reg, TC_AT_INGRESS_OFFSET);
> +	*insn++ = BPF_ALU32_IMM(BPF_AND, tmp_reg, 1 << TC_AT_INGRESS_SHIFT);
> +	*insn++ = BPF_JMP32_IMM(BPF_JNE, tmp_reg, 0, 1);
> +#endif
> +
> +	/* test tstamp != 0 */
> +	*insn++ = BPF_JMP_IMM(BPF_JNE, value_reg, 0, 3);
> +	/* writing __sk_buff->tstamp at ingress or writing 0,
> +	 * clear the skb->mono_delivery_time.
> +	 */
> +	*insn++ = BPF_LDX_MEM(BPF_B, tmp_reg, skb_reg,
> +			      SKB_MONO_DELIVERY_TIME_OFFSET);
> +	*insn++ = BPF_ALU32_IMM(BPF_AND, tmp_reg,
> +				~(1 << SKB_MONO_DELIVERY_TIME_SHIFT));
> +	*insn++ = BPF_STX_MEM(BPF_B, skb_reg, tmp_reg,
> +			      SKB_MONO_DELIVERY_TIME_OFFSET);
> +
> +	return insn;
> +}

I wonder if we'll see the regression from this. We read/write tstamp
frequently and I'm not sure we care about the forwarding case.

As a future work/follow up, do you think we can support cases like
bpf_prog_load(prog_type=SCHED_CLS expected_attach_type=TC_EGRESS) where
we can generate bytecode with only BPF_LDX_MEM/BPF_STX_MEM for skb->tstamp?
(essentially a bytecode as it was prior to your patch series)

Since we know that that specific program will run only at egress,
I'm assuming we can generate simpler bytecode? (of coarse it needs more
work on cls_bpf to enforce this new expected_attach_type constraint)
