Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6DDB6243A0
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 14:51:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231226AbiKJNvX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 08:51:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231235AbiKJNvV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 08:51:21 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD4151743E;
        Thu, 10 Nov 2022 05:51:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=KLBqLgMW/J+kUYh//78nQLqBYL/YSG7r5+kbe5pMFp8=; b=wuATyY99/h3XOViGQ7CGKdEiNZ
        oKj4Zk1EbyxMWcbViXKJVsYI+Z4UPKps8HBv8ztC0XMlXpOsg+KOceQxTQ7N8BJwn/6OiyA4lNRsW
        A8kTMh0Tc+bB9gah9K5+Zf7/xO7l9ZfTKnomM81333QScgsq8t3Fp8O1D14ZljBW3u3s=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ot7xN-0022Le-Tn; Thu, 10 Nov 2022 14:51:01 +0100
Date:   Thu, 10 Nov 2022 14:51:01 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jamie Bainbridge <jamie.bainbridge@gmail.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tcp: Add listening address to SYN flood message
Message-ID: <Y20Bxc1gQ8nrFsvA@lunn.ch>
References: <f847459dc0a0e2d8ffa1d290d06e0e4a226a6f39.1668075479.git.jamie.bainbridge@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f847459dc0a0e2d8ffa1d290d06e0e4a226a6f39.1668075479.git.jamie.bainbridge@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 10, 2022 at 09:21:06PM +1100, Jamie Bainbridge wrote:
> The SYN flood message prints the listening port number, but on a system
> with many processes bound to the same port on different IPs, it's
> impossible to tell which socket is the problem.
> 
> Add the listen IP address to the SYN flood message. It might have been
> nicer to print the address first, but decades of monitoring tools are
> watching for the string "SYN flooding on port" so don't break that.
> 
> Tested with each protcol's "any" address and a host address:
> 
>  Possible SYN flooding on port 9001. IP 0.0.0.0.
>  Possible SYN flooding on port 9001. IP 127.0.0.1.
>  Possible SYN flooding on port 9001. IP ::.
>  Possible SYN flooding on port 9001. IP fc00::1.
> 
> Signed-off-by: Jamie Bainbridge <jamie.bainbridge@gmail.com>
> ---
>  net/ipv4/tcp_input.c | 16 +++++++++++++---
>  1 file changed, 13 insertions(+), 3 deletions(-)
> 
> diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> index 0640453fce54b6daae0861d948f3db075830daf6..fb86056732266fedc8ad574bbf799dbdd7a425a3 100644
> --- a/net/ipv4/tcp_input.c
> +++ b/net/ipv4/tcp_input.c
> @@ -6831,9 +6831,19 @@ static bool tcp_syn_flood_action(const struct sock *sk, const char *proto)
>  		__NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPREQQFULLDROP);
>  
>  	if (!queue->synflood_warned && syncookies != 2 &&
> -	    xchg(&queue->synflood_warned, 1) == 0)
> -		net_info_ratelimited("%s: Possible SYN flooding on port %d. %s.  Check SNMP counters.\n",
> -				     proto, sk->sk_num, msg);
> +	    xchg(&queue->synflood_warned, 1) == 0) {
> +#if IS_ENABLED(CONFIG_IPV6)
> +		if (sk->sk_family == AF_INET6) {

Can the IS_ENABLED() go inside the if? You get better build testing
that way.

     Andrew
