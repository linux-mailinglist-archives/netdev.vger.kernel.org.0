Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF20029895
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 15:11:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391439AbfEXNK5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 09:10:57 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55808 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391361AbfEXNK5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 May 2019 09:10:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=2r9aqgu0e5ubA7q5DOisFwWJNL/IXIBlFZbEpx2Qecw=; b=i3X5HGFN1J+mISudMJeaZvy4T2
        0oYPRb4JCQ3n9naqpn08+ov7/3AiXm97wmD4Itdx8x+ADVa/Z95q9jQtwdtJpFROoQw/1Jdtx+3tO
        eTZvXL0NblxRlB2bWLwXPBdcropcVjUvmiXF9NLP9Xzuf+vR0XttL3OFGE4QFxn4b+9c=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hU9yC-0000qs-7c; Fri, 24 May 2019 15:10:48 +0200
Date:   Fri, 24 May 2019 15:10:48 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "maxime.chevallier@bootlin.com" <maxime.chevallier@bootlin.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [RFC PATCH net-next 2/9] net: phy: Guard against the presence of
 a netdev
Message-ID: <20190524131048.GA2979@lunn.ch>
References: <20190523011958.14944-1-ioana.ciornei@nxp.com>
 <20190523011958.14944-3-ioana.ciornei@nxp.com>
 <20190523221835.GB21208@lunn.ch>
 <VI1PR0402MB280048FACD410AA6356B2410E0020@VI1PR0402MB2800.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <VI1PR0402MB280048FACD410AA6356B2410E0020@VI1PR0402MB2800.eurprd04.prod.outlook.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Hi Ioana
> > 
> > Looking at the functions changed here, they seem to be related to phy_attach(),
> > phy_connect(), and phy_detach() etc. Is the intention you can call these
> > functions and pass a NULL pointer for the net_device?
> > 
> > 	Andrew
> 
> Hi Andrew,
> 
> Yes, the intention is exactly to pass a NULL pointer for the  net_device from PHYLINK.
> The changes that do this are in "[RFC,net-next,5/9] net: phylink: Add phylink_create_raw".

Hi Ioana

I think in general, we don't want MAC drivers doing this.

We should enforce that the general APIs get a netdev. PHYLINK uses
phy_attach_direct() which is the lowest level of these attach() and
connect() calls. And there is only one MAC driver using
phy_attach_direct(). So please add checks for the netdev and return
-EINVAL in these higher level callers to phy_attach_direct().

Thanks
	Andrew
