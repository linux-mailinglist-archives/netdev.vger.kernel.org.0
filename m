Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C981A301E41
	for <lists+netdev@lfdr.de>; Sun, 24 Jan 2021 19:52:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726445AbhAXSv7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jan 2021 13:51:59 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:56988 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726177AbhAXSv6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 24 Jan 2021 13:51:58 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1l3kTh-002PUt-OC; Sun, 24 Jan 2021 19:51:13 +0100
Date:   Sun, 24 Jan 2021 19:51:13 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     stefanc@marvell.com, netdev@vger.kernel.org,
        thomas.petazzoni@bootlin.com, davem@davemloft.net,
        nadavh@marvell.com, ymarkman@marvell.com,
        linux-kernel@vger.kernel.org, kuba@kernel.org, mw@semihalf.com,
        atenart@kernel.org
Subject: Re: [PATCH v2 RFC net-next 03/18] net: mvpp2: add CM3 SRAM memory map
Message-ID: <YA3BoZxqPrUCWZ0w@lunn.ch>
References: <1611488647-12478-1-git-send-email-stefanc@marvell.com>
 <1611488647-12478-4-git-send-email-stefanc@marvell.com>
 <20210124124443.GX1551@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210124124443.GX1551@shell.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 24, 2021 at 12:44:43PM +0000, Russell King - ARM Linux admin wrote:
> On Sun, Jan 24, 2021 at 01:43:52PM +0200, stefanc@marvell.com wrote:
> > +		priv->sram_pool = of_gen_pool_get(dn, "cm3-mem", 0);
> > +		if (!priv->sram_pool) {
> > +			if (!defer_once) {
> > +				defer_once = true;
> > +				/* Try defer once */
> > +				return -EPROBE_DEFER;
> > +			}
> > +			dev_warn(&pdev->dev, "DT is too old, Flow control not supported\n");
> > +			return -ENOMEM;
> > +		}
> > +		priv->cm3_base = (void __iomem *)gen_pool_alloc(priv->sram_pool,
> > +								MSS_SRAM_SIZE);
> > +		if (!priv->cm3_base)
> > +			return -ENOMEM;
> 
> This probably could do with a comment indicating that it is reliant on
> this allocation happening at offset zero into the SRAM. The only reason
> that is guaranteed _at the moment_ is because the SRAM mapping is 0x800
> bytes in size, and you are requesting 0x800 bytes in this allocation,
> so allocating the full size.

Hi Russell

I'm wondering if using a pool even makes sense. The ACPI case just
ioremap() the memory region. Either this memory is dedicated, and then
there is no need to use a pool, or the memory is shared, and at some
point the ACPI code is going to run into problems when some other
driver also wants access.

       Andrew
