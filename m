Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BAC367D074
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 16:41:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231790AbjAZPla (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 10:41:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231772AbjAZPl3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 10:41:29 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 722E0BBB2;
        Thu, 26 Jan 2023 07:41:28 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id 144so1329779pfv.11;
        Thu, 26 Jan 2023 07:41:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=XCvmcIdx5fdw1GMACTpaHQZ+1idkf4hZRVy6p1RcIBI=;
        b=KZYDwoZIXjGgE9UALUiQKATfOd+wQi76zL1H/ULsvTysQHrMDMU/niY0YvskfWPLYY
         0MizNYhvKu8uezGLTbiWK943n5j3jATXIiXH5HNDA7nO/d6l8lhBTscMMWa7QeboeQix
         992Xgopik16kalunNJ1mEcofUDJ9Hw6U9s0hZMD1AeKPAnmEYg6GsxouE5mAMsmNeCYG
         rdK7Tn1E6z+zy+ckqgUZGXuUsKTHdPRuyTUF9tKoaRKDd8l1rcqlgcvTREb8Wu/4DwYd
         k7HzsX/g1Ol6K+YK58frHFQp0AvHoK/zc28cYfRyz3C2X41E/YJze4a3wjeR3gM/lQ98
         9QtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XCvmcIdx5fdw1GMACTpaHQZ+1idkf4hZRVy6p1RcIBI=;
        b=OGrQZdoRKfvTPgOvLA3rqrDg1Aq8fGfzV3SAEGUFydWrTwu/DwovKxIWhkbDkMcxD2
         Y24PFz2Qhw2MTfb1X3cQ6UeDcE68c6ei8ZQcOgIr2C8JgFxJP3xp/WDxf+J+tqpaa4vF
         LgkD5kBUZgAOrycA+f9S3rD1gORuLKVoZN83xLlY2JwveqItgew4d4q52lWJ4WhFm+hU
         fLBl+w/HDKClQsHX0nUX6IEzxGONuVZ820oH4/JN5Fe83EK6n4amtdF4ZGeHMW/oTn1z
         gQ5+VPwxRFZZyueE14w1qow6pKa8wO4IrbRnj3XMcNhdo+btwlUCh2JkrcPp38/5kkHk
         hNyw==
X-Gm-Message-State: AFqh2koLeMtNOIjFtjjCHOnBvT/apLGEG0ije0jNMgIxoHb+uxN5BD+m
        BnfYVSBDNTcpwfDxT8aRJ/PANWtyopjt7FUOH6g=
X-Google-Smtp-Source: AMrXdXtliXm3qzAp1OySrCcvqud74fmyNDG9AbhmGesljHKBoYTLfnE8wGN7/QgFaWM3aVqRn+0Lc45/LKTb8uNxB6Y=
X-Received: by 2002:a63:f402:0:b0:480:5a43:293d with SMTP id
 g2-20020a63f402000000b004805a43293dmr3970815pgi.9.1674747687656; Thu, 26 Jan
 2023 07:41:27 -0800 (PST)
MIME-Version: 1.0
References: <20230124124300.94886-1-nbd@nbd.name> <CAC_iWjKAEgUB8Z3WNNVgUK8omXD+nwt_VPSVyFn1i4EQzJadog@mail.gmail.com>
 <f3d079ce930895475f307de3fdaed0b85b4f2671.camel@gmail.com> <Y9JWniFQmcc7m5Ey@hera>
In-Reply-To: <Y9JWniFQmcc7m5Ey@hera>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Thu, 26 Jan 2023 07:41:15 -0800
Message-ID: <CAKgT0UcSD5N7A4Bu1V3ue_+RVfiMqN+e8TQwn0FtAL_sXE3bkA@mail.gmail.com>
Subject: Re: [PATCH] net: page_pool: fix refcounting issues with fragmented allocation
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     Felix Fietkau <nbd@nbd.name>, netdev@vger.kernel.org,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        linux-kernel@vger.kernel.org, Yunsheng Lin <linyunsheng@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 26, 2023 at 2:32 AM Ilias Apalodimas
<ilias.apalodimas@linaro.org> wrote:
>
> Hi Alexander,
>
> Sorry for being late to the party,  was overloaded...
>
> On Tue, Jan 24, 2023 at 07:57:35AM -0800, Alexander H Duyck wrote:
> > On Tue, 2023-01-24 at 16:11 +0200, Ilias Apalodimas wrote:
> > > Hi Felix,
> > >
> > > ++cc Alexander and Yunsheng.
> > >
> > > Thanks for the report
> > >
> > > On Tue, 24 Jan 2023 at 14:43, Felix Fietkau <nbd@nbd.name> wrote:
> > > >
> > > > While testing fragmented page_pool allocation in the mt76 driver, I was able
> > > > to reliably trigger page refcount underflow issues, which did not occur with
> > > > full-page page_pool allocation.
> > > > It appears to me, that handling refcounting in two separate counters
> > > > (page->pp_frag_count and page refcount) is racy when page refcount gets
> > > > incremented by code dealing with skb fragments directly, and
> > > > page_pool_return_skb_page is called multiple times for the same fragment.
> > > >
> > > > Dropping page->pp_frag_count and relying entirely on the page refcount makes
> > > > these underflow issues and crashes go away.
> > > >
> > >
> > > This has been discussed here [1].  TL;DR changing this to page
> > > refcount might blow up in other colorful ways.  Can we look closer and
> > > figure out why the underflow happens?
> > >
> > > [1] https://lore.kernel.org/netdev/1625903002-31619-4-git-send-email-linyunsheng@huawei.com/
> > >
> > > Thanks
> > > /Ilias
> > >
> > >
> >
> > The logic should be safe in terms of the page pool itself as it should
> > be holding one reference to the page while the pp_frag_count is non-
> > zero. That one reference is what keeps the two halfs in sync as the
> > page shouldn't be able to be freed until we exhaust the pp_frag_count.
>
> Do you remember why we decided to go with the fragment counter instead of
> page references?

The issue has to do with when to destroy the mappings. Basically with
the fragment counter we destroy the mappings and remove the page from
the pool when the count hits 0. The reference count is really used for
the page allocator to do its tracking. If we end up trying to merge
the two the problem becomes one of lifetimes as we wouldn't know when
to destroy the DMA mappings as they would have to live the full life
of the page.

> >
> > To have an underflow there are two possible scenarios. One is that
> > either put_page or free_page is being called somewhere that the
> > page_pool freeing functions should be used.
>
> Wouldn't that affect the non fragmented path as well? IOW the driver that
> works with a full page would crash as well.

The problem is the non-fragmented path doesn't get as noisy. Also
there aren't currently any wireless drivers making use of the page
pool, or at least that is my understanding. I'm suspecting something
like the issue we saw in 1effe8ca4e34c ("skbuff: fix coalescing for
page_pool fragment recycling"). We likely have some corner case where
we should be taking a page reference and clearing a pp_recycle flag.
