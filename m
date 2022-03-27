Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5F084E85DE
	for <lists+netdev@lfdr.de>; Sun, 27 Mar 2022 07:13:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234670AbiC0FPM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Mar 2022 01:15:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234486AbiC0FPJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Mar 2022 01:15:09 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F5FD13EAF
        for <netdev@vger.kernel.org>; Sat, 26 Mar 2022 22:13:28 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id k21so19698549lfe.4
        for <netdev@vger.kernel.org>; Sat, 26 Mar 2022 22:13:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4DsawngOkTaf1ffe3Djt9i8R04p2xlEj2LaUyWMHpLQ=;
        b=IL1j88A1zMmNQ619gkjkOLfevd4yJp/uUvy/JL+W394T7Ci9byh8r//w+swnF4uoTk
         MZxgdJEbG5E8/y/0RfpNKMtcmR1SxV+ftoqfImF3PZxALDLZgAsd0IabrARdiKS285Pw
         iUyVNk8ywuM4lUwh7TQ+LKc1DK3c/TGkrq11k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4DsawngOkTaf1ffe3Djt9i8R04p2xlEj2LaUyWMHpLQ=;
        b=gcLYbnnszCOcZAFqS5yjC28UjealYRdyYXGe/X154GJnwjRlb3krAJTm3ZwQ5/ih4n
         BssMfa0iBfRu0E9bhwAdbdl03VpvHBGJ/EUHT4dSGO/IgqmSDN5q4rKCB8bXVFFs1xWW
         w1zFempiVcEmWladbE7h++OtOT/DfTSl+VM66mHSX4aEIm/cQg6GGSc0i58bsbPGIIB5
         ydsYplUsnXyMEHXfephzvifCpiIXIkPtDBPhTFwYDy9SSbeOvXFZP7W4m100JDnd15S0
         SbIq6m6fNZtA9cSqE3Z2ao09pbHctoWQgpFh1Mk+mW4Wf1GYb7OgO5N6D4xwLHpVobCL
         BL6g==
X-Gm-Message-State: AOAM532lLtLf11fbU34b87BC8EVl/Gl8XUv4HLNekVesb6sf7lcZAm4I
        gnlFA/rEVn9Ps4JCkBraWsOtjy1464xTbCzDl9c=
X-Google-Smtp-Source: ABdhPJyINKLmrQQoU2j9/BOu7b0CY52m6qy27SD80hFQwawQPxtNRxGI2cL10kc6BFpUvszOOA7Wxw==
X-Received: by 2002:a05:6512:22cd:b0:44a:6d2c:8b9f with SMTP id g13-20020a05651222cd00b0044a6d2c8b9fmr10620201lfu.142.1648358006009;
        Sat, 26 Mar 2022 22:13:26 -0700 (PDT)
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com. [209.85.167.50])
        by smtp.gmail.com with ESMTPSA id u3-20020a2e2e03000000b00249b9d8de47sm735525lju.115.2022.03.26.22.13.25
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 26 Mar 2022 22:13:25 -0700 (PDT)
Received: by mail-lf1-f50.google.com with SMTP id t25so19681700lfg.7
        for <netdev@vger.kernel.org>; Sat, 26 Mar 2022 22:13:25 -0700 (PDT)
X-Received: by 2002:ac2:4203:0:b0:448:8053:d402 with SMTP id
 y3-20020ac24203000000b004488053d402mr14244664lfh.687.1648357591941; Sat, 26
 Mar 2022 22:06:31 -0700 (PDT)
MIME-Version: 1.0
References: <1812355.tdWV9SEqCh@natalenko.name> <f88ca616-96d1-82dc-1bc8-b17480e937dd@arm.com>
 <20220324055732.GB12078@lst.de> <4386660.LvFx2qVVIh@natalenko.name>
 <81ffc753-72aa-6327-b87b-3f11915f2549@arm.com> <878rsza0ih.fsf@toke.dk>
 <4be26f5d8725cdb016c6fdd9d05cfeb69cdd9e09.camel@freebox.fr>
 <20220324163132.GB26098@lst.de> <d8a1cbf4-a521-78ec-1560-28d855e0913e@arm.com>
 <871qyr9t4e.fsf@toke.dk> <CAHk-=whUQCCaQXJt3KUeQ8mtnLeVXEScNXCp+_DYh2SNY7EcEA@mail.gmail.com>
 <20220327054848.1a545b12.pasic@linux.ibm.com>
In-Reply-To: <20220327054848.1a545b12.pasic@linux.ibm.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat, 26 Mar 2022 22:06:15 -0700
X-Gmail-Original-Message-ID: <CAHk-=whUJ=tMEgP3KiWwk0pzmHn+1QORUu50syE+zOGk4UnFog@mail.gmail.com>
Message-ID: <CAHk-=whUJ=tMEgP3KiWwk0pzmHn+1QORUu50syE+zOGk4UnFog@mail.gmail.com>
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

On Sat, Mar 26, 2022 at 8:49 PM Halil Pasic <pasic@linux.ibm.com> wrote:
>
> I agree it CPU modified buffers *concurrently* with DMA can never work,
> and I believe the ownership model was conceived to prevent this
> situation.

But that just means that the "ownership" model is garbage, and cannot
handle this REAL LIFE situation.

Here's the deal: if somebody makes a model that is counter-factual,
you have exactly two choices:

 - fix the damn model

 - live in a la-la-land that isn't reality

Which choice do you pick?

And I'll be brutally honest: if you pick the la-la-land one, I don't
think we can really discuss this any more.

> But a CPU can modify the buffer *after* DMA has written to
> it, while the mapping is still alive.

Yes.

But you are making ALL your arguments based on that "ownership" model
that we now know is garbage.

If you make your arguments based on garbage, the end result _might_
work just by happenstance, but the arguments sure aren't very
convincing, are they?

So let's make it really clear that the arguments must not be based on
some "ownership" model that you just admitted cannot handle the very
real case of real and common hardware.

Ok?

>  For example one could do one
> partial read from the device, *after* the DMA is done,
> sync_for_cpu(DMA_FROM_DEVICE), examine, then zero out the entire buffer,
> sync_for_device(DMA_FROM_DEVICE)

So the result you want to get to I can believe in, but your sequence
of getting there is untenable, since it depends on breaking other
cases that are more important than your utterly broken hardware that
you don't even know how much data it filled.

And I fundamentally also happen to think that since the CPU just wrote
that buffer, and *that* write is what you want to sync with the
device, then that DMA_FROM_DEVICE was just pure fantasy to begin with.

So that code sequence you quote is wrong. You are literally trying to
re-introduce the semantics that we already know broke the ath9k
driver.

Instead, let me give you a couple of alternative scenarios.

Alternative 1:

 - ok, so the CPU wrote zeroes to the area, and we want to tell the
DMA mapping code that it needs to make that CPU write visible to the
device.

 - Ahh, you mean "sync_for_device(DMA_TO_DEVICE)"?

 - Yes.

   The "for_device()" tells us that afterwards, the device can access
the memory (we synced it for the device).

   And the DMA_TO_DEVICE tells us that we're transferring the zeroes
we wrote on the CPU to the device bounce buffer.

   Now the device got those zeroes, and it can overwrite them
(partially), and everything is fine

 - And then we need to use "sync_for_cpu(DMA_FROM_DEVICE)" when we
want to see the result once it's all done?

 - Yes.

 - Splendid. Except I don't like how you mix DMA_TO_DEVICE and
DMA_FROM_DEVICE and you made the dma_alloc() not use DMA_BIDIRECTIONAL

 - Yeah, that's ugly, but it matches reality, and it would "just work" today.

Alternative 2:

 - Ok, so the CPU doesn't even want to write to the area AT ALL, but
we know we have a broken device that might not fill all of the bounce
buffer, and we don't want to see old stale bounce buffer contents that
could come from some other operation entirely and leak sensitive data
that wasn't for us.

 - Ahh, so you really want to just clear the bounce buffer before IO?

 - Yes. So let's introduce a "clear_bounce_buffer()" operation before
starting DMA. Let's call it "sync_for_device(DMA_NONE)" and teach the
non-bounce-buffer dmas mapping entities to just ignore it, because
they don't have a bounce buffer that can contain stale data.

 - Sounds good.

Alternative 3:

 - Ok, you have me stumped. I can't come up with something else sane.

Anyway, notice what's common about these alternatives? They are based
not on some "we have a broken model", but on trying to solve the
actual real-life problem case.

I'm more than happy to hear other alternatives.

But the alternative I am _not_ willing to entertain is "Yeah, we have
a model of ownership, and that can't handle ath9k because that one
wants to do CPU reads while DMA is possibly active, so ath9k is
broken".

Can we please agree on that?

                          Linus
