Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D93822CC55B
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 19:40:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730945AbgLBSk0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 13:40:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:38754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728656AbgLBSkZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Dec 2020 13:40:25 -0500
Date:   Wed, 2 Dec 2020 10:39:37 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1606934384;
        bh=LJXaf2fvlrkEU24yHJod1IUh7+QkKVM4tLvbdSWB/ug=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=JfSXeHG4MHd46ywV1sz04P7JjpqeNCEseCzbOBUrHlAg9FDcU9aoO6H73F/uGZmr9
         7HxTGDZAzkaShYRED4l9kpXP39XsIMtjUuVwMWUZ43xx43TodCGtfQd0ZeJd5CTcMu
         a4/2O1JeLU35nUGim/WTV1L5BcNNUk5K7MyP5yji8mu9cGi9IazMWry57AwPCKBbLR
         QvG6SWTtvExsxTtHBXuJ6NbQthx1cX5bKKlnVwD4hcp/FjF1iIenFBpkNG6Yi6Irz4
         9b2VDPw0oSRdn71aHQNWMsC2IpvCAapCKlPsB33Gr+CQim1jV4CbiyECLcoWs/UPkq
         qXgm4ljKGm5eg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org
Subject: Re: [PATCH v2 2/2] net: dsa: qca: ar9331: export stats64
Message-ID: <20201202103937.137e587b@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201202120712.6212-3-o.rempel@pengutronix.de>
References: <20201202120712.6212-1-o.rempel@pengutronix.de>
        <20201202120712.6212-3-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  2 Dec 2020 13:07:12 +0100 Oleksij Rempel wrote:
> +static void ar9331_read_stats(struct ar9331_sw_port *port)
> +{
> +	mutex_lock(&port->lock);

> +	mutex_unlock(&port->lock);
> +}

> +static void ar9331_get_stats64(struct dsa_switch *ds, int port,
> +			       struct rtnl_link_stats64 *s)
> +{
> +	struct ar9331_sw_priv *priv = (struct ar9331_sw_priv *)ds->priv;
> +	struct ar9331_sw_port *p = &priv->port[port];
> +
> +	ar9331_read_stats(p);

> +}
> +
>  static const struct dsa_switch_ops ar9331_sw_ops = {

> +	.get_stats64		= ar9331_get_stats64,
>  };

You can't take sleeping locks from .ndo_get_stats64.

Also regmap may sleep?

+	ret = regmap_read(priv->regmap, reg, &val);

Am I missing something?
