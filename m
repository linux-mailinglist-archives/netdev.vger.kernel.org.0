Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8DD74F719A
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 03:42:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239676AbiDGBgI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 21:36:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238942AbiDGBeG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 21:34:06 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14CFB146B50
        for <netdev@vger.kernel.org>; Wed,  6 Apr 2022 18:31:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=AutGOXX2loO5AnASfTQWIYfuQnxKSlVczsaYAFdkkzE=; b=x+Zc9MobKkNw/umcTRFPzwdw7h
        anm3bSE2UdsbZgVP9rmUQO6RSNlCfzdrwbrVAe1YQQK8aPs8VackOsIZQxnlJ1DswJ4E83Dwk4Oc3
        nm7IhXQjuYN8BUTt1y8VIlqv56BP1ZVqYaA1GVwW1/plFHKvr2csPYg/3AcSNSmGtiMo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ncH06-00EXv6-3w; Thu, 07 Apr 2022 03:31:54 +0200
Date:   Thu, 7 Apr 2022 03:31:54 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek Vasut <marex@denx.de>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH] net: phy: micrel: ksz9031/ksz9131: add cabletest support
Message-ID: <Yk4/Cm3uuBF7vplL@lunn.ch>
References: <20220406185020.301197-1-marex@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220406185020.301197-1-marex@denx.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int ksz9x31_cable_test_start(struct phy_device *phydev)
> +{
> +	int ret;
> +
> +	/* KSZ9131RNX, DS00002841B-page 38, 4.14 LinkMD (R) Cable Diagnostic
> +	 * Prior to running the cable diagnostics, Auto-negotiation should
> +	 * be disabled, full duplex set and the link speed set to 1000Mbps
> +	 * via the Basic Control Register.
> +	 */
> +	ret = phy_modify(phydev, MII_BMCR,
> +			 BMCR_SPEED1000 | BMCR_FULLDPLX |
> +			 BMCR_ANENABLE | BMCR_SPEED100,
> +			 BMCR_SPEED1000 | BMCR_FULLDPLX);
> +	if (ret)
> +		return ret;
> +
> +	/* KSZ9131RNX, DS00002841B-page 38, 4.14 LinkMD (R) Cable Diagnostic
> +	 * The Master-Slave configuration should be set to Slave by writing
> +	 * a value of 0x1000 to the Auto-Negotiation Master Slave Control
> +	 * Register.
> +	 */
> +	return phy_modify(phydev, MII_CTRL1000,
> +			  CTL1000_ENABLE_MASTER | CTL1000_AS_MASTER,
> +			  CTL1000_ENABLE_MASTER);

Did you check if this gets undone when the cable test is
completed? The phy state machine will call phy_init_hw(), but i've no
idea if that is sufficient to reset the master selection.

Otherwise, this looks good.

	   Andrew
