Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 803F22E0FB5
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 22:12:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728061AbgLVVKU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 16:10:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:37468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727922AbgLVVKU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Dec 2020 16:10:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B436121973;
        Tue, 22 Dec 2020 21:09:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608671379;
        bh=e/ITTobUzRvo16vPX4v6KrbP8NfY9y58/unHLfkEWb8=;
        h=From:To:Cc:Subject:Date:From;
        b=nHFfK4JfVwTPIWF26JvdEMl9V+B7crqPYmdm40uyWqfs5TsxPB0enRtMUdM7zpFI/
         85N25WOBoCrAaPQjgftuts/jRRvJidyRZVydomzGMNuQK7b87ZuPgoDnuTT5lt90h8
         P0wPmo33KJmmbmAvQOI2gF26jfiOFjxceSQSuYqFc5tuqwqYfFPVtEC140/9JuZRlk
         gVuSUZy0yTzI121nZ1nhtq0SyCD/dgMHaJmyo66tpXMqQ6oTH8wMxjIPCkIHctrjQS
         5N62tf6LcCEI7jGK0LyS3IGSoSRy8PePLXFgdtLHaZJ+pbayA0wTl391Q9WMrpxDPJ
         UsAXT3IVKs2qw==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, brouer@redhat.com,
        lorenzo.bianconi@redhat.com, alexander.duyck@gmail.com,
        maciej.fijalkowski@intel.com, saeed@kernel.org
Subject: [PATCH v5 bpf-next 0/2] introduce xdp_init_buff/xdp_prepare_buff
Date:   Tue, 22 Dec 2020 22:09:27 +0100
Message-Id: <cover.1608670965.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce xdp_init_buff and xdp_prepare_buff utility routines to initialize
xdp_buff data structure and remove duplicated code in all XDP capable
drivers.

Changes since v4:
- fix xdp_init_buff/xdp_prepare_buff (natural order is xdp_init_buff() first
  and then xdp_prepare_buff())

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

Acked-by: Shay Agroskin <shayagr@amazon.com>
Acked-by: Martin Habets <habetsm.xilinx@gmail.com>
Acked-by: Camelia Groza <camelia.groza@nxp.com>

 drivers/net/ethernet/amazon/ena/ena_netdev.c  | 10 ++++----
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c |  9 +++----
 .../net/ethernet/cavium/thunder/nicvf_main.c  | 12 +++++-----
 .../net/ethernet/freescale/dpaa/dpaa_eth.c    | 10 ++++----
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  | 14 ++++-------
 drivers/net/ethernet/intel/i40e/i40e_txrx.c   | 18 +++++++-------
 drivers/net/ethernet/intel/ice/ice_txrx.c     | 15 ++++++------
 drivers/net/ethernet/intel/igb/igb_main.c     | 18 +++++++-------
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 19 +++++++--------
 .../net/ethernet/intel/ixgbevf/ixgbevf_main.c | 19 +++++++--------
 drivers/net/ethernet/marvell/mvneta.c         | 10 +++-----
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   | 14 +++++------
 drivers/net/ethernet/mellanox/mlx4/en_rx.c    |  9 +++----
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   |  8 ++-----
 .../ethernet/netronome/nfp/nfp_net_common.c   | 12 +++++-----
 drivers/net/ethernet/qlogic/qede/qede_fp.c    |  9 +++----
 drivers/net/ethernet/sfc/rx.c                 | 10 +++-----
 drivers/net/ethernet/socionext/netsec.c       |  9 +++----
 drivers/net/ethernet/ti/cpsw.c                | 18 +++++---------
 drivers/net/ethernet/ti/cpsw_new.c            | 18 +++++---------
 drivers/net/hyperv/netvsc_bpf.c               |  8 ++-----
 drivers/net/tun.c                             | 12 ++++------
 drivers/net/veth.c                            | 14 ++++-------
 drivers/net/virtio_net.c                      | 18 +++++---------
 drivers/net/xen-netfront.c                    | 10 ++++----
 include/net/xdp.h                             | 19 +++++++++++++++
 net/bpf/test_run.c                            | 11 ++++-----
 net/core/dev.c                                | 24 +++++++++----------
 28 files changed, 163 insertions(+), 214 deletions(-)

-- 
2.29.2

