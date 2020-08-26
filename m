Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54A952537EC
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 21:12:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726851AbgHZTMc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 15:12:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726723AbgHZTMa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 15:12:30 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CB5BC061574
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 12:12:30 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id v2so2779245ilq.4
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 12:12:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8z5Xhi6enr8YdRnDjy52EOoKpYINSm+nC7W2doz3ps4=;
        b=Lc7C7uHma+9V9S1b+uS2/nCyCMbZ57VnbhoIshNDVaXsImyXUnXorXQNEBaVKW3fUy
         Ib8jtrZ8KN5cybrM5Ph8+hcS+dlIfg8zVl2iA7H1x2irtHf83hJvSGlKVV1dvBZ3vq7v
         f+QNHZNiEv3L+l+jBsev9id3bmL6TXkPQp2GXU7Xu0tUM11c1qQWWdejmcpo/8Nq2U/A
         fZ5cVYahwdv87Q8rW3eXt2G+cl8F09TjS76rXV8F2YXe29Hh6iy1zjcDB+LQxNlLiYHh
         4jr3aq1hZwmPvHkjRm12dbQJIsiVXpwzFgqWXaCpm8uPeUW5iIyVNWGtSPK4HMWZSEIS
         cw1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8z5Xhi6enr8YdRnDjy52EOoKpYINSm+nC7W2doz3ps4=;
        b=KINsLVktrPxIrWtmFN+HTRZlkhm/aJtCKkQVVibCn//p9WLGnlr2OdNDKETVI30rzH
         OwfE0qkpaW9AmI08fUf3vO6TxGHe6X+n3oyRofsaaNaH0KO7BKMqoQaC8RyX6xRpTI4a
         VzZpnShZ0w7rBCmaoI7Q0MHgdVxqMxOzZpoq2aRH14IBr5fTT2FP/82aMrsC5mqSyqol
         CVQ597k6XhyEYDH3yWOcNkEmucSUGxFOyxdHjGh7bRYixFHkar8aBD/H0cZtcX2fqOHR
         QIHMgLKRla5QXIPd1Ob+VEUMGMluFLHtN5XNMsprLIGs43Eb3SR8TU9cTDZ56XUhxRZr
         qCOQ==
X-Gm-Message-State: AOAM532Ls2eJvrIxhFRhsmxABJLZ9GSMnLapy5Mz6RTkrwTnAaWgrgXn
        AMhn5t352KopvlUtDb1sk+k=
X-Google-Smtp-Source: ABdhPJxTb/gplm1jjKlmNz1xmt0VifNoF7pSLEc+P+2SRqJT7PFEam1ddsMFW/6IniBfa8Ej3Eye0A==
X-Received: by 2002:a92:a1c5:: with SMTP id b66mr10801145ill.71.1598469149576;
        Wed, 26 Aug 2020 12:12:29 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:305a:ae30:42e4:e2ca])
        by smtp.googlemail.com with ESMTPSA id u68sm1618144ioe.18.2020.08.26.12.12.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Aug 2020 12:12:29 -0700 (PDT)
Subject: Re: [PATCH net-next 4/7] ipv4: nexthop: Correctly update nexthop
 group when removing a nexthop
To:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
References: <20200826164857.1029764-1-idosch@idosch.org>
 <20200826164857.1029764-5-idosch@idosch.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <11cecb67-cbe5-4d54-1644-fc775a87acb2@gmail.com>
Date:   Wed, 26 Aug 2020 13:12:28 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200826164857.1029764-5-idosch@idosch.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/26/20 10:48 AM, Ido Schimmel wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> Each nexthop group contains an indication if it has IPv4 nexthops
> ('has_v4'). Its purpose is to prevent IPv6 routes from using groups with
> IPv4 nexthops.
> 
> However, the indication is not updated when a nexthop is removed. This
> results in the kernel wrongly rejecting IPv6 routes from pointing to
> groups that only contain IPv6 nexthops. Example:
> 
> # ip nexthop replace id 1 via 192.0.2.2 dev dummy10
> # ip nexthop replace id 2 via 2001:db8:1::2 dev dummy10
> # ip nexthop replace id 10 group 1/2
> # ip nexthop del id 1
> # ip route replace 2001:db8:10::/64 nhid 10
> Error: IPv6 routes can not use an IPv4 nexthop.
> 
> Solve this by updating the indication according to the new set of
> member nexthops.
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  net/ipv4/nexthop.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
> index 1b736e3e1baa..5199a2815df6 100644
> --- a/net/ipv4/nexthop.c
> +++ b/net/ipv4/nexthop.c
> @@ -797,7 +797,7 @@ static void remove_nh_grp_entry(struct net *net, struct nh_grp_entry *nhge,
>  		return;
>  	}
>  
> -	newg->has_v4 = nhg->has_v4;
> +	newg->has_v4 = false;
>  	newg->mpath = nhg->mpath;
>  	newg->fdb_nh = nhg->fdb_nh;
>  	newg->num_nh = nhg->num_nh;
> @@ -806,12 +806,18 @@ static void remove_nh_grp_entry(struct net *net, struct nh_grp_entry *nhge,
>  	nhges = nhg->nh_entries;
>  	new_nhges = newg->nh_entries;
>  	for (i = 0, j = 0; i < nhg->num_nh; ++i) {
> +		struct nh_info *nhi;
> +
>  		/* current nexthop getting removed */
>  		if (nhg->nh_entries[i].nh == nh) {
>  			newg->num_nh--;
>  			continue;
>  		}
>  
> +		nhi = rtnl_dereference(nhges[i].nh->nh_info);
> +		if (nhi->family == AF_INET)
> +			newg->has_v4 = true;
> +
>  		list_del(&nhges[i].nh_list);
>  		new_nhges[j].nh_parent = nhges[i].nh_parent;
>  		new_nhges[j].nh = nhges[i].nh;
> 

Reviewed-by: David Ahern <dsahern@gmail.com>
