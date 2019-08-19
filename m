Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 332109281F
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 17:14:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727683AbfHSPOd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 11:14:33 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:41928 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726628AbfHSPOd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Aug 2019 11:14:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=nFZpbvfIabN6ZxKbSqt9D3Cc1DfWniWgSlpwjlw0n+Q=; b=ra7HSHHXFtGvuiSKMnz7YcpZjO
        qrgvxNKomvKX631ODd0yRNYN5vU+uCAPwJJSsQDQ0RYKuNOQG6e+VNA9mWEiAefB2ikestGWCLY0d
        fqPKtWdQSPhObn0N3cV3JQzPSc9ifLT00tRUuVJ/bn8YgTFmuAa3G/D+ERAvWik8IoHs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hzjMb-0006xZ-Ad; Mon, 19 Aug 2019 17:14:29 +0200
Date:   Mon, 19 Aug 2019 17:14:29 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Hubert Feurstein <h.feurstein@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next 1/3] net: mdio: add support for passing a PTP
 system timestamp to the mii_bus driver
Message-ID: <20190819151429.GG15291@lunn.ch>
References: <20190816163157.25314-1-h.feurstein@gmail.com>
 <20190816163157.25314-2-h.feurstein@gmail.com>
 <20190819131736.GD8981@lunn.ch>
 <CA+h21hou0v0gPURO3VHe2Ur1-heXnuueN5F92iDLffArB+1d5w@mail.gmail.com>
 <CA+h21hpe1JRBAGX5GwAZopuG9D2oe-+G+7Y026vBLPhhX--YNQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+h21hpe1JRBAGX5GwAZopuG9D2oe-+G+7Y026vBLPhhX--YNQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > How expensive is ptp_read_system_prets()? My original suggestion was
> > > to unconditionally call it here, and then let the driver overwrite it
> > > if it supports finer grained time stamping. MDIO is slow, so as long
> > > as ptp_read_system_prets() is not too expensive, i prefer KISS.
> > >
> > >    Andrew
> >
> > While that works for the pre_ts, it doesn't work for the post_ts (the
> > MDIO bus core will unconditionally overwrite the system timestamp from
> > the driver).
> > Unless you're suggesting to keep the pre_ts unconditional and the
> > post_ts under the "if" condition, which is a bit odd.
> > According to my tests with a scope (measuring the width between SPI
> > transfers with and without the ptp_read_system_*ts calls), two calls
> > to ktime_get_real_ts64 amount to around 750 ns on a 1200 MHz Cortex A7
> > core, or around 90 clock cycles.
> 
> 900 clock cycles, my bad.

That is quite a lot. I was just expecting it to read a free running
clock and maybe do some unit conversions. 900 cycles suggests it is
doing a lot more.

So please keep with the idea of the bus driver indicating if it
supports the time stamping. But please make it a generic bus->flags,
and bit 0 indicating time stamping. At some point in the future, it
would be useful to indicate if the bus supports c45, which would be
another use of flags.

Thanks
	Andrew
