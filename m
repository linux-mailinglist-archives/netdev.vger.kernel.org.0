Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1D9C4CC579
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 19:54:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231799AbiCCSzJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 13:55:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229644AbiCCSzI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 13:55:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A233B4F9C4;
        Thu,  3 Mar 2022 10:54:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2E25E61A56;
        Thu,  3 Mar 2022 18:54:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F310C004E1;
        Thu,  3 Mar 2022 18:54:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646333660;
        bh=mutDwSR/v8DiY5qKbjYmwX+yC9X0apECr6w7HVLTv/M=;
        h=From:To:Cc:Subject:Date:From;
        b=RnY8e/wXZY/ys0ddjOERmZt/DUCVdcDsqm40XU/WovqOHSh2DTZpYPodpL+7XzGAO
         q0tds84+Xw6+UrDhM0IuMeITd3161Ro+zRP9Ivs1aUY8ibalk6H9fAhVd2HGz/60Eh
         2Kab7dxIPILcwEESe39KftTgrrNfJCbI4s2lD4A+F/80CAdCuGE/4YBhzV+7YUXVQN
         lgo4lt39uW0xyh4pbMkdJc5iCI313CfLpurnTYspwFUv37R7QiID3fx739Kv/Kcf4F
         q0HWYAp92fbAbhQrnqgwlZEUQflaV05n6gRGm5Jl1OQinR8OnGuKk2atSGPvqmnr8S
         vMlJT0z5URKiw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     torvalds@linux-foundation.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Networking for 5.17-rc7
Date:   Thu,  3 Mar 2022 10:54:19 -0800
Message-Id: <20220303185419.1418173-1-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Linus!

Lots of various size fixes, the length of the tag speaks for itself.
Most of the 5.17-relevant stuff comes from xfrm, wifi and bt trees
which had been lagging as you pointed out previously. But there's
also a larger than we'd like portion of fixes for bugs from previous
releases.

3 more fixes still under discussion, including and xfrm revert for
uAPI error.

The following changes since commit d8152cfe2f21d6930c680311b03b169899c8d2a0:

  Merge tag 'pci-v5.17-fixes-5' of git://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci (2022-02-24 13:19:57 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.17-rc7

for you to fetch changes up to 2d3916f3189172d5c69d33065c3c21119fe539fc:

  ipv6: fix skb drops in igmp6_event_query() and igmp6_event_report() (2022-03-03 09:47:06 -0800)

----------------------------------------------------------------
Networking fixes for 5.17-rc7, including fixes from can, xfrm, wifi,
bluetooth, and netfilter.

Current release - regressions:

 - iwlwifi: don't advertise TWT support, prevent FW crash

 - xfrm: fix the if_id check in changelink

 - xen/netfront: destroy queues before real_num_tx_queues is zeroed

 - bluetooth: fix not checking MGMT cmd pending queue, make scanning
   work again

Current release - new code bugs:

 - mptcp: make SIOCOUTQ accurate for fallback socket

 - bluetooth: access skb->len after null check

 - bluetooth: hci_sync: fix not using conn_timeout

 - smc: fix cleanup when register ULP fails

 - dsa: restore error path of dsa_tree_change_tag_proto

 - iwlwifi: fix build error for IWLMEI

 - iwlwifi: mvm: propagate error from request_ownership to the user

Previous releases - regressions:

 - xfrm: fix pMTU regression when reported pMTU is too small

 - xfrm: fix TCP MSS calculation when pMTU is close to 1280

 - bluetooth: fix bt_skb_sendmmsg not allocating partial chunks

 - ipv6: ensure we call ipv6_mc_down() at most once, prevent leaks

 - ipv6: prevent leaks in igmp6 when input queues get full

 - fix up skbs delta_truesize in UDP GRO frag_list

 - eth: e1000e: fix possible HW unit hang after an s0ix exit

 - eth: e1000e: correct NVM checksum verification flow

 - ptp: ocp: fix large time adjustments

Previous releases - always broken:

 - tcp: make tcp_read_sock() more robust in presence of urgent data

 - xfrm: distinguishing SAs and SPs by if_id in xfrm_migrate

 - xfrm: fix xfrm_migrate issues when address family changes

 - dcb: flush lingering app table entries for unregistered devices

 - smc: fix unexpected SMC_CLC_DECL_ERR_REGRMB error

 - mac80211: fix EAPoL rekey fail in 802.3 rx path

 - mac80211: fix forwarded mesh frames AC & queue selection

 - netfilter: nf_queue: fix socket access races and bugs

 - batman-adv: fix ToCToU iflink problems and check the result
   belongs to the expected net namespace

 - can: gs_usb, etas_es58x: fix opened_channel_cnt's accounting

 - can: rcar_canfd: register the CAN device when fully ready

 - eth: igb, igc: phy: drop premature return leaking HW semaphore

 - eth: ixgbe: xsk: change !netif_carrier_ok() handling in
   ixgbe_xmit_zc(), prevent live lock when link goes down

 - eth: stmmac: only enable DMA interrupts when ready

 - eth: sparx5: move vlan checks before any changes are made

 - eth: iavf: fix races around init, removal, resets and vlan ops

 - ibmvnic: more reset flow fixes

Misc:

 - eth: fix return value of __setup handlers

Signed-off-by: Jakub Kicinski <kuba@kernel.org>

----------------------------------------------------------------
Alex Elder (2):
      net: ipa: fix a build dependency
      net: ipa: add an interconnect dependency

Amit Cohen (2):
      selftests: mlxsw: tc_police_scale: Make test more robust
      selftests: mlxsw: resource_scale: Fix return value

Antony Antony (1):
      xfrm: fix the if_id check in changelink

Ben Dooks (1):
      rfkill: define rfill_soft_blocked() if !RFKILL

Brian Gix (1):
      Bluetooth: Fix not checking MGMT cmd pending queue

Casper Andersson (2):
      net: sparx5: Fix add vlan when invalid operation
      net: sparx5: Add #include to remove warning

Christophe JAILLET (1):
      bnx2: Fix an error message

Corinna Vinschen (1):
      igc: igc_read_phy_reg_gpy: drop premature return

D. Wythe (3):
      net/smc: fix connection leak
      net/smc: fix unexpected SMC_CLC_DECL_ERR_REGRMB error generated by client
      net/smc: fix unexpected SMC_CLC_DECL_ERR_REGRMB error cause by server

David S. Miller (6):
      Merge branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec
      Merge branch 'ibmvnic-fixes'
      Merge branch '40GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue
      Merge branch '1GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue
      Merge tag 'wireless-for-net-2022-03-01' of git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless
      Merge branch 'smc-fix'

Deren Wu (1):
      mac80211: fix EAPoL rekey fail in 802.3 rx path

Emmanuel Grumbach (1):
      iwlwifi: mvm: return value for request_ownership

Eric Dumazet (5):
      netfilter: nf_tables: prefer kfree_rcu(ptr, rcu) variant
      netfilter: fix use-after-free in __nf_register_net_hook()
      bpf, sockmap: Do not ignore orig_len parameter
      tcp: make tcp_read_sock() more robust
      ipv6: fix skb drops in igmp6_event_query() and igmp6_event_report()

Florian Westphal (5):
      netfilter: egress: silence egress hook lockdep splats
      netfilter: nf_queue: don't assume sk is full socket
      selftests: netfilter: add nfqueue TCP_NEW_SYN_RECV socket race test
      netfilter: nf_queue: fix possible use-after-free
      netfilter: nf_queue: handle socket prefetch

Golan Ben Ami (1):
      iwlwifi: don't advertise TWT support

Jakub Kicinski (8):
      Merge tag 'for-net-2022-02-24' of git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth
      Merge branch 'mptcp-fixes-for-5-17'
      Merge tag 'linux-can-fixes-for-5.17-20220225' of git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf
      Merge tag 'for-net-2022-03-01' of git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth
      Merge tag 'wireless-for-net-2022-03-02' of git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless
      Merge tag 'batadv-net-pullrequest-20220302' of git://git.open-mesh.org/linux-merge
      Merge branch 'selftests-mlxsw-a-couple-of-fixes'

Jia-Ju Bai (2):
      net: chelsio: cxgb3: check the return value of pci_find_capability()
      atm: firestream: check the return value of ioremap() in fs_init()

Jiasheng Jiang (1):
      nl80211: Handle nla_memdup failures in handle_nan_filter

Jiri Bohac (2):
      xfrm: fix MTU regression
      Revert "xfrm: xfrm_state_mtu should return at least 1280 for ipv6"

Johannes Berg (3):
      mac80211: refuse aggregations sessions before authorized
      mac80211: treat some SAE auth steps as final
      cfg80211: fix CONFIG_CFG80211_EXTRA_REGDB_KEYDIR typo

Jonathan Lemon (1):
      ptp: ocp: Add ptp_ocp_adjtime_coarse for large adjustments

Lad Prabhakar (1):
      can: rcar_canfd: rcar_canfd_channel_probe(): register the CAN device when fully ready

Leon Romanovsky (1):
      xfrm: enforce validity of offload input flags

Lin Ma (1):
      Bluetooth: fix data races in smp_unregister(), smp_del_chan()

Luiz Augusto von Dentz (4):
      Bluetooth: hci_core: Fix leaking sent_cmd skb
      Bluetooth: Fix bt_skb_sendmmsg not allocating partial chunks
      Bluetooth: hci_sync: Fix hci_update_accept_list_sync
      Bluetooth: hci_sync: Fix not using conn_timeout

Maciej Fijalkowski (1):
      ixgbe: xsk: change !netif_carrier_ok() handling in ixgbe_xmit_zc()

Marek Marczykowski-Górecki (1):
      xen/netfront: destroy queues before real_num_tx_queues is zeroed

Mat Martineau (1):
      mptcp: Correctly set DATA_FIN timeout when number of retransmits is large

Nicolas Escande (1):
      mac80211: fix forwarded mesh frames AC & queue selection

Niels Dossche (1):
      sfc: extend the locking on mcdi->seqno

Paolo Abeni (2):
      mptcp: accurate SIOCOUTQ for fallback socket
      selftests: mptcp: do complete cleanup at exit

Paul Blakey (1):
      net/sched: act_ct: Fix flow table lookup failure with no originating ifindex

Randy Dunlap (4):
      net: sxgbe: fix return value of __setup handler
      net: stmmac: fix return value of __setup handler
      iwlwifi: mvm: check debugfs_dir ptr before use
      iwlwifi: fix build error for IWLMEI

Sasha Neftin (3):
      igc: igc_write_phy_reg_gpy: drop premature return
      e1000e: Fix possible HW unit hang after an s0ix exit
      e1000e: Correct NVM checksum verification flow

Slawomir Laba (8):
      iavf: Rework mutexes for better synchronisation
      iavf: Add waiting so the port is initialized in remove
      iavf: Fix init state closure on remove
      iavf: Fix locking for VIRTCHNL_OP_GET_OFFLOAD_VLAN_V2_CAPS
      iavf: Fix race in init state
      iavf: Fix deadlock in iavf_reset_task
      iavf: Fix missing check for running netdev
      iavf: Fix __IAVF_RESETTING state usage

Sreeramya Soratkal (1):
      nl80211: Update bss channel on channel switch for P2P_CLIENT

Sukadev Bhattiprolu (8):
      ibmvnic: free reset-work-item when flushing
      ibmvnic: initialize rc before completing wait
      ibmvnic: define flush_reset_queue helper
      ibmvnic: complete init_done on transport events
      ibmvnic: register netdev after init of adapter
      ibmvnic: init init_done_rc earlier
      ibmvnic: clear fop when retrying probe
      ibmvnic: Allow queueing resets during probe

Sven Eckelmann (3):
      batman-adv: Request iflink once in batadv-on-batadv check
      batman-adv: Request iflink once in batadv_get_real_netdevice
      batman-adv: Don't expect inter-netns unique iflink indices

Tony Lu (1):
      net/smc: Fix cleanup when register ULP fails

Vincent Mailhol (2):
      can: etas_es58x: change opened_channel_cnt's type from atomic_t to u8
      can: gs_usb: change active_channels's type from atomic_t to u8

Vincent Whitchurch (1):
      net: stmmac: only enable DMA interrupts when ready

Vladimir Oltean (4):
      net: dcb: flush lingering app table entries for unregistered devices
      net: dsa: restore error path of dsa_tree_change_tag_proto
      net: dcb: disable softirqs in dcbnl_flush_dev()
      net: dsa: make dsa_tree_change_tag_proto actually unwind the tag proto change

Wang Qing (1):
      Bluetooth: assign len after null check

Yan Yan (2):
      xfrm: Check if_id in xfrm_migrate
      xfrm: Fix xfrm migrate issues when address family changes

Zheyu Ma (1):
      net: arcnet: com20020: Fix null-ptr-deref in com20020pci_probe()

j.nixdorf@avm.de (1):
      net: ipv6: ensure we call ipv6_mc_down() at most once

lena wang (1):
      net: fix up skbs delta_truesize in UDP GRO frag_list

 drivers/atm/firestream.c                           |   2 +
 drivers/net/arcnet/com20020-pci.c                  |   3 +
 drivers/net/can/rcar/rcar_canfd.c                  |   6 +-
 drivers/net/can/usb/etas_es58x/es58x_core.c        |   9 +-
 drivers/net/can/usb/etas_es58x/es58x_core.h        |   8 +-
 drivers/net/can/usb/gs_usb.c                       |  10 +-
 drivers/net/ethernet/broadcom/bnx2.c               |   2 +-
 drivers/net/ethernet/chelsio/cxgb3/t3_hw.c         |   2 +
 drivers/net/ethernet/ibm/ibmvnic.c                 | 183 +++++++++++++++++----
 drivers/net/ethernet/ibm/ibmvnic.h                 |   1 +
 drivers/net/ethernet/intel/e1000e/hw.h             |   1 +
 drivers/net/ethernet/intel/e1000e/ich8lan.c        |   8 +-
 drivers/net/ethernet/intel/e1000e/ich8lan.h        |   1 +
 drivers/net/ethernet/intel/e1000e/netdev.c         |  26 +++
 drivers/net/ethernet/intel/iavf/iavf.h             |   6 +-
 drivers/net/ethernet/intel/iavf/iavf_main.c        | 159 ++++++++++++------
 drivers/net/ethernet/intel/iavf/iavf_virtchnl.c    |  24 +--
 drivers/net/ethernet/intel/igc/igc_phy.c           |   4 -
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c       |   6 +-
 .../net/ethernet/microchip/sparx5/sparx5_main.h    |   2 +
 .../net/ethernet/microchip/sparx5/sparx5_vlan.c    |  20 +--
 drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c    |   6 +-
 drivers/net/ethernet/sfc/mcdi.c                    |   2 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |  34 +++-
 drivers/net/ipa/Kconfig                            |   2 +
 drivers/net/wireless/intel/Makefile                |   1 +
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c |   3 +-
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c   |  11 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |   1 -
 .../net/wireless/intel/iwlwifi/mvm/vendor-cmd.c    |   5 +-
 drivers/net/xen-netfront.c                         |  39 +++--
 drivers/ptp/ptp_ocp.c                              |  25 ++-
 include/linux/netfilter_netdev.h                   |   4 +
 include/linux/rfkill.h                             |   5 +
 include/net/bluetooth/bluetooth.h                  |   3 +-
 include/net/bluetooth/hci_core.h                   |   8 +
 include/net/ndisc.h                                |   4 +-
 include/net/netfilter/nf_flow_table.h              |   6 +-
 include/net/netfilter/nf_queue.h                   |   2 +-
 include/net/xfrm.h                                 |   6 +-
 include/uapi/linux/xfrm.h                          |   6 +
 net/batman-adv/hard-interface.c                    |  29 +++-
 net/bluetooth/hci_core.c                           |   1 +
 net/bluetooth/hci_sync.c                           |  30 +++-
 net/bluetooth/mgmt.c                               |  99 +++++++----
 net/bluetooth/mgmt_util.c                          |   3 +-
 net/core/skbuff.c                                  |   2 +-
 net/core/skmsg.c                                   |   2 +-
 net/dcb/dcbnl.c                                    |  44 +++++
 net/dsa/dsa2.c                                     |   2 +-
 net/ipv4/esp4.c                                    |   2 +-
 net/ipv4/tcp.c                                     |  10 +-
 net/ipv6/addrconf.c                                |   8 +-
 net/ipv6/esp6.c                                    |   2 +-
 net/ipv6/ip6_output.c                              |  11 +-
 net/ipv6/mcast.c                                   |  32 ++--
 net/key/af_key.c                                   |   2 +-
 net/mac80211/agg-tx.c                              |  10 +-
 net/mac80211/ieee80211_i.h                         |   2 +-
 net/mac80211/mlme.c                                |  16 +-
 net/mac80211/rx.c                                  |  14 +-
 net/mptcp/protocol.c                               |  18 +-
 net/netfilter/core.c                               |   5 +-
 net/netfilter/nf_flow_table_offload.c              |   6 +-
 net/netfilter/nf_queue.c                           |  36 +++-
 net/netfilter/nf_tables_api.c                      |   4 +-
 net/netfilter/nfnetlink_queue.c                    |  12 +-
 net/sched/act_ct.c                                 |  13 +-
 net/smc/af_smc.c                                   |  14 +-
 net/smc/smc_core.c                                 |   5 +-
 net/wireless/Makefile                              |   2 +-
 net/wireless/nl80211.c                             |  15 +-
 net/xfrm/xfrm_device.c                             |   6 +-
 net/xfrm/xfrm_interface.c                          |   2 +-
 net/xfrm/xfrm_policy.c                             |  14 +-
 net/xfrm/xfrm_state.c                              |  29 ++--
 net/xfrm/xfrm_user.c                               |   6 +-
 .../drivers/net/mlxsw/spectrum/resource_scale.sh   |   2 +-
 .../selftests/drivers/net/mlxsw/tc_police_scale.sh |   3 +-
 tools/testing/selftests/net/mptcp/mptcp_connect.sh |   4 +-
 tools/testing/selftests/netfilter/.gitignore       |   1 +
 tools/testing/selftests/netfilter/Makefile         |   2 +-
 tools/testing/selftests/netfilter/connect_close.c  | 136 +++++++++++++++
 tools/testing/selftests/netfilter/nft_queue.sh     |  19 +++
 84 files changed, 988 insertions(+), 343 deletions(-)
 create mode 100644 tools/testing/selftests/netfilter/connect_close.c
