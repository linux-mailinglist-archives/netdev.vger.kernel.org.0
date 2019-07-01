Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F7675C0BA
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 17:56:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730155AbfGAPz6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 11:55:58 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45980 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727370AbfGAPz6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Jul 2019 11:55:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=qAvuqM9wvrxZVoAPvKFSAyGBuX1/Agx1OTcZdKrt30s=; b=wiKRhMigVC0L/bJMtNll6y9YP+
        J00ya1G54slJo86gspqDUoI3Y1ypqc/K28y33KMcGiIWW9rDTd+fl9XGDl+xBhLTOd8+IXDBTTNhY
        G3ydgATopd+CxfRy1Kiirm3qOtGHGGApjgmDXUk0xBuRdlphcZTamNLMmDhkdTeV2MMg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hhyeg-00089Z-RH; Mon, 01 Jul 2019 17:55:46 +0200
Date:   Mon, 1 Jul 2019 17:55:46 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Pawel Dembicki <paweldembicki@gmail.com>
Cc:     linus.walleij@linaro.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] net: dsa: Change DT bindings for Vitesse VSC73xx
 switches
Message-ID: <20190701155546.GA30468@lunn.ch>
References: <20190701152723.624-1-paweldembicki@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190701152723.624-1-paweldembicki@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 01, 2019 at 05:27:20PM +0200, Pawel Dembicki wrote:
> This commit document changes after split vsc73xx driver into core and
> spi part. The change of DT bindings is required for support the same
> vsc73xx chip, which need PI bus to communicate with CPU. It also

SPI

> introduce how to use vsc73xx platform driver.
> 
> Signed-off-by: Pawel Dembicki <paweldembicki@gmail.com>
> ---
>  .../bindings/net/dsa/vitesse,vsc73xx.txt      | 74 ++++++++++++++++---
>  1 file changed, 64 insertions(+), 10 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/net/dsa/vitesse,vsc73xx.txt b/Documentation/devicetree/bindings/net/dsa/vitesse,vsc73xx.txt
> index ed4710c40641..c6a4cd85891c 100644
> --- a/Documentation/devicetree/bindings/net/dsa/vitesse,vsc73xx.txt
> +++ b/Documentation/devicetree/bindings/net/dsa/vitesse,vsc73xx.txt
> @@ -2,8 +2,8 @@ Vitesse VSC73xx Switches
>  ========================
>  
>  This defines device tree bindings for the Vitesse VSC73xx switch chips.
> -The Vitesse company has been acquired by Microsemi and Microsemi in turn
> -acquired by Microchip but retains this vendor branding.
> +The Vitesse company has been acquired by Microsemi and Microsemi has
> +been acquired Microchip but retains this vendor branding.
>  
>  The currently supported switch chips are:
>  Vitesse VSC7385 SparX-G5 5+1-port Integrated Gigabit Ethernet Switch
> @@ -11,16 +11,26 @@ Vitesse VSC7388 SparX-G8 8-port Integrated Gigabit Ethernet Switch
>  Vitesse VSC7395 SparX-G5e 5+1-port Integrated Gigabit Ethernet Switch
>  Vitesse VSC7398 SparX-G8e 8-port Integrated Gigabit Ethernet Switch
>  
> -The device tree node is an SPI device so it must reside inside a SPI bus
> -device tree node, see spi/spi-bus.txt
> +This switch could have two different management interface.
> +
> +If SPI interface is used, the device tree node is an SPI device so it must
> +reside inside a SPI bus device tree node, see spi/spi-bus.txt
> +
> +If Platform driver is used, the device tree node is an platform device so it
> +must reside inside a platform bus device tree node.
>  
>  Required properties:
>  
> -- compatible: must be exactly one of:
> -	"vitesse,vsc7385"
> -	"vitesse,vsc7388"
> -	"vitesse,vsc7395"
> -	"vitesse,vsc7398"

You cannot remove these. It will break backwards compatibility.
Adding new compatible strings is fine, but you cannot remove existing
ones.

	Andrew

