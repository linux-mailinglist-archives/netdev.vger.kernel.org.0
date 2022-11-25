Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49DDD6382F5
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 05:00:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbiKYEAj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 23:00:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbiKYEAa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 23:00:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 139B624BE0;
        Thu, 24 Nov 2022 20:00:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D2ACDB8294F;
        Fri, 25 Nov 2022 04:00:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D6ECC433D6;
        Fri, 25 Nov 2022 04:00:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669348825;
        bh=0ncaSe79cpwev/GLzrjvk94rTWihJRKM5GtqTSlAKg0=;
        h=Date:Subject:To:References:From:In-Reply-To:From;
        b=CwVS9hfYBh7PIMcc9t6i6zqDqB9YX1nwopROM5EZJwAo6qS4++d9xeJdcfsK52hCq
         4wANYO4qu1lR408AhtavIcQnEothXEfSPvjJJfJYgw4EWgEkACgA0F9LwMK3SneB6r
         oEhhTHlDyLLfQU0/gjf0FgEqtKe5770IJ96O/nclh9uDTapCw3b81dg3Ez3VV+J4se
         cmt1TUOfP6ympDq231YVdL3ssZ+qzcxEt09YT/cWkJV3jKZfTZxbvAX/PBQfH8QiP5
         lI428ctlvHZ2fFSaazJ/H7Dkg1y2ilyGvKB1ZmeDG+hF9M5gYRIgf6UlENASTeAdcC
         1ubohkM9eCmTg==
Message-ID: <ba4d41bc-ec24-f4b4-e4d5-f9db51fed071@kernel.org>
Date:   Thu, 24 Nov 2022 20:00:24 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.1
Subject: Re: [PATCH] net: setsockopt: fix IPV6_UNICAST_IF option for connected
 sockets
Content-Language: en-US
To:     Richard Gobert <richardbgobert@gmail.com>, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20221124114713.GA73129@debian>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20221124114713.GA73129@debian>
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

On 11/24/22 4:48 AM, Richard Gobert wrote:
> Change the behaviour of ip6_datagram_connect to consider the interface
> set by the IPV6_UNICAST_IF socket option, similarly to udpv6_sendmsg.
> 
> This change is the IPv6 counterpart of the fix for IP_UNICAST_IF.
> The tests introduced by that patch showed that the incorrect
> behavior is present in IPv6 as well.
> This patch fixes the broken test.
> 
> Reported-by: kernel test robot <oliver.sang@intel.com>
> Link: https://lore.kernel.org/r/202210062117.c7eef1a3-oliver.sang@intel.com
> 

Fixes tag here.

> Signed-off-by: Richard Gobert <richardbgobert@gmail.com>
> ---
>  net/ipv6/datagram.c | 16 +++++++++++-----
>  1 file changed, 11 insertions(+), 5 deletions(-)
> 
> diff --git a/net/ipv6/datagram.c b/net/ipv6/datagram.c
> index 7c7155b48f17..c3999f9e3545 100644
> --- a/net/ipv6/datagram.c
> +++ b/net/ipv6/datagram.c
> @@ -42,24 +42,30 @@ static void ip6_datagram_flow_key_init(struct flowi6 *fl6, struct sock *sk)
>  {
>  	struct inet_sock *inet = inet_sk(sk);
>  	struct ipv6_pinfo *np = inet6_sk(sk);
> +	int oif;

	int oif = sk->sk_bound_dev_if;
>  
>  	memset(fl6, 0, sizeof(*fl6));
>  	fl6->flowi6_proto = sk->sk_protocol;
>  	fl6->daddr = sk->sk_v6_daddr;
>  	fl6->saddr = np->saddr;
> -	fl6->flowi6_oif = sk->sk_bound_dev_if;
> +	oif = sk->sk_bound_dev_if;

and then drop this line in the middle of all of the fl6 setup.

>  	fl6->flowi6_mark = sk->sk_mark;
>  	fl6->fl6_dport = inet->inet_dport;
>  	fl6->fl6_sport = inet->inet_sport;
>  	fl6->flowlabel = np->flow_label;
>  	fl6->flowi6_uid = sk->sk_uid;
>  
> -	if (!fl6->flowi6_oif)
> -		fl6->flowi6_oif = np->sticky_pktinfo.ipi6_ifindex;
> +	if (!oif)
> +		oif = np->sticky_pktinfo.ipi6_ifindex;
>  
> -	if (!fl6->flowi6_oif && ipv6_addr_is_multicast(&fl6->daddr))
> -		fl6->flowi6_oif = np->mcast_oif;
> +	if (!oif) {
> +		if (ipv6_addr_is_multicast(&fl6->daddr))
> +			oif = np->mcast_oif;
> +		else
> +			oif = np->ucast_oif;
> +	}
>  
> +	fl6->flowi6_oif = oif;
>  	security_sk_classify_flow(sk, flowi6_to_flowi_common(fl6));
>  }
>  

thanks for the fix.

Besides the nit,
Reviewed-by: David Ahern <dsahern@kernel.org>
