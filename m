Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0839739C3E8
	for <lists+netdev@lfdr.de>; Sat,  5 Jun 2021 01:31:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231787AbhFDXdJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 19:33:09 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:46418 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229853AbhFDXdI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Jun 2021 19:33:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=YJbFM+mniWomHAgPF3WLlUJ8IqG1KjGc3LuxmDM/h84=; b=pUELUT9KUfEAa9dQ14tQhXy427
        mCtysKeJt67EDv5jVWEiZnB99rm7Q4gjTf7RqaOk1vWudkEH8dcigAp3jLoH6O/p4SitfY+tNHRoo
        vNS+xvTbziTLGo7H2CJBcI74HeJapOOk/nwfWewzVp03iMuhdBzzdro1QMYETsSFyz1A=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lpJHW-007sOj-UT; Sat, 05 Jun 2021 01:31:14 +0200
Date:   Sat, 5 Jun 2021 01:31:14 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v1 5/7] net: usb: asix: add error handling for
 asix_mdio_* functions
Message-ID: <YLq3wuAMvljqEJbn@lunn.ch>
References: <20210604134244.2467-1-o.rempel@pengutronix.de>
 <20210604134244.2467-6-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210604134244.2467-6-o.rempel@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -void asix_mdio_write(struct net_device *netdev, int phy_id, int loc, int val)
> +static int __asix_mdio_write(struct net_device *netdev, int phy_id, int loc,
> +			     int val)
>  {
>  	struct usbnet *dev = netdev_priv(netdev);
>  	__le16 res = cpu_to_le16(val);
> @@ -517,13 +522,24 @@ void asix_mdio_write(struct net_device *netdev, int phy_id, int loc, int val)
>  	} while (!(smsr & AX_HOST_EN) && (i++ < 30) && (ret != -ENODEV));
>  	if (ret == -ENODEV) {
>  		mutex_unlock(&dev->phy_mutex);
> -		return;
> +		return ret;

Now that you have added an out: it might be better to use a goto?

Otherwise

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
