Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 078292EC188
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 17:56:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727558AbhAFQzx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 11:55:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727273AbhAFQzw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 11:55:52 -0500
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17630C06134D
        for <netdev@vger.kernel.org>; Wed,  6 Jan 2021 08:55:12 -0800 (PST)
Received: by mail-ot1-x32e.google.com with SMTP id b24so3621255otj.0
        for <netdev@vger.kernel.org>; Wed, 06 Jan 2021 08:55:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=B0MrxKRy2LHEvQ3Uofmz63gSLowsTGCYhzfAX1ZL7iQ=;
        b=fj21VGbfucIDNLeyIqLzC1KexGreqvU51hJeryPlNe2Ad6Cp4ZJhiI54dPMl2wxax3
         Q3aF30YvY4/jxnj4kq0KUrbSRi5ORC548RGLKreHc28Vrx1pOijWkckS+fDtK0zGGPwU
         LMNHk3ADjaRP0vMoBfHIiAezr7TLtm9vmvQfLpUkuC2SbBYpB8JfK4zApFLI4MzSrP37
         PZVx8vS+pgqMwbERICYF31b/3vxZPJjjn0dOit3C9xOC0rl6CfHkzn/y5UJmzq6D2C+k
         LqhB/dhg94FZ3S7a+y6JXhBqhbR7aXbE2iD+daseKxT5LROMyyz5T5kV/Xw1B6D7zXSx
         dViA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=B0MrxKRy2LHEvQ3Uofmz63gSLowsTGCYhzfAX1ZL7iQ=;
        b=mwrQxv1h/acXGPsPaA8oZnsArn+KKxuO1cm/9nr3/3kXipZyB+J9dKD4rMlwJT9jyl
         OahAvOPuI8csjVp67+ldFTQwCwfsn/ORruF9ICrdSut7qBLo1vrXkK0z2Lrjz3SkKbyb
         fsYFqrQ0NJpRVTW0mK1iqeknFUVTomx7/eokAxHL2l0y4eu+nhA7nq6llGabSNoeiebT
         Esg3YxEISYRYnGOrQ377ITQNu3tkNZm+MtngnqFaXIniOTgVba0qS1hWyAcBUERWUBn2
         mdgRtV3HikJjX/DXyWD5+VIkmsJxYC7Ur14urPP8bC2grxTV3GWZYz9qZwpqUyjRNy9B
         G10A==
X-Gm-Message-State: AOAM532dlueE2sqTjxjY+QGtHj4xncUF7AMCpkbC7yRxXBZUN6fR+zEd
        GnlEwMQTHModtjJz1JkADeFAAjZpzF4=
X-Google-Smtp-Source: ABdhPJwPJVbIKTxfpWkN6WIOrgApUWoBk+fTHenDWXUcC3WazPiKc1iogDYAzit8Zvin/l4607sJxA==
X-Received: by 2002:a05:6830:1bc6:: with SMTP id v6mr3838861ota.135.1609952111501;
        Wed, 06 Jan 2021 08:55:11 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:282:800:dc80:e074:7fa1:391b:b88d])
        by smtp.googlemail.com with ESMTPSA id z38sm601015ooi.34.2021.01.06.08.55.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Jan 2021 08:55:10 -0800 (PST)
Subject: Re: [net PATCH 1/2] net: ipv6: fib: flush exceptions when purging
 route
To:     Sean Tranchetti <stranche@quicinc.com>, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org
Cc:     subashab@codearurora.org,
        Sean Tranchetti <stranche@codeaurora.org>,
        Wei Wang <weiwan@google.com>
References: <1609892546-11389-1-git-send-email-stranche@quicinc.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <9290e64d-7e07-53c7-5b3a-4e24498c65be@gmail.com>
Date:   Wed, 6 Jan 2021 09:55:09 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <1609892546-11389-1-git-send-email-stranche@quicinc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/5/21 5:22 PM, Sean Tranchetti wrote:
> From: Sean Tranchetti <stranche@codeaurora.org>
> 
> Route removal is handled by two code paths. The main removal path is via
> fib6_del_route() which will handle purging any PMTU exceptions from the
> cache, removing all per-cpu copies of the DST entry used by the route, and
> releasing the fib6_info struct.
> 
> The second removal location is during fib6_add_rt2node() during a route
> replacement operation. This path also calls fib6_purge_rt() to handle
> cleaning up the per-cpu copies of the DST entries and releasing the
> fib6_info associated with the older route, but it does not flush any PMTU
> exceptions that the older route had. Since the older route is removed from
> the tree during the replacement, we lose any way of accessing it again.
> 
> As these lingering DSTs and the fib6_info struct are holding references to
> the underlying netdevice struct as well, unregistering that device from the
> kernel can never complete.
> 

I think the right fixes tag is:

Fixes: 2b760fcf5cfb3 ("ipv6: hook up exception table to store dst cache")

cc'ed author of that patch.

> Signed-off-by: Sean Tranchetti <stranche@codeaurora.org>
> ---
>  net/ipv6/ip6_fib.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
> index 605cdd3..f43e275 100644
> --- a/net/ipv6/ip6_fib.c
> +++ b/net/ipv6/ip6_fib.c
> @@ -1025,6 +1025,8 @@ static void fib6_purge_rt(struct fib6_info *rt, struct fib6_node *fn,
>  {
>  	struct fib6_table *table = rt->fib6_table;
>  
> +	/* Flush all cached dst in exception table */
> +	rt6_flush_exceptions(rt);
>  	fib6_drop_pcpu_from(rt, table);
>  
>  	if (rt->nh && !list_empty(&rt->nh_list))
> @@ -1927,9 +1929,6 @@ static void fib6_del_route(struct fib6_table *table, struct fib6_node *fn,
>  	net->ipv6.rt6_stats->fib_rt_entries--;
>  	net->ipv6.rt6_stats->fib_discarded_routes++;
>  
> -	/* Flush all cached dst in exception table */
> -	rt6_flush_exceptions(rt);
> -
>  	/* Reset round-robin state, if necessary */
>  	if (rcu_access_pointer(fn->rr_ptr) == rt)
>  		fn->rr_ptr = NULL;
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


