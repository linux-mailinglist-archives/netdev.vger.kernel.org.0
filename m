Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 830835E68B6
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 18:42:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232228AbiIVQml (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 12:42:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231839AbiIVQmV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 12:42:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6EFCF3903;
        Thu, 22 Sep 2022 09:41:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B845CB838E8;
        Thu, 22 Sep 2022 16:40:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EDF0C433D6;
        Thu, 22 Sep 2022 16:40:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663864841;
        bh=oJtN2KuDULeiPV0qtIRxd8+/B0MwYH0ahlAVAB/Gzk0=;
        h=From:To:Cc:Subject:Date:From;
        b=CrkEcSapf5zKh5h2HHeVX5a2DZ7RhbGFOrdKaRr8TXNTlJyDoUA2w+8953dA1TyeU
         opR9MjEZMmQ+OQ5EnnovRkxrpouAmh4/GuvQqYQlPk3TeTdzw9aRTk2M5jQ1dzWLN8
         dl97mZoMhxiqOHz2cm03bT0M2YRnK/klI2ZEIBx3eYGTo5NWnKfSrgQGQuHWHZ5cgk
         pJIs1pqigYTjsa2bOu1+vHKYsYFo8YCiyWPeUbttSgEq45WW+RsTF+ihlpmxDX41Uo
         tNUlfugPLh459DLAt6ycnrWRQtnhZwf5N+L4BgsjQDY5MbCwIYqpVlKSQ+ZiNNIkY7
         IdlXrZ9kPaZow==
From:   Jakub Kicinski <kuba@kernel.org>
To:     torvalds@linux-foundation.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, pabeni@redhat.com
Subject: [PULL] Networking for 6.0-rc7
Date:   Thu, 22 Sep 2022 09:40:40 -0700
Message-Id: <20220922164040.2751371-1-kuba@kernel.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Linus!

The following changes since commit 26b1224903b3fb66e8aa564868d0d57648c32b15:

  Merge tag 'net-6.0-rc5' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2022-09-08 08:15:01 -0400)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-6.0-rc7

for you to fetch changes up to 83e4b196838d90799a8879e5054a3beecf9ed256:

  selftests: forwarding: add shebang for sch_red.sh (2022-09-22 07:33:56 -0700)

----------------------------------------------------------------
Including fixes from wifi, netfilter and can.

A handful of awaited fixes here - revert of the FEC changes,
bluetooth fix, fixes for iwlwifi spew.

We added a warning in PHY/MDIO code which is triggering on
a couple of platforms in a false-positive-ish way. If we can't
iron that out over the week we'll drop it and re-add for 6.1.

I've added a new "follow up fixes" section for fixes to fixes
in 6.0-rcs but it may actually give the false impression that
those are problematic or that more testing time would have
caught them. So likely a one time thing.

Follow up fixes:

 - nf_tables_addchain: fix nft_counters_enabled underflow

 - ebtables: fix memory leak when blob is malformed

 - nf_ct_ftp: fix deadlock when nat rewrite is needed

Current release - regressions:

 - Revert "fec: Restart PPS after link state change"
 - Revert "net: fec: Use a spinlock to guard `fep->ptp_clk_on`"

 - Bluetooth: fix HCIGETDEVINFO regression

 - wifi: mt76: fix 5 GHz connection regression on mt76x0/mt76x2

 - mptcp: fix fwd memory accounting on coalesce

 - rwlock removal fall out:
   - ipmr: always call ip{,6}_mr_forward() from RCU read-side
     critical section
   - ipv6: fix crash when IPv6 is administratively disabled

 - tcp: read multiple skbs in tcp_read_skb()

 - mdio_bus_phy_resume state warning fallout:
   - eth: ravb: fix PHY state warning splat during system resume
   - eth: sh_eth: fix PHY state warning splat during system resume

Current release - new code bugs:

 - wifi: iwlwifi: don't spam logs with NSS>2 messages

 - eth: mtk_eth_soc: enable XDP support just for MT7986 SoC

Previous releases - regressions:

 - bonding: fix NULL deref in bond_rr_gen_slave_id

 - wifi: iwlwifi: mark IWLMEI as broken

Previous releases - always broken:

 - nf_conntrack helpers:
   - irc: tighten matching on DCC message
   - sip: fix ct_sip_walk_headers
   - osf: fix possible bogus match in nf_osf_find()

 - ipvlan: fix out-of-bound bugs caused by unset skb->mac_header

 - core: fix flow symmetric hash

 - bonding, team: unsync device addresses on ndo_stop

 - phy: micrel: fix shared interrupt on LAN8814

Signed-off-by: Jakub Kicinski <kuba@kernel.org>

----------------------------------------------------------------
Alex Elder (1):
      net: ipa: properly limit modem routing table use

Benjamin Poirier (4):
      net: bonding: Share lacpdu_mcast_addr definition
      net: bonding: Unsync device addresses on ndo_stop
      net: team: Unsync device addresses on ndo_stop
      net: Add tests for bonding and team address list management

Bhupesh Sharma (1):
      MAINTAINERS: Add myself as a reviewer for Qualcomm ETHQOS Ethernet driver

Brett Creeley (1):
      iavf: Fix cached head and tail value for iavf_get_tx_pending

Cong Wang (1):
      tcp: read multiple skbs in tcp_read_skb()

Dave Ertman (1):
      ice: Don't double unplug aux on peer initiated reset

David Leadbeater (1):
      netfilter: nf_conntrack_irc: Tighten matching on DCC message

David S. Miller (4):
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf
      Merge branch '100GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue
      Merge branch 'net-unsync-addresses-from-ports'
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf

David Thompson (1):
      mlxbf_gige: clear MDIO gateway lock after read

Ding Hui (1):
      ice: Fix crash by keep old cfg when update TCs more than queues

Felix Fietkau (2):
      wifi: mt76: fix reading current per-tid starting sequence number for aggregation
      wifi: mt76: fix 5 GHz connection regression on mt76x0/mt76x2

Florian Westphal (3):
      selftests: nft_concat_range: add socat support
      netfilter: ebtables: fix memory leak when blob is malformed
      netfilter: nf_ct_ftp: fix deadlock when nat rewrite is needed

Francesco Dolcini (2):
      Revert "fec: Restart PPS after link state change"
      Revert "net: fec: Use a spinlock to guard `fep->ptp_clk_on`"

Geert Uytterhoeven (2):
      net: ravb: Fix PHY state warning splat during system resume
      net: sh_eth: Fix PHY state warning splat during system resume

Haimin Zhang (1):
      net/ieee802154: fix uninit value bug in dgram_sendmsg

Haiyang Zhang (1):
      net: mana: Add rmb after checking owner bits

Hangbin Liu (1):
      selftests: forwarding: add shebang for sch_red.sh

Hangyu Hua (1):
      net: sched: fix possible refcount leak in tc_new_tfilter()

Ido Schimmel (4):
      netdevsim: Fix hwstats debugfs file permissions
      ipmr: Always call ip{,6}_mr_forward() from RCU read-side critical section
      selftests: forwarding: Add test cases for unresolved multicast routes
      ipv6: Fix crash when IPv6 is administratively disabled

Igor Ryzhov (1):
      netfilter: nf_conntrack_sip: fix ct_sip_walk_headers

Ioana Ciornei (1):
      net: phy: aquantia: wait for the suspend/resume operations to finish

Jakub Kicinski (11):
      Merge tag 'for-net-2022-09-09' of git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth
      Merge tag 'batadv-net-pullrequest-20220916' of git://git.open-mesh.org/linux-merge
      Merge tag 'wireless-2022-09-19' of git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless
      Merge branch 'ipmr-always-call-ip-6-_mr_forward-from-rcu-read-side-critical-section'
      Merge branch 'wireguard-patches-for-6-0-rc6'
      Merge branch 'fixes-for-tc-taprio-software-mode'
      Merge tag 'linux-can-fixes-for-6.0-20220921' of git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can
      Merge branch '40GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue
      Merge branch '100GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue
      Merge branch 'bonding-fix-null-deref-in-bond_rr_gen_slave_id'
      bnxt: prevent skb UAF after handing over to PTP worker

Jason A. Donenfeld (4):
      wifi: iwlwifi: don't spam logs with NSS>2 messages
      wireguard: ratelimiter: disable timings test by default
      wireguard: selftests: do not install headers on UML
      wireguard: netlink: avoid variable-sized memcpy on sockaddr

Jeroen de Borst (1):
      MAINTAINERS: gve: update developers

Jianglei Nie (1):
      net: atlantic: fix potential memory leak in aq_ndev_close()

Jonathan Toppins (2):
      bonding: fix NULL deref in bond_rr_gen_slave_id
      selftests: bonding: cause oops in bond_rr_gen_slave_id

Larysa Zaremba (1):
      ice: Fix ice_xdp_xmit() when XDP TX queue number is not sufficient

Liang He (2):
      of: mdio: Add of_node_put() when breaking out of for_each_xx
      net: marvell: Fix refcounting bugs in prestera_port_sfp_bind()

Lorenzo Bianconi (1):
      net: ethernet: mtk_eth_soc: enable XDP support just for MT7986 SoC

Lu Wei (1):
      ipvlan: Fix out-of-bound bugs caused by unset skb->mac_header

Ludovic Cintrat (1):
      net: core: fix flow symmetric hash

Luiz Augusto von Dentz (1):
      Bluetooth: Fix HCIGETDEVINFO regression

Marc Kleine-Budde (3):
      can: flexcan: flexcan_mailbox_read() fix return value for drop = true
      can: gs_usb: gs_can_open(): fix race dev->can.state condition
      can: gs_usb: gs_usb_set_phys_id(): return with error if identify is not supported

Mateusz Palczewski (1):
      ice: Fix interface being down after reset with link-down-on-close flag on

Matthieu Baerts (1):
      Documentation: mptcp: fix pm_type formatting

Michael Walle (1):
      net: phy: micrel: fix shared interrupt on LAN8814

Michal Jaron (3):
      iavf: Fix set max MTU size with port VLAN and jumbo frames
      i40e: Fix VF set max MTU size
      i40e: Fix set max_tx_rate when it is lower than 1 Mbps

Michal Swiatkowski (1):
      ice: config netdev tc before setting queues number

Norbert Zulinski (1):
      iavf: Fix bad page state

Oleksandr Mazur (1):
      net: marvell: prestera: add support for for Aldrin2

Pablo Neira Ayuso (2):
      netfilter: nfnetlink_osf: fix possible bogus match in nf_osf_find()
      netfilter: conntrack: remove nf_conntrack_helper documentation

Paolo Abeni (2):
      mptcp: fix fwd memory accounting on coalesce
      Merge branch 'revert-fec-ptp-changes'

Peilin Ye (2):
      tcp: Use WARN_ON_ONCE() in tcp_read_skb()
      udp: Use WARN_ON_ONCE() in udp_read_skb()

Rakesh Sankaranarayanan (1):
      net: dsa: microchip: lan937x: fix maximum frame length check

Sean Anderson (1):
      net: sunhme: Fix packet reception for len < RX_COPY_THRESHOLD

Shailend Chand (1):
      gve: Fix GFP flags when allocing pages

Shigeru Yoshida (1):
      batman-adv: Fix hang up with small MTU hard-interface

Sylwester Dziedziuch (1):
      iavf: Fix change VF's mac address

Tetsuo Handa (3):
      net: clear msg_get_inq in __get_compat_msghdr()
      netfilter: nf_tables: fix nft_counters_enabled underflow at nf_tables_addchain()
      netfilter: nf_tables: fix percpu memory leak at nf_tables_addchain()

Toke Høiland-Jørgensen (1):
      wifi: iwlwifi: Mark IWLMEI as broken

Vadim Fedorenko (1):
      bnxt_en: fix flags to check for supported fw version

Vladimir Oltean (4):
      net: enetc: move enetc_set_psfp() out of the common enetc_set_features()
      net: enetc: deny offload of tc-based TSN features on VF interfaces
      net/sched: taprio: avoid disabling offload when it was never enabled
      net/sched: taprio: make qdisc_leaf() see the per-netdev-queue pfifo child qdiscs

Wen Gu (1):
      net/smc: Stop the CLC flow if no link to map buffers on

Íñigo Huguet (4):
      sfc: fix TX channel offset when using legacy interrupts
      sfc: fix null pointer dereference in efx_hard_start_xmit
      sfc/siena: fix TX channel offset when using legacy interrupts
      sfc/siena: fix null pointer dereference in efx_hard_start_xmit

 Documentation/networking/mptcp-sysctl.rst          |   1 -
 Documentation/networking/nf_conntrack-sysctl.rst   |   9 --
 MAINTAINERS                                        |   6 +-
 drivers/net/bonding/bond_3ad.c                     |   5 +-
 drivers/net/bonding/bond_main.c                    |  72 ++++++++------
 drivers/net/can/flexcan/flexcan-core.c             |  10 +-
 drivers/net/can/usb/gs_usb.c                       |  21 ++--
 drivers/net/dsa/microchip/lan937x_main.c           |   4 -
 drivers/net/ethernet/aquantia/atlantic/aq_main.c   |   3 -
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |  10 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c      |   4 +-
 drivers/net/ethernet/freescale/enetc/Makefile      |   1 -
 drivers/net/ethernet/freescale/enetc/enetc.c       |  53 +---------
 drivers/net/ethernet/freescale/enetc/enetc.h       |  12 ++-
 drivers/net/ethernet/freescale/enetc/enetc_pf.c    |  32 +++++-
 drivers/net/ethernet/freescale/enetc/enetc_qos.c   |  23 +++++
 drivers/net/ethernet/freescale/enetc/enetc_vf.c    |  17 +++-
 drivers/net/ethernet/freescale/fec.h               |  11 +--
 drivers/net/ethernet/freescale/fec_main.c          |  59 +++--------
 drivers/net/ethernet/freescale/fec_ptp.c           |  57 ++++-------
 drivers/net/ethernet/google/gve/gve_rx_dqo.c       |   2 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c        |  32 ++++--
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c |  20 ++++
 drivers/net/ethernet/intel/iavf/iavf_main.c        |   9 +-
 drivers/net/ethernet/intel/iavf/iavf_txrx.c        |   9 +-
 drivers/net/ethernet/intel/iavf/iavf_virtchnl.c    |   7 +-
 drivers/net/ethernet/intel/ice/ice_lib.c           |  42 +++++---
 drivers/net/ethernet/intel/ice/ice_main.c          |  25 ++---
 drivers/net/ethernet/intel/ice/ice_txrx.c          |   5 +-
 .../net/ethernet/marvell/prestera/prestera_main.c  |   2 +
 .../net/ethernet/marvell/prestera/prestera_pci.c   |   1 +
 drivers/net/ethernet/mediatek/mtk_eth_soc.c        |   2 +-
 .../ethernet/mellanox/mlxbf_gige/mlxbf_gige_mdio.c |   6 ++
 drivers/net/ethernet/microsoft/mana/gdma_main.c    |  10 ++
 drivers/net/ethernet/renesas/ravb_main.c           |   2 +
 drivers/net/ethernet/renesas/sh_eth.c              |   2 +
 drivers/net/ethernet/sfc/efx_channels.c            |   2 +-
 drivers/net/ethernet/sfc/siena/efx_channels.c      |   2 +-
 drivers/net/ethernet/sfc/siena/tx.c                |   2 +-
 drivers/net/ethernet/sfc/tx.c                      |   2 +-
 drivers/net/ethernet/sun/sunhme.c                  |   4 +-
 drivers/net/ipa/ipa_qmi.c                          |   8 +-
 drivers/net/ipa/ipa_qmi_msg.c                      |   8 +-
 drivers/net/ipa/ipa_qmi_msg.h                      |  37 ++++---
 drivers/net/ipa/ipa_table.c                        |   2 -
 drivers/net/ipa/ipa_table.h                        |   3 +
 drivers/net/ipvlan/ipvlan_core.c                   |   6 +-
 drivers/net/mdio/of_mdio.c                         |   1 +
 drivers/net/netdevsim/hwstats.c                    |   6 +-
 drivers/net/phy/aquantia_main.c                    |  53 +++++++++-
 drivers/net/phy/micrel.c                           |  18 ++--
 drivers/net/team/team.c                            |  24 +++--
 drivers/net/wireguard/netlink.c                    |  13 ++-
 drivers/net/wireguard/selftest/ratelimiter.c       |  25 ++---
 drivers/net/wireless/intel/iwlwifi/Kconfig         |   1 +
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |   4 +-
 drivers/net/wireless/mediatek/mt76/mac80211.c      |   3 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c    |   2 +-
 include/net/bluetooth/hci_sock.h                   |   2 -
 include/net/bond_3ad.h                             |   2 -
 include/net/bonding.h                              |   3 +
 include/net/ieee802154_netdev.h                    |  37 +++++++
 net/batman-adv/hard-interface.c                    |   4 +
 net/bridge/netfilter/ebtables.c                    |   4 +-
 net/compat.c                                       |   1 +
 net/core/flow_dissector.c                          |   5 +-
 net/ieee802154/socket.c                            |  42 ++++----
 net/ipv4/ipmr.c                                    |   2 +
 net/ipv4/tcp.c                                     |  29 ++++--
 net/ipv4/udp.c                                     |   2 +-
 net/ipv6/af_inet6.c                                |   4 +-
 net/ipv6/ip6mr.c                                   |   5 +-
 net/mptcp/protocol.c                               |   8 +-
 net/netfilter/nf_conntrack_ftp.c                   |   6 +-
 net/netfilter/nf_conntrack_irc.c                   |  34 +++++--
 net/netfilter/nf_conntrack_sip.c                   |   4 +-
 net/netfilter/nf_tables_api.c                      |   8 +-
 net/netfilter/nfnetlink_osf.c                      |   4 +-
 net/sched/cls_api.c                                |   1 +
 net/sched/sch_taprio.c                             |  18 ++--
 net/smc/smc_core.c                                 |   5 +-
 tools/testing/selftests/Makefile                   |   1 +
 .../testing/selftests/drivers/net/bonding/Makefile |   6 +-
 .../net/bonding/bond-arp-interval-causes-panic.sh  |  49 +++++++++
 tools/testing/selftests/drivers/net/bonding/config |   1 +
 .../drivers/net/bonding/dev_addr_lists.sh          | 109 +++++++++++++++++++++
 .../selftests/drivers/net/bonding/lag_lib.sh       |  61 ++++++++++++
 tools/testing/selftests/drivers/net/team/Makefile  |   6 ++
 tools/testing/selftests/drivers/net/team/config    |   3 +
 .../selftests/drivers/net/team/dev_addr_lists.sh   |  51 ++++++++++
 .../selftests/net/forwarding/router_multicast.sh   |  92 ++++++++++++++++-
 tools/testing/selftests/net/forwarding/sch_red.sh  |   1 +
 .../selftests/netfilter/nft_concat_range.sh        |  65 +++++++++---
 tools/testing/selftests/wireguard/qemu/Makefile    |   2 +
 94 files changed, 1057 insertions(+), 432 deletions(-)
 create mode 100755 tools/testing/selftests/drivers/net/bonding/bond-arp-interval-causes-panic.sh
 create mode 100755 tools/testing/selftests/drivers/net/bonding/dev_addr_lists.sh
 create mode 100644 tools/testing/selftests/drivers/net/bonding/lag_lib.sh
 create mode 100644 tools/testing/selftests/drivers/net/team/Makefile
 create mode 100644 tools/testing/selftests/drivers/net/team/config
 create mode 100755 tools/testing/selftests/drivers/net/team/dev_addr_lists.sh
