Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DDAD5A5C3A
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 08:55:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230062AbiH3Gzs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 02:55:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229939AbiH3Gzm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 02:55:42 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1D7642AE1
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 23:55:38 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1oSv9s-0003o2-Ev; Tue, 30 Aug 2022 08:55:36 +0200
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1oSv9p-0005Jg-M3; Tue, 30 Aug 2022 08:55:33 +0200
Date:   Tue, 30 Aug 2022 08:55:33 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        =?utf-8?B?U8O4cmVu?= Andersen <san@skov.dk>
Subject: Re: [Patch net-next v2 0/9] net: dsa: microchip: add support for
 phylink mac config and link up
Message-ID: <20220830065533.GA18106@pengutronix.de>
References: <20220724092823.24567-1-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220724092823.24567-1-arun.ramadoss@microchip.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Arun,

starting with this patch set I have following regression on ksz8873
switch. Can you please take a look at it:
 8<--- cut here ---
 Unable to handle kernel NULL pointer dereference at virtual address 00000005
 ksz8863-switch gpio-0:00: nonfatal error -34 setting MTU to 1500 on port 0
...
 Modules linked in:                                          
 CPU: 0 PID: 16 Comm: kworker/0:1 Not tainted 6.0.0-rc2-00436-g3da285df1324 #74
 Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
 Workqueue: events_power_efficient phylink_resolve
 PC is at ksz_set_gbit+0x5c/0xa4
 LR is at arch_atomic_cmpxchg_relaxed+0x1c/0x38
....
 Backtrace: 
  ksz_set_gbit from ksz_phylink_mac_link_up+0x15c/0x1c8
  ksz_phylink_mac_link_up from dsa_port_phylink_mac_link_up+0x7c/0x80
  dsa_port_phylink_mac_link_up from phylink_resolve+0x304/0x3d0
  phylink_resolve from process_one_work+0x214/0x31c
  process_one_work from worker_thread+0x254/0x2d4
  worker_thread from kthread+0xfc/0x108
  kthread from ret_from_fork+0x14/0x2c
...
 ksz8863-switch gpio-0:00 lan2 (uninitialized): PHY [dsa-0.0:01] driver [Micrel KSZ8851 Ethernet MAC or KSZ886X Switch] (irq=POLL)
 ksz8863-switch gpio-0:00: nonfatal error -34 setting MTU to 1500 on port 1
 device eth0 entered promiscuous mode
 DSA: tree 0 setup
 ---[ end trace 0000000000000000 ]---

Regards,
Oleksij

On Sun, Jul 24, 2022 at 02:58:14PM +0530, Arun Ramadoss wrote:
> This patch series add support common phylink mac config and link up for the ksz
> series switches. At present, ksz8795 and ksz9477 doesn't implement the phylink
> mac config and link up. It configures the mac interface in the port setup hook.
> ksz8830 series switch does not mac link configuration. For lan937x switches, in
> the part support patch series has support only for MII and RMII configuration.
> Some group of switches have some register address and bit fields common and
> others are different. So, this patch aims to have common phylink implementation
> which configures the register based on the chip id.

> Changes in v2
> - combined the modification of duplex, tx_pause and rx_pause into single
>   function.
> 
> Changes in v1
> - Squash the reading rgmii value from dt to patch which apply the rgmii value
> - Created the new function ksz_port_set_xmii_speed
> - Seperated the namespace values for xmii_ctrl_0 and xmii_ctrl_1 register
> - Applied the rgmii delay value based on the rx/tx-internal-delay-ps
> 
> Arun Ramadoss (9):
>   net: dsa: microchip: add common gigabit set and get function
>   net: dsa: microchip: add common ksz port xmii speed selection function
>   net: dsa: microchip: add common duplex and flow control function
>   net: dsa: microchip: add support for common phylink mac link up
>   net: dsa: microchip: lan937x: add support for configuing xMII register
>   net: dsa: microchip: apply rgmii tx and rx delay in phylink mac config
>   net: dsa: microchip: ksz9477: use common xmii function
>   net: dsa: microchip: ksz8795: use common xmii function
>   net: dsa: microchip: add support for phylink mac config
> 
>  drivers/net/dsa/microchip/ksz8795.c      |  40 ---
>  drivers/net/dsa/microchip/ksz8795_reg.h  |   8 -
>  drivers/net/dsa/microchip/ksz9477.c      | 183 +------------
>  drivers/net/dsa/microchip/ksz9477_reg.h  |  24 --
>  drivers/net/dsa/microchip/ksz_common.c   | 312 ++++++++++++++++++++++-
>  drivers/net/dsa/microchip/ksz_common.h   |  54 ++++
>  drivers/net/dsa/microchip/lan937x.h      |   8 +-
>  drivers/net/dsa/microchip/lan937x_main.c | 125 +++------
>  drivers/net/dsa/microchip/lan937x_reg.h  |  32 ++-
>  9 files changed, 431 insertions(+), 355 deletions(-)
> 
> 
> base-commit: 502c6f8cedcce7889ccdefeb88ce36b39acd522f
> -- 
> 2.36.1
> 

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
