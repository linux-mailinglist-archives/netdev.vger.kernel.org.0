Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B5FB29F580
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 20:43:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726156AbgJ2Tnj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 15:43:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:56380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725948AbgJ2Tnj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Oct 2020 15:43:39 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4D46F20782;
        Thu, 29 Oct 2020 19:43:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604000617;
        bh=h3MleAy+1i2eMRVMC5aKx7VQAHzPoDk2AMn0XlSZBZY=;
        h=Date:From:To:Cc:Subject:From;
        b=vjfObC9WXk9Tesv8y8OWMIHzvLU10Mbvqe+c+mQtsYn1yQ2tVAm8yQiFTmvDbQFF2
         uF1QLvpKsrX+KXWZm+qJ6akObbqG2+J6UmkgVI0uSEFEW+r79r8mNjuhkTVA2zIUxk
         FzCTMrhyTIyJ18jhq9G+2hkhZKkJa12viWmMzQuw=
Date:   Thu, 29 Oct 2020 12:43:35 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Networking
Message-ID: <20201029124335.2886a2bf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following changes since commit 3cb12d27ff655e57e8efe3486dca2a22f4e30578:

  Merge tag 'net-5.10-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2020-10-23 12:05:49 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.10-rc2

for you to fetch changes up to 2734a24e6e5d18522fbf599135c59b82ec9b2c9e:

  r8169: fix issue with forced threading in combination with shared interrupts (2020-10-29 11:49:04 -0700)

----------------------------------------------------------------
Networking fixes for 5.10-rc2.

Current release regressions:

 - r8169: fix forced threading conflicting with other shared
   interrupts; we tried to fix the use of raise_softirq_irqoff
   from an IRQ handler on RT by forcing hard irqs, but this
   driver shares legacy PCI IRQs so drop the _irqoff() instead

 - tipc: fix memory leak caused by a recent syzbot report fix
   to tipc_buf_append()

Current release - bugs in new features:

 - devlink: Unlock on error in dumpit() and fix some error codes

 - net/smc: fix null pointer dereference in smc_listen_decline()

Previous release - regressions:

 - tcp: Prevent low rmem stalls with SO_RCVLOWAT.

 - net: protect tcf_block_unbind with block lock

 - ibmveth: Fix use of ibmveth in a bridge; the self-imposed filtering
   to only send legal frames to the hypervisor was too strict

 - net: hns3: Clear the CMDQ registers before unmapping BAR region;
   incorrect cleanup order was leading to a crash

 - bnxt_en - handful of fixes to fixes:
    - Send HWRM_FUNC_RESET fw command unconditionally, even
      if there are PCIe errors being reported
    - Check abort error state in bnxt_open_nic().
    - Invoke cancel_delayed_work_sync() for PFs also.
    - Fix regression in workqueue cleanup logic in bnxt_remove_one().

 - mlxsw: Only advertise link modes supported by both driver
   and device, after removal of 56G support from the driver
   56G was not cleared from advertised modes

 - net/smc: fix suppressed return code

Previous release - always broken:

 - netem: fix zero division in tabledist, caused by integer overflow

 - bnxt_en: Re-write PCI BARs after PCI fatal error.

 - cxgb4: set up filter action after rewrites

 - net: ipa: command payloads already mapped

Misc:

 - s390/ism: fix incorrect system EID, it's okay to change since
   it was added in current release

 - vsock: use ns_capable_noaudit() on socket create to suppress
   false positive audit messages

Signed-off-by: Jakub Kicinski <kuba@kernel.org>

----------------------------------------------------------------
Aleksandr Nogikh (1):
      netem: fix zero division in tabledist

Alex Elder (1):
      net: ipa: command payloads already mapped

Amit Cohen (2):
      mlxsw: Only advertise link modes supported by both driver and device
      mlxsw: core: Fix use-after-free in mlxsw_emad_trans_finish()

Andrew Gabbasov (1):
      ravb: Fix bit fields checking in ravb_hwtstamp_get()

Arjun Roy (1):
      tcp: Prevent low rmem stalls with SO_RCVLOWAT.

Dan Carpenter (3):
      net: hns3: clean up a return in hclge_tm_bp_setup()
      devlink: Fix some error codes
      devlink: Unlock on error in dumpit()

Guillaume Nault (1):
      net/sched: act_mpls: Add softdep on mpls_gso.ko

Heiner Kallweit (1):
      r8169: fix issue with forced threading in combination with shared interrupts

Ido Schimmel (1):
      mlxsw: core: Fix memory leak on module removal

Jakub Kicinski (4):
      Merge branch 'ionic-memory-usage-fixes'
      Merge branch 'net-smc-fixes-2020-10-23'
      Merge branch 'mlxsw-various-fixes'
      Merge branch 'bnxt_en-bug-fixes'

Jeff Vander Stoep (1):
      vsock: use ns_capable_noaudit() on socket create

Karsten Graul (3):
      net/smc: fix null pointer dereference in smc_listen_decline()
      net/smc: fix suppressed return code
      s390/ism: fix incorrect system EID

Leon Romanovsky (1):
      net: protect tcf_block_unbind with block lock

Lijun Pan (1):
      ibmvnic: fix ibmvnic_set_mac

Masahiro Fujiwara (1):
      gtp: fix an use-before-init in gtp_newlink()

Michael Chan (1):
      bnxt_en: Check abort error state in bnxt_open_nic().

Michael Ellerman (1):
      net: ucc_geth: Drop extraneous parentheses in comparison

Paolo Abeni (1):
      mptcp: add missing memory scheduling in the rx path

Raju Rangoju (1):
      cxgb4: set up filter action after rewrites

Shannon Nelson (3):
      ionic: clean up sparse complaints
      ionic: no rx flush in deinit
      ionic: fix mem leak in rx_empty

Thomas Bogendoerfer (1):
      ibmveth: Fix use of ibmveth in a bridge.

Tung Nguyen (1):
      tipc: fix memory leak caused by tipc_buf_append()

Vasundhara Volam (4):
      bnxt_en: Fix regression in workqueue cleanup logic in bnxt_remove_one().
      bnxt_en: Invoke cancel_delayed_work_sync() for PFs also.
      bnxt_en: Re-write PCI BARs after PCI fatal error.
      bnxt_en: Send HWRM_FUNC_RESET fw command unconditionally.

Vinay Kumar Yadav (3):
      chelsio/chtls: fix tls record info to user
      chelsio/chtls: fix deadlock issue
      chelsio/chtls: fix memory leaks in CPL handlers

Zenghui Yu (1):
      net: hns3: Clear the CMDQ registers before unmapping BAR region

 drivers/net/ethernet/broadcom/bnxt/bnxt.c          | 49 ++++++++++++-------
 drivers/net/ethernet/broadcom/bnxt/bnxt.h          |  1 +
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c  | 56 +++++++++++-----------
 drivers/net/ethernet/chelsio/cxgb4/t4_tcb.h        |  4 ++
 .../chelsio/inline_crypto/chtls/chtls_cm.c         | 29 +++++------
 .../chelsio/inline_crypto/chtls/chtls_io.c         |  7 ++-
 drivers/net/ethernet/freescale/ucc_geth.c          |  2 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c  |  2 +-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |  2 +-
 drivers/net/ethernet/ibm/ibmveth.c                 |  6 ---
 drivers/net/ethernet/ibm/ibmvnic.c                 |  8 +++-
 drivers/net/ethernet/mellanox/mlxsw/core.c         |  5 ++
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c     |  9 +++-
 drivers/net/ethernet/mellanox/mlxsw/spectrum.h     |  1 +
 .../net/ethernet/mellanox/mlxsw/spectrum_ethtool.c | 30 ++++++++++++
 drivers/net/ethernet/pensando/ionic/ionic_dev.c    |  4 +-
 drivers/net/ethernet/pensando/ionic/ionic_dev.h    |  2 +
 drivers/net/ethernet/pensando/ionic/ionic_fw.c     |  6 +--
 drivers/net/ethernet/pensando/ionic/ionic_lif.c    | 29 ++++++-----
 drivers/net/ethernet/pensando/ionic/ionic_main.c   |  4 +-
 drivers/net/ethernet/pensando/ionic/ionic_stats.h  |  2 +-
 drivers/net/ethernet/pensando/ionic/ionic_txrx.c   | 47 +++++++-----------
 drivers/net/ethernet/pensando/ionic/ionic_txrx.h   |  1 -
 drivers/net/ethernet/realtek/r8169_main.c          |  4 +-
 drivers/net/ethernet/renesas/ravb_main.c           | 10 ++--
 drivers/net/gtp.c                                  | 16 +++----
 drivers/net/ipa/gsi_trans.c                        | 21 +++++---
 drivers/s390/net/ism_drv.c                         |  2 +-
 net/core/devlink.c                                 | 30 +++++++-----
 net/ipv4/tcp.c                                     |  2 +
 net/ipv4/tcp_input.c                               |  3 +-
 net/mptcp/protocol.c                               | 10 ++++
 net/sched/act_mpls.c                               |  1 +
 net/sched/cls_api.c                                |  4 +-
 net/sched/sch_netem.c                              |  9 +++-
 net/smc/af_smc.c                                   |  7 +--
 net/smc/smc_core.c                                 |  7 ++-
 net/tipc/msg.c                                     |  5 +-
 net/vmw_vsock/af_vsock.c                           |  2 +-
 39 files changed, 261 insertions(+), 178 deletions(-)
