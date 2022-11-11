Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36EA962570F
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 10:42:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233484AbiKKJml (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 04:42:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231235AbiKKJmj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 04:42:39 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 242E2654E3
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 01:41:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668159696;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xbnPOqtI0GzWpFzFMeJ+pnuodgROHkMeeL/ReftNsOE=;
        b=WHqh3lzHyMO4jkgzDeDQVcTGxHBP2UW0CV817rFIz8u7QgHrPRXH5B5bph6BZvwiVGatO6
        ZRvWRAdjfj4Uu7ToeM4UF6b4oPK8J9aYkvWPvRQyPP4cJxOO9qQ6ZoFTdefOc9vtdLWgiz
        lgH3n4vl+D+5tP3IHosVwBXwARXIhQ8=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-271-6yf002k7PFuOzfGjww0Xrw-1; Fri, 11 Nov 2022 04:41:34 -0500
X-MC-Unique: 6yf002k7PFuOzfGjww0Xrw-1
Received: by mail-ed1-f69.google.com with SMTP id b13-20020a056402350d00b00464175c3f1eso3274074edd.11
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 01:41:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xbnPOqtI0GzWpFzFMeJ+pnuodgROHkMeeL/ReftNsOE=;
        b=SFutkWtON2i6B7CP/ovhB89UCxpy1oF3UlHQ2ToqGYXL/tUGWvE7xVus+GAps2sKb3
         UprGIW6UcTzha21xUYi34hY+7BhV94NkTFv7QFhP9zqh/+Iqfgpf9PxaxT2j/OTcI7tq
         wTUgfZAuqQoM+Dq7lN8FW5TXitnTbaeM03acai1oTJzTqXDnBMbgN8jIlL06rwCs6To9
         imnFIAeUqnKxSIJ1abX4ElBw0xOm66R9PLMqG8foF0YOtI4C1tM2cp6MKBhWxUxRo+cv
         llnZ7JgSjMixiipMCgrQOXTfymhX6u55HdieE4S0LyKSzXrzbIXmPzt/u8tPGm8d6kdv
         1MSA==
X-Gm-Message-State: ANoB5pnT5MT57vYpaQMNfLd0MS1By/e3//bDTsLC2rGXD6R9fJJbgzHm
        kNAz6XvbOllKJrIS7gmF0oGxUxdJM+uVNH/PKVkx9cy7gSpE+lgZ8idy7niX7H+8IsJG33Y9fOG
        uLnULPxMCyxIDrDjy
X-Received: by 2002:a17:906:7692:b0:7ae:3fa3:d7c6 with SMTP id o18-20020a170906769200b007ae3fa3d7c6mr1121708ejm.494.1668159693506;
        Fri, 11 Nov 2022 01:41:33 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6Mg+PoPArGJwZiTT3bqzPZX5EP/LiJTsP0djh+ZVpddPIv6lk82BEnXjz3ExeQxTbQb/kWZg==
X-Received: by 2002:a17:906:7692:b0:7ae:3fa3:d7c6 with SMTP id o18-20020a170906769200b007ae3fa3d7c6mr1121685ejm.494.1668159693073;
        Fri, 11 Nov 2022 01:41:33 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id ky14-20020a170907778e00b00782539a02absm663743ejc.194.2022.11.11.01.41.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Nov 2022 01:41:32 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id D9A427A68A1; Fri, 11 Nov 2022 10:41:29 +0100 (CET)
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
In-Reply-To: <2e3c1e2d-bc60-b406-31e3-6e922eea3f9f@linux.dev>
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
 <d8d23d7b-c997-ae8d-b4ee-a1182ff657f5@linux.dev>
 <CAKH8qBvoR36wJShRE5zbgif2L9hweM6vSPVEHugY_ctOQgvpdQ@mail.gmail.com>
 <2e3c1e2d-bc60-b406-31e3-6e922eea3f9f@linux.dev>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 11 Nov 2022 10:41:29 +0100
Message-ID: <87leoh7rqu.fsf@toke.dk>
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

> On 11/10/22 4:57 PM, Stanislav Fomichev wrote:
>> On Thu, Nov 10, 2022 at 4:33 PM Martin KaFai Lau <martin.lau@linux.dev> =
wrote:
>>>
>>> On 11/10/22 3:52 PM, Stanislav Fomichev wrote:
>>>> On Thu, Nov 10, 2022 at 3:14 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke=
@redhat.com> wrote:
>>>>>
>>>>> Skipping to the last bit:
>>>>>
>>>>>>>>>>      } else {
>>>>>>>>>>        use kfuncs
>>>>>>>>>>      }
>>>>>>>>>>
>>>>>>>>>> 5. Support the case where we keep program's metadata and kernel's
>>>>>>>>>> xdp_to_skb_metadata
>>>>>>>>>>      - skb_metadata_import_from_xdp() will "consume" it by mem-m=
oving the
>>>>>>>>>> rest of the metadata over it and adjusting the headroom
>>>>>>>>>
>>>>>>>>> I was thinking the kernel's xdp_to_skb_metadata is always before =
the program's
>>>>>>>>> metadata.  xdp prog should usually work in this order also: read/=
write headers,
>>>>>>>>> write its own metadata, call bpf_xdp_metadata_export_to_skb(), an=
d return
>>>>>>>>> XDP_PASS/XDP_REDIRECT.  When it is XDP_PASS, the kernel just need=
s to pop the
>>>>>>>>> xdp_to_skb_metadata and pass the remaining program's metadata to =
the bpf-tc.
>>>>>>>>>
>>>>>>>>> For the kernel and xdp prog, I don't think it matters where the
>>>>>>>>> xdp_to_skb_metadata is.  However, the xdp->data_meta (program's m=
etadata) has to
>>>>>>>>> be before xdp->data because of the current data_meta and data com=
parison usage
>>>>>>>>> in the xdp prog.
>>>>>>>>>
>>>>>>>>> The order of the kernel's xdp_to_skb_metadata and the program's m=
etadata
>>>>>>>>> probably only matters to the userspace AF_XDP.  However, I don't =
see how AF_XDP
>>>>>>>>> supports the program's metadata now.  afaict, it can only work no=
w if there is
>>>>>>>>> some sort of contract between them or the AF_XDP currently does n=
ot use the
>>>>>>>>> program's metadata.  Either way, we can do the mem-moving only fo=
r AF_XDP and it
>>>>>>>>> should be a no op if there is no program's metadata?  This behavi=
or could also
>>>>>>>>> be configurable through setsockopt?
>>>>>>>>
>>>>>>>> Agreed on all of the above. For now it seems like the safest thing=
 to
>>>>>>>> do is to put xdp_to_skb_metadata last to allow af_xdp to properly
>>>>>>>> locate btf_id.
>>>>>>>> Let's see if Toke disagrees :-)
>>>>>>>
>>>>>>> As I replied to Martin, I'm not sure it's worth the complexity to
>>>>>>> logically split the SKB metadata from the program's own metadata (as
>>>>>>> opposed to just reusing the existing data_meta pointer)?
>>>>>>
>>>>>> I'd gladly keep my current requirement where it's either or, but not=
 both :-)
>>>>>> We can relax it later if required?
>>>>>
>>>>> So the way I've been thinking about it is simply that the skb_metadata
>>>>> would live in the same place at the data_meta pointer (including
>>>>> adjusting that pointer to accommodate it), and just overriding the
>>>>> existing program metadata, if any exists. But looking at it now, I gu=
ess
>>>>> having the split makes it easier for a program to write its own custom
>>>>> metadata and still use the skb metadata. See below about the ordering.
>>>>>
>>>>>>> However, if we do, the layout that makes most sense to me is puttin=
g the
>>>>>>> skb metadata before the program metadata, like:
>>>>>>>
>>>>>>> --------------
>>>>>>> | skb_metadata
>>>>>>> --------------
>>>>>>> | data_meta
>>>>>>> --------------
>>>>>>> | data
>>>>>>> --------------
>>>>>>>
>>>
>>> Yeah, for the kernel and xdp prog (ie not AF_XDP), I meant this:
>>>
>>> | skb_metadata | custom metadata | data |
>>>
>>>>>>> Not sure if that's what you meant? :)
>>>>>>
>>>>>> I was suggesting the other way around: |custom meta|skb_metadata|dat=
a|
>>>>>> (but, as Martin points out, consuming skb_metadata in the kernel
>>>>>> becomes messier)
>>>>>>
>>>>>> af_xdp can check whether skb_metdata is present by looking at data -
>>>>>> offsetof(struct skb_metadata, btf_id).
>>>>>> progs that know how to handle custom metadata, will look at data -
>>>>>> sizeof(skb_metadata)
>>>>>>
>>>>>> Otherwise, if it's the other way around, how do we find skb_metadata
>>>>>> in a redirected frame?
>>>>>> Let's say we have |skb_metadata|custom meta|data|, how does the final
>>>>>> program find skb_metadata?
>>>>>> All the progs have to agree on the sizeof(tc/custom meta), right?
>>>>>
>>>>> Erm, maybe I'm missing something here, but skb_metadata is fixed size,
>>>>> right? So if the "skb_metadata is present" flag is set, we know that =
the
>>>>> sizeof(skb_metadata) bytes before the data_meta pointer contains the
>>>>> metadata, and if the flag is not set, we know those bytes are not val=
id
>>>>> metadata.
>>>
>>> right, so to get to the skb_metadata, it will be
>>> data_meta -=3D sizeof(skb_metadata);  /* probably need alignment */
>>>
>>>>>
>>>>> For AF_XDP, we'd need to transfer the flag as well, and it could apply
>>>>> the same logic (getting the size from the vmlinux BTF).
>>>>>
>>>>> By this logic, the BTF_ID should be the *first* entry of struct
>>>>> skb_metadata, since that will be the field AF_XDP programs can find
>>>>> right off the bat, no? >
>>>> The problem with AF_XDP is that, IIUC, it doesn't have a data_meta
>>>> pointer in the userspace.
>>>
>>> Yep. It is my understanding also.  Missing data_meta pointer in the AF_=
XDP
>>> rx_desc is a potential problem.  Having BTF_ID or not won't help.
>>>
>>>>
>>>> You get an rx descriptor where the address points to the 'data':
>>>> | 256 bytes headroom where metadata can go | data |
>>>>
>>>> So you have (at most) 256 bytes of headroom, some of that might be the
>>>> metadata, but you really don't know where it starts. But you know it
>>>> definitely ends where the data begins.
>>>>
>>>> So if we have the following, we can locate skb_metadata:
>>>> | 256-sizeof(skb_metadata) headroom | custom metadata | skb_metadata |=
 data |
>>>> data - sizeof(skb_metadata) will get you there
>>>>
>>>> But if it's the other way around, the program has to know
>>>> sizeof(custom metadata) to locate skb_metadata:
>>>> | 256-sizeof(skb_metadata) headroom | skb_metadata | custom metadata |=
 data |
>>>
>>> Right, this won't work if the AF_XDP user does not know how big the cus=
tom
>>> metadata is.  The kernel then needs to swap the "skb_metadata" and "cus=
tom
>>> metadata" + setting a flag in the AF_XDP rx_desc->options to make it lo=
oks like
>>> this:
>>> | custom metadata | skb_metadata | data |
>>>
>>> However, since data_meta is missing from the rx_desc, may be we can saf=
ely
>>> assume the AF_XDP user always knows the size of the custom metadata or =
there is
>>> usually no "custom metadata" and no swap is needed?
>>=20
>> If we can assume they can share that info, can they also share more
>> info on what kind of metadata they would prefer to get?
>> If they can agree on the size, maybe they also can agree on the flows
>> that need skb_metdata vs the flows that need a custom one?
>>=20
>> Seems like we can start with supporting either one, but not both and
>> extend in the future once we have more understanding on whether it's
>> actually needed or not?
>>=20
>> bpf_xdp_metadata_export_to_skb: adjust data meta, add uses-skb-metadata =
flag
>> bpf_xdp_adjust_meta: unconditionally reset uses-skb-metadata flag
> hmm... I am thinking:
>
> bpf_xdp_adjust_meta: move the existing (if any) skb_metadata and adjust=20
> xdp->data_meta.
>
> bpf_xdp_metadata_export_to_skb: If skb_metadata exists, overwrites the ex=
isting=20
> one.  If not exists, gets headroom before xdp->data_meta and writes hints.

Yeah, +1 on this. For AF_XDP that means that if you only do
bpf_xdp_metadata_export_to_skb() you'll get the skb metadata right
before data, and if you add custom metadata yourself, that goes
in-between so you'll need to have some way to communicate the length to
the AF_XDP consumer. And a default program (like in libxdp) can just
check the metadata pointer and make sure to remove any metadata before
redirecting to userspace, like in the example from my other reply to
Martin.

-Toke

