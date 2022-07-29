Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93ABD584C1D
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 08:50:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234292AbiG2Gus (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 02:50:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233434AbiG2Gup (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 02:50:45 -0400
Received: from relay7-d.mail.gandi.net (relay7-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::227])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5D3020BD6;
        Thu, 28 Jul 2022 23:50:42 -0700 (PDT)
Received: (Authenticated sender: maxime.chevallier@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 305B520003;
        Fri, 29 Jul 2022 06:50:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1659077441;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VArjTbD7FSaQb0tgbNiKVH96xYPmiJmsUZgAk82eZWo=;
        b=bEemRDID19M43BonRh9+LrwTyv+asZ6HnYNrwN2wAs4IxK4gXZvfbOuaBOKkrjpoLX8vI1
        CsIfvQ5e6EASKP6NdwohvCWw8jMkKFBo9EtHbROv71YvLESAG4ihNJiE87Vv3FNEwm2fzN
        S5lXlQYqAsGBcZM5IgIoQzneEZKfgULbdZ6JbeEJSw2DSh5U6r3CsAKd+HKvXL2xOSEm0n
        e0AtAI64jsaKmXQRRoiyRj4m/0/j/ncO2TEjHH3s0GNFayFQN5r+qBF72YDAQAN28/Tz/+
        O2EgigmKSMmpI4/U1p61EZutyQ9Q0LYyN8J+MthD9tPy4b9BLyXBr8h4du9k0A==
Date:   Fri, 29 Jul 2022 08:50:36 +0200
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, davem@davemloft.net,
        Rob Herring <robh+dt@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        thomas.petazzoni@bootlin.com,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org, Horatiu.Vultur@microchip.com,
        Allan.Nielsen@microchip.com, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next 3/4] net: phy: Add helper to derive the number
 of ports from a phy mode
Message-ID: <20220729085036.2b180478@pc-10.home>
In-Reply-To: <df39cfc9-6fd8-e277-870b-67059dcebb2b@gmail.com>
References: <20220728145252.439201-1-maxime.chevallier@bootlin.com>
        <20220728145252.439201-4-maxime.chevallier@bootlin.com>
        <YuMAdACnRKsL8/xD@lunn.ch>
        <df39cfc9-6fd8-e277-870b-67059dcebb2b@gmail.com>
Organization: Bootlin
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Florian, Andrew,

On Thu, 28 Jul 2022 14:44:47 -0700
Florian Fainelli <f.fainelli@gmail.com> wrote:

> On 7/28/22 14:32, Andrew Lunn wrote:
> >> +int phy_interface_num_ports(phy_interface_t interface)
> >> +{
> >> +	switch (interface) {
> >> +	case PHY_INTERFACE_MODE_NA:
> >> +	case PHY_INTERFACE_MODE_INTERNAL:
> >> +		return 0;  
> > 
> > I've not yet looked at how this is used. Returning 0 could have
> > interesting effects i guess? INTERNAL clearly does have some sort of
> > path between the MAC and the PHY, so i think 1 would be a better
> > value. NA is less clear, it generally means Don't touch. But again,
> > there still needs to be a path between the MAC and PHY, otherwise
> > there would not be any to touch.
> > 
> > Why did you pick 0?  

My reasonning was that PHY_INTERNAL is likely a custom solution to link
IPs existing on the same die, so nothing prevents vendors from
multiplexing links on that interface. But it's a far-fetched
reasonning, so 1 can be good, as other interfaces that are meant to be
used on-die like XGMII.

> I would agree that returning 1 is a more sensible default to avoid
> breaking users of that function. However this makes me wonder, in
> what case will we break the following common meaning:
> 
> - Q -> quad
> - P -> penta
> - O -> octal
> 
> Is the helper really needed in the sense that the phy_interface_t
> enumeration is explicit enough thanks to or because of its name? --
> Florian

Good question actually ! It started as a point from Russell proposing a
helper to get the number of serdes lanes for a given interface, but
this sisn't quite fit the use-case, which was simply to simplify

	if (interface == PHY_INTERFACE_MODE_QSGMII ||
	    interface == PHY_INTERFACE_MODE_QUSGMII)

into

	if (phy_interface_num_ports(interface) == 4)

But this a slim simplification at the cost of a new helper to maintain,
so I can repove that if you want.

Thanks for the reviews,

Maxime
