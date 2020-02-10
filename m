Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E4F9157388
	for <lists+netdev@lfdr.de>; Mon, 10 Feb 2020 12:36:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727347AbgBJLg3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Feb 2020 06:36:29 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:38558 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726961AbgBJLg3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Feb 2020 06:36:29 -0500
Received: from localhost (82-95-191-104.ip.xs4all.nl [82.95.191.104])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C189914BA5846;
        Mon, 10 Feb 2020 03:36:25 -0800 (PST)
Date:   Mon, 10 Feb 2020 12:36:19 +0100 (CET)
Message-Id: <20200210.123619.546500251078019206.davem@davemloft.net>
To:     Jason@zx2c4.com
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        shannon.nelson@oracle.com
Subject: Re: [PATCH net 3/5] sunvnet: use icmp_ndo_send helper
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200209143143.151632-3-Jason@zx2c4.com>
References: <20200209143143.151632-1-Jason@zx2c4.com>
        <20200209143143.151632-3-Jason@zx2c4.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 10 Feb 2020 03:36:28 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Sun,  9 Feb 2020 15:31:41 +0100

> Because sunvnet is calling icmp from network device context, it should use
> the ndo helper so that the rate limiting applies correctly.
> 
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>

Two things, first you should resubmit this patch series with a proper
header [PATCH 0/N ... ] posting.

Second:

> @@ -1363,14 +1363,14 @@ sunvnet_start_xmit_common(struct sk_buff *skb, struct net_device *dev,
>  			rt = ip_route_output_key(dev_net(dev), &fl4);
>  			if (!IS_ERR(rt)) {
>  				skb_dst_set(skb, &rt->dst);
> -				icmp_send(skb, ICMP_DEST_UNREACH,
> -					  ICMP_FRAG_NEEDED,
> -					  htonl(localmtu));
> +				icmp_ndo_send(skb, ICMP_DEST_UNREACH,
> +					      ICMP_FRAG_NEEDED,
> +					      htonl(localmtu));
>  			}
>  		}

Well, obviously if the saddr could be wrong here then this invalidates
the route lookup done in the lines above your changes.

It looks like this code is just making sure the ICMP path is routable
which is kinda bogus because that is the icmp code's job.  So very
likely the right thing to do is to remove all of that route lookup
and check code entirely.  And that matches what all the other instances
of driver icmp calls in your patces do.
