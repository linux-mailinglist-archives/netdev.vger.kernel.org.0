Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52A8D3CA1AC
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 17:50:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239370AbhGOPxl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 11:53:41 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:57158 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238841AbhGOPxj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Jul 2021 11:53:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=1EFyQ8ie4h3mbGIJ1dxorPzj8uRnod+uetVD2o2OJKM=; b=mgkXGI/nwWsq2mDsXt8XTySciO
        kstWDHDz03080VYmuyyETkxNbVV3hSV5X/npVOZYSAjAOkQPNJlPoOb/wprd5cKLOsuQqVpX2JGEE
        uqXhnOjkAtQtwLtvihB5K6dfOTarIRKHMhhiO2oRWAWduMX0KvktJPPm6XkAlviqlNPY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1m43dE-00DVG6-Hv; Thu, 15 Jul 2021 17:50:36 +0200
Date:   Thu, 15 Jul 2021 17:50:36 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Lino Sanfilippo <LinoSanfilippo@gmx.de>, woojung.huh@microchip.com,
        UNGLinuxDriver@microchip.com, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] net: dsa: tag_ksz: dont let the hardware process the
 layer 4 checksum
Message-ID: <YPBZTFlWwXK/hl95@lunn.ch>
References: <20210714191723.31294-1-LinoSanfilippo@gmx.de>
 <20210714191723.31294-3-LinoSanfilippo@gmx.de>
 <20210714194812.stay3oqyw3ogshhj@skbuf>
 <YO9F2LhTizvr1l11@lunn.ch>
 <20210715065455.7nu7zgle2haa6wku@skbuf>
 <YPAzZXaC/En3s4ly@lunn.ch>
 <20210715143648.yutq6vceoblnhhfp@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210715143648.yutq6vceoblnhhfp@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Tell me more (show me some code).

https://elixir.bootlin.com/linux/latest/source/drivers/net/ethernet/marvell/mvneta.c#L1747

and

https://elixir.bootlin.com/linux/latest/source/drivers/net/ethernet/marvell/mvneta.c#L1944

It uses skb_network_offset(skb) to know where the real header is. This
should work independent of DSA or EDSA.

mvpp2_main.c looks to have something similar. The older mv643xx_eth.c
also has something, but it is more subtle. Ah, found it:

https://elixir.bootlin.com/linux/latest/source/drivers/net/ethernet/marvell/mv643xx_eth.c#L683

> I expect Marvell switches to be equally broken on the Broadcom genet
> controller?

Maybe. Depends on how genet works. A Broadcom switch connected to a
Marvell MAC probably works, since the code is generic. It should work
for any switch which uses head tagging, although mv643xx_eth.c is
limited to 4 or 8 byte tags.

	Andrew
