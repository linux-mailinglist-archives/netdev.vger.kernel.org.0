Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AFD144ACD4
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 12:46:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343557AbhKILtN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 06:49:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229879AbhKILtL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Nov 2021 06:49:11 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6198FC061764;
        Tue,  9 Nov 2021 03:46:25 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1mkPZs-0004YE-OB; Tue, 09 Nov 2021 12:46:12 +0100
Date:   Tue, 9 Nov 2021 12:46:12 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Changliang Wu <changliang.wu@smartx.com>
Cc:     davem@davemloft.net, kuba@kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, edumazet@google.com, idosch@OSS.NVIDIA.COM,
        amcohen@nvidia.com, fw@strlen.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ipv4: add sysctl knob to control the discarding of skb
 from local in ip_forward
Message-ID: <20211109114612.GC16363@breakpoint.cc>
References: <1636457577-43305-1-git-send-email-changliang.wu@smartx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1636457577-43305-1-git-send-email-changliang.wu@smartx.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Changliang Wu <changliang.wu@smartx.com> wrote:
> This change is meant to add a control for forwarding skb from local.
> By default, ip forward will not receive the pakcet to/from the local.
> But in some special cases, for example:
> -
> |  ovs-bridge  gw-port |  <---->   kube-proxy(iptables) |
> -
> Ovs sends the packet to the gateway, which requires iptables for nat,
> such as kube-proxy (iptables), and then sends it back to the gateway
> through routing for further processing in ovs.

This a very terse description.  How does packet end up in forward
after skb->sk assignment?

> diff --git a/net/ipv4/ip_forward.c b/net/ipv4/ip_forward.c
> index 00ec819..06b7e00 100644
> --- a/net/ipv4/ip_forward.c
> +++ b/net/ipv4/ip_forward.c
> @@ -95,9 +95,6 @@ int ip_forward(struct sk_buff *skb)
>  	if (skb->pkt_type != PACKET_HOST)
>  		goto drop;
>  
> -	if (unlikely(skb->sk))
> -		goto drop;
> -

Please have a look at
2ab957492d13bb819400ac29ae55911d50a82a13

you need to explain why this is now ok.

Without explanation i have to assume stack will now crash again
when net->ipv4.sysctl_ip_fwd_accept_local=1 and TW socket is assigned.
