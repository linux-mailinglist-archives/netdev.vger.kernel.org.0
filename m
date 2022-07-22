Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2A6757DF5C
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 12:10:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234826AbiGVKKL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 06:10:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234772AbiGVKKI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 06:10:08 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACFA3BC3;
        Fri, 22 Jul 2022 03:10:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=I/TeU7vG/TCOeE+ZVogJWf8GrihqAvOKUnOuXWXxgFM=; b=gpVqBUulvPzgezoxNMRIKP2SGb
        drQsSP3WP7roNnSXfozLzw/HXwmUhHl6WR2lUaAps63KJzLx0TCnLASXZnAIJx5SMuck8cObaFgwM
        vzNPCbt4GJj5qOJ0FNb6uENG4gEuaeddmhI1bzhN8Qvm5XmcSt1pUYwjtTd9pY24AQqRo+ZlMWZ2G
        y99Xl5/V7lmuCggMcxw2zEVQ64M5+9T5f94ZWp5/hDP0Q+plfcZ+LTNEBZCf9z9divaWjTeC5pZq8
        dBxbIZfpbkmwsfJuTRIfnH42EIveQsG7kzEO/AKy5VXUsmtfJxrEhfTupUaMsNT9hafFmCf91agHB
        hpDb90ng==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:33504)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oEpbc-0006lj-R2; Fri, 22 Jul 2022 11:10:00 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oEpba-0005k8-67; Fri, 22 Jul 2022 11:09:58 +0100
Date:   Fri, 22 Jul 2022 11:09:58 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [Patch net-next v1 3/9] net: dsa: microchip: add common duplex
 and flow control function
Message-ID: <Ytp3dl5l9jkp94lU@shell.armlinux.org.uk>
References: <20220722092459.18653-1-arun.ramadoss@microchip.com>
 <20220722092459.18653-4-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220722092459.18653-4-arun.ramadoss@microchip.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Fri, Jul 22, 2022 at 02:54:53PM +0530, Arun Ramadoss wrote:
> +void ksz_set_fullduplex(struct ksz_device *dev, int port, bool val)
> +{
> +	const u8 *bitval = dev->info->xmii_ctrl0;
> +	const u16 *regs = dev->info->regs;
> +	u8 data8;
> +
> +	ksz_pread8(dev, port, regs[P_XMII_CTRL_0], &data8);
> +
> +	data8 &= ~P_MII_DUPLEX_M;
> +
> +	if (val)
> +		data8 |= FIELD_PREP(P_MII_DUPLEX_M,
> +				    bitval[P_MII_FULL_DUPLEX]);
> +	else
> +		data8 |= FIELD_PREP(P_MII_DUPLEX_M,
> +				    bitval[P_MII_HALF_DUPLEX]);
> +
> +	ksz_pwrite8(dev, port, regs[P_XMII_CTRL_0], data8);
> +}
> +
> +void ksz_set_tx_pause(struct ksz_device *dev, int port, bool val)
> +{
> +	const u32 *masks = dev->info->masks;
> +	const u16 *regs = dev->info->regs;
> +	u8 data8;
> +
> +	ksz_pread8(dev, port, regs[P_XMII_CTRL_0], &data8);
> +
> +	if (val)
> +		data8 |= masks[P_MII_TX_FLOW_CTRL];
> +	else
> +		data8 &= ~masks[P_MII_TX_FLOW_CTRL];
> +
> +	ksz_pwrite8(dev, port, regs[P_XMII_CTRL_0], data8);
> +}
> +
> +void ksz_set_rx_pause(struct ksz_device *dev, int port, bool val)
> +{
> +	const u32 *masks = dev->info->masks;
> +	const u16 *regs = dev->info->regs;
> +	u8 data8;
> +
> +	ksz_pread8(dev, port, regs[P_XMII_CTRL_0], &data8);
> +
> +	if (val)
> +		data8 |= masks[P_MII_RX_FLOW_CTRL];
> +	else
> +		data8 &= ~masks[P_MII_RX_FLOW_CTRL];
> +
> +	ksz_pwrite8(dev, port, regs[P_XMII_CTRL_0], data8);
> +}
> +

Having looked through all the proposed patches and noticed that these
three functions are always called serially. What is the reason to make
these separate functions which all read the same register, modify a
single bit, and then write it back.

What we end up with is the following sequence:

- read P_XMII_CTRL_0
- udpate P_MII_HALF_DUPLEX bit
- write P_XMII_CTRL_0
- read P_XMII_CTRL_0
- update P_MII_TX_FLOW_CTRL bit
- write P_XMII_CTRL_0
- read P_XMII_CTRL_0
- update P_MII_RX_FLOW_CTRL bit
- write P_XMII_CTRL_0

whereas the original code did:

- read P_XMII_CTRL_0
- udpate P_MII_HALF_DUPLEX, P_MII_TX_FLOW_CTRL and P_MII_RX_FLOW_CTRL
  bits
- write P_XMII_CTRL_0

which was much more efficient, not only in terms of CPU cycles, but also
IO cycles and code size.

You could do this instead:

	u8 mask, val, ctrl0;

	mask = P_MII_DUPLEX_M | masks[P_MII_TX_FLOW_CTRL] |
	       masks[P_MII_RX_FLOW_CTRL];

	if (duplex == DUPLEX_FULL)
		val = FIELD_PREP(P_MII_DUPLEX_M, bitval[P_MII_FULL_DUPLEX]);
	else
		val = FIELD_PREP(P_MII_DUPLEX_M, bitval[P_MII_HALF_DUPLEX]);

	if (tx_pause)
		val |= masks[P_MII_TX_FLOW_CTRL];
	
	if (rx_pause)
		val |= masks[P_MII_RX_FLOW_CTRL];
	
	ksz_pread8(dev, port, REG_PORT_XMII_CTRL_0, &ctrl0);
	ctrl0 = (ctrl0 & ~mask) | val;
	ksz_pwrite8(dev, port, REG_PORT_XMII_CTRL_0, ctrl0);

and maybe convert that last three lines into a helper, ksz_pmodify8()
which could be useful in other parts of the driver where you do a
read-modify-write operation on a register.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
