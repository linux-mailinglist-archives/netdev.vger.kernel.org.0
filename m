Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B6171309EC
	for <lists+netdev@lfdr.de>; Sun,  5 Jan 2020 21:43:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726825AbgAEUnW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jan 2020 15:43:22 -0500
Received: from gloria.sntech.de ([185.11.138.130]:41086 "EHLO gloria.sntech.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726092AbgAEUnV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 Jan 2020 15:43:21 -0500
Received: from ip5f5a5f74.dynamic.kabel-deutschland.de ([95.90.95.116] helo=diego.localnet)
        by gloria.sntech.de with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <heiko@sntech.de>)
        id 1ioCjp-0000m4-Ne; Sun, 05 Jan 2020 21:43:05 +0100
From:   Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To:     linux-arm-kernel@lists.infradead.org,
        David Miller <davem@davemloft.net>
Cc:     p.rajanbabu@samsung.com, Jose.Abreu@synopsys.com,
        jayati.sahu@samsung.com, alexandre.torgue@st.com,
        rcsekar@samsung.com, netdev@vger.kernel.org,
        sriram.dash@samsung.com, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, pankaj.dubey@samsung.com,
        peppe.cavallaro@st.com, linux-stm32@st-md-mailman.stormreply.com
Subject: Re: [PATCH] net: stmmac: platform: Fix MDIO init for platforms without PHY
Date:   Sun, 05 Jan 2020 21:43:04 +0100
Message-ID: <1700835.tBzmY8zkgn@diego>
In-Reply-To: <20191220.212918.1661751615125167321.davem@davemloft.net>
References: <CGME20191219102407epcas5p103b26e6fb191f7135d870a3449115c89@epcas5p1.samsung.com> <1576750621-78066-1-git-send-email-p.rajanbabu@samsung.com> <20191220.212918.1661751615125167321.davem@davemloft.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Am Samstag, 21. Dezember 2019, 06:29:18 CET schrieb David Miller:
> From: Padmanabhan Rajanbabu <p.rajanbabu@samsung.com>
> Date: Thu, 19 Dec 2019 15:47:01 +0530
> 
> > The current implementation of "stmmac_dt_phy" function initializes
> > the MDIO platform bus data, even in the absence of PHY. This fix
> > will skip MDIO initialization if there is no PHY present.
> > 
> > Fixes: 7437127 ("net: stmmac: Convert to phylink and remove phylib logic")
> > Acked-by: Jayati Sahu <jayati.sahu@samsung.com>
> > Signed-off-by: Sriram Dash <sriram.dash@samsung.com>
> > Signed-off-by: Padmanabhan Rajanbabu <p.rajanbabu@samsung.com>
> 
> Applied and queued up for -stable, thanks.

with this patch applied I now run into issues on multiple rockchip
platforms using a gmac interface.

When probing the driver and trying to establish a connection for a nfsroot
it always runs into a null pointer in mdiobus_get_phy():

[   26.878839] rk_gmac-dwmac ff360000.ethernet: IRQ eth_wake_irq not found
[   26.886322] rk_gmac-dwmac ff360000.ethernet: IRQ eth_lpi not found
[   26.894505] rk_gmac-dwmac ff360000.ethernet: PTP uses main clock
[   26.908209] rk_gmac-dwmac ff360000.ethernet: clock input or output? (output).
[   26.916269] rk_gmac-dwmac ff360000.ethernet: Can not read property: tx_delay.
[   26.924297] rk_gmac-dwmac ff360000.ethernet: set tx_delay to 0x30
[   26.931150] rk_gmac-dwmac ff360000.ethernet: Can not read property: rx_delay.
[   26.939166] rk_gmac-dwmac ff360000.ethernet: set rx_delay to 0x10
[   26.946021] rk_gmac-dwmac ff360000.ethernet: integrated PHY? (no).
[   26.953032] rk_gmac-dwmac ff360000.ethernet: cannot get clock clk_mac_refout
[   26.966161] rk_gmac-dwmac ff360000.ethernet: init for RMII
[   26.972633] rk_gmac-dwmac ff360000.ethernet: User ID: 0x10, Synopsys ID: 0x35
[   26.980830] rk_gmac-dwmac ff360000.ethernet:         DWMAC1000
[   26.986735] rk_gmac-dwmac ff360000.ethernet: DMA HW capability register supported
[   26.995145] rk_gmac-dwmac ff360000.ethernet: RX Checksum Offload Engine supported
[   27.003540] rk_gmac-dwmac ff360000.ethernet: COE Type 2
[   27.009408] rk_gmac-dwmac ff360000.ethernet: TX Checksum insertion supported
[   27.017320] rk_gmac-dwmac ff360000.ethernet: Wake-Up On Lan supported
[   27.024577] rk_gmac-dwmac ff360000.ethernet: Normal descriptors
[   27.031211] rk_gmac-dwmac ff360000.ethernet: Ring mode enabled
[   27.037743] rk_gmac-dwmac ff360000.ethernet: Enable RX Mitigation via HW Watchdog Timer
[   27.209823] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000398
 2IP-Config: eth0 hardware address  66:e4:9b:b1:30:c3 mtu 1500 DHCP
7.219681] Mem abort info:
[   27.229322]   ESR = 0x96000006
[   27.229328]   EC = 0x25: DABT (current EL), IL = 32 bits
[   27.229330]   SET = 0, FnV = 0
[   27.229332]   EA = 0, S1PTW = 0
[   27.229334] Data abort info:
[   27.229336]   ISV = 0, ISS = 0x00000006
[   27.229338]   CM = 0, WnR = 0
[   27.229342] user pgtable: 4k pages, 48-bit VAs, pgdp=000000003e7d4000
[   27.229345] [0000000000000398] pgd=0000000036739003, pud=0000000035894003, pmd=0000000000000000
[   27.273398] Internal error: Oops: 96000006 [#1] SMP
[   27.273403] Modules linked in: smsc95xx smsc75xx ax88179_178a asix usbnet panel_leadtek_ltk500hd1829 dwmac_rk stmmac_platform stmmac rockchipdrm phy_rockchip_inno_dsidphy analogix_dp dw_hdmi cec r
c_core dw_mipi_dsi drm_kms_helper rtc_rk808 drm drm_panel_orientation_quirks
[   27.305785] CPU: 3 PID: 1388 Comm: ipconfig Not tainted 5.5.0-rc4-00934-gd57e566e6874 #1463
[   27.305790] Hardware name: Theobroma Systems Cobra with Leadtek Display (DT)
[   27.323006] pstate: 40000005 (nZcv daif -PAN -UAO)
[   27.323020] pc : mdiobus_get_phy+0x4/0x20
[   27.332867] lr : stmmac_open+0x780/0xa78 [stmmac]
[   27.332872] sp : ffff80001113b9a0
[   27.341823] x29: ffff80001113b9a0 x28: 0000000000401003
[   27.347761] x27: ffff00003d5cf200 x26: 0000000000000000
[   27.353699] x25: 0000000000000001 x24: 0000000000000000
[   27.359636] x23: 0000000000001002 x22: ffff800008b790a0
[   27.365575] x21: ffff000035f84000 x20: 00000000ffffffff
[   27.371513] x19: ffff000035f84800 x18: 0000000000000000
[   27.377451] x17: 0000000000000000 x16: 0000000000000000
[   27.383389] x15: 0000000000000000 x14: ffffffffffffffff
[   27.389328] x13: 0000000000000020 x12: 0101010101010101
[   27.395266] x11: 0000000000000003 x10: 0101010101010101
[   27.401203] x9 : fffffffffffffffd x8 : 7f7f7f7f7f7f7f7f
[   27.407143] x7 : fefefeff646c606d x6 : 1e091448e4e5f6e9
[   27.413074] x5 : 697665644814091e x4 : 8080808000000000
[   27.419013] x3 : 8343c96b232bb348 x2 : ffff00003d63f880
[   27.424953] x1 : fffffffffffffff8 x0 : 0000000000000000
[   27.430882] Call trace:
[   27.433620]  mdiobus_get_phy+0x4/0x20
[   27.437715]  __dev_open+0xe4/0x160
[   27.441515]  __dev_change_flags+0x160/0x1b8
[   27.446191]  dev_change_flags+0x20/0x60
[   27.450478]  devinet_ioctl+0x66c/0x738
[   27.454666]  inet_ioctl+0x2f4/0x360
[   27.458565]  sock_do_ioctl+0x44/0x2b0
[   27.462657]  sock_ioctl+0x1c8/0x508
[   27.466556]  do_vfs_ioctl+0x604/0xbd0
[   27.470646]  ksys_ioctl+0x78/0xa8
[   27.474351]  __arm64_sys_ioctl+0x1c/0x28
[   27.478737]  el0_svc_common.constprop.0+0x68/0x160
[   27.484083]  el0_svc_handler+0x20/0x80
[   27.488273]  el0_sync_handler+0x10c/0x180
[   27.492753]  el0_sync+0x140/0x180
[   27.496462] Code: 97ffffb0 a8c17bfd d65f03c0 8b21cc01 (f941d020)
[   27.503275] ---[ end trace 6f6ca54e66af6d48 ]---

With the expected output being normally at this point:
[   18.575321] rk_gmac-dwmac ff360000.ethernet eth0: PHY [stmmac-0:00] driver [RTL8201F Fast Ethernet]
[   18.602975] rk_gmac-dwmac ff360000.ethernet eth0: No Safety Features support found
[   18.611505] rk_gmac-dwmac ff360000.ethernet eth0: PTP not supported by HW
[   18.619117] rk_gmac-dwmac ff360000.ethernet eth0: configuring for phy/rmii link mode
[   22.719478] rk_gmac-dwmac ff360000.ethernet eth0: Link is Up - 100Mbps/Full - flow control rx/tx

or

[   27.326984] rk_gmac-dwmac ff360000.ethernet eth0: PHY [stmmac-0:00] driver [Generic PHY]
[   27.353543] rk_gmac-dwmac ff360000.ethernet eth0: No Safety Features support found
[   27.362055] rk_gmac-dwmac ff360000.ethernet eth0: PTP not supported by HW
[   27.369663] rk_gmac-dwmac ff360000.ethernet eth0: configuring for phy/rmii link mode
[   29.406784] rk_gmac-dwmac ff360000.ethernet eth0: Link is Up - 100Mbps/Full - flow control rx/tx


This is torvalds git head and it was still working at -rc1 and all kernels
before that. When I just revert this commit, things also start working
again, so I guess something must be wrong here?

Thanks
Heiko


