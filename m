Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C66952F53E2
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 21:11:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728867AbhAMUJY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 15:09:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:60898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728763AbhAMUJY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Jan 2021 15:09:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A2075208B8;
        Wed, 13 Jan 2021 20:08:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610568523;
        bh=Ej/rzxfSzsaQGeKJE6VmjaR8gM40cv/+y3lw7hw1xAA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Rtg1iQA3qrCOKSL2FHmpu87c4xJJn6YV/5cCDCcWNDBQ6/A54RpWZvkfA4ZDRXXs9
         4Hje3aH4qEfK2/3MVfi+6JTMSXzG7SM4JYaJL2Ysf3ps3X3WTcUHwFmOTTnLRJRdIV
         UzAZ1PloM8mUdDLGXt7fsbwaxOsuf8IHPRb8svqH+YYgl1wwM27D9SO72Ye9OzpDW9
         vZ/uimCb0xpufj4vXy8m7PgWTBucArhTqn4GEmwY0AGfhc2sVOQzVI/1/Oyqqrjn7E
         2zfRTqPUWWCKwKW7JQRA7k3i3lqd8zHzUIwJeuybGiJ1ANYhg2iwA/JFj5NbP6EAdJ
         OJka5svupLBDw==
Date:   Wed, 13 Jan 2021 21:08:39 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     andrew@lunn.ch, netdev@vger.kernel.org, olteanv@gmail.com,
        pavana.sharma@digi.com
Subject: Re: mv88e6xxx: 2500base-x inband AN is broken on Amethyst? what to
 do?
Message-ID: <20210113210839.40bb9446@kernel.org>
In-Reply-To: <20210113102849.GG1551@shell.armlinux.org.uk>
References: <20210113011823.3e407b31@kernel.org>
        <20210113102849.GG1551@shell.armlinux.org.uk>
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

OK, so I did some tests with Peridot and 88X3310:

On 88E6390 switch, when CMODE in the port register for a port capable of
SerDes is set to 1000base-x, the switch self-configures the SerDes PHY
to inband AN:
  register 4.2000 has value 0x1940

but when CMODE is set to 2500base-x, the switch self-configure the PHY
without inband AN:
  register 4.2000 has value 0x0940

Also the 88X3310 PHY, when configured with MACTYPE=4
 (that is the mode that switches host interface between
  10gbase-r/5gbase-r/2500base-x/sgmii, depending on copper speed)
and when copper speed is 2500, the PHY self-configures without inband
AN:
  register 4.2000 has value 0x0140

It seems to me that on these Marvell devices, they consider 2500base-x
not capable of inband AN and disable it by default.

Moreover when the PHY has disabled inband AN and the Peridot switch has
it enabled (by software), they won't link. I tried enabling the inband
AN on the PHY, but it does not seem to work. Peridot can only
communicate with the PHY in 2500base-x with inband AN disabled.

This means that the commit
  a5a6858b793ff ("net: dsa: mv88e6xxx: extend phylink to Serdes PHYs")
causes a regression, since the code started enabling inband AN on
2500base-x mode on the mv88e6390 family, and they stopped working with
the PHY.

Russell, could we, for now, just edit the code so that when
  mv88e6390_serdes_pcs_config
is being configured with inband mode in 2500base-x, the inband mode
won't be enabled and the function will print a warning?
This could come with a Fixes tag so that it is backported to stable.

Afterwards we can work on refactoring the phylink code so that either
the driver can inform phylink whether 2500base-x inband AN is supported,
or maybe we can determine from some documentation or whatnot whether
inband AN is supported on 2500base-x at all.

Marek
