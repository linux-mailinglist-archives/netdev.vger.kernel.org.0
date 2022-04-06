Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE4854F62E3
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 17:18:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235785AbiDFPSe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 11:18:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236333AbiDFPR7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 11:17:59 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC67A5252F1;
        Wed,  6 Apr 2022 05:18:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=HY9AyFTTSvyl0mlHOq1Vq0LKi+bYjw8bBCj2u/ZVLyk=; b=aDF2DGovnriLp72Za6zAVUGbsL
        fhWT/9D+P1OKvm4m5O31hA6qWT6uPkpoRITU9hBGXBldGdHMmstMualOautB7X5SsmTO6CUuCExpc
        30dA0WI/95RtqLgmheb/LNqrUaSikCWIlvAWMXi6uQUqIkNt/+PbqimmDrrzeV8ZJn6E=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nc4bN-00ERSk-HN; Wed, 06 Apr 2022 14:17:33 +0200
Date:   Wed, 6 Apr 2022 14:17:33 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Potin Lai <potin.lai@quantatw.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Joel Stanley <joel@jms.id.au>,
        Andrew Jeffery <andrew@aj.id.au>,
        Patrick Williams <patrick@stwcx.xyz>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-aspeed@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/3] net: mdio: aspeed: Introduce read write function
 for c22 and c45
Message-ID: <Yk2E3X7MaJhWi32O@lunn.ch>
References: <20220406012002.15128-1-potin.lai@quantatw.com>
 <20220406012002.15128-3-potin.lai@quantatw.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220406012002.15128-3-potin.lai@quantatw.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int aspeed_mdio_read(struct mii_bus *bus, int addr, int regnum)
> +{
> +	dev_dbg(&bus->dev, "%s: addr: %d, regnum: %d\n", __func__, addr,
> +		regnum);
> +
> +	if (regnum & MII_ADDR_C45)
> +		return aspeed_mdio_read_c45(bus, addr, regnum);
> +
> +	return aspeed_mdio_read_c22(bus, addr, regnum);
> +}
> +
>  static int aspeed_mdio_write(struct mii_bus *bus, int addr, int regnum, u16 val)
>  {
>  	dev_dbg(&bus->dev, "%s: addr: %d, regnum: %d, val: 0x%x\n",
>  		__func__, addr, regnum, val);
>  
> -	/* Just clause 22 for the moment */
>  	if (regnum & MII_ADDR_C45)
> -		return -EOPNOTSUPP;
> +		return aspeed_mdio_write_c45(bus, addr, regnum, val);
>  
> -	return aspeed_mdio_op(bus, ASPEED_MDIO_CTRL_ST_C22, MDIO_C22_OP_WRITE,
> -			      addr, regnum, val);
> +	return aspeed_mdio_write_c22(bus, addr, regnum, val);
>  }

Hi Portin

Nice structure. This will helper with future cleanup where C22 and C45
will be completely separated, and the c45 variants will be directly
passed dev_ad and reg, rather than have to extract them from regnum.

A few process issues.

Please read the netdev FAQ. The subject list should indicate the tree,
and there should be an patch 0/3 which explains the big picture of
what the patchset does. 0/3 will then be used for the merge commit.

     Andrew
