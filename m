Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCE431BAFCC
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 22:53:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726587AbgD0UxK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 16:53:10 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:39278 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726233AbgD0UxK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Apr 2020 16:53:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=efGhNMcByzIKwbSuL6+vIN5HMP8eMlHWTX1uzI68CKU=; b=okKfxjU3DeDIGelVFIvPPuBMDI
        C68caCcqv6LaOQtuwHOeWOCI8Ke5BP7ftpNSssHybDw/WHfD64fLx81xk1PLunFmEyCcNNdOGugix
        8uoCpG3F4SlvffSBQD8mDNgibT/XU1r7Is6/zTZzYUQ0dLE1B3PRUE49/rBVSPHMSt4o=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jTA8J-005H3T-FU; Mon, 27 Apr 2020 22:13:39 +0200
Date:   Mon, 27 Apr 2020 22:13:39 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Leonard Crestez <leonard.crestez@nxp.com>
Cc:     Andy Duan <fugang.duan@nxp.com>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Chris Healy <Chris.Healy@zii.aero>,
        dl-linux-imx <linux-imx@nxp.com>, Chris Healy <cphealy@gmail.com>
Subject: Re: [PATCH] net: ethernet: fec: Replace interrupt driven MDIO with
 polled IO
Message-ID: <20200427201339.GJ1250287@lunn.ch>
References: <20200414004551.607503-1-andrew@lunn.ch>
 <VI1PR04MB6941D611F6EF67BB42826D4EEEAF0@VI1PR04MB6941.eurprd04.prod.outlook.com>
 <20200427164620.GD1250287@lunn.ch>
 <VI1PR04MB6941C603529307039AF7F4ABEEAF0@VI1PR04MB6941.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <VI1PR04MB6941C603529307039AF7F4ABEEAF0@VI1PR04MB6941.eurprd04.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Leonard

> Does not help.

Thanks for testing it.

> What does seem to help is inserting prints after the 
> FEC_ENET_MII check but that's probably because it inject a long delay 
> equivalent to the long udelay Andy has mentioned.

Yes, serial ports are slow...

> I found that in my case FEC_ENET_MII is already set on entry to 
> fec_enet_mdio_read, doesn't this make fec_enet_mdio_wait pointless?
> Perhaps the problem is that the MII Interrupt pending bit is not 
> cleared. I can fix the problem like this:
> 
> diff --git drivers/net/ethernet/freescale/fec_main.c 
> drivers/net/ethernet/freescale/fec_main.c
> index 1ae075a246a3..f1330071647c 100644
> --- drivers/net/ethernet/freescale/fec_main.c
> +++ drivers/net/ethernet/freescale/fec_main.c
> @@ -1841,10 +1841,19 @@ static int fec_enet_mdio_read(struct mii_bus 
> *bus, int mii_id, int regnum)
> 
>          ret = pm_runtime_get_sync(dev);
>          if (ret < 0)
>                  return ret;
> 
> +       if (1) {
> +               u32 ievent;
> +               ievent = readl(fep->hwp + FEC_IEVENT);
> +               if (ievent & FEC_ENET_MII) {
> +                       dev_warn(dev, "found FEC_ENET_MII pending\n");
> +                       writel(FEC_ENET_MII, fep->hwp + FEC_IEVENT);
> +               }

How often do you see this warning?

The patch which is causing the regression clears any pending events in
fec_enet_mii_init() and after each time we wait. So the bit should not
be set here. If it is set, the question is why?

The other option is that the hardware is broken. It is setting the
event bit way too soon, before we can actually read the data from the
register.

	Andrew	
