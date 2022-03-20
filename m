Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4AD94E1952
	for <lists+netdev@lfdr.de>; Sun, 20 Mar 2022 02:17:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244594AbiCTBTC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Mar 2022 21:19:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234519AbiCTBTB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Mar 2022 21:19:01 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3CBA154041;
        Sat, 19 Mar 2022 18:17:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=2e0T9LwsAC/Tza29vckpTrrbUDteKZ8EaVgFk6ZcSJ0=; b=PgNA7yKTmSZUdBXaC4YkfVCmtW
        6GQFkA4k8n5/WlQ5XTys57uWdNq5bZCHvteKR8KTxjo+nNvnTYQEtCerg4naR249oxD1nX62GjD0L
        6Pc6uMD6GDr/Ywi8NfUGXQIpneNx8RuBU0Q+sDMdwcY8abUfKCIp3IpszNr+Dda8NtRk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nVkCH-00Blh4-3s; Sun, 20 Mar 2022 02:17:29 +0100
Date:   Sun, 20 Mar 2022 02:17:29 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
Cc:     netdev@vger.kernel.org, olteanv@gmail.com, robh+dt@kernel.org,
        UNGLinuxDriver@microchip.com, woojung.huh@microchip.com,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v9 net-next 06/11] net: dsa: microchip: add DSA support
 for microchip lan937x
Message-ID: <YjaAqXfiBrMggIdA@lunn.ch>
References: <20220318085540.281721-1-prasanna.vengateshan@microchip.com>
 <20220318085540.281721-7-prasanna.vengateshan@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220318085540.281721-7-prasanna.vengateshan@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +int lan937x_reset_switch(struct ksz_device *dev)
> +{
> +	u32 data32;
> +	u8 data8;
> +	int ret;
> +
> +	/* reset switch */
> +	ret = lan937x_cfg(dev, REG_SW_OPERATION, SW_RESET, true);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = ksz_read8(dev, REG_SW_LUE_CTRL_1, &data8);
> +	if (ret < 0)
> +		return ret;
> +
> +	/* Enable Auto Aging */
> +	ret = ksz_write8(dev, REG_SW_LUE_CTRL_1, data8 | SW_LINK_AUTO_AGING);
> +	if (ret < 0)
> +		return ret;
> +
> +	/* disable interrupts */
> +	ret = ksz_write32(dev, REG_SW_INT_MASK__4, SWITCH_INT_MASK);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = ksz_write32(dev, REG_SW_PORT_INT_MASK__4, 0xFF);
> +	if (ret < 0)
> +		return ret;
> +
> +	return ksz_read32(dev, REG_SW_PORT_INT_STATUS__4, &data32);

I would probably enable auto aging in the setup routing, not the
reset.  Disabling interrupts is less clear, maybe it also belongs in
setup?

> +static void lan937x_switch_exit(struct ksz_device *dev)
> +{
> +	lan937x_reset_switch(dev);
> +}

Humm. Does a reset leave the switch in a dumb mode, or is it totally
disabled?

> +int lan937x_internal_phy_write(struct ksz_device *dev, int addr, int reg,
> +			       u16 val)
> +{
> +	u16 temp, addr_base;
> +	unsigned int value;
> +	int ret;
> +
> +	/* Check for internal phy port */
> +	if (!lan937x_is_internal_phy_port(dev, addr))
> +		return -EOPNOTSUPP;
> +
> +	if (lan937x_is_internal_base_tx_phy_port(dev, addr))
> +		addr_base = REG_PORT_TX_PHY_CTRL_BASE;
> +	else
> +		addr_base = REG_PORT_T1_PHY_CTRL_BASE;
> +
> +	temp = PORT_CTRL_ADDR(addr, (addr_base + (reg << 2)));
> +
> +	ret = ksz_write16(dev, REG_VPHY_IND_ADDR__2, temp);
> +	if (ret < 0)
> +		return ret;

...

> +}
> +
> +int lan937x_internal_phy_read(struct ksz_device *dev, int addr, int reg,
> +			      u16 *val)
> +{
> +	u16 temp, addr_base;
> +	unsigned int value;
> +	int ret;
> +
> +	/* Check for internal phy port, return 0xffff for non-existent phy */
> +	if (!lan937x_is_internal_phy_port(dev, addr))
> +		return 0xffff;
> +
> +	if (lan937x_is_internal_base_tx_phy_port(dev, addr))
> +		addr_base = REG_PORT_TX_PHY_CTRL_BASE;
> +	else
> +		addr_base = REG_PORT_T1_PHY_CTRL_BASE;
> +
> +	/* get register address based on the logical port */
> +	temp = PORT_CTRL_ADDR(addr, (addr_base + (reg << 2)));
> +
> +	ret = ksz_write16(dev, REG_VPHY_IND_ADDR__2, temp);
> +	if (ret < 0)
> +		return ret;

Looks pretty similar to me. You should pull this out into a helper.


> +void lan937x_port_setup(struct ksz_device *dev, int port, bool cpu_port)
> +{
> +	struct dsa_switch *ds = dev->ds;
> +	u8 member;
> +
> +	/* enable tag tail for host port */
> +	if (cpu_port) {
> +		lan937x_port_cfg(dev, port, REG_PORT_CTRL_0,
> +				 PORT_TAIL_TAG_ENABLE, true);
> +	}

Checkpatch probably warns here that the {} are not needed.

> +
> +	/* disable frame check length field */
> +	lan937x_port_cfg(dev, port, REG_PORT_MAC_CTRL_0, PORT_FR_CHK_LENGTH,
> +			 false);
> +
> +	/* set back pressure for half duplex */
> +	lan937x_port_cfg(dev, port, REG_PORT_MAC_CTRL_1, PORT_BACK_PRESSURE,
> +			 true);
> +
> +	/* enable 802.1p priority */
> +	lan937x_port_cfg(dev, port, P_PRIO_CTRL, PORT_802_1P_PRIO_ENABLE, true);
> +
> +	if (!lan937x_is_internal_phy_port(dev, port)) {
> +		/* enable flow control */
> +		lan937x_port_cfg(dev, port, REG_PORT_XMII_CTRL_0,
> +				 PORT_TX_FLOW_CTRL | PORT_RX_FLOW_CTRL,
> +				 true);
> +	}

Here as well.

> +struct lan_alu_struct {
> +	/* entry 1 */
> +	u8	is_static:1;
> +	u8	is_src_filter:1;
> +	u8	is_dst_filter:1;
> +	u8	prio_age:3;
> +	u32	_reserv_0_1:23;
> +	u8	mstp:3;

I assume this works O.K, but bitfields are nornaly defined using one
type. I would of used u32 for them all. Is there some advantage of
missing u8 and u32?

> +	/* entry 2 */
> +	u8	is_override:1;
> +	u8	is_use_fid:1;
> +	u32	_reserv_1_1:22;
> +	u8	port_forward:8;
> +	/* entry 3 & 4*/
> +	u32	_reserv_2_1:9;
> +	u8	fid:7;
> +	u8	mac[ETH_ALEN];
> +};

  Andrew
