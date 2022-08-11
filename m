Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25F475906A8
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 21:07:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235986AbiHKSvJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 14:51:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234335AbiHKSvI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 14:51:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 224849A94A;
        Thu, 11 Aug 2022 11:51:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ADB20B82245;
        Thu, 11 Aug 2022 18:51:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26836C433D6;
        Thu, 11 Aug 2022 18:51:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660243863;
        bh=mJYg/X+8pcwLkOgMY2Qf/7rz11WtJ6JOOSCQ6hEeFAU=;
        h=From:To:Cc:Subject:Date:From;
        b=SGfSMBuFpHHKMOuJnwVxcQtHK5DnCz/ZX2D1nx0NZHT2h0csftES+6Jv9FgIUpgm4
         10wLkyGTYNZHGERlDFA4prHtrxfqQUWfNQSfCPH9P5/iru6QmLYkU+Z9IH2KU7V5A1
         v7sBT51KHkdUBLNyIg501gmAl6CHQ6InuqJz2d8zTttMqdEJjwWHykz5ac09tBMN50
         hqdjAm3iqGojy+YTH9wZHChqAPZahMg99P7gtsWya5sGnYD1B64h17Vdg+lmH5Gzun
         QBy1r0AY7y6n1Na/ZAN6SNEdFRheJqz2DEnsqi3gy6xUwLTy5H7aZXw/+6aL0+eCYb
         BvR+fJhpTqMeg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     torvalds@linux-foundation.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, pabeni@redhat.com
Subject: [PULL] Networking for 6.0-rc1
Date:   Thu, 11 Aug 2022 11:51:02 -0700
Message-Id: <20220811185102.3253045-1-kuba@kernel.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Linus!

The following changes since commit f86d1fbbe7858884d6754534a0afbb74fc30bc26:

  Merge tag 'net-next-6.0' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next (2022-08-03 16:29:08 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-6.0-rc1

for you to fetch changes up to c2e75634cbe368065f140dd30bf8b1a0355158fd:

  net: atm: bring back zatm uAPI (2022-08-11 10:31:19 -0700)

----------------------------------------------------------------
Including fixes from bluetooth, bpf, can and netfilter.

A little longer PR than usual but it's all fixes, no late features.
It's long partially because of timing, and partially because of
follow ups to stuff that got merged a week or so before the merge
window and wasn't as widely tested. Maybe the Bluetooth fixes are
a little alarming so we'll address that, but the rest seems okay
and not scary.

Notably we're including a fix for the netfilter Kconfig [1], your
WiFi warning [2] and a bluetooth fix which should unblock syzbot [3].

Current release - regressions:

 - Bluetooth:
   - don't try to cancel uninitialized works [3]
   - L2CAP: fix use-after-free caused by l2cap_chan_put

 - tls: rx: fix device offload after recent rework

 - devlink: fix UAF on failed reload and leftover locks in mlxsw

Current release - new code bugs:

 - netfilter:
   - flowtable: fix incorrect Kconfig dependencies [1]
   - nf_tables: fix crash when nf_trace is enabled

 - bpf:
   - use proper target btf when exporting attach_btf_obj_id
   - arm64: fixes for bpf trampoline support

 - Bluetooth:
   - ISO: unlock on error path in iso_sock_setsockopt()
   - ISO: fix info leak in iso_sock_getsockopt()
   - ISO: fix iso_sock_getsockopt for BT_DEFER_SETUP
   - ISO: fix memory corruption on iso_pinfo.base
   - ISO: fix not using the correct QoS
   - hci_conn: fix updating ISO QoS PHY

 - phy: dp83867: fix get nvmem cell fail

Previous releases - regressions:

 - wifi: cfg80211: fix validating BSS pointers in
   __cfg80211_connect_result [2]

 - atm: bring back zatm uAPI after ATM had been removed

 - properly fix old bug making bonding ARP monitor mode not being
   able to work with software devices with lockless Tx

 - tap: fix null-deref on skb->dev in dev_parse_header_protocol

 - revert "net: usb: ax88179_178a needs FLAG_SEND_ZLP" it helps
   some devices and breaks others

 - netfilter:
   - nf_tables: many fixes rejecting cross-object linking
     which may lead to UAFs
   - nf_tables: fix null deref due to zeroed list head
   - nf_tables: validate variable length element extension

 - bgmac: fix a BUG triggered by wrong bytes_compl

 - bcmgenet: indicate MAC is in charge of PHY PM

Previous releases - always broken:

 - bpf:
   - fix bad pointer deref in bpf_sys_bpf() injected via test infra
   - disallow non-builtin bpf programs calling the prog_run command
   - don't reinit map value in prealloc_lru_pop
   - fix UAFs during the read of map iterator fd
   - fix invalidity check for values in sk local storage map
   - reject sleepable program for non-resched map iterator

 - mptcp:
   - move subflow cleanup in mptcp_destroy_common()
   - do not queue data on closed subflows

 - virtio_net: fix memory leak inside XDP_TX with mergeable

 - vsock: fix memory leak when multiple threads try to connect()

 - rework sk_user_data sharing to prevent psock leaks

 - geneve: fix TOS inheriting for ipv4

 - tunnels & drivers: do not use RT_TOS for IPv6 flowlabel

 - phy: c45 baset1: do not skip aneg configuration if clock role
   is not specified

 - rose: avoid overflow when /proc displays timer information

 - x25: fix call timeouts in blocking connects

 - can: mcp251x: fix race condition on receive interrupt

 - can: j1939:
   - replace user-reachable WARN_ON_ONCE() with netdev_warn_once()
   - fix memory leak of skbs in j1939_session_destroy()

Misc:

 - docs: bpf: clarify that many things are not uAPI

 - seg6: initialize induction variable to first valid array index
   (to silence clang vs objtool warning)

 - can: ems_usb: fix clang 14's -Wunaligned-access warning

Signed-off-by: Jakub Kicinski <kuba@kernel.org>

----------------------------------------------------------------
Aijun Sun (1):
      bpf, arm64: Allocate program buffer using kvcalloc instead of kcalloc

Alexandra Winter (1):
      s390/qeth: cache link_info for ethtool

Alexei Starovoitov (4):
      Merge branch 'Don't reinit map value in prealloc_lru_pop'
      bpf: Disallow bpf programs call prog_run command.
      Merge branch 'fixes for bpf map iterator'
      bpf: Shut up kern_sys_bpf warning.

Cezar Bulinaru (2):
      net: tap: NULL pointer derefence in dev_parse_header_protocol when skb->dev is null
      selftests: add few test cases for tap driver

Chen Lin (1):
      dpaa2-eth: trace the allocated address instead of page struct

Chia-Lin Kao (AceLan) (1):
      net: atlantic: fix aq_vec index out of range error

Christophe JAILLET (2):
      netfilter: ip6t_LOG: Fix a typo in a comment
      ax88796: Fix some typo in a comment

Clayton Yager (1):
      macsec: Fix traffic counters/statistics

Dan Carpenter (1):
      Bluetooth: ISO: unlock on error path in iso_sock_setsockopt()

David S. Miller (2):
      Merge branch 'mptcp-fixes'
      Merge tag 'linux-can-fixes-for-6.0-20220810' of git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can

Duoming Zhou (1):
      atm: idt77252: fix use-after-free bugs caused by tst_timer

Fedor Pchelkin (2):
      can: j1939: j1939_sk_queue_activate_next_locked(): replace WARN_ON_ONCE with netdev_warn_once()
      can: j1939: j1939_session_destroy(): fix memory leak of skbs

Florian Fainelli (2):
      net: phy: Warn about incorrect mdio_bus_phy_resume() state
      net: bcmgenet: Indicate MAC is in charge of PHY PM

Florian Westphal (5):
      selftests: mptcp: make sendfile selftest work
      netfilter: nf_tables: fix crash when nf_trace is enabled
      selftests: netfilter: add test case for nf trace infrastructure
      netfilter: nf_tables: fix null deref due to zeroed list head
      plip: avoid rcu debug splat

Francois Romieu (1):
      net: avoid overflow when rose /proc displays timer information.

Gao Feng (1):
      net: bpf: Use the protocol's set_rcvlowat behavior if there is one

Gerhard Engleder (2):
      tsnep: Fix unused warning for 'tsnep_of_match'
      tsnep: Fix tsnep_tx_unmap() error path usage

Harman Kalra (1):
      octeontx2-af: suppress external profile loading warning

Hawkins Jiawei (2):
      net: fix refcount bug in sk_psock_get (2)
      net: refactor bpf_sk_reuseport_detach()

Hou Tao (9):
      bpf: Acquire map uref in .init_seq_private for array map iterator
      bpf: Acquire map uref in .init_seq_private for hash map iterator
      bpf: Acquire map uref in .init_seq_private for sock local storage map iterator
      bpf: Acquire map uref in .init_seq_private for sock{map,hash} iterator
      bpf: Check the validity of max_rdwr_access for sock local storage map iterator
      bpf: Only allow sleepable program for resched-able iterator
      selftests/bpf: Add tests for reading a dangling map iter fd
      selftests/bpf: Add write tests for sk local storage map iterator
      selftests/bpf: Ensure sleepable program is rejected by hash map iter

Ido Schimmel (2):
      devlink: Fix use-after-free after a failed reload
      selftests: forwarding: Fix failing tests with old libnet

Jakub Kicinski (18):
      Merge branch 'make-dsa-work-with-bonding-s-arp-monitor'
      Merge branch 'netfilter-followup-fixes-for-net'
      Merge branch 'octeontx2-af-driver-fixes-for-npc'
      eth: fix the help in Wangxun's Kconfig
      Merge branch 'tsnep-two-fixes-for-the-driver'
      Merge tag 'for-net-2022-08-08' of git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth
      Merge tag 'wireless-2022-08-09' of git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf
      Merge branch 'do-not-use-rt_tos-for-ipv6-flowlabel'
      genetlink: correct uAPI defines
      Merge branch 'net-enhancements-to-sk_user_data-field'
      Merge https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf
      tls: rx: device: bound the frag walk
      tls: rx: device: don't try to copy too much on detach
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf
      MAINTAINERS: use my korg address for mt7601u
      net: add missing kdoc for struct genl_multicast_group::flags
      net: atm: bring back zatm uAPI

Jay Vosburgh (1):
      bonding: fix reference count leak in balance-alb mode

Jialiang Wang (1):
      nfp: fix use-after-free in area_cache_get()

Jinghao Jia (1):
      BPF: Fix potential bad pointer dereference in bpf_sys_bpf()

Jiri Olsa (2):
      bpf: Cleanup ftrace hash in bpf_trampoline_put
      mptcp, btf: Add struct mptcp_sock definition when CONFIG_MPTCP is disabled

Jose Alonso (1):
      Revert "net: usb: ax88179_178a needs FLAG_SEND_ZLP"

Kalle Valo (1):
      wifi: wilc1000: fix spurious inline in wilc_handle_disconnect()

Kumar Kartikeya Dwivedi (3):
      bpf: Allow calling bpf_prog_test kfuncs in tracing programs
      bpf: Don't reinit map value in prealloc_lru_pop
      selftests/bpf: Add test for prealloc_lru_pop bug

Luiz Augusto von Dentz (8):
      Bluetooth: L2CAP: Fix l2cap_global_chan_by_psm regression
      Bluetooth: hci_conn: Fix updating ISO QoS PHY
      Bluetooth: ISO: Fix info leak in iso_sock_getsockopt()
      Bluetooth: ISO: Fix memory corruption
      Bluetooth: hci_event: Fix build warning with C=1
      Bluetooth: MGMT: Fixes build warnings with C=1
      Bluetooth: ISO: Fix iso_sock_getsockopt for BT_DEFER_SETUP
      Bluetooth: ISO: Fix not using the correct QoS

Marc Kleine-Budde (1):
      can: ems_usb: fix clang's -Wunaligned-access warning

Martin Schiller (1):
      net/x25: fix call timeouts in blocking connects

Matthias May (5):
      geneve: fix TOS inheriting for ipv4
      geneve: do not use RT_TOS for IPv6 flowlabel
      vxlan: do not use RT_TOS for IPv6 flowlabel
      mlx5: do not use RT_TOS for IPv6 flowlabel
      ipv6: do not use RT_TOS for IPv6 flowlabel

Maxim Mikityanskiy (1):
      net/tls: Use RCU API to access tls_ctx->netdev

Naveen Mamindlapalli (1):
      octeontx2-pf: Fix NIX_AF_TL3_TL2X_LINKX_CFG register configuration

Nick Child (1):
      MAINTAINERS: Update ibmveth maintainer

Nick Desaulniers (1):
      net: seg6: initialize induction variable to first valid array index

Nikita Shubin (1):
      net: phy: dp83867: fix get nvmem cell fail

Oleksij Rempel (1):
      net: phy: c45 baset1: do not skip aneg configuration if clock role is not specified

Pablo Neira Ayuso (4):
      netfilter: flowtable: fix incorrect Kconfig dependencies
      netfilter: nf_tables: validate variable length element extension
      netfilter: nf_tables: upfront validation of data via nft_data_init()
      netfilter: nf_tables: disallow jump to implicit chain from set element

Paolo Abeni (2):
      mptcp: move subflow cleanup in mptcp_destroy_common()
      mptcp: do not queue data on closed subflows

Paul E. McKenney (3):
      bpf: Update bpf_design_QA.rst to clarify that kprobes is not ABI
      bpf: Update bpf_design_QA.rst to clarify that attaching to functions is not ABI
      bpf: Update bpf_design_QA.rst to clarify that BTF_ID does not ABIify a function

Peilin Ye (2):
      vsock: Fix memory leak in vsock_connect()
      vsock: Set socket state back to SS_UNCONNECTED in vsock_connect_timeout()

Sandor Bodo-Merle (1):
      net: bgmac: Fix a BUG triggered by wrong bytes_compl

Sebastian Würl (1):
      can: mcp251x: Fix race condition on receive interrupt

Slark Xiao (1):
      net: usb: qmi_wwan: Add support for Cinterion MV32

Soenke Huster (1):
      Bluetooth: Fix null pointer deref on unexpected status event

Stanislav Fomichev (2):
      bpf: Use proper target btf when exporting attach_btf_obj_id
      selftests/bpf: Excercise bpf_obj_get_info_by_fd for bpf2bpf

Stanislaw Kardach (1):
      octeontx2-af: Apply tx nibble fixup always

Subbaraya Sundeep (2):
      octeontx2-af: Fix mcam entry resource leak
      octeontx2-af: Fix key checking for source mac

Sun Shouxin (1):
      net:bonding:support balance-alb interface with vlan to bridge

Tetsuo Handa (1):
      Bluetooth: don't try to cancel uninitialized works at mgmt_index_removed()

Thadeu Lima de Souza Cascardo (4):
      netfilter: nf_tables: do not allow SET_ID to refer to another table
      netfilter: nf_tables: do not allow CHAIN_ID to refer to another table
      netfilter: nf_tables: do not allow RULE_ID to refer to another chain
      net_sched: cls_route: remove from list when handle is 0

Topi Miettinen (1):
      netlabel: fix typo in comment

Vadim Pasternak (1):
      mlxsw: minimal: Fix deadlock in ports creation

Veerendranath Jakkam (1):
      wifi: cfg80211: Fix validating BSS pointers in __cfg80211_connect_result

Vladimir Oltean (6):
      net: bonding: replace dev_trans_start() with the jiffies of the last ARP/NS
      net/sched: remove hacks added to dev_trans_start() for bonding to work
      Revert "veth: Add updating of trans_start"
      docs: net: bonding: remove mentions of trans_start
      net: dsa: felix: fix min gate len calculation for tc when its first gate is closed
      net: dsa: felix: suppress non-changes to the tagging protocol

Xu Kuohai (1):
      bpf, arm64: Fix bpf trampoline instruction endianness

Xuan Zhuo (1):
      virtio_net: fix memory leak inside XPD_TX with mergeable

Yang Li (1):
      bnxt_en: Remove duplicated include bnxt_devlink.c

Yu Xiao (1):
      nfp: ethtool: fix the display error of `ethtool -m DEVNAME`

 Documentation/bpf/bpf_design_QA.rst                |  25 ++
 Documentation/networking/bonding.rst               |   9 -
 MAINTAINERS                                        |   4 +-
 arch/arm64/net/bpf_jit_comp.c                      |  16 +-
 drivers/atm/idt77252.c                             |   1 +
 drivers/net/bonding/bond_alb.c                     |  10 +
 drivers/net/bonding/bond_main.c                    |  45 ++-
 drivers/net/can/spi/mcp251x.c                      |  18 +-
 drivers/net/can/usb/ems_usb.c                      |   2 +-
 drivers/net/dsa/ocelot/felix.c                     |   3 +
 drivers/net/dsa/ocelot/felix_vsc9959.c             |  15 +-
 drivers/net/ethernet/aquantia/atlantic/aq_nic.c    |  21 +-
 drivers/net/ethernet/broadcom/bgmac.c              |   2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c  |   1 -
 drivers/net/ethernet/broadcom/genet/bcmmii.c       |   3 +
 .../chelsio/inline_crypto/ch_ktls/chcr_ktls.c      |   8 +-
 drivers/net/ethernet/engleder/tsnep_main.c         |  10 +-
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c   |   4 +-
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c    |   6 +
 .../net/ethernet/marvell/octeontx2/af/rvu_npc.c    |  15 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c |   3 +-
 .../ethernet/marvell/octeontx2/nic/otx2_common.c   |  19 +-
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |   1 +
 .../net/ethernet/mellanox/mlx5/core/en/tc_tun.c    |   4 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c |   8 +-
 drivers/net/ethernet/mellanox/mlxsw/minimal.c      |   7 -
 .../net/ethernet/netronome/nfp/nfp_net_ethtool.c   |   2 +
 .../ethernet/netronome/nfp/nfpcore/nfp_cppcore.c   |   3 +-
 drivers/net/ethernet/wangxun/Kconfig               |   6 +-
 drivers/net/geneve.c                               |  15 +-
 drivers/net/macsec.c                               |  58 ++-
 drivers/net/phy/dp83867.c                          |   2 +-
 drivers/net/phy/phy-c45.c                          |  34 +-
 drivers/net/phy/phy_device.c                       |   6 +
 drivers/net/plip/plip.c                            |   2 +-
 drivers/net/tap.c                                  |  20 +-
 drivers/net/usb/ax88179_178a.c                     |  26 +-
 drivers/net/usb/qmi_wwan.c                         |   2 +
 drivers/net/veth.c                                 |   4 -
 drivers/net/virtio_net.c                           |   5 +-
 drivers/net/vxlan/vxlan_core.c                     |   2 +-
 drivers/net/wireless/microchip/wilc1000/hif.c      |   2 +-
 drivers/net/wireless/microchip/wilc1000/hif.h      |   3 +-
 drivers/s390/net/qeth_core_main.c                  | 168 +++-----
 drivers/s390/net/qeth_ethtool.c                    |  12 +-
 include/linux/bpfptr.h                             |   8 +-
 include/linux/skmsg.h                              |   3 +-
 include/net/ax88796.h                              |   4 +-
 include/net/bonding.h                              |  13 +-
 include/net/genetlink.h                            |   5 +-
 include/net/mptcp.h                                |   4 +
 include/net/netfilter/nf_tables.h                  |  13 +-
 include/net/sock.h                                 |  68 +++-
 include/net/tls.h                                  |   2 +-
 include/uapi/linux/atm_zatm.h                      |  47 +++
 include/uapi/linux/genetlink.h                     |   5 +-
 include/uapi/linux/netfilter_ipv6/ip6t_LOG.h       |   2 +-
 kernel/bpf/arraymap.c                              |   6 +
 kernel/bpf/bpf_iter.c                              |  11 +-
 kernel/bpf/hashtab.c                               |   8 +-
 kernel/bpf/reuseport_array.c                       |   9 +-
 kernel/bpf/syscall.c                               |  35 +-
 kernel/bpf/trampoline.c                            |   5 +-
 net/ax25/ax25_timer.c                              |   4 +-
 net/bluetooth/aosp.c                               |  15 +-
 net/bluetooth/hci_conn.c                           |  11 +-
 net/bluetooth/hci_event.c                          |   7 +-
 net/bluetooth/iso.c                                |  35 +-
 net/bluetooth/l2cap_core.c                         |  13 +-
 net/bluetooth/mgmt.c                               |   7 +-
 net/bluetooth/msft.c                               |  15 +-
 net/bpf/test_run.c                                 |   1 +
 net/can/j1939/socket.c                             |   5 +-
 net/can/j1939/transport.c                          |   8 +-
 net/core/bpf_sk_storage.c                          |  12 +-
 net/core/devlink.c                                 |   4 +-
 net/core/filter.c                                  |   5 +-
 net/core/skmsg.c                                   |   4 +-
 net/core/sock_map.c                                |  20 +-
 net/ipv6/ip6_output.c                              |   3 +-
 net/ipv6/seg6_local.c                              |  10 +-
 net/mptcp/protocol.c                               |  47 ++-
 net/mptcp/protocol.h                               |  13 +-
 net/mptcp/subflow.c                                |   3 +-
 net/netfilter/Kconfig                              |   3 +-
 net/netfilter/nf_tables_api.c                      | 184 ++++++---
 net/netfilter/nf_tables_core.c                     |  21 +-
 net/netfilter/nft_bitwise.c                        |  66 ++--
 net/netfilter/nft_cmp.c                            |  44 +--
 net/netfilter/nft_dynset.c                         |   2 +-
 net/netfilter/nft_immediate.c                      |  22 +-
 net/netfilter/nft_range.c                          |  27 +-
 net/netlabel/netlabel_unlabeled.c                  |   2 +-
 net/sched/cls_route.c                              |   2 +-
 net/sched/sch_generic.c                            |   8 +-
 net/tls/tls_device.c                               |  46 ++-
 net/tls/tls_device_fallback.c                      |   3 +-
 net/tls/tls_strp.c                                 |   2 +-
 net/vmw_vsock/af_vsock.c                           |  10 +-
 net/wireless/sme.c                                 |   8 +-
 net/x25/af_x25.c                                   |   5 +
 tools/lib/bpf/skel_internal.h                      |   4 +-
 tools/testing/selftests/bpf/prog_tests/bpf_iter.c  | 116 +++++-
 .../selftests/bpf/prog_tests/fexit_bpf2bpf.c       |  95 +++++
 tools/testing/selftests/bpf/prog_tests/lru_bug.c   |  21 +
 .../selftests/bpf/progs/bpf_iter_bpf_hash_map.c    |   9 +
 .../bpf/progs/bpf_iter_bpf_sk_storage_map.c        |  22 +-
 tools/testing/selftests/bpf/progs/lru_bug.c        |  49 +++
 tools/testing/selftests/net/.gitignore             |   3 +-
 tools/testing/selftests/net/Makefile               |   2 +-
 .../net/forwarding/custom_multipath_hash.sh        |  24 +-
 .../net/forwarding/gre_custom_multipath_hash.sh    |  24 +-
 .../net/forwarding/ip6gre_custom_multipath_hash.sh |  24 +-
 tools/testing/selftests/net/mptcp/mptcp_connect.c  |  26 +-
 tools/testing/selftests/net/tap.c                  | 434 +++++++++++++++++++++
 .../selftests/netfilter/nft_trans_stress.sh        |  81 +++-
 116 files changed, 1865 insertions(+), 646 deletions(-)
 create mode 100644 include/uapi/linux/atm_zatm.h
 create mode 100644 tools/testing/selftests/bpf/prog_tests/lru_bug.c
 create mode 100644 tools/testing/selftests/bpf/progs/lru_bug.c
 create mode 100644 tools/testing/selftests/net/tap.c
