Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78CFA891F6
	for <lists+netdev@lfdr.de>; Sun, 11 Aug 2019 16:06:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726510AbfHKOGx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Aug 2019 10:06:53 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:33064 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726313AbfHKOGx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Aug 2019 10:06:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:To:From:Date:Reply-To:Cc:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=nW31To8e/HVDndtYjU5jwgGcj3+Org1F3hIFKo2GeJI=; b=SgVfHGGDxMQicFrar1JNGKUgV
        XJTkcZN8CvXXtP885TWEVNMGPiW86EtVhltQ48cpqeSY8nTxft/PtvJHa6xcZwsolI0tcWGk0osL2
        g13ilpwGAkKwaM3j3LIEfbsK4kOup8NmqSXO+PTHhyJkDd7nD/p+t3AwAcra86ezCTXS5rMIgLayr
        PclhlmxrVhvfkXXI+DmfDcxyW/aVKZSbxptC95EQA+Y3Wu6LhO+o1omOWPnFOirNHDlnoQBaaFJcJ
        a7N0hVu42yuJ4P9ZyXL0+ArmWQVzLqeVdx2DcbWKnow5qycw91UFtuGA/Wa4p5bi6mXxVpU/NHC26
        gFe73aciQ==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:43674)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1hwoUj-0005ay-Ih; Sun, 11 Aug 2019 15:06:49 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1hwoUe-0005dY-VA; Sun, 11 Aug 2019 15:06:44 +0100
Date:   Sun, 11 Aug 2019 15:06:44 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     linux-arm-kernel@lists.infradead.org,
        Fabio Estevam <festevam@gmail.com>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [BUG] fec mdio times out under system stress
Message-ID: <20190811140644.GD13294@shell.armlinux.org.uk>
References: <20190811133707.GC13294@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190811133707.GC13294@shell.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 11, 2019 at 02:37:07PM +0100, Russell King - ARM Linux admin wrote:
> Hi Fabio,
> 
> When I woke up this morning, I found that one of the Hummingboards
> had gone offline (as in, lost network link) during the night.
> Investigating, I find that the system had gone into OOM, and at
> that time, triggered an unrelated:
> 
> [4111697.698776] fec 2188000.ethernet eth0: MDIO read timeout
> [4111697.712996] MII_DATA: 0x6006796d
> [4111697.729415] MII_SPEED: 0x0000001a
> [4111697.745232] IEVENT: 0x00000000
> [4111697.745242] IMASK: 0x0a8000aa
> [4111698.002233] Atheros 8035 ethernet 2188000.ethernet-1:00: PHY state change RUNNING -> HALTED
> [4111698.009882] fec 2188000.ethernet eth0: Link is Down
> 
> This is on a dual-core iMX6.
> 
> It looks like the read actually completed (since MII_DATA contains
> the register data) but we somehow lost the interrupt (or maybe
> received the interrupt after wait_for_completion_timeout() timed
> out.)
> 
> From what I can see, the OOM events happened on CPU1, CPU1 was
> allocated the FEC interrupt, and the PHY polling that suffered the
> MDIO timeout was on CPU0.
> 
> Given that IEVENT is zero, it seems that CPU1 had read serviced the
> interrupt, but it is not clear how far through processing that it
> was - it may be that fec_enet_interrupt() had been delayed by the
> OOM condition.
> 
> This seems rather fragile - as the system slowing down due to OOM
> triggers the network to completely collapse by phylib taking the
> PHY offline, making the system inaccessible except through the
> console.
> 
> In my case, even serial console wasn't operational (except for
> magic sysrq).  Not sure what agetty was playing at... so the only
> way I could recover any information from the system was to connect
> the HDMI and plug in a USB keyboard.
> 
> Any thoughts on how FEC MDIO accesses could be made more robust?
> 
> Maybe phylib should retry a number of times - but with read-sensitive
> registers, if the read has already completed successfully, and its
> just a problem with the FEC MDIO hardware, that could cause issues.

I should also note for the phylib people:

After phylib has received an error, and has entered the HALTED state,
downing the interface produces this warning, which seems rather unfair
as the FEC doesn't know that its PHY suffered an error - it is merely
reversing the phy_start() that happened when the interface was opened.

[4144039.099786] ------------[ cut here ]------------
[4144039.109001] WARNING: CPU: 1 PID: 25842 at drivers/net/phy/phy.c:835 fec_enet_close+0x14/0x148
[4144039.124366] called from state HALTED
[4144039.132626] Modules linked in: 8021q brcmfmac brcmutil imx_thermal
snd_soc_imx_spdif snd_soc_imx_audmux nvmem_imx_ocotp cfg80211
snd_soc_sgtl5000 imx_sdma
virt_dma rc_cec snd_soc_fsl_ssi snd_soc_fsl_spdif coda imx_pcm_dma
v4l2_mem2mem
imx_vdoa etnaviv videobuf2_dma_contig gpu_sched dw_hdmi_cec
dw_hdmi_ahb_audio imx6q_cpufreq caamrng caam_jr caam error ip_tables
x_tables [last unloaded: evbug][4144039.177249] CPU: 1 PID: 25842 Comm:
ip Tainted: G        W         5.1.0+ #319
[4144039.189477] Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
[4144039.201025] [<c00194f0>] (unwind_backtrace) from [<c0014748>] (show_stack+0x10/0x14)
[4144039.213769] [<c0014748>] (show_stack) from [<c082e11c>] (dump_stack+0x9c/0xd4)
[4144039.225959] [<c082e11c>] (dump_stack) from [<c0030f3c>] (__warn+0xf8/0x124)
[4144039.237828] [<c0030f3c>] (__warn) from [<c0031030>] (warn_slowpath_fmt+0x38/0x48)
[4144039.250275] [<c0031030>] (warn_slowpath_fmt) from [<c052cb14>] (fec_enet_close+0x14/0x148)
[4144039.263558] [<c052cb14>] (fec_enet_close) from [<c066b5bc>] (__dev_close_many+0x88/0xf0)
[4144039.276639] [<c066b5bc>] (__dev_close_many) from [<c06740cc>] (__dev_change_flags+0xa4/0x1a0)
[4144039.290130] [<c06740cc>] (__dev_change_flags) from [<c06741e8>] (dev_change_flags+0x18/0x48)
[4144039.303558] [<c06741e8>] (dev_change_flags) from [<c068db80>] (do_setlink+0x29c/0x990)
[4144039.316517] [<c068db80>] (do_setlink) from [<c068eae8>] (__rtnl_newlink+0x4a4/0x72c)
[4144039.329282] [<c068eae8>] (__rtnl_newlink) from [<c068edb0>] (rtnl_newlink+0x40/0x60)
[4144039.342023] [<c068edb0>] (rtnl_newlink) from [<c0689a10>] (rtnetlink_rcv_msg+0x244/0x470)
[4144039.355224] [<c0689a10>] (rtnetlink_rcv_msg) from [<c06d20a0>] (netlink_rcv_skb+0xe0/0xf4)
[4144039.368492] [<c06d20a0>] (netlink_rcv_skb) from [<c06d194c>] (netlink_unicast+0x170/0x1b8)
[4144039.381758] [<c06d194c>] (netlink_unicast) from [<c06d1cdc>] (netlink_sendmsg+0x2b8/0x340)
[4144039.395023] [<c06d1cdc>] (netlink_sendmsg) from [<c064999c>] (sock_sendmsg+0x14/0x24)
[4144039.407825] [<c064999c>] (sock_sendmsg) from [<c064a5a0>] (___sys_sendmsg+0x200/0x214)
[4144039.420714] [<c064a5a0>] (___sys_sendmsg) from [<c064b0c4>] (__sys_sendmsg+0x40/0x6c)
[4144039.433506] [<c064b0c4>] (__sys_sendmsg) from [<c0009000>] (ret_fast_syscall+0x0/0x28)
[4144039.446366] Exception stack(0xe1933fa8 to 0xe1933ff0)
[4144039.456329] 3fa0:                   bea086f0 bea086bc 00000003 bea086d0 00000000 00000000
[4144039.469464] 3fc0: bea086f0 bea086bc 00000000 00000128 0062a278 bea086d0 5d5011f3 0062a000
[4144039.482590] 3fe0: 00000128 bea08680 b6dfc4cb b6d7d6f6
[4144039.492652] irq event stamp: 0
[4144039.500650] hardirqs last  enabled at (0): [<00000000>]   (null)
[4144039.511628] hardirqs last disabled at (0): [<c002e55c>] copy_process.part.4+0x30c/0x19e8
[4144039.524691] softirqs last  enabled at (0): [<c002e55c>] copy_process.part.4+0x30c/0x19e8
[4144039.537691] softirqs last disabled at (0): [<00000000>]   (null)
[4144039.548554] ---[ end trace b5e8d4b0f30ae00b ]---


-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
