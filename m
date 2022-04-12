Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FC484FE23E
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 15:21:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356038AbiDLNWY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 09:22:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355531AbiDLNWR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 09:22:17 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 697E150B34;
        Tue, 12 Apr 2022 06:10:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=WuiFiHeMvZDkq8Q1J+rs3YTSaLxbzfLA/uH6C46aS9A=; b=SYbDldAR1Y7f5n17R+WO4UvgWZ
        4t+btoG7FyDmhtSvTemy98cGzaqJcwMXRlrejM7/9s81cWnn2FznXZmZLA71pOGPbtwKsuZYAosJX
        oR87WRwmH+SdZYYSasxIZeM/MrV9xJ/y3zKaGzEi+wWUcNn16X1saCFl1ZfpX6s/9VBY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1neGI0-00FSJU-IF; Tue, 12 Apr 2022 15:10:36 +0200
Date:   Tue, 12 Apr 2022 15:10:36 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Grygorii Strashko <grygorii.strashko@ti.com>
Cc:     Puranjay Mohan <p-mohan@ti.com>, linux-kernel@vger.kernel.org,
        bjorn.andersson@linaro.org, mathieu.poirier@linaro.org,
        krzysztof.kozlowski+dt@linaro.org,
        linux-remoteproc@vger.kernel.org, devicetree@vger.kernel.org,
        nm@ti.com, ssantosh@kernel.org, s-anna@ti.com,
        linux-arm-kernel@lists.infradead.org, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org, vigneshr@ti.com,
        kishon@ti.com, Roger Quadros <rogerq@kernel.org>
Subject: Re: [RFC 13/13] net: ti: icssg-prueth: Add ICSSG ethernet driver
Message-ID: <YlV6TKTl5uQGZrQX@lunn.ch>
References: <20220406094358.7895-1-p-mohan@ti.com>
 <20220406094358.7895-14-p-mohan@ti.com>
 <Yk3d/cC36fhNmfY2@lunn.ch>
 <468d4d9b-44b4-2894-2a75-4caab1e72147@ti.com>
 <f3ae48a8-7177-3a92-bdfd-3b243a5527c1@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f3ae48a8-7177-3a92-bdfd-3b243a5527c1@ti.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > > +	if (phy_if == PHY_INTERFACE_MODE_RGMII_ID ||
> > > > +	    phy_if == PHY_INTERFACE_MODE_RGMII_TXID)
> > > > +		rgmii_tx_id |= ICSSG_CTRL_RGMII_ID_MODE;
> > > > +
> > > > +	regmap_update_bits(ctrl_mmr, icssgctrl_reg, ICSSG_CTRL_RGMII_ID_MODE, rgmii_tx_id);
> > > > +
> > > > +	return 0;
> > > > +}
> > > > 
> > > 
> > > O.K, so this does not do what i initially thought it was doing. I was
> > > thinking it was to fine tune the delay, ti,syscon-rgmii-delay would be
> > > a small pico second value to allow the 2ns delay to be tuned to the
> > > board.
> > > 
> > > But now i think this is actually inserting the full 2ns delay?
> > > 
> > > The problem is, you also pass phy_if to of_phy_connect() so the PHY
> > > will also insert the delay if requested. So you end up with double
> > > delays for rgmii_id and rgmii_txid.
> 
> It's misunderstanding here. The bit field name in TRM is RGMII0_ID_MODE
> and meaning:
> 0h - Internal transmit delay is enabled
> 1h - Internal transmit delay is not enabled.
> 
> So here internal delay will be disabled for RGMII_ID/RGMII_TXID.

And enabled for the others?

Why don't you always disable the delays and let the PHY do it? That is
what pretty much every other MAC/PHY combination does.

    Andrew
