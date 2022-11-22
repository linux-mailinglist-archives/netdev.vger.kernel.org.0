Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D2BE634976
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 22:40:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235033AbiKVVkE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 16:40:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232572AbiKVVkD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 16:40:03 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FB45C5B72;
        Tue, 22 Nov 2022 13:39:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1669153199; x=1700689199;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=SObOV4ZVsIhR7Pxn0ehVi6XI7f+9C+SzUdrriWqtbxU=;
  b=KC9tI+yl4ON/W8dci5vDn4ChTJLw1w0PG2cUZwYhhDL/36B+vyTmES8m
   lkLnQ8d5IRZCIRDfYhK8OjMH04S69i1KVwwQtRQsxGVGC6vRVtHwWY+aY
   FhLvJXmQgiywl3nx2txTYTjduJHuVJphwzTS3OL5nEqGGWpvVr23ZNQPC
   J2Xb4seTt3XqO16fYl3N9ubdeCoR6dayK8OseHtqru71Mdb+uHDTvvZb0
   Tyz/vkeKcLfW2iR+cP2LDJAmnbP0lzGkcfbM6/Qf+S7xVYzTVEgnAGUJ+
   9etWcM9XFXsRL2zHi/IY/k3UCwah6HbbY7Q6prPsWAQIbhKTpqCyF3nyM
   w==;
X-IronPort-AV: E=Sophos;i="5.96,185,1665471600"; 
   d="scan'208";a="190137418"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 22 Nov 2022 14:39:59 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Tue, 22 Nov 2022 14:39:54 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Tue, 22 Nov 2022 14:39:51 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bpf@vger.kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <hawk@kernel.org>, <john.fastabend@gmail.com>,
        <alexandr.lobakin@intel.com>, <UNGLinuxDriver@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v4 0/7] net: lan966x: Extend xdp support
Date:   Tue, 22 Nov 2022 22:44:06 +0100
Message-ID: <20221122214413.3446006-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,T_SPF_TEMPERROR autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extend the current support of XDP in lan966x with the action XDP_TX and
XDP_REDIRECT.
The first patches just prepare the things such that it would be easier
to add XDP_TX and XDP_REDIRECT actions. Like adding XDP_PACKET_HEADROOM,
introduce helper functions, use the correct dma_dir for the page pool
The last 2 patches introduce the XDP actions XDP_TX and XDP_REDIRECT.

v3->v4:
- use napi_consume_skb instead of dev_kfree_skb_any
- arrange members in struct lan966x_tx_dcb_buf not to have holes
- fix when xdp program is added the check for determining if page pool
  needs to be recreated was wrong
- change type for len in lan966x_tx_dcb_buf to u32

v2->v3:
- make sure to update rxq memory model
- update the page pool direction if there is any xdp program
- in case of action XDP_TX give back to reuse the page
- in case of action XDP_REDIRECT, remap the frame and make sure to
  unmap it when is transmitted.

v1->v2:
- use skb_reserve of using skb_put and skb_pull
- make sure that data_len doesn't include XDP_PACKET_HEADROOM

Horatiu Vultur (7):
  net: lan966x: Add XDP_PACKET_HEADROOM
  net: lan966x: Introduce helper functions
  net: lan966x: Add len field to lan966x_tx_dcb_buf
  net: lan966x: Update rxq memory model
  net: lan966x: Update dma_dir of page_pool_params
  net: lan966x: Add support for XDP_TX
  net: lan966x: Add support for XDP_REDIRECT

 .../ethernet/microchip/lan966x/lan966x_fdma.c | 265 +++++++++++++++---
 .../ethernet/microchip/lan966x/lan966x_main.c |   5 +-
 .../ethernet/microchip/lan966x/lan966x_main.h |  25 +-
 .../ethernet/microchip/lan966x/lan966x_xdp.c  |  70 ++++-
 4 files changed, 314 insertions(+), 51 deletions(-)

-- 
2.38.0

