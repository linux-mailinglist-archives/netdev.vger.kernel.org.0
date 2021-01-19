Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6DBE2FC26E
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 22:37:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727801AbhASVfX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 16:35:23 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:48514 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726134AbhASV2I (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Jan 2021 16:28:08 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1l1yX4-001WV7-2E; Tue, 19 Jan 2021 22:27:22 +0100
Date:   Tue, 19 Jan 2021 22:27:22 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek Vasut <marex@denx.de>
Cc:     netdev@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next] net: dsa: microchip: ksz8795: Fix KSZ8794 port
 map again
Message-ID: <YAdOuvUfa2ZdtaX6@lunn.ch>
References: <20210119205518.470974-1-marex@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210119205518.470974-1-marex@denx.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 19, 2021 at 09:55:18PM +0100, Marek Vasut wrote:
> The KSZ8795 switch has 4 external ports {0,1,2,3} and 1 CPU port {4}, so
> does the KSZ8765. The KSZ8794 seems to be repackaged KSZ8795 with different
> ID and port 3 not routed out, however the port 3 registers are present in
> the silicon, so the KSZ8794 switch has 3 external ports {0,1,2} and 1 CPU
> port {4}. Currently the driver always uses the last port as CPU port, on
> KSZ8795/KSZ8765 that is port 4 and that is OK, but on KSZ8794 that is port
> 3 and that is not OK, as it must also be port 4.
> 
> This patch adjusts the driver such that it always registers a switch with
> 5 ports total (4 external ports, 1 CPU port), always sets the CPU port to
> switch port 4, and then configures the external port mask according to
> the switch model -- 3 ports for KSZ8794 and 4 for KSZ8795/KSZ8765.

Hi Marek

What appears to be missing is any checks for somebody trying to use
the 'somewhat non-existent' port.

Assuming all the drivers set dev->port_mask properly, i think you can
add a check to ksz_enable_port() and return -EINVAL if the requested
port is not a member of port_mask.

     Andrew
