Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25F8C47A264
	for <lists+netdev@lfdr.de>; Sun, 19 Dec 2021 22:44:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236677AbhLSVoU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Dec 2021 16:44:20 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:34220 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231821AbhLSVoT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Dec 2021 16:44:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=a1yRnAELPlkrTgkMNOZBUWRdDpJf9axUBetZqgk2zg8=; b=mFC4n+bOzxtdjoyeb8FrId80/J
        94tpxpCy+sqpFDOOrW+2HtwdFxryznUNhZwJP48KInWXU8ZEcOvd9BN3GCYgmwEJlcUcGpVFb0iAZ
        2NTbH2OWalYysBkDaTBgHfCYbJNZBhjSjqsdzx3uHP4VKkIP1YGrLvK6v3RuZXk0tGYo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mz3ya-00GyiZ-Kq; Sun, 19 Dec 2021 22:44:16 +0100
Date:   Sun, 19 Dec 2021 22:44:16 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Alvin =?utf-8?Q?=C5=A0ipraga?= <ALSI@bang-olufsen.dk>
Cc:     Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "arinc.unal@arinc9.com" <arinc.unal@arinc9.com>
Subject: Re: [PATCH net-next v2 07/13] net: dsa: realtek: add new mdio
 interface for drivers
Message-ID: <Yb+nsFxIeM9RkjPc@lunn.ch>
References: <20211216201342.25587-1-luizluca@gmail.com>
 <20211218081425.18722-1-luizluca@gmail.com>
 <20211218081425.18722-8-luizluca@gmail.com>
 <ea9b8a62-e6ba-0d99-9164-ae5a53075309@bang-olufsen.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ea9b8a62-e6ba-0d99-9164-ae5a53075309@bang-olufsen.dk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > +int realtek_mdio_read_reg(struct realtek_priv *priv, u32 addr, u32 *data)
> > +{
> > +	u32 phy_id = priv->phy_id;
> > +	struct mii_bus *bus = priv->bus;
> > +
> > +	BUG_ON(in_interrupt());
> 
> Again, please don't use BUG here - just make sure this never happens (it 
> looks OK to me). There is a separate warning in mutex_lock which may 
> print a stacktrace if the kernel is configured to do so.

I did not look at the full patch. But if this is a standard MDIO
driver, there is no way we are in interrupt context. The MDIO layer
takes a mutex to prevent parallel operations.

Also, if you really do want to put a test here, it is better to make
use of the kernel infrastructure. might_sleep() if the correct way to
do this.

   Andrew
