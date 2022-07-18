Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 714AD578244
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 14:25:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233818AbiGRMZ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 08:25:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233098AbiGRMZz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 08:25:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BB1F1222
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 05:25:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658147152;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2HOs3OkKUNp4PyOmXFLlGEqanFGczy+pen+KXEzEqlY=;
        b=F5EUNspt9fhzOVSLoHvHt41eNxVjQoFeZuXoWIkTHMQOTwKcWOnEHH8FukHCl0U1XEuvmw
        DM3DtFCdiZrCCwPjw+EBoZwhJtHR16HOL1VI/s+gL02N0O46kh2r5Ynt9831qT8DpkaZ1N
        qQcKquOYy2YF1C3nSFHDF/1YxMgHIW4=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-171-QIk4izzwNYqCEr28rjKOiA-1; Mon, 18 Jul 2022 08:25:52 -0400
X-MC-Unique: QIk4izzwNYqCEr28rjKOiA-1
Received: by mail-ed1-f69.google.com with SMTP id m10-20020a056402510a00b0043a93d807ffso7806328edd.12
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 05:25:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=2HOs3OkKUNp4PyOmXFLlGEqanFGczy+pen+KXEzEqlY=;
        b=NKXsVYmjaMswI3XA7ua8l53PbLBIIOFsvdidtX/VKuRFeUJHUkPVWcMkqsyYSshUcM
         mdQpoe/9R8yKTsddt2RpwCdzhtP6RtGeBRWmmxSDRSJxUPwy0DlAA/lnIKa7OJAwG13R
         KJ0oOPTwRTG27llEA6EA5juO5pY2JRy3Ut7A1fdul3w7IAkrRU/rlwiZSxn8O1sdpmt2
         FAHlKba/AGjjHdpUExPK/toB3tLV13C5YiW4/UwMULLKcb9umebif1FHGisxFrCbsLuj
         lZBzLAueD7vWLVmuLefOXvx32DRISGkUmioR3QGSLqoBP+w9XREUr/FjDdwX191QEpss
         PwNw==
X-Gm-Message-State: AJIora+LNHp23HbtVxzFosxZqbs+biDvXdqFwnE6d7/LXaLMocJyFxdK
        xy4F8uXwagrKwwXf95m9Fsr9CmGix9RuKvf+hUwe1gKdmNcOCmOfGxrfEqvU0++h7ifawHJo/uj
        TQ83W/kjn89icVqeb
X-Received: by 2002:a05:6402:1d97:b0:43a:7b45:8e14 with SMTP id dk23-20020a0564021d9700b0043a7b458e14mr36442063edb.418.1658147150054;
        Mon, 18 Jul 2022 05:25:50 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1sYSHx8zgfl89P4W22SZOlAxTGAprQt28Li1UxfygWlEYBHu05DMCyVzqoKVvAjzTPhSp1Skw==
X-Received: by 2002:a05:6402:1d97:b0:43a:7b45:8e14 with SMTP id dk23-20020a0564021d9700b0043a7b458e14mr36442000edb.418.1658147149241;
        Mon, 18 Jul 2022 05:25:49 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id h9-20020aa7c609000000b0043ab1ad0b6bsm8479305edq.37.2022.07.18.05.25.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 05:25:47 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id B561A4D9EEF; Mon, 18 Jul 2022 14:25:46 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Stanislav Fomichev <sdf@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
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
        Freysteinn Alfredsson <freysteinn.alfredsson@kau.se>
Subject: Re: [RFC PATCH 00/17] xdp: Add packet queueing and scheduling
 capabilities
In-Reply-To: <YtRfG5YNtNHZXOUc@pop-os.localdomain>
References: <20220713111430.134810-1-toke@redhat.com>
 <CAKH8qBtdnku7StcQ-SamadvAF==DRuLLZO94yOR1WJ9Bg=uX1w@mail.gmail.com>
 <877d4gpto8.fsf@toke.dk>
 <CAKH8qBvODehxeGrqyY6+9TJPePe_KLb6vX9P1rKDgbQhuLpSSQ@mail.gmail.com>
 <87v8s0nf8h.fsf@toke.dk> <YtRfG5YNtNHZXOUc@pop-os.localdomain>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 18 Jul 2022 14:25:46 +0200
Message-ID: <87v8ruli9h.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cong Wang <xiyou.wangcong@gmail.com> writes:

> On Thu, Jul 14, 2022 at 12:46:54PM +0200, Toke H=C3=B8iland-J=C3=B8rgense=
n wrote:
>> Stanislav Fomichev <sdf@google.com> writes:
>>=20
>> > On Wed, Jul 13, 2022 at 2:52 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke=
@redhat.com> wrote:
>> >>
>> >> Stanislav Fomichev <sdf@google.com> writes:
>> >>
>> >> > On Wed, Jul 13, 2022 at 4:14 AM Toke H=C3=B8iland-J=C3=B8rgensen <t=
oke@redhat.com> wrote:
>> >> >>
>> >> >> Packet forwarding is an important use case for XDP, which offers
>> >> >> significant performance improvements compared to forwarding using =
the
>> >> >> regular networking stack. However, XDP currently offers no mechani=
sm to
>> >> >> delay, queue or schedule packets, which limits the practical uses =
for
>> >> >> XDP-based forwarding to those where the capacity of input and outp=
ut links
>> >> >> always match each other (i.e., no rate transitions or many-to-one
>> >> >> forwarding). It also prevents an XDP-based router from doing any k=
ind of
>> >> >> traffic shaping or reordering to enforce policy.
>> >> >>
>> >> >> This series represents a first RFC of our attempt to remedy this l=
ack. The
>> >> >> code in these patches is functional, but needs additional testing =
and
>> >> >> polishing before being considered for merging. I'm posting it here=
 as an
>> >> >> RFC to get some early feedback on the API and overall design of the
>> >> >> feature.
>> >> >>
>> >> >> DESIGN
>> >> >>
>> >> >> The design consists of three components: A new map type for storin=
g XDP
>> >> >> frames, a new 'dequeue' program type that will run in the TX softi=
rq to
>> >> >> provide the stack with packets to transmit, and a set of helpers t=
o dequeue
>> >> >> packets from the map, optionally drop them, and to schedule an int=
erface
>> >> >> for transmission.
>> >> >>
>> >> >> The new map type is modelled on the PIFO data structure proposed i=
n the
>> >> >> literature[0][1]. It represents a priority queue where packets can=
 be
>> >> >> enqueued in any priority, but is always dequeued from the head. Fr=
om the
>> >> >> XDP side, the map is simply used as a target for the bpf_redirect_=
map()
>> >> >> helper, where the target index is the desired priority.
>> >> >
>> >> > I have the same question I asked on the series from Cong:
>> >> > Any considerations for existing carousel/edt-like models?
>> >>
>> >> Well, the reason for the addition in patch 5 (continuously increasing
>> >> priorities) is exactly to be able to implement EDT-like behaviour, wh=
ere
>> >> the priority is used as time units to clock out packets.
>> >
>> > Ah, ok, I didn't read the patches closely enough. I saw some limits
>> > for the ranges and assumed that it wasn't capable of efficiently
>> > storing 64-bit timestamps..
>>=20
>> The goal is definitely to support full 64-bit priorities. Right now you
>> have to start out at 0 but can go on for a full 64 bits, but that's a
>> bit of an API wart that I'd like to get rid of eventually...
>>=20
>> >> > Can we make the map flexible enough to implement different qdisc
>> >> > policies?
>> >>
>> >> That's one of the things we want to be absolutely sure about. We are
>> >> starting out with the PIFO map type because the literature makes a go=
od
>> >> case that it is flexible enough to implement all conceivable policies.
>> >> The goal of the test harness linked as note [4] is to actually examine
>> >> this; Frey is our PhD student working on this bit.
>> >>
>> >> Thus far we haven't hit any limitations on this, but we'll need to add
>> >> more policies before we are done with this. Another consideration is
>> >> performance, of course, so we're also planning to do a comparison wit=
h a
>> >> more traditional "bunch of FIFO queues" type data structure for at le=
ast
>> >> a subset of the algorithms. Kartikeya also had an idea for an
>> >> alternative way to implement a priority queue using (semi-)lockless
>> >> skiplists, which may turn out to perform better.
>> >>
>> >> If there's any particular policy/algorithm you'd like to see included=
 in
>> >> this evaluation, please do let us know, BTW! :)
>> >
>> > I honestly am not sure what the bar for accepting this should be. But
>> > on the Cong's series I mentioned Martin's CC bpf work as a great
>> > example of what we should be trying to do for qdisc-like maps. Having
>> > a bpf version of fq/fq_codel/whatever_other_complex_qdisc might be
>> > very convincing :-)
>>=20
>> Just doing flow queueing is quite straight forward with PIFOs. We're
>> working on fq_codel. Personally I also want to implement something that
>> has feature parity with sch_cake (which includes every feature and the
>> kitchen sink already) :)
>
> And how exactly would you plan to implement Least Slack Time First with
> PIFOs?  See https://www.usenix.org/system/files/nsdi20-paper-sharma.pdf.
> Can you be as specific as possible ideally with a pesudo code?

By sticking flows into the PIFO instead of individual packets.
Basically:

enqueue:

flow_id =3D hash_pkt(pkt);
flow_pifo =3D &flows[flow_id];
pifo_enqueue(flow_pifo, pkt, 0); // always enqueue at rank 0, so effectivel=
y a FIFO
pifo_enqueue(toplevel_pifo, flow_id, compute_rank(flow_id));

dequeue:

flow_id =3D pifo_dequeue(toplevel_pifo);
flow_pifo =3D &flows[flow_id];
pkt =3D pifo_dequeue(flow_pifo);
pifo_enqueue(toplevel_pifo, flow_id, compute_rank(flow_id)); // re-enqueue
return pkt;


We have not gotten around to doing a full implementation of this yet,
but SRPT/LSTF is on our list of algorithms to add :)

> BTW, this is very easy to do with my approach as no FO limitations.

How does being able to dequeue out-of-order actually help with this
particular scheme? On dequeue you still process things in priority
order?

-Toke

