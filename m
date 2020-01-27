Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 445A014A18A
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 11:13:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729465AbgA0KNc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 05:13:32 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:36990 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727233AbgA0KNc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 05:13:32 -0500
Received: from localhost (unknown [213.175.37.12])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D405615128942;
        Mon, 27 Jan 2020 02:13:29 -0800 (PST)
Date:   Mon, 27 Jan 2020 11:13:27 +0100 (CET)
Message-Id: <20200127.111327.391981642587628280.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        netdev@vger.kernel.org, marek.behun@nic.cz, vladimir.oltean@nxp.com
Subject: Re: [PATCH net] net: dsa: Fix use-after-free in probing of DSA
 switch tree
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200125210111.22058-1-olteanv@gmail.com>
References: <20200125210111.22058-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 27 Jan 2020 02:13:31 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Sat, 25 Jan 2020 23:01:11 +0200

> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> DSA sets up a switch tree little by little. Every switch of the N
> members of the tree calls dsa_register_switch, and (N - 1) will just
> touch the dst->ports list with their ports and quickly exit. Only the
> last switch that calls dsa_register_switch will find all DSA links
> complete in dsa_tree_setup_routing_table, and not return zero as a
> result but instead go ahead and set up the entire DSA switch tree
> (practically on behalf of the other switches too).
> 
> The trouble is that the (N - 1) switches don't clean up after themselves
> after they get an error such as EPROBE_DEFER. Their footprint left in
> dst->ports by dsa_switch_touch_ports is still there. And switch N, the
> one responsible with actually setting up the tree, is going to work with
> those stale dp, dp->ds and dp->ds->dev pointers. In particular ds and
> ds->dev might get freed by the device driver.
> 
> Be there a 2-switch tree and the following calling order:
> - Switch 1 calls dsa_register_switch
>   - Calls dsa_switch_touch_ports, populates dst->ports
>   - Calls dsa_port_parse_cpu, gets -EPROBE_DEFER, exits.
> - Switch 2 calls dsa_register_switch
>   - Calls dsa_switch_touch_ports, populates dst->ports
>   - Probe doesn't get deferred, so it goes ahead.
>   - Calls dsa_tree_setup_routing_table, which returns "complete == true"
>     due to Switch 1 having called dsa_switch_touch_ports before.
>   - Because the DSA links are complete, it calls dsa_tree_setup_switches
>     now.
>   - dsa_tree_setup_switches iterates through dst->ports, initializing
>     the Switch 1 ds structure (invalid) and the Switch 2 ds structure
>     (valid).
>   - Undefined behavior (use after free, sometimes NULL pointers, etc).
> 
> Real example below (debugging prints added by me, as well as guards
> against NULL pointers):
 ...
> The solution is to recognize that the functions that call
> dsa_switch_touch_ports (dsa_switch_parse_of, dsa_switch_parse) have side
> effects, and therefore one should clean up their side effects on error
> path. The cleanup of dst->ports was taken from dsa_switch_remove and
> moved into a dedicated dsa_switch_release_ports function, which should
> really be per-switch (free only the members of dst->ports that are also
> members of ds, instead of all switch ports).
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Applied, thank you.
