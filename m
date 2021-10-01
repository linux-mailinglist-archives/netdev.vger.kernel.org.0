Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E91441F6F7
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 23:32:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355609AbhJAVeT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 17:34:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:35874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355158AbhJAVeS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Oct 2021 17:34:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 43EC161247;
        Fri,  1 Oct 2021 21:32:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633123953;
        bh=vOLbyl3TMuj8IhqlW9t81BHG2iJK6YG0NcGy0vjgzoI=;
        h=From:To:Cc:Subject:Date:From;
        b=isRSXAtD5sLIP+NgllXpV98xab+4FJsjmLq3iHStooxs+htSOxoBh4pY8OYSTK/Dh
         pzqpsG5S+6nfp4p2ngNPZ0V+4jpLOsnd5usvXn4oVxoFzdxe28cWOlXd8RdE+KXvnt
         2DBb8daob5t7clOX1Jj1nDmr0WF6oMp4y44a6Dsi/B5nFUf61HJRKyjgs0foT3nVxl
         fA5xH/V1fpEB5LkOFHuY5htkRwe13qdr4vuMskADcq9R001JQCxLZy1CpERDWSoxLt
         InoSbf1e/eh2+9T5qpu6nszKNKY3W8LYVcLlkk9phba8hGaLbq1gtc6JtiXc4D2KMy
         D7wj88nMaJs1g==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 00/11] Use netdev->dev_addr write helpers (part 1)
Date:   Fri,  1 Oct 2021 14:32:17 -0700
Message-Id: <20211001213228.1735079-1-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 406f42fa0d3c ("net-next: When a bond have a massive amount 
of VLANs...") introduced a rbtree for faster Ethernet address look
up. To maintain netdev->dev_addr in this tree we need to make all
the writes to it got through appropriate helpers.

This is the first installment of predictably tedious conversion.
It tackles:

  memcpy(netdev->dev_addr, something, ETH_ADDR)

and

  ether_addr_copy(netdev->dev_addr, something)

replacing both with eth_hw_addr_set().

The first 7 patches are done entirely by sparse.
Next 4 were semi-manual because the sparse conversion
resulted in errors.

Jakub Kicinski (11):
  arch: use eth_hw_addr_set()
  net: use eth_hw_addr_set()
  ethernet: use eth_hw_addr_set()
  net: usb: use eth_hw_addr_set()
  net: use eth_hw_addr_set() instead of ether_addr_copy()
  ethernet: use eth_hw_addr_set() instead of ether_addr_copy()
  net: usb: use eth_hw_addr_set() instead of ether_addr_copy()
  ethernet: chelsio: use eth_hw_addr_set()
  ethernet: s2io: use eth_hw_addr_set()
  fddi: use eth_hw_addr_set()
  ethernet: use eth_hw_addr_set() - casts

 arch/m68k/emu/nfeth.c                                     | 2 +-
 arch/xtensa/platforms/iss/network.c                       | 2 +-
 drivers/net/ethernet/3com/3c509.c                         | 2 +-
 drivers/net/ethernet/8390/ax88796.c                       | 6 +++---
 drivers/net/ethernet/agere/et131x.c                       | 4 ++--
 drivers/net/ethernet/alacritech/slicoss.c                 | 2 +-
 drivers/net/ethernet/allwinner/sun4i-emac.c               | 2 +-
 drivers/net/ethernet/amazon/ena/ena_netdev.c              | 2 +-
 drivers/net/ethernet/amd/atarilance.c                     | 2 +-
 drivers/net/ethernet/amd/au1000_eth.c                     | 2 +-
 drivers/net/ethernet/amd/nmclan_cs.c                      | 2 +-
 drivers/net/ethernet/amd/pcnet32.c                        | 2 +-
 drivers/net/ethernet/aquantia/atlantic/aq_nic.c           | 2 +-
 drivers/net/ethernet/atheros/alx/main.c                   | 2 +-
 drivers/net/ethernet/broadcom/b44.c                       | 2 +-
 drivers/net/ethernet/broadcom/bcm63xx_enet.c              | 6 +++---
 drivers/net/ethernet/broadcom/bgmac-bcma.c                | 2 +-
 drivers/net/ethernet/broadcom/bgmac.c                     | 2 +-
 drivers/net/ethernet/broadcom/bnx2.c                      | 2 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c          | 2 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c         | 2 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_vfpf.c          | 7 +++----
 drivers/net/ethernet/broadcom/bnxt/bnxt.c                 | 4 ++--
 drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c           | 2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c             | 2 +-
 drivers/net/ethernet/broadcom/genet/bcmgenet.c            | 4 ++--
 drivers/net/ethernet/brocade/bna/bnad.c                   | 4 ++--
 drivers/net/ethernet/cavium/liquidio/lio_core.c           | 2 +-
 drivers/net/ethernet/cavium/liquidio/lio_main.c           | 2 +-
 drivers/net/ethernet/cavium/liquidio/lio_vf_main.c        | 2 +-
 drivers/net/ethernet/cavium/thunder/nicvf_main.c          | 3 +--
 drivers/net/ethernet/chelsio/cxgb/subr.c                  | 2 +-
 drivers/net/ethernet/chelsio/cxgb3/t3_hw.c                | 4 ++--
 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h                | 2 +-
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c                | 2 +-
 drivers/net/ethernet/chelsio/cxgb4vf/adapter.h            | 3 ++-
 drivers/net/ethernet/cirrus/ep93xx_eth.c                  | 2 +-
 drivers/net/ethernet/cirrus/mac89x0.c                     | 2 +-
 drivers/net/ethernet/cortina/gemini.c                     | 4 ++--
 drivers/net/ethernet/davicom/dm9000.c                     | 2 +-
 drivers/net/ethernet/dec/tulip/tulip_core.c               | 2 +-
 drivers/net/ethernet/dlink/sundance.c                     | 2 +-
 drivers/net/ethernet/emulex/benet/be_main.c               | 4 ++--
 drivers/net/ethernet/ethoc.c                              | 4 ++--
 drivers/net/ethernet/ezchip/nps_enet.c                    | 2 +-
 drivers/net/ethernet/faraday/ftgmac100.c                  | 4 ++--
 drivers/net/ethernet/freescale/fec_main.c                 | 2 +-
 drivers/net/ethernet/google/gve/gve_adminq.c              | 2 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c           | 4 ++--
 drivers/net/ethernet/huawei/hinic/hinic_main.c            | 2 +-
 drivers/net/ethernet/ibm/ehea/ehea_main.c                 | 2 +-
 drivers/net/ethernet/ibm/ibmveth.c                        | 4 ++--
 drivers/net/ethernet/ibm/ibmvnic.c                        | 5 ++---
 drivers/net/ethernet/intel/e100.c                         | 2 +-
 drivers/net/ethernet/intel/fm10k/fm10k_netdev.c           | 2 +-
 drivers/net/ethernet/intel/fm10k/fm10k_pci.c              | 4 ++--
 drivers/net/ethernet/intel/i40e/i40e_main.c               | 4 ++--
 drivers/net/ethernet/intel/iavf/iavf_main.c               | 2 +-
 drivers/net/ethernet/intel/iavf/iavf_virtchnl.c           | 4 ++--
 drivers/net/ethernet/intel/ice/ice_main.c                 | 4 ++--
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c         | 6 +++---
 drivers/net/ethernet/jme.c                                | 2 +-
 drivers/net/ethernet/korina.c                             | 2 +-
 drivers/net/ethernet/marvell/mv643xx_eth.c                | 4 ++--
 drivers/net/ethernet/marvell/mvneta.c                     | 2 +-
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c           | 4 ++--
 drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c            | 2 +-
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c  | 2 +-
 drivers/net/ethernet/marvell/prestera/prestera_main.c     | 2 +-
 drivers/net/ethernet/marvell/pxa168_eth.c                 | 2 +-
 drivers/net/ethernet/marvell/skge.c                       | 2 +-
 drivers/net/ethernet/marvell/sky2.c                       | 2 +-
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c            | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c         | 2 +-
 .../net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c    | 2 +-
 drivers/net/ethernet/micrel/ks8851_common.c               | 2 +-
 drivers/net/ethernet/micrel/ksz884x.c                     | 7 +++----
 drivers/net/ethernet/microchip/enc28j60.c                 | 4 ++--
 drivers/net/ethernet/microchip/lan743x_main.c             | 4 ++--
 drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c     | 2 +-
 drivers/net/ethernet/microsoft/mana/mana_en.c             | 2 +-
 drivers/net/ethernet/mscc/ocelot_net.c                    | 4 ++--
 drivers/net/ethernet/myricom/myri10ge/myri10ge.c          | 2 +-
 drivers/net/ethernet/neterion/s2io.c                      | 2 +-
 drivers/net/ethernet/neterion/vxge/vxge-main.c            | 2 +-
 drivers/net/ethernet/netronome/nfp/abm/main.c             | 2 +-
 drivers/net/ethernet/netronome/nfp/nfp_net_main.c         | 2 +-
 drivers/net/ethernet/netronome/nfp/nfp_netvf_main.c       | 2 +-
 drivers/net/ethernet/ni/nixge.c                           | 2 +-
 drivers/net/ethernet/nvidia/forcedeth.c                   | 2 +-
 drivers/net/ethernet/nxp/lpc_eth.c                        | 2 +-
 drivers/net/ethernet/qlogic/qede/qede_filter.c            | 4 ++--
 drivers/net/ethernet/qlogic/qede/qede_main.c              | 2 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c          | 2 +-
 drivers/net/ethernet/qualcomm/emac/emac.c                 | 2 +-
 drivers/net/ethernet/renesas/sh_eth.c                     | 2 +-
 drivers/net/ethernet/seeq/sgiseeq.c                       | 2 +-
 drivers/net/ethernet/sfc/ef100_nic.c                      | 2 +-
 drivers/net/ethernet/sfc/ef10_sriov.c                     | 2 +-
 drivers/net/ethernet/sfc/efx.c                            | 2 +-
 drivers/net/ethernet/sfc/efx_common.c                     | 4 ++--
 drivers/net/ethernet/sfc/falcon/efx.c                     | 6 +++---
 drivers/net/ethernet/sgi/ioc3-eth.c                       | 2 +-
 drivers/net/ethernet/sgi/meth.c                           | 2 +-
 drivers/net/ethernet/smsc/smsc911x.c                      | 4 ++--
 drivers/net/ethernet/socionext/netsec.c                   | 2 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c         | 2 +-
 drivers/net/ethernet/sun/niu.c                            | 4 ++--
 drivers/net/ethernet/sun/sungem.c                         | 2 +-
 drivers/net/ethernet/sun/sunhme.c                         | 8 ++++----
 drivers/net/ethernet/sun/sunqe.c                          | 2 +-
 drivers/net/ethernet/ti/am65-cpsw-nuss.c                  | 2 +-
 drivers/net/ethernet/ti/cpsw.c                            | 6 +++---
 drivers/net/ethernet/ti/cpsw_new.c                        | 4 ++--
 drivers/net/ethernet/ti/davinci_emac.c                    | 2 +-
 drivers/net/ethernet/ti/netcp_core.c                      | 2 +-
 drivers/net/ethernet/toshiba/ps3_gelic_net.c              | 2 +-
 drivers/net/ethernet/toshiba/spider_net.c                 | 2 +-
 drivers/net/ethernet/toshiba/tc35815.c                    | 2 +-
 drivers/net/ethernet/wiznet/w5100.c                       | 4 ++--
 drivers/net/ethernet/wiznet/w5300.c                       | 4 ++--
 drivers/net/ethernet/xilinx/ll_temac_main.c               | 4 ++--
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c         | 2 +-
 drivers/net/ethernet/xscale/ixp4xx_eth.c                  | 2 +-
 drivers/net/fddi/skfp/skfddi.c                            | 5 +++--
 drivers/net/hyperv/netvsc_drv.c                           | 2 +-
 drivers/net/ipvlan/ipvlan_main.c                          | 4 ++--
 drivers/net/macsec.c                                      | 2 +-
 drivers/net/macvlan.c                                     | 4 ++--
 drivers/net/usb/aqc111.c                                  | 2 +-
 drivers/net/usb/asix_common.c                             | 2 +-
 drivers/net/usb/asix_devices.c                            | 2 +-
 drivers/net/usb/ax88172a.c                                | 2 +-
 drivers/net/usb/ax88179_178a.c                            | 4 ++--
 drivers/net/usb/dm9601.c                                  | 2 +-
 drivers/net/usb/ipheth.c                                  | 2 +-
 drivers/net/usb/kalmia.c                                  | 2 +-
 drivers/net/usb/lan78xx.c                                 | 4 ++--
 drivers/net/usb/r8152.c                                   | 2 +-
 drivers/net/usb/rndis_host.c                              | 2 +-
 drivers/net/usb/rtl8150.c                                 | 2 +-
 drivers/net/usb/sr9800.c                                  | 2 +-
 include/linux/etherdevice.h                               | 2 +-
 net/8021q/vlan_dev.c                                      | 6 +++---
 net/bridge/br_stp_if.c                                    | 2 +-
 net/dsa/slave.c                                           | 4 ++--
 net/ethernet/eth.c                                        | 2 +-
 net/hsr/hsr_device.c                                      | 2 +-
 net/hsr/hsr_main.c                                        | 2 +-
 149 files changed, 205 insertions(+), 207 deletions(-)

-- 
2.31.1

