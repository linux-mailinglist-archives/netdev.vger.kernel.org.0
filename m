Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05818427FB8
	for <lists+netdev@lfdr.de>; Sun, 10 Oct 2021 09:29:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230321AbhJJHb0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Oct 2021 03:31:26 -0400
Received: from relmlor2.renesas.com ([210.160.252.172]:39251 "EHLO
        relmlie6.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229697AbhJJHbZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Oct 2021 03:31:25 -0400
X-IronPort-AV: E=Sophos;i="5.85,362,1624287600"; 
   d="scan'208";a="96694901"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie6.idc.renesas.com with ESMTP; 10 Oct 2021 16:29:25 +0900
Received: from localhost.localdomain (unknown [10.226.92.12])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id CA4E2400197C;
        Sun, 10 Oct 2021 16:29:22 +0900 (JST)
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Biju Das <biju.das.jz@bp.renesas.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Adam Ford <aford173@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>
Subject: [PATCH net-next v2 00/14] Add functional support for Gigabit Ethernet driver
Date:   Sun, 10 Oct 2021 08:29:06 +0100
Message-Id: <20211010072920.20706-1-biju.das.jz@bp.renesas.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The DMAC and EMAC blocks of Gigabit Ethernet IP found on RZ/G2L SoC are
similar to the R-Car Ethernet AVB IP.

The Gigabit Ethernet IP consists of Ethernet controller (E-MAC), Internal
TCP/IP Offload Engine (TOE)  and Dedicated Direct memory access controller
(DMAC).

With a few changes in the driver we can support both IPs.

This patch series is aims to add functional support for Gigabit Ethernet driver
by filling all the stubs except set_features.

set_feature patch will send as separate RFC patch along with rx_checksum
patch, as it needs further discussion related to HW checksum.

With this series, we can do boot kernel with rootFS mounted on NFS on RZ/G2L
platforms.

Ref:-
 https://patchwork.kernel.org/project/linux-renesas-soc/list/?series=557655

V1->V2:
 * Removed the unrelated comment "GbEthernet TOE Hardware checksum status"
   and macros TOE_IPV4_RX_CSUM_OK and TOE_IPV6_RX_CSUM_OK which is accidentally
   introduced as part of RFC discussion from patch #6.

RFC->V1:
 * Removed patch#3 will send it as RFC
 * Removed rx_csum functionality from patch#7, will send it as RFC
 * Renamed "nc_queue" -> "nc_queues"
 * Separated the comment patch into 2 separate patches.
 * Documented PFRI register bit
 * Added Sergey's Rb tag

RFC changes:
 * used ALIGN macro for calculating the value for max_rx_len.
 * used rx_max_buf_size instead of rx_2k_buffers feature bit.
 * moved struct ravb_rx_desc *gbeth_rx_ring near to ravb_private::rx_ring
   and allocating it for 1 RX queue.
 * Started using gbeth_rx_ring instead of gbeth_rx_ring[q].
 * renamed ravb_alloc_rx_desc to ravb_alloc_rx_desc_rcar
 * renamed ravb_rx_ring_free to ravb_rx_ring_free_rcar
 * renamed ravb_rx_ring_format to ravb_rx_ring_format_rcar
 * renamed ravb_rcar_rx to ravb_rx_rcar
 * renamed "tsrq" variable
 * Updated the comments

Biju Das (14):
  ravb: Use ALIGN macro for max_rx_len
  ravb: Add rx_max_buf_size to struct ravb_hw_info
  ravb: Fillup ravb_alloc_rx_desc_gbeth() stub
  ravb: Fillup ravb_rx_ring_free_gbeth() stub
  ravb: Fillup ravb_rx_ring_format_gbeth() stub
  ravb: Fillup ravb_rx_gbeth() stub
  ravb: Add carrier_counters to struct ravb_hw_info
  ravb: Add support to retrieve stats for GbEthernet
  ravb: Rename "tsrq" variable
  ravb: Optimize ravb_emac_init_gbeth function
  ravb: Rename "nc_queue" feature bit
  ravb: Document PFRI register bit
  ravb: Update EMAC configuration mode comment
  ravb: Fix typo AVB->DMAC

 drivers/net/ethernet/renesas/ravb.h      |  13 +-
 drivers/net/ethernet/renesas/ravb_main.c | 325 +++++++++++++++++++----
 2 files changed, 287 insertions(+), 51 deletions(-)

-- 
2.17.1

