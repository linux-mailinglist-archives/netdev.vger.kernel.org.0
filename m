Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 197512A21A1
	for <lists+netdev@lfdr.de>; Sun,  1 Nov 2020 21:54:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727062AbgKAUyN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Nov 2020 15:54:13 -0500
Received: from 95-31-39-132.broadband.corbina.ru ([95.31.39.132]:56318 "EHLO
        blackbox.su" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726848AbgKAUyN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 1 Nov 2020 15:54:13 -0500
Received: from metabook.localnet (metabook.metanet [192.168.2.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by blackbox.su (Postfix) with ESMTPSA id DD28982D0B;
        Sun,  1 Nov 2020 23:54:14 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=blackbox.su;
        s=201811; t=1604264054;
        bh=NM/b9PAL2Tkb6vXEKVIO7dSi39/y1uyXlRgLXij/Xk0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XuGb8lBSZyASAF9XxE/ie6Y/YbZ4gNX5FFLEi9YJwXFPOlo/6LYvaqr8i2NkuLyVX
         khGlxnRvJPuVgd+wa86zaoSS7bDEQPq9RipqLvQobeuu0MLo+e1s+H17Mmay3BMeCu
         J27zRmCKn6Omi5fCyr0VOA1GFxmesqoMw9KxX74q5JIKf82lDH52v2pqatymJsy9LO
         9tiyoIjnJnp2BQKpN5NuCxzwOqipklRi58EgbrgNXoZvpjIsmJOvBypkFuqKiRm1MN
         f8XY3X0+QWNjFoDuv4kamUtSYFM8QwWOB3MOjwn31RiexgvrVIhlIsnNZnZrpkR9CY
         C/vB1sRfzp0Gg==
From:   Sergej Bauer <sbauer@blackbox.su>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Markus Elfring <Markus.Elfring@web.de>, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com, linux-kernel@vger.kernel.org,
        Bryan Whitehead <bryan.whitehead@microchip.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH v2] lan743x: Fix for potential null pointer dereference
Date:   Sun, 01 Nov 2020 23:54:04 +0300
Message-ID: <2534292.OMWdIsrgY9@metabook>
In-Reply-To: <20201101203820.GD1109407@lunn.ch>
References: <20201031143619.7086-1-sbauer@blackbox.su> <145853726.prPdODYtnq@metabook> <20201101203820.GD1109407@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sunday, November 1, 2020 11:38:20 PM MSK Andrew Lunn wrote:
> On Sun, Nov 01, 2020 at 10:54:38PM +0300, Sergej Bauer wrote:
> > > > Signed-off-by: Sergej Bauer <sbauer@blackbox.su>
> > > 
> > > * I miss a change description here.
> > 
> > The reason for the fix is when the device is down netdev->phydev will be
> > NULL and there is no checking for this situation. So 'ethtool ethN' leads
> > to kernel panic.
> > 
> > > > @@ -809,9 +812,12 @@ static int lan743x_ethtool_set_wol(struct
> > > > net_device
> > > > *netdev,>
> > > > 
> > > >  	device_set_wakeup_enable(&adapter->pdev->dev, (bool)wol->wolopts);
> > > > 
> > > > -	phy_ethtool_set_wol(netdev->phydev, wol);
> > > > +	if (netdev->phydev)
> > > > +		ret = phy_ethtool_set_wol(netdev->phydev, wol);
> > > > +	else
> > > > +		ret = -EIO;
> 
> -ENETDOWN would be better, it gives a hit that WoL can be configured
> when the interface is configured up.
> 
>  Andrew

Ok, thank you, Andrew! I was doubted in the correctness of returning -EIO.

                Regards,
                        Sergej.



