Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66B712E0D1F
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 17:14:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727719AbgLVQNV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 11:13:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727628AbgLVQNU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Dec 2020 11:13:20 -0500
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81E35C0613D6
        for <netdev@vger.kernel.org>; Tue, 22 Dec 2020 08:12:40 -0800 (PST)
Received: by mail-io1-xd31.google.com with SMTP id 81so12400355ioc.13
        for <netdev@vger.kernel.org>; Tue, 22 Dec 2020 08:12:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=njGlXLtRwielxtlKtHoN0vNxunsd02VjgOVbDtsTLkw=;
        b=dn6eHmwnqPMSXPIwlarnk7uXiPAPDWrZOzg9C4jQ8omAuizTUuU8vCLnBPQWXNsVy5
         1dpsie+9js8dg+7SpmRkLkcfWse15WudB/0WagvMEcJb+7j8Y4OJPE6yX8Q/wAdhL4mZ
         8MJQhlPIt/txTywQDrnbqm3/pFmgVDaImF9OS6qcv2j8DG94PjL/DRCdXS8BSkGAmbgN
         MdreiI5Fg5+teiBVAxiY+H+C1Tep0ut+zFBPTER6sa7k0ZU0Z+Ib+KSccNY01FZnfcAr
         rPPJBcjUSr4Mw1DRZnRiKxI7Wv9tmCcC6i514Btwbk/4fEa7qq6YxUAwLy655NwjjVQX
         a23w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=njGlXLtRwielxtlKtHoN0vNxunsd02VjgOVbDtsTLkw=;
        b=Thc90fmsT4uPfHZTmDBbSKeHFgdrifwdg9Jf5nktrCQTuDqjMi3GIT6zY4x2sXf8Hc
         c3OI729hSKVz0lbAh6jgPsNE6LM3ksr65PKIjZ8RjIS+qY2xXl8lAU+zRGbyEj33NLTW
         OgSmRy8Oa+N2JbmvkG3F8kF9xzsqllDmF0k7wi1dvAo6AXluYiNvotTrU2xQsLZQbwP0
         PdaE8Er/HhF/bhmhhOaP7YWSrIJrpBqDNfO2Koo+u+DwWBU1Sv7qYKjLiFCb1TXZenFM
         XVGXDQ3xPgM0ZfWMvbIZ7ytciTxXgUDbugunrvrbsNs46wTB2hRuxu/J5UoO6ohbGK3r
         qdKA==
X-Gm-Message-State: AOAM533qOvJLDxO0T5r1qg1q+w1n+GGg83BPy2tTnR2BD9pd39zLS7HI
        aTHeSmNLBQnCsbU6xEPPhzg1dixKwvAQ1ZlpdGg=
X-Google-Smtp-Source: ABdhPJxSn3S7ZI8tS57H0NWxGrwVVAGT2UNyti2EpmfrwEzb5f2mPeylacplg7FGOjKXEJcDexQg7Lb22NMcS859it4=
X-Received: by 2002:a05:6602:150b:: with SMTP id g11mr18350594iow.88.1608653559857;
 Tue, 22 Dec 2020 08:12:39 -0800 (PST)
MIME-Version: 1.0
References: <20201221193644.1296933-1-atenart@kernel.org> <20201221193644.1296933-2-atenart@kernel.org>
 <CAKgT0UfTgYhED1f6vdsoT72A3=D2Grh4U-A6pp43FLZoCs30Gw@mail.gmail.com> <160862887909.1246462.8442420561350999328@kwain.local>
In-Reply-To: <160862887909.1246462.8442420561350999328@kwain.local>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Tue, 22 Dec 2020 08:12:28 -0800
Message-ID: <CAKgT0UfzNA8qk+QFTN6ihXTxZkcE=vfrjBtyHKL6_9Yyzxt=eQ@mail.gmail.com>
Subject: Re: [PATCH net v2 1/3] net: fix race conditions in xps by locking the
 maps and dev->tc_num
To:     Antoine Tenart <atenart@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Netdev <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 22, 2020 at 1:21 AM Antoine Tenart <atenart@kernel.org> wrote:
>
> Hello Alexander, Jakub,
>
> Quoting Alexander Duyck (2020-12-22 00:21:57)
> >
> > Looking over this patch it seems kind of obvious that extending the
> > xps_map_mutex is making things far more complex then they need to be.
> >
> > Applying the rtnl_mutex would probably be much simpler. Although as I
> > think you have already discovered we need to apply it to the store,
> > and show for this interface. In addition we probably need to perform
> > similar locking around traffic_class_show in order to prevent it from
> > generating a similar error.
>
> I don't think we have the same kind of issues with traffic_class_show:
> dev->num_tc is used, but not for navigating through the map. Protecting
> only a single read wouldn't change much. We can still think about what
> could go wrong here without the lock, but that is not related to this
> series of fixes.

The problem is we are actually reading the netdev, tx queue, and
tc_to_txq mapping. Basically we have several different items that we
are accessing at the same time. If any one is updated while we are
doing it then it will throw things off.

> If I understood correctly, as things are a bit too complex now, you
> would prefer that we go for the solution proposed in v1?

Yeah, that is what I am thinking. Basically we just need to make sure
the num_tc cannot be updated while we are reading the other values.

> I can still do the code factoring for the 2 sysfs show operations, but
> that would then target net-next and would be in a different series. So I
> believe we'll use the patches of v1, unmodified.

I agree the code factoring would be better targeted to net-next.

The rtnl_lock approach from v1 would work for net and for backports.

> Jakub, should I send a v3 then?
>
> Thanks!
> Antoine
