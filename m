Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 648E5574B12
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 12:47:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238480AbiGNKrG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 06:47:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238459AbiGNKrB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 06:47:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id ECC0253D16
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 03:46:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657795619;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QDEpv/nd3ThZpP+3Vj5BLpAOoRGWUT5570LW5fkHEXA=;
        b=iWVIErTUX3cSl7K+KLeBLet1llpsnv+C23v9fw2t98uRGxS7yn/Xrt1gfaINxkvW3+Di48
        MqQBP4oU2KdXTByEa6oj88RUybcXRrOJF0jdDG/fTezyvunOLdYMrdTu/tt3M8TnAT6Sbx
        6grj6mNjEHBCCjqmyk8s4CQn4v0HCFQ=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-460-av1nJ-3CNsi78gZmFN1daw-1; Thu, 14 Jul 2022 06:46:58 -0400
X-MC-Unique: av1nJ-3CNsi78gZmFN1daw-1
Received: by mail-ej1-f72.google.com with SMTP id qb28-20020a1709077e9c00b0072af6ccc1aeso611751ejc.6
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 03:46:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=QDEpv/nd3ThZpP+3Vj5BLpAOoRGWUT5570LW5fkHEXA=;
        b=zDidagGlA6HlvskYmI6aZLjEpDWexFXNyG/aK0P8k6gZtCp+KHA6JwnrA1BnV6ybXp
         8+kKxO3Z02pLkbOqGCg0gobyUNWjVDoC61kY5bmo4d+/rXzG6upG+I2bzo+Dwah5KzeN
         iSwnjdnqRWsuy40R+GBxVCQYYR3L3mRDPKlIAi1sBiadiZEXhGwedKoNLpIqldpmreUS
         kDGF/tskT8ayFO/bGO9CF+7JLxKROktVsbyIVtSYLvptZ2Q8pNx4f9LkkA0wFpO9UH9S
         dvMbjrVhByhMkH81Pne0/4rAiXzTiIXrUnxoi3m6S+sNjPc6tCleNu85LVB4HeXRpkgy
         ouJA==
X-Gm-Message-State: AJIora9FgHeacYsZVikAhjNx+yOey+gt1McGlOK8z6xUF8yqBns6+xk0
        xNk1VFOmFkC5Y5MM9XZkXqjI+EeLGGL+y9dvtgKzy3L+pVkXVyuxmZaGmieofiq3/d8/dJqcqrd
        1/YTAcfTdX1/PbscS
X-Received: by 2002:a17:907:7388:b0:72b:9be1:e32d with SMTP id er8-20020a170907738800b0072b9be1e32dmr7653018ejc.611.1657795616641;
        Thu, 14 Jul 2022 03:46:56 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1u9OOcNIIJScRiVqXDGnhKuBd2gDS7vr7IcFGG82F4ntixmfV/Hg7CrJmh+ZCaByCBIIwjrEg==
X-Received: by 2002:a17:907:7388:b0:72b:9be1:e32d with SMTP id er8-20020a170907738800b0072b9be1e32dmr7652979ejc.611.1657795616209;
        Thu, 14 Jul 2022 03:46:56 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id sz20-20020a1709078b1400b0072b31307a79sm550672ejc.60.2022.07.14.03.46.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jul 2022 03:46:55 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id AF6334D9B28; Thu, 14 Jul 2022 12:46:54 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>,
        Jiri Olsa <jolsa@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Mykola Lysenko <mykolal@fb.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Freysteinn Alfredsson <freysteinn.alfredsson@kau.se>,
        Cong Wang <xiyou.wangcong@gmail.com>
Subject: Re: [RFC PATCH 00/17] xdp: Add packet queueing and scheduling
 capabilities
In-Reply-To: <CAKH8qBvODehxeGrqyY6+9TJPePe_KLb6vX9P1rKDgbQhuLpSSQ@mail.gmail.com>
References: <20220713111430.134810-1-toke@redhat.com>
 <CAKH8qBtdnku7StcQ-SamadvAF==DRuLLZO94yOR1WJ9Bg=uX1w@mail.gmail.com>
 <877d4gpto8.fsf@toke.dk>
 <CAKH8qBvODehxeGrqyY6+9TJPePe_KLb6vX9P1rKDgbQhuLpSSQ@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 14 Jul 2022 12:46:54 +0200
Message-ID: <87v8s0nf8h.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Stanislav Fomichev <sdf@google.com> writes:

> On Wed, Jul 13, 2022 at 2:52 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@re=
dhat.com> wrote:
>>
>> Stanislav Fomichev <sdf@google.com> writes:
>>
>> > On Wed, Jul 13, 2022 at 4:14 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke=
@redhat.com> wrote:
>> >>
>> >> Packet forwarding is an important use case for XDP, which offers
>> >> significant performance improvements compared to forwarding using the
>> >> regular networking stack. However, XDP currently offers no mechanism =
to
>> >> delay, queue or schedule packets, which limits the practical uses for
>> >> XDP-based forwarding to those where the capacity of input and output =
links
>> >> always match each other (i.e., no rate transitions or many-to-one
>> >> forwarding). It also prevents an XDP-based router from doing any kind=
 of
>> >> traffic shaping or reordering to enforce policy.
>> >>
>> >> This series represents a first RFC of our attempt to remedy this lack=
. The
>> >> code in these patches is functional, but needs additional testing and
>> >> polishing before being considered for merging. I'm posting it here as=
 an
>> >> RFC to get some early feedback on the API and overall design of the
>> >> feature.
>> >>
>> >> DESIGN
>> >>
>> >> The design consists of three components: A new map type for storing X=
DP
>> >> frames, a new 'dequeue' program type that will run in the TX softirq =
to
>> >> provide the stack with packets to transmit, and a set of helpers to d=
equeue
>> >> packets from the map, optionally drop them, and to schedule an interf=
ace
>> >> for transmission.
>> >>
>> >> The new map type is modelled on the PIFO data structure proposed in t=
he
>> >> literature[0][1]. It represents a priority queue where packets can be
>> >> enqueued in any priority, but is always dequeued from the head. From =
the
>> >> XDP side, the map is simply used as a target for the bpf_redirect_map=
()
>> >> helper, where the target index is the desired priority.
>> >
>> > I have the same question I asked on the series from Cong:
>> > Any considerations for existing carousel/edt-like models?
>>
>> Well, the reason for the addition in patch 5 (continuously increasing
>> priorities) is exactly to be able to implement EDT-like behaviour, where
>> the priority is used as time units to clock out packets.
>
> Ah, ok, I didn't read the patches closely enough. I saw some limits
> for the ranges and assumed that it wasn't capable of efficiently
> storing 64-bit timestamps..

The goal is definitely to support full 64-bit priorities. Right now you
have to start out at 0 but can go on for a full 64 bits, but that's a
bit of an API wart that I'd like to get rid of eventually...

>> > Can we make the map flexible enough to implement different qdisc
>> > policies?
>>
>> That's one of the things we want to be absolutely sure about. We are
>> starting out with the PIFO map type because the literature makes a good
>> case that it is flexible enough to implement all conceivable policies.
>> The goal of the test harness linked as note [4] is to actually examine
>> this; Frey is our PhD student working on this bit.
>>
>> Thus far we haven't hit any limitations on this, but we'll need to add
>> more policies before we are done with this. Another consideration is
>> performance, of course, so we're also planning to do a comparison with a
>> more traditional "bunch of FIFO queues" type data structure for at least
>> a subset of the algorithms. Kartikeya also had an idea for an
>> alternative way to implement a priority queue using (semi-)lockless
>> skiplists, which may turn out to perform better.
>>
>> If there's any particular policy/algorithm you'd like to see included in
>> this evaluation, please do let us know, BTW! :)
>
> I honestly am not sure what the bar for accepting this should be. But
> on the Cong's series I mentioned Martin's CC bpf work as a great
> example of what we should be trying to do for qdisc-like maps. Having
> a bpf version of fq/fq_codel/whatever_other_complex_qdisc might be
> very convincing :-)

Just doing flow queueing is quite straight forward with PIFOs. We're
working on fq_codel. Personally I also want to implement something that
has feature parity with sch_cake (which includes every feature and the
kitchen sink already) :)

>> >> The dequeue program type is a new BPF program type that is attached t=
o an
>> >> interface; when an interface is scheduled for transmission, the stack=
 will
>> >> execute the attached dequeue program and, if it returns a packet to
>> >> transmit, that packet will be transmitted using the existing ndo_xdp_=
xmit()
>> >> driver function.
>> >>
>> >> The dequeue program can obtain packets by pulling them out of a PIFO =
map
>> >> using the new bpf_packet_dequeue() helper. This returns a pointer to =
an
>> >> xdp_md structure, which can be dereferenced to obtain packet data and
>> >> data_meta pointers like in an XDP program. The returned packets are a=
lso
>> >> reference counted, meaning the verifier enforces that the dequeue pro=
gram
>> >> either drops the packet (with the bpf_packet_drop() helper), or retur=
ns it
>> >> for transmission. Finally, a helper is added that can be used to actu=
ally
>> >> schedule an interface for transmission using the dequeue program type=
; this
>> >> helper can be called from both XDP and dequeue programs.
>> >>
>> >> PERFORMANCE
>> >>
>> >> Preliminary performance tests indicate about 50ns overhead of adding
>> >> queueing to the xdp_fwd example (last patch), which translates to a 2=
0% PPS
>> >> overhead (but still 2x the forwarding performance of the netstack):
>> >>
>> >> xdp_fwd :     4.7 Mpps  (213 ns /pkt)
>> >> xdp_fwd -Q:   3.8 Mpps  (263 ns /pkt)
>> >> netstack:       2 Mpps  (500 ns /pkt)
>> >>
>> >> RELATION TO BPF QDISC
>> >>
>> >> Cong Wang's BPF qdisc patches[2] share some aspects of this series, in
>> >> particular the use of a map to store packets. This is no accident, as=
 we've
>> >> had ongoing discussions for a while now. I have no great hope that we=
 can
>> >> completely converge the two efforts into a single BPF-based queueing
>> >> API (as has been discussed before[3], consolidating the SKB and XDP p=
aths
>> >> is challenging). Rather, I'm hoping that we can converge the designs =
enough
>> >> that we can share BPF code between XDP and qdisc layers using common
>> >> functions, like it's possible to do with XDP and TC-BPF today. This w=
ould
>> >> imply agreeing on the map type and API, and possibly on the set of he=
lpers
>> >> available to the BPF programs.
>> >
>> > What would be the big difference for the map wrt xdp_frame vs sk_buff
>> > excluding all obvious stuff like locking/refcnt?
>>
>> I expect it would be quite straight-forward to just add a second subtype
>> of the PIFO map in this series that holds skbs. In fact, I think that
>> from the BPF side, the whole model implemented here would be possible to
>> carry over to the qdisc layer more or less wholesale. Some other
>> features of the qdisc layer, like locking, classes, and
>> multi-CPU/multi-queue management may be trickier, but I'm not sure how
>> much of that we should expose in a BPF qdisc anyway (as you may have
>> noticed I commented on Cong's series to this effect regarding the
>> classful qdiscs).
>
> Maybe a related question here: with the way you do
> BPF_MAP_TYPE_PIFO_GENERIC vs BPF_MAP_TYPE_PIFO_XDP, how hard it would
> be have support for storing xdp_frames/skb in any map? Let's say we
> have generic BPF_MAP_TYPE_RBTREE, where the key is
> priority/timestamp/whatever, can we, based on the value's btf_id,
> figure out the rest? (that the value is kernel structure and needs
> special care and more constraints - can't be looked up from user space
> and so on)
>
> Seems like we really need to have two special cases: where we transfer
> ownership of xdp_frame/skb to/from the map, any other big
> complications?
>
> That way we can maybe untangle the series a bit: we can talk about
> efficient data structures for storing frames/skbs independently of
> some generic support for storing them in the maps. Any major
> complications with that approach?

I've had discussions with Kartikeya on this already (based on his 'kptr
in map' work). That may well end up being feasible, which would be
fantastic. The reason we didn't use it for this series is that there's
still some work to do on the generic verifier/infrastructure support
side of this (the PIFO map is the oldest part of this series), and I
didn't want to hold up the rest of the queueing work until that landed.

Now that we have a functional prototype I expect that iterating on the
data structure will be the next step. One complication with XDP is that
we probably want to keep using XDP_REDIRECT to place packets into the
map because that gets us bulking which is important for performance;
however, in general I like the idea of using BTF to designate the map
value type, and if we can figure out a way to make it completely generic
even for packets I'm all for that! :)

>> >> PATCH STRUCTURE
>> >>
>> >> This series consists of a total of 17 patches, as follows:
>> >>
>> >> Patches 1-3 are smaller preparatory refactoring patches used by subse=
quent
>> >> patches.
>> >
>> > Seems like these can go separately without holding the rest?
>>
>> Yeah, guess so? They don't really provide much benefit without the users
>> alter in the series, though, so not sure there's much point in sending
>> them separately?
>>
>> >> Patches 4-5 introduce the PIFO map type, and patch 6 introduces the d=
equeue
>> >> program type.
>> >
>> > [...]
>> >
>> >> Patches 7-10 adds the dequeue helpers and the verifier features neede=
d to
>> >> recognise packet pointers, reference count them, and allow dereferenc=
ing
>> >> them to obtain packet data pointers.
>> >
>> > Have you considered using kfuncs for these instead of introducing new
>> > hooks/contexts/etc?
>>
>> I did, but I'm not sure it's such a good fit? In particular, the way the
>> direct packet access is implemented for dequeue programs (where you can
>> get an xdp_md pointer and deref that to get data and data_end pointers)
>> is done this way so programs can share utility functions between XDP and
>> dequeue programs. And having a new program type for the dequeue progs
>> seem like the obvious thing to do since they're doing something new?
>>
>> Maybe I'm missing something, though; could you elaborate on how you'd
>> use kfuncs instead?
>
> I was thinking about the approach in general. In networking bpf, we've
> been adding new program types, new contexts and new explicit hooks.
> This all requires a ton of boiler plate (converting from uapi ctx to
> the kernel, exposing hook points, etc, etc). And looking at Benjamin's
> HID series, it's so much more elegant: there is no uapi, just kernel
> function that allows it to be overridden and a bunch of kfuncs
> exposed. No uapi, no helpers, no fake contexts.
>
> For networking and xdp the ship might have sailed, but I was wondering
> whether we should be still stuck in that 'old' boilerplate world or we
> have a chance to use new nice shiny things :-)
>
> (but it might be all moot if we'd like to have stable upis?)

Right, I see what you mean. My immediate feeling is that having an
explicit stable UAPI for XDP has served us well. We do all kinds of
rewrite tricks behind the scenes (things like switching between xdp_buff
and xdp_frame, bulking, direct packet access, reading ifindexes by
pointer walking txq->dev, etc) which are important ways to improve
performance without exposing too many nitty-gritty details into the API.

There's also consistency to consider: I think the addition of queueing
should work as a natural extension of the existing programming model for
XDP. So I feel like this is more a case of "if we were starting from
scratch today we might do things differently (like the HID series), but
when extending things let's keep it consistent"?

-Toke

