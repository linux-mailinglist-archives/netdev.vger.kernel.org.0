Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F5A54D75E9
	for <lists+netdev@lfdr.de>; Sun, 13 Mar 2022 15:44:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234647AbiCMOpT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Mar 2022 10:45:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233811AbiCMOpT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Mar 2022 10:45:19 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B04853ED0F;
        Sun, 13 Mar 2022 07:44:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=IE4hwCJ4VUC9IKmRcRVWFekq0CQCWakqfk3Q5RvuQ8s=; b=fZVPK8NrD6HPhKeo+T2dQ3hlef
        c4kR+fMh1EJDEMi0MnCezl3NamqVIXFHhv/FGtw+ZbIr91HpV/sXTDblDlhwisrn8lBqzcF28oSDP
        c71NvmrZ59TtUMFM9ZXJ7895W3ojVZG126pgXnl56MTlj0FI9JpW77AeRk/+1KrfAUVA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nTPRw-00Ad7Q-AR; Sun, 13 Mar 2022 15:44:00 +0100
Date:   Sun, 13 Mar 2022 15:44:00 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Walle <michael@walle.cc>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 3/3] et: mdio: mscc-miim: add lan966x internal
 phy reset support
Message-ID: <Yi4DMGnpiOswNiXp@lunn.ch>
References: <20220313002153.11280-1-michael@walle.cc>
 <20220313002153.11280-4-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220313002153.11280-4-michael@walle.cc>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>  /* When high resolution timers aren't built-in: we can't use usleep_range() as
> @@ -157,27 +166,29 @@ static int mscc_miim_write(struct mii_bus *bus, int mii_id,
>  static int mscc_miim_reset(struct mii_bus *bus)
>  {
>  	struct mscc_miim_dev *miim = bus->priv;
> -	int offset = miim->phy_reset_offset;
> -	int mask = PHY_CFG_PHY_ENA | PHY_CFG_PHY_COMMON_RESET |
> -		   PHY_CFG_PHY_RESET;
> +	unsigned int offset, mask;
>  	int ret;
>  
> -	if (miim->phy_regs) {
> -		ret = regmap_write(miim->phy_regs, offset, 0);
> -		if (ret < 0) {
> -			WARN_ONCE(1, "mscc reset set error %d\n", ret);
> -			return ret;
> -		}
> +	if (!miim->phy_regs || !miim->info)
> +		return 0;

I would put the check for miim->info in the probe. Not checking the
return value from *_get_match_data() is one of the things the bots
reports and we receive patches for. You have the check, but it is
hidden away, and i doubt the bot nor the bot handlers are clever
enough to find it.

       Andrew
