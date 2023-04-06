Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1C246D9C15
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 17:20:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239524AbjDFPUn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 11:20:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239416AbjDFPUl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 11:20:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1389D83D0;
        Thu,  6 Apr 2023 08:20:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 86BC56493B;
        Thu,  6 Apr 2023 15:20:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79C27C433D2;
        Thu,  6 Apr 2023 15:20:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680794439;
        bh=iALBjLcxbxclmXrrb+HdrgJzCQJ1kju85BKHlucp6Bk=;
        h=From:To:Cc:Subject:Date:From;
        b=rHDPjry6rOenPyPv8Z5L2hZXK0ds6x7Q63yXVi3d5Qa/TXKtvMIcE4ZZOCw0uWU4u
         pV3jNNHK3vRsO4xtpWYAsDuDkq+F8f7Y5P6rOTfIORhmuwb0KKIlV5Xb0lkEPmqHzY
         rYd0G4HnzyEAMETLms+Wr/UWLEiul4GHJlJevs992cmIOo3q00yfuGMI/kOu8eHF88
         WSzQNf+Ou1IKqyoITksoZoAYlVZ4xVIZGi2iYsBruZKKTOAjB75zSQPepBSP13d7rh
         nLirnd6zonrZbNcnU/2ZtqPCl4V9mESliUoQUhxi/F40b3ALrU7VAS7bzdmkOZku1R
         LSmi9tUT4TTvA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     torvalds@linux-foundation.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, pabeni@redhat.com
Subject: [PULL v2] Networking for v6.3-rc6
Date:   Thu,  6 Apr 2023 08:20:37 -0700
Message-Id: <20230406152037.897403-1-kuba@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Linus!

As Paolo said on v1: there are a few regressions from this release.
Otherwise this is somewhat smallish, possibly due to the season holiday.

The following changes since commit b2bc47e9b2011a183f9d3d3454a294a938082fb9:

  Merge tag 'net-6.3-rc5' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2023-03-30 14:05:21 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-6.3-rc6-2

for you to fetch changes up to 8fbc10b995a506e173f1080dfa2764f232a65e02:

  net: stmmac: check fwnode for phy device before scanning for phy (2023-04-06 08:10:43 -0700)

----------------------------------------------------------------
Including fixes from wireless and can.

Current release - regressions:

 - wifi: mac80211:
   - fix potential null pointer dereference
   - fix receiving mesh packets in forwarding=0 networks
   - fix mesh forwarding

Current release - new code bugs:

   - virtio/vsock: fix leaks due to missing skb owner

Previous releases - regressions:

  - raw: fix NULL deref in raw_get_next().

  - sctp: check send stream number after wait_for_sndbuf

  - qrtr:
    - fix a refcount bug in qrtr_recvmsg()
    - do not do DEL_SERVER broadcast after DEL_CLIENT

  - wifi: brcmfmac: fix SDIO suspend/resume regression

  - wifi: mt76: fix use-after-free in fw features query.

  - can: fix race between isotp_sendsmg() and isotp_release()

  - eth: mtk_eth_soc: fix remaining throughput regression

   -eth: ice: reset FDIR counter in FDIR init stage

Previous releases - always broken:

  - core: don't let netpoll invoke NAPI if in xmit context

  - icmp: guard against too small mtu

  - ipv6: fix an uninit variable access bug in __ip6_make_skb()

  - wifi: mac80211: fix the size calculation of ieee80211_ie_len_eht_cap()

  - can: fix poll() to not report false EPOLLOUT events

  - eth: gve: secure enough bytes in the first TX desc for all TCP pkts

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>

----------------------------------------------------------------
Andrea Righi (1):
      l2tp: generate correct module alias strings

Andy Roulin (1):
      ethtool: reset #lanes when lanes is omitted

Arnd Bergmann (1):
      net: netcp: MAX_SKB_FRAGS is now 'int'

Arseniy Krasnov (1):
      vsock/vmci: convert VMCI error code to -ENOMEM on send

Ben Greear (1):
      wifi: mt76: mt7921: Fix use-after-free in fw features query.

Bobby Eshleman (1):
      virtio/vsock: fix leaks due to missing skb owner

Corinna Vinschen (1):
      net: stmmac: fix up RX flow hash indirection table when setting channels

Daniel Golle (1):
      net: sfp: add quirk enabling 2500Base-x for HG MXPD-483II

David S. Miller (1):
      Merge branch 'phy-handle-fixes'

Eric Dumazet (2):
      icmp: guard against too small mtu
      netlink: annotate lockless accesses to nlk->max_recvmsg_len

Felix Fietkau (8):
      wifi: mac80211: drop bogus static keywords in A-MSDU rx
      wifi: mac80211: fix potential null pointer dereference
      wifi: mac80211: fix receiving mesh packets in forwarding=0 networks
      wifi: mac80211: fix mesh forwarding
      wifi: mac80211: fix flow dissection for forwarded packets
      wifi: mac80211: fix invalid drv_sta_pre_rcu_remove calls for non-uploaded sta
      net: ethernet: mtk_eth_soc: fix remaining throughput regression
      wifi: mt76: ignore key disable commands

Greg Ungerer (1):
      net: fec: make use of MDIO C45 quirk

Gustav Ekelund (1):
      net: dsa: mv88e6xxx: Reset mv88e6393x force WD event bit

Hangbin Liu (1):
      selftests: net: rps_default_mask.sh: delete veth link specifically

Hans de Goede (1):
      wifi: brcmfmac: Fix SDIO suspend/resume regression

Jakub Kicinski (7):
      Merge tag 'wireless-2023-03-30' of git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless
      Revert "net: netcp: MAX_SKB_FRAGS is now 'int'"
      net: don't let netpoll invoke NAPI if in xmit context
      Merge branch 'raw-ping-fix-locking-in-proc-net-raw-icmp'
      Merge branch '100GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue
      Merge tag 'linux-can-fixes-for-6.3-20230405' of git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can
      Merge tag 'wireless-2023-04-05' of git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless

Jiri Slaby (SUSE) (1):
      net: wwan: t7xx: do not compile with -Werror

Kalle Valo (1):
      wifi: ath11k: reduce the MHI timeout to 20s

Kuniyuki Iwashima (2):
      raw: Fix NULL deref in raw_get_next().
      ping: Fix potentail NULL deref for /proc/net/icmp.

Lingyu Liu (1):
      ice: Reset FDIR counter in FDIR init stage

Lorenzo Bianconi (1):
      wifi: mt76: mt7921: fix fw used for offload check for mt7922

Michael Sit Wei Hong (4):
      net: phylink: add phylink_expects_phy() method
      net: stmmac: check if MAC needs to attach to a PHY
      net: stmmac: remove redundant fixup to support fixed-link mode
      net: stmmac: check fwnode for phy device before scanning for phy

Michal Sojka (1):
      can: isotp: isotp_ops: fix poll() to not report false EPOLLOUT events

Oleksij Rempel (1):
      can: j1939: j1939_tp_tx_dat_new(): fix out-of-bounds memory access

Oliver Hartkopp (2):
      can: isotp: isotp_recvmsg(): use sock_recv_cmsgs() to get SOCK_RXQ_OVFL infos
      can: isotp: fix race between isotp_sendsmg() and isotp_release()

Ryder Lee (1):
      wifi: mac80211: fix the size calculation of ieee80211_ie_len_eht_cap()

Shailend Chand (1):
      gve: Secure enough bytes in the first TX desc for all TCP pkts

Siddharth Vadapalli (1):
      net: ethernet: ti: am65-cpsw: Fix mdio cleanup in probe

Simei Su (1):
      ice: fix wrong fallback logic for FDIR

Song Yoong Siang (1):
      net: stmmac: Add queue reset into stmmac_xdp_open() function

Sricharan Ramabadhran (1):
      net: qrtr: Do not do DEL_SERVER broadcast after DEL_CLIENT

Xin Long (1):
      sctp: check send stream number after wait_for_sndbuf

Ziyang Xuan (2):
      net: qrtr: Fix a refcount bug in qrtr_recvmsg()
      ipv6: Fix an uninit variable access bug in __ip6_make_skb()

 drivers/net/dsa/mv88e6xxx/chip.c                   |  2 +-
 drivers/net/dsa/mv88e6xxx/global2.c                | 20 ++++++
 drivers/net/dsa/mv88e6xxx/global2.h                |  1 +
 drivers/net/ethernet/freescale/fec.h               |  5 ++
 drivers/net/ethernet/freescale/fec_main.c          | 32 ++++++----
 drivers/net/ethernet/google/gve/gve.h              |  2 +
 drivers/net/ethernet/google/gve/gve_tx.c           | 12 ++--
 drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c | 23 ++++++-
 drivers/net/ethernet/mediatek/mtk_eth_soc.c        |  4 ++
 drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c  |  1 -
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  | 21 +++++-
 drivers/net/ethernet/ti/am65-cpsw-nuss.c           |  6 +-
 drivers/net/phy/phylink.c                          | 19 ++++++
 drivers/net/phy/sfp.c                              |  4 ++
 drivers/net/wireless/ath/ath11k/mhi.c              |  2 +-
 .../wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c  | 36 ++++++++---
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.h    |  2 +
 drivers/net/wireless/mediatek/mt76/mt7603/main.c   | 10 +--
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c    | 70 ++++++--------------
 drivers/net/wireless/mediatek/mt76/mt7615/main.c   | 15 ++---
 drivers/net/wireless/mediatek/mt76/mt7615/mt7615.h |  6 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_util.c  | 18 +++---
 drivers/net/wireless/mediatek/mt76/mt7915/main.c   | 13 ++--
 drivers/net/wireless/mediatek/mt76/mt7921/init.c   |  7 +-
 drivers/net/wireless/mediatek/mt76/mt7921/main.c   | 13 ++--
 drivers/net/wireless/mediatek/mt76/mt7921/pci.c    |  2 +-
 drivers/net/wireless/mediatek/mt76/mt7996/main.c   | 13 ++--
 drivers/net/wwan/t7xx/Makefile                     |  2 -
 include/linux/phylink.h                            |  1 +
 include/net/raw.h                                  |  4 +-
 net/can/isotp.c                                    | 74 ++++++++++++++--------
 net/can/j1939/transport.c                          |  5 +-
 net/core/netpoll.c                                 | 19 +++++-
 net/ethtool/linkmodes.c                            |  7 +-
 net/ipv4/icmp.c                                    |  5 ++
 net/ipv4/ping.c                                    |  8 +--
 net/ipv4/raw.c                                     | 36 ++++++-----
 net/ipv4/raw_diag.c                                | 10 ++-
 net/ipv6/ip6_output.c                              |  7 +-
 net/ipv6/raw.c                                     | 10 ++-
 net/l2tp/l2tp_ip.c                                 |  8 +--
 net/l2tp/l2tp_ip6.c                                |  8 +--
 net/mac80211/rx.c                                  | 29 +++++----
 net/mac80211/sta_info.c                            |  3 +-
 net/mac80211/util.c                                |  2 +-
 net/netlink/af_netlink.c                           | 15 +++--
 net/qrtr/af_qrtr.c                                 |  2 +
 net/qrtr/ns.c                                      | 15 +++--
 net/sctp/socket.c                                  |  4 ++
 net/vmw_vsock/virtio_transport_common.c            | 10 +++
 net/vmw_vsock/vmci_transport.c                     |  8 ++-
 tools/testing/selftests/net/rps_default_mask.sh    |  1 +
 52 files changed, 408 insertions(+), 244 deletions(-)
