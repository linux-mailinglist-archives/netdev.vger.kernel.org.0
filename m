Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA3EE6CB179
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 00:13:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229538AbjC0WNS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 18:13:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbjC0WNR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 18:13:17 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C92D3D8
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 15:13:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=W56/CGNMJiQr06iysdj9N9jPShiwfekjmoAjm4N21Pw=; b=T9WF3yMH/Fy8ryWQK0VskRcm39
        gRWaQ3OPixHEsmuU1V3t2KRu4/82dk90G1gCiU/Q7KBPuRk/yik1l3Wg6PWS9flMBxypwYb8SFs4l
        47c7t5UFtyMhsJIBI2Scbs7tUA4EKVqreaIeoMrJn6QnbT1wIstgzj/5cE8gnBo3ZAIM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pgv5W-008ZaB-IZ; Tue, 28 Mar 2023 00:13:14 +0200
Date:   Tue, 28 Mar 2023 00:13:14 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>
Subject: Re: [RFC/RFT 05/23] net: phy: Immediately call adjust_link if only
 tx_lpi_enabled changes
Message-ID: <30ae760b-b7c4-4756-bfde-27b43c64b28a@lunn.ch>
References: <20230327170201.2036708-1-andrew@lunn.ch>
 <20230327170201.2036708-6-andrew@lunn.ch>
 <ZCHaGbhSWk5xLnAi@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZCHaGbhSWk5xLnAi@shell.armlinux.org.uk>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 27, 2023 at 07:02:01PM +0100, Russell King (Oracle) wrote:
> On Mon, Mar 27, 2023 at 07:01:43PM +0200, Andrew Lunn wrote:
> > The MAC driver changes its EEE hardware configuration in its
> > adjust_link callback. This is called when auto-neg completes. If
> > set_eee is called with a change to tx_lpi_enabled which does not
> > trigger an auto-neg, it is necessary to call the adjust_link callback
> > so that the MAC is reconfigured to take this change into account.
> > 
> > When setting phydev->eee_active, take tx_lpi_enabled into account, so
> > the MAC drivers don't need to consider tx_lpi_enabled.
> > 
> > Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> 
> Hmm..
> 
> > @@ -1619,11 +1619,20 @@ int phy_ethtool_set_eee(struct phy_device *phydev, struct ethtool_eee *data)
> >  
> >  	mutex_lock(&phydev->lock);
> >  	ret = genphy_c45_ethtool_set_eee(phydev, data);
> > -	if (!ret)
> > +	if (ret >= 0) {
> > +		if (ret == 0) {
> > +			/* auto-neg not triggered */
> > +			if (phydev->tx_lpi_enabled != data->tx_lpi_enabled) {
> > +				phydev->tx_lpi_enabled = data->tx_lpi_enabled;
> > +				if (phydev->link)
> > +					phy_link_up(phydev);
> > +			}
> > +		}
> >  		phydev->tx_lpi_enabled = data->tx_lpi_enabled;
> 
> So we set eee_active depending on tx_lpi_enabled:
> 
> > +			phydev->eee_active = (err & phydev->tx_lpi_enabled);
> 
> However, if tx_lpi_enabled changes state in this function, we don't
> update phydev->eee_active, but it's phydev->eee_active that gets
> passed back to MAC drivers. Is that intentional?

No, that is a bug. I don't think phy_check_link_status() can be called
here, since we might not be in state RUNNING. So a bit of refactoring
is required to add a function which can update phydev->eee_active.

Thanks
	Andrew
