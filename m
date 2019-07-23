Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FA8972258
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 00:25:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392501AbfGWWZA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 18:25:00 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60662 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729617AbfGWWY6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jul 2019 18:24:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=JBjWPZFWOr2ZDHDrYZ3UsWyBFtkPoXj28/OnBpUt3GQ=; b=jf5frP/e/9v9AkZbCfEO1L6WHG
        stJcK+9H+bc3VfDJ5aFprTTmZFD7CoLUusKuhuF6EPbqfVtpw152T6zfk5purm9QXR0LU46OaYxzu
        VLIWYChioB4lOP9a2ZTjH6ma77mxIHPt7PK5Wx0eAX/A4Mt4/urbLGxvC+8oqHXfEgQY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hq3DK-0003xn-Oo; Wed, 24 Jul 2019 00:24:54 +0200
Date:   Wed, 24 Jul 2019 00:24:54 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Claudiu Manoil <claudiu.manoil@nxp.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        alexandru.marginean@nxp.com, linux-kernel@vger.kernel.org,
        Li Yang <leoyang.li@nxp.com>, Rob Herring <robh+dt@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH net-next 1/3] enetc: Add mdio bus driver for the PCIe
 MDIO endpoint
Message-ID: <20190723222454.GE13517@lunn.ch>
References: <1563894955-545-1-git-send-email-claudiu.manoil@nxp.com>
 <1563894955-545-2-git-send-email-claudiu.manoil@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1563894955-545-2-git-send-email-claudiu.manoil@nxp.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +	bus = mdiobus_alloc_size(sizeof(u32 *));
> +	if (!bus)
> +		return -ENOMEM;
> +

> +	bus->priv = pci_iomap_range(pdev, 0, ENETC_MDIO_REG_OFFSET, 0);

This got me confused for a while. You allocate space for a u32
pointer. bus->priv will point to this space. However, you are not
using this space, you {ab}use the pointer to directly hold the return
from pci_iomap_range(). This works, but sparse is probably unhappy,
and you are wasting the space the u32 pointer takes.

    Andrew
