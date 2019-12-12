Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80CF311CDEF
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 14:14:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729385AbfLLNOx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 08:14:53 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:50038 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728996AbfLLNOx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Dec 2019 08:14:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=HwFFFSlWfHzqreqZF4L/lRrwS7lsRs+Qp/Ypk9EX61I=; b=qWt2v+gPalYn/7PZPp6B8/ifdQ
        XkVjCVwg5iQ8g10WqfvYnD3LYkFfu3KDjDe6wF0sbAtCdu5AvggDiK++C1gwGJRbKxAX7oog0u/vv
        yx8B8LAOm00iMkukQWzvIgPPqQTOFpcil6XRUTPLfbv3kTjh9n9YxSXWt8MAJffJzNfk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ifOIq-0002hL-An; Thu, 12 Dec 2019 14:14:48 +0100
Date:   Thu, 12 Dec 2019 14:14:48 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Baruch Siach <baruch@tkos.co.il>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>, netdev@vger.kernel.org,
        Denis Odintsov <d.odintsov@traviangames.com>,
        Hubert Feurstein <h.feurstein@gmail.com>
Subject: Re: [BUG] mv88e6xxx: tx regression in v5.3
Message-ID: <20191212131448.GA9959@lunn.ch>
References: <87tv67tcom.fsf@tarshish>
 <20191211131111.GK16369@lunn.ch>
 <87fthqu6y6.fsf@tarshish>
 <20191211174938.GB30053@lunn.ch>
 <20191212085045.nqhfldkbebqzzamv@sapphire.tkos.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191212085045.nqhfldkbebqzzamv@sapphire.tkos.co.il>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> As you guessed, mv88e6xxx_mac_config() exits early because 
> mv88e6xxx_phy_is_internal() returns true for port number 2, and 'mode' is 
> MLO_AN_PHY. What is the right MAC/PHY setup flow in this case?

So this goes back to

commit d700ec4118f9d5e88db8f678e7342f28c93037b9
Author: Marek Vasut <marex@denx.de>
Date:   Wed Sep 12 00:15:24 2018 +0200

    net: dsa: mv88e6xxx: Make sure to configure ports with external PHYs
    
    The MV88E6xxx can have external PHYs attached to certain ports and those
    PHYs could even be on different MDIO bus than the one within the switch.
    This patch makes sure that ports with such PHYs are configured correctly
    according to the information provided by the PHY.

@@ -709,13 +717,17 @@ static void mv88e6xxx_mac_config(struct dsa_switch *ds, int port,
        struct mv88e6xxx_chip *chip = ds->priv;
        int speed, duplex, link, pause, err;
 
-       if (mode == MLO_AN_PHY)
+       if ((mode == MLO_AN_PHY) && mv88e6xxx_phy_is_internal(ds, port))
                return;

The idea being, that the MAC has direct knowledge of the PHY
configuration because it is internal. There is no need to configure
the MAC, it does it itself.

This assumption seems wrong for the switch you have.

I think it is just a optimisation. So we can probably remove this phy
internal test.

And
        } else if (!mv88e6xxx_phy_is_internal(ds, port)) {

also needs to change.

It would be interesting to know if the MAC is completely wrongly
configured, or it is just a subset of parameters.

	    Andrew
