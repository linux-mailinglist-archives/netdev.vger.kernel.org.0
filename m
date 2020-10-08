Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 733842879FD
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 18:31:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730161AbgJHQbN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 12:31:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726029AbgJHQbN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 12:31:13 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44B93C061755
        for <netdev@vger.kernel.org>; Thu,  8 Oct 2020 09:31:13 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id 7so4731116pgm.11
        for <netdev@vger.kernel.org>; Thu, 08 Oct 2020 09:31:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=oiJYtPu41HGw8+LXAzTx3b0LlTOWLZ98J+XiMdVn0j4=;
        b=j6ni/qUVUkGcGcp0kwEFRyzbRqH27FD/7RiRSphtG5+u/v50nk4M518DLlgMhyFoEZ
         YHd4plQ7LosVM+82i2y5IpaT2dXTx6ZiMYMOWyY/07eH0CPDNzls93+SuI1wHdbYLqfX
         rEHRV6Mn6gLS1OFOk5JUcx9ORgq55KmVmpr6+Xxw/olFGn3CERi7EHNwxDhg5Qxdjf2f
         awBv4UQwL6JCFgsAB7INJqkYrGAOY/W3hCTv3Js95BDJgnIpwboNpRH0P6EKF1vGutXb
         AI5F5POXKnCK3ZsUUFWveTQJ48wY/TprAEsd1lhFo/xlxx89EKsTHDYV6v13e5+1qnFF
         89cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oiJYtPu41HGw8+LXAzTx3b0LlTOWLZ98J+XiMdVn0j4=;
        b=lwDJRSKs0PaRbdjwofL+GC9nKDNe1ynEixVZKz9XGXuNnMJCCZss7fv4DV7rB90/cz
         PzyqrQPPJwtiovIfzbxdY3p9gewK1vZZgFu34eyVUX1sbXwbblFNVRWAjmKHlcGvtY/v
         CeHgfii12iMPb9YLa0fWMP8/g5YhxLFihxJggLz4iK5cgTHReiyPFRtaNma1mvvoklL8
         eADGOHViK1Y9aMIt3eaXs9v6SxOXyKr+2zKSjhTXxIMQKLqfq2IT6QkCUTgn2Nm/lFQK
         DnVmyzbOZcCZkksbqeis+NWL4fitn9FdRnnf0YES5vVCTodjfPEwgT0ZZvOELiUL0IRT
         yoJQ==
X-Gm-Message-State: AOAM532TopktYFeUmkcvLcx1tifofiywAOv80JPVhft5NgsIcZ5e0C6h
        +/R8xQLez+/9tAbJxoVbO2A=
X-Google-Smtp-Source: ABdhPJz4AORo6fiBMRWuKByrIwuSrU5scaZUcOxJTyI5OWd8z++qgFUWEY8OsZcKrW8ATduHYvCVRg==
X-Received: by 2002:a17:90a:d489:: with SMTP id s9mr4496178pju.50.1602174672791;
        Thu, 08 Oct 2020 09:31:12 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([72.164.175.30])
        by smtp.googlemail.com with ESMTPSA id kv19sm7691896pjb.22.2020.10.08.09.31.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Oct 2020 09:31:11 -0700 (PDT)
Subject: Re: [PATCH 1/2] net/ipv6: always honour route mtu during forwarding
To:     =?UTF-8?Q?Maciej_=c5=bbenczykowski?= <zenczykowski@gmail.com>,
        =?UTF-8?Q?Maciej_=c5=bbenczykowski?= <maze@google.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Linux Network Development Mailing List <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Lorenzo Colitti <lorenzo@google.com>,
        Sunmeet Gill <sgill@quicinc.com>,
        Vinay Paradkar <vparadka@qti.qualcomm.com>,
        Tyler Wear <twear@quicinc.com>,
        David Ahern <dsahern@kernel.org>
References: <20201008033102.623894-1-zenczykowski@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <902c6608-dbf8-2ba9-4202-c43dac322b3e@gmail.com>
Date:   Thu, 8 Oct 2020 09:31:11 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201008033102.623894-1-zenczykowski@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/7/20 8:31 PM, Maciej Żenczykowski wrote:
> From: Maciej Żenczykowski <maze@google.com>
> 
> This matches the new ipv4 behaviour as of commit:
>   commit 02a1b175b0e92d9e0fa5df3957ade8d733ceb6a0
>   Author: Maciej Żenczykowski <maze@google.com>
>   Date:   Wed Sep 23 13:18:15 2020 -0700
> 
>   net/ipv4: always honour route mtu during forwarding

just summarize that as:
commit 02a1b175b0e9 ("net/ipv4: always honour route mtu during forwarding")



> diff --git a/include/net/ip6_route.h b/include/net/ip6_route.h
> index 2a5277758379..598415743f46 100644
> --- a/include/net/ip6_route.h
> +++ b/include/net/ip6_route.h
> @@ -311,19 +311,13 @@ static inline bool rt6_duplicate_nexthop(struct fib6_info *a, struct fib6_info *
>  static inline unsigned int ip6_dst_mtu_forward(const struct dst_entry *dst)
>  {
>  	struct inet6_dev *idev;
> -	unsigned int mtu;
> +	unsigned int mtu = dst_metric_raw(dst, RTAX_MTU);

newline here for readability

> +	if (mtu)
> +		return mtu;
>  
> -	if (dst_metric_locked(dst, RTAX_MTU)) {
> -		mtu = dst_metric_raw(dst, RTAX_MTU);
> -		if (mtu)
> -			return mtu;
> -	}
> -
> -	mtu = IPV6_MIN_MTU;
>  	rcu_read_lock();
>  	idev = __in6_dev_get(dst->dev);
> -	if (idev)
> -		mtu = idev->cnf.mtu6;
> +	mtu = idev ? idev->cnf.mtu6 : IPV6_MIN_MTU;
>  	rcu_read_unlock();
>  
>  	return mtu;
> 

besides the nit comments, the change looks fine to me. Please add test
cases to tools/testing/selftests/net/pmtu.sh for this change.
