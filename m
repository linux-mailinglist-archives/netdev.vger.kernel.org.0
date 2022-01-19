Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 910D2493FD7
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 19:26:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356718AbiASS0O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 13:26:14 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:43120 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348214AbiASS0N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 13:26:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7AA1A6168C;
        Wed, 19 Jan 2022 18:26:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB883C004E1;
        Wed, 19 Jan 2022 18:26:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642616772;
        bh=NvrT/dDc0DcnZFzBs+zt/ziG8OWPA3G0GZg/SpUIVQ8=;
        h=From:To:Cc:Subject:Date:From;
        b=vBVCdG9CRXbFnVixDAfVx6KrBHtcdZ0qiMrAB/b+UlBrxKEzEenv2cLIZvODfKYCB
         wRtHAIVJvPmFOXXOSGKy1EAZ++ZKIOqs83MC6x1s2HREbqWaK86eoM3UjUKbiCQArY
         AeD63PnhwWmnBDbmvA1L/AWYF/73ejY4uXH3JHbSiiJqyBSNOHcaxXTmwlSk0QM0GW
         HwbhvuU4lg/b3X+uX+2hZLn/whUTzm9x1p1pWxSBlcQhbTKb2KWGuI95r3KTkthY3C
         GKtGBLOCx/Px+hatMDoCluDhHiLcrzH2WmyEC4xk6fa/yYid6TnWAwdGM9T6x1fEAq
         qy7DXZRGaNtNw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     torvalds@linux-foundation.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Networking for 5.17-rc1
Date:   Wed, 19 Jan 2022 10:26:11 -0800
Message-Id: <20220119182611.400333-1-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Linus!

Quite a handful of old regression fixes but of those all are pre-5.16.

The following changes since commit fe8152b38d3a994c4c6fdbc0cd6551d569a5715a:

  Merge tag 'devprop-5.17-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm (2022-01-10 20:48:19 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.17-rc1

for you to fetch changes up to ff9fc0a31d85fcf0011eb4bc4ecaf47d3cc9e21c:

  Merge branch 'ipv4-avoid-pathological-hash-tables' (2022-01-19 08:14:43 -0800)

----------------------------------------------------------------
Networking fixes for 5.17-rc1, including fixes from netfilter, bpf.

Current release - regressions:

 - fix memory leaks in the skb free deferral scheme if upper layer
   protocols are used, i.e. in-kernel TCP readers like TLS

Current release - new code bugs:

 - nf_tables: fix NULL check typo in _clone() functions

 - change the default to y for Vertexcom vendor Kconfig

 - a couple of fixes to incorrect uses of ref tracking

 - two fixes for constifying netdev->dev_addr

Previous releases - regressions:

 - bpf:
   - various verifier fixes mainly around register offset handling
     when passed to helper functions
   - fix mount source displayed for bpffs (none -> bpffs)

 - bonding:
   - fix extraction of ports for connection hash calculation
   - fix bond_xmit_broadcast return value when some devices are down

 - phy: marvell: add Marvell specific PHY loopback

 - sch_api: don't skip qdisc attach on ingress, prevent ref leak

 - htb: restore minimal packet size handling in rate control

 - sfp: fix high power modules without diagnostic monitoring

 - mscc: ocelot:
   - don't let phylink re-enable TX PAUSE on the NPI port
   - don't dereference NULL pointers with shared tc filters

 - smsc95xx: correct reset handling for LAN9514

 - cpsw: avoid alignment faults by taking NET_IP_ALIGN into account

 - phy: micrel: use kszphy_suspend/_resume for irq aware devices,
   avoid races with the interrupt

Previous releases - always broken:

 - xdp: check prog type before updating BPF link

 - smc: resolve various races around abnormal connection termination

 - sit: allow encapsulated IPv6 traffic to be delivered locally

 - axienet: fix init/reset handling, add missing barriers,
   read the right status words, stop queues correctly

 - add missing dev_put() in sock_timestamping_bind_phc()

Misc:

 - ipv4: prevent accidentally passing RTO_ONLINK to
   ip_route_output_key_hash() by sanitizing flags

 - ipv4: avoid quadratic behavior in netns dismantle

 - stmmac: dwmac-oxnas: add support for OX810SE

 - fsl: xgmac_mdio: add workaround for erratum A-009885

Signed-off-by: Jakub Kicinski <kuba@kernel.org>

----------------------------------------------------------------
Alex Elder (3):
      net: ipa: fix atomic update in ipa_endpoint_replenish()
      net: ipa: use a bitmap for endpoint replenish_enabled
      net: ipa: prevent concurrent replenish

Ard Biesheuvel (1):
      net: cpsw: avoid alignment faults by taking NET_IP_ALIGN into account

Christophe JAILLET (1):
      net: ethernet: sun4i-emac: Fix an error handling path in emac_probe()

Christy Lee (1):
      bpf: Fix incorrect integer literal used for marking scratched stack.

Claudiu Beznea (1):
      net: phy: micrel: use kszphy_suspend()/kszphy_resume for irq aware devices

Colin Ian King (3):
      nfc: pn544: make array rset_cmd static const
      net: phy: at803x: make array offsets static
      atm: iphase: remove redundant pointer skb

Conley Lee (1):
      net: ethernet: sun4i-emac: replace magic number with macro

Daniel Borkmann (7):
      bpf: Generalize check_ctx_reg for reuse with other types
      bpf: Mark PTR_TO_FUNC register initially with zero offset
      bpf: Generally fix helper register offset check
      bpf: Fix out of bounds access for ringbuf helpers
      bpf: Fix ringbuf memory type confusion when passing to helpers
      bpf, selftests: Add various ringbuf tests with invalid offset
      bpf, selftests: Add ringbuf memory type confusion test

David S. Miller (4):
      Merge branch 'ipa-fixes'
      Merge branch 'smc-race-fixes'
      Merge branch 'skb-leak-fixes'
      Merge branch 'axienet-fixes'

Eric Dumazet (10):
      net: sched: do not allocate a tracker in tcf_exts_init()
      ref_tracker: use __GFP_NOFAIL more carefully
      net: bridge: fix net device refcount tracking issue in error path
      net/smc: fix possible NULL deref in smc_pnet_add_eth()
      inet: frags: annotate races around fqdir->dead and fqdir->high_thresh
      af_unix: annote lockless accesses to unix_tot_inflight & gc_in_progress
      ipv4: update fib_info_cnt under spinlock protection
      netns: add schedule point in ops_exit_list()
      ipv4: avoid quadratic behavior in netns dismantle
      ipv4: add net_hash_mix() dispersion to fib_info_laddrhash keys

Gal Pressman (2):
      net/tls: Fix another skb memory leak when running kTLS traffic
      net: Flush deferred skb free on socket destroy

Guillaume Nault (4):
      xfrm: Don't accidentally set RTO_ONLINK in decode_session4()
      gre: Don't accidentally set RTO_ONLINK in gre_fill_metadata_dst()
      libcxgb: Don't accidentally set RTO_ONLINK in cxgb_find_route()
      mlx5: Don't accidentally set RTO_ONLINK before mlx5e_route_lookup_ipv4_get()

Horatiu Vultur (1):
      net: ocelot: Fix the call to switchdev_bridge_port_offload

Ignat Korchagin (1):
      sit: allow encapsulated IPv6 traffic to be delivered locally

Jakub Kicinski (5):
      Merge branch 'ipv4-fix-accidental-rto_onlink-flags-passed-to-ip_route_output_key_hash'
      Merge branch 'arm-ox810se-add-ethernet-support'
      Merge https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf
      Merge branch 'net-fsl-xgmac_mdio-add-workaround-for-erratum-a-009885'
      Merge branch 'ipv4-avoid-pathological-hash-tables'

Jie Wang (1):
      net: bonding: fix bond_xmit_broadcast return value error bug

Jordy Zomer (1):
      nfc: st21nfca: Fix potential buffer overflows in EVT_TRANSACTION

Kai-Heng Feng (1):
      net: stmmac: Fix "Unbalanced pm_runtime_enable!" warning

Kevin Bracey (1):
      net_sched: restore "mpu xxx" handling

Krzysztof Kozlowski (1):
      nfc: llcp: fix NULL error pointer dereference on sendmsg() after failed bind()

Kyoungkyu Park (1):
      net: qmi_wwan: Add Hucom Wireless HM-211S/K

Li Zhijian (2):
      kselftests/net: adapt the timeout to the largest runtime
      kselftests/net: list all available tests in usage()

Markus Reichl (1):
      net: usb: Correct reset handling of smsc95xx

Matt Johnston (1):
      mctp: test: zero out sockaddr

Maxim Mikityanskiy (1):
      sch_api: Don't skip qdisc attach on ingress

Miaoqian Lin (1):
      lib82596: Fix IRQ check in sni_82596_probe

Michael Ellerman (2):
      net: apple: mace: Fix build since dev_addr constification
      net: apple: bmac: Fix build since dev_addr constification

Michael Walle (1):
      Revert "of: net: support NVMEM cells with MAC in text format"

Miroslav Lichvar (1):
      net: fix sock_timestamping_bind_phc() to release device

Mohammad Athari Bin Ismail (1):
      net: phy: marvell: add Marvell specific PHY loopback

Moshe Tal (1):
      bonding: Fix extraction of ports from the packet headers

Neil Armstrong (2):
      dt-bindings: net: oxnas-dwmac: Add bindings for OX810SE
      net: stmmac: dwmac-oxnas: Add support for OX810SE

Pablo Neira Ayuso (1):
      netfilter: nf_tables: typo NULL check in _clone() function

Pawel Dembicki (1):
      net: qmi_wwan: add ZTE MF286D modem 19d2:1485

Robert Hancock (9):
      net: axienet: increase reset timeout
      net: axienet: Wait for PhyRstCmplt after core reset
      net: axienet: reset core on initialization prior to MDIO access
      net: axienet: add missing memory barriers
      net: axienet: limit minimum TX ring size
      net: axienet: Fix TX ring slot available check
      net: axienet: fix number of TX ring slots for available check
      net: axienet: fix for TX busy handling
      net: axienet: increase default TX ring size to 128

Russell King (Oracle) (1):
      net: sfp: fix high power modules without diagnostic monitoring

Saeed Mahameed (1):
      Revert "net: vertexcom: default to disabled on kbuild"

Sergey Shtylyov (1):
      bcmgenet: add WOL IRQ check

Slark Xiao (1):
      net: wwan: Fix MRU mismatch issue which may lead to data connection lost

Tobias Waldekranz (4):
      net/fsl: xgmac_mdio: Add workaround for erratum A-009885
      dt-bindings: net: Document fsl,erratum-a009885
      powerpc/fsl/dts: Enable WA for erratum A-009885 on fman3l MDIO buses
      net/fsl: xgmac_mdio: Fix incorrect iounmap when removing module

Toke Høiland-Jørgensen (3):
      xdp: check prog type before updating BPF link
      bpf/selftests: convert xdp_link test to ASSERT_* macros
      bpf/selftests: Add check for updating XDP bpf_link with wrong program type

Tom Rix (2):
      net: ethernet: mtk_eth_soc: fix error checking in mtk_mac_config()
      net: mscc: ocelot: fix using match before it is set

Vladimir Oltean (2):
      net: mscc: ocelot: don't let phylink re-enable TX PAUSE on the NPI port
      net: mscc: ocelot: don't dereference NULL pointers with shared tc filters

Wen Gu (5):
      net/smc: Resolve the race between link group access and termination
      net/smc: Introduce a new conn->lgr validity check helper
      net/smc: Resolve the race between SMC-R link access and clear
      net/smc: Remove unused function declaration
      net/smc: Fix hung_task when removing SMC-R devices

Yafang Shao (1):
      bpf: Fix mount source show for bpffs

Yevhen Orlov (4):
      net: marvell: prestera: Cleanup router struct
      net: marvell: prestera: Refactor get/put VR functions
      net: marvell: prestera: Refactor router functions
      net: marvell: prestera: Fix deinit sequence for router

 Documentation/devicetree/bindings/net/fsl-fman.txt |   9 ++
 .../devicetree/bindings/net/oxnas-dwmac.txt        |   3 +
 arch/powerpc/boot/dts/fsl/qoriq-fman3l-0.dtsi      |   2 +
 drivers/atm/iphase.c                               |   4 +-
 drivers/net/bonding/bond_main.c                    |  34 +++--
 drivers/net/ethernet/allwinner/sun4i-emac.c        |  31 +++--
 drivers/net/ethernet/allwinner/sun4i-emac.h        |  18 +++
 drivers/net/ethernet/apple/bmac.c                  |   5 +-
 drivers/net/ethernet/apple/mace.c                  |  16 ++-
 drivers/net/ethernet/broadcom/genet/bcmgenet.c     |  10 +-
 drivers/net/ethernet/chelsio/libcxgb/libcxgb_cm.c  |   3 +-
 drivers/net/ethernet/freescale/xgmac_mdio.c        |  28 +++--
 drivers/net/ethernet/i825xx/sni_82596.c            |   3 +-
 drivers/net/ethernet/marvell/prestera/prestera.h   |   1 -
 .../net/ethernet/marvell/prestera/prestera_hw.c    |   4 +-
 .../net/ethernet/marvell/prestera/prestera_main.c  |   1 +
 .../ethernet/marvell/prestera/prestera_router.c    |  24 ++--
 .../ethernet/marvell/prestera/prestera_router_hw.c |  40 +++---
 .../ethernet/marvell/prestera/prestera_router_hw.h |   3 +-
 drivers/net/ethernet/mediatek/mtk_eth_soc.c        |   2 +-
 .../net/ethernet/mellanox/mlx5/core/en/tc_tun.c    |   5 +-
 drivers/net/ethernet/mscc/ocelot.c                 |   5 +-
 drivers/net/ethernet/mscc/ocelot_flower.c          |  44 +++++--
 drivers/net/ethernet/mscc/ocelot_net.c             |   6 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac-oxnas.c  | 101 +++++++++++----
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |   3 +-
 drivers/net/ethernet/ti/cpsw.c                     |   6 +-
 drivers/net/ethernet/ti/cpsw_new.c                 |   6 +-
 drivers/net/ethernet/ti/cpsw_priv.c                |   2 +-
 drivers/net/ethernet/vertexcom/Kconfig             |   2 +-
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c  | 135 ++++++++++++--------
 drivers/net/ipa/ipa_endpoint.c                     |  28 +++--
 drivers/net/ipa/ipa_endpoint.h                     |  17 ++-
 drivers/net/phy/at803x.c                           |   2 +-
 drivers/net/phy/marvell.c                          |  56 ++++++++-
 drivers/net/phy/micrel.c                           |  36 +++---
 drivers/net/phy/sfp.c                              |  25 +++-
 drivers/net/usb/qmi_wwan.c                         |   2 +
 drivers/net/usb/smsc95xx.c                         |   3 +-
 drivers/net/wwan/mhi_wwan_mbim.c                   |   4 +-
 drivers/nfc/pn544/i2c.c                            |   2 +-
 drivers/nfc/st21nfca/se.c                          |  10 ++
 include/linux/bpf.h                                |   9 +-
 include/linux/bpf_verifier.h                       |   4 +-
 include/net/inet_frag.h                            |  11 +-
 include/net/ipv6_frag.h                            |   3 +-
 include/net/pkt_cls.h                              |   4 +-
 include/net/sch_generic.h                          |   5 +
 kernel/bpf/btf.c                                   |   2 +-
 kernel/bpf/inode.c                                 |  14 ++-
 kernel/bpf/verifier.c                              |  81 ++++++++----
 lib/ref_tracker.c                                  |   5 +-
 net/bridge/br_if.c                                 |   3 +-
 net/core/dev.c                                     |   6 +
 net/core/net_namespace.c                           |   4 +-
 net/core/of_net.c                                  |  33 ++---
 net/core/sock.c                                    |   5 +
 net/ipv4/fib_semantics.c                           |  76 ++++++------
 net/ipv4/inet_fragment.c                           |   8 +-
 net/ipv4/ip_fragment.c                             |   3 +-
 net/ipv4/ip_gre.c                                  |   5 +-
 net/ipv6/sit.c                                     |   2 +-
 net/mctp/test/route-test.c                         |   2 +-
 net/netfilter/nft_connlimit.c                      |   2 +-
 net/netfilter/nft_last.c                           |   2 +-
 net/netfilter/nft_limit.c                          |   2 +-
 net/netfilter/nft_quota.c                          |   2 +-
 net/nfc/llcp_sock.c                                |   5 +
 net/sched/sch_api.c                                |   2 +-
 net/sched/sch_generic.c                            |   1 +
 net/smc/af_smc.c                                   |   6 +-
 net/smc/smc.h                                      |   1 +
 net/smc/smc_cdc.c                                  |   3 +-
 net/smc/smc_clc.c                                  |   2 +-
 net/smc/smc_core.c                                 | 137 ++++++++++++++-------
 net/smc/smc_core.h                                 |  12 ++
 net/smc/smc_diag.c                                 |   6 +-
 net/smc/smc_pnet.c                                 |   3 +-
 net/smc/smc_wr.h                                   |   4 -
 net/tls/tls_sw.c                                   |   1 +
 net/unix/garbage.c                                 |  14 ++-
 net/unix/scm.c                                     |   6 +-
 net/xfrm/xfrm_policy.c                             |   3 +-
 tools/testing/selftests/bpf/prog_tests/d_path.c    |  14 +++
 tools/testing/selftests/bpf/prog_tests/xdp_link.c  |  61 +++++----
 .../selftests/bpf/progs/test_d_path_check_types.c  |  32 +++++
 tools/testing/selftests/bpf/progs/test_xdp_link.c  |   6 +
 tools/testing/selftests/bpf/verifier/ringbuf.c     |  95 ++++++++++++++
 tools/testing/selftests/bpf/verifier/spill_fill.c  |   2 +-
 tools/testing/selftests/net/fcnal-test.sh          |   3 +
 tools/testing/selftests/net/settings               |   2 +-
 91 files changed, 1041 insertions(+), 414 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/test_d_path_check_types.c
 create mode 100644 tools/testing/selftests/bpf/verifier/ringbuf.c
