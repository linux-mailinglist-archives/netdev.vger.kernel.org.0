Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBC6762CF50
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 01:05:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232869AbiKQAFu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 19:05:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232527AbiKQAFt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 19:05:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6906B876
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 16:05:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 42D3A61F23
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 00:05:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62DAAC433D6;
        Thu, 17 Nov 2022 00:05:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668643547;
        bh=NoK+Dtu/WJC9kC09UYULU4slH+/XiEoJR7RRjImClT8=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=HSum+XpSiJH3UqvKqHrJFb6BrGIPzg2Qj6B4/FcZBsjK1k/VLT3l0/rQsRPEcfCIa
         jyOBLu4AqViz1pvXOKTkmrNj1EEtzI1zRwOoykY+WCHdP1AIl6NGcwNpCkwH1u7UhC
         ShZRJaeIMe5m/QDBRFwnyQOU8iazvYT0T755AmNKhJ3F/cuVPCDaFsfszNXvDvle3V
         yHTX42bWVFruGfjJcMwdMEfO3GQGiNoPItkLmd9PeZLmOwOPWxarmmi6t/R0Y/3aqn
         7qEi+WLor9UQngx7ky698Z9rM2qWH5HfQXd7Q+fob8oeEf9dIPqv7gV4gipMsGaEHl
         VoXtihrE4vffA==
Message-ID: <7bd211f1-e970-0ad2-8346-69849f0347c4@kernel.org>
Date:   Wed, 16 Nov 2022 17:05:46 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.1
Subject: Re: [PATCH net-next 2/6] ipv6: fib6_new_sernum() optimization
Content-Language: en-US
To:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com
References: <20221115091101.2234482-1-edumazet@google.com>
 <20221115091101.2234482-3-edumazet@google.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20221115091101.2234482-3-edumazet@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/15/22 2:10 AM, Eric Dumazet wrote:
> Adopt atomic_try_cmpxchg() which is slightly more efficient.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: David Ahern <dsahern@kernel.org>
> ---
>  net/ipv6/ip6_fib.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
> index 413f66781e50de62d6b20042d84798e7da59165a..2438da5ff6da810d9f612fc66df4d28510f50f10 100644
> --- a/net/ipv6/ip6_fib.c
> +++ b/net/ipv6/ip6_fib.c
> @@ -91,13 +91,12 @@ static void fib6_walker_unlink(struct net *net, struct fib6_walker *w)
>  
>  static int fib6_new_sernum(struct net *net)
>  {
> -	int new, old;
> +	int new, old = atomic_read(&net->ipv6.fib6_sernum);
>  
>  	do {
> -		old = atomic_read(&net->ipv6.fib6_sernum);
>  		new = old < INT_MAX ? old + 1 : 1;
> -	} while (atomic_cmpxchg(&net->ipv6.fib6_sernum,
> -				old, new) != old);
> +	} while (!atomic_try_cmpxchg(&net->ipv6.fib6_sernum, &old, new));
> +
>  	return new;
>  }
>  

Reviewed-by: David Ahern <dsahern@kernel.org>
