Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4947235B7C6
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 02:39:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235857AbhDLAi2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Apr 2021 20:38:28 -0400
Received: from mail-ej1-f49.google.com ([209.85.218.49]:43767 "EHLO
        mail-ej1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235484AbhDLAi1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Apr 2021 20:38:27 -0400
Received: by mail-ej1-f49.google.com with SMTP id l4so17372371ejc.10;
        Sun, 11 Apr 2021 17:38:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hhzMptSRLec1c49GB9hd4ctxKibNLuRbXyBV5wPGE9Q=;
        b=h3KV/dwZuHRALN85FCzICxQnOPvKLJmO/uOvosKvyG+9NxLjDg52JsPrlaisW3P0h6
         jycrRhG+2qYMaeXS5eOLDJtMChZRSZS1219j3hl45kyF1H0TWAvQnDqsZiT5/agFXPzp
         /oAazia6a8C8pfUbt+CqZCon9jtvjWQbtXxYQYMx3tDroyvsJouPsua9qUxyFBlcMx/i
         KpF0dfe8La4e+zcZpBr0Ag4CdXv5UKqj/zl6/JTJNsBKl6k34NVY4dy4YMe/C7BH1o0d
         SYEuxzczKyFT9lq+BTUtIpSBMyh8S6HDiLmurZwZb0PbN6P5up5fBKoxuwpS2JHI504b
         AMxQ==
X-Gm-Message-State: AOAM531TLqja7XHTEQYRINQY2eVAc1arsMSdAs4hrI7Ru/flFvjBcp14
        QZaZ/YjQkN6z18fFZM0WBnfB17Yd2yY=
X-Google-Smtp-Source: ABdhPJyaiM+MbqtE1lLpaOy07e7gzXDh+zaQ64dRusg3KN1gpcp3EYILFdlv4exZmt892Lmc/BOv9g==
X-Received: by 2002:a17:906:8288:: with SMTP id h8mr10313073ejx.75.1618187889692;
        Sun, 11 Apr 2021 17:38:09 -0700 (PDT)
Received: from msft-t490s.teknoraver.net (net-93-66-21-119.cust.vodafonedsl.it. [93.66.21.119])
        by smtp.gmail.com with ESMTPSA id a9sm5477837eds.33.2021.04.11.17.38.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Apr 2021 17:38:08 -0700 (PDT)
From:   Matteo Croce <mcroce@linux.microsoft.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Julia Lawall <julia.lawall@inria.fr>
Subject: [PATCH net-next v2 0/3] introduce skb_for_each_frag()
Date:   Mon, 12 Apr 2021 02:37:59 +0200
Message-Id: <20210412003802.51613-1-mcroce@linux.microsoft.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matteo Croce <mcroce@microsoft.com>

Introduce skb_for_each_frag, an helper macro to iterate over the SKB frags.

First patch introduces the helper, the second one is generated with
coccinelle and uses the macro where possible.
Last one is a chunk which have to be applied by hand.

The second patch raises some checkpatch.pl warnings because part of
net/tls/tls_sw.c is indented with spaces.

Build tested with an allmodconfig and a test run.

v1 -> v2:
- don't replace code where a local variable holds a cached value
  for skb_shinfo(skb)->nr_frags

Matteo Croce (3):
  skbuff: add helper to walk over the fraglist
  net: use skb_for_each_frag() helper where possible
  net: use skb_for_each_frag() in illegal_highdma()

 drivers/atm/he.c                              |  2 +-
 drivers/hsi/clients/ssi_protocol.c            |  2 +-
 drivers/infiniband/hw/hfi1/ipoib_tx.c         |  2 +-
 drivers/infiniband/hw/hfi1/vnic_sdma.c        |  2 +-
 drivers/infiniband/ulp/ipoib/ipoib_ib.c       |  4 +--
 drivers/net/ethernet/3com/3c59x.c             |  2 +-
 drivers/net/ethernet/3com/typhoon.c           |  2 +-
 drivers/net/ethernet/adaptec/starfire.c       |  2 +-
 drivers/net/ethernet/aeroflex/greth.c         |  2 +-
 drivers/net/ethernet/alteon/acenic.c          |  2 +-
 drivers/net/ethernet/amd/xgbe/xgbe-desc.c     |  2 +-
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c      |  2 +-
 .../net/ethernet/apm/xgene/xgene_enet_main.c  |  2 +-
 drivers/net/ethernet/atheros/alx/main.c       |  2 +-
 .../net/ethernet/atheros/atl1e/atl1e_main.c   |  2 +-
 .../net/ethernet/broadcom/bnx2x/bnx2x_cmn.c   |  2 +-
 drivers/net/ethernet/broadcom/tg3.c           |  2 +-
 .../ethernet/cavium/thunder/nicvf_queues.c    |  2 +-
 drivers/net/ethernet/chelsio/cxgb3/sge.c      |  2 +-
 drivers/net/ethernet/emulex/benet/be_main.c   |  2 +-
 .../net/ethernet/freescale/dpaa/dpaa_eth.c    |  2 +-
 drivers/net/ethernet/freescale/gianfar.c      |  3 +-
 drivers/net/ethernet/google/gve/gve_tx.c      |  2 +-
 drivers/net/ethernet/hisilicon/hix5hd2_gmac.c |  4 +--
 .../net/ethernet/hisilicon/hns3/hns3_enet.c   |  4 +--
 drivers/net/ethernet/huawei/hinic/hinic_rx.c  |  2 +-
 drivers/net/ethernet/huawei/hinic/hinic_tx.c  |  4 +--
 drivers/net/ethernet/ibm/ibmveth.c            |  2 +-
 drivers/net/ethernet/ibm/ibmvnic.c            |  2 +-
 drivers/net/ethernet/intel/fm10k/fm10k_main.c |  2 +-
 drivers/net/ethernet/intel/igb/igb_main.c     |  2 +-
 drivers/net/ethernet/intel/igbvf/netdev.c     |  2 +-
 drivers/net/ethernet/intel/igc/igc_main.c     |  2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |  2 +-
 .../net/ethernet/intel/ixgbevf/ixgbevf_main.c |  2 +-
 drivers/net/ethernet/marvell/mv643xx_eth.c    |  2 +-
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   |  2 +-
 drivers/net/ethernet/marvell/skge.c           |  2 +-
 drivers/net/ethernet/marvell/sky2.c           |  8 ++---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c   |  2 +-
 .../net/ethernet/mellanox/mlx5/core/en_tx.c   |  2 +-
 drivers/net/ethernet/mellanox/mlxsw/pci.c     |  2 +-
 drivers/net/ethernet/realtek/8139cp.c         |  2 +-
 drivers/net/ethernet/realtek/r8169_main.c     |  2 +-
 drivers/net/ethernet/rocker/rocker_main.c     |  2 +-
 drivers/net/ethernet/sfc/tx.c                 |  2 +-
 drivers/net/ethernet/sun/niu.c                |  4 +--
 drivers/net/ethernet/sun/sungem.c             |  2 +-
 drivers/net/ethernet/sun/sunhme.c             |  2 +-
 drivers/net/ethernet/sun/sunvnet_common.c     |  4 +--
 .../net/ethernet/synopsys/dwc-xlgmac-desc.c   |  2 +-
 .../net/ethernet/synopsys/dwc-xlgmac-net.c    |  2 +-
 drivers/net/ethernet/ti/am65-cpsw-nuss.c      |  2 +-
 drivers/net/ethernet/ti/netcp_core.c          |  2 +-
 drivers/net/ethernet/via/via-velocity.c       |  2 +-
 drivers/net/usb/usbnet.c                      |  2 +-
 drivers/net/vmxnet3/vmxnet3_drv.c             |  4 +--
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c  |  2 +-
 drivers/net/wireless/intel/iwlwifi/queue/tx.c |  2 +-
 drivers/net/xen-netback/netback.c             |  2 +-
 drivers/net/xen-netfront.c                    |  2 +-
 drivers/s390/net/qeth_core_main.c             |  4 +--
 drivers/scsi/fcoe/fcoe_transport.c            |  2 +-
 drivers/staging/octeon/ethernet-tx.c          |  2 +-
 drivers/target/iscsi/cxgbit/cxgbit_target.c   |  4 +--
 include/linux/skbuff.h                        |  4 +++
 net/appletalk/ddp.c                           |  2 +-
 net/core/datagram.c                           |  4 +--
 net/core/dev.c                                |  2 +-
 net/core/skbuff.c                             | 32 +++++++++----------
 net/ipv4/inet_fragment.c                      |  2 +-
 net/ipv4/tcp.c                                |  2 +-
 net/ipv4/tcp_output.c                         |  2 +-
 net/iucv/af_iucv.c                            |  4 +--
 net/kcm/kcmsock.c                             |  3 +-
 net/tls/tls_sw.c                              |  2 +-
 76 files changed, 108 insertions(+), 106 deletions(-)

-- 
2.30.2

