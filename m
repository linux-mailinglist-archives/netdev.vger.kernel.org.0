Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D67D9626F27
	for <lists+netdev@lfdr.de>; Sun, 13 Nov 2022 12:12:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235182AbiKMLMT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Nov 2022 06:12:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232676AbiKMLMS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Nov 2022 06:12:18 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEBB9FCCC;
        Sun, 13 Nov 2022 03:12:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1668337939; x=1699873939;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=J9ony0CQq5d3iyH5sLi8OTPUU5tzF0QxE8ldp/fcBvg=;
  b=ViZYmyYYGqDQtipZY7xoaKe4zvj3FFX+KbzMV1+yJDq0YFpW6D1GnCaz
   g1Z7DrASeC3Ys+tlxa8m9AwHyqRcqI+lz9KkVYcN1IVHeBVT/quImcBB4
   Xa6fE/jx1faAZOLaBaRkmBLlZdzVC7ayuc1rxKQuos3CuVfzrVtPVI32Z
   ZAOk/BOHPjUks3WnivWjJI/hKWHieGYHaXkr+ybCcyyxIt1PF47iBX62p
   x2/Fh2mGiSK8DaIl+sS2IfKxLBEILtGqi8SFGIhojMEWK1691O1LeUNn7
   zqYoCcehQ9Mj7/xz1gzGGzhlQNgX4CQ4IH0h5iDCb8YIDbNa6B+T8l/Yb
   Q==;
X-IronPort-AV: E=Sophos;i="5.96,161,1665471600"; 
   d="scan'208";a="188767032"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 13 Nov 2022 04:12:18 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Sun, 13 Nov 2022 04:12:16 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Sun, 13 Nov 2022 04:12:14 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bpf@vger.kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <hawk@kernel.org>, <john.fastabend@gmail.com>,
        <alexandr.lobakin@intel.com>, <UNGLinuxDriver@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next 0/5] net: lan966x: Extend xdp support
Date:   Sun, 13 Nov 2022 12:15:54 +0100
Message-ID: <20221113111559.1028030-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extend the current support of XDP in lan966x with the action XDP_TX and
XDP_REDIRECT.
The first patch introduced a headroom for all the received frames. This
is needed when the XDP_TX and XDP_REDIRECT is added.
The next 2 patches, just introduced some helper functions that can be
reused when is needed to transmit back the frame.
The last 2 patches introduce the XDP actions XDP_TX and XDP_REDIRECT.

Horatiu Vultur (5):
  net: lan966x: Add XDP_PACKET_HEADROOM
  net: lan966x: Introduce helper functions
  net: lan966x: Add len field to lan966x_tx_dcb_buf
  net: lan966x: Add support for XDP_TX
  net: lan966x: Add support for XDP_REDIRECT

 .../ethernet/microchip/lan966x/lan966x_fdma.c | 183 ++++++++++++++----
 .../ethernet/microchip/lan966x/lan966x_main.c |   5 +-
 .../ethernet/microchip/lan966x/lan966x_main.h |  15 ++
 .../ethernet/microchip/lan966x/lan966x_xdp.c  |  41 +++-
 4 files changed, 200 insertions(+), 44 deletions(-)

-- 
2.38.0

