Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E431955B317
	for <lists+netdev@lfdr.de>; Sun, 26 Jun 2022 19:21:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230491AbiFZRTK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jun 2022 13:19:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230346AbiFZRTJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jun 2022 13:19:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A89BDE095
        for <netdev@vger.kernel.org>; Sun, 26 Jun 2022 10:19:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 36E46B8018A
        for <netdev@vger.kernel.org>; Sun, 26 Jun 2022 17:19:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D053C34114;
        Sun, 26 Jun 2022 17:19:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656263945;
        bh=ebLJMl+ZWkDlsxD4OKbpISWgi9B8atjAPIAdTF5lrAc=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=lJqjbAykt/nQmFyPLEeAZDc+75QUC//mMniqL9UGb8hH7BBAZRoWrp1T0TpLsPFT6
         7/MSaKhDm3EcKw0sRKSh0BGdgtFLFsqd6091XTB519y+qhwDJEBM1qoncsZrbnsrZA
         PINb/eCDIOudN8kXOX308I4I4RQMpEfuWFS4Yscrx7pghE7KahkH2on8Tgwv8+zP2L
         OpxzIiRKlGp5nKvTkOQSkIA5i0CARP6bgUNisQ9LoaJ1ZG0nMfbifq0tWY8HFqCoAW
         5N2EFe7Ycu4g0kfAKCgfSSC83OszDmNcpkt7ouZJSbgr2+WQU8yBQ0IuAs6HaVN1Rm
         VW1yQgGt+DLoA==
Message-ID: <e398f5ae-6dad-2d98-aa29-fd1fda759b28@kernel.org>
Date:   Sun, 26 Jun 2022 11:19:04 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.10.0
Subject: Re: [PATCH net] ipv6: take care of disable_policy when restoring
 routes
Content-Language: en-US
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Steffen Klassert <klassert@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     netdev@vger.kernel.org, stable@kernel.org,
        David Forster <dforster@brocade.com>,
        Siwar Zitouni <siwar.zitouni@6wind.com>
References: <20220623120015.32640-1-nicolas.dichtel@6wind.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20220623120015.32640-1-nicolas.dichtel@6wind.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/23/22 6:00 AM, Nicolas Dichtel wrote:
> When routes corresponding to addresses are restored by
> fixup_permanent_addr(), the dst_nopolicy parameter was not set.
> The typical use case is a user that configures an address on a down
> interface and then put this interface up.
> 
> Let's take care of this flag in addrconf_f6i_alloc(), so that every callers
> benefit ont it.
> 
> CC: stable@kernel.org
> CC: David Forster <dforster@brocade.com>
> Fixes: df789fe75206 ("ipv6: Provide ipv6 version of "disable_policy" sysctl")
> Reported-by: Siwar Zitouni <siwar.zitouni@6wind.com>
> Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
> ---
> 
> I choose to be conservative in my patch, thus I filter anycast addresses. But
> I don't see why this flag is not set on anycast routes. Any thoughts
> about this?

no strong opinions here.

> 
>  net/ipv6/addrconf.c | 4 ----
>  net/ipv6/route.c    | 9 ++++++++-
>  2 files changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
> index 1b1932502e9e..5864cbc30db6 100644
> --- a/net/ipv6/addrconf.c
> +++ b/net/ipv6/addrconf.c
> @@ -1109,10 +1109,6 @@ ipv6_add_addr(struct inet6_dev *idev, struct ifa6_config *cfg,
>  		goto out;
>  	}
>  
> -	if (net->ipv6.devconf_all->disable_policy ||
> -	    idev->cnf.disable_policy)
> -		f6i->dst_nopolicy = true;
> -
>  	neigh_parms_data_state_setall(idev->nd_parms);
>  
>  	ifa->addr = *cfg->pfx;
> diff --git a/net/ipv6/route.c b/net/ipv6/route.c
> index d25dc83bac62..828355710c57 100644
> --- a/net/ipv6/route.c
> +++ b/net/ipv6/route.c
> @@ -4569,8 +4569,15 @@ struct fib6_info *addrconf_f6i_alloc(struct net *net,
>  	}
>  
>  	f6i = ip6_route_info_create(&cfg, gfp_flags, NULL);
> -	if (!IS_ERR(f6i))
> +	if (!IS_ERR(f6i)) {
>  		f6i->dst_nocount = true;
> +
> +		if (!anycast &&
> +		    (net->ipv6.devconf_all->disable_policy ||
> +		     idev->cnf.disable_policy))
> +			f6i->dst_nopolicy = true;
> +	}
> +
>  	return f6i;
>  }
>  

Reviewed-by: David Ahern <dsahern@kernel.org>
