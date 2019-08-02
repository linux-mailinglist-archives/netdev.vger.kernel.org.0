Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C4507FF04
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 18:58:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732790AbfHBQ6C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 12:58:02 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:57448 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726300AbfHBQ6C (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Aug 2019 12:58:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=WKKkdvYsTKTKugW3bqZDf2rCHcrUocUQxCga4FLtUiA=; b=twtHpeOwg1wkJYLCGwCryLTXrg
        +926gA1gIR93MYBjUo1ROQJwNAi2wufif1fkVcAQwLkrNpVxkbZWiEXipnp7BGikO5yTGgDD/OvJC
        mjypuB15q+KCR+XvPSQlwSe70wH4gN6g/8lMG080mvVFY8wlWHXe+UnKCbNy0th2M1NE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1htasN-0002NL-Cs; Fri, 02 Aug 2019 18:57:55 +0200
Date:   Fri, 2 Aug 2019 18:57:55 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Matthias Kaehlcke <mka@chromium.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Douglas Anderson <dianders@chromium.org>
Subject: Re: [PATCH v4 1/4] dt-bindings: net: phy: Add subnode for LED
 configuration
Message-ID: <20190802165755.GM2099@lunn.ch>
References: <20190801190759.28201-1-mka@chromium.org>
 <20190801190759.28201-2-mka@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190801190759.28201-2-mka@chromium.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 01, 2019 at 12:07:56PM -0700, Matthias Kaehlcke wrote:
> The LED behavior of some Ethernet PHYs is configurable. Add an
> optional 'leds' subnode with a child node for each LED to be
> configured. The binding aims to be compatible with the common
> LED binding (see devicetree/bindings/leds/common.txt).
> 
> A LED can be configured to be 'on' when a link with a certain speed
> is active, or to blink on RX/TX activity. For the configuration to
> be effective it needs to be supported by the hardware and the
> corresponding PHY driver.
> 
> Suggested-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
> ---
> Changes in v4:
> - patch added to the series
> ---
>  .../devicetree/bindings/net/ethernet-phy.yaml | 47 +++++++++++++++++++
>  1 file changed, 47 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/ethernet-phy.yaml b/Documentation/devicetree/bindings/net/ethernet-phy.yaml
> index f70f18ff821f..81c5aacc89a5 100644
> --- a/Documentation/devicetree/bindings/net/ethernet-phy.yaml
> +++ b/Documentation/devicetree/bindings/net/ethernet-phy.yaml
> @@ -153,6 +153,38 @@ properties:
>        Delay after the reset was deasserted in microseconds. If
>        this property is missing the delay will be skipped.
>  
> +patternProperties:
> +  "^leds$":
> +    type: object
> +    description:
> +      Subnode with configuration of the PHY LEDs.
> +
> +    patternProperties:
> +      "^led@[0-9]+$":
> +        type: object
> +        description:
> +          Subnode with the configuration of a single PHY LED.
> +
> +    properties:
> +      reg:
> +        description:
> +          The ID number of the LED, typically corresponds to a hardware ID.
> +        $ref: "/schemas/types.yaml#/definitions/uint32"
> +
> +      linux,default-trigger:
> +        description:
> +          This parameter, if present, is a string specifying the trigger
> +          assigned to the LED. Supported triggers are:
> +            "phy_link_10m_active" - LED will be on when a 10Mb/s link is active
> +            "phy_link_100m_active" - LED will be on when a 100Mb/s link is active
> +            "phy_link_1g_active" - LED will be on when a 1Gb/s link is active
> +            "phy_link_10g_active" - LED will be on when a 10Gb/s link is active
> +            "phy_activity" - LED will blink when data is received or transmitted

Matthias

We should think a bit more about these names.

I can see in future needing 1G link, but it blinks off when there is
active traffic? So phy_link_1g_active could be confusing, and very similar to
phy_link_1g_activity? So maybe 

> +            "phy_link_10m" - LED will be solid on when a 10Mb/s link is active
> +            "phy_link_100m" - LED will be solid on when a 100Mb/s link is active
> +            "phy_link_1g" - LED will be solid on when a 1Gb/s link is active

etc.

And then in the future we can have

               "phy_link_1g_activity' - LED will be on when 1Gbp/s
                                        link is active and blink off
                                        with activity.

What other use cases do we have? I don't want to support everything,
but we should be able to represent the most common modes without the
names getting too confusing.

      Andrew
