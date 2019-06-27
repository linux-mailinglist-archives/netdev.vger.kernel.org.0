Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 462215864C
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 17:50:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726596AbfF0Puj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 11:50:39 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:48648 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726384AbfF0Puj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 11:50:39 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hgWfU-00045i-OE; Thu, 27 Jun 2019 17:50:36 +0200
Date:   Thu, 27 Jun 2019 17:50:36 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Thomas Jarosch <thomas.jarosch@intra2net.com>
Cc:     Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org,
        Juliana Rodrigueiro <juliana.rodrigueiro@intra2net.com>
Subject: Re: 4.19: Traced deadlock during xfrm_user module load
Message-ID: <20190627155036.vzoo2xikdfuyiug3@breakpoint.cc>
References: <20190625155509.pgcxwgclqx3lfxxr@intra2net.com>
 <20190625165344.ii4zgvxydqj663ny@breakpoint.cc>
 <20190627154629.27g5uwd47esyhz4s@intra2net.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190627154629.27g5uwd47esyhz4s@intra2net.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thomas Jarosch <thomas.jarosch@intra2net.com> wrote:
> You wrote on Tue, Jun 25, 2019 at 06:53:44PM +0200:
> > Thanks for this detailed analysis.
> > In this specific case I think this is enough:
> > 
> > diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
> > index 92077d459109..61ba92415480 100644
> > --- a/net/netfilter/nfnetlink.c
> > +++ b/net/netfilter/nfnetlink.c
> > @@ -578,7 +578,8 @@ static int nfnetlink_bind(struct net *net, int group)
> >         ss = nfnetlink_get_subsys(type << 8);
> >         rcu_read_unlock();
> >         if (!ss)
> > -               request_module("nfnetlink-subsys-%d", type);
> > +               request_module_nowait("nfnetlink-subsys-%d", type);
> >         return 0;
> >  }
> >  #endif
> 
> thanks for the patch! We finally found an easy way to reproduce the deadlock,
> the following commands instantly trigger the problem on our machines:
> 
>     rmmod nf_conntrack_netlink
>     rmmod xfrm_user
>     conntrack -e NEW -E & modprobe -v xfrm_user
> 
> Note: the "-e" filter is needed to trigger the problematic
> code path in the kernel.
> 
> We were worried that using "_nowait" would introduce other race conditions,
> since the requested service might not be available by the time it is required.

Then this code would be buggy too, there is no guarantee that a
request_module() succeeds.

> "nfnetlink_bind()", the caller will listen on the socket for messages
> regardless whether the needed modules are loaded, loading or unloaded.
> To verify this we added a three second sleep during the initialisation of
> nf_conntrack_netlink. The events started to appear after
> the delayed init was completed.
> 
> If this is the case, then using "_nowait" should suffice as a fix
> for the problem. Could you please confirm these assumptions
> and give us some piece of mind?

Yes, _nowait is safe here (and needed, as you find out).
I'm away for a few hours but I plan to submit this patch officially
soon.
