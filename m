Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A5E95F2177
	for <lists+netdev@lfdr.de>; Sun,  2 Oct 2022 07:46:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229529AbiJBFid (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Oct 2022 01:38:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiJBFic (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Oct 2022 01:38:32 -0400
Received: from 1wt.eu (wtarreau.pck.nerim.net [62.212.114.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 16A57326C1
        for <netdev@vger.kernel.org>; Sat,  1 Oct 2022 22:38:29 -0700 (PDT)
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 2925cCTs019070;
        Sun, 2 Oct 2022 07:38:12 +0200
Date:   Sun, 2 Oct 2022 07:38:12 +0200
From:   Willy Tarreau <w@1wt.eu>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: Re: [PATCH net-next] once: add DO_ONCE_SLOW() for sleepable contexts
Message-ID: <20221002053812.GA18978@1wt.eu>
References: <20221001205102.2319658-1-eric.dumazet@gmail.com>
 <20221001211529.GC15441@1wt.eu>
 <YzjEPq6owOKBACj3@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YzjEPq6owOKBACj3@zx2c4.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 02, 2022 at 12:50:38AM +0200, Jason A. Donenfeld wrote:
> > > This patch adds DO_ONCE_SLOW() which uses a mutex instead of a spinlock
> > > for operations where we prefer to stay in process context.
> > 
> > That's a nice improvement I think. I was wondering if, for this special
> > case, we *really* need an exclusive DO_ONCE(). I mean, we're getting
> > random bytes, we really do not care if two CPUs change them in parallel
> > provided that none uses them before the table is entirely filled. Thus
> > that could probably end up as something like:
> > 
> >     if (!atomic_read(&done)) {
> >         get_random_bytes(array);
> >         atomic_set(&done, 1);
> >     }
> 
> If you don't care about the tables being consistent between CPUs, then
> yea, sure, that seems like a reasonable approach, and I like not
> polluting once.{c,h} with some _SLOW() special cases.

I don't see this as pollution, it possibly is a nice addition for certain
use cases or early fast paths where the risk of contention is high.

> If you don't want
> the atomic read in there you could also do the same pattern with a
> static branch, like what DO_ONCE() does:
> 
>    if (static_branch_unlikely(&need_bytes)) {
>       get_random_bytes(array);
>       static_branch_disable(&need_bytes);
>    }
> 
> Anyway, same thing as your suggestion more or less.

What I don't know in fact is if the code patching itself can be
responsible for a measurable part of the extra time Christophe noticed.
Anyway at least Christophe now has a few approaches to try, let's first
see if any of them fixes the regression.

Willy
