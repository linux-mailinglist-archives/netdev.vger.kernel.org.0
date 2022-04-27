Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81EB051204D
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 20:38:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242079AbiD0Q2W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 12:28:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243186AbiD0Q1h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 12:27:37 -0400
Received: from 1wt.eu (wtarreau.pck.nerim.net [62.212.114.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 009BF41FB5;
        Wed, 27 Apr 2022 09:22:12 -0700 (PDT)
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 23RGLwSQ003715;
        Wed, 27 Apr 2022 18:21:58 +0200
Date:   Wed, 27 Apr 2022 18:21:58 +0200
From:   Willy Tarreau <w@1wt.eu>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Moshe Kol <moshe.kol@mail.huji.ac.il>,
        Yossi Gilad <yossi.gilad@mail.huji.ac.il>,
        Amit Klein <aksecurity@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 3/7] tcp: resalt the secret every 10 seconds
Message-ID: <20220427162158.GC3488@1wt.eu>
References: <20220427065233.2075-1-w@1wt.eu>
 <20220427065233.2075-4-w@1wt.eu>
 <20220427085621.5f2d1759@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220427085621.5f2d1759@hermes.local>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Stephen,

On Wed, Apr 27, 2022 at 08:56:21AM -0700, Stephen Hemminger wrote:
> On Wed, 27 Apr 2022 08:52:29 +0200
> Willy Tarreau <w@1wt.eu> wrote:
> 
> > From: Eric Dumazet <edumazet@google.com>
> > 
> > In order to limit the ability for an observer to recognize the source
> > ports sequence used to contact a set of destinations, we should
> > periodically shuffle the secret. 10 seconds looks effective enough
> > without causing particular issues.
> > 
> > Cc: Moshe Kol <moshe.kol@mail.huji.ac.il>
> > Cc: Yossi Gilad <yossi.gilad@mail.huji.ac.il>
> > Cc: Amit Klein <aksecurity@gmail.com>
> > Tested-by: Willy Tarreau <w@1wt.eu>
> > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > ---
> >  net/core/secure_seq.c | 12 +++++++++---
> >  1 file changed, 9 insertions(+), 3 deletions(-)
> > 
> > diff --git a/net/core/secure_seq.c b/net/core/secure_seq.c
> > index 2cdd43a63f64..200ab4686275 100644
> > --- a/net/core/secure_seq.c
> > +++ b/net/core/secure_seq.c
> > @@ -22,6 +22,8 @@
> >  static siphash_aligned_key_t net_secret;
> >  static siphash_aligned_key_t ts_secret;
> >  
> 
> Rather than hard coding, why not have a sysctl knob for this?
> That way the tinfoil types can set it smaller.

It's a legit question. First I think that there's no good value; before
it used to be infinite, and now we're trying to figure a reasonable value
that make the attack impractical without going too close to the risk of
occasionally failing to establish a connection. I'm really not convinced
that there's any benefit in fiddling with that, except for breaking one's
stack by resalting too often and complaining about stupid network issues
with ACK or RST being sent in response to a SYN.

And stupidly, dividing jiffies by a constant known at build time is
slightly cheaper than dividing by a variable. I know it's a detail but
we tried hard to limit the accumulation of details here :-/

Just my two cents,
Willy
