Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 336D229056C
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 14:45:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405356AbgJPMpn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 08:45:43 -0400
Received: from mailout01.rmx.de ([94.199.90.91]:60580 "EHLO mailout01.rmx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2395037AbgJPMpm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Oct 2020 08:45:42 -0400
Received: from kdin01.retarus.com (kdin01.dmz1.retloc [172.19.17.48])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mailout01.rmx.de (Postfix) with ESMTPS id 4CCQqP31Q6z2SSmN;
        Fri, 16 Oct 2020 14:45:37 +0200 (CEST)
Received: from mta.arri.de (unknown [217.111.95.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by kdin01.retarus.com (Postfix) with ESMTPS id 4CCQq43XBqz2xZS;
        Fri, 16 Oct 2020 14:45:20 +0200 (CEST)
Received: from n95hx1g2.localnet (192.168.54.46) by mta.arri.de
 (192.168.100.104) with Microsoft SMTP Server (TLS) id 14.3.408.0; Fri, 16 Oct
 2020 14:44:47 +0200
From:   Christian Eggers <ceggers@arri.de>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     Kurt Kanzenbach <kurt@linutronix.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] net: dsa: ksz: fix padding size of skb
Date:   Fri, 16 Oct 2020 14:44:46 +0200
Message-ID: <1655621.YBUmbkoM4d@n95hx1g2>
Organization: Arnold & Richter Cine Technik GmbH & Co. Betriebs KG
In-Reply-To: <20201016090527.tbzmjkraok5k7pwb@skbuf>
References: <20201014161719.30289-1-ceggers@arri.de> <4467366.g9nP7YU7d8@n95hx1g2> <20201016090527.tbzmjkraok5k7pwb@skbuf>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Originating-IP: [192.168.54.46]
X-RMX-ID: 20201016-144526-4CCQq43XBqz2xZS-0@kdin01
X-RMX-SOURCE: 217.111.95.66
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Friday, 16 October 2020, 11:05:27 CEST, Vladimir Oltean wrote:
> On Fri, Oct 16, 2020 at 11:00:20AM +0200, Christian Eggers wrote:
> > On Friday, 16 October 2020, 09:45:42 CEST, Kurt Kanzenbach wrote:
> > > Hmm. I've never observed any problems using DSA with L2 PTP time
> > > stamping with this tail tag code. What's the impact exactly? Memory
> > > corruption?
> > 
> 
> Kurt is asking, and rightfully so, because his tag_hellcreek.c driver
> (for a 1588 switch with tail tags) is copied from tag_ksz.c.
> I have also attempted to replicate your issue at my end and failed to do
> so. 

After spending some additional hours, I managed to reproduce the original
problem on my current environment (BUG output is below). Some important
properties of my system:

Machine: 
- ARMv7 (i.MX6ULL), SMP_CACHE_BYTES is 64
- DSA device: Microchip KSZ9563 (I am currently working on time stamping support)

In order to trigger the problem, we need a skb with a length between 56 and 59.
It must be a PTP message with is  marked for time stamping in 
dsa_switch_ops::port_txtstamp, so it will be cloned in dsa_skb_tx_timestamp().
In my setup, only PTP Delay_Req fulfills both requirements (if transferred
via L2, not UDPv4/v6). Last, CONFIG_SLOB must be selected.

In ksz_common_xmit() we have the following conditions:
- skb->len is 58
- skb->cloned is 1
- skb_tailroom() is 68
--> condition "skb_tailroom(skb) >= padlen + len" is easily fulfilled, 2 bytes padding is required

__skb_put_padto() calls then __skb_pad() which in turn calls 
pskb_expand_head(.., nhead=0, ntail=-66, ...)
- osize is 128
- size = 128 + 0 + (-66) = 62  (two bytes are reserved before the mac header)
- size = SKB_DATA_ALIGN(size)  --> 64 on ARMv7
- data = kmalloc_reserve(64 + 256)
- ksize(data) returns 64 + 256  (only with CONFIG_SLOB)
- size = SKB_WITH_OVERHEAD(...) is 64
- skb_tailroom() is 4 (before padding 2 bytes)

--> the copied skb has enough size for padding, but not for the tail tag (1+4 bytes if PTP is enabled).
- back in __skb_pad(), 2 bytes will be initialized with memset()
- back in __skb_put_padto(), __skb_put increments the tail and len by 2
---> skb_tailroom() is 2 now

- back in ksz9893_xmit(), skb_put(..., 4) (in my code) calls skb_over_panic()
because the tail has grown beyond then end. QED.

> In principle, it is indeed true that a cloned skb should not be
> modified without calling skb_unshare() first. The DSA core
> (dsa_slave_xmit) should do that. But that doesn't explain the symptoms
> you're seeing, which is why I asked for skb_dump.
As dsa_slave_xmit() is (in my case) the cause for the cloned skb
(in dsa_skb_tx_timestamp()), solving the problem there makes sense. The 
drawback compared with my solution (checking for skb->cloned myself)
may be, that the skb may have to be copied another time in ksz_common_xmit()
because there is still not enough tailroom for the tag. Probably this could be
solved with using dsa_device_ops::overhead and "manually" unsharing
in dsa_slave_xmit().

@Vladimir: Please let me know, which solution you prefer.
1. Considering skb->cloned in ksz_common_xmit()
2. Using skb_unshare() before calling dsa_device_ops::xmit()
3. "Manually" unsharing in dsa_slave_xmit(), reserving enough tailroom
for the tail tag (and ETH_ZLEN?). Would moving the "else" clause from
ksz_common_xmit()  to dsa_slave_xmit() do the job correctly?

Best regards
Christian

[   81.416971] skbuff: skb_over_panic: text:bf9fd3e3 len:64 put:4 head:c739dd40 data:c739dd42 tail:0xc739dd82 end:0xc739dd80 dev:lan0
[   81.423081] Internal error: Oops - undefined instruction: 0 [#1] THUMB2
[   81.426428] Modules linked in: bridge stp llc sd_mod ebt_ip ebtable_broute ebtables x_tables usb_storage scsi_mod ksz9477_i2c ksz9477 st_magn_spi tag_ksz st_sensors_spi regmap_spi ksz_common dsa_core st_magn_i2c st_sensors_i2c st_magn phylink st_sensors
 at24 as73211 industrialio_triggered_buffer rtc_rv3028 kfifo_buf i2c_dev regmap_i2c usb49xx i2c_imx i2c_core imx_thermal anatop_regulator imx2_wdt imx_fan spidev leds_gpio leds_pwm led_class iio_trig_sysfs imx6sx_adc industrialio micrel fec ptp pps_core at
25 spi_imx spi_bitbang imx_napi dev nfsv3 nfs lockd grace sunrpc usb_f_ecm u_ether libcomposite configfs ci_hdrc_imx ci_hdrc ulpi ehci_hcd usbcore nls_base tcpm roles typec udc_core usb_common usbmisc_imx phy_mxs_usb fixed imx_sdma virt_dma
[   81.460419] CPU: 0 PID: 286 Comm: ptp4l Not tainted 5.9.0-rc8+ #31
[   81.463561] Hardware name: Freescale i.MX6 Ultralite (Device Tree)
[   81.466725] PC is at skb_panic+0x30/0x3c
[   81.468708] LR is at skb_panic+0x31/0x3c
[   81.470703] pc : [<c028f054>]    lr : [<c028f055>]    psr: 00000033
[   81.474018] sp : c56ddd08  ip : 00000000  fp : c074b288
[   81.476683] r10: c074b29c  r9 : bfa09caf  r8 : c4889e40
[   81.479353] r7 : c739dd80  r6 : c739dd82  r5 : c04eaeae  r4 : 00000004
[   81.482694] r3 : 00000000  r2 : c071bb1c  r1 : c070df78  r0 : 00000076
[   81.486043] Flags: nzcv  IRQs on  FIQs on  Mode SVC_32  ISA Thumb  Segment user
[   81.489800] Control: 50c53c7d  Table: 85c08059  DAC: 00000055
[   81.492747] Process ptp4l (pid: 286, stack limit = 0xf8a7d922)
[   81.495945] Stack: (0xc56ddd08 to 0xc56de000)
[   81.498180] dd00:                   00000004 c739dd40 c739dd42 c739dd82 c739dd80 c3c44040
[   81.502357] dd20: c739dd82 c028a18b 00000001 c739dd50 00000000 00000042 c725f580 bf9fd3e3
[   81.506533] dd40: c7430c7c bf9fd0cf 00000044 c725f580 00000002 bf9fd187 bf9fd459 c725f580
[   81.510709] dd60: c725f580 c432e6c0 00000042 bf9fd46d c3c44040 c725f580 c725f8c0 bf9e6dbd
[   81.514903] dd80: bf9e6d41 c46c39c0 c0749140 00000000 00000000 00000000 c46c39c0 c0292b9f
[   81.519318] dda0: 00000000 c725f580 c0749140 c029585d c0749140 c3c44040 c3c44040 c3c44040
[   81.523493] ddc0: 0000003a c56dddf8 c725f580 c725f580 c0749140 c3c44040 c46c39c0 00000000
[   81.527662] dde0: c7430cc0 c74302c0 c56ddedc c0295e2d 000005ea c74302c0 fffffff4 c02fb9ef
[   81.531831] de00: 00000000 0000f788 00000000 00000000 00000000 c74304c0 c725f580 c3c44040
[   81.535998] de20: 0000003a 0000003a 000005ea c02fe013 c56dde70 00000000 00000000 00000000
[   81.540413] de40: 00000300 00000010 00000000 00000000 00000122 c5444be8 c5447940 0000001b
[   81.544587] de60: 00000000 c56ddcfc c017ff09 00000100 00000000 00000000 00000000 00000000
[   81.548758] de80: 00000000 00000000 00000000 00000045 00000001 00000000 c74302c0 00000000
[   81.553018] dea0: 00000000 00000000 c56dc000 00000122 018e1a7a c0285559 00200000 c0286525
[   81.557177] dec0: c56ddee4 532380f0 00000013 fffffff7 00000000 018e1a7a 0000003a 00000000
[   81.561358] dee0: 00000000 00000005 00000000 00000000 c56ddedc 00000000 00000000 00000000
[   81.565562] df00: 00000000 00000000 00000000 c56ddf38 25c17d03 bec4fb28 00000000 00000161
[   81.569746] df20: c0100224 bec4fb30 00000008 00000000 c56ddf78 c012f9fd 00000000 00000000
[   81.574156] df40: 00000000 c01300b9 00000000 00000000 bec4fb28 c019ad8f 00000000 00000000
[   81.578311] df60: 00000000 018df2f0 00000001 00000000 26a83bd2 000000a8 00000000 00000000
[   81.582477] df80: 00000000 c56ddf68 00000000 00000000 00000000 00000000 0000003a 00000122
[   81.586661] dfa0: c0100224 c0100041 00000000 00000000 00000010 018e1a7a 0000003a 00000000
[   81.590846] dfc0: 00000000 00000000 0000003a 00000122 b6f92080 018e2098 018e1a88 018e1a7a
[   81.595144] dfe0: bec4f4b0 bec4f4a0 b6f43973 b6f4fc5c 60000030 00000010 00000000 00000000
[   81.599338] [<c028f054>] (skb_panic) from [<c028a18b>] (skb_put+0x2b/0x34)
[   81.602861] [<c028a18b>] (skb_put) from [<bf9fd3e3>] (ksz9477_xmit_timestamp+0x19/0x8e [tag_ksz])
[   81.607404] [<bf9fd3e3>] (ksz9477_xmit_timestamp [tag_ksz]) from [<bf9fd46d>] (ksz9893_xmit+0x15/0x42 [tag_ksz])
[   81.612624] [<bf9fd46d>] (ksz9893_xmit [tag_ksz]) from [<bf9e6dbd>] (dsa_slave_xmit+0x7d/0x96 [dsa_core])
[   81.617662] [<bf9e6dbd>] (dsa_slave_xmit [dsa_core]) from [<c0292b9f>] (netdev_start_xmit+0x13/0x2c)
[   81.622319] [<c0292b9f>] (netdev_start_xmit) from [<c029585d>] (dev_hard_start_xmit+0x6d/0xc8)
[   81.626703] [<c029585d>] (dev_hard_start_xmit) from [<c0295e2d>] (__dev_queue_xmit+0x25d/0x2e0)
[   81.631126] [<c0295e2d>] (__dev_queue_xmit) from [<c02fe013>] (packet_sendmsg+0x883/0x92c)
[   81.635337] [<c02fe013>] (packet_sendmsg) from [<c0285559>] (sock_sendmsg_nosec+0xb/0x16)
[   81.639767] [<c0285559>] (sock_sendmsg_nosec) from [<c0286525>] (__sys_sendto+0x69/0x7c)
[   81.643916] [<c0286525>] (__sys_sendto) from [<c0100041>] (ret_fast_syscall+0x1/0x5a)
[   81.647900] Exception stack(0xc56ddfa8 to 0xc56ddff0)
[   81.650702] dfa0:                   00000000 00000000 00000010 018e1a7a 0000003a 00000000
[   81.654865] dfc0: 00000000 00000000 0000003a 00000122 b6f92080 018e2098 018e1a88 018e1a7a
[   81.659033] dfe0: bec4f4b0 bec4f4a0 b6f43973 b6f4fc5c
[   81.661623] Code: 6d03 4803 f699 ffbe (de02) bf00
[   81.664071] ---[ end trace 8f263011ec91dee5 ]---
[   81.666434] Kernel panic - not syncing: Fatal exception in interrupt
[   81.669693] ---[ end Kernel panic - not syncing: Fatal exception in interrupt ]---



