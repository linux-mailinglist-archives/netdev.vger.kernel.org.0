Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B9CF614C7A
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 15:21:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230218AbiKAOVs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 10:21:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229766AbiKAOVq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 10:21:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1D7F1B78A
        for <netdev@vger.kernel.org>; Tue,  1 Nov 2022 07:20:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667312449;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=af8a5692vQNnHtfl4OiAhO0hfTr2zQ516tgQOTBk6F8=;
        b=Hf3zQUy9KvEkGozb6F54bjfdRCT7zvnU5DeauBLg0eLPwb4BENyODYdkEUds9gi3BSOy0s
        V/jGZmsdlxUY3+hqQ7QKtQ4JAbnMbp0LcF1Zj8sL8jSK000f16KamxB46uncvOt9w4aVWB
        3zMYIp10qvEPkuCoG2CJT5oVgZLBIgA=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-609-aGhysppNP0iXrvm-sdKAZQ-1; Tue, 01 Nov 2022 10:20:48 -0400
X-MC-Unique: aGhysppNP0iXrvm-sdKAZQ-1
Received: by mail-ej1-f72.google.com with SMTP id he6-20020a1709073d8600b0078e20190301so8062989ejc.22
        for <netdev@vger.kernel.org>; Tue, 01 Nov 2022 07:20:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=af8a5692vQNnHtfl4OiAhO0hfTr2zQ516tgQOTBk6F8=;
        b=HJVAEflZgGttvaIhy3+5DWlHAVwPPPh7Ymle9yIQcKckkHOo1NH34j3zwEnNTT1e5l
         hiRNTLt/rYUsmqDokJP+p9B2wsLC4JQQGh8wXrWXMEU+oBzN+u8IHOxtd9VUt6TK78SX
         C1acGmSPsowmdiBbsanyFthFpgTJISzjIwF52emNIMMYihLTb/fliBPz1tVgFDHIyO79
         Gdh4PCUtC/UepZK0W2Hg68FwGsI2hlLJrRvl2vdYmMybRf/GpWAONN4AG75IipNX0joY
         ie16ZNa1HrLYB3dfKHayajAzTquBwiF7iu+KiFTBJXSPNF7OHMnf4mitDrZNKo7rEQZV
         EQFA==
X-Gm-Message-State: ACrzQf1AzIAa+rkzkpH0Jx5WhdsXwT5ceAapqQhNyRRKanBK5TvcFXy5
        blc09OAyWFHUxtCwBZN/QyC+n3j6GYKRvyaf+DV5oDWyTzTyzqwdyq5D2YSL9Fj4eqj5e4+GaCh
        FnOmyUXJFAgoLS1el
X-Received: by 2002:a17:907:1dec:b0:7aa:6262:f23f with SMTP id og44-20020a1709071dec00b007aa6262f23fmr18937200ejc.38.1667312446478;
        Tue, 01 Nov 2022 07:20:46 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6aDckAMRxEEVFgZBwDFvL3lMW4RACwP6nIccNT4NUAIDnjh9X31yp2rCqvrTBmz+z7LIZn4Q==
X-Received: by 2002:a17:907:1dec:b0:7aa:6262:f23f with SMTP id og44-20020a1709071dec00b007aa6262f23fmr18937142ejc.38.1667312446014;
        Tue, 01 Nov 2022 07:20:46 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id v14-20020a1709063bce00b0072af4af2f46sm4226672ejf.74.2022.11.01.07.20.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Nov 2022 07:20:45 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 21A2E723719; Tue,  1 Nov 2022 15:20:45 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     David Ahern <dsahern@gmail.com>,
        Stanislav Fomichev <sdf@google.com>,
        Martin KaFai Lau <martin.lau@linux.dev>
Cc:     "Bezdeka, Florian" <florian.bezdeka@siemens.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "alexandr.lobakin@intel.com" <alexandr.lobakin@intel.com>,
        "anatoly.burakov@intel.com" <anatoly.burakov@intel.com>,
        "song@kernel.org" <song@kernel.org>,
        "Deric, Nemanja" <nemanja.deric@siemens.com>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "Kiszka, Jan" <jan.kiszka@siemens.com>,
        "magnus.karlsson@gmail.com" <magnus.karlsson@gmail.com>,
        "willemb@google.com" <willemb@google.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "brouer@redhat.com" <brouer@redhat.com>, "yhs@fb.com" <yhs@fb.com>,
        "kpsingh@kernel.org" <kpsingh@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "mtahhan@redhat.com" <mtahhan@redhat.com>,
        "xdp-hints@xdp-project.net" <xdp-hints@xdp-project.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jolsa@kernel.org" <jolsa@kernel.org>,
        "haoluo@google.com" <haoluo@google.com>
Subject: Re: [xdp-hints] Re: [RFC bpf-next 0/5] xdp: hints via kfuncs
In-Reply-To: <3caaaf96-58cf-9bf5-dcfe-2f6522f4da02@gmail.com>
References: <20221027200019.4106375-1-sdf@google.com>
 <635bfc1a7c351_256e2082f@john.notmuch>
 <20221028110457.0ba53d8b@kernel.org>
 <CAKH8qBshi5dkhqySXA-Rg66sfX0-eTtVYz1ymHfBxSE=Mt2duA@mail.gmail.com>
 <635c62c12652d_b1ba208d0@john.notmuch>
 <20221028181431.05173968@kernel.org>
 <5aeda7f6bb26b20cb74ef21ae9c28ac91d57fae6.camel@siemens.com>
 <875yg057x1.fsf@toke.dk>
 <CAKH8qBvQbgE=oSZoH4xiLJmqMSXApH-ufd-qEKGKD8=POfhrWQ@mail.gmail.com>
 <77b115a0-bbba-48eb-89bd-3078b5fb7eeb@linux.dev>
 <CAKH8qBsGB1G60cu91Au816gsB2zF8T0P-yDwxbTEOxX0TN3WgA@mail.gmail.com>
 <87wn8e4z14.fsf@toke.dk> <3caaaf96-58cf-9bf5-dcfe-2f6522f4da02@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 01 Nov 2022 15:20:45 +0100
Message-ID: <87tu3i4uyq.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Ahern <dsahern@gmail.com> writes:

> On 11/1/22 6:52 AM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> Stanislav Fomichev <sdf@google.com> writes:
>>=20
>>> On Mon, Oct 31, 2022 at 3:57 PM Martin KaFai Lau <martin.lau@linux.dev>=
 wrote:
>>>>
>>>> On 10/31/22 10:00 AM, Stanislav Fomichev wrote:
>>>>>> 2. AF_XDP programs won't be able to access the metadata without usin=
g a
>>>>>> custom XDP program that calls the kfuncs and puts the data into the
>>>>>> metadata area. We could solve this with some code in libxdp, though;=
 if
>>>>>> this code can be made generic enough (so it just dumps the available
>>>>>> metadata functions from the running kernel at load time), it may be
>>>>>> possible to make it generic enough that it will be forward-compatible
>>>>>> with new versions of the kernel that add new fields, which should
>>>>>> alleviate Florian's concern about keeping things in sync.
>>>>>
>>>>> Good point. I had to convert to a custom program to use the kfuncs :-(
>>>>> But your suggestion sounds good; maybe libxdp can accept some extra
>>>>> info about at which offset the user would like to place the metadata
>>>>> and the library can generate the required bytecode?
>>>>>
>>>>>> 3. It will make it harder to consume the metadata when building SKBs=
. I
>>>>>> think the CPUMAP and veth use cases are also quite important, and th=
at
>>>>>> we want metadata to be available for building SKBs in this path. May=
be
>>>>>> this can be resolved by having a convenient kfunc for this that can =
be
>>>>>> used for programs doing such redirects. E.g., you could just call
>>>>>> xdp_copy_metadata_for_skb() before doing the bpf_redirect, and that
>>>>>> would recursively expand into all the kfunc calls needed to extract =
the
>>>>>> metadata supported by the SKB path?
>>>>>
>>>>> So this xdp_copy_metadata_for_skb will create a metadata layout that
>>>>
>>>> Can the xdp_copy_metadata_for_skb be written as a bpf prog itself?
>>>> Not sure where is the best point to specify this prog though.  Somehow=
 during
>>>> bpf_xdp_redirect_map?
>>>> or this prog belongs to the target cpumap and the xdp prog redirecting=
 to this
>>>> cpumap has to write the meta layout in a way that the cpumap is expect=
ing?
>>>
>>> We're probably interested in triggering it from the places where xdp
>>> frames can eventually be converted into skbs?
>>> So for plain 'return XDP_PASS' and things like bpf_redirect/etc? (IOW,
>>> anything that's not XDP_DROP / AF_XDP redirect).
>>> We can probably make it magically work, and can generate
>>> kernel-digestible metadata whenever data =3D=3D data_meta, but the
>>> question - should we?
>>> (need to make sure we won't regress any existing cases that are not
>>> relying on the metadata)
>>=20
>> So I was thinking about whether we could have the kernel do this
>> automatically, and concluded that this was probably not feasible in
>> general, which is why I suggested the explicit helper. My reasoning was
>> as follows:
>>=20
>> For straight XDP_PASS in the driver we don't actually need to do
>> anything today, as the driver itself will build the SKB and read any
>> metadata it needs from the HW descriptor[0].
>
> The program can pop encap headers, mpls tags, ... and thus affect the
> metadata in the descriptor (besides the timestamp).

Hmm, right, good point. How does XDP_PASS deal with that today, though?

I guess this is an argument for making the "read HW metadata into SKB
format" thing be a kfunc/helper rather than a flag to bpf_redirect(),
then. Because then we can allow the XDP program to override/modify the
metadata afterwards, either by defining it as:

int xdp_copy_metadata_for_skb(struct xdp_md *ctx, struct xdp_skb_meta *over=
ride, int flags)

where the XDP program can fill in 'override' with new data that takes
precedence over the stuff from the HW (like a modified checksum or
offset or something).

Or we can just have xdp_copy_metadata_for_skb() into the regular XDP
metadata area, and let the XDP program modify it afterwards. I feel like
the override argument would be easier to use, though.

Also, having it be completely opaque *where* the metadata is stored when
using xdp_copy_metadata_for_skb() lets us be more flexible about it.
E.g., the helper could write the timestamp directly into
skb_shared_info, instead of stuffing it into the metadata area where it
then has to be copied out later.

>> This leaves packets that are redirected (either to a veth or a cpumap so
>> we build SKBs from them later); here the problem is that we buffer the
>> packets (for performance reasons) so that the redirect doesn't actually
>> happen until after the driver exits the NAPI loop. At which point we
>> don't have access to the HW descriptors anymore, so we can't actually
>> read the metadata.
>>=20
>> This means that if we want to execute the metadata gathering
>> automatically, we'd have to do it in xdp_do_redirect(). Which means that
>> we'll have to figure out, at that point, whether the XDP frame is likely
>> to be converted to an SKB. This will add at least one branch (and
>> probably more) that will be in-path for every redirected frame.
>
> or forwarded to a tun device as an xdp frame and wanting to pass
> metadata into a VM which may construct an skb in the guest. This case is
> arguably aligned with the redirect from vendor1 to vendor2.
>
> This thread (and others) seem to be focused on the Rx path, but the Tx
> path is equally important with similar needs.

You're right, of course. Thinking a bit out loud here, but I actually
think the kfunc approach makes the TX side easier:

We already have to ability to execute a second "TX" XDP program inside
the devmaps. At which point that program is also tied to a particular
interface. So we could duplicate the RX-side kfunc trick, and expose a
set of *writer* kfuncs for metadata. So that an XDP program in the
devmap can simply do:

if (bpf_xdp_metadata_tx_timestamp_supported())
  bpf_xdp_metadata_tx_timestamp(ctx, tsval);

and those two kfuncs will be unrolled by the TX-side driver as well to
store them wherever they need to go to reach the wire.

The one complication here being, of course, that by the time the devmap
XDP program is executed, the driver hasn't seen the frame at all, yet,
so it doesn't have anywhere to store that data. We'd need to reuse the
frame metadata area for this (with some flag indicating that it's
valid), or we'd need a new area the driver could use as scratch space
specific to the xdp_frame (like the skb->cb field, I suppose).

-Toke

