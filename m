Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E96218A216
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 19:05:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726704AbgCRSF2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 14:05:28 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:60622 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726506AbgCRSF2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 14:05:28 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1jEd4I-0006fk-Fi; Wed, 18 Mar 2020 19:05:26 +0100
Date:   Wed, 18 Mar 2020 19:05:26 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
        mptcp@lists.01.org, Eric Dumazet <edumazet@google.com>
Subject: Re: [RFC mptcp-next] tcp: mptcp: use mptcp receive buffer space to
 select rcv window
Message-ID: <20200318180526.GJ979@breakpoint.cc>
References: <20200318141917.2612-1-fw@strlen.de>
 <48933c49-0889-5dba-29e2-62640e47797a@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48933c49-0889-5dba-29e2-62640e47797a@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eric Dumazet <eric.dumazet@gmail.com> wrote:
> > @@ -2771,6 +2771,11 @@ u32 __tcp_select_window(struct sock *sk)
> >  	int full_space = min_t(int, tp->window_clamp, allowed_space);
> >  	int window;
> >  
> > +	if (sk_is_mptcp(sk)) {
> > +		mptcp_space(sk, &free_space, &allowed_space);
> > +		full_space = min_t(int, tp->window_clamp, allowed_space);
> > +	}
> 
> You could move the full_space = min_t(int, tp->window_clamp, allowed_space);
> after this block factorize it.

Indeed, will do.

> > diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
> > index 40ad7995b13b..aefcbb8bb737 100644
> > --- a/net/mptcp/subflow.c
> > +++ b/net/mptcp/subflow.c
> > @@ -745,6 +745,23 @@ bool mptcp_subflow_data_available(struct sock *sk)
> >  	return subflow->data_avail;
> >  }
> >  
> > +/* If ssk has an mptcp parent socket, use the mptcp rcvbuf occupancy,
> > + * not the ssk one.
> > + *
> > + * In mptcp, rwin is about the mptcp-level connection data.
> > + *
> > + * Data that is still on the ssk rx queue can thus be ignored,
> > + * as far as mptcp peer is concerened that data is still inflight.
> > + */
> > +void mptcp_space(const struct sock *ssk, int *space, int *full_space)
> > +{
> > +	const struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(ssk);
> > +	const struct sock *sk = READ_ONCE(subflow->conn);
> 
> What are the rules protecting subflow->conn lifetime ?
> 
> Why dereferencing sk after this line is safe ?

Subflow sockets hold a reference on the master/parent mptcp-socket.
