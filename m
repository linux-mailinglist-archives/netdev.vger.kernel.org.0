Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82B18235174
	for <lists+netdev@lfdr.de>; Sat,  1 Aug 2020 11:30:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728714AbgHAJ3v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Aug 2020 05:29:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725931AbgHAJ3v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Aug 2020 05:29:51 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05DA8C06174A
        for <netdev@vger.kernel.org>; Sat,  1 Aug 2020 02:29:51 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1k1npn-00065G-6X; Sat, 01 Aug 2020 11:29:43 +0200
Date:   Sat, 1 Aug 2020 11:29:43 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Florian Westphal <fw@strlen.de>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH net-next] tcp: fix build fong CONFIG_MPTCP=n
Message-ID: <20200801092943.GH5271@breakpoint.cc>
References: <20200801020929.3000802-1-edumazet@google.com>
 <20200801074645.GG5271@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200801074645.GG5271@breakpoint.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Florian Westphal <fw@strlen.de> wrote:
> Eric Dumazet <edumazet@google.com> wrote:
> > Fixes these errors:
> > 
> > net/ipv4/syncookies.c: In function 'tcp_get_cookie_sock':
> > net/ipv4/syncookies.c:216:19: error: 'struct tcp_request_sock' has no
> > member named 'drop_req'
> >   216 |   if (tcp_rsk(req)->drop_req) {
> >       |                   ^~
> > net/ipv4/syncookies.c: In function 'cookie_tcp_reqsk_alloc':
> > net/ipv4/syncookies.c:289:27: warning: unused variable 'treq'
> > [-Wunused-variable]
> >   289 |  struct tcp_request_sock *treq;
> >       |                           ^~~~
> 
> Ugh, sorry about this.
> 
> > make[3]: *** [scripts/Makefile.build:280: net/ipv4/syncookies.o] Error 1
> > make[3]: *** Waiting for unfinished jobs....
> >
> > Fixes: 9466a1ccebbe ("mptcp: enable JOIN requests even if cookies are in use")
> > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > Cc: Florian Westphal <fw@strlen.de>
> > ---
> >  net/ipv4/syncookies.c | 5 +++--
> >  1 file changed, 3 insertions(+), 2 deletions(-)
> > 
> > diff --git a/net/ipv4/syncookies.c b/net/ipv4/syncookies.c
> > index 11b20474be8310d7070750a1c7b4013f2fba2f55..f0794f0232bae749244fff35d8b96b1f561a5e87 100644
> > --- a/net/ipv4/syncookies.c
> > +++ b/net/ipv4/syncookies.c
> > @@ -213,7 +213,7 @@ struct sock *tcp_get_cookie_sock(struct sock *sk, struct sk_buff *skb,
> >  		tcp_sk(child)->tsoffset = tsoff;
> >  		sock_rps_save_rxhash(child, skb);
> >  
> > -		if (tcp_rsk(req)->drop_req) {
> > +		if (rsk_drop_req(req)) {
> 
> This hunk breaks join self test for mptcp, but it should not. Looks like
> cookie path missed a ->is_mptcp = 1 somewhere.  Investigating.

I take that back, the failure is spurious, also sometimes occurs with
no-cookie part of test and also happens with a checkout before the
syncookie patches got merged.  I will take another look at this on
Monday.  No need to hold up this fix, so

Acked-by: Florian Westphal <fw@strlen.de>
