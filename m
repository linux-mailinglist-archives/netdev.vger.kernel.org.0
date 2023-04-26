Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 077646EFC98
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 23:43:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239848AbjDZVni (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 17:43:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239759AbjDZVnh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 17:43:37 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 337532117
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 14:43:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=leGVRGfsMRGNDI78ABU5pGNQ16pnw8fAJpPb0KbQ9ns=; b=TYLXK52b/OdpfEe/rsaqkAL7uq
        VjfsggVt9YN9gp2+UCeII3r+1iOxRuLIY6f0205SgO0fx1beG7Pnm435DgAylUwtscPg4iCAPcIhV
        krr6Esq/uRmrK7mRmJVwAcD8K1fWErSnHfuJYIbYUO9xQr36XNjrmHRsoVoKgOIL8XuI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1prmvF-00BJ2v-0P; Wed, 26 Apr 2023 23:43:33 +0200
Date:   Wed, 26 Apr 2023 23:43:32 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     =?iso-8859-1?Q?Ram=F3n?= Nordin Rodriguez 
        <ramon.nordin.rodriguez@ferroamp.se>
Cc:     Parthiban Veerasooran <Parthiban.Veerasooran@microchip.com>,
        netdev@vger.kernel.org, davem@davemloft.net,
        jan.huber@microchip.com, thorsten.kummermehr@microchip.com
Subject: Re: [PATCH net-next 2/2] net: phy: microchip_t1s: add support for
 Microchip LAN865x Rev.B0 PHYs
Message-ID: <d4649b51-b06e-42f3-88d3-e269c304d0ac@lunn.ch>
References: <20230426114655.93672-1-Parthiban.Veerasooran@microchip.com>
 <20230426114655.93672-3-Parthiban.Veerasooran@microchip.com>
 <ZEmPT1El342j7O8I@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZEmPT1El342j7O8I@debian>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > +/* indirect read pseudocode from AN1760
> > + * write_register(0x4, 0x00D8, addr)
> > + * write_register(0x4, 0x00DA, 0x2)
> > + * return (int8)(read_register(0x4, 0x00D9))
> > + */
> 
> I suggest this comment block is slightly changed to
> 
> /* Pulled from AN1760 describing 'indirect read'
>  *
>  * write_register(0x4, 0x00D8, addr)
>  * write_register(0x4, 0x00DA, 0x2)
>  * return (int8)(read_register(0x4, 0x00D9))
>  *
>  * 0x4 refers to memory map selector 4, which maps to MDIO_MMD_VEND2
>  */
> 
> > +static int lan865x_revb0_indirect_read(struct phy_device *phydev, u16 addr)
> > +{
> > +	int ret;
> > +
> > +	ret = phy_write_mmd(phydev, MDIO_MMD_VEND2, 0xD8, addr);
> > +	if (ret)
> > +		return ret;
> > +
> > +	ret = phy_write_mmd(phydev, MDIO_MMD_VEND2, 0xDA, 0x0002);
> > +	if (ret)
> > +		return ret;
> > +
> > +	ret = phy_read_mmd(phydev, MDIO_MMD_VEND2, 0xD9);
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	return ret;
> > +}

It is unclear to me how 0x4 maps to MDIO_MMD_VEND2, which is 31.

Why not just describe it in terms of MMD read/write?

> The func itself might get a bit more readable by naming the magic regs
> and value, below is a suggestion.
> 
> static int lan865x_revb0_indirect_read(struct phy_device *phydev, u16 addr)
> {
> 	int ret;
> 	static const u16 fixup_w0_reg = 0x00D8;
> 	static const u16 fixup_r0_reg = 0x00D9;
> 	static const u16 fixup_w1_val = 0x0002;
> 	static const u16 fixup_w1_reg = 0x00DA;

#defines would be normal, not variables.

And i guess 0x0002 is actually BIT(1). And it probably means something
like START? 0xD8 is some sort of address register, so i would put ADDR
in the name. 0xD9 appears to be a control register, so CTRL. And 0xDA
is a data register? So these could be give more descriptive names,
just by my reverse engineering it. With the actual data sheet, i'm
expect somebody could do better.

> > +static int lan865x_revb0_config_init(struct phy_device *phydev)
> > +{
> > +	int addr;
> > +	int value;
> > +	int ret;
> > +
> > +	/* As per AN1760, the below configuration applies only to the LAN8650/1
> > +	 * hardware revision Rev.B0.
> > +	 */
> 
> I think this is implied by having it the device specific init func, you
> can probably drop this comment.

A reference to AN1760 somewhere in the driver would be good, to help
people understand why this magic is needed. Does AN1760 actually
explain the magic, or just say you need to do this to make it work, Trust Us(tm).

	    Andrew
