Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9AC6686BF5
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 17:42:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231569AbjBAQmG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 11:42:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbjBAQmF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 11:42:05 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BB6246AA;
        Wed,  1 Feb 2023 08:42:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=SgddTTKAGF4Pttul+G878Am4ZtBBoyVHLpFQBrA5TvI=; b=4uAr010FWqz5h8GkiMsnC/YeF9
        GKNm8kkHE/KzalFSu8IpBOj0vbMvoNWL3oXAvyhQlPyo2v5bLY487HnGMk7tNgNd4tn5BuuTY31uC
        13bkA8Fdg+4TPlyjEF88jxCXk/Oum7BB/pxA55X1Hm3XYlwQAQbLJLA9C86tjmHzqmlI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pNGBD-003oEr-D7; Wed, 01 Feb 2023 17:41:51 +0100
Date:   Wed, 1 Feb 2023 17:41:51 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Wei Fang <wei.fang@nxp.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Arun.Ramadoss@microchip.com, intel-wired-lan@lists.osuosl.org
Subject: Re: [PATCH net-next v4 08/23] net: phy: migrate phy_init_eee() to
 genphy_c45_eee_is_active()
Message-ID: <Y9qWT11Ckf0g+whv@lunn.ch>
References: <20230201145845.2312060-1-o.rempel@pengutronix.de>
 <20230201145845.2312060-9-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230201145845.2312060-9-o.rempel@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>  int phy_init_eee(struct phy_device *phydev, bool clk_stop_enable)
>  {
> +	int ret;
> +
>  	if (!phydev->drv)
>  		return -EIO;
>  
> -	/* According to 802.3az,the EEE is supported only in full duplex-mode.
> -	 */
> -	if (phydev->duplex == DUPLEX_FULL) {

This got me for a while, where did the duplex check go?

But you now compare the local advertised EEE and the link peer EEE.
Since it is impossible to advertise a half duplex mode, the result can
never contain a half duplex mode.

I've done the work now, but a comment about this in the commit message
would of been nice.

FYI: Thanks for converting all users of the old functions. I was not
expecting that.

	Andrew
