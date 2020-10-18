Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63010291866
	for <lists+netdev@lfdr.de>; Sun, 18 Oct 2020 18:49:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727185AbgJRQty (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Oct 2020 12:49:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:49612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726613AbgJRQtx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 18 Oct 2020 12:49:53 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F69A2222B;
        Sun, 18 Oct 2020 16:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603039793;
        bh=h+a1Vt070skwp40zl87iBgkHz1karNa8fg8pzLMX5Zg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ad2oDpJg7iParr/YDbPWp0vEYAAqBIZe4U1nQzQNe2JeB0GuU5ZUmsipGnEm5433d
         gOsyGi1YadrD0g2quTOssbZn4NBqo4pI9/B1M8gIG7oe21DfUGIpuswguqnBL39Cp9
         VcAOB3xr30q2AJqXKmxrQIHMUksdscB/G5Bbggtk=
Date:   Sun, 18 Oct 2020 09:49:51 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, Christian Eggers <ceggers@arri.de>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: Re: [RFC PATCH 01/13] net: dsa: add plumbing for custom netdev
 statistics
Message-ID: <20201018094951.0016f208@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201017213611.2557565-2-vladimir.oltean@nxp.com>
References: <20201017213611.2557565-1-vladimir.oltean@nxp.com>
        <20201017213611.2557565-2-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 18 Oct 2020 00:35:59 +0300 Vladimir Oltean wrote:
> DSA needs to push a header onto every packet on TX, and this might cause
> reallocation under certain scenarios, which might affect, for example,
> performance.
> 
> But reallocated packets are not standardized in struct pcpu_sw_netstats,
> struct net_device_stats or anywhere else, it seems, so we need to roll
> our own extra netdevice statistics and expose them to ethtool.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Could you consider adding "driver" stats under RTM_GETSTATS, 
or a similar new structured interface over ethtool?

Looks like the statistic in question has pretty clear semantics,
and may be more broadly useful.

> +/* Driver statistics, other than those in struct rtnl_link_stats64.
> + * These are collected per-CPU and aggregated by ethtool.
> + */
> +struct dsa_slave_stats {
> +	__u64			tx_reallocs;

s/__u/u/

> +	struct u64_stats_sync	syncp;
> +} __aligned(1 * sizeof(u64));

Why aligned to u64? Compiler should pick a reasonable alignment here 
by itself.
