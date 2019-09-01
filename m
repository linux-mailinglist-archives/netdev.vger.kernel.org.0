Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92D2CA4BFE
	for <lists+netdev@lfdr.de>; Sun,  1 Sep 2019 22:47:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729004AbfIAUp3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Sep 2019 16:45:29 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:48744 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728900AbfIAUp3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Sep 2019 16:45:29 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4F71D1537CE95;
        Sun,  1 Sep 2019 13:45:28 -0700 (PDT)
Date:   Sun, 01 Sep 2019 13:45:25 -0700 (PDT)
Message-Id: <20190901.134525.286041997131171719.davem@davemloft.net>
To:     torvalds@linux-foundation.org
CC:     akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Networking
From:   David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 01 Sep 2019 13:45:28 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


1) Fix some length checks during OGM processing in batman-adv, from
   Sven Eckelmann.

2) Fix regression that caused netfilter conntrack sysctls to not be per-netns
   any more.  From Florian Westphal.

3) Use after free in netpoll, from Feng Sun.

4) Guard destruction of pfifo_fast per-cpu qdisc stats with
   qdisc_is_percpu_stats(), from Davide Caratti.  Similar bug
   is fixed in pfifo_fast_enqueue().

5) Fix memory leak in mld_del_delrec(), from Eric Dumazet.

6) Handle neigh events on internal ports correctly in nfp, from John
   Hurley.

7) Clear SKB timestamp in NF flow table code so that it does not
   confuse fq scheduler.  From Florian Westphal.

8) taprio destroy can crash if it is invoked in a failure path of
   taprio_init(), because the list head isn't setup properly yet
   and the list del is unconditional.  Perform the list add earlier
   to address this.  From Vladimir Oltean.

9) Make sure to reapply vlan filters on device up, in aquantia driver.
   From Dmitry Bogdanov.

10) sgiseeq driver releases DMA memory using free_page() instead of
    dma_free_attrs().  From Christophe JAILLET.

Please pull, thanks a lot!

The following changes since commit 9e8312f5e160ade069e131d54ab8652cf0e86e1a:

  Merge tag 'nfs-for-5.3-3' of git://git.linux-nfs.org/projects/trondmy/linux-nfs (2019-08-27 13:22:57 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git 

for you to fetch changes up to e1e54ec7fb55501c33b117c111cb0a045b8eded2:

  net: seeq: Fix the function used to release some memory in an error handling path (2019-09-01 12:10:11 -0700)

----------------------------------------------------------------
Chen-Yu Tsai (1):
      net: stmmac: dwmac-rk: Don't fail if phy regulator is absent

Christophe JAILLET (2):
      enetc: Add missing call to 'pci_free_irq_vectors()' in probe and remove functions
      net: seeq: Fix the function used to release some memory in an error handling path

Cong Wang (1):
      net_sched: fix a NULL pointer deref in ipt action

David Howells (8):
      rxrpc: Improve jumbo packet counting
      rxrpc: Use info in skbuff instead of reparsing a jumbo packet
      rxrpc: Pass the input handler's data skb reference to the Rx ring
      rxrpc: Abstract out rxtx ring cleanup
      rxrpc: Add a private skb flag to indicate transmission-phase skbs
      rxrpc: Use the tx-phase skb flag to simplify tracing
      rxrpc: Use skb_unshare() rather than skb_cow_data()
      rxrpc: Fix lack of conn cleanup when local endpoint is cleaned up [ver #2]

David S. Miller (11):
      Merge branch 'macb-Update-ethernet-compatible-string-for-SiFive-FU540'
      Merge branch 'r8152-fix-side-effect'
      Merge branch 'nfp-flower-fix-bugs-in-merge-tunnel-encap-code'
      Merge tag 'mac80211-for-davem-2019-08-29' of git://git.kernel.org/.../jberg/mac80211
      Merge tag 'rxrpc-fixes-20190827' of git://git.kernel.org/.../dhowells/linux-fs
      Merge git://git.kernel.org/.../bpf/bpf
      Merge git://git.kernel.org/.../pablo/nf
      Merge tag 'batadv-net-for-davem-20190830' of git://git.open-mesh.org/linux-merge
      Merge branch 'Fix-issues-in-tc-taprio-and-tc-cbs'
      Merge branch 'net-aquantia-fixes-on-vlan-filters-and-other-conditions'
      Merge branch 'net-dsa-microchip-add-KSZ8563-support'

Davide Caratti (3):
      net/sched: pfifo_fast: fix wrong dereference when qdisc is reset
      net/sched: pfifo_fast: fix wrong dereference in pfifo_fast_enqueue
      tc-testing: don't hardcode 'ip' in nsPlugin.py

Denis Kenzior (2):
      mac80211: Don't memset RXCB prior to PAE intercept
      mac80211: Correctly set noencrypt for PAE frames

Dmitry Bogdanov (4):
      net: aquantia: fix removal of vlan 0
      net: aquantia: fix limit of vlan filters
      net: aquantia: reapply vlan filters on up
      net: aquantia: fix out of memory condition on rx side

Eric Dumazet (2):
      tcp: remove empty skb from write queue in error cases
      mld: fix memory leak in mld_del_delrec()

Feng Sun (1):
      net: fix skb use after free in netpoll

Florian Westphal (2):
      netfilter: conntrack: make sysctls per-namespace again
      netfilter: nf_flow_table: clear skb tstamp before xmit

George McCollister (1):
      net: dsa: microchip: fill regmap_config name

Greg Rose (1):
      openvswitch: Properly set L4 keys on "later" IP fragments

Hayes Wang (2):
      Revert "r8152: napi hangup fix after disconnect"
      r8152: remove calling netif_napi_del

Igor Russkikh (1):
      net: aquantia: linkstate irq should be oneshot

Jiong Wang (1):
      nfp: bpf: fix latency bug when updating stack index register

John Hurley (2):
      nfp: flower: prevent ingress block binds on internal ports
      nfp: flower: handle neighbour events on internal ports

Justin Pettit (1):
      openvswitch: Clear the L4 portion of the key for "later" fragments.

Ka-Cheong Poon (1):
      net/rds: Fix info leak in rds6_inc_info_copy()

Luca Coelho (1):
      iwlwifi: pcie: handle switching killer Qu B0 NICs to C0

Marco Hartmann (1):
      Add genphy_c45_config_aneg() function to phy-c45.c

Naveen N. Rao (1):
      bpf: handle 32-bit zext during constant blinding

Razvan Stefanescu (2):
      dt-bindings: net: dsa: document additional Microchip KSZ8563 switch
      net: dsa: microchip: add KSZ8563 compatibility string

Ryan M. Collins (1):
      net: bcmgenet: use ethtool_op_get_ts_info()

Sven Eckelmann (2):
      batman-adv: Only read OGM tvlv_len after buffer len check
      batman-adv: Only read OGM2 tvlv_len after buffer len check

Takashi Iwai (1):
      sky2: Disable MSI on yet another ASUS boards (P6Xxxx)

Thomas Falcon (1):
      ibmvnic: Do not process reset during or after device removal

Thomas Jarosch (1):
      netfilter: nf_conntrack_ftp: Fix debug output

Todd Seidelmann (1):
      netfilter: xt_physdev: Fix spurious error message in physdev_mt_check

Vlad Buslov (1):
      net: sched: act_sample: fix psample group handling on overwrite

Vladimir Oltean (4):
      net: dsa: tag_8021q: Future-proof the reserved fields in the custom VID
      taprio: Fix kernel panic in taprio_destroy
      taprio: Set default link speed to 10 Mbps in taprio_set_picos_per_byte
      net/sched: cbs: Set default link speed to 10 Mbps in cbs_set_port_rate

Willem de Bruijn (1):
      tcp: inherit timestamp on mtu probe

Yash Shah (2):
      macb: bindings doc: update sifive fu540-c000 binding
      macb: Update compatibility string for SiFive FU540-C000

YueHaibing (1):
      amd-xgbe: Fix error path in xgbe_mod_init()

wenxu (1):
      netfilter: nft_meta_bridge: Fix get NFT_META_BRI_IIFVPROTO in network byteorder

 Documentation/devicetree/bindings/net/dsa/ksz.txt         |   1 +
 Documentation/devicetree/bindings/net/macb.txt            |   4 +-
 drivers/net/dsa/microchip/ksz9477_spi.c                   |   1 +
 drivers/net/dsa/microchip/ksz_common.h                    |   1 +
 drivers/net/ethernet/amd/xgbe/xgbe-main.c                 |  10 ++-
 drivers/net/ethernet/aquantia/atlantic/aq_filters.c       |   5 +-
 drivers/net/ethernet/aquantia/atlantic/aq_main.c          |   4 ++
 drivers/net/ethernet/aquantia/atlantic/aq_nic.c           |   2 +-
 drivers/net/ethernet/aquantia/atlantic/aq_vec.c           |   3 +-
 drivers/net/ethernet/broadcom/genet/bcmgenet.c            |   1 +
 drivers/net/ethernet/cadence/macb_main.c                  |   2 +-
 drivers/net/ethernet/freescale/enetc/enetc_ptp.c          |   5 +-
 drivers/net/ethernet/ibm/ibmvnic.c                        |   6 +-
 drivers/net/ethernet/marvell/sky2.c                       |   7 +++
 drivers/net/ethernet/netronome/nfp/bpf/jit.c              |  17 +++--
 drivers/net/ethernet/netronome/nfp/flower/offload.c       |   7 ++-
 drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c   |   8 +--
 drivers/net/ethernet/seeq/sgiseeq.c                       |   7 ++-
 drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c            |   6 +-
 drivers/net/phy/phy-c45.c                                 |  26 ++++++++
 drivers/net/phy/phy.c                                     |   2 +-
 drivers/net/usb/r8152.c                                   |   5 +-
 drivers/net/wireless/intel/iwlwifi/cfg/22000.c            |  24 ++++++++
 drivers/net/wireless/intel/iwlwifi/iwl-config.h           |   2 +
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c             |   4 ++
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c           |   7 +--
 include/linux/phy.h                                       |   1 +
 include/net/act_api.h                                     |   4 +-
 include/net/psample.h                                     |   1 +
 include/trace/events/rxrpc.h                              |  59 +++++++++---------
 kernel/bpf/core.c                                         |   8 ++-
 net/batman-adv/bat_iv_ogm.c                               |  20 +++---
 net/batman-adv/bat_v_ogm.c                                |  18 ++++--
 net/bridge/netfilter/nft_meta_bridge.c                    |   2 +-
 net/core/netpoll.c                                        |   6 +-
 net/dsa/tag_8021q.c                                       |   2 +
 net/ipv4/tcp.c                                            |  30 ++++++---
 net/ipv4/tcp_output.c                                     |   3 +-
 net/ipv6/mcast.c                                          |   5 +-
 net/mac80211/rx.c                                         |   6 +-
 net/netfilter/nf_conntrack_ftp.c                          |   2 +-
 net/netfilter/nf_conntrack_standalone.c                   |   5 ++
 net/netfilter/nf_flow_table_ip.c                          |   3 +-
 net/netfilter/xt_physdev.c                                |   6 +-
 net/openvswitch/conntrack.c                               |   5 ++
 net/openvswitch/flow.c                                    | 160 +++++++++++++++++++++++++++--------------------
 net/openvswitch/flow.h                                    |   1 +
 net/psample/psample.c                                     |   2 +-
 net/rds/recv.c                                            |   5 +-
 net/rxrpc/af_rxrpc.c                                      |   3 -
 net/rxrpc/ar-internal.h                                   |  17 +++--
 net/rxrpc/call_event.c                                    |   8 +--
 net/rxrpc/call_object.c                                   |  33 +++++-----
 net/rxrpc/conn_client.c                                   |  44 +++++++++++++
 net/rxrpc/conn_event.c                                    |   6 +-
 net/rxrpc/conn_object.c                                   |   2 +-
 net/rxrpc/input.c                                         | 304 +++++++++++++++++++++++++++++++++++++++++++++++++-----------------------------------------
 net/rxrpc/local_event.c                                   |   4 +-
 net/rxrpc/local_object.c                                  |   5 +-
 net/rxrpc/output.c                                        |   6 +-
 net/rxrpc/peer_event.c                                    |  10 +--
 net/rxrpc/protocol.h                                      |   9 +++
 net/rxrpc/recvmsg.c                                       |  47 ++++++++------
 net/rxrpc/rxkad.c                                         |  32 +++-------
 net/rxrpc/sendmsg.c                                       |  13 ++--
 net/rxrpc/skbuff.c                                        |  40 ++++++++----
 net/sched/act_bpf.c                                       |   2 +-
 net/sched/act_connmark.c                                  |   2 +-
 net/sched/act_csum.c                                      |   2 +-
 net/sched/act_ct.c                                        |   2 +-
 net/sched/act_ctinfo.c                                    |   2 +-
 net/sched/act_gact.c                                      |   2 +-
 net/sched/act_ife.c                                       |   2 +-
 net/sched/act_ipt.c                                       |  11 ++--
 net/sched/act_mirred.c                                    |   2 +-
 net/sched/act_mpls.c                                      |   2 +-
 net/sched/act_nat.c                                       |   2 +-
 net/sched/act_pedit.c                                     |   2 +-
 net/sched/act_police.c                                    |   2 +-
 net/sched/act_sample.c                                    |   8 ++-
 net/sched/act_simple.c                                    |   2 +-
 net/sched/act_skbedit.c                                   |   2 +-
 net/sched/act_skbmod.c                                    |   2 +-
 net/sched/act_tunnel_key.c                                |   2 +-
 net/sched/act_vlan.c                                      |   2 +-
 net/sched/sch_cbs.c                                       |  19 +++---
 net/sched/sch_generic.c                                   |  19 ++++--
 net/sched/sch_taprio.c                                    |  31 +++++-----
 tools/testing/selftests/tc-testing/plugin-lib/nsPlugin.py |  22 +++----
 89 files changed, 761 insertions(+), 487 deletions(-)
