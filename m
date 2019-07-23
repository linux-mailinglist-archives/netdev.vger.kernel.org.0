Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C68BD70F8A
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 05:08:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387865AbfGWDIh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 23:08:37 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:36372 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730004AbfGWDIh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jul 2019 23:08:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=sg3Plg5zJYWjcazlM4XTvUKaAwuBuwVRKYnN70fapAw=; b=EZ5uFVP0yJxiMLJCjVPLZZaYj
        t0ifl0oksG0iGN95nnt3v3sFhL8JU8a6M9c+rOK3lGI8pOxgpJ98WAfv5lfd+NIYXSFbj/y8R8bMf
        yFju07DY3dJdbUtMQ1MmomfjUbDS7dRBHDg1MzoFPwfCreWBjHcygxtrHYxnjhhbaurEtiJ+wwEE7
        q47M95kbLh/tj1ZdJw1ftMgV67Z4hwZC38yANlVM5CY5mh+X+paAQ4cGitJ+rBQNhokM/immJRWNA
        TP8R+XL1VqQ59rc7Ct7yjn4ORNQc7zJAL3F4f6baiwP/qeV1QrBsEuOih+/6VhhWvFvTj6gGjJbJN
        rtZVGSMYw==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hplAJ-00036Y-8R; Tue, 23 Jul 2019 03:08:35 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     davem@davemloft.net
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>, hch@lst.de,
        netdev@vger.kernel.org
Subject: [PATCH v3 0/7] Convert skb_frag_t to bio_vec
Date:   Mon, 22 Jul 2019 20:08:24 -0700
Message-Id: <20190723030831.11879-1-willy@infradead.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

The skb_frag_t and bio_vec are fundamentally the same (page, offset,
length) tuple.  This patch series unifies the two, leaving the
skb_frag_t typedef in place.  This has the immediate advantage that
we already have iov_iter support for bvecs and don't need to add
support for iterating skbuffs.  It enables a long-term plan to use
bvecs more broadly within the kernel and should make network-storage
drivers able to do less work converting between skbuffs and biovecs.

It will consume more memory on 32-bit kernels.  If that proves
problematic, we can look at ways of addressing it.

v3: Rebase on latest Linus with net-next merged.
  - Reorder the uncontroversial 'Use skb accessors' patches first so you
    can apply just those two if you want to hold off on the full
    conversion.
  - Convert all the users of 'struct skb_frag_struct' to skb_frag_t.

Matthew Wilcox (Oracle) (7):
  net: Use skb accessors in network drivers
  net: Use skb accessors in network core
  net: Increase the size of skb_frag_t
  net: Reorder the contents of skb_frag_t
  net: Rename skb_frag page to bv_page
  net: Rename skb_frag_t size to bv_len
  net: Convert skb_frag_t to bio_vec

 drivers/crypto/chelsio/chtls/chtls_io.c       |  6 ++--
 drivers/hsi/clients/ssi_protocol.c            |  3 +-
 drivers/infiniband/hw/hfi1/vnic_sdma.c        |  2 +-
 drivers/net/ethernet/3com/3c59x.c             |  2 +-
 drivers/net/ethernet/agere/et131x.c           |  6 ++--
 drivers/net/ethernet/amd/xgbe/xgbe-desc.c     |  2 +-
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c      |  2 +-
 .../net/ethernet/apm/xgene/xgene_enet_main.c  |  3 +-
 drivers/net/ethernet/atheros/alx/main.c       |  4 +--
 .../net/ethernet/atheros/atl1c/atl1c_main.c   |  4 +--
 .../net/ethernet/atheros/atl1e/atl1e_main.c   |  3 +-
 drivers/net/ethernet/atheros/atlx/atl1.c      |  3 +-
 drivers/net/ethernet/broadcom/bgmac.c         |  2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     |  2 +-
 drivers/net/ethernet/brocade/bna/bnad.c       |  2 +-
 drivers/net/ethernet/calxeda/xgmac.c          |  2 +-
 .../net/ethernet/cavium/liquidio/lio_main.c   | 23 ++++++-------
 .../ethernet/cavium/liquidio/lio_vf_main.c    | 23 ++++++-------
 .../ethernet/cavium/thunder/nicvf_queues.c    |  4 +--
 drivers/net/ethernet/chelsio/cxgb3/sge.c      |  2 +-
 drivers/net/ethernet/cortina/gemini.c         |  5 ++-
 drivers/net/ethernet/emulex/benet/be_main.c   |  2 +-
 drivers/net/ethernet/freescale/enetc/enetc.c  |  2 +-
 drivers/net/ethernet/freescale/fec_main.c     |  4 +--
 drivers/net/ethernet/hisilicon/hix5hd2_gmac.c |  2 +-
 drivers/net/ethernet/hisilicon/hns/hns_enet.c |  4 +--
 .../net/ethernet/hisilicon/hns3/hns3_enet.c   |  8 ++---
 drivers/net/ethernet/huawei/hinic/hinic_tx.c  |  2 +-
 drivers/net/ethernet/ibm/emac/core.c          |  2 +-
 drivers/net/ethernet/intel/e1000/e1000_main.c |  3 +-
 drivers/net/ethernet/intel/e1000e/netdev.c    |  3 +-
 drivers/net/ethernet/intel/fm10k/fm10k_main.c |  5 +--
 drivers/net/ethernet/intel/i40e/i40e_txrx.c   |  4 +--
 drivers/net/ethernet/intel/i40e/i40e_txrx.h   |  2 +-
 drivers/net/ethernet/intel/iavf/iavf_txrx.c   |  4 +--
 drivers/net/ethernet/intel/iavf/iavf_txrx.h   |  2 +-
 drivers/net/ethernet/intel/ice/ice_txrx.c     |  6 ++--
 drivers/net/ethernet/intel/igb/igb_main.c     |  5 +--
 drivers/net/ethernet/intel/igbvf/netdev.c     |  2 +-
 drivers/net/ethernet/intel/igc/igc_main.c     |  5 +--
 drivers/net/ethernet/intel/ixgb/ixgb_main.c   |  4 +--
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |  9 ++---
 .../net/ethernet/intel/ixgbevf/ixgbevf_main.c |  2 +-
 drivers/net/ethernet/jme.c                    |  5 ++-
 drivers/net/ethernet/marvell/mvneta.c         |  4 +--
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   |  7 ++--
 drivers/net/ethernet/mediatek/mtk_eth_soc.c   |  4 +--
 drivers/net/ethernet/mellanox/mlx4/en_tx.c    |  4 +--
 .../net/ethernet/mellanox/mlx5/core/en_tx.c   |  2 +-
 drivers/net/ethernet/microchip/lan743x_main.c |  5 ++-
 .../net/ethernet/myricom/myri10ge/myri10ge.c  | 10 +++---
 .../ethernet/netronome/nfp/nfp_net_common.c   |  6 ++--
 .../ethernet/qlogic/netxen/netxen_nic_main.c  |  4 +--
 .../net/ethernet/qlogic/qlcnic/qlcnic_io.c    |  2 +-
 drivers/net/ethernet/qualcomm/emac/emac-mac.c | 12 +++----
 .../net/ethernet/synopsys/dwc-xlgmac-desc.c   |  2 +-
 .../net/ethernet/synopsys/dwc-xlgmac-net.c    |  2 +-
 drivers/net/ethernet/tehuti/tehuti.c          |  2 +-
 drivers/net/usb/usbnet.c                      |  4 +--
 drivers/net/vmxnet3/vmxnet3_drv.c             |  7 ++--
 drivers/net/wireless/ath/wil6210/debugfs.c    |  3 +-
 drivers/net/wireless/ath/wil6210/txrx.c       |  9 +++--
 drivers/net/wireless/ath/wil6210/txrx_edma.c  |  2 +-
 drivers/net/xen-netback/netback.c             |  4 +--
 drivers/s390/net/qeth_core_main.c             |  2 +-
 drivers/scsi/fcoe/fcoe_transport.c            |  2 +-
 drivers/staging/octeon/ethernet-tx.c          |  5 ++-
 .../staging/unisys/visornic/visornic_main.c   |  4 +--
 drivers/target/iscsi/cxgbit/cxgbit_target.c   | 13 +++----
 include/linux/bvec.h                          |  5 ++-
 include/linux/skbuff.h                        | 34 ++++++-------------
 net/core/skbuff.c                             | 26 ++++++++------
 net/core/tso.c                                |  8 ++---
 net/ipv4/tcp.c                                | 14 ++++----
 net/kcm/kcmsock.c                             |  8 ++---
 net/tls/tls_device.c                          | 14 ++++----
 76 files changed, 202 insertions(+), 220 deletions(-)

-- 
2.20.1

