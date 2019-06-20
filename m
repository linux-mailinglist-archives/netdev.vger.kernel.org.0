Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 734B24D9E4
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 21:00:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726068AbfFTTAg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 15:00:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32055 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725905AbfFTTAg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Jun 2019 15:00:36 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B75AA31628FE;
        Thu, 20 Jun 2019 19:00:30 +0000 (UTC)
Received: from localhost (unknown [10.36.112.13])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 50D91601B6;
        Thu, 20 Jun 2019 19:00:27 +0000 (UTC)
Date:   Thu, 20 Jun 2019 21:00:22 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     David Miller <davem@davemloft.net>, Jianlin Shi <jishi@redhat.com>,
        Wei Wang <weiwan@google.com>, Martin KaFai Lau <kafai@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v6 03/11] ipv4/route: Allow NULL flowinfo in
 rt_fill_info()
Message-ID: <20190620205946.7ecd5ae7@redhat.com>
In-Reply-To: <9efa65d3-5797-fde0-d5c2-3c7747d591ad@gmail.com>
References: <cover.1560987611.git.sbrivio@redhat.com>
        <5ba00822d7e86cdcb9231b39fda3cc4a04e2836f.1560987611.git.sbrivio@redhat.com>
        <9efa65d3-5797-fde0-d5c2-3c7747d591ad@gmail.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Thu, 20 Jun 2019 19:00:36 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 20 Jun 2019 07:15:55 -0600
David Ahern <dsahern@gmail.com> wrote:

> On 6/19/19 5:59 PM, Stefano Brivio wrote:
> > In the next patch, we're going to use rt_fill_info() to dump exception
> > routes upon RTM_GETROUTE with NLM_F_ROOT, meaning userspace is requesting
> > a dump and not a specific route selection, which in turn implies the input
> > interface is not relevant. Update rt_fill_info() to handle a NULL
> > flowinfo.
> > 
> > Suggested-by: David Ahern <dsahern@gmail.com>
> > Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
> > ---
> > v6: New patch
> > 
> >  net/ipv4/route.c | 57 ++++++++++++++++++++++++++----------------------
> >  1 file changed, 31 insertions(+), 26 deletions(-)
> > 
> > diff --git a/net/ipv4/route.c b/net/ipv4/route.c
> > index 66cbe8a7a168..052a80373b1d 100644
> > --- a/net/ipv4/route.c
> > +++ b/net/ipv4/route.c
> > @@ -2699,7 +2699,8 @@ static int rt_fill_info(struct net *net, __be32 dst, __be32 src,
> >  	r->rtm_family	 = AF_INET;
> >  	r->rtm_dst_len	= 32;
> >  	r->rtm_src_len	= 0;
> > -	r->rtm_tos	= fl4->flowi4_tos;
> > +	if (fl4)
> > +		r->rtm_tos	= fl4->flowi4_tos;  
> 
> tracing back to the alloc_skb it does not appear to be initialized to 0,
> so this should be:
> 	r->rtm_tos	= fl4 ? fl4->flowi4_tos : 0;

I guess you're right, but I'm still wondering why I'm not seeing it
with KMSAN. Thanks for catching this, I'll fix it.

-- 
Stefano
