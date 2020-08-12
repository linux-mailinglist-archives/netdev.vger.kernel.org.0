Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B054242688
	for <lists+netdev@lfdr.de>; Wed, 12 Aug 2020 10:04:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726640AbgHLIE0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Aug 2020 04:04:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726479AbgHLIE0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Aug 2020 04:04:26 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FB2AC06174A
        for <netdev@vger.kernel.org>; Wed, 12 Aug 2020 01:04:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=BP0FbEDD5JLr1aVqV7cCA/oiA/OSo3ceveVnWn36bE0=; b=AD5pXusq3pLnJgtOMNWK15q+G2
        dks0uOj5VULS9sBV/iBPVnzDRlAupKbgTQDeNdF+7Bn2BYwy7BrBIm44UbYkZDsGjlcG+Ds99dJLc
        X2dtWxKxhK/ouIjmcfSUyMIh5avpKbp/4z6NfcCFJv87+5LaPFw1kRmCEqljfOfsur7CXNiL8z32B
        l0/f/0jfbGLiZFLxYsyQyO3ON8snV7IjBiqY0vbJO+6LkEbHxViJVhpONO+GTZmb41b/j2hOHRyJV
        vC08otfYMq0iuMgryw45dLdG9LWqTZV+FZ84BFsk2yViX2UYnCMoaLniN52k4fj2dqe0x2U2HW04Q
        7w0UOeug==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k5lhQ-0000uv-Mj; Wed, 12 Aug 2020 08:01:51 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id CB9D3300DAE;
        Wed, 12 Aug 2020 10:00:49 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 872F7220F91A1; Wed, 12 Aug 2020 10:00:49 +0200 (CEST)
Date:   Wed, 12 Aug 2020 10:00:49 +0200
From:   peterz@infradead.org
To:     Maciej =?utf-8?Q?=C5=BBenczykowski?= <maze@google.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Alex Belits <abelits@marvell.com>,
        Nitesh Narayan Lal <nitesh@redhat.com>
Subject: Re: [PATCH net] net: accept an empty mask in
 /sys/class/net/*/queues/rx-*/rps_cpus
Message-ID: <20200812080049.GH2674@hirez.programming.kicks-ass.net>
References: <20200812013440.851707-1-edumazet@google.com>
 <CANP3RGc6Gz73Gt3v9M7KYNeNd57o--=3mF6yqdRjqOViG+TG7A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANP3RGc6Gz73Gt3v9M7KYNeNd57o--=3mF6yqdRjqOViG+TG7A@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 11, 2020 at 06:45:23PM -0700, Maciej Żenczykowski wrote:
> On Tue, Aug 11, 2020 at 6:34 PM Eric Dumazet <edumazet@google.com> wrote:
> 
> > We must accept an empty mask in store_rps_map(), or we are not able
> > to disable RPS on a queue.
> >
> > Fixes: 07bbecb34106 ("net: Restrict receive packets queuing to
> > housekeeping CPUs")
> > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > Reported-by: Maciej Żenczykowski <maze@google.com>
> > Cc: Alex Belits <abelits@marvell.com>
> > Cc: Nitesh Narayan Lal <nitesh@redhat.com>
> > Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
> > ---
> >  net/core/net-sysfs.c | 12 +++++++-----
> >  1 file changed, 7 insertions(+), 5 deletions(-)
> >
> > diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
> > index
> > 9de33b594ff2693c054022a42703c90084122444..efec66fa78b70b2fe5b0a5920317eb1d0415d9e3
> > 100644
> > --- a/net/core/net-sysfs.c
> > +++ b/net/core/net-sysfs.c
> > @@ -757,11 +757,13 @@ static ssize_t store_rps_map(struct netdev_rx_queue
> > *queue,
> >                 return err;
> >         }
> >
> > -       hk_flags = HK_FLAG_DOMAIN | HK_FLAG_WQ;
> > -       cpumask_and(mask, mask, housekeeping_cpumask(hk_flags));
> > -       if (cpumask_empty(mask)) {
> > -               free_cpumask_var(mask);
> > -               return -EINVAL;
> > +       if (!cpumask_empty(mask)) {
> > +               hk_flags = HK_FLAG_DOMAIN | HK_FLAG_WQ;
> > +               cpumask_and(mask, mask, housekeeping_cpumask(hk_flags));
> > +               if (cpumask_empty(mask)) {
> > +                       free_cpumask_var(mask);
> > +                       return -EINVAL;
> > +               }
> >         }

Ah indeed! Sorry about that.

Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
