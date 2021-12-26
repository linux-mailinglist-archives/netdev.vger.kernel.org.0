Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CE2647F95B
	for <lists+netdev@lfdr.de>; Sun, 26 Dec 2021 23:26:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234729AbhLZW0i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Dec 2021 17:26:38 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:42154 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232727AbhLZW0h (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 Dec 2021 17:26:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Ruwqd3R8hjH2U0DTpsHDY4KKMtPY7Qqnmy4Da5pTtCA=; b=LUf7Pp9I+k2KsTDL8n7IJ+fDPH
        jzWhSPbnowCaw8bdW1LR6Cpku/pkvhLFOsig4PPIKwWhKu5zxSz7BCklQ9Q51LClqsc2yRzm4lw2U
        IBAfGVtJbf2ls4QINwv3rYxYyYOcrKgiSyTfyit88ONnUxFTvVd0oeEwKoLYvhYCXjFA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1n1byI-00HX2c-UI; Sun, 26 Dec 2021 23:26:30 +0100
Date:   Sun, 26 Dec 2021 23:26:30 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Daniel Golle <daniel@makrotopia.org>,
        linux-mediatek@lists.infradead.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>
Subject: Re: [PATCH] net: ethernet: mtk_eth_soc: implement Clause 45 MDIO
 access
Message-ID: <YcjsFnbg87o45ltd@lunn.ch>
References: <YcjepQ2fmkPZ2+pE@makrotopia.org>
 <YcjjzNJ159Bo1xk7@lunn.ch>
 <YcjlMCacTTJ4RsSA@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YcjlMCacTTJ4RsSA@shell.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 26, 2021 at 09:57:04PM +0000, Russell King (Oracle) wrote:
> On Sun, Dec 26, 2021 at 10:51:08PM +0100, Andrew Lunn wrote:
> > > +	if (phy_register & MII_ADDR_C45) {
> > > +		u8 dev_num = (phy_register >> 16) & 0x1f;
> > > +		u16 reg = (u16)(phy_register & 0xffff);
> > 
> > Hi Daniel
> > 
> > You can use the helpers
> > 
> > mdio_phy_id_is_c45()
> > mdio_phy_id_prtad()
> > mdio_phy_id_devad()
> 
> Before someone makes a mistake with this... no, don't use these. These
> are for the userspace MII ioctl API, not for drivers.

Ah, Sorry.

Thanks Russell, i got this wrong. I though there was some helpers for
this, and happened to land on bnxt_hwrm_port_phy_read(), without
checking what it was actually used for.

> The C45 register address can be extracted by masking with
> MII_REGADDR_C45_MASK. The C45 devad can be extracted by shifting right
> by MII_DEVADDR_C45_SHIFT and masking 5 bits. We don't have helpers for
> this.

Maybe we should have helpers.

      Andrew
