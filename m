Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F5E41D6BA4
	for <lists+netdev@lfdr.de>; Sun, 17 May 2020 19:58:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726270AbgEQR6b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 May 2020 13:58:31 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:36074 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726252AbgEQR6b (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 17 May 2020 13:58:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Lzvw59ofRtdjnameVD7whWRnjy+izTp5aL8GTNO7p/0=; b=ASLGuOZ4QQaTphpA9Vl9Pe3CfZ
        RsN55L1xr96rpwtOMejvthCBPs3IwWsUqUJ35vD5JQLxTA4qdNfvjxsf8FZzoygm5USPrnWvkIJuE
        cKPyZY83wmPPj/Ugo32VWMxiLfZGJ5R8XBcPZnLIyraiM9oc7c6pcLKzm4M2sNpw0MSI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jaNYK-002YDs-Fb; Sun, 17 May 2020 19:58:20 +0200
Date:   Sun, 17 May 2020 19:58:20 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Baruch Siach <baruch@tkos.co.il>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org
Subject: Re: [RFC PATCH] drivers: net: mdio_bus: try indirect clause 45 regs
 access
Message-ID: <20200517175820.GB606317@lunn.ch>
References: <3e2c01449dc29bc3d138d3a19e0c2220495dd7ed.1589710856.git.baruch@tkos.co.il>
 <20200517103558.GT1551@shell.armlinux.org.uk>
 <87lflq3afx.fsf@tarshish>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87lflq3afx.fsf@tarshish>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > I don't think this should be done at mdiobus level; I think this is a
> > layering violation.  It needs to happen at the PHY level because the
> > indirect C45 access via C22 registers is specific to PHYs.
> >
> > It also needs to check in the general case that the PHY does indeed
> > support the C22 register set - not all C45 PHYs do.
> >
> > So, I think we want this fallback to be conditional on:
> >
> > - are we probing for the PHY, trying to read its IDs and
> >   devices-in-package registers - if yes, allow fallback.
> > - does the C45 PHY support the C22 register set - if yes, allow
> >   fallback.
> 
> I'll take a look. Thanks.
 
Hi Baruch

Another option to consider is a third compatible string. We have
compatibles for C22, C45. Add another one for C45 over C22, and have
the core support it as the third access method next to C22 and C45.

We already rely on the DT author getting C22 vs C45 correct for the
hardware. Is it too much to ask they get it write when there are three
options?

As to your particular hardware, if i remember correctly, some of the
Marvell SoCs have mdio and xmdio bus masters. The mdio bus can only do
C22, and the xmdio can only do C45. Have the hardware engineers put
the PHY on the wrong bus?

     Andrew

