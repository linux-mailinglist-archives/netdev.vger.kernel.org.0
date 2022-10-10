Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 002E95FA43E
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 21:36:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229653AbiJJTft (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Oct 2022 15:35:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbiJJTfq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Oct 2022 15:35:46 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AE5974B89;
        Mon, 10 Oct 2022 12:35:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=bQBNkKvViR1DqMAB7e/n5mW7JBZLqIweo5nh9dpW24o=; b=UtwroqWkI3CCaRCCtqKUuIf2jd
        4Iq1VH2cffWzbOiCNH2YKJFC7RNrfeT+qET96YufGuV4MJShQxpBDyD+/bA37FebtwTOT4MXtghUr
        TGNKe7faXU/qIMOQVx/WiIpWRC5vjbBoReF6RJ09jXIPYnxRjY/tIQDuWVjryOWqisfQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ohyYp-001eJE-6j; Mon, 10 Oct 2022 21:35:35 +0200
Date:   Mon, 10 Oct 2022 21:35:35 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, bryan.whitehead@microchip.com,
        edumazet@google.com, pabeni@redhat.com,
        UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next V3] net: lan743x: Add support to SGMII register
 dump for PCI11010/PCI11414 chips
Message-ID: <Y0R0B0sOzjOTIM66@lunn.ch>
References: <20221003103821.4356-1-Raju.Lakkaraju@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221003103821.4356-1-Raju.Lakkaraju@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>  static int lan743x_get_regs_len(struct net_device *dev)
>  {
> -	return MAX_LAN743X_ETH_REGS * sizeof(u32);
> +	struct lan743x_adapter *adapter = netdev_priv(dev);
> +	u32 num_regs = MAX_LAN743X_ETH_COMMON_REGS;
> +
> +	if (adapter->is_sgmii_en)
> +		num_regs += MAX_LAN743X_ETH_SGMII_REGS;
> +
> +	return num_regs * sizeof(u32);
>  }
>  
>  static void lan743x_get_regs(struct net_device *dev,
>  			     struct ethtool_regs *regs, void *p)
>  {
> +	struct lan743x_adapter *adapter = netdev_priv(dev);
> +	int regs_len;
> +
> +	regs_len = lan743x_get_regs_len(dev);
> +	memset(p, 0, regs_len);
> +
>  	regs->version = LAN743X_ETH_REG_VERSION;
> +	regs->len = regs_len;
> +
> +	lan743x_common_regs(dev, p);
> +	p = (u32 *)p + MAX_LAN743X_ETH_COMMON_REGS;
>  
> -	lan743x_common_regs(dev, regs, p);
> +	if (adapter->is_sgmii_en) {
> +		lan743x_sgmii_regs(dev, p);
> +		p = (u32 *)p + MAX_LAN743X_ETH_SGMII_REGS;
> +	}

This seems O.K. for the moment, but how does it work when you add the
next set of optional registers? Say you want to add the PTP registers?

One idea might be to use the LAN743X_ETH_REG_VERSION as a
bitfield. Bit 0 indicates the common registers are present. Bit 1
indicates the SGMII registers are present. Bit 2 is for whatever next
set of optional registers you add, say PTP.

    Andrew
