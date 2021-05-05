Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 711B4373366
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 03:00:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231739AbhEEBBp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 May 2021 21:01:45 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:53504 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231408AbhEEBBo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 May 2021 21:01:44 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1le5u9-002Z8Y-EB; Wed, 05 May 2021 03:00:45 +0200
Date:   Wed, 5 May 2021 03:00:45 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH net-next v3 13/20] net: dsa: qca8k: make rgmii delay
 configurable
Message-ID: <YJHuPdyj9B19sbUJ@lunn.ch>
References: <20210504222915.17206-1-ansuelsmth@gmail.com>
 <20210504222915.17206-13-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210504222915.17206-13-ansuelsmth@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 05, 2021 at 12:29:07AM +0200, Ansuel Smith wrote:
> The legacy qsdk code used a different delay instead of the max value.
> Qsdk use 1 ps for rx and 2 ps for tx. Make these values configurable
> using the standard rx/tx-internal-delay-ps ethernet binding and apply
> qsdk values by default. The connected gmac doesn't add any delay so no
> additional delay is added to tx/rx.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> ---
>  drivers/net/dsa/qca8k.c | 51 +++++++++++++++++++++++++++++++++++++++--
>  drivers/net/dsa/qca8k.h | 11 +++++----
>  2 files changed, 55 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
> index 22334d416f53..cb9b44769e92 100644
> --- a/drivers/net/dsa/qca8k.c
> +++ b/drivers/net/dsa/qca8k.c
> @@ -779,6 +779,47 @@ qca8k_setup_mdio_bus(struct qca8k_priv *priv)
>  	return 0;
>  }
>  
> +static int
> +qca8k_setup_of_rgmii_delay(struct qca8k_priv *priv)
> +{
> +	struct device_node *ports, *port;
> +	u32 val;
> +
> +	ports = of_get_child_by_name(priv->dev->of_node, "ports");
> +	if (!ports)
> +		return -EINVAL;
> +
> +	/* Assume only one port with rgmii-id mode */
> +	for_each_available_child_of_node(ports, port) {

Are delays global? Or per port? They really should be per port.  If it
is global, one value that applies to all ports, i would not use
it. Have the PHY apply the delay, not the MAC.

    Andrew
