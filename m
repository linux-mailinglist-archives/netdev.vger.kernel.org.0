Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AB13290D65
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 23:46:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728905AbgJPVqk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 17:46:40 -0400
Received: from mga07.intel.com ([134.134.136.100]:43895 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728478AbgJPVqk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Oct 2020 17:46:40 -0400
IronPort-SDR: cDRIO/vYbL2cV27KJySFdkQhs9PPVVoyFGsa3MwI3qwmVWlCeT7UvYhREC/PMops+ZCQAQS0w5
 yaE7RnU9Fp2A==
X-IronPort-AV: E=McAfee;i="6000,8403,9776"; a="230882326"
X-IronPort-AV: E=Sophos;i="5.77,384,1596524400"; 
   d="scan'208";a="230882326"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2020 14:46:36 -0700
IronPort-SDR: rCnkDr1xGpsFe5IGSDvzran3Qzkp8hUe1lCUFQPnnWIyh8L0TxZIPpI/cXulHhduc2AyxBN7+m
 ZNpsqdFGZcrQ==
X-IronPort-AV: E=Sophos;i="5.77,384,1596524400"; 
   d="scan'208";a="531881393"
Received: from jbrandeb-mobl4.amr.corp.intel.com (HELO localhost) ([10.209.117.85])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2020 14:46:36 -0700
Date:   Fri, 16 Oct 2020 14:46:36 -0700
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        dsahern@gmail.com, nikolay@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>, paulmck@kernel.org
Subject: Re: [PATCH net] nexthop: Fix performance regression in nexthop
 deletion
Message-ID: <20201016144636.000011cf@intel.com>
In-Reply-To: <20201016172914.643282-1-idosch@idosch.org>
References: <20201016172914.643282-1-idosch@idosch.org>
X-Mailer: Claws Mail 3.12.0 (GTK+ 2.24.28; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ido Schimmel wrote:

> From: Ido Schimmel <idosch@nvidia.com>
> 
> While insertion of 16k nexthops all using the same netdev ('dummy10')
> takes less than a second, deletion takes about 130 seconds:
> 
> # time -p ip -b nexthop.batch
> real 0.29
> user 0.01
> sys 0.15
> 
> # time -p ip link set dev dummy10 down
> real 131.03
> user 0.06
> sys 0.52

snip...

> Since nexthops are always deleted under RTNL, synchronize_net() can be
> used instead. It will call synchronize_rcu_expedited() which only blocks
> for several microseconds as opposed to multiple milliseconds like
> synchronize_rcu().
> 
> With this patch deletion of 16k nexthops takes less than a second:
> 
> # time -p ip link set dev dummy10 down
> real 0.12
> user 0.00
> sys 0.04

That's a nice result! Well done! I can't really speak to whether or not
there is any horrible side effect of using synchronize_rcu_expedited(),
but FWIW:

Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>


> 
> Tested with fib_nexthops.sh which includes torture tests that prompted
> the initial change:
> 
> # ./fib_nexthops.sh
> ...
> Tests passed: 134
> Tests failed:   0
> 
> Fixes: 90f33bffa382 ("nexthops: don't modify published nexthop groups")
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>

Nice fix, good commit message, thanks!

> ---
>  net/ipv4/nexthop.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
> index 8c0f17c6863c..0dc43ad28eb9 100644
> --- a/net/ipv4/nexthop.c
> +++ b/net/ipv4/nexthop.c
> @@ -845,7 +845,7 @@ static void remove_nexthop_from_groups(struct net *net, struct nexthop *nh,
>  		remove_nh_grp_entry(net, nhge, nlinfo);
>  
>  	/* make sure all see the newly published array before releasing rtnl */
> -	synchronize_rcu();
> +	synchronize_net();
>  }
>  
>  static void remove_nexthop_group(struct nexthop *nh, struct nl_info *nlinfo)


