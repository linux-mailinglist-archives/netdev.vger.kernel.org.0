Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91BE6269D4B
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 06:25:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726405AbgIOEYe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 00:24:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:42274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726123AbgIOEYc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Sep 2020 00:24:32 -0400
Received: from sx1.lan (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2356D20771;
        Tue, 15 Sep 2020 04:24:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600143870;
        bh=2+KoI+dw4u7gm2YW5td6mFufi41IZ2J/gWNqWNQ7nEM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=vmz+Nn9Ty/S2IFDd2vsu2VWx8sdH0ov7e2iVGv9IE/oFtj0vnAq4cb3U/3o8Z04vd
         5CJwUjaEf5jd7Lp8PM3yxcBKOHj/VgRJREHz9cv68EFBKc4NHotZBXOXXMW6N8ZmTe
         IefA+twxeYIZ553PsskFnokyT/x1xu3/MGfLAoZw=
Message-ID: <a28498acdf87f11e81d3282d63f18dbe1a3d5329.camel@kernel.org>
Subject: Re: [PATCH net-next v2 00/10] make drivers/net/ethernet W=1 clean
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        netdev@vger.kernel.org
Cc:     intel-wired-lan@lists.osuosl.org
Date:   Mon, 14 Sep 2020 21:24:28 -0700
In-Reply-To: <20200915014455.1232507-1-jesse.brandeburg@intel.com>
References: <20200915014455.1232507-1-jesse.brandeburg@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2020-09-14 at 18:44 -0700, Jesse Brandeburg wrote:
> After applying the patches below, the drivers/net/ethernet
> directory can be built as modules with W=1 with no warnings (so
> far on x64_64 arch only!).
> As Jakub pointed out, there is much more work to do to clean up
> C=1, but that will be another series of changes.
> 
> This series removes 1,283 warnings and hopefully allows the
> ethernet directory to move forward from here without more
> warnings being added. There is only one objtool warning now.
> 
> Some of these patches are already sent to Intel Wired Lan, but
> the rest of the series titled drivers/net/ethernet affects other
> drivers. The changes are all pretty straightforward.
> 
> As part of testing this series I realized that I have ~1,500 more
> kdoc warnings to fix due to being in other arch or not compiled
> with my x86_64 .config. Feel free to run
> $ 'git ls-files *.[ch] | grep drivers/net/ethernet | xargs
> scripts/kernel-doc -none'
> to see the remaining issues.
> 

Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>

Hi Jesse, 
What was the criteria to select which drivers to enable in your .config
?

I think we need some automation here and have a well known .config that
enables as many drivers as we can for static + compilation testing,
otherwise we are going to need to repeat this patch every 2-3 months.

I know Jakub and Dave do some compilation testing before merging but i
don't know how much driver coverage they have and if they use a
specific .config or they just manually create one on demand..

bottom line, we need a bot after this series is applied.
All we need is to daily apply all ongoing patches to some testing
branch and let 0-DAY kernel test [1] run on it with whatever make
command we define and with all drivers enabled.
         
[1] https://lists.01.org/pipermail/kbuild-all 

> ---
> 
> Q: Maybe I can fix the remaining warnings in a followup patch? If
> I try to put it on this series it will make it much larger
> (double).
> 
> changes in v2:
> 	- non-rfc
> 	- addressed list comments from Edward Cree, Jacob Keller and
> 	  Vinicius Costa Gomes
> 	- re-split the Intel patches into functional and kdoc only
> 	- split out the sfc changes that generated discussion to
> 	  a single patch.
> 
> Jesse Brandeburg (10):
>   i40e: prepare flash string in a simpler way
>   intel-ethernet: clean up W=1 warnings in kdoc
>   intel: handle unused assignments
>   drivers/net/ethernet: clean up unused assignments
>   drivers/net/ethernet: rid ethernet of no-prototype warnings
>   drivers/net/ethernet: handle one warning explicitly
>   drivers/net/ethernet: add some basic kdoc tags
>   drivers/net/ethernet: remove incorrectly formatted doc
>   sfc: fix kdoc warning
>   drivers/net/ethernet: clean up mis-targeted comments
> 
>  drivers/net/ethernet/amazon/ena/ena_com.c     |   2 +-
>  .../aquantia/atlantic/hw_atl/hw_atl_b0.c      |   2 +-
>  drivers/net/ethernet/arc/emac_arc.c           |   2 +-
>  .../net/ethernet/atheros/atl1c/atl1c_main.c   |   6 +-
>  .../net/ethernet/atheros/atl1e/atl1e_main.c   |   7 +-
>  drivers/net/ethernet/atheros/atlx/atl1.c      |   2 +-
>  drivers/net/ethernet/atheros/atlx/atl2.c      |   6 +-
>  .../net/ethernet/broadcom/bnx2x/bnx2x_cmn.c   |   2 +
>  .../ethernet/broadcom/bnx2x/bnx2x_ethtool.c   |   6 +-
>  .../net/ethernet/broadcom/bnx2x/bnx2x_main.c  |  12 +-
>  .../net/ethernet/broadcom/bnx2x/bnx2x_sp.c    |  98 ++---
>  drivers/net/ethernet/brocade/bna/bfa_cee.c    |  20 +-
>  drivers/net/ethernet/brocade/bna/bfa_ioc.c    |   8 +-
>  drivers/net/ethernet/brocade/bna/bnad.c       |   7 +-
>  drivers/net/ethernet/cadence/macb_main.c      |   6 +-
>  drivers/net/ethernet/cadence/macb_pci.c       |   2 +-
>  drivers/net/ethernet/calxeda/xgmac.c          |   2 +
>  .../ethernet/cavium/liquidio/cn68xx_device.c  |   1 +
>  .../net/ethernet/cavium/liquidio/lio_core.c   |  92 ++---
>  .../net/ethernet/cavium/liquidio/lio_main.c   | 351 +++++++++-------
> --
>  .../ethernet/cavium/liquidio/lio_vf_main.c    | 158 ++++----
>  .../ethernet/cavium/liquidio/octeon_console.c |  12 +-
>  .../ethernet/cavium/liquidio/octeon_device.c  |  13 +-
>  .../ethernet/cavium/liquidio/octeon_droq.c    |   2 +-
>  .../ethernet/cavium/liquidio/octeon_mailbox.c |   5 +-
>  .../ethernet/cavium/liquidio/octeon_mem_ops.c |   1 +
>  .../net/ethernet/chelsio/cxgb3/cxgb3_main.c   |   8 +-
>  drivers/net/ethernet/chelsio/cxgb3/sge.c      |  28 +-
>  drivers/net/ethernet/chelsio/cxgb3/t3_hw.c    |   5 +-
>  drivers/net/ethernet/cisco/enic/enic_api.c    |   2 +-
>  .../net/ethernet/cisco/enic/enic_ethtool.c    |   2 +-
>  drivers/net/ethernet/cortina/gemini.c         |   8 +-
>  drivers/net/ethernet/dec/tulip/de4x5.c        |   4 +-
>  drivers/net/ethernet/dec/tulip/media.c        |   5 -
>  drivers/net/ethernet/dnet.c                   |   8 +-
>  drivers/net/ethernet/ethoc.c                  |   6 +-
>  .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  |   2 +-
>  drivers/net/ethernet/freescale/fec_ptp.c      |   8 +-
>  drivers/net/ethernet/freescale/fman/fman.c    |  14 +-
>  .../net/ethernet/freescale/fman/fman_muram.c  |   6 +-
>  .../net/ethernet/freescale/fman/fman_port.c   |  23 +-
>  drivers/net/ethernet/freescale/fman/mac.c     |   4 +-
>  drivers/net/ethernet/hisilicon/hns/hnae.c     |   2 +-
>  .../net/ethernet/hisilicon/hns/hns_dsaf_mac.c |  34 +-
>  .../ethernet/hisilicon/hns/hns_dsaf_main.c    | 148 ++++----
>  .../ethernet/hisilicon/hns/hns_dsaf_misc.c    |   7 +-
>  .../net/ethernet/hisilicon/hns/hns_dsaf_ppe.c |  17 +-
>  .../net/ethernet/hisilicon/hns/hns_dsaf_rcb.c |   7 +-
>  .../ethernet/hisilicon/hns/hns_dsaf_xgmac.c   |   3 +-
>  drivers/net/ethernet/hisilicon/hns/hns_enet.c |   4 +-
>  .../net/ethernet/hisilicon/hns/hns_ethtool.c  |  48 +--
>  .../hisilicon/hns3/hns3pf/hclge_dcb.c         |   1 +
>  drivers/net/ethernet/hisilicon/hns_mdio.c     |   3 +-
>  .../net/ethernet/huawei/hinic/hinic_hw_cmdq.c |   2 +-
>  .../net/ethernet/huawei/hinic/hinic_hw_dev.c  |   6 +-
>  .../net/ethernet/huawei/hinic/hinic_hw_eqs.c  |   1 +
>  .../net/ethernet/huawei/hinic/hinic_hw_if.c   |   1 +
>  .../net/ethernet/huawei/hinic/hinic_hw_mgmt.c |   1 +
>  .../net/ethernet/huawei/hinic/hinic_main.c    |   2 +-
>  drivers/net/ethernet/intel/e100.c             |   8 +-
>  drivers/net/ethernet/intel/e1000/e1000_hw.c   | 147 ++++----
>  drivers/net/ethernet/intel/e1000/e1000_main.c |  39 +-
>  .../net/ethernet/intel/e1000e/80003es2lan.c   |   1 -
>  drivers/net/ethernet/intel/e1000e/ich8lan.c   |  16 +-
>  drivers/net/ethernet/intel/e1000e/netdev.c    |  50 ++-
>  drivers/net/ethernet/intel/e1000e/phy.c       |   3 +
>  drivers/net/ethernet/intel/e1000e/ptp.c       |   2 +-
>  drivers/net/ethernet/intel/i40e/i40e_client.c |   2 -
>  drivers/net/ethernet/intel/i40e/i40e_common.c |   4 +-
>  drivers/net/ethernet/intel/i40e/i40e_ddp.c    |   8 +-
>  drivers/net/ethernet/intel/i40e/i40e_main.c   |  17 +-
>  drivers/net/ethernet/intel/i40e/i40e_ptp.c    |   1 -
>  drivers/net/ethernet/intel/i40e/i40e_txrx.c   |   7 +-
>  .../ethernet/intel/i40e/i40e_virtchnl_pf.c    |   9 +-
>  drivers/net/ethernet/intel/iavf/iavf_main.c   |  20 +-
>  drivers/net/ethernet/intel/igb/e1000_82575.c  |   6 +-
>  drivers/net/ethernet/intel/igb/e1000_i210.c   |   5 +-
>  drivers/net/ethernet/intel/igb/e1000_mac.c    |   1 +
>  drivers/net/ethernet/intel/igb/e1000_mbx.c    |   1 +
>  drivers/net/ethernet/intel/igb/igb_main.c     |  28 +-
>  drivers/net/ethernet/intel/igb/igb_ptp.c      |   8 +-
>  drivers/net/ethernet/intel/igbvf/netdev.c     |  17 +-
>  drivers/net/ethernet/intel/igc/igc_main.c     |   2 +-
>  drivers/net/ethernet/intel/igc/igc_ptp.c      |   4 +-
>  drivers/net/ethernet/intel/ixgb/ixgb_hw.c     | 135 ++++---
>  drivers/net/ethernet/intel/ixgb/ixgb_main.c   |  17 +-
>  drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |   3 +-
>  drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c  |   8 +-
>  .../net/ethernet/intel/ixgbevf/ixgbevf_main.c |   3 +-
>  drivers/net/ethernet/marvell/mvneta.c         |   7 +-
>  drivers/net/ethernet/marvell/pxa168_eth.c     |   3 +-
>  drivers/net/ethernet/mellanox/mlx4/en_tx.c    |   2 +-
>  drivers/net/ethernet/micrel/ksz884x.c         |  59 +--
>  .../ethernet/microchip/encx24j600-regmap.c    |   2 +-
>  drivers/net/ethernet/microchip/lan743x_main.c |   9 +-
>  drivers/net/ethernet/natsemi/ns83820.c        |   6 +-
>  drivers/net/ethernet/neterion/s2io.c          |  91 ++---
>  .../net/ethernet/neterion/vxge/vxge-config.c  |   5 +-
>  .../net/ethernet/neterion/vxge/vxge-ethtool.c |   2 +-
>  .../net/ethernet/neterion/vxge/vxge-main.c    |  10 +-
>  .../net/ethernet/neterion/vxge/vxge-traffic.c |  72 ++--
>  .../oki-semi/pch_gbe/pch_gbe_ethtool.c        |   4 +-
>  .../ethernet/oki-semi/pch_gbe/pch_gbe_main.c  |   5 +-
>  .../ethernet/oki-semi/pch_gbe/pch_gbe_param.c |  14 +-
>  .../net/ethernet/packetengines/yellowfin.c    |   2 +-
>  .../net/ethernet/qlogic/netxen/netxen_nic.h   |   3 -
>  .../qlogic/netxen/netxen_nic_ethtool.c        |   3 +
>  .../ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c   |   3 +-
>  drivers/net/ethernet/qualcomm/emac/emac.c     |   1 +
>  drivers/net/ethernet/realtek/8139cp.c         |   2 +
>  drivers/net/ethernet/renesas/sh_eth.c         |  10 +
>  .../net/ethernet/samsung/sxgbe/sxgbe_main.c   |  17 +-
>  drivers/net/ethernet/sfc/falcon/farch.c       |  29 +-
>  drivers/net/ethernet/sfc/falcon/rx.c          |   2 +
>  drivers/net/ethernet/sfc/falcon/selftest.c    |   2 +-
>  drivers/net/ethernet/sfc/mcdi.h               |   1 +
>  drivers/net/ethernet/sfc/net_driver.h         |   2 +-
>  drivers/net/ethernet/sfc/ptp.c                |   7 +-
>  drivers/net/ethernet/sis/sis900.c             |   8 +-
>  .../net/ethernet/stmicro/stmmac/dwmac-rk.c    |   2 +-
>  .../net/ethernet/stmicro/stmmac/stmmac_main.c |  18 +-
>  .../ethernet/stmicro/stmmac/stmmac_platform.c |   3 +-
>  drivers/net/ethernet/sun/cassini.c            |   4 +-
>  .../net/ethernet/synopsys/dwc-xlgmac-common.c |   2 +-
>  drivers/net/ethernet/tehuti/tehuti.c          |  17 +-
>  drivers/net/ethernet/ti/cpsw_new.c            |   2 -
>  drivers/net/ethernet/ti/davinci_cpdma.c       |   2 +-
>  drivers/net/ethernet/ti/davinci_emac.c        |  10 +-
>  drivers/net/ethernet/ti/tlan.c                |   4 +-
>  drivers/net/ethernet/via/via-rhine.c          |   2 +-
>  drivers/net/ethernet/via/via-velocity.c       |  40 +-
>  drivers/net/ethernet/xilinx/ll_temac_main.c   |  26 +-
>  132 files changed, 1222 insertions(+), 1110 deletions(-)
> 
> 
> base-commit: b55353e2cc1415c1ece3ae34a856309b40bb0b4b

