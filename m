Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FDB34E5990
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 21:07:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240517AbiCWUJA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 16:09:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239934AbiCWUI7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 16:08:59 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27F7385659;
        Wed, 23 Mar 2022 13:07:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=pyn2uk6hP/JZdZoC6sjuiFzoIRCFMcZz+lk7gUqAIQ8=; b=y1S0yMfayT0AsXhV77kRxe2Mjw
        wae+OJHLzDoysrWCDvY5BE6oJoECoZfmYZhY0B17FjBQ1iC31lUKuSqO9zEwR1mUA/DpHGqOgj1eQ
        +75SN+DgjGcmeXFctJwJncr7lI2bLnnvu8exZi4rgymCIisWX5pD5MNp96Ic8mRAS2Pk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nX7GI-00CKrc-Si; Wed, 23 Mar 2022 21:07:18 +0100
Date:   Wed, 23 Mar 2022 21:07:18 +0100
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
Subject: Re: [PATCH RFC net-next 4/5] net: phy: introduce is_c45_over_c22 flag
Message-ID: <Yjt99k57mM5PQ8bT@lunn.ch>
References: <20220323183419.2278676-1-michael@walle.cc>
 <20220323183419.2278676-5-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220323183419.2278676-5-michael@walle.cc>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 23, 2022 at 07:34:18PM +0100, Michael Walle wrote:
> The GPY215 driver supports indirect accesses to c45 over the c22
> registers. In its probe function phy_get_c45_ids() is called and the
> author descibed their use case as follows:
> 
>   The problem comes from condition "phydev->c45_ids.mmds_present &
>   MDIO_DEVS_AN".
> 
>   Our product supports both C22 and C45.
> 
>   In the real system, we found C22 was used by customers (with indirect
>   access to C45 registers when necessary).
> 
> So it is pretty clear that the intention was to have a method to use the
> c45 features over a c22-only MDIO bus. The purpose of calling
> phy_get_c45_ids() is to populate the .c45_ids for a PHY which wasn't
> probed as a c45 one. Thus, first rename the phy_get_c45_ids() function
> to reflect its actual meaning and second, add a new flag which indicates
> that this is actually a c45 PHY but behind a c22 bus. The latter is
> important for phylink because phylink will treat c45 in a special way by
> checking the .is_c45 property. But in our case this isn't set.

Thinking out loud...

1) We have a C22 only bus. Easy, C45 over C22 should be used.

2) We have a C45 only bus. Easy, C45 should be used, and it will of
   probed that way.

3) We have a C22 and C45 bus, but MDIOBUS_NO_CAP. It will probe C22,
   but ideally we want to swap to C45.

4) We have a C22 and C45 bus, MDIOBUS_C22_C45. It will probe C22, but
   ideally we want to swap to C45.

> @@ -99,7 +99,7 @@ static int gpy_probe(struct phy_device *phydev)
>  	int ret;
>  
>  	if (!phydev->is_c45) {
> -		ret = phy_get_c45_ids(phydev);
> +		ret = phy_get_c45_ids_by_c22(phydev);
>  		if (ret < 0)
>  			return ret;
>  	}

If we are inside the if, we know we probed C22. We have to achieve two
things:

1) Get the c45 ids,
2) Figure out if C45 works, or if C45 over C22 is needed.

I don't see how we are getting this second bit of information, if we
are explicitly using c45 over c22.

This _by_c22 is also making me think of the previous patch, where we
look at the bus capabilities. We are explicitly saying here was want
c45 over c22, and the PHY driver should know the PHY is capable of
it. So we don't need to look at the capabilities, just do it.

     Andrew
