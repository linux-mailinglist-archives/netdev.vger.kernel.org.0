Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D449663C734
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 19:32:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235964AbiK2ScJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 13:32:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235940AbiK2ScI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 13:32:08 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66C93654C1;
        Tue, 29 Nov 2022 10:32:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=wIKgYoD0U9V/FJ0sV3et6MEEkcpyezkYMDQv2JE1xug=; b=QEtv03LPOokn2byHbhnSg53HbY
        jTltuRc+dW47YOXRIu3rvks9tzGAyN+CjLvauNziwoYD6sEM+WMhsvjIV3DCdQddyvdQIk7h/LWFz
        zhUhSAdRizMqxiSK7l3mPkf5FnxJnjQus7VCsy3JX/80XH5UCML0fHKcCDMRuHeMGGDs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1p05O7-003tzW-NM; Tue, 29 Nov 2022 19:31:23 +0100
Date:   Tue, 29 Nov 2022 19:31:23 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Chukun Pan <amadeus@jmu.edu.cn>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Wu <david.wu@rock-chips.com>,
        Rob Herring <robh+dt@kernel.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/2] ethernet: stmicro: stmmac: Add SGMII/QSGMII support
 for RK3568
Message-ID: <Y4ZP+0koq0xIm4H9@lunn.ch>
References: <20221129072714.22880-1-amadeus@jmu.edu.cn>
 <20221129072714.22880-2-amadeus@jmu.edu.cn>
 <e4676089-7ce2-e123-4e2a-a7d8835e9118@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e4676089-7ce2-e123-4e2a-a7d8835e9118@linaro.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > -static int phy_power_on(struct rk_priv_data *bsp_priv, bool enable)
> > +static int rk_gmac_phy_power_on(struct rk_priv_data *bsp_priv, bool enable)
> >  {
> >  	struct regulator *ldo = bsp_priv->regulator;
> >  	int ret;
> > @@ -1728,6 +1909,18 @@ static struct rk_priv_data *rk_gmac_setup(struct platform_device *pdev,
> >  							"rockchip,grf");
> >  	bsp_priv->php_grf = syscon_regmap_lookup_by_phandle(dev->of_node,
> >  							    "rockchip,php-grf");
> > +	bsp_priv->xpcs = syscon_regmap_lookup_by_phandle(dev->of_node,
> > +							 "rockchip,xpcs");
> > +	if (!IS_ERR(bsp_priv->xpcs)) {
> > +		struct phy *comphy;
> > +
> > +		comphy = devm_of_phy_get(&pdev->dev, dev->of_node, NULL);
> 
> So instead of having PHY driver, you added a syscon and implemented PHY
> driver here. No. Make a proper PHY driver.

I'm also thinking there should be a proper pcs driver in drivers/net/pcs.

    Andrew
