Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9ECD7650ED5
	for <lists+netdev@lfdr.de>; Mon, 19 Dec 2022 16:42:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231783AbiLSPmZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Dec 2022 10:42:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232283AbiLSPmX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Dec 2022 10:42:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83E6312083;
        Mon, 19 Dec 2022 07:42:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 25BC0B80EA3;
        Mon, 19 Dec 2022 15:42:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 428EAC433EF;
        Mon, 19 Dec 2022 15:42:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671464539;
        bh=tZDVjbL0ZWIptwNSQ822sM+4L3GOnBEYSN9bYCt+/R8=;
        h=From:To:Cc:Subject:Date:From;
        b=Z9R3pLLvaG4tAk5nWmynGQqmva0Sh2x+pbGmcO+FryktleNpiu7RpJdOXwMKMgPJm
         lFkEaDWfXwt2bfQxETjM7lk/qslBXHzHzaQ3PHFT/C5LYmDaRtB+08e4OTSkpDUv9t
         TWD8J9/6l903mX1YwDqbkS8GQr12+Vv1lTE+P8OYG58ErcdXlsuCLRTPOryHTqwvht
         epICnM02/xatD/NmdOzjlCpMclyY6N/3JCSBfHFQbs0g/BqzRfMp1OIXPpqPW3RrhB
         Yq6mNPx8ORD2zV8+6l97vCqvw5igLKVpIKzmMviSs1M6Go2qCjQG6F0aaMZhGsLG2K
         sAVXtEDuwbY4w==
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
        grygorii.strashko@ti.com, mst@redhat.com, bjorn@kernel.org,
        magnus.karlsson@intel.com, maciej.fijalkowski@intel.com,
        intel-wired-lan@lists.osuosl.org, lorenzo.bianconi@redhat.com
Subject: [RFC bpf-next 0/8] xdp: introduce xdp-feature support
Date:   Mon, 19 Dec 2022 16:41:29 +0100
Message-Id: <cover.1671462950.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.38.1
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

Kumar Kartikeya Dwivedi (1):
  libbpf: add API to get XDP/XSK supported features

Lorenzo Bianconi (3):
  tools: uapi: align if_link.h
  bpf: devmap: check XDP features in bpf_map_update_elem and
    __xdp_enqueue
  selftests/bpf: introduce XDP compliance test tool

Marek Majtyka (4):
  net: introduce XDP features flag
  drivers: net: turn on XDP features
  xsk: add usage of XDP features flags
  xsk: add check for full support of XDP in bind

 .../networking/netdev-xdp-features.rst        |  60 ++
 drivers/net/ethernet/amazon/ena/ena_netdev.c  |   5 +
 .../net/ethernet/aquantia/atlantic/aq_nic.c   |   3 +
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     |   2 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c |   2 +
 .../net/ethernet/cavium/thunder/nicvf_main.c  |   2 +
 .../net/ethernet/freescale/dpaa/dpaa_eth.c    |   2 +
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  |   1 +
 .../net/ethernet/freescale/enetc/enetc_pf.c   |   3 +
 .../ethernet/fungible/funeth/funeth_main.c    |   6 +
 drivers/net/ethernet/intel/i40e/i40e_main.c   |   9 +-
 drivers/net/ethernet/intel/ice/ice_main.c     |   5 +
 drivers/net/ethernet/intel/igb/igb_main.c     |   9 +-
 drivers/net/ethernet/intel/igc/igc_main.c     |   2 +
 drivers/net/ethernet/intel/igc/igc_xdp.c      |   5 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |   5 +
 .../net/ethernet/intel/ixgbevf/ixgbevf_main.c |   1 +
 drivers/net/ethernet/marvell/mvneta.c         |   3 +
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   |   3 +
 .../ethernet/marvell/octeontx2/nic/otx2_pf.c  |   9 +-
 drivers/net/ethernet/mediatek/mtk_eth_soc.c   |   5 +
 .../net/ethernet/mellanox/mlx4/en_netdev.c    |   2 +
 .../net/ethernet/mellanox/mlx5/core/en_main.c |   9 +
 drivers/net/ethernet/microsoft/mana/mana_en.c |   2 +
 .../ethernet/netronome/nfp/nfp_net_common.c   |   3 +
 drivers/net/ethernet/qlogic/qede/qede_main.c  |   2 +
 drivers/net/ethernet/sfc/efx.c                |   2 +
 drivers/net/ethernet/sfc/siena/efx.c          |   2 +
 drivers/net/ethernet/socionext/netsec.c       |   2 +
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |   1 +
 drivers/net/ethernet/ti/cpsw.c                |   2 +
 drivers/net/ethernet/ti/cpsw_new.c            |   2 +
 drivers/net/hyperv/netvsc_drv.c               |   2 +
 drivers/net/netdevsim/netdev.c                |   1 +
 drivers/net/tun.c                             |   3 +
 drivers/net/veth.c                            |   4 +
 drivers/net/virtio_net.c                      |   5 +
 drivers/net/xen-netfront.c                    |   1 +
 include/linux/netdevice.h                     |   2 +
 include/linux/xdp_features.h                  |  64 ++
 include/net/xdp.h                             |  39 +
 include/uapi/linux/if_link.h                  |   7 +
 include/uapi/linux/if_xdp.h                   |   1 +
 include/uapi/linux/xdp_features.h             |  34 +
 kernel/bpf/devmap.c                           |  25 +-
 net/core/filter.c                             |  13 +-
 net/core/rtnetlink.c                          |  34 +
 net/xdp/xsk.c                                 |   4 +-
 net/xdp/xsk_buff_pool.c                       |  20 +-
 tools/include/uapi/linux/if_link.h            |  10 +
 tools/include/uapi/linux/if_xdp.h             |   1 +
 tools/include/uapi/linux/xdp_features.h       |  34 +
 tools/lib/bpf/libbpf.h                        |   1 +
 tools/lib/bpf/libbpf.map                      |   1 +
 tools/lib/bpf/netlink.c                       |  62 ++
 tools/testing/selftests/bpf/Makefile          |   5 +-
 .../selftests/bpf/progs/test_xdp_features.c   | 235 ++++++
 .../selftests/bpf/test_xdp_features.sh        |  99 +++
 tools/testing/selftests/bpf/xdp_features.c    | 745 ++++++++++++++++++
 tools/testing/selftests/bpf/xsk.c             |   3 +
 60 files changed, 1602 insertions(+), 24 deletions(-)
 create mode 100644 Documentation/networking/netdev-xdp-features.rst
 create mode 100644 include/linux/xdp_features.h
 create mode 100644 include/uapi/linux/xdp_features.h
 create mode 100644 tools/include/uapi/linux/xdp_features.h
 create mode 100644 tools/testing/selftests/bpf/progs/test_xdp_features.c
 create mode 100755 tools/testing/selftests/bpf/test_xdp_features.sh
 create mode 100644 tools/testing/selftests/bpf/xdp_features.c

-- 
2.38.1

