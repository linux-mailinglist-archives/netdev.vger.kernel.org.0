Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D61B4D9A7D
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 12:38:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238773AbiCOLj7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 07:39:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235775AbiCOLj6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 07:39:58 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A11D7B846
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 04:38:46 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1nU5Vi-0000dI-J1; Tue, 15 Mar 2022 12:38:42 +0100
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1nU5Vh-0005vj-Ee; Tue, 15 Mar 2022 12:38:41 +0100
Date:   Tue, 15 Mar 2022 12:38:41 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Lukas Wunner <lukas@wunner.de>
Cc:     Andrew Lunn <andrew@lunn.ch>, Oliver Neukum <oneukum@suse.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: ordering of call to unbind() in usbnet_disconnect
Message-ID: <20220315113841.GA22337@pengutronix.de>
References: <62b944a1-0df2-6e81-397c-6bf9dea266ef@suse.com>
 <20220310113820.GG15680@pengutronix.de>
 <20220314184234.GA556@wunner.de>
 <Yi+UHF37rb0URSwb@lunn.ch>
 <20220315054403.GA14588@pengutronix.de>
 <20220315083234.GA27883@wunner.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220315083234.GA27883@wunner.de>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 12:37:39 up 94 days, 20:23, 94 users,  load average: 0.31, 0.20,
 0.12
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

On Tue, Mar 15, 2022 at 09:32:34AM +0100, Lukas Wunner wrote:
> On Tue, Mar 15, 2022 at 06:44:03AM +0100, Oleksij Rempel wrote:
> > On Mon, Mar 14, 2022 at 08:14:36PM +0100, Andrew Lunn wrote:
> > > On Mon, Mar 14, 2022 at 07:42:34PM +0100, Lukas Wunner wrote:
> > > > On Thu, Mar 10, 2022 at 12:38:20PM +0100, Oleksij Rempel wrote:
> > > > > On Thu, Mar 10, 2022 at 12:25:08PM +0100, Oliver Neukum wrote:
> > > > > > I got bug reports that 2c9d6c2b871d ("usbnet: run unbind() before
> > > > > > unregister_netdev()") is causing regressions.
> > > > > > Rather than simply reverting it,
> > > > > > it seems to me that the call needs to be split. One in the old place
> > > > > > and one in the place you moved it to.
> > > > 
> > > > I disagree.  The commit message claims that the change is necessary
> > > > because phy_disconnect() fails if called with
> > > > phydev->attached_dev == NULL.
> > > 
> > > The only place i see which sets phydev->attached_dev is
> > > phy_attach_direct(). So if phydev->attached_dev is NULL, the PHY has
> > > not been attached, and hence there is no need to call
> > > phy_disconnect().
> > 
> > phydev->attached_dev is not NULL.
> 
> Right, I was mistaken, sorry.
> 
> 
> > It was linked to unregistered/freed
> > netdev. This is why my patch changing the order to call phy_disconnect()
> > first and then unregister_netdev().
> 
> Unregistered yes, but freed no.  Here's the order before 2c9d6c2b871d:
> 
>   usbnet_disconnect()
>     unregister_netdev()
>     ax88772_unbind()
>       phy_disconnect()
>     free_netdev()
> 
> Is it illegal to disconnect a PHY from an unregistered, but not yet freed
> net_device?
> 
> Oleksij, the commit message of 2c9d6c2b871d says that disconnecting the
> PHY "fails" in that situation.  Please elaborate what the failure looked
> like.  Did you get a stacktrace?

[   15.459655] asix 2-1.2:1.0 eth1: Link is Up - 100Mbps/Full - flow control off
[   30.600242] usb 2-1.2: USB disconnect, device number 3
[   30.611962] asix 2-1.2:1.0 eth1: unregister 'asix' usb-ci_hdrc.1-1.2, ASIX AX88772B USB 2.0 Ethernet
[   30.649173] asix 2-1.2:1.0 eth1 (unregistered): Failed to write reg index 0x0000: -19
[   30.657027] asix 2-1.2:1.0 eth1 (unregistered): Failed to write Medium Mode mode to 0x0000: ffffffed
[   30.683006] asix 2-1.2:1.0 eth1 (unregistered): Link is Down
[   30.689512] asix 2-1.2:1.0 eth1 (unregistered): Failed to write reg index 0x0000: -19
[   30.697359] asix 2-1.2:1.0 eth1 (unregistered): Failed to enable software MII access
[   30.706009] asix 2-1.2:1.0 eth1 (unregistered): Failed to write reg index 0x0000: -19
[   30.714277] asix 2-1.2:1.0 eth1 (unregistered): Failed to enable software MII access
[   30.732689] 8<--- cut here ---
[   30.735757] Unable to handle kernel paging request at virtual address 2e839000
[   30.742984] pgd = af824ad7
[   30.745695] [2e839000] *pgd=00000000
[   30.749282] Internal error: Oops: 5 [#1] PREEMPT SMP ARM
[   30.754602] Modules linked in:
[   30.757663] CPU: 0 PID: 77 Comm: kworker/0:2 Not tainted 5.13.0-rc3-00818-g06edf1a940be #2
[   30.765934] Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
[   30.772466] Workqueue: events linkwatch_event
[   30.776841] PC is at linkwatch_do_dev+0x6c/0x88
[   30.781380] LR is at __local_bh_enable_ip+0x6c/0x100
[   30.786356] pc : [<c08637f4>]    lr : [<c013e5c4>]    psr: 60030093
[   30.792625] sp : c1d2bed8  ip : 00000001  fp : c28d2000
[   30.797852] r10: c0fcf19c  r9 : c0fcf170  r8 : 00000000
[   30.803080] r7 : c102f044  r6 : c1d2beec  r5 : 00000063  r4 : c28d2000
[   30.809611] r3 : 00000000  r2 : 00000000  r1 : 2e839000  r0 : 60030013
[   30.816140] Flags: nZCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segment none
[   30.823367] Control: 10c5387d  Table: 12b54059  DAC: 00000051
[   30.829114] Register r0 information: non-paged memory
[   30.834174] Register r1 information: non-paged memory
[   30.839231] Register r2 information: NULL pointer
[   30.843941] Register r3 information: NULL pointer
[   30.848649] Register r4 information: slab kmalloc-2k start c28d2000 pointer offset 0 size 2048
[   30.857287] Register r5 information: non-paged memory
[   30.862344] Register r6 information: non-slab/vmalloc memory
[   30.868008] Register r7 information: non-slab/vmalloc memory
[   30.873673] Register r8 information: NULL pointer
[   30.878381] Register r9 information: non-slab/vmalloc memory
[   30.884045] Register r10 information: non-slab/vmalloc memory
[   30.889797] Register r11 information: slab kmalloc-2k start c28d2000 pointer offset 0 size 2048
[   30.898516] Register r12 information: non-paged memory
[   30.903662] Process kworker/0:2 (pid: 77, stack limit = 0xded42e9b)
[   30.909935] Stack: (0xc1d2bed8 to 0xc1d2c000)
[   30.914298] bec0:                                                       c28d22cc c0863a48
[   30.922481] bee0: 00000000 c1d2a000 00000008 c1d2beec c1d2beec 73675768 c1d4da84 c0fcf170
[   30.930663] bf00: c1ce0d80 ef6d28c0 ef6d5c00 00000000 00000000 c0fed000 ef6d28c0 c0863b8c
[   30.938844] bf20: c0fcf170 c0155550 c1d2a000 c0a13fd4 ef6d28d8 c1ce0d80 ef6d28c0 c1ce0d94
[   30.947026] bf40: ef6d28d8 c0f03d00 00000008 c1d2a000 ef6d28c0 c0155dc0 c1003e48 c0fec754
[   30.955208] bf60: c1ce75e4 c1ce75c0 c1ce7fc0 c1d2a000 00000000 c1931eb4 c0155d5c c1ce0d80
[   30.963389] bf80: c1ce75e4 c015bacc 00000000 c1ce7fc0 c015b954 00000000 00000000 00000000
[   30.971570] bfa0: 00000000 00000000 00000000 c0100150 00000000 00000000 00000000 00000000
[   30.979750] bfc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[   30.987931] bfe0: 00000000 00000000 00000000 00000000 00000013 00000000 00000000 00000000
[   30.996114] [<c08637f4>] (linkwatch_do_dev) from [<c0863a48>] (__linkwatch_run_queue+0xe0/0x1f0)
[   31.004917] [<c0863a48>] (__linkwatch_run_queue) from [<c0863b8c>] (linkwatch_event+0x34/0x3c)
[   31.013540] [<c0863b8c>] (linkwatch_event) from [<c0155550>] (process_one_work+0x20c/0x5d0)
[   31.021911] [<c0155550>] (process_one_work) from [<c0155dc0>] (worker_thread+0x64/0x570)
[   31.030010] [<c0155dc0>] (worker_thread) from [<c015bacc>] (kthread+0x178/0x190)
[   31.037421] [<c015bacc>] (kthread) from [<c0100150>] (ret_from_fork+0x14/0x24)
[   31.044654] Exception stack(0xc1d2bfb0 to 0xc1d2bff8)
[   31.049710] bfa0:                                     00000000 00000000 00000000 00000000
[   31.057891] bfc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[   31.066071] bfe0: 00000000 00000000 00000000 00000000 00000013 00000000
[   31.072692] Code: e10f0000 f10c0080 e59432c8 ee1d1f90 (e7932001) 
[   31.078788] ---[ end trace f80581862631ce84 ]---

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
