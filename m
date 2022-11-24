Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC9A76377A5
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 12:27:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbiKXL1y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 06:27:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229828AbiKXL1w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 06:27:52 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C965E442DF
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 03:26:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669289211;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=tOWySo7YpCxM1dfzDDGXvYrUPYRxYSR+RCXAb7/uyiU=;
        b=QTajVq0D52IHaGSGB8ymaQiJZa3b6npiMrx8MgQED1nx/6qtm/whXXWjvU830U2/7OhvQb
        fagf1PeIgjU5V75SuRNb/2i4Pw5Lu0Yt7HM5/e6khGmV2qWK1FRSZqZxohStLYwsag5Km6
        zcDA2SaD6GOjhQHLGnTt1qzuQGv9OgY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-591-C4qts9L4PSiv2a-c_BGPPQ-1; Thu, 24 Nov 2022 06:26:49 -0500
X-MC-Unique: C4qts9L4PSiv2a-c_BGPPQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 38316801585;
        Thu, 24 Nov 2022 11:26:49 +0000 (UTC)
Received: from gerbillo.redhat.com (unknown [10.39.192.248])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 156AA40C2064;
        Thu, 24 Nov 2022 11:26:47 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Networking for 6.1-rc7
Date:   Thu, 24 Nov 2022 12:25:57 +0100
Message-Id: <20221124112557.17960-1-pabeni@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Linus!

Mostly driver fixes with a relevant exception: the DCCP/TCP bind
fix, which covers a quite uncommon case.

We just received the notice for a route/netlink regression in 6.1,
currently under investigation.

Happy thanksgiving ;)

The following changes since commit 847ccab8fdcf4a0cd85a278480fab1ccdc9f6136:

  Merge tag 'net-6.1-rc6' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2022-11-17 08:58:36 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-6.1-rc7

for you to fetch changes up to 661e5ebbafd26d9d2e3c749f5cf591e55c7364f5:

  net: thunderx: Fix the ACPI memory leak (2022-11-24 10:15:47 +0100)

----------------------------------------------------------------
Networking fixes for 6.1-rc7, including fixes from rxrpc, netfilter and
xfrm

Current release - regressions:

 - dccp/tcp: fix bhash2 issues related to WARN_ON() in inet_csk_get_port().

 - l2tp: don't sleep and disable BH under writer-side sk_callback_lock

 - eth: ice: fix handling of burst tx timestamps

Current release - new code bugs:

 - xfrm: squelch kernel warning in case XFRM encap type is not available

 - eth: mlx5e: fix possible race condition in macsec extended packet number update routine

Previous releases - regressions:

 - neigh: decrement the family specific qlen

 - netfilter: fix ipset regression

 - rxrpc: fix race between conn bundle lookup and bundle removal [ZDI-CAN-15975]

 - eth: iavf: do not restart tx queues after reset task failure

 - eth: nfp: add port from netdev validation for EEPROM access

 - eth: mtk_eth_soc: fix potential memory leak in mtk_rx_alloc()

Previous releases - always broken:

 - tipc: set con sock in tipc_conn_alloc

 - nfc:
   - fix potential memory leaks
   - fix incorrect sizing calculations in EVT_TRANSACTION

 - eth: octeontx2-af: fix pci device refcount leak

 - eth: bonding: fix ICMPv6 header handling when receiving IPv6 messages

 - eth: prestera: add missing unregister_netdev() in prestera_port_create()

 - eth: tsnep: fix rotten packets

Misc:

 - usb: qmi_wwan: add support for LARA-L6.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>

----------------------------------------------------------------
Chen Zhongjin (1):
      xfrm: Fix ignored return value in xfrm6_init()

Chris Mi (1):
      net/mlx5e: Offload rule only when all encaps are valid

Christian Langrock (1):
      xfrm: replay: Fix ESN wrap around for GSO

Dan Carpenter (1):
      octeontx2-af: cn10k: mcs: Fix copy and paste bug in mcs_bbe_intr_handler()

Daniel Díaz (1):
      selftests/net: Find nettest in current directory

Daniel Xu (1):
      netfilter: conntrack: Fix data-races around ct mark

David Howells (1):
      rxrpc: Fix race between conn bundle lookup and bundle removal [ZDI-CAN-15975]

David S. Miller (2):
      Merge branch 'nfc-leaks'
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf

Davide Tronchin (1):
      net: usb: qmi_wwan: add u-blox 0x1342 composition

Diana Wang (1):
      nfp: fill splittable of devlink_port_attrs correctly

Eli Cohen (1):
      net/mlx5: Lag, avoid lockdep warnings

Emeel Hakim (3):
      net/mlx5e: Fix MACsec SA initialization routine
      net/mlx5e: Fix MACsec update SecY
      net/mlx5e: Fix possible race condition in macsec extended packet number update routine

Eyal Birger (2):
      xfrm: fix "disable_policy" on ipv4 early demux
      xfrm: lwtunnel: squelch kernel warning in case XFRM encap type is not available

Felix Fietkau (1):
      netfilter: flowtable_offload: add missing locking

Gerhard Engleder (1):
      tsnep: Fix rotten packets

Hangbin Liu (1):
      bonding: fix ICMPv6 header handling when receiving IPv6 messages

Hanjun Guo (1):
      net: wwan: t7xx: Fix the ACPI memory leak

Herbert Xu (1):
      af_key: Fix send_acquire race with pfkey_register

Hui Tang (1):
      net: mvpp2: fix possible invalid pointer dereference

Ivan Vecera (2):
      iavf: Fix a crash during reset task
      iavf: Do not restart Tx queues after reset task failure

Jaco Coetzee (1):
      nfp: add port from netdev validation for EEPROM access

Jacob Keller (1):
      ice: fix handling of burst Tx timestamps

Jakub Kicinski (10):
      Merge branch 'mptcp-selftests-fix-timeouts-and-test-isolation'
      Merge branch 'nfp-fixes-for-v6-1'
      Merge branch 'tipc-fix-two-race-issues-in-tipc_conn_alloc'
      Merge branch '40GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue
      Merge branch 'dccp-tcp-fix-bhash2-issues-related-to-warn_on-in-inet_csk_get_port'
      Merge branch 'net-ethernet-mtk_eth_soc-fix-memory-leak-in-error-path'
      Merge tag 'mlx5-fixes-2022-11-21' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf
      Merge branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec
      Merge branch 'nfc-st-nci-restructure-validating-logic-in-evt_transaction'

Jakub Sitnicki (1):
      l2tp: Don't sleep and disable BH under writer-side sk_callback_lock

Jiasheng Jiang (1):
      octeontx2-pf: Add check for devm_kcalloc

Jozsef Kadlecsik (1):
      netfilter: ipset: restore allowing 64 clashing elements in hash:net,iface

Kees Cook (1):
      ipv4/fib: Replace zero-length array with DECLARE_FLEX_ARRAY() helper

Kuniyuki Iwashima (4):
      dccp/tcp: Reset saddr on failure after inet6?_hash_connect().
      dccp/tcp: Remove NULL check for prev_saddr in inet_bhash2_update_saddr().
      dccp/tcp: Update saddr under bhash's lock.
      dccp/tcp: Fixup bhash2 bucket when connect() fails.

Leon Romanovsky (1):
      net: liquidio: simplify if expression

Li Zetao (1):
      virtio_net: Fix probe failed when modprobe virtio_net

Lin Ma (1):
      nfc/nci: fix race with opening and closing

Liu Jian (3):
      net: ethernet: mtk_eth_soc: fix error handling in mtk_open()
      net: sparx5: fix error handling in sparx5_port_open()
      net: altera_tse: release phylink resources in tse_shutdown()

Liu Shixin (1):
      NFC: nci: fix memory leak in nci_rx_data_packet()

Lu Wei (1):
      net: microchip: sparx5: Fix return value in sparx5_tc_setup_qdisc_ets()

Mahesh Bandewar (1):
      ipvlan: hold lower dev to avoid possible use-after-free

Martin Faltesek (3):
      nfc: st-nci: fix incorrect validating logic in EVT_TRANSACTION
      nfc: st-nci: fix memory leaks in EVT_TRANSACTION
      nfc: st-nci: fix incorrect sizing calculations in EVT_TRANSACTION

Matthieu Baerts (2):
      selftests: mptcp: run mptcp_sockopt from a new netns
      selftests: mptcp: fix mibit vs mbit mix up

Moshe Shemesh (4):
      net/mlx5: Fix FW tracer timestamp calculation
      net/mlx5: cmdif, Print info on any firmware cmd failure to tracepoint
      net/mlx5: Fix handling of entry refcount when command is not issued to FW
      net/mlx5: Fix sync reset event handler error flow

Nir Levy (1):
      Documentation: networking: Update generic_netlink_howto URL

Pablo Neira Ayuso (1):
      netfilter: nf_tables: do not set up extensions for end interval

Paolo Abeni (1):
      selftests: mptcp: gives slow test-case more time

Peter Kosyh (1):
      net/mlx4: Check retval of mlx4_bitmap_init

Roi Dayan (1):
      net/mlx5: E-Switch, Set correctly vport destination

Roy Novich (1):
      net/mlx5: Do not query pci info while pci disabled

Santiago Ruano Rincón (1):
      net/cdc_ncm: Fix multicast RX support for CDC NCM devices with ZLP

Shang XiaoJing (3):
      nfc: nfcmrvl: Fix potential memory leak in nfcmrvl_i2c_nci_send()
      nfc: nxp-nci: Fix potential memory leak in nxp_nci_send()
      nfc: s3fwrn5: Fix potential memory leak in s3fwrn5_nci_send()

Shay Drory (1):
      net/mlx5: SF: Fix probing active SFs during driver probe phase

Slawomir Laba (1):
      iavf: Fix race condition between iavf_shutdown and iavf_remove

Stefan Assmann (1):
      iavf: remove INITIAL_MAC_SET to allow gARP to work properly

Tariq Toukan (2):
      net/mlx5e: Fix missing alignment in size of MTT/KLM entries
      net/mlx5e: Remove leftovers from old XSK queues enumeration

Thomas Jarosch (1):
      xfrm: Fix oops in __xfrm_state_delete()

Thomas Zeitlhofer (1):
      net: neigh: decrement the family specific qlen

Vishwanath Pai (1):
      netfilter: ipset: regression in ip_set_hash_ip.c

Vladimir Oltean (2):
      net: dsa: sja1105: disallow C45 transactions on the BASE-TX MDIO bus
      net: enetc: preserve TX ring priority across reconfiguration

Wang Hai (2):
      net: pch_gbe: fix potential memleak in pch_gbe_tx_queue()
      arcnet: fix potential memory leak in com20020_probe()

Wang ShaoBo (1):
      net: wwan: iosm: use ACPI_FREE() but not kfree() in ipc_pcie_read_bios_cfg()

Wang Yufen (1):
      selftests/net: fix missing xdp_dummy

Wei Yongjun (1):
      net: phy: at803x: fix error return code in at803x_probe()

Xin Long (3):
      tipc: set con sock in tipc_conn_alloc
      tipc: add an extra conn_get in tipc_conn_alloc
      net: sched: allow act_ct to be built without NF_NAT

Xiongfeng Wang (1):
      octeontx2-af: Fix reference count issue in rvu_sdp_init()

Yan Cangang (2):
      net: ethernet: mtk_eth_soc: fix resource leak in error path
      net: ethernet: mtk_eth_soc: fix memory leak in error path

Yang Yingliang (3):
      octeontx2-af: debugsfs: fix pci device refcount leak
      net: pch_gbe: fix pci device refcount leak while module exiting
      bnx2x: fix pci device refcount leak in bnx2x_vf_is_pcie_pending()

Yu Liao (1):
      net: thunderx: Fix the ACPI memory leak

Yuan Can (1):
      net: dm9051: Fix missing dev_kfree_skb() in dm9051_loop_rx()

YueHaibing (2):
      macsec: Fix invalid error code set
      tipc: check skb_linearize() return value in tipc_disc_rcv()

Zhang Changzhong (3):
      net/qla3xxx: fix potential memleak in ql3xxx_send()
      sfc: fix potential memleak in __ef100_hard_start_xmit()
      net: marvell: prestera: add missing unregister_netdev() in prestera_port_create()

Zheng Bin (1):
      octeontx2-pf: Remove duplicate MACSEC setting

Ziyang Xuan (2):
      net: ethernet: mtk_eth_soc: fix potential memory leak in mtk_rx_alloc()
      ipv4: Fix error return code in fib_table_insert()

 Documentation/networking/generic_netlink.rst       |   2 +-
 drivers/net/arcnet/com20020_cs.c                   |  11 ++-
 drivers/net/bonding/bond_main.c                    |  17 ++--
 drivers/net/dsa/sja1105/sja1105_mdio.c             |   6 ++
 drivers/net/ethernet/altera/altera_tse_main.c      |   1 +
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c  |  12 ++-
 drivers/net/ethernet/cavium/liquidio/lio_main.c    |   4 +-
 drivers/net/ethernet/cavium/thunder/thunder_bgx.c  |   4 +-
 drivers/net/ethernet/davicom/dm9051.c              |   4 +-
 drivers/net/ethernet/engleder/tsnep_main.c         |  57 +++++++++++-
 drivers/net/ethernet/freescale/enetc/enetc.c       |   8 +-
 drivers/net/ethernet/freescale/enetc/enetc.h       |   1 +
 drivers/net/ethernet/freescale/enetc/enetc_qos.c   |  21 +++--
 drivers/net/ethernet/intel/iavf/iavf.h             |   1 -
 drivers/net/ethernet/intel/iavf/iavf_main.c        |  41 +++++----
 drivers/net/ethernet/intel/ice/ice_main.c          |  12 +--
 drivers/net/ethernet/intel/ice/ice_ptp.c           |  20 ++---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c    |   8 +-
 drivers/net/ethernet/marvell/octeontx2/Kconfig     |   1 -
 drivers/net/ethernet/marvell/octeontx2/af/mcs.c    |   2 +-
 .../ethernet/marvell/octeontx2/af/rvu_debugfs.c    |   3 +
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    |   2 +
 .../net/ethernet/marvell/octeontx2/af/rvu_sdp.c    |   7 +-
 .../net/ethernet/marvell/prestera/prestera_main.c  |   1 +
 drivers/net/ethernet/mediatek/mtk_eth_soc.c        |  17 ++--
 drivers/net/ethernet/mediatek/mtk_ppe.c            |  19 +++-
 drivers/net/ethernet/mediatek/mtk_ppe.h            |   1 +
 drivers/net/ethernet/mellanox/mlx4/qp.c            |   3 +-
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c      |  47 +++++-----
 .../mellanox/mlx5/core/diag/cmd_tracepoint.h       |  45 ++++++++++
 .../ethernet/mellanox/mlx5/core/diag/fw_tracer.c   |   2 +-
 .../ethernet/mellanox/mlx5/core/en/tc_tun_encap.c  |  16 ++--
 .../ethernet/mellanox/mlx5/core/en/tc_tun_encap.h  |   3 +-
 .../ethernet/mellanox/mlx5/core/en_accel/macsec.c  |  19 ++--
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |  18 ----
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   5 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |  17 ++--
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c |   9 +-
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c  |   3 +-
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h  |  14 ++-
 .../net/ethernet/mellanox/mlx5/core/lag/mpesw.c    | 100 +++++++++++++--------
 .../net/ethernet/mellanox/mlx5/core/lag/mpesw.h    |   1 -
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |   9 +-
 .../net/ethernet/mellanox/mlx5/core/sf/dev/dev.c   |  88 ++++++++++++++++++
 .../net/ethernet/microchip/sparx5/sparx5_netdev.c  |  14 ++-
 drivers/net/ethernet/microchip/sparx5/sparx5_tc.c  |   7 +-
 drivers/net/ethernet/netronome/nfp/nfp_devlink.c   |   2 +-
 .../net/ethernet/netronome/nfp/nfp_net_ethtool.c   |   3 +
 .../net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c   |   6 +-
 drivers/net/ethernet/qlogic/qla3xxx.c              |   1 +
 drivers/net/ethernet/sfc/ef100_netdev.c            |   1 +
 drivers/net/ipvlan/ipvlan.h                        |   1 +
 drivers/net/ipvlan/ipvlan_main.c                   |   2 +
 drivers/net/macsec.c                               |   1 -
 drivers/net/phy/at803x.c                           |   4 +-
 drivers/net/usb/cdc_ncm.c                          |   1 +
 drivers/net/usb/qmi_wwan.c                         |   1 +
 drivers/net/virtio_net.c                           |   3 +-
 drivers/net/wwan/iosm/iosm_ipc_pcie.c              |   2 +-
 drivers/net/wwan/t7xx/t7xx_modem_ops.c             |   2 +
 drivers/nfc/nfcmrvl/i2c.c                          |   4 +-
 drivers/nfc/nxp-nci/core.c                         |   8 +-
 drivers/nfc/s3fwrn5/core.c                         |   1 +
 drivers/nfc/st-nci/se.c                            |  49 +++++++---
 include/linux/mlx5/driver.h                        |   1 +
 include/net/inet_hashtables.h                      |   3 +-
 include/net/neighbour.h                            |   2 +-
 net/core/flow_dissector.c                          |   2 +-
 net/core/lwtunnel.c                                |   4 +-
 net/core/neighbour.c                               |  58 ++++++------
 net/dccp/ipv4.c                                    |  23 ++---
 net/dccp/ipv6.c                                    |  24 ++---
 net/dccp/proto.c                                   |   3 +-
 net/ipv4/af_inet.c                                 |  11 +--
 net/ipv4/esp4_offload.c                            |   3 +
 net/ipv4/fib_trie.c                                |   6 +-
 net/ipv4/inet_hashtables.c                         |  84 ++++++++++++++---
 net/ipv4/ip_input.c                                |   5 ++
 net/ipv4/netfilter/ipt_CLUSTERIP.c                 |   4 +-
 net/ipv4/tcp.c                                     |   3 +-
 net/ipv4/tcp_ipv4.c                                |  21 ++---
 net/ipv6/esp6_offload.c                            |   3 +
 net/ipv6/tcp_ipv6.c                                |  20 +----
 net/ipv6/xfrm6_policy.c                            |   6 +-
 net/key/af_key.c                                   |  34 ++++---
 net/l2tp/l2tp_core.c                               |  17 ++--
 net/netfilter/ipset/ip_set_hash_gen.h              |   2 +-
 net/netfilter/ipset/ip_set_hash_ip.c               |   8 +-
 net/netfilter/nf_conntrack_core.c                  |   2 +-
 net/netfilter/nf_conntrack_netlink.c               |  24 ++---
 net/netfilter/nf_conntrack_standalone.c            |   2 +-
 net/netfilter/nf_flow_table_offload.c              |   4 +
 net/netfilter/nf_tables_api.c                      |   6 +-
 net/netfilter/nft_ct.c                             |   6 +-
 net/netfilter/xt_connmark.c                        |  18 ++--
 net/nfc/nci/core.c                                 |   2 +-
 net/nfc/nci/data.c                                 |   4 +-
 net/openvswitch/conntrack.c                        |   8 +-
 net/rxrpc/ar-internal.h                            |   1 +
 net/rxrpc/conn_client.c                            |  38 ++++----
 net/sched/Kconfig                                  |   2 +-
 net/sched/act_connmark.c                           |   4 +-
 net/sched/act_ct.c                                 |   8 +-
 net/sched/act_ctinfo.c                             |   6 +-
 net/tipc/discover.c                                |   5 +-
 net/tipc/topsrv.c                                  |  20 +++--
 net/xfrm/xfrm_device.c                             |  15 +++-
 net/xfrm/xfrm_replay.c                             |   2 +-
 tools/testing/selftests/net/fcnal-test.sh          |  11 ++-
 tools/testing/selftests/net/mptcp/mptcp_join.sh    |   6 +-
 tools/testing/selftests/net/mptcp/mptcp_sockopt.sh |   9 +-
 tools/testing/selftests/net/mptcp/simult_flows.sh  |   5 +-
 tools/testing/selftests/net/pmtu.sh                |  10 ++-
 tools/testing/selftests/net/udpgro.sh              |   8 +-
 tools/testing/selftests/net/udpgro_bench.sh        |   8 +-
 tools/testing/selftests/net/udpgro_frglist.sh      |   8 +-
 tools/testing/selftests/net/udpgro_fwd.sh          |   3 +-
 tools/testing/selftests/net/veth.sh                |  11 +--
 119 files changed, 917 insertions(+), 483 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/diag/cmd_tracepoint.h

