Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D09181EBD
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 16:11:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729002AbfHEOLE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 10:11:04 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:34164 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726508AbfHEOLE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Aug 2019 10:11:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=L8KhNR5DFcSR8uqlzveeJUJecQCiPoybMlEDouI2PYM=; b=lkYXdh97pG6GHl2wLJ1qeP0f5S
        x7XUJTIGk4SmuW95vK8z9fzcWPdVNwYtiWXxQVULVictmCWUK9RM8Lkp+8OSqdHlWlnf3+C56hfVH
        JInNFvI35dKlD8uLGCxlZYMEfBKZHP8bCP3aObduYEgYz3WzpD3mlV/b/ms3T500+oAI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hudhU-0007Gl-2d; Mon, 05 Aug 2019 16:11:00 +0200
Date:   Mon, 5 Aug 2019 16:11:00 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Alexandru Ardelean <alexandru.ardelean@analog.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        robh+dt@kernel.org, mark.rutland@arm.com, f.fainelli@gmail.com,
        hkallweit1@gmail.com
Subject: Re: [PATCH 16/16] dt-bindings: net: add bindings for ADIN PHY driver
Message-ID: <20190805141100.GG24275@lunn.ch>
References: <20190805165453.3989-1-alexandru.ardelean@analog.com>
 <20190805165453.3989-17-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190805165453.3989-17-alexandru.ardelean@analog.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +  adi,rx-internal-delay:
> +    $ref: /schemas/types.yaml#/definitions/uint32
> +    description: |
> +      RGMII RX Clock Delay used only when PHY operates in RGMII mode (phy-mode
> +      is "rgmii-id", "rgmii-rxid", "rgmii-txid") see `dt-bindings/net/adin.h`
> +      default value is 0 (which represents 2 ns)
> +    enum: [ 0, 1, 2, 6, 7 ]

We want these numbers to be in ns. So the default value would actually
be 2. The driver needs to convert the number in DT to a value to poke
into a PHY register. Please rename the property adi,rx-internal-delay-ns.

> +
> +  adi,tx-internal-delay:
> +    $ref: /schemas/types.yaml#/definitions/uint32
> +    description: |
> +      RGMII TX Clock Delay used only when PHY operates in RGMII mode (phy-mode
> +      is "rgmii-id", "rgmii-rxid", "rgmii-txid") see `dt-bindings/net/adin.h`
> +      default value is 0 (which represents 2 ns)
> +    enum: [ 0, 1, 2, 6, 7 ]

Same here.

> +
> +  adi,fifo-depth:
> +    $ref: /schemas/types.yaml#/definitions/uint32
> +    description: |
> +      When operating in RMII mode, this option configures the FIFO depth.
> +      See `dt-bindings/net/adin.h`.
> +    enum: [ 0, 1, 2, 3, 4, 5 ]

Units? You should probably rename this adi,fifo-depth-bits and list
the valid values in bits.

> +
> +  adi,eee-enabled:
> +    description: |
> +      Advertise EEE capabilities on power-up/init (default disabled)
> +    type: boolean

It is not the PHY which decides this. The MAC indicates if it is EEE
capable to phylib. phylib looks into the PHY registers to determine if
the PHY supports EEE. phylib will then enable EEE
advertisement. Please remove this, and ensure EEE is disabled by
default.

	Andrew
