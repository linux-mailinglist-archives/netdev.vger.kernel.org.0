Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC0FF622269
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 04:07:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230153AbiKIDHh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 22:07:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbiKIDHg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 22:07:36 -0500
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB77323389;
        Tue,  8 Nov 2022 19:07:34 -0800 (PST)
Message-ID: <9a8fefe4-2fcb-95b7-cda0-06509feee78e@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1667963253;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=G8x8TDBiHxQ9VKMGSGUM7+Z5JTuZcFhVsjlFzdHN1qA=;
        b=tFB5WjgCHb1penBW1amggwYltSN8KzdJjjJ6veB/FuR08hljS7NEbAXmAhD18pin4yqZ/B
        jCoTeO3fNgw31gesBQpHg0+q4N61Mp5eQFwIzDGgv66GuYfgqQo1ee6Hyb50zNu7ZvWZl+
        7cPdjD+nVInu2iAXlT37U/pC3zoDcm4=
Date:   Tue, 8 Nov 2022 19:07:26 -0800
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
 <187e89c3-d7de-7bec-c72e-d9d6eb5bcca0@linux.dev>
 <CAKH8qBv_ZO=rsJcq2Lvq36d9sTAXs6kfUmW1Hk17bB=BGiGzhw@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <CAKH8qBv_ZO=rsJcq2Lvq36d9sTAXs6kfUmW1Hk17bB=BGiGzhw@mail.gmail.com>
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

On 11/8/22 1:54 PM, Stanislav Fomichev wrote:
> On Mon, Nov 7, 2022 at 2:02 PM Martin KaFai Lau <martin.lau@linux.dev> wrote:
>>
>> On 11/3/22 8:25 PM, Stanislav Fomichev wrote:
>>>> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
>>> index 59c9fd55699d..dba857f212d7 100644
>>> --- a/include/linux/skbuff.h
>>> +++ b/include/linux/skbuff.h
>>> @@ -4217,9 +4217,13 @@ static inline bool skb_metadata_differs(const struct sk_buff *skb_a,
>>>               true : __skb_metadata_differs(skb_a, skb_b, len_a);
>>>    }
>>>
>>> +void skb_metadata_import_from_xdp(struct sk_buff *skb, size_t len);
>>> +
>>>    static inline void skb_metadata_set(struct sk_buff *skb, u8 meta_len)
>>>    {
>>>        skb_shinfo(skb)->meta_len = meta_len;
>>> +     if (meta_len)
>>> +             skb_metadata_import_from_xdp(skb, meta_len);
>>>    }
>>>
>> [ ... ]
>>
>>> +struct xdp_to_skb_metadata {
>>> +     u32 magic; /* xdp_metadata_magic */
>>> +     u64 rx_timestamp;
>>> +} __randomize_layout;
>>> +
>>> +struct bpf_patch;
>>> +
>>
>> [ ... ]
>>
>>> +void skb_metadata_import_from_xdp(struct sk_buff *skb, size_t len)
>>> +{
>>> +     struct xdp_to_skb_metadata *meta = (void *)(skb_mac_header(skb) - len);
>>> +
>>> +     /* Optional SKB info, currently missing:
>>> +      * - HW checksum info           (skb->ip_summed)
>>> +      * - HW RX hash                 (skb_set_hash)
>>> +      * - RX ring dev queue index    (skb_record_rx_queue)
>>> +      */
>>> +
>>> +     if (len != sizeof(struct xdp_to_skb_metadata))
>>> +             return;
>>> +
>>> +     if (meta->magic != xdp_metadata_magic)
>>> +             return;
>>> +
>>> +     if (meta->rx_timestamp) {
>>> +             *skb_hwtstamps(skb) = (struct skb_shared_hwtstamps){
>>> +                     .hwtstamp = ns_to_ktime(meta->rx_timestamp),
>>> +             };
>>> +     }
>>> +}
>>
>> Considering the metadata will affect the gro, should the meta be cleared after
>> importing to the skb?
> 
> Yeah, good suggestion, will clear it here.
> 
>> [ ... ]
>>
>>> +/* Since we're not actually doing a call but instead rewriting
>>> + * in place, we can only afford to use R0-R5 scratch registers.
>>> + *
>>> + * We reserve R1 for bpf_xdp_metadata_export_to_skb and let individual
>>> + * metadata kfuncs use only R0,R4-R5.
>>> + *
>>> + * The above also means we _cannot_ easily call any other helper/kfunc
>>> + * because there is no place for us to preserve our R1 argument;
>>> + * existing R6-R9 belong to the callee.
>>> + */
>>> +void xdp_metadata_export_to_skb(const struct bpf_prog *prog, struct bpf_patch *patch)
>>> +{
>>> +     u32 func_id;
>>> +
>>> +     /*
>>> +      * The code below generates the following:
>>> +      *
>>> +      * void bpf_xdp_metadata_export_to_skb(struct xdp_md *ctx)
>>> +      * {
>>> +      *      struct xdp_to_skb_metadata *meta;
>>> +      *      int ret;
>>> +      *
>>> +      *      ret = bpf_xdp_adjust_meta(ctx, -sizeof(*meta));
>>> +      *      if (!ret)
>>> +      *              return;
>>> +      *
>>> +      *      meta = ctx->data_meta;
>>> +      *      meta->magic = xdp_metadata_magic;
>>> +      *      meta->rx_timestamp = bpf_xdp_metadata_rx_timestamp(ctx);
>>> +      * }
>>> +      *
>>> +      */
>>> +
>>> +     bpf_patch_append(patch,
>>> +             /* r2 = ((struct xdp_buff *)r1)->data_meta; */
>>> +             BPF_LDX_MEM(BPF_DW, BPF_REG_2, BPF_REG_1,
>>> +                         offsetof(struct xdp_buff, data_meta)),
>>> +             /* r3 = ((struct xdp_buff *)r1)->data; */
>>> +             BPF_LDX_MEM(BPF_DW, BPF_REG_3, BPF_REG_1,
>>> +                         offsetof(struct xdp_buff, data)),
>>> +             /* if (data_meta != data) return;
>>> +              *
>>> +              *      data_meta > data: xdp_data_meta_unsupported()
>>> +              *      data_meta < data: already used, no need to touch
>>> +              */
>>> +             BPF_JMP_REG(BPF_JNE, BPF_REG_2, BPF_REG_3, S16_MAX),
>>> +
>>> +             /* r2 -= sizeof(struct xdp_to_skb_metadata); */
>>> +             BPF_ALU64_IMM(BPF_SUB, BPF_REG_2,
>>> +                           sizeof(struct xdp_to_skb_metadata)),
>>> +             /* r3 = ((struct xdp_buff *)r1)->data_hard_start; */
>>> +             BPF_LDX_MEM(BPF_DW, BPF_REG_3, BPF_REG_1,
>>> +                         offsetof(struct xdp_buff, data_hard_start)),
>>> +             /* r3 += sizeof(struct xdp_frame) */
>>> +             BPF_ALU64_IMM(BPF_ADD, BPF_REG_3,
>>> +                           sizeof(struct xdp_frame)),
>>> +             /* if (data-sizeof(struct xdp_to_skb_metadata) < data_hard_start+sizeof(struct xdp_frame)) return; */
>>> +             BPF_JMP_REG(BPF_JLT, BPF_REG_2, BPF_REG_3, S16_MAX),
>>> +
>>> +             /* ((struct xdp_buff *)r1)->data_meta = r2; */
>>> +             BPF_STX_MEM(BPF_DW, BPF_REG_1, BPF_REG_2,
>>> +                         offsetof(struct xdp_buff, data_meta)),
>>> +
>>> +             /* *((struct xdp_to_skb_metadata *)r2)->magic = xdp_metadata_magic; */
>>> +             BPF_ST_MEM(BPF_W, BPF_REG_2,
>>> +                        offsetof(struct xdp_to_skb_metadata, magic),
>>> +                        xdp_metadata_magic),
>>> +     );
>>> +
>>> +     /*      r0 = bpf_xdp_metadata_rx_timestamp(ctx); */
>>> +     func_id = xdp_metadata_kfunc_id(XDP_METADATA_KFUNC_RX_TIMESTAMP);
>>> +     prog->aux->xdp_kfunc_ndo->ndo_unroll_kfunc(prog, func_id, patch);
>>> +
>>> +     bpf_patch_append(patch,
>>> +             /* r2 = ((struct xdp_buff *)r1)->data_meta; */
>>> +             BPF_LDX_MEM(BPF_DW, BPF_REG_2, BPF_REG_1,
>>> +                         offsetof(struct xdp_buff, data_meta)),
>>> +             /* *((struct xdp_to_skb_metadata *)r2)->rx_timestamp = r0; */
>>> +             BPF_STX_MEM(BPF_DW, BPF_REG_2, BPF_REG_0,
>>> +                         offsetof(struct xdp_to_skb_metadata, rx_timestamp)),
>>
>> Can the xdp prog still change the metadata through xdp->data_meta? tbh, I am not
>> sure it is solid enough by asking the xdp prog not to use the same random number
>> in its own metadata + not to change the metadata through xdp->data_meta after
>> calling bpf_xdp_metadata_export_to_skb().
> 
> What do you think the usecase here might be? Or are you suggesting we
> reject further access to data_meta after
> bpf_xdp_metadata_export_to_skb somehow?
> 
> If we want to let the programs override some of this
> bpf_xdp_metadata_export_to_skb() metadata, it feels like we can add
> more kfuncs instead of exposing the layout?
> 
> bpf_xdp_metadata_export_to_skb(ctx);
> bpf_xdp_metadata_export_skb_hash(ctx, 1234);


I can't think of a use case now for the xdp prog to use the xdp_to_skb_metadata 
while the xdp prog can directly call the kfunc (eg 
bpf_xdp_metadata_rx_timestamp) to get individual hint.  I was asking if patch 7 
is an actual use case because it does test the tstamp in XDP_PASS or it is 
mostly for selftest purpose?  Yeah, may be the xdp prog will be able to change 
the xdp_to_skb_metadata eventually but that is for later.

My concern is the xdp prog is allowed to change xdp_to_skb_metadata or 
by-coincident writing metadata that matches the random and the sizeof(struct 
xdp_to_skb_metadata).

Also, the added opacity of xdp_to_skb_metadata (__randomize_layout + random int) 
is trying very hard to hide it from xdp prog.  Instead, would it be cleaner to 
have a flag in xdp->flags (to be set by bpf_xdp_metadata_export_to_skb?) to 
guard this, like one of Jesper's patch.  The xdp_convert_ctx_access() and 
bpf_xdp_adjust_meta() can check this bit to ensure the xdp_to_skb_metadata 
cannot be read and no metadata can be added/deleted after that.  btw, is it 
possible to keep both xdp_to_skb_metadata and the xdp_prog's metadata?  After 
skb_metadata_import_from_xdp popping the xdp_to_skb_metadata, the remaining 
xdp_prog's metatdata can still be used by the bpf-tc.

> ...
> 
>> Does xdp_to_skb_metadata have a use case for XDP_PASS (like patch 7) or the
>> xdp_to_skb_metadata can be limited to XDP_REDIRECT only?
> 
> XDP_PASS cases where we convert xdp_buff into skb in the drivers right
> now usually have C code to manually pull out the metadata (out of hw
> desc) and put it into skb.
> 
> So, currently, if we're calling bpf_xdp_metadata_export_to_skb() for
> XDP_PASS, we're doing a double amount of work:
> skb_metadata_import_from_xdp first, then custom driver code second.
> 
> In theory, maybe we should completely skip drivers custom parsing when
> there is a prog with BPF_F_XDP_HAS_METADATA?
> Then both xdp->skb paths (XDP_PASS+XDP_REDIRECT) will be bpf-driven
> and won't require any mental work (plus, the drivers won't have to
> care either in the future).
>  > WDYT?


Yeah, not sure if it can solely depend on BPF_F_XDP_HAS_METADATA but it makes 
sense to only use the hints (if ever written) from xdp prog especially if it 
will eventually support xdp prog changing some of the hints in the future.  For 
now, I think either way is fine since they are the same and the xdp prog is sort 
of doing extra unnecessary work anyway by calling 
bpf_xdp_metadata_export_to_skb() with XDP_PASS and knowing nothing can be 
changed now.


> 
>>> +     );
>>> +
>>> +     bpf_patch_resolve_jmp(patch);
>>> +}
>>> +
>>>    static int __init xdp_metadata_init(void)
>>>    {
>>> +     xdp_metadata_magic = get_random_u32() | 1;
>>>        return register_btf_kfunc_id_set(BPF_PROG_TYPE_XDP, &xdp_metadata_kfunc_set);
>>>    }
>>>    late_initcall(xdp_metadata_init);

