Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 559286DE015
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 17:55:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231217AbjDKPzd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 11:55:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231214AbjDKPza (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 11:55:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4615044A3
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 08:55:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D071F628C9
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 15:55:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11142C433D2;
        Tue, 11 Apr 2023 15:55:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681228527;
        bh=9+O55Y1oijHTjHZtskQYGTLpei1p4Gwpm1UjhLPceuM=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=diIUB4hpJs+bhlRuhjcuc6KFcbywLvNSaYHQ+sJskWYXSTm8RR+Sk6Ilslyfss/+5
         rrCXIe+lxqhz0lbDQfP8+aZqWYYUmFhfKYrKBcXYS4LKiwkHm4JDbd3ATuDGDO9rQD
         wvV4peVzP86OpzbLHV4kKnA4d8JVXTcXvjve+iIY/Sm0UDH2waRJ6pkUcnp8/Z043p
         NU0naWJpn652l2jFhCL+F6RWFb2nlM/rv+PCnu1r1tN1YQnKkF4X4UPZ5FTy2wts7I
         W0GmW5n8Lt0OOErjwkZcUDgy94vHx06R9YzxXm50U/Uzvz1ZcOjc5JGVt3m9pNTBCf
         l/F+/WZQdlgMA==
Message-ID: <ac05b04d-a7ad-3804-39fd-2267904e9f23@kernel.org>
Date:   Tue, 11 Apr 2023 09:55:25 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.1
Subject: Re: [PATCH iproute2] iptunnel: detect protocol mismatch on tunnel
 change
Content-Language: en-US
To:     Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org
Cc:     bluca@debian.org, Robin <imer@imer.cc>
References: <20230410233509.7616-1-stephen@networkplumber.org>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20230410233509.7616-1-stephen@networkplumber.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/10/23 5:35 PM, Stephen Hemminger wrote:
> diff --git a/ip/iptunnel.c b/ip/iptunnel.c
> index 02c3670b469d..b6da145913d6 100644
> --- a/ip/iptunnel.c
> +++ b/ip/iptunnel.c
> @@ -17,6 +17,7 @@
>  #include <net/if_arp.h>
>  #include <linux/ip.h>
>  #include <linux/if_tunnel.h>
> +#include <linux/ip6_tunnel.h>
>  
>  #include "rt_names.h"
>  #include "utils.h"
> @@ -172,11 +173,20 @@ static int parse_args(int argc, char **argv, int cmd, struct ip_tunnel_parm *p)
>  			if (get_ifname(p->name, *argv))
>  				invarg("\"name\" not a valid ifname", *argv);
>  			if (cmd == SIOCCHGTUNNEL && count == 0) {
> -				struct ip_tunnel_parm old_p = {};
> +				union {
> +					struct ip_tunnel_parm ip_tnl;
> +					struct ip6_tnl_parm2 ip6_tnl;
> +				} old_p = {};'

That addresses the stack smashing, but ....

>  
>  				if (tnl_get_ioctl(*argv, &old_p))
>  					return -1;
> -				*p = old_p;
> +
> +				if (old_p.ip_tnl.iph.version != 4 ||
> +				    old_p.ip_tnl.iph.ihl != 5)

this field overlays laddr in ip6_tnl_parm2 which means there is a
collision in valid addresses.


> +					invarg("\"name\" is not an ip tunnel",
> +					       *argv);
> +
> +				*p = old_p.ip_tnl;
>  			}
>  		}
>  		count++;

