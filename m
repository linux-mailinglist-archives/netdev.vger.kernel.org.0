Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5A7D10300B
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 00:22:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727405AbfKSXW2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 18:22:28 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:46458 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727389AbfKSXW2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 18:22:28 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8B6211428DA53;
        Tue, 19 Nov 2019 15:22:27 -0800 (PST)
Date:   Tue, 19 Nov 2019 15:22:27 -0800 (PST)
Message-Id: <20191119.152227.1835791894022993413.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        claudiu.manoil@nxp.com, alexandru.marginean@nxp.com,
        xiaoliang.yang_1@nxp.com, yangbo.lu@nxp.com,
        netdev@vger.kernel.org, vladimir.oltean@nxp.com
Subject: Re: [PATCH net-next] net: dsa: felix: Fix CPU port assignment when
 not last port
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191118181657.25333-1-olteanv@gmail.com>
References: <20191118181657.25333-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 19 Nov 2019 15:22:28 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Mon, 18 Nov 2019 20:16:57 +0200

> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> On the NXP LS1028A, there are 2 Ethernet links between the Felix switch
> and the ENETC:
> - eno2 <-> swp4, at 2.5G
> - eno3 <-> swp5, at 1G
> 
> Only one of the above Ethernet port pairs can act as a DSA link for
> tagging.
> 
> When adding initial support for the driver, it was tested only on the 1G
> eno3 <-> swp5 interface, due to the necessity of using PHYLIB initially
> (which treats fixed-link interfaces as emulated C22 PHYs, so it doesn't
> support fixed-link speeds higher than 1G).
> 
> After making PHYLINK work, it appears that swp4 still can't act as CPU
> port. So it looks like ocelot_set_cpu_port was being called for swp4,
> but then it was called again for swp5, overwriting the CPU port assigned
> in the DT.
> 
> It appears that when you call dsa_upstream_port for a port that is not
> defined in the device tree (such as swp5 when using swp4 as CPU port),
> its dp->cpu_dp pointer is not initialized by dsa_tree_setup_default_cpu,
> and this trips up the following condition in dsa_upstream_port:
> 
> 	if (!cpu_dp)
> 		return port;
> 
> So the moral of the story is: don't call dsa_upstream_port for a port
> that is not defined in the device tree, and therefore its dsa_port
> structure is not completely initialized (ds->num_ports is still 6).
> 
> Fixes: 56051948773e ("net: dsa: ocelot: add driver for Felix switch family")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Applied.
