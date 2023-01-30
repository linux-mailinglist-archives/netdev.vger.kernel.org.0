Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71830681736
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 18:05:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237354AbjA3RFf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 12:05:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234818AbjA3RFd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 12:05:33 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD6E4DBF6
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 09:04:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675098283;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4FZEGn1LQxNIbZvsUu9GzXy5VnO2JkqiWUJWL2BkONI=;
        b=fqjf3q8NFnXURYOVEMArfJhDDsmTeV+aixHrXCt3XdB45M7LJ5gIEvmHDN4x99Nc51TWN2
        IUs24mpdDk5n0kvgkujxjLt1oEEfjYnxQ/M0s4GN0PXKnQOeSVT+spKGUBVvBynLJdBgb8
        hxTwVfb8buZ/+maJzdu4rgY2XAfYzGk=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-471-n78yWEgBPreRa5JNhZSZiw-1; Mon, 30 Jan 2023 12:04:42 -0500
X-MC-Unique: n78yWEgBPreRa5JNhZSZiw-1
Received: by mail-ej1-f71.google.com with SMTP id hp2-20020a1709073e0200b0084d47e3fe82so7729264ejc.8
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 09:04:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4FZEGn1LQxNIbZvsUu9GzXy5VnO2JkqiWUJWL2BkONI=;
        b=1S2M/qs1P5pwEIjVtF630/Yk//1A4c6O29qwFjwiI70of/6FeOMVgcNPzvjpWbiHfg
         X1BO+SEAtcly7ft7zma7CFPjABDcpuTy98raylt/bqLmHs1QdgpOKM+h5yskb1nOp7FM
         Qzhu4F6U5PvgoaVwMyCoDk7Y0PMifWe9HpBhy13nzYiBjR5BD+edPg5ZDwkZibrYvQy1
         R2DpHi/ttCLF+/RxRPoOZH/70XhEygMFFFzxWCdMRteRlVz0HcP1UG/SHPWsoEzSwGog
         YX6EvTm4MUmrkqFcP0vAAnSvqnlcYwLIYUt9iW4utewIqV7YS96vMZCz1wcFs9xr0dG0
         LuRA==
X-Gm-Message-State: AFqh2kpVQ47H92bJkpHr4kvdupLOiOnK4FZYwhE4d4soKTbp3EkBrCoB
        zUtt+C2VQPG6GxhUEzGYcTbgsRhQ2dcDDLqmCnVTkyLg7kd5CffgZ6Jy0Ndyj2ZHsAhsTAOxOPA
        YEJM+GRKRZDqyfVYj
X-Received: by 2002:a05:6402:3894:b0:49e:45a8:1ac9 with SMTP id fd20-20020a056402389400b0049e45a81ac9mr53023744edb.24.1675098281080;
        Mon, 30 Jan 2023 09:04:41 -0800 (PST)
X-Google-Smtp-Source: AMrXdXt7Mw9HrdiUA8lLnOM9qoL1bOuVMrMQjCLroDn4RjGvD3/8M+xIzwMnDZeTp/wDlCTHClczWA==
X-Received: by 2002:a05:6402:3894:b0:49e:45a8:1ac9 with SMTP id fd20-20020a056402389400b0049e45a81ac9mr53023723edb.24.1675098280834;
        Mon, 30 Jan 2023 09:04:40 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id p4-20020a056402500400b0049dfd6bdc25sm7111200eda.84.2023.01.30.09.04.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jan 2023 09:04:40 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id E48259726DC; Mon, 30 Jan 2023 18:04:38 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     Jiri Pirko <jiri@resnulli.us>,
        John Fastabend <john.fastabend@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Jamal Hadi Salim <hadi@mojatatu.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        kernel@mojatatu.com, deb.chatterjee@intel.com,
        anjali.singhai@intel.com, namrata.limaye@intel.com,
        khalidm@nvidia.com, tom@sipanda.io, pratyush@sipanda.io,
        xiyou.wangcong@gmail.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, vladbu@nvidia.com, simon.horman@corigine.com,
        stefanc@marvell.com, seong.kim@amd.com, mattyk@nvidia.com,
        dan.daly@intel.com, john.andy.fingerhut@intel.com
Subject: Re: [PATCH net-next RFC 00/20] Introducing P4TC
In-Reply-To: <CAM0EoM=u-VSDZAifwTiOy8vXAGX7Hwg4rdea62-kNFGsHj7ObQ@mail.gmail.com>
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
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 30 Jan 2023 18:04:38 +0100
Message-ID: <878rhkx8bd.fsf@toke.dk>
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

Jamal Hadi Salim <jhs@mojatatu.com> writes:

> So i dont have to respond to each email individually, I will respond
> here in no particular order. First let me provide some context, if
> that was already clear please skip it. Hopefully providing the context
> will help us to focus otherwise that bikeshed's color and shape will
> take forever to settle on.
>
> __Context__
>
> I hope we all agree that when you have 2x100G NIC (and i have seen
> people asking for 2x800G NICs) no XDP or DPDK is going to save you. To
> visualize: one 25G port is 35Mpps unidirectional. So "software stack"
> is not the answer. You need to offload.

I'm not disputing the need to offload, and I'm personally delighted that
P4 is breaking open the vendor black boxes to provide a standardised
interface for this.

However, while it's true that software can't keep up at the high end,
not everything runs at the high end, and today's high end is tomorrow's
mid end, in which XDP can very much play a role. So being able to move
smoothly between the two, and even implement functions that split
processing between them, is an essential feature of a programmable
networking path in Linux. Which is why I'm objecting to implementing the
P4 bits as something that's hanging off the side of the stack in its own
thing and is not integrated with the rest of the stack. You were touting
this as a feature ("being self-contained"). I consider it a bug.

> Scriptability is not a new idea in TC (see u32 and pedit and others in
> TC).

u32 is notoriously hard to use. The others are neat, but obviously
limited to particular use cases. Do you actually expect anyone to use P4
by manually entering TC commands to build a pipeline? I really find that
hard to believe...

> IOW, we are reusing and plugging into a proven and deployed mechanism
> with a built-in policy driven, transparent symbiosis between hardware
> offload and software that has matured over time. You can take a
> pipeline or a table or actions and split them between hardware and
> software transparently, etc.

That's a control plane feature though, it's not an argument for adding
another interpreter to the kernel.

> This hammer already meets our goals.

That 60k+ line patch submission of yours says otherwise...

> It's about using the appropriate tool for the right problem. We are
> not going to rewrite that infra in rust or ebpf just because.

"The right tool for the job" also means something that integrates well
with the wider ecosystem. For better or worse, in the kernel that
ecosystem (of datapath programmability) is BPF-based. Dismissing request
to integrate with that as, essentially, empty fanboyism, comes across as
incredibly arrogant.

> Toke, I labelled that one option as IMpossible as a parody - it is
> what the vendors are saying today and my play on words is "even
> impossible says IM possible".

Side note: I think it would be helpful if you dropped all the sarcasm
and snide remarks when communicating this stuff in writing, especially
to a new audience. It just confuses things, and doesn't exactly help
with the perception of arrogance either...

-Toke

