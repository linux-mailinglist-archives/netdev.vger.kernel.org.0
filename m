Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E55A01AB1B4
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 21:33:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437609AbgDOT3v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 15:29:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2437482AbgDOT3k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Apr 2020 15:29:40 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87963C061A0F
        for <netdev@vger.kernel.org>; Wed, 15 Apr 2020 12:29:40 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 03BE4128B65B4;
        Wed, 15 Apr 2020 12:29:37 -0700 (PDT)
Date:   Wed, 15 Apr 2020 12:29:35 -0700 (PDT)
Message-Id: <20200415.122935.535027595001230500.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     horatiu.vultur@microchip.com, alexandre.belloni@bootlin.com,
        antoine.tenart@bootlin.com, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, joergen.andreasen@microchip.com,
        allan.nielsen@microchip.com, claudiu.manoil@nxp.com,
        netdev@vger.kernel.org, UNGLinuxDriver@microchip.com,
        alexandru.marginean@nxp.com, xiaoliang.yang_1@nxp.com,
        yangbo.lu@nxp.com, po.liu@nxp.com, jiri@mellanox.com,
        idosch@idosch.org, kuba@kernel.org
Subject: Re: [PATCH net] net: mscc: ocelot: fix untagged packet drops when
 enslaving to vlan aware bridge
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200414193615.29506-1-olteanv@gmail.com>
References: <20200414193615.29506-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 15 Apr 2020 12:29:38 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Tue, 14 Apr 2020 22:36:15 +0300

> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> To rehash a previous explanation given in commit 1c44ce560b4d ("net:
> mscc: ocelot: fix vlan_filtering when enslaving to bridge before link is
> up"), the switch driver operates the in a mode where a single VLAN can
> be transmitted as untagged on a particular egress port. That is the
> "native VLAN on trunk port" use case.
> 
> The configuration for this native VLAN is driven in 2 ways:
>  - Set the egress port rewriter to strip the VLAN tag for the native
>    VID (as it is egress-untagged, after all).
>  - Configure the ingress port to drop untagged and priority-tagged
>    traffic, if there is no native VLAN. The intention of this setting is
>    that a trunk port with no native VLAN should not accept untagged
>    traffic.
> 
> Since both of the above configurations for the native VLAN should only
> be done if VLAN awareness is requested, they are actually done from the
> ocelot_port_vlan_filtering function, after the basic procedure of
> toggling the VLAN awareness flag of the port.
> 
> But there's a problem with that simplistic approach: we are trying to
> juggle with 2 independent variables from a single function:
>  - Native VLAN of the port - its value is held in port->vid.
>  - VLAN awareness state of the port - currently there are some issues
>    here, more on that later*.
> The actual problem can be seen when enslaving the switch ports to a VLAN
> filtering bridge:
>  0. The driver configures a pvid of zero for each port, when in
>     standalone mode. While the bridge configures a default_pvid of 1 for
>     each port that gets added as a slave to it.
>  1. The bridge calls ocelot_port_vlan_filtering with vlan_aware=true.
>     The VLAN-filtering-dependent portion of the native VLAN
>     configuration is done, considering that the native VLAN is 0.
>  2. The bridge calls ocelot_vlan_add with vid=1, pvid=true,
>     untagged=true. The native VLAN changes to 1 (change which gets
>     propagated to hardware).
>  3. ??? - nobody calls ocelot_port_vlan_filtering again, to reapply the
>     VLAN-filtering-dependent portion of the native VLAN configuration,
>     for the new native VLAN of 1. One can notice that after toggling "ip
>     link set dev br0 type bridge vlan_filtering 0 && ip link set dev br0
>     type bridge vlan_filtering 1", the new native VLAN finally makes it
>     through and untagged traffic finally starts flowing again. But
>     obviously that shouldn't be needed.
> 
> So it is clear that 2 independent variables need to both re-trigger the
> native VLAN configuration. So we introduce the second variable as
> ocelot_port->vlan_aware.
> 
> *Actually both the DSA Felix driver and the Ocelot driver already had
> each its own variable:
>  - Ocelot: ocelot_port_private->vlan_aware
>  - Felix: dsa_port->vlan_filtering
> but the common Ocelot library needs to work with a single, common,
> variable, so there is some refactoring done to move the vlan_aware
> property from the private structure into the common ocelot_port
> structure.
> 
> Fixes: 97bb69e1e36e ("net: mscc: ocelot: break apart ocelot_vlan_port_apply")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Applied and queued up for -stable, thanks.
