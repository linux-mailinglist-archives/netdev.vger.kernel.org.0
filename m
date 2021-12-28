Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EE8C48081E
	for <lists+netdev@lfdr.de>; Tue, 28 Dec 2021 10:57:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229899AbhL1J5j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Dec 2021 04:57:39 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:43192 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229570AbhL1J5i (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Dec 2021 04:57:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=4MXP99o6jhL/94Qb5drFlJpRUdWNJ1K2ZT4IJrRnK34=; b=KmqEHVfcAR1iOF+rMCveri/etV
        Bm6zwAH8KncCGarh+Fv5YkmZygfppd03rubqar9X4/vJKyfuYA4W0YqC/8NPV+DXIscC4ood2b+W6
        4EpNFnZQDvUQug4pCXpw3u/BYWXwjdTxo1uWlj8wKTDagY2/1OlznF62euPVuWJtdTcM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1n29Ec-0001qa-HJ; Tue, 28 Dec 2021 10:57:34 +0100
Date:   Tue, 28 Dec 2021 10:57:34 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
Cc:     Alvin =?utf-8?Q?=C5=A0ipraga?= <ALSI@bang-olufsen.dk>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Subject: Re: [PATCH net-next v2 07/13] net: dsa: realtek: add new mdio
 interface for drivers
Message-ID: <Ycrfjr7wh6IhN+rF@lunn.ch>
References: <20211216201342.25587-1-luizluca@gmail.com>
 <20211218081425.18722-1-luizluca@gmail.com>
 <20211218081425.18722-8-luizluca@gmail.com>
 <ea9b8a62-e6ba-0d99-9164-ae5a53075309@bang-olufsen.dk>
 <CAJq09z4g_jfNuRgh4JLLYw0nPg_borA_RT6gnVaoEovAKK6Vnw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJq09z4g_jfNuRgh4JLLYw0nPg_borA_RT6gnVaoEovAKK6Vnw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > +int realtek_mdio_read_reg(struct realtek_priv *priv, u32 addr, u32 *data)
> > > +{
> > > +     u32 phy_id = priv->phy_id;
> > > +     struct mii_bus *bus = priv->bus;
> > > +
> > > +     BUG_ON(in_interrupt());
> >
> > Again, please don't use BUG here - just make sure this never happens (it
> > looks OK to me). There is a separate warning in mutex_lock which may
> > print a stacktrace if the kernel is configured to do so.
> 
> OK. So, is it safe to simply drop it?

Yes. The MDIO core will never call this in interrupt context.

If you want to be paranoid, use might_sleep(); and build your kernel
with CONFIG_DEBUG_ATOMIC_SLEEP.

     Andrew
