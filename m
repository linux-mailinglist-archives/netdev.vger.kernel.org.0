Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0330124309E
	for <lists+netdev@lfdr.de>; Wed, 12 Aug 2020 23:43:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726568AbgHLVnf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Aug 2020 17:43:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726508AbgHLVnf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Aug 2020 17:43:35 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47041C061383;
        Wed, 12 Aug 2020 14:43:35 -0700 (PDT)
Received: from localhost (50-47-102-2.evrt.wa.frontiernet.net [50.47.102.2])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 15F2012A18E8C;
        Wed, 12 Aug 2020 14:26:48 -0700 (PDT)
Date:   Wed, 12 Aug 2020 14:43:32 -0700 (PDT)
Message-Id: <20200812.144332.2288214156822456254.davem@davemloft.net>
To:     mathieu.desnoyers@efficios.com
Cc:     dsahern@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 2/3] ipv4/icmp: l3mdev: Perform icmp error route lookup
 on source device routing table
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200811195003.1812-3-mathieu.desnoyers@efficios.com>
References: <20200811195003.1812-1-mathieu.desnoyers@efficios.com>
        <20200811195003.1812-3-mathieu.desnoyers@efficios.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 12 Aug 2020 14:26:48 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Date: Tue, 11 Aug 2020 15:50:02 -0400

> @@ -465,6 +465,7 @@ static struct rtable *icmp_route_lookup(struct net *net,
>  					int type, int code,
>  					struct icmp_bxm *param)
>  {
> +	struct net_device *route_lookup_dev = NULL;
>  	struct rtable *rt, *rt2;
>  	struct flowi4 fl4_dec;
>  	int err;
> @@ -479,7 +480,17 @@ static struct rtable *icmp_route_lookup(struct net *net,
>  	fl4->flowi4_proto = IPPROTO_ICMP;
>  	fl4->fl4_icmp_type = type;
>  	fl4->fl4_icmp_code = code;
> -	fl4->flowi4_oif = l3mdev_master_ifindex(skb_dst(skb_in)->dev);
> +	/*
> +	 * The device used for looking up which routing table to use is
> +	 * preferably the source whenever it is set, which should ensure
> +	 * the icmp error can be sent to the source host, else fallback
> +	 * on the destination device.
> +	 */
> +	if (skb_in->dev)
> +		route_lookup_dev = skb_in->dev;
> +	else if (skb_dst(skb_in))
> +		route_lookup_dev = skb_dst(skb_in)->dev;
> +	fl4->flowi4_oif = l3mdev_master_ifindex(route_lookup_dev);

The caller of icmp_route_lookup() uses the opposite prioritization of
devices for determining the network namespace to use:

	if (rt->dst.dev)
		net = dev_net(rt->dst.dev);
	else if (skb_in->dev)
		net = dev_net(skb_in->dev);
	else
		goto out;

Do we have to reverse the ordering there too?

And when I read fallback in your commit message description, I
imagined that you would have a two tiered lookup scheme.  First you
would be trying the skb_in->dev for a lookup (to accomodate the VRF
case), and if that failed you'd try again with skb_dst()->dev.
