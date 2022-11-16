Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EA3462CB7B
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 21:52:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234488AbiKPUwH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 15:52:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234622AbiKPUvy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 15:51:54 -0500
Received: from mail-oa1-x33.google.com (mail-oa1-x33.google.com [IPv6:2001:4860:4864:20::33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 969756711B
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 12:51:35 -0800 (PST)
Received: by mail-oa1-x33.google.com with SMTP id 586e51a60fabf-13bef14ea06so21578780fac.3
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 12:51:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=lwhVPHIMIomo3BXcO1W7sLlexkx0CTxVPJcQuGHw/8o=;
        b=NVjWD1LkjwamwK9d6fbufkAMaomEFHxZY+bRcUFXRF6gFj7SQrv4GAlETRVzNmyfOw
         jtGMZTSDH5QC9pYPkSO1cqt/muNZS2KQj5IyMpJzsbd6TBS6yClc0nz4/MgoKCalmPEq
         KzMFNbd/JR1pM75UGX/ix3k0c5daCAOBPrYgZghkuhX8sGYh6GhHWp9tQWyYdn/2CJT6
         pS+GcW1cM78kXdkUDmzphM+H4MRK/UphSzlVFYgXmFGI1B/IhLBknmpWIeyGrSNPPsC8
         F5hlV7f/d2Nq8Q9PS3+QuLuCDACg5k39xQkRdnHdKF+VE61O6kTvgxPnW3bW9JQP4yzt
         VtlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lwhVPHIMIomo3BXcO1W7sLlexkx0CTxVPJcQuGHw/8o=;
        b=4KnOvqR49uhvBVl7jtGOWYV+PZQIAo7+GLdrAPkebCX3IKkML0AXNrCG13Jc3dD4MO
         XzasWktKsB0s+6twbz5iW8+XjkFjLmwiRayyFukbsegovfJLSFYeWNxw5Vyakc89AsYB
         cOh8ePiks+85iijLEeyfsXsdBMGSPlVNFmKSn014MwibFkou0KZEdxFGv9yyLKM40Xau
         IzO+dxRHST66h7K+TJBj5PxfySpZtOF6ht1xlxutG3ykxGPzNAjJsRi7k2u1xDGIs6ah
         eODYuRJVLbuDnlh1Ap6r46qaUaM43dkWjLBXqbO0SnRzte3NocdV10xCSY0wnEHHw+I0
         YQrw==
X-Gm-Message-State: ANoB5pmP4ToGixc/wthRX4Tb0Ib7eQOhMYQTZyiLtN2SkdLzM1mWDdUJ
        aRc4yCgrcbG50eWW5t3togIhlc8eC45xsQc7BW0C9A==
X-Google-Smtp-Source: AA0mqf6AnWu6ZOpWwAlz4LRUfKA5FZ2GMyKfkbaeivMwdlj7/dT9WtHZbPViRrSGVJ0NtmfnjH4iq1gH6O5FuKTYrYo=
X-Received: by 2002:a05:6870:e9a2:b0:13b:be90:a68a with SMTP id
 r34-20020a056870e9a200b0013bbe90a68amr2708824oao.181.1668631894779; Wed, 16
 Nov 2022 12:51:34 -0800 (PST)
MIME-Version: 1.0
References: <20221115030210.3159213-1-sdf@google.com> <20221115030210.3159213-7-sdf@google.com>
 <fd21dfd5-f458-dfba-594d-3aafd6a4648a@linux.dev>
In-Reply-To: <fd21dfd5-f458-dfba-594d-3aafd6a4648a@linux.dev>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Wed, 16 Nov 2022 12:51:23 -0800
Message-ID: <CAKH8qBuWB1edLwBXCbiyNgca6NE1OZowwhHYn7QvTrPi-rvFJA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 06/11] xdp: Carry over xdp metadata into skb context
To:     Martin KaFai Lau <martin.lau@linux.dev>
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
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 15, 2022 at 11:04 PM Martin KaFai Lau <martin.lau@linux.dev> wrote:
>
> On 11/14/22 7:02 PM, Stanislav Fomichev wrote:
> > Implement new bpf_xdp_metadata_export_to_skb kfunc which
> > prepares compatible xdp metadata for kernel consumption.
> > This kfunc should be called prior to bpf_redirect
> > or when XDP_PASS'ing the frame into the kernel (note, the drivers
> > have to be updated to enable consuming XDP_PASS'ed metadata).
> >
> > veth driver is amended to consume this metadata when converting to skb.
> >
> > Internally, XDP_FLAGS_HAS_SKB_METADATA flag is used to indicate
> > whether the frame has skb metadata. The metadata is currently
> > stored prior to xdp->data_meta. bpf_xdp_adjust_meta refuses
> > to work after a call to bpf_xdp_metadata_export_to_skb (can lift
> > this requirement later on if needed, we'd have to memmove
> > xdp_skb_metadata).
>
> It is ok to refuse bpf_xdp_adjust_meta() after bpf_xdp_metadata_export_to_skb()
> for now.  However, it will also need to refuse bpf_xdp_adjust_head().

Good catch!

> [ ... ]
>
> > +/* For the packets directed to the kernel, this kfunc exports XDP metadata
> > + * into skb context.
> > + */
> > +noinline int bpf_xdp_metadata_export_to_skb(const struct xdp_md *ctx)
> > +{
> > +     return 0;
> > +}
> > +
>
> I think it is still better to return 'struct xdp_skb_metata *' instead of
> true/false.  Like:
>
> noinline struct xdp_skb_metata *bpf_xdp_metadata_export_to_skb(const struct
> xdp_md *ctx)
> {
>         return 0;
> }
>
> The KF_RET_NULL has already been set in
> BTF_SET8_START_GLOBAL(xdp_metadata_kfunc_ids).  There is
> "xdp_btf_struct_access()" that can allow write access to 'struct xdp_skb_metata'
> What else is missing? We can try to solve it.

Ah, that KF_RET_NULL is a left-over from my previous attempt to return
pointers :-)
I can retry with returning a pointer, I don't have a preference, but I
felt like returning simple -errno might be more simple api-wise.
(with bpf_xdp_metadata_export_to_skb returning NULL vs return loggable
errno - I'd prefer the latter, but not strongly)

> Then there is no need for this double check in patch 8 selftest which is not
> easy to use:
>
> +               if (bpf_xdp_metadata_export_to_skb(ctx) < 0) {
> +                       bpf_printk("bpf_xdp_metadata_export_to_skb failed");
> +                       return XDP_DROP;
> +               }
>
> [ ... ]
>
> +               skb_metadata = ctx->skb_metadata;
> +               if (!skb_metadata) {
> +                       bpf_printk("no ctx->skb_metadata");
> +                       return XDP_DROP;
> +               }
>
> [ ... ]
>
>
> > diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
> > index b444b1118c4f..71e3bc7ad839 100644
> > --- a/tools/include/uapi/linux/bpf.h
> > +++ b/tools/include/uapi/linux/bpf.h
> > @@ -6116,6 +6116,12 @@ enum xdp_action {
> >       XDP_REDIRECT,
> >   };
> >
> > +/* Subset of XDP metadata exported to skb context.
> > + */
> > +struct xdp_skb_metadata {
> > +     __u64 rx_timestamp;
> > +};
> > +
> >   /* user accessible metadata for XDP packet hook
> >    * new fields must be added to the end of this structure
> >    */
> > @@ -6128,6 +6134,7 @@ struct xdp_md {
> >       __u32 rx_queue_index;  /* rxq->queue_index  */
> >
> >       __u32 egress_ifindex;  /* txq->dev->ifindex */
> > +     __bpf_md_ptr(struct xdp_skb_metadata *, skb_metadata);
>
> Once the above bpf_xdp_metadata_export_to_skb() returning a pointer works, then
> it can be another kfunc 'struct xdp_skb_metata * bpf_xdp_get_skb_metadata(const
> struct xdp_md *ctx)' to return the skb_metadata which was a similar point
> discussed in the previous RFC.

I see. I think you've mentioned it previously somewhere to have a
kfunc accessor vs uapi field and I totally forgot. Will try to address
it, ty!
