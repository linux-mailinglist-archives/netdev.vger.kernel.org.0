Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84F5459AFC6
	for <lists+netdev@lfdr.de>; Sat, 20 Aug 2022 20:52:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231268AbiHTSsw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Aug 2022 14:48:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229854AbiHTSst (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Aug 2022 14:48:49 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E977C46220;
        Sat, 20 Aug 2022 11:48:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Fap6JIYMdWXN0zZpRYLSvtD5yGfzaSQ75IJSrYc0Zzs=; b=49j5uThbtvoOljoIvu6795+v0G
        CzSrZg5zpjOpInLpKXf4meJciv0KYDepJXg8M9JZmjjZdvaffsi6YqYairWD3eCf1ixihM/ex2jbv
        tzNGyxwqUXjmRIt4fYKBRXgwWaPAqzMECcATf9nbmhvzCvjOIjgmR8Ll9ukrpAsnd9f4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oPTWM-00E3pD-1M; Sat, 20 Aug 2022 20:48:34 +0200
Date:   Sat, 20 Aug 2022 20:48:34 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        David Jander <david@protonic.nl>
Subject: Re: [PATCH net-next v1 7/7] ethtool: add interface to interact with
 Ethernet Power Equipment
Message-ID: <YwEsgpVPNtmvtYni@lunn.ch>
References: <20220819120109.3857571-1-o.rempel@pengutronix.de>
 <20220819120109.3857571-8-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220819120109.3857571-8-o.rempel@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int pse_get_pse_attributs(struct net_device *dev,
> +				 struct pse_reply_data *data)
> +{
> +	struct phy_device *phydev = dev->phydev;
> +	int ret;
> +
> +	if (!phydev)
> +		return -EOPNOTSUPP;
> +
> +	mutex_lock(&phydev->lock);
> +	if (!phydev->psec) {
> +		ret = -EOPNOTSUPP;
> +		goto error_unlock;
> +	}
> +
> +	ret = pse_podl_get_admin_sate(phydev->psec);
> +	if (ret < 0)
> +		goto error_unlock;

The locking is triggering all sorts of questions in my mind... I don't
have the answers yet, so consider this more a discussion.

You need somewhere to place the psec. Since we are talking power over
copper lines, there will be some sort of PHY, so phydev->psec seems
reasonable. However, there is a general trend of moving all DSA
Ethernet switches to phylink, which is going to make this a bit
tricker to actually get to the phydev object.

But using phydev->lock? Humm. At least in the PoE world, there seems
to be lots of I2C or SPI controllers. Why hold the phydev lock when
performing an I2C transaction? You have a generic linux regulator
driver. How would you see a generic C45.2.9 driver? If it calls in the
PHY driver, the lock is already held, and we have to be careful to not
deadlock.

I'm more thinking along the lines of psec should have a lock of its
own.  pse_podl_get_admin_state(), pse_podl_get_pw_d_status() etc
should take that mutex before calling to the actual driver.

For a PHY which actually supports C45.2.9, i hope that the phylib core
looks at the phy driver structure, sees that some pse_podl ops are
implemented, and instantiates and registers a psec object. The phylib
core provides wrappers, which take the phylib lock before calling into
the driver. And if the PHY strictly follows C45.2.9, the calls are
actually into phylib helpers. Otherwise the PHY driver can do its own
implementation.

     Andrew
