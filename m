Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F12029FBB
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 22:21:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404099AbfEXUVD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 16:21:03 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:57106 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403845AbfEXUVD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 May 2019 16:21:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=XaCVH6lHNk+HuoRHqT3kpi6FeIY+sUbFQre8eD6A/zQ=; b=qh/bf8vFWYIgO16wMxdWf7ySQP
        G3tXBbDsSOA9N0j1IFAIsnOUP/ESUgt9GJ1F3oyb6MxI3AItv+NSDej1Up7MQ7Tbh6b7LTl4uSYwv
        k7n0guReuXoRw4T5P1T7j96UTPS+GHhkLxsSrWOTrXjAHxSrgHt7a+IwLRQ1DPlXtiPw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hUGgW-0004Rr-Iz; Fri, 24 May 2019 22:21:00 +0200
Date:   Fri, 24 May 2019 22:21:00 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Krzysztof Halasa <khalasa@piap.pl>
Subject: Re: [PATCH 8/8] net: ethernet: ixp4xx: Support device tree probing
Message-ID: <20190524202100.GR21208@lunn.ch>
References: <20190524162023.9115-1-linus.walleij@linaro.org>
 <20190524162023.9115-9-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190524162023.9115-9-linus.walleij@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +	/* FIXME: get from MDIO handle */
> +	ret = of_property_read_u32(np, "phy", &val);
> +	if (ret) {
> +		dev_err(dev, "no phy\n");
> +		return NULL;
> +	}
> +	plat->phy = val;

Hi Linus

You might want to work on the MDIO code first. It is O.K. to do
something like:

np = NULL;

if (dev->of_node)
	np = of_get_child_by_name(dev->of_node, "mdio");

of_mdiobus_register(np, mdio_bus)

If np is NULL, it will fall back to mdiobus_register().

Then here you can do the correct

priv->phy_node = of_parse_phandle(dev->of_node, "phy-handle", 0);

and later call 

       phy = of_phy_connect(ndev, priv->phy_node, &ixp4xx_adjust_link,
                           PHY_INTERFACE_MODE_MII);

You just need to watch out for the -EPROBE_DEFFERED.

    Andrew
