Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5349D5A38DD
	for <lists+netdev@lfdr.de>; Sat, 27 Aug 2022 18:46:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233773AbiH0Qqn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Aug 2022 12:46:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229905AbiH0Qql (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Aug 2022 12:46:41 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44D634E613;
        Sat, 27 Aug 2022 09:46:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=s5TxmRNgoy9ai70H1gzGSV/jupaqV7UD+lcNcZxjcZ4=; b=4VlQwx1hjv7E/Mo+d6tDuSjyUv
        bQAWvrKZzYIqsyDCUFXqlYCJNf7lUg4fie4sA+j+9oXcNzV3jz1E7/s16LCeYTLwJvBqELUlaEPOO
        D7OWEpNm0rmShtwFYu41kTt3cPCIdWUa9xBRk4Of2UM9EgO/okIDfAUI73b7Y1J01nOE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oRyx3-00En06-Ry; Sat, 27 Aug 2022 18:46:29 +0200
Date:   Sat, 27 Aug 2022 18:46:29 +0200
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
        David Jander <david@protonic.nl>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Robert Marko <robert.marko@sartura.hr>
Subject: Re: [PATCH net-next v3 5/7] net: mdiobus: search for PSE nodes by
 parsing PHY nodes.
Message-ID: <YwpKZe3vAC+YPC52@lunn.ch>
References: <20220827051033.3903585-1-o.rempel@pengutronix.de>
 <20220827051033.3903585-6-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220827051033.3903585-6-o.rempel@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> @@ -26,6 +26,7 @@
>  #include <linux/netdevice.h>
>  #include <linux/phy.h>
>  #include <linux/phy_led_triggers.h>
> +#include <linux/pse-pd/pse.h>
>  #include <linux/property.h>
>  #include <linux/sfp.h>
>  #include <linux/skbuff.h>
> @@ -988,6 +989,7 @@ EXPORT_SYMBOL(phy_device_register);
>   */
>  void phy_device_remove(struct phy_device *phydev)
>  {
> +	pse_control_put(phydev->psec);
>  	unregister_mii_timestamper(phydev->mii_ts);

Just a nit-pick: I try to do remove in the opposite order to register,
just in case there are any inter-dependencies. It seems very unlikely
that the time stamper would depend on the psa, but the order performed
in register would allow it.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
