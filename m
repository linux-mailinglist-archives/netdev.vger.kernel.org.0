Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 479C94E5946
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 20:40:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344326AbiCWTl3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 15:41:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240358AbiCWTl2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 15:41:28 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B9345749C;
        Wed, 23 Mar 2022 12:39:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=EXspul3bxV1ROddHWUH5dYvmEAgYPmadkfO6M4GEFq4=; b=dVeofnZ+TOMTdO2uLMs5Upulco
        bGum5lnQdTfrlAcA64OHzpfybLu6QbuJzHJk+s/exqbrOBOwCz6Nex/JkRHywxZ8qzSVRK7KEdHs8
        HphUmRaKIBVbZRBdIx4Yv5mQCeRR248aQTGrMO5OsL+oRCs8yqtPDKZbx6krQOUZYEgU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nX6pg-00CKi9-2T; Wed, 23 Mar 2022 20:39:48 +0100
Date:   Wed, 23 Mar 2022 20:39:48 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Walle <michael@walle.cc>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Xu Liang <lxu@maxlinear.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC net-next 2/5] net: phy: support indirect c45 access
 in get_phy_c45_ids()
Message-ID: <Yjt3hHWt0mW6er8/@lunn.ch>
References: <20220323183419.2278676-1-michael@walle.cc>
 <20220323183419.2278676-3-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220323183419.2278676-3-michael@walle.cc>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int mdiobus_probe_mmd_read(struct mii_bus *bus, int prtad, int devad,
> +				  u16 regnum)
> +{
> +	int ret;
> +
> +	/* For backwards compatibility, treat MDIOBUS_NO_CAP as c45 capable */
> +	if (bus->probe_capabilities == MDIOBUS_NO_CAP ||
> +	    bus->probe_capabilities >= MDIOBUS_C45)

Maybe we should do the work and mark up those that are C45 capable. At
a quick count, see 16 of them.

> +		return mdiobus_c45_read(bus, prtad, devad, regnum);
> +
> +	mutex_lock(&bus->mdio_lock);
> +
> +	/* Write the desired MMD Devad */
> +	ret = __mdiobus_write(bus, prtad, MII_MMD_CTRL, devad);
> +	if (ret)
> +		goto out;
> +
> +	/* Write the desired MMD register address */
> +	ret = __mdiobus_write(bus, prtad, MII_MMD_DATA, regnum);
> +	if (ret)
> +		goto out;
> +
> +	/* Select the Function : DATA with no post increment */
> +	ret = __mdiobus_write(bus, prtad, MII_MMD_CTRL,
> +			      devad | MII_MMD_CTRL_NOINCR);
> +	if (ret)
> +		goto out;

Make mmd_phy_indirect() usable, rather then repeat it.

     Andrew
