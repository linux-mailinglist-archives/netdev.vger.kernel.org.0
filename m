Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33F042C491E
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 21:33:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730067AbgKYUdX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 15:33:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:33096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725876AbgKYUdW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Nov 2020 15:33:22 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 32BC3206F7;
        Wed, 25 Nov 2020 20:33:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606336402;
        bh=xxByuzrg9ts+Axv6Kf2r/EfXCXoHXfNsKMoH58vJx2Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZD5k9a+uH9PyURPflde5JL+3VaRHRXWSHluvSg0/+UCjzOhVgxezyuIgpOyWYQXsR
         DFILvdSe2q7r3uGNlPuCGa8uNKOu7yuaLa1a89FLWDSSixwKUC7YIO3WPeoWcL0YuE
         +zJFGcRwJHaCc+Uolx6LbktELhg2brB2BBOjwv1o=
Date:   Wed, 25 Nov 2020 12:33:20 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
        mptcp@lists.01.org, Davide Caratti <dcaratti@redhat.com>
Subject: Re: [PATCH net-next] mptcp: put reference in mptcp timeout timer
Message-ID: <20201125123317.678761e6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <e44300a0567cdec8241c06d1c6b78083cdd4254a.camel@redhat.com>
References: <20201124162446.11448-1-fw@strlen.de>
        <e44300a0567cdec8241c06d1c6b78083cdd4254a.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 24 Nov 2020 17:42:21 +0100 Paolo Abeni wrote:
> On Tue, 2020-11-24 at 17:24 +0100, Florian Westphal wrote:
> > On close this timer might be scheduled. mptcp uses sk_reset_timer for
> > this, so the a reference on the mptcp socket is taken.
> > 
> > This causes a refcount leak which can for example be reproduced
> > with 'mp_join_server_v4.pkt' from the mptcp-packetdrill repo.  
> 
> Whoops, my fault!
> 
> > The leak has nothing to do with join requests, v1_mp_capable_bind_no_cs.pkt
> > works too when replacing the last ack mpcapable to v1 instead of v0.
> > 
> > unreferenced object 0xffff888109bba040 (size 2744):
> >   comm "packetdrill", [..]
> >   backtrace:
> >     [..] sk_prot_alloc.isra.0+0x2b/0xc0
> >     [..] sk_clone_lock+0x2f/0x740
> >     [..] mptcp_sk_clone+0x33/0x1a0
> >     [..] subflow_syn_recv_sock+0x2b1/0x690 [..]
> > 
> > Fixes: e16163b6e2b7 ("mptcp: refactor shutdown and close")
> > Cc: Paolo Abeni <pabeni@redhat.com>
> > Cc: Davide Caratti <dcaratti@redhat.com>
> > Signed-off-by: Florian Westphal <fw@strlen.de>
> > ---
> >  net/mptcp/protocol.c | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
> > index 4b7794835fea..dc979571f561 100644
> > --- a/net/mptcp/protocol.c
> > +++ b/net/mptcp/protocol.c
> > @@ -1710,6 +1710,7 @@ static void mptcp_timeout_timer(struct timer_list *t)
> >  	struct sock *sk = from_timer(sk, t, sk_timer);
> >  
> >  	mptcp_schedule_work(sk);
> > +	sock_put(sk);
> >  }
> >  
> >  /* Find an idle subflow.  Return NULL if there is unacked data at tcp  
> 
> LGTM, thanks!
> Acked-by: Paolo Abeni <pabeni@redhat.com>

Applied, thanks!
