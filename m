Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE69449ED3B
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 22:11:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344243AbiA0VL4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 16:11:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344232AbiA0VLz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 16:11:55 -0500
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A29D3C061714
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 13:11:54 -0800 (PST)
Received: by mail-lj1-x231.google.com with SMTP id t7so6130500ljc.10
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 13:11:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3NP886naQFIZy4hOu+mozQZtAsGAiRcomA5EwVdDex0=;
        b=UZghS5AveaGm/Vu5fU6iApb7RjqrZ40IVW6Oej1MhNJSMEiWO9C/lKr/Miy5nWpQJU
         xBRL/MBrh2m+Qu/6YBSWyGM47LEsIg15PloDskbBmafn35+tYrmAGsfmGzTXfKVAwoLw
         z88gcuJMAUYlLoohFNt1BTiPwgHih9PwtmCJ4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3NP886naQFIZy4hOu+mozQZtAsGAiRcomA5EwVdDex0=;
        b=CSo/4CCMyStWaIOPgoTQFaloXtMvKstx6bY3YC7/SixjjN+OUA0CEB1aWbSsWUnR3U
         OGMaJMbYYvA0InRjSXgiolxH4cBjorRDPEI7v29NDe1P6AdBYEjyd0Tkxg2av5kxgAbx
         yyktJQKnZEWatpikEdyjFDPsuXNPxlYin8QbFlUWLEOzrzb8P9OqgY3OBkxejwGF0O6z
         XGAzn+yZaHjhcz0/8eCm6efJdQvQDPjm4B0yGcuvqhrYzbOJxUbkLUslDywWGmzCwQLj
         zI7j6jQq5OuN4p82QdeZqrcDRj+9END5X719+OvGt3JMtVdOq17Uf1ymGQdgMqQmU+TW
         Knsw==
X-Gm-Message-State: AOAM530r4/3cTE1SDPQw5l6KRMIh1a5yltzxAeDFYRR+Y1e/IGhMS6fc
        V+we8UqM06PScXz8CLehowpsvBA5vhHcElSxSIwtEw==
X-Google-Smtp-Source: ABdhPJzg1X4GMR7jqcIPVHu84LASSmK09+KkawNVByetcdYF7Ys7J0wWnMh6xRRjkSuooNbIhaoeJA2TUHNcAVAIG6c=
X-Received: by 2002:a2e:8756:: with SMTP id q22mr3819475ljj.93.1643317913014;
 Thu, 27 Jan 2022 13:11:53 -0800 (PST)
MIME-Version: 1.0
References: <1643237300-44904-1-git-send-email-jdamato@fastly.com>
 <1643237300-44904-2-git-send-email-jdamato@fastly.com> <20220127083214.39b80c20@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220127083214.39b80c20@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Joe Damato <jdamato@fastly.com>
Date:   Thu, 27 Jan 2022 13:11:42 -0800
Message-ID: <CALALjgy7MiubHg2TTqMpTeLtZ2bs9iFc1HRs4Rzy2B9252qyUQ@mail.gmail.com>
Subject: Re: [PATCH 1/6] net: page_pool: Add alloc stats and fast path stat
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        ilias.apalodimas@linaro.org, hawk@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 27, 2022 at 8:32 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed, 26 Jan 2022 14:48:15 -0800 Joe Damato wrote:
> > Add a stats structure with a an internal alloc structure for holding
> > allocation path related stats.
> >
> > The alloc structure contains the stat 'fast'. This stat tracks fast
> > path allocations.
> >
> > A static inline accessor function is exposed for accessing this stat.
>
> > +/**
> > + * stats for tracking page_pool events.
> > + *
> > + * accessor functions for these stats provided below.
> > + *
> > + * Note that it is the responsibility of the API consumer to ensure that
> > + * the page_pool has not been destroyed while accessing stats fields.
> > + */
> > +struct page_pool_stats {
> > +     struct {
> > +             u64 fast; /* fast path allocations */
> > +     } alloc;
> > +};
>
> scripts/kernel-doc says:
>
> include/net/page_pool.h:75: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
>  * stats for tracking page_pool events.

Thank you. I had only been running scripts/checkpatch, but will
remember to also run kernel-doc in the future. I will correct the
comments in the v2.
