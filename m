Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A04E598CF2
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 21:56:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343991AbiHRTzy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 15:55:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242458AbiHRTzx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 15:55:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B02FDCE483;
        Thu, 18 Aug 2022 12:55:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1E4E161331;
        Thu, 18 Aug 2022 19:55:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37268C433C1;
        Thu, 18 Aug 2022 19:55:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660852551;
        bh=BKTyr5zWYmcCfK97rfsJYAKQXm87NWZ+COUu8L2gPKM=;
        h=From:To:Cc:Subject:Date:From;
        b=gMEHT/6e6AAZkVNv/ob1scwGNeg/48SUgU8XTIUk2cTTGtjyZ6qzL+uOksb16BF2l
         ksHlrn8qTtq+iAH/BW69bGdv2jNYEqbc/HER9noB3FNs2EL00DyETM692W/7s8+M1i
         jJIq2XxGa02QNcicfdt42DruLSL+iSuCNOzsqpZ651zz326eOFP5d6VJUEcW4aVF1S
         nT8Kl2S8qG1uxSU7o6gcIwvZRcQT58n49AUQ/HKUdlSnPOXBHqni8ZAYC0wfBBZY11
         37DCRNm5RIvWB8K+ec6tTmQ0t2IFU2sysi7knZdqnKNrE+gm3M8BwJi6hnFf29nUSK
         V0iGt3I9I12KQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     torvalds@linux-foundation.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, pabeni@redhat.com
Subject: [PULL] Networking for 6.0-rc2
Date:   Thu, 18 Aug 2022 12:55:49 -0700
Message-Id: <20220818195549.1805709-1-kuba@kernel.org>
X-Mailer: git-send-email 2.36.1
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

The following changes since commit 7ebfc85e2cd7b08f518b526173e9a33b56b3913b:

  Merge tag 'net-6.0-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2022-08-11 13:45:37 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-6.0-rc2

for you to fetch changes up to f4693b81ea3802d2c28c868e1639e580d0da2d1f:

  net: moxa: MAC address reading, generating, validity checking (2022-08-18 11:08:54 -0700)

----------------------------------------------------------------
Including fixes from netfilter.

Current release - regressions:

 - tcp: fix cleanup and leaks in tcp_read_skb() (the new way BPF
   socket maps get data out of the TCP stack)

 - tls: rx: react to strparser initialization errors

 - netfilter: nf_tables: fix scheduling-while-atomic splat

 - net: fix suspicious RCU usage in bpf_sk_reuseport_detach()

Current release - new code bugs:

 - mlxsw: ptp: fix a couple of races, static checker warnings
   and error handling

Previous releases - regressions:

 - netfilter:
   - nf_tables: fix possible module reference underflow in error path
   - make conntrack helpers deal with BIG TCP (skbs > 64kB)
   - nfnetlink: re-enable conntrack expectation events

 - net: fix potential refcount leak in ndisc_router_discovery()

Previous releases - always broken:

 - sched: cls_route: disallow handle of 0

 - neigh: fix possible local DoS due to net iface start/stop loop

 - rtnetlink: fix module refcount leak in rtnetlink_rcv_msg

 - sched: fix adding qlen to qcpu->backlog in gnet_stats_add_queue_cpu

 - virtio_net: fix endian-ness for RSS

 - dsa: mv88e6060: prevent crash on an unused port

 - fec: fix timer capture timing in `fec_ptp_enable_pps()`

 - ocelot: stats: fix races, integer wrapping and reading incorrect
   registers (the change of register definitions here accounts for
   bulk of the changed LoC in this PR)

Signed-off-by: Jakub Kicinski <kuba@kernel.org>

----------------------------------------------------------------
Alan Brady (1):
      i40e: Fix to stop tx_timeout recovery if GLOBR fails

Alexander Mikhalitsyn (1):
      neighbour: make proxy_queue.qlen limit per-device

Amit Cohen (4):
      mlxsw: spectrum_ptp: Fix compilation warnings
      mlxsw: spectrum: Clear PTP configuration after unregistering the netdevice
      mlxsw: spectrum_ptp: Protect PTP configuration with a mutex
      mlxsw: spectrum_ptp: Forbid PTP enablement only in RX or in TX

Arun Ramadoss (1):
      net: dsa: microchip: ksz9477: fix fdb_dump last invalid entry

Benjamin Mikailenko (2):
      ice: Fix VSI rebuild WARN_ON check for VF
      ice: Ignore error message when setting same promiscuous mode

Christophe JAILLET (1):
      stmmac: intel: Add a missing clk_disable_unprepare() call in intel_eth_pci_remove()

Cong Wang (4):
      tcp: fix sock skb accounting in tcp_read_skb()
      tcp: fix tcp_cleanup_rbuf() for tcp_read_skb()
      tcp: refactor tcp_read_skb() a bit
      tcp: handle pure FIN case correctly

Csókás Bence (1):
      fec: Fix timer capture timing in `fec_ptp_enable_pps()`

David Howells (1):
      net: Fix suspicious RCU usage in bpf_sk_reuseport_detach()

David S. Miller (3):
      Merge branch '100GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net -queue
      Merge branch 'mlxsw-fixes'
      Merge branch '40GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue

Denis V. Lunev (1):
      neigh: fix possible DoS due to net iface start/stop loop

Florian Westphal (8):
      netfilter: nf_ct_sane: remove pseudo skb linearization
      netfilter: nf_ct_h323: cap packet size at 64k
      netfilter: nf_ct_ftp: prefer skb_linearize
      netfilter: nf_ct_irc: cap packet search space to 4k
      netfilter: nf_tables: fix scheduling-while-atomic splat
      netfilter: nfnetlink: re-enable conntrack expectation events
      testing: selftests: nft_flowtable.sh: use random netns names
      testing: selftests: nft_flowtable.sh: rework test to detect offload failure

Geert Uytterhoeven (2):
      netfilter: conntrack: NF_CONNTRACK_PROCFS should no longer default to y
      dt-bindings: Fix incorrect "the the" corrections

Grzegorz Siwik (3):
      ice: Fix double VLAN error when entering promisc mode
      ice: Ignore EEXIST when setting promisc mode
      ice: Fix clearing of promisc mode with bridge over bond

Hongbin Wang (1):
      ip6_tunnel: Fix the type of functions

Ivan Vecera (1):
      iavf: Fix deadlock in initialization

Jakub Kicinski (7):
      Merge branch '40GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue
      tls: rx: react to strparser initialization errors
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf
      Merge branch 'fixes-for-ocelot-driver-statistics'
      net: genl: fix error path memory leak in policy dumping
      Merge branch '100GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue
      Merge branch 'tcp-some-bug-fixes-for-tcp_read_skb'

Jamal Hadi Salim (1):
      net_sched: cls_route: disallow handle of 0

Jason Wang (3):
      net: ipa: Fix comment typo
      bnx2x: Fix comment typo
      net: cxgb3: Fix comment typo

Jilin Yuan (1):
      skfp/h: fix repeated words in comments

Leon Romanovsky (1):
      net/mlx5e: Allocate flow steering storage during uplink initialization

Li Qiong (1):
      net: lan966x: fix checking for return value of platform_get_irq_byname()

Lin Ma (1):
      igb: Add lock to avoid data race

Lorenzo Bianconi (1):
      net: ethernet: mtk_eth_soc: fix possible NULL pointer dereference in mtk_xdp_run

Maxim Kochetkov (1):
      net: qrtr: start MHI channel after endpoit creation

Michael S. Tsirkin (1):
      virtio_net: fix endian-ness for RSS

Michal Jaron (1):
      ice: Fix call trace with null VSI during VF reset

Mikulas Patocka (1):
      rds: add missing barrier to release_refill

Pablo Neira Ayuso (8):
      netfilter: nf_tables: use READ_ONCE and WRITE_ONCE for shared generation id access
      netfilter: nf_tables: disallow NFTA_SET_ELEM_KEY_END with NFT_SET_ELEM_INTERVAL_END flag
      netfilter: nf_tables: possible module reference underflow in error path
      netfilter: nf_tables: really skip inactive sets when allocating name
      netfilter: nf_tables: validate NFTA_SET_ELEM_OBJREF based on NFT_SET_OBJECT flag
      netfilter: nf_tables: NFTA_SET_ELEM_KEY_END requires concat and interval flags
      netfilter: nf_tables: disallow NFT_SET_ELEM_CATCHALL and NFT_SET_ELEM_INTERVAL_END
      netfilter: nf_tables: check NFT_SET_CONCAT flag if field_count is specified

Przemyslaw Patynowski (4):
      iavf: Fix adminq error handling
      iavf: Fix NULL pointer dereference in iavf_get_link_ksettings
      iavf: Fix reset error handling
      i40e: Fix tunnel checksum offload with fragmented traffic

Rustam Subkhankulov (1):
      net: dsa: sja1105: fix buffer overflow in sja1105_setup_devlink_regions()

Sergei Antonov (3):
      net: dsa: mv88e6060: prevent crash on an unused port
      net: moxa: pass pdev instead of ndev to DMA functions
      net: moxa: MAC address reading, generating, validity checking

Sylwester Dziedziuch (1):
      ice: Fix VF not able to send tagged traffic with no VLAN filters

Vladimir Oltean (9):
      net: dsa: don't warn in dsa_port_set_state_now() when driver doesn't support it
      net: dsa: felix: fix ethtool 256-511 and 512-1023 TX packet counters
      net: mscc: ocelot: fix incorrect ndo_get_stats64 packet counters
      net: mscc: ocelot: fix address of SYS_COUNT_TX_AGING counter
      net: mscc: ocelot: turn stats_lock into a spinlock
      net: mscc: ocelot: fix race between ndo_get_stats64 and ocelot_check_stats_work
      net: mscc: ocelot: make struct ocelot_stat_layout array indexable
      net: mscc: ocelot: keep ocelot_stat_layout by reg address, not offset
      net: mscc: ocelot: report ndo_get_stats64 from the wraparound-resistant ocelot->stats

Xin Xiong (2):
      net/sunrpc: fix potential memory leaks in rpc_sysfs_xprt_state_change()
      net: fix potential refcount leak in ndisc_router_discovery()

Zhengchao Shao (2):
      net: rtnetlink: fix module reference count leak issue in rtnetlink_rcv_msg
      net: sched: fix misuse of qcpu->backlog in gnet_stats_add_queue_cpu

 .../devicetree/bindings/net/qcom-emac.txt          |   2 +-
 .../devicetree/bindings/thermal/rcar-thermal.yaml  |   2 +-
 drivers/net/dsa/microchip/ksz9477.c                |   3 +
 drivers/net/dsa/mv88e6060.c                        |   3 +
 drivers/net/dsa/ocelot/felix_vsc9959.c             | 558 +++++++++++++++++----
 drivers/net/dsa/ocelot/seville_vsc9953.c           | 553 ++++++++++++++++----
 drivers/net/dsa/sja1105/sja1105_devlink.c          |   2 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c   |   2 +-
 drivers/net/ethernet/chelsio/cxgb3/cxgb3_offload.c |   2 +-
 drivers/net/ethernet/freescale/fec_ptp.c           |   6 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c        |   4 +-
 drivers/net/ethernet/intel/i40e/i40e_txrx.c        |   8 +-
 drivers/net/ethernet/intel/iavf/iavf_adminq.c      |  15 +-
 drivers/net/ethernet/intel/iavf/iavf_main.c        |  22 +-
 drivers/net/ethernet/intel/ice/ice_fltr.c          |   8 +-
 drivers/net/ethernet/intel/ice/ice_lib.c           |   8 +-
 drivers/net/ethernet/intel/ice/ice_main.c          |  12 +-
 drivers/net/ethernet/intel/ice/ice_switch.c        |   9 +-
 drivers/net/ethernet/intel/ice/ice_vf_lib.c        |  15 +-
 drivers/net/ethernet/intel/ice/ice_virtchnl.c      |  57 ++-
 drivers/net/ethernet/intel/igb/igb.h               |   2 +
 drivers/net/ethernet/intel/igb/igb_main.c          |  12 +-
 drivers/net/ethernet/mediatek/mtk_eth_soc.c        |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |  25 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c     |   2 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c |  30 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.h |  18 +-
 .../net/ethernet/microchip/lan966x/lan966x_main.c  |   8 +-
 drivers/net/ethernet/moxa/moxart_ether.c           |  33 +-
 drivers/net/ethernet/mscc/ocelot.c                 |  62 ++-
 drivers/net/ethernet/mscc/ocelot_net.c             |  55 +-
 drivers/net/ethernet/mscc/ocelot_vsc7514.c         | 468 +++++++++++++----
 drivers/net/ethernet/mscc/vsc7514_regs.c           |  84 +++-
 drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c  |   1 +
 drivers/net/fddi/skfp/h/hwmtm.h                    |   2 +-
 drivers/net/ipa/ipa_reg.h                          |   2 +-
 drivers/net/virtio_net.c                           |   4 +-
 include/net/neighbour.h                            |   1 +
 include/net/netns/conntrack.h                      |   2 +-
 include/net/sock.h                                 |  25 +
 include/soc/mscc/ocelot.h                          | 179 ++++++-
 kernel/bpf/reuseport_array.c                       |   2 +-
 net/core/gen_stats.c                               |   2 +-
 net/core/neighbour.c                               |  46 +-
 net/core/rtnetlink.c                               |   1 +
 net/core/skmsg.c                                   |   5 +-
 net/dsa/port.c                                     |   7 +-
 net/ipv4/tcp.c                                     |  49 +-
 net/ipv6/ip6_tunnel.c                              |  19 +-
 net/ipv6/ndisc.c                                   |   3 +
 net/netfilter/Kconfig                              |   1 -
 net/netfilter/nf_conntrack_ftp.c                   |  24 +-
 net/netfilter/nf_conntrack_h323_main.c             |  10 +-
 net/netfilter/nf_conntrack_irc.c                   |  12 +-
 net/netfilter/nf_conntrack_sane.c                  |  68 ++-
 net/netfilter/nf_tables_api.c                      |  74 ++-
 net/netfilter/nfnetlink.c                          |  83 ++-
 net/netlink/genetlink.c                            |   6 +-
 net/netlink/policy.c                               |  14 +-
 net/qrtr/mhi.c                                     |  12 +-
 net/rds/ib_recv.c                                  |   1 +
 net/sched/cls_route.c                              |  10 +
 net/sunrpc/sysfs.c                                 |   6 +-
 net/tls/tls_sw.c                                   |   4 +-
 tools/testing/selftests/netfilter/nft_flowtable.sh | 377 +++++++-------
 65 files changed, 2351 insertions(+), 793 deletions(-)
