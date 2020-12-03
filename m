Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D76092CDCD0
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 18:54:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731532AbgLCRyL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 12:54:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731158AbgLCRyL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 12:54:11 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC102C061A4E
        for <netdev@vger.kernel.org>; Thu,  3 Dec 2020 09:53:30 -0800 (PST)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1kksnC-00083s-SV; Thu, 03 Dec 2020 18:53:22 +0100
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1kksnA-0005tE-GO; Thu, 03 Dec 2020 18:53:20 +0100
Date:   Thu, 3 Dec 2020 18:53:20 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org
Subject: Re: [PATCH v3 net-next 2/2] net: dsa: qca: ar9331: export stats64
Message-ID: <20201203175320.f3fmyaqoxifydwzv@pengutronix.de>
References: <20201202140904.24748-1-o.rempel@pengutronix.de>
 <20201202140904.24748-3-o.rempel@pengutronix.de>
 <20201202104207.697cfdbb@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <20201203085011.GA3606@pengutronix.de>
 <20201203083517.3b616782@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201203083517.3b616782@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 18:42:17 up 1 day,  7:48, 21 users,  load average: 0.06, 0.06, 0.01
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 03, 2020 at 08:35:17AM -0800, Jakub Kicinski wrote:
> On Thu, 3 Dec 2020 09:50:11 +0100 Oleksij Rempel wrote:
> > @Jakub,
> > 
> > > You can't take sleeping locks from .ndo_get_stats64.
> > > 
> > > Also regmap may sleep?
> > > 
> > > +	ret = regmap_read(priv->regmap, reg, &val);  
> > 
> > Yes. And underling layer is mdio bus which is by default sleeping as
> > well.
> > 
> > > Am I missing something?  
> > 
> > In this log, the  ar9331_get_stats64() was never called from atomic or
> > irq context. Why it should not be sleeping?
> 
> You missed some long discussions about this within last week on netdev.
> Also Documentation/networking/statistics.rst.
> 
> To answer your direct question - try:
> 
> # cat /proc/net/dev
> 
> procfs iterates over devices while holding only an RCU read lock.

Now i can reproduce it :)

[33683.199864] BUG: sleeping function called from invalid context at kernel/locking/mutex.c:935
[33683.210737] in_atomic(): 0, irqs_disabled(): 0, non_block: 0, pid: 593, name: cat
[33683.216796] INFO: lockdep is turned off.
[33683.222972] CPU: 0 PID: 593 Comm: cat Not tainted 5.10.0-rc3-ar9331-00733-gff7090915bb7-dirty #28
[33683.231743] Stack : 808f0000 80885ffc 820eba5c 00000000 00000000 d4a19200 80980000 819a93c8
[33683.240093]         80980ca7 80d43358 804ee1f4 80980000 00000002 800afe08 820eba08 d4a19200
[33683.247181]         00000000 00000000 8089ffb0 00000000 820ebfe0 00000000 00000000 00000000
[33683.257767]         820ebab4 77bbfdc0 00fae587 77e859a0 80980000 80000000 00000000 80990000
[33683.266107]         804ee1f4 80980000 00000002 8200f750 8097ca9c d4a19200 000859df 00000001
[33683.274529]         ...
[33683.275626] Call Trace:
[33683.280156] [<80069ce0>] show_stack+0x9c/0x140
[33683.283200] [<800afe08>] ___might_sleep+0x220/0x244
[33683.290441] [<8073c030>] __mutex_lock+0x70/0x374
[33683.293651] [<8073c360>] mutex_lock_nested+0x2c/0x38
[33683.300793] [<804ee1f4>] ar9331_read_stats+0x34/0x834
[33683.304441] [<804eea34>] ar9331_get_stats64+0x40/0x394
[33683.311797] [<80526584>] dev_get_stats+0x58/0xfc
[33683.315013] [<805657bc>] dev_seq_printf_stats+0x44/0x228
[33683.322476] [<805659e8>] dev_seq_show+0x48/0x50
[33683.325601] [<8021dd28>] seq_read_iter+0x3d8/0x4d0
[33683.332585] [<8021df60>] seq_read+0x140/0x198
[33683.335532] [<8026f950>] proc_reg_read+0xe4/0xf8
[33683.342397] [<801f0840>] vfs_read+0xc8/0x1a8
[33683.345260] [<801f0b7c>] ksys_read+0x9c/0xfc
[33683.352056] [<80071aa4>] syscall_common+0x34/0x58

Hm.. There is no way i can guarantee that underlying mdio system is
not using mutexes. So, i can't read stats directly from HW within
ar9331_get_stats64(), only driver internal storage can be used. It is possible
to poll it more frequently, but  it make no reals sense on this low power
devices.

What kind of options do we have?

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
