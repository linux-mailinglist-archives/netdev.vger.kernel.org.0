Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B08929208D
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 01:01:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729524AbgJRXBu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Oct 2020 19:01:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:52642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726681AbgJRXBu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 18 Oct 2020 19:01:50 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 57A7C20720;
        Sun, 18 Oct 2020 23:01:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603062109;
        bh=0XHHPvp67qZax3bsXz6sZZHJ1GOQKrKzO098AVjNzC0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CQD1J6Oyoz2Ic+GKffGgx7WUw6Sai0ZJJYI70GOmcxRz3QPKrrTPIheKUxF7O8jQ4
         VQI8t6wUrCTob9JmSw50Ys4sD8GOOzbCw6lS0cJSe9jWrtKNpQAFG20WygT1hHcpe4
         YJe9TkLCQWDVF5304HgAGKLE7zCqQA3wAR5cw7lg=
Date:   Sun, 18 Oct 2020 16:01:47 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Reji Thomas <rejithomas@juniper.net>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, rejithomas.d@gmail.com,
        kernel test robot <lkp@intel.com>,
        Mathieu Xhonneux <m.xhonneux@gmail.com>,
        David Lebrun <david.lebrun@uclouvain.be>
Subject: Re: [PATCH v2] IPv6: sr: Fix End.X nexthop to use oif.
Message-ID: <20201018160147.6b3c940a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201015082119.68287-1-rejithomas@juniper.net>
References: <20201015082119.68287-1-rejithomas@juniper.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 15 Oct 2020 13:51:19 +0530 Reji Thomas wrote:
> Currently End.X action doesn't consider the outgoing interface
> while looking up the nexthop.This breaks packet path functionality
> specifically while using link local address as the End.X nexthop.
> The patch fixes this by enforcing End.X action to have both nh6 and
> oif and using oif in lookup.It seems this is a day one issue.
> 
> Fixes: 140f04c33bbc ("ipv6: sr: implement several seg6local actions")
> Signed-off-by: Reji Thomas <rejithomas@juniper.net>

David, Mathiey - any comments?

> @@ -239,6 +250,8 @@ static int input_action_end(struct sk_buff *skb, struct seg6_local_lwt *slwt)
>  static int input_action_end_x(struct sk_buff *skb, struct seg6_local_lwt *slwt)
>  {
>  	struct ipv6_sr_hdr *srh;
> +	struct net_device *odev;
> +	struct net *net = dev_net(skb->dev);

Order longest to shortest.

>  
>  	srh = get_and_validate_srh(skb);
>  	if (!srh)
> @@ -246,7 +259,11 @@ static int input_action_end_x(struct sk_buff *skb, struct seg6_local_lwt *slwt)
>  
>  	advance_nextseg(srh, &ipv6_hdr(skb)->daddr);
>  
> -	seg6_lookup_nexthop(skb, &slwt->nh6, 0);
> +	odev = dev_get_by_index_rcu(net, slwt->oif);
> +	if (!odev)
> +		goto drop;

Are you doing this lookup just to make sure that oif exists?
Looks a little wasteful for fast path, but more importantly 
it won't be backward compatible, right? See below..

> +
> +	seg6_strict_lookup_nexthop(skb, &slwt->nh6, odev->ifindex, 0);
>  
>  	return dst_input(skb);
>  

> @@ -566,7 +583,8 @@ static struct seg6_action_desc seg6_action_table[] = {
>  	},
>  	{
>  		.action		= SEG6_LOCAL_ACTION_END_X,
> -		.attrs		= (1 << SEG6_LOCAL_NH6),
> +		.attrs		= ((1 << SEG6_LOCAL_NH6) |
> +				   (1 << SEG6_LOCAL_OIF)),
>  		.input		= input_action_end_x,
>  	},
>  	{

If you set this parse_nla_action() will reject all
SEG6_LOCAL_ACTION_END_X without OIF.

As you say the OIF is only required for using link local addresses,
so this change breaks perfectly legitimate configurations.

Can we instead only warn about the missing OIF, and only do that when
nh is link local?

Also doesn't SEG6_LOCAL_ACTION_END_DX6 need a similar treatment?
