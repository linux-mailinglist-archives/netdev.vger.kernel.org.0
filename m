Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 815326201AC
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 23:02:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232498AbiKGWCE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 17:02:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231992AbiKGWCC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 17:02:02 -0500
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B5463B8;
        Mon,  7 Nov 2022 14:02:01 -0800 (PST)
Message-ID: <187e89c3-d7de-7bec-c72e-d9d6eb5bcca0@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1667858519;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5Lah0aa6diJhPNTAGAxAtQxlp7AX+K4kMo28ZVTFjP4=;
        b=nalMmdEXcuy725S/fF0nTT8AYked5sz3xF+1Hfy1Qf9qxTVYRb7naxYvdMyq0I/QpYlW5V
        lrpPbCs6nleKeP76+OtiKREylLKdWlLWrp1llS0UmLWOe2rPh4yPJP0L38fhMnhrmTXD5N
        +40TdZskWeTLwjvO10qUVlBtn7YZ0JE=
Date:   Mon, 7 Nov 2022 14:01:53 -0800
MIME-Version: 1.0
Subject: Re: [RFC bpf-next v2 06/14] xdp: Carry over xdp metadata into skb
 context
Content-Language: en-US
To:     Stanislav Fomichev <sdf@google.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        song@kernel.org, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, haoluo@google.com, jolsa@kernel.org,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org, bpf@vger.kernel.org
References: <20221104032532.1615099-1-sdf@google.com>
 <20221104032532.1615099-7-sdf@google.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <20221104032532.1615099-7-sdf@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/3/22 8:25 PM, Stanislav Fomichev wrote:
> > diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index 59c9fd55699d..dba857f212d7 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -4217,9 +4217,13 @@ static inline bool skb_metadata_differs(const struct sk_buff *skb_a,
>   	       true : __skb_metadata_differs(skb_a, skb_b, len_a);
>   }
>   
> +void skb_metadata_import_from_xdp(struct sk_buff *skb, size_t len);
> +
>   static inline void skb_metadata_set(struct sk_buff *skb, u8 meta_len)
>   {
>   	skb_shinfo(skb)->meta_len = meta_len;
> +	if (meta_len)
> +		skb_metadata_import_from_xdp(skb, meta_len);
>   }
>
[ ... ]

> +struct xdp_to_skb_metadata {
> +	u32 magic; /* xdp_metadata_magic */
> +	u64 rx_timestamp;
> +} __randomize_layout;
> +
> +struct bpf_patch;
> +

[ ... ]

> +void skb_metadata_import_from_xdp(struct sk_buff *skb, size_t len)
> +{
> +	struct xdp_to_skb_metadata *meta = (void *)(skb_mac_header(skb) - len);
> +
> +	/* Optional SKB info, currently missing:
> +	 * - HW checksum info		(skb->ip_summed)
> +	 * - HW RX hash			(skb_set_hash)
> +	 * - RX ring dev queue index	(skb_record_rx_queue)
> +	 */
> +
> +	if (len != sizeof(struct xdp_to_skb_metadata))
> +		return;
> +
> +	if (meta->magic != xdp_metadata_magic)
> +		return;
> +
> +	if (meta->rx_timestamp) {
> +		*skb_hwtstamps(skb) = (struct skb_shared_hwtstamps){
> +			.hwtstamp = ns_to_ktime(meta->rx_timestamp),
> +		};
> +	}
> +}

Considering the metadata will affect the gro, should the meta be cleared after 
importing to the skb?

[ ... ]

> +/* Since we're not actually doing a call but instead rewriting
> + * in place, we can only afford to use R0-R5 scratch registers.
> + *
> + * We reserve R1 for bpf_xdp_metadata_export_to_skb and let individual
> + * metadata kfuncs use only R0,R4-R5.
> + *
> + * The above also means we _cannot_ easily call any other helper/kfunc
> + * because there is no place for us to preserve our R1 argument;
> + * existing R6-R9 belong to the callee.
> + */
> +void xdp_metadata_export_to_skb(const struct bpf_prog *prog, struct bpf_patch *patch)
> +{
> +	u32 func_id;
> +
> +	/*
> +	 * The code below generates the following:
> +	 *
> +	 * void bpf_xdp_metadata_export_to_skb(struct xdp_md *ctx)
> +	 * {
> +	 *	struct xdp_to_skb_metadata *meta;
> +	 *	int ret;
> +	 *
> +	 *	ret = bpf_xdp_adjust_meta(ctx, -sizeof(*meta));
> +	 *	if (!ret)
> +	 *		return;
> +	 *
> +	 *	meta = ctx->data_meta;
> +	 *	meta->magic = xdp_metadata_magic;
> +	 *	meta->rx_timestamp = bpf_xdp_metadata_rx_timestamp(ctx);
> +	 * }
> +	 *
> +	 */
> +
> +	bpf_patch_append(patch,
> +		/* r2 = ((struct xdp_buff *)r1)->data_meta; */
> +		BPF_LDX_MEM(BPF_DW, BPF_REG_2, BPF_REG_1,
> +			    offsetof(struct xdp_buff, data_meta)),
> +		/* r3 = ((struct xdp_buff *)r1)->data; */
> +		BPF_LDX_MEM(BPF_DW, BPF_REG_3, BPF_REG_1,
> +			    offsetof(struct xdp_buff, data)),
> +		/* if (data_meta != data) return;
> +		 *
> +		 *	data_meta > data: xdp_data_meta_unsupported()
> +		 *	data_meta < data: already used, no need to touch
> +		 */
> +		BPF_JMP_REG(BPF_JNE, BPF_REG_2, BPF_REG_3, S16_MAX),
> +
> +		/* r2 -= sizeof(struct xdp_to_skb_metadata); */
> +		BPF_ALU64_IMM(BPF_SUB, BPF_REG_2,
> +			      sizeof(struct xdp_to_skb_metadata)),
> +		/* r3 = ((struct xdp_buff *)r1)->data_hard_start; */
> +		BPF_LDX_MEM(BPF_DW, BPF_REG_3, BPF_REG_1,
> +			    offsetof(struct xdp_buff, data_hard_start)),
> +		/* r3 += sizeof(struct xdp_frame) */
> +		BPF_ALU64_IMM(BPF_ADD, BPF_REG_3,
> +			      sizeof(struct xdp_frame)),
> +		/* if (data-sizeof(struct xdp_to_skb_metadata) < data_hard_start+sizeof(struct xdp_frame)) return; */
> +		BPF_JMP_REG(BPF_JLT, BPF_REG_2, BPF_REG_3, S16_MAX),
> +
> +		/* ((struct xdp_buff *)r1)->data_meta = r2; */
> +		BPF_STX_MEM(BPF_DW, BPF_REG_1, BPF_REG_2,
> +			    offsetof(struct xdp_buff, data_meta)),
> +
> +		/* *((struct xdp_to_skb_metadata *)r2)->magic = xdp_metadata_magic; */
> +		BPF_ST_MEM(BPF_W, BPF_REG_2,
> +			   offsetof(struct xdp_to_skb_metadata, magic),
> +			   xdp_metadata_magic),
> +	);
> +
> +	/*	r0 = bpf_xdp_metadata_rx_timestamp(ctx); */
> +	func_id = xdp_metadata_kfunc_id(XDP_METADATA_KFUNC_RX_TIMESTAMP);
> +	prog->aux->xdp_kfunc_ndo->ndo_unroll_kfunc(prog, func_id, patch);
> +
> +	bpf_patch_append(patch,
> +		/* r2 = ((struct xdp_buff *)r1)->data_meta; */
> +		BPF_LDX_MEM(BPF_DW, BPF_REG_2, BPF_REG_1,
> +			    offsetof(struct xdp_buff, data_meta)),
> +		/* *((struct xdp_to_skb_metadata *)r2)->rx_timestamp = r0; */
> +		BPF_STX_MEM(BPF_DW, BPF_REG_2, BPF_REG_0,
> +			    offsetof(struct xdp_to_skb_metadata, rx_timestamp)),

Can the xdp prog still change the metadata through xdp->data_meta? tbh, I am not 
sure it is solid enough by asking the xdp prog not to use the same random number 
in its own metadata + not to change the metadata through xdp->data_meta after 
calling bpf_xdp_metadata_export_to_skb().

Does xdp_to_skb_metadata have a use case for XDP_PASS (like patch 7) or the 
xdp_to_skb_metadata can be limited to XDP_REDIRECT only?


> +	);
> +
> +	bpf_patch_resolve_jmp(patch);
> +}
> +
>   static int __init xdp_metadata_init(void)
>   {
> +	xdp_metadata_magic = get_random_u32() | 1;
>   	return register_btf_kfunc_id_set(BPF_PROG_TYPE_XDP, &xdp_metadata_kfunc_set);
>   }
>   late_initcall(xdp_metadata_init);
