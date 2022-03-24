Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1CC84E695D
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 20:33:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352961AbiCXTe7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 15:34:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345103AbiCXTe5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 15:34:57 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 117AC6313
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 12:33:25 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id h1so6833908edj.1
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 12:33:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=7ocr+zNBzLy/6V5R8wtgclLYODnbC8wqaRaDBOcpGsE=;
        b=WXJOxqP+A5zMAAeglXUwwXwm6CdqHnTIlvW7/xITHkfLm0l9NrhvUsL/He558mycRA
         VdKU9P7nwZJx35e0DULKlv5C9sFMFPTxUzNh9GE1D85zKtfkg1cfIBWUR6eKr8fMZSMt
         poa1NyRAI1YJ+p+Bz/tVZQpcDzOAbj8llkHVA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=7ocr+zNBzLy/6V5R8wtgclLYODnbC8wqaRaDBOcpGsE=;
        b=4hR70J+3xlahK31QsqIFz7p2hubUqq++KvYH4x6X14VBcb/SOKPzzG48da+5KMX5nF
         7AzJ/QLFRpl1xK+zs3F6C5NTjJ1b6itAONpOqHE+ZZWusHAZInaBZXOEhOQDpvJE6kxo
         pQ7ft9EcBI4NVbuSvgQZB5W7cFjRVOsGXnCYGJ7SeFH0t10wGc5a+WUnOLOpnlZlLJBm
         61IKKwZoQFc/XQ/gOz0N9K56ntsKiKMfdwrLGPoWhQ7uZGqkCLhz4Xi9dXY9srAplR21
         Owk1LoB0aB0fPnsY1x7SyLh3fgN9hhlRPNqGw8YGM6/iAwm8G0H0tPLVsivxtVDupvJq
         g4WQ==
X-Gm-Message-State: AOAM5313kKNnpjpwd44HD4cPr1pO3ZwaHPfz3xZ7RpqFOD+zB/ylZq/T
        iH1Npzjj6xT9DzFaQrcnE50P5C1A0TQtdSvL
X-Google-Smtp-Source: ABdhPJwJfxYgl1GUo8Us/Xn91uYD6aokTyTLXfpwFjrgmOipgLzR6qMJUBKMaBZO6xB0fb0Ce4ZDXA==
X-Received: by 2002:a05:6402:35d1:b0:419:7f2e:cdb7 with SMTP id z17-20020a05640235d100b004197f2ecdb7mr8691543edc.152.1648150403259;
        Thu, 24 Mar 2022 12:33:23 -0700 (PDT)
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com. [209.85.218.50])
        by smtp.gmail.com with ESMTPSA id sb31-20020a1709076d9f00b006ceb969822esm1455077ejc.76.2022.03.24.12.33.22
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Mar 2022 12:33:22 -0700 (PDT)
Received: by mail-ej1-f50.google.com with SMTP id j15so11200652eje.9
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 12:33:22 -0700 (PDT)
X-Received: by 2002:a05:6512:3055:b0:44a:3914:6603 with SMTP id
 b21-20020a056512305500b0044a39146603mr4836615lfb.435.1648150029811; Thu, 24
 Mar 2022 12:27:09 -0700 (PDT)
MIME-Version: 1.0
References: <1812355.tdWV9SEqCh@natalenko.name> <f88ca616-96d1-82dc-1bc8-b17480e937dd@arm.com>
 <20220324055732.GB12078@lst.de> <4386660.LvFx2qVVIh@natalenko.name>
 <81ffc753-72aa-6327-b87b-3f11915f2549@arm.com> <878rsza0ih.fsf@toke.dk>
 <4be26f5d8725cdb016c6fdd9d05cfeb69cdd9e09.camel@freebox.fr>
 <20220324163132.GB26098@lst.de> <d8a1cbf4-a521-78ec-1560-28d855e0913e@arm.com>
 <871qyr9t4e.fsf@toke.dk>
In-Reply-To: <871qyr9t4e.fsf@toke.dk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 24 Mar 2022 12:26:53 -0700
X-Gmail-Original-Message-ID: <CAHk-=whUQCCaQXJt3KUeQ8mtnLeVXEScNXCp+_DYh2SNY7EcEA@mail.gmail.com>
Message-ID: <CAHk-=whUQCCaQXJt3KUeQ8mtnLeVXEScNXCp+_DYh2SNY7EcEA@mail.gmail.com>
Subject: Re: [REGRESSION] Recent swiotlb DMA_FROM_DEVICE fixes break
 ath9k-based AP
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>
Cc:     Robin Murphy <robin.murphy@arm.com>,
        Christoph Hellwig <hch@lst.de>,
        Maxime Bizon <mbizon@freebox.fr>,
        Oleksandr Natalenko <oleksandr@natalenko.name>,
        Halil Pasic <pasic@linux.ibm.com>,
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

On Thu, Mar 24, 2022 at 10:07 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@tok=
e.dk> wrote:
>
> Right, but is that sync_for_device call really needed?

Well, imagine that you have a non-cache-coherent DMA (not bounce
buffers - just bad hardware)...

So the driver first does that dma_sync_single_for_cpu() for the CPU
see the current state (for the non-cache-coherent case it would just
invalidate caches).

The driver then examines the command buffer state, sees that it's
still in progress, and does that return -EINPROGRESS.

It's actually very natural in that situation to flush the caches from
the CPU side again. And so dma_sync_single_for_device() is a fairly
reasonable thing to do in that situation.

But it doesn't seem *required*, no. The CPU caches only have a copy of
the data in them, no writeback needed (and writeback wouldn't work
since DMA from the device may be in progress).

So I don't think the dma_sync_single_for_device() is *wrong* per se,
because the CPU didn't actually do any modifications.

But yes, I think it's unnecessary - because any later CPU accesses
would need that dma_sync_single_for_cpu() anyway, which should
invalidate any stale caches.

And it clearly doesn't work in a bounce-buffer situation, but honestly
I don't think a "CPU modified buffers concurrently with DMA" can
*ever* work in that situation, so I think it's wrong for a bounce
buffer model to ever do anything in the dma_sync_single_for_device()
situation.

Does removing that dma_sync_single_for_device() actually fix the
problem for the ath driver?

There's a fair number of those dma_sync_single_for_device() things all
over. Could we find mis-uses and warn about them some way? It seems to
be a very natural thing to do in this context, but bounce buffering
does make them very fragile.

                 Linus
