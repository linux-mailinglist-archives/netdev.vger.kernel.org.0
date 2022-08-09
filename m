Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50E0858DA66
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 16:34:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238977AbiHIOeA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 10:34:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231768AbiHIOd7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 10:33:59 -0400
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DEF518374;
        Tue,  9 Aug 2022 07:33:58 -0700 (PDT)
Received: by mail-ot1-x32b.google.com with SMTP id l5-20020a05683004a500b0063707ff8244so2086861otd.12;
        Tue, 09 Aug 2022 07:33:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=kjw93QTfVlqJuSptxO5/BqOinS7HQwob28jAAztpcBU=;
        b=Bbkf6xayIAAXDEo70VAhm0hGrJOV93jWiM4J3o0918fMBzik3wqs+BEYzsqRpnOROX
         GzERIhUqfFyFSsVD8q6FoKcgVUfP8tDfrLkkccRT5tzVCAopgI/8TKd1odODVYnEeEEd
         ycjYrrOQsamFKHfChF8/toDN34F2Gcg4y9/5/jKrcLSxd2aK/Mu8QMZVstGBa4sIdJHz
         rmScCcxo11FnFZTd7IRoKd3LdTVMU22BxgCCiUGdDSkMNxl/gV0KQYWKkuD+KgYp96d3
         maieCgv0s2MaHjJGy7JeFbt2tH3R/hmjBxOJYX06VQGvdoFLmVRj0gMAzjuEdBh4OFZ9
         LbRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=kjw93QTfVlqJuSptxO5/BqOinS7HQwob28jAAztpcBU=;
        b=cBLjl5+mI8ItNF/zEXXqT0olb8Ko4ak5Ifdsbp+g1u0g7HI26TZjpgyGacssdVH5fy
         5Ar4LqpOfLrTAGvwrhy29/hMgIEJVVS9ylRfebP6F9yg9OtZ11nKWJeKMEB9aei8bRYj
         Z1iWXurRQfSZh8VS6vNn2lKpQ/SUBkM4J6uRBsIhlxcsETtGw194+CgUV1F1DRiVctEp
         BC21Gxy1/F/NwKfXHu2Ee/jLq83zeKEgH2DZgiUglfkCP49KD9JVHADVlhFEv5sx1Ne3
         rgsHIu6xXNHCYd0gKilJ6BFM35PLye1yPX8bBpzQqXjE/L0ALDNFiA7GADfBxXejEozV
         41+w==
X-Gm-Message-State: ACgBeo3eF1iEXYTwrbtR93g+f/EijN1tN8IFoSvIy1abbAiMysdo+RVc
        MyR8xkJoAc0jfiWow1GB6K1bMyoPkHUfUjTO7JQ=
X-Google-Smtp-Source: AA6agR69QyVQ0npiwVTAvrRokMu0WDClkvi+ZvJhBlh5QlEMkY/NnvYoMFu+DiQhkpwUNZxW6anc8AV2mQO33yu8Ouk=
X-Received: by 2002:a05:6830:d0b:b0:61c:1bc2:fbc0 with SMTP id
 bu11-20020a0568300d0b00b0061c1bc2fbc0mr8516534otb.348.1660055637348; Tue, 09
 Aug 2022 07:33:57 -0700 (PDT)
MIME-Version: 1.0
References: <20220715125013.247085-1-mlombard@redhat.com> <20220808171452.d870753e1494b92ba2142116@linux-foundation.org>
 <CAFL455nMBPMD2KkdnsWrq6x_XjwdRCTsCe0Ohbm9Df7aTfiq_A@mail.gmail.com>
In-Reply-To: <CAFL455nMBPMD2KkdnsWrq6x_XjwdRCTsCe0Ohbm9Df7aTfiq_A@mail.gmail.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Tue, 9 Aug 2022 07:33:46 -0700
Message-ID: <CAKgT0Ud2Dc0Gbeys7Zwhtqr+j5Qghp3JEyK2LmPUKtbZ4dyDqQ@mail.gmail.com>
Subject: Re: [PATCH V3] mm: prevent page_frag_alloc() from corrupting the memory
To:     Maurizio Lombardi <mlombard@redhat.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        =?UTF-8?B?5oSa5qCR?= <chen45464546@163.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 9, 2022 at 4:45 AM Maurizio Lombardi <mlombard@redhat.com> wrot=
e:
>
> =C3=BAt 9. 8. 2022 v 2:14 odes=C3=ADlatel Andrew Morton
> <akpm@linux-foundation.org> napsal:
> >
> > On Fri, 15 Jul 2022 14:50:13 +0200 Maurizio Lombardi <mlombard@redhat.c=
om> wrote:
> >
> > > A number of drivers call page_frag_alloc() with a
> > > fragment's size > PAGE_SIZE.
> > > In low memory conditions, __page_frag_cache_refill() may fail the ord=
er 3
> > > cache allocation and fall back to order 0;
> > > In this case, the cache will be smaller than the fragment, causing
> > > memory corruptions.
> > >
> > > Prevent this from happening by checking if the newly allocated cache
> > > is large enough for the fragment; if not, the allocation will fail
> > > and page_frag_alloc() will return NULL.
> >
> > Can we come up with a Fixes: for this?
>
> I think the bug has been introduced in kernel 3.19-rc1
> Fixes: ffde7328a36d16e626bae8468571858d71cd010b

The problem is this patch won't cleanly apply to that since we moved
the function. In addition this issue is a bit more complex since it
isn't necessarily a problem in the code, but the assumption on how it
is can be used by a select few drivers that were using it to allocate
to higher order pages.

It would probably be best to just go with:
Fixes: b63ae8ca096d ("mm/net: Rename and move page fragment handling
from net/ to mm/")

> >
> > Should this fix be backported into -stable kernels?
>
> Yes, IMO this should be backported to -stable

This should be fine for -stable. Basically it just needs to be there
to block the drivers that abused the API to allocate high order pages
instead of fragments of an order 0 page. Ultimately the correct fix
for this is to fix those drivers, but this at least is enough so that
they will fail allocations now instead of corrupting memory by
overflowing an order 0 page.
