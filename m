Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FD0C6EF683
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 16:34:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241427AbjDZOd6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 10:33:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241176AbjDZOd6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 10:33:58 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3587423E;
        Wed, 26 Apr 2023 07:33:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=5LP2i8y2xJFTwdbUQ5+4MPdVWFdvS8ZpwBegSvNH80w=; b=uETSTHfNla9N5IyIFrX7Bfxg1f
        rGLzCbzB//pGQJPJxiSprS7Axe6jBQFLc7FHA/LI+rOtjWoKZwGHyR8n5yzR638jHyP7fW7cU+aLu
        2kcOHLo4vgvJvzYn3PCcR12gIbXTd/M/Y5KxmhxUqtdcaGBPOVtaMpH6QyBLsNTrhLXc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1prgDS-00BHYH-DS; Wed, 26 Apr 2023 16:33:54 +0200
Date:   Wed, 26 Apr 2023 16:33:54 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Frank Sae <Frank.Sae@motor-comm.com>
Cc:     Samin Guo <samin.guo@starfivetech.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, Peter Geis <pgwipeout@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Yanhong Wang <yanhong.wang@starfivetech.com>
Subject: Re: [PATCH v1 2/2] net: phy: motorcomm: Add pad drive strength cfg
 support
Message-ID: <4c935728-ab18-4941-9621-c26e3b3799f7@lunn.ch>
References: <20230426063541.15378-1-samin.guo@starfivetech.com>
 <20230426063541.15378-3-samin.guo@starfivetech.com>
 <11f0641a-ef6c-eee8-79f3-45654ae006d5@motor-comm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11f0641a-ef6c-eee8-79f3-45654ae006d5@motor-comm.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > +	u32 val;
> >  
> >  	ret = ytphy_rgmii_clk_delay_config_with_lock(phydev);
> >  	if (ret < 0)
> > @@ -1518,6 +1524,32 @@ static int yt8531_config_init(struct phy_device *phydev)
> >  			return ret;
> >  	}
> >  
> > +	if (!of_property_read_u32(node, "rx-clk-driver-strength", &val)) {
> 
> Please check the val of "val", add the handle of default value.

You can assign val to 3, or better still some #define, before calling
of_property_read_u32(). If the property is not found, val will retain
that value, and you can then write it to the register.

But please do add range checks for when val is in DT. We don't want
anybody using 42. -EINVAL should be returned.

	Andrew
