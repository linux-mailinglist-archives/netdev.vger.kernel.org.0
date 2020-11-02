Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 720C72A265D
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 09:47:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728248AbgKBIrr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 03:47:47 -0500
Received: from mslow2.mail.gandi.net ([217.70.178.242]:55492 "EHLO
        mslow2.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728104AbgKBIrr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 03:47:47 -0500
Received: from relay10.mail.gandi.net (unknown [217.70.178.230])
        by mslow2.mail.gandi.net (Postfix) with ESMTP id 96B6D3A6BD0
        for <netdev@vger.kernel.org>; Mon,  2 Nov 2020 08:47:45 +0000 (UTC)
Received: from localhost (lfbn-lyo-1-997-19.w86-194.abo.wanadoo.fr [86.194.74.19])
        (Authenticated sender: alexandre.belloni@bootlin.com)
        by relay10.mail.gandi.net (Postfix) with ESMTPSA id 83E55240016;
        Mon,  2 Nov 2020 08:47:20 +0000 (UTC)
Date:   Mon, 2 Nov 2020 09:47:20 +0100
From:   Alexandre Belloni <alexandre.belloni@bootlin.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 1/7] net: mscc: ocelot: use the pvid of zero
 when bridged with vlan_filtering=0
Message-ID: <20201102084720.GA7761@piout.net>
References: <20201031102916.667619-1-vladimir.oltean@nxp.com>
 <20201031102916.667619-2-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201031102916.667619-2-vladimir.oltean@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On 31/10/2020 12:29:10+0200, Vladimir Oltean wrote:
> Currently, mscc_ocelot ports configure pvid=0 in standalone mode, and
> inherit the pvid from the bridge when one is present.
> 
> When the bridge has vlan_filtering=0, the software semantics are that
> packets should be received regardless of whether there's a pvid
> configured on the ingress port or not. However, ocelot does not observe
> those semantics today.
> 
> Moreover, changing the PVID is also a problem with vlan_filtering=0.
> We are privately remapping the VID of FDB, MDB entries to the port's
> PVID when those are VLAN-unaware (i.e. when the VID of these entries
> comes to us as 0). But we have no logic of adjusting that remapping when
> the user changes the pvid and vlan_filtering is 0. So stale entries
> would be left behind, and untagged traffic will stop matching on them.
> 
> And even if we were to solve that, there's an even bigger problem. If
> swp0 has pvid 1, and swp1 has pvid 2, and both are under a vlan_filtering=0
> bridge, they should be able to forward traffic between one another.
> However, with ocelot they wouldn't do that.
> 
> The simplest way of fixing this is to never configure the pvid based on
> what the bridge is asking for, when vlan_filtering is 0. Only if there
> was a VLAN that the bridge couldn't mangle, that we could use as pvid....
> So, turns out, there's 0 just for that. And for a reason: IEEE
> 802.1Q-2018, page 247, Table 9-2-Reserved VID values says:
> 
> 	The null VID. Indicates that the tag header contains only
> 	priority information; no VID is present in the frame.
> 	This VID value shall not be configured as a PVID or a member
> 	~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 	of a VID Set, or configured in any FDB entry, or used in any
> 	Management operation.
> 
> So, aren't we doing exactly what 802.1Q says not to? Well, in a way, but
> what we're doing here is just driver-level bookkeeping, all for the
> better. The fact that we're using a pvid of 0 is not observable behavior
> from the outside world: the network stack does not see the classified
> VLAN that the switch uses, in vlan_filtering=0 mode. And we're also more
> consistent with the standalone mode now.
> 

IIRC, we are using pvid 1 because else bridging breaks when
CONFIG_VLAN_8021Q is not enabled. Did you test that configuration?



-- 
Alexandre Belloni, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
