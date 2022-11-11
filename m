Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 165866256F6
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 10:39:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233683AbiKKJjN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 04:39:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233459AbiKKJjM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 04:39:12 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 909BB6CA3D
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 01:38:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668159493;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CuzRwI1mSTi/386dr9HtHu+gFAxlK7t/8OnS9h0/MI8=;
        b=fWPOZ/ICmybkufdzg1zkayjx7xJji2tCbckq2BQ/79rkbNKvZAqrFwxMuN/402Rge9f8m2
        UOk66/GseoCHxfMo9b84DD5JHn/Fv/mdX2zxk2b2nuKrgoTZHoLOL11kqALFxm7wXKpefJ
        zbnwB0SWh0TpwPO4Znt2rgxhDoSJ668=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-211-_GQ3pd54PbWTAiwB7A6uMA-1; Fri, 11 Nov 2022 04:38:12 -0500
X-MC-Unique: _GQ3pd54PbWTAiwB7A6uMA-1
Received: by mail-ej1-f70.google.com with SMTP id sh31-20020a1709076e9f00b007ae32b7eb51so2732543ejc.9
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 01:38:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CuzRwI1mSTi/386dr9HtHu+gFAxlK7t/8OnS9h0/MI8=;
        b=vltYcUxHclNrfxe1vm/PVf0WbyV62SNyTWkLX0j6iLGyWu/sRUvW1CtvjvVtPpKeJw
         W9Ij1o9o+MBHxfQC8+A1EhEfxmJL3wOPScwSdURGInzW37Z9sDk7sXVyr9/WX1o6eOVb
         7fFDICuew9SE7/Oald6seR2MHhW2kSNGHUL5NYhl7ALzjUI6O08MQSPDrloD3bVXixeU
         AeJYTDs3dPgDrVF/OR1XRB7HVlSoe9qr5aWUiR2mwHSlZ+2CRpzsIggtnsVs0UZxaVjZ
         RXkVMYJEg74XuLnj7zquVsV1b9t1Ta8V/U8XdNOsVYUSo6K4ftUqyjFEgv99ov7rbMnk
         laVw==
X-Gm-Message-State: ANoB5pkWRT7PPmdPr7UVlO3zjg/wrKD/ZkrFnBXxkERnnF2Gcb/+WMPA
        3Uk4iCYJwl7JM0LkpDDHl9ooU0rCZpfNHWXXLFl5WK+e5z5VMoC+6acKUC1s84BOZZvBsgi4G+6
        8jC8CbIxf7wX24825
X-Received: by 2002:a05:6402:34f:b0:460:12ef:cc45 with SMTP id r15-20020a056402034f00b0046012efcc45mr731719edw.249.1668159491247;
        Fri, 11 Nov 2022 01:38:11 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5BoVg5/sQIOxSVn1Wrw0hWRqLlG7VKbMrBd99qOGof+9QDVLhrIqKUJpzb0Jcybgy+fNljWA==
X-Received: by 2002:a05:6402:34f:b0:460:12ef:cc45 with SMTP id r15-20020a056402034f00b0046012efcc45mr731679edw.249.1668159490817;
        Fri, 11 Nov 2022 01:38:10 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id eg25-20020a056402289900b00457b5ba968csm875513edb.27.2022.11.11.01.38.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Nov 2022 01:38:10 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 3E3EE7A689F; Fri, 11 Nov 2022 10:37:53 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Martin KaFai Lau <martin.lau@linux.dev>,
        Stanislav Fomichev <sdf@google.com>
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
Subject: Re: [xdp-hints] Re: [RFC bpf-next v2 06/14] xdp: Carry over xdp
 metadata into skb context
In-Reply-To: <d403ef7d-6dfd-bcaf-6088-cff5081f49e9@linux.dev>
References: <20221104032532.1615099-1-sdf@google.com>
 <20221104032532.1615099-7-sdf@google.com>
 <187e89c3-d7de-7bec-c72e-d9d6eb5bcca0@linux.dev>
 <CAKH8qBv_ZO=rsJcq2Lvq36d9sTAXs6kfUmW1Hk17bB=BGiGzhw@mail.gmail.com>
 <9a8fefe4-2fcb-95b7-cda0-06509feee78e@linux.dev>
 <6f57370f-7ec3-07dd-54df-04423cab6d1f@linux.dev> <87leokz8lq.fsf@toke.dk>
 <5a23b856-88a3-a57a-2191-b673f4160796@linux.dev>
 <CAKH8qBsfVOoR1MNAFx3uR9Syoc0APHABsf97kb8SGpK+T1qcew@mail.gmail.com>
 <32f81955-8296-6b9a-834a-5184c69d3aac@linux.dev>
 <CAKH8qBuLMZrFmmi77Qbt7DCd1w9FJwdeK5CnZTJqHYiWxwDx6w@mail.gmail.com>
 <87y1siyjf6.fsf@toke.dk>
 <CAKH8qBsfzYmQ9SZXhFetf_zQPNmE_L=_H_rRxJEwZzNbqtoKJA@mail.gmail.com>
 <87o7texv08.fsf@toke.dk>
 <CAKH8qBtjYV=tb28y6bvo3tGonzjvm2JLyis9AFPSMTuXsL3NPA@mail.gmail.com>
 <87eduaxsep.fsf@toke.dk> <d403ef7d-6dfd-bcaf-6088-cff5081f49e9@linux.dev>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 11 Nov 2022 10:37:53 +0100
Message-ID: <87o7td7rwu.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Martin KaFai Lau <martin.lau@linux.dev> writes:

> On 11/10/22 4:10 PM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>>> The problem with AF_XDP is that, IIUC, it doesn't have a data_meta
>>> pointer in the userspace.
>>>
>>> You get an rx descriptor where the address points to the 'data':
>>> | 256 bytes headroom where metadata can go | data |
>>=20
>> Ah, I was missing the bit where the data pointer actually points at
>> data, not the start of the buf. Oops, my bad!
>>=20
>>> So you have (at most) 256 bytes of headroom, some of that might be the
>>> metadata, but you really don't know where it starts. But you know it
>>> definitely ends where the data begins.
>>>
>>> So if we have the following, we can locate skb_metadata:
>>> | 256-sizeof(skb_metadata) headroom | custom metadata | skb_metadata | =
data |
>>> data - sizeof(skb_metadata) will get you there
>>>
>>> But if it's the other way around, the program has to know
>>> sizeof(custom metadata) to locate skb_metadata:
>>> | 256-sizeof(skb_metadata) headroom | skb_metadata | custom metadata | =
data |
>>>
>>> Am I missing something here?
>>=20
>> Hmm, so one could argue that the only way AF_XDP can consume custom
>> metadata today is if it knows out of band what the size of it is. And if
>> it knows that, it can just skip over it to go back to the skb_metadata,
>> no?
>
> +1 I replied with a similar point in another email. I also think we
> can safely assume this.

Great!

>>=20
>> The only problem left then is if there were multiple XDP programs called
>> in sequence (whether before a redirect, or by libxdp chaining or tail
>> calls), and the first one resized the metadata area without the last one
>> knowing about it. For this, we could add a CLOBBER_PROGRAM_META flag to
>> the skb_metadata helper which if set will ensure that the program
>> metadata length is reset to 0?
>
> How is it different from the same xdp prog calling bpf_xdp_adjust_meta() =
and=20
> bpf_xdp_metadata_export_to_skb() multiple times.  The earlier stored=20
> skb_metadata needs to be moved during the latter bpf_xdp_adjust_meta().  =
The=20
> latter bpf_xdp_metadata_export_to_skb() will overwrite the earlier skb_me=
tadata.

Well, it would just be a convenience flag, so instead of doing:

metalen =3D ctx->data - ctx->data_meta;
if (metalen)
  xdp_adjust_meta(-metalen);
bpf_xdp_metadata_export_to_skb(ctx);

you could just do:

bpf_xdp_metadata_export_to_skb(ctx, CLOBBER_PROGRAM_META);

and the kernel would do the check+move for you. But, well, the couple of
extra instructions to do the check in BPF is probably fine.

(I'm talking here about a program that wants to make sure that any
custom metadata that may have been added by an earlier program is
removed before redirecting to an XSK socket; I expect we'd want to do
something like this in the default program in libxdp).

-Toke

