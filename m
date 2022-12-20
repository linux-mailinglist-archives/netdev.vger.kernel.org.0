Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E163D6527E2
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 21:31:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234283AbiLTUak (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 15:30:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234183AbiLTUa1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 15:30:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB5851CB36;
        Tue, 20 Dec 2022 12:30:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 72790B8197A;
        Tue, 20 Dec 2022 20:30:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDEFFC433EF;
        Tue, 20 Dec 2022 20:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671568223;
        bh=wIOlW69jFdLX4IO7wOB1/gOTA3sNbKZ+0iHkJpJieik=;
        h=From:To:Cc:Subject:Date:From;
        b=c8rTVA4l4MajrnRylm6DxlrGg4EL+Ova2UYiHDNOEvc0QS8xyjkkpxRoDqpemhof9
         aWeoLavr5OUq/Jmg5GiTtlIoZ1JFfO1QyBVYVu6F8p8EcokQrS/E0Ng/P5himJ3sfE
         57R4tAIzWGNItfkwnsYdrTCYWgYzOiOokNpraDuk5zpeEdfvxgZqiJyGytTttv+BNI
         ujwtHy2T5et/HXKJtjOnmdqVzO4AVK5bk5wbRHsiRWvT6Dth2jyLoPwHTGcVWcHcLP
         2CfU+PGsyGMe5v3rabdIhzfwE2IMlqBLxJopil9/xI7j+q/VoLVPpXpafd12Icnrf9
         wYe/IQPEUtXWg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     torvalds@linux-foundation.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, pabeni@redhat.com
Subject: [PULL] Networking for v6.2-rc1
Date:   Tue, 20 Dec 2022 12:30:22 -0800
Message-Id: <20221220203022.1084532-1-kuba@kernel.org>
X-Mailer: git-send-email 2.38.1
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

Traffic is winding down significantly so let us pass our fixes to you
earlier than the usual Thu schedule.

We have a fix for the BPF issue we were looking at before 6.1 final,
no surprises there. RxRPC fixes were merged relatively late so there's
an outpour of follow ups. Last one worth mentioning is the tree-wide
fix for network file systems / in-tree socket users, to prevent nested
networking calls from corrupting socket memory allocator.

Happy holidays (and unless something urgent happens) - till next year!


The following changes since commit 7e68dd7d07a28faa2e6574dd6b9dbd90cdeaae91:

  Merge tag 'net-next-6.2' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next (2022-12-13 15:47:48 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-6.2-rc1

for you to fetch changes up to 19e72b064fc32cd58f6fc0b1eb64ac2e4f770e76:

  net: fec: check the return value of build_skb() (2022-12-20 11:33:24 -0800)

----------------------------------------------------------------
Including fixes from bpf, netfilter and can.

Current release - regressions:

 - bpf: synchronize dispatcher update with bpf_dispatcher_xdp_func

 - rxrpc:
  - fix security setting propagation
  - fix null-deref in rxrpc_unuse_local()
  - fix switched parameters in peer tracing

Current release - new code bugs:

 - rxrpc:
   - fix I/O thread startup getting skipped
   - fix locking issues in rxrpc_put_peer_locked()
   - fix I/O thread stop
   - fix uninitialised variable in rxperf server
   - fix the return value of rxrpc_new_incoming_call()

 - microchip: vcap: fix initialization of value and mask

 - nfp: fix unaligned io read of capabilities word

Previous releases - regressions:

 - stop in-kernel socket users from corrupting socket's task_frag

 - stream: purge sk_error_queue in sk_stream_kill_queues()

 - openvswitch: fix flow lookup to use unmasked key

 - dsa: mv88e6xxx: avoid reg_lock deadlock in mv88e6xxx_setup_port()

 - devlink:
   - hold region lock when flushing snapshots
   - protect devlink dump by the instance lock

Previous releases - always broken:

 - bpf:
   - prevent leak of lsm program after failed attach
   - resolve fext program type when checking map compatibility

 - skbuff: account for tail adjustment during pull operations

 - macsec: fix net device access prior to holding a lock

 - bonding: switch back when high prio link up

 - netfilter: flowtable: really fix NAT IPv6 offload

 - enetc: avoid buffer leaks on xdp_do_redirect() failure

 - unix: fix race in SOCK_SEQPACKET's unix_dgram_sendmsg()

 - dsa: microchip: remove IRQF_TRIGGER_FALLING in request_threaded_irq

Signed-off-by: Jakub Kicinski <kuba@kernel.org>

----------------------------------------------------------------
Arnd Bergmann (1):
      net: ethernet: ti: am65-cpsw: fix CONFIG_PM #ifdef

Arun Ramadoss (1):
      net: dsa: microchip: remove IRQF_TRIGGER_FALLING in request_threaded_irq

Benjamin Coddington (2):
      Treewide: Stop corrupting socket's task_frag
      net: simplify sk_page_frag

Biju Das (1):
      ravb: Fix "failed to switch device to config mode" message during unbind

Christophe JAILLET (1):
      myri10ge: Fix an error handling path in myri10ge_probe()

Cong Wang (1):
      net_sched: reject TCF_EM_SIMPLE case for complex ematch module

Daniel Golle (1):
      net: dsa: mt7530: remove redundant assignment

David Howells (9):
      rxrpc: Fix missing unlock in rxrpc_do_sendmsg()
      rxrpc: Fix security setting propagation
      rxrpc: Fix NULL deref in rxrpc_unuse_local()
      rxrpc: Fix I/O thread startup getting skipped
      rxrpc: Fix locking issues in rxrpc_put_peer_locked()
      rxrpc: Fix switched parameters in peer tracing
      rxrpc: Fix I/O thread stop
      rxrpc: rxperf: Fix uninitialised variable
      rxrpc: Fix the return value of rxrpc_new_incoming_call()

David S. Miller (3):
      Merge branch 'devlink-fixes'
      Merge branch '1GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue
      Merge branch 'rxrpc-fixes'

Donald Hunter (1):
      docs/bpf: Reword docs for BPF_MAP_TYPE_SK_STORAGE

Eelco Chaudron (1):
      openvswitch: Fix flow lookup to use unmasked key

Emeel Hakim (1):
      net: macsec: fix net device access prior to holding a lock

Eric Dumazet (1):
      net: stream: purge sk_error_queue in sk_stream_kill_queues()

Gaosheng Cui (1):
      net: stmmac: fix errno when create_singlethread_workqueue() fails

Guillaume Nault (1):
      net: Introduce sk_use_task_frag in struct sock.

Haibo Chen (1):
      can: flexcan: avoid unbalanced pm_runtime_enable warning

Hangbin Liu (2):
      bonding: add missed __rcu annotation for curr_active_slave
      bonding: do failover when high prio link up

Horatiu Vultur (1):
      net: microchip: vcap: Fix initialization of value and mask

Huanhuan Wang (1):
      nfp: fix unaligned io read of capabilities word

Jakub Kicinski (10):
      Merge branch 'bonding-fix-high-prio-not-effect-issue'
      Merge branch 'misdn-don-t-call-dev_kfree_skb-kfree_skb-under-spin_lock_irqsave'
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf
      devlink: hold region lock when flushing snapshots
      selftests: devlink: fix the fd redirect in dummy_reporter_test
      selftests: devlink: add a warning for interfaces coming up
      Merge tag 'for-netdev' of https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf
      devlink: protect devlink dump by the instance lock
      Merge branch 'stop-corrupting-socket-s-task_frag'
      Merge tag 'linux-can-fixes-for-6.2-20221219' of git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can

Jeremy Kerr (1):
      mctp: serial: Fix starting value for frame check sequence

Jiri Olsa (1):
      bpf: Synchronize dispatcher update with bpf_dispatcher_xdp_func

Jiri Slaby (SUSE) (1):
      wireguard: timers: cast enum limits members to int in prints

Kirill Tkhai (1):
      unix: Fix race in SOCK_SEQPACKET's unix_dgram_sendmsg()

Li Qiong (1):
      ipvs: add a 'default' case in do_ip_vs_set_ctl()

Li Zetao (1):
      r6040: Fix kmemleak in probe and remove

Liang Li (1):
      selftests: bonding: add bonding prio option test

Marc Kleine-Budde (1):
      can: kvaser_usb: hydra: help gcc-13 to figure out cmd_len

Matt Johnston (1):
      mctp: Remove device type check at unregister

Milan Landaverde (1):
      bpf: prevent leak of lsm program after failed attach

Minsuk Kang (1):
      nfc: pn533: Clear nfc_target before being used

Muhammad Husaini Zulkifli (1):
      igc: Add checking for basetime less than zero

Qingfang DENG (1):
      netfilter: flowtable: really fix NAT IPv6 offload

Song Liu (1):
      selftests/bpf: Select CONFIG_FUNCTION_ERROR_INJECTION

Sriram Yagnaraman (1):
      netfilter: conntrack: document sctp timeouts

Subash Abhinov Kasiviswanathan (1):
      skbuff: Account for tail adjustment during pull operations

Tan Tee Min (3):
      igc: allow BaseTime 0 enrollment for Qbv
      igc: recalculate Qbv end_time by considering cycle time
      igc: Set Qbv start_time and end_time to end_time if not being configured in GCL

Toke Høiland-Jørgensen (2):
      bpf: Resolve fext program type when checking map compatibility
      selftests/bpf: Add a test for using a cpumap from an freplace-to-XDP program

Tony Nguyen (1):
      igb: Initialize mailbox message for VF reset

Vincent Mailhol (1):
      Documentation: devlink: add missing toc entry for etas_es58x devlink doc

Vinicius Costa Gomes (2):
      igc: Enhance Qbv scheduling by using first flag bit
      igc: Use strict cycles for Qbv scheduling

Vladimir Oltean (2):
      net: enetc: avoid buffer leaks on xdp_do_redirect() failure
      net: dsa: mv88e6xxx: avoid reg_lock deadlock in mv88e6xxx_setup_port()

Wei Fang (1):
      net: fec: check the return value of build_skb()

Yang Yingliang (3):
      mISDN: hfcsusb: don't call dev_kfree_skb/kfree_skb() under spin_lock_irqsave()
      mISDN: hfcpci: don't call dev_kfree_skb/kfree_skb() under spin_lock_irqsave()
      mISDN: hfcmulti: don't call dev_kfree_skb/kfree_skb() under spin_lock_irqsave()

Yonghong Song (1):
      selftests/bpf: Fix a selftest compilation error with CONFIG_SMP=n

 Documentation/bpf/map_sk_storage.rst               |  56 ++---
 Documentation/networking/devlink/index.rst         |   1 +
 Documentation/networking/nf_conntrack-sysctl.rst   |  33 +++
 drivers/block/drbd/drbd_receiver.c                 |   3 +
 drivers/block/nbd.c                                |   1 +
 drivers/isdn/hardware/mISDN/hfcmulti.c             |  19 +-
 drivers/isdn/hardware/mISDN/hfcpci.c               |  13 +-
 drivers/isdn/hardware/mISDN/hfcsusb.c              |  12 +-
 drivers/net/bonding/bond_main.c                    |  24 +-
 drivers/net/can/flexcan/flexcan-core.c             |  12 +-
 drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c  |  33 ++-
 drivers/net/dsa/microchip/ksz_common.c             |   3 +-
 drivers/net/dsa/mt7530.c                           |   3 -
 drivers/net/dsa/mv88e6xxx/chip.c                   |   9 +-
 drivers/net/ethernet/freescale/enetc/enetc.c       |  35 +--
 drivers/net/ethernet/freescale/fec_main.c          |   8 +
 drivers/net/ethernet/intel/igb/igb_main.c          |   2 +-
 drivers/net/ethernet/intel/igc/igc.h               |   3 +
 drivers/net/ethernet/intel/igc/igc_defines.h       |   2 +
 drivers/net/ethernet/intel/igc/igc_main.c          | 210 +++++++++++++++---
 drivers/net/ethernet/intel/igc/igc_tsn.c           |  13 +-
 .../net/ethernet/microchip/vcap/vcap_api_debugfs.c |   2 +
 drivers/net/ethernet/myricom/myri10ge/myri10ge.c   |   1 +
 .../net/ethernet/netronome/nfp/nfp_net_common.c    |   2 +-
 drivers/net/ethernet/rdc/r6040.c                   |   5 +-
 drivers/net/ethernet/renesas/ravb_main.c           |   2 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |   1 +
 drivers/net/ethernet/ti/am65-cpsw-nuss.c           |   4 +-
 drivers/net/macsec.c                               |  34 +--
 drivers/net/mctp/mctp-serial.c                     |   6 +-
 drivers/net/wireguard/timers.c                     |   8 +-
 drivers/nfc/pn533/pn533.c                          |   4 +
 drivers/nvme/host/tcp.c                            |   1 +
 drivers/scsi/iscsi_tcp.c                           |   1 +
 drivers/usb/usbip/usbip_common.c                   |   1 +
 fs/cifs/connect.c                                  |   1 +
 fs/dlm/lowcomms.c                                  |   2 +
 fs/ocfs2/cluster/tcp.c                             |   1 +
 include/net/sock.h                                 |  10 +-
 include/trace/events/rxrpc.h                       |   2 +-
 kernel/bpf/core.c                                  |   5 +-
 kernel/bpf/dispatcher.c                            |   5 +
 kernel/bpf/syscall.c                               |   6 +-
 net/9p/trans_fd.c                                  |   1 +
 net/ceph/messenger.c                               |   1 +
 net/core/devlink.c                                 |   5 +
 net/core/skbuff.c                                  |   3 +
 net/core/sock.c                                    |   1 +
 net/core/stream.c                                  |   6 +
 net/mctp/device.c                                  |  14 +-
 net/netfilter/ipvs/ip_vs_ctl.c                     |   5 +
 net/netfilter/nf_flow_table_offload.c              |   6 +-
 net/openvswitch/datapath.c                         |  25 ++-
 net/rxrpc/ar-internal.h                            |   8 +-
 net/rxrpc/call_accept.c                            |  18 +-
 net/rxrpc/call_object.c                            |   1 +
 net/rxrpc/conn_client.c                            |   2 -
 net/rxrpc/io_thread.c                              |  10 +-
 net/rxrpc/local_object.c                           |   5 +-
 net/rxrpc/peer_event.c                             |  10 +-
 net/rxrpc/peer_object.c                            |  23 +-
 net/rxrpc/rxperf.c                                 |   2 +-
 net/rxrpc/security.c                               |   6 +-
 net/rxrpc/sendmsg.c                                |   2 +-
 net/sched/ematch.c                                 |   2 +
 net/sunrpc/xprtsock.c                              |   3 +
 net/unix/af_unix.c                                 |  11 +-
 net/xfrm/espintcp.c                                |   1 +
 tools/testing/selftests/bpf/config                 |   1 +
 .../selftests/bpf/prog_tests/fexit_bpf2bpf.c       |  48 ++++
 .../testing/selftests/bpf/progs/freplace_progmap.c |  24 ++
 tools/testing/selftests/bpf/progs/rcu_read_lock.c  |   8 +-
 .../selftests/bpf/progs/task_kfunc_failure.c       |   2 +-
 .../testing/selftests/drivers/net/bonding/Makefile |   3 +-
 .../selftests/drivers/net/bonding/option_prio.sh   | 245 +++++++++++++++++++++
 .../selftests/drivers/net/netdevsim/devlink.sh     |   4 +-
 .../drivers/net/netdevsim/devlink_trap.sh          |  13 ++
 77 files changed, 861 insertions(+), 257 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/freplace_progmap.c
 create mode 100755 tools/testing/selftests/drivers/net/bonding/option_prio.sh
