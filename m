Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50FA02918A8
	for <lists+netdev@lfdr.de>; Sun, 18 Oct 2020 19:36:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726906AbgJRRgx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Oct 2020 13:36:53 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:33446 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725776AbgJRRgx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 18 Oct 2020 13:36:53 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kUCbx-002Ky7-51; Sun, 18 Oct 2020 19:36:49 +0200
Date:   Sun, 18 Oct 2020 19:36:49 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        Christian Eggers <ceggers@arri.de>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: Re: [RFC PATCH 01/13] net: dsa: add plumbing for custom netdev
 statistics
Message-ID: <20201018173649.GF456889@lunn.ch>
References: <20201017213611.2557565-1-vladimir.oltean@nxp.com>
 <20201017213611.2557565-2-vladimir.oltean@nxp.com>
 <20201018094951.0016f208@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201018094951.0016f208@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 18, 2020 at 09:49:51AM -0700, Jakub Kicinski wrote:
> > +	struct u64_stats_sync	syncp;
> > +} __aligned(1 * sizeof(u64));
> 
> Why aligned to u64? Compiler should pick a reasonable alignment here 
> by itself.

Hi Jakub

I wondered that as well. But:

struct gnet_stats_basic_cpu {
        struct gnet_stats_basic_packed bstats;
        struct u64_stats_sync syncp;
} __aligned(2 * sizeof(u64));

/* often modified stats are per-CPU, other are shared (netdev->stats) */
struct pcpu_sw_netstats {
        u64     rx_packets;
        u64     rx_bytes;
        u64     tx_packets;
        u64     tx_bytes;
        struct u64_stats_sync   syncp;
} __aligned(4 * sizeof(u64));

struct pcpu_lstats {
        u64_stats_t packets;
        u64_stats_t bytes;
        struct u64_stats_sync syncp;
} __aligned(2 * sizeof(u64));

Cargo cult or is there a real need?

      Andrew
