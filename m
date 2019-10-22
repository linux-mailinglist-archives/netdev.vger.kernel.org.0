Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26AA5E0C60
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 21:15:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732548AbfJVTPY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 15:15:24 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:58482 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729696AbfJVTPY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Oct 2019 15:15:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=WJCO3YKGAZjhIMjHbvwyuW3SP20kLT82+PT6PZHrxow=; b=MZ8b6oPjA8QFqiQrEhS43S8Nr6
        v+iXaJsONln111aM8Nmsb2ZxpTtBoHoVgDyLuPGD+KvYXYnbAo0XLdHiviBB0GNXvxyPZ+LUnAp4a
        lulCMsb5PEwrcGKWjonqkzMIv/lJq/fgqgSPwYyoqYxP4Kr3nf6GrhJh8jRvEcIguqh0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iMzcm-0003N8-M8; Tue, 22 Oct 2019 21:15:20 +0200
Date:   Tue, 22 Oct 2019 21:15:20 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Thomas =?iso-8859-1?Q?H=E4mmerle?= 
        <Thomas.Haemmerle@wolfvision.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "m.tretter@pengutronix.de" <m.tretter@pengutronix.de>
Subject: Re: [PATCH v2] net: phy: dp83867: support Wake on LAN
Message-ID: <20191022191520.GA12558@lunn.ch>
References: <1571742645-13800-1-git-send-email-thomas.haemmerle@wolfvision.net>
 <1571749572-9736-1-git-send-email-thomas.haemmerle@wolfvision.net>
 <7916e170-116d-421b-e95b-b3c3cca7f97a@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7916e170-116d-421b-e95b-b3c3cca7f97a@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > +static int dp83867_set_wol(struct phy_device *phydev,
> > +			   struct ethtool_wolinfo *wol)
> > +{
> > +	struct net_device *ndev = phydev->attached_dev;
> > +	u16 val_rxcfg, val_micr;
> > +	const u8 *mac;
> > +
> > +	val_rxcfg = phy_read_mmd(phydev, DP83867_DEVADDR, DP83867_RXFCFG);
> > +	val_micr = phy_read(phydev, MII_DP83867_MICR);
> > +
> > +	if (wol->wolopts & (WAKE_MAGIC | WAKE_MAGICSECURE | WAKE_UCAST |
> > +			    WAKE_BCAST)) {
> > +		val_rxcfg |= DP83867_WOL_ENH_MAC;
> > +		val_micr |= MII_DP83867_MICR_WOL_INT_EN;
> > +
> > +		if (wol->wolopts & WAKE_MAGIC) {
> > +			mac = (const u8 *)ndev->dev_addr;
> 
> Using a cast to add/remove a const qualifier usually isn't too nice.
> Why not simply declare mac w/o const?
> 
> Also PHY might not be attached. I think ndev should be checked for NULL.

Hi Heiner

I thought about that as well. But the ethtool API is invoked using a
network interface name. It would be odd to call into the PHY driver if
the PHY was not attached. And the resulting Oops would help us
identify the bug.

Plus all the other PHY drivers which implement magic packet WoL assume
the PHY is attached. It could be they are all broken i suppose...

    Andrew
