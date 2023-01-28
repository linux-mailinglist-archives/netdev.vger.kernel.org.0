Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C94B67F85F
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 15:06:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233631AbjA1OGo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Jan 2023 09:06:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230175AbjA1OGo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Jan 2023 09:06:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B12AA3C2C;
        Sat, 28 Jan 2023 06:06:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3AB2160C05;
        Sat, 28 Jan 2023 14:06:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1778AC4339B;
        Sat, 28 Jan 2023 14:06:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674914801;
        bh=/lg9r1PrlzYTWrbPq6/YzOGbXiWbjRm+A8rXFVtzXl4=;
        h=From:To:Cc:Subject:Date:From;
        b=KLNX3PsH/m1fT8Q46hsNE6eM20GGH7P3k6U2VTLS+Xb5zD3/XUfYBZD+OsEdJzwmi
         swIjbL6XRrI8Kwfa1pMdxGcCqk5DrmHEYL59OVvlsjmenjjMNPL76pZMrb+txM3f/3
         VIlRFEZjDXF07/g9T7v8+wW8Alsb/chsOvP/0pFhqXYGcD+emGjm+PUhQ+YMEangui
         qtpBBUYF6dNKxArxhfmfiW2YcIQ3FHfUw1cLQf/3Lfa75/3Xk7XQpw2Pqqw38uu9zW
         9cNHFHp+Fdk103Toodu/Qtjgn+YNv9sjlVy9Eojs8YWBHxveEZF2wbkQ32q9XnFaFG
         IEFs5XQyAU+UA==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, hawk@kernel.org,
        toke@redhat.com, memxor@gmail.com, alardam@gmail.com,
        saeedm@nvidia.com, anthony.l.nguyen@intel.com, gospo@broadcom.com,
        vladimir.oltean@nxp.com, nbd@nbd.name, john@phrozen.org,
        leon@kernel.org, simon.horman@corigine.com, aelior@marvell.com,
        christophe.jaillet@wanadoo.fr, ecree.xilinx@gmail.com,
        mst@redhat.com, bjorn@kernel.org, magnus.karlsson@intel.com,
        maciej.fijalkowski@intel.com, intel-wired-lan@lists.osuosl.org,
        lorenzo.bianconi@redhat.com, martin.lau@linux.dev, sdf@google.com
Subject: [PATCH v4 bpf-next 0/8] xdp: introduce xdp-feature support
Date:   Sat, 28 Jan 2023 15:06:11 +0100
Message-Id: <cover.1674913191.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce the capability to export the XDP features supported by the NIC.
Introduce a XDP compliance test tool (xdp_features) to check the features
exported by the NIC match the real features supported by the driver.
Allow XDP_REDIRECT of non-linear XDP frames into a devmap.
Export XDP features for each XDP capable driver.
Extend libbpf netlink implementation in order to support netlink_generic
protocol.
Introduce a simple generic netlink family for netdev data.

Changes since v3:
- add IPv6 support to XDP compliance test tool
- rely on network_helpers in XDP compliance test tool
- cosmetics changes

Changes since v2:
- rebase on top of bpf-next
- fix compilation error

Changes since v1:
- add Documentation to netdev.yaml
- use flags instead of enum as type for netdev.yaml definitions
- squash XDP_PASS, XDP_DROP, XDP_TX and XDP_ABORTED into XDP_BASIC since they
  are supported by all drivers.
- add notifier event to xdp_features_set_redirect_target() and
  xdp_features_clear_redirect_target()
- add selftest for xdp-features support in bpf_xdp_detach()
- add IPv6 preliminary support to XDP compliance test tool

Changes since RFCv2:
- do not assume fixed layout for genl kernel messages
- fix warnings in netdev_nl_dev_fill
- fix capabilities for nfp driver
- add supported_sg parameter to xdp_features_set_redirect_target and drop
  __xdp_features_set_redirect_target routine

Changes since RFCv1:
- Introduce netdev-genl implementation and get rid of rtnl one.
- Introduce netlink_generic support in libbpf netlink implementation
- Rename XDP_FEATURE_* in NETDEV_XDP_ACT_*
- Rename XDP_FEATURE_REDIRECT_TARGET in NETDEV_XDP_ACT_NDO_XMIT
- Rename XDP_FEATURE_FRAG_RX in NETDEV_XDP_ACT_RX_SG
- Rename XDP_FEATURE_FRAG_TARFET in NETDEV_XDP_ACT_NDO_XMIT
- Get rid of XDP_LOCK feature.
- Move xdp_feature field in a netdevice struct hole in the 4th cacheline.

Jakub Kicinski (1):
  netdev-genl: create a simple family for netdev stuff

Lorenzo Bianconi (5):
  libbpf: add the capability to specify netlink proto in
    libbpf_netlink_send_recv
  libbpf: add API to get XDP/XSK supported features
  bpf: devmap: check XDP features in __xdp_enqueue routine
  selftests/bpf: add test for bpf_xdp_query xdp-features support
  selftests/bpf: introduce XDP compliance test tool

Marek Majtyka (2):
  drivers: net: turn on XDP features
  xsk: add usage of XDP features flags

 Documentation/netlink/specs/netdev.yaml       | 100 +++
 drivers/net/ethernet/amazon/ena/ena_netdev.c  |   4 +
 .../net/ethernet/aquantia/atlantic/aq_nic.c   |   5 +
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     |   3 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c |   2 +
 .../net/ethernet/cavium/thunder/nicvf_main.c  |   2 +
 .../net/ethernet/freescale/dpaa/dpaa_eth.c    |   4 +
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  |   4 +
 .../net/ethernet/freescale/enetc/enetc_pf.c   |   3 +
 .../ethernet/fungible/funeth/funeth_main.c    |   6 +
 drivers/net/ethernet/intel/i40e/i40e_main.c   |  10 +-
 drivers/net/ethernet/intel/ice/ice_main.c     |   5 +
 drivers/net/ethernet/intel/igb/igb_main.c     |   9 +-
 drivers/net/ethernet/intel/igc/igc_main.c     |   3 +
 drivers/net/ethernet/intel/igc/igc_xdp.c      |   5 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |   6 +
 .../net/ethernet/intel/ixgbevf/ixgbevf_main.c |   1 +
 drivers/net/ethernet/marvell/mvneta.c         |   3 +
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   |   4 +
 .../ethernet/marvell/octeontx2/nic/otx2_pf.c  |   8 +-
 drivers/net/ethernet/mediatek/mtk_eth_soc.c   |   6 +
 .../net/ethernet/mellanox/mlx4/en_netdev.c    |   2 +
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  11 +
 drivers/net/ethernet/microsoft/mana/mana_en.c |   2 +
 .../ethernet/netronome/nfp/nfp_net_common.c   |   5 +
 drivers/net/ethernet/qlogic/qede/qede_main.c  |   3 +
 drivers/net/ethernet/sfc/efx.c                |   4 +
 drivers/net/ethernet/sfc/siena/efx.c          |   4 +
 drivers/net/ethernet/socionext/netsec.c       |   3 +
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |   2 +
 drivers/net/ethernet/ti/cpsw.c                |   4 +
 drivers/net/ethernet/ti/cpsw_new.c            |   4 +
 drivers/net/hyperv/netvsc_drv.c               |   2 +
 drivers/net/netdevsim/netdev.c                |   1 +
 drivers/net/tun.c                             |   5 +
 drivers/net/veth.c                            |   4 +
 drivers/net/virtio_net.c                      |   4 +
 drivers/net/xen-netfront.c                    |   2 +
 include/linux/netdevice.h                     |   3 +
 include/net/xdp.h                             |  15 +
 include/uapi/linux/netdev.h                   |  59 ++
 kernel/bpf/devmap.c                           |  16 +-
 net/core/Makefile                             |   3 +-
 net/core/dev.c                                |   1 +
 net/core/filter.c                             |  13 +-
 net/core/netdev-genl-gen.c                    |  48 ++
 net/core/netdev-genl-gen.h                    |  23 +
 net/core/netdev-genl.c                        | 179 +++++
 net/core/xdp.c                                |  18 +
 net/xdp/xsk_buff_pool.c                       |   7 +-
 tools/include/uapi/linux/netdev.h             |  59 ++
 tools/lib/bpf/libbpf.h                        |   3 +-
 tools/lib/bpf/netlink.c                       | 118 ++-
 tools/lib/bpf/nlattr.h                        |  12 +
 tools/testing/selftests/bpf/.gitignore        |   1 +
 tools/testing/selftests/bpf/Makefile          |  11 +-
 .../bpf/prog_tests/xdp_do_redirect.c          |  27 +-
 .../selftests/bpf/prog_tests/xdp_info.c       |   8 +
 .../selftests/bpf/progs/xdp_features.c        | 275 +++++++
 .../selftests/bpf/test_xdp_features.sh        | 100 +++
 tools/testing/selftests/bpf/xdp_features.c    | 731 ++++++++++++++++++
 tools/testing/selftests/bpf/xdp_features.h    |  33 +
 62 files changed, 1985 insertions(+), 33 deletions(-)
 create mode 100644 Documentation/netlink/specs/netdev.yaml
 create mode 100644 include/uapi/linux/netdev.h
 create mode 100644 net/core/netdev-genl-gen.c
 create mode 100644 net/core/netdev-genl-gen.h
 create mode 100644 net/core/netdev-genl.c
 create mode 100644 tools/include/uapi/linux/netdev.h
 create mode 100644 tools/testing/selftests/bpf/progs/xdp_features.c
 create mode 100755 tools/testing/selftests/bpf/test_xdp_features.sh
 create mode 100644 tools/testing/selftests/bpf/xdp_features.c
 create mode 100644 tools/testing/selftests/bpf/xdp_features.h

-- 
2.39.1

