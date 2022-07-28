Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 740FE58461A
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 20:54:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231209AbiG1SkP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 14:40:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbiG1SkO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 14:40:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF5D0E52;
        Thu, 28 Jul 2022 11:40:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6A279B824FD;
        Thu, 28 Jul 2022 18:40:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFD38C433C1;
        Thu, 28 Jul 2022 18:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659033609;
        bh=lOBwNrqWNCKyX7sc657+GSxEk4asPX1rXJGkxa6syIk=;
        h=From:To:Cc:Subject:Date:From;
        b=WGbTB0Uc9ogRIpmMxlQRbDmoyyuNFZK7sYSxiKa7m1AyTyUrl2gs3m98KKE/CHpAa
         O8cxzKVfqMVAi4fltFJgsCSdEcsweI1q28CmqlwjHmpXVqRjxHY3B1Be0dAI/rhPuv
         BOMDEsLTwyqGUpW0Jehe5JA0vUNiVtxXRQsbV28emw9s1Zt1gMpfhSND2kJkTc5KnU
         zBhuW3oX+vz4Z3qU6v+3KBMMuIuxYE2hmxMvYlc0D9gb3jf5/brGQ0OqVPFenosKMy
         K8IDVxC24UpqkSvdoORzpEGBaJOoLS54YY5Tk8iWIVzTtXl+3XzdYQrQUkNLAdzCg5
         Kap4MaxKXv+lg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     torvalds@linux-foundation.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PULL] Networking for 5.19-final
Date:   Thu, 28 Jul 2022 11:40:07 -0700
Message-Id: <20220728184007.1642187-1-kuba@kernel.org>
X-Mailer: git-send-email 2.36.1
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

The following changes since commit 7ca433dc6dedb2ec98dfc943f6db0c9b8996ed11:

  Merge tag 'net-5.19-rc8' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2022-07-21 11:08:35 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.19-final

for you to fetch changes up to 4d3d3a1b244fd54629a6b7047f39a7bbc8d11910:

  stmmac: dwmac-mediatek: fix resource leak in probe (2022-07-28 10:43:04 -0700)

----------------------------------------------------------------
Including fixes from bluetooth and netfilter, no known blockers
for the release.

Current release - regressions:

 - wifi: mac80211: do not abuse fq.lock in ieee80211_do_stop(),
   fix taking the lock before its initialized

 - Bluetooth: mgmt: fix double free on error path

Current release - new code bugs:

 - eth: ice: fix tunnel checksum offload with fragmented traffic

Previous releases - regressions:

 - tcp: md5: fix IPv4-mapped support after refactoring, don't take
   the pure v6 path

 - Revert "tcp: change pingpong threshold to 3", improving detection
   of interactive sessions

 - mld: fix netdev refcount leak in mld_{query | report}_work() due
   to a race

 - Bluetooth:
   - always set event mask on suspend, avoid early wake ups
   - L2CAP: fix use-after-free caused by l2cap_chan_put

 - bridge: do not send empty IFLA_AF_SPEC attribute

Previous releases - always broken:

 - ping6: fix memleak in ipv6_renew_options()

 - sctp: prevent null-deref caused by over-eager error paths

 - virtio-net: fix the race between refill work and close,
   resulting in NAPI scheduled after close and a BUG()

 - macsec:
   - fix three netlink parsing bugs
   - avoid breaking the device state on invalid change requests
   - fix a memleak in another error path

Misc:

 - dt-bindings: net: ethernet-controller: rework 'fixed-link' schema

 - two more batches of sysctl data race adornment

Signed-off-by: Jakub Kicinski <kuba@kernel.org>

----------------------------------------------------------------
Abhishek Pandit-Subedi (1):
      Bluetooth: Always set event mask on suspend

Alejandro Lucero (1):
      sfc: disable softirqs for ptp TX

Anirudh Venkataramanan (1):
      ice: Fix VSIs unable to share unicast MAC

Benjamin Poirier (1):
      bridge: Do not send empty IFLA_AF_SPEC attribute

Christophe JAILLET (1):
      caif: Fix bitmap data type in "struct caifsock"

Dan Carpenter (2):
      Bluetooth: mgmt: Fix double free on error path
      stmmac: dwmac-mediatek: fix resource leak in probe

David S. Miller (3):
      Merge branch 'sysctl-races-part-5'
      Merge branch 'macsec-config-issues'
      Merge branch 'net-sysctl-races-part-6'

Dimitris Michailidis (1):
      net/funeth: Fix fun_xdp_tx() and XDP packet reclaim

Duoming Zhou (1):
      sctp: fix sleep in atomic context bug in timer handlers

Eric Dumazet (1):
      tcp: md5: fix IPv4-mapped support

Florian Westphal (3):
      netfilter: nf_queue: do not allow packet truncation below transport header offset
      netfilter: nf_tables: add rescheduling points during loop detection walks
      netfilter: nft_queue: only allow supported familes and hooks

Jakub Kicinski (3):
      Merge tag 'for-net-2022-07-26' of git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf
      Merge branch '100GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue

Jason Wang (1):
      virtio-net: fix the race between refill work and close

Jianglei Nie (1):
      net: macsec: fix potential resource leak in macsec_add_rxsa() and macsec_add_txsa()

Jonathan Lemon (1):
      ptp: ocp: Select CRC16 in the Kconfig.

Kuniyuki Iwashima (23):
      tcp: Fix data-races around sysctl_tcp_dsack.
      tcp: Fix a data-race around sysctl_tcp_app_win.
      tcp: Fix a data-race around sysctl_tcp_adv_win_scale.
      tcp: Fix a data-race around sysctl_tcp_frto.
      tcp: Fix a data-race around sysctl_tcp_nometrics_save.
      tcp: Fix data-races around sysctl_tcp_no_ssthresh_metrics_save.
      tcp: Fix data-races around sysctl_tcp_moderate_rcvbuf.
      tcp: Fix data-races around sysctl_tcp_workaround_signed_windows.
      tcp: Fix a data-race around sysctl_tcp_limit_output_bytes.
      tcp: Fix a data-race around sysctl_tcp_challenge_ack_limit.
      tcp: Fix a data-race around sysctl_tcp_min_tso_segs.
      tcp: Fix a data-race around sysctl_tcp_tso_rtt_log.
      tcp: Fix a data-race around sysctl_tcp_min_rtt_wlen.
      tcp: Fix a data-race around sysctl_tcp_autocorking.
      tcp: Fix a data-race around sysctl_tcp_invalid_ratelimit.
      tcp: Fix data-races around sk_pacing_rate.
      net: Fix data-races around sysctl_[rw]mem(_offset)?.
      tcp: Fix a data-race around sysctl_tcp_comp_sack_delay_ns.
      tcp: Fix a data-race around sysctl_tcp_comp_sack_slack_ns.
      tcp: Fix a data-race around sysctl_tcp_comp_sack_nr.
      tcp: Fix data-races around sysctl_tcp_reflect_tos.
      ipv4: Fix data-races around sysctl_fib_notify_on_flag_change.
      net: ping6: Fix memleak in ipv6_renew_options().

Liang He (1):
      net: sungem_phy: Add of_node_put() for reference returned by of_get_parent()

Luiz Augusto von Dentz (1):
      Bluetooth: L2CAP: Fix use-after-free caused by l2cap_chan_put

Maciej Fijalkowski (2):
      ice: check (DD | EOF) bits on Rx descriptor rather than (EOP | RS)
      ice: do not setup vlan for loopback VSI

Mat Martineau (1):
      mptcp: Do not return EINPROGRESS when subflow creation succeeds

Maxim Mikityanskiy (1):
      net/tls: Remove the context from the list in tls_device_down

Michal Maloszewski (1):
      i40e: Fix interface init with MSI interrupts (no MSI-X)

Paolo Abeni (1):
      Merge branch 'octeontx2-minor-tc-fixes'

Przemyslaw Patynowski (2):
      ice: Fix max VLANs available for VF
      ice: Fix tunnel checksum offload with fragmented traffic

Rob Herring (2):
      dt-bindings: net: ethernet-controller: Rework 'fixed-link' schema
      dt-bindings: net: fsl,fec: Add missing types to phy-reset-* properties

Sabrina Dubroca (4):
      macsec: fix NULL deref in macsec_add_rxsa
      macsec: fix error message in macsec_add_rxsa and _txsa
      macsec: limit replay window size with XPN
      macsec: always read MACSEC_SA_ATTR_PN as a u64

Slark Xiao (3):
      nfp: bpf: Fix typo 'the the' in comment
      net: ipa: Fix typo 'the the' in comment
      s390/qeth: Fix typo 'the the' in comment

Subbaraya Sundeep (1):
      octeontx2-pf: Fix UDP/TCP src and dst port tc filters

Sunil Goutham (1):
      octeontx2-pf: cn10k: Fix egress ratelimit configuration

Taehee Yoo (1):
      net: mld: fix reference count leak in mld_{query | report}_work()

Tetsuo Handa (1):
      wifi: mac80211: do not abuse fq.lock in ieee80211_do_stop()

Vladimir Oltean (2):
      net: pcs: xpcs: propagate xpcs_read error to xpcs_get_state_c37_sgmii
      net: dsa: fix reference counting for LAG FDBs

Wei Wang (1):
      Revert "tcp: change pingpong threshold to 3"

Xin Long (2):
      Documentation: fix sctp_wmem in ip-sysctl.rst
      sctp: leave the err path free in sctp_stream_init to sctp_stream_free

Ziyang Xuan (1):
      ipv6/addrconf: fix a null-ptr-deref bug for ip6_ptr

 .../bindings/net/ethernet-controller.yaml          | 123 ++++++++++-----------
 Documentation/devicetree/bindings/net/fsl,fec.yaml |   3 +
 Documentation/networking/ip-sysctl.rst             |   9 +-
 drivers/net/ethernet/fungible/funeth/funeth_rx.c   |   5 +-
 drivers/net/ethernet/fungible/funeth/funeth_tx.c   |  20 ++--
 drivers/net/ethernet/fungible/funeth/funeth_txrx.h |   6 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c        |   4 +
 drivers/net/ethernet/intel/ice/ice_ethtool.c       |   3 +-
 drivers/net/ethernet/intel/ice/ice_main.c          |  10 +-
 drivers/net/ethernet/intel/ice/ice_sriov.c         |  40 -------
 drivers/net/ethernet/intel/ice/ice_txrx.c          |   8 +-
 drivers/net/ethernet/intel/ice/ice_virtchnl.c      |   3 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_tc.c   | 106 ++++++++++++------
 drivers/net/ethernet/netronome/nfp/bpf/jit.c       |   2 +-
 drivers/net/ethernet/sfc/ptp.c                     |  22 ++++
 .../net/ethernet/stmicro/stmmac/dwmac-mediatek.c   |   9 +-
 drivers/net/ipa/ipa_qmi_msg.h                      |   2 +-
 drivers/net/macsec.c                               |  33 ++++--
 drivers/net/pcs/pcs-xpcs.c                         |   2 +-
 drivers/net/sungem_phy.c                           |   1 +
 drivers/net/virtio_net.c                           |  37 ++++++-
 drivers/ptp/Kconfig                                |   1 +
 drivers/s390/net/qeth_core_main.c                  |   2 +-
 include/net/addrconf.h                             |   3 +
 include/net/bluetooth/l2cap.h                      |   1 +
 include/net/inet_connection_sock.h                 |  10 +-
 include/net/sock.h                                 |   8 +-
 include/net/tcp.h                                  |   2 +-
 net/bluetooth/hci_sync.c                           |   6 +-
 net/bluetooth/l2cap_core.c                         |  61 +++++++---
 net/bluetooth/mgmt.c                               |   1 -
 net/bridge/br_netlink.c                            |   8 +-
 net/caif/caif_socket.c                             |  20 ++--
 net/decnet/af_decnet.c                             |   4 +-
 net/dsa/switch.c                                   |   1 +
 net/ipv4/fib_trie.c                                |   7 +-
 net/ipv4/tcp.c                                     |  23 ++--
 net/ipv4/tcp_input.c                               |  41 +++----
 net/ipv4/tcp_ipv4.c                                |   4 +-
 net/ipv4/tcp_metrics.c                             |  10 +-
 net/ipv4/tcp_output.c                              |  27 ++---
 net/ipv6/mcast.c                                   |  14 ++-
 net/ipv6/ping.c                                    |   6 +
 net/ipv6/tcp_ipv6.c                                |   4 +-
 net/mac80211/iface.c                               |   3 +-
 net/mptcp/options.c                                |   2 +-
 net/mptcp/protocol.c                               |   8 +-
 net/mptcp/subflow.c                                |   2 +-
 net/netfilter/nf_tables_api.c                      |   6 +
 net/netfilter/nfnetlink_queue.c                    |   7 +-
 net/netfilter/nft_queue.c                          |  27 +++++
 net/sctp/associola.c                               |   5 +-
 net/sctp/stream.c                                  |  19 +---
 net/sctp/stream_sched.c                            |   2 +-
 net/tipc/socket.c                                  |   2 +-
 net/tls/tls_device.c                               |   7 +-
 56 files changed, 481 insertions(+), 321 deletions(-)
