Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 721EB4FE399
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 16:19:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352575AbiDLOWA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 10:22:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229922AbiDLOV7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 10:21:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C495A4CD63;
        Tue, 12 Apr 2022 07:19:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 54230B81B79;
        Tue, 12 Apr 2022 14:19:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD641C385A5;
        Tue, 12 Apr 2022 14:19:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649773179;
        bh=1VUTZxonrCDkfPHXmdBH8Zj1TmEucW75R7ve0axxL0k=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=of4K9vJZ+LeNJbW6AbXYt+DWGKQsDW2i5QxkJhqVNXkQcgeq2rfs8qAFJ/jUa9Dmf
         Kp0M5377b9xO7kL+BNh7mUEnpNMMl+KjXXkVoDXvkEqcJ4Y7vjDdSgaYGtBuiZzBVE
         l68rZx0CyCBtW77IHI0Kk6xa2rXQn0K4yFtDkh+m5//bopSL9J0QbD7R+r4Qk4tQr9
         B/gXEcYld+1o08ke+sFGiRAG6l7gSoqInN0lpnXqQd8EfN0tQAUIIY1n4W4xeQOYL2
         VpV/CO6QeXNSRM+wLcWHgnm02Uv1Kx/McNJRuCMj2JstOlSOVPcVGKFaCSwr0LqF71
         O7+P2T3bptneQ==
Message-ID: <a64e1342-c953-40c5-2afb-0e9654e7d002@kernel.org>
Date:   Tue, 12 Apr 2022 08:19:37 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: [PATCH nf] netfilter: Update ip6_route_me_harder to consider L3
 domain
Content-Language: en-US
To:     Martin Willi <martin@strongswan.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
References: <20220412074639.1963131-1-martin@strongswan.org>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20220412074639.1963131-1-martin@strongswan.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/12/22 1:46 AM, Martin Willi wrote:
> @@ -39,6 +38,13 @@ int ip6_route_me_harder(struct net *net, struct sock *sk_partial, struct sk_buff
>  	};
>  	int err;
>  
> +	if (sk && sk->sk_bound_dev_if)
> +		fl6.flowi6_oif = sk->sk_bound_dev_if;
> +	else if (strict)
> +		fl6.flowi6_oif = dev->ifindex;
> +	else
> +		fl6.flowi6_oif = l3mdev_master_ifindex(dev);

For top of tree, this is now fl6.flowi6_l3mdev and dev is only needed
here so make this:
	fl6.flowi6_l3mdev = l3mdev_master_ifindex(skb_dst(skb)->dev);

> +
>  	fib6_rules_early_flow_dissect(net, skb, &fl6, &flkeys);
>  	dst = ip6_route_output(net, sk, &fl6);
>  	err = dst->error;

