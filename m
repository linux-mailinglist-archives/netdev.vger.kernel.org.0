Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D93B6DF754
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 15:36:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229694AbjDLNgM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 09:36:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbjDLNgK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 09:36:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98C878A53
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 06:35:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681306480;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=avnUO+n0BtEa4d40ZQG2oXgOaFPN9DVhnjMogjSitH8=;
        b=Ra7YmniaS0mHj2qPYLc/8QekN3k8yHoza5uax387Tq+dcO/2PU34A93yeRqgGNou6GHO/+
        gZoFl0SSLQG8t2YJ0pitnQU6fbYht4gK9O227/J2H+CUNTHhCqBr0ueUL3QY8/yC4IW+oN
        HQGGeAlCHkYprrbVw2STTyHYokq3V6M=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-472-ycYNkNUNP7yc2rCVgtViqg-1; Wed, 12 Apr 2023 09:34:39 -0400
X-MC-Unique: ycYNkNUNP7yc2rCVgtViqg-1
Received: by mail-ej1-f71.google.com with SMTP id vx12-20020a170907a78c00b0094a9009d99bso3687124ejc.21
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 06:34:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681306478;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=avnUO+n0BtEa4d40ZQG2oXgOaFPN9DVhnjMogjSitH8=;
        b=6isa1rBR/oOdQ6NK+A+rB1KHVdP95GcwNAu78RhqR2URBEapQw6DrSB6iyJr9m/mdx
         uqsoEfgKlVoWjhleER6ds5S4dSmPzkSNkG4TAvsvSHK4mDpLNhXmjRi9rNb8joPsfzZ2
         v+yYKEeHBX7kkwNbRkenmqIYnQQt8mn7tz8g6axMKhRWQeUE2E4gyG9btLtoQHG3Lfks
         hSNBeTNO4e9Z8W5RTyZjN+fgP8gS2pmIu43tNCimHuIWYMTAKiJ1wphzeYJk7yM59WxU
         o/DnBRHSlNRFAs2q5Z92YLY40W25gf9rpwGmBuRogzbveaWj0uC8PgrKxGV7rd7CwE9L
         YCgw==
X-Gm-Message-State: AAQBX9f2BQXvMeYWuMXTHkae/HMdYl77IEPvEN3xHdbmyaSHyoZPELcR
        9zyAD//8/97y9IFZDqpgMtRaeItieisgIRA7lkYivE+mj6J2sdXoKvnVB/1j76Hzz45sT3LcsIW
        Gl/BHIt+5/CbjQ15z
X-Received: by 2002:a17:906:99c8:b0:8e6:bcb6:469e with SMTP id s8-20020a17090699c800b008e6bcb6469emr2343003ejn.0.1681306476781;
        Wed, 12 Apr 2023 06:34:36 -0700 (PDT)
X-Google-Smtp-Source: AKy350YgapZMeMC4Rm/QdXzs4rXyxXgFabYvm7ZL0sTQJ3wSeNGkMdybuNwlZL/acPVv3QhRoQAsuw==
X-Received: by 2002:a17:906:99c8:b0:8e6:bcb6:469e with SMTP id s8-20020a17090699c800b008e6bcb6469emr2342948ejn.0.1681306475958;
        Wed, 12 Apr 2023 06:34:35 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id 22-20020a170906319600b00930525d89e2sm7264423ejy.89.2023.04.12.06.34.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Apr 2023 06:34:35 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 00D35AA78D2; Wed, 12 Apr 2023 15:34:34 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Kal Cutter Conley <kal.conley@dectris.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
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
In-Reply-To: <CAHApi-nuD7iSY7fGPeMYiNf8YX3dG27tJx1=n8b_i=ZQdZGZbw@mail.gmail.com>
References: <20230406130205.49996-1-kal.conley@dectris.com>
 <20230406130205.49996-2-kal.conley@dectris.com> <87sfdckgaa.fsf@toke.dk>
 <ZDBEng1KEEG5lOA6@boxer>
 <CAHApi-nuD7iSY7fGPeMYiNf8YX3dG27tJx1=n8b_i=ZQdZGZbw@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 12 Apr 2023 15:34:34 +0200
Message-ID: <875ya12phx.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kal Cutter Conley <kal.conley@dectris.com> writes:

>> > > Add core AF_XDP support for chunk sizes larger than PAGE_SIZE. This
>> > > enables sending/receiving jumbo ethernet frames up to the theoretical
>> > > maxiumum of 64 KiB. For chunk sizes > PAGE_SIZE, the UMEM is required
>> > > to consist of HugeTLB VMAs (and be hugepage aligned). Initially, only
>> > > SKB mode is usable pending future driver work.
>> >
>> > Hmm, interesting. So how does this interact with XDP multibuf?
>>
>> To me it currently does not interact with mbuf in any way as it is enabled
>> only for skb mode which linearizes the skb from what i see.
>>
>> I'd like to hear more about Kal's use case - Kal do you use AF_XDP in SKB
>> mode on your side?
>
> Our use-case is to receive jumbo Ethernet frames up to 9000 bytes with
> AF_XDP in zero-copy mode. This patchset is a step in this direction.
> At the very least, it lets you test out the feature in SKB mode
> pending future driver support. Currently, XDP multi-buffer does not
> support AF_XDP at all. It could support it in theory, but I think it
> would need some UAPI design work and a bit of implementation work.
>
> Also, I think that the approach taken in this patchset has some
> advantages over XDP multi-buffer:
>     (1) It should be possible to achieve higher performance
>         (a) because the packet data is kept together
>         (b) because you need to acquire and validate less descriptors
> and touch the queue pointers less often.
>     (2) It is a nicer user-space API.
>         (a) Since the packet data is all available in one linear
> buffer. This may even be a requirement to avoid an extra copy if the
> data must be handed off contiguously to other code.
>
> The disadvantage of this patchset is requiring the user to allocate
> HugeTLB pages which is an extra complication.
>
> I am not sure if this patchset would need to interact with XDP
> multi-buffer at all directly. Does anyone have anything to add here?

Well, I'm mostly concerned with having two different operation and
configuration modes for the same thing. We'll probably need to support
multibuf for AF_XDP anyway for the non-ZC path, which means we'll need
to create a UAPI for that in any case. And having two APIs is just going
to be more complexity to handle at both the documentation and
maintenance level.

It *might* be worth it to do this if the performance benefit is really
compelling, but, well, you'd need to implement both and compare directly
to know that for sure :)

-Toke

