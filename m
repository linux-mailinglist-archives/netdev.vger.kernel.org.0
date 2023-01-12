Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EAC06678BD
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 16:13:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240203AbjALPNO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 10:13:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240141AbjALPMc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 10:12:32 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D171A19D
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 07:00:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673535651;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=f/gQ8aM3aL20tS/jvTVDFto1id0FgsygEMifcwjEP6g=;
        b=KcKrNrR2itegq7ewDBwhKTlA1yi/RP2Uf2jr614F1r4+1aJDiTxvCSfErOLZhXpNTcspHS
        DJKxn3FTAqxDKqqi9MaMvjoYJUrPJ8BU5TOw20/sRQhyJGwwt21gDGDstM9vM7qNqOYjw4
        oMNMJYBgkednfZ6uRHYe6jilGqimmfQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-349-i62xN2EKM9KlyvVGLq_ojQ-1; Thu, 12 Jan 2023 10:00:47 -0500
X-MC-Unique: i62xN2EKM9KlyvVGLq_ojQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5364487A386;
        Thu, 12 Jan 2023 15:00:47 +0000 (UTC)
Received: from gerbillo.redhat.com (unknown [10.39.193.16])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DE0FE2166B26;
        Thu, 12 Jan 2023 15:00:45 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Networking for 6.2-rc4
Date:   Thu, 12 Jan 2023 16:00:09 +0100
Message-Id: <20230112150009.473990-1-pabeni@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
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

The rxrpc changes are noticeable large: to address a recent regression
has been necessary completing the threaded refactor.

This also includes the fix for the noqueue issue you have been CCed on.

The following changes since commit 50011c32f421215f6231996fcc84fd1fe81c4a48:

  Merge tag 'net-6.2-rc3' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2023-01-05 12:40:50 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-6.2-rc4

for you to fetch changes up to be53771c87f4e322a9835d3faa9cd73a4ecdec5b:

  r8152: add vendor/device ID pair for Microsoft Devkit (2023-01-12 14:26:04 +0100)

----------------------------------------------------------------
Including fixes from rxrpc.

Current release - regressions:

  - rxrpc:
    - only disconnect calls in the I/O thread
    - move client call connection to the I/O thread
    - fix incoming call setup race

  - eth: mlx5:
    - restore pkt rate policing support
    - fix memory leak on updating vport counters

Previous releases - regressions:

  - gro: take care of DODGY packets

  - ipv6: deduct extension header length in rawv6_push_pending_frames

  - tipc: fix unexpected link reset due to discovery messages

Previous releases - always broken:

  - sched: disallow noqueue for qdisc classes

  - eth: ice: fix potential memory leak in ice_gnss_tty_write()

  - eth: ixgbe: fix pci device refcount leak

  - eth: mlx5:
    - fix command stats access after free
    - fix macsec possible null dereference when updating MAC security entity (SecY)

Signed-off-by: Paolo Abeni <pabeni@redhat.com>

----------------------------------------------------------------
Alex Elder (1):
      net: ipa: correct IPA v4.7 IMEM offset

Andre Przywara (1):
      r8152: add vendor/device ID pair for Microsoft Devkit

Angela Czubak (1):
      octeontx2-af: Fix LMAC config in cgx_lmac_rx_tx_enable

Ariel Levkovich (2):
      net/mlx5: check attr pointer validity before dereferencing it
      net/mlx5e: TC, Keep mod hdr actions after mod hdr alloc

Aya Levin (1):
      net/mlx5e: Fix memory leak on updating vport counters

Biao Huang (1):
      stmmac: dwmac-mediatek: remove the dwmac_fix_mac_speed

Christopher S Hall (1):
      igc: Fix PPS delta between two synchronized end-points

Clément Léger (1):
      net: lan966x: check for ptp to be enabled in lan966x_ptp_deinit()

Daniil Tatianin (1):
      iavf/iavf_main: actually log ->src mask when talking about it

David Howells (19):
      rxrpc: Stash the network namespace pointer in rxrpc_local
      rxrpc: Make the local endpoint hold a ref on a connected call
      rxrpc: Separate call retransmission from other conn events
      rxrpc: Only set/transmit aborts in the I/O thread
      rxrpc: Only disconnect calls in the I/O thread
      rxrpc: Implement a mechanism to send an event notification to a connection
      rxrpc: Clean up connection abort
      rxrpc: Tidy up abort generation infrastructure
      rxrpc: Make the set of connection IDs per local endpoint
      rxrpc: Offload the completion of service conn security to the I/O thread
      rxrpc: Set up a connection bundle from a call, not rxrpc_conn_parameters
      rxrpc: Split out the call state changing functions into their own file
      rxrpc: Wrap accesses to get call state to put the barrier in one place
      rxrpc: Move call state changes from sendmsg to I/O thread
      rxrpc: Move call state changes from recvmsg to I/O thread
      rxrpc: Remove call->state_lock
      rxrpc: Move the client conn cache management to the I/O thread
      rxrpc: Move client call connection to the I/O thread
      rxrpc: Fix incoming call setup race

David S. Miller (2):
      Merge tag 'rxrpc-fixes-20230107' of git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs
      Merge tag 'mlx5-fixes-2023-01-09' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux

Dragos Tatulea (3):
      net/mlx5e: IPoIB, Block queue count configuration when sub interfaces are present
      net/mlx5e: IPoIB, Block PKEY interfaces with less rx queues than parent
      net/mlx5e: IPoIB, Fix child PKEY interface stats on rx path

Emeel Hakim (2):
      net/mlx5e: Fix macsec ssci attribute handling in offload path
      net/mlx5e: Fix macsec possible null dereference when updating MAC security entity (SecY)

Eric Dumazet (1):
      gro: take care of DODGY packets

Frederick Lawler (1):
      net: sched: disallow noqueue for qdisc classes

Gavin Li (1):
      net/mlx5e: Don't support encap rules with gbp option

Guillaume Nault (3):
      selftests/net: l2_tos_ttl_inherit.sh: Set IPv6 addresses with "nodad".
      selftests/net: l2_tos_ttl_inherit.sh: Run tests in their own netns.
      selftests/net: l2_tos_ttl_inherit.sh: Ensure environment cleanup on failure.

Hariprasad Kelam (1):
      octeontx2-pf: Fix resource leakage in VF driver unbind

Heiner Kallweit (1):
      Revert "r8169: disable detection of chip version 36"

Herbert Xu (1):
      ipv6: raw: Deduct extension header length in rawv6_push_pending_frames

Horatiu Vultur (1):
      net: lan966x: Allow to add rules in TCAM even if not enabled

Hui Wang (1):
      net: usb: cdc_ether: add support for Thales Cinterion PLS62-W modem

Ido Schimmel (1):
      net/sched: act_mpls: Fix warning during failed attribute validation

Ivan T. Ivanov (1):
      brcmfmac: Prefer DT board type over DMI board type

Jakub Kicinski (3):
      Merge branch '100GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue
      bnxt: make sure we return pages to the pool
      Merge branch '10GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue

Jiasheng Jiang (1):
      ice: Add check for kzalloc

Jie Wang (1):
      net: hns3: fix wrong use of rss size during VF rss config

Kees Cook (1):
      mlxsw: spectrum_router: Replace 0-length array with flexible array

Minsuk Kang (1):
      nfc: pn533: Wait for out_urb's completion in pn533_usb_send_frame()

Mirsad Goran Todorovac (1):
      af_unix: selftest: Fix the size of the parameter to connect()

Moshe Shemesh (1):
      net/mlx5: Fix command stats access after free

Noor Azura Ahmad Tarmizi (1):
      net: stmmac: add aux timestamps fifo clearance wait

Oz Shlomo (2):
      net/mlx5e: TC, ignore match level for post meter rules
      net/mlx5e: TC, Restore pkt rate policing support

Paolo Abeni (1):
      Merge branch 'selftests-net-isolate-l2_tos_ttl_inherit-sh-in-its-own-netns'

Rahul Rameshbabu (1):
      net/mlx5: Fix ptp max frequency adjustment range

Roy Novich (1):
      net/mlx5e: Verify dev is present for fix features ndo

Shay Drory (1):
      net/mlx5: E-switch, Coverity: overlapping copy

Tung Nguyen (1):
      tipc: fix unexpected link reset due to discovery messages

Yang Yingliang (1):
      ixgbe: fix pci device refcount leak

Yevgeny Kliteynik (1):
      net/mlx5: DR, Fix 'stack frame size exceeds limit' error in dr_rule

Yuan Can (1):
      ice: Fix potential memory leak in ice_gnss_tty_write()

 Documentation/networking/rxrpc.rst                 |   4 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |   4 +-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |   2 +-
 drivers/net/ethernet/intel/iavf/iavf_main.c        |   2 +-
 drivers/net/ethernet/intel/ice/ice_gnss.c          |  24 +-
 drivers/net/ethernet/intel/igc/igc_defines.h       |   2 +
 drivers/net/ethernet/intel/igc/igc_ptp.c           |  10 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c       |  14 +-
 drivers/net/ethernet/marvell/octeontx2/af/cgx.c    |   4 +-
 drivers/net/ethernet/marvell/octeontx2/af/cgx.h    |   1 -
 .../net/ethernet/marvell/octeontx2/nic/otx2_vf.c   |   2 +
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c      |  13 +-
 .../ethernet/mellanox/mlx5/core/en/tc/act/police.c |   6 -
 .../ethernet/mellanox/mlx5/core/en/tc/post_meter.c |   1 +
 .../ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c  |   2 +
 .../ethernet/mellanox/mlx5/core/en_accel/macsec.c  |  19 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   3 +
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |   3 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |   5 +-
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |   6 +-
 .../ethernet/mellanox/mlx5/core/ipoib/ethtool.c    |  16 +-
 .../net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c  |  38 ++
 .../net/ethernet/mellanox/mlx5/core/ipoib/ipoib.h  |   6 +
 .../ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c |  18 +-
 .../net/ethernet/mellanox/mlx5/core/lib/clock.c    |   2 +-
 .../ethernet/mellanox/mlx5/core/steering/dr_rule.c |  11 +-
 .../net/ethernet/mellanox/mlxsw/spectrum_router.c  |   2 +-
 .../net/ethernet/microchip/lan966x/lan966x_ptp.c   |   3 +
 .../ethernet/microchip/lan966x/lan966x_vcap_impl.c |   3 -
 drivers/net/ethernet/realtek/r8169_main.c          |   5 +-
 .../net/ethernet/stmicro/stmmac/dwmac-mediatek.c   |  26 -
 drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c   |   5 +-
 drivers/net/ipa/data/ipa_data-v4.7.c               |   2 +-
 drivers/net/usb/cdc_ether.c                        |   6 +
 drivers/net/usb/r8152.c                            |   1 +
 .../net/wireless/broadcom/brcm80211/brcmfmac/of.c  |   5 +-
 drivers/nfc/pn533/usb.c                            |  44 +-
 fs/afs/cmservice.c                                 |   6 +-
 fs/afs/rxrpc.c                                     |  24 +-
 include/linux/mlx5/driver.h                        |   2 +-
 include/net/af_rxrpc.h                             |   3 +-
 include/trace/events/rxrpc.h                       | 160 +++--
 net/core/gro.c                                     |   5 +-
 net/ipv6/raw.c                                     |   4 +
 net/rxrpc/Makefile                                 |   1 +
 net/rxrpc/af_rxrpc.c                               |  27 +-
 net/rxrpc/ar-internal.h                            | 212 +++---
 net/rxrpc/call_accept.c                            |  57 +-
 net/rxrpc/call_event.c                             |  86 ++-
 net/rxrpc/call_object.c                            | 116 ++--
 net/rxrpc/call_state.c                             |  69 ++
 net/rxrpc/conn_client.c                            | 709 ++++++---------------
 net/rxrpc/conn_event.c                             | 382 ++++-------
 net/rxrpc/conn_object.c                            |  67 +-
 net/rxrpc/conn_service.c                           |   1 -
 net/rxrpc/input.c                                  | 175 ++---
 net/rxrpc/insecure.c                               |  20 +-
 net/rxrpc/io_thread.c                              | 204 +++---
 net/rxrpc/local_object.c                           |  35 +-
 net/rxrpc/net_ns.c                                 |  17 -
 net/rxrpc/output.c                                 |  60 +-
 net/rxrpc/peer_object.c                            |  23 +-
 net/rxrpc/proc.c                                   |  17 +-
 net/rxrpc/recvmsg.c                                | 256 ++------
 net/rxrpc/rxkad.c                                  | 356 +++++------
 net/rxrpc/rxperf.c                                 |  17 +-
 net/rxrpc/security.c                               |  53 +-
 net/rxrpc/sendmsg.c                                | 195 +++---
 net/sched/act_mpls.c                               |   8 +-
 net/sched/sch_api.c                                |   5 +
 net/tipc/node.c                                    |  12 +-
 .../testing/selftests/net/af_unix/test_unix_oob.c  |   2 +-
 tools/testing/selftests/net/l2_tos_ttl_inherit.sh  | 202 +++---
 74 files changed, 1954 insertions(+), 1956 deletions(-)
 create mode 100644 net/rxrpc/call_state.c

