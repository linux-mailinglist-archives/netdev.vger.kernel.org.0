Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A8CD220634
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 09:31:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729355AbgGOHbR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 03:31:17 -0400
Received: from mail.intenta.de ([178.249.25.132]:40096 "EHLO mail.intenta.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728888AbgGOHbR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jul 2020 03:31:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=intenta.de; s=dkim1;
        h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:CC:To:From:Date; bh=K4q1E59OsyH+5CO1gR1zn2E/c5I1MRudGlErx4Cz/cs=;
        b=k1MEWPxCC0A/gvCdfiJzLZrI0YmXEAFD/axFwnJ1pgh9QAoT2uRlCKEbSjIkcKWOdt/SmQNAMKbY0PARgVi46DHLEbmPL/BJctBsDeU811qzJi6yKoB3g1sHuQ2WPEaiZSif1i9P6bEJB6GPxxm1/c1I+mxvmKotYxDCJm7gr2ZMP/KTsiUjTIk//EESmbf+sdstMLSmzrCly2ZELxb+nLCNcwgCuzAywi+KhHJnM4T26NMwATO1b2nY50sUwXk/iKB//VS2VxkcyY6zDhp4pqeqL+zTAtt8XikkYJAVhMz+j78cGC/qm4gaogxuvQM5MPje/OWOJfSxQzFXwePVoQ==;
Date:   Wed, 15 Jul 2020 09:31:12 +0200
From:   Helmut Grohne <helmut.grohne@intenta.de>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Ludovic Desroches <ludovic.desroches@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Rob Herring" <robh+dt@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] net: dsa: microchip: look for phy-mode in port nodes
Message-ID: <20200715073112.GA25047@laureti-dev>
References: <20200617082235.GA1523@laureti-dev>
 <20200714120827.GA7939@laureti-dev>
 <20200714222716.GP1078057@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200714222716.GP1078057@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ICSMA002.intenta.de (10.10.16.48) To ICSMA002.intenta.de
 (10.10.16.48)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

Thank you for the quick reply.

On Wed, Jul 15, 2020 at 12:27:16AM +0200, Andrew Lunn wrote:
> I think this change is more complex than it needs to be. Only the CPU
> port supports different interface modes. So i don't see the need to
> handle both dev->interface and p->interface. Just first search
> ksz_switch_register() first look in the cpu port node, and if not
> found go back to the old location. The rest of the code can stay the
> same.

The driver supports (among others) the KSZ9897R, which comes with two
MAC ports supporting[1, page 8] RGMII/RMII/MII (ports 6 and 7). Both of
these can be connected to a CPU, so they can both operate as CPU ports
in principle.

However, one can only enable tail tagging for one of them at a time[1,
page 39]. As the current driver expects tail tagging to be enabled on
CPU ports, it doesn't work as is with the driver. It could still be used
to form a ring of switches such that a single failing switch would leave
two chains of switches attached to the CPU. This kind of failover seems
to be part of the DSA vision (but I fail to find a reference at the
moment).

For these reasons, I think that there can be multiple CPU ports in
future. Now there is a trade-off. Either we further encode the
assumption of there being only a single CPU port more deeply into the
driver (as it already does assume that) or we can take the opportunity
to already lift it here with the vision for runtime reconfiguration of
switch topologies.

You seem to be in favour of more deeply encoding the "there can be only
one CPU port" assumption. Based on that assumption, the rest of what you
write makes very much sense to me. Is that the direction to go?

Helmut

[1] http://ww1.microchip.com/downloads/en/DeviceDoc/KSZ9897R-Data-Sheet-DS00002330D.pdf
