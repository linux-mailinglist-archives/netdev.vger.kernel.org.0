Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C73DF1F493
	for <lists+netdev@lfdr.de>; Wed, 15 May 2019 14:39:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726607AbfEOMjj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 May 2019 08:39:39 -0400
Received: from relay10.mail.gandi.net ([217.70.178.230]:49933 "EHLO
        relay10.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726392AbfEOMjj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 May 2019 08:39:39 -0400
Received: from bootlin.com (aaubervilliers-681-1-43-46.w90-88.abo.wanadoo.fr [90.88.161.46])
        (Authenticated sender: maxime.chevallier@bootlin.com)
        by relay10.mail.gandi.net (Postfix) with ESMTPSA id 8EA3C24000E;
        Wed, 15 May 2019 12:39:36 +0000 (UTC)
Date:   Wed, 15 May 2019 14:39:36 +0200
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: dsa: using multi-gbps speeds on CPU port
Message-ID: <20190515143936.524acd4e@bootlin.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello everyone,

I'm working on a setup where I have a 88e6390X DSA switch connected to
a CPU (an armada 8040) with 2500BaseX and RXAUI interfaces (we only use
one at a time).

I'm facing a limitation with the current way to represent that link,
where we use a fixed-link description in the CPU port, like this :

...
switch0: switch0@1 {
	...
	port@0 {
		reg = <0>;
		label = "cpu";
		ethernet = <&eth0>;
		phy-mode = "2500base-x";
		fixed-link {
			speed = <2500>;
			full-duplex;
		};
	};
};
...

In this scenario, the dsa core will try to create a PHY emulating the
fixed-link on the DSA port side. This can't work with link speeds above
1Gbps, since we don't have any emulation for these PHYs, which would be
using C45 MMDs.

We could add support to emulate these modes, but I think there were some
discussions about using phylink to support these higher speed fixed-link
modes, instead of using PHY emulation.

However using phylink in master DSA ports seems to be a bit tricky,
since master ports don't have a dedicated net_device, and instead
reference the CPU-side netdevice (if I understood correctly).

I'll be happy to help on that, but before prototyping anything, I wanted
to have your thougts on this, and see if you had any plans.

Thanks,

Maxime
