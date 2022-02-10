Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4857C4B16FE
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 21:33:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241067AbiBJUdX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 15:33:23 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230430AbiBJUdW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 15:33:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA4DBF23;
        Thu, 10 Feb 2022 12:33:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6CB80B82726;
        Thu, 10 Feb 2022 20:33:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75E6BC004E1;
        Thu, 10 Feb 2022 20:33:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644525200;
        bh=42qNlj99rtn6pz+T/nlPGwT4RHoZdSo1gDuZFlrNHls=;
        h=From:To:Cc:Subject:Date:From;
        b=jAdq718uoiUl6tK+oaMmhKXYPEKaV8Z6xgvv6MGgCU+9NdQ/gx+/rt9u+F3ta9wZI
         /dMVphhvd7opFW2jFMigDk5C2U9PZZpTINdM3dcQBc0bM/KaOX/YHNXM1KLN5DncL1
         eslNtzOB9BB7m/WnLBg9ot2orXyeQX38VdYx2hO5zjgVLJxAhlGHrdGZA5ekZA52RN
         mRPyTNyCNs9Br2pzT+VtLuBcTM/icE8QtBiP8TxVAa+LyBYFY1BQzCGZxsgRvZbIdd
         W63B5uVkjP2g9aGy0DnAPT7etFCytXDMqQkFM3rMqqBFtTLzWOmvWiJskskpkLJVLZ
         fxepiyWVXGdLA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     torvalds@linux-foundation.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Networking for 5.17-rc4
Date:   Thu, 10 Feb 2022 12:32:58 -0800
Message-Id: <20220210203258.2596078-1-kuba@kernel.org>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Linus!

The following changes since commit dcb85f85fa6f142aae1fe86f399d4503d49f2b60:

  gcc-plugins/stackleak: Use noinstr in favor of notrace (2022-02-03 17:02:21 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.17-rc4

for you to fetch changes up to 51a04ebf21122d5c76a716ecd9bfc33ea44b2b39:

  net: dsa: mv88e6xxx: fix use-after-free in mv88e6xxx_mdios_unregister (2022-02-10 11:46:03 -0800)

----------------------------------------------------------------
Networking fixes for 5.17-rc4, including fixes from netfilter and can.

Current release - new code bugs:

 - sparx5: fix get_stat64 out-of-bound access and crash

 - smc: fix netdev ref tracker misuse

Previous releases - regressions:

 - eth: ixgbevf: require large buffers for build_skb on 82599VF,
   avoid overflows

 - eth: ocelot: fix all IP traffic getting trapped to CPU with PTP
   over IP

 - bonding: fix rare link activation misses in 802.3ad mode

Previous releases - always broken:

 - tcp: fix tcp sock mem accounting in zero-copy corner cases

 - remove the cached dst when uncloning an skb dst and its metadata,
   since we only have one ref it'd lead to an UaF

 - netfilter:
   - conntrack: don't refresh sctp entries in closed state
   - conntrack: re-init state for retransmitted syn-ack, avoid
     connection establishment getting stuck with strange stacks
   - ctnetlink: disable helper autoassign, avoid it getting lost
   - nft_payload: don't allow transport header access for fragments

 - dsa: fix use of devres for mdio throughout drivers

 - eth: amd-xgbe: disable interrupts during pci removal

 - eth: dpaa2-eth: unregister netdev before disconnecting the PHY

 - eth: ice: fix IPIP and SIT TSO offload

Signed-off-by: Jakub Kicinski <kuba@kernel.org>

----------------------------------------------------------------
Antoine Tenart (2):
      net: do not keep the dst cache when uncloning an skb dst and its metadata
      net: fix a memleak when uncloning an skb dst and its metadata

Cai Huoqing (1):
      net: ethernet: litex: Add the dependency on HAS_IOMEM

Colin Foster (1):
      net: mscc: ocelot: fix mutex lock error during ethtool stats read

Dan Carpenter (1):
      ice: fix an error code in ice_cfg_phy_fec()

Dave Ertman (2):
      ice: Fix KASAN error in LAG NETDEV_UNREGISTER handler
      ice: Avoid RTNL lock when re-creating auxiliary device

David S. Miller (3):
      Merge branch 'net-fix-skb-unclone-issues'
      Merge tag 'linux-can-fixes-for-5.17-20220209' of git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can
      Merge branch 'vlan-QinQ-leak-fix'

Duoming Zhou (2):
      ax25: fix NPD bug in ax25_disconnect
      ax25: fix UAF bugs of net_device caused by rebinding operation

Eric Dumazet (5):
      tcp: take care of mixed splice()/sendmsg(MSG_ZEROCOPY) case
      net/smc: fix ref_tracker issue in smc_pnet_add()
      net/smc: use GFP_ATOMIC allocation in smc_pnet_add_eth()
      ipmr,ip6mr: acquire RTNL before calling ip[6]mr_free_table() on failure path
      veth: fix races around rq->rx_notify_masked

Florian Westphal (6):
      netfilter: conntrack: don't refresh sctp entries in closed state
      netfilter: nft_payload: don't allow th access for fragments
      netfilter: conntrack: move synack init code to helper
      netfilter: conntrack: re-init state for retransmitted syn-ack
      MAINTAINERS: netfilter: update git links
      netfilter: ctnetlink: disable helper autoassign

Jakub Kicinski (4):
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf
      Merge branch 'more-dsa-fixes-for-devres-mdiobus_-alloc-register'
      Merge branch 'mptcp-fixes-for-5-17'
      Merge branch '100GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue

Jesse Brandeburg (1):
      ice: fix IPIP and SIT TSO offload

Joel Stanley (1):
      net: mdio: aspeed: Add missing MODULE_DEVICE_TABLE

Jon Maloy (1):
      tipc: rate limit warning for received illegal binding update

Kishen Maloor (1):
      mptcp: netlink: process IPv6 addrs in creating listening sockets

Louis Peens (1):
      nfp: flower: fix ida_idx not being released

Mahesh Bandewar (1):
      bonding: pair enable_port with slave_arr_updates

Marc St-Amand (1):
      net: macb: Align the dma and coherent dma masks

Matthieu Baerts (1):
      selftests: mptcp: add missing join check

Oliver Hartkopp (2):
      can: isotp: fix potential CAN frame reception race in isotp_rcv()
      can: isotp: fix error path in isotp_sendmsg() to unlock wait queue

Pavel Parkhomenko (2):
      net: phy: marvell: Fix MDI-x polarity setting in 88e1118-compatible PHYs
      net: phy: marvell: Fix RGMII Tx/Rx delays setting in 88e1121-compatible PHYs

Raju Rangoju (1):
      net: amd-xgbe: disable interrupts during pci removal

Robert-Ionut Alexa (1):
      dpaa2-eth: unregister the netdev before disconnecting from the PHY

Samuel Mendoza-Jonas (1):
      ixgbevf: Require large buffers for build_skb on 82599VF

Slark Xiao (1):
      net: usb: qmi_wwan: Add support for Dell DW5829e

Steen Hegelund (1):
      net: sparx5: Fix get_stat64 crash in tcpdump

Sukadev Bhattiprolu (1):
      ibmvnic: don't release napi in __ibmvnic_open()

Tao Liu (1):
      gve: Recording rx queue before sending to napi

Tom Rix (1):
      skbuff: cleanup double word in comment

Victor Erminpour (1):
      net: mpls: Fix GCC 12 warning

Vladimir Oltean (10):
      net: mscc: ocelot: fix all IP traffic getting trapped to CPU with PTP over IP
      net: dsa: mv88e6xxx: don't use devres for mdiobus
      net: dsa: ar9331: register the mdiobus under devres
      net: dsa: bcm_sf2: don't use devres for mdiobus
      net: dsa: felix: don't use devres for mdiobus
      net: dsa: seville: register the mdiobus under devres
      net: dsa: mt7530: fix kernel bug in mdiobus_free() when unbinding
      net: dsa: lantiq_gswip: don't use devres for mdiobus
      net: dsa: fix panic when DSA master device unbinds on shutdown
      net: dsa: mv88e6xxx: fix use-after-free in mv88e6xxx_mdios_unregister

Xin Long (2):
      vlan: introduce vlan_dev_free_egress_priority
      vlan: move dev_put into vlan_dev_uninit

 MAINTAINERS                                        |  4 +-
 drivers/net/bonding/bond_3ad.c                     |  3 +-
 drivers/net/dsa/bcm_sf2.c                          |  7 ++-
 drivers/net/dsa/lantiq_gswip.c                     | 14 +++--
 drivers/net/dsa/mt7530.c                           |  2 +-
 drivers/net/dsa/mv88e6xxx/chip.c                   | 15 ++++--
 drivers/net/dsa/ocelot/felix_vsc9959.c             |  4 +-
 drivers/net/dsa/ocelot/seville_vsc9953.c           |  5 +-
 drivers/net/dsa/qca/ar9331.c                       |  3 +-
 drivers/net/ethernet/amd/xgbe/xgbe-pci.c           |  3 ++
 drivers/net/ethernet/cadence/macb_main.c           |  2 +-
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c   |  4 +-
 drivers/net/ethernet/google/gve/gve_rx.c           |  1 +
 drivers/net/ethernet/ibm/ibmvnic.c                 | 13 +++--
 drivers/net/ethernet/intel/ice/ice.h               |  3 +-
 drivers/net/ethernet/intel/ice/ice_common.c        |  3 +-
 drivers/net/ethernet/intel/ice/ice_lag.c           | 34 ++++++++++---
 drivers/net/ethernet/intel/ice/ice_lan_tx_rx.h     |  1 +
 drivers/net/ethernet/intel/ice/ice_main.c          | 28 +++++++---
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c  | 13 ++---
 drivers/net/ethernet/litex/Kconfig                 |  2 +-
 .../net/ethernet/microchip/sparx5/sparx5_ethtool.c |  2 +-
 drivers/net/ethernet/mscc/ocelot.c                 | 19 +++++--
 .../ethernet/netronome/nfp/flower/tunnel_conf.c    | 12 +++--
 drivers/net/mdio/mdio-aspeed.c                     |  1 +
 drivers/net/phy/marvell.c                          | 17 ++++---
 drivers/net/usb/qmi_wwan.c                         |  2 +
 drivers/net/veth.c                                 | 13 +++--
 include/net/dst_metadata.h                         | 14 ++++-
 include/uapi/linux/netfilter/nf_conntrack_common.h |  2 +-
 net/8021q/vlan.h                                   |  2 +-
 net/8021q/vlan_dev.c                               | 15 ++++--
 net/8021q/vlan_netlink.c                           |  7 +--
 net/ax25/af_ax25.c                                 |  7 ++-
 net/can/isotp.c                                    | 29 ++++++++---
 net/core/skbuff.c                                  |  2 +-
 net/dsa/dsa2.c                                     | 25 +++------
 net/ipv4/ipmr.c                                    |  2 +
 net/ipv4/tcp.c                                     | 33 +++++++-----
 net/ipv6/ip6mr.c                                   |  2 +
 net/mpls/af_mpls.c                                 |  2 +-
 net/mptcp/pm_netlink.c                             |  8 ++-
 net/netfilter/nf_conntrack_netlink.c               |  3 +-
 net/netfilter/nf_conntrack_proto_sctp.c            |  9 ++++
 net/netfilter/nf_conntrack_proto_tcp.c             | 59 +++++++++++++++-------
 net/netfilter/nft_exthdr.c                         |  2 +-
 net/netfilter/nft_payload.c                        |  9 ++--
 net/smc/smc_pnet.c                                 |  8 +--
 net/tipc/name_distr.c                              |  2 +-
 tools/testing/selftests/net/mptcp/mptcp_join.sh    |  1 +
 50 files changed, 318 insertions(+), 155 deletions(-)
