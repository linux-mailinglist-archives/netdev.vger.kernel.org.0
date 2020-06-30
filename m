Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5885B20EDF6
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 08:01:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729381AbgF3GBs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 02:01:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726047AbgF3GBr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 02:01:47 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DC8AC061755
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 23:01:47 -0700 (PDT)
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 1E8DA22FE6;
        Tue, 30 Jun 2020 08:01:42 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1593496905;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ss/fN8bdlHeLUI21akf/rjF8LLkIC3ZorFmfKARH7KI=;
        b=U8QC24JSniMs1bbdBDXNrMW8W/dQ2l5R0o8PBb5ytNR+eA9KKyMfG8BzdgkqmYLFvm3ChY
        ZLUbEUxUkLZCa3OSfseOL/tJjD3G3/ahA2biAoEZCTY0wHyauSaGNjt14l1+gAQoeke/Kf
        Ogh/FgnlQuVd9ZF4YyrHmp64CeUAQ70=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 30 Jun 2020 08:01:41 +0200
From:   Michael Walle <michael@walle.cc>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH net-next v3 0/9] net: phy: add Lynx PCS MDIO module
In-Reply-To: <CA+h21hq146U6Zb38Nrc=BKwMu4esNtpK5g79oojxVmGs5gLcYg@mail.gmail.com>
References: <20200621225451.12435-1-ioana.ciornei@nxp.com>
 <20200622092944.GB1551@shell.armlinux.org.uk>
 <CA+h21hq146U6Zb38Nrc=BKwMu4esNtpK5g79oojxVmGs5gLcYg@mail.gmail.com>
User-Agent: Roundcube Webmail/1.4.6
Message-ID: <0a2c0e6ea53be6c77875022916fbb33d@walle.cc>
X-Sender: michael@walle.cc
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

Am 2020-06-22 11:34, schrieb Vladimir Oltean:
> On Mon, 22 Jun 2020 at 12:29, Russell King - ARM Linux admin
> <linux@armlinux.org.uk> wrote:
>> 
>> On Mon, Jun 22, 2020 at 01:54:42AM +0300, Ioana Ciornei wrote:
>> > Add support for the Lynx PCS as a separate module in drivers/net/phy/.
>> > The advantage of this structure is that multiple ethernet or switch
>> > drivers used on NXP hardware (ENETC, Felix DSA switch etc) can share the
>> > same implementation of PCS configuration and runtime management.
>> >
>> > The PCS is represented as an mdio_device and the callbacks exported are
>> > highly tied with PHYLINK and can't be used without it.
>> >
>> > The first 3 patches add some missing pieces in PHYLINK and the locked
>> > mdiobus write accessor. Next, the Lynx PCS MDIO module is added as a
>> > standalone module. The majority of the code is extracted from the Felix
>> > DSA driver. The last patch makes the necessary changes in the Felix
>> > driver in order to use the new common PCS implementation.
>> >
>> > At the moment, USXGMII (only with in-band AN and speeds up to 2500),
>> > SGMII, QSGMII (with and without in-band AN) and 2500Base-X (only w/o
>> > in-band AN) are supported by the Lynx PCS MDIO module since these were
>> > also supported by Felix and no functional change is intended at this
>> > time.
>> 
>> Overall, I think we need to sort out the remaining changes in phylink
>> before moving forward with this patch set - I've made some progress
>> with Florian and the Broadcom DSA switches late last night.  I'm now
>> working on updating the felix DSA driver.
>> 
> 
> What needs to be done in the felix driver that is not part of this
> series? Maybe you could review this instead?
> 
>> There's another reason - having looked at the work I did with this
>> same PHY, I think you are missing configuration of the link timer,
>> which is different in SGMII and 1000BASE-X.  Please can you look at
>> the code I came up with?  "dpaa2-mac: add 1000BASE-X/SGMII PCS 
>> support".
>> 
>> Thanks.
>> 
> 
> felix does not have support code for 1000base-x, so I think it's
> natural to not clutter this series with things like that.
> Things like USXGMII up to 10G, 10GBase-R, are also missing, for much
> of the same reason - we wanted to make no functional change to the
> existing code, precisely because we wanted it to go in quickly. There
> are multiple things that are waiting for it:
> - Michael Walle's enetc patches are going to use pcs-lynx

How likely is it that this will be sorted out before the 5.9 merge
window will be closed? The thing is, we have boards out in the
wild which have a non-working ethernet with their stock bootloader
and which depend on the following patch series to get that fixed:

https://lore.kernel.org/netdev/20200528063847.27704-1-michael@walle.cc/

Thus, if this is going to take longer, I'd do a respin of that
series. We already missed the 5.8 release and I don't know if
a "Fixes:" tag (or a CC stable) is appropriate here because it
is kind of a new functionality.

-michael
