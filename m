Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0F91380623
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 11:24:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232266AbhENJZg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 05:25:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbhENJZf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 05:25:35 -0400
Received: from mail.aperture-lab.de (mail.aperture-lab.de [IPv6:2a01:4f8:c2c:665b::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB439C061574;
        Fri, 14 May 2021 02:24:21 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id A01813E942;
        Fri, 14 May 2021 11:24:17 +0200 (CEST)
Date:   Fri, 14 May 2021 11:24:14 +0200
From:   Linus =?utf-8?Q?L=C3=BCssing?= <linus.luessing@c0d3.blue>
To:     Matteo Croce <mcroce@linux.microsoft.com>
Cc:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: bridge: fix build when IPv6 is disabled
Message-ID: <20210514092414.GD2222@otheros>
References: <20210514015348.15448-1-mcroce@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210514015348.15448-1-mcroce@linux.microsoft.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Last-TLS-Session-Version: TLSv1.2
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 14, 2021 at 03:53:48AM +0200, Matteo Croce wrote:
> From: Matteo Croce <mcroce@microsoft.com>
> 
> The br_ip6_multicast_add_router() prototype is defined only when
> CONFIG_IPV6 is enabled, but the function is always referenced, so there
> is this build error with CONFIG_IPV6 not defined:
> 
> net/bridge/br_multicast.c: In function ‘__br_multicast_enable_port’:
> net/bridge/br_multicast.c:1743:3: error: implicit declaration of function ‘br_ip6_multicast_add_router’; did you mean ‘br_ip4_multicast_add_router’? [-Werror=implicit-function-declaration]
>  1743 |   br_ip6_multicast_add_router(br, port);
>       |   ^~~~~~~~~~~~~~~~~~~~~~~~~~~
>       |   br_ip4_multicast_add_router
> net/bridge/br_multicast.c: At top level:
> net/bridge/br_multicast.c:2804:13: warning: conflicting types for ‘br_ip6_multicast_add_router’
>  2804 | static void br_ip6_multicast_add_router(struct net_bridge *br,
>       |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~
> net/bridge/br_multicast.c:2804:13: error: static declaration of ‘br_ip6_multicast_add_router’ follows non-static declaration
> net/bridge/br_multicast.c:1743:3: note: previous implicit declaration of ‘br_ip6_multicast_add_router’ was here
>  1743 |   br_ip6_multicast_add_router(br, port);
>       |   ^~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> Fix this build error by moving the definition out of the #ifdef.
> 
> Fixes: a3c02e769efe ("net: bridge: mcast: split multicast router state for IPv4 and IPv6")
> Signed-off-by: Matteo Croce <mcroce@microsoft.com>
> ---
>  net/bridge/br_multicast.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
> index 0703725527b3..53c3a9d80d9c 100644
> --- a/net/bridge/br_multicast.c
> +++ b/net/bridge/br_multicast.c
> @@ -62,9 +62,9 @@ static void br_multicast_port_group_rexmit(struct timer_list *t);
>  
>  static void
>  br_multicast_rport_del_notify(struct net_bridge_port *p, bool deleted);
> -#if IS_ENABLED(CONFIG_IPV6)
>  static void br_ip6_multicast_add_router(struct net_bridge *br,
>  					struct net_bridge_port *port);
> +#if IS_ENABLED(CONFIG_IPV6)
>  static void br_ip6_multicast_leave_group(struct net_bridge *br,
>  					 struct net_bridge_port *port,
>  					 const struct in6_addr *group,
> -- 
> 2.31.1
> 

Acked-by: Linus Lüssing <linus.luessing@c0d3.blue>
