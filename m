Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A3B84B0E30
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 14:15:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242058AbiBJNOf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 08:14:35 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239881AbiBJNOe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 08:14:34 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53DFC1157;
        Thu, 10 Feb 2022 05:14:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=a3sjCPkuo/yp/xxSnVr5f3pnRVPuuMGoup115Dij2eQ=; b=zHo7AbkpDJzLDPt3595KfZw3Gn
        wkORiO4MvrO3tVWySWtQ4xpum5LQbEc13cPDc4XmABICv8qRnitfaMBd8ZAytUfYLgrKxga1vk8Ue
        O9X6NZI4qBBKjM6CyZJV/jjUJkeHyN4QnJ56N7cNQc8eiXnfzWqQX1G244Yg1BL7v4sM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nI9HH-005IYz-S9; Thu, 10 Feb 2022 14:14:27 +0100
Date:   Thu, 10 Feb 2022 14:14:27 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, UNGLinuxDriver@microchip.com,
        davem@davemloft.net, kernel test robot <lkp@intel.com>
Subject: Re: [PATCH net-next] net: lan966x: Fix when CONFIG_IPV6 is not set
Message-ID: <YgUPswHG60Fi9rjA@lunn.ch>
References: <20220209101823.1270489-1-horatiu.vultur@microchip.com>
 <YgPHjxpo0N4ND1ch@lunn.ch>
 <20220209180620.3699bf25@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20220210083612.4mszzwgcrvmn67rn@soft-dev3-1.localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220210083612.4mszzwgcrvmn67rn@soft-dev3-1.localhost>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> What do you think if I do something like this in the lan966x_main.h
> 
> ---
> #if IS_ENABLED(CONFIG_IPV6)
> static inline bool lan966x_hw_offload_ipv6(struct sk_buff *skb)
> {
> 	if (skb->protocol == htons(ETH_P_IPV6) &&
> 	    ipv6_addr_is_multicast(&ipv6_hdr(skb)->daddr) &&
> 	    !ipv6_mc_check_mld(skb))
> 		return false;
> 
> 	return true;
> }
> #else
> static inline bool lan966x_hw_offload_ipv6(struct sk_buff *skb)
> {
> 	return false;
> }
> #endif
> ---

The reason we prefer not to use #if is that it reduced compile testing
coverage. The block of code inside gets compiled a lot less.

> And then in lan966x_main.c just call this function.
> 
> > 
> > If it's linking we can do:
> > 
> >         if (IS_ENABLED(CONFIG_IPV6) &&
> >             skb->protocol == htons(ETH_P_IPV6) &&
> >             ipv6_addr_is_multicast(&ipv6_hdr(skb)->daddr) &&
> >             !ipv6_mc_check_mld(skb))
> >                 return false;

Jakub solution results in the code always being compiled, but the
IS_ENABLED(CONFIG_IPV6) gets turned into a constant 0 or 1. The
optimizer can then remove the whole block of code in the 0 case.

> I was also looking at other drivers on how they use 'ipv6_mc_check_mld'.
> Then I have seen that drivers/net/amt.c and net/bridge/br_multicast.c
> they wrap this function with #if.
> But then there is net/batman-adv/multicast.c which doesn't do that and
> it can compile and link without CONFIG_IPV6 and I just don't see how
> that is working.

Maybe it is to do with this at the end of net/ip6/Makefile

ifneq ($(CONFIG_IPV6),)
obj-$(CONFIG_NET_UDP_TUNNEL) += ip6_udp_tunnel.o
obj-y += mcast_snoop.o
endif

