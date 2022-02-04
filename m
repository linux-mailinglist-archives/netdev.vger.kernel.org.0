Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB7EB4A9296
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 04:08:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356732AbiBDDIE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 22:08:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241328AbiBDDIC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 22:08:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EA3DC061714
        for <netdev@vger.kernel.org>; Thu,  3 Feb 2022 19:08:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9DD61B83626
        for <netdev@vger.kernel.org>; Fri,  4 Feb 2022 03:08:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D55AC340E8;
        Fri,  4 Feb 2022 03:07:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643944079;
        bh=/C25DKLpEjQDzE0SHOu/tV9NpONBHBXPlH1TyOafGgk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JXZd/QPFXGPTuAEZhV24g+sCKJKcEtHJeCgR+HD15yFGV1Wio09QDGsmv3lHM6a3L
         KP+3HB0JRj8SasaYDDduMR6gC5bNbe6yoCton0bNr2JhoBXeiZ17l2RUmCqdZQi+q+
         PrdTzyLvhC/WXQzsXeMWZsbxSxv0Xnd3r434BjbwzWJTw2XwMkfa11A60B2F+k8MYS
         mgFdO8n8YPCAfVh4Hu3ssKN4PKEDjbSV3XcoQy0lnf1EazohUZD0XlhYZufZ8nWVFB
         Y6VfP82Jz8YB+NoLvPd1d0B1KdG0WcAYA/FzZCW+d9R7flwCCnvtGP6CjFD0UC1dDt
         XIgPehMO9ehqQ==
Date:   Thu, 3 Feb 2022 19:07:57 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jacques de Laval <Jacques.De.Laval@westermo.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 1/1] net: Add new protocol attribute to IP
 addresses
Message-ID: <20220203190757.2be1dd75@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220203163106.1276624-1-Jacques.De.Laval@westermo.com>
References: <20220203163106.1276624-1-Jacques.De.Laval@westermo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 3 Feb 2022 17:31:06 +0100 Jacques de Laval wrote:
> diff --git a/include/net/if_inet6.h b/include/net/if_inet6.h
> index 653e7d0f65cb..f7c270b24167 100644
> --- a/include/net/if_inet6.h
> +++ b/include/net/if_inet6.h
> @@ -73,6 +73,8 @@ struct inet6_ifaddr {
>  
>  	struct rcu_head		rcu;
>  	struct in6_addr		peer_addr;
> +
> +	__u8			ifa_proto;

nit: the __ types are for uAPI, you can use a normal u8 here.

>  };
>  
>  struct ip6_sf_socklist {
> diff --git a/include/uapi/linux/if_addr.h b/include/uapi/linux/if_addr.h
> index dfcf3ce0097f..2aa46b9c9961 100644
> --- a/include/uapi/linux/if_addr.h
> +++ b/include/uapi/linux/if_addr.h

> @@ -69,4 +70,7 @@ struct ifa_cacheinfo {
>  #define IFA_PAYLOAD(n) NLMSG_PAYLOAD(n,sizeof(struct ifaddrmsg))
>  #endif
>  
> +/* ifa_protocol */
> +#define IFAPROT_UNSPEC	0
> +
>  #endif

What's the purpose of defining this as a constant?
