Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B35452A9FCF
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 23:17:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728673AbgKFWR5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 17:17:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:41048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728055AbgKFWR4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Nov 2020 17:17:56 -0500
Received: from localhost.localdomain (HSI-KBW-46-223-126-90.hsi.kabel-badenwuerttemberg.de [46.223.126.90])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 00D4E206C1;
        Fri,  6 Nov 2020 22:17:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604701074;
        bh=czmkIDB7dvgg8a+vKJXMjmTYCFIokQzQ/5PyyT42XMk=;
        h=From:To:Cc:Subject:Date:From;
        b=SuhirdkoM6srhYpDWpDhKWhNlVXAIcJeXHb842a4YKsyJ1VxnQCCnWfD0JcqVHppQ
         611e9OmaRlKMVRF4pjYW0D/We0e7blvVxh702NMeJQn+FeCjnqhDqZvJaWY3LoFWR/
         3L147/13i2vxLez+FgBxbpULYTTt925DUMwDKwEo=
From:   Arnd Bergmann <arnd@kernel.org>
To:     netdev@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, bridge@lists.linux-foundation.org,
        linux-hams@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Johannes Berg <johannes@sipsolutions.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: [RFC net-next 00/28] ndo_ioctl rework
Date:   Fri,  6 Nov 2020 23:17:15 +0100
Message-Id: <20201106221743.3271965-1-arnd@kernel.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

This series is some fallout from the series I sent earlier today to get
rid of compat_alloc_user_space() and copy_in_user().

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

At this point, only a few oddball things remain in ndo_do_ioctl:
bridge, bonding, wan and two socket protocols passing down
SIOCSIFADDR/SIOCGIFADDR. Again, these could all be moved into
other callbacks as well if desired.

Any suggestions on how to proceed? I think the ndo_siocdevprivate
change is the most interesting here, and I would like to get
that merged. For the wireless drivers, removing the old drivers
instead of just the dead code might be an alternative, depending
on whether anyone thinks there might still be users.

The ndo_eth_ioctl change was something I did because it seemed
easy, but I'm not super attached to it, and it could well be done
differently.

None of this is really tested beyond simple compile tests,
please review. All of it is also available as part of a larger
branch at

https://git.kernel.org/pub/scm/linux/kernel/git/arnd/playground.git \
	compat-alloc-user-space-6

     Arnd

Arnd Bergmann (28):
  net: split out SIOCDEVPRIVATE handling from dev_ioctl
  staging: rtlwifi: use siocdevprivate
  staging: wlan-ng: use siocdevprivate
  hostap: use ndo_siocdevprivate
  wireless: remove old ioctls
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
  dev_ioctl: pass SIOCDEVPRIVATE data separately
  dev_ioctl: split out ndo_eth_ioctl
  wan: use ndo_siocdevprivate
  hamradio: use ndo_siocdevprivate
  airo: use ndo_siocdevprivate
  ip_tunnel: use ndo_siocdevprivate
  hippi: use ndo_siocdevprivate
  sb1000: use ndo_siocdevprivate
  ppp: use ndo_siocdevprivate
  net: socket: return changed ifreq from SIOCDEVPRIVATE

 Documentation/networking/netdevices.rst       |    4 +
 Documentation/networking/timestamping.rst     |    6 +-
 drivers/infiniband/ulp/ipoib/ipoib_main.c     |    8 +-
 drivers/net/appletalk/ipddp.c                 |   15 +-
 drivers/net/bonding/bond_main.c               |   72 +-
 drivers/net/eql.c                             |   23 +-
 drivers/net/ethernet/3com/3c574_cs.c          |    2 +-
 drivers/net/ethernet/3com/3c59x.c             |    4 +-
 drivers/net/ethernet/8390/ax88796.c           |    2 +-
 drivers/net/ethernet/8390/axnet_cs.c          |    2 +-
 drivers/net/ethernet/8390/pcnet_cs.c          |    2 +-
 drivers/net/ethernet/adaptec/starfire.c       |    2 +-
 drivers/net/ethernet/agere/et131x.c           |    2 +-
 drivers/net/ethernet/allwinner/sun4i-emac.c   |    2 +-
 drivers/net/ethernet/amd/amd8111e.c           |    2 +-
 drivers/net/ethernet/amd/au1000_eth.c         |    2 +-
 drivers/net/ethernet/amd/pcnet32.c            |    2 +-
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c      |    2 +-
 .../net/ethernet/aquantia/atlantic/aq_main.c  |    2 +-
 drivers/net/ethernet/arc/emac_main.c          |    2 +-
 drivers/net/ethernet/atheros/ag71xx.c         |    2 +-
 drivers/net/ethernet/atheros/alx/main.c       |    2 +-
 .../net/ethernet/atheros/atl1c/atl1c_main.c   |    2 +-
 .../net/ethernet/atheros/atl1e/atl1e_main.c   |    2 +-
 drivers/net/ethernet/atheros/atlx/atl1.c      |    2 +-
 drivers/net/ethernet/atheros/atlx/atl2.c      |    2 +-
 drivers/net/ethernet/aurora/nb8800.c          |    2 +-
 drivers/net/ethernet/broadcom/b44.c           |    2 +-
 drivers/net/ethernet/broadcom/bcm63xx_enet.c  |    4 +-
 drivers/net/ethernet/broadcom/bgmac.c         |    2 +-
 drivers/net/ethernet/broadcom/bnx2.c          |    2 +-
 .../net/ethernet/broadcom/bnx2x/bnx2x_main.c  |    2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     |    2 +-
 .../net/ethernet/broadcom/genet/bcmgenet.c    |    2 +-
 drivers/net/ethernet/broadcom/sb1250-mac.c    |    2 +-
 drivers/net/ethernet/broadcom/tg3.c           |    2 +-
 drivers/net/ethernet/cadence/macb_main.c      |    4 +-
 .../net/ethernet/cavium/liquidio/lio_main.c   |    2 +-
 .../ethernet/cavium/liquidio/lio_vf_main.c    |    2 +-
 .../net/ethernet/cavium/octeon/octeon_mgmt.c  |    2 +-
 .../net/ethernet/cavium/thunder/nicvf_main.c  |    2 +-
 drivers/net/ethernet/chelsio/cxgb/cxgb2.c     |    2 +-
 .../net/ethernet/chelsio/cxgb3/cxgb3_main.c   |   14 +-
 .../net/ethernet/chelsio/cxgb4/cxgb4_main.c   |    2 +-
 .../ethernet/chelsio/cxgb4vf/cxgb4vf_main.c   |    2 +-
 drivers/net/ethernet/cirrus/ep93xx_eth.c      |    2 +-
 drivers/net/ethernet/davicom/dm9000.c         |    2 +-
 drivers/net/ethernet/dec/tulip/de4x5.c        |    9 +-
 drivers/net/ethernet/dec/tulip/tulip_core.c   |    2 +-
 drivers/net/ethernet/dec/tulip/winbond-840.c  |    2 +-
 drivers/net/ethernet/dlink/dl2k.c             |    2 +-
 drivers/net/ethernet/dlink/sundance.c         |    2 +-
 drivers/net/ethernet/dnet.c                   |    2 +-
 drivers/net/ethernet/ethoc.c                  |    2 +-
 drivers/net/ethernet/faraday/ftgmac100.c      |    2 +-
 drivers/net/ethernet/faraday/ftmac100.c       |    2 +-
 drivers/net/ethernet/fealnx.c                 |    2 +-
 .../net/ethernet/freescale/dpaa/dpaa_eth.c    |    2 +-
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  |    2 +-
 .../net/ethernet/freescale/enetc/enetc_pf.c   |    2 +-
 .../net/ethernet/freescale/enetc/enetc_vf.c   |    2 +-
 drivers/net/ethernet/freescale/fec_main.c     |    2 +-
 drivers/net/ethernet/freescale/fec_mpc52xx.c  |    2 +-
 .../ethernet/freescale/fs_enet/fs_enet-main.c |    2 +-
 drivers/net/ethernet/freescale/gianfar.c      |    2 +-
 drivers/net/ethernet/freescale/ucc_geth.c     |    2 +-
 drivers/net/ethernet/hisilicon/hisi_femac.c   |    2 +-
 drivers/net/ethernet/hisilicon/hns/hns_enet.c |    2 +-
 .../net/ethernet/hisilicon/hns3/hns3_enet.c   |    2 +-
 drivers/net/ethernet/ibm/emac/core.c          |    4 +-
 drivers/net/ethernet/ibm/ibmveth.c            |    2 +-
 drivers/net/ethernet/intel/e100.c             |    2 +-
 drivers/net/ethernet/intel/e1000/e1000_main.c |    2 +-
 drivers/net/ethernet/intel/e1000e/netdev.c    |    2 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c   |    2 +-
 drivers/net/ethernet/intel/igb/igb_main.c     |    2 +-
 drivers/net/ethernet/intel/igbvf/netdev.c     |    2 +-
 drivers/net/ethernet/intel/igc/igc_main.c     |    2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |    2 +-
 drivers/net/ethernet/jme.c                    |    2 +-
 drivers/net/ethernet/korina.c                 |    2 +-
 drivers/net/ethernet/lantiq_etop.c            |    2 +-
 drivers/net/ethernet/marvell/mv643xx_eth.c    |    2 +-
 drivers/net/ethernet/marvell/mvneta.c         |    2 +-
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   |    2 +-
 .../ethernet/marvell/octeontx2/nic/otx2_pf.c  |    2 +-
 drivers/net/ethernet/marvell/pxa168_eth.c     |    2 +-
 drivers/net/ethernet/marvell/skge.c           |    2 +-
 drivers/net/ethernet/marvell/sky2.c           |    4 +-
 drivers/net/ethernet/mediatek/mtk_eth_soc.c   |    2 +-
 drivers/net/ethernet/mediatek/mtk_star_emac.c |    2 +-
 .../net/ethernet/mellanox/mlx4/en_netdev.c    |    2 +-
 .../net/ethernet/mellanox/mlx5/core/en_main.c |    2 +-
 .../ethernet/mellanox/mlx5/core/ipoib/ipoib.c |    2 +-
 .../mellanox/mlx5/core/ipoib/ipoib_vlan.c     |    2 +-
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |    2 +-
 drivers/net/ethernet/micrel/ks8851_common.c   |    2 +-
 drivers/net/ethernet/micrel/ksz884x.c         |    2 +-
 drivers/net/ethernet/microchip/lan743x_main.c |    2 +-
 drivers/net/ethernet/mscc/ocelot_net.c        |    2 +-
 drivers/net/ethernet/natsemi/natsemi.c        |    2 +-
 drivers/net/ethernet/neterion/s2io.c          |    2 +-
 .../net/ethernet/neterion/vxge/vxge-main.c    |    2 +-
 drivers/net/ethernet/nxp/lpc_eth.c            |    2 +-
 .../ethernet/oki-semi/pch_gbe/pch_gbe_main.c  |    2 +-
 drivers/net/ethernet/packetengines/hamachi.c  |   63 +-
 .../net/ethernet/packetengines/yellowfin.c    |    2 +-
 drivers/net/ethernet/qlogic/qede/qede_main.c  |    2 +-
 drivers/net/ethernet/qualcomm/emac/emac.c     |    2 +-
 drivers/net/ethernet/rdc/r6040.c              |    2 +-
 drivers/net/ethernet/realtek/8139cp.c         |    2 +-
 drivers/net/ethernet/realtek/8139too.c        |    2 +-
 drivers/net/ethernet/realtek/r8169_main.c     |    2 +-
 drivers/net/ethernet/renesas/ravb_main.c      |    2 +-
 drivers/net/ethernet/renesas/sh_eth.c         |    4 +-
 .../net/ethernet/samsung/sxgbe/sxgbe_main.c   |    2 +-
 drivers/net/ethernet/sfc/efx.c                |    2 +-
 drivers/net/ethernet/sfc/falcon/efx.c         |    2 +-
 drivers/net/ethernet/sgi/ioc3-eth.c           |    2 +-
 drivers/net/ethernet/sgi/meth.c               |    2 +-
 drivers/net/ethernet/sis/sis190.c             |    2 +-
 drivers/net/ethernet/sis/sis900.c             |    2 +-
 drivers/net/ethernet/smsc/epic100.c           |    2 +-
 drivers/net/ethernet/smsc/smc91c92_cs.c       |    2 +-
 drivers/net/ethernet/smsc/smsc911x.c          |    2 +-
 drivers/net/ethernet/smsc/smsc9420.c          |    2 +-
 drivers/net/ethernet/socionext/netsec.c       |    2 +-
 drivers/net/ethernet/socionext/sni_ave.c      |    2 +-
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |    2 +-
 drivers/net/ethernet/sun/cassini.c            |    2 +-
 drivers/net/ethernet/sun/niu.c                |    2 +-
 drivers/net/ethernet/sun/sungem.c             |    2 +-
 .../net/ethernet/synopsys/dwc-xlgmac-net.c    |    2 +-
 drivers/net/ethernet/tehuti/tehuti.c          |   18 +-
 drivers/net/ethernet/ti/am65-cpsw-nuss.c      |    2 +-
 drivers/net/ethernet/ti/cpmac.c               |    2 +-
 drivers/net/ethernet/ti/cpsw.c                |    2 +-
 drivers/net/ethernet/ti/cpsw_new.c            |    2 +-
 drivers/net/ethernet/ti/davinci_emac.c        |    2 +-
 drivers/net/ethernet/ti/netcp_core.c          |    2 +-
 drivers/net/ethernet/ti/tlan.c                |    2 +-
 drivers/net/ethernet/toshiba/spider_net.c     |    2 +-
 drivers/net/ethernet/toshiba/tc35815.c        |    2 +-
 drivers/net/ethernet/tundra/tsi108_eth.c      |    2 +-
 drivers/net/ethernet/via/via-rhine.c          |    2 +-
 drivers/net/ethernet/via/via-velocity.c       |    2 +-
 drivers/net/ethernet/xilinx/ll_temac_main.c   |    2 +-
 .../net/ethernet/xilinx/xilinx_axienet_main.c |    2 +-
 drivers/net/ethernet/xilinx/xilinx_emaclite.c |    2 +-
 drivers/net/ethernet/xircom/xirc2ps_cs.c      |    2 +-
 drivers/net/ethernet/xscale/ixp4xx_eth.c      |    2 +-
 drivers/net/fddi/skfp/skfddi.c                |   18 +-
 drivers/net/hamradio/baycom_epp.c             |    9 +-
 drivers/net/hamradio/baycom_par.c             |   12 +-
 drivers/net/hamradio/baycom_ser_fdx.c         |   12 +-
 drivers/net/hamradio/baycom_ser_hdx.c         |   12 +-
 drivers/net/hamradio/bpqether.c               |    9 +-
 drivers/net/hamradio/dmascc.c                 |   17 +-
 drivers/net/hamradio/hdlcdrv.c                |   20 +-
 drivers/net/hamradio/scc.c                    |   13 +-
 drivers/net/hamradio/yam.c                    |   13 +-
 drivers/net/hippi/rrunner.c                   |   11 +-
 drivers/net/hippi/rrunner.h                   |    3 +-
 drivers/net/macvlan.c                         |    8 +-
 drivers/net/phy/phy.c                         |    4 +-
 drivers/net/plip/plip.c                       |   11 +-
 drivers/net/ppp/ppp_generic.c                 |    6 +-
 drivers/net/sb1000.c                          |   20 +-
 drivers/net/slip/slip.c                       |   12 +-
 drivers/net/usb/asix_devices.c                |    6 +-
 drivers/net/usb/ax88172a.c                    |    2 +-
 drivers/net/usb/ax88179_178a.c                |    2 +-
 drivers/net/usb/cdc-phonet.c                  |    5 +-
 drivers/net/usb/dm9601.c                      |    2 +-
 drivers/net/usb/lan78xx.c                     |    2 +-
 drivers/net/usb/mcs7830.c                     |    2 +-
 drivers/net/usb/pegasus.c                     |    4 +-
 drivers/net/usb/r8152.c                       |    2 +-
 drivers/net/usb/rtl8150.c                     |    5 +-
 drivers/net/usb/smsc75xx.c                    |    2 +-
 drivers/net/usb/smsc95xx.c                    |    2 +-
 drivers/net/usb/sr9700.c                      |    2 +-
 drivers/net/usb/sr9800.c                      |    2 +-
 drivers/net/wan/c101.c                        |   20 +-
 drivers/net/wan/dlci.c                        |    7 +-
 drivers/net/wan/farsync.c                     |   38 +-
 drivers/net/wan/hdlc_fr.c                     |    3 +
 drivers/net/wan/lmc/lmc_main.c                |   38 +-
 drivers/net/wan/n2.c                          |   18 +-
 drivers/net/wan/pc300too.c                    |   19 +-
 drivers/net/wan/pci200syn.c                   |   19 +-
 drivers/net/wan/sbni.c                        |   12 +-
 drivers/net/wan/sdla.c                        |    8 +-
 drivers/net/wireless/atmel/atmel.c            |   72 --
 drivers/net/wireless/cisco/airo.c             |   15 +-
 drivers/net/wireless/intersil/hostap/hostap.h |    4 +-
 .../wireless/intersil/hostap/hostap_ioctl.c   |  227 +---
 .../wireless/intersil/hostap/hostap_main.c    |    6 +-
 drivers/s390/net/qeth_core.h                  |    2 +
 drivers/s390/net/qeth_core_main.c             |   35 +-
 drivers/s390/net/qeth_l2_main.c               |    2 +-
 drivers/s390/net/qeth_l3_main.c               |   10 +-
 drivers/staging/ks7010/ks_wlan_net.c          |   21 -
 drivers/staging/octeon/ethernet.c             |   12 +-
 drivers/staging/rtl8188eu/include/ieee80211.h |    2 -
 .../staging/rtl8188eu/include/osdep_intf.h    |    3 +-
 .../staging/rtl8188eu/include/rtw_android.h   |    3 +-
 .../staging/rtl8188eu/os_dep/ioctl_linux.c    |  941 --------------
 drivers/staging/rtl8188eu/os_dep/os_intfs.c   |    2 +-
 .../staging/rtl8188eu/os_dep/rtw_android.c    |   13 +-
 drivers/staging/rtl8192u/r8192U_core.c        |  109 --
 drivers/staging/rtl8712/os_intfs.c            |    1 -
 drivers/staging/rtl8712/osdep_intf.h          |    2 -
 drivers/staging/rtl8712/rtl871x_ioctl_linux.c |  125 --
 .../staging/rtl8723bs/include/osdep_intf.h    |    3 +-
 .../staging/rtl8723bs/os_dep/ioctl_linux.c    | 1089 +----------------
 drivers/staging/rtl8723bs/os_dep/os_intfs.c   |   21 +-
 drivers/staging/wlan-ng/p80211netdev.c        |   75 +-
 include/linux/hdlcdrv.h                       |    2 +-
 include/linux/netdevice.h                     |   13 +-
 include/net/dsa.h                             |   14 +-
 include/net/ip_tunnels.h                      |    3 +-
 net/8021q/vlan_dev.c                          |    6 +-
 net/bridge/br_device.c                        |    1 +
 net/bridge/br_ioctl.c                         |   36 +-
 net/bridge/br_private.h                       |    2 +
 net/core/dev_ioctl.c                          |   73 +-
 net/dsa/master.c                              |    6 +-
 net/dsa/slave.c                               |    2 +-
 net/ethtool/ioctl.c                           |    3 +-
 net/ipv4/ip_gre.c                             |    2 +-
 net/ipv4/ip_tunnel.c                          |    9 +-
 net/ipv4/ip_vti.c                             |    2 +-
 net/ipv4/ipip.c                               |    2 +-
 net/ipv6/ip6_gre.c                            |   16 +-
 net/ipv6/ip6_tunnel.c                         |   18 +-
 net/ipv6/ip6_vti.c                            |   21 +-
 net/ipv6/sit.c                                |   35 +-
 net/phonet/pn_dev.c                           |    6 +-
 net/socket.c                                  |   57 +-
 240 files changed, 829 insertions(+), 3253 deletions(-)

Cc: linux-kernel@vger.kernel.org
Cc: linux-wireless@vger.kernel.org
Cc: bridge@lists.linux-foundation.org
Cc: linux-hams@vger.kernel.org
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Heiner Kallweit <hkallweit1@gmail.com>

-- 
2.27.0

