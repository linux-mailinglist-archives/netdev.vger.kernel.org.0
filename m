Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FCDA4C3636
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 20:53:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234068AbiBXTxl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 14:53:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233310AbiBXTxk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 14:53:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF70025D267;
        Thu, 24 Feb 2022 11:53:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F357DB82920;
        Thu, 24 Feb 2022 19:53:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FD11C340E9;
        Thu, 24 Feb 2022 19:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645732386;
        bh=oXItC0NjDc2WEH/99CAmErS6bAX3gw8fCyHnwvU2Iv4=;
        h=From:To:Cc:Subject:Date:From;
        b=I9eRLgpHAo9JcADY7CqRwv1ZK3EGOU9xvLGueVpFRyW8YYB1N21mWE64m/Nkc6Tnj
         DvqM64YkA2Rla+tmJJlZLCncV/Jde7hMECXXhjKapKb5sR+/bbYGIxgr3fdSToXOEx
         XVipXiIe6xN9+PloodfjhU+NWHFQpO3iH10wdpeBUy7vCxoLgdGDUj2zy0h63jPvaU
         kM79UO2+ywaSheOkEOms7f+ybaimDhOubwWki+xZJULF/K/B88n93jqKCuFm8EGjT2
         iLCLLi/9SUBkjfqjG6tKX1u0Ty1sHciJF1zT6A7iMcw3UkDe7Wg/PDkv7XZmdJ98mv
         RA91vOixWg6yA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     torvalds@linux-foundation.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Networking for 5.17-rc6
Date:   Thu, 24 Feb 2022 11:53:05 -0800
Message-Id: <20220224195305.1584666-1-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Linus!

The following changes since commit 8b97cae315cafd7debf3601f88621e2aa8956ef3:

  Merge tag 'net-5.17-rc5' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2022-02-17 11:33:59 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.17-rc6

for you to fetch changes up to 42404d8f1c01861b22ccfa1d70f950242720ae57:

  net: mv643xx_eth: process retval from of_get_mac_address (2022-02-24 10:05:08 -0800)

----------------------------------------------------------------
Networking fixes for 5.17-rc6, including fixes from bpf and netfilter.

Current release - regressions:

 - bpf: fix crash due to out of bounds access into reg2btf_ids

 - mvpp2: always set port pcs ops, avoid null-deref

 - eth: marvell: fix driver load from initrd

 - eth: intel: revert "Fix reset bw limit when DCB enabled with 1 TC"

Current release - new code bugs:

 - mptcp: fix race in overlapping signal events

Previous releases - regressions:

 - xen-netback: revert hotplug-status changes causing devices to
   not be configured

 - dsa:
   - avoid call to __dev_set_promiscuity() while rtnl_mutex isn't held
   - fix panic when removing unoffloaded port from bridge

 - dsa: microchip: fix bridging with more than two member ports

Previous releases - always broken:

 - bpf:
  - fix crash due to incorrect copy_map_value when both spin lock
    and timer are present in a single value
  - fix a bpf_timer initialization issue with clang
  - do not try bpf_msg_push_data with len 0
  - add schedule points in batch ops

 - nf_tables:
   - unregister flowtable hooks on netns exit
   - correct flow offload action array size
   - fix a couple of memory leaks

 - vsock: don't check owner in vhost_vsock_stop() while releasing

 - gso: do not skip outer ip header in case of ipip and net_failover

 - smc: use a mutex for locking "struct smc_pnettable"

 - openvswitch: fix setting ipv6 fields causing hw csum failure

 - mptcp: fix race in incoming ADD_ADDR option processing

 - sysfs: add check for netdevice being present to speed_show

 - sched: act_ct: fix flow table lookup after ct clear or switching
   zones

 - eth: intel: fixes for SR-IOV forwarding offloads

 - eth: broadcom: fixes for selftests and error recovery

 - eth: mellanox: flow steering and SR-IOV forwarding fixes

Misc:

 - make __pskb_pull_tail() & pskb_carve_frag_list() drop_monitor
   friends not report freed skbs as drops

 - force inlining of checksum functions in net/checksum.h

Signed-off-by: Jakub Kicinski <kuba@kernel.org>

----------------------------------------------------------------
Alexei Starovoitov (2):
      Merge branch 'Fix for crash due to overwrite in copy_map_value'
      Merge branch 'bpf: fix a bpf_timer initialization issue'

Alvin Šipraga (2):
      net: dsa: fix panic when removing unoffloaded port from bridge
      MAINTAINERS: add myself as co-maintainer for Realtek DSA switch drivers

Ariel Levkovich (1):
      net/mlx5: Fix wrong limitation of metadata match on ecpf

Baruch Siach (1):
      net: mdio-ipq4019: add delay after clock enable

Chris Mi (1):
      net/mlx5: Fix tc max supported prio for nic mode

Christophe JAILLET (1):
      nfp: flower: Fix a potential leak in nfp_tunnel_add_shared_mac()

Christophe Leroy (1):
      net: Force inlining of checksum functions in net/checksum.h

Dan Carpenter (2):
      udp_tunnel: Fix end of loop test in udp_tunnel_nic_unregister()
      tipc: Fix end of loop tests for list_for_each_entry()

David S. Miller (5):
      Merge branch 'mptcp-fixes'
      Merge branch '100GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue
      Merge branch 'bnxt_en-fixes'
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf
      Merge branch 'ftgmac100-fixes'

Duoming Zhou (1):
      drivers: hamradio: 6pack: fix UAF bug caused by mod_timer()

Eric Dumazet (3):
      bpf: Add schedule points in batch ops
      net-timestamp: convert sk->sk_tskey to atomic_t
      net: __pskb_pull_tail() & pskb_carve_frag_list() drop_monitor friends

Fabio M. De Francesco (1):
      net/smc: Use a mutex for locking "struct smc_pnettable"

Felix Maurer (2):
      bpf: Do not try bpf_msg_push_data with len 0
      selftests: bpf: Check bpf_msg_push_data return value

Florian Westphal (2):
      netfilter: nft_limit: fix stateful object memory leak
      netfilter: nf_tables: fix memory leak during stateful obj update

Gal Pressman (2):
      net/mlx5e: Fix wrong return value on ioctl EEPROM query failure
      net/mlx5e: Fix VF min/max rate parameters interchange mistake

Heyi Guo (3):
      drivers/net/ftgmac100: refactor ftgmac100_reset_task to enable direct function call
      drivers/net/ftgmac100: adjust code place for function call dependency
      drivers/net/ftgmac100: fix DHCP potential failure with systemd

Jacob Keller (1):
      ice: fix concurrent reset and removal of VFs

Jakub Kicinski (2):
      Merge https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf
      Merge tag 'mlx5-fixes-2022-02-23' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux

Jeremy Linton (1):
      net: mvpp2: always set port pcs ops

Kalesh AP (2):
      bnxt_en: Restore the resets_reliable flag in bnxt_open()
      bnxt_en: Fix devlink fw_activate

Kumar Kartikeya Dwivedi (3):
      bpf: Fix crash due to incorrect copy_map_value
      selftests/bpf: Add test for bpf_timer overwriting crash
      bpf: Fix crash due to out of bounds access into reg2btf_ids.

Lama Kayal (2):
      net/mlx5e: Add feature check for set fec counters
      net/mlx5e: Add missing increment of count

Maher Sanalla (1):
      net/mlx5: Update log_max_qp value to be 17 at most

Manish Chopra (1):
      bnx2x: fix driver load from initrd

Maor Dickman (2):
      net/mlx5e: Fix MPLSoUDP encap to use MPLS action information
      net/mlx5e: MPLSoUDP decap, fix check for unsupported matches

Maor Gottlieb (1):
      net/mlx5: Fix possible deadlock on rule deletion

Marek Marczykowski-Górecki (2):
      Revert "xen-netback: remove 'hotplug-status' once it has served its purpose"
      Revert "xen-netback: Check for hotplug-status existence before watching"

Mateusz Palczewski (1):
      Revert "i40e: Fix reset bw limit when DCB enabled with 1 TC"

Mauri Sandberg (1):
      net: mv643xx_eth: process retval from of_get_mac_address

Meir Lichtinger (1):
      net/mlx5: Update the list of the PCI supported devices

Michael Chan (3):
      bnxt_en: Fix offline ethtool selftest with RDMA enabled
      bnxt_en: Fix occasional ethtool -t loopback test failures
      bnxt_en: Increase firmware message response DMA wait time

Michal Swiatkowski (1):
      ice: fix setting l4 port flag when adding filter

Niels Dossche (1):
      ipv6: prevent a possible race condition with lifetimes

Oliver Neukum (1):
      sr9700: sanity check for packet length

Pablo Neira Ayuso (3):
      netfilter: xt_socket: missing ifdef CONFIG_IP6_NF_IPTABLES dependency
      netfilter: nf_tables_offload: incorrect flow offload action array size
      netfilter: nf_tables: unregister flowtable hooks on netns exit

Paolo Abeni (7):
      selftests: mptcp: fix diag instability
      selftests: mptcp: improve 'fair usage on close' stability
      mptcp: fix race in overlapping signal events
      mptcp: fix race in incoming ADD_ADDR option processing
      mptcp: add mibs counter for ignored incoming options
      selftests: mptcp: more robust signal race test
      selftests: mptcp: be more conservative with cookie MPJ limits

Paul Blakey (2):
      net/sched: act_ct: Fix flow table lookup after ct clear or switching zones
      openvswitch: Fix setting ipv6 fields causing hw csum failure

Pavan Chebbi (1):
      bnxt_en: Fix incorrect multicast rx mask setting when not requested

Roi Dayan (3):
      net/mlx5e: TC, Reject rules with drop and modify hdr action
      net/mlx5e: TC, Reject rules with forward and drop actions
      net/mlx5e: TC, Skip redundant ct clear actions

Somnath Kotur (1):
      bnxt_en: Fix active FEC reporting to ethtool

Stefano Garzarella (1):
      vhost/vsock: don't check owner in vhost_vsock_stop() while releasing

Subash Abhinov Kasiviswanathan (1):
      MAINTAINERS: rmnet: Update email addresses

Sukadev Bhattiprolu (1):
      ibmvnic: schedule failover only if vioctl fails

Svenning Sørensen (1):
      net: dsa: microchip: fix bridging with more than two member ports

Tao Liu (1):
      gso: do not skip outer ip header in case of ipip and net_failover

Tariq Toukan (1):
      net/mlx5e: kTLS, Use CHECKSUM_UNNECESSARY for device-offloaded packets

Tom Rix (2):
      ice: check the return of ice_ptp_gettimex64
      ice: initialize local variable 'tlv'

Vladimir Oltean (1):
      net: dsa: avoid call to __dev_set_promiscuity() while rtnl_mutex isn't held

Wan Jiabing (1):
      net: sched: avoid newline at end of message in NL_SET_ERR_MSG_MOD

Wojciech Drewek (1):
      ice: Match on all profiles in slow-path

Xiaoke Wang (1):
      net: ll_temac: check the return value of devm_kmalloc()

Xin Long (1):
      ping: remove pr_err from ping_lookup

Yevgeny Kliteynik (4):
      net/mlx5: DR, Cache STE shadow memory
      net/mlx5: DR, Fix slab-out-of-bounds in mlx5_cmd_dr_create_fte
      net/mlx5: DR, Don't allow match on IP w/o matching on full ethertype/ip_version
      net/mlx5: DR, Fix the threshold that defines when pool sync is initiated

Yonghong Song (2):
      bpf: Emit bpf_timer in vmlinux BTF
      bpf: Fix a bpf_timer initialization issue

suresh kumar (1):
      net-sysfs: add check for netdevice being present to speed_show

 MAINTAINERS                                        |   5 +-
 drivers/net/dsa/microchip/ksz_common.c             |  26 ++-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c   |   3 +
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |  47 +++-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h          |   1 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c  |  39 +++-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c  |  17 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.c     |  12 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.h     |   2 +-
 drivers/net/ethernet/faraday/ftgmac100.c           | 243 +++++++++++----------
 drivers/net/ethernet/ibm/ibmvnic.c                 |   6 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c        |  12 +-
 drivers/net/ethernet/intel/ice/ice.h               |   1 -
 drivers/net/ethernet/intel/ice/ice_common.c        |   2 +-
 drivers/net/ethernet/intel/ice/ice_eswitch.c       |   1 +
 drivers/net/ethernet/intel/ice/ice_main.c          |   2 +
 drivers/net/ethernet/intel/ice/ice_protocol_type.h |   1 +
 drivers/net/ethernet/intel/ice/ice_ptp.c           |   5 +-
 drivers/net/ethernet/intel/ice/ice_switch.c        |   4 +-
 drivers/net/ethernet/intel/ice/ice_tc_lib.c        |   4 +-
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c   |  42 ++--
 drivers/net/ethernet/marvell/mv643xx_eth.c         |  24 +-
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c    |   6 +-
 .../ethernet/mellanox/mlx5/core/en/tc/act/act.h    |   2 +
 .../net/ethernet/mellanox/mlx5/core/en/tc/act/ct.c |   7 +
 .../ethernet/mellanox/mlx5/core/en/tc/act/mirred.c |   6 +
 .../ethernet/mellanox/mlx5/core/en/tc/act/mpls.c   |  11 +
 .../net/ethernet/mellanox/mlx5/core/en/tc_priv.h   |   1 +
 .../ethernet/mellanox/mlx5/core/en/tc_tun_encap.c  |   3 +
 .../mellanox/mlx5/core/en/tc_tun_mplsoudp.c        |  33 ++-
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.h   |   8 +
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |   3 +-
 .../net/ethernet/mellanox/mlx5/core/en_selftest.c  |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c |   6 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |  12 +
 drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c  |   2 +-
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |   4 -
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |   2 +
 .../ethernet/mellanox/mlx5/core/lib/fs_chains.c    |   3 +
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |   4 +-
 .../mellanox/mlx5/core/steering/dr_icm_pool.c      | 120 ++++++----
 .../mellanox/mlx5/core/steering/dr_matcher.c       |  20 +-
 .../ethernet/mellanox/mlx5/core/steering/dr_ste.c  |  32 ++-
 .../mellanox/mlx5/core/steering/dr_types.h         |  10 +
 .../ethernet/mellanox/mlx5/core/steering/fs_dr.c   |  33 ++-
 .../ethernet/mellanox/mlx5/core/steering/mlx5dr.h  |   5 +
 .../ethernet/netronome/nfp/flower/tunnel_conf.c    |   4 +-
 drivers/net/ethernet/xilinx/ll_temac_main.c        |   2 +
 drivers/net/hamradio/6pack.c                       |   4 +-
 drivers/net/mdio/mdio-ipq4019.c                    |   6 +-
 drivers/net/usb/sr9700.c                           |   2 +-
 drivers/net/xen-netback/xenbus.c                   |  14 +-
 drivers/vhost/vsock.c                              |  21 +-
 include/linux/bpf.h                                |   9 +-
 include/net/checksum.h                             |  52 +++--
 include/net/netfilter/nf_tables.h                  |   2 +-
 include/net/netfilter/nf_tables_offload.h          |   2 -
 include/net/sock.h                                 |   4 +-
 kernel/bpf/btf.c                                   |   5 +-
 kernel/bpf/helpers.c                               |   2 +
 kernel/bpf/syscall.c                               |   3 +
 net/can/j1939/transport.c                          |   2 +-
 net/core/filter.c                                  |   3 +
 net/core/net-sysfs.c                               |   2 +-
 net/core/skbuff.c                                  |   6 +-
 net/core/sock.c                                    |   4 +-
 net/dsa/master.c                                   |   7 +-
 net/dsa/port.c                                     |  29 ++-
 net/ipv4/af_inet.c                                 |   5 +-
 net/ipv4/ip_output.c                               |   2 +-
 net/ipv4/ping.c                                    |   1 -
 net/ipv4/udp_tunnel_nic.c                          |   2 +-
 net/ipv6/addrconf.c                                |   2 +
 net/ipv6/ip6_offload.c                             |   2 +
 net/ipv6/ip6_output.c                              |   2 +-
 net/mptcp/mib.c                                    |   2 +
 net/mptcp/mib.h                                    |   2 +
 net/mptcp/pm.c                                     |   8 +-
 net/mptcp/pm_netlink.c                             |  29 ++-
 net/netfilter/nf_tables_api.c                      |  16 +-
 net/netfilter/nf_tables_offload.c                  |   3 +-
 net/netfilter/nft_dup_netdev.c                     |   6 +
 net/netfilter/nft_fwd_netdev.c                     |   6 +
 net/netfilter/nft_immediate.c                      |  12 +-
 net/netfilter/nft_limit.c                          |  18 ++
 net/netfilter/xt_socket.c                          |   2 +
 net/openvswitch/actions.c                          |  46 +++-
 net/sched/act_api.c                                |   2 +-
 net/sched/act_ct.c                                 |   5 -
 net/smc/smc_pnet.c                                 |  42 ++--
 net/smc/smc_pnet.h                                 |   2 +-
 net/tipc/name_table.c                              |   2 +-
 net/tipc/socket.c                                  |   2 +-
 .../testing/selftests/bpf/prog_tests/timer_crash.c |  32 +++
 .../selftests/bpf/progs/test_sockmap_kern.h        |  26 ++-
 tools/testing/selftests/bpf/progs/timer_crash.c    |  54 +++++
 tools/testing/selftests/net/mptcp/diag.sh          |  44 +++-
 tools/testing/selftests/net/mptcp/mptcp_join.sh    |  32 ++-
 99 files changed, 990 insertions(+), 439 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/timer_crash.c
 create mode 100644 tools/testing/selftests/bpf/progs/timer_crash.c
