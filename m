Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 530F0FF571
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 21:25:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727420AbfKPUZB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Nov 2019 15:25:01 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:53334 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727115AbfKPUZB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Nov 2019 15:25:01 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BF7BE15172458;
        Sat, 16 Nov 2019 12:25:00 -0800 (PST)
Date:   Sat, 16 Nov 2019 12:25:00 -0800 (PST)
Message-Id: <20191116.122500.1947417671610186623.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        netdev@vger.kernel.org
Subject: Re: [PATCH net] net: dsa: tag_8021q: Fix dsa_8021q_restore_pvid
 for an absent pvid
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191116160825.29232-1-olteanv@gmail.com>
References: <20191116160825.29232-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 16 Nov 2019 12:25:01 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Sat, 16 Nov 2019 18:08:25 +0200

> This sequence of operations:
> ip link set dev br0 type bridge vlan_filtering 1
> bridge vlan del dev swp2 vid 1
> ip link set dev br0 type bridge vlan_filtering 1
> ip link set dev br0 type bridge vlan_filtering 0
> 
> apparently fails with the message:
 ...
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

Applied, thanks.
