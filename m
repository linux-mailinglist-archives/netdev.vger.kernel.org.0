Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C738102F8C
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 23:50:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727336AbfKSWux (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 17:50:53 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:46166 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726290AbfKSWuw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 17:50:52 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EC2671423DA68;
        Tue, 19 Nov 2019 14:50:51 -0800 (PST)
Date:   Tue, 19 Nov 2019 14:50:48 -0800 (PST)
Message-Id: <20191119.145048.487849503145486152.davem@davemloft.net>
To:     anders.roxell@linaro.org
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, paulmck@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: ipmr: fix suspicious RCU warning
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191118090925.2474-1-anders.roxell@linaro.org>
References: <20191118090925.2474-1-anders.roxell@linaro.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 19 Nov 2019 14:50:52 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Anders Roxell <anders.roxell@linaro.org>
Date: Mon, 18 Nov 2019 10:09:25 +0100

> @@ -108,9 +108,18 @@ static void igmpmsg_netlink_event(struct mr_table *mrt, struct sk_buff *pkt);
>  static void mroute_clean_tables(struct mr_table *mrt, int flags);
>  static void ipmr_expire_process(struct timer_list *t);
>  
> +#ifdef CONFIG_PROVE_LOCKING
> +int ip_mr_initialized;
> +void ip_mr_now_initialized(void) { ip_mr_initialized = 1; }
> +#else
> +const int ip_mr_initialized = 1;
> +void ip_mr_now_initialized(void) { }
> +#endif

This seems excessive and a bit not so pretty.

> +
>  #ifdef CONFIG_IP_MROUTE_MULTIPLE_TABLES
>  #define ipmr_for_each_table(mrt, net) \
> -	list_for_each_entry_rcu(mrt, &net->ipv4.mr_tables, list)
> +	list_for_each_entry_rcu(mrt, &net->ipv4.mr_tables, list, \
> +			(lockdep_rtnl_is_held() || !ip_mr_initialized))
>  
>  static struct mr_table *ipmr_mr_table_iter(struct net *net,
>  					   struct mr_table *mrt)

The problematic code path is ipmr_rules_init() done during ipmr_net_init().

You can just wrap this call around RCU locking or take the RTNL mutex.

That way you don't need to rediculous ip_mr_initialized knob which frankly
doesn't even seem accurate to me.  It's a centralized global variable
which is holding state about multiple network namespace objects which makes
absolutely no sense at all, it's wrong.
