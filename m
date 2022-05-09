Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23E6551FCE9
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 14:33:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234585AbiEIMgj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 08:36:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234528AbiEIMgh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 08:36:37 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAF35284924;
        Mon,  9 May 2022 05:32:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=VvadgFGR5P7Y1v/cSX7S4UjT+qCj1J/fEEMY6EaLxbE=; b=4DROTrduGydJj/ZaRB/TsSFC78
        3LscZqNAdYrMMpEP3jgH3vbIaVJyOBHorGQU8yR3rZkRizfb3PRHeXcluKeyidUkeapArws3gBCj7
        2vGRgVGhklzt19zJV+t7shNPDyG7k3ox9PMeKfXdllIp/o7qrMbAzDKgyc1weMy1Uz5w=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1no2Z3-001wQT-9m; Mon, 09 May 2022 14:32:37 +0200
Date:   Mon, 9 May 2022 14:32:37 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Puranjay Mohan <p-mohan@ti.com>
Cc:     linux-kernel@vger.kernel.org, davem@davemloft.net,
        edumazet@google.com, krzysztof.kozlowski+dt@linaro.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org, nm@ti.com,
        ssantosh@kernel.org, s-anna@ti.com,
        linux-arm-kernel@lists.infradead.org, rogerq@kernel.org,
        grygorii.strashko@ti.com, vigneshr@ti.com, kishon@ti.com,
        robh+dt@kernel.org, afd@ti.com
Subject: Re: [PATCH 2/2] net: ti: icssg-prueth: Add ICSSG ethernet driver
Message-ID: <YnkJ5bFd72d0FagD@lunn.ch>
References: <20220506052433.28087-1-p-mohan@ti.com>
 <20220506052433.28087-3-p-mohan@ti.com>
 <YnVQW7xpSWEE2/HP@lunn.ch>
 <f674c56c-0621-f471-9517-5c349940d362@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f674c56c-0621-f471-9517-5c349940d362@ti.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> >> +static void icssg_init_emac_mode(struct prueth *prueth)
> >> +{
> >> +	u8 mac[ETH_ALEN] = { 0 };
> >> +
> >> +	if (prueth->emacs_initialized)
> >> +		return;
> >> +
> >> +	regmap_update_bits(prueth->miig_rt, FDB_GEN_CFG1, SMEM_VLAN_OFFSET_MASK, 0);
> >> +	regmap_write(prueth->miig_rt, FDB_GEN_CFG2, 0);
> >> +	/* Clear host MAC address */
> >> +	icssg_class_set_host_mac_addr(prueth->miig_rt, mac);
> > 
> > Seems an odd thing to do, set it to 00:00:00:00:00:00. You probably
> > want to add a comment why you do this odd thing.
> 
> Actually, this is when the device is configured as a bridge, the host
> mac address has to be set to zero to while bringing it back to emac
> mode. I will add a comment to explain this.

I don't see any switchdev interface. How does it get into bridge mode?

> >> +	} else if (emac->link) {
> >> +		new_state = true;
> >> +		emac->link = 0;
> >> +		/* defaults for no link */
> >> +
> >> +		/* f/w should support 100 & 1000 */
> >> +		emac->speed = SPEED_1000;
> >> +
> >> +		/* half duplex may not supported by f/w */
> >> +		emac->duplex = DUPLEX_FULL;
> > 
> > Why set speed and duplex when you have just lost the link? They are
> > meaningless until the link comes back.
> 
> These were just the default values that we added.
> What do you suggest I put here?

Nothing. If the link is down, they are meaningless. If something is
accessing them when the link is down, that code is broken. So i
suppose you could give them poison values to help find your broken
code.

> >> +	for_each_child_of_node(eth_ports_node, eth_node) {
> >> +		u32 reg;
> >> +
> >> +		if (strcmp(eth_node->name, "port"))
> >> +			continue;
> >> +		ret = of_property_read_u32(eth_node, "reg", &reg);
> >> +		if (ret < 0) {
> >> +			dev_err(dev, "%pOF error reading port_id %d\n",
> >> +				eth_node, ret);
> >> +		}
> >> +
> >> +		if (reg == 0)
> >> +			eth0_node = eth_node;
> >> +		else if (reg == 1)
> >> +			eth1_node = eth_node;
> > 
> > and if reg == 4
> > 
> > Or reg 0 appears twice?
> 
> In both of the cases that you mentioned, the device tree schema check
> will fail, hence, we can safely assume that this will be 0 and 1 only.

Nothing forces you to run the scheme checker. It is not run by the
kernel before it starts accessing the DT blob. You should assume it is
invalid until you have proven it to be valid.

	Andrew
