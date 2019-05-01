Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B68610882
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 15:54:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726565AbfEANyW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 09:54:22 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50962 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726165AbfEANyW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 May 2019 09:54:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=4b2MeUM65BJCSCVV5omqKdf271pxpyOswePbL8+W7f4=; b=0GXurpj8rD8/3hixIl1Iwnk4e8
        NJ4/JKTZGYuwArzJWvpTmIVXUP0UHXeGybTs3idHvKmfC7MTmJVXVa4B/7Rbij5rKYfg2lUJzJ5R5
        0CElid7s3A7cPstCIH5mq+EsFkM/b4CMLN95HtdhVrJ6x9/MyeldSWH5oMpcCtiykNw8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hLpgf-0003Xb-Em; Wed, 01 May 2019 15:54:17 +0200
Date:   Wed, 1 May 2019 15:54:17 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Petr =?utf-8?Q?=C5=A0tetiar?= <ynezz@true.cz>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Alban Bedel <albeu@free.fr>
Subject: Re: Handling of EPROBE_DEFER in of_get_mac_address [Was: Re: [PATCH
 v2 3/4] net: macb: Drop nvmem_get_mac_address usage]
Message-ID: <20190501135417.GB19809@lunn.ch>
References: <1556456002-13430-1-git-send-email-ynezz@true.cz>
 <1556456002-13430-4-git-send-email-ynezz@true.cz>
 <20190428165637.GJ23059@lunn.ch>
 <20190428210814.GA346@meh.true.cz>
 <20190428213640.GB10772@lunn.ch>
 <20190429075514.GB346@meh.true.cz>
 <20190429130248.GC10772@lunn.ch>
 <20190430141335.GC346@meh.true.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190430141335.GC346@meh.true.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 30, 2019 at 04:13:35PM +0200, Petr Štetiar wrote:
> Andrew Lunn <andrew@lunn.ch> [2019-04-29 15:02:48]:
> 
> Hi Andrew,
> 
> > > My understanding of -PROBE_DEFER is, that it needs to be propagated back from
> > > the driver's probe callback/hook to the upper device/driver subsystem in order
> > > to be moved to the list of pending drivers and considered for probe later
> > > again. This is not going to happen in any of the current drivers, thus it will
> > > probably still always result in random MAC address in case of -EPROBE_DEFER
> > > error from the nvmem subsystem.
> > 
> > All current drivers which don't look in NVMEM don't expect
> > EPROBE_DEFER. 
> 
> once there's NVMEM wired in of_get_mac_address, one can simply use it, nothing
> is going to stop the potential user of doing so and if EPROBE_DEFER isn't
> propagated from the driver back to the upper device driver subsytem, it's
> probably going to end with random MAC address in some (very rare?) cases.

Hi Petr

There is no simple answer here. If we add EPROBE_DEFER support to all
the current drivers using of_get_mac_address(), we are likely to break
something. Regressions are bad. If somebody does add NVMEM properties
to a device which does not currently have them, and it fails, that it
just bad testing, not a regressions.

So i would keep it KISS. Allow of_get_mac_address() to return an
error, but don't modify current drivers to look for it.

       Andrew
