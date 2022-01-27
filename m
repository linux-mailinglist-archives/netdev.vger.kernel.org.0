Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5051249EF13
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 00:55:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243394AbiA0XzR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 18:55:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229658AbiA0XzQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 18:55:16 -0500
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0325FC061714
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 15:55:16 -0800 (PST)
Received: by mail-lj1-x232.google.com with SMTP id z7so6640572ljj.4
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 15:55:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tKITQprWMQWZ0S2MUC7tRxmK+x/kgvVxT0nwvaf2g9w=;
        b=KPmYzmzRT6bXluVgaktvlucF3KoJq7wUmoPcuzsB34JQ5jiFTcwXyJEfaanlP4N6Cg
         H+zONLTA7ZyQZz6lLVKuYW2cpwx8mOUSA6ZRZ4bZ5YzdliEUCc01gO8FBO7Jg07DYWZq
         7NMncrlzyCJ7Rmoe+ajt2Qcj83Z6WA0KFKc+Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tKITQprWMQWZ0S2MUC7tRxmK+x/kgvVxT0nwvaf2g9w=;
        b=0b0ODF5m5pFJDR/Nx/llbyIio931ssY05HiuVwfejnzIGEyr6CyBHUO1jodaJKP7DJ
         yT5HztMQOmtnVJITUqukTEOvAH7q/dfMF2qsbR/UTdZqns/9hETcSQmVpZZnmPHRJ8/v
         WVxMLVKcJu8k+XHJP1q49hpZfxxKHboo+fztwfs+5UUfUQtDZI3yxtPbUyLjpaGCujy5
         myDzc97Q3DY1zxnlixBPPkql7iYb3UkYv3ZrTJxGJJEMLb5Iz4xf++sPenbWFBGISBD6
         NmBt71oSGOKqBeKwo1cx/v46AKhldOAOqfJ9xxDcgDMTUXOZTrmQXhIN/av92Cg3ffki
         qunA==
X-Gm-Message-State: AOAM5301BWHvXEEgfazSFHdtZayg7T6jm3xeQC2c2f3ffPSz9pTGaspV
        zXt1bvNPRhQ0fUIeVmwdd+TQcCUQdSQR5Aj65fedIU1briQcdQ==
X-Google-Smtp-Source: ABdhPJy5tenH+Sj98OBjvBsfuo3zfNNr9q6E3JezuK9ILOu+DfCBzRX1baz+nznVZY057e4nIykLKwWCpBQLsPE+TTI=
X-Received: by 2002:a2e:bf0f:: with SMTP id c15mr4335780ljr.408.1643327714360;
 Thu, 27 Jan 2022 15:55:14 -0800 (PST)
MIME-Version: 1.0
References: <1643237300-44904-1-git-send-email-jdamato@fastly.com> <YfJhIpBGW6suBwkY@hades>
In-Reply-To: <YfJhIpBGW6suBwkY@hades>
From:   Joe Damato <jdamato@fastly.com>
Date:   Thu, 27 Jan 2022 15:55:03 -0800
Message-ID: <CALALjgyosP7GeMZgiQ3c=TXP=wBJeOC4GYV3PtKY544JbQ72Hg@mail.gmail.com>
Subject: Re: [PATCH net-next 0/6] net: page_pool: Add page_pool stat counters
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        hawk@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 27, 2022 at 1:08 AM Ilias Apalodimas
<ilias.apalodimas@linaro.org> wrote:
>
> Hi Joe,
>
> On Wed, Jan 26, 2022 at 02:48:14PM -0800, Joe Damato wrote:
> > Greetings:
> >
> > This series adds some stat counters for the page_pool allocation path which
> > help to track:
> >
> >       - fast path allocations
> >       - slow path order-0 allocations
> >       - slow path high order allocations
> >       - refills which failed due to an empty ptr ring, forcing a slow
> >         path allocation
> >       - allocations fulfilled via successful refill
> >       - pages which cannot be added to the cache because of numa mismatch
> >         (i.e. waived)
> >
>
> Thanks for the patch.  Stats are something that's indeed missing from the
> API.  The patch  should work for Rx based allocations (which is what you
> currently cover),  since the RX side is usually protected by NAPI.  However
> we've added a few features recently,  which we would like to have stats on.

Thanks for taking a look at the patch.

> commit 6a5bcd84e886("page_pool: Allow drivers to hint on SKB recycling"),
> introduces recycling capabilities on the API.  I think it would be far more
> interesting to be able to extend the statistics to recycled/non-recycled
> packets as well in the future.

I agree. Tracking recycling events would be both helpful and
interesting, indeed.

> But the recycling is asynchronous and we
> can't add locks just for the sake of accurate statistics.

Agreed.

> Can we instead
> convert that to a per-cpu structure for producers?

If my understanding of your proposal is accurate, moving the stats
structure to a per-cpu structure (instead of per-pool) would add
ambiguity as to the performance of a specific driver's page pool. In
exchange for the ambiguity, though, we'd get stats for additional
events, which could be interesting.

It seems like under load it might be very useful to know that a
particular driver's page pool is adding pressure to the buddy
allocator in the slow path. I suppose that a user could move softirqs
around on their system to alleviate some of the ambiguity and perhaps
that is good enough.







> Thanks!
> /Ilias
>
> > Some static inline wrappers are provided for accessing these stats. The
> > intention is that drivers which use the page_pool API can, if they choose,
> > use this stats API.
> >
> > It assumed that the API consumer will ensure the page_pool is not destroyed
> > during calls to the stats API.
> >
> > If this series is accepted, I'll submit a follow up patch which will export
> > these stats per RX-ring via ethtool in a driver which uses the page_pool
> > API.
> >
> > Joe Damato (6):
> >   net: page_pool: Add alloc stats and fast path stat
> >   net: page_pool: Add a stat for the slow alloc path
> >   net: page_pool: Add a high order alloc stat
> >   net: page_pool: Add stat tracking empty ring
> >   net: page_pool: Add stat tracking cache refills.
> >   net: page_pool: Add a stat tracking waived pages.
> >
> >  include/net/page_pool.h | 82 +++++++++++++++++++++++++++++++++++++++++++++++++
> >  net/core/page_pool.c    | 15 +++++++--
> >  2 files changed, 94 insertions(+), 3 deletions(-)
> >
> > --
> > 2.7.4
> >
