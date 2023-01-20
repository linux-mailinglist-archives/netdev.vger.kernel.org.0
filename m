Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C90E675AF0
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 18:17:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbjATRRR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 12:17:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbjATRRQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 12:17:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0558C474CD;
        Fri, 20 Jan 2023 09:17:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 935566201F;
        Fri, 20 Jan 2023 17:17:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7285CC4339B;
        Fri, 20 Jan 2023 17:17:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674235034;
        bh=HddGKq7jpAFH3stbFop+NtpcRF44pZc1QHNJRcPQQGc=;
        h=From:To:Cc:Subject:Date:From;
        b=H/Nn3P3CVFEy0mPqyB4akF+1CP2OXL209t+UsdvSToY8yTwL5+FtPqcCao0zzCEV0
         NBiAZyE1XHW7l3zIASGLgnXZ0/WjrzdRUsBvgE9HhIoHjUf+CnJNTbCu1p/mmFle6z
         /M8lAsfYj20EcygFOFvft7lzs24+lcTOEduaRHRf7U7ccxF/UCY5956LsS0kkonIbD
         2uct8NSk+N/NsD06d++0hb8RrZTkvrttZcan0V7Kz1k8R9C6XA4bi86IBFCJwygQp+
         Sy3dfg6ibkzEGe1TqLZ0y87NBC0ZHQrIUdiq5Y28E1HbbC3aA1vuXYrWBMNbqCQ0s0
         EMe/Vf/OvNOqA==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, davem@davemloft.net, kuba@kernel.org,
        hawk@kernel.org, pabeni@redhat.com, edumazet@google.com,
        toke@redhat.com, memxor@gmail.com, alardam@gmail.com,
        saeedm@nvidia.com, anthony.l.nguyen@intel.com, gospo@broadcom.com,
        vladimir.oltean@nxp.com, nbd@nbd.name, john@phrozen.org,
        leon@kernel.org, simon.horman@corigine.com, aelior@marvell.com,
        christophe.jaillet@wanadoo.fr, ecree.xilinx@gmail.com,
        mst@redhat.com, bjorn@kernel.org, magnus.karlsson@intel.com,
        maciej.fijalkowski@intel.com, intel-wired-lan@lists.osuosl.org,
        lorenzo.bianconi@redhat.com, niklas.soderlund@corigine.com
Subject: [PATCH bpf-next 0/7] xdp: introduce xdp-feature support
Date:   Fri, 20 Jan 2023 18:16:49 +0100
Message-Id: <cover.1674234430.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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

Lorenzo Bianconi (4):
  libbpf: add the capability to specify netlink proto in
    libbpf_netlink_send_recv
  libbpf: add API to get XDP/XSK supported features
  bpf: devmap: check XDP features in bpf_map_update_elem and
    __xdp_enqueue
  selftests/bpf: introduce XDP compliance test tool

Marek Majtyka (2):
  drivers: net: turn on XDP features
  xsk: add usage of XDP features flags

 Documentation/netlink/specs/netdev.yaml       |  72 ++
 drivers/net/ethernet/amazon/ena/ena_netdev.c  |   5 +
 .../net/ethernet/aquantia/atlantic/aq_nic.c   |   4 +
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     |   2 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c |   2 +
 .../net/ethernet/cavium/thunder/nicvf_main.c  |   2 +
 .../net/ethernet/freescale/dpaa/dpaa_eth.c    |   2 +
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  |   1 +
 .../net/ethernet/freescale/enetc/enetc_pf.c   |   2 +
 .../ethernet/fungible/funeth/funeth_main.c    |   6 +
 drivers/net/ethernet/intel/i40e/i40e_main.c   |  10 +-
 drivers/net/ethernet/intel/ice/ice_main.c     |   5 +
 drivers/net/ethernet/intel/igb/igb_main.c     |  10 +-
 drivers/net/ethernet/intel/igc/igc_main.c     |   2 +
 drivers/net/ethernet/intel/igc/igc_xdp.c      |   5 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |   5 +
 .../net/ethernet/intel/ixgbevf/ixgbevf_main.c |   1 +
 drivers/net/ethernet/marvell/mvneta.c         |   2 +
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   |   3 +
 .../ethernet/marvell/octeontx2/nic/otx2_pf.c  |   8 +-
 drivers/net/ethernet/mediatek/mtk_eth_soc.c   |   5 +
 .../net/ethernet/mellanox/mlx4/en_netdev.c    |   2 +
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  10 +
 drivers/net/ethernet/microsoft/mana/mana_en.c |   1 +
 .../ethernet/netronome/nfp/nfp_net_common.c   |   5 +
 drivers/net/ethernet/qlogic/qede/qede_main.c  |   2 +
 drivers/net/ethernet/sfc/efx.c                |   3 +
 drivers/net/ethernet/sfc/siena/efx.c          |   3 +
 drivers/net/ethernet/socionext/netsec.c       |   2 +
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |   1 +
 drivers/net/ethernet/ti/cpsw.c                |   2 +
 drivers/net/ethernet/ti/cpsw_new.c            |   3 +
 drivers/net/hyperv/netvsc_drv.c               |   2 +
 drivers/net/netdevsim/netdev.c                |   1 +
 drivers/net/tun.c                             |   4 +
 drivers/net/veth.c                            |   3 +
 drivers/net/virtio_net.c                      |   5 +
 drivers/net/xen-netfront.c                    |   1 +
 include/linux/netdevice.h                     |   2 +
 include/net/xdp.h                             |  34 +
 include/uapi/linux/netdev.h                   |  66 ++
 kernel/bpf/devmap.c                           |  25 +-
 net/core/Makefile                             |   3 +-
 net/core/filter.c                             |  13 +-
 net/core/netdev-genl-gen.c                    |  48 ++
 net/core/netdev-genl-gen.h                    |  23 +
 net/core/netdev-genl.c                        | 178 +++++
 net/xdp/xsk_buff_pool.c                       |   3 +-
 tools/include/uapi/linux/netdev.h             |  66 ++
 tools/lib/bpf/libbpf.h                        |   3 +-
 tools/lib/bpf/netlink.c                       | 121 ++-
 tools/lib/bpf/nlattr.h                        |  12 +
 tools/testing/selftests/bpf/Makefile          |   5 +-
 .../selftests/bpf/progs/test_xdp_features.c   | 237 ++++++
 .../selftests/bpf/test_xdp_features.sh        |  99 +++
 tools/testing/selftests/bpf/xdp_features.c    | 743 ++++++++++++++++++
 56 files changed, 1852 insertions(+), 33 deletions(-)
 create mode 100644 Documentation/netlink/specs/netdev.yaml
 create mode 100644 include/uapi/linux/netdev.h
 create mode 100644 net/core/netdev-genl-gen.c
 create mode 100644 net/core/netdev-genl-gen.h
 create mode 100644 net/core/netdev-genl.c
 create mode 100644 tools/include/uapi/linux/netdev.h
 create mode 100644 tools/testing/selftests/bpf/progs/test_xdp_features.c
 create mode 100755 tools/testing/selftests/bpf/test_xdp_features.sh
 create mode 100644 tools/testing/selftests/bpf/xdp_features.c

-- 
2.39.0

