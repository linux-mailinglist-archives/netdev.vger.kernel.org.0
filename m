Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDF694E8361
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 19:39:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234599AbiCZSk6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Mar 2022 14:40:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232939AbiCZSk4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Mar 2022 14:40:56 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE30E2FFD2
        for <netdev@vger.kernel.org>; Sat, 26 Mar 2022 11:39:19 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id t25so18426888lfg.7
        for <netdev@vger.kernel.org>; Sat, 26 Mar 2022 11:39:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=2m51oiAn/Cj+SF/F+aV22/Ai48y8dhVaDitWIYFgHko=;
        b=Xzpb8EwMd16IfpevZXCSnZ1w7igDgljvhc1UKwPCGJbTR1UuTbbMqaENrY8MItnW6A
         /mhYRG9m1OqxvKFji2pu2e6epPatTwTurg1n0sv6438+lqS7kq56HR/JgRktiNPSjzbW
         jslyVNaXHhOqnGPtddZTS6jVTkH+ZYGjaxVaM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=2m51oiAn/Cj+SF/F+aV22/Ai48y8dhVaDitWIYFgHko=;
        b=FyKx94xjzfjDhyQjbApiSS6u1GGIJ1/W/zCkB2veS7i6uJLqI1koaxeokHGm+54br0
         XwB1FKUmvQEd5bsKLdDvuaB10oawg1zUk8fSeuec3YeM2o1UWMqVylVcdERAO3Y3mbIs
         63QBZ4vHQz/RrpUEAyR/AOCpFajINgZWOP4vdFuqk0QLfdi5cd1nQ8GvdkRpFref5mZ2
         uKg+i1cGe0Xd6rMlmFzUO1/KvzdcZPpeV5xlUjQNF2Vs9Xqr0MjjQ0N/eq2QamMMe4Ij
         VpTGNU1GWcv9llQVeYdEU8FrIF8F3ky5eL9u3pyFiFQ6OgxlD+wutzrXtJAbn9C26z5x
         TmGg==
X-Gm-Message-State: AOAM530w7QqR1WwuKWVWkfFZ01ignA7fOVU6eHvwsyGIL1y7egrQKRoh
        ZrldKsf0NBBK/QzGdbp7EuccKZa5GEfMXP6utqs=
X-Google-Smtp-Source: ABdhPJwyp9pi+qYhfxB1ilJN1zKRXejglYdeTLakeU73ZC8tfhpeM6iULXf4dzKaYP1VTb7euRzY0w==
X-Received: by 2002:a19:6456:0:b0:437:974a:f5ce with SMTP id b22-20020a196456000000b00437974af5cemr13102096lfj.394.1648319957939;
        Sat, 26 Mar 2022 11:39:17 -0700 (PDT)
Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com. [209.85.208.179])
        by smtp.gmail.com with ESMTPSA id r19-20020a2e8e33000000b002495db7fe99sm1105470ljk.27.2022.03.26.11.39.16
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 26 Mar 2022 11:39:16 -0700 (PDT)
Received: by mail-lj1-f179.google.com with SMTP id g24so14151561lja.7
        for <netdev@vger.kernel.org>; Sat, 26 Mar 2022 11:39:16 -0700 (PDT)
X-Received: by 2002:a2e:6f17:0:b0:248:124:9c08 with SMTP id
 k23-20020a2e6f17000000b0024801249c08mr13222025ljc.506.1648319955630; Sat, 26
 Mar 2022 11:39:15 -0700 (PDT)
MIME-Version: 1.0
References: <1812355.tdWV9SEqCh@natalenko.name> <f88ca616-96d1-82dc-1bc8-b17480e937dd@arm.com>
 <20220324055732.GB12078@lst.de> <4386660.LvFx2qVVIh@natalenko.name>
 <81ffc753-72aa-6327-b87b-3f11915f2549@arm.com> <878rsza0ih.fsf@toke.dk>
 <4be26f5d8725cdb016c6fdd9d05cfeb69cdd9e09.camel@freebox.fr>
 <20220324163132.GB26098@lst.de> <d8a1cbf4-a521-78ec-1560-28d855e0913e@arm.com>
 <871qyr9t4e.fsf@toke.dk> <CAHk-=whUQCCaQXJt3KUeQ8mtnLeVXEScNXCp+_DYh2SNY7EcEA@mail.gmail.com>
 <31434708dcad126a8334c99ee056dcce93e507f1.camel@freebox.fr>
 <cce202fb-5185-aa3e-9e9b-11626192cb49@arm.com> <20220326003853.44c3285c.pasic@linux.ibm.com>
 <8735j47l7y.fsf@toke.dk>
In-Reply-To: <8735j47l7y.fsf@toke.dk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat, 26 Mar 2022 11:38:59 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjorwZTQuQB8QBgNpdBZNz7uyprgaTT+1Q6_1FaT3sAmQ@mail.gmail.com>
Message-ID: <CAHk-=wjorwZTQuQB8QBgNpdBZNz7uyprgaTT+1Q6_1FaT3sAmQ@mail.gmail.com>
Subject: Re: [REGRESSION] Recent swiotlb DMA_FROM_DEVICE fixes break
 ath9k-based AP
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>
Cc:     Halil Pasic <pasic@linux.ibm.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Maxime Bizon <mbizon@freebox.fr>,
        Netdev <netdev@vger.kernel.org>, Kalle Valo <kvalo@kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Oleksandr Natalenko <oleksandr@natalenko.name>,
        stable <stable@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        iommu <iommu@lists.linux-foundation.org>,
        Olha Cherevyk <olha.cherevyk@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 26, 2022 at 9:06 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke=
.dk> wrote:
>
> I was also toying with the idea of having a copy-based peek helper like:
>
> u32 data =3D dma_peek_word(buf, offset)

I really don't think you can or want to have a word-based one.

That said, I like the *name* of that thing.

I think a lot of confusion comes from the very subtle naming of
fundamentally having a lot of odd conditions with

 - two different "directions of the sync" - ie who it is that cares:

       dma_sync_single_for_{cpu,device}

 - three different "direction of the data" - ie who it is that writes the d=
ata:

        DMA_FROM_DEVICE / DMA_TO_DEVICE / DMA_BIDIRECTIONAL

so you have six possible combinations, three of which seem insane and
not useful, and of the three that are actually possible, some are very
unusual (it exactly that "device is the one writing, but we want to
sync the dma area for the device").

I do not think it helps that not only do we have this combinatorial
naming, we also use _different_ names. We say "for device" and "for
cpu", but then when we specify who does the writing, we don't say "cpu
vs device", we just specify the direction instead (FROM_DEVICE means
the device did the writing, TO_DEVICE means that the CPU did the
writing).

Anyway, I spent a lot of time looking at this, and I am now personally
convinced that commit aa6f8dcbab47 (swiotlb: rework "fix info leak
with DMA_FROM_DEVICE") was just completely buggy, and was buggy
exactly becasue it was fundamentally confused even about which
direction the bounce was happening.

I have reverted it in my tree, and I tried to write a comprehensive
summary about why it was wrong.

What I *didn't* do in that commit was to argue against the naming, and
try to enumerate all the different valid cases.

Because I think naming matters, and I think the current dma_sync()
interfaces are horribly confusing exactly due to those naming
combinatorials.

But I think "peek" is a good name, not because I think reading one
work is a valid thing (you want to often peek more than that), but
because it seems much more intuitive than
"dma_sync_for_cpu(DMA_FROM_DEVICE)".

Similarly, I would think that "flush" is a much better word for
"dma_sync_for_device(DMA_FROM_CPU)".

I don't know what a good word for
"dma_sync_for_device(DMA_FROM_DEVICE)" is, but maybe "forget" would
come closest - we want the CPU to "forget" what it peeked.

Anyway, I have reverted that commit, and I think it was wrong both in
spirit and in implementation, and I'll ask Greg to remove it from
stable.

And I think the security argument was entirely bogus, because the
whole security argument was based on an incorrect understanding of the
direction of the data.

But hey, I may currently be convinced that revert is the right thing
to do, BUT I've been wrong before, and I'll happily change my mind if
somebody makes a really cogent argument

               Linus
