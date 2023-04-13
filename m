Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AD296E1681
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 23:32:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229893AbjDMVcV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 17:32:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbjDMVcV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 17:32:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92E37AA;
        Thu, 13 Apr 2023 14:32:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 166F960B33;
        Thu, 13 Apr 2023 21:32:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22776C433EF;
        Thu, 13 Apr 2023 21:32:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681421538;
        bh=JH02kp/JlRAvsOQvqVWjT2LTMuLyWCZapLkYg5zS0Rw=;
        h=From:To:Cc:Subject:Date:From;
        b=KQpL2Y5/LK6Wg/EoYyslu8ttdQMr66uUgRuawIA6Y+9Y5RfOMcNw/Ag241aJcAyja
         cr46YMxgfZ+IeECbiDm5UltUxOwEle+KwdkwgIMSC3QFc/4LU5F8Au+JpXKFgaGhL9
         oHFNtB5yw+285FE+ShfMY4T0P5r5Focl03ll9RDVFr8bAguHWpuAEcpzL5FEtmeUcw
         DBzQ5vIWEC8cVr1jhbz4BBfBeXkezeMAQQGP5KD/xKhcUHHpWMqFqyxQgiQbjLwIZm
         v76Xg+I1FDBvufzNony7/xSnmyxEMSCZlOcDEAJ/GWJOzyY1Avv4DuDBV73PASrhoO
         jYXlZ6kqCXvtQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     torvalds@linux-foundation.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, pabeni@redhat.com
Subject: [GIT PULL] Networking for v6.3-rc7
Date:   Thu, 13 Apr 2023 14:32:17 -0700
Message-Id: <20230413213217.822550-1-kuba@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Linus!

The following changes since commit f2afccfefe7be1f7346564fe619277110d341f9b:

  Merge tag 'net-6.3-rc6-2' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2023-04-06 11:39:07 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git net-6.3-rc7

for you to fetch changes up to d0f89c4c1d4e7614581d4fe7caebb3ce6bceafe6:

  Merge tag 'for-netdev' of https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf (2023-04-13 13:04:44 -0700)

----------------------------------------------------------------
Including fixes from bpf, and bluetooth.

Not all that quiet given spring celebrations, but "current" fixes
are thinning out, which is encouraging. One outstanding regression
in the mlx5 driver when using old FW, not blocking but we're pushing
for a fix.

Current release - new code bugs:

 - eth: enetc: workaround for unresponsive pMAC after receiving
   express traffic

Previous releases - regressions:

 - rtnetlink: restore RTM_NEW/DELLINK notification behavior,
   keep the pid/seq fields 0 for backward compatibility

Previous releases - always broken:

 - sctp: fix a potential overflow in sctp_ifwdtsn_skip

 - mptcp:
   - use mptcp_schedule_work instead of open-coding it and make
     the worker check stricter, to avoid scheduling work on closed
     sockets
   - fix NULL pointer dereference on fastopen early fallback

 - skbuff: fix memory corruption due to a race between skb coalescing
   and releasing clones confusing page_pool reference counting

 - bonding: fix neighbor solicitation validation on backup slaves

 - bpf: tcp: use sock_gen_put instead of sock_put in bpf_iter_tcp

 - bpf: arm64: fixed a BTI error on returning to patched function

 - openvswitch: fix race on port output leading to inf loop

 - sfp: initialize sfp->i2c_block_size at sfp allocation to avoid
   returning a different errno than expected

 - phy: nxp-c45-tja11xx: unregister PTP, purge queues on remove

 - Bluetooth: fix printing errors if LE Connection times out

 - Bluetooth: assorted UaF, deadlock and data race fixes

 - eth: macb: fix memory corruption in extended buffer descriptor mode

Misc:

 - adjust the XDP Rx flow hash API to also include the protocol layers
   over which the hash was computed

Signed-off-by: Jakub Kicinski <kuba@kernel.org>

----------------------------------------------------------------
Aaron Conole (1):
      selftests: openvswitch: adjust datapath NL message declaration

Ahmed Zaki (2):
      iavf: refactor VLAN filter states
      iavf: remove active_cvlans and active_svlans bitmaps

Alexei Starovoitov (1):
      Merge branch 'XDP-hints: change RX-hash kfunc bpf_xdp_metadata_rx_hash'

Claudia Draghicescu (1):
      Bluetooth: Set ISO Data Path on broadcast sink

David S. Miller (2):
      Merge branch 'bonding-ns-validation-fixes'
      Merge branch 'sfp-eeprom'

Denis Plotnikov (1):
      qlcnic: check pci_reset_function result

Douglas Anderson (1):
      r8152: Add __GFP_NOWARN to big allocations

Eric Dumazet (1):
      udp6: fix potential access to stale information

Felix Huettner (1):
      net: openvswitch: fix race on port output

George Guo (1):
      LoongArch, bpf: Fix jit to skip speculation barrier opcode

Hangbin Liu (3):
      bonding: fix ns validation on backup slaves
      selftests: bonding: re-format bond option tests
      selftests: bonding: add arp validate test

Harshit Mogalapalli (2):
      niu: Fix missing unwind goto in niu_alloc_channels()
      net: wwan: iosm: Fix error handling path in ipc_pcie_probe()

Ivan Bornyakov (2):
      net: sfp: initialize sfp->i2c_block_size at sfp allocation
      net: sfp: avoid EEPROM read of absent SFP module

Jakub Kicinski (5):
      Merge tag 'for-netdev' of https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf
      Merge tag 'for-net-2023-04-10' of git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth
      Merge branch '40GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue
      Merge branch 'mptcp-more-fixes-for-6-3'
      Merge tag 'for-netdev' of https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf

Jesper Dangaard Brouer (6):
      selftests/bpf: xdp_hw_metadata remove bpf_printk and add counters
      xdp: rss hash types representation
      mlx5: bpf_xdp_metadata_rx_hash add xdp rss hash type
      veth: bpf_xdp_metadata_rx_hash add xdp rss hash type
      mlx4: bpf_xdp_metadata_rx_hash add xdp rss hash type
      selftests/bpf: Adjust bpf_xdp_metadata_rx_hash for new arg

Kuniyuki Iwashima (1):
      smc: Fix use-after-free in tcp_write_timer_handler().

Liang Chen (1):
      skbuff: Fix a race between coalescing and releasing SKBs

Lorenzo Bianconi (1):
      selftests/bpf: fix xdp_redirect xdp-features selftest for veth driver

Luiz Augusto von Dentz (6):
      Bluetooth: hci_conn: Fix not cleaning up on LE Connection failure
      Bluetooth: Fix printing errors if LE Connection times out
      Bluetooth: SCO: Fix possible circular locking dependency on sco_connect_cfm
      Bluetooth: SCO: Fix possible circular locking dependency sco_sock_getsockopt
      Bluetooth: hci_conn: Fix possible UAF
      Bluetooth: L2CAP: Fix use-after-free in l2cap_disconnect_{req,rsp}

Martin KaFai Lau (1):
      bpf: tcp: Use sock_gen_put instead of sock_put in bpf_iter_tcp

Martin Willi (1):
      rtnetlink: Restore RTM_NEW/DELLINK notification behavior

Matthieu Baerts (1):
      selftests: mptcp: userspace pm: uniform verify events

Min Li (1):
      Bluetooth: Fix race condition in hidp_session_thread

Paolo Abeni (3):
      mptcp: use mptcp_schedule_work instead of open-coding it
      mptcp: stricter state check in mptcp_worker
      mptcp: fix NULL pointer dereference on fastopen early fallback

Radu Pirea (OSS) (2):
      net: phy: nxp-c45-tja11xx: fix unsigned long multiplication overflow
      net: phy: nxp-c45-tja11xx: add remove callback

Rob Herring (1):
      net: ti/cpsw: Add explicit platform_device.h and of_platform.h includes

Roman Gushchin (1):
      net: macb: fix a memory corruption in extended buffer descriptor mode

Sasha Finkelstein (1):
      bluetooth: btbcm: Fix logic error in forming the board name.

Vladimir Oltean (1):
      net: enetc: workaround for unresponsive pMAC after receiving express traffic

Xin Long (2):
      sctp: fix a potential overflow in sctp_ifwdtsn_skip
      selftests: add the missing CONFIG_IP_SCTP in net config

Xu Kuohai (1):
      bpf, arm64: Fixed a BTI error on returning to patched function

YueHaibing (1):
      tcp: restrict net.ipv4.tcp_app_win

Zheng Wang (1):
      Bluetooth: btsdio: fix use after free bug in btsdio_remove due to race condition

Ziyang Xuan (1):
      net: qrtr: Fix an uninit variable access bug in qrtr_tx_resume()

 Documentation/networking/ip-sysctl.rst             |   2 +
 arch/arm64/net/bpf_jit.h                           |   4 +
 arch/arm64/net/bpf_jit_comp.c                      |   3 +-
 arch/loongarch/net/bpf_jit.c                       |   4 +
 drivers/bluetooth/btbcm.c                          |   2 +-
 drivers/bluetooth/btsdio.c                         |   1 +
 drivers/net/bonding/bond_main.c                    |   5 +-
 drivers/net/ethernet/cadence/macb_main.c           |   4 +
 .../net/ethernet/freescale/enetc/enetc_ethtool.c   |  16 ++
 drivers/net/ethernet/intel/iavf/iavf.h             |  20 +-
 drivers/net/ethernet/intel/iavf/iavf_main.c        |  44 ++--
 drivers/net/ethernet/intel/iavf/iavf_virtchnl.c    |  68 +++---
 drivers/net/ethernet/mellanox/mlx4/en_rx.c         |  22 +-
 drivers/net/ethernet/mellanox/mlx4/mlx4_en.h       |   3 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c   |  63 ++++-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_ctx.c    |   8 +-
 drivers/net/ethernet/sun/niu.c                     |   2 +-
 drivers/net/ethernet/ti/cpsw.c                     |   2 +-
 drivers/net/ethernet/ti/cpsw_new.c                 |   3 +-
 drivers/net/phy/nxp-c45-tja11xx.c                  |  14 +-
 drivers/net/phy/sfp.c                              |  19 +-
 drivers/net/usb/r8152.c                            |   2 +-
 drivers/net/veth.c                                 |  10 +-
 drivers/net/wwan/iosm/iosm_ipc_pcie.c              |   3 +-
 include/linux/mlx5/device.h                        |  14 +-
 include/linux/netdevice.h                          |   3 +-
 include/linux/rtnetlink.h                          |   3 +-
 include/net/bluetooth/hci_core.h                   |   1 +
 include/net/bonding.h                              |   8 +-
 include/net/xdp.h                                  |  47 ++++
 net/bluetooth/hci_conn.c                           |  89 ++++---
 net/bluetooth/hci_event.c                          |  18 +-
 net/bluetooth/hci_sync.c                           |  13 +-
 net/bluetooth/hidp/core.c                          |   2 +-
 net/bluetooth/l2cap_core.c                         |  24 +-
 net/bluetooth/sco.c                                |  85 ++++---
 net/core/dev.c                                     |   3 +-
 net/core/rtnetlink.c                               |  11 +-
 net/core/skbuff.c                                  |  16 +-
 net/core/xdp.c                                     |  10 +-
 net/ipv4/sysctl_net_ipv4.c                         |   3 +
 net/ipv4/tcp_ipv4.c                                |   4 +-
 net/ipv6/udp.c                                     |   8 +-
 net/mptcp/fastopen.c                               |  11 +-
 net/mptcp/options.c                                |   5 +-
 net/mptcp/protocol.c                               |   2 +-
 net/mptcp/subflow.c                                |  18 +-
 net/openvswitch/actions.c                          |   2 +-
 net/qrtr/af_qrtr.c                                 |   8 +-
 net/sctp/stream_interleave.c                       |   3 +-
 net/smc/af_smc.c                                   |  11 +
 .../selftests/bpf/prog_tests/xdp_do_redirect.c     |  30 ++-
 .../selftests/bpf/prog_tests/xdp_metadata.c        |   2 +
 .../testing/selftests/bpf/progs/xdp_hw_metadata.c  |  42 ++--
 tools/testing/selftests/bpf/progs/xdp_metadata.c   |   6 +-
 tools/testing/selftests/bpf/progs/xdp_metadata2.c  |   7 +-
 tools/testing/selftests/bpf/xdp_hw_metadata.c      |  10 +-
 tools/testing/selftests/bpf/xdp_metadata.h         |   4 +
 .../testing/selftests/drivers/net/bonding/Makefile |   3 +-
 .../selftests/drivers/net/bonding/bond_options.sh  | 264 +++++++++++++++++++++
 .../drivers/net/bonding/bond_topo_3d1c.sh          | 143 +++++++++++
 .../selftests/drivers/net/bonding/option_prio.sh   | 245 -------------------
 tools/testing/selftests/net/config                 |   1 +
 tools/testing/selftests/net/mptcp/userspace_pm.sh  |   2 +
 .../testing/selftests/net/openvswitch/ovs-dpctl.py |   2 +-
 65 files changed, 990 insertions(+), 517 deletions(-)
 create mode 100755 tools/testing/selftests/drivers/net/bonding/bond_options.sh
 create mode 100644 tools/testing/selftests/drivers/net/bonding/bond_topo_3d1c.sh
 delete mode 100755 tools/testing/selftests/drivers/net/bonding/option_prio.sh
