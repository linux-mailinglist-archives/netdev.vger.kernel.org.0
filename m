Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE2E0665D27
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 14:57:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232327AbjAKN5B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 08:57:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232824AbjAKN44 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 08:56:56 -0500
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F5682655
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 05:56:55 -0800 (PST)
Received: by mail-lf1-x135.google.com with SMTP id b3so23641295lfv.2
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 05:56:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=B5OwSRrShELMDRHw2AqTPEjqCDs2lQd6ByoCjom86lc=;
        b=BUp6f3y4KYEOUipcrcrb15l5HoLpgM66vNtQfw5gDsyHt9t1Pe68sa1KPYNaEJA7WC
         MbKnXqUJbhSOuhDFxM7zHdRPzrw9Bc35T+333hhKszVEsGqI6NcXSeQoLs2U9yyR+dfk
         3jmeBbCv3B0pwkH18XFg/xopPEX4vuYd4Nsy+zF2tj6Bq4Fd03+X0NQB6/Yy4oondfLN
         aYAG8ZQiWWBkda97Ad1vRMX1eZo0lMBd/tujdaOjK0C1DeuiHgUCUMU+0WVmznKeJjUN
         +Yq8a3brObVEIdM7oEbODDWSYDSgv0MsnIgDyg/fwkrFY9uCp10SrGsY77znNdncH0G6
         dj7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=B5OwSRrShELMDRHw2AqTPEjqCDs2lQd6ByoCjom86lc=;
        b=MZHsptVC9od32bb9le+6cXoaUM/Fo2NT0MJH9OixrI0vnsWErQPEZzTO2QUoVTGaOT
         cE91Sc5QKl240zC+N9udlFDhKtO0Y9MQGCMFy1QAbD0jcVWWr9UtEiPiXIFrxUWJrvz+
         r8Ix2VVIWJGCsYSB1ZHM10k17q4wQpl7GS3QInTAw36MaLzHN1QTIXRPASNgCSoL2l96
         nL3Ita1iPsZY9u8JR5rbvBG+i1qCh35/9fzxSz1zc6aSik5PiiTaqpuKj1ZY4YNqF+Hy
         YLwuX3x5XETCWDzwizJ6vUxLU3Ujbw31MlvJU50vAEI1q1xFHwgXVuyCuhUo8f9zR/yU
         UeWQ==
X-Gm-Message-State: AFqh2kohbdzMO4Ysg61DGBcQkQucp7Unv1BUA3vRM5onSmYMVj2yUKxl
        Co37LLw2KuZa3LA8vkk/g6uIRNK+/0UYARGgvtiyWg==
X-Google-Smtp-Source: AMrXdXtCxd6Nv2QgxP7EOBTb8lhUFCSQE1Ukv2LoL5yQFFKywuU8yWpkxXOR6l7NGB3j9zxYbviRuiN6CjodMeasJoI=
X-Received: by 2002:ac2:48ac:0:b0:4cb:4488:7d97 with SMTP id
 u12-20020ac248ac000000b004cb44887d97mr1277769lfg.447.1673445413510; Wed, 11
 Jan 2023 05:56:53 -0800 (PST)
MIME-Version: 1.0
References: <20230105214631.3939268-1-willy@infradead.org> <20230105214631.3939268-5-willy@infradead.org>
 <Y70vqm/HlRvqL2Uv@hera> <Y72yxN065TaMm0ua@casper.infradead.org>
In-Reply-To: <Y72yxN065TaMm0ua@casper.infradead.org>
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
Date:   Wed, 11 Jan 2023 15:56:17 +0200
Message-ID: <CAC_iWjK9nrvsL0sVrwdYsmqhiBXU-9WRZ4B+tGPtk+8qrkknQw@mail.gmail.com>
Subject: Re: [PATCH v2 04/24] page_pool: Convert page_pool_release_page() to page_pool_release_netmem()
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Jesper Dangaard Brouer <hawk@kernel.org>, netdev@vger.kernel.org,
        linux-mm@kvack.org, Shakeel Butt <shakeelb@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 10 Jan 2023 at 20:47, Matthew Wilcox <willy@infradead.org> wrote:
>
> On Tue, Jan 10, 2023 at 11:28:10AM +0200, Ilias Apalodimas wrote:
> > > -static inline void page_pool_release_page(struct page_pool *pool,
> > > -                                     struct page *page)
> > > +static inline void page_pool_release_netmem(struct page_pool *pool,
> > > +                                     struct netmem *nmem)
> > >  {
> > >  }
> > >
> > > @@ -378,6 +378,12 @@ static inline void page_pool_put_page_bulk(struct page_pool *pool, void **data,
> > >  }
> > >  #endif
> > >
> >
> > I think it's worth commenting here that page_pool_release_page() is
> > eventually going to be removed once we convert all drivers and shouldn't
> > be used anymore
>
> OK.  How about I add this to each function in this category:
>
> /* Compat, remove when all users gone */
>
> and then we can find them all by grepping for 'Compat'?

Yep that's fine

Thanks
/Ilias
