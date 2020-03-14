Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20FCA18581A
	for <lists+netdev@lfdr.de>; Sun, 15 Mar 2020 02:54:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727550AbgCOByf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Mar 2020 21:54:35 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:36040 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727298AbgCOBye (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Mar 2020 21:54:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=WB2hC7u1Rf4qwcDkIAtTzj5N6O1WK9yw8It6QfvYX8s=; b=Sf7JcTOTD2LZ6+7sTLcWuOplCE
        yy77P1D4tn4KKXL0wpo4MzgHT8qAwRbvVrz5O5+imHof7hjHKIkhUKGXlbaw0d8+1DHE05sPdSUo2
        NzynINiGJAGhi3fg8MXQhGr1y3at2KVKwpPuvqGtc3gYDrkDHDDpOkWzbWp/+frYhjlY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jDBp8-0001fW-SZ; Sat, 14 Mar 2020 19:47:50 +0100
Date:   Sat, 14 Mar 2020 19:47:50 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH net-next 4/8] net: dsa: mv88e6xxx: extend phylink to
 Serdes PHYs
Message-ID: <20200314184750.GH5388@lunn.ch>
References: <20200314101431.GF25745@shell.armlinux.org.uk>
 <E1jD3pX-0006Db-Hi@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1jD3pX-0006Db-Hi@rmk-PC.armlinux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> @@ -683,9 +754,14 @@ static void mv88e6xxx_mac_link_up(struct dsa_switch *ds, int port,
>  		/* FIXME: for an automedia port, should we force the link
>  		 * down here - what if the link comes up due to "other" media
>  		 * while we're bringing the port up, how is the exclusivity
> -		 * handled in the Marvell hardware? E.g. port 4 on 88E6532
> +		 * handled in the Marvell hardware? E.g. port 2 on 88E6390
>  		 * shared between internal PHY and Serdes.
>  		 */

automedia makes things interesting. You have to read the cmode to know
if the internal PHY or the SERDES has 'won'. I thimk my preference
would of been to keep it simple and look at phy-mode in DT. If it is
1000BaseX, turn on the SERDES and turn off the internal PHY. But i
know of at lease one person who wants auto media.

> +static int mv88e6xxx_serdes_pcs_get_state(struct mv88e6xxx_chip *chip,
> +					  u16 status, u16 lpa,
> +					  struct phylink_link_state *state)
> +{

At some point in the future, we might want to rename this. If i
remember correct, the 1000BaseX and SGMII PCS uses different registers
to the 10G PCS. We will need to look at the cmode to determine which
PCS is in operation.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
