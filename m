Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 453561030FF
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 02:12:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727471AbfKTBMT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 20:12:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:43270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727262AbfKTBMS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Nov 2019 20:12:18 -0500
Received: from paulmck-ThinkPad-P72.home (unknown [199.201.64.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CDA892245C;
        Wed, 20 Nov 2019 01:12:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574212337;
        bh=YVHFJP4Tg+uw9cqmlPx827g2cuX+27hpz2I8QmaOS+E=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=QmEXo52I896jnaFA1ELwMs8w57Kzti/fIf87OBz7rLXE31Q5zdp+oLYAhOP+HkaBj
         elfKj6ziCzfzU9TF1DxdlhYnovU1XYAFD93P/XlWopjt6X+VyNybvJeLqz3+O3dQ3u
         5iyiPL+e4mvcU2WjoXjNLeXIek5fNCgsRUsnXoA8=
Received: by paulmck-ThinkPad-P72.home (Postfix, from userid 1000)
        id 45B9435227AB; Tue, 19 Nov 2019 17:12:17 -0800 (PST)
Date:   Tue, 19 Nov 2019 17:12:17 -0800
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     David Miller <davem@davemloft.net>
Cc:     anders.roxell@linaro.org, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: ipmr: fix suspicious RCU warning
Message-ID: <20191120011217.GM2889@paulmck-ThinkPad-P72>
Reply-To: paulmck@kernel.org
References: <20191118090925.2474-1-anders.roxell@linaro.org>
 <20191119.145048.487849503145486152.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191119.145048.487849503145486152.davem@davemloft.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 19, 2019 at 02:50:48PM -0800, David Miller wrote:
> From: Anders Roxell <anders.roxell@linaro.org>
> Date: Mon, 18 Nov 2019 10:09:25 +0100
> 
> > @@ -108,9 +108,18 @@ static void igmpmsg_netlink_event(struct mr_table *mrt, struct sk_buff *pkt);
> >  static void mroute_clean_tables(struct mr_table *mrt, int flags);
> >  static void ipmr_expire_process(struct timer_list *t);
> >  
> > +#ifdef CONFIG_PROVE_LOCKING
> > +int ip_mr_initialized;
> > +void ip_mr_now_initialized(void) { ip_mr_initialized = 1; }
> > +#else
> > +const int ip_mr_initialized = 1;
> > +void ip_mr_now_initialized(void) { }
> > +#endif
> 
> This seems excessive and a bit not so pretty.
> 
> > +
> >  #ifdef CONFIG_IP_MROUTE_MULTIPLE_TABLES
> >  #define ipmr_for_each_table(mrt, net) \
> > -	list_for_each_entry_rcu(mrt, &net->ipv4.mr_tables, list)
> > +	list_for_each_entry_rcu(mrt, &net->ipv4.mr_tables, list, \
> > +			(lockdep_rtnl_is_held() || !ip_mr_initialized))
> >  
> >  static struct mr_table *ipmr_mr_table_iter(struct net *net,
> >  					   struct mr_table *mrt)
> 
> The problematic code path is ipmr_rules_init() done during ipmr_net_init().
> 
> You can just wrap this call around RCU locking or take the RTNL mutex.

Agreed, that would work quite well.

							Thanx, Paul

> That way you don't need to rediculous ip_mr_initialized knob which frankly
> doesn't even seem accurate to me.  It's a centralized global variable
> which is holding state about multiple network namespace objects which makes
> absolutely no sense at all, it's wrong.
