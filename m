Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C19975C0CF
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 18:03:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730234AbfGAQDQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 12:03:16 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:46012 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727419AbfGAQDQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Jul 2019 12:03:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=IetNNsaoWLkYSAXHE+XLJKKaYo2maSqrxawr9i3AODM=; b=aOPoFzu5X7DIXa6UoMwgiG7W4O
        dEG+8mePAq/q1GKJV5ij276Gar/vIfjp5D6Gn+ilv3X7r4mITYTQBKzBmDCOqmazbSVrCZpM0Rgfu
        bD1AXorJAWLUU/UpxuflwHXIkXlpVBNaXiBRvzQzEL8HCGlLZCOkd1UZFV2oAk/bcK/Q=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hhylr-0008CQ-5d; Mon, 01 Jul 2019 18:03:11 +0200
Date:   Mon, 1 Jul 2019 18:03:11 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Pawel Dembicki <paweldembicki@gmail.com>
Cc:     linus.walleij@linaro.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] net: dsa: vsc73xx: Split vsc73xx driver
Message-ID: <20190701160311.GB30468@lunn.ch>
References: <20190701152723.624-1-paweldembicki@gmail.com>
 <20190701152723.624-2-paweldembicki@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190701152723.624-2-paweldembicki@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> @@ -495,12 +380,12 @@ static int vsc73xx_update_bits(struct vsc73xx *vsc, u8 block, u8 subblock,
>  	int ret;
>  
>  	/* Same read-modify-write algorithm as e.g. regmap */
> -	ret = vsc73xx_read(vsc, block, subblock, reg, &orig);
> +	ret = vsc->ops->read(vsc, block, subblock, reg, &orig);
>  	if (ret)
>  		return ret;
>  	tmp = orig & ~mask;
>  	tmp |= val & mask;
> -	return vsc73xx_write(vsc, block, subblock, reg, tmp);
> +	return vsc->ops->write(vsc, block, subblock, reg, tmp);

This patch would be a lot less invasive and smaller if you hid the
difference between SPI and platform inside vsc73xx_write() and
vsc73xx_read().

> -static int vsc73xx_probe(struct spi_device *spi)
> +int vsc73xx_probe(struct vsc73xx *vsc)
>  {
> -	struct device *dev = &spi->dev;

  struct device *dev = vsc->dev;

and then a lot of the changes you make here go away.

In general, think about how to make the changes small. It saves your
time from actually making changes, and reviewer time since the patch
it smaller.

    Andrew
