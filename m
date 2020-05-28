Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 511E91E648D
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 16:51:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403765AbgE1OvJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 10:51:09 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:53852 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391278AbgE1OvE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 10:51:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=YdogGHLOMaBcSB6iiHTIAEAIzmw2Cd51eBBKBzmOPtw=; b=Mw02PCMg9rYkTYqS6wZIfE3Dvz
        qH4isjC3zgJK8cO7WWBhcDLo0x1he9AW4ykEiaor9ePHXjSXzs7r4exHclaReJP8jxZl8CQaUC0PE
        F4TVVOa6aXwWd+dHvfl8t2Q3NyoLI4s5B7llc49H2bkfGR8CkA6+7fvVVKe3vVvi1bxo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jeJs2-003Wup-DV; Thu, 28 May 2020 16:50:58 +0200
Date:   Thu, 28 May 2020 16:50:58 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        linux@armlinux.org.uk, antoine.tenart@bootlin.com,
        alexandre.belloni@bootlin.com, horatiu.vultur@microchip.com,
        allan.nielsen@microchip.com, UNGLinuxDriver@microchip.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        madalin.bucur@oss.nxp.com, radu-andrei.bulie@nxp.com,
        fido_max@inbox.ru
Subject: Re: [PATCH net-next 06/11] net: dsa: ocelot: create a template for
 the DSA tags on xmit
Message-ID: <20200528145058.GA840827@lunn.ch>
References: <20200527234113.2491988-1-olteanv@gmail.com>
 <20200527234113.2491988-7-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200527234113.2491988-7-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 28, 2020 at 02:41:08AM +0300, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> With this patch we try to kill 2 birds with 1 stone.
> 
> First of all, some switches that use tag_ocelot.c don't have the exact
> same bitfield layout for the DSA tags. The destination ports field is
> different for Seville VSC9953 for example. So the choices are to either
> duplicate tag_ocelot.c into a new tag_seville.c (sub-optimal) or somehow
> take into account a supposed ocelot->dest_ports_offset when packing this
> field into the DSA injection header (again not ideal).
> 
> Secondly, tag_ocelot.c already needs to memset a 128-bit area to zero
> and call some packing() functions of dubious performance in the
> fastpath. And most of the values it needs to pack are pretty much
> constant (BYPASS=1, SRC_PORT=CPU, DEST=port index). So it would be good
> if we could improve that.
> 
> The proposed solution is to allocate a memory area per port at probe
> time, initialize that with the statically defined bits as per chip
> hardware revision, and just perform a simpler memcpy in the fastpath.

Hi Vladimir

We try to keep the taggers independent of the DSA drivers. I think
tag_ocelot.c is the only one that breaks this.

tag drivers are kernel modules. They have all the options of a kernel
module, such as init and exit functions. You could create these
templates in the module init function, and clean them up in the exit
function. You can also register multiple taggers in one
driver. tag_brcm.c does this as an example. So you can have a Seville
tagger which uses different templates to ocelot.

       Andrew
