Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A57827FE8
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 16:38:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730905AbfEWOh6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 10:37:58 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45089 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730782AbfEWOh6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 May 2019 10:37:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ENx3kqedT/0klsMuf6qE0zDvG+kSozHAtQW6A5pcGGc=; b=OmcCPX/Rl/CibSt6QsRQi2K4ka
        vK9N7FzgvEl0MjXlIi8SxTA/wP98YUhM3sdDE7aDmBlBJCxTNb8xfvVfZxah2l4adFwurpZbEGYJA
        wRA0EfIRapEFD1q83khflFZL24g1GHkeji54fcjg6IHJVes/5mLsE2K/ZnH9bu+lf0Cg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hToqm-0005Z2-EC; Thu, 23 May 2019 16:37:44 +0200
Date:   Thu, 23 May 2019 16:37:44 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Maxime Ripard <maxime.ripard@bootlin.com>
Cc:     Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Chen-Yu Tsai <wens@csie.org>, devicetree@vger.kernel.org,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Antoine =?iso-8859-1?Q?T=E9nart?= <antoine.tenart@bootlin.com>,
        netdev@vger.kernel.org,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/8] dt-bindings: net: Add a YAML schemas for the generic
 PHY options
Message-ID: <20190523143744.GB19369@lunn.ch>
References: <74d98cc3c744d53710c841381efd41cf5f15e656.1558605170.git-series.maxime.ripard@bootlin.com>
 <aa5ec90854429c2d9e2c565604243e1b10cfd94b.1558605170.git-series.maxime.ripard@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aa5ec90854429c2d9e2c565604243e1b10cfd94b.1558605170.git-series.maxime.ripard@bootlin.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 23, 2019 at 11:56:45AM +0200, Maxime Ripard wrote:
> The networking PHYs have a number of available device tree properties that
> can be used in their device tree node. Add a YAML schemas for those.
> 
> Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
> ---
>  Documentation/devicetree/bindings/net/ethernet-phy.yaml | 148 +++++++++-
>  Documentation/devicetree/bindings/net/phy.txt           |  80 +-----
>  2 files changed, 149 insertions(+), 79 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/net/ethernet-phy.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/ethernet-phy.yaml b/Documentation/devicetree/bindings/net/ethernet-phy.yaml
> new file mode 100644
> index 000000000000..eb79ee6db977
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/ethernet-phy.yaml
> @@ -0,0 +1,148 @@
> +# SPDX-License-Identifier: GPL-2.0
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/ethernet-phy.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Ethernet PHY Generic Binding
> +
> +maintainers:
> +  - David S. Miller <davem@davemloft.net>
> +
> +properties:
> +  $nodename:
> +    pattern: "^ethernet-phy(@[a-f0-9])?$"
> +
> +  compatible:
> +    oneOf:

I don't know the language. It is valid to have both
ethernet-phy-ieee802.3-c45 and
ethernet-phy-id[a-f0-9]{4}\\.[a-f0-9]{4}$".  Does this oneOf prevent
multiple compatible strings?

Also, the general case is no compatible at all.

> +      - const: ethernet-phy-ieee802.3-c22
> +        description: PHYs that implement IEEE802.3 clause 22
> +      - const: ethernet-phy-ieee802.3-c45
> +        description: PHYs that implement IEEE802.3 clause 45
> +      - pattern: "^ethernet-phy-id[a-f0-9]{4}\\.[a-f0-9]{4}$"
> +        description:
> +          The first group of digits is the 16 bit Phy Identifier 1
> +          register, this is the chip vendor OUI bits 3:18. The
> +          second group of digits is the Phy Identifier 2 register,
> +          this is the chip vendor OUI bits 19:24, followed by 10
> +          bits of a vendor specific ID.

Could we try to retain:

> -  If the PHY reports an incorrect ID (or none at all) then the
> -  "compatible" list may contain an entry with the correct PHY ID in the
     ...

Using it is generally wrong, and that is not clear in the new text.

> +
> +  reg:
> +    maxItems: 1
> +    minimum: 0
> +    maximum: 31
> +    description:
> +      The ID number for the PHY.
> +
> +  interrupts:
> +    maxItems: 1
> +
> +  max-speed:
> +    enum:
> +      - 10
> +      - 100
> +      - 1000

This is outdated in the text description. Any valid speed is
supported, currently 10 - 200000, as listed in phy_setting settings().

   Andrew
