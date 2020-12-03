Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC1492CDB5E
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 17:39:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731299AbgLCQgA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 11:36:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:50498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726869AbgLCQgA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Dec 2020 11:36:00 -0500
Date:   Thu, 3 Dec 2020 08:35:17 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607013319;
        bh=Fps3SuFCOQ6ghSUTftMolRWfThLdxBOE/j906OfJAPA=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=l/e9EM2iljfAx/fhFW/4BS0wQY9yeLGH8GXneLQjfi1siRkSdNGeSyxDuKntJyDFc
         7eijts63OTryZMw5OtyfE/11H9sK14HRrt5kdbT3Kb2fKyNzZg9bY/9cRC3swXqcaU
         alHvN9xSrJwXScXKLqbLTgRi86zaFSRTAOFOaaRjcBVkuYo/ZsvmBm2pfY2UWe+O+r
         IGSjIxsddcAgBP8gbgqXQW+50g2km4ZX33USsicUqY9xgRnykyDQQNBYO1qoyLPRwf
         zWM2e0aBFD50onMGycQEBR7S/oTRsiO2B3/HpNefwbOjGYhmjAOxf0NNSdp5mHa21H
         +S4AfgVUMG1oA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org
Subject: Re: [PATCH v3 net-next 2/2] net: dsa: qca: ar9331: export stats64
Message-ID: <20201203083517.3b616782@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201203085011.GA3606@pengutronix.de>
References: <20201202140904.24748-1-o.rempel@pengutronix.de>
        <20201202140904.24748-3-o.rempel@pengutronix.de>
        <20201202104207.697cfdbb@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
        <20201203085011.GA3606@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 3 Dec 2020 09:50:11 +0100 Oleksij Rempel wrote:
> @Jakub,
> 
> > You can't take sleeping locks from .ndo_get_stats64.
> > 
> > Also regmap may sleep?
> > 
> > +	ret = regmap_read(priv->regmap, reg, &val);  
> 
> Yes. And underling layer is mdio bus which is by default sleeping as
> well.
> 
> > Am I missing something?  
> 
> In this log, the  ar9331_get_stats64() was never called from atomic or
> irq context. Why it should not be sleeping?

You missed some long discussions about this within last week on netdev.
Also Documentation/networking/statistics.rst.

To answer your direct question - try:

# cat /proc/net/dev

procfs iterates over devices while holding only an RCU read lock.
