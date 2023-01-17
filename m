Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 297A866DED4
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 14:30:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230282AbjAQNaa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 08:30:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229730AbjAQNa2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 08:30:28 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E822538EA5
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 05:30:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=1wIVZSVUgTUedV2LQo9/FHDRbS3j1hP9CCyFacP4Lu0=; b=mZQbWh0YsZcChCYJOyOVHzBOmN
        QV1tP2wkYK8wpRRzlXwWKJMTwxlRLSyR3Hn4PpnwpEhU5Jb9Lw/yGDwq63BG+UQFbGmuo80vOvC60
        Ny3PIdAfGTFx6mMFT794GGZYqTvGf858VSB/B2zTp4PWOorGQegTqPp9lx3t9k4JJAvQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pHm2d-002KAi-AQ; Tue, 17 Jan 2023 14:30:19 +0100
Date:   Tue, 17 Jan 2023 14:30:19 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Kevin Hilman <khilman@baylibre.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "open list:ARM/Amlogic Meson..." <linux-amlogic@lists.infradead.org>
Subject: Re: [PATCH net-next] net: phy: meson-gxl: support more G12A-internal
 PHY versions
Message-ID: <Y8ai6+oaaP0KwkAY@lunn.ch>
References: <d75ef7df-a645-7fdd-491a-f89f70dbea01@gmail.com>
 <Y8Qwk5H8Yd7qiN0j@lunn.ch>
 <03ea260e-f03c-d9d7-6f5f-ff72836f5739@gmail.com>
 <51abd8ca-8172-edfa-1c18-b1e48231f316@linaro.org>
 <6de25c61-c187-fb88-5bd7-477b1db1510e@gmail.com>
 <699f6ee109b3a72b2b377f42a78705f47d4a77b9.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <699f6ee109b3a72b2b377f42a78705f47d4a77b9.camel@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > The PHY compatible string in DT is the following in all cases:
> > compatible = "ethernet-phy-id0180.3301"

This form of compatible has two purposes.

1) You cannot read the PHY ID register during MDIO bus enumeration,
generally because you need to turn on GPIOs, clocks, regulators etc,
which the MDIO/PHY core does not know how to do.

2) The PHY has bad values in its ID registers, typically because the
manufactures messed up.

If you have a compatible like this, the ID registers are totally
ignored by Linux, and the ID is used to find the driver and tell the
driver exactly which of the multiple devices it supports it should
assume the device is.

So you should use this from of compatible with care. You can easily
end up thinking you have a different PHY to what you actually have,
which could then result in wrong erratas being applied etc, or even
the wrong driver being used.

    Andrew
