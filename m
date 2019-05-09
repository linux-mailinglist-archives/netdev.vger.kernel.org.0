Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 690F018BB8
	for <lists+netdev@lfdr.de>; Thu,  9 May 2019 16:29:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726597AbfEIO3a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 May 2019 10:29:30 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:59355 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726192AbfEIO3a (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 May 2019 10:29:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=o1P+iHcm/WelbNQUUbk3aR/BpZM5+Dk0wm3H2D+sFZw=; b=mhoUtsJGPnRj6wVqYnXeagJj5z
        /dEl952Pg9vWmSqIQg2Ffrg9sDD5hE+iFZQmpizDFyvm9MPiu3CZMlTLQywVTQSWvcUhpTsSlMaUE
        AWuC43NXd1y75UBAIP2VFIvINtFU0JKqvacKjY1ha4TbP4FJXKwB+qp3hIRGJBxI6h8k=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hOk33-0002Fn-OI; Thu, 09 May 2019 16:29:25 +0200
Date:   Thu, 9 May 2019 16:29:25 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Grzeschik <m.grzeschik@pengutronix.de>
Cc:     Tristram.Ha@microchip.com, kernel@pengutronix.de,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org
Subject: Re: [RFC 1/3] mdio-bitbang: add SMI0 mode support
Message-ID: <20190509142925.GL25013@lunn.ch>
References: <20190508211330.19328-1-m.grzeschik@pengutronix.de>
 <20190508211330.19328-2-m.grzeschik@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190508211330.19328-2-m.grzeschik@pengutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 08, 2019 at 11:13:28PM +0200, Michael Grzeschik wrote:
> Some microchip phys support the Serial Management Interface Protocol
> (SMI) for the configuration of the extended register set. We add
> MII_ADDR_SMI0 as an availabe interface to the mdiobb write and read
> functions, as this interface can be easy realized using the bitbang mdio
> driver.
> 
> Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
> Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
> ---
>  drivers/net/phy/mdio-bitbang.c | 10 ++++++++++
>  include/linux/phy.h            | 12 ++++++++++++
>  2 files changed, 22 insertions(+)
> 
> diff --git a/drivers/net/phy/mdio-bitbang.c b/drivers/net/phy/mdio-bitbang.c
> index 5136275c8e739..a978f8a9a172b 100644
> --- a/drivers/net/phy/mdio-bitbang.c
> +++ b/drivers/net/phy/mdio-bitbang.c
> @@ -22,6 +22,10 @@
>  #define MDIO_READ 2
>  #define MDIO_WRITE 1
>  
> +#define SMI0_RW_OPCODE	0
> +#define SMI0_READ_PHY	(1 << 4)
> +#define SMI0_WRITE_PHY	(0 << 4)
> +
>  #define MDIO_C45 (1<<15)
>  #define MDIO_C45_ADDR (MDIO_C45 | 0)
>  #define MDIO_C45_READ (MDIO_C45 | 3)
> @@ -157,6 +161,9 @@ static int mdiobb_read(struct mii_bus *bus, int phy, int reg)
>  	if (reg & MII_ADDR_C45) {
>  		reg = mdiobb_cmd_addr(ctrl, phy, reg);
>  		mdiobb_cmd(ctrl, MDIO_C45_READ, phy, reg);
> +	} else if (reg & MII_ADDR_SMI0) {
> +		mdiobb_cmd(ctrl, SMI0_RW_OPCODE,
> +			   (reg & 0xE0) >> 5 | SMI0_READ_PHY, reg);
>  	} else
>  		mdiobb_cmd(ctrl, MDIO_READ, phy, reg);
>  
> @@ -188,6 +195,9 @@ static int mdiobb_write(struct mii_bus *bus, int phy, int reg, u16 val)
>  	if (reg & MII_ADDR_C45) {
>  		reg = mdiobb_cmd_addr(ctrl, phy, reg);
>  		mdiobb_cmd(ctrl, MDIO_C45_WRITE, phy, reg);
> +	} else if (reg & MII_ADDR_SMI0) {
> +		mdiobb_cmd(ctrl, SMI0_RW_OPCODE,
> +			   (reg & 0xE0) >> 5 | SMI0_WRITE_PHY, reg);
>  	} else
>  		mdiobb_cmd(ctrl, MDIO_WRITE, phy, reg);
>  
> diff --git a/include/linux/phy.h b/include/linux/phy.h
> index 073fb151b5a99..f011722fbd5c2 100644
> --- a/include/linux/phy.h
> +++ b/include/linux/phy.h
> @@ -199,6 +199,18 @@ static inline const char *phy_modes(phy_interface_t interface)
>     IEEE 802.3ae clause 45 addressing mode used by 10GIGE phy chips. */
>  #define MII_ADDR_C45 (1<<30)
>  
> +/* Serial Management Interface (SMI) uses the following frame format:
> + *
> + *       preamble|start|Read/Write|  PHY   |  REG  |TA|   Data bits      | Idle
> + *               |frame| OP code  |address |address|  |                  |
> + * read | 32x1´s | 01  |    00    | 1xRRR  | RRRRR |Z0| 00000000DDDDDDDD |  Z
> + * write| 32x1´s | 01  |    00    | 0xRRR  | RRRRR |10| xxxxxxxxDDDDDDDD |  Z
> + *
> + * The register number is encoded with the 5 least significant bits in REG
> + * and the 3 most significant bits in PHY
> + */
> +#define MII_ADDR_SMI0 (1<<31)
> +

Michael

This is a Micrel Proprietary protocol. So we should reflect this in
the name. MII_ADDR_MICREL_SMI? Why the 0? Are there different
versions? Maybe replace all SMI0 with MICREL_SMI in mdio-bitbang.c

When i look at this, i don't see how a normal MDIO bus driver is going
to support this. Only the bit banging driver, or maybe a Micrel MDIO
bus master hardware driver. So i think the diagram should be placed
into mdio-bitbang.c, and it would be nice to add a diagram of standard
SMI.

	Andrew
