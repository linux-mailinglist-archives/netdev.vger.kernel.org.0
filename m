Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FFD24BB46A
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 09:40:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232746AbiBRIk1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 03:40:27 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232743AbiBRIkY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 03:40:24 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F8502B354A
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 00:40:05 -0800 (PST)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1nKyo1-000675-Ag; Fri, 18 Feb 2022 09:39:57 +0100
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1nKyo0-0001O4-2y; Fri, 18 Feb 2022 09:39:56 +0100
Date:   Fri, 18 Feb 2022 09:39:56 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, kernel@pengutronix.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v1 1/1] net: dsa: microchip: ksz9477: export HW
 stats over stats64 interface
Message-ID: <20220218083956.GA4681@pengutronix.de>
References: <20220217140726.248071-1-o.rempel@pengutronix.de>
 <20220217155554.bo6gcva6h2pkryou@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220217155554.bo6gcva6h2pkryou@skbuf>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 09:37:36 up 69 days, 17:23, 83 users,  load average: 0.83, 0.51,
 0.31
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

On Thu, Feb 17, 2022 at 05:55:54PM +0200, Vladimir Oltean wrote:
> On Thu, Feb 17, 2022 at 03:07:26PM +0100, Oleksij Rempel wrote:
> > +static void ksz9477_get_stats64(struct dsa_switch *ds, int port,
> > +				struct rtnl_link_stats64 *stats)
> > +{
> > +	struct ksz_device *dev = ds->priv;
> > +	struct ksz9477_stats_raw *raw;
> > +	struct ksz_port_mib *mib;
> > +	int ret;
> > +
> > +	mib = &dev->ports[port].mib;
> > +	raw = (struct ksz9477_stats_raw *)mib->counters;
> > +
> > +	mutex_lock(&mib->cnt_mutex);
> 
> The eternal problem, ndo_get_stats64 runs in atomic context,
> mutex_lock() sleeps. Please test your patches with
> CONFIG_DEBUG_ATOMIC_SLEEP=y.

Good point, thx! I reworked the code.

Beside, I get this warning with differnt locking validators:
[  153.140000] br0: port 1(lan2) entered blocking state
[  153.190000] br0: port 1(lan2) entered disabled state
[  153.320000] device lan2 entered promiscuous mode
[  153.350000] ------------[ cut here ]------------
[  153.350000] WARNING: CPU: 0 PID: 71 at net/core/dev.c:7913 __dev_set_promiscuity+0x10c/0x138
[  153.360000] RTNL: assertion failed at net/core/dev.c (7913)
[  153.370000] Modules linked in: atmel_aes atmel_tdes atmel_sha
[  153.370000] CPU: 0 PID: 71 Comm: kworker/u2:5 Not tainted 5.17.0-rc2-00714-g845f6fa17e48-dirty #33
[  153.370000] Hardware name: Atmel SAMA5
[  153.370000] Workqueue: dsa_ordered dsa_slave_switchdev_event_work
[  153.370000]  unwind_backtrace from show_stack+0x18/0x1c
[  153.370000]  show_stack from dump_stack_lvl+0x58/0x70
[  153.370000]  dump_stack_lvl from __warn+0xd8/0x228
[  153.370000]  __warn from warn_slowpath_fmt+0x98/0xc8
[  153.370000]  warn_slowpath_fmt from __dev_set_promiscuity+0x10c/0x138
[  153.370000]  __dev_set_promiscuity from __dev_set_rx_mode+0x8c/0x98
[  153.370000]  __dev_set_rx_mode from dev_uc_add+0x84/0x8c
[  153.370000]  dev_uc_add from dsa_port_host_fdb_add+0x48/0x80
[  153.370000]  dsa_port_host_fdb_add from dsa_slave_switchdev_event_work+0x1dc/0x254
[  153.370000]  dsa_slave_switchdev_event_work from process_one_work+0x2b0/0x7d4
[  153.370000]  process_one_work from worker_thread+0x4c/0x53c
[  153.370000]  worker_thread from kthread+0xf8/0x12c
[  153.370000]  kthread from ret_from_fork+0x14/0x2c
[  153.370000] Exception stack(0xc1f13fb0 to 0xc1f13ff8)
[  153.370000] 3fa0:                                     00000000 00000000 00000000 00000000
[  153.370000] 3fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[  153.370000] 3fe0: 00000000 00000000 00000000 00000000 00000013 00000000
[  153.380000] irq event stamp: 0
[  153.390000] hardirqs last  enabled at (0): [<00000000>] 0x0
[  153.390000] hardirqs last disabled at (0): [<c0124b38>] copy_process+0x7d8/0x194c
[  153.400000] softirqs last  enabled at (0): [<c0124b38>] copy_process+0x7d8/0x194c
[  153.410000] softirqs last disabled at (0): [<00000000>] 0x0
[  153.410000] ---[ end trace 0000000000000000 ]---
[  153.420000] device eth0 entered promiscuous mode
[  153.770000] ksz9477-switch spi1.0 lan2: configuring for phy/gmii link mode
[  155.040000] ksz9477-switch spi1.0 lan4: Link is Down
[  156.960000] ksz9477-switch spi1.0 lan2: Link is Up - 1Gbps/Full - flow control rx/tx


Is it something known?

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
