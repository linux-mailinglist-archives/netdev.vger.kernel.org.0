Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC745261879
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 19:56:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728301AbgIHR4a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 13:56:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731947AbgIHR4I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 13:56:08 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21728C061573
        for <netdev@vger.kernel.org>; Tue,  8 Sep 2020 10:56:08 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id t13so16230429ile.9
        for <netdev@vger.kernel.org>; Tue, 08 Sep 2020 10:56:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8T+PCf94axCuwCpZHubJbkrjzROS0OankrEuKHVfywM=;
        b=u7pwCHSwhWF2FMPxtsKqWqKsYCP7fhmxp6H6Hvsh+qoJBe8FLWePqz/wz61zDEWZk/
         gJv+LgmgmsBSrIysj7mZSn15rzrdbq95xbjp7P4pfMTouOxjvJ0DVn3hZzgyORADQwqp
         wZXYrHPTN+uBHa3Y+KPyA4M05odS8cN0YTlnG8rCROlo9HVOY6KpdieEejIEwQROIP+R
         ThcCOb/trbh3E85bqmMECrv9YJdGE0Er843fnebokJtpt48QrX7avq1pqnDWaf84yw57
         be5QID+ri/Ex0SB2GFKqK0S63Ukq3J5aGx33XBl51zXRmzgnDTJEBuJcA9iClbr97v9s
         wPBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8T+PCf94axCuwCpZHubJbkrjzROS0OankrEuKHVfywM=;
        b=haQta2xiGgA6GYyOKDGzAiBshGaSaWYKL4GYlR+yEKeQIH+s+Rvm1uN2pWLeq6o1Wz
         AQBxbtEW9JXQLdTZFzcEwAxRKwCksRR+7hmmkV4VuUOx1aAmaWBRSC4H20CkvL6Ya+re
         w7b1hfSEgBo0PBkCKC/QkEe9CIdNS24OwN5t2AsYGFneUEmeXHwjBET/I78iheA+vfC7
         jK8bbk+4xUoWwn+LrROmPwY4dwbihxgJJQKwgJZdBNdpmkgdwSfG/SsKi3hc5WqT3zRV
         LdEzWnOCWHejXJcXqTsWM4V/kAyt7OV6bimp1iVAJr20HKEoyxB1pEiiDz7ec2RfBb7i
         cwpg==
X-Gm-Message-State: AOAM531R0cd69sRRgNun8Dmr3/Onb3Dy4ULl0c7c5cd6cN4mjk92gP93
        SvIkXmoGx5mSaITGcD4pfOw=
X-Google-Smtp-Source: ABdhPJyZj1s1z4gCfOqU/XLy3cgde2kfVeaN+7W6GIzchJ1A1aJb2vKX7WRC8d6FCxgSCHe7ds1g/A==
X-Received: by 2002:a92:3007:: with SMTP id x7mr24731770ile.48.1599587767515;
        Tue, 08 Sep 2020 10:56:07 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:ec70:7b06:eed6:6e35])
        by smtp.googlemail.com with ESMTPSA id m87sm10777941ilb.58.2020.09.08.10.56.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Sep 2020 10:56:06 -0700 (PDT)
Subject: Re: [PATCH net] ipv6: avoid lockdep issue in fib6_del()
To:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
References: <20200908082023.3690438-1-edumazet@google.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <11b1b766-5eb8-4306-605c-a423fc3e1544@gmail.com>
Date:   Tue, 8 Sep 2020 11:56:06 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200908082023.3690438-1-edumazet@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/8/20 2:20 AM, Eric Dumazet wrote:
> syzbot reported twice a lockdep issue in fib6_del() [1]
> which I think is caused by net->ipv6.fib6_null_entry
> having a NULL fib6_table pointer.
> 
> fib6_del() already checks for fib6_null_entry special
> case, we only need to return earlier.
> 
> Bug seems to occur very rarely, I have thus chosen
> a 'bug origin' that makes backports not too complex.

Make sense.
> 
> [1]
...
> 
> Fixes: 421842edeaf6 ("net/ipv6: Add fib6_null_entry")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: David Ahern <dsahern@gmail.com>
> ---
>  net/ipv6/ip6_fib.c | 13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
> index 25a90f3f705c7e6d53615f490f36c5722f3bd8b1..4a664ad4f4d4bb2b521f67e8433a06c77bd301ee 100644
> --- a/net/ipv6/ip6_fib.c
> +++ b/net/ipv6/ip6_fib.c
> @@ -1993,14 +1993,19 @@ static void fib6_del_route(struct fib6_table *table, struct fib6_node *fn,
>  /* Need to own table->tb6_lock */
>  int fib6_del(struct fib6_info *rt, struct nl_info *info)
>  {
> -	struct fib6_node *fn = rcu_dereference_protected(rt->fib6_node,
> -				    lockdep_is_held(&rt->fib6_table->tb6_lock));
> -	struct fib6_table *table = rt->fib6_table;
>  	struct net *net = info->nl_net;
>  	struct fib6_info __rcu **rtp;
>  	struct fib6_info __rcu **rtp_next;
> +	struct fib6_table *table;
> +	struct fib6_node *fn;
>  
> -	if (!fn || rt == net->ipv6.fib6_null_entry)
> +	if (rt == net->ipv6.fib6_null_entry)
> +		return -ENOENT;
> +
> +	table = rt->fib6_table;
> +	fn = rcu_dereference_protected(rt->fib6_node,
> +				       lockdep_is_held(&table->tb6_lock));
> +	if (!fn)
>  		return -ENOENT;
>  
>  	WARN_ON(!(fn->fn_flags & RTN_RTINFO));
> 

seems like a reasonable refactoring for the noted problem.

Reviewed-by: David Ahern <dsahern@gmail.com>

