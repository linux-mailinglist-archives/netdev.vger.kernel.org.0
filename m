Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D6966A4DA2
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 22:57:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229686AbjB0V5w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 16:57:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbjB0V5v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 16:57:51 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2188420063;
        Mon, 27 Feb 2023 13:57:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5165DCE1182;
        Mon, 27 Feb 2023 21:57:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 366ECC433D2;
        Mon, 27 Feb 2023 21:57:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677535064;
        bh=gOZxyiOZX3SaWmtE+RUusjiqzefuBVgJYXvGUSQ2Lmw=;
        h=From:To:Cc:Subject:Date:From;
        b=FUl4t9WDiSoA+bEuZroFpAzC/RCae6GMAKh5A9zHdpgv9+J4sCxErsg/ds06xIKP3
         TFVooIlRIsT7FheyG13mWmWzZemCg532D9zS6+XmRD4lySvc7WyEsfvaFi8JRJIg0B
         BFwMKXwC+VNThoHY7IA7/Zr/Z20JZszIqKTyJc+yGtLn2HHT3cd5OQQMiDRSfDlz4P
         SKVyn+hOU0GwajMHQAmwk+jf+BVJDqcZHcbT81xiDa3XuVEx9JnSaRnCABz0A3Uya0
         higONvgmPx7IUlCfI0Ksth19j7WmMHMeHz19sj0dNiX6hXOJPOIDm0wJydJkNVBxUD
         tsSxd5ZHYLe3Q==
From:   Jakub Kicinski <kuba@kernel.org>
To:     torvalds@linux-foundation.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, pabeni@redhat.com
Subject: [PULL] Networking for v6.3-rc1
Date:   Mon, 27 Feb 2023 13:57:43 -0800
Message-Id: <20230227215743.747911-1-kuba@kernel.org>
X-Mailer: git-send-email 2.39.1
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

The notable fixes here are the EEE fix which restores boot for
many embedded platforms (real and QEMU); WiFi warning suppression
and the ICE Kconfig cleanup.

The following changes since commit 5b7c4cabbb65f5c469464da6c5f614cbd7f730f2:

  Merge tag 'net-next-6.3' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next (2023-02-21 18:24:12 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-6.3-rc1

for you to fetch changes up to 580f98cc33a260bb8c6a39ae2921b29586b84fdf:

  tcp: tcp_check_req() can be called from process context (2023-02-27 11:59:29 -0800)

----------------------------------------------------------------
Including fixes from wireless and netfilter.

Current release - regressions:

 - phy: multiple fixes for EEE rework

 - wifi: wext: warn about usage only once

 - wifi: ath11k: allow system suspend to survive ath11k

Current release - new code bugs:

 - mlx5: Fix memory leak in IPsec RoCE creation

 - ibmvnic: assign XPS map to correct queue index

Previous releases - regressions:

 - netfilter: ip6t_rpfilter: Fix regression with VRF interfaces

 - netfilter: ctnetlink: make event listener tracking global

 - nf_tables: allow to fetch set elements when table has an owner

 - mlx5:
   - fix skb leak while fifo resync and push
   - fix possible ptp queue fifo use-after-free

Previous releases - always broken:

 - sched: fix action bind logic

 - ptp: vclock: use mutex to fix "sleep on atomic" bug if driver
   also uses a mutex

 - netfilter: conntrack: fix rmmod double-free race

 - netfilter: xt_length: use skb len to match in length_mt6,
   avoid issues with BIG TCP

Misc:

 - ice: remove unnecessary CONFIG_ICE_GNSS

 - mlx5e: remove hairpin write debugfs files

 - sched: act_api: move TCA_EXT_WARN_MSG to the correct hierarchy

Signed-off-by: Jakub Kicinski <kuba@kernel.org>

----------------------------------------------------------------
David S. Miller (3):
      Merge tag 'mlx5-fixes-2023-02-24' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux
      Merge branch 'net-sched-action-bind'
      Merge branch 'net-ocelot-switch-regressions'

Deepak R Varma (1):
      octeontx2-pf: Use correct struct reference in test condition

Eric Dumazet (2):
      net: fix __dev_kfree_skb_any() vs drop monitor
      tcp: tcp_check_req() can be called from process context

Fedor Pchelkin (1):
      nfc: fix memory leak of se_io context in nfc_genl_se_io

Florian Westphal (3):
      netfilter: conntrack: fix rmmod double-free race
      netfilter: ebtables: fix table blob use-after-free
      netfilter: ctnetlink: make event listener tracking global

Gal Pressman (1):
      net/mlx5e: Remove hairpin write debugfs files

Geetha sowjanya (1):
      octeontx2-pf: Recalculate UDP checksum for ptp 1-step sync packet

Hangyu Hua (1):
      netfilter: ctnetlink: fix possible refcount leak in ctnetlink_create_conntrack()

Jacob Keller (1):
      ice: remove unnecessary CONFIG_ICE_GNSS

Jakub Kicinski (6):
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf
      tools: ynl-gen: fix single attribute structs with attr 0 only
      tools: ynl-gen: re-raise the exception instead of printing
      tools: net: add __pycache__ to gitignore
      Merge branch 'tools-ynl-gen-fix-glitches-found-by-chuck'
      Merge tag 'wireless-2023-02-27' of git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless

Johannes Berg (1):
      wifi: wext: warn about usage only once

Len Brown (1):
      wifi: ath11k: allow system suspend to survive ath11k

Lorenzo Bianconi (1):
      wifi: mt76: usb: fix use-after-free in mt76u_free_rx_queue

Lu Wei (2):
      ipv6: Add lwtunnel encap size of all siblings in nexthop calculation
      selftests: fib_tests: Add test cases for IPv4/IPv6 in route notify

Maher Sanalla (1):
      net/mlx5: ECPF, wait for VF pages only after disabling host PFs

Maor Dickman (1):
      net/mlx5: Geneve, Fix handling of Geneve object id as error code

Michal Schmidt (1):
      qede: avoid uninitialized entries in coal_entry array

Nathan Chancellor (1):
      net/sched: cls_api: Move call to tcf_exts_miss_cookie_base_destroy()

Nick Child (1):
      ibmvnic: Assign XPS map to correct queue index

Oleksij Rempel (5):
      net: phy: c45: use "supported_eee" instead of supported for access validation
      net: phy: c45: add genphy_c45_an_config_eee_aneg() function
      net: phy: do not force EEE support
      net: phy: c45: genphy_c45_ethtool_set_eee: validate EEE link modes
      net: phy: c45: fix network interface initialization failures on xtensa, arm:cubieboard

Pablo Neira Ayuso (1):
      netfilter: nf_tables: allow to fetch set elements when table has an owner

Paolo Abeni (1):
      Merge branch 'net-phy-eee-fixes'

Patrisious Haddad (1):
      net/mlx5: Fix memory leak in IPsec RoCE creation

Pavel Tikhomirov (1):
      netfilter: x_tables: fix percpu counter block leak on error path when creating new netns

Pedro Tammela (4):
      net/sched: act_pedit: fix action bind logic
      net/sched: act_mpls: fix action bind logic
      net/sched: act_sample: fix action bind logic
      net/sched: act_api: move TCA_EXT_WARN_MSG to the correct hierarchy

Phil Sutter (1):
      netfilter: ip6t_rpfilter: Fix regression with VRF interfaces

Roi Dayan (1):
      net/mlx5e: Verify flow_source cap before using it

Russell King (Oracle) (1):
      net: dsa: ocelot_ext: remove unnecessary phylink.h include

Sean Anderson (1):
      net: sunhme: Fix region request

Tariq Toukan (1):
      netdev-genl: fix repeated typo oflloading -> offloading

Tom Rix (1):
      xen-netback: remove unused variables pending_idx and index

Vadim Fedorenko (2):
      mlx5: fix skb leak while fifo resync and push
      mlx5: fix possible ptp queue fifo use-after-free

Vladimir Oltean (3):
      net: dsa: seville: ignore mscc-miim read errors from Lynx PCS
      net: dsa: felix: fix internal MDIO controller resource length
      net: mscc: ocelot: fix duplicate driver name error

Xin Long (2):
      netfilter: xt_length: use skb len to match in length_mt6
      sctp: add a refcnt in sctp_stream_priorities to avoid a nested loop

Yang Li (1):
      net/mlx5: Remove NULL check before dev_{put, hold}

Yang Yingliang (1):
      net/mlx5e: TC, fix return value check in mlx5e_tc_act_stats_create()

nick black (1):
      docs: net: fix inaccuracies in msg_zerocopy.rst

Íñigo Huguet (1):
      ptp: vclock: use mutex to fix "sleep on atomic" bug

 Documentation/netlink/specs/netdev.yaml            |  2 +-
 Documentation/networking/msg_zerocopy.rst          |  6 +-
 drivers/mfd/ocelot-core.c                          |  2 +-
 drivers/net/dsa/ocelot/felix_vsc9959.c             |  2 +-
 drivers/net/dsa/ocelot/ocelot_ext.c                |  3 +-
 drivers/net/dsa/ocelot/seville_vsc9953.c           |  4 +-
 drivers/net/ethernet/ibm/ibmvnic.c                 |  4 +-
 drivers/net/ethernet/intel/Kconfig                 |  4 +-
 drivers/net/ethernet/intel/ice/Makefile            |  2 +-
 drivers/net/ethernet/intel/ice/ice_gnss.h          |  4 +-
 .../ethernet/marvell/octeontx2/nic/otx2_flows.c    |  2 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_txrx.c | 76 ++++++++++++-----
 drivers/net/ethernet/mellanox/mlx5/core/ecpf.c     |  4 +
 drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c   | 25 +++++-
 .../net/ethernet/mellanox/mlx5/core/en/rep/tc.c    |  3 +-
 .../ethernet/mellanox/mlx5/core/en/tc/act_stats.c  |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h  |  4 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c |  1 +
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.h |  1 +
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    | 59 -------------
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |  3 +-
 .../net/ethernet/mellanox/mlx5/core/lib/geneve.c   |  1 +
 .../mellanox/mlx5/core/lib/ipsec_fs_roce.c         | 13 +--
 drivers/net/ethernet/mellanox/mlx5/core/sriov.c    |  4 +
 drivers/net/ethernet/qlogic/qede/qede_main.c       | 21 ++---
 drivers/net/ethernet/sun/sunhme.c                  |  6 +-
 drivers/net/mdio/mdio-mscc-miim.c                  |  9 +-
 drivers/net/phy/phy-c45.c                          | 56 ++++++++++---
 drivers/net/phy/phy_device.c                       | 21 ++++-
 drivers/net/wireless/ath/ath11k/pci.c              |  2 +-
 drivers/net/wireless/mediatek/mt76/usb.c           |  1 +
 drivers/net/xen-netback/netback.c                  |  5 --
 drivers/nfc/st-nci/se.c                            |  6 ++
 drivers/nfc/st21nfca/se.c                          |  6 ++
 drivers/ptp/ptp_private.h                          |  2 +-
 drivers/ptp/ptp_vclock.c                           | 44 +++++-----
 include/linux/mdio/mdio-mscc-miim.h                |  2 +-
 include/linux/netfilter.h                          |  5 ++
 include/linux/phy.h                                |  6 ++
 include/net/netns/conntrack.h                      |  1 -
 include/net/sctp/structs.h                         |  1 +
 include/uapi/linux/netdev.h                        |  2 +-
 net/bridge/netfilter/ebtables.c                    |  2 +-
 net/core/dev.c                                     |  4 +-
 net/ipv4/netfilter/arp_tables.c                    |  4 +
 net/ipv4/netfilter/ip_tables.c                     |  7 +-
 net/ipv4/tcp_minisocks.c                           |  7 +-
 net/ipv6/netfilter/ip6_tables.c                    |  7 +-
 net/ipv6/netfilter/ip6t_rpfilter.c                 |  4 +-
 net/ipv6/route.c                                   | 11 +--
 net/netfilter/core.c                               |  3 +
 net/netfilter/nf_conntrack_bpf.c                   |  1 -
 net/netfilter/nf_conntrack_core.c                  | 25 +++---
 net/netfilter/nf_conntrack_ecache.c                |  2 +-
 net/netfilter/nf_conntrack_netlink.c               |  8 +-
 net/netfilter/nf_tables_api.c                      |  2 +-
 net/netfilter/nfnetlink.c                          |  9 +-
 net/netfilter/xt_length.c                          |  3 +-
 net/nfc/netlink.c                                  |  4 +
 net/sched/act_api.c                                |  4 +-
 net/sched/act_mpls.c                               | 66 ++++++++-------
 net/sched/act_pedit.c                              | 58 +++++++------
 net/sched/act_sample.c                             | 11 ++-
 net/sched/cls_api.c                                |  2 +-
 net/sctp/stream_sched_prio.c                       | 52 +++++-------
 net/wireless/wext-core.c                           |  4 +-
 tools/include/uapi/linux/netdev.h                  |  2 +-
 tools/net/ynl/lib/.gitignore                       |  1 +
 tools/net/ynl/lib/nlspec.py                        |  4 +-
 tools/net/ynl/ynl-gen-c.py                         |  2 +-
 tools/testing/selftests/net/fib_tests.sh           | 96 +++++++++++++++++++++-
 tools/testing/selftests/netfilter/rpath.sh         | 32 ++++++--
 72 files changed, 546 insertions(+), 318 deletions(-)
 create mode 100644 tools/net/ynl/lib/.gitignore
