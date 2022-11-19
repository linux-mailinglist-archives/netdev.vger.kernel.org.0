Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE748630EB8
	for <lists+netdev@lfdr.de>; Sat, 19 Nov 2022 13:32:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233895AbiKSMcX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Nov 2022 07:32:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233752AbiKSMcO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Nov 2022 07:32:14 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7407450A2
        for <netdev@vger.kernel.org>; Sat, 19 Nov 2022 04:31:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668861085;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=l3aCNi/Pba6T1IvMVp0Yu0+UTE16Y1ghfyngfmGFQFQ=;
        b=fpGmI/PtiFTklFMQqHB34u8NNnAgMCJMzei/dQ3q0TAlDutE4yuAiCfhFqqaXoivcaWDne
        9MEbwsobdkfVeciLE76QBD9VvNM11pXwIFSPtez8Jy81XVJ7EPtd6FO0UfaJFIXlZckmbW
        SpbogRkxlT0FSc4LWB5KJXQ9Fke/38I=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-128-tWGCqmJnOA2tHLvnMaxdqA-1; Sat, 19 Nov 2022 07:31:23 -0500
X-MC-Unique: tWGCqmJnOA2tHLvnMaxdqA-1
Received: by mail-ed1-f72.google.com with SMTP id q13-20020a056402518d00b00462b0599644so4193617edd.20
        for <netdev@vger.kernel.org>; Sat, 19 Nov 2022 04:31:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=l3aCNi/Pba6T1IvMVp0Yu0+UTE16Y1ghfyngfmGFQFQ=;
        b=0hf0hAt/8nnqGXJ+QJvQyxlr35eTCG7jxYYT8PPtbOCQXViTf/plycqo4g3UmSxTka
         mp4J7R8N2IEz6QZ9UIA2kV+eGwDvIdh3lC0Rv38+JutEV0G+ycDvdifUDh0Gntk6mnS+
         bNkMw2EpU8r7vyOnIW2OnefNOirut9Vy8SlsFIXWe5fxTE0QGtwaBtp03cfnC0hQlFlu
         30vcJUQ/sSsWlVIH91YDr2oG/5nAvvRaWFOCqa4X5VdVU1w/lVIbjQuF4xhf1xkopDh6
         Yomiu7tyeT2ygR0h05LyDYCqpONk0UfzzDMeOaOjsPFwcccOiqxftKl+2/Hl/fNQAF55
         vPAQ==
X-Gm-Message-State: ANoB5pk1R/1J8Jp5Q/wJFfzKfn7Y9KsuoRKQRUwXYn4v328Y/zANZNdm
        uel7pPzkCichwnkP8u6etdtuSRAlHMFN3goEVAy/hZnoFqrgCJ9458wjCdmIvD00/tfV/sVwp0b
        HK6QfjvTGGtK6zRFE
X-Received: by 2002:a17:906:3385:b0:7a2:b352:a0d3 with SMTP id v5-20020a170906338500b007a2b352a0d3mr9082905eja.399.1668861082352;
        Sat, 19 Nov 2022 04:31:22 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7nxCM5XBNwLx2zmVae7JCRY2LVz5ERFNHsthxtMg3JXxIyqR8Ilj7lVrFGxNDJZTpAo4rcNQ==
X-Received: by 2002:a17:906:3385:b0:7a2:b352:a0d3 with SMTP id v5-20020a170906338500b007a2b352a0d3mr9082871eja.399.1668861081770;
        Sat, 19 Nov 2022 04:31:21 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id d7-20020a170906304700b007b29d292852sm34958ejd.148.2022.11.19.04.31.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Nov 2022 04:31:21 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 902E07CDFA3; Sat, 19 Nov 2022 13:31:20 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Stanislav Fomichev <sdf@google.com>,
        Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     bpf@vger.kernel.org, brouer@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, martin.lau@linux.dev,
        song@kernel.org, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, haoluo@google.com, jolsa@kernel.org,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org
Subject: Re: [xdp-hints] Re: [PATCH bpf-next 06/11] xdp: Carry over xdp
 metadata into skb context
In-Reply-To: <CAKH8qBv8UtHZrgSGzVn3ZJSfkdv1H3kXGbakp9rCFdOABL=3BQ@mail.gmail.com>
References: <20221115030210.3159213-1-sdf@google.com>
 <20221115030210.3159213-7-sdf@google.com>
 <e26f75dd-f52f-a69b-6754-54e1fe044a42@redhat.com>
 <CAKH8qBv8UtHZrgSGzVn3ZJSfkdv1H3kXGbakp9rCFdOABL=3BQ@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Sat, 19 Nov 2022 13:31:20 +0100
Message-ID: <871qpzxh0n.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Stanislav Fomichev <sdf@google.com> writes:

> On Fri, Nov 18, 2022 at 6:05 AM Jesper Dangaard Brouer
> <jbrouer@redhat.com> wrote:
>>
>>
>> On 15/11/2022 04.02, Stanislav Fomichev wrote:
>> > Implement new bpf_xdp_metadata_export_to_skb kfunc which
>> > prepares compatible xdp metadata for kernel consumption.
>> > This kfunc should be called prior to bpf_redirect
>> > or when XDP_PASS'ing the frame into the kernel (note, the drivers
>> > have to be updated to enable consuming XDP_PASS'ed metadata).
>> >
>> > veth driver is amended to consume this metadata when converting to skb.
>> >
>> > Internally, XDP_FLAGS_HAS_SKB_METADATA flag is used to indicate
>> > whether the frame has skb metadata. The metadata is currently
>> > stored prior to xdp->data_meta. bpf_xdp_adjust_meta refuses
>> > to work after a call to bpf_xdp_metadata_export_to_skb (can lift
>> > this requirement later on if needed, we'd have to memmove
>> > xdp_skb_metadata).
>> >
>>
>> I think it is wrong to refuses using metadata area (bpf_xdp_adjust_meta)
>> when the function bpf_xdp_metadata_export_to_skb() have been called.
>> In my design they were suppose to co-exist, and BPF-prog was expected to
>> access this directly themselves.
>>
>> With this current design, I think it is better to place the struct
>> xdp_skb_metadata (maybe call it xdp_skb_hints) after xdp_frame (in the
>> top of the frame).  This way we don't conflict with metadata and
>> headroom use-cases.  Plus, verifier will keep BPF-prog from accessing
>> this area directly (which seems to be one of the new design goals).
>>
>> By placing it after xdp_frame, I think it would be possible to let veth
>> unroll functions seamlessly access this info for XDP_REDIRECT'ed
>> xdp_frame's.
>>
>> WDYT?
>
> Not everyone seems to be happy with exposing this xdp_skb_metadata via
> uapi though :-(
> So I'll drop this part in the v2 for now. But let's definitely keep
> talking about the future approach.

Jakub was objecting to putting it in the UAPI header, but didn't we
already agree that this wasn't necessary?

I.e., if we just define

struct xdp_skb_metadata *bpf_xdp_metadata_export_to_skb()

as a kfunc, the xdp_skb_metadata struct won't appear in any UAPI headers
and will only be accessible via BTF? And we can put the actual data
wherever we choose, since that bit is nicely hidden behind the kfunc,
while the returned pointer still allows programs to access it.

We could even make that kfunc smart enough that it checks if the field
is already populated and just return the pointer to the existing data
instead of re-populating it int his case (with a flag to override,
maybe?).

> Putting it after xdp_frame SGTM; with this we seem to avoid the need
> to memmove it on adjust_{head,meta}.
>
> But going back to the uapi part, what if we add separate kfunc
> accessors for skb exported metadata?
>
> To export:
> bpf_xdp_metadata_export_rx_timestamp_to_skb(ctx, rx_timestamp)
> bpf_xdp_metadata_export_rx_hash_to_skb(ctx, rx_hash)
> // ^^ these prepare xdp_skb_metadata after xdp_frame, but not expose
> it via uapi/af_xdp/etc
>
> Then bpf_xdp_metadata_export_to_skb can be 'static inline' define in
> the headers:
>
> void bpf_xdp_metadata_export_to_skb(ctx)
> {
>   if (bpf_xdp_metadata_rx_timestamp_supported(ctx))
>     bpf_xdp_metadata_export_rx_timestamp_to_skb(ctx,
> bpf_xdp_metadata_rx_timestamp(ctx));
>   if (bpf_xdp_metadata_rx_hash_supported(ctx))
>     bpf_xdp_metadata_export_rx_hash_to_skb(ctx, bpf_xdp_metadata_rx_hash(ctx));
> }

The problem with this is that the BPF programs then have to keep up with
the kernel. I.e., if the kernel later adds support for a new field that
is used in the SKB, old XDP programs won't be populating it, which seems
suboptimal. I think rather the kernel should be in control of the SKB
metadata, and just allow XDP to consume it (and change individual fields
as needed).

> The only issue, it seems, is that if the final bpf program would like
> to export this metadata to af_xdp, it has to manually adj_meta and use
> bpf_xdp_metadata_skb_rx_xxx to prepare a custom layout. Not sure
> whether performance would suffer with this extra copy; but we can at
> least try and see..

If we write the metadata after the packet data, that could still be
transferred to AF_XDP, couldn't it? Userspace would just have to know
how to find and read it, like it would  if it's before the metadata.

-Toke

