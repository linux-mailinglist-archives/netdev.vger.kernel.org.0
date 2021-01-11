Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFCB52F2440
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 01:34:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405467AbhALAZf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 19:25:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:36454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404199AbhAKXrP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Jan 2021 18:47:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DEC5122D00;
        Mon, 11 Jan 2021 23:46:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610408793;
        bh=LCczpMEwQ7Inf94GYXmm33lV1dDfuGjkKnAZtODSx+Q=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ok1LVieRpA9vIX3sw76GFGJV0FCZuJhx/Y9GPfDA1yGyAfdozL4euIiH/Yr4YR5yN
         wPx38wYy8+PuFbmOEH8vttMizUtXhtzcWEuhsE1BJnFqr2fu9iCLVzAIGGrgReZZ91
         bmjiBn6X9xcrL1dIgv8iIRG3rMpXAdPeSSgAef3MxmVQG9xIsg3QfeiQQK5UFxDchv
         RzbPKp3XCSIyaP55RZukMS44fstfOABZKER0egaurFDD9WZN0ri/zAIRNyG2ZwG0Ua
         6+4D+eebviwIp9oj18jREmGQqZ5uO7As9y1Qddlsxrji31wUQBCkn6H044dp/QuEn1
         vy4x4+Ts+boKQ==
Message-ID: <fa9efc8c4c0cb3dd3b0bba153b4b368e64ff06c3.camel@kernel.org>
Subject: Re: [PATCH v6 net-next 03/15] net: procfs: hold netif_lists_lock
 when retrieving device statistics
From:   Saeed Mahameed <saeed@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Eric Dumazet <edumazet@google.com>,
        George McCollister <george.mccollister@gmail.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Arnd Bergmann <arnd@arndb.de>, Taehee Yoo <ap420073@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, Florian Westphal <fw@strlen.de>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>
Date:   Mon, 11 Jan 2021 15:46:32 -0800
In-Reply-To: <20210109172624.2028156-4-olteanv@gmail.com>
References: <20210109172624.2028156-1-olteanv@gmail.com>
         <20210109172624.2028156-4-olteanv@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2021-01-09 at 19:26 +0200, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> In the effort of making .ndo_get_stats64 be able to sleep, we need to
> ensure the callers of dev_get_stats do not use atomic context.
> 
> The /proc/net/dev file uses an RCU read-side critical section to
> ensure
> the integrity of the list of network interfaces, because it iterates
> through all net devices in the netns to show their statistics.
> 
> To offer the equivalent protection against an interface registering
> or
> deregistering, while also remaining in sleepable context, we can use
> the
> netns mutex for the interface lists.
> 
> Cc: Cong Wang <xiyou.wangcong@gmail.com>
> Cc: Eric Dumazet <edumazet@google.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
> Changes in v6:
> None.
> 
> Changes in v5:
> None.
> 
> Changes in v4:
> None.
> 
> Changes in v3:
> None.
> 
> Changes in v2:
> None.
> 
>  net/core/net-procfs.c | 13 ++++++++-----
>  1 file changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/net/core/net-procfs.c b/net/core/net-procfs.c
> index c714e6a9dad4..4784703c1e39 100644
> --- a/net/core/net-procfs.c
> +++ b/net/core/net-procfs.c
> @@ -21,7 +21,7 @@ static inline struct net_device
> *dev_from_same_bucket(struct seq_file *seq, loff
>  	unsigned int count = 0, offset = get_offset(*pos);
>  
>  	h = &net->dev_index_head[get_bucket(*pos)];
> -	hlist_for_each_entry_rcu(dev, h, index_hlist) {
> +	hlist_for_each_entry(dev, h, index_hlist) {
>  		if (++count == offset)
>  			return dev;
>  	}
> @@ -51,9 +51,11 @@ static inline struct net_device
> *dev_from_bucket(struct seq_file *seq, loff_t *p
>   *	in detail.
>   */
>  static void *dev_seq_start(struct seq_file *seq, loff_t *pos)
> -	__acquires(RCU)
>  {
> -	rcu_read_lock();
> +	struct net *net = seq_file_net(seq);
> +
> +	netif_lists_lock(net);
> +

This can be very costly, holding a mutex while traversing the whole
netedv lists and reading their stats, we need to at least allow
multiple readers to enter as it was before, so maybe you want to use
rw_semaphore instead of the mutex.

or just have a unified approach of rcu+refcnt/dev_hold as you did for
bonding and failover patches #13..#14, I used the same approach to
achieve the same for sysfs and procfs more than 2 years ago, you are
welcome to use my patches:
https://lore.kernel.org/netdev/4cc44e85-cb5e-502c-30f3-c6ea564fe9ac@gmail.com/


>  	if (!*pos)
>  		return SEQ_START_TOKEN;
>  
> @@ -70,9 +72,10 @@ static void *dev_seq_next(struct seq_file *seq,
> void *v, loff_t *pos)
>  }
>  
>  static void dev_seq_stop(struct seq_file *seq, void *v)
> -	__releases(RCU)
>  {
> -	rcu_read_unlock();
> +	struct net *net = seq_file_net(seq);
> +
> +	netif_lists_unlock(net);
>  }
>  
>  static void dev_seq_printf_stats(struct seq_file *seq, struct
> net_device *dev)

