Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8323B1747B5
	for <lists+netdev@lfdr.de>; Sat, 29 Feb 2020 16:42:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727142AbgB2PmW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Feb 2020 10:42:22 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:39784 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727070AbgB2PmW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 29 Feb 2020 10:42:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=iZuw/pvRa7xameAMNnCGHbBoA0L0pl49ZDm5F8xaDjo=; b=fmhVz6uXY8xH99U9QwoBuOyPSG
        aOzmNe7uqF4suFclvezByPARh7B0XmKu4GPbn1pH06kWV1JIN4ffo1H6wWP4iptFJ+WERqjkk470K
        IFhphvsgZekx8JUPcc1ugL/D+tP4uNu60NfDFl93DRYn5SZrvZaF+Se0skUB5pelJ12c=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1j84Fr-0001nx-CT; Sat, 29 Feb 2020 16:42:15 +0100
Date:   Sat, 29 Feb 2020 16:42:15 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net] net: dsa: fix phylink_start()/phylink_stop() calls
Message-ID: <20200229154215.GD6305@lunn.ch>
References: <E1j7lU0-0003pp-Ff@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1j7lU0-0003pp-Ff@rmk-PC.armlinux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -int dsa_port_enable(struct dsa_port *dp, struct phy_device *phy)
> +int dsa_port_enable_locked(struct dsa_port *dp, struct phy_device *phy)
>  {
>  	struct dsa_switch *ds = dp->ds;
>  	int port = dp->index;
>  	int err;
>  
> +	if (dp->pl)
> +		phylink_start(dp->pl);
> +
>  	if (ds->ops->port_enable) {
>  		err = ds->ops->port_enable(ds, port, phy);
>  		if (err)
> @@ -81,7 +84,18 @@ int dsa_port_enable(struct dsa_port *dp, struct phy_device *phy)
>  	return 0;
>  }

Hi Russell

I'm wondering about the order here. You are starting phylink before
the port is actually enabled in the hardware. Could phylink_start()
result in synchronous calls into the MAC to configure the port? If the
port is disabled, maybe that configuration will not stick?

The current code in dsa_slave_open() first enables the port, then
calls phylink_start(). So maybe we should keep the ordering the same?
  
> +void dsa_port_disable_locked(struct dsa_port *dp)
>  {
>  	struct dsa_switch *ds = dp->ds;
>  	int port = dp->index;
> @@ -91,6 +105,16 @@ void dsa_port_disable(struct dsa_port *dp)
>  
>  	if (ds->ops->port_disable)
>  		ds->ops->port_disable(ds, port);
> +
> +	if (dp->pl)
> +		phylink_stop(dp->pl);
> +}

The current code first stops phylink, then disables the port...

Apart from this ordering issue, the code looks good.

Thanks
    Andrew
