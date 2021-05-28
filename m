Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FE19393B55
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 04:15:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235974AbhE1CRE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 22:17:04 -0400
Received: from mga04.intel.com ([192.55.52.120]:41336 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232965AbhE1CRD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 May 2021 22:17:03 -0400
IronPort-SDR: PbkV4YoL0n3ythmTDvAu4oBj+4NQSgAdwy9X7OuZ5WePXmWnoeAF4UfkF/ZfP+NSlmVQifWOBa
 1fYbLyzhUSBg==
X-IronPort-AV: E=McAfee;i="6200,9189,9997"; a="200987829"
X-IronPort-AV: E=Sophos;i="5.83,228,1616482800"; 
   d="scan'208";a="200987829"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2021 19:15:29 -0700
IronPort-SDR: pqbA7s4J2I/2jxRimGLA8UeMAtiir6fdg2uJbXH9PmYu+JJhiHoJ+Fmg0sOoEXUPyPXAT9MzI+
 v7y2tTwKHFUg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,228,1616482800"; 
   d="scan'208";a="480846736"
Received: from linux.intel.com ([10.54.29.200])
  by fmsmga002.fm.intel.com with ESMTP; 27 May 2021 19:15:28 -0700
Received: from linux.intel.com (unknown [10.88.229.80])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id 0C88B5807BA;
        Thu, 27 May 2021 19:15:24 -0700 (PDT)
Date:   Fri, 28 May 2021 10:15:21 +0800
From:   Wong Vee Khee <vee.khee.wong@linux.intel.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [RFC PATCH net-next 0/8] Convert xpcs to phylink_pcs_ops
Message-ID: <20210528021521.GA20022@linux.intel.com>
References: <20210527204528.3490126-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210527204528.3490126-1-olteanv@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 27, 2021 at 11:45:20PM +0300, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> This patch series is COMPLETELY UNTESTED (I don't have stmmac hardware
> with the xpcs) hence the RFC tag. If people from Intel could test this
> it would be great.
> 
> Background: the sja1105 DSA driver currently drives a Designware XPCS
> for SGMII and 2500base-X, and it would be nice to reuse some code with
> the xpcs module. This would also help consolidate the phylink_pcs_ops,
> since the only user of that, currently, is the lynx_pcs.
> 
> Therefore, this series makes the xpcs expose the same kind of API that
> the lynx_pcs module does.
> 
> Note: this patch series must be applied on top of:
> https://patchwork.kernel.org/project/netdevbpf/patch/20210527155959.3270478-1-olteanv@gmail.com/
> 
> Vladimir Oltean (8):
>   net: pcs: xpcs: delete shim definition for mdio_xpcs_get_ops()
>   net: pcs: xpcs: check for supported PHY interface modes in
>     phylink_validate
>   net: pcs: xpcs: export xpcs_validate
>   net: pcs: export xpcs_config_eee
>   net: pcs: xpcs: export xpcs_probe
>   net: pcs: xpcs: convert to phylink_pcs_ops
>   net: pcs: xpcs: use mdiobus_c45_addr in xpcs_{read,write}
>   net: pcs: xpcs: convert to mdio_device
> 
>  drivers/net/ethernet/stmicro/stmmac/common.h  |   3 +-
>  drivers/net/ethernet/stmicro/stmmac/hwif.h    |  14 --
>  .../ethernet/stmicro/stmmac/stmmac_ethtool.c  |   5 +-
>  .../net/ethernet/stmicro/stmmac/stmmac_main.c |  41 +---
>  .../net/ethernet/stmicro/stmmac/stmmac_mdio.c |  41 ++--
>  drivers/net/pcs/pcs-xpcs.c                    | 199 +++++++++++-------
>  include/linux/pcs/pcs-xpcs.h                  |  35 +--
>  7 files changed, 162 insertions(+), 176 deletions(-)

I got the following kernel panic after applying [1], and followed by
this patch series.

[1] https://patchwork.kernel.org/project/netdevbpf/patch/20210527155959.3270478-1-olteanv@gmail.com/


[   10.742057] libphy: stmmac: probed
[   10.750396] mdio_bus stmmac-1:01: attached PHY driver [unbound] (mii_bus:phy_addr=stmmac-1:01, irq=POLL)
[   10.818222] intel-eth-pci 0000:00:1e.4 (unnamed net_device) (uninitialized): failed to validate link configuration for in-band status
[   10.830348] intel-eth-pci 0000:00:1e.4 (unnamed net_device) (uninitialized): failed to setup phy (-22)
[   10.879931] ish-hid {33AECD58-B679-4E54-9BD9-A04D34F0C226}: [hid-ish]: enum_devices_done OK, num_hid_devices=6
[   10.901311] hid-generic 001F:8087:0AC2.0001: device has no listeners, quitting
[   10.922498] hid-generic 001F:8087:0AC2.0002: device has no listeners, quitting
[   10.940073] hid-generic 001F:8087:0AC2.0003: device has no listeners, quitting
[   10.951878] hid-generic 001F:8087:0AC2.0004: device has no listeners, quitting
[   10.958230] atkbd serio0: Failed to enable keyboard on isa0060/serio0
[   10.965799] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input5
[   10.978620] ------------[ cut here ]------------
[   10.983295] stmmac-0000:00:1e.4 already disabled
[   10.987973] WARNING: CPU: 3 PID: 2588 at drivers/clk/clk.c:952 clk_core_disable+0x96/0x1b0
[   10.989541] hid-generic 001F:8087:0AC3.0005: device has no listeners, quitting
[   10.996322] Modules linked in: intel_ishtp_hid(+) ax88179_178a dwmac_intel(+) usbnet x86_pkg_temp_thermal stmmac mii kvm_intel dwc3 atkbd mei_wdt udc_core pcs_xpcs libps2 mei_hdcp kvm phylink libphy irqbypass spi_pxa2xx_platform i915(+) wdat_wdt dw_dmac mei_me dw_dmac_core i2c_i801 intel_ish_ipc intel_rapl_msr intel_ishtp pcspkr i2c_smbus mei dwc3_pci thermal tpm_crb tpm_tis tpm_tis_core parport_pc parport tpm i8042 intel_pmc_core sch_fq_codel uhid fuse configfs snd_hda_intel snd_intel_dspcfg snd_intel_sdw_acpi snd_hda_codec snd_hda_core snd_pcm snd_timer snd soundcore
[   11.006487] hid-generic 001F:8087:0AC3.0006: device has no listeners, quitting
[   11.054376] CPU: 3 PID: 2588 Comm: systemd-udevd Tainted: G     U            5.13.0-rc3-intel-lts #68
[   11.054378] Hardware name: Intel Corporation Tiger Lake Client Platform/TigerLake U DDR4 SODIMM RVP, BIOS TGLIFUI1.R00.3373.AF0.2009230546 09/23/2020
[   11.084467] RIP: 0010:clk_core_disable+0x96/0x1b0
[   11.089221] Code: 00 8b 05 45 96 17 01 85 c0 7f 24 48 8b 5b 30 48 85 db 74 a5 8b 43 7c 85 c0 75 93 48 8b 33 48 c7 c7 6e 32 0c 8d e8 b2 5d 52 00 <0f> 0b 5b 5d c3 65 8b 05 76 31 d8 73 89 c0 48 0f a3 05 bc 92 1a 01
[   11.108121] RSP: 0018:ffffacc50038baa0 EFLAGS: 00010086
[   11.113400] RAX: 0000000000000000 RBX: ffff9702895e3800 RCX: 0000000000000000
[   11.120594] RDX: 0000000000000002 RSI: ffffffff8d062d5f RDI: 00000000ffffffff
[   11.127794] RBP: 0000000000000283 R08: 0000000000000000 R09: ffffacc50038b8d0
[   11.134995] R10: 0000000000000001 R11: 0000000000000001 R12: ffff9702895e3800
[   11.142189] R13: 0000000000000006 R14: ffff970282a960c8 R15: ffffacc50038bad0
[   11.149382] FS:  00007fe7654f6780(0000) GS:ffff970417f80000(0000) knlGS:0000000000000000
[   11.157536] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   11.163337] CR2: 00007f5e93783000 CR3: 0000000108ca0001 CR4: 0000000000770ee0
[   11.170530] PKRU: 55555554
[   11.173275] Call Trace:
[   11.175755]  clk_core_disable_lock+0x1b/0x30
[   11.180075]  intel_eth_pci_probe.cold+0x11d/0x136 [dwmac_intel]
[   11.186055]  pci_device_probe+0xcf/0x150
[   11.190021]  really_probe+0xf5/0x3e0
[   11.193646]  driver_probe_device+0x64/0x150
[   11.197874]  device_driver_attach+0x53/0x60
[   11.202103]  __driver_attach+0x9f/0x150
[   11.205984]  ? device_driver_attach+0x60/0x60
[   11.210387]  ? device_driver_attach+0x60/0x60
[   11.214789]  bus_for_each_dev+0x77/0xc0
[   11.218670]  bus_add_driver+0x184/0x1f0
[   11.222550]  driver_register+0x6c/0xc0
[   11.226347]  ? 0xffffffffc0641000
[   11.229705]  do_one_initcall+0x4a/0x210
[   11.233585]  ? kmem_cache_alloc_trace+0x305/0x4e0
[   11.238337]  do_init_module+0x5c/0x230
[   11.242127]  load_module+0x2894/0x2b70
[   11.245919]  ? __do_sys_finit_module+0xb5/0x120
[   11.250496]  __do_sys_finit_module+0xb5/0x120
[   11.254899]  do_syscall_64+0x42/0x80
[   11.258517]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[   11.263624] RIP: 0033:0x7fe76579bd4d
[   11.267247] Code: 00 c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 03 31 0c 00 f7 d8 64 89 01 48
[   11.286138] RSP: 002b:00007ffd7aaa2e08 EFLAGS: 00000246 ORIG_RAX: 0000000000000139
[   11.293772] RAX: ffffffffffffffda RBX: 00005649a8ea6990 RCX: 00007fe76579bd4d
[   11.300964] RDX: 0000000000000000 RSI: 00007fe76592f1e3 RDI: 0000000000000012
[   11.308158] RBP: 0000000000020000 R08: 0000000000000000 R09: 0000000000000000
[   11.315351] R10: 0000000000000012 R11: 0000000000000246 R12: 00007fe76592f1e3
[   11.322544] R13: 0000000000000000 R14: 0000000000000000 R15: 00007ffd7aaa2fc8
[   11.329739] ---[ end trace 2cfbe6d1617011ac ]---
[   11.334825] ------------[ cut here ]------------


HTH,
 VK

