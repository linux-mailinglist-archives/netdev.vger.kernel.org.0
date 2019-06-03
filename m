Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5CC8325EB
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 03:07:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726714AbfFCBHq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jun 2019 21:07:46 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:48736 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726561AbfFCBHq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 2 Jun 2019 21:07:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=NI8tXjuoHj65qlHBHn/UeywAuQJIOuif1sn3h6uP9Iw=; b=P9s57QnAaUAS/Z6st//IwpNW0u
        JEmkyPCvqDUEtPv26dfHXOHmCPaVYbNAQdqDJfrEGXbxGfhkaYcMtudmIzW1ytgmcHJ8ZwUB6xiR+
        OiUrFrhTrhKmBoYS7yXh05rdDChqfLsMu9UMgCoX/FNo9y91zY5WN1FluEYEw9KLdWyM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hXbRs-0002eJ-9M; Mon, 03 Jun 2019 03:07:40 +0200
Date:   Mon, 3 Jun 2019 03:07:40 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net, richardcochran@gmail.com,
        john.stultz@linaro.org, tglx@linutronix.de, sboyd@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2 net-next 02/10] net: dsa: Add teardown callback for
 drivers
Message-ID: <20190603010740.GI19081@lunn.ch>
References: <20190602213926.2290-1-olteanv@gmail.com>
 <20190602213926.2290-3-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190602213926.2290-3-olteanv@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 03, 2019 at 12:39:18AM +0300, Vladimir Oltean wrote:
> This is helpful for e.g. draining per-driver (not per-port) tagger
> queues.
> 
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
> ---
> Changes in v2:
> 
> Patch is new.
> 
>  include/net/dsa.h | 1 +
>  net/dsa/dsa2.c    | 3 +++
>  2 files changed, 4 insertions(+)
> 
> diff --git a/include/net/dsa.h b/include/net/dsa.h
> index a7f36219904f..4033e0677be4 100644
> --- a/include/net/dsa.h
> +++ b/include/net/dsa.h
> @@ -361,6 +361,7 @@ struct dsa_switch_ops {
>  						  int port);
>  
>  	int	(*setup)(struct dsa_switch *ds);
> +	void	(*teardown)(struct dsa_switch *ds);
>  	u32	(*get_phy_flags)(struct dsa_switch *ds, int port);
>  
>  	/*
> diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
> index b70befe8a3c8..5bd3e9a4c709 100644
> --- a/net/dsa/dsa2.c
> +++ b/net/dsa/dsa2.c
> @@ -407,6 +407,9 @@ static int dsa_switch_setup(struct dsa_switch *ds)
>  
>  static void dsa_switch_teardown(struct dsa_switch *ds)
>  {
> +	if (ds->ops->teardown)
> +		ds->ops->teardown(ds);
> +
>  	if (ds->slave_mii_bus && ds->ops->phy_read)
>  		mdiobus_unregister(ds->slave_mii_bus);
>  

Hi Vladimir

If we want to keep with symmetric with dsa_switch_setup(), this
teardown should be added after dsa_switch_unregister_notifier() and
before devlink_unregister().

       Andrew
