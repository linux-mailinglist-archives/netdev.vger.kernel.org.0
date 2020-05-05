Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB66A1C57B7
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 16:01:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729235AbgEEOBj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 10:01:39 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:42596 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728076AbgEEOBj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 May 2020 10:01:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=MQhJQSV5DPC+RnQ18Gv5OjUfrbMB0JR8XzYM9Fu0Cns=; b=BPLdwwcd4KtC0HTYqHjtwDw1X2
        mJVWPB/049rFgZ8S7LEq4nNbSLR/3zKrk7qLN6vTYnlH2BC+ePiuxyYNm3mjV6WYL4QFpFgEvAcTD
        mOXu9KbDkhWxhkg1NSMok1gnLzHA8wkShofmqZvzcJausKRgNN1V7JZcqosLpe3YxvJU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jVy8V-000wMg-KV; Tue, 05 May 2020 16:01:27 +0200
Date:   Tue, 5 May 2020 16:01:27 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Marek Vasut <marex@denx.de>, David Jander <david@protonic.nl>,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v1] dt-bindings: net: nxp,tja11xx: rework validation
 support
Message-ID: <20200505140127.GJ208718@lunn.ch>
References: <20200505104215.8975-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200505104215.8975-1-o.rempel@pengutronix.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 05, 2020 at 12:42:15PM +0200, Oleksij Rempel wrote:
> To properly identify this node, we need to use ethernet-phy-id0180.dc80.
> And add missing required properties.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---
>  .../devicetree/bindings/net/nxp,tja11xx.yaml  | 55 ++++++++++++-------
>  1 file changed, 35 insertions(+), 20 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/net/nxp,tja11xx.yaml b/Documentation/devicetree/bindings/net/nxp,tja11xx.yaml
> index 42be0255512b3..cc322107a24a2 100644
> --- a/Documentation/devicetree/bindings/net/nxp,tja11xx.yaml
> +++ b/Documentation/devicetree/bindings/net/nxp,tja11xx.yaml
> @@ -1,4 +1,4 @@
> -# SPDX-License-Identifier: GPL-2.0+
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
>  %YAML 1.2
>  ---
>  $id: http://devicetree.org/schemas/net/nxp,tja11xx.yaml#
> @@ -12,44 +12,59 @@ maintainers:
>    - Heiner Kallweit <hkallweit1@gmail.com>
>  
>  description:
> -  Bindings for NXP TJA11xx automotive PHYs
> +  Bindings for the NXP TJA1102 automotive PHY. This is a dual PHY package where
> +  only the first PHY has global configuration register and HW health
> +  monitoring.
>  
> -allOf:
> -  - $ref: ethernet-phy.yaml#
> +properties:
> +  compatible:
> +    const: ethernet-phy-id0180.dc80
> +    description: ethernet-phy-id0180.dc80 used for TJA1102 PHY
> +
> +  reg:
> +    minimum: 0
> +    maximum: 14
> +    description:
> +      The PHY address of the parent PHY.

Hi Oleksij

reg is normally 0 to 31, since that is the address range for MDIO. 
Did you use 14 here because of what strapping allows?

> +required:
> +  - compatible
> +  - reg
> +  - '#address-cells'
> +  - '#size-cells'

So we have two different meanings of 'required' here.

One meaning is the code requires it. compatible is not required, the
driver will correctly be bind to the device based on its ID registers.
Is reg also required by the code?

The second meaning is about keeping the yaml verifier happy. It seems
like compatible is needed for the verifier. Is reg also required? We
do recommend having reg, but the generic code does not require it.

   Andrew

