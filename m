Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 313511D36AB
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 18:40:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726174AbgENQkL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 12:40:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:55112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726067AbgENQkL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 May 2020 12:40:11 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0A688206A5;
        Thu, 14 May 2020 16:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589474410;
        bh=Wbe+BLJ8SmtXx7TidpeEcsibW884yBOuoni+9QEk6pk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JiSnK00bfBAsfzapkii2tTsCXKRL/+zpVWF6Kf5bL3ubiTUyurm4QoPoOQgJ6qvRP
         Z6Jp+Ka/ogyk2kjhieJcUcl0zwMq5lNOrsvdN7rIsxYGvLK1hUlXjpL6eSxrgonz1m
         O4kDO0YSzVvwB/jxCbopDHYsLjp+kjfTsyGZRrsg=
Date:   Thu, 14 May 2020 09:40:08 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     madhuparnabhowmik10@gmail.com
Cc:     davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        sfr@canb.auug.org.au, frextrite@gmail.com, joel@joelfernandes.org,
        paulmck@kernel.org, cai@lca.pw
Subject: Re: [PATCH net] ipv6: Fix suspicious RCU usage warning in ip6mr
Message-ID: <20200514094008.6421ea71@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200514070204.3108-1-madhuparnabhowmik10@gmail.com>
References: <20200514070204.3108-1-madhuparnabhowmik10@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 14 May 2020 12:32:04 +0530 madhuparnabhowmik10@gmail.com wrote:
> From: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
> 
> This patch fixes the following warning:
> 
> =============================
> WARNING: suspicious RCU usage
> 5.7.0-rc4-next-20200507-syzkaller #0 Not tainted
> -----------------------------
> net/ipv6/ip6mr.c:124 RCU-list traversed in non-reader section!!
> 
> ipmr_new_table() returns an existing table, but there is no table at
> init. Therefore the condition: either holding rtnl or the list is empty
> is used.
> 
> Fixes: d13fee049f ("Default enable RCU list lockdep debugging with .."): WARNING: suspicious RCU usage

	Fixes tag: Fixes: d13fee049f ("Default enable RCU list lockdep debugging with .."): WARNING: suspicious RCU usage
	Has these problem(s):
		- Target SHA1 does not exist

I think the message at the end is confusing automation, could you use
the standard Fixes tag format, please?

> Reported-by: kernel test robot <lkp@intel.com>
> Suggested-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
> ---
>  net/ipv6/ip6mr.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/ipv6/ip6mr.c b/net/ipv6/ip6mr.c
> index 65a54d74acc1..fbe282bb8036 100644
> --- a/net/ipv6/ip6mr.c
> +++ b/net/ipv6/ip6mr.c
> @@ -98,7 +98,7 @@ static void ipmr_expire_process(struct timer_list *t);
>  #ifdef CONFIG_IPV6_MROUTE_MULTIPLE_TABLES
>  #define ip6mr_for_each_table(mrt, net) \
>  	list_for_each_entry_rcu(mrt, &net->ipv6.mr6_tables, list, \
> -				lockdep_rtnl_is_held())
> +				lockdep_rtnl_is_held() ||  list_empty(&net->ipv6.mr6_tables))

double space, line over 80 chars

>  static struct mr_table *ip6mr_mr_table_iter(struct net *net,
>  					    struct mr_table *mrt)

Other than these nits looks good, thanks!
