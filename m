Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 401F9276AC7
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 09:30:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727089AbgIXHaW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 03:30:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726655AbgIXHaV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 03:30:21 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98ABAC0613CE;
        Thu, 24 Sep 2020 00:30:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=XgcGJ4sjIBTMAlJ2aTWqRW+QA3vpY8W+uIP1Muzktyc=; b=S1BVR9KRk5gwMpGsS4TSkkHnYV
        GDdeP+4hzqnOLjmkgTQF3vDuegYsLCixunemrnJ8KmIxgsRHnP6pob4AX3L/eUO6stS//0ww54+he
        2hpf9yMmqGDJwm8+OnURJ8c8auXCyRm99AOuuUnnsxtlsEoOsFiJyjBLqFZpO36BK8CqjmZMK9Tlx
        dZqKOsjIwjGlyvpyLH0+gZhlhpAWGbdMIMAURyV8BGEHMk6c+1ExazZEo0eooHv4MUcfj1iqUSxcO
        u0jL061DHP2DkQXaofjA1MUvSXt8c0zPc4LpbLUKBiXf/EPDqGD0Qm1Pf70N9PNSwEQYHTZXQhJtm
        fudIAkVA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kLLhe-00064O-Bp; Thu, 24 Sep 2020 07:30:06 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id EB37D300455;
        Thu, 24 Sep 2020 09:30:03 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id AA1F82BC0B6AD; Thu, 24 Sep 2020 09:30:03 +0200 (CEST)
Date:   Thu, 24 Sep 2020 09:30:03 +0200
From:   peterz@infradead.org
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        syzbot <syzbot+c32502fd255cb3a44048@syzkaller.appspotmail.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>
Subject: Re: possible deadlock in xfrm_policy_delete
Message-ID: <20200924073003.GZ1362448@hirez.programming.kicks-ass.net>
References: <00000000000056c1dc05afc47ddb@google.com>
 <20200924043554.GA9443@gondor.apana.org.au>
 <CACT4Y+aw+Z_7JwDiu65hL7K99f1oBfRFavZz4Pr4o8Us5peH4g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACT4Y+aw+Z_7JwDiu65hL7K99f1oBfRFavZz4Pr4o8Us5peH4g@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 24, 2020 at 06:44:12AM +0200, Dmitry Vyukov wrote:
> On Thu, Sep 24, 2020 at 6:36 AM Herbert Xu <herbert@gondor.apana.org.au> wrote:
> > >  (k-slock-AF_INET6){+.-.}-{2:2}

That's a seqlock.

> > What's going on with all these bogus lockdep reports?
> >
> > These are two completely different locks, one is for TCP and the
> > other is for SCTP.  Why is lockdep suddenly beoming confused about
> > this?
> >
> > FWIW this flood of bogus reports started on 16/Sep.
> 
> 
> FWIW one of the dups of this issue was bisected to:
> 
> commit 1909760f5fc3f123e47b4e24e0ccdc0fc8f3f106
> Author: Ahmed S. Darwish <a.darwish@linutronix.de>
> Date:   Fri Sep 4 15:32:31 2020 +0000
> 
>     seqlock: PREEMPT_RT: Do not starve seqlock_t writers
> 
> Can it be related?

Did that tree you're testing include 267580db047e ("seqlock: Unbreak
lockdep") ?
