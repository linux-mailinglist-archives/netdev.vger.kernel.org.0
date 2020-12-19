Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDCC02DF0CB
	for <lists+netdev@lfdr.de>; Sat, 19 Dec 2020 18:56:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727283AbgLSRzw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Dec 2020 12:55:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:57290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727127AbgLSRzv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 19 Dec 2020 12:55:51 -0500
From:   Lorenzo Bianconi <lorenzo@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, brouer@redhat.com,
        lorenzo.bianconi@redhat.com, alexander.duyck@gmail.com,
        maciej.fijalkowski@intel.com, saeed@kernel.org
Subject: [PATCH v4 bpf-next 0/2] introduce xdp_init_buff/xdp_prepare_buff
Date:   Sat, 19 Dec 2020 18:54:59 +0100
Message-Id: <cover.1608399672.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce xdp_init_buff and xdp_prepare_buff utility routines to initialize
xdp_buff data structure and remove duplicated code in all XDP capable
drivers.

Changes since v3:
- use __always_inline instead of inline for xdp_init_buff/xdp_prepare_buff
- add 'const bool meta_valid' to xdp_prepare_buff signature to avoid
  overwriting data_meta with xdp_set_data_meta_invalid()
- introduce removed comment in bnxt driver

Changes since v2:
- precompute xdp->data as hard_start + headroom and save it in a local
  variable to reuse it for xdp->data_end and xdp->data_meta in
  xdp_prepare_buff()

Changes since v1:
- introduce xdp_prepare_buff utility routine

Lorenzo Bianconi (2):
  net: xdp: introduce xdp_init_buff utility routine
  net: xdp: introduce xdp_prepare_buff utility routine

Acked-by: Martin Habets <habetsm.xilinx@gmail.com>
Acked-by: Camelia Groza <camelia.groza@nxp.com>

 drivers/net/ethernet/amazon/ena/ena_netdev.c  | 10 ++++------
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c |  9 +++------
 .../net/ethernet/cavium/thunder/nicvf_main.c  | 12 ++++++------
 .../net/ethernet/freescale/dpaa/dpaa_eth.c    | 10 ++++------
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  | 14 +++++---------
 drivers/net/ethernet/intel/i40e/i40e_txrx.c   | 18 +++++++++---------
 drivers/net/ethernet/intel/ice/ice_txrx.c     | 15 ++++++++-------
 drivers/net/ethernet/intel/igb/igb_main.c     | 18 +++++++++---------
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 19 +++++++++----------
 .../net/ethernet/intel/ixgbevf/ixgbevf_main.c | 19 +++++++++----------
 drivers/net/ethernet/marvell/mvneta.c         | 10 +++-------
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   | 14 +++++++-------
 drivers/net/ethernet/mellanox/mlx4/en_rx.c    |  9 +++------
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   |  8 ++------
 .../ethernet/netronome/nfp/nfp_net_common.c   | 12 ++++++------
 drivers/net/ethernet/qlogic/qede/qede_fp.c    |  9 +++------
 drivers/net/ethernet/sfc/rx.c                 | 10 +++-------
 drivers/net/ethernet/socionext/netsec.c       |  9 +++------
 drivers/net/ethernet/ti/cpsw.c                | 18 ++++++------------
 drivers/net/ethernet/ti/cpsw_new.c            | 18 ++++++------------
 drivers/net/hyperv/netvsc_bpf.c               |  8 ++------
 drivers/net/tun.c                             | 12 ++++--------
 drivers/net/veth.c                            | 14 +++++---------
 drivers/net/virtio_net.c                      | 18 ++++++------------
 drivers/net/xen-netfront.c                    | 10 ++++------
 include/net/xdp.h                             | 19 +++++++++++++++++++
 net/bpf/test_run.c                            |  9 +++------
 net/core/dev.c                                | 18 ++++++++----------
 28 files changed, 159 insertions(+), 210 deletions(-)

-- 
2.29.2

