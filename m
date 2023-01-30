Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C19C5681C94
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 22:21:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230238AbjA3VVu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 16:21:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbjA3VVt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 16:21:49 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FB26360A5
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 13:21:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675113663;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=H1OnNYIbcVCLPlGNbhB50RVUiQcwKinclitfP2ErKOE=;
        b=CpFMDXPEAvzzEep45FVNjn/ko9iNTLc0beb2aHD+EFamhXxB+dcNNrCnAey+eFeUr08ObB
        AxB5IodOKkS3eOa1ffGXnc3UYVsDfm1UzXReVzrUEgRTr0cxM09DxRBNgHD90C/uDk/sMY
        XIHHt+YrXKdLmE+t5oFRMI9qjhPUHNc=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-669-cT7ptBWpPh2ctP0jDJs_3Q-1; Mon, 30 Jan 2023 16:21:00 -0500
X-MC-Unique: cT7ptBWpPh2ctP0jDJs_3Q-1
Received: by mail-ej1-f70.google.com with SMTP id js21-20020a17090797d500b008858509ff2aso3325825ejc.4
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 13:21:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=H1OnNYIbcVCLPlGNbhB50RVUiQcwKinclitfP2ErKOE=;
        b=NuZgDYuIEFZ0qabIqq6C2JmK1kGOLAVx6SDJpdEnYPJB1PVQ8QekWs4wzVFZ4fMmiw
         MlvHJO9ahBy2X2UshfBSLgfjuNCUHvnRhVvl3XOM+HQFTA3PaCLgVw9leZtY/g65F10T
         OxxxQfMybC+CCcEPZ4we4tI1NjZ6c8telyBD+6dm8eE3QA+XRqsmOc8NrhJbHxLv30s0
         dV9m7uFYspya7l1GqWTYn9XwHTjNRigJxdhhZyvB1OhHVXUYrb7nm53ZupIp5gHjPPtb
         j/tXvAOOi3x/i3NiSHljOLqTAwiCynI4zkSDv3IY5MbXaOAQHPIygTuxsxrIZHPw+moO
         N3mQ==
X-Gm-Message-State: AO0yUKXl5+JCUjwOfzb5lqDExXplzpP0emP2LzvSYWfUR8mHFjsLhx8j
        d1O4zRuERR3ZU7DCDi67vJTgOBZ1PdSTOzryRVNvoJNN7MJTJaEJTCNtl5LXFn0ZKjOpHLC3++h
        wxj/S6kvgxdfae1BU
X-Received: by 2002:a05:6402:194d:b0:499:4130:fae with SMTP id f13-20020a056402194d00b0049941300faemr1066904edz.10.1675113659068;
        Mon, 30 Jan 2023 13:20:59 -0800 (PST)
X-Google-Smtp-Source: AK7set81Gp8EEXLZAv1IqpGEhSzsaU1BUMzPM48jMPsb8u3jty6Ut9qHOWhdMjjb0jRMGYK2FWkToQ==
X-Received: by 2002:a05:6402:194d:b0:499:4130:fae with SMTP id f13-20020a056402194d00b0049941300faemr1066868edz.10.1675113658758;
        Mon, 30 Jan 2023 13:20:58 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id a6-20020aa7cf06000000b004a23558f01fsm3339591edy.43.2023.01.30.13.20.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jan 2023 13:20:58 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 9607A972735; Mon, 30 Jan 2023 22:20:56 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     John Fastabend <john.fastabend@gmail.com>,
        Jamal Hadi Salim <hadi@mojatatu.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>,
        John Fastabend <john.fastabend@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        kernel@mojatatu.com, deb.chatterjee@intel.com,
        anjali.singhai@intel.com, namrata.limaye@intel.com,
        khalidm@nvidia.com, tom@sipanda.io, pratyush@sipanda.io,
        xiyou.wangcong@gmail.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, vladbu@nvidia.com, simon.horman@corigine.com,
        stefanc@marvell.com, seong.kim@amd.com, mattyk@nvidia.com,
        dan.daly@intel.com, john.andy.fingerhut@intel.com
Subject: Re: [PATCH net-next RFC 00/20] Introducing P4TC
In-Reply-To: <63d8325819298_3985f20824@john.notmuch>
References: <CAAFAkD8kahd0Ao6BVjwx+F+a0nUK0BzTNFocnpaeQrN7E8VRdQ@mail.gmail.com>
 <Y9RPsYbi2a9Q/H8h@google.com>
 <CAM0EoM=ONYkF_1CST7i_F9yDQRxSFSTO25UzWJzcRGa1efM2Sg@mail.gmail.com>
 <CAKH8qBtU-1A1iKnvTXV=5v8Dim1FBmtvL6wOqgdspSFRCwNohA@mail.gmail.com>
 <CA+FuTScHsm3Ajje=ziRBafXUQ5FHHEAv6R=LRWr1+c3QpCL_9w@mail.gmail.com>
 <CAM0EoMnBXnWDQKu5e0z1_zE3yabb2pTnOdLHRVKsChRm+7wxmQ@mail.gmail.com>
 <CA+FuTScBO-h6iM47-NbYSDDt6LX7pUXD82_KANDcjp7Y=99jzg@mail.gmail.com>
 <63d6069f31bab_2c3eb20844@john.notmuch>
 <CAM0EoMmeYc7KxY=Sv=oynrvYMeb-GD001Zh4m5TMMVXYre=tXw@mail.gmail.com>
 <63d747d91add9_3367c208f1@john.notmuch> <Y9eYNsklxkm8CkyP@nanopsycho>
 <87pmawxny5.fsf@toke.dk>
 <CAM0EoM=u-VSDZAifwTiOy8vXAGX7Hwg4rdea62-kNFGsHj7ObQ@mail.gmail.com>
 <878rhkx8bd.fsf@toke.dk>
 <CAAFAkD9Sh5jbp4qkzxuS+J3PGdtN-Kc2HdP8CDqweY36extSdA@mail.gmail.com>
 <87wn53wz77.fsf@toke.dk> <63d8325819298_3985f20824@john.notmuch>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 30 Jan 2023 22:20:56 +0100
Message-ID: <87leljwwg7.fsf@toke.dk>
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

John Fastabend <john.fastabend@gmail.com> writes:

> Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> Jamal Hadi Salim <hadi@mojatatu.com> writes:
>>=20
>> > On Mon, Jan 30, 2023 at 12:04 PM Toke H=C3=B8iland-J=C3=B8rgensen <tok=
e@redhat.com> wrote:
>> >>
>> >> Jamal Hadi Salim <jhs@mojatatu.com> writes:
>> >>
>> >> > So i dont have to respond to each email individually, I will respond
>> >> > here in no particular order. First let me provide some context, if
>> >> > that was already clear please skip it. Hopefully providing the cont=
ext
>> >> > will help us to focus otherwise that bikeshed's color and shape will
>> >> > take forever to settle on.
>> >> >
>> >> > __Context__
>> >> >
>> >> > I hope we all agree that when you have 2x100G NIC (and i have seen
>> >> > people asking for 2x800G NICs) no XDP or DPDK is going to save you.=
 To
>> >> > visualize: one 25G port is 35Mpps unidirectional. So "software stac=
k"
>> >> > is not the answer. You need to offload.
>> >>
>> >> I'm not disputing the need to offload, and I'm personally delighted t=
hat
>> >> P4 is breaking open the vendor black boxes to provide a standardised
>> >> interface for this.
>> >>
>> >> However, while it's true that software can't keep up at the high end,
>> >> not everything runs at the high end, and today's high end is tomorrow=
's
>> >> mid end, in which XDP can very much play a role. So being able to move
>> >> smoothly between the two, and even implement functions that split
>> >> processing between them, is an essential feature of a programmable
>> >> networking path in Linux. Which is why I'm objecting to implementing =
the
>> >> P4 bits as something that's hanging off the side of the stack in its =
own
>> >> thing and is not integrated with the rest of the stack. You were tout=
ing
>> >> this as a feature ("being self-contained"). I consider it a bug.
>> >>
>> >> > Scriptability is not a new idea in TC (see u32 and pedit and others=
 in
>> >> > TC).
>> >>
>> >> u32 is notoriously hard to use. The others are neat, but obviously
>> >> limited to particular use cases.
>> >
>> > Despite my love for u32, I admit its user interface is cryptic. I just
>> > wanted to point out to existing samples of scriptable and offloadable
>> > TC objects.
>> >
>> >> Do you actually expect anyone to use P4
>> >> by manually entering TC commands to build a pipeline? I really find t=
hat
>> >> hard to believe...
>> >
>> > You dont have to manually hand code anything - its the compilers job.
>>=20
>> Right, that was kinda my point: in that case the compiler could just as
>> well generate a (set of) BPF program(s) instead of this TC script thing.
>>=20
>> >> > IOW, we are reusing and plugging into a proven and deployed mechani=
sm
>> >> > with a built-in policy driven, transparent symbiosis between hardwa=
re
>> >> > offload and software that has matured over time. You can take a
>> >> > pipeline or a table or actions and split them between hardware and
>> >> > software transparently, etc.
>> >>
>> >> That's a control plane feature though, it's not an argument for adding
>> >> another interpreter to the kernel.
>> >
>> > I am not sure what you mean by control, but what i described is kernel
>> > built in. Of course i could do more complex things from user space (if
>> > that is what you mean as control).
>>=20
>> "Control plane" as in SDN parlance. I.e., the bits that keep track of
>> configuration of the flow/pipeline/table configuration.
>>=20
>> There's no reason you can't have all that infrastructure and use BPF as
>> the datapath language. I.e., instead of:
>>=20
>> tc p4template create pipeline/aP4proggie numtables 1
>> ... + all the other stuff to populate it
>>=20
>> you could just do:
>>=20
>> tc p4 create pipeline/aP4proggie obj_file aP4proggie.bpf.o
>>=20
>> and still have all the management infrastructure without the new
>> interpreter and associated complexity in the kernel.
>>=20
>> >> > This hammer already meets our goals.
>> >>
>> >> That 60k+ line patch submission of yours says otherwise...
>> >
>> > This is pretty much covered in the cover letter and a few responses in
>> > the thread since.
>>=20
>> The only argument for why your current approach makes sense I've seen
>> you make is "I don't want to rewrite it in BPF". Which is not a
>> technical argument.
>>=20
>> I'm not trying to be disingenuous here, BTW: I really don't see the
>> technical argument for why the P4 data plane has to be implemented as
>> its own interpreter instead of integrating with what we have already
>> (i.e., BPF).
>>=20
>> -Toke
>>=20
>
> I'll just take this here becaues I think its mostly related.
>
> Still not convinced the P4TC has any value for sw. From the
> slide you say vendors prefer you have this picture roughtly.
>
>
>    [ P4 compiler ] ------ [ P4TC backend ] ----> TC API
>         |
>         |
>    [ P4 Vendor backend ]
>         |
>         |
>         V
>    [ Devlink ]
>
>
> Now just replace P4TC backend with P4C and your only work is to
> replace devlink with the current hw specific bits and you have
> a sw and hw components. Then you get XDP-BPF pretty easily from
> P4XDP backend if you like. The compat piece is handled by compiler
> where it should be. My CPU is not a MAT so pretending it is seems
> not ideal to me, I don't have a TCAM on my cores.
>
> For runtime get those vendors to write their SDKs over Devlink
> and no need for this software thing. The runtime for P4c should
> already work over BPF. Giving this picture
>
>    [ P4 compiler ] ------ [ P4C backend ] ----> BPF
>         |
>         |
>    [ P4 Vendor backend ]
>         |
>         |
>         V
>    [ Devlink ]
>
> And much less work for us to maintain.

Yes, this was basically my point as well. Thank you for putting it into
ASCII diagrams! :)

There's still the control plane bit: some kernel component that
configures the pieces (pipelines?) created in the top-right and
bottom-left corners of your diagram(s), keeping track of which pipelines
are in HW/SW, maybe updating some match tables dynamically and
extracting statistics. I'm totally OK with having that bit be in the
kernel, but that can be added on top of your second diagram just as well
as on top of the first one...

-Toke

