Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 726634A916A
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 01:06:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355802AbiBDAEk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 19:04:40 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:35208 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355926AbiBDAEj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 19:04:39 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D948461902;
        Fri,  4 Feb 2022 00:04:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FBB6C340E8;
        Fri,  4 Feb 2022 00:04:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643933078;
        bh=E4a7SjUKZMYWWt3XX3jNo3tpK10eaS/O7oDDDVlZp8o=;
        h=From:To:Cc:Subject:Date:From;
        b=B9T/5NApZrhUKafq+MGI+Z7aAVVLmEprqOxsNEglgFvbuLCrlOxUvZdgLY+0lK9ab
         pc89MD5QrjNi0jJkmK/DYj7j/9tp7tQdHSSouguWR5hGplwoIyrN3vor5xFLW9C98a
         KuPiT5lbo0mkW8qI8OBvPd86xeiMU5aMbwBj4COsP3BD+MC4ahlYd9is2lPRTNOFGQ
         pR4siyTa0VmWeNyjwbyCSEnET4+cTBXBBk5Ee+prZazNhQEPov75u5G/Z0rBBS8qR6
         U4nhz0P3h0lTQHB+/kdT3AbyNRI0L+hQFnc5r6K9ZtGtaIAo2wbI4HCh2ZgegYHtMq
         MA+WcOAzu2Tmw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     torvalds@linux-foundation.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Networking for 5.17-rc3
Date:   Thu,  3 Feb 2022 16:04:28 -0800
Message-Id: <20220204000428.2889873-1-kuba@kernel.org>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Linus!

The following changes since commit 23a46422c56144939c091c76cf389aa863ce9c18:

  Merge tag 'net-5.17-rc2' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2022-01-27 20:58:39 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.17-rc3

for you to fetch changes up to 87563a043cef044fed5db7967a75741cc16ad2b1:

  ax25: fix reference count leaks of ax25_dev (2022-02-03 14:20:36 -0800)

----------------------------------------------------------------
Networking fixes for 5.17-rc3, including fixes from bpf, netfilter,
and ieee802154.

Current release - regressions:

 - Partially revert "net/smc: Add netlink net namespace support",
   fix uABI breakage

 - netfilter:
     - nft_ct: fix use after free when attaching zone template
     - nft_byteorder: track register operations

Previous releases - regressions:

 - ipheth: fix EOVERFLOW in ipheth_rcvbulk_callback

 - phy: qca8081: fix speeds lower than 2.5Gb/s

 - sched: fix use-after-free in tc_new_tfilter()

Previous releases - always broken:

 - tcp: fix mem under-charging with zerocopy sendmsg()

 - tcp: add missing tcp_skb_can_collapse() test in tcp_shift_skb_data()

 - neigh: do not trigger immediate probes on NUD_FAILED from
   neigh_managed_work, avoid a deadlock

 - bpf: use VM_MAP instead of VM_ALLOC for ringbuf, avoid KASAN
   false-positives

 - netfilter: nft_reject_bridge: fix for missing reply from prerouting

 - smc: forward wakeup to smc socket waitqueue after fallback

 - ieee802154:
     - return meaningful error codes from the netlink helpers
     - mcr20a: fix lifs/sifs periods
     - at86rf230, ca8210: stop leaking skbs on error paths

 - macsec: add missing un-offload call for NETDEV_UNREGISTER of parent

 - ax25: add refcount in ax25_dev to avoid UAF bugs

 - eth: mlx5e:
     - fix SFP module EEPROM query
     - fix broken SKB allocation in HW-GRO
     - IPsec offload: fix tunnel mode crypto for non-TCP/UDP flows

 - eth: amd-xgbe:
     - fix skb data length underflow
     - ensure reset of the tx_timer_active flag, avoid Tx timeouts

 - eth: stmmac: fix runtime pm use in stmmac_dvr_remove()

 - eth: e1000e: handshake with CSME starts from Alder Lake platforms

Signed-off-by: Jakub Kicinski <kuba@kernel.org>

----------------------------------------------------------------
Alex Elder (2):
      dt-bindings: net: qcom,ipa: add optional qcom,qmp property
      net: ipa: request IPA register values be retained

Alexei Starovoitov (1):
      bpf: Fix renaming task_getsecid_subj->current_getsecid_subj.

Arınç ÜNAL (1):
      net: dsa: mt7530: make NET_DSA_MT7530 select MEDIATEK_GE_PHY

Camel Guo (1):
      net: stmmac: dump gmac4 DMA registers correctly

Daniel Borkmann (1):
      net, neigh: Do not trigger immediate probes on NUD_FAILED from neigh_managed_work

David S. Miller (3):
      Merge branch 'ax25-fixes'
      Merge tag 'ieee802154-for-net-2022-01-28' of git://git.kernel.org/pub/scm/linux/kernel/git/sschmidt/wpan
      Merge tag 'mlx5-fixes-2022-02-01' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux

Dima Chumak (1):
      net/mlx5: Fix offloading with ESWITCH_IPV4_TTL_MODIFY_ENABLE

Dmitry V. Levin (1):
      Partially revert "net/smc: Add netlink net namespace support"

Duoming Zhou (3):
      ax25: improve the incomplete fix to avoid UAF and NPD bugs
      ax25: add refcount in ax25_dev to avoid UAF bugs
      ax25: fix reference count leaks of ax25_dev

Eric Dumazet (5):
      net: sched: fix use-after-free in tc_new_tfilter()
      rtnetlink: make sure to refresh master_dev/m_ops in __rtnl_newlink()
      af_packet: fix data-race in packet_setsockopt / packet_setsockopt
      tcp: fix mem under-charging with zerocopy sendmsg()
      tcp: add missing tcp_skb_can_collapse() test in tcp_shift_skb_data()

Florian Westphal (4):
      netfilter: nft_ct: fix use after free when attaching zone template
      selftests: netfilter: reduce zone stress test running time
      selftests: netfilter: check stateless nat udp checksum fixup
      selftests: nft_concat_range: add test for reload with no element add/del

Gal Pressman (1):
      net/mlx5e: Fix module EEPROM query

Geert Uytterhoeven (1):
      netfilter: Remove flowtable relics

Georgi Valkov (1):
      ipheth: fix EOVERFLOW in ipheth_rcvbulk_callback

Haiyue Wang (1):
      gve: fix the wrong AdminQ buffer queue index check

He Fengqing (1):
      bpf: Fix possible race in inc_misses_counter

Hou Tao (1):
      bpf: Use VM_MAP instead of VM_ALLOC for ringbuf

Jakub Kicinski (6):
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf
      ethernet: smc911x: fix indentation in get/set EEPROM
      Merge branch '40GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue
      Merge branch '1GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue
      Merge branch 'net-ipa-enable-register-retention'
      Merge https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf

Jean-Philippe Brucker (1):
      tools: Ignore errors from `which' when searching a GCC toolchain

Jedrzej Jagielski (1):
      i40e: Fix reset bw limit when DCB enabled with 1 TC

Jisheng Zhang (1):
      net: stmmac: properly handle with runtime pm in stmmac_dvr_remove()

Jonathan McDowell (1):
      net: phy: Fix qca8081 with speeds lower than 2.5Gb/s

Karen Sornek (1):
      i40e: Fix reset path while removing the driver

Kees Cook (2):
      net/mlx5e: Use struct_group() for memcpy() region
      net/mlx5e: Avoid field-overflowing memcpy()

Khalid Manaa (2):
      net/mlx5e: Fix wrong calculation of header index in HW_GRO
      net/mlx5e: Fix broken SKB allocation in HW-GRO

Lior Nahmanson (2):
      net: macsec: Fix offload support for NETDEV_UNREGISTER event
      net: macsec: Verify that send_sci is on when setting Tx sci explicitly

Maher Sanalla (1):
      net/mlx5: Use del_timer_sync in fw reset flow of halting poll

Maor Dickman (2):
      net/mlx5e: Fix handling of wrong devices during bond netevent
      net/mlx5: E-Switch, Fix uninitialized variable modact

Maxim Mikityanskiy (1):
      net/mlx5e: Don't treat small ceil values as unlimited in HTB offload

Miquel Raynal (6):
      net: ieee802154: hwsim: Ensure proper channel selection at probe time
      net: ieee802154: mcr20a: Fix lifs/sifs periods
      net: ieee802154: at86rf230: Stop leaking skb's
      net: ieee802154: ca8210: Stop leaking skb's
      net: ieee802154: Return meaningful error codes from the netlink helpers
      MAINTAINERS: Remove Harry Morris bouncing address

Nathan Chancellor (1):
      tools/resolve_btfids: Do not print any commands when building silently

Pablo Neira Ayuso (2):
      netfilter: nft_byteorder: track register operations
      netfilter: nf_tables: remove assignment with no effect in chain blob builder

Phil Sutter (1):
      netfilter: nft_reject_bridge: Fix for missing reply from prerouting

Raed Salem (2):
      net/mlx5e: IPsec: Fix crypto offload for non TCP/UDP encapsulated traffic
      net/mlx5e: IPsec: Fix tunnel mode crypto offload for non TCP/UDP traffic

Raju Rangoju (1):
      net: amd-xgbe: ensure to reset the tx_timer_active flag

Roi Dayan (4):
      net/mlx5e: TC, Reject rules with drop and modify hdr action
      net/mlx5e: TC, Reject rules with forward and drop actions
      net/mlx5: Bridge, Fix devlink deadlock on net namespace deletion
      net/mlx5e: Avoid implicit modify hdr for decap drop rule

Sasha Neftin (2):
      e1000e: Separate ADP board type from TGP
      e1000e: Handshake with CSME starts from ADL platforms

Sean Young (1):
      tools headers UAPI: remove stale lirc.h

Shyam Sundar S K (1):
      net: amd-xgbe: Fix skb data length underflow

Steen Hegelund (1):
      net: sparx5: do not refer to skb after passing it on

Vlad Buslov (2):
      net/mlx5: Bridge, take rtnl lock in init error handler
      net/mlx5: Bridge, ensure dev_name is null-terminated

Wen Gu (1):
      net/smc: Forward wakeup to smc socket waitqueue after fallback

Yannick Vignon (1):
      net: stmmac: ensure PTP time register reads are consistent

Yuji Ishikawa (1):
      net: stmmac: dwmac-visconti: No change to ETHER_CLOCK_SEL for unexpected speed request.

 .../devicetree/bindings/net/qcom,ipa.yaml          |   6 +
 MAINTAINERS                                        |   3 +-
 drivers/net/dsa/Kconfig                            |   1 +
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c           |  14 +-
 drivers/net/ethernet/google/gve/gve_adminq.c       |   2 +-
 drivers/net/ethernet/intel/e1000e/e1000.h          |   4 +-
 drivers/net/ethernet/intel/e1000e/ich8lan.c        |  20 ++
 drivers/net/ethernet/intel/e1000e/netdev.c         |  39 ++--
 drivers/net/ethernet/intel/i40e/i40e.h             |   1 +
 drivers/net/ethernet/intel/i40e/i40e_main.c        |  31 ++-
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |   6 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/qos.c   |   3 +-
 .../net/ethernet/mellanox/mlx5/core/en/rep/bond.c  |  32 ++-
 .../ethernet/mellanox/mlx5/core/en/rep/bridge.c    |   6 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h  |   5 +
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c   |   4 +-
 .../mellanox/mlx5/core/en_accel/ipsec_rxtx.c       |  13 +-
 .../mellanox/mlx5/core/en_accel/ipsec_rxtx.h       |   9 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |  30 ++-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |  15 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c    |   2 +-
 .../net/ethernet/mellanox/mlx5/core/esw/bridge.c   |   4 +
 .../mlx5/core/esw/diag/bridge_tracepoint.h         |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c |   2 +-
 .../ethernet/mellanox/mlx5/core/lib/fs_chains.c    |   9 +-
 drivers/net/ethernet/mellanox/mlx5/core/port.c     |   9 +-
 .../net/ethernet/microchip/sparx5/sparx5_packet.c  |   2 +-
 drivers/net/ethernet/smsc/smc911x.c                |   8 +-
 .../net/ethernet/stmicro/stmmac/dwmac-visconti.c   |   9 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac_dma.h    |   1 +
 .../net/ethernet/stmicro/stmmac/stmmac_ethtool.c   |  19 +-
 .../net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c  |  19 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |   6 +-
 drivers/net/ieee802154/at86rf230.c                 |  13 +-
 drivers/net/ieee802154/ca8210.c                    |   1 +
 drivers/net/ieee802154/mac802154_hwsim.c           |   1 +
 drivers/net/ieee802154/mcr20a.c                    |   4 +-
 drivers/net/ipa/ipa_power.c                        |  52 +++++
 drivers/net/ipa/ipa_power.h                        |   7 +
 drivers/net/ipa/ipa_uc.c                           |   5 +
 drivers/net/macsec.c                               |  33 +--
 drivers/net/phy/at803x.c                           |  26 +--
 drivers/net/usb/ipheth.c                           |   6 +-
 include/linux/if_vlan.h                            |   6 +-
 include/net/ax25.h                                 |  12 ++
 include/net/neighbour.h                            |  18 +-
 include/uapi/linux/smc_diag.h                      |  11 +-
 kernel/bpf/bpf_lsm.c                               |   2 +-
 kernel/bpf/ringbuf.c                               |   2 +-
 kernel/bpf/trampoline.c                            |   5 +-
 net/ax25/af_ax25.c                                 |  23 ++-
 net/ax25/ax25_dev.c                                |  28 ++-
 net/ax25/ax25_route.c                              |  13 +-
 net/bridge/netfilter/nft_reject_bridge.c           |   8 +-
 net/core/neighbour.c                               |  18 +-
 net/core/rtnetlink.c                               |   6 +-
 net/ieee802154/nl802154.c                          |   8 +-
 net/ipv4/netfilter/Kconfig                         |   4 -
 net/ipv4/tcp.c                                     |   7 +-
 net/ipv4/tcp_input.c                               |   2 +
 net/ipv6/netfilter/Kconfig                         |   4 -
 net/ipv6/netfilter/Makefile                        |   3 -
 net/ipv6/netfilter/nf_flow_table_ipv6.c            |   0
 net/netfilter/nf_tables_api.c                      |   1 -
 net/netfilter/nft_byteorder.c                      |  12 ++
 net/netfilter/nft_ct.c                             |   5 +-
 net/packet/af_packet.c                             |   8 +-
 net/sched/cls_api.c                                |  11 +-
 net/smc/af_smc.c                                   | 133 ++++++++++--
 net/smc/smc.h                                      |  20 +-
 net/smc/smc_diag.c                                 |   2 -
 tools/bpf/resolve_btfids/Makefile                  |   6 +-
 tools/include/uapi/linux/lirc.h                    | 229 ---------------------
 tools/scripts/Makefile.include                     |   2 +-
 tools/testing/selftests/bpf/test_lirc_mode2_user.c |   1 -
 .../selftests/netfilter/nft_concat_range.sh        |  72 ++++++-
 tools/testing/selftests/netfilter/nft_nat.sh       | 152 ++++++++++++++
 .../testing/selftests/netfilter/nft_zones_many.sh  |  12 +-
 78 files changed, 877 insertions(+), 453 deletions(-)
 delete mode 100644 net/ipv6/netfilter/nf_flow_table_ipv6.c
 delete mode 100644 tools/include/uapi/linux/lirc.h
