Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 686875A225A
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 09:53:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245715AbiHZHxp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 03:53:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245731AbiHZHxj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 03:53:39 -0400
Received: from bmailout1.hostsharing.net (bmailout1.hostsharing.net [IPv6:2a01:37:1000::53df:5f64:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BA84D3EF8;
        Fri, 26 Aug 2022 00:53:35 -0700 (PDT)
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
         client-signature RSA-PSS (4096 bits) client-digest SHA256)
        (Client CN "*.hostsharing.net", Issuer "RapidSSL TLS DV RSA Mixed SHA256 2020 CA-1" (verified OK))
        by bmailout1.hostsharing.net (Postfix) with ESMTPS id B9BAF30002503;
        Fri, 26 Aug 2022 09:53:31 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id A6DE64F247; Fri, 26 Aug 2022 09:53:31 +0200 (CEST)
Date:   Fri, 26 Aug 2022 09:53:31 +0200
From:   Lukas Wunner <lukas@wunner.de>
To:     Marek Szyprowski <m.szyprowski@samsung.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org,
        Steve Glendinning <steve.glendinning@shawell.net>,
        UNGLinuxDriver@microchip.com, Oliver Neukum <oneukum@suse.com>,
        Andre Edich <andre.edich@microchip.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Martyn Welch <martyn.welch@collabora.com>,
        Gabriel Hojda <ghojda@yo2urs.ro>,
        Christoph Fritz <chf.fritz@googlemail.com>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Philipp Rosenberger <p.rosenberger@kunbus.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>,
        Ferry Toth <fntoth@gmail.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        'Linux Samsung SOC' <linux-samsung-soc@vger.kernel.org>
Subject: Re: [PATCH net-next v3 5/7] usbnet: smsc95xx: Forward PHY interrupts
 to PHY driver to avoid polling
Message-ID: <20220826075331.GA32117@wunner.de>
References: <cover.1652343655.git.lukas@wunner.de>
 <748ac44eeb97b209f66182f3788d2a49d7bc28fe.1652343655.git.lukas@wunner.de>
 <CGME20220517101846eucas1p2c132f7e7032ed00996e222e9cc6cdf99@eucas1p2.samsung.com>
 <a5315a8a-32c2-962f-f696-de9a26d30091@samsung.com>
 <20220519190841.GA30869@wunner.de>
 <31baa38c-b2c7-10cd-e9cd-eee140f01788@samsung.com>
 <e598a232-6c78-782a-316f-77902644ad6c@samsung.com>
 <20220826071924.GA21264@wunner.de>
 <2b1a1588-505e-dff3-301d-bfc1fb14d685@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2b1a1588-505e-dff3-301d-bfc1fb14d685@samsung.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 26, 2022 at 09:41:46AM +0200, Marek Szyprowski wrote:
> On 26.08.2022 09:19, Lukas Wunner wrote:
> > On Fri, Aug 26, 2022 at 08:51:58AM +0200, Marek Szyprowski wrote:
> >> On 19.05.2022 23:22, Marek Szyprowski wrote:
> >>> On 19.05.2022 21:08, Lukas Wunner wrote:
> >>>> On Tue, May 17, 2022 at 12:18:45PM +0200, Marek Szyprowski wrote:
> >>>>> This patch landed in the recent linux next-20220516 as commit
> >>>>> 1ce8b37241ed ("usbnet: smsc95xx: Forward PHY interrupts to PHY
> >>>>> driver to
> >>>>> avoid polling"). Unfortunately it breaks smsc95xx usb ethernet
> >>>>> operation
> >>>>> after system suspend-resume cycle. On the Odroid XU3 board I got the
> >>>>> following warning in the kernel log:
> >>>>>
> >>>>> # time rtcwake -s10 -mmem
> >>>>> rtcwake: wakeup from "mem" using /dev/rtc0 at Tue May 17 09:16:07 2022
> >>>>> PM: suspend entry (deep)
> >>>>> Filesystems sync: 0.001 seconds
> >>>>> Freezing user space processes ... (elapsed 0.002 seconds) done.
> >>>>> OOM killer disabled.
> >>>>> Freezing remaining freezable tasks ... (elapsed 0.001 seconds) done.
> >>>>> printk: Suspending console(s) (use no_console_suspend to debug)
> >>>>> smsc95xx 4-1.1:1.0 eth0: entering SUSPEND2 mode
> >>>>> smsc95xx 4-1.1:1.0 eth0: Failed to read reg index 0x00000114: -113
> >>>>> smsc95xx 4-1.1:1.0 eth0: Error reading MII_ACCESS
> >>>>> smsc95xx 4-1.1:1.0 eth0: __smsc95xx_mdio_read: MII is busy
> >>>>> ------------[ cut here ]------------
> >>>>> WARNING: CPU: 2 PID: 73 at drivers/net/phy/phy.c:946
> >>>>> phy_state_machine+0x98/0x28c
> >>>> [...]
> >>>>> It looks that the driver's suspend/resume operations might need some
> >>>>> adjustments. After the system suspend/resume cycle the driver is not
> >>>>> operational anymore. Reverting the $subject patch on top of linux
> >>>>> next-20220516 restores ethernet operation after system suspend/resume.
> >>>> Thanks a lot for the report. It seems the PHY is signaling a link
> >>>> change
> >>>> shortly before system sleep and by the time the phy_state_machine()
> >>>> worker
> >>>> gets around to handle it, the device has already been suspended and thus
> >>>> refuses any further USB requests with -EHOSTUNREACH (-113):
> > [...]
> >>>> Assuming the above theory is correct, calling phy_stop_machine()
> >>>> after usbnet_suspend() would be sufficient to fix the issue.
> >>>> It cancels the phy_state_machine() worker.
> >>>>
> >>>> The small patch below does that. Could you give it a spin?
> >>> That's it. Your analysis is right and the patch fixes the issue. Thanks!
> >>>
> >>> Feel free to add:
> >>>
> >>> Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
> >>>
> >>> Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
> >> Gentle ping for the final patch...
> > Hm?  Actually this issue is supposed to be fixed by mainline commit
> > 1758bde2e4aa ("net: phy: Don't trigger state machine while in suspend").
> >
> > The initial fix attempt that you're replying to should not be necessary
> > with that commit.
> >
> > Are you still seeing issues even with 1758bde2e4aa applied?
> > Or are you maybe using a custom downstream tree which is missing that commit?
> 
> On Linux next-20220825 I still get the following warning during 
> suspend/resume cycle:
> 
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 1483 at drivers/net/phy/phy_device.c:323 
> mdio_bus_phy_resume+0x10c/0x110
> Modules linked in: exynos_gsc s5p_jpeg s5p_mfc videobuf2_dma_contig 
> v4l2_mem2mem videobuf2_memops videobuf2_v4l2 videobuf2_common videodev 
> mc s5p_cec
> CPU: 0 PID: 1483 Comm: rtcwake Not tainted 6.0.0-rc2-next-20220825 #5482
> Hardware name: Samsung Exynos (Flattened Device Tree)
>   unwind_backtrace from show_stack+0x10/0x14
>   show_stack from dump_stack_lvl+0x58/0x70
>   dump_stack_lvl from __warn+0xc8/0x220
>   __warn from warn_slowpath_fmt+0x5c/0xb4
>   warn_slowpath_fmt from mdio_bus_phy_resume+0x10c/0x110
>   mdio_bus_phy_resume from dpm_run_callback+0x94/0x208
>   dpm_run_callback from device_resume+0x124/0x21c
>   device_resume from dpm_resume+0x108/0x278
>   dpm_resume from dpm_resume_end+0xc/0x18
>   dpm_resume_end from suspend_devices_and_enter+0x208/0x70c
>   suspend_devices_and_enter from pm_suspend+0x364/0x430
>   pm_suspend from state_store+0x68/0xc8
>   state_store from kernfs_fop_write_iter+0x110/0x1d4
>   kernfs_fop_write_iter from vfs_write+0x1c4/0x2ac
>   vfs_write from ksys_write+0x5c/0xd4
>   ksys_write from ret_fast_syscall+0x0/0x1c
> Exception stack(0xf2ee5fa8 to 0xf2ee5ff0)
> 5fa0:                   00000004 0002b438 00000004 0002b438 00000004 
> 00000000
> 5fc0: 00000004 0002b438 000291b0 00000004 0002b438 00000004 befd9c1c 
> 00028160
> 5fe0: 0000006c befd9ae8 b6eb4148 b6f118a4
> irq event stamp: 58381
> hardirqs last  enabled at (58393): [<c019ff28>] vprintk_emit+0x320/0x344
> hardirqs last disabled at (58400): [<c019fedc>] vprintk_emit+0x2d4/0x344
> softirqs last  enabled at (58258): [<c0101694>] __do_softirq+0x354/0x618
> softirqs last disabled at (58247): [<c012dd18>] __irq_exit_rcu+0x140/0x1ec
> ---[ end trace 0000000000000000 ]---
> 
> The mentioned patch fixes it.

Color me confused.

With "the mentioned patch", are you referring to 1758bde2e4aa
or are you referring to the little test patch in this e-mail:
https://lore.kernel.org/netdev/20220519190841.GA30869@wunner.de/

There's a Tested-by from you on 1758bde2e4aa, so I assume the
commit fixed the issue at the time.  Does it still occur
intermittently?  Or does it occur every time?  In the latter case,
I'd assume some other change was made in the meantime and that
other change exposed the issue again...

Thanks,

Lukas
