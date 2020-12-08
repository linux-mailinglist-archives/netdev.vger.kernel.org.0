Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD3B02D1FBB
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 02:11:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726044AbgLHBKU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 20:10:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:39098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725853AbgLHBKT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Dec 2020 20:10:19 -0500
Date:   Mon, 7 Dec 2020 17:09:37 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607389779;
        bh=9y8Saqnc6HtKSYcuLKWtKArWs6/Z6e+uT4yesj/XHJ8=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=tMq8XqGs967V9qsmbD1OKkxuzOzKYqskPXZJ6+VbBbLmee+PTZbrG7IJWkpfLVBEX
         gS1Vs6z6F1yECSo7Bc62YfaYMPr8IQBb5YKkLTk4SxUP7Ak3kI81Von/eGGpcGAJDK
         gvsfXDxbqcvSVg5zvPiGZAS0fsvxLyUsZineS3UN89W7TJNQdsYDa2oMq6T/UQacsT
         UugNslVpumxk4S2FL4GnSVt6S1nQbQ3e3L32LAqdy26UHaRhSdTgylkYxdWnae4Ur1
         iaulzFJuydNuI4T31vot0/0+3fP0PWLzVjQb12ajeItDHPlkFhy78Xgb1mc/yQqGrU
         kK5fvDokP6Mug==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        "Allan W . Nielsen" <allan.nielsen@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Steen Hegelund <steen.hegelund@microchip.com>
Subject: Re: [PATCH v3 net-next] net: mscc: ocelot: install MAC addresses in
 .ndo_set_rx_mode from process context
Message-ID: <20201207170937.2bed0b40@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201205004315.143851-1-vladimir.oltean@nxp.com>
References: <20201205004315.143851-1-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat,  5 Dec 2020 02:43:15 +0200 Vladimir Oltean wrote:
> Currently ocelot_set_rx_mode calls ocelot_mact_learn directly, which has
> a very nice ocelot_mact_wait_for_completion at the end. Introduced in
> commit 639c1b2625af ("net: mscc: ocelot: Register poll timeout should be
> wall time not attempts"), this function uses readx_poll_timeout which
> triggers a lot of lockdep warnings and is also dangerous to use from
> atomic context, potentially leading to lockups and panics.
> 
> Steen Hegelund added a poll timeout of 100 ms for checking the MAC
> table, a duration which is clearly absurd to poll in atomic context.
> So we need to defer the MAC table access to process context, which we do
> via a dynamically allocated workqueue which contains all there is to
> know about the MAC table operation it has to do.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
> Changes in v3:
> - Dropped Fixes tag and retargeted to net-next
> - Dropped get_device/put_device since they don't offer real protection
> - Now allocating a private ordered workqueue which is drained on unbind
>   to avoid accessing freed memory
> 
> Changes in v2:
> - Added Fixes tag (it won't backport that far, but anyway)
> - Using get_device and put_device to avoid racing with unbind
> 
>  drivers/net/ethernet/mscc/ocelot.c     |  5 ++
>  drivers/net/ethernet/mscc/ocelot_net.c | 81 +++++++++++++++++++++++++-
>  include/soc/mscc/ocelot.h              |  2 +
>  3 files changed, 85 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
> index abea8dd2b0cb..b9626eec8db6 100644
> --- a/drivers/net/ethernet/mscc/ocelot.c
> +++ b/drivers/net/ethernet/mscc/ocelot.c
> @@ -1513,6 +1513,10 @@ int ocelot_init(struct ocelot *ocelot)
>  	if (!ocelot->stats_queue)
>  		return -ENOMEM;
>  
> +	ocelot->owq = alloc_ordered_workqueue("ocelot-owq", WQ_MEM_RECLAIM);

Why MEM_RECLAIM ?

> +	if (!ocelot->owq)
> +		return -ENOMEM;

I don't think you can pass NULL to destroy_workqueue() so IDK how this
code does error handling (freeing of ocelot->stats_queue if owq fails).

>  	INIT_LIST_HEAD(&ocelot->multicast);
>  	INIT_LIST_HEAD(&ocelot->pgids);
>  	ocelot_mact_init(ocelot);
> @@ -1619,6 +1623,7 @@ void ocelot_deinit(struct ocelot *ocelot)
>  {
>  	cancel_delayed_work(&ocelot->stats_work);
>  	destroy_workqueue(ocelot->stats_queue);
> +	destroy_workqueue(ocelot->owq);
>  	mutex_destroy(&ocelot->stats_lock);
>  }

> +static int ocelot_enqueue_mact_action(struct ocelot *ocelot,
> +				      const struct ocelot_mact_work_ctx *ctx)
> +{
> +	struct ocelot_mact_work_ctx *w = kmalloc(sizeof(*w), GFP_ATOMIC);
> +
> +	if (!w)
> +		return -ENOMEM;
> +
> +	memcpy(w, ctx, sizeof(*w));

kmemdup()?
