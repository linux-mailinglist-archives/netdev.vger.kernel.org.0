Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB3FD632EBB
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 22:25:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230114AbiKUVY7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 16:24:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbiKUVYt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 16:24:49 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A92E4A6A11;
        Mon, 21 Nov 2022 13:24:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1669065885; x=1700601885;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=k5GRNaDhj4ibRaeT11hc9R8Nx0FyYSnxC5yTXXL3pBQ=;
  b=nP6McflAQEAUWtiy+KVE0p5rK5MeB5BxnjcEUIIdVNGn83/ONYh16p2X
   9Os2xwsgpzlk1+v8Gyj5H7o5m8TW46SdUL8wllf0HK2iJcLA86CEF9KMY
   Pc3sZP5abjfz2LtLbim1g+5vK+/3MgK/Qp7SNzEk6fwLGjEMLMI3Shvdh
   nb23F4cMU8dWsKlFH0jw1p7UKzDbsH7T4dGHkdqt51q0uwW4A9Varei8j
   9NI0KP1vvE6LOqfmGTkUFA5k9F7Vo4EqlN2uU7vTTUtga5ykz9PxJh139
   qzW5z08JQsiOeqmFFaynGcGvtJSKyJ8fx6BD1qAxbbeLyLMjxWWjpeaww
   A==;
X-IronPort-AV: E=Sophos;i="5.96,182,1665471600"; 
   d="scan'208";a="124468632"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 21 Nov 2022 14:24:44 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Mon, 21 Nov 2022 14:24:33 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Mon, 21 Nov 2022 14:24:30 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bpf@vger.kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <hawk@kernel.org>, <john.fastabend@gmail.com>,
        <UNGLinuxDriver@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v3 0/7] net: lan966x: Extend xdp support
Date:   Mon, 21 Nov 2022 22:28:43 +0100
Message-ID: <20221121212850.3212649-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,T_SPF_TEMPERROR autolearn=ham autolearn_force=no
        version=3.4.6
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

 .../ethernet/microchip/lan966x/lan966x_fdma.c | 266 +++++++++++++++---
 .../ethernet/microchip/lan966x/lan966x_main.c |   5 +-
 .../ethernet/microchip/lan966x/lan966x_main.h |  19 ++
 .../ethernet/microchip/lan966x/lan966x_xdp.c  |  70 ++++-
 4 files changed, 312 insertions(+), 48 deletions(-)

-- 
2.38.0

