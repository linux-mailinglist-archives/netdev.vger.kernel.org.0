Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDD103D7717
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 15:46:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236680AbhG0Np6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 09:45:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:45888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232271AbhG0Np4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Jul 2021 09:45:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3950861A87;
        Tue, 27 Jul 2021 13:45:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627393556;
        bh=FzICyZ6AjDqjQ3S5amdxgEhGj75U5ZI8zQdv39qfBSQ=;
        h=From:To:Cc:Subject:Date:From;
        b=ZblrxptOpUqwscZZ1wqgWALYP4hXmXCQolCpKO3p0nTMd6Cqdv17fNjUBal0hwRyY
         UFa5lyuDoZbJALWGeNSggxKzZ16ckLn8+Lb3b7cFoDEYmKJ4jXhQiZoFU0Fwt+da8B
         d1yLiU+UWybfIHWfZptPTfylQOwhqrxkC/f8JiJYy5RNEnP/T2bBRpthOFShvQRlWf
         +9li4nhR2Amum/BdafqkDooDr6LRVeU+ZNE9x0UGhQVpMNLNNUMCugQyu752t9CbGR
         l3qpMV9VT26htc8To9mqSq/X7y29Gy31mq+Id4aBOMJbQZdFiRsziha2tJadItzOGk
         BGC6iqqbhl9TQ==
From:   Arnd Bergmann <arnd@kernel.org>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Arnd Bergmann <arnd@arndb.de>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Raju Rangoju <rajur@chelsio.com>,
        Thomas Sailer <t.sailer@alumni.ethz.ch>,
        Joerg Reuter <jreuter@yaina.de>,
        Jean-Paul Roubelat <jpr@f6fbb.org>,
        Jes Sorensen <jes@trained-monkey.org>,
        Krzysztof Halasa <khc@pm.waw.pl>,
        Kevin Curtis <kevin.curtis@farsite.co.uk>,
        Zhao Qiang <qiang.zhao@nxp.com>,
        Martin Schiller <ms@dev.tdt.de>,
        Kalle Valo <kvalo@codeaurora.org>, Jouni Malinen <j@w1.fi>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Remi Denis-Courmont <courmisch@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Christoph Hellwig <hch@lst.de>,
        linux-parisc@vger.kernel.org, linux-hams@vger.kernel.org,
        linux-hippi@sunsite.dk, linux-ppp@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-x25@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-s390@vger.kernel.org,
        bridge@lists.linux-foundation.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH net-next v3 00/31] ndo_ioctl rework
Date:   Tue, 27 Jul 2021 15:44:46 +0200
Message-Id: <20210727134517.1384504-1-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

This series is a follow-up to the series for removing
compat_alloc_user_space() and copy_in_user() that has now
been merged.

I wanted to be sure I address all the ways that 'struct ifreq' is used
in device drivers through .ndo_do_ioctl, originally to prove that
my approach of changing the struct definition was correct, but then
I discarded that approach and went on anyway.

Roughly, the contents here are:

 - split out all the users of SIOCDEVPRIVATE ioctls into a
   separate ndo_siocdevprivate callback, to better see what
   gets used where

 - fix compat handling for those drivers that pass data
   directly inside of 'ifreq' rather than using an indirect
   ifr_data pointer

 - remove unreachable code in ndo_ioctl handlers that relies
   on command codes we never pass into that, in particular
   for wireless drivers

 - split out the ethernet specific ioctls into yet another
   ndo_eth_ioctl callback, as these are by far the most
   common use of ndo_do_ioctl today. I considered splitting
   them further into MII and timestamp controls, but
   went with the simpler change for now.

 - split out bonding and wandev ioctls into separate helpers

 - rework the bridge handling with a separate callback

At this point, only a few oddball things remain in ndo_do_ioctl:
appletalk and ieee802154 pass down SIOCSIFADDR/SIOCGIFADDR and
some wireless drivers have completely dead code.

I have thoroughly compile tested this on randconfig builds,
but not done any notable runtime testing, so please review.
All of it is also available as part of a larger branch at

https://git.kernel.org/pub/scm/linux/kernel/git/arnd/playground.git \
	compat-alloc-user-space-12

Changes since v2:
- rebase to net-next
- fix qeth regression
- Cc driver maintainers for each patch and in cover letter

Changes since v1:

- rebase to linux-5.14-rc2
- add conversion for ndo_siowandev, bridge and bonding drivers
- leave broken wifi drivers untouched for now

Link: https://lore.kernel.org/netdev/20201106221743.3271965-14-arnd@kernel.org/

Arnd Bergmann (31):
  net: split out SIOCDEVPRIVATE handling from dev_ioctl
  staging: rtlwifi: use siocdevprivate
  staging: wlan-ng: use siocdevprivate
  hostap: use ndo_siocdevprivate
  bridge: use ndo_siocdevprivate
  phonet: use siocdevprivate
  tulip: use ndo_siocdevprivate
  bonding: use siocdevprivate
  appletalk: use ndo_siocdevprivate
  hamachi: use ndo_siocdevprivate
  tehuti: use ndo_siocdevprivate
  eql: use ndo_siocdevprivate
  fddi: use ndo_siocdevprivate
  net: usb: use ndo_siocdevprivate
  slip/plip: use ndo_siocdevprivate
  qeth: use ndo_siocdevprivate
  cxgb3: use ndo_siocdevprivate
  hamradio: use ndo_siocdevprivate
  airo: use ndo_siocdevprivate
  ip_tunnel: use ndo_siocdevprivate
  hippi: use ndo_siocdevprivate
  sb1000: use ndo_siocdevprivate
  ppp: use ndo_siocdevprivate
  wan: use ndo_siocdevprivate
  wan: cosa: remove dead cosa_net_ioctl() function
  dev_ioctl: pass SIOCDEVPRIVATE data separately
  dev_ioctl: split out ndo_eth_ioctl
  net: split out ndo_siowandev ioctl
  net: socket: return changed ifreq from SIOCDEVPRIVATE
  net: bridge: move bridge ioctls out of .ndo_do_ioctl
  net: bonding: move ioctl handling to private ndo operation

 Documentation/networking/netdevices.rst       |  29 +++++
 Documentation/networking/timestamping.rst     |   6 +-
 drivers/char/pcmcia/synclink_cs.c             |  23 ++--
 drivers/infiniband/ulp/ipoib/ipoib_main.c     |   8 +-
 drivers/net/appletalk/ipddp.c                 |  16 ++-
 drivers/net/bonding/bond_main.c               |  74 ++++++++---
 drivers/net/eql.c                             |  24 ++--
 drivers/net/ethernet/3com/3c574_cs.c          |   2 +-
 drivers/net/ethernet/3com/3c59x.c             |   4 +-
 drivers/net/ethernet/8390/ax88796.c           |   2 +-
 drivers/net/ethernet/8390/axnet_cs.c          |   2 +-
 drivers/net/ethernet/8390/pcnet_cs.c          |   2 +-
 drivers/net/ethernet/actions/owl-emac.c       |   6 +-
 drivers/net/ethernet/adaptec/starfire.c       |   2 +-
 drivers/net/ethernet/agere/et131x.c           |   2 +-
 drivers/net/ethernet/allwinner/sun4i-emac.c   |   2 +-
 drivers/net/ethernet/amd/amd8111e.c           |   2 +-
 drivers/net/ethernet/amd/au1000_eth.c         |   2 +-
 drivers/net/ethernet/amd/pcnet32.c            |   2 +-
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c      |   2 +-
 .../net/ethernet/aquantia/atlantic/aq_main.c  |   2 +-
 drivers/net/ethernet/arc/emac_main.c          |   2 +-
 drivers/net/ethernet/atheros/ag71xx.c         |   2 +-
 drivers/net/ethernet/atheros/alx/main.c       |   2 +-
 .../net/ethernet/atheros/atl1c/atl1c_main.c   |   2 +-
 .../net/ethernet/atheros/atl1e/atl1e_main.c   |   2 +-
 drivers/net/ethernet/atheros/atlx/atl1.c      |   2 +-
 drivers/net/ethernet/atheros/atlx/atl2.c      |   2 +-
 drivers/net/ethernet/broadcom/b44.c           |   2 +-
 drivers/net/ethernet/broadcom/bcm63xx_enet.c  |   4 +-
 drivers/net/ethernet/broadcom/bgmac.c         |   2 +-
 drivers/net/ethernet/broadcom/bnx2.c          |   2 +-
 .../net/ethernet/broadcom/bnx2x/bnx2x_main.c  |   2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     |   2 +-
 .../net/ethernet/broadcom/genet/bcmgenet.c    |   2 +-
 drivers/net/ethernet/broadcom/sb1250-mac.c    |   2 +-
 drivers/net/ethernet/broadcom/tg3.c           |   2 +-
 drivers/net/ethernet/cadence/macb_main.c      |   4 +-
 .../net/ethernet/cavium/liquidio/lio_main.c   |   2 +-
 .../ethernet/cavium/liquidio/lio_vf_main.c    |   2 +-
 .../net/ethernet/cavium/octeon/octeon_mgmt.c  |   2 +-
 .../net/ethernet/cavium/thunder/nicvf_main.c  |   2 +-
 drivers/net/ethernet/chelsio/cxgb/cxgb2.c     |   2 +-
 .../net/ethernet/chelsio/cxgb3/cxgb3_main.c   |  14 +-
 .../net/ethernet/chelsio/cxgb4/cxgb4_main.c   |   2 +-
 .../ethernet/chelsio/cxgb4vf/cxgb4vf_main.c   |   2 +-
 drivers/net/ethernet/cirrus/ep93xx_eth.c      |   2 +-
 drivers/net/ethernet/davicom/dm9000.c         |   2 +-
 drivers/net/ethernet/dec/tulip/de4x5.c        |  11 +-
 drivers/net/ethernet/dec/tulip/tulip_core.c   |   2 +-
 drivers/net/ethernet/dec/tulip/winbond-840.c  |   2 +-
 drivers/net/ethernet/dlink/dl2k.c             |   2 +-
 drivers/net/ethernet/dlink/sundance.c         |   2 +-
 drivers/net/ethernet/dnet.c                   |   2 +-
 drivers/net/ethernet/ethoc.c                  |   2 +-
 drivers/net/ethernet/faraday/ftgmac100.c      |   2 +-
 drivers/net/ethernet/faraday/ftmac100.c       |   2 +-
 drivers/net/ethernet/fealnx.c                 |   2 +-
 .../net/ethernet/freescale/dpaa/dpaa_eth.c    |   2 +-
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  |   2 +-
 .../net/ethernet/freescale/enetc/enetc_pf.c   |   2 +-
 .../net/ethernet/freescale/enetc/enetc_vf.c   |   2 +-
 drivers/net/ethernet/freescale/fec_main.c     |   2 +-
 drivers/net/ethernet/freescale/fec_mpc52xx.c  |   2 +-
 .../ethernet/freescale/fs_enet/fs_enet-main.c |   2 +-
 drivers/net/ethernet/freescale/gianfar.c      |   2 +-
 drivers/net/ethernet/freescale/ucc_geth.c     |   2 +-
 drivers/net/ethernet/hisilicon/hisi_femac.c   |   2 +-
 drivers/net/ethernet/hisilicon/hns/hns_enet.c |   2 +-
 .../net/ethernet/hisilicon/hns3/hns3_enet.c   |   2 +-
 drivers/net/ethernet/ibm/emac/core.c          |   4 +-
 drivers/net/ethernet/ibm/ibmveth.c            |   2 +-
 drivers/net/ethernet/intel/e100.c             |   2 +-
 drivers/net/ethernet/intel/e1000/e1000_main.c |   2 +-
 drivers/net/ethernet/intel/e1000e/netdev.c    |   2 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c   |   2 +-
 drivers/net/ethernet/intel/ice/ice_main.c     |   6 +-
 drivers/net/ethernet/intel/igb/igb_main.c     |   2 +-
 drivers/net/ethernet/intel/igbvf/netdev.c     |   2 +-
 drivers/net/ethernet/intel/igc/igc_main.c     |   2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |   2 +-
 drivers/net/ethernet/jme.c                    |   2 +-
 drivers/net/ethernet/korina.c                 |   2 +-
 drivers/net/ethernet/lantiq_etop.c            |   2 +-
 drivers/net/ethernet/marvell/mv643xx_eth.c    |   2 +-
 drivers/net/ethernet/marvell/mvneta.c         |   2 +-
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   |   2 +-
 .../ethernet/marvell/octeontx2/nic/otx2_pf.c  |   2 +-
 drivers/net/ethernet/marvell/pxa168_eth.c     |   2 +-
 drivers/net/ethernet/marvell/skge.c           |   2 +-
 drivers/net/ethernet/marvell/sky2.c           |   4 +-
 drivers/net/ethernet/mediatek/mtk_eth_soc.c   |   2 +-
 drivers/net/ethernet/mediatek/mtk_star_emac.c |   2 +-
 .../net/ethernet/mellanox/mlx4/en_netdev.c    |   2 +-
 .../net/ethernet/mellanox/mlx5/core/en_main.c |   2 +-
 .../ethernet/mellanox/mlx5/core/ipoib/ipoib.c |   2 +-
 .../mellanox/mlx5/core/ipoib/ipoib_vlan.c     |   2 +-
 .../mellanox/mlxbf_gige/mlxbf_gige_main.c     |   4 +-
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |   2 +-
 drivers/net/ethernet/micrel/ks8851_common.c   |   2 +-
 drivers/net/ethernet/micrel/ksz884x.c         |   2 +-
 drivers/net/ethernet/microchip/lan743x_main.c |   2 +-
 drivers/net/ethernet/mscc/ocelot_net.c        |   2 +-
 drivers/net/ethernet/natsemi/natsemi.c        |   2 +-
 drivers/net/ethernet/neterion/s2io.c          |   2 +-
 .../net/ethernet/neterion/vxge/vxge-main.c    |   2 +-
 drivers/net/ethernet/nxp/lpc_eth.c            |   2 +-
 .../ethernet/oki-semi/pch_gbe/pch_gbe_main.c  |   2 +-
 drivers/net/ethernet/packetengines/hamachi.c  |  63 +++++----
 .../net/ethernet/packetengines/yellowfin.c    |   2 +-
 .../net/ethernet/pensando/ionic/ionic_lif.c   |   4 +-
 drivers/net/ethernet/qlogic/qede/qede_main.c  |   2 +-
 drivers/net/ethernet/qualcomm/emac/emac.c     |   2 +-
 drivers/net/ethernet/rdc/r6040.c              |   2 +-
 drivers/net/ethernet/realtek/8139cp.c         |   2 +-
 drivers/net/ethernet/realtek/8139too.c        |   2 +-
 drivers/net/ethernet/realtek/r8169_main.c     |   2 +-
 drivers/net/ethernet/renesas/ravb_main.c      |   2 +-
 drivers/net/ethernet/renesas/sh_eth.c         |   4 +-
 .../net/ethernet/samsung/sxgbe/sxgbe_main.c   |   2 +-
 drivers/net/ethernet/sfc/efx.c                |   2 +-
 drivers/net/ethernet/sfc/falcon/efx.c         |   2 +-
 drivers/net/ethernet/sgi/ioc3-eth.c           |   2 +-
 drivers/net/ethernet/sgi/meth.c               |   2 +-
 drivers/net/ethernet/sis/sis190.c             |   2 +-
 drivers/net/ethernet/sis/sis900.c             |   2 +-
 drivers/net/ethernet/smsc/epic100.c           |   2 +-
 drivers/net/ethernet/smsc/smc91c92_cs.c       |   2 +-
 drivers/net/ethernet/smsc/smsc911x.c          |   2 +-
 drivers/net/ethernet/smsc/smsc9420.c          |   2 +-
 drivers/net/ethernet/socionext/netsec.c       |   2 +-
 drivers/net/ethernet/socionext/sni_ave.c      |   2 +-
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |   2 +-
 drivers/net/ethernet/sun/cassini.c            |   2 +-
 drivers/net/ethernet/sun/niu.c                |   2 +-
 drivers/net/ethernet/sun/sungem.c             |   2 +-
 .../net/ethernet/synopsys/dwc-xlgmac-net.c    |   2 +-
 drivers/net/ethernet/tehuti/tehuti.c          |  18 +--
 drivers/net/ethernet/ti/am65-cpsw-nuss.c      |   2 +-
 drivers/net/ethernet/ti/cpmac.c               |   2 +-
 drivers/net/ethernet/ti/cpsw.c                |   2 +-
 drivers/net/ethernet/ti/cpsw_new.c            |   2 +-
 drivers/net/ethernet/ti/davinci_emac.c        |   2 +-
 drivers/net/ethernet/ti/netcp_core.c          |   2 +-
 drivers/net/ethernet/ti/tlan.c                |   2 +-
 drivers/net/ethernet/toshiba/spider_net.c     |   2 +-
 drivers/net/ethernet/toshiba/tc35815.c        |   2 +-
 drivers/net/ethernet/tundra/tsi108_eth.c      |   2 +-
 drivers/net/ethernet/via/via-rhine.c          |   2 +-
 drivers/net/ethernet/via/via-velocity.c       |   2 +-
 drivers/net/ethernet/xilinx/ll_temac_main.c   |   2 +-
 .../net/ethernet/xilinx/xilinx_axienet_main.c |   2 +-
 drivers/net/ethernet/xilinx/xilinx_emaclite.c |   2 +-
 drivers/net/ethernet/xircom/xirc2ps_cs.c      |   2 +-
 drivers/net/ethernet/xscale/ixp4xx_eth.c      |   2 +-
 drivers/net/fddi/skfp/skfddi.c                |  19 ++-
 drivers/net/hamradio/baycom_epp.c             |   9 +-
 drivers/net/hamradio/baycom_par.c             |  12 +-
 drivers/net/hamradio/baycom_ser_fdx.c         |  12 +-
 drivers/net/hamradio/baycom_ser_hdx.c         |  12 +-
 drivers/net/hamradio/bpqether.c               |   9 +-
 drivers/net/hamradio/dmascc.c                 |  18 ++-
 drivers/net/hamradio/hdlcdrv.c                |  20 +--
 drivers/net/hamradio/scc.c                    |  13 +-
 drivers/net/hamradio/yam.c                    |  19 ++-
 drivers/net/hippi/rrunner.c                   |  11 +-
 drivers/net/hippi/rrunner.h                   |   3 +-
 drivers/net/macvlan.c                         |   8 +-
 drivers/net/phy/phy.c                         |   4 +-
 drivers/net/plip/plip.c                       |  12 +-
 drivers/net/ppp/ppp_generic.c                 |   6 +-
 drivers/net/sb1000.c                          |  20 +--
 drivers/net/slip/slip.c                       |  13 +-
 drivers/net/usb/asix_devices.c                |   6 +-
 drivers/net/usb/ax88172a.c                    |   2 +-
 drivers/net/usb/ax88179_178a.c                |   2 +-
 drivers/net/usb/cdc-phonet.c                  |   5 +-
 drivers/net/usb/dm9601.c                      |   2 +-
 drivers/net/usb/lan78xx.c                     |   2 +-
 drivers/net/usb/mcs7830.c                     |   2 +-
 drivers/net/usb/pegasus.c                     |   5 +-
 drivers/net/usb/r8152.c                       |   2 +-
 drivers/net/usb/rtl8150.c                     |   5 +-
 drivers/net/usb/smsc75xx.c                    |   2 +-
 drivers/net/usb/smsc95xx.c                    |   2 +-
 drivers/net/usb/sr9700.c                      |   2 +-
 drivers/net/usb/sr9800.c                      |   2 +-
 drivers/net/wan/c101.c                        |  33 +++--
 drivers/net/wan/cosa.c                        |  15 +--
 drivers/net/wan/farsync.c                     | 123 ++++++++++--------
 drivers/net/wan/fsl_ucc_hdlc.c                |  19 ++-
 drivers/net/wan/hdlc.c                        |   9 +-
 drivers/net/wan/hdlc_cisco.c                  |  14 +-
 drivers/net/wan/hdlc_fr.c                     |  40 +++---
 drivers/net/wan/hdlc_ppp.c                    |   8 +-
 drivers/net/wan/hdlc_raw.c                    |  14 +-
 drivers/net/wan/hdlc_raw_eth.c                |  14 +-
 drivers/net/wan/hdlc_x25.c                    |  16 +--
 drivers/net/wan/hostess_sv11.c                |   7 +-
 drivers/net/wan/ixp4xx_hss.c                  |  19 ++-
 drivers/net/wan/lmc/lmc.h                     |   2 +-
 drivers/net/wan/lmc/lmc_main.c                |  33 +++--
 drivers/net/wan/lmc/lmc_proto.c               |   7 -
 drivers/net/wan/lmc/lmc_proto.h               |   1 -
 drivers/net/wan/n2.c                          |  32 +++--
 drivers/net/wan/pc300too.c                    |  44 ++++---
 drivers/net/wan/pci200syn.c                   |  32 +++--
 drivers/net/wan/sbni.c                        |  15 ++-
 drivers/net/wan/sealevel.c                    |  10 +-
 drivers/net/wan/wanxl.c                       |  21 ++-
 drivers/net/wireless/cisco/airo.c             |  15 ++-
 drivers/net/wireless/intersil/hostap/hostap.h |   3 +-
 .../wireless/intersil/hostap/hostap_ioctl.c   |  30 ++++-
 .../wireless/intersil/hostap/hostap_main.c    |   3 +
 drivers/s390/net/qeth_core.h                  |   5 +-
 drivers/s390/net/qeth_core_main.c             |  35 +++--
 drivers/s390/net/qeth_l2_main.c               |   3 +-
 drivers/s390/net/qeth_l3_main.c               |  12 +-
 drivers/staging/octeon/ethernet.c             |  12 +-
 .../staging/rtl8188eu/include/osdep_intf.h    |   2 +
 .../staging/rtl8188eu/include/rtw_android.h   |   3 +-
 .../staging/rtl8188eu/os_dep/ioctl_linux.c    |   3 -
 drivers/staging/rtl8188eu/os_dep/os_intfs.c   |   1 +
 .../staging/rtl8188eu/os_dep/rtw_android.c    |  14 +-
 .../staging/rtl8723bs/include/osdep_intf.h    |   2 +
 .../staging/rtl8723bs/os_dep/ioctl_linux.c    |  18 ++-
 drivers/staging/rtl8723bs/os_dep/os_intfs.c   |   1 +
 drivers/staging/wlan-ng/p80211netdev.c        |  76 ++---------
 drivers/tty/synclink_gt.c                     |  19 ++-
 include/linux/hdlc.h                          |   4 +-
 include/linux/hdlcdrv.h                       |   2 +-
 include/linux/if_bridge.h                     |   7 +-
 include/linux/netdevice.h                     |  28 +++-
 include/net/dsa.h                             |  14 +-
 include/net/ip_tunnels.h                      |   3 +-
 net/8021q/vlan_dev.c                          |   6 +-
 net/bridge/br.c                               |   2 +-
 net/bridge/br_device.c                        |   2 +-
 net/bridge/br_ioctl.c                         |  52 ++++----
 net/bridge/br_private.h                       |   7 +-
 net/core/dev_ioctl.c                          | 104 +++++++++++----
 net/dsa/master.c                              |   6 +-
 net/dsa/slave.c                               |   2 +-
 net/ethtool/ioctl.c                           |   3 +-
 net/ipv4/ip_gre.c                             |   2 +-
 net/ipv4/ip_tunnel.c                          |   9 +-
 net/ipv4/ip_vti.c                             |   2 +-
 net/ipv4/ipip.c                               |   2 +-
 net/ipv6/ip6_gre.c                            |  17 +--
 net/ipv6/ip6_tunnel.c                         |  21 +--
 net/ipv6/ip6_vti.c                            |  21 +--
 net/ipv6/sit.c                                |  35 ++---
 net/phonet/pn_dev.c                           |   6 +-
 net/socket.c                                  |  90 ++++++-------
 254 files changed, 1134 insertions(+), 957 deletions(-)

-- 
2.29.2

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Jay Vosburgh <j.vosburgh@gmail.com>
Cc: Veaceslav Falico <vfalico@gmail.com>
Cc: Andy Gospodarek <andy@greyhouse.net>
Cc: Raju Rangoju <rajur@chelsio.com>
Cc: Thomas Sailer <t.sailer@alumni.ethz.ch>
Cc: Joerg Reuter <jreuter@yaina.de>
Cc: Jean-Paul Roubelat <jpr@f6fbb.org>
Cc: Jes Sorensen <jes@trained-monkey.org>
Cc: Krzysztof Halasa <khc@pm.waw.pl>
Cc: "Jan \"Yenya\" Kasprzak" <kas@fi.muni.cz>
Cc: Kevin Curtis <kevin.curtis@farsite.co.uk>
Cc: Zhao Qiang <qiang.zhao@nxp.com>
Cc: Martin Schiller <ms@dev.tdt.de>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: Jouni Malinen <j@w1.fi>
Cc: Julian Wiedmann <jwi@linux.ibm.com>
Cc: Karsten Graul <kgraul@linux.ibm.com>
Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc: David Ahern <dsahern@kernel.org>
Cc: Roopa Prabhu <roopa@nvidia.com>
Cc: Nikolay Aleksandrov <nikolay@nvidia.com>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Remi Denis-Courmont <courmisch@gmail.com>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Christoph Hellwig <hch@lst.de>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-parisc@vger.kernel.org
Cc: linux-hams@vger.kernel.org
Cc: linux-hippi@sunsite.dk
Cc: linux-ppp@vger.kernel.org
Cc: linux-usb@vger.kernel.org
Cc: linux-x25@vger.kernel.org
Cc: linux-wireless@vger.kernel.org
Cc: linux-s390@vger.kernel.org
Cc: bridge@lists.linux-foundation.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-mediatek@lists.infradead.org
