Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E48760B8DE
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 21:56:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233908AbiJXT4f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 15:56:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232638AbiJXT4E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 15:56:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D76BA1AC;
        Mon, 24 Oct 2022 11:19:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4A6656151B;
        Mon, 24 Oct 2022 18:18:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 684F2C433D6;
        Mon, 24 Oct 2022 18:18:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666635517;
        bh=nycgIwXxeRUg1hsH5IueGUAFbxCD/iCQJ0P+MoG61Ug=;
        h=From:To:Cc:Subject:Date:From;
        b=J7Debh02gwlrLSyPNOnSEZPQ4tVLYUcfWauwQyXF2sX5rFhrF+b0GpEe7nj3lofs4
         dchE7JajjqOFnXz531nFYiBT0Din3mRhYnFRb9qIh24UGXIaTqhbwoZCVkQY1uXZTg
         bSCqlqU3FrZlPmPhkjHq7+fo+l4xWHh5WXGF48bWCgfI6Kpk0BsFDn7xdagjHnzhG9
         YBnZzRvxeTXxcchBqnnJjSMt4CS7iz0oOvqEKapsehFDcbqnFTEy2E+sfm+fyNud61
         B8AMTZxq8nnTKqzvsPPxjQxHEC2ZPY6i+YMZswT+oeF1fRbItjw2nHtplcu890NIsc
         0Kc5rxyffxxPA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     torvalds@linux-foundation.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, pabeni@redhat.com
Subject: [PULL] Networking for v6.1-rc3 (part 1)
Date:   Mon, 24 Oct 2022 11:18:35 -0700
Message-Id: <20221024181835.475631-1-kuba@kernel.org>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Linus!

An extra PR so that we can fast-forward and get some perf and iouring
fixes back from your tree. The net-memcg fix stands out, the rest is
very run-off-the-mill. Maybe I'm biased.

I give up on the GCC 8 / objtool warning, Alexei says is a known compiler
bug. I haven't seen anyone else complaining, either.


The following changes since commit 6d36c728bc2e2d632f4b0dea00df5532e20dfdab:

  Merge tag 'net-6.1-rc2' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2022-10-20 17:24:59 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-6.1-rc3-1

for you to fetch changes up to 720ca52bcef225b967a339e0fffb6d0c7e962240:

  net-memcg: avoid stalls when under memory pressure (2022-10-24 10:35:09 -0700)

----------------------------------------------------------------
Including fixes from bpf.

Current release - regressions:

 - eth: fman: re-expose location of the MAC address to userspace,
   apparently some udev scripts depended on the exact value

Current release - new code bugs:

 - bpf:
   - wait for busy refill_work when destroying bpf memory allocator
   - allow bpf_user_ringbuf_drain() callbacks to return 1
   - fix dispatcher patchable function entry to 5 bytes nop

Previous releases - regressions:

 - net-memcg: avoid stalls when under memory pressure

 - tcp: fix indefinite deferral of RTO with SACK reneging

 - tipc: fix a null-ptr-deref in tipc_topsrv_accept

 - eth: macb: specify PHY PM management done by MAC

 - tcp: fix a signed-integer-overflow bug in tcp_add_backlog()

Previous releases - always broken:

 - eth: amd-xgbe: SFP fixes and compatibility improvements

Misc:

 - docs: netdev: offer performance feedback to contributors

Signed-off-by: Jakub Kicinski <kuba@kernel.org>

----------------------------------------------------------------
Alexei Starovoitov (1):
      Merge branch 'Wait for busy refill_work when destroying bpf memory allocator'

Andrii Nakryiko (1):
      Merge branch 'Allow bpf_user_ringbuf_drain() callbacks to return 1'

Benjamin Poirier (2):
      selftests: net: Fix cross-tree inclusion of scripts
      selftests: net: Fix netdev name mismatch in cleanup

David S. Miller (1):
      Merge branch 'kcm-data-races'

David Vernet (2):
      bpf: Allow bpf_user_ringbuf_drain() callbacks to return 1
      selftests/bpf: Make bpf_user_ringbuf_drain() selftest callback return 1

Eric Dumazet (2):
      kcm: annotate data-races around kcm->rx_psock
      kcm: annotate data-races around kcm->rx_wait

Horatiu Vultur (1):
      net: lan966x: Fix the rx drop counter

Hou Tao (2):
      bpf: Wait for busy refill_work when destroying bpf memory allocator
      bpf: Use __llist_del_all() whenever possbile during memory draining

Jakub Kicinski (8):
      Merge branch 'selftests-net-fix-problems-in-some-drivers-net-tests'
      Merge branch 'fix-some-issues-in-huawei-hinic-driver'
      ethtool: pse-pd: fix null-deref on genl_info in dump
      MAINTAINERS: add keyword match on PTP
      Merge branch 'amd-xgbe-miscellaneous-fixes'
      docs: netdev: offer performance feedback to contributors
      Merge tag 'for-netdev' of https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf
      net-memcg: avoid stalls when under memory pressure

Jiri Olsa (1):
      bpf: Fix dispatcher patchable function entry to 5 bytes nop

Leon Romanovsky (1):
      net/mlx5e: Cleanup MACsec uninitialization routine

Lu Wei (1):
      tcp: fix a signed-integer-overflow bug in tcp_add_backlog()

Neal Cardwell (1):
      tcp: fix indefinite deferral of RTO with SACK reneging

Raju Rangoju (5):
      amd-xgbe: Yellow carp devices do not need rrc
      amd-xgbe: use enums for mailbox cmd and sub_cmds
      amd-xgbe: enable PLL_CTL for fixed PHY modes only
      amd-xgbe: fix the SFP compliance codes check for DAC cables
      amd-xgbe: add the bit rate quirk for Molex cables

Sean Anderson (1):
      net: fman: Use physical address for userspace interfaces

Sergiu Moga (1):
      net: macb: Specify PHY PM management done by MAC

Shang XiaoJing (1):
      nfc: virtual_ncidev: Fix memory leak in virtual_nci_send()

Stanislav Fomichev (2):
      selftests/bpf: Add reproducer for decl_tag in func_proto return type
      bpf: prevent decl_tag from being referenced in func_proto

Xin Long (1):
      tipc: fix a null-ptr-deref in tipc_topsrv_accept

Yang Yingliang (1):
      net: netsec: fix error handling in netsec_register_mdio()

Yinjun Zhang (1):
      nfp: only clean `sp_indiff` when application firmware is unloaded

Zhang Changzhong (1):
      net: lantiq_etop: don't free skb when returning NETDEV_TX_BUSY

Zhengchao Shao (5):
      net: hinic: fix incorrect assignment issue in hinic_set_interrupt_cfg()
      net: hinic: fix memory leak when reading function table
      net: hinic: fix the issue of CMDQ memory leaks
      net: hinic: fix the issue of double release MBOX callback of VF
      net: fix UAF issue in nfqnl_nf_hook_drop() when ops_init() failed

Íñigo Huguet (1):
      atlantic: fix deadlock at aq_nic_stop

 Documentation/process/maintainer-netdev.rst        | 10 +++
 MAINTAINERS                                        |  1 +
 arch/x86/net/bpf_jit_comp.c                        | 13 +++
 drivers/net/ethernet/amd/xgbe/xgbe-pci.c           |  5 ++
 drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c        | 58 ++++++++-----
 drivers/net/ethernet/amd/xgbe/xgbe.h               | 26 ++++++
 drivers/net/ethernet/aquantia/atlantic/aq_macsec.c | 96 ++++++++++++++++------
 drivers/net/ethernet/aquantia/atlantic/aq_nic.h    |  2 +
 drivers/net/ethernet/cadence/macb_main.c           |  1 +
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c     |  4 +-
 .../net/ethernet/freescale/dpaa/dpaa_eth_sysfs.c   |  2 +-
 drivers/net/ethernet/freescale/fman/mac.c          | 12 +--
 drivers/net/ethernet/freescale/fman/mac.h          |  2 +-
 drivers/net/ethernet/huawei/hinic/hinic_debugfs.c  | 18 ++--
 drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c  |  2 +-
 drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c   |  2 +-
 drivers/net/ethernet/huawei/hinic/hinic_sriov.c    |  1 -
 drivers/net/ethernet/lantiq_etop.c                 |  1 -
 .../ethernet/mellanox/mlx5/core/en_accel/macsec.c  | 11 +--
 .../ethernet/microchip/lan966x/lan966x_ethtool.c   | 10 ++-
 drivers/net/ethernet/netronome/nfp/nfp_main.c      | 38 ++++-----
 drivers/net/ethernet/socionext/netsec.c            |  2 +
 drivers/nfc/virtual_ncidev.c                       |  3 +
 include/linux/bpf.h                                | 14 +++-
 include/net/sock.h                                 |  2 +-
 kernel/bpf/btf.c                                   |  5 ++
 kernel/bpf/dispatcher.c                            |  6 ++
 kernel/bpf/memalloc.c                              | 18 +++-
 kernel/bpf/verifier.c                              |  1 +
 net/core/net_namespace.c                           |  7 ++
 net/ethtool/pse-pd.c                               |  2 +-
 net/ipv4/tcp_input.c                               |  3 +-
 net/ipv4/tcp_ipv4.c                                |  4 +-
 net/kcm/kcmsock.c                                  | 23 ++++--
 net/tipc/topsrv.c                                  | 16 +++-
 tools/testing/selftests/bpf/prog_tests/btf.c       | 13 +++
 .../selftests/bpf/progs/user_ringbuf_success.c     |  4 +-
 .../testing/selftests/drivers/net/bonding/Makefile |  4 +-
 .../drivers/net/bonding/dev_addr_lists.sh          |  2 +-
 .../drivers/net/bonding/net_forwarding_lib.sh      |  1 +
 .../drivers/net/dsa/test_bridge_fdb_stress.sh      |  4 +-
 tools/testing/selftests/drivers/net/team/Makefile  |  4 +
 .../selftests/drivers/net/team/dev_addr_lists.sh   |  6 +-
 .../testing/selftests/drivers/net/team/lag_lib.sh  |  1 +
 .../drivers/net/team/net_forwarding_lib.sh         |  1 +
 tools/testing/selftests/lib.mk                     |  4 +-
 46 files changed, 336 insertions(+), 129 deletions(-)
 create mode 120000 tools/testing/selftests/drivers/net/bonding/net_forwarding_lib.sh
 create mode 120000 tools/testing/selftests/drivers/net/team/lag_lib.sh
 create mode 120000 tools/testing/selftests/drivers/net/team/net_forwarding_lib.sh
