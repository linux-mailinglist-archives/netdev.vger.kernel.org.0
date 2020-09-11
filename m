Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFAB4266A1B
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 23:34:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725921AbgIKVe3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 17:34:29 -0400
Received: from mga06.intel.com ([134.134.136.31]:9794 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725894AbgIKVeJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Sep 2020 17:34:09 -0400
IronPort-SDR: +QaRkwa+PqMh171DzcrQGms/z2qht/L2rUyYRUc57w1JvOuxZWA5P5ymgAYB+PJiCRXzr58J+m
 6/WdFoRX1uUg==
X-IronPort-AV: E=McAfee;i="6000,8403,9741"; a="220414097"
X-IronPort-AV: E=Sophos;i="5.76,417,1592895600"; 
   d="scan'208";a="220414097"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2020 14:34:07 -0700
IronPort-SDR: e8FXOrcrTkIuyS72dqB6sdKM/KvMfp2AqBqUQ9K/8ftDjVOesN71p64Fh7PVlpGS5XRcjqh5ta
 E7KyCCpGMSAw==
X-IronPort-AV: E=Sophos;i="5.76,417,1592895600"; 
   d="scan'208";a="450118909"
Received: from jbrandeb-mobl3.amr.corp.intel.com (HELO localhost) ([10.209.99.126])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2020 14:34:07 -0700
Date:   Fri, 11 Sep 2020 14:34:05 -0700
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org
Subject: Re: [RFC PATCH net-next v1 00/11] make drivers/net/ethernet W=1
 clean
Message-ID: <20200911143405.00004085@intel.com>
In-Reply-To: <20200911131238.1069129c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20200911012337.14015-1-jesse.brandeburg@intel.com>
        <20200911075515.6d81066b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200911120005.00000178@intel.com>
        <20200911131238.1069129c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Mailer: Claws Mail 3.12.0 (GTK+ 2.24.28; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski wrote:

> Yeah, maybe you need COMPILE_TEST? (full list of the warnings triggered
> by the last patch at the end of the email)

Ah, good idea, I checked and I have that set, however, I understand
what's going on now.
 
> > but I'd like to target the actual job you're running and use that as
> > the short-term goal.
> 
> If the code is of any use:
> 
> https://github.com/kuba-moo/nipa
> 
> But it expects to run against a patchwork instance.

Thanks! that's interesting on it's own!

> 
> > Also, if you have any comments about the removal of the lvalue from
> > some of the register read operations, I figure that is the riskiest
> > part of all this.
> 
> Nothing looked suspicious to me. Besides if the compiler is warning that
> the variable is unused I'm pretty sure it will optimize that variable
> out, anyway so machine code shouldn't change with this series.

Good point, I'll check that.
 
 
> ../drivers/net/ethernet/atheros/atlx/atl1.c:1999:26: warning: cast to restricted __le16
> ../drivers/net/ethernet/atheros/atlx/atl1.c:2060:33: warning: cast to restricted __le16
> ../drivers/net/ethernet/atheros/atlx/atl1.c:2125:45: warning: invalid assignment: |=
> ../drivers/net/ethernet/atheros/atlx/atl1.c:2125:45:    left side has type restricted __le32

<snip>

If I'm not mistaken *all* the warnings you had listed are from C=1
(sparse) which would be best fixed with a second set of patches. This
set of patches only aimed to get rid of the W=1 (gcc warnings and kdoc
warnings from scripts/kernel-doc)

If you run the commands separately you'll see what I mean.
make W=1 M=drivers/net/ethernet
make C=2 M=drivers/net/ethernet

C=2 will force the sparse check but unfortunately will also rebuild
everything again.

I see about 1188 unique sparse warnings in drivers/net/ethernet and
only 16 unique errors from sparse.  It's a lot but fixable. However my
experience with these warnings is that I could break something in
fixing them on drivers I can't test.

I just did some spelunking on the sparse warnings, there are only 82
different ones (many are repeated).  About half are context
imbalances where a lock maybe isn't released. I would bet a bunch are
undetected bugs.

TL;DR

Here is a list of driver files with sparse warnings from C=1, maybe we
can encourage some others to help me fix them?

drivers/net/ethernet/3com/3c509.c
drivers/net/ethernet/3com/3c574_cs.c
drivers/net/ethernet/3com/3c589_cs.c
drivers/net/ethernet/3com/3c59x.c
drivers/net/ethernet/3com/typhoon.c
drivers/net/ethernet/8390/axnet_cs.c
drivers/net/ethernet/8390/ne2k-pci.c
drivers/net/ethernet/8390/pcnet_cs.c
drivers/net/ethernet/adaptec/starfire.c
drivers/net/ethernet/alacritech/slicoss.c
drivers/net/ethernet/alteon/acenic.c
drivers/net/ethernet/amd/pcnet32.c
drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2.c
drivers/net/ethernet/arc/emac_main.c
drivers/net/ethernet/atheros/alx/main.c
drivers/net/ethernet/atheros/atl1c/atl1c_hw.c
drivers/net/ethernet/atheros/atl1c/atl1c_main.c
drivers/net/ethernet/atheros/atl1e/atl1e_main.c
drivers/net/ethernet/atheros/atlx/atl1.c
drivers/net/ethernet/broadcom/bnx2.c
drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c
drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
drivers/net/ethernet/broadcom/cnic.c
drivers/net/ethernet/broadcom/tg3.c
drivers/net/ethernet/brocade/bna/bfa_cee.c
drivers/net/ethernet/brocade/bna/bfa_ioc.c
drivers/net/ethernet/brocade/bna/bfa_ioc.h
drivers/net/ethernet/brocade/bna/bfa_msgq.c
drivers/net/ethernet/brocade/bna/bnad.c
drivers/net/ethernet/brocade/bna/bna_enet.c
drivers/net/ethernet/brocade/bna/bna_tx_rx.c
drivers/net/ethernet/cadence/macb_main.c
drivers/net/ethernet/cavium/liquidio/cn23xx_pf_device.c
drivers/net/ethernet/cavium/liquidio/cn23xx_vf_device.c
drivers/net/ethernet/cavium/liquidio/lio_core.c
drivers/net/ethernet/cavium/liquidio/lio_main.c
drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
drivers/net/ethernet/cavium/liquidio/lio_vf_rep.c
drivers/net/ethernet/cavium/liquidio/octeon_mailbox.c
drivers/net/ethernet/cavium/liquidio/request_manager.c
drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
drivers/net/ethernet/chelsio/cxgb3/sge.c
drivers/net/ethernet/chelsio/cxgb3/t3_hw.c
drivers/net/ethernet/chelsio/cxgb4vf/sge.c
drivers/net/ethernet/chelsio/cxgb/sge.c
drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
drivers/net/ethernet/chelsio/libcxgb/libcxgb_ppm.c
drivers/net/ethernet/cisco/enic/enic_ethtool.c
drivers/net/ethernet/cisco/enic/enic_main.c
drivers/net/ethernet/cisco/enic/enic_pp.c
drivers/net/ethernet/cisco/enic/vnic_vic.c
drivers/net/ethernet/dlink/dl2k.c
drivers/net/ethernet/dlink/sundance.c
drivers/net/ethernet/emulex/benet/be_cmds.c
drivers/net/ethernet/emulex/benet/be_main.c
drivers/net/ethernet/ethoc.c
drivers/net/ethernet/freescale/dpaa2/dpmac.c
drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
drivers/net/ethernet/freescale/enetc/enetc_hw.h
drivers/net/ethernet/freescale/enetc/enetc_qos.c
drivers/net/ethernet/freescale/fsl_pq_mdio.c
drivers/net/ethernet/freescale/gianfar.c
drivers/net/ethernet/freescale/xgmac_mdio.c
drivers/net/ethernet/huawei/hinic/hinic_common.c
drivers/net/ethernet/huawei/hinic/hinic_hw_api_cmd.c
drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c
drivers/net/ethernet/huawei/hinic/hinic_hw_eqs.c
drivers/net/ethernet/huawei/hinic/hinic_hw_io.c
drivers/net/ethernet/huawei/hinic/hinic_hw_mbox.c
drivers/net/ethernet/huawei/hinic/hinic_hw_qp.c
drivers/net/ethernet/huawei/hinic/hinic_hw_wq.c
drivers/net/ethernet/huawei/hinic/hinic_main.c
drivers/net/ethernet/huawei/hinic/hinic_port.c
drivers/net/ethernet/huawei/hinic/hinic_rx.c
drivers/net/ethernet/huawei/hinic/hinic_tx.c
drivers/net/ethernet/intel/e1000/e1000_ethtool.c
drivers/net/ethernet/intel/e100.c
drivers/net/ethernet/intel/fm10k/fm10k_pci.c
drivers/net/ethernet/intel/i40e/i40e_main.c
drivers/net/ethernet/intel/i40e/i40e_txrx.c
drivers/net/ethernet/intel/i40e/i40e_xsk.c
drivers/net/ethernet/intel/igb/igb_ethtool.c
drivers/net/ethernet/intel/igb/igb_main.c
drivers/net/ethernet/intel/igb/igb_ptp.c
drivers/net/ethernet/intel/igbvf/netdev.c
drivers/net/ethernet/intel/igc/igc_dump.c
drivers/net/ethernet/intel/igc/igc_ethtool.c
drivers/net/ethernet/intel/ixgbe/ixgbe_82599.c
drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c
drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
drivers/net/ethernet/jme.c
drivers/net/ethernet/marvell/mv643xx_eth.c
drivers/net/ethernet/marvell/mvneta.c
drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
drivers/net/ethernet/marvell/octeontx2/af/rvu.c
drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
drivers/net/ethernet/marvell/skge.c
drivers/net/ethernet/marvell/sky2.c
drivers/net/ethernet/micrel/ks8851_par.c
drivers/net/ethernet/micrel/ksz884x.c
drivers/net/ethernet/myricom/myri10ge/myri10ge.c
drivers/net/ethernet/natsemi/ns83820.c
drivers/net/ethernet/neterion/s2io.c
drivers/net/ethernet/neterion/vxge/vxge-config.c
drivers/net/ethernet/neterion/vxge/vxge-main.c
drivers/net/ethernet/nvidia/forcedeth.c
drivers/net/ethernet/nxp/lpc_eth.c
drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
drivers/net/ethernet/packetengines/hamachi.c
drivers/net/ethernet/qlogic/netxen/netxen_nic_ctx.c
drivers/net/ethernet/qlogic/netxen/netxen_nic_ethtool.c
drivers/net/ethernet/qlogic/netxen/netxen_nic_hw.c
drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c
drivers/net/ethernet/qlogic/qed/qed_mcp.c
drivers/net/ethernet/qualcomm/emac/emac-mac.c
drivers/net/ethernet/qualcomm/qca_7k_common.c
drivers/net/ethernet/realtek/8139too.c
drivers/net/ethernet/renesas/sh_eth.c
drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
drivers/net/ethernet/stmicro/stmmac/dwmac-anarion.c
drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c
drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c
drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
drivers/net/ethernet/sun/cassini.c
drivers/net/ethernet/synopsys/dwc-xlgmac-hw.c
drivers/net/ethernet/ti/tlan.c
drivers/net/ethernet/via/via-rhine.c
drivers/net/ethernet/via/via-velocity.c
drivers/net/ethernet/via/via-velocity.h
drivers/net/ethernet/xilinx/ll_temac_main.c
drivers/net/ethernet/xilinx/xilinx_axienet_main.c

