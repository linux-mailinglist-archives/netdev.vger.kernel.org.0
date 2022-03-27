Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD5494E85EA
	for <lists+netdev@lfdr.de>; Sun, 27 Mar 2022 07:21:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234997AbiC0FXB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Mar 2022 01:23:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230244AbiC0FXA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Mar 2022 01:23:00 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4E7165FF
        for <netdev@vger.kernel.org>; Sat, 26 Mar 2022 22:21:22 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id 17so15182195lji.1
        for <netdev@vger.kernel.org>; Sat, 26 Mar 2022 22:21:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3AIrmmPfx/ZOrHBctYZwCCwGfAaK/1/IH4psZd3wsUE=;
        b=djCcgOaCULO1J4pux52MUZuwiPblxKGguZJ9FLwYib2dSNo188P6jyJlcS/Z3+Vjqp
         NuxHz+nULM3zYzdCDc/LCticaRTrzP6Eu8i5lYrUz9D+Qn4hFWHokDkpiq4ZgcyhM3fv
         2VMFEP6rvt3FcDITehwTGDWmAXZRTRWN+Beak=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3AIrmmPfx/ZOrHBctYZwCCwGfAaK/1/IH4psZd3wsUE=;
        b=WqbOQsTSnyQkgxNZsXsVCX3ta3v1g10/xd19OM/q0LjFp1+1kBuW5tCD55InIwaS1D
         4J56wcEmLUi2sUC/62lGAMnykXYIXYsj9jqAatpcRV21Iht+Vf3qv8m0hroAl+EQYVTC
         oyBMiWjC9vaTrF1InTJFI4q+fWHnyff3l5OQ089e+Tj4uuMi+3TWVXisABXNkvItkOVK
         x7o4c7ATOpclsfCtLtRY9xjQENlSaY3p5esNNrlhRLqEn+m+sy5uOA6vMvzIz+sNfN95
         fFXzIaUmIm9IedsD5bPwng/ZV3ApoehinmA/ElwJYh+9uUoxYGtQzLDXUzkNutfo8jY/
         Jb/Q==
X-Gm-Message-State: AOAM533O18iG7p9881rpOlH6+BBTJ+YSRbk+jPIr/0TiIhzpEP4zeIwK
        o+aMXAPAxIv8/+HiEGnbngap+hJi8OroF6j+6kk=
X-Google-Smtp-Source: ABdhPJzcefN6dYRLXmWT64x0ucxUfkaVKuGPaQFmojPTyruBjzOwuJiZ6BuFB9ikhWdjrtO7Idg9xg==
X-Received: by 2002:a05:651c:1603:b0:248:e00:aeba with SMTP id f3-20020a05651c160300b002480e00aebamr14970250ljq.456.1648358481083;
        Sat, 26 Mar 2022 22:21:21 -0700 (PDT)
Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com. [209.85.208.176])
        by smtp.gmail.com with ESMTPSA id h13-20020ac24dad000000b0044a3cf811b7sm1251849lfe.195.2022.03.26.22.21.20
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 26 Mar 2022 22:21:20 -0700 (PDT)
Received: by mail-lj1-f176.google.com with SMTP id r22so15181021ljd.4
        for <netdev@vger.kernel.org>; Sat, 26 Mar 2022 22:21:20 -0700 (PDT)
X-Received: by 2002:a2e:6f17:0:b0:248:124:9c08 with SMTP id
 k23-20020a2e6f17000000b0024801249c08mr14918936ljc.506.1648358479393; Sat, 26
 Mar 2022 22:21:19 -0700 (PDT)
MIME-Version: 1.0
References: <1812355.tdWV9SEqCh@natalenko.name> <f88ca616-96d1-82dc-1bc8-b17480e937dd@arm.com>
 <20220324055732.GB12078@lst.de> <4386660.LvFx2qVVIh@natalenko.name>
 <81ffc753-72aa-6327-b87b-3f11915f2549@arm.com> <878rsza0ih.fsf@toke.dk>
 <4be26f5d8725cdb016c6fdd9d05cfeb69cdd9e09.camel@freebox.fr>
 <20220324163132.GB26098@lst.de> <d8a1cbf4-a521-78ec-1560-28d855e0913e@arm.com>
 <871qyr9t4e.fsf@toke.dk> <CAHk-=whUQCCaQXJt3KUeQ8mtnLeVXEScNXCp+_DYh2SNY7EcEA@mail.gmail.com>
 <20220327054848.1a545b12.pasic@linux.ibm.com> <CAHk-=whUJ=tMEgP3KiWwk0pzmHn+1QORUu50syE+zOGk4UnFog@mail.gmail.com>
In-Reply-To: <CAHk-=whUJ=tMEgP3KiWwk0pzmHn+1QORUu50syE+zOGk4UnFog@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat, 26 Mar 2022 22:21:03 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgUx5CVF_1aEkhhEiRGXHgKzUdKiyctBKcHAxkxPpbiaw@mail.gmail.com>
Message-ID: <CAHk-=wgUx5CVF_1aEkhhEiRGXHgKzUdKiyctBKcHAxkxPpbiaw@mail.gmail.com>
Subject: Re: [REGRESSION] Recent swiotlb DMA_FROM_DEVICE fixes break
 ath9k-based AP
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>,
        Robin Murphy <robin.murphy@arm.com>,
        Christoph Hellwig <hch@lst.de>,
        Maxime Bizon <mbizon@freebox.fr>,
        Oleksandr Natalenko <oleksandr@natalenko.name>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Olha Cherevyk <olha.cherevyk@gmail.com>,
        iommu <iommu@lists.linux-foundation.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 26, 2022 at 10:06 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Sat, Mar 26, 2022 at 8:49 PM Halil Pasic <pasic@linux.ibm.com> wrote:
> >
> > I agree it CPU modified buffers *concurrently* with DMA can never work,
> > and I believe the ownership model was conceived to prevent this
> > situation.
>
> But that just means that the "ownership" model is garbage, and cannot
> handle this REAL LIFE situation.

Just to clarify: I obviously agree that the "both sides modify
concurrently" obviously cannot work with bounce buffers.

People still do want to do that, but they'll limit themselves to
actual cache-coherent DMA when they do so (or do nasty uncached
accesses but at least no bounce buffering).

But the "bounce ownership back and forth" model comes up empty when
the CPU wants to read while the DMA is still going on. And that not
only can work, but *has* worked.

You could have a new "get me a non-ownership copy" operation of
course, but that hits the problem of "which existing drivers need it?"

We have no idea, outside of ath9k.

This is why I believe we have to keep the existing semantics in a way
that keep ath9k - and any number of unknown other drivers - happy.

And then for the cases where you want to introduce the zeroing because
you don't know how much data the DMA returned - those are the ones
you'll have to mark some way.

                  Linus
