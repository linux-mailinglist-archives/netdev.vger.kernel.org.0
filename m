Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 990854926E5
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 14:16:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238974AbiARNQW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 08:16:22 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:43046 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236141AbiARNQV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Jan 2022 08:16:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=5uKSg1jbSZCAY3NiK22LI67jIWWN8OnNGPK10udHGpA=; b=haErt7NNRU791rmaOnnJH50v/W
        k++PzDKUizEjqvLHKpaQd2Um86AUegdsCCRAxz7SIswSNjzI8Tm0952GkGbqCJY0voD9i44DeFMld
        zm+/jxtRinsmlO4cluxfn48cpRZ0x42daCMiHlHeTTvZn/77i6csEUvFXSwEyXH/SYB0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1n9oLR-001ls0-G2; Tue, 18 Jan 2022 14:16:17 +0100
Date:   Tue, 18 Jan 2022 14:16:17 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        Frank Wunderlich <frank-w@public-files.de>
Subject: Re: [PATCH net-next v4 05/11] net: dsa: realtek: use phy_read in
 ds->ops
Message-ID: <Yea9oR0AteAMwjW2@lunn.ch>
References: <20220105031515.29276-1-luizluca@gmail.com>
 <20220105031515.29276-6-luizluca@gmail.com>
 <79a9c7c2-9bd0-d5d1-6d5a-d505cdc564be@gmail.com>
 <CAJq09z4U5qmBuPUqBnGpT+qcG-vmtFwNMg5Uau3q3F53W-0YDA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJq09z4U5qmBuPUqBnGpT+qcG-vmtFwNMg5Uau3q3F53W-0YDA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Thanks, Florian. You should be correct. It might call
> mdiobus_unregister() and mdiobus_free() twice, once inside the dsa
> code and another one by the devm (if I understood how devm functions
> work).
> 
> The issue is that the dsa switch is assuming that if slave_mii is
> allocated and ds->ops->phy_read is defined, it has allocated the
> slave_mii by itself and it should clean up the slave_mii during
> teardown.

Correct. Either the DSA core takes care of the mdiobus and uses the
phy_read and phy_write ops, or the driver internally registers its own
mdiobus, and phy_read and phy_write ops are not implemented. The core
is not designed to mix those together.

> if ds->ops->phy_read value should not tell if ds->slave_mii_bus should
> be cleaned by the DSA switch.
> 
> I would selfishly hope the correct one was the second option because
> it would make my code much cleaner. If not, that's a complex issue to
> solve without lots of duplications: realtek-smi drivers should not
> have ds->ops->phy_read defined while realtek-mdio requires it. I'll
> need to duplicate dsa_switch_ops for each subdriver only to unset
> phy_read and also duplicate realtek_variant for each interface only to
> reference that different dsa_switch_ops.

One option would be to provide a dummy mdiobus driver for
realtek-mdio, which simply passes the access through to the existing
MDIO bus.

     Andrew
