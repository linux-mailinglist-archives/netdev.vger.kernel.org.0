Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 216C22F710C
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 04:40:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728940AbhAODjl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 22:39:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726311AbhAODjk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 22:39:40 -0500
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88A30C061575
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 19:39:00 -0800 (PST)
Received: by mail-io1-xd30.google.com with SMTP id e22so15665926iom.5
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 19:39:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ToUJsMwDBuaHsW9Gv8sF8Wp8m3cG4OGDxZ84C52QhTg=;
        b=KvgZmNvYDisXkuSSUUTLi9XhFpXPFUBzQP94gBKHNsxjqdfyovIuBak325cfLGlxvM
         dLv/2FlC9zcz+iHNNJRsbvndDGctlkImuZpDLIbQ4GyzgumC9RUJXN9e1LQsumkG82tH
         xFiO5jcEqZEQbUKtJ6PQsAnpk6kuxqgyNgh4NILgYDi0bYlDoUWQaYRbAl0HEfLlBerT
         0XXYVSarwv7hcGOsIse+4xEHFdeZiTQDC+tDzq05h8ElH3zsT+scOTm6k8MU3NQ1WYzD
         1Ysuj4zeEL0EGRtXfzDfZGs5jkc9D7NVH2wbmCYi5IEpjqJAVz15elBmbewgptbI4VPW
         +wdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ToUJsMwDBuaHsW9Gv8sF8Wp8m3cG4OGDxZ84C52QhTg=;
        b=gbtgtM8l8kq/S8k5a6Dfaa8KlUgXxk40GVOkf23pugsvg+qeL/95If6Lb5QMC4MqIL
         C7+qqXtm1IAhq/sbtHwOlc4GswL2zcbpp9IyuXzO2F2f9NqFNQBP8QS5KGERuBl5iBq4
         pU4tqTMx1g4dU59nGXBHTMqYGTsvp/oG5tiaIRXp30iyoKH3tJ/sCM6yL3FwQj4zh9Pd
         SKGO3BNkyADFprc9n1unq7UgIjr8YP9fZXrsxkieo8zmFiKFk39GW8lXIdggmZkIj040
         BD5Epqazl6SpOZtpDh8g50r0jhErXt1xJkjp3NssIzEHYud3UuanMm3S+LnHbxG9GTlk
         8zkA==
X-Gm-Message-State: AOAM531cnYVZqhy92W6J2P7yL5ihI3b+vBmHdcDh0Cs9M+EF9gb6D/zU
        sod+4CUMXpDzWHcFhE2LRsXuk5wNK9vNiAVzXRg=
X-Google-Smtp-Source: ABdhPJx/Bdwz7tTtP4cyJHfBEa/AYK5NdTPYk/LIz48SVXOhUT8T0ylHN1ynlFfwhE8DzIz+vfk5PgYKMCtLPeuAUl0=
X-Received: by 2002:a92:d210:: with SMTP id y16mr9245356ily.97.1610681939931;
 Thu, 14 Jan 2021 19:38:59 -0800 (PST)
MIME-Version: 1.0
References: <20210115003123.1254314-1-weiwan@google.com> <20210115003123.1254314-3-weiwan@google.com>
 <CAKgT0UdiBnLiGP=C0XKTpv-_Z-UTGSfkwtL-2QzHZS3AEkMbnA@mail.gmail.com>
In-Reply-To: <CAKgT0UdiBnLiGP=C0XKTpv-_Z-UTGSfkwtL-2QzHZS3AEkMbnA@mail.gmail.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Thu, 14 Jan 2021 19:38:49 -0800
Message-ID: <CAKgT0UeP2YWwim1QELj_6mp1R7HGPgtwcd_xruAZAmJk9ivR9A@mail.gmail.com>
Subject: Re: [PATCH net-next v6 2/3] net: implement threaded-able napi poll
 loop support
To:     Wei Wang <weiwan@google.com>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Felix Fietkau <nbd@nbd.name>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 14, 2021 at 7:14 PM Alexander Duyck
<alexander.duyck@gmail.com> wrote:
>
> On Thu, Jan 14, 2021 at 4:33 PM Wei Wang <weiwan@google.com> wrote:
> >

<snip>

> > +void napi_enable(struct napi_struct *n)
> > +{
> > +       BUG_ON(!test_bit(NAPI_STATE_SCHED, &n->state));
> > +       smp_mb__before_atomic();
> > +       clear_bit(NAPI_STATE_SCHED, &n->state);
> > +       clear_bit(NAPI_STATE_NPSVC, &n->state);
> > +       WARN_ON(napi_set_threaded(n, n->dev->threaded));
>
> I am not sure what the point is in having a return value if you are
> just using it to trigger a WARN_ON. It might make more sense to
> actually set the WARN_ON inside of napi_set_threaded instead of having
> it here as you could then identify the error much more easily. Or for
> that matter you might be able to use something like pr_warn which
> would allow you a more detailed message about the specific netdev that
> experienced the failure.

One additional change I would make here. The call to napi_set_threaded
should be moved to before the smp_mb__before_atomic(). That way we can
guarantee that the threaded flag and task_struct pointer are visible
to all consumers before they can set NAPI_STATE_SCHED. Otherwise I
think we run the risk of a race where a napi request could fire before
we have finished configuring it.
