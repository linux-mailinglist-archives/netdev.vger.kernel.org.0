Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06F191CC4B0
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 23:19:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728424AbgEIVTl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 17:19:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:59194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727108AbgEIVTl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 May 2020 17:19:41 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7C45721473;
        Sat,  9 May 2020 21:19:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589059180;
        bh=VmwPVJKT2v+erZFsLCasdEboGnLPwgraIeEZ+VZKOMs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=wOsCHPDrh0mHaFSaxipTFAcZ+JRW6Ycicfqco2CcTCCoSv8LTi4yHScET00RKIYxj
         XigbMqA5U4m4L26IkmKQZA2J7gSDX3c261EmTEcfeS5rO4ZHOTPzNW0Ygo5JRt10+d
         WUiPtLUW6z1rpQW4iaBOK7mJf4U9EkLVQXYt+EmY=
Date:   Sat, 9 May 2020 14:19:38 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Amol Grover <frextrite@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Joel Fernandes <joel@joelfernandes.org>,
        Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>
Subject: Re: [PATCH net 2/2 RESEND] ipmr: Add lockdep expression to
 ipmr_for_each_table macro
Message-ID: <20200509141938.028fa959@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200509072243.3141-2-frextrite@gmail.com>
References: <20200509072243.3141-1-frextrite@gmail.com>
        <20200509072243.3141-2-frextrite@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat,  9 May 2020 12:52:44 +0530 Amol Grover wrote:
> ipmr_for_each_table() uses list_for_each_entry_rcu() for
> traversing outside of an RCU read-side critical section but
> under the protection of pernet_ops_rwsem. Hence add the
> corresponding lockdep expression to silence the following
> false-positive warning at boot:

Thanks for the fix, the warning has been annoying me as well!

> [    0.645292] =============================
> [    0.645294] WARNING: suspicious RCU usage
> [    0.645296] 5.5.4-stable #17 Not tainted
> [    0.645297] -----------------------------
> [    0.645299] net/ipv4/ipmr.c:136 RCU-list traversed in non-reader section!!

please provide a fuller stack trace, it would have helped the review

> Signed-off-by: Amol Grover <frextrite@gmail.com>
> ---
>  net/ipv4/ipmr.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
> index 99c864eb6e34..950ffe9943da 100644
> --- a/net/ipv4/ipmr.c
> +++ b/net/ipv4/ipmr.c
> @@ -109,9 +109,10 @@ static void mroute_clean_tables(struct mr_table *mrt, int flags);
>  static void ipmr_expire_process(struct timer_list *t);
>  
>  #ifdef CONFIG_IP_MROUTE_MULTIPLE_TABLES
> -#define ipmr_for_each_table(mrt, net) \
> -	list_for_each_entry_rcu(mrt, &net->ipv4.mr_tables, list, \
> -				lockdep_rtnl_is_held())
> +#define ipmr_for_each_table(mrt, net)					\
> +	list_for_each_entry_rcu(mrt, &net->ipv4.mr_tables, list,	\
> +				lockdep_rtnl_is_held() ||		\
> +				lockdep_is_held(&pernet_ops_rwsem))

This is a strange condition, IMHO. How can we be fine with either
lock.. This is supposed to be the writer side lock, one can't have 
two writer side locks..

I think what is happening is this:

ipmr_net_init() -> ipmr_rules_init() -> ipmr_new_table()

ipmr_new_table() returns an existing table if there is one, but
obviously none can exist at init.  So a better fix would be:

#define ipmr_for_each_table(mrt, net)					\
	list_for_each_entry_rcu(mrt, &net->ipv4.mr_tables, list,	\
				lockdep_rtnl_is_held() ||		\
				list_empty(&net->ipv4.mr_tables))

Thoughts?
