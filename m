Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 441F757D8F8
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 05:27:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230486AbiGVD1R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 23:27:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbiGVD1P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 23:27:15 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9261A9368C;
        Thu, 21 Jul 2022 20:27:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=5u7RoGzLQzUaoRKGdfln+jG1YUe/P0RSrCB5jT5RLuM=; b=0sMZ7ACkqjUQb6O3VzDVkDhKS1
        +XwKqrE/tpIKef+upJnJuKhE3bOyDvteAFa6KsBWDQLXCRJEc3NS8XRmUCLaCHfiN3cnV8ASD8AZ0
        bE/YIYiiP0tv3gPrD5+PwM9/JRO8KP7/5+vHGo2jiyJSw7XNW6EWOfEcntARYMK9l9tY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oEjJh-00B6bG-L8; Fri, 22 Jul 2022 05:27:05 +0200
Date:   Fri, 22 Jul 2022 05:27:05 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Chunhao Lin <hau@realtek.com>, netdev@vger.kernel.org,
        nic_swsd@realtek.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] r8169: add support for rtl8168h(revid 0x2a) +
 rtl8211fs fiber application
Message-ID: <YtoZCaLTMFw8cTem@lunn.ch>
References: <20220721144550.4405-1-hau@realtek.com>
 <356f4285-1e83-ab14-c890-4131acd8e61d@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <356f4285-1e83-ab14-c890-4131acd8e61d@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > +#define RT_SFP_ST (1)
> > +#define RT_SFP_OP_W (1)
> > +#define RT_SFP_OP_R (2)
> > +#define RT_SFP_TA_W (2)
> > +#define RT_SFP_TA_R (0)
> > +
> > +static void rtl_sfp_if_write(struct rtl8169_private *tp,
> > +				  struct rtl_sfp_if_mask *sfp_if_mask, u8 reg, u16 val)
> > +{
> > +	struct rtl_sfp_if_info sfp_if_info = {0};
> > +	const u16 mdc_reg = PIN_I_SEL_1;
> > +	const u16 mdio_reg = PIN_I_SEL_2;
> > +
> > +	rtl_select_sfp_if(tp, sfp_if_mask, &sfp_if_info);
> > +
> > +	/* change to output mode */
> > +	r8168_mac_ocp_write(tp, PINOE, sfp_if_info.mdio_oe_o);
> > +
> > +	/* init sfp interface */
> > +	r8168_mac_ocp_write(tp, mdc_reg, sfp_if_info.mdc_pd);
> > +	r8168_mac_ocp_write(tp, mdio_reg, sfp_if_info.mdio_pu);
> > +
> > +	/* preamble 32bit of 1 */
> > +	rtl_sfp_shift_bit_in(tp, &sfp_if_info, 0xffffffff, 32);
> > +
> > +	/* opcode write */
> > +	rtl_sfp_shift_bit_in(tp, &sfp_if_info, RT_SFP_ST, 2);
> > +	rtl_sfp_shift_bit_in(tp, &sfp_if_info, RT_SFP_OP_W, 2);
> > +
> > +	/* phy address */
> > +	rtl_sfp_shift_bit_in(tp, &sfp_if_info, sfp_if_mask->phy_addr, 5);
> > +
> > +	/* phy reg */
> > +	rtl_sfp_shift_bit_in(tp, &sfp_if_info, reg, 5);
> > +
> > +	/* turn-around(TA) */
> > +	rtl_sfp_shift_bit_in(tp, &sfp_if_info, RT_SFP_TA_W, 2);
> > +
> > +	/* write phy data */
> > +	rtl_sfp_shift_bit_in(tp, &sfp_if_info, val, 16);

This looks like a bit-banging MDIO bus? If so, please use the kernel
code, drivers/net/mdio/mdio-bitbang.c. You just need to provide it
with functions to write and read a bit, and it will do the rest,
including C45 which you don't seem to support here.

> > +static enum rtl_sfp_if_type rtl8168h_check_sfp(struct rtl8169_private *tp)
> > +{
> > +	int i;
> > +	int const checkcnt = 4;
> > +
> > +	rtl_sfp_eeprom_write(tp, 0x1f, 0x0000);
> > +	for (i = 0; i < checkcnt; i++) {
> > +		if (rtl_sfp_eeprom_read(tp, 0x02) != RTL8211FS_PHY_ID_1 ||
> > +			rtl_sfp_eeprom_read(tp, 0x03) != RTL8211FS_PHY_ID_2)
> > +			break;
> > +	}

Reading registers 2 and 3 for a PhY idea? Who not just use phylib, and
a PHY driver?

  Andrew
