Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3CEE19D57
	for <lists+netdev@lfdr.de>; Fri, 10 May 2019 14:36:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727502AbfEJMgf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 May 2019 08:36:35 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60196 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727323AbfEJMgf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 May 2019 08:36:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=MekxkdfHTv2UimRHiZmA2i0PnXs7VdSAQMinmdkKnhE=; b=wmjULQshAnrZLW6mPy0G8sg2Ht
        i72aMz0fZ96w/aIR2MYGATSfdBDD9iwxuKVyml93yNkWc8+xW5z3Rhs8YI+nM48mkHAM6zvA/S3fJ
        onW3Q4qIMOo8ZND6BXN7koeRIRCe7cSIfrQWzubVoMVi9vkDnALNbVh4N4dXxqC4Hup4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hP4lL-0002Nc-CP; Fri, 10 May 2019 14:36:31 +0200
Date:   Fri, 10 May 2019 14:36:31 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Grzeschik <mgr@pengutronix.de>
Cc:     Tristram.Ha@microchip.com, kernel@pengutronix.de,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org
Subject: Re: [RFC 1/3] mdio-bitbang: add SMI0 mode support
Message-ID: <20190510123631.GE4889@lunn.ch>
References: <20190508211330.19328-1-m.grzeschik@pengutronix.de>
 <20190508211330.19328-2-m.grzeschik@pengutronix.de>
 <20190509142925.GL25013@lunn.ch>
 <20190510073224.obymtg4thqleypne@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190510073224.obymtg4thqleypne@pengutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > +/* Serial Management Interface (SMI) uses the following frame format:
> > > + *
> > > + *       preamble|start|Read/Write|  PHY   |  REG  |TA|   Data bits      | Idle
> > > + *               |frame| OP code  |address |address|  |                  |
> > > + * read | 32x1큦 | 01  |    00    | 1xRRR  | RRRRR |Z0| 00000000DDDDDDDD |  Z
> > > + * write| 32x1큦 | 01  |    00    | 0xRRR  | RRRRR |10| xxxxxxxxDDDDDDDD |  Z
> > > + *
> > > + * The register number is encoded with the 5 least significant bits in REG
> > > + * and the 3 most significant bits in PHY
> > > + */
> > > +#define MII_ADDR_SMI0 (1<<31)
> > > +
> > 
> > Michael
> > 
> > This is a Micrel Proprietary protocol. So we should reflect this in
> > the name. MII_ADDR_MICREL_SMI? Why the 0? Are there different
> > versions? Maybe replace all SMI0 with MICREL_SMI in mdio-bitbang.c
> 
> There are two variants of the SMI interface.

Hi Michael

O.K, that explains the 0.

> 
> The KSZ8863/73/93 Products use the above Variant described as "SMI0".
> 
> The KSZ8864/95 Products use another layout:
> 
>       preamble|start|Read/Write|  PHY   |  REG  |TA|   Data bits      | Idle
>               |frame| OP code  |address |address|  |                  |
> read | 32x1큦 | 01  |    10    | RR11R  | RRRRR |Z0| 00000000DDDDDDDD |  Z
> write| 32x1큦 | 01  |    01    | RR11R  | RRRRR |10| xxxxxxxxDDDDDDDD |  Z
> 
> So they describe their write/read operation in the OP code rather then
> the PHY address.

At a first look, i think a standard MDIO bus controller can do this?
If so, we don't need a second define, just some code in the switch
driver which shuffles bits around.

> 
> We could change the SMI index to SMI_KSZ88X3 for the current SMI0 to
> give it a more descriptive name.

That seems sensible. In the mv88e6xxx driver, we name things based on
the first device to introduce the feature.

    Andrew
