Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B315575599
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 21:05:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232688AbiGNTFB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 15:05:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232623AbiGNTFA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 15:05:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD94352E7B;
        Thu, 14 Jul 2022 12:04:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6A201621AE;
        Thu, 14 Jul 2022 19:04:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81E4CC34114;
        Thu, 14 Jul 2022 19:04:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657825497;
        bh=tB6hR4ChgQITGe8XS9ThbtDGN3Wu28pBBAA9BdwKVZE=;
        h=From:To:Cc:Subject:Date:From;
        b=I/MxXESJbNzS/gwDsK/U39AX8NLAzdY25SgCL5TLxn4LeJ0iIFXpbSlMOjiNyuOg6
         eu3RX1h1ZBAqLcAtdtwH/BmKVByA62y6o00N/BLRo2FBu82nF28NWwOiCmoeQh1qpP
         K3eGzx8Lha9kYB2C8FTzPYHsPQolYHw8gxCWmtniHqVtKEnirPHtwe2uxatvha5N1y
         T5uXPc8yC4koC8+EHIv3dTA21pKd8sTNnsLwz0qSrwTN7Kot+uHoiX1att/RKd3t3I
         2ImKV6zG80Whq8qeKi9OX8B0Wg1Ccq8aUmflY0d1VKPxntZTeOwxlqwSAx5INyDVVk
         upXci9cDaYPgg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     torvalds@linux-foundation.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PULL] Networking for 5.19-rc7
Date:   Thu, 14 Jul 2022 12:04:51 -0700
Message-Id: <20220714190451.2808151-1-kuba@kernel.org>
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

Still no major regressions, the release continues to be calm.
An uptick of fixes this time around due to trivial data race
fixes and patches flowing down from subtrees.

There has been a few driver fixes (particularly few fixes for
false positives due to 66e4c8d95008 which went into -next in May!)
that make me worry the wide testing is not exactly fully thru.
So "calm" but not "let's just cut the final ASAP" vibes over here.

The following changes since commit ef4ab3ba4e4f99b1f3af3a7b74815f59394d822e:

  Merge tag 'net-5.19-rc6' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2022-07-07 10:08:20 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.19-rc7

for you to fetch changes up to 656bd03a2cd853e7c7c4e08968ad8c0ea993737d:

  nfp: flower: configure tunnel neighbour on cmsg rx (2022-07-14 10:12:56 -0700)

----------------------------------------------------------------
Including fixes from netfilter, bpf and wireless.

Current release - regressions:

 - wifi: rtw88: fix write to const table of channel parameters

Current release - new code bugs:

 - mac80211: add gfp_t parameter to
   ieeee80211_obss_color_collision_notify

 - mlx5:
   - TC, allow offload from uplink to other PF's VF
   - Lag, decouple FDB selection and shared FDB
   - Lag, correct get the port select mode str

 - bnxt_en: fix and simplify XDP transmit path

 - r8152: fix accessing unset transport header

Previous releases - regressions:

 - conntrack: fix crash due to confirmed bit load reordering
   (after atomic -> refcount conversion)

 - stmmac: dwc-qos: disable split header for Tegra194

Previous releases - always broken:

 - mlx5e: ring the TX doorbell on DMA errors

 - bpf: make sure mac_header was set before using it

 - mac80211: do not wake queues on a vif that is being stopped

 - mac80211: fix queue selection for mesh/OCB interfaces

 - ip: fix dflt addr selection for connected nexthop

 - seg6: fix skb checksums for SRH encapsulation/insertion

 - xdp: fix spurious packet loss in generic XDP TX path

 - bunch of sysctl data race fixes

 - nf_log: incorrect offset to network header

Misc:

 - bpf: add flags arg to bpf_dynptr_read and bpf_dynptr_write APIs

Signed-off-by: Jakub Kicinski <kuba@kernel.org>

----------------------------------------------------------------
Andrea Mayer (3):
      seg6: fix skb checksum evaluation in SRH encapsulation/insertion
      seg6: fix skb checksum in SRv6 End.B6 and End.B6.Encaps behaviors
      seg6: bpf: fix skb checksum in bpf_push_seg6_encap()

Baowen Zheng (1):
      nfp: fix issue of skb segments exceeds descriptor limitation

Chia-Lin Kao (AceLan) (2):
      net: atlantic: remove deep parameter on suspend/resume functions
      net: atlantic: remove aq_nic_deinit() when resume

Dan Carpenter (1):
      net: stmmac: fix leaks in probe

David S. Miller (5):
      Merge branch 'sysctl-data-races'
      Merge branch 'mptcp-fixes'
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf
      Merge branch 'net-sysctl-races'
      Merge tag 'wireless-2022-07-13' of git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless

Eli Cohen (1):
      net/mlx5: TC, allow offload from uplink to other PF's VF

Eric Dumazet (2):
      bpf: Make sure mac_header was set before using it
      vlan: fix memory leak in vlan_newlink()

Felix Fietkau (2):
      wifi: mac80211: do not wake queues on a vif that is being stopped
      wifi: mac80211: fix queue selection for mesh/OCB interfaces

Florian Westphal (1):
      netfilter: conntrack: fix crash due to confirmed bit load reordering

Gal Pressman (1):
      net/mlx5e: Fix capability check for updating vnic env counters

Hayes Wang (1):
      r8152: fix accessing unset transport header

Jakub Kicinski (6):
      Merge tag 'mlx5-fixes-2022-07-06' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux
      Merge https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf
      Merge branch 'selftests-forwarding-install-two-missing-tests'
      selftest: net: add tun to .gitignore
      Merge branch 'bnxt_en-5-bug-fixes'
      Merge branch '100GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue

Joanne Koong (1):
      bpf: Add flags arg to bpf_dynptr_read and bpf_dynptr_write APIs

Johan Almbladh (1):
      xdp: Fix spurious packet loss in generic XDP TX path

Johannes Berg (1):
      wifi: mac80211_hwsim: set virtio device ready in probe()

Jon Hunter (1):
      net: stmmac: dwc-qos: Disable split header for Tegra194

Juergen Gross (1):
      xen/netback: avoid entering xenvif_rx_next_skb() with an empty rx queue

Kalle Valo (2):
      dt-bindings: net: wireless: ath9k: Change Toke as maintainer
      dt-bindings: net: wireless: ath11k: change Kalle's email

Kashyap Desai (1):
      bnxt_en: reclaim max resources if sriov enable fails

Kuniyuki Iwashima (27):
      sysctl: Fix data races in proc_dointvec().
      sysctl: Fix data races in proc_douintvec().
      sysctl: Fix data races in proc_dointvec_minmax().
      sysctl: Fix data races in proc_douintvec_minmax().
      sysctl: Fix data races in proc_doulongvec_minmax().
      sysctl: Fix data races in proc_dointvec_jiffies().
      tcp: Fix a data-race around sysctl_tcp_max_orphans.
      inetpeer: Fix data-races around sysctl.
      net: Fix data-races around sysctl_mem.
      cipso: Fix data-races around sysctl.
      icmp: Fix data-races around sysctl.
      ipv4: Fix a data-race around sysctl_fib_sync_mem.
      sysctl: Fix data-races in proc_dou8vec_minmax().
      sysctl: Fix data-races in proc_dointvec_ms_jiffies().
      tcp: Fix a data-race around sysctl_max_tw_buckets.
      icmp: Fix a data-race around sysctl_icmp_echo_ignore_all.
      icmp: Fix data-races around sysctl_icmp_echo_enable_probe.
      icmp: Fix a data-race around sysctl_icmp_echo_ignore_broadcasts.
      icmp: Fix a data-race around sysctl_icmp_ignore_bogus_error_responses.
      icmp: Fix a data-race around sysctl_icmp_errors_use_inbound_ifaddr.
      icmp: Fix a data-race around sysctl_icmp_ratelimit.
      icmp: Fix a data-race around sysctl_icmp_ratemask.
      raw: Fix a data-race around sysctl_raw_l3mdev_accept.
      tcp: Fix data-races around sysctl_tcp_ecn.
      tcp: Fix a data-race around sysctl_tcp_ecn_fallback.
      ipv4: Fix data-races around sysctl_ip_dynaddr.
      nexthop: Fix data-races around nexthop_compat_mode.

Liang He (1):
      net: ftgmac100: Hold reference returned by of_get_child_by_name()

Liu, Changcheng (1):
      net/mlx5: Lag, correct get the port select mode str

Lorenzo Bianconi (1):
      wifi: mac80211: add gfp_t parameter to ieeee80211_obss_color_collision_notify

Mark Bloch (1):
      net/mlx5: Lag, decouple FDB selection and shared FDB

Martin Blumenstingl (2):
      selftests: forwarding: Install local_termination.sh
      selftests: forwarding: Install no_forwarding.sh

Matthieu Baerts (1):
      selftests: mptcp: validate userspace PM tests by default

Maxim Mikityanskiy (1):
      net/mlx5e: Ring the TX doorbell on DMA errors

Michael Chan (2):
      bnxt_en: Fix bnxt_reinit_after_abort() code path
      bnxt_en: Fix and simplify XDP transmit path

Nick Bowler (1):
      net: sunhme: output link status with a single print.

Nicolas Dichtel (2):
      ip: fix dflt addr selection for connected nexthop
      selftests/net: test nexthop without gw

Pablo Neira Ayuso (2):
      netfilter: nf_log: incorrect offset to network header
      netfilter: nf_tables: replace BUG_ON by element length check

Paolo Abeni (2):
      mptcp: fix subflow traversal at disconnect time
      Merge branch 'seg6-fix-skb-checksum-for-srh-encapsulation-insertion'

Paul Blakey (1):
      net/mlx5e: Fix enabling sriov while tc nic rules are offloaded

Paul M Stillwell Jr (2):
      ice: handle E822 generic device ID in PLDM header
      ice: change devlink code to read NVM in blocks

Pavan Chebbi (1):
      bnxt_en: Fix bnxt_refclk_read()

Pavel Skripkin (1):
      net: ocelot: fix wrong time_after usage

Ping-Ke Shih (1):
      rtw88: 8821c: fix access const table of channel parameters

Roi Dayan (1):
      net/mlx5e: CT: Use own workqueue instead of mlx5e priv

Ryder Lee (1):
      wifi: mac80211: check skb_shared in ieee80211_8023_xmit()

Siddharth Vadapalli (1):
      net: ethernet: ti: am65-cpsw: Fix devlink port register sequence

Steven Rostedt (Google) (1):
      net: sock: tracing: Fix sock_exceed_buf_limit not to dereference stale pointer

Tariq Toukan (3):
      net/mlx5e: kTLS, Fix build time constant test in TX
      net/mlx5e: kTLS, Fix build time constant test in RX
      net/tls: Check for errors in tls_device_init

Tianyu Yuan (1):
      nfp: flower: configure tunnel neighbour on cmsg rx

Tom Lendacky (1):
      MAINTAINERS: Add an additional maintainer to the AMD XGBE driver

Vikas Gupta (1):
      bnxt_en: fix livepatch query

Vinayak Yadawad (1):
      wifi: cfg80211: Allow P2P client interface to indicate port authorization

Yevhen Orlov (1):
      net: marvell: prestera: fix missed deinit sequence

Íñigo Huguet (2):
      sfc: fix use after free when disabling sriov
      sfc: fix kernel panic when creating VF

 .../bindings/net/wireless/qca,ath9k.yaml           |   2 +-
 .../bindings/net/wireless/qcom,ath11k.yaml         |   2 +-
 Documentation/networking/ip-sysctl.rst             |   4 +-
 MAINTAINERS                                        |   1 +
 .../net/ethernet/aquantia/atlantic/aq_pci_func.c   |  23 ++--
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |   5 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h          |   1 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c  |   8 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c      |  13 ++-
 drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c    |   7 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c      |  10 +-
 .../chelsio/inline_crypto/chtls/chtls_cm.c         |   2 +-
 drivers/net/ethernet/faraday/ftgmac100.c           |  15 ++-
 drivers/net/ethernet/intel/ice/ice_devids.h        |   1 +
 drivers/net/ethernet/intel/ice/ice_devlink.c       |  59 ++++++----
 drivers/net/ethernet/intel/ice/ice_fw_update.c     |  96 ++++++++++++++++-
 drivers/net/ethernet/intel/ice/ice_main.c          |   1 +
 .../ethernet/marvell/prestera/prestera_router.c    |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c |  20 ++--
 .../ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c |   3 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c |   3 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c    |  39 +++++--
 .../net/ethernet/mellanox/mlx5/core/esw/legacy.c   |   5 +-
 .../net/ethernet/mellanox/mlx5/core/lag/debugfs.c  |  14 ++-
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c  |  18 ++--
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h  |   3 +-
 .../net/ethernet/mellanox/mlx5/core/lag/mpesw.c    |   5 +-
 drivers/net/ethernet/mscc/ocelot_fdma.c            |  17 ++-
 .../ethernet/netronome/nfp/flower/tunnel_conf.c    |  18 +++-
 drivers/net/ethernet/netronome/nfp/nfdk/dp.c       |  33 ++++--
 drivers/net/ethernet/sfc/ef10.c                    |   3 +
 drivers/net/ethernet/sfc/ef10_sriov.c              |  10 +-
 .../ethernet/stmicro/stmmac/dwmac-dwc-qos-eth.c    |   1 +
 .../net/ethernet/stmicro/stmmac/dwmac-ingenic.c    |   6 +-
 drivers/net/ethernet/sun/sunhme.c                  |  43 +++-----
 drivers/net/ethernet/ti/am65-cpsw-nuss.c           |  17 +--
 drivers/net/usb/r8152.c                            |  14 +--
 drivers/net/wireless/ath/ath11k/wmi.c              |   3 +-
 drivers/net/wireless/mac80211_hwsim.c              |   2 +
 drivers/net/wireless/realtek/rtw88/main.h          |   6 +-
 drivers/net/wireless/realtek/rtw88/rtw8821c.c      |  14 +--
 drivers/net/xen-netback/rx.c                       |   1 +
 include/net/cfg80211.h                             |   5 +-
 include/net/mac80211.h                             |   3 +-
 include/net/netfilter/nf_tables.h                  |  14 ++-
 include/net/raw.h                                  |   2 +-
 include/net/sock.h                                 |   2 +-
 include/net/tls.h                                  |   4 +-
 include/trace/events/sock.h                        |   6 +-
 include/uapi/linux/bpf.h                           |  11 +-
 kernel/bpf/core.c                                  |   8 +-
 kernel/bpf/helpers.c                               |  12 ++-
 kernel/sysctl.c                                    |  37 ++++---
 net/8021q/vlan_netlink.c                           |  10 +-
 net/core/dev.c                                     |   8 +-
 net/core/filter.c                                  |   1 -
 net/ipv4/af_inet.c                                 |   4 +-
 net/ipv4/cipso_ipv4.c                              |  12 ++-
 net/ipv4/fib_semantics.c                           |   4 +-
 net/ipv4/fib_trie.c                                |   2 +-
 net/ipv4/icmp.c                                    |  20 ++--
 net/ipv4/inet_timewait_sock.c                      |   3 +-
 net/ipv4/inetpeer.c                                |  12 ++-
 net/ipv4/nexthop.c                                 |   5 +-
 net/ipv4/syncookies.c                              |   2 +-
 net/ipv4/sysctl_net_ipv4.c                         |  12 +++
 net/ipv4/tcp.c                                     |   3 +-
 net/ipv4/tcp_input.c                               |   2 +-
 net/ipv4/tcp_output.c                              |   4 +-
 net/ipv6/icmp.c                                    |   2 +-
 net/ipv6/route.c                                   |   2 +-
 net/ipv6/seg6_iptunnel.c                           |   5 +-
 net/ipv6/seg6_local.c                              |   2 -
 net/mac80211/cfg.c                                 |   4 +-
 net/mac80211/iface.c                               |   2 +
 net/mac80211/rx.c                                  |   3 +-
 net/mac80211/tx.c                                  |  36 +++----
 net/mac80211/util.c                                |   3 +
 net/mac80211/wme.c                                 |   4 +-
 net/mptcp/protocol.c                               |   4 +-
 net/netfilter/nf_conntrack_core.c                  |  22 ++++
 net/netfilter/nf_conntrack_netlink.c               |   1 +
 net/netfilter/nf_conntrack_standalone.c            |   3 +
 net/netfilter/nf_log_syslog.c                      |   8 +-
 net/netfilter/nf_tables_api.c                      |  72 +++++++++----
 net/tls/tls_device.c                               |   4 +-
 net/tls/tls_main.c                                 |   7 +-
 net/wireless/sme.c                                 |   3 +-
 tools/include/uapi/linux/bpf.h                     |  11 +-
 tools/testing/selftests/bpf/progs/dynptr_fail.c    |  10 +-
 tools/testing/selftests/bpf/progs/dynptr_success.c |   4 +-
 tools/testing/selftests/net/.gitignore             |   1 +
 tools/testing/selftests/net/Makefile               |   2 +-
 tools/testing/selftests/net/fib_nexthop_nongw.sh   | 119 +++++++++++++++++++++
 tools/testing/selftests/net/forwarding/Makefile    |   2 +
 tools/testing/selftests/net/mptcp/Makefile         |   2 +-
 98 files changed, 768 insertions(+), 331 deletions(-)
 create mode 100755 tools/testing/selftests/net/fib_nexthop_nongw.sh
