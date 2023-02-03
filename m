Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C474689E16
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 16:24:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232569AbjBCPY3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 10:24:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232391AbjBCPYK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 10:24:10 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B648DAF0F0;
        Fri,  3 Feb 2023 07:22:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=u7jwLMXldmeJxhCcGr/15aDobf0TWv+r93C3ZJojfIk=; b=3pb3nUWrNv8EtAjlU3Jf2bufFz
        wpolZXfSNmIA+jXRDuE07Cza6yeXZB0ys4qHd43GYco99oA6Ipt7PE2lJ8GnT5M4E1RYinv1+/AGE
        FcU/UPOrwdC+sfK0C7yyQenTc1QxZ4yrFboXQhQN/hTFhZ1Unmg9PjQJ+3C7QzjGEDMY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pNxsp-0041JE-Vy; Fri, 03 Feb 2023 16:21:47 +0100
Date:   Fri, 3 Feb 2023 16:21:47 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Daniel Golle <daniel@makrotopia.org>, netdev@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        John Crispin <john@phrozen.org>, Felix Fietkau <nbd@nbd.name>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jianhui Zhao <zhaojh329@gmail.com>,
        =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Subject: Re: [PATCH 7/9] net: pcs: add driver for MediaTek SGMII PCS
Message-ID: <Y90mi1dTmMkXdkPX@lunn.ch>
References: <cover.1675407169.git.daniel@makrotopia.org>
 <30f3ff512a2082ba4cf58bf6098f2ed776051976.1675407169.git.daniel@makrotopia.org>
 <Y90Wxb8iuCRo06yr@lunn.ch>
 <20230203150014.ugkasp4rq5arqs6s@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230203150014.ugkasp4rq5arqs6s@skbuf>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 03, 2023 at 05:00:14PM +0200, Vladimir Oltean wrote:
> On Fri, Feb 03, 2023 at 03:14:29PM +0100, Andrew Lunn wrote:
> > > index 6e7e6c346a3e..cf65646656e9 100644
> > > --- a/drivers/net/pcs/Kconfig
> > > +++ b/drivers/net/pcs/Kconfig
> > > @@ -18,6 +18,12 @@ config PCS_LYNX
> > >  	  This module provides helpers to phylink for managing the Lynx PCS
> > >  	  which is part of the Layerscape and QorIQ Ethernet SERDES.
> > >  
> > > +config PCS_MTK
> > > +	tristate
> > > +	help
> > > +	  This module provides helpers to phylink for managing the LynxI PCS
> > > +	  which is part of MediaTek's SoC and Ethernet switch ICs.
> > 
> > You should probably have a more specific name, for when MTK produces a
> > new PCS which is completely different.
> > 
> > Also, how similar is this LynxI PCS to the Lynx PCS?
> 
> Probably not very similar. Here's the Mediatek 32-bit memory map,
> translated by me to a 16-bit MDIO memory map:

Thanks. Given the similarities in the name, i had to ask...

	Andrew
