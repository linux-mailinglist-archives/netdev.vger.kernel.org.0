Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F6D465ECCE
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 14:19:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232427AbjAENSU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 08:18:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234385AbjAENRo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 08:17:44 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46A565AC64;
        Thu,  5 Jan 2023 05:17:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=KMLqgdiGpsgveS+d9Haf3IhQ0Gi2pqpU6Hr1FOq0nFo=; b=0q
        PZfQX1Abg7bndIQjbrZuL1JGANzX3z+0NgHP3Du+YyiFaKAG7jolPcN9YeONXB0iru+VdVTybuMLv
        YFodXcwA9i0o7JRMXg/X0He/uNZtj25HqnkaO48Wi6mW00ye9xMwt+7h9lWnku5QE5sTg3Yr9abVi
        CsZKfiGsK07zfxI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pDQ7W-001DMp-6K; Thu, 05 Jan 2023 14:17:22 +0100
Date:   Thu, 5 Jan 2023 14:17:22 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Frank <Frank.Sae@motor-comm.com>
Cc:     Peter Geis <pgwipeout@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        xiaogang.fan@motor-comm.com, fei.zhang@motor-comm.com,
        hua.sun@motor-comm.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH net-next v1 1/3] dt-bindings: net: Add Motorcomm yt8xxx
 ethernet phy Driver bindings
Message-ID: <Y7bN4vJXMi66FF6v@lunn.ch>
References: <20230105073024.8390-1-Frank.Sae@motor-comm.com>
 <20230105073024.8390-2-Frank.Sae@motor-comm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230105073024.8390-2-Frank.Sae@motor-comm.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +  motorcomm,rx-delay-basic:
> +    description: |
> +      Tristate, setup the basic RGMII RX Clock delay of PHY.
> +      This basic delay is fixed at 2ns (1000Mbps) or 8ns (100Mbps、10Mbps).
> +      This basic delay usually auto set by hardware according to the voltage
> +      of RXD0 pin (low = 0, turn off;   high = 1, turn on).
> +      If not exist, this delay is controlled by hardware.
> +      0: turn off;   1: turn on.
> +    $ref: /schemas/types.yaml#/definitions/uint32
> +    enum: [0, 1]

Why is this needed? When the MAC driver connects to the PHY, it passes
phy-mode. For RGMII, this is one of:

linux/phy.h:	PHY_INTERFACE_MODE_RGMII,
linux/phy.h:	PHY_INTERFACE_MODE_RGMII_ID,
linux/phy.h:	PHY_INTERFACE_MODE_RGMII_RXID,
linux/phy.h:	PHY_INTERFACE_MODE_RGMII_TXID,

This tells you if you need to add a delay for the RX clock line, the
TX clock line, or both. That is all you need to know for basic RGMII
delays.

> +  motorcomm,rx-delay-additional-ps:

ethernet-phy.yaml defines rx-internal-delay-ps. Please use that.

> +    description: |
> +      Setup the additional RGMII RX Clock delay of PHY defined in pico seconds.
> +      RGMII RX Clock Delay = rx-delay-basic + rx-delay-additional-ps.
> +    enum:
> +      - 0
> +      - 150
> +      - 300
> +      - 450
> +      - 600
> +      - 750
> +      - 900
> +      - 1050
> +      - 1200
> +      - 1350
> +      - 1500
> +      - 1650
> +      - 1800
> +      - 1950
> +      - 2100
> +      - 2250

Is this property mandatory? If not, please document what value is used
if it is not present.

> +
> +  motorcomm,tx-delay-ge-ps:

tx-internal-delay-ps

And please define the default.

> +  motorcomm,tx-delay-fe-ps:

So you can only set the TX delay? What is RX delay set to? Same as 1G?
I would suggest you call this motorcomm,tx-internal-delay-fe-ps, so
that it is similar to the standard tx-internal-delay-ps.

> +    description: |
> +      Setup PHY's RGMII TX Clock delay  defined in pico seconds when the speed
> +      is 100Mbps or 10Mbps.
> +    enum:
> +      - 0
> +      - 150
> +      - 300
> +      - 450
> +      - 600
> +      - 750
> +      - 900
> +      - 1050
> +      - 1200
> +      - 1350
> +      - 1500
> +      - 1650
> +      - 1800
> +      - 1950
> +      - 2100
> +      - 2250
> +
> +  motorcomm,keep-pll-enabled:
> +    description: |
> +      If set, keep the PLL enabled even if there is no link. Useful if you
> +      want to use the clock output without an ethernet link.
> +    type: boolean
> +
> +  motorcomm,auto-sleep-disabled:
> +    description: |
> +      If set, PHY will not enter sleep mode and close AFE after unplug cable
> +      for a timer.
> +    type: boolean

These two i can see being useful. But everything afterwards seems like
just copy/paste from vendor SDK for things which the hardware can do,
but probably nobody ever uses. Do you have a board using any of the
following properties?

> +
> +  motorcomm,tx-clk-adj-enabled:
> +    description: |
> +      Useful if you want to use tx-clk-xxxx-inverted to adj the delay of tx clk.
> +    type: boolean
> +
> +  motorcomm,tx-clk-10-inverted:
> +    description: |
> +      Use original or inverted RGMII Transmit PHY Clock to drive the RGMII
> +      Transmit PHY Clock delay train configuration when speed is 10Mbps.
> +    type: boolean
> +
> +  motorcomm,tx-clk-100-inverted:
> +    description: |
> +      Use original or inverted RGMII Transmit PHY Clock to drive the RGMII
> +      Transmit PHY Clock delay train configuration when speed is 100Mbps.
> +    type: boolean
> +
> +  motorcomm,tx-clk-1000-inverted:
> +    description: |
> +      Use original or inverted RGMII Transmit PHY Clock to drive the RGMII
> +      Transmit PHY Clock delay train configuration when speed is 1000Mbps.
> +    type: boolean
> +
> +  motorcomm,sds-tx-amplitude:
> +    description: |
> +      Setup the tx driver amplitude control of SerDes. Higher amplitude is
> +      helpful for long distance.
> +      0: low;   1: middle;   2: high.
> +    $ref: /schemas/types.yaml#/definitions/uint32
> +    enum: [0, 1, 2]
> +
> +unevaluatedProperties: false
> +
> +examples:
> +  - |
> +    ethernet {
> +        #address-cells = <1>;
> +        #size-cells = <0>;
> +        ethernet-phy@5 {
> +            reg = <5>;

PHYs are on MDIO busses, so i would expect to see an MDIO bus here,
not Ethernet.

    Andrew
