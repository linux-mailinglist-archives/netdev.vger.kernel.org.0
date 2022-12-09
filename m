Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5FA26482A6
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 14:00:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229815AbiLINAZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 08:00:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbiLINAY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 08:00:24 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FAEB1DF0A
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 04:59:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670590769;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IeC3V4Nv/NsdvdBX2htp9hv5uXYY+hSvBqMVRWFE8oI=;
        b=T1FW7dXDFh7RVtAYOTOJLEJNf/H1wNwvzsY5w2CpIwVfI8vSXbEJ7emY/YlwsjG3a5Dcoa
        BESFwiStHWuYGdvfrST3+2kKYpsEyQuEODSy7HF3656yJQd631wB3oXMnVIi4Mqa89PzT9
        72MlGrgZgUERxb/lfcSz6hfXM59UecA=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-444-Tgmp1n3NNHqZR-dsk7rJkg-1; Fri, 09 Dec 2022 07:59:28 -0500
X-MC-Unique: Tgmp1n3NNHqZR-dsk7rJkg-1
Received: by mail-ed1-f69.google.com with SMTP id w22-20020a056402269600b0046b00a9ee5fso1328190edd.2
        for <netdev@vger.kernel.org>; Fri, 09 Dec 2022 04:59:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IeC3V4Nv/NsdvdBX2htp9hv5uXYY+hSvBqMVRWFE8oI=;
        b=FKccfYrt2SG1VP5vfTevR+DHftUfXRJyRuh35Os2KXaMXivfuemxvFCe1TiXK6O9Tc
         4I8XgaJGgHFe69urkO+uPOLQfWKrs2pDJixkdicoVpNXdGMwxZ0bztw5mIQT9wrxE9Zo
         MYqysfmX3C0iEpcwIw9jTP9dgHIam6sT9NGkcEjqSumm72iASY3CY1DMIJML0r09/QKF
         OF0j0HuoSgbrKhrb/ZhdDJUPFanrz5z43MxjXoOrbocvtasf+P6SFqtXd9ZsraO18Ue0
         sQ53uLnL/KrgbbDvgUrL5e91eJ8bG5LFt7xz6nIU0dGEWMBQYHiFcgavTkcNNji4bmRw
         wewg==
X-Gm-Message-State: ANoB5pnXUP4trtDz67eUwCssQPuKDF2rhRSsLbVnmGxMGx31WEoa9Gjf
        8PLA4pLHNE5AHBR42ICkea4e2VC7IbuJG+SWytEgkJahYFm7+c8Km2db8hTOvVTBCTdg5mpVMqT
        IIYK1M6Htg1CyVLhu
X-Received: by 2002:aa7:cc09:0:b0:461:b2d7:46b5 with SMTP id q9-20020aa7cc09000000b00461b2d746b5mr4823465edt.7.1670590767249;
        Fri, 09 Dec 2022 04:59:27 -0800 (PST)
X-Google-Smtp-Source: AA0mqf62yqbyHKMXuCwuCnCOSrMW7y2E0jvLw7+w8XTVt3ir1lQes3EUGT1RFAq952dNBRtdmzNRpQ==
X-Received: by 2002:aa7:cc09:0:b0:461:b2d7:46b5 with SMTP id q9-20020aa7cc09000000b00461b2d746b5mr4823422edt.7.1670590766878;
        Fri, 09 Dec 2022 04:59:26 -0800 (PST)
Received: from [192.168.41.200] (83-90-141-187-cable.dk.customer.tdc.net. [83.90.141.187])
        by smtp.gmail.com with ESMTPSA id p4-20020aa7d304000000b00461cdda400esm624646edq.4.2022.12.09.04.59.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Dec 2022 04:59:26 -0800 (PST)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <66fa1861-30dd-6d00-ed14-0cf4a6b39f3c@redhat.com>
Date:   Fri, 9 Dec 2022 13:59:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Cc:     brouer@redhat.com,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        Network Development <netdev@vger.kernel.org>
Subject: Re: [xdp-hints] Re: [PATCH bpf-next v3 11/12] mlx5: Support RX XDP
 metadata
Content-Language: en-US
To:     Saeed Mahameed <saeed@kernel.org>,
        Stanislav Fomichev <sdf@google.com>
References: <20221206024554.3826186-1-sdf@google.com>
 <20221206024554.3826186-12-sdf@google.com> <875yellcx6.fsf@toke.dk>
 <CAKH8qBv7nWdknuf3ap_ekpAhMgvtmoJhZ3-HRuL8Wv70SBWMSQ@mail.gmail.com>
 <87359pl9zy.fsf@toke.dk>
 <CAADnVQ+=71Y+ypQTOgFTJWY7w3YOUdY39is4vpo3aou11=eMmw@mail.gmail.com>
 <87tu25ju77.fsf@toke.dk>
 <CAADnVQ+MyE280Q-7iw2Y-P6qGs4xcDML-tUrXEv_EQTmeESVaQ@mail.gmail.com>
 <87o7sdjt20.fsf@toke.dk>
 <CAKH8qBswBu7QAWySWOYK4X41mwpdBj0z=6A9WBHjVYQFq9Pzjw@mail.gmail.com>
 <Y5LGlgpxpzSu701h@x130>
In-Reply-To: <Y5LGlgpxpzSu701h@x130>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 09/12/2022 06.24, Saeed Mahameed wrote:
> On 08 Dec 18:57, Stanislav Fomichev wrote:
>> On Thu, Dec 8, 2022 at 4:54 PM Toke Høiland-Jørgensen 
>> <toke@redhat.com> wrote:
>>>
>>> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
>>>
>>> > On Thu, Dec 8, 2022 at 4:29 PM Toke Høiland-Jørgensen <toke@redhat.com> wrote:
>>> >>
>>> >> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
>>> >>
>>> >> > On Thu, Dec 8, 2022 at 4:02 PM Toke Høiland-Jørgensen <toke@redhat.com> wrote:
>>> >> >>
>>> >> >> Stanislav Fomichev <sdf@google.com> writes:
>>> >> >>
>>> >> >> > On Thu, Dec 8, 2022 at 2:59 PM Toke Høiland-Jørgensen <toke@redhat.com> wrote:
>>> >> >> >>
>>> >> >> >> Stanislav Fomichev <sdf@google.com> writes:
>>> >> >> >>
>>> >> >> >> > From: Toke Høiland-Jørgensen <toke@redhat.com>
>>> >> >> >> >
>>> >> >> >> > Support RX hash and timestamp metadata kfuncs. We need to pass in the cqe
>>> >> >> >> > pointer to the mlx5e_skb_from* functions so it can be retrieved from the
>>> >> >> >> > XDP ctx to do this.
>>> >> >> >>
>>> >> >> >> So I finally managed to get enough ducks in row to actually benchmark
>>> >> >> >> this. With the caveat that I suddenly can't get the timestamp support to
>>> >> >> >> work (it was working in an earlier version, but now
>>> >> >> >> timestamp_supported() just returns false). I'm not sure if this is an
>>> >> >> >> issue with the enablement patch, or if I just haven't gotten the
>>> >> >> >> hardware configured properly. I'll investigate some more, but figured
>>> >> >> >> I'd post these results now:
>>> >> >> >>
>>> >> >> >> Baseline XDP_DROP:         25,678,262 pps / 38.94 ns/pkt
>>> >> >> >> XDP_DROP + read metadata:  23,924,109 pps / 41.80 ns/pkt
>>> >> >> >> Overhead:                   1,754,153 pps /  2.86 ns/pkt
>>> >> >> >>
>>> >> >> >> As per the above, this is with calling three kfuncs/pkt
>>> >> >> >> (metadata_supported(), rx_hash_supported() and rx_hash()). So that's
>>> >> >> >> ~0.95 ns per function call, which is a bit less, but not far off from
>>> >> >> >> the ~1.2 ns that I'm used to. The tests where I accidentally called the
>>> >> >> >> default kfuncs cut off ~1.3 ns for one less kfunc call, so it's
>>> >> >> >> definitely in that ballpark.
>>> >> >> >>
>>> >> >> >> I'm not doing anything with the data, just reading it into an on-stack
>>> >> >> >> buffer, so this is the smallest possible delta from just getting the
>>> >> >> >> data out of the driver. I did confirm that the call instructions are
>>> >> >> >> still in the BPF program bytecode when it's dumped back out from the
>>> >> >> >> kernel.
>>> >> >> >>
>>> >> >> >> -Toke
>>> >> >> >>
>>> >> >> >
>>> >> >> > Oh, that's great, thanks for running the numbers! Will definitely
>>> >> >> > reference them in v4!
>>> >> >> > Presumably, we should be able to at least unroll most of the
>>> >> >> > _supported callbacks if we want, they should be relatively easy; but
>>> >> >> > the numbers look fine as is?
>>> >> >>
>>> >> >> Well, this is for one (and a half) piece of metadata. If we extrapolate
>>> >> >> it adds up quickly. Say we add csum and vlan tags, say, and maybe
>>> >> >> another callback to get the type of hash (l3/l4). Those would probably
>>> >> >> be relevant for most packets in a fairly common setup. Extrapolating
>>> >> >> from the ~1 ns/call figure, that's 8 ns/pkt, which is 20% of the
>>> >> >> baseline of 39 ns.
>>> >> >>
>>> >> >> So in that sense I still think unrolling makes sense. At least for the
>>> >> >> _supported() calls, as eating a whole function call just for that is
>>> >> >> probably a bit much (which I think was also Jakub's point in a sibling
>>> >> >> thread somewhere).
>>> >> >
>>> >> > imo the overhead is tiny enough that we can wait until
>>> >> > generic 'kfunc inlining' infra is ready.
>>> >> >
>>> >> > We're planning to dual-compile some_kernel_file.c
>>> >> > into native arch and into bpf arch.
>>> >> > Then the verifier will automatically inline bpf asm
>>> >> > of corresponding kfunc.
>>> >>
>>> >> Is that "planning" or "actively working on"? Just trying to get a sense
>>> >> of the time frames here, as this sounds neat, but also something that
>>> >> could potentially require quite a bit of fiddling with the build system
>>> >> to get to work? :)
>>> >
>>> > "planning", but regardless how long it takes I'd rather not
>>> > add any more tech debt in the form of manual bpf asm generation.
>>> > We have too much of it already: gen_lookup, convert_ctx_access, etc.
>>>
>>> Right, I'm no fan of the manual ASM stuff either. However, if we're
>>> stuck with the function call overhead for the foreseeable future, maybe
>>> we should think about other ways of cutting down the number of function
>>> calls needed?
>>>
>>> One thing I can think of is to get rid of the individual _supported()
>>> kfuncs and instead have a single one that lets you query multiple
>>> features at once, like:
>>>
>>> __u64 features_supported, features_wanted = XDP_META_RX_HASH | 
>>> XDP_META_TIMESTAMP;
>>>
>>> features_supported = bpf_xdp_metadata_query_features(ctx, 
>>> features_wanted);
>>>
>>> if (features_supported & XDP_META_RX_HASH)
>>>   hash = bpf_xdp_metadata_rx_hash(ctx);
>>>
>>> ...etc
>>
>> I'm not too happy about having the bitmasks tbh :-(
>> If we want to get rid of the cost of those _supported calls, maybe we
>> can do some kind of libbpf-like probing? That would require loading a
>> program + waiting for some packet though :-(
>>
>> Or maybe they can just be cached for now?
>>
>> if (unlikely(!got_first_packet)) {
>>  have_hash = bpf_xdp_metadata_rx_hash_supported();
>>  have_timestamp = bpf_xdp_metadata_rx_timestamp_supported();
>>  got_first_packet = true;
>> }
> 
> hash/timestap/csum is per packet .. vlan as well depending how you look at
> it..

True, we cannot cache this as it is *per packet* info.

> Sorry I haven't been following the progress of xdp meta data, but why did
> we drop the idea of btf and driver copying metdata in front of the xdp
> frame ?
> 

It took me some time to understand this new approach, and why it makes
sense.  This is my understanding of the design direction change:

This approach gives more control to the XDP BPF-prog to pick and choose
which XDP hints are relevant for the specific use-case.  BPF-prog can
also skip storing hints anywhere and just read+react on value (that e.g.
comes from RX-desc).

For the use-cases redirect, AF_XDP, chained BPF-progs, XDP-to-TC,
SKB-creation, we *do* need to store hints somewhere, as RX-desc will be
out-of-scope.  I this patchset hand-waves and says BPF-prog can just
manually store this in a prog custom layout in metadata area.  I'm not
super happy with ignoring/hand-waving all these use-case, but I
hope/think we later can extend this some more structure to support these
use-cases better (with this patchset as a foundation).

I actually like this kfunc design, because the BPF-prog's get an
intuitive API, and on driver side we can hide the details of howto
extract the HW hints.


> hopefully future HW generations will do that for free ..

True.  I think it is worth repeating, that the approach of storing HW
hints in metadata area (in-front of packet data) was to allow future HW
generations to write this.  Thus, eliminating the 6 ns (that I showed it
cost), and then it would be up-to XDP BPF-prog to pick and choose which
to read, like this patchset already offers.

This patchset isn't incompatible with future HW generations doing this,
as the kfunc would hide the details and point to this area instead of
the RX-desc.  While we get the "store for free" from hardware, I do
worry that reading this memory area (which will part of DMA area) is
going to be slower than reading from RX-desc.

> if btf is the problem then each vendor can provide a bpf func(s) that would
> parse the metdata inside of the xdp/bpf prog domain to help programs
> extract the vendor specific data..
> 

In some sense, if unroll will becomes a thing, then this patchset is
partly doing this.

I did imagine that after/followup on XDP-hints with BTF patchset, we
would allow drivers to load an BPF-prog that changed/selected which HW
hints were relevant, to reduce those 6 ns overhead we introduced.

--Jesper

