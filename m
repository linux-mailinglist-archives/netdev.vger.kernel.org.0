Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB85A681B50
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 21:22:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229680AbjA3UWe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 15:22:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbjA3UWZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 15:22:25 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69E52470AD
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 12:21:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675110098;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XoMvMwGH3M001qHmVrhga8kOY/IHdEZ731jtPOb2RBk=;
        b=D77fWZoJt308Hrp0VxfmDqyJVYG3O+gb/wyjFlhtoNibRsaMP7+DnFipA1MRE//YGv9XfK
        XFEoE2Vk+eWfvA9SJQS/XWpQqd0QtuKkQA76GCuwMzOReLxKXlCO00gOu4N25dqQJHSR5s
        R1yfYxT3f3MZ+4Gpc/ym2cUb3AJCqJY=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-418-O_IEiVF1OOGt0ipaTkKNnA-1; Mon, 30 Jan 2023 15:21:36 -0500
X-MC-Unique: O_IEiVF1OOGt0ipaTkKNnA-1
Received: by mail-ej1-f71.google.com with SMTP id kt9-20020a1709079d0900b00877f4df5aceso8157898ejc.21
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 12:21:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XoMvMwGH3M001qHmVrhga8kOY/IHdEZ731jtPOb2RBk=;
        b=5dJU5lCO0BsDIYzLuea8ujTjKh9G3zqhFYSuSEIkOSXHoIEudo5D1IFuWSQsC82V7k
         jDr9ee5sTIn3ViSed9NUcNF3zARihcVOnLMfUI2Ql++O7zyGkSrLTFmoUnqkRtCoVe9y
         15uRFPyJW9+hA7gCuHD2MNS3tnZ8I7Nm6ATHLt4Tt25ruy8F6wKHKPRvcqxoBXJs/V1u
         pm9tUbqUG/TUSJiM9CbX6I5uBGukjdOZ1nByNEv20Of9IVDYOLGjlXzFw5rzx/NlfOgb
         veCw/HuXVdOJur+f3tf0q13r46Y9JI+q+6iVlU4c/7R+H3hfnCCPYV7wG/2zoRtFGZlQ
         s+Mw==
X-Gm-Message-State: AO0yUKXhtQJRONXIhZn7gbPZCs6/IrIRxN4Mxt5F03ggj/NAa7JEGXB7
        OuWJ71nrtbfsgA/AxqH7ZOMaChX+88eXRUfRYQULkxLXvrTtsu0e5UiTeyQP6jb54QXxU3mINzN
        J1qTATUNDhCBf0V3g
X-Received: by 2002:a17:906:384f:b0:885:9ce9:dc79 with SMTP id w15-20020a170906384f00b008859ce9dc79mr7732330ejc.77.1675110094995;
        Mon, 30 Jan 2023 12:21:34 -0800 (PST)
X-Google-Smtp-Source: AK7set8EbLPWUwR9qsaIETrRaO3yDvyl1PH/WAueLZJUb+5f2RasEArWqCbmd22hY4tIeqvY75QYnQ==
X-Received: by 2002:a17:906:384f:b0:885:9ce9:dc79 with SMTP id w15-20020a170906384f00b008859ce9dc79mr7732281ejc.77.1675110094280;
        Mon, 30 Jan 2023 12:21:34 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id f17-20020a1709064dd100b0087853fbb55dsm7223945ejw.40.2023.01.30.12.21.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jan 2023 12:21:33 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 6EFBF972717; Mon, 30 Jan 2023 21:21:32 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Jamal Hadi Salim <hadi@mojatatu.com>
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
In-Reply-To: <CAAFAkD9Sh5jbp4qkzxuS+J3PGdtN-Kc2HdP8CDqweY36extSdA@mail.gmail.com>
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
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 30 Jan 2023 21:21:32 +0100
Message-ID: <87wn53wz77.fsf@toke.dk>
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

Jamal Hadi Salim <hadi@mojatatu.com> writes:

> On Mon, Jan 30, 2023 at 12:04 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@r=
edhat.com> wrote:
>>
>> Jamal Hadi Salim <jhs@mojatatu.com> writes:
>>
>> > So i dont have to respond to each email individually, I will respond
>> > here in no particular order. First let me provide some context, if
>> > that was already clear please skip it. Hopefully providing the context
>> > will help us to focus otherwise that bikeshed's color and shape will
>> > take forever to settle on.
>> >
>> > __Context__
>> >
>> > I hope we all agree that when you have 2x100G NIC (and i have seen
>> > people asking for 2x800G NICs) no XDP or DPDK is going to save you. To
>> > visualize: one 25G port is 35Mpps unidirectional. So "software stack"
>> > is not the answer. You need to offload.
>>
>> I'm not disputing the need to offload, and I'm personally delighted that
>> P4 is breaking open the vendor black boxes to provide a standardised
>> interface for this.
>>
>> However, while it's true that software can't keep up at the high end,
>> not everything runs at the high end, and today's high end is tomorrow's
>> mid end, in which XDP can very much play a role. So being able to move
>> smoothly between the two, and even implement functions that split
>> processing between them, is an essential feature of a programmable
>> networking path in Linux. Which is why I'm objecting to implementing the
>> P4 bits as something that's hanging off the side of the stack in its own
>> thing and is not integrated with the rest of the stack. You were touting
>> this as a feature ("being self-contained"). I consider it a bug.
>>
>> > Scriptability is not a new idea in TC (see u32 and pedit and others in
>> > TC).
>>
>> u32 is notoriously hard to use. The others are neat, but obviously
>> limited to particular use cases.
>
> Despite my love for u32, I admit its user interface is cryptic. I just
> wanted to point out to existing samples of scriptable and offloadable
> TC objects.
>
>> Do you actually expect anyone to use P4
>> by manually entering TC commands to build a pipeline? I really find that
>> hard to believe...
>
> You dont have to manually hand code anything - its the compilers job.

Right, that was kinda my point: in that case the compiler could just as
well generate a (set of) BPF program(s) instead of this TC script thing.

>> > IOW, we are reusing and plugging into a proven and deployed mechanism
>> > with a built-in policy driven, transparent symbiosis between hardware
>> > offload and software that has matured over time. You can take a
>> > pipeline or a table or actions and split them between hardware and
>> > software transparently, etc.
>>
>> That's a control plane feature though, it's not an argument for adding
>> another interpreter to the kernel.
>
> I am not sure what you mean by control, but what i described is kernel
> built in. Of course i could do more complex things from user space (if
> that is what you mean as control).

"Control plane" as in SDN parlance. I.e., the bits that keep track of
configuration of the flow/pipeline/table configuration.

There's no reason you can't have all that infrastructure and use BPF as
the datapath language. I.e., instead of:

tc p4template create pipeline/aP4proggie numtables 1
... + all the other stuff to populate it

you could just do:

tc p4 create pipeline/aP4proggie obj_file aP4proggie.bpf.o

and still have all the management infrastructure without the new
interpreter and associated complexity in the kernel.

>> > This hammer already meets our goals.
>>
>> That 60k+ line patch submission of yours says otherwise...
>
> This is pretty much covered in the cover letter and a few responses in
> the thread since.

The only argument for why your current approach makes sense I've seen
you make is "I don't want to rewrite it in BPF". Which is not a
technical argument.

I'm not trying to be disingenuous here, BTW: I really don't see the
technical argument for why the P4 data plane has to be implemented as
its own interpreter instead of integrating with what we have already
(i.e., BPF).

-Toke

