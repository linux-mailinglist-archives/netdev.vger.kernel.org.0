Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1053D4C440
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 01:57:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730859AbfFSX5j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 19:57:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47480 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726298AbfFSX5j (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Jun 2019 19:57:39 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 25081308302F;
        Wed, 19 Jun 2019 23:57:39 +0000 (UTC)
Received: from localhost (unknown [10.36.112.13])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9516F1001B30;
        Wed, 19 Jun 2019 23:57:36 +0000 (UTC)
Date:   Thu, 20 Jun 2019 01:57:32 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     David Miller <davem@davemloft.net>, Jianlin Shi <jishi@redhat.com>,
        Wei Wang <weiwan@google.com>, Martin KaFai Lau <kafai@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH net v5 5/6] ipv6: Dump route exceptions if requested
Message-ID: <20190620015732.7650f506@redhat.com>
In-Reply-To: <333b0a08-07dd-3c70-1268-2d9eb5646564@gmail.com>
References: <cover.1560827176.git.sbrivio@redhat.com>
        <364403cca3d7836557f8ffe83c9c48b436be76eb.1560827176.git.sbrivio@redhat.com>
        <333b0a08-07dd-3c70-1268-2d9eb5646564@gmail.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Wed, 19 Jun 2019 23:57:39 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 18 Jun 2019 09:19:53 -0600
David Ahern <dsahern@gmail.com> wrote:

> On 6/18/19 7:20 AM, Stefano Brivio wrote:
> > diff --git a/net/ipv6/route.c b/net/ipv6/route.c
> > index 0f60eb3a2873..7375f3b7d310 100644
> > --- a/net/ipv6/route.c
> > +++ b/net/ipv6/route.c
> > @@ -4854,33 +4854,94 @@ static bool fib6_info_uses_dev(const struct fib6_info *f6i,
> >  	return false;
> >  }
> >  
> > -int rt6_dump_route(struct fib6_info *rt, void *p_arg)
> > +/* Return -1 if done with node, number of handled routes on partial dump */
> > +int rt6_dump_route(struct fib6_info *rt, void *p_arg, unsigned int skip)  
> 
> Changing the return code of rt6_dump_route should be a separate patch.

I guess the purpose would be to highlight how existing cases are
changed, but that looks rather trivial to me. Anyway, changed in v6.

> > +	if (filter->dump_routes) {
> > +		if (skip) {
> > +			skip--;
> > +		} else {
> > +			if (rt6_fill_node(net, arg->skb, rt, NULL, NULL, NULL,
> > +					  0, RTM_NEWROUTE,
> > +					  NETLINK_CB(arg->cb->skb).portid,
> > +					  arg->cb->nlh->nlmsg_seq, flags)) {
> > +				return 0;
> > +			}
> > +			count++;
> > +		}
> > +	}
> > +
> > +	if (!filter->dump_exceptions)
> > +		return -1;
> > +  
> 
> And the dump of the exception bucket should be a standalone function.
> You will see why with net-next (it is per fib6_nh).

Sure, no way around it now, changed in v6.

-- 
Stefano
