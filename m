Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D928D624EBC
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 01:11:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229837AbiKKALZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 19:11:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbiKKALY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 19:11:24 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 882932612C
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 16:10:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668125426;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cN+b6fqq1dkQeTqQS6RUFlVS/ytGwTRKagES5GWY2hM=;
        b=ReHVa99Qzal90Q14SGnk52GuitgyG1Y+Xkj6wVk5G1m2+Xle4CLut+c+o7F01wRk9p9Kmf
        GwrgZBC7YM3FdOucRZqemRoFiSWcTHmn3Bn2SS6n2ihKZx6LWeJc1AEaSeynP5XZZKyWCK
        4bY2FOX7GKxOMUw9IYvHBQ32PVQUWOw=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-645-sl-WaE5nPiWBUV07z9Ziqw-1; Thu, 10 Nov 2022 19:10:25 -0500
X-MC-Unique: sl-WaE5nPiWBUV07z9Ziqw-1
Received: by mail-ej1-f72.google.com with SMTP id dn14-20020a17090794ce00b007ae5d040ca8so2086919ejc.17
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 16:10:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cN+b6fqq1dkQeTqQS6RUFlVS/ytGwTRKagES5GWY2hM=;
        b=NiU2boUHZYzI+Zd55TgZ3rjCi0cvSrRKj2Y32qrASMMQwYngPPfEV0xu53HghTVDgy
         l0k2JtOrXHp13j52PkgXUm0hU03pAWk2IjgEqx/UG2vAWvjXQCm1WkG984YsaOpFPhqz
         ejIYwdxAS1OMGBcwWWdJpRcj18yw3kqBF4gaiRwfFUlgy9fsykPQ3BY+yeHXyWAQFVsP
         CYTqzavlxKm0DIdCBI8Mv/bKqgqgFKGN5pLteCk48nj74FIlmkbn9+ysZhEt0WYAiNuc
         8LfC12f2L0sjd9mLHmNTLy9NVbC2Ltg3onBl8wJbQ3ipIBnFDHrBiv6O4nvyt+4U9Gkj
         akvg==
X-Gm-Message-State: ACrzQf38WZ+37FLJkyebH1FmKsb4S7a17Xmylk1f7tpwGoqanNlxpxnf
        GPr024edo8wWXpumZJtv+j3w4jHItNaA00VZf5mMrbsanX6sQY3CJN49jKxTrQhz5m3W06w/tzT
        ZW++WqUIeh+zCV6c4
X-Received: by 2002:a17:906:9f04:b0:7ad:cda3:93c7 with SMTP id fy4-20020a1709069f0400b007adcda393c7mr4381891ejc.500.1668125423790;
        Thu, 10 Nov 2022 16:10:23 -0800 (PST)
X-Google-Smtp-Source: AMsMyM7TLFcR6zwXStLirBPX+20mv1HMXyySdJVex4wXCDY3TULLAXTv2TLcymv9KQwXqBUnvjJM2g==
X-Received: by 2002:a17:906:9f04:b0:7ad:cda3:93c7 with SMTP id fy4-20020a1709069f0400b007adcda393c7mr4381866ejc.500.1668125423373;
        Thu, 10 Nov 2022 16:10:23 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id o5-20020a056402038500b004619f024864sm407288edv.81.2022.11.10.16.10.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Nov 2022 16:10:22 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 98D70782762; Fri, 11 Nov 2022 01:10:22 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Martin KaFai Lau <martin.lau@linux.dev>, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, song@kernel.org,
        yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org,
        haoluo@google.com, jolsa@kernel.org,
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
In-Reply-To: <CAKH8qBtjYV=tb28y6bvo3tGonzjvm2JLyis9AFPSMTuXsL3NPA@mail.gmail.com>
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
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 11 Nov 2022 01:10:22 +0100
Message-ID: <87eduaxsep.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Stanislav Fomichev <sdf@google.com> writes:

> On Thu, Nov 10, 2022 at 3:14 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@re=
dhat.com> wrote:
>>
>> Skipping to the last bit:
>>
>> >> >> >    } else {
>> >> >> >      use kfuncs
>> >> >> >    }
>> >> >> >
>> >> >> > 5. Support the case where we keep program's metadata and kernel's
>> >> >> > xdp_to_skb_metadata
>> >> >> >    - skb_metadata_import_from_xdp() will "consume" it by mem-mov=
ing the
>> >> >> > rest of the metadata over it and adjusting the headroom
>> >> >>
>> >> >> I was thinking the kernel's xdp_to_skb_metadata is always before t=
he program's
>> >> >> metadata.  xdp prog should usually work in this order also: read/w=
rite headers,
>> >> >> write its own metadata, call bpf_xdp_metadata_export_to_skb(), and=
 return
>> >> >> XDP_PASS/XDP_REDIRECT.  When it is XDP_PASS, the kernel just needs=
 to pop the
>> >> >> xdp_to_skb_metadata and pass the remaining program's metadata to t=
he bpf-tc.
>> >> >>
>> >> >> For the kernel and xdp prog, I don't think it matters where the
>> >> >> xdp_to_skb_metadata is.  However, the xdp->data_meta (program's me=
tadata) has to
>> >> >> be before xdp->data because of the current data_meta and data comp=
arison usage
>> >> >> in the xdp prog.
>> >> >>
>> >> >> The order of the kernel's xdp_to_skb_metadata and the program's me=
tadata
>> >> >> probably only matters to the userspace AF_XDP.  However, I don't s=
ee how AF_XDP
>> >> >> supports the program's metadata now.  afaict, it can only work now=
 if there is
>> >> >> some sort of contract between them or the AF_XDP currently does no=
t use the
>> >> >> program's metadata.  Either way, we can do the mem-moving only for=
 AF_XDP and it
>> >> >> should be a no op if there is no program's metadata?  This behavio=
r could also
>> >> >> be configurable through setsockopt?
>> >> >
>> >> > Agreed on all of the above. For now it seems like the safest thing =
to
>> >> > do is to put xdp_to_skb_metadata last to allow af_xdp to properly
>> >> > locate btf_id.
>> >> > Let's see if Toke disagrees :-)
>> >>
>> >> As I replied to Martin, I'm not sure it's worth the complexity to
>> >> logically split the SKB metadata from the program's own metadata (as
>> >> opposed to just reusing the existing data_meta pointer)?
>> >
>> > I'd gladly keep my current requirement where it's either or, but not b=
oth :-)
>> > We can relax it later if required?
>>
>> So the way I've been thinking about it is simply that the skb_metadata
>> would live in the same place at the data_meta pointer (including
>> adjusting that pointer to accommodate it), and just overriding the
>> existing program metadata, if any exists. But looking at it now, I guess
>> having the split makes it easier for a program to write its own custom
>> metadata and still use the skb metadata. See below about the ordering.
>>
>> >> However, if we do, the layout that makes most sense to me is putting =
the
>> >> skb metadata before the program metadata, like:
>> >>
>> >> --------------
>> >> | skb_metadata
>> >> --------------
>> >> | data_meta
>> >> --------------
>> >> | data
>> >> --------------
>> >>
>> >> Not sure if that's what you meant? :)
>> >
>> > I was suggesting the other way around: |custom meta|skb_metadata|data|
>> > (but, as Martin points out, consuming skb_metadata in the kernel
>> > becomes messier)
>> >
>> > af_xdp can check whether skb_metdata is present by looking at data -
>> > offsetof(struct skb_metadata, btf_id).
>> > progs that know how to handle custom metadata, will look at data -
>> > sizeof(skb_metadata)
>> >
>> > Otherwise, if it's the other way around, how do we find skb_metadata
>> > in a redirected frame?
>> > Let's say we have |skb_metadata|custom meta|data|, how does the final
>> > program find skb_metadata?
>> > All the progs have to agree on the sizeof(tc/custom meta), right?
>>
>> Erm, maybe I'm missing something here, but skb_metadata is fixed size,
>> right? So if the "skb_metadata is present" flag is set, we know that the
>> sizeof(skb_metadata) bytes before the data_meta pointer contains the
>> metadata, and if the flag is not set, we know those bytes are not valid
>> metadata.
>>
>> For AF_XDP, we'd need to transfer the flag as well, and it could apply
>> the same logic (getting the size from the vmlinux BTF).
>>
>> By this logic, the BTF_ID should be the *first* entry of struct
>> skb_metadata, since that will be the field AF_XDP programs can find
>> right off the bat, no?
>
> The problem with AF_XDP is that, IIUC, it doesn't have a data_meta
> pointer in the userspace.
>
> You get an rx descriptor where the address points to the 'data':
> | 256 bytes headroom where metadata can go | data |

Ah, I was missing the bit where the data pointer actually points at
data, not the start of the buf. Oops, my bad!

> So you have (at most) 256 bytes of headroom, some of that might be the
> metadata, but you really don't know where it starts. But you know it
> definitely ends where the data begins.
>
> So if we have the following, we can locate skb_metadata:
> | 256-sizeof(skb_metadata) headroom | custom metadata | skb_metadata | da=
ta |
> data - sizeof(skb_metadata) will get you there
>
> But if it's the other way around, the program has to know
> sizeof(custom metadata) to locate skb_metadata:
> | 256-sizeof(skb_metadata) headroom | skb_metadata | custom metadata | da=
ta |
>
> Am I missing something here?

Hmm, so one could argue that the only way AF_XDP can consume custom
metadata today is if it knows out of band what the size of it is. And if
it knows that, it can just skip over it to go back to the skb_metadata,
no?

The only problem left then is if there were multiple XDP programs called
in sequence (whether before a redirect, or by libxdp chaining or tail
calls), and the first one resized the metadata area without the last one
knowing about it. For this, we could add a CLOBBER_PROGRAM_META flag to
the skb_metadata helper which if set will ensure that the program
metadata length is reset to 0?

-Toke

