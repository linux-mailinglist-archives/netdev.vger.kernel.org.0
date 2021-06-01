Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA740396EC3
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 10:20:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233364AbhFAIWK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 04:22:10 -0400
Received: from mga12.intel.com ([192.55.52.136]:52680 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233300AbhFAIWK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 04:22:10 -0400
IronPort-SDR: 63OOVneRAB5Ao5xgi1gwFD1wSuqOmwBZgmi4UVeBE79eS/c3xMLKAmqGNEefA/3+4NJsx5GMcp
 wZndFpkqbS0g==
X-IronPort-AV: E=McAfee;i="6200,9189,10001"; a="183183221"
X-IronPort-AV: E=Sophos;i="5.83,239,1616482800"; 
   d="scan'208";a="183183221"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2021 01:20:17 -0700
IronPort-SDR: 4gFtPXPkZ2YtR5X48ND2vMvAiT/6Mooc4BeqL9IwEpA/lrwQApYD00uaRhA852xoNV6vzaxIVJ
 aHMzkmlbAFFQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,239,1616482800"; 
   d="scan'208";a="632791218"
Received: from linux.intel.com ([10.54.29.200])
  by fmsmga006.fm.intel.com with ESMTP; 01 Jun 2021 01:20:16 -0700
Received: from linux.intel.com (unknown [10.88.229.80])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id 13453580409;
        Tue,  1 Jun 2021 01:20:12 -0700 (PDT)
Date:   Tue, 1 Jun 2021 16:20:09 +0800
From:   Wong Vee Khee <vee.khee.wong@linux.intel.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [RFC PATCH v2 net-next 0/9] Convert xpcs to phylink_pcs_ops
Message-ID: <20210601082009.GA16813@linux.intel.com>
References: <20210601003325.1631980-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210601003325.1631980-1-olteanv@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 01, 2021 at 03:33:16AM +0300, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> This patch series is partially tested (some code paths have been covered
> on the NXP SJA1105) but since I don't have stmmac hardware, it would
> still be appreciated if people from Intel could give this another run.
> 
> Background: the sja1105 DSA driver currently drives a Designware XPCS
> for SGMII and 2500base-X, and it would be nice to reuse some code with
> the xpcs module. This would also help consolidate the phylink_pcs_ops,
> since the only other dedicated PCS driver, currently, is the lynx_pcs.
> 
> Therefore, this series makes the xpcs expose the same kind of API that
> the lynx_pcs module does. The main changes are getting rid of struct
> mdio_xpcs_ops, being compatible with struct phylink_pcs_ops and being
> less reliant on the phy_interface_t passed to xpcs_probe (now renamed to
> xpcs_create).
> 
> Vladimir Oltean (9):
>   net: pcs: xpcs: delete shim definition for mdio_xpcs_get_ops()
>   net: pcs: xpcs: there is only one PHY ID
>   net: pcs: xpcs: make the checks related to the PHY interface mode
>     stateless
>   net: pcs: xpcs: export xpcs_validate
>   net: pcs: xpcs: export xpcs_config_eee
>   net: pcs: xpcs: export xpcs_probe
>   net: pcs: xpcs: use mdiobus_c45_addr in xpcs_{read,write}
>   net: pcs: xpcs: convert to mdio_device
>   net: pcs: xpcs: convert to phylink_pcs_ops
> 
>  drivers/net/ethernet/stmicro/stmmac/common.h  |   3 +-
>  drivers/net/ethernet/stmicro/stmmac/hwif.h    |  14 -
>  .../ethernet/stmicro/stmmac/stmmac_ethtool.c  |  12 +-
>  .../net/ethernet/stmicro/stmmac/stmmac_main.c |  44 +--
>  .../net/ethernet/stmicro/stmmac/stmmac_mdio.c |  47 ++-
>  drivers/net/pcs/pcs-xpcs.c                    | 371 ++++++++++++------
>  include/linux/pcs/pcs-xpcs.h                  |  40 +-
>  7 files changed, 306 insertions(+), 225 deletions(-)

I am seeing kernel panic after applying this patch series on my Intel
Tigerlake board:

[   12.770067] intel-eth-pci 0000:00:1e.4 enp0s30f4: FPE workqueue start
[   12.776481] intel-eth-pci 0000:00:1e.4 enp0s30f4: configuring for inband/sgmii link mode
[   12.784527] BUG: kernel NULL pointer dereference, address: 0000000000000000
[   12.791454] #PF: supervisor instruction fetch in kernel mode
[   12.797083] #PF: error_code(0x0010) - not-present page
[   12.802203] PGD 0 P4D 0
[   12.804739] Oops: 0010 [#1] PREEMPT SMP NOPTI
[   12.809080] CPU: 2 PID: 2023 Comm: connmand Tainted: G     U            5.13.0-rc3-intel-lts #73
[   12.817813] Hardware name: Intel Corporation Tiger Lake Client Platform/TigerLake U DDR4 SODIMM RVP, BIOS TGLIFUI1.R00.3373.AF0.2009230546 09/23/2020
[   12.831105] RIP: 0010:0x0
[   12.833732] Code: Unable to access opcode bytes at RIP 0xffffffffffffffd6.
[   12.840566] RSP: 0018:ffff9f404052bb78 EFLAGS: 00010246
[   12.845771] RAX: 0000000000000000 RBX: ffff93e489bdda00 RCX: 0000000000000000
[   12.852867] RDX: ffff9f404052bba0 RSI: 0000000000000002 RDI: ffff93e4891244d8
[   12.859963] RBP: ffff9f404052bba0 R08: 0000000000000000 R09: ffff9f404052b888
[   12.867054] R10: 0000000000000001 R11: 0000000000000001 R12: 0000000000000001
[   12.874145] R13: ffff93e4891208c0 R14: 0000000000000006 R15: 0000000000000001
[   12.881242] FS:  00007fd656ece7c0(0000) GS:ffff93e617f00000(0000) knlGS:0000000000000000
[   12.889286] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   12.895000] CR2: ffffffffffffffd6 CR3: 000000010e674004 CR4: 0000000000770ee0
[   12.902094] PKRU: 55555554
[   12.904796] Call Trace:
[   12.907245]  phylink_major_config+0x5e/0x1a0 [phylink]
[   12.912368]  phylink_start+0x204/0x2c0 [phylink]
[   12.916971]  stmmac_open+0x3d0/0x9f0 [stmmac]
[   12.921317]  __dev_open+0xe7/0x180
[   12.924710]  __dev_change_flags+0x174/0x1d0
[   12.928882]  ? __thaw_task+0x40/0x40
[   12.932453]  ? arch_stack_walk+0x9e/0xf0
[   12.936363]  dev_change_flags+0x21/0x60
[   12.940188]  devinet_ioctl+0x5e8/0x750
[   12.943925]  ? common_interrupt+0xc0/0xe0
[   12.947927]  inet_ioctl+0x190/0x1c0
[   12.951408]  ? dev_ioctl+0x26d/0x4c0
[   12.954972]  sock_do_ioctl+0x44/0x140
[   12.958627]  ? alloc_empty_file+0x61/0xb0
[   12.962628]  sock_ioctl+0x22c/0x320
[   12.966111]  __x64_sys_ioctl+0x80/0xb0
[   12.969852]  do_syscall_64+0x42/0x80
[   12.973418]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[   12.978446] RIP: 0033:0x7fd65741b4bb
[   12.982015] Code: 0f 1e fa 48 8b 05 c5 69 0c 00 64 c7 00 26 00 00 00 48 c7 c0 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 95 69 0c 00 f7 d8 64 89 01 48
[   13.000645] RSP: 002b:00007ffda8ca3288 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[   13.008170] RAX: ffffffffffffffda RBX: 00005576e8ee2100 RCX: 00007fd65741b4bb
[   13.015262] RDX: 00007ffda8ca3290 RSI: 0000000000008914 RDI: 0000000000000010
[   13.022355] RBP: 0000000000000010 R08: 00005576e8ee2100 R09: 0000000000000000
[   13.029447] R10: 00005576e8e8f010 R11: 0000000000000246 R12: 0000000000000000
[   13.036539] R13: 00007ffda8ca3290 R14: 0000000000000001 R15: 00007ffda8ca39d0
[   13.043633] Modules linked in: bluetooth ecryptfs hid_sensor_gyro_3d hid_sensor_incl_3d hid_sensor_magn_3d hid_sensor_accel_3d hid_sensor_als hid_sensor_trigger hid_sensor_iio_common hid_sensor_custom hid_sensor_hub intel_ishtp_loader intel_ishtp_hid intel_gpy ax88179_178a usbnet dwmac_intel mii x86_pkg_temp_thermal stmmac dwc3 kvm_intel pcs_xpcs mei_wdt mei_hdcp atkbd udc_core libps2 phylink kvm libphy i915 spi_pxa2xx_platform irqbypass intel_rapl_msr mei_me wdat_wdt i2c_i801 pcspkr dw_dmac dw_dmac_core intel_ish_ipc i2c_smbus mei intel_ishtp dwc3_pci tpm_crb thermal parport_pc i8042 tpm_tis parport tpm_tis_core tpm intel_pmc_core sch_fq_codel uhid fuse configfs snd_hda_intel snd_intel_dspcfg snd_intel_sdw_acpi snd_hda_codec snd_hda_core snd_pcm snd_timer snd soundcore
[   13.111247] CR2: 0000000000000000
[   13.114556] ---[ end trace aef3fc6d992073a6 ]---

