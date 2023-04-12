Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 611376E0220
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 00:50:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229630AbjDLWuI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 18:50:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbjDLWuH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 18:50:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85C04768D
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 15:49:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681339761;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2wfPThJ6uD5L19aBEF9JBG7PLb1538J2zAREBtpus8g=;
        b=gp97uxaeGduoDqcc8AUjMIlJS2NhGSaRmejOt3wCauanUjBmDy8n230jFnZuREx8TncQmw
        62FFytU7xiGF4ezvjI3htljBlAyJSFXYnVKppmGmUGE4Nrz+uGbofDCzXxCR6glb1HzgDk
        16kuNZxHdBY/QTsMfga5VRrCQwL0VqU=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-227-bLre6yqaNo60CXgsahrJrA-1; Wed, 12 Apr 2023 18:49:17 -0400
X-MC-Unique: bLre6yqaNo60CXgsahrJrA-1
Received: by mail-ed1-f71.google.com with SMTP id d2-20020a50f682000000b0050503f2097aso1788228edn.14
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 15:49:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681339757;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2wfPThJ6uD5L19aBEF9JBG7PLb1538J2zAREBtpus8g=;
        b=ZhTAJzdXuA4tqPUybTAdyBEgVlEGtmyy49hDQrFcRvHB94xaBciYs5dd568gTpKjU1
         bLTP6KDr12QQ0Yk72nS2X+MWAdr9ky/mxMNXca7Gah/sXbHtfL45kcJce4KCP77rVkHA
         BX8jK+HKIq0D7cC2s6SHiPMTUemysQVpTqWx8YW1qvTVFCKJpRkl36/Jd0uM6AnL8czl
         92L1LZRFbdxC/UD0cPrJbgeVdJqRb9XZHyYZcVAhinPfooQo5Z3Bb3RmGgxASrKeXYY8
         cWYKh5EXwxABGj26LJ2igdj5eNn/Zy0BCYyQD+CkOk9CG1C10du+5MMOfYKt/mymjvRi
         6FYQ==
X-Gm-Message-State: AAQBX9fS8vfj7O+AWJyO/LFXbVKqxZileBufR+CkUt4CWdeEPJYHz1UI
        IW+0ZM92tGV+suHREl5aWH/2wTmn85BrD5Og0Fzo8e8Xvm098vfR6Q6V5z5xWNTf+O6GBK9Edpu
        RbA5P/xMfqJCcdb2z
X-Received: by 2002:a17:906:e07:b0:93d:e6c8:ed5e with SMTP id l7-20020a1709060e0700b0093de6c8ed5emr4232653eji.20.1681339756777;
        Wed, 12 Apr 2023 15:49:16 -0700 (PDT)
X-Google-Smtp-Source: AKy350YHZC+OPPN1Ok/V44r6BzHazE/PVcSQNdhDZYC0v2k36DLDasA1DxoEYQ2wZPQkSLcb/RSq4A==
X-Received: by 2002:a17:906:e07:b0:93d:e6c8:ed5e with SMTP id l7-20020a1709060e0700b0093de6c8ed5emr4232632eji.20.1681339756397;
        Wed, 12 Apr 2023 15:49:16 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id w18-20020a1709064a1200b0094e92b50076sm15810eju.133.2023.04.12.15.49.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Apr 2023 15:49:15 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 4631BAA7980; Thu, 13 Apr 2023 00:49:15 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     Kal Cutter Conley <kal.conley@dectris.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH bpf-next v3 1/3] xsk: Support UMEM chunk_size > PAGE_SIZE
In-Reply-To: <CAJ8uoz0arggpZdf9KPe5+pJbq_nVJUmvVryPHuwAsqswGs1LZw@mail.gmail.com>
References: <20230406130205.49996-1-kal.conley@dectris.com>
 <20230406130205.49996-2-kal.conley@dectris.com> <87sfdckgaa.fsf@toke.dk>
 <ZDBEng1KEEG5lOA6@boxer>
 <CAHApi-nuD7iSY7fGPeMYiNf8YX3dG27tJx1=n8b_i=ZQdZGZbw@mail.gmail.com>
 <875ya12phx.fsf@toke.dk>
 <CAJ8uoz0arggpZdf9KPe5+pJbq_nVJUmvVryPHuwAsqswGs1LZw@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 13 Apr 2023 00:49:15 +0200
Message-ID: <87ttxk1ztg.fsf@toke.dk>
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

Magnus Karlsson <magnus.karlsson@gmail.com> writes:

> On Wed, 12 Apr 2023 at 15:40, Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>>
>> Kal Cutter Conley <kal.conley@dectris.com> writes:
>>
>> >> > > Add core AF_XDP support for chunk sizes larger than PAGE_SIZE. Th=
is
>> >> > > enables sending/receiving jumbo ethernet frames up to the theoret=
ical
>> >> > > maxiumum of 64 KiB. For chunk sizes > PAGE_SIZE, the UMEM is requ=
ired
>> >> > > to consist of HugeTLB VMAs (and be hugepage aligned). Initially, =
only
>> >> > > SKB mode is usable pending future driver work.
>> >> >
>> >> > Hmm, interesting. So how does this interact with XDP multibuf?
>> >>
>> >> To me it currently does not interact with mbuf in any way as it is en=
abled
>> >> only for skb mode which linearizes the skb from what i see.
>> >>
>> >> I'd like to hear more about Kal's use case - Kal do you use AF_XDP in=
 SKB
>> >> mode on your side?
>> >
>> > Our use-case is to receive jumbo Ethernet frames up to 9000 bytes with
>> > AF_XDP in zero-copy mode. This patchset is a step in this direction.
>> > At the very least, it lets you test out the feature in SKB mode
>> > pending future driver support. Currently, XDP multi-buffer does not
>> > support AF_XDP at all. It could support it in theory, but I think it
>> > would need some UAPI design work and a bit of implementation work.
>> >
>> > Also, I think that the approach taken in this patchset has some
>> > advantages over XDP multi-buffer:
>> >     (1) It should be possible to achieve higher performance
>> >         (a) because the packet data is kept together
>> >         (b) because you need to acquire and validate less descriptors
>> > and touch the queue pointers less often.
>> >     (2) It is a nicer user-space API.
>> >         (a) Since the packet data is all available in one linear
>> > buffer. This may even be a requirement to avoid an extra copy if the
>> > data must be handed off contiguously to other code.
>> >
>> > The disadvantage of this patchset is requiring the user to allocate
>> > HugeTLB pages which is an extra complication.
>> >
>> > I am not sure if this patchset would need to interact with XDP
>> > multi-buffer at all directly. Does anyone have anything to add here?
>>
>> Well, I'm mostly concerned with having two different operation and
>> configuration modes for the same thing. We'll probably need to support
>> multibuf for AF_XDP anyway for the non-ZC path, which means we'll need
>> to create a UAPI for that in any case. And having two APIs is just going
>> to be more complexity to handle at both the documentation and
>> maintenance level.
>
> One does not replace the other. We need them both, unfortunately.
> Multi-buff is great for e.g., stitching together different headers
> with the same data. Point to different buffers for the header in each
> packet but the same piece of data in all of them. This will never be
> solved with Kal's approach. We just need multi-buffer support for
> this. BTW, we are close to posting multi-buff support for AF_XDP. Just
> hang in there a little while longer while the last glitches are fixed.
> We have to stage it in two patch sets as it will be too long
> otherwise. First one will only contain improvements to the xsk
> selftests framework so that multi-buffer tests can be supported. The
> second one will be the core code and the actual multi-buffer tests.

Alright, sounds good!

> As for what Kal's patches are good for, please see below.
>
>> It *might* be worth it to do this if the performance benefit is really
>> compelling, but, well, you'd need to implement both and compare directly
>> to know that for sure :)
>
> The performance benefit is compelling. As I wrote in a mail to a post
> by Kal, there are users out there that state that this feature (for
> zero-copy mode nota bene) is a must for them to be able to use AF_XDP
> instead of DPDK style user-mode drivers. They have really tough
> latency requirements.

Hmm, okay, looking forward to seeing the benchmark results, then! :)

-Toke

