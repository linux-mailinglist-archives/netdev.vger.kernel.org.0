Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39B925709DC
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 20:23:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229949AbiGKSXQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 14:23:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbiGKSXP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 14:23:15 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A07474D80E;
        Mon, 11 Jul 2022 11:23:14 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id r14so8127843wrg.1;
        Mon, 11 Jul 2022 11:23:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=LDyh/vtAqlchTUEJhEUMVYzVZhOGqr+c1tP2nxvPQ3E=;
        b=BaSeEBuhTSPhFm1WrSLp2YkYR10LGnYPSUVyfpevAiQd+DV3x60uiu1vOlXhEPoafT
         8uhaaIcyLSG9Pfly5++bPQSfjqetrKb+e2ZuT3cl6BE2XJ9sebsq1WjXLnrFxAa9uuEy
         H0o65IOCCQv07sPoU38yamOZAPVR9Sd7l8Eh6TG99L8bB7C+WOf8NhQaC6Ukbid8ud4F
         T69SBV5AT+wvKH8c0PvqhABw//I3Wdju5UbLtOE+Id97rVZ/WeALxW8lH3P9dTY2NmWV
         FOYV00GouzXZIvvNtP2S6wbHzYTMayz+PPB/hR0kNDqsUC45ixtSk5aY1fgDPrAkg5ua
         Iqpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=LDyh/vtAqlchTUEJhEUMVYzVZhOGqr+c1tP2nxvPQ3E=;
        b=Medv72cGPK2w2uTWVRA1cxaIetKn/9/u2gIpAX+TCG8sauI/mluydfMYsWc1BcoXuz
         /ZL2FgzE76N+V2aIrJq8T5Y0ApdDAcHyCX1pxALcQFBXA4rBwI+cxA6LxufVK4SITvI4
         p7DJ4HtEBzQx1qguLVCqsREwe5pzqUmv85/WQhZ+X9w551/ZoR3Pg/cJFJqR4O+yleQk
         k5XMnhXggckIMf0JMxVGKXocCxxd8+jiU+w8hnaW7imW78yt8qemur0/vKjGzoYxWkfs
         NESwGfvLjSdBCtjoPHGLsFfUP2zuvls42W/phf7zZO7i5rfOutSDvGoJ6mEWxWW5IAZ0
         0XLA==
X-Gm-Message-State: AJIora85CpOB5zmaYhKzaHzCk1R2U/pSN/Wsqop7XTNsSdYYbZSQKXlE
        gqOvgkEWtPNiDazlm0VvO6l+3GxfgD2WY5nqujU=
X-Google-Smtp-Source: AGRyM1vnXJ5hhT+ys1lcCGj0nB0+/HxOwAfACFTvmeWcxHW8mH9vqF6mNfjJ5oVC0wEams8uv9j7kD9E93A0fTrK9e4=
X-Received: by 2002:adf:f90c:0:b0:21a:3dcb:d106 with SMTP id
 b12-20020adff90c000000b0021a3dcbd106mr17872123wrr.448.1657563793057; Mon, 11
 Jul 2022 11:23:13 -0700 (PDT)
MIME-Version: 1.0
References: <20220711075225.15687-1-mlombard@redhat.com> <CAKgT0UedQL-Yeum8m=j6oX5s2SjzjtwcwFXBZQde+FzmkmL5bQ@mail.gmail.com>
 <CAFL455nwqqrviZranVvVgRapSF_Na3vwR4NYM+=Hqbvt3+fJeA@mail.gmail.com>
In-Reply-To: <CAFL455nwqqrviZranVvVgRapSF_Na3vwR4NYM+=Hqbvt3+fJeA@mail.gmail.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Mon, 11 Jul 2022 11:23:01 -0700
Message-ID: <CAKgT0Ue0j1-EF+X0miM4ZYQgJ7xLX79BwN58rqHcaEBzC6BBcg@mail.gmail.com>
Subject: Re: [PATCH] mm: prevent page_frag_alloc() from corrupting the memory
To:     Maurizio Lombardi <mlombard@redhat.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>, Chen Lin <chen45464546@163.com>
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

On Mon, Jul 11, 2022 at 9:17 AM Maurizio Lombardi <mlombard@redhat.com> wro=
te:
>
> po 11. 7. 2022 v 17:34 odes=C3=ADlatel Alexander Duyck
> <alexander.duyck@gmail.com> napsal:
> >
> > Rather than forcing us to free the page it might be better to move the
> > lines getting the size and computing the offset to the top of the "if
> > (unlikely(offset < 0)) {" block. Then instead of freeing the page we
> > could just return NULL and don't have to change the value of any
> > fields in the page_frag_cache.
> >
> > That way a driver performing bad requests can't force us to start
> > allocating and freeing pages like mad by repeatedly flushing the
> > cache.
> >
>
> I understand. On the other hand, if we free the cache page then the
> next time __page_frag_cache_refill() runs it may be successful
> at allocating the order=3D3 cache, the normal page_frag_alloc() behaviour=
 will
> therefore be restored.

That is a big "maybe". My concern is that it will actually make memory
pressure worse by forcing us to reduce the number of uses for a lower
order page. One bad actor will have us flushing memory like mad so a
guy expecting a small fragment may end up allocating 32K pages because
someone else is trying to allocate them.

I recommend we do not optimize for a case which this code was not
designed for. Try to optimize for the standard case that most of the
drivers are using. These drivers that are allocating higher order
pages worth of memory should really be using alloc_pages. Using this
to allocate pages over 4K in size is just a waste since they are not
likely to see page reuse which is what this code expects to see.
