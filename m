Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC2CB5FDEFB
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 19:30:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229972AbiJMRaf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 13:30:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229861AbiJMRaR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 13:30:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9E521BE91;
        Thu, 13 Oct 2022 10:29:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 90D5B618D7;
        Thu, 13 Oct 2022 17:29:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB50AC433D6;
        Thu, 13 Oct 2022 17:29:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665682194;
        bh=dgamv1WD4e4OHeEfZRuftyyK9wNJhEN0+bFLo24PNgU=;
        h=From:To:Cc:Subject:Date:From;
        b=UcwbOpZgLKU18RWWgoKjMgfa2XqVVGvs0TANsy83nLEYMuMcs+dZcW/rTWhEORrmY
         0EHeachApvo3XhH/r2hHBoitn/MSaOt2wlMIHLahEi8VvjOpDLCHqMOh1AS3reQwfv
         u/Aq+2YiyiPqcV6Ftp+N8/iunVYIaDPJzsMMWJXmWQunqFCOPV08V8JpQ10iAuJgwc
         9iffqDJIxgKyvPIwfjMVMkQzgAENkRtiuMVrLo/k+h+TnEksVi0/CrJCFi1s+w1Vue
         zSF2N3a/Q/WOcxkK3VmwLaAQZ1ppV8UHdsqjzN6DDRlfNv8fmJpsbTx+u8wTF6nFrh
         HDPYm/dR5VYMA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     torvalds@linux-foundation.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, pabeni@redhat.com
Subject: [PULL] Networking for v6.1-rc1
Date:   Thu, 13 Oct 2022 10:29:52 -0700
Message-Id: <20221013172952.338043-1-kuba@kernel.org>
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

We don't have a fix for the gcc 8.5 objtool warning, yet, because
apparently it's very compiler-version specific. I seem to be the only
one bothered by it so far. So I'll keep poking but if my own setup
updates to a new compiler I may stop caring as well..

The following changes since commit 0326074ff4652329f2a1a9c8685104576bd8d131:

  Merge tag 'net-next-6.1' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next (2022-10-04 13:38:03 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-6.1-rc1

for you to fetch changes up to 99df45c9e0a43b1b88dab294265e2be4a040a441:

  sunhme: fix an IS_ERR() vs NULL check in probe (2022-10-13 09:34:09 -0700)

----------------------------------------------------------------
Including fixes from netfilter, and wifi.

Current release - regressions:

 - Revert "net/sched: taprio: make qdisc_leaf() see
   the per-netdev-queue pfifo child qdiscs", it may cause crashes
   when the qdisc is reconfigured

 - inet: ping: fix splat due to packet allocation refactoring in inet

 - tcp: clean up kernel listener's reqsk in inet_twsk_purge(),
   fix UAF due to races when per-netns hash table is used

Current release - new code bugs:

 - eth: adin1110: check in netdev_event that netdev belongs to driver

 - fixes for PTR_ERR() vs NULL bugs in driver code, from Dan and co.

Previous releases - regressions:

 - ipv4: handle attempt to delete multipath route when fib_info
   contains an nh reference, avoid oob access

 - wifi: fix handful of bugs in the new Multi-BSSID code

 - wifi: mt76: fix rate reporting / throughput regression on mt7915
   and newer, fix checksum offload

 - wifi: iwlwifi: mvm: fix double list_add at
   iwl_mvm_mac_wake_tx_queue (other cases)

 - wifi: mac80211: do not drop packets smaller than the LLC-SNAP
   header on fast-rx

Previous releases - always broken:

 - ieee802154: don't warn zero-sized raw_sendmsg()

 - ipv6: ping: fix wrong checksum for large frames

 - mctp: prevent double key removal and unref

 - tcp/udp: fix memory leaks and races around IPV6_ADDRFORM

 - hv_netvsc: fix race between VF offering and VF association message

Misc:

 - remove -Warray-bounds silencing in the drivers, compilers fixed

Signed-off-by: Jakub Kicinski <kuba@kernel.org>

----------------------------------------------------------------
Alexander Aring (2):
      Revert "net/ieee802154: reject zero-sized raw_sendmsg()"
      net: ieee802154: return -EINVAL for unknown addr type

Alexander Wetzel (1):
      wifi: mac80211: netdev compatible TX stop for iTXQ drivers

Alexandru Tachici (1):
      net: ethernet: adi: adin1110: Add check in netdev_event

Anssi Hannula (4):
      can: kvaser_usb_leaf: Fix overread with an invalid command
      can: kvaser_usb: Fix use of uninitialized completion
      can: kvaser_usb_leaf: Fix TX queue out of sync after restart
      can: kvaser_usb_leaf: Fix CAN state after restart

Casper Andersson (1):
      docs: networking: phy: add missing space

Dan Carpenter (3):
      wifi: mac80211: unlock on error in ieee80211_can_powered_addr_change()
      net: marvell: prestera: fix a couple NULL vs IS_ERR() checks
      sunhme: fix an IS_ERR() vs NULL check in probe

David Ahern (1):
      ipv4: Handle attempt to delete multipath route when fib_info contains an nh reference

David S. Miller (2):
      Merge branch 'inet-ping-fixes'
      Merge branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf

Divya Koppera (1):
      net: phy: micrel: Fixes FIELD_GET assertion

Duoming Zhou (1):
      mISDN: hfcpci: Fix use-after-free bug in hfcpci_softirq

Eric Dumazet (5):
      macvlan: enforce a consistent minimal mtu
      ipv6: ping: fix wrong checksum for large frames
      inet: ping: fix recent breakage
      tcp: cdg: allow tcp_cdg_release() to be called multiple times
      kcm: avoid potential race in kcm_tx_work

Felix Fietkau (6):
      wifi: mt76: fix rate reporting / throughput regression on mt7915 and newer
      wifi: mac80211: do not drop packets smaller than the LLC-SNAP header on fast-rx
      wifi: mac80211: fix decap offload for stations on AP_VLAN interfaces
      wifi: cfg80211: fix ieee80211_data_to_8023_exthdr handling of small packets
      wifi: mt76: fix receiving LLC packets on mt7615/mt7915
      wifi: mt76: fix rx checksum offload on mt7615/mt7915/mt7921

Florian Fainelli (1):
      net: systemport: Enable all RX descriptors for SYSTEMPORT Lite

Gaurav Kohli (1):
      hv_netvsc: Fix race between VF offering and VF association message from host

Geert Uytterhoeven (1):
      net: pse-pd: PSE_REGULATOR should depend on REGULATOR

Hawkins Jiawei (1):
      wifi: wext: use flex array destination for memcpy()

Jakub Kicinski (3):
      Merge tag 'ieee802154-for-net-2022-10-05' of git://git.kernel.org/pub/scm/linux/kernel/git/sschmidt/wpan
      Merge tag 'wireless-2022-10-11' of git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless
      Merge branch 'tcp-udp-fix-memory-leaks-and-data-races-around-ipv6_addrform'

James Prestwood (2):
      wifi: mac80211: fix probe req HE capabilities access
      wifi: mac80211: remove/avoid misleading prints

Jeremy Kerr (1):
      mctp: prevent double key removal and unref

Johannes Berg (10):
      wifi: cfg80211: fix u8 overflow in cfg80211_update_notlisted_nontrans()
      wifi: cfg80211/mac80211: reject bad MBSSID elements
      wifi: mac80211: fix MBSSID parsing use-after-free
      wifi: cfg80211: ensure length byte is present before access
      wifi: cfg80211: fix BSS refcounting bugs
      wifi: cfg80211: avoid nontransmitted BSS list corruption
      wifi: mac80211_hwsim: avoid mac80211 warning on bad rate
      wifi: mac80211: fix crash in beacon protection for P2P-device
      wifi: cfg80211: update hidden BSSes to avoid WARN_ON
      Merge branch 'cve-fixes-2022-10-13'

Jose Ignacio Tornos Martinez (1):
      wifi: iwlwifi: mvm: fix double list_add at iwl_mvm_mac_wake_tx_queue (other cases)

Kalle Valo (1):
      wifi: ath11k: mac: fix reading 16 bytes from a region of size 0 warning

Kees Cook (3):
      net: ethernet: mediatek: Remove -Warray-bounds exception
      net: ethernet: bgmac: Remove -Warray-bounds exception
      wifi: nl80211: Split memcpy() of struct nl80211_wowlan_tcp_data_token flexible array

Kuniyuki Iwashima (6):
      tcp/udp: Fix memory leak in ipv6_renew_options().
      udp: Call inet6_destroy_sock() in setsockopt(IPV6_ADDRFORM).
      tcp/udp: Call inet6_destroy_sock() in IPv6 sk->sk_destruct().
      ipv6: Fix data races around sk->sk_prot.
      tcp: Fix data races around icsk->icsk_af_ops.
      tcp: Clean up kernel listener's reqsk in inet_twsk_purge()

Leon Romanovsky (1):
      net/mlx5: Make ASO poll CQ usable in atomic context

Louis Peens (1):
      nfp: flower: fix incorrect struct type in GRE key_size

Maksym Glubokiy (1):
      net: prestera: span: do not unbind things things that were never bound

Marc Kleine-Budde (1):
      Merge patch series "can: kvaser_usb: Various fixes"

Marek Behún (1):
      net: sfp: fill also 5gbase-r and 25gbase-r modes in sfp_parse_support()

Matthias Schiffer (1):
      net: ethernet: ti: am65-cpsw: set correct devlink flavour for unused ports

Paolo Abeni (2):
      Merge tag 'linux-can-fixes-for-6.1-20221011' of git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can
      Merge tag 'wireless-2022-10-13' of git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless

Phil Sutter (3):
      selftests: netfilter: Test reverse path filtering
      netfilter: rpfilter/fib: Populate flowic_l3mdev field
      selftests: netfilter: Fix nft_fib.sh for all.rp_filter=1

Serhiy Boiko (1):
      prestera: matchall: do not rollback if rule exists

Tetsuo Handa (1):
      net/ieee802154: don't warn zero-sized raw_sendmsg()

Vadim Fedorenko (1):
      ] ptp: ocp: remove symlink for second GNSS

Vladimir Oltean (1):
      Revert "net/sched: taprio: make qdisc_leaf() see the per-netdev-queue pfifo child qdiscs"

Wenjia Zhang (1):
      MAINTAINERS: add Jan as SMC maintainer

Xin Long (1):
      openvswitch: add nf_ct_is_confirmed check before assigning the helper

Yang Li (2):
      octeontx2-pf: mcs: remove unneeded semicolon
      net: enetc: Remove duplicated include in enetc_qos.c

Yang Yingliang (4):
      octeontx2-pf: mcs: fix missing unlock in some error paths
      net: dsa: fix wrong pointer passed to PTR_ERR() in dsa_port_phylink_create()
      octeontx2-af: cn10k: mcs: Fix error return code in mcs_register_interrupts()
      octeontx2-pf: mcs: fix possible memory leak in otx2_probe()

 Documentation/networking/phy.rst                   |   2 +-
 MAINTAINERS                                        |   1 +
 drivers/isdn/hardware/mISDN/hfcpci.c               |   3 +-
 drivers/net/can/usb/kvaser_usb/kvaser_usb.h        |   2 +
 drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c   |   3 +-
 drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c  |   2 +-
 drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c   |  79 +++++++++++
 drivers/net/ethernet/adi/adin1110.c                |  13 +-
 drivers/net/ethernet/broadcom/Makefile             |   5 -
 drivers/net/ethernet/broadcom/bcmsysport.h         |   2 +-
 drivers/net/ethernet/freescale/enetc/enetc_qos.c   |   1 -
 drivers/net/ethernet/marvell/octeontx2/af/mcs.c    |   4 +-
 .../ethernet/marvell/octeontx2/nic/cn10k_macsec.c  |   7 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   |   4 +-
 .../ethernet/marvell/prestera/prestera_matchall.c  |   2 +
 .../ethernet/marvell/prestera/prestera_router_hw.c |   6 +-
 .../net/ethernet/marvell/prestera/prestera_span.c  |   5 +-
 drivers/net/ethernet/mediatek/Makefile             |   5 -
 .../net/ethernet/mellanox/mlx5/core/en/tc/meter.c  |   8 +-
 .../ethernet/mellanox/mlx5/core/en_accel/macsec.c  |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/lib/aso.c  |  10 +-
 drivers/net/ethernet/mellanox/mlx5/core/lib/aso.h  |   2 +-
 .../net/ethernet/netronome/nfp/flower/offload.c    |   4 +-
 drivers/net/ethernet/sun/sunhme.c                  |   4 +-
 drivers/net/ethernet/ti/am65-cpsw-nuss.c           |   5 +-
 drivers/net/hyperv/hyperv_net.h                    |   3 +-
 drivers/net/hyperv/netvsc.c                        |   4 +
 drivers/net/hyperv/netvsc_drv.c                    |  19 +++
 drivers/net/macvlan.c                              |   2 +-
 drivers/net/phy/micrel.c                           |   9 +-
 drivers/net/phy/sfp-bus.c                          |   3 +
 drivers/net/pse-pd/Kconfig                         |   1 +
 drivers/net/wireless/ath/ath11k/mac.c              |   5 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       |   2 +
 drivers/net/wireless/mac80211_hwsim.c              |   2 +
 drivers/net/wireless/mediatek/mt76/dma.c           |   5 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c    |  12 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mac.c    |  12 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mac.c    |   4 +-
 drivers/net/wireless/mediatek/mt76/tx.c            |  10 +-
 drivers/ptp/ptp_ocp.c                              |   1 +
 include/linux/wireless.h                           |  10 +-
 include/net/ieee802154_netdev.h                    |  12 +-
 include/net/ipv6.h                                 |   2 +
 include/net/udp.h                                  |   2 +-
 include/net/udplite.h                              |   8 --
 net/core/sock.c                                    |   6 +-
 net/dsa/port.c                                     |   2 +-
 net/ieee802154/socket.c                            |   7 +-
 net/ipv4/af_inet.c                                 |  23 +++-
 net/ipv4/fib_semantics.c                           |   8 +-
 net/ipv4/inet_timewait_sock.c                      |  15 ++-
 net/ipv4/netfilter/ipt_rpfilter.c                  |   2 +-
 net/ipv4/netfilter/nft_fib_ipv4.c                  |   2 +-
 net/ipv4/ping.c                                    |  23 +---
 net/ipv4/tcp.c                                     |  10 +-
 net/ipv4/tcp_cdg.c                                 |   2 +
 net/ipv4/tcp_minisocks.c                           |   9 +-
 net/ipv4/udp.c                                     |   9 +-
 net/ipv4/udplite.c                                 |   8 ++
 net/ipv6/af_inet6.c                                |  14 +-
 net/ipv6/ipv6_sockglue.c                           |  34 ++---
 net/ipv6/netfilter/ip6t_rpfilter.c                 |   9 +-
 net/ipv6/netfilter/nft_fib_ipv6.c                  |   5 +-
 net/ipv6/ping.c                                    |   2 +-
 net/ipv6/tcp_ipv6.c                                |   6 +-
 net/ipv6/udp.c                                     |  15 ++-
 net/ipv6/udp_impl.h                                |   1 +
 net/ipv6/udplite.c                                 |   9 +-
 net/kcm/kcmsock.c                                  |   2 +-
 net/mac80211/ieee80211_i.h                         |   8 ++
 net/mac80211/iface.c                               |   8 +-
 net/mac80211/mlme.c                                |   7 +-
 net/mac80211/rx.c                                  |  21 +--
 net/mac80211/tx.c                                  |  10 +-
 net/mac80211/util.c                                |  34 ++---
 net/mctp/af_mctp.c                                 |  23 +++-
 net/mctp/route.c                                   |  10 +-
 net/openvswitch/conntrack.c                        |   3 +-
 net/sched/sch_taprio.c                             |   8 +-
 net/wireless/nl80211.c                             |   4 +-
 net/wireless/scan.c                                |  77 +++++++----
 net/wireless/util.c                                |  40 +++---
 net/wireless/wext-core.c                           |  17 ++-
 tools/testing/selftests/net/fib_nexthops.sh        |   5 +
 tools/testing/selftests/netfilter/Makefile         |   2 +-
 tools/testing/selftests/netfilter/nft_fib.sh       |   1 +
 tools/testing/selftests/netfilter/rpath.sh         | 147 +++++++++++++++++++++
 88 files changed, 684 insertions(+), 275 deletions(-)
 create mode 100755 tools/testing/selftests/netfilter/rpath.sh
