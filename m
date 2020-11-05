Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F7352A870D
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 20:25:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732156AbgKETZM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 14:25:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:40580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726729AbgKETZM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Nov 2020 14:25:12 -0500
Received: from cakuba.hsd1.ca.comcast.net (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9F5032083B;
        Thu,  5 Nov 2020 19:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604604309;
        bh=wRlsVlmFSl6RWi9sN14uRixMDSccSC9oLOYe7CNDhk4=;
        h=From:To:Cc:Subject:Date:From;
        b=N2J+XbHE75SaqCzg6wusJ9wacEbVv22D9BMlIY2nXJFEv3NKhvCQ9yum2EQqWTxma
         fa52g7mE/r+cFUOFuwQW0cDsWJXFe/CCACDqK2R+UyLwxXSTc8AfUpILfowUPSdXr2
         /vLxH8h2IkD8DTHHfzVBjnjGnvr5z0WytXh6/AuI=
From:   Jakub Kicinski <kuba@kernel.org>
To:     torvalds@linux-foundation.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Networking
Date:   Thu,  5 Nov 2020 11:25:08 -0800
Message-Id: <20201105192508.1699334-1-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following changes since commit 07e0887302450a62f51dba72df6afb5fabb23d1c:

  Merge tag 'fallthrough-fixes-clang-5.10-rc2' of git://git.kernel.org/pub/scm/linux/kernel/git/gustavoars/linux (2020-10-29 13:02:52 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.10-rc3

for you to fetch changes up to 2bcbf42add911ef63a6d90e92001dc2bcb053e68:

  ionic: check port ptr before use (2020-11-05 09:58:25 -0800)

----------------------------------------------------------------
Networking fixes for 5.10-rc3, including fixes from wireless, can,
and netfilter subtrees.

Current release - bugs in new features:

 - can: isotp: isotp_rcv_cf(): enable RX timeout handling in
   listen-only mode

Previous release - regressions:

 - mac80211:
   - don't require VHT elements for HE on 2.4 GHz
   - fix regression where EAPOL frames were sent in plaintext

 - netfilter:
   - ipset: Update byte and packet counters regardless of whether
     they match

 - ip_tunnel: fix over-mtu packet send by allowing fragmenting even
   if inner packet has IP_DF (don't fragment) set in its header
   (when TUNNEL_DONT_FRAGMENT flag is not set on the tunnel dev)

 - net: fec: fix MDIO probing for some FEC hardware blocks

 - ip6_tunnel: set inner ipproto before ip6_tnl_encap to un-break
   gso support

 - sctp: Fix COMM_LOST/CANT_STR_ASSOC err reporting on big-endian
   platforms, sparse-related fix used the wrong integer size

Previous release - always broken:

 - netfilter: use actual socket sk rather than skb sk when routing
   harder

 - r8169: work around short packet hw bug on RTL8125 by padding frames

 - net: ethernet: ti: cpsw: disable PTPv1 hw timestamping
   advertisement, the hardware does not support it

 - chelsio/chtls: fix always leaking ctrl_skb and another leak caused
   by a race condition

 - fix drivers incorrectly writing into skbs on TX:
   - cadence: force nonlinear buffers to be cloned
   - gianfar: Account for Tx PTP timestamp in the skb headroom
   - gianfar: Replace skb_realloc_headroom with skb_cow_head for PTP

 - can: flexcan:
   - remove FLEXCAN_QUIRK_DISABLE_MECR quirk for LS1021A
   - add ECC initialization for VF610 and LX2160A
   - flexcan_remove(): disable wakeup completely

 - can: fix packet echo functionality:
   - peak_canfd: fix echo management when loopback is on
   - make sure skbs are not freed in IRQ context in case they need
     to be dropped
   - always clone the skbs to make sure they have a reference on
     the socket, and prevent it from disappearing
   - fix real payload length return value for RTR frames

 - can: j1939: return failure on bind if netdev is down, rather than
   waiting indefinitely

Misc:

 - IPv6: reply ICMP error if the first fragment don't include all
   headers to improve compliance with RFC 8200

Signed-off-by: Jakub Kicinski <kuba@kernel.org>

----------------------------------------------------------------
Alexander Ovechkin (1):
      ip6_tunnel: set inner ipproto before ip6_tnl_encap

Camelia Groza (2):
      dpaa_eth: update the buffer layout for non-A050385 erratum scenarios
      dpaa_eth: fix the RX headroom size alignment

Claudiu Manoil (2):
      gianfar: Replace skb_realloc_headroom with skb_cow_head for PTP
      gianfar: Account for Tx PTP timestamp in the skb headroom

Colin Ian King (2):
      net: atm: fix update of position index in lec_seq_next
      can: isotp: padlen(): make const array static, makes object smaller

Dan Carpenter (1):
      can: peak_usb: add range checking in decode operations

Daniele Palmas (1):
      net: usb: qmi_wwan: add Telit LE910Cx 0x1230 composition

Davide Caratti (1):
      mptcp: token: fix unititialized variable

Eelco Chaudron (1):
      net: openvswitch: silence suspicious RCU usage warning

Geert Uytterhoeven (1):
      can: isotp: Explain PDU in CAN_ISOTP help text

Greg Ungerer (1):
      net: fec: fix MDIO probing for some FEC hardware blocks

Grygorii Strashko (1):
      net: ethernet: ti: cpsw: disable PTPv1 hw timestamping advertisement

Hangbin Liu (2):
      ICMPv6: Add ICMPv6 Parameter Problem, code 3 definition
      IPv6: reply ICMP error if the first fragment don't include all headers

Heiner Kallweit (1):
      r8169: work around short packet hw bug on RTL8125

Jakub Kicinski (6):
      Merge branch 'ipv6-reply-icmp-error-if-fragment-doesn-t-contain-all-headers'
      Merge git://git.kernel.org/.../pablo/nf
      Merge tag 'mac80211-for-net-2020-10-30' of git://git.kernel.org/.../jberg/mac80211
      Merge branch 'dpaa_eth-buffer-layout-fixes'
      Merge branch 'master' of git://git.kernel.org/.../klassert/ipsec
      Merge tag 'linux-can-fixes-for-5.10-20201103' of git://git.kernel.org/.../mkl/linux-can

Jason A. Donenfeld (2):
      wireguard: selftests: check that route_me_harder packets use the right sk
      netfilter: use actual socket sk rather than skb sk when routing harder

Joakim Zhang (4):
      can: flexcan: remove FLEXCAN_QUIRK_DISABLE_MECR quirk for LS1021A
      can: flexcan: add ECC initialization for LX2160A
      can: flexcan: add ECC initialization for VF610
      can: flexcan: flexcan_remove(): disable wakeup completely

Johannes Berg (4):
      mac80211: fix use of skb payload instead of header
      cfg80211: initialize wdev data earlier
      mac80211: always wind down STA state
      mac80211: don't require VHT elements for HE on 2.4 GHz

Jonathan McDowell (1):
      net: dsa: qca8k: Fix port MTU setting

Marc Kleine-Budde (2):
      can: rx-offload: don't call kfree_skb() from IRQ context
      can: mcp251xfd: mcp251xfd_regmap_crc_read(): increase severity of CRC read error messages

Marek Szyprowski (1):
      net: stmmac: Fix channel lock initialization

Mark Deneen (1):
      cadence: force nonlinear buffers to be cloned

Mathy Vanhoef (1):
      mac80211: fix regression where EAPOL frames were sent in plaintext

Mauro Carvalho Chehab (1):
      mac80211: fix kernel-doc markups

Navid Emamdoost (1):
      can: xilinx_can: handle failure cases of pm_runtime_get_sync

Oleksij Rempel (3):
      dt-bindings: can: add can-controller.yaml
      dt-bindings: can: flexcan: convert fsl,*flexcan bindings to yaml
      can: can_create_echo_skb(): fix echo skb generation: always use skb_clone()

Oliver Hartkopp (2):
      can: dev: __can_get_echo_skb(): fix real payload length return value for RTR frames
      can: isotp: isotp_rcv_cf(): enable RX timeout handling in listen-only mode

Pablo Neira Ayuso (2):
      netfilter: nftables: fix netlink report logic in flowtable and genid
      netfilter: nf_tables: missing validation from the abort path

Petr Malat (1):
      sctp: Fix COMM_LOST/CANT_STR_ASSOC err reporting on big-endian platforms

Shannon Nelson (1):
      ionic: check port ptr before use

Stefano Brivio (1):
      netfilter: ipset: Update byte and packet counters regardless of whether they match

Stephane Grosjean (2):
      can: peak_usb: peak_usb_get_ts_time(): fix timestamp wrapping
      can: peak_canfd: pucan_handle_can_rx(): fix echo management when loopback is on

Sukadev Bhattiprolu (1):
      powerpc/vnic: Extend "failover pending" window

Tom Rix (1):
      can: mcp251xfd: remove unneeded break

Vinay Kumar Yadav (2):
      chelsio/chtls: fix memory leaks caused by a race
      chelsio/chtls: fix always leaking ctrl_skb

Vincent Mailhol (1):
      can: dev: can_get_echo_skb(): prevent call to kfree_skb() in hard IRQ context

Wong Vee Khee (1):
      stmmac: intel: Fix kernel panic on pci probe

Xin Long (1):
      xfrm: interface: fix the priorities for ipip and ipv6 tunnels

Ye Bin (1):
      cfg80211: regulatory: Fix inconsistent format argument

Yegor Yefremov (4):
      can: j1939: rename jacd tool
      can: j1939: fix syntax and spelling
      can: j1939: swap addr and pgn in the send example
      can: j1939: use backquotes for code samples

YueHaibing (1):
      sfp: Fix error handing in sfp_probe()

Zhang Changzhong (3):
      can: proc: can_remove_proc(): silence remove_proc_entry warning
      can: j1939: j1939_sk_bind(): return failure if netdev is down
      can: ti_hecc: ti_hecc_probe(): add missed clk_disable_unprepare() in error path

kernel test robot (1):
      can: mcp251xfd: mcp251xfd_regmap_nocrc_read(): fix semicolon.cocci warnings

wenxu (1):
      ip_tunnel: fix over-mtu packet send fail without TUNNEL_DONT_FRAGMENT flags

zhuoliang zhang (1):
      net: xfrm: fix a race condition during allocing spi

 .../bindings/net/can/can-controller.yaml           |  18 +++
 .../devicetree/bindings/net/can/fsl,flexcan.yaml   | 135 +++++++++++++++++++++
 .../devicetree/bindings/net/can/fsl-flexcan.txt    |  57 ---------
 Documentation/networking/j1939.rst                 | 120 +++++++++---------
 drivers/net/can/dev.c                              |  14 ++-
 drivers/net/can/flexcan.c                          |  12 +-
 drivers/net/can/peak_canfd/peak_canfd.c            |  11 +-
 drivers/net/can/rx-offload.c                       |   4 +-
 drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c     |  22 ++--
 drivers/net/can/spi/mcp251xfd/mcp251xfd-regmap.c   |  18 +--
 drivers/net/can/ti_hecc.c                          |   8 +-
 drivers/net/can/usb/peak_usb/pcan_usb_core.c       |  51 +++++++-
 drivers/net/can/usb/peak_usb/pcan_usb_fd.c         |  48 ++++++--
 drivers/net/can/xilinx_can.c                       |   6 +-
 drivers/net/dsa/qca8k.c                            |   4 +-
 drivers/net/ethernet/cadence/macb_main.c           |   3 +-
 .../chelsio/inline_crypto/chtls/chtls_cm.c         |   2 +-
 .../chelsio/inline_crypto/chtls/chtls_hw.c         |   3 +
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c     |  28 +++--
 drivers/net/ethernet/freescale/fec.h               |   6 +
 drivers/net/ethernet/freescale/fec_main.c          |  29 +++--
 drivers/net/ethernet/freescale/gianfar.c           |  14 +--
 drivers/net/ethernet/ibm/ibmvnic.c                 |  36 +++++-
 .../net/ethernet/pensando/ionic/ionic_ethtool.c    |   5 +
 drivers/net/ethernet/realtek/r8169_main.c          |  14 ++-
 drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c  |  14 +--
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |   1 +
 drivers/net/ethernet/ti/cpsw_ethtool.c             |   1 -
 drivers/net/ethernet/ti/cpsw_priv.c                |   5 +-
 drivers/net/phy/sfp.c                              |   3 +-
 drivers/net/usb/qmi_wwan.c                         |   1 +
 include/linux/can/skb.h                            |  20 ++-
 include/linux/netfilter/nfnetlink.h                |   9 +-
 include/linux/netfilter_ipv4.h                     |   2 +-
 include/linux/netfilter_ipv6.h                     |  10 +-
 include/net/cfg80211.h                             |   9 +-
 include/net/mac80211.h                             |   7 +-
 include/uapi/linux/icmpv6.h                        |   1 +
 net/atm/lec.c                                      |   5 +-
 net/can/Kconfig                                    |   5 +-
 net/can/isotp.c                                    |  26 ++--
 net/can/j1939/socket.c                             |   6 +
 net/can/proc.c                                     |   6 +-
 net/ipv4/ip_tunnel.c                               |   3 -
 net/ipv4/netfilter.c                               |   8 +-
 net/ipv4/netfilter/iptable_mangle.c                |   2 +-
 net/ipv4/netfilter/nf_reject_ipv4.c                |   2 +-
 net/ipv4/xfrm4_tunnel.c                            |   4 +-
 net/ipv6/icmp.c                                    |   8 +-
 net/ipv6/ip6_tunnel.c                              |   4 +-
 net/ipv6/netfilter.c                               |   6 +-
 net/ipv6/netfilter/ip6table_mangle.c               |   2 +-
 net/ipv6/reassembly.c                              |  33 ++++-
 net/ipv6/xfrm6_tunnel.c                            |   4 +-
 net/mac80211/mlme.c                                |   3 +-
 net/mac80211/sta_info.c                            |  18 +++
 net/mac80211/sta_info.h                            |   9 +-
 net/mac80211/tx.c                                  |  44 ++++---
 net/mptcp/token.c                                  |   2 +-
 net/netfilter/ipset/ip_set_core.c                  |   3 +-
 net/netfilter/ipvs/ip_vs_core.c                    |   4 +-
 net/netfilter/nf_nat_proto.c                       |   4 +-
 net/netfilter/nf_synproxy_core.c                   |   2 +-
 net/netfilter/nf_tables_api.c                      |  19 +--
 net/netfilter/nfnetlink.c                          |  22 +++-
 net/netfilter/nft_chain_route.c                    |   4 +-
 net/netfilter/utils.c                              |   4 +-
 net/openvswitch/datapath.c                         |  14 +--
 net/openvswitch/flow_table.c                       |   2 +-
 net/sctp/sm_sideeffect.c                           |   4 +-
 net/wireless/core.c                                |  57 +++++----
 net/wireless/core.h                                |   5 +-
 net/wireless/nl80211.c                             |   3 +-
 net/wireless/reg.c                                 |   2 +-
 net/xfrm/xfrm_interface.c                          |   8 +-
 net/xfrm/xfrm_state.c                              |   8 +-
 tools/testing/selftests/wireguard/netns.sh         |   8 ++
 .../testing/selftests/wireguard/qemu/kernel.config |   2 +
 78 files changed, 744 insertions(+), 382 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/can/can-controller.yaml
 create mode 100644 Documentation/devicetree/bindings/net/can/fsl,flexcan.yaml
 delete mode 100644 Documentation/devicetree/bindings/net/can/fsl-flexcan.txt
