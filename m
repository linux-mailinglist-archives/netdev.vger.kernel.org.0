Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D9156BE0A7
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 06:32:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229820AbjCQFcA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 01:32:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbjCQFb6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 01:31:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2BE6B79D0;
        Thu, 16 Mar 2023 22:31:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0C69F621AF;
        Fri, 17 Mar 2023 05:31:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E25EC433EF;
        Fri, 17 Mar 2023 05:31:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679031113;
        bh=zL+T0eThYopPNKOijEeDmS5OMHiLaG7lOtYlKB0TBqI=;
        h=From:To:Cc:Subject:Date:From;
        b=lWm+mhHf3Ptr5S2bMcRgBI025W0kR/lzm+jSzcyHEMB7QW4FUujOew+FPcsxrzM2C
         DMfuas81Vq6KpXiGVLn24zmCcNvWo6wWkRPy/zKu0VqlXIvc59n/EvFRqRg9WJPLfy
         g7wfQ4GB9E6UY09pjHwiDsP59W2XpBBghA88JE0pKsymHjBiRHrnrkaF39lZ4IOUld
         1KbCMpHhzgOgUhAM1I8GCSpwPq1qO/ZAqpanB8oT/dLREabx+q65Lu9Dnpr6RRGQS3
         kudO/fNNHptL2GPXm8DRO0XrjGxYaBzapDyAkNRmKElKjUiUlaT4De614pLDQF/f7X
         kGd8W/a7URoFA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     torvalds@linux-foundation.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, pabeni@redhat.com
Subject: [PULL] Networking for v6.3-rc3
Date:   Thu, 16 Mar 2023 22:31:52 -0700
Message-Id: <20230317053152.2232639-1-kuba@kernel.org>
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

A little more changes than usual, but it's pretty normal for us
that the rc3/rc4 PRs are oversized as people start testing in
earnest. Possibly an extra boost from people deploying the 6.1 LTS
but that's more of an unscientific hunch.

The following changes since commit 44889ba56cbb3d51154660ccd15818bc77276696:

  Merge tag 'net-6.3-rc2' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2023-03-09 10:56:58 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-6.3-rc3

for you to fetch changes up to 0c98b8bc48cf91bf8bdad123d6c07195341b0a81:

  Merge branch 'net-ipa-minor-bug-fixes' (2023-03-16 21:33:20 -0700)

----------------------------------------------------------------
Including fixes from netfilter, wifi and ipsec.

Current release - regressions:

 - phy: mscc: fix deadlock in phy_ethtool_{get,set}_wol()

 - virtio: vsock: don't use skbuff state to account credit

 - virtio: vsock: don't drop skbuff on copy failure

 - virtio_net: fix page_to_skb() miscalculating the memory size

Current release - new code bugs:

 - eth: correct xdp_features after device reconfig

 - wifi: nl80211: fix the puncturing bitmap policy

 - net/mlx5e: flower:
   - fix raw counter initialization
   - fix missing error code
   - fix cloned flow attribute

 - ipa:
   - fix some register validity checks
   - fix a surprising number of bad offsets
   - kill FILT_ROUT_CACHE_CFG IPA register

Previous releases - regressions:

 - tcp: fix bind() conflict check for dual-stack wildcard address

 - veth: fix use after free in XDP_REDIRECT when skb headroom is small

 - ipv4: fix incorrect table ID in IOCTL path

 - ipvlan: make skb->skb_iif track skb->dev for l3s mode

 - mptcp:
  - fix possible deadlock in subflow_error_report
  - fix UaFs when destroying unaccepted and listening sockets

 - dsa: mv88e6xxx: fix max_mtu of 1492 on 6165, 6191, 6220, 6250, 6290

Previous releases - always broken:

 - tcp: tcp_make_synack() can be called from process context,
   don't assume preemption is disabled when updating stats

 - netfilter: correct length for loading protocol registers

 - virtio_net: add checking sq is full inside xdp xmit

 - phy: nxp-c45-tja11xx: fix MII_BASIC_CONFIG_REV bit number

 - eth: i40e: fix crash during reboot when adapter is in recovery mode

 - eth: ice: avoid deadlock on rtnl lock when auxiliary device
   plug/unplug meets bonding

 - dsa: mt7530:
   - remove now incorrect comment regarding port 5
   - set PLL frequency and trgmii only when trgmii is used

 - eth: mtk_eth_soc: reset PCS state when changing interface types

Misc:

 - ynl: another license adjustment

 - move the TCA_EXT_WARN_MSG attribute for tc action

Signed-off-by: Jakub Kicinski <kuba@kernel.org>

----------------------------------------------------------------
Adham Faris (1):
      net/mlx5e: Lower maximum allowed MTU in XSK to match XDP prerequisites

Alex Elder (5):
      net: ipa: fix a surprising number of bad offsets
      net: ipa: reg: include <linux/bug.h>
      net: ipa: add two missing declarations
      net: ipa: kill FILT_ROUT_CACHE_CFG IPA register
      net: ipa: fix some register validity checks

Alexandra Winter (1):
      net/iucv: Fix size of interrupt data

Arseniy Krasnov (4):
      virtio/vsock: don't use skbuff state to account credit
      virtio/vsock: remove redundant 'skb_pull()' call
      virtio/vsock: don't drop skbuff on copy failure
      test/vsock: copy to user failure test

Arınç ÜNAL (2):
      net: dsa: mt7530: remove now incorrect comment regarding port 5
      net: dsa: mt7530: set PLL frequency and trgmii only when trgmii is used

Breno Leitao (1):
      tcp: tcp_make_synack() can be called from process context

D. Wythe (1):
      net/smc: fix NULL sndbuf_desc in smc_cdc_tx_handler()

Daniel Golle (2):
      net: ethernet: mtk_eth_soc: reset PCS state
      net: ethernet: mtk_eth_soc: only write values if needed

Daniel Jurgens (1):
      net/mlx5: Disable eswitch before waiting for VF pages

Daniil Tatianin (2):
      qed/qed_dev: guard against a possible division by zero
      qed/qed_mng_tlv: correctly zero out ->min instead of ->hour

Dave Ertman (1):
      ice: avoid bonding causing auxiliary plug/unplug under RTNL lock

David S. Miller (5):
      Merge branch 'net-smc-fixes'
      Merge branch 'mtk_eth_soc-SGMII-fixes'
      Merge branch 'net-virtio-vsock'
      Merge branch 'net-dsa-marvell-mtu-reporting'
      Merge branch 'virtio_net-xdp-bugs'

Emeel Hakim (1):
      net/mlx5e: Fix macsec ASO context alignment

Eric Dumazet (1):
      net: tunnels: annotate lockless accesses to dev->needed_headroom

Fedor Pchelkin (1):
      nfc: pn533: initialize struct pn533_out_arg properly

Gal Pressman (1):
      net/mlx5e: kTLS, Fix missing error unwind on unsupported cipher type

Geliang Tang (1):
      mptcp: add ro_after_init for tcp{,v6}_prot_override

Hangbin Liu (2):
      Revert "net/sched: act_api: move TCA_EXT_WARN_MSG to the correct hierarchy"
      net/sched: act_api: add specific EXT_WARN_MSG for tc action

Heiner Kallweit (1):
      net: phy: smsc: bail out in lan87xx_read_status if genphy_read_status fails

Herbert Xu (2):
      xfrm: Zero padding when dumping algos and encap
      xfrm: Allow transport-mode states with AF_UNSPEC selector

Ido Schimmel (2):
      mlxsw: spectrum: Fix incorrect parsing depth after reload
      ipv4: Fix incorrect table ID in IOCTL path

Ivan Vecera (1):
      i40e: Fix kernel crash during reboot when adapter is in recovery mode

Jakub Kicinski (16):
      Merge branch 'add-checking-sq-is-full-inside-xdp-xmit'
      Merge tag 'wireless-2023-03-10' of git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless
      Merge branch 'update-xdp_features-flag-according-to-nic-re-configuration'
      Merge branch 'mptcp-fixes-for-6-3'
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf
      Merge branch 'tcp-fix-bind-regression-for-dual-stack-wildcard-address'
      Merge branch 'net-renesas-set-mac_managed_pm-at-probe-time'
      Merge tag 'ipsec-2023-03-15' of git://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec
      Merge tag 'mlx5-fixes-2023-03-15' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux
      tools: ynl: make definitions optional again
      ynl: broaden the license even more
      ynl: make the tooling check the license
      Merge branch 'ynl-another-license-adjustment'
      Merge branch 'net-sched-fix-parsing-of-tca_ext_warn_msg-for-tc-action'
      net: xdp: don't call notifiers during driver init
      Merge branch 'net-ipa-minor-bug-fixes'

Jeremy Sowden (4):
      netfilter: nft_nat: correct length for loading protocol registers
      netfilter: nft_masq: correct length for loading protocol registers
      netfilter: nft_redir: correct length for loading protocol registers
      netfilter: nft_redir: correct value of inet type `.maxattrs`

Jianguo Wu (1):
      ipvlan: Make skb->skb_iif track skb->dev for l3s mode

Jiri Pirko (1):
      MAINTAINERS: make my email address consistent

Johannes Berg (4):
      wifi: nl80211: fix NULL-ptr deref in offchan check
      wifi: nl80211: fix puncturing bitmap policy
      wifi: mac80211: check basic rates validity
      wifi: cfg80211: fix MLO connection ownership

Kristian Overskeid (1):
      net: hsr: Don't log netdev_err message on unknown prp dst node

Kuniyuki Iwashima (2):
      tcp: Fix bind() conflict check for dual-stack wildcard address.
      selftest: Add test for bind() conflicts.

Lorenzo Bianconi (8):
      tools: ynl: fix render-max for flags definition
      tools: ynl: fix get_mask utility routine
      xdp: add xdp_set_features_flag utility routine
      net: thunderx: take into account xdp_features setting tx/rx queues
      net: ena: take into account xdp_features setting tx/rx queues
      veth: take into account device reconfiguration for xdp_features flag
      net/mlx5e: take into account device reconfiguration for xdp_features flag
      veth: rely on rtnl_dereference() instead of on rcu_dereference() in veth_set_xdp_features()

Maciej Fijalkowski (1):
      ice: xsk: disable txq irq before flushing hw

Maor Dickman (2):
      net/mlx5: E-switch, Fix wrong usage of source port rewrite in split rules
      net/mlx5: E-switch, Fix missing set of split_count when forward to ovs internal port

Marek Vasut (1):
      net: dsa: microchip: fix RGMII delay configuration on KSZ8765/KSZ8794/KSZ8795

Matteo Croce (1):
      mvpp2: take care of xdp_features when reconfiguring queues

Matthieu Baerts (3):
      selftests: mptcp: userspace pm: fix printed values
      mptcp: avoid setting TCP_CLOSE state twice
      hsr: ratelimit only when errors are printed

Oz Shlomo (4):
      net/sched: TC, fix raw counter initialization
      net/mlx5e: TC, fix missing error code
      net/mlx5e: TC, fix cloned flow attribute
      net/mlx5e: TC, Remove error message log print

Paolo Abeni (5):
      mptcp: fix possible deadlock in subflow_error_report
      mptcp: refactor passive socket initialization
      mptcp: use the workqueue to destroy unaccepted sockets
      mptcp: fix UaF in listener shutdown
      mptcp: fix lockdep false positive in mptcp_pm_nl_create_listen_socket()

Parav Pandit (2):
      net/mlx5e: Don't cache tunnel offloads capability
      net/mlx5: Fix setting ec_function bit in MANAGE_PAGES

Paul Blakey (1):
      net/mlx5e: Fix cleanup null-ptr deref on encap lock

Po-Hsu Lin (1):
      selftests: net: devlink_port_split.py: skip test if no suitable device available

Radu Pirea (OSS) (1):
      net: phy: nxp-c45-tja11xx: fix MII_BASIC_CONFIG_REV bit

Rob Herring (1):
      net: Use of_property_read_bool() for boolean properties

Shawn Bohrer (1):
      veth: Fix use after free in XDP_REDIRECT

Shay Drory (1):
      net/mlx5: Set BREAK_FW_WAIT flag first when removing driver

Stefan Raspl (1):
      net/smc: Fix device de-init sequence

Szymon Heidrich (2):
      net: usb: smsc75xx: Limit packet length to skb->len
      net: usb: smsc75xx: Move packet length check to prevent kernel panic in skb_pull

Thomas Bogendoerfer (1):
      i825xx: sni_82596: use eth_hw_addr_set()

Toke Høiland-Jørgensen (1):
      net: atlantic: Fix crash when XDP is enabled but no program is loaded

Vadim Fedorenko (1):
      bnxt_en: reset PHC frequency in free-running mode

Vladimir Oltean (3):
      net: phy: mscc: fix deadlock in phy_ethtool_{get,set}_wol()
      net: dsa: don't error out when drivers return ETH_DATA_LEN in .port_max_mtu()
      net: dsa: mv88e6xxx: fix max_mtu of 1492 on 6165, 6191, 6220, 6250, 6290

Wenjia Zhang (1):
      net/smc: fix deadlock triggered by cancel_delayed_work_syn()

Wolfram Sang (2):
      ravb: avoid PHY being resumed when interface is not up
      sh_eth: avoid PHY being resumed when interface is not up

Xuan Zhuo (5):
      virtio_net: reorder some funcs
      virtio_net: separate the logic of checking whether sq is full
      virtio_net: add checking sq is full inside xdp xmit
      virtio_net: fix page_to_skb() miss headroom
      virtio_net: free xdp shinfo frags when build_skb_from_xdp_buff() fails

Zheng Wang (1):
      nfc: st-nci: Fix use after free bug in ndlc_remove due to race condition

 .mailmap                                           |   3 +
 Documentation/netlink/genetlink-c.yaml             |   2 +-
 Documentation/netlink/genetlink-legacy.yaml        |   2 +-
 Documentation/netlink/genetlink.yaml               |   2 +-
 Documentation/netlink/specs/ethtool.yaml           |   2 +-
 Documentation/netlink/specs/fou.yaml               |   2 +-
 Documentation/netlink/specs/netdev.yaml            |   3 +-
 Documentation/userspace-api/netlink/specs.rst      |   3 +-
 MAINTAINERS                                        |   6 +-
 drivers/net/can/cc770/cc770_platform.c             |  12 +-
 drivers/net/dsa/microchip/ksz_common.c             |   2 +-
 drivers/net/dsa/mt7530.c                           |  64 ++++----
 drivers/net/dsa/mv88e6xxx/chip.c                   |  16 +-
 drivers/net/ethernet/amazon/ena/ena_ethtool.c      |  15 +-
 drivers/net/ethernet/amazon/ena/ena_netdev.c       |   6 +-
 drivers/net/ethernet/aquantia/atlantic/aq_ring.c   |  28 +++-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |   6 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h          |   2 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c      |  56 ++++---
 drivers/net/ethernet/cadence/macb_main.c           |   2 +-
 .../net/ethernet/cavium/thunder/nicvf_ethtool.c    |  17 +-
 drivers/net/ethernet/cavium/thunder/nicvf_main.c   |   4 +-
 drivers/net/ethernet/davicom/dm9000.c              |   4 +-
 drivers/net/ethernet/freescale/fec_main.c          |   2 +-
 drivers/net/ethernet/freescale/fec_mpc52xx.c       |   2 +-
 drivers/net/ethernet/freescale/gianfar.c           |   4 +-
 drivers/net/ethernet/i825xx/sni_82596.c            |  14 +-
 drivers/net/ethernet/ibm/emac/core.c               |   8 +-
 drivers/net/ethernet/ibm/emac/rgmii.c              |   2 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c        |   1 +
 drivers/net/ethernet/intel/ice/ice.h               |  14 +-
 drivers/net/ethernet/intel/ice/ice_main.c          |  19 +--
 drivers/net/ethernet/intel/ice/ice_xsk.c           |   5 +-
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c    |  15 +-
 drivers/net/ethernet/mediatek/mtk_eth_soc.h        |   4 +
 drivers/net/ethernet/mediatek/mtk_sgmii.c          |  28 ++--
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |   2 +-
 .../ethernet/mellanox/mlx5/core/en/tc/act/police.c |   1 -
 .../ethernet/mellanox/mlx5/core/en/tc/act_stats.c  |   5 +
 .../ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c |  24 +--
 .../ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c |  22 +--
 .../ethernet/mellanox/mlx5/core/en_accel/macsec.c  |   2 +-
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |  10 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  51 ++++--
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |  21 ++-
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |  10 +-
 .../net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c  |   1 -
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |   4 +-
 .../net/ethernet/mellanox/mlx5/core/pagealloc.c    |  22 ++-
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c     |   2 +
 .../net/ethernet/mellanox/mlxsw/spectrum_router.c  |  14 ++
 drivers/net/ethernet/qlogic/qed/qed_dev.c          |   5 +
 drivers/net/ethernet/qlogic/qed/qed_mng_tlv.c      |   2 +-
 drivers/net/ethernet/renesas/ravb_main.c           |  12 +-
 drivers/net/ethernet/renesas/sh_eth.c              |  12 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac-imx.c    |   3 +-
 drivers/net/ethernet/sun/niu.c                     |   2 +-
 drivers/net/ethernet/ti/cpsw-phy-sel.c             |   3 +-
 drivers/net/ethernet/ti/netcp_ethss.c              |   8 +-
 drivers/net/ethernet/via/via-velocity.c            |   3 +-
 drivers/net/ethernet/via/via-velocity.h            |   2 +-
 drivers/net/ethernet/xilinx/ll_temac_main.c        |   9 +-
 drivers/net/ipa/gsi_reg.c                          |   9 +-
 drivers/net/ipa/gsi_reg.h                          |   4 +
 drivers/net/ipa/ipa_reg.c                          |  28 ++--
 drivers/net/ipa/ipa_reg.h                          |  21 +--
 drivers/net/ipa/reg.h                              |   3 +-
 drivers/net/ipa/reg/gsi_reg-v4.5.c                 |  56 +++----
 drivers/net/ipa/reg/gsi_reg-v4.9.c                 |  44 +++---
 drivers/net/ipvlan/ipvlan_l3s.c                    |   1 +
 drivers/net/phy/mscc/mscc_main.c                   |  24 +--
 drivers/net/phy/nxp-c45-tja11xx.c                  |   2 +-
 drivers/net/phy/smsc.c                             |   5 +-
 drivers/net/usb/smsc75xx.c                         |   7 +
 drivers/net/veth.c                                 |  48 +++++-
 drivers/net/virtio_net.c                           | 171 ++++++++++++---------
 drivers/net/wan/fsl_ucc_hdlc.c                     |  11 +-
 drivers/net/wireless/ti/wlcore/spi.c               |   3 +-
 drivers/nfc/pn533/usb.c                            |   1 +
 drivers/nfc/st-nci/ndlc.c                          |   6 +-
 include/linux/netdevice.h                          |   6 +-
 include/net/xdp.h                                  |  11 ++
 include/uapi/linux/fou.h                           |   2 +-
 include/uapi/linux/netdev.h                        |   4 +-
 include/uapi/linux/rtnetlink.h                     |   1 +
 net/core/netdev-genl-gen.c                         |   2 +-
 net/core/netdev-genl-gen.h                         |   2 +-
 net/core/xdp.c                                     |  28 +++-
 net/dsa/slave.c                                    |   9 +-
 net/hsr/hsr_framereg.c                             |   2 +-
 net/ipv4/fib_frontend.c                            |   3 +
 net/ipv4/fou_nl.c                                  |   2 +-
 net/ipv4/fou_nl.h                                  |   2 +-
 net/ipv4/inet_hashtables.c                         |   8 +-
 net/ipv4/ip_tunnel.c                               |  12 +-
 net/ipv4/tcp_output.c                              |   2 +-
 net/ipv6/ip6_tunnel.c                              |   4 +-
 net/iucv/iucv.c                                    |   2 +-
 net/mac80211/cfg.c                                 |  21 +--
 net/mptcp/pm_netlink.c                             |  16 ++
 net/mptcp/protocol.c                               |  64 ++++----
 net/mptcp/protocol.h                               |   6 +-
 net/mptcp/subflow.c                                | 128 +++++----------
 net/ncsi/ncsi-manage.c                             |   4 +-
 net/netfilter/nft_masq.c                           |   2 +-
 net/netfilter/nft_nat.c                            |   2 +-
 net/netfilter/nft_redir.c                          |   4 +-
 net/sched/act_api.c                                |   8 +-
 net/smc/af_smc.c                                   |   1 +
 net/smc/smc_cdc.c                                  |   3 +
 net/smc/smc_core.c                                 |   2 +-
 net/vmw_vsock/virtio_transport_common.c            |  29 ++--
 net/wireless/nl80211.c                             |  26 ++--
 net/xfrm/xfrm_state.c                              |   5 -
 net/xfrm/xfrm_user.c                               |  45 +++++-
 tools/include/uapi/linux/netdev.h                  |   4 +-
 tools/net/ynl/lib/nlspec.py                        |  17 +-
 tools/net/ynl/ynl-gen-c.py                         |  26 ++--
 tools/testing/selftests/net/.gitignore             |   1 +
 tools/testing/selftests/net/Makefile               |   1 +
 tools/testing/selftests/net/bind_wildcard.c        | 114 ++++++++++++++
 tools/testing/selftests/net/devlink_port_split.py  |  36 ++++-
 tools/testing/selftests/net/mptcp/userspace_pm.sh  |   2 +-
 tools/testing/vsock/vsock_test.c                   | 118 ++++++++++++++
 125 files changed, 1204 insertions(+), 660 deletions(-)
 create mode 100644 tools/testing/selftests/net/bind_wildcard.c
