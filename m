Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC6EF2F5812
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 04:01:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728582AbhANCNr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 21:13:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:40662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729192AbhAMViP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Jan 2021 16:38:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5D64022510;
        Wed, 13 Jan 2021 21:37:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610573853;
        bh=ui6OjwOzcftw1qc02VnerTayu10Pkc364VS5kiWkxIQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jpzVF8flggbfy71FV71EUR5YDySZqV0dmg30OBV62QBCSfoNQWY2XmZLxD1O6rG/t
         Y7GUnGbyVVHp5ekDqp/MNyWVIdn6tjdPxClMgDJoWoBbES19mXgJWDinCBW00T4sB2
         OpHC+YvO8wHgOq3/7hNC7wYKyVl4x18uFZPk67QpQUCknYPWYy8wetdO7pGmKofF5v
         KJjtOMSeoF7ck3xVxgwiZI2C8hYaYO1v0m9+lGHPeqE4l/DR4uAkwQmPf+kpmk96Go
         qMbwMNLfM4vrg8eqnRK0YXOO5LobzGtNgbNr5BxAnPjEtoSJdWl1mhxwETptijA6mo
         VGxS5c0BC6FKg==
Date:   Wed, 13 Jan 2021 22:37:29 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     andrew@lunn.ch, netdev@vger.kernel.org, olteanv@gmail.com,
        pavana.sharma@digi.com
Subject: Re: mv88e6xxx: 2500base-x inband AN is broken on Amethyst? what to
 do?
Message-ID: <20210113223729.33c8bb65@kernel.org>
In-Reply-To: <20210113212125.GJ1551@shell.armlinux.org.uk>
References: <20210113011823.3e407b31@kernel.org>
        <20210113102849.GG1551@shell.armlinux.org.uk>
        <20210113210839.40bb9446@kernel.org>
        <20210113212125.GJ1551@shell.armlinux.org.uk>
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 13 Jan 2021 21:21:25 +0000
Russell King - ARM Linux admin <linux@armlinux.org.uk> wrote:

> > Russell, could we, for now, just edit the code so that when
> >   mv88e6390_serdes_pcs_config
> > is being configured with inband mode in 2500base-x, the inband mode
> > won't be enabled and the function will print a warning?
> > This could come with a Fixes tag so that it is backported to stable.  
> 
> I don't see any other easy option, so yes, please do that.

Will do.

> > Afterwards we can work on refactoring the phylink code so that either
> > the driver can inform phylink whether 2500base-x inband AN is supported,
> > or maybe we can determine from some documentation or whatnot whether
> > inband AN is supported on 2500base-x at all.  
> 
> I suspect there is no definitive documentation on exactly what
> 2500base-x actually is. I suspect it may just be easier to turn off AN
> for 2500base-x everywhere, so at least all Linux systems are compatible
> irrespective of the hardware.
> 
> Yes, it means losing pause negotiation, and people will have to
> manually set pause on each end.

This would need a little refactoring of the phylink_sfp_config
function, but I don't think it will be that hard.

> One thing that I don't know is whether the GPON SFP ONT modules that
> use 2500base-x will still function with AN disabled - although I have
> the modules, it appeared that they both needed a connection to the ONU
> to switch from 1000base-x to 2500base-x on the host side - and as I
> don't have an ONU I can test with, I have no way to check their
> behaviour.

We have an ISP here in Prague who is willing to lend us some GPON
ONU devices to get GPON SFP modules work on Turris. I will ask him if he
has one capable of 2.5g and try to borrow it.

Marek
