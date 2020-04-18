Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD5001AF5BF
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 00:54:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728274AbgDRWyX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Apr 2020 18:54:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727927AbgDRWyX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Apr 2020 18:54:23 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7920FC061A0C
        for <netdev@vger.kernel.org>; Sat, 18 Apr 2020 15:54:23 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5BF9B12783B70;
        Sat, 18 Apr 2020 15:54:22 -0700 (PDT)
Date:   Sat, 18 Apr 2020 15:54:21 -0700 (PDT)
Message-Id: <20200418.155421.1807745357594780485.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     horatiu.vultur@microchip.com, alexandre.belloni@bootlin.com,
        antoine.tenart@bootlin.com, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, joergen.andreasen@microchip.com,
        allan.nielsen@microchip.com, claudiu.manoil@nxp.com,
        netdev@vger.kernel.org, UNGLinuxDriver@microchip.com,
        alexandru.marginean@nxp.com, xiaoliang.yang_1@nxp.com,
        yangbo.lu@nxp.com, po.liu@nxp.com, jiri@mellanox.com,
        idosch@idosch.org, kuba@kernel.org
Subject: Re: [PATCH net-next] net: mscc: ocelot: deal with problematic
 MAC_ETYPE VCAP IS2 rules
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200417190308.32598-1-olteanv@gmail.com>
References: <20200417190308.32598-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 18 Apr 2020 15:54:23 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Fri, 17 Apr 2020 22:03:08 +0300

> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> By default, the VCAP IS2 will produce a single match for each frame, on
> the most specific classification.
> 
> Example: a ping packet (ICMP over IPv4 over Ethernet) sent from an IP
> address of 10.0.0.1 and a MAC address of 96:18:82:00:04:01 will match
> this rule:
> 
> tc filter add dev swp0 ingress protocol ipv4 \
> 	flower skip_sw src_ip 10.0.0.1 action drop
> 
> but not this one:
> 
> tc filter add dev swp0 ingress \
> 	flower skip_sw src_mac 96:18:82:00:04:01 action drop
> 
> Currently the driver does not really warn the user in any way about
> this, and the behavior is rather strange anyway.
> 
> The current patch is a workaround to force matches on MAC_ETYPE keys
> (DMAC and SMAC) for all packets irrespective of higher layer protocol.
> The setting is made at the port level.
> 
> Of course this breaks all other non-src_mac and non-dst_mac matches, so
> rule exclusivity checks have been added to the driver, in order to never
> have rules of both types on any ingress port.
> 
> The bits that discard higher-level protocol information are set only
> once a MAC_ETYPE rule is added to a filter block, and only for the ports
> that are bound to that filter block. Then all further non-MAC_ETYPE
> rules added to that filter block should be denied by the ports bound to
> it.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Applied.
