Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7AB951DD8D
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 18:24:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1443758AbiEFQ16 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 12:27:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348275AbiEFQ15 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 12:27:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB9106EB10;
        Fri,  6 May 2022 09:24:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7A28B61FB9;
        Fri,  6 May 2022 16:24:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83FA7C385A9;
        Fri,  6 May 2022 16:24:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651854252;
        bh=wTXEscK9VBgHJe/fSlna6PK3W41cFBchYyGv8z2pebI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=p1nOCalow/2RQwbMhADcIJBXbNSSDpU7ndJNAMZ+LklR/Ytf/Yk8pOkxXuDGMp4eM
         gP2IUNDuWrQDJb0PLMNEvLoS/S6s8wMtxFlY+CoM4fPh9Jj1IXCgNO8Jkag6TSHmBa
         xWR+wwShhvXYY//Xbqo66sdDofowm73XFvChIPGNVTdVFrxxindXpSnUZzl2YSA1F0
         zdx38UmAW5uz5fs28TZqPNUoB8EdnjkSQSIyZd/EkmSTH9p3tKp3VxzP0a9bIkcE5A
         xTDo+H5OW7Us7vTESTUfLA26MTpoN7foivQz7ZYTonrPvGF7OyssneL1TKFtDBEomH
         iIr1h9KZs2ExQ==
Date:   Fri, 6 May 2022 09:24:10 -0700
From:   Josh Poimboeuf <jpoimboe@kernel.org>
To:     Artem Savkov <asavkov@redhat.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Anna-Maria Behnsen <anna-maria@linutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 2/2] net: make tcp keepalive timer upper bound
Message-ID: <20220506162410.b5wkq4ybsiut4rzu@treble>
References: <87zgkwjtq2.ffs@tglx>
 <20220505131811.3744503-1-asavkov@redhat.com>
 <20220505131811.3744503-3-asavkov@redhat.com>
 <20220505175654.jhu3zldboxdcjifr@treble>
 <YnTCjFE2+/JEgglV@samus.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YnTCjFE2+/JEgglV@samus.usersys.redhat.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 06, 2022 at 08:39:08AM +0200, Artem Savkov wrote:
> On Thu, May 05, 2022 at 10:56:54AM -0700, Josh Poimboeuf wrote:
> > On Thu, May 05, 2022 at 03:18:11PM +0200, Artem Savkov wrote:
> > > Make sure TCP keepalive timer does not expire late. Switching to upper
> > > bound timers means it can fire off early but in case of keepalive
> > > tcp_keepalive_timer() handler checks elapsed time and resets the timer
> > > if it was triggered early. This results in timer "cascading" to a
> > > higher precision and being just a couple of milliseconds off it's
> > > original mark.
> > > This adds minimal overhead as keepalive timers are never re-armed and
> > > are usually quite long.
> > > 
> > > Signed-off-by: Artem Savkov <asavkov@redhat.com>
> > > ---
> > >  net/ipv4/inet_connection_sock.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
> > > index 1e5b53c2bb26..bb2dbfb6f5b5 100644
> > > --- a/net/ipv4/inet_connection_sock.c
> > > +++ b/net/ipv4/inet_connection_sock.c
> > > @@ -589,7 +589,7 @@ EXPORT_SYMBOL(inet_csk_delete_keepalive_timer);
> > >  
> > >  void inet_csk_reset_keepalive_timer(struct sock *sk, unsigned long len)
> > >  {
> > > -	sk_reset_timer(sk, &sk->sk_timer, jiffies + len);
> > > +	sk_reset_timer(sk, &sk->sk_timer, jiffies + upper_bound_timeout(len));
> > >  }
> > >  EXPORT_SYMBOL(inet_csk_reset_keepalive_timer);
> > 
> > As I mentioned before, there might be two sides to the same coin,
> > depending on whether the keepalive is detecting vs preventing the
> > disconnect.  So this might possibly fix one case, while breaking
> > another.
> 
> But cascading is still there in the handler so it will fire off quite
> close to original timer in any case.

Ah, indeed it does.  Sorry, I should try actually reading the patch
description next time :-/ Looks good to me.

Reviewed-by: Josh Poimboeuf <jpoimboe@kernel.org>

-- 
Josh
