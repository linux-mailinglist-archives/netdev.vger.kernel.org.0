Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DAEA571D2E
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 16:45:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230411AbiGLOoz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 10:44:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233665AbiGLOom (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 10:44:42 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B0E821E35;
        Tue, 12 Jul 2022 07:44:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=TIMJuXXvaSY0EDiwuEYp7w+lzyifMk6auUfw6Pmy8H8=; b=f5VgE4wDv0lSQC5lTzqabKnVFB
        2MGHWFSwP7P/40XxyUz26NovWdTh/lT2cUCI2TDwxXIOFpKmrZjyEk8viz7KfDHVlA8JUC0ZTuscZ
        dumqPhR//ME/UnijW00DpOQvNb6P0vH/GMuMygkcYT5BPY+TK8t5suvl4SjK8Q7k26y0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oBH7h-00A3p2-Tq; Tue, 12 Jul 2022 16:44:25 +0200
Date:   Tue, 12 Jul 2022 16:44:25 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Frank <Frank.Sae@motor-comm.com>
Cc:     Peter Geis <pgwipeout@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, yinghong.zhang@motor-comm.com,
        fei.zhang@motor-comm.com, hua.sun@motor-comm.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] net: phy: Add driver for Motorcomm yt8521 gigabit
 ethernet
Message-ID: <Ys2IyaI2u2iLL0g6@lunn.ch>
References: <20220711103706.709-1-Frank.Sae@motor-comm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220711103706.709-1-Frank.Sae@motor-comm.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 11, 2022 at 06:37:06PM +0800, Frank wrote:
> patch v3:
>  Hi Andrew
>  Thanks and based on your comments we modified the patch as below.
>  
> > It is generally not that simple. Fibre, you probably want 1000BaseX,
> > unless the fibre module is actually copper, and then you want
> > SGMII. So you need something to talk to the fibre module and ask it
> > what it is. That something is phylink. Phylink does not support both
> > copper and fibre at the same time for one MAC.
> 
>  yes, you said it and for MAC, it does not support copper and Fiber at same time.
>  but from Physical Layer, you know, sometimes both Copper and Fiber cables are
>  connected. in this case, Phy driver should do arbitration and report to MAC
>  which media should be used and Link-up.
>  This is the reason that the driver has a "polling mode", and by default, also
>  this driver takes fiber as first priority which matches phy chip default behavior.

The Marvell 10G driver is another PHY which can be used for both
Copper and Fibre. In order to do this, it has a few extra functions:

static int mv3310_sfp_insert(void *upstream, const struct sfp_eeprom_id *id)
{
        struct phy_device *phydev = upstream;
        __ETHTOOL_DECLARE_LINK_MODE_MASK(support) = { 0, };
        phy_interface_t iface;

        sfp_parse_support(phydev->sfp_bus, id, support);
        iface = sfp_select_interface(phydev->sfp_bus, support);

        if (iface != PHY_INTERFACE_MODE_10GBASER) {
                dev_err(&phydev->mdio.dev, "incompatible SFP module inserted\n");
                return -EINVAL;
        }
        return 0;
}

static const struct sfp_upstream_ops mv3310_sfp_ops = {
        .attach = phy_sfp_attach,
        .detach = phy_sfp_detach,
        .module_insert = mv3310_sfp_insert,
};

Also see the at803x driver.

This allows the PHY to report to phylink what it is doing, and to
determine the host side interface mode. I would expect this driver to
implement sfp_upstream_ops as well.

	  Andrew
