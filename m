Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6D5816377C
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 00:51:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727285AbgBRXvA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 18:51:00 -0500
Received: from smtp.uniroma2.it ([160.80.6.23]:40390 "EHLO smtp.uniroma2.it"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726691AbgBRXvA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Feb 2020 18:51:00 -0500
Received: from utente-Aspire-V3-572G (wireless-130-133.net.uniroma2.it [160.80.133.130])
        by smtp-2015.uniroma2.it (8.14.4/8.14.4/Debian-8) with SMTP id 01INo6DF032331;
        Wed, 19 Feb 2020 00:50:11 +0100
Date:   Wed, 19 Feb 2020 00:50:07 +0100
From:   Carmine Scarpitta <carmine.scarpitta@uniroma2.it>
To:     David Ahern <dsahern@gmail.com>
Cc:     davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ahmed.abdelsalam@gssi.it,
        dav.lebrun@gmail.com, andrea.mayer@uniroma2.it,
        paolo.lungaroni@cnit.it
Subject: Re: [net-next 1/2] Perform IPv4 FIB lookup in a predefined FIB
 table
Message-Id: <20200219005007.23d724b7f717ef89ad3d75e5@uniroma2.it>
In-Reply-To: <7302c1f7-b6d1-90b7-5df1-3e5e0ba98f53@gmail.com>
References: <20200213010932.11817-1-carmine.scarpitta@uniroma2.it>
        <20200213010932.11817-2-carmine.scarpitta@uniroma2.it>
        <7302c1f7-b6d1-90b7-5df1-3e5e0ba98f53@gmail.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.100.0 at smtp-2015
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, 
Thanks for the review and sorry for the late reply 

Indeed both call fib_table_lookup and rt_dst_alloc are exported for modules. 
However, several functions defined in route.c are not exported:
- the two functions rt_cache_valid and rt_cache_route required to handle the routing cache
- find_exception, required to support fib exceptions.
This would require duplicating a lot of the IPv4 routing code. 
The reason behind this change is really to reuse the IPv4 routing code instead of doing a duplication. 

For the fi member of the struct fib_result, we will fix it by initializing before "if (!tbl_known)"

Thanks, 
Carmine 


On Sat, 15 Feb 2020 11:06:43 -0700
David Ahern <dsahern@gmail.com> wrote:

> On 2/12/20 6:09 PM, Carmine Scarpitta wrote:
> > In IPv4, the routing subsystem is invoked by calling ip_route_input_rcu()
> > which performs the recognition logic and calls ip_route_input_slow().
> > 
> > ip_route_input_slow() initialises both "fi" and "table" members
> > of the fib_result structure to null before calling fib_lookup().
> > 
> > fib_lookup() performs fib lookup in the routing table configured
> > by the policy routing rules.
> > 
> > In this patch, we allow invoking the ip4 routing subsystem
> > with known routing table. This is useful for use-cases implementing
> > a separate routing table per tenant.
> > 
> > The patch introduces a new flag named "tbl_known" to the definition of
> > ip_route_input_rcu() and ip_route_input_slow().
> > 
> > When the flag is set, ip_route_input_slow() will call fib_table_lookup()
> > using the defined table instead of using fib_lookup().
> 
> I do not like this change. If you want a specific table lookup, then why
> just call fib_table_lookup directly? Both it and rt_dst_alloc are
> exported for modules. Your next patch already does a fib table lookup.
> 
> 
> > 
> > Signed-off-by: Carmine Scarpitta <carmine.scarpitta@uniroma2.it>
> > Acked-by: Ahmed Abdelsalam <ahmed.abdelsalam@gssi.it>
> > Acked-by: Andrea Mayer <andrea.mayer@uniroma2.it>
> > Acked-by: Paolo Lungaroni <paolo.lungaroni@cnit.it>
> > ---
> >  include/net/route.h |  2 +-
> >  net/ipv4/route.c    | 22 ++++++++++++++--------
> >  2 files changed, 15 insertions(+), 9 deletions(-)
> > 
> > diff --git a/include/net/route.h b/include/net/route.h
> > index a9c60fc68e36..4ff977bd7029 100644
> > --- a/include/net/route.h
> > +++ b/include/net/route.h
> > @@ -183,7 +183,7 @@ int ip_route_input_noref(struct sk_buff *skb, __be32 dst, __be32 src,
> >  			 u8 tos, struct net_device *devin);
> >  int ip_route_input_rcu(struct sk_buff *skb, __be32 dst, __be32 src,
> >  		       u8 tos, struct net_device *devin,
> > -		       struct fib_result *res);
> > +		       struct fib_result *res, bool tbl_known);
> >  
> >  int ip_route_use_hint(struct sk_buff *skb, __be32 dst, __be32 src,
> >  		      u8 tos, struct net_device *devin,
> > diff --git a/net/ipv4/route.c b/net/ipv4/route.c
> > index d5c57b3f77d5..39cec9883d6f 100644
> > --- a/net/ipv4/route.c
> > +++ b/net/ipv4/route.c
> > @@ -2077,7 +2077,7 @@ int ip_route_use_hint(struct sk_buff *skb, __be32 daddr, __be32 saddr,
> >  
> >  static int ip_route_input_slow(struct sk_buff *skb, __be32 daddr, __be32 saddr,
> >  			       u8 tos, struct net_device *dev,
> > -			       struct fib_result *res)
> > +			       struct fib_result *res, bool tbl_known)
> >  {
> >  	struct in_device *in_dev = __in_dev_get_rcu(dev);
> >  	struct flow_keys *flkeys = NULL, _flkeys;
> > @@ -2109,8 +2109,6 @@ static int ip_route_input_slow(struct sk_buff *skb, __be32 daddr, __be32 saddr,
> >  	if (ipv4_is_multicast(saddr) || ipv4_is_lbcast(saddr))
> >  		goto martian_source;
> >  
> > -	res->fi = NULL;
> > -	res->table = NULL;
> >  	if (ipv4_is_lbcast(daddr) || (saddr == 0 && daddr == 0))
> >  		goto brd_input;
> 
> I believe this also introduces a potential bug. You remove the fi
> initialization yet do not cover the goto case.
> 
> 


-- 
Carmine Scarpitta <carmine.scarpitta@uniroma2.it>
