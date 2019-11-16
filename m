Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42196FF2CC
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 17:21:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730438AbfKPQVV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Nov 2019 11:21:21 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:43066 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728813AbfKPQVT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 16 Nov 2019 11:21:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=h1hYWbl4tI2lGh9mcyecmNitZsMkAn7Wd5++KuhjZjg=; b=b0OqyJuYM74bUvKDKvTOnd00GN
        sHlLfkGEltZLg/UthP5/A/d3LhkRTW/7qMek6Ys9lNCu/cRRPKICM3/t69T7H7ITUjD6QLslmXZDj
        4wBomvRjQrkPPlMdqrzM3Li4HRKWjJJYPT1mZ27tXIOLC4Tns0kQPx53fSb65UgBiGSI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iW0p2-000623-6Q; Sat, 16 Nov 2019 17:21:16 +0100
Date:   Sat, 16 Nov 2019 17:21:16 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net] net: dsa: tag_8021q: Fix dsa_8021q_restore_pvid for
 an absent pvid
Message-ID: <20191116162116.GF5653@lunn.ch>
References: <20191116160825.29232-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191116160825.29232-1-olteanv@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 16, 2019 at 06:08:25PM +0200, Vladimir Oltean wrote:
> This sequence of operations:
> ip link set dev br0 type bridge vlan_filtering 1
> bridge vlan del dev swp2 vid 1
> ip link set dev br0 type bridge vlan_filtering 1
> ip link set dev br0 type bridge vlan_filtering 0
> 
> apparently fails with the message:
> 
> [   31.305716] sja1105 spi0.1: Reset switch and programmed static config. Reason: VLAN filtering
> [   31.322161] sja1105 spi0.1: Couldn't determine PVID attributes (pvid 0)
> [   31.328939] sja1105 spi0.1: Failed to setup VLAN tagging for port 1: -2
> [   31.335599] ------------[ cut here ]------------
> [   31.340215] WARNING: CPU: 1 PID: 194 at net/switchdev/switchdev.c:157 switchdev_port_attr_set_now+0x9c/0xa4
> [   31.349981] br0: Commit of attribute (id=6) failed.
> [   31.354890] Modules linked in:
> [   31.357942] CPU: 1 PID: 194 Comm: ip Not tainted 5.4.0-rc6-01792-gf4f632e07665-dirty #2062
> [   31.366167] Hardware name: Freescale LS1021A
> [   31.370437] [<c03144dc>] (unwind_backtrace) from [<c030e184>] (show_stack+0x10/0x14)
> [   31.378153] [<c030e184>] (show_stack) from [<c11d1c1c>] (dump_stack+0xe0/0x10c)
> [   31.385437] [<c11d1c1c>] (dump_stack) from [<c034c730>] (__warn+0xf4/0x10c)
> [   31.392373] [<c034c730>] (__warn) from [<c034c7bc>] (warn_slowpath_fmt+0x74/0xb8)
> [   31.399827] [<c034c7bc>] (warn_slowpath_fmt) from [<c11ca204>] (switchdev_port_attr_set_now+0x9c/0xa4)
> [   31.409097] [<c11ca204>] (switchdev_port_attr_set_now) from [<c117036c>] (__br_vlan_filter_toggle+0x6c/0x118)
> [   31.418971] [<c117036c>] (__br_vlan_filter_toggle) from [<c115d010>] (br_changelink+0xf8/0x518)
> [   31.427637] [<c115d010>] (br_changelink) from [<c0f8e9ec>] (__rtnl_newlink+0x3f4/0x76c)
> [   31.435613] [<c0f8e9ec>] (__rtnl_newlink) from [<c0f8eda8>] (rtnl_newlink+0x44/0x60)
> [   31.443329] [<c0f8eda8>] (rtnl_newlink) from [<c0f89f20>] (rtnetlink_rcv_msg+0x2cc/0x51c)
> [   31.451477] [<c0f89f20>] (rtnetlink_rcv_msg) from [<c1008df8>] (netlink_rcv_skb+0xb8/0x110)
> [   31.459796] [<c1008df8>] (netlink_rcv_skb) from [<c1008648>] (netlink_unicast+0x17c/0x1f8)
> [   31.468026] [<c1008648>] (netlink_unicast) from [<c1008980>] (netlink_sendmsg+0x2bc/0x3b4)
> [   31.476261] [<c1008980>] (netlink_sendmsg) from [<c0f43858>] (___sys_sendmsg+0x230/0x250)
> [   31.484408] [<c0f43858>] (___sys_sendmsg) from [<c0f44c84>] (__sys_sendmsg+0x50/0x8c)
> [   31.492209] [<c0f44c84>] (__sys_sendmsg) from [<c0301000>] (ret_fast_syscall+0x0/0x28)
> [   31.500090] Exception stack(0xedf47fa8 to 0xedf47ff0)
> [   31.505122] 7fa0:                   00000002 b6f2e060 00000003 beabd6a4 00000000 00000000
> [   31.513265] 7fc0: 00000002 b6f2e060 5d6e3213 00000128 00000000 00000001 00000006 000619c4
> [   31.521405] 7fe0: 00086078 beabd658 0005edbc b6e7ce68
> 
> The reason is the implementation of br_get_pvid:
> 
> static inline u16 br_get_pvid(const struct net_bridge_vlan_group *vg)
> {
> 	if (!vg)
> 		return 0;
> 
> 	smp_rmb();
> 	return vg->pvid;
> }
> 
> Since VID 0 is an invalid pvid from the bridge's point of view, let's
> add this check in dsa_8021q_restore_pvid to avoid restoring a pvid that
> doesn't really exist.
> 
> Fixes: 5f33183b7fdf ("net: dsa: tag_8021q: Restore bridge VLANs when enabling vlan_filtering")
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
