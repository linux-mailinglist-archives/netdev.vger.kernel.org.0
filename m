Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0EBC4761CC
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 20:35:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231522AbhLOTeM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 14:34:12 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:57238 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230099AbhLOTeL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Dec 2021 14:34:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=mea4z1meHDb7hqTabT1eHO2uB5dQ+dRIYt40n/hstTA=; b=vjYHKCrFQipvPJhgUgCSZPkDCm
        jMBUcwOPDp7B4SSwyO0u0/77A6mrcPmqNRLXrJmhJ/75z1EMqD+i497KvJArYK6Txr0A0/2Mwytvv
        h63jfGewMxtVfd35z3cVVCMzzF+43CusPVXHYgwqDbil5dpMZP5ItcPQX+h4yKlQRbl4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mxa2K-00Gg6J-4q; Wed, 15 Dec 2021 20:34:00 +0100
Date:   Wed, 15 Dec 2021 20:34:00 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Francesco Dolcini <francesco.dolcini@toradex.com>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Philippe Schenker <philippe.schenker@toradex.com>,
        netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Fabio Estevam <festevam@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 3/3] net: fec: reset phy on resume after power-up
Message-ID: <YbpDKH6CaHzm119W@lunn.ch>
References: <DB8PR04MB679570A356B655A5D6BFE818E6769@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <YbnDc/snmb1WYVCt@shell.armlinux.org.uk>
 <Ybm3NDeq96TSjh+k@lunn.ch>
 <20211215110139.GA64001@francesco-nb.int.toradex.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211215110139.GA64001@francesco-nb.int.toradex.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> This is all correct and will solve the issue, however ...
> 
> The problem I see is that nor the phylib nor the PHY driver is aware
> that the PHY was powered down, if we unconditionally assert the reset in
> the suspend callback in the PHY driver/lib this will affect in a bad
> case the most common use case in which we keep the PHY powered in
> suspend.

We know if the PHY should be left up because of WoL. So that is not an
issue. We can also put the PHY into lower power mode, before making
the call to put the PHY into reset.  If the reset is not implemented,
the PHY stays in low power mode. If it is implemented, it is both in
lower power mode and held in reset. And if the regulator is provided,
the power will go off.

> The reason is that the power consumption in reset is higher in reset
> compared to the normal PHY software power down.

Does the datasheet have numbers for in lower power mode and held in
reset? We only have an issue if held in reset when in low power mode
consumes more power than simply in low power mode.

	Andrew
