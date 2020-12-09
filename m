Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE9312D4016
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 11:38:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730146AbgLIKhI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 05:37:08 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27812 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729974AbgLIKhI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 05:37:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607510141;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dAql8gCv9yVOMYT8aJZ9hY04NH2fp35r42qf0N65spY=;
        b=Kydi39Q1dFGpS6qJusUyVsaZPWAYakI3Yi4BoP38n9j/6dLgYy4tlLb4pc3TGl7J9pxDxe
        I/FnxKfJAQeLFk1ydzK+BeNq/7UHlegCB7fKjN733RyhG3H+jPM0qq5/CIplWgqO1pi7tz
        BrTfenuRiDpGbXbig5+TlYAF/immawU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-433-DX5UoUEgM9quQoHsFIMBrg-1; Wed, 09 Dec 2020 05:35:33 -0500
X-MC-Unique: DX5UoUEgM9quQoHsFIMBrg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 162901052085;
        Wed,  9 Dec 2020 10:35:18 +0000 (UTC)
Received: from [10.36.113.83] (ovpn-113-83.ams2.redhat.com [10.36.113.83])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EDD95105B21F;
        Wed,  9 Dec 2020 10:35:14 +0000 (UTC)
From:   "Eelco Chaudron" <echaudro@redhat.com>
To:     "Maciej Fijalkowski" <maciej.fijalkowski@intel.com>
Cc:     "Lorenzo Bianconi" <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        sameehj@amazon.com, john.fastabend@gmail.com, dsahern@kernel.org,
        brouer@redhat.com, lorenzo.bianconi@redhat.com, jasowang@redhat.com
Subject: Re: [PATCH v5 bpf-next 13/14] bpf: add new frame_length field to the
 XDP ctx
Date:   Wed, 09 Dec 2020 11:35:13 +0100
Message-ID: <96C89134-A747-4E05-AA11-CB6EA1420900@redhat.com>
In-Reply-To: <20201208221746.GA33399@ranger.igk.intel.com>
References: <cover.1607349924.git.lorenzo@kernel.org>
 <0547d6f752e325f56a8e5f6466b50e81ff29d65f.1607349924.git.lorenzo@kernel.org>
 <20201208221746.GA33399@ranger.igk.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8 Dec 2020, at 23:17, Maciej Fijalkowski wrote:

> On Mon, Dec 07, 2020 at 05:32:42PM +0100, Lorenzo Bianconi wrote:
>> From: Eelco Chaudron <echaudro@redhat.com>
>>
>> This patch adds a new field to the XDP context called frame_length,
>> which will hold the full length of the packet, including fragments
>> if existing.
>
> The approach you took for ctx access conversion is barely described :/

You are right, I should have added some details on why I have chosen to 
take this approach. The reason is, to avoid a dedicated entry in the 
xdp_frame structure and maintaining it in the various eBPF helpers.

I'll update the commit message in the next revision to include this.

>>
>> eBPF programs can determine if fragments are present using something
>> like:
>>
>>   if (ctx->data_end - ctx->data < ctx->frame_length) {
>>     /* Fragements exists. /*
>>   }
>>
>> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
>> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
>> ---
>>  include/net/xdp.h              | 22 +++++++++
>>  include/uapi/linux/bpf.h       |  1 +
>>  kernel/bpf/verifier.c          |  2 +-
>>  net/core/filter.c              | 83 
>> ++++++++++++++++++++++++++++++++++
>>  tools/include/uapi/linux/bpf.h |  1 +
>>  5 files changed, 108 insertions(+), 1 deletion(-)
>>
>> diff --git a/include/net/xdp.h b/include/net/xdp.h
>> index 09078ab6644c..e54d733c90ed 100644
>> --- a/include/net/xdp.h
>> +++ b/include/net/xdp.h
>> @@ -73,8 +73,30 @@ struct xdp_buff {
>>  	void *data_hard_start;
>>  	struct xdp_rxq_info *rxq;
>>  	struct xdp_txq_info *txq;
>> +	/* If any of the bitfield lengths for frame_sz or mb below change,
>> +	 * make sure the defines here are also updated!
>> +	 */
>> +#ifdef __BIG_ENDIAN_BITFIELD
>> +#define MB_SHIFT	  0
>> +#define MB_MASK		  0x00000001
>> +#define FRAME_SZ_SHIFT	  1
>> +#define FRAME_SZ_MASK	  0xfffffffe
>> +#else
>> +#define MB_SHIFT	  31
>> +#define MB_MASK		  0x80000000
>> +#define FRAME_SZ_SHIFT	  0
>> +#define FRAME_SZ_MASK	  0x7fffffff
>> +#endif
>> +#define FRAME_SZ_OFFSET() offsetof(struct xdp_buff, 
>> __u32_bit_fields_offset)
>> +#define MB_OFFSET()	  offsetof(struct xdp_buff, 
>> __u32_bit_fields_offset)
>> +	/* private: */
>> +	u32 __u32_bit_fields_offset[0];
>
> Why? I don't get that. Please explain.

I was trying to find an easy way to extract the data/fields, maybe using 
BTF but had no luck.
So I resorted back to an existing approach in sk_buff, see 
https://elixir.bootlin.com/linux/v5.10-rc7/source/include/linux/skbuff.h#L780

> Also, looking at all the need for masking/shifting, I wonder if it 
> would
> be better to have u32 frame_sz and u8 mb...

Yes, I agree having u32 would be way better, even for u32 for the mb 
field. I’ve seen other code converting flags to u32 for easy access in 
the eBPF context structures.

I’ll see there are some comments in general on the bit definitions for 
mb, but I’ll try to convince them to use u32 for both in the next 
revision, as I think for the xdp_buff structure size is not a real 
problem ;)

>> +	/* public: */
>>  	u32 frame_sz:31; /* frame size to deduce data_hard_end/reserved 
>> tailroom*/
>>  	u32 mb:1; /* xdp non-linear buffer */
>> +
>> +	/* Temporary registers to make conditional access/stores possible. 
>> */
>> +	u64 tmp_reg[2];
>
> IMHO this kills the bitfield approach we have for vars above.

See above…

>>  };
>>
>>  /* Reserve memory area at end-of data area.
>> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
>> index 30b477a26482..62c50ab28ea9 100644
>> --- a/include/uapi/linux/bpf.h
>> +++ b/include/uapi/linux/bpf.h
>> @@ -4380,6 +4380,7 @@ struct xdp_md {
>>  	__u32 rx_queue_index;  /* rxq->queue_index  */
>>
>>  	__u32 egress_ifindex;  /* txq->dev->ifindex */
>> +	__u32 frame_length;
>>  };
>>
>>  /* DEVMAP map-value layout
>> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
>> index 93def76cf32b..c50caea29fa2 100644
>> --- a/kernel/bpf/verifier.c
>> +++ b/kernel/bpf/verifier.c
>> @@ -10526,7 +10526,7 @@ static int convert_ctx_accesses(struct 
>> bpf_verifier_env *env)
>>  	const struct bpf_verifier_ops *ops = env->ops;
>>  	int i, cnt, size, ctx_field_size, delta = 0;
>>  	const int insn_cnt = env->prog->len;
>> -	struct bpf_insn insn_buf[16], *insn;
>> +	struct bpf_insn insn_buf[32], *insn;
>>  	u32 target_size, size_default, off;
>>  	struct bpf_prog *new_prog;
>>  	enum bpf_access_type type;
>> diff --git a/net/core/filter.c b/net/core/filter.c
>> index 4c4882d4d92c..278640db9e0a 100644
>> --- a/net/core/filter.c
>> +++ b/net/core/filter.c
>> @@ -8908,6 +8908,7 @@ static u32 xdp_convert_ctx_access(enum 
>> bpf_access_type type,
>>  				  struct bpf_insn *insn_buf,
>>  				  struct bpf_prog *prog, u32 *target_size)
>>  {
>> +	int ctx_reg, dst_reg, scratch_reg;
>>  	struct bpf_insn *insn = insn_buf;
>>
>>  	switch (si->off) {
>> @@ -8954,6 +8955,88 @@ static u32 xdp_convert_ctx_access(enum 
>> bpf_access_type type,
>>  		*insn++ = BPF_LDX_MEM(BPF_W, si->dst_reg, si->dst_reg,
>>  				      offsetof(struct net_device, ifindex));
>>  		break;
>> +	case offsetof(struct xdp_md, frame_length):
>> +		/* Need tmp storage for src_reg in case src_reg == dst_reg,
>> +		 * and a scratch reg */
>> +		scratch_reg = BPF_REG_9;
>> +		dst_reg = si->dst_reg;
>> +
>> +		if (dst_reg == scratch_reg)
>> +			scratch_reg--;
>> +
>> +		ctx_reg = (si->src_reg == si->dst_reg) ? scratch_reg - 1 : 
>> si->src_reg;
>> +		while (dst_reg == ctx_reg || scratch_reg == ctx_reg)
>> +			ctx_reg--;
>> +
>> +		/* Save scratch registers */
>> +		if (ctx_reg != si->src_reg) {
>> +			*insn++ = BPF_STX_MEM(BPF_DW, si->src_reg, ctx_reg,
>> +					      offsetof(struct xdp_buff,
>> +						       tmp_reg[1]));
>> +
>> +			*insn++ = BPF_MOV64_REG(ctx_reg, si->src_reg);
>> +		}
>> +
>> +		*insn++ = BPF_STX_MEM(BPF_DW, ctx_reg, scratch_reg,
>> +				      offsetof(struct xdp_buff, tmp_reg[0]));
>
> Why don't you push regs to stack, use it and then pop it back? That 
> way I
> suppose you could avoid polluting xdp_buff with tmp_reg[2].

There is no “real” stack in eBPF, only a read-only frame pointer, 
and as we are replacing a single instruction, we have no info on what we 
can use as scratch space.

>> +
>> +		/* What does this code do?
>> +		 *   dst_reg = 0
>> +		 *
>> +		 *   if (!ctx_reg->mb)
>> +		 *      goto no_mb:
>> +		 *
>> +		 *   dst_reg = (struct xdp_shared_info *)xdp_data_hard_end(xdp)
>> +		 *   dst_reg = dst_reg->data_length
>> +		 *
>> +		 * NOTE: xdp_data_hard_end() is xdp->hard_start +
>> +		 *       xdp->frame_sz - sizeof(shared_info)
>> +		 *
>> +		 * no_mb:
>> +		 *   dst_reg += ctx_reg->data_end - ctx_reg->data
>> +		 */
>> +		*insn++ = BPF_MOV64_IMM(dst_reg, 0);
>> +
>> +		*insn++ = BPF_LDX_MEM(BPF_W, scratch_reg, ctx_reg, MB_OFFSET());
>> +		*insn++ = BPF_ALU32_IMM(BPF_AND, scratch_reg, MB_MASK);
>> +		*insn++ = BPF_JMP_IMM(BPF_JEQ, scratch_reg, 0, 7); /*goto no_mb; 
>> */
>> +
>> +		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct xdp_buff,
>> +						       data_hard_start),
>> +				      dst_reg, ctx_reg,
>> +				      offsetof(struct xdp_buff, data_hard_start));
>> +		*insn++ = BPF_LDX_MEM(BPF_W, scratch_reg, ctx_reg,
>> +				      FRAME_SZ_OFFSET());
>> +		*insn++ = BPF_ALU32_IMM(BPF_AND, scratch_reg, FRAME_SZ_MASK);
>> +		*insn++ = BPF_ALU32_IMM(BPF_RSH, scratch_reg, FRAME_SZ_SHIFT);
>> +		*insn++ = BPF_ALU64_REG(BPF_ADD, dst_reg, scratch_reg);
>> +		*insn++ = BPF_ALU64_IMM(BPF_SUB, dst_reg,
>> +					SKB_DATA_ALIGN(sizeof(struct skb_shared_info)));
>> +		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct xdp_shared_info,
>> +						       data_length),
>> +				      dst_reg, dst_reg,
>> +				      offsetof(struct xdp_shared_info,
>> +					       data_length));
>> +
>> +		/* no_mb: */
>> +		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct xdp_buff, data_end),
>> +				      scratch_reg, ctx_reg,
>> +				      offsetof(struct xdp_buff, data_end));
>> +		*insn++ = BPF_ALU64_REG(BPF_ADD, dst_reg, scratch_reg);
>> +		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct xdp_buff, data),
>> +				      scratch_reg, ctx_reg,
>> +				      offsetof(struct xdp_buff, data));
>> +		*insn++ = BPF_ALU64_REG(BPF_SUB, dst_reg, scratch_reg);
>> +
>> +		/* Restore scratch registers */
>> +		*insn++ = BPF_LDX_MEM(BPF_DW, scratch_reg, ctx_reg,
>> +				      offsetof(struct xdp_buff, tmp_reg[0]));
>> +
>> +		if (ctx_reg != si->src_reg)
>> +			*insn++ = BPF_LDX_MEM(BPF_DW, ctx_reg, ctx_reg,
>> +					      offsetof(struct xdp_buff,
>> +						       tmp_reg[1]));
>> +		break;
>>  	}
>>
>>  	return insn - insn_buf;
>> diff --git a/tools/include/uapi/linux/bpf.h 
>> b/tools/include/uapi/linux/bpf.h
>> index 30b477a26482..62c50ab28ea9 100644
>> --- a/tools/include/uapi/linux/bpf.h
>> +++ b/tools/include/uapi/linux/bpf.h
>> @@ -4380,6 +4380,7 @@ struct xdp_md {
>>  	__u32 rx_queue_index;  /* rxq->queue_index  */
>>
>>  	__u32 egress_ifindex;  /* txq->dev->ifindex */
>> +	__u32 frame_length;
>>  };
>>
>>  /* DEVMAP map-value layout
>> -- 
>> 2.28.0
>>

