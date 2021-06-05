Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34E4A39C4A7
	for <lists+netdev@lfdr.de>; Sat,  5 Jun 2021 02:56:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231140AbhFEA6j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 20:58:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:34406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230185AbhFEA6i (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Jun 2021 20:58:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 61AA9611AD;
        Sat,  5 Jun 2021 00:56:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622854611;
        bh=szaErMb1Urdpfx9KyB77+4Pl2SB2ZxoCuyd+7zkhA90=;
        h=From:To:Cc:Subject:Date:From;
        b=SeZaUlvclu3P044Ez2/CppNdEf2FD78NJ9+2EXZj72jaKV6Auda7/aojYVcAuiEIk
         wjojil6Q1o7gJNJCh2ysDpfd4bPKMlfrU6RxVH16i+L7dhcleBT10aH34ZEY+oGWQe
         w+vUqb9fzaerhvhcek7x3cO1Sv479erQ++hJifk/rqbdty5HJcgxOE/uLJeVgbUc3L
         YU5DbdULoLiCTMgrFvlkU8qdwv/Fy7FWClNyKXOj1pi7J2bzS7HY6o+r0jNywxdxwT
         i6y18SCO61WePx0OuIUzmhThntE+t4bwsksN0eY2zkzwxKHgH/5gX4+aVU6+EVDsb1
         rBJV+mrgf52xA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     torvalds@linux-foundation.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Networking for 5.13-rc5
Date:   Fri,  4 Jun 2021 17:56:50 -0700
Message-Id: <20210605005650.2542428-1-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Linus!

Things haven't slowed down just yet, both in terms of regressions
in current release and largish fixes for older code, but we usually
see a slowdown only after -rc5.

The discussion on bpf vs lockdown seems to be sufficiently settled
not to warrant delaying the PR further.

The following changes since commit d7c5303fbc8ac874ae3e597a5a0d3707dc0230b4:

  Merge tag 'net-5.13-rc4' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2021-05-26 17:44:49 -1000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.13-rc5

for you to fetch changes up to 3822d0670c9d4342794d73e0d0e615322b40438e:

  cxgb4: avoid link re-train during TC-MQPRIO configuration (2021-06-04 14:45:13 -0700)

----------------------------------------------------------------
Networking fixes for 5.13-rc5, including fixes from bpf, wireless,
netfilter and wireguard trees.

The bpf vs lockdown+audit fix is the most notable.

Current release - regressions:

 - virtio-net: fix page faults and crashes when XDP is enabled

 - mlx5e: fix HW timestamping with CQE compression, and make sure they
          are only allowed to coexist with capable devices

 - stmmac:
        - fix kernel panic due to NULL pointer dereference of mdio_bus_data
        - fix double clk unprepare when no PHY device is connected

Current release - new code bugs:

 - mt76: a few fixes for the recent MT7921 devices and runtime
         power management

Previous releases - regressions:

 - ice: - track AF_XDP ZC enabled queues in bitmap to fix copy mode Tx
        - fix allowing VF to request more/less queues via virtchnl
	- correct supported and advertised autoneg by using PHY capabilities
        - allow all LLDP packets from PF to Tx

 - kbuild: quote OBJCOPY var to avoid a pahole call break the build

Previous releases - always broken:

 - bpf, lockdown, audit: fix buggy SELinux lockdown permission checks

 - mt76: address the recent FragAttack vulnerabilities not covered
         by generic fixes

 - ipv6: fix KASAN: slab-out-of-bounds Read in fib6_nh_flush_exceptions

 - Bluetooth:
 	 - fix the erroneous flush_work() order, to avoid double free
         - use correct lock to prevent UAF of hdev object

 - nfc: fix NULL ptr dereference in llcp_sock_getname() after failed connect

 - ieee802154: multiple fixes to error checking and return values

 - igb: fix XDP with PTP enabled

 - intel: add correct exception tracing for XDP

 - tls: fix use-after-free when TLS offload device goes down and back up

 - ipvs: ignore IP_VS_SVC_F_HASHED flag when adding service

 - netfilter: nft_ct: skip expectations for confirmed conntrack

 - mptcp: fix falling back to TCP in presence of out of order packets
          early in connection lifetime

 - wireguard: switch from O(n) to a O(1) algorithm for maintaining peers,
          fixing stalls and a large memory leak in the process

Misc:

 - devlink: correct VIRTUAL port to not have phys_port attributes

 - Bluetooth: fix VIRTIO_ID_BT assigned number

 - net: return the correct errno code ENOBUF -> ENOMEM

 - wireguard:
         - peer: allocate in kmem_cache saving 25% on peer memory
         - do not use -O3

Signed-off-by: Jakub Kicinski <kuba@kernel.org>

----------------------------------------------------------------
Alexander Aring (1):
      net: sock: fix in-kernel mark setting

Andy Shevchenko (1):
      net: ieee802154: mrf24j40: Drop unneeded of_match_ptr()

Ariel Levkovich (1):
      net/sched: act_ct: Fix ct template allocation for zone 0

Aya Levin (3):
      net/mlx5e: Fix incompatible casting
      net/mlx5e: Fix HW TS with CQE compression according to profile
      net/mlx5e: Fix conflict with HW TS and CQE compression

Brett Creeley (2):
      ice: Fix allowing VF to request more/less queues via virtchnl
      ice: Fix VFR issues for AVF drivers that expect ATQLEN cleared

Coco Li (1):
      ipv6: Fix KASAN: slab-out-of-bounds Read in fib6_nh_flush_exceptions

Dan Robertson (1):
      net: ieee802154: fix null deref in parse dev addr

Daniel Borkmann (1):
      bpf, lockdown, audit: Fix buggy SELinux lockdown permission checks

Dave Ertman (1):
      ice: Allow all LLDP packets from PF to Tx

David S. Miller (12):
      Merge branch 'virtio_net-build_skb-fixes'
      Merge branch 'ktls-use-after-free'
      Merge tag 'mlx5-fixes-2021-06-01' of git://git.kernel.org/pub/scm/linu x/kernel/git/saeed/linux
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf
      Merge branch '1GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue
      Merge branch 'caif-fixes'
      Merge tag 'wireless-drivers-2021-06-03' of git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers
      Merge tag 'ieee802154-for-davem-2021-06-03' of git://git.kernel.org/pub/scm/linux/kernel/git/sschmidt/wpan
      Merge tag 'for-net-2021-06-03' of git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth
      Merge branch 'wireguard-fixes'
      Merge branch '100GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue

Felix Fietkau (4):
      mt76: connac: fix HT A-MPDU setting field in STA_REC_PHY
      mt76: mt7921: fix max aggregation subframes setting
      mt76: validate rx A-MSDU subframes
      mt76: mt7921: remove leftover 80+80 HE capability

Florian Westphal (1):
      netfilter: conntrack: unregister ipv4 sockopts on error unwind

Geert Uytterhoeven (1):
      virtchnl: Add missing padding to virtchnl_proto_hdrs

Haiyue Wang (1):
      ice: handle the VF VSI rebuild failure

Jakub Kicinski (2):
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf
      Merge branch 'mptcp-fixes-for-5-13'

Jason A. Donenfeld (9):
      wireguard: selftests: remove old conntrack kconfig value
      wireguard: selftests: make sure rp_filter is disabled on vethc
      wireguard: do not use -O3
      wireguard: use synchronize_net rather than synchronize_rcu
      wireguard: peer: allocate in kmem_cache
      wireguard: allowedips: initialize list head in selftest
      wireguard: allowedips: remove nodes in O(1)
      wireguard: allowedips: allocate nodes in kmem_cache
      wireguard: allowedips: free empty intermediate nodes when removing single node

Javier Martinez Canillas (1):
      kbuild: Quote OBJCOPY var to avoid a pahole call break the build

Jiapeng Chong (2):
      ethernet: myri10ge: Fix missing error code in myri10ge_probe()
      rtnetlink: Fix missing error code in rtnl_bridge_notify()

Joe Perches (1):
      MAINTAINERS: nfc mailing lists are subscribers-only

Josh Triplett (1):
      net: ipconfig: Don't override command-line hostnames or domains

Julian Anastasov (1):
      ipvs: ignore IP_VS_SVC_F_HASHED flag when adding service

Krzysztof Kozlowski (1):
      nfc: fix NULL ptr dereference in llcp_sock_getname() after failed connect

Kurt Kanzenbach (1):
      igb: Fix XDP with PTP enabled

Lin Ma (2):
      Bluetooth: fix the erroneous flush_work() order
      Bluetooth: use correct lock to prevent UAF of hdev object

Lorenzo Bianconi (4):
      mt76: mt7921: fix possible AOOB issue in mt7921_mcu_tx_rate_report
      mt76: connac: do not schedule mac_work if the device is not running
      mt76: mt76x0e: fix device hang during suspend/resume
      mt76: mt7615: do not set MT76_STATE_PM at bootstrap

Luiz Augusto von Dentz (1):
      Bluetooth: btusb: Fix failing to init controllers with operation firmware

Maciej Fijalkowski (1):
      ice: track AF_XDP ZC enabled queues in bitmap

Magnus Karlsson (6):
      i40e: add correct exception tracing for XDP
      ice: add correct exception tracing for XDP
      ixgbe: add correct exception tracing for XDP
      igb: add correct exception tracing for XDP
      ixgbevf: add correct exception tracing for XDP
      igc: add correct exception tracing for XDP

Marcel Holtmann (1):
      Bluetooth: Fix VIRTIO_ID_BT assigned number

Maxim Mikityanskiy (2):
      net/tls: Replace TLS_RX_SYNC_RUNNING with RCU
      net/tls: Fix use-after-free after the TLS device goes down and up

Moshe Shemesh (1):
      net/mlx5: Check firmware sync reset requested is set before trying to abort it

Pablo Neira Ayuso (5):
      netfilter: nf_tables: missing error reporting for not selected expressions
      netfilter: nf_tables: extended netlink error reporting for chain type
      netfilter: nf_tables: fix table flag updates
      netfilter: nft_ct: skip expectations for confirmed conntrack
      netfilter: nfnetlink_cthelper: hit EBUSY on updates if size mismatches

Paolo Abeni (4):
      mptcp: fix sk_forward_memory corruption on retransmission
      mptcp: always parse mptcp options for MPC reqsk
      mptcp: do not reset MP_CAPABLE subflow on mapping errors
      mptcp: update selftest for fallback due to OoO

Parav Pandit (1):
      devlink: Correct VIRTUAL port to not have phys_port attributes

Paul Blakey (1):
      net/sched: act_ct: Offload connections with commit action

Paul Greenwalt (1):
      ice: report supported and advertised autoneg using PHY capabilities

Pavel Skripkin (5):
      net: kcm: fix memory leak in kcm_sendmsg
      net: caif: added cfserl_release function
      net: caif: add proper error handling
      net: caif: fix memory leak in caif_device_notify
      net: caif: fix memory leak in cfusbl_device_notify

Rahul Lakkireddy (2):
      cxgb4: fix regression with HASH tc prio value update
      cxgb4: avoid link re-train during TC-MQPRIO configuration

Roi Dayan (3):
      net/mlx5e: Disable TLS offload for uplink representor
      net/mlx5e: Check for needed capability for cvlan matching
      net/mlx5e: Fix adding encap rules to slow path

Sriranjani P (1):
      net: stmmac: fix kernel panic due to NULL pointer dereference of mdio_bus_data

Vladimir Oltean (1):
      net: dsa: tag_8021q: fix the VLAN IDs used for encoding sub-VLANs

Wei Yongjun (1):
      ieee802154: fix error return code in ieee802154_llsec_getparams()

Wong Vee Khee (1):
      net: stmmac: fix issue where clk is being unprepared twice

Xuan Zhuo (3):
      virtio-net: fix for unable to handle page fault for address
      virtio_net: get build_skb() buf by data ptr
      virtio-net: fix for skb_over_panic inside big mode

Yang Li (1):
      net/ieee802154: drop unneeded assignment in llsec_iter_devkeys()

Yevgeny Kliteynik (1):
      net/mlx5: DR, Create multi-destination flow table with level less than 64

Yunjian Wang (1):
      sch_htb: fix refcount leak in htb_parent_to_leaf_offload

Zhen Lei (1):
      ieee802154: fix error return code in ieee802154_add_iface()

Zheng Yongjun (3):
      net/x25: Return the correct errno code
      net: Return the correct errno code
      fib: Return the correct errno code

zhang kai (1):
      sit: set name of device back to struct parms

 MAINTAINERS                                        |  10 +-
 drivers/bluetooth/btusb.c                          |  23 ++-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h         |   2 -
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c    |   4 +-
 .../net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c   |  14 +-
 .../net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.c   |   9 +-
 drivers/net/ethernet/chelsio/cxgb4/sge.c           |   6 +
 drivers/net/ethernet/intel/i40e/i40e_txrx.c        |   7 +-
 drivers/net/ethernet/intel/i40e/i40e_xsk.c         |   8 +-
 drivers/net/ethernet/intel/ice/ice.h               |   8 +-
 drivers/net/ethernet/intel/ice/ice_ethtool.c       |  51 +-----
 drivers/net/ethernet/intel/ice/ice_hw_autogen.h    |   1 +
 drivers/net/ethernet/intel/ice/ice_lib.c           |  12 ++
 drivers/net/ethernet/intel/ice/ice_txrx.c          |  17 +-
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c   |  19 ++-
 drivers/net/ethernet/intel/ice/ice_xsk.c           |  11 +-
 drivers/net/ethernet/intel/igb/igb.h               |   2 +-
 drivers/net/ethernet/intel/igb/igb_main.c          |  55 +++---
 drivers/net/ethernet/intel/igb/igb_ptp.c           |  23 ++-
 drivers/net/ethernet/intel/igc/igc_main.c          |  11 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |  16 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c       |  14 +-
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c  |   3 +
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |  12 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  77 +++++++--
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |   9 +
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |   3 +-
 drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c |   3 +
 .../ethernet/mellanox/mlx5/core/lib/fs_chains.c    |   2 +-
 .../ethernet/mellanox/mlx5/core/lib/fs_chains.h    |   5 +
 .../ethernet/mellanox/mlx5/core/steering/dr_fw.c   |   3 +-
 drivers/net/ethernet/myricom/myri10ge/myri10ge.c   |   1 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |   6 +-
 drivers/net/ieee802154/mrf24j40.c                  |   4 +-
 drivers/net/virtio_net.c                           |  20 +--
 drivers/net/wireguard/Makefile                     |   3 +-
 drivers/net/wireguard/allowedips.c                 | 189 +++++++++++----------
 drivers/net/wireguard/allowedips.h                 |  14 +-
 drivers/net/wireguard/main.c                       |  17 +-
 drivers/net/wireguard/peer.c                       |  27 ++-
 drivers/net/wireguard/peer.h                       |   3 +
 drivers/net/wireguard/selftest/allowedips.c        | 165 +++++++++---------
 drivers/net/wireguard/socket.c                     |   2 +-
 drivers/net/wireless/mediatek/mt76/mac80211.c      |  26 +++
 drivers/net/wireless/mediatek/mt76/mt7615/init.c   |   1 -
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c    |   5 +-
 .../net/wireless/mediatek/mt76/mt7615/sdio_mcu.c   |  19 ++-
 .../net/wireless/mediatek/mt76/mt7615/usb_mcu.c    |   3 -
 .../net/wireless/mediatek/mt76/mt76_connac_mcu.c   |   4 +
 drivers/net/wireless/mediatek/mt76/mt76x0/pci.c    |  81 ++++++++-
 drivers/net/wireless/mediatek/mt76/mt7921/init.c   |   4 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mac.c    |   5 +-
 drivers/net/wireless/mediatek/mt76/mt7921/main.c   |   3 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.c    |  17 +-
 include/linux/avf/virtchnl.h                       |   1 +
 include/linux/mlx5/mlx5_ifc.h                      |   2 +
 include/net/caif/caif_dev.h                        |   2 +-
 include/net/caif/cfcnfg.h                          |   2 +-
 include/net/caif/cfserl.h                          |   1 +
 include/net/netfilter/nf_tables.h                  |   6 -
 include/net/tls.h                                  |  10 +-
 include/uapi/linux/virtio_ids.h                    |   2 +-
 kernel/bpf/helpers.c                               |   7 +-
 kernel/trace/bpf_trace.c                           |  32 ++--
 net/bluetooth/hci_core.c                           |   7 +-
 net/bluetooth/hci_sock.c                           |   4 +-
 net/caif/caif_dev.c                                |  13 +-
 net/caif/caif_usb.c                                |  14 +-
 net/caif/cfcnfg.c                                  |  16 +-
 net/caif/cfserl.c                                  |   5 +
 net/compat.c                                       |   2 +-
 net/core/devlink.c                                 |   4 +-
 net/core/fib_rules.c                               |   2 +-
 net/core/rtnetlink.c                               |   4 +-
 net/core/sock.c                                    |  16 +-
 net/dsa/tag_8021q.c                                |   2 +-
 net/ieee802154/nl-mac.c                            |  10 +-
 net/ieee802154/nl-phy.c                            |   4 +-
 net/ieee802154/nl802154.c                          |   9 +-
 net/ipv4/ipconfig.c                                |  13 +-
 net/ipv6/route.c                                   |   8 +-
 net/ipv6/sit.c                                     |   3 +
 net/kcm/kcmsock.c                                  |   5 +
 net/mptcp/protocol.c                               |  16 +-
 net/mptcp/subflow.c                                |  79 ++++-----
 net/netfilter/ipvs/ip_vs_ctl.c                     |   2 +-
 net/netfilter/nf_conntrack_proto.c                 |   2 +-
 net/netfilter/nf_tables_api.c                      |  84 ++++++---
 net/netfilter/nfnetlink_cthelper.c                 |   8 +-
 net/netfilter/nft_ct.c                             |   2 +-
 net/nfc/llcp_sock.c                                |   2 +
 net/sched/act_ct.c                                 |  10 +-
 net/sched/sch_htb.c                                |   8 +-
 net/tls/tls_device.c                               |  60 +++++--
 net/tls/tls_device_fallback.c                      |   7 +
 net/tls/tls_main.c                                 |   1 +
 net/x25/af_x25.c                                   |   2 +-
 scripts/Makefile.modfinal                          |   2 +-
 scripts/link-vmlinux.sh                            |   2 +-
 tools/testing/selftests/net/mptcp/mptcp_connect.sh |  13 +-
 tools/testing/selftests/wireguard/netns.sh         |   1 +
 .../testing/selftests/wireguard/qemu/kernel.config |   1 -
 102 files changed, 991 insertions(+), 576 deletions(-)
