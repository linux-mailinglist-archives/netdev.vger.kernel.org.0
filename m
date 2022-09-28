Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8042A5EDEB8
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 16:24:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234324AbiI1OYT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 10:24:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234274AbiI1OYS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 10:24:18 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 484CFA98DB
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 07:24:17 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id 88so368880pjz.4
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 07:24:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date;
        bh=hlcad05NExEsT9KS3IF9kNKINFpCOx6UTJCu0ZwqNes=;
        b=a6j3krf6oMyWapj9D7XCL0Si9w7QgPrJv4zU/g7cqwHiS95guiMbzl4PtCCmBy2uPT
         fTbGm52UPhZ1DePz9pvz2CE+5L0irfwzo5k7zVCT/YrENgMKrA0pMvjUzkinZbjmxFeq
         x6u4ZS7sI/AlvrpTxqS0y8lA4qQfL1010k54ZrUanwDQk/8wYnos6Vd2KBqSw8PeLogL
         Y6MIZfy0feiD2CaZfREBQZbUXFISYnEb1t26uVT5hniXu4DN39HAQVsd8/f4WH1xk2pP
         PZeoDuXI3azUAOcWQIO3uSX8b8bidREO0zb9loKqwUGCeKP3WwTNxA4f//GdyXSls2Rz
         91Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date;
        bh=hlcad05NExEsT9KS3IF9kNKINFpCOx6UTJCu0ZwqNes=;
        b=2x8ewSSGJmu9Won5J4T8BhVRA4aNLoHnx5OQkHucs6i4bC2ElmgE+OCdHrKBJnsOqo
         CGmC1sJ4wQ24sqEd9Awdb7C4bPvE9Eglmm5ODsFivM+glpIWjPNtgO2RiiLC2I8OIAm7
         UJfhLBkt+Z8YqSpblTtk7UtjwT6uALLxSF8XL583GTnB+vbOVKGjZodEKZoLUIqmxQYm
         Z2S1ofXTOfu4EwLdmQnLK4NiRpZ/7XUVyXCVMApQlG+SmGZUokO38pY3+QycU5axWM//
         We58wZia5ZzRmRFH4zKyGdZwQBFSHLsx+XbTHsAw4COQ+Y+8YrCoyFZzezXUYYIs45J+
         06Eg==
X-Gm-Message-State: ACrzQf3OxJNq4gZjuMTqXHmGPWtaTrdHAVUffkaLdoyrmba4zCyIOKfI
        IYFXFfhLjZ5uBGKEG5RtOds=
X-Google-Smtp-Source: AMsMyM7SwEJO8O0OweeMbOy359DbB7tBTGXwUNBDwuhhDuTYK2CxLNv0VOM/NpNJgyZkE8JoJvj9Qw==
X-Received: by 2002:a17:90b:180e:b0:202:a0c3:6da with SMTP id lw14-20020a17090b180e00b00202a0c306damr10488780pjb.94.1664375056576;
        Wed, 28 Sep 2022 07:24:16 -0700 (PDT)
Received: from [192.168.0.128] ([98.97.119.47])
        by smtp.googlemail.com with ESMTPSA id o24-20020a17090ac09800b002000d577cc3sm1581217pjs.55.2022.09.28.07.24.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Sep 2022 07:24:15 -0700 (PDT)
Message-ID: <d8dce1ae33860437c55c56ffa9718cb1d1523bad.camel@gmail.com>
Subject: Re: [PATCH net-next v4] net: skb: introduce and use a single page
 frag cache
From:   Alexander H Duyck <alexander.duyck@gmail.com>
To:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexander H Duyck <alexanderduyck@fb.com>
Date:   Wed, 28 Sep 2022 07:24:14 -0700
In-Reply-To: <6b6f65957c59f86a353fc09a5127e83a32ab5999.1664350652.git.pabeni@redhat.com>
References: <6b6f65957c59f86a353fc09a5127e83a32ab5999.1664350652.git.pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2022-09-28 at 10:43 +0200, Paolo Abeni wrote:
> After commit 3226b158e67c ("net: avoid 32 x truesize under-estimation
> for tiny skbs") we are observing 10-20% regressions in performance
> tests with small packets. The perf trace points to high pressure on
> the slab allocator.
>=20
> This change tries to improve the allocation schema for small packets
> using an idea originally suggested by Eric: a new per CPU page frag is
> introduced and used in __napi_alloc_skb to cope with small allocation
> requests.
>=20
> To ensure that the above does not lead to excessive truesize
> underestimation, the frag size for small allocation is inflated to 1K
> and all the above is restricted to build with 4K page size.
>=20
> Note that we need to update accordingly the run-time check introduced
> with commit fd9ea57f4e95 ("net: add napi_get_frags_check() helper").
>=20
> Alex suggested a smart page refcount schema to reduce the number
> of atomic operations and deal properly with pfmemalloc pages.
>=20
> Under small packet UDP flood, I measure a 15% peak tput increases.
>=20
> Suggested-by: Eric Dumazet <eric.dumazet@gmail.com>
> Suggested-by: Alexander H Duyck <alexanderduyck@fb.com>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> ---
> v3 -> v4:
>  - NAPI_HAS_SMALL_PAGE <-> 4K page (Eric)
>  - fixed typos in comments (Eric)
>=20
> v2 -> v3:
>  - updated Alex email address
>  - fixed build with !NAPI_HAS_SMALL_PAGE_FRAG
>=20
> v1 -> v2:
>  - better page_frag_alloc_1k() (Alex & Eric)
>  - avoid duplicate code and gfp_flags misuse in __napi_alloc_skb() (Alex)
> ---


Looks good to me.

Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
