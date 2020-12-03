Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B9E42CCCF1
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 04:05:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727652AbgLCDES (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 22:04:18 -0500
Received: from static.214.254.202.116.clients.your-server.de ([116.202.254.214]:53784
        "EHLO ciao.gmane.io" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726908AbgLCDER (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 22:04:17 -0500
Received: from list by ciao.gmane.io with local (Exim 4.92)
        (envelope-from <gl-netdev-2@m.gmane-mx.org>)
        id 1kkeu7-000195-1v
        for netdev@vger.kernel.org; Thu, 03 Dec 2020 04:03:35 +0100
X-Injected-Via-Gmane: http://gmane.org/
To:     netdev@vger.kernel.org
From:   Grant Edwards <grant.b.edwards@gmail.com>
Subject: Re: net: macb: fail when there's no PHY
Date:   Thu, 3 Dec 2020 03:03:30 -0000 (UTC)
Message-ID: <rq9ki2$uqk$1@ciao.gmane.io>
References: <20170921195905.GA29873@grante>
 <66c0a032-4d20-69f1-deb4-6c65af6ec740@gmail.com>
 <CAK=1mW6Gti0QpUjirB6PfMCiQvnDjkbb56pVKkQmpCSkRU6wtA@mail.gmail.com>
 <6a9c1d4a-ed73-3074-f9fa-158c697c7bfe@gmail.com> <X8fb4zGoxcS6gFsc@grante>
 <20201202183531.GJ2324545@lunn.ch> <rq8p74$2l0$1@ciao.gmane.io>
 <20201202211134.GM2324545@lunn.ch>
User-Agent: slrn/1.0.3 (Linux)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-12-02, Andrew Lunn <andrew@lunn.ch> wrote:

>>> So it will access the MDIO bus of the PHY that is attached to the
>>> MAC.
>>
>> If that's the case, wouldn't the ioctl() calls "just work" even when
>> only the fixed-phy mdio bus and fake PHY are declared in the device
>> tree?
>
> The fixed-link PHY is connected to the MAC. So the IOCTL calls will be
> made to the fixed-link fake MDIO bus.

Ah! When you said "the PHY that is attached to the MAC" above, I
thought you meant electrically attached to the MAC via the mdio bus.

Then how does Forian Fainelli's solution below work? Won't the first
phy found be the fixed one, and then the ioctl() calls will use the
fixed-link bus?

Florian Fainelli wrote:

>>> You should be able to continue having the macb MDIO bus controller be
>>> registered with no PHY/MDIO devices represented in Device Tree such that
>>> user-space can continue to use it for ioctl() *and* you can point the
>>> macb node to a fixed PHY for the purpose of having fixed link parameters.
>>>
>>> There are various drivers that support exactly this mode of operation
>>> where they use a fixed PHY for the Ethernet MAC link parameters, yet
>>> their MDIO bus controller is used to interface with other devices such
>>> as Ethernet switches over MDIO. Example of drivers supporting that are
>>> stmmac, fec, mtk_star_emac and ag71xx. The way it ends up looking like
>>> in Device Tree is the following:
>>>
>>> &eth0 {
>>>         fixed-link {
>>>                 speed = <1000>;
>>>                 full-duplex;
>>>         };
>>>
>>>         mdio {
>>>                 phy0: phy@0 {
>>>                         reg = <0>;
>>>                 };
>>>         };
>>> };

