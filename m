Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D381B2F6BC9
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 21:09:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730466AbhANUGe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 15:06:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:37410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727560AbhANUGd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Jan 2021 15:06:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E576A22DFA;
        Thu, 14 Jan 2021 20:05:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610654752;
        bh=wob9sN21sFhiGllCBbiibV5Ik888Gr008rmHdO5CDgs=;
        h=From:To:Cc:Subject:Date:From;
        b=W7gOtDh94KaVfK/9VwP9WYYFL9kDHlebWjyVp2ZkGR+ywTTgBDUOE1XGNUNu4BGHK
         s8ahLdJUUmaiwp2wKUejkHKE+PNMK6N4NXbWf8CmnGnN7A1NIRzbYnBSLbj365TvKn
         0LKsp8qJiFFoHVqmh8D7EiEf+rVqDBR+begDYwpcRHhITmt4n0Vy6ay70F070AX8eb
         /7zWYy4Igb2smG3zw1qrRmuqVHcwX/LA1xMsAA9nUXy723vStwzK0LdOQhGtbgCu2j
         +nWBxI7xG9YoIllSyXlPSzHmjykExRjmlWGXg3VH8y/dm0jj8LNk+dT2ddA0OohaD4
         qzUHuYglbMuoQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     torvalds@linux-foundation.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Networking for 5.11-rc4
Date:   Thu, 14 Jan 2021 12:05:51 -0800
Message-Id: <20210114200551.208209-1-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

We have a few fixes for long standing issues, in particular
Eric's fix to not underestimate the skb sizes, and my fix for
brokenness of register_netdevice() error path. They may uncover
other bugs so we will keep an eye on them. Also included are
Willem's fixes for kmap(_atomic).

Looking at the "current release" fixes, it seems we are about
one rc behind a normal cycle. We've previously seen an uptick
of "people had run their test suites" / "humans actually tried 
to use new features" fixes between rc2 and rc3.

The following changes since commit 6279d812eab67a6df6b22fa495201db6f2305924:

  Merge tag 'net-5.11-rc3-2' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2021-01-08 12:12:30 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.11-rc4

for you to fetch changes up to 13a9499e833387fcc7a53915bbe5cddf3c336b59:

  mptcp: fix locking in mptcp_disconnect() (2021-01-14 11:25:21 -0800)

----------------------------------------------------------------
Networking fixes for 5.11-rc4, including fixes from can and netfilter.

Current release - regressions:

 - fix feature enforcement to allow NETIF_F_HW_TLS_TX
   if IP_CSUM && IPV6_CSUM

 - dcb: accept RTM_GETDCB messages carrying set-like DCB commands
        if user is admin for backward-compatibility

 - selftests/tls: fix selftests build after adding ChaCha20-Poly1305

Current release - always broken:

 - ppp: fix refcount underflow on channel unbridge

 - bnxt_en: clear DEFRAG flag in firmware message when retry flashing

 - smc: fix out of bound access in the new netlink interface

Previous releases - regressions:

 - fix use-after-free with UDP GRO by frags

 - mptcp: better msk-level shutdown

 - rndis_host: set proper input size for OID_GEN_PHYSICAL_MEDIUM request

 - i40e: xsk: fix potential NULL pointer dereferencing

Previous releases - always broken:

 - skb frag: kmap_atomic fixes

 - avoid 32 x truesize under-estimation for tiny skbs

 - fix issues around register_netdevice() failures

 - udp: prevent reuseport_select_sock from reading uninitialized socks

 - dsa: unbind all switches from tree when DSA master unbinds

 - dsa: clear devlink port type before unregistering slave netdevs

 - can: isotp: isotp_getname(): fix kernel information leak

 - mlxsw: core: Thermal control fixes

 - ipv6: validate GSO SKB against MTU before finish IPv6 processing

 - stmmac: use __napi_schedule() for PREEMPT_RT

 - net: mvpp2: remove Pause and Asym_Pause support

Misc:

 - remove from MAINTAINERS folks who had been inactive for >5yrs

Signed-off-by: Jakub Kicinski <kuba@kernel.org>

----------------------------------------------------------------
Andrey Zhizhikin (1):
      rndis_host: set proper input size for OID_GEN_PHYSICAL_MEDIUM request

Aya Levin (1):
      net: ipv6: Validate GSO SKB before finish IPv6 processing

Ayush Sawal (1):
      cxgb4/chtls: Fix tid stuck due to wrong update of qid

Baptiste Lepers (2):
      udp: Prevent reuseport_select_sock from reading uninitialized socks
      rxrpc: Call state should be read with READ_ONCE() under some circumstances

Chen Yi (1):
      selftests: netfilter: Pass family parameter "-f" to conntrack tool

Cristian Dumitrescu (1):
      i40e: fix potential NULL pointer dereferencing

David Howells (1):
      rxrpc: Fix handling of an unsupported token type in rxrpc_read()

David Wu (1):
      net: stmmac: Fixed mtu channged by cache aligned

Dinghao Liu (1):
      netfilter: nf_nat: Fix memleak in nf_nat_init

Dongseok Yi (1):
      net: fix use-after-free when UDP GRO with shared fraglist

Eric Dumazet (1):
      net: avoid 32 x truesize under-estimation for tiny skbs

Geert Uytterhoeven (2):
      dt-bindings: net: renesas,etheravb: RZ/G2H needs tx-internal-delay-ps
      nt: usb: USB_RTL8153_ECM should not default to y

Guvenc Gulce (1):
      net/smc: use memcpy instead of snprintf to avoid out of bounds read

Hoang Le (1):
      tipc: fix NULL deref in tipc_link_xmit()

Jakub Kicinski (21):
      docs: net: explain struct net_device lifetime
      net: make free_netdev() more lenient with unregistering devices
      net: make sure devices go through netdev_wait_all_refs
      Merge branch 'net-fix-issues-around-register_netdevice-failures'
      Merge branch 'mlxsw-core-thermal-control-fixes'
      Merge branch 'skb-frag-kmap_atomic-fixes'
      Merge branch 'bnxt_en-bug-fixes'
      Merge branch 'mptcp-a-couple-of-fixes'
      smc: fix out of bound access in smc_nl_get_sys_info()
      Merge branch 'net-smc-fix-out-of-bound-access-in-netlink-interface'
      Merge git://git.kernel.org/.../pablo/nf
      Merge tag 'linux-can-fixes-for-5.11-20210113' of git://git.kernel.org/.../mkl/linux-can
      net: sit: unregister_netdevice on newlink's error path
      MAINTAINERS: altx: move Jay Cliburn to CREDITS
      MAINTAINERS: net: move Alexey Kuznetsov to CREDITS
      MAINTAINERS: vrf: move Shrijeet to CREDITS
      MAINTAINERS: ena: remove Zorik Machulsky from reviewers
      MAINTAINERS: tls: move Aviad to CREDITS
      MAINTAINERS: ipvs: move Wensong Zhang to CREDITS
      MAINTAINERS: dccp: move Gerrit Renker to CREDITS
      Merge branch 'maintainers-remove-inactive-folks-from-networking'

Jesper Dangaard Brouer (1):
      netfilter: conntrack: fix reading nf_conntrack_buckets

Leon Schuermann (2):
      r8152: Add Lenovo Powered USB-C Travel Hub
      r8153_ecm: Add Lenovo Powered USB-C Hub as a fallback of r8152

Manish Chopra (1):
      netxen_nic: fix MSI/MSI-x interrupts

Marco Felsch (1):
      net: phy: smsc: fix clk error handling

Mauro Carvalho Chehab (1):
      net: tip: fix a couple kernel-doc markups

Michael Chan (1):
      bnxt_en: Improve stats context resource accounting with RDMA driver loaded.

Oliver Hartkopp (1):
      can: isotp: isotp_getname(): fix kernel information leak

Paolo Abeni (3):
      mptcp: more strict state checking for acks
      mptcp: better msk-level shutdown.
      mptcp: fix locking in mptcp_disconnect()

Pavan Chebbi (1):
      bnxt_en: Clear DEFRAG flag in firmware message when retry flashing.

Petr Machata (1):
      net: dcb: Accept RTM_GETDCB messages carrying set-like DCB commands

Qinglang Miao (1):
      can: mcp251xfd: mcp251xfd_handle_rxif_one(): fix wrong NULL pointer check

Seb Laveze (2):
      dt-bindings: net: dwmac: fix queue priority documentation
      net: stmmac: use __napi_schedule() for PREEMPT_RT

Stefan Chulski (1):
      net: mvpp2: Remove Pause and Asym_Pause support

Stephan Gerhold (1):
      net: ipa: modem: add missing SET_NETDEV_DEV() for proper sysfs links

Tariq Toukan (1):
      net: Allow NETIF_F_HW_TLS_TX if IP_CSUM && IPV6_CSUM

Tom Parkin (1):
      ppp: fix refcount underflow on channel unbridge

Vadim Fedorenko (1):
      selftests/tls: fix selftests after adding ChaCha20-Poly1305

Vadim Pasternak (2):
      mlxsw: core: Add validation of transceiver temperature thresholds
      mlxsw: core: Increase critical threshold for ASIC thermal zone

Vladimir Oltean (2):
      net: dsa: unbind all switches from tree when DSA master unbinds
      net: dsa: clear devlink port type before unregistering slave netdevs

Willem de Bruijn (3):
      net: support kmap_local forced debugging in skb_frag_foreach
      net: compound page support in skb_seq_read
      esp: avoid unneeded kmap_atomic call

Yannick Vignon (2):
      net: stmmac: fix taprio schedule configuration
      net: stmmac: fix taprio configuration when base_time is in the past

 CREDITS                                            |  24 +++
 .../devicetree/bindings/net/renesas,etheravb.yaml  |   1 +
 .../devicetree/bindings/net/snps,dwmac.yaml        |   8 +-
 Documentation/networking/netdevices.rst            | 171 ++++++++++++++++++++-
 Documentation/networking/tls-offload.rst           |   2 +-
 MAINTAINERS                                        |   9 +-
 drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c     |   2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c  |   3 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c      |   8 +-
 drivers/net/ethernet/chelsio/cxgb4/t4_tcb.h        |   7 +
 .../ethernet/chelsio/inline_crypto/chtls/chtls.h   |   4 +
 .../chelsio/inline_crypto/chtls/chtls_cm.c         |  32 +++-
 .../chelsio/inline_crypto/chtls/chtls_hw.c         |  41 +++++
 drivers/net/ethernet/intel/i40e/i40e_xsk.c         |   2 +-
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c    |   2 -
 drivers/net/ethernet/mellanox/mlxsw/core_thermal.c |  13 +-
 .../net/ethernet/qlogic/netxen/netxen_nic_main.c   |   7 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac5.c       |  52 +------
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |   7 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c    |  20 ++-
 drivers/net/ipa/ipa_modem.c                        |   1 +
 drivers/net/phy/smsc.c                             |   3 +-
 drivers/net/ppp/ppp_generic.c                      |  12 +-
 drivers/net/usb/Kconfig                            |   1 -
 drivers/net/usb/cdc_ether.c                        |   7 +
 drivers/net/usb/r8152.c                            |   1 +
 drivers/net/usb/r8153_ecm.c                        |   8 +
 drivers/net/usb/rndis_host.c                       |   2 +-
 include/linux/skbuff.h                             |   3 +-
 net/8021q/vlan.c                                   |   4 +-
 net/can/isotp.c                                    |   1 +
 net/core/dev.c                                     |  37 +++--
 net/core/rtnetlink.c                               |  23 +--
 net/core/skbuff.c                                  |  57 ++++++-
 net/core/sock_reuseport.c                          |   2 +-
 net/dcb/dcbnl.c                                    |   2 +-
 net/dsa/dsa2.c                                     |   4 +
 net/dsa/master.c                                   |  10 ++
 net/ipv4/esp4.c                                    |   7 +-
 net/ipv6/esp6.c                                    |   7 +-
 net/ipv6/ip6_output.c                              |  41 ++++-
 net/ipv6/sit.c                                     |   5 +-
 net/mptcp/protocol.c                               |  69 +++------
 net/netfilter/nf_conntrack_standalone.c            |   3 +
 net/netfilter/nf_nat_core.c                        |   1 +
 net/rxrpc/input.c                                  |   2 +-
 net/rxrpc/key.c                                    |   6 +-
 net/smc/smc_core.c                                 |  20 ++-
 net/smc/smc_ib.c                                   |   6 +-
 net/smc/smc_ism.c                                  |   3 +-
 net/tipc/link.c                                    |  11 +-
 net/tipc/node.c                                    |   2 +-
 tools/testing/selftests/net/tls.c                  |   4 +-
 .../selftests/netfilter/nft_conntrack_helper.sh    |  12 +-
 54 files changed, 569 insertions(+), 223 deletions(-)
