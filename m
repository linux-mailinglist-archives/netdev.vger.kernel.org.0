Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D61FF380E59
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 18:43:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234762AbhENQon (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 12:44:43 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:40626 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230431AbhENQol (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 May 2021 12:44:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=a3EKWIis+zR6gQ4DUZ9TNegMci0bPDZjHjVHulVe+gI=; b=mhb66vKQJ/NVPgv4tnTioqdNr7
        4sQyoTbl26QQtylNUgnVhcbpDT0hQovK5963TuaszgCPDCi9LtXMyor2zoG+x0pZmEVfL+kScAX+w
        1QGU3HdB4Zv7O+LZ87G6dA1SaiiGdC+w9HZL+VXcVYMcd8AvrmwuqukUX8m158MhEXUQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lhauK-004D9H-Ld; Fri, 14 May 2021 18:43:24 +0200
Date:   Fri, 14 May 2021 18:43:24 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH net-next v5 07/25] net: dsa: qca8k: handle error with
 qca8k_rmw operation
Message-ID: <YJ6orOpINGHT6kZD@lunn.ch>
References: <20210511020500.17269-1-ansuelsmth@gmail.com>
 <20210511020500.17269-8-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210511020500.17269-8-ansuelsmth@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -static u32
> -qca8k_rmw(struct qca8k_priv *priv, u32 reg, u32 mask, u32 val)
> +static int
> +qca8k_rmw(struct qca8k_priv *priv, u32 reg, u32 mask, u32 write_val)
>  {
>  	struct mii_bus *bus = priv->bus;
>  	u16 r1, r2, page;
> -	u32 ret;
> +	u32 val;
> +	int ret;
>  
>  	qca8k_split_addr(reg, &r1, &r2, &page);
>  
> @@ -205,10 +206,15 @@ qca8k_rmw(struct qca8k_priv *priv, u32 reg, u32 mask, u32 val)
>  	if (ret < 0)
>  		goto exit;
>  
> -	ret = qca8k_mii_read32(bus, 0x10 | r2, r1);
> -	ret &= ~mask;
> -	ret |= val;
> -	qca8k_mii_write32(bus, 0x10 | r2, r1, ret);
> +	val = qca8k_mii_read32(bus, 0x10 | r2, r1);
> +	if (val < 0) {
> +		ret = val;
> +		goto exit;
> +	}
> +
> +	val &= ~mask;
> +	val |= write_val;
> +	qca8k_mii_write32(bus, 0x10 | r2, r1, val);

Does qca8k_mii_write32() not return an code?

Seems like yet another function you could modify. But i suggest you
wait, get this patchset merged first.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
