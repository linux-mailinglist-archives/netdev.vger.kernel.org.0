Return-Path: <netdev+bounces-11250-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AF7DA7322EA
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 00:57:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D2C921C20F20
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 22:57:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6F387464;
	Thu, 15 Jun 2023 22:57:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79477657
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 22:57:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB1B2C433C8;
	Thu, 15 Jun 2023 22:57:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686869837;
	bh=IYHov47zpNtK3EvkkUSglMjcqEvPSaRLMpVn9p7Mxog=;
	h=From:To:Cc:Subject:Date:From;
	b=HYACdSW8G5QNgik71LtbfX3YA9C0bEK0N+c2I/0gM3+qCQaXhFmYJ8VBzYsU5qQng
	 SeJVcCZTZeVBLsrWDb+MgO/JcnqdPXi0UmdGOpSLTyL9evH78UQezG2rHL/2DS7suw
	 vnlFutY99Tp07R/pb0NRw87VeHbAAzI43ocOTAaTtpora6X1pJtGiiv7ugw+V1wpB/
	 Z0VWM+Z3qwyXjTbhpctVO+EzqqlUpXJTuXm+AQBXsP4KipCj6xWDsLA2tf9D6ynGcD
	 K/pGWYV//SaIe4gD0w9XedFE5FUGELuhkuQHITVEx5U/7ShXitaKM9fmL60AhU3gjw
	 433bHiwLH3RlQ==
From: Jakub Kicinski <kuba@kernel.org>
To: torvalds@linux-foundation.org
Cc: kuba@kernel.org,
	davem@davemloft.net,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	pabeni@redhat.com
Subject: [GIT PULL] Networking for v6.4-rc7
Date: Thu, 15 Jun 2023 15:57:16 -0700
Message-Id: <20230615225716.1507720-1-kuba@kernel.org>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Linus!

The following changes since commit 25041a4c02c7cf774d8b6ed60586fd64f1cdaa81:

  Merge tag 'net-6.4-rc6' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2023-06-08 09:27:19 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git net-6.4-rc7

for you to fetch changes up to 8f0e3703571fe771d06235870ccbbf4ad41e63e8:

  Merge branch 'udplite-dccp-print-deprecation-notice' (2023-06-15 15:09:00 -0700)

----------------------------------------------------------------
Including fixes from wireless, and netfilter.

Selftests excluded - we have 58 patches and diff of +442/-199,
which isn't really small but perhaps with the exception of
the WiFi locking change it's old(ish) bugs.

We have no known problems with v6.4.

The selftest changes are rather large as MPTCP folks try to apply
Greg's guidance that selftest from torvalds/linux should be able
to run against stable kernels.

Last thing I should call out is the DCCP/UDP-lite deprecation notices,
we are fairly sure those are dead, but if we're wrong reverting them
back in won't be fun.

Current release - regressions:

 - wifi:
  - cfg80211: fix double lock bug in reg_wdev_chan_valid()
  - iwlwifi: mvm: spin_lock_bh() to fix lockdep regression

Current release - new code bugs:

 - handshake: remove fput() that causes use-after-free

Previous releases - regressions:

 - sched: cls_u32: fix reference counter leak leading to overflow

 - sched: cls_api: fix lockup on flushing explicitly created chain

Previous releases - always broken:

 - nf_tables: integrate pipapo into commit protocol

 - nf_tables: incorrect error path handling with NFT_MSG_NEWRULE,
   fix dangling pointer on failure

 - ping6: fix send to link-local addresses with VRF

 - sched: act_pedit: parse L3 header for L4 offset, the skb may
   not have the offset saved

 - sched: act_ct: fix promotion of offloaded unreplied tuple

 - sched: refuse to destroy an ingress and clsact Qdiscs if there
   are lockless change operations in flight

 - wifi: mac80211: fix handful of bugs in multi-link operation

 - ipvlan: fix bound dev checking for IPv6 l3s mode

 - eth: enetc: correct the indexes of highest and 2nd highest TCs

 - eth: ice: fix XDP memory leak when NIC is brought up and down

Misc:

 - add deprecation notices for UDP-lite and DCCP

 - selftests: mptcp: skip tests not supported by old kernels

 - sctp: handle invalid error codes without calling BUG()

Signed-off-by: Jakub Kicinski <kuba@kernel.org>

----------------------------------------------------------------
Ahmed Zaki (1):
      iavf: remove mask from iavf_irq_enable_queues()

Aleksandr Loktionov (1):
      igb: fix nvm.ops.read() error handling

Alex Maftei (1):
      selftests/ptp: Fix timestamp printf format for PTP_SYS_OFFSET

Benjamin Berg (3):
      wifi: cfg80211: fix link del callback to call correct handler
      wifi: mac80211: take lock before setting vif links
      wifi: mac80211: fragment per STA profile correctly

Christian Marangi (1):
      net: ethernet: stmicro: stmmac: fix possible memory leak in __stmmac_open

Dan Carpenter (4):
      wifi: cfg80211: fix double lock bug in reg_wdev_chan_valid()
      sctp: handle invalid error codes without calling BUG()
      sctp: fix an error code in sctp_sf_eat_auth()
      net: ethernet: ti: am65-cpsw: Call of_node_put() on error path

Danielle Ratson (1):
      selftests: forwarding: hw_stats_l3: Set addrgenmode in a separate step

David Christensen (1):
      bnx2x: fix page fault following EEH recovery

David S. Miller (2):
      Merge branch 'octeontx2-af-fixes'
      Merge tag 'nf-23-06-08' of git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf

Dmitry Mastykin (1):
      netlabel: fix shift wrapping bug in netlbl_catmap_setlong()

Eric Dumazet (1):
      net: lapbether: only support ethernet devices

Fedor Pchelkin (1):
      net: macsec: fix double free of percpu stats

Guillaume Nault (1):
      ping6: Fix send to link-local addresses with VRF.

Hangbin Liu (1):
      ipvlan: fix bound dev checking for IPv6 l3s mode

Hugh Dickins (1):
      wifi: iwlwifi: mvm: spin_lock_bh() to fix lockdep regression

Ilan Peer (1):
      wifi: mac80211: Use active_links instead of valid_links in Tx

Jakub Buchocki (1):
      ice: Fix ice module unload

Jakub Kicinski (9):
      Merge branch 'selftests-mptcp-skip-tests-not-supported-by-old-kernels-part-2'
      Merge branch '100GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue
      net: ethtool: correct MAX attribute value for stats
      Merge branch 'fixes-for-q-usgmii-speeds-and-autoneg'
      Merge branch 'mptcp-fixes'
      Merge branch 'fix-small-bugs-and-annoyances-in-tc-testing'
      Merge tag 'wireless-2023-06-14' of git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless
      Merge branch '1GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue
      Merge branch 'udplite-dccp-print-deprecation-notice'

Jan Karcher (1):
      MAINTAINERS: add reviewers for SMC Sockets

Jiasheng Jiang (1):
      octeon_ep: Add missing check for ioremap

Johannes Berg (2):
      wifi: mac80211: fix link activation settings order
      wifi: cfg80211: remove links only on AP

Julian Ruess (1):
      s390/ism: Fix trying to free already-freed IRQ by repeated ism_dev_exit()

Kamil Maziarz (1):
      ice: Fix XDP memory leak when NIC is brought up and down

Kuniyuki Iwashima (2):
      udplite: Print deprecation notice.
      dccp: Print deprecation notice.

Lee Jones (1):
      net/sched: cls_u32: Fix reference counter leak leading to overflow

Lin Ma (2):
      net/handshake: remove fput() that causes use-after-free
      net: tipc: resize nlattr array to correct size

Matthieu Baerts (31):
      selftests: mptcp: lib: skip if missing symbol
      selftests: mptcp: connect: skip transp tests if not supported
      selftests: mptcp: connect: skip disconnect tests if not supported
      selftests: mptcp: connect: skip TFO tests if not supported
      selftests: mptcp: diag: skip listen tests if not supported
      selftests: mptcp: diag: skip inuse tests if not supported
      selftests: mptcp: pm nl: remove hardcoded default limits
      selftests: mptcp: pm nl: skip fullmesh flag checks if not supported
      selftests: mptcp: sockopt: relax expected returned size
      selftests: mptcp: sockopt: skip getsockopt checks if not supported
      selftests: mptcp: sockopt: skip TCP_INQ checks if not supported
      selftests: mptcp: userspace pm: skip if 'ip' tool is unavailable
      selftests: mptcp: userspace pm: skip if not supported
      selftests: mptcp: userspace pm: skip PM listener events tests if unavailable
      selftests: mptcp: lib: skip if not below kernel version
      selftests: mptcp: join: use 'iptables-legacy' if available
      selftests: mptcp: join: helpers to skip tests
      selftests: mptcp: join: skip check if MIB counter not supported
      selftests: mptcp: join: skip test if iptables/tc cmds fail
      selftests: mptcp: join: support local endpoint being tracked or not
      selftests: mptcp: join: skip Fastclose tests if not supported
      selftests: mptcp: join: support RM_ADDR for used endpoints or not
      selftests: mptcp: join: skip implicit tests if not supported
      selftests: mptcp: join: skip backup if set flag on ID not supported
      selftests: mptcp: join: skip fullmesh flag tests if not supported
      selftests: mptcp: join: skip userspace PM tests if not supported
      selftests: mptcp: join: skip fail tests if not supported
      selftests: mptcp: join: skip MPC backups tests if not supported
      selftests: mptcp: join: skip PM listener tests if not supported
      selftests: mptcp: join: uniform listener tests
      selftests: mptcp: join: skip mixed tests if not supported

Max Tottenham (1):
      net/sched: act_pedit: Parse L3 Header for L4 offset

Maxime Chevallier (2):
      net: phylink: report correct max speed for QUSGMII
      net: phylink: use a dedicated helper to parse usgmii control word

Muhammad Husaini Zulkifli (1):
      igc: Clean the TX buffer and TX descriptor ring

Nithin Dabilpuram (1):
      octeontx2-af: fix lbk link credits on cn10k

Pablo Neira Ayuso (3):
      netfilter: nf_tables: integrate pipapo into commit protocol
      netfilter: nfnetlink: skip error delivery on batch in case of ENOMEM
      netfilter: nf_tables: incorrect error path handling with NFT_MSG_NEWRULE

Paolo Abeni (1):
      Merge branch 'net-sched-fix-race-conditions-in-mini_qdisc_pair_swap'

Paul Blakey (1):
      net/sched: act_ct: Fix promotion of offloaded unreplied tuple

Peilin Ye (2):
      net/sched: Refactor qdisc_graft() for ingress and clsact Qdiscs
      net/sched: qdisc_destroy() old ingress and clsact Qdiscs before grafting

Ratheesh Kannoth (1):
      octeontx2-af: Fix promiscuous mode

Satha Rao (1):
      octeontx2-af: fixed resource availability check

Simon Horman (1):
      ice: Don't dereference NULL in ice_gnss_read error path

Vinicius Costa Gomes (1):
      igc: Fix possible system crash when loading module

Vlad Buslov (5):
      selftests/tc-testing: Fix Error: Specified qdisc kind is unknown.
      selftests/tc-testing: Fix Error: failed to find target LOG
      selftests/tc-testing: Fix SFB db test
      selftests/tc-testing: Remove configs that no longer exist
      net/sched: cls_api: Fix lockup on flushing explicitly created chain

Vladimir Oltean (1):
      net: dsa: felix: fix taprio guard band overflow at 10Mbps with jumbo frames

Wei Fang (1):
      net: enetc: correct the indexes of highest and 2nd highest TCs

Wes Huang (1):
      net: usb: qmi_wwan: add support for Compal RXM-G1

Yoshihiro Shimoda (1):
      net: renesas: rswitch: Fix timestamp feature after all descriptors are used

Yuezhen Luan (1):
      igb: Fix extts capture value format for 82580/i354/i350

Zhengchao Shao (1):
      net/sched: taprio: fix slab-out-of-bounds Read in taprio_dequeue_from_txq

Íñigo Huguet (1):
      sfc: fix XDP queues mode with legacy IRQ

 MAINTAINERS                                        |   3 +
 drivers/net/dsa/ocelot/felix_vsc9959.c             |   2 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c   |   9 +-
 drivers/net/ethernet/freescale/enetc/enetc_qos.c   |   4 +-
 drivers/net/ethernet/intel/iavf/iavf.h             |   2 +-
 drivers/net/ethernet/intel/iavf/iavf_main.c        |  15 +-
 drivers/net/ethernet/intel/iavf/iavf_register.h    |   2 +-
 drivers/net/ethernet/intel/ice/ice_gnss.c          |   8 +-
 drivers/net/ethernet/intel/ice/ice_main.c          |  20 +-
 drivers/net/ethernet/intel/igb/igb_ethtool.c       |   3 +
 drivers/net/ethernet/intel/igb/igb_main.c          |   8 +-
 drivers/net/ethernet/intel/igc/igc_main.c          |  12 +-
 .../net/ethernet/marvell/octeon_ep/octep_main.c    |   7 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    |   7 +-
 .../ethernet/marvell/octeontx2/af/rvu_npc_hash.c   |  29 +-
 drivers/net/ethernet/renesas/rswitch.c             |  36 +-
 drivers/net/ethernet/sfc/efx_channels.c            |   2 +
 drivers/net/ethernet/sfc/siena/efx_channels.c      |   2 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |   9 +-
 drivers/net/ethernet/ti/am65-cpsw-nuss.c           |   2 +-
 drivers/net/ipvlan/ipvlan_l3s.c                    |   4 +
 drivers/net/macsec.c                               |  12 +-
 drivers/net/phy/phylink.c                          |  41 +-
 drivers/net/usb/qmi_wwan.c                         |   2 +
 drivers/net/wan/lapbether.c                        |   3 +
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c        |  12 +-
 drivers/s390/net/ism_drv.c                         |   8 -
 include/net/netfilter/nf_flow_table.h              |   2 +-
 include/net/netfilter/nf_tables.h                  |   4 +-
 include/net/sch_generic.h                          |   8 +
 include/uapi/linux/ethtool_netlink.h               |   2 +-
 net/dccp/proto.c                                   |   3 +
 net/handshake/handshake.h                          |   1 -
 net/handshake/request.c                            |   4 -
 net/ipv4/udplite.c                                 |   2 +
 net/ipv6/ping.c                                    |   3 +-
 net/ipv6/udplite.c                                 |   4 +
 net/mac80211/cfg.c                                 |   9 +-
 net/mac80211/ieee80211_i.h                         |   2 +-
 net/mac80211/link.c                                |   4 +-
 net/mac80211/mlme.c                                |   5 +-
 net/mac80211/tx.c                                  |   6 +-
 net/mac80211/util.c                                |   4 +-
 net/netfilter/nf_flow_table_core.c                 |  13 +-
 net/netfilter/nf_flow_table_ip.c                   |   4 +-
 net/netfilter/nf_tables_api.c                      |  59 ++-
 net/netfilter/nfnetlink.c                          |   3 +-
 net/netfilter/nft_set_pipapo.c                     |  55 ++-
 net/netlabel/netlabel_kapi.c                       |   3 +-
 net/sched/act_ct.c                                 |   9 +-
 net/sched/act_pedit.c                              |  48 +-
 net/sched/cls_api.c                                |  12 +-
 net/sched/cls_u32.c                                |  18 +-
 net/sched/sch_api.c                                |  44 +-
 net/sched/sch_generic.c                            |  14 +-
 net/sched/sch_taprio.c                             |   3 +
 net/sctp/sm_sideeffect.c                           |   5 +-
 net/sctp/sm_statefuns.c                            |   2 +-
 net/tipc/bearer.c                                  |   4 +-
 net/wireless/rdev-ops.h                            |   6 +-
 net/wireless/reg.c                                 |   3 -
 net/wireless/util.c                                |   9 +-
 .../selftests/net/forwarding/hw_stats_l3.sh        |  11 +-
 tools/testing/selftests/net/mptcp/config           |   1 +
 tools/testing/selftests/net/mptcp/diag.sh          |  42 +-
 tools/testing/selftests/net/mptcp/mptcp_connect.sh |  20 +
 tools/testing/selftests/net/mptcp/mptcp_join.sh    | 513 +++++++++++++--------
 tools/testing/selftests/net/mptcp/mptcp_lib.sh     |  64 +++
 tools/testing/selftests/net/mptcp/mptcp_sockopt.c  |  18 +-
 tools/testing/selftests/net/mptcp/mptcp_sockopt.sh |  20 +-
 tools/testing/selftests/net/mptcp/pm_netlink.sh    |  27 +-
 tools/testing/selftests/net/mptcp/userspace_pm.sh  |  13 +-
 tools/testing/selftests/ptp/testptp.c              |   6 +-
 tools/testing/selftests/tc-testing/config          |   6 +-
 .../selftests/tc-testing/tc-tests/qdiscs/sfb.json  |   4 +-
 tools/testing/selftests/tc-testing/tdc.sh          |   1 +
 76 files changed, 945 insertions(+), 442 deletions(-)

