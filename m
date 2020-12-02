Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E7562CC663
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 20:17:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387556AbgLBTRm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 14:17:42 -0500
Received: from static.214.254.202.116.clients.your-server.de ([116.202.254.214]:51020
        "EHLO ciao.gmane.io" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726082AbgLBTRm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 14:17:42 -0500
Received: from list by ciao.gmane.io with local (Exim 4.92)
        (envelope-from <gl-netdev-2@m.gmane-mx.org>)
        id 1kkXcZ-0000st-8d
        for netdev@vger.kernel.org; Wed, 02 Dec 2020 20:16:59 +0100
X-Injected-Via-Gmane: http://gmane.org/
To:     netdev@vger.kernel.org
From:   Grant Edwards <grant.b.edwards@gmail.com>
Subject: Re: net: macb: fail when there's no PHY
Date:   Wed, 2 Dec 2020 19:16:52 -0000 (UTC)
Message-ID: <rq8p74$2l0$1@ciao.gmane.io>
References: <20170921195905.GA29873@grante>
 <66c0a032-4d20-69f1-deb4-6c65af6ec740@gmail.com>
 <CAK=1mW6Gti0QpUjirB6PfMCiQvnDjkbb56pVKkQmpCSkRU6wtA@mail.gmail.com>
 <6a9c1d4a-ed73-3074-f9fa-158c697c7bfe@gmail.com> <X8fb4zGoxcS6gFsc@grante>
 <20201202183531.GJ2324545@lunn.ch>
User-Agent: slrn/1.0.3 (Linux)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-12-02, Andrew Lunn <andrew@lunn.ch> wrote:
>> When using the SIOC[SG]MIIREG ioctl() call, how does one control
>> whether the fake fixed-link bus is accessed or the real macb-mdio bus
>> is accessed?
>
> As far as i remember, that ioctl is based on the interface name.

Right.

> So it will access the MDIO bus of the PHY that is attached to the
> MAC.

If that's the case, wouldn't the ioctl() calls "just work" even when
only the fixed-phy mdio bus and fake PHY are declared in the device
tree?  There must have been something else going on that caused our
user-space code to be unable to talk to the devices on the mdio
bus. We assumed it was because there was only one mdio bus (the fake
one) in the device tree. I'm beginning to suspect that's not the
reason.

> I guess you have user space drivers using the IOCTL to access
> devices on the real bus?

Yes.

> A switch?

There is a switch, but it's not on the mdio bus (on some models, the
switch is access via memory-mapped registers, on others the switch is
accessed via SPI). The PHYs that are attached to the "other" ports of
the switch are on the macb mdio bus.

> Can you swap to a DSA driver?

Possibly. It looks like DSA uses frame tagging. We have two slightly
different platforms. One doesn't have any tagging capabilities. The
other does, but the tags are reserved for use by another chunk of
custom code we've added to the macb.c driver to provide MAC-level
access for a userspace protocol stack which operates in parallel with
the kernel's network stack. It's almost, but not quite, as ugly as it
sounds.

>> How does the macb driver decide which bus/id combination to use as
>> "the phy" that controls the link duplex/speed settting the the MAC?
>
> phy-handle points to a PHY.

OK, I think I've got a vague idea of how that would be done.

[When it comes to device-tree stuff, I've learned that "a vague idea"
is pretty much the best I can manage. Nothing ever works the way I
think it's going to the first time, but with enough guesses I usually
get there.]

--
Grant

