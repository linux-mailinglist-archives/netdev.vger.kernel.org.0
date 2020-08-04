Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B18323C1FB
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 00:58:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727061AbgHDW6k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 18:58:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726955AbgHDW6i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Aug 2020 18:58:38 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76E60C06174A;
        Tue,  4 Aug 2020 15:58:38 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 20AAA128958FA;
        Tue,  4 Aug 2020 15:41:49 -0700 (PDT)
Date:   Tue, 04 Aug 2020 15:58:31 -0700 (PDT)
Message-Id: <20200804.155831.644663742975051162.davem@davemloft.net>
To:     wenyang@linux.alibaba.com
Cc:     kuba@kernel.org, xlpang@linux.alibaba.com,
        caspar@linux.alibaba.com, andrew@lunn.ch, edumazet@google.com,
        jiri@mellanox.com, leon@kernel.org, jwi@linux.ibm.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: core: explicitly call linkwatch_fire_event to
 speed up the startup of network services
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200801085845.20153-1-wenyang@linux.alibaba.com>
References: <20200801085845.20153-1-wenyang@linux.alibaba.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 04 Aug 2020 15:41:49 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wen Yang <wenyang@linux.alibaba.com>
Date: Sat,  1 Aug 2020 16:58:45 +0800

> diff --git a/net/core/link_watch.c b/net/core/link_watch.c
> index 75431ca..6b9d44b 100644
> --- a/net/core/link_watch.c
> +++ b/net/core/link_watch.c
> @@ -98,6 +98,9 @@ static bool linkwatch_urgent_event(struct net_device *dev)
>  	if (netif_is_lag_port(dev) || netif_is_lag_master(dev))
>  		return true;
>  
> +	if ((dev->flags & IFF_UP) && dev->operstate == IF_OPER_DOWN)
> +		return true;
> +
>  	return netif_carrier_ok(dev) &&	qdisc_tx_changing(dev);
>  }
>  

You're bypassing explicitly the logic here:

	/*
	 * Limit the number of linkwatch events to one
	 * per second so that a runaway driver does not
	 * cause a storm of messages on the netlink
	 * socket.  This limit does not apply to up events
	 * while the device qdisc is down.
	 */
	if (!urgent_only)
		linkwatch_nextevent = jiffies + HZ;
	/* Limit wrap-around effect on delay. */
	else if (time_after(linkwatch_nextevent, jiffies + HZ))
		linkwatch_nextevent = jiffies;

Something about this isn't right.  We need to analyze what you are seeing,
what device you are using, and what systemd is doing to figure out what
the right place for the fix.

Thank you.
