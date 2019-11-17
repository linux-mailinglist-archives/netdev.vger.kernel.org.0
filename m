Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49904FFA9C
	for <lists+netdev@lfdr.de>; Sun, 17 Nov 2019 17:08:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726119AbfKQQEy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Nov 2019 11:04:54 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:49784 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726069AbfKQQEx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Nov 2019 11:04:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Sh7e9K4cMAvriTq3SA06I6v7Cs1IsyC2LoG2l2Grb54=; b=X7G1amrNpvCumib3FFhMLEx/e
        ax9VJG4EQyTdhyHw6SNtYo5jbrQXcAYey3CZmAlHdVo62gnGwbT6v4NBw7LfU6ZZpnMGy/hoICw1R
        O4GSOIn5Z4wLYFpGN9ZYeOpDv6fnM9JZ/iNZxtr+DOVevKBlRi/bVn3DPUfTGxizLkSn23sisb64C
        TYits4L+VISHbRgMiamibmmAjAXOyZcQPDq7Z2J45xNrCQ5kAIODZ+7UJDTQKmJzf7P/Qpu3t/Uqn
        TFavevkVKQTvGVfHrfjTBPtLhXfKl4jXPmg+AhsqJPY0nwUyvGyD4OFknDLUA1T2jzQFN78a2PSAd
        EZLd020tg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:40892)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1iWN2d-0006Bl-S3; Sun, 17 Nov 2019 16:04:48 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1iWN2Z-0007Kg-Ne; Sun, 17 Nov 2019 16:04:43 +0000
Date:   Sun, 17 Nov 2019 16:04:43 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        laurentiu.tudor@nxp.com, andrew@lunn.ch, f.fainelli@gmail.com
Subject: Re: [PATCH net-next v4 0/5] dpaa2-eth: add MAC/PHY support through
 phylink
Message-ID: <20191117160443.GG1344@shell.armlinux.org.uk>
References: <1572477512-4618-1-git-send-email-ioana.ciornei@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1572477512-4618-1-git-send-email-ioana.ciornei@nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 31, 2019 at 01:18:27AM +0200, Ioana Ciornei wrote:
> The dpaa2-eth driver now has support for connecting to its associated PHY
> device found through standard OF bindings. The PHY interraction is handled
> by PHYLINK and even though, at the moment, only RGMII_* phy modes are
> supported by the driver, this is just the first step into adding the
> necessary changes to support the entire spectrum of capabilities.
> 
> This comes after feedback on the initial DPAA2 MAC RFC submitted here:
> https://lwn.net/Articles/791182/
> 
> The notable change is that now, the DPMAC is not a separate driver, and
> communication between the DPMAC and DPNI no longer happens through
> firmware. Rather, the DPMAC is now a set of API functions that other
> net_device drivers (DPNI, DPSW, etc) can use for PHY management.
> 
> The change is incremental, because the DPAA2 architecture has many modes of
> connecting net devices in hardware loopback (for example DPNI to DPNI).
> Those operating modes do not have a DPMAC and phylink instance.
> 
> The documentation patch provides a more complete view of the software
> architecture and the current implementation.

Hi,

I've just switched from using the previous solution to this solution,
and when I use the following on SolidRun's Clearfog CX platform:

# ls-addni dpmac.7
# ls-addni dpmac.8

I get lots of warnings spat out of the kernel:

------------[ cut here ]------------
Unable to drop a managed device link reference WARNING: CPU: 0 PID: 1580 drivers/base/core.c:456 device_link_put_kref+0x40/0x64
Modules linked in: nf_tables nfnetlink mlx4_en fsl_dpaa2_ptp crct10dif_ce ptp_qoriq mlx4_core m25p80 spi_nor sbsa_gwdt qsfp vhost_net tun vhost tap ip_tables x_tables
CPU: 0 PID: 1580 Comm: irq/128-dprc.1 Not tainted 5.3.0+ #491
Hardware name: SolidRun LX2160A Clearfog CX (DT)
pstate: 60400005 (nZCv daif +PAN -UAO)
pc : device_link_put_kref+0x40/0x64
lr : device_link_put_kref+0x40/0x64
sp : ffffff8015583a10
x29: ffffff8015583a10 x28: 0000000000000000
x27: ffffffe2d0bc3ab4 x26: ffffff8015583dbc
x25: ffffff8010c48bb0 x24: ffffffe2d08a8000
x23: ffffffe2d0bc0000 x22: ffffffe2d0bc1560
x21: ffffffe2d0bc1560 x20: ffffffe2d1058b80
x19: ffffff8010f3f570 x18: 0000000000000000
x17: 0000000000000000 x16: 0000000000000000
x15: ffffffffffffffff x14: 0000000000000040
x13: 0000000000000220 x12: 0000000000000018
x11: 0000000000000000 x10: ffffffe2ecb2c1e0
x9 : 0000000000000000 x8 : 00000000ad126c4a
x7 : 0000000000000000 x6 : ffffff801015aa18
x5 : 0000000000000000 x4 : 0000000000000000
x3 : 0000000000000000 x2 : ffffffe2f1a118e8
x1 : ffffffe2ecb2c140 x0 : 000000000000002e
Call trace:
 device_link_put_kref+0x40/0x64
 device_link_del+0x34/0x4c
 fsl_mc_object_free+0x40/0x48
 free_dpbp+0x44/0x50
 dpaa2_eth_remove+0xc4/0x108
 fsl_mc_driver_remove+0x1c/0x58
 device_release_driver_internal+0xe4/0x198
 device_links_unbind_consumers+0xd0/0xf8
 device_release_driver_internal+0x5c/0x198
 device_release_driver+0x14/0x1c
 bus_remove_device+0xcc/0x108
 device_del+0x138/0x34c
 fsl_mc_device_remove+0x14/0x28
 __fsl_mc_device_remove_if_not_in_mc+0x94/0xb4
 device_for_each_child+0x3c/0x7c
 dprc_scan_objects+0x2ac/0x348
 dprc_irq0_handler_thread+0xec/0x15c
 irq_thread_fn+0x28/0x6c
 irq_thread+0x10c/0x18c
 kthread+0xf8/0x124
 ret_from_fork+0x10/0x18
---[ end trace 8308e7d5e463dbb1 ]---
------------[ cut here ]------------
Unable to drop a managed device link reference
... repeats ...

The other thing I see is that with dpmac.7 added, I get all the iommu
group messages, and buried in there is:

fsl_dpaa2_eth dpni.1: Probed interface eth1

as expected.  When I issue the dpmac.8 command (which is when all those
warnings are spat out) I see:

fsl_dpaa2_eth dpni.2: Probed interface eth1

So dpni.1 has gone, eth1 has gone to be replaced by dpni.2 bound to eth1.

Looking in /sys/bus/fsl-mc/devices/dpni.[12]/ it seems that both
devices still exist, but dpni.1 has been unbound from the dpaa2 eth
driver.

If I then ask for dpmac.9 and dpmac.10, then everything works as
expected, they become eth2 and eth3 respectively, and eth1 doesn't
get unbound.

The warnings are caused by calls to device_link_del() scattered
throughout the DPAA2/FSL-MC code - you can't remove the device links
which are not created with DL_FLAG_STATELESS - but you can't create
a device link with the DL_FLAG_STATELESS flag set and with the
autoprobe/autoremove flags set - please read the documentation for
device_link_add().

Merely deleting the calls doesn't seem to be the right thing either -
I don't think the devices go away, so the links will persist.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
