Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46E9A398D54
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 16:43:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230487AbhFBOpd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 10:45:33 -0400
Received: from mga02.intel.com ([134.134.136.20]:45860 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230400AbhFBOp3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Jun 2021 10:45:29 -0400
IronPort-SDR: a3SHGyFlH0R+CYlYuaRFT4IlHrpBBVvTqUbFU4PNdOjBfUvA/lTNGaUKZydeu84mWwXu7vkMNV
 Jmj2ZqMaVD4Q==
X-IronPort-AV: E=McAfee;i="6200,9189,10003"; a="190917452"
X-IronPort-AV: E=Sophos;i="5.83,242,1616482800"; 
   d="scan'208";a="190917452"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2021 07:43:43 -0700
IronPort-SDR: jCEk/b9jEibEey8Vn66j4qjbpaxEhVWl8KOBKe9Zic1XNgYHYI8pH3hPfpPPnvm9AYTZpZQmIM
 WLo3gLlrdWuA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,242,1616482800"; 
   d="scan'208";a="400030606"
Received: from linux.intel.com ([10.54.29.200])
  by orsmga006.jf.intel.com with ESMTP; 02 Jun 2021 07:43:42 -0700
Received: from linux.intel.com (unknown [10.88.229.80])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id 723C55805F0;
        Wed,  2 Jun 2021 07:43:39 -0700 (PDT)
Date:   Wed, 2 Jun 2021 22:43:36 +0800
From:   Wong Vee Khee <vee.khee.wong@linux.intel.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [RFC PATCH v2 net-next 9/9] net: pcs: xpcs: convert to
 phylink_pcs_ops
Message-ID: <20210602144336.GA30309@linux.intel.com>
References: <20210601003325.1631980-1-olteanv@gmail.com>
 <20210601003325.1631980-10-olteanv@gmail.com>
 <20210601121032.GV30436@shell.armlinux.org.uk>
 <20210602134321.ppvusilvmmybodtx@skbuf>
 <20210602134749.GL30436@shell.armlinux.org.uk>
 <20210602140233.3zk6mtr7turmza2r@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210602140233.3zk6mtr7turmza2r@skbuf>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 02, 2021 at 05:02:33PM +0300, Vladimir Oltean wrote:
> On Wed, Jun 02, 2021 at 02:47:49PM +0100, Russell King (Oracle) wrote:
> > On Wed, Jun 02, 2021 at 04:43:21PM +0300, Vladimir Oltean wrote:
> > > On Tue, Jun 01, 2021 at 01:10:33PM +0100, Russell King (Oracle) wrote:
> > > > On Tue, Jun 01, 2021 at 03:33:25AM +0300, Vladimir Oltean wrote:
> > > > >  static const struct phylink_mac_ops stmmac_phylink_mac_ops = {
> > > > >  	.validate = stmmac_validate,
> > > > > -	.mac_pcs_get_state = stmmac_mac_pcs_get_state,
> > > > > -	.mac_config = stmmac_mac_config,
> > > > 
> > > > mac_config is still a required function.
> > > 
> > > This is correct, thanks.
> > > 
> > > VK, would you mind testing again with this extra patch added to the mix?
> > > If it works, I will add it to the series in v3, ordered properly.
> > > 
> > > -----------------------------[ cut here]-----------------------------
> > > From a79863027998451c73d5bbfaf1b77cf6097a110c Mon Sep 17 00:00:00 2001
> > > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> > > Date: Wed, 2 Jun 2021 16:35:55 +0300
> > > Subject: [PATCH] net: phylink: allow the mac_config method to be missing if
> > >  pcs_ops are provided
> > > 
> > > The pcs_config method from struct phylink_pcs_ops does everything that
> > > the mac_config method from struct phylink_mac_ops used to do in the
> > > legacy approach of driving a MAC PCS. So allow drivers to not implement
> > > the mac_config method if there is nothing to do. Keep the method
> > > required for setups that do not provide pcs_ops.
> > > 
> > > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> > > ---
> > >  drivers/net/phy/phylink.c | 9 +++++++++
> > >  1 file changed, 9 insertions(+)
> > > 
> > > diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
> > > index 96d8e88b4e46..a8842c6ce3a2 100644
> > > --- a/drivers/net/phy/phylink.c
> > > +++ b/drivers/net/phy/phylink.c
> > > @@ -415,6 +415,9 @@ static void phylink_resolve_flow(struct phylink_link_state *state)
> > >  static void phylink_mac_config(struct phylink *pl,
> > >  			       const struct phylink_link_state *state)
> > >  {
> > > +	if (!pl->mac_ops->mac_config)
> > > +		return;
> > > +
> > >  	phylink_dbg(pl,
> > >  		    "%s: mode=%s/%s/%s/%s adv=%*pb pause=%02x link=%u an=%u\n",
> > >  		    __func__, phylink_an_mode_str(pl->cur_link_an_mode),
> > > @@ -1192,6 +1195,12 @@ void phylink_start(struct phylink *pl)
> > >  
> > >  	ASSERT_RTNL();
> > >  
> > > +	/* The mac_ops::mac_config method may be absent only if the
> > > +	 * pcs_ops are present.
> > > +	 */
> > > +	if (WARN_ON_ONCE(!pl->mac_ops->mac_config && !pl->pcs_ops))
> > > +		return;
> > > +
> > >  	phylink_info(pl, "configuring for %s/%s link mode\n",
> > >  		     phylink_an_mode_str(pl->cur_link_an_mode),
> > >  		     phy_modes(pl->link_config.interface));
> > 
> > I would rather we didn't do that - I suspect your case is not the
> > common scenario, so please add a dummy function to stmmac instead.
> 
> Ok, in that case the only delta to be applied should be:
> 
> -----------------------------[ cut here]-----------------------------
> >From 998569108392befc591f790e46fe5dcd1d0b6278 Mon Sep 17 00:00:00 2001
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> Date: Wed, 2 Jun 2021 17:00:12 +0300
> Subject: [PATCH] fixup! net: pcs: xpcs: convert to phylink_pcs_ops
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> index d5685a74f3b7..704aa91b145a 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> @@ -1000,6 +1000,12 @@ static void stmmac_validate(struct phylink_config *config,
>  		xpcs_validate(priv->hw->xpcs, supported, state);
>  }
>  
> +static void stmmac_mac_config(struct phylink_config *config, unsigned int mode,
> +			      const struct phylink_link_state *state)
> +{
> +	/* Nothing to do, xpcs_config() handles everything */
> +}
> +
>  static void stmmac_fpe_link_state_handle(struct stmmac_priv *priv, bool is_up)
>  {
>  	struct stmmac_fpe_cfg *fpe_cfg = priv->plat->fpe_cfg;
> -----------------------------[ cut here]-----------------------------

No luck.. I am still seeing the same kernel panic on my side with the
additional patch applied:

[   12.513652] intel-eth-pci 0000:00:1e.4 enp0s30f4: FPE workqueue start
[   12.520079] intel-eth-pci 0000:00:1e.4 enp0s30f4: configuring for inband/sgmii link mode
[   12.528141] BUG: kernel NULL pointer dereference, address: 0000000000000000
[   12.535072] #PF: supervisor instruction fetch in kernel mode
[   12.540719] #PF: error_code(0x0010) - not-present page
[   12.545843] PGD 0 P4D 0
[   12.548382] Oops: 0010 [#1] PREEMPT SMP NOPTI
[   12.552733] CPU: 3 PID: 2657 Comm: connmand Tainted: G     U            5.13.0-rc3-intel-lts #79
[   12.561485] Hardware name: Intel Corporation Tiger Lake Client Platform/TigerLake U DDR4 SODIMM RVP, BIOS TGLIFUI1.R00.3373.AF0.2009230546 09/23/2020
[   12.574803] RIP: 0010:0x0
[   12.577436] Code: Unable to access opcode bytes at RIP 0xffffffffffffffd6.
[   12.584280] RSP: 0018:ffffaa05404efb78 EFLAGS: 00010246
[   12.589489] RAX: 0000000000000000 RBX: ffffa0fb91758c00 RCX: 0000000000000000
[   12.596600] RDX: ffffaa05404efba0 RSI: 0000000000000002 RDI: ffffa0facc63c4d8
[   12.603711] RBP: ffffaa05404efba0 R08: 0000000000000000 R09: ffffaa05404ef888
[   12.610825] R10: 0000000000000001 R11: 0000000000000001 R12: 0000000000000001
[   12.617935] R13: ffffa0facc6388c0 R14: 0000000000000006 R15: 0000000000000001
[   12.625040] FS:  00007f4a6d5b87c0(0000) GS:ffffa0fc57f80000(0000) knlGS:0000000000000000
[   12.633096] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   12.638825] CR2: ffffffffffffffd6 CR3: 000000010e3f6004 CR4: 0000000000770ee0
[   12.645932] PKRU: 55555554
[   12.648641] Call Trace:
[   12.651095]  phylink_major_config+0x5e/0x1a0 [phylink]
[   12.656219]  phylink_start+0x204/0x2c0 [phylink]
[   12.660833]  stmmac_open+0x3d0/0x9f0 [stmmac]
[   12.665186]  __dev_open+0xe7/0x180
[   12.668594]  __dev_change_flags+0x174/0x1d0
[   12.672773]  ? __thaw_task+0x40/0x40
[   12.676348]  ? arch_stack_walk+0x9e/0xf0
[   12.680266]  dev_change_flags+0x21/0x60
[   12.684100]  devinet_ioctl+0x5e8/0x750
[   12.687847]  inet_ioctl+0x190/0x1c0
[   12.691335]  ? dev_ioctl+0x26d/0x4c0
[   12.694907]  sock_do_ioctl+0x44/0x140
[   12.698569]  ? alloc_empty_file+0x61/0xb0
[   12.702572]  sock_ioctl+0x22c/0x320
[   12.706061]  __x64_sys_ioctl+0x80/0xb0
[   12.709808]  do_syscall_64+0x42/0x80
[   12.713381]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[   12.718425] RIP: 0033:0x7f4a6db054bb
[   12.721995] Code: 0f 1e fa 48 8b 05 c5 69 0c 00 64 c7 00 26 00 00 00 48 c7 c0 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 95 69 0c 00 f7 d8 64 89 01 48
[   12.740656] RSP: 002b:00007ffdeab00da8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[   12.748194] RAX: ffffffffffffffda RBX: 0000562741681100 RCX: 00007f4a6db054bb
[   12.755300] RDX: 00007ffdeab00db0 RSI: 0000000000008914 RDI: 0000000000000010
[   12.762405] RBP: 0000000000000010 R08: 0000562741681100 R09: 0000000000000000
[   12.769510] R10: 000056274162e010 R11: 0000000000000246 R12: 0000000000000000
[   12.776613] R13: 00007ffdeab00db0 R14: 0000000000000001 R15: 00007ffdeab014f0
[   12.783721] Modules linked in: bluetooth ecryptfs hid_sensor_incl_3d hid_sensor_magn_3d hid_sensor_gyro_3d hid_sensor_als hid_sensor_accel_3d hid_sensor_trigger hid_sensor_iio_common hid_sensor_custom hid_sensor_hub intel_ishtp_loader intel_ishtp_hid mxl_gpy x86_pkg_temp_thermal ax88179_178a dwmac_intel usbnet mii stmmac dwc3 atkbd kvm_intel pcs_xpcs mei_wdt phylink mei_hdcp udc_core kvm libps2 libphy mei_me i915 irqbypass spi_pxa2xx_platform intel_rapl_msr pcspkr dw_dmac wdat_wdt i2c_i801 dw_dmac_core i2c_smbus intel_ish_ipc mei intel_ishtp dwc3_pci thermal tpm_crb tpm_tis tpm_tis_core intel_pmc_core parport_pc i8042 parport tpm sch_fq_codel uhid fuse configfs snd_hda_intel snd_intel_dspcfg snd_intel_sdw_acpi snd_hda_codec snd_hda_core snd_pcm snd_timer snd soundcore
[   12.851290] CR2: 0000000000000000
[   12.854603] ---[ end trace 52b9ca69be06d1e3 ]---


My git log:-
dc25bc46886e (HEAD -> master) phy: maxlinear: add Maxlinear GPY115/21x/24x driver
d059f32fcef1 fixup! net: pcs: xpcs: convert to phylink_pcs_ops
1a1a9c7267c1 net: pcs: xpcs: convert to phylink_pcs_ops
ec25f3c80108 net: pcs: xpcs: convert to mdio_device
912a23a5768a net: pcs: xpcs: use mdiobus_c45_addr in xpcs_{read,write}
af2bd0a4e32c net: pcs: xpcs: export xpcs_probe
7e4eea51132f net: pcs: xpcs: export xpcs_config_eee
37d5e086fc83 net: pcs: xpcs: export xpcs_validate
d58487edb1a8 net: pcs: xpcs: make the checks related to the PHY interface mode stateless
2f0eba94af8d net: pcs: xpcs: there is only one PHY ID
67148dd06896 net: pcs: xpcs: delete shim definition for mdio_xpcs_get_ops()
5fe8e519e44f (origin/master, origin/HEAD) Merge git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next

HTH,
 VK
