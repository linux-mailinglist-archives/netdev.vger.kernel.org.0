Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 264A42CF37F
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 19:01:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728553AbgLDSBE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 13:01:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:42306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726405AbgLDSBE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Dec 2020 13:01:04 -0500
Date:   Fri, 4 Dec 2020 10:00:21 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607104823;
        bh=LnogAlczYYRk55K0dSmjMxTp0ZqR4yvG50Rywdgs/78=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=RnHTKb5REVzot0htlQVNnyaDUrUhg6N6TTX7k9KtPcQjR6RFL5s+OTd/VPpCcrH3V
         946exCo4cWIegBhlOYANLerIgAt3KVR1kHlYPt6RP/YOjsFUuLw6bivafRT6iFOPHa
         8nqQ5iiWQxc7LLlA3wGcfudi9BpefOftIGrpud9+Ij1nUBtI7/vzcSBD7YyMGzMwxB
         +6I+8LS9K+wWy5+HmPIxy6GHBWZX3Wt+xj/kbMk+KLj7E2QBszwW4pLXSHNsSGlyKV
         KvM4OX60QwyQYq3RhbAEGPC7F0FkcfTsbp86LFxMPuq9QVg/LCCNctsO+015Mf+vgY
         uApgdDTRMbwdQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        "Allan W . Nielsen" <allan.nielsen@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Steen Hegelund <steen.hegelund@microchip.com>
Subject: Re: [PATCH v2 net] net: mscc: ocelot: install MAC addresses in
 .ndo_set_rx_mode from process context
Message-ID: <20201204100021.0b026725@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201204175125.1444314-1-vladimir.oltean@nxp.com>
References: <20201204175125.1444314-1-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  4 Dec 2020 19:51:25 +0200 Vladimir Oltean wrote:
> Currently ocelot_set_rx_mode calls ocelot_mact_learn directly, which has
> a very nice ocelot_mact_wait_for_completion at the end. Introduced in
> commit 639c1b2625af ("net: mscc: ocelot: Register poll timeout should be
> wall time not attempts"), this function uses readx_poll_timeout which
> triggers a lot of lockdep warnings and is also dangerous to use from
> atomic context, leading to lockups and panics.
> 
> Steen Hegelund added a poll timeout of 100 ms for checking the MAC
> table, a duration which is clearly absurd to poll in atomic context.
> So we need to defer the MAC table access to process context, which we do
> via a dynamically allocated workqueue which contains all there is to
> know about the MAC table operation it has to do.
> 
> Fixes: 639c1b2625af ("net: mscc: ocelot: Register poll timeout should be wall time not attempts")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
> Changes in v2:
> - Added Fixes tag (it won't backport that far, but anyway)
> - Using get_device and put_device to avoid racing with unbind

Does get_device really protect you from unbind? I thought it only
protects you from .release being called, IOW freeing struct device
memory..

More usual way of handling this would be allocating your own workqueue
and flushing that wq at the right point.

>  drivers/net/ethernet/mscc/ocelot_net.c | 83 +++++++++++++++++++++++++-
>  1 file changed, 80 insertions(+), 3 deletions(-)

This is a little large for a rc7 fix :S

What's the expected poll time? maybe it's not that bad to busy wait?
Clearly nobody noticed the issue in 2 years (you mention lockdep so 
not a "real" deadlock) which makes me think the wait can't be that long?

Also for a reference - there are drivers out there with busy poll
timeout of seconds :/


