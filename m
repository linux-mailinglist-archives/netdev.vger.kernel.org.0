Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C5F361E627
	for <lists+netdev@lfdr.de>; Sun,  6 Nov 2022 22:07:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230106AbiKFVH3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Nov 2022 16:07:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229669AbiKFVH3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Nov 2022 16:07:29 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31F4FC2E;
        Sun,  6 Nov 2022 13:07:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1667768848; x=1699304848;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=/2BBNsdvrwucb6tUpgYSstuHL9H/ukOGvzhZaG2TZ9c=;
  b=RZXzuaTureW6Ik15T2Ucvvk0/oEXdm6m3kv+ZrvCw3ix/MqieEqb/+dk
   vXbTWjVvsrt3lmEGkXN04Kd9ImBIMiwXSfU+V36n5Ow55yLiaN2u7RB+L
   TrNHIJ9nlY+v2f1madAN58rMkwfjPCjFGUZhFt+KijKBceujSz6sAGS5+
   FuvfHiPd2iRghthPgQDXiCM4CgN7SWOAeWHk4XDQtSp876vqooqJtSAOB
   Fq3W2dC+VOUIDl7kh6OJ9G7M08S/nZvD52QnyjEgrWZ0JtUP82/1H0Xdo
   oz39yjqvREoyVhwQDGyowm6w3mmC0l1cnDywtL+KA/WIgAhvft4UKbwha
   A==;
X-IronPort-AV: E=Sophos;i="5.96,142,1665471600"; 
   d="scan'208";a="187824988"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 Nov 2022 14:07:27 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Sun, 6 Nov 2022 14:07:26 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Sun, 6 Nov 2022 14:07:23 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <hawk@kernel.org>, <john.fastabend@gmail.com>,
        <linux@armlinux.org.uk>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v2 0/4] net: lan966x: Add xdp support
Date:   Sun, 6 Nov 2022 22:11:50 +0100
Message-ID: <20221106211154.3225784-1-horatiu.vultur@microchip.com>
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

Add support for xdp in lan966x driver. Currently only XDP_PASS and
XDP_DROP are supported.

The first 2 patches are just moving things around just to simplify
the code for when the xdp is added.
Patch 3 actually adds the xdp. Currently the only supported actions
are XDP_PASS and XDP_DROP. In the future this will be extended with
XDP_TX and XDP_REDIRECT.
Patch 4 changes to use page pool API, because the handling of the
pages is similar with what already lan966x driver is doing. In this
way is possible to remove some of the code.

All these changes give a small improvement on the RX side:
Before:
iperf3 -c 10.96.10.1 -R
[  5]   0.00-10.01  sec   514 MBytes   430 Mbits/sec    0         sender
[  5]   0.00-10.00  sec   509 MBytes   427 Mbits/sec              receiver

After:
iperf3 -c 10.96.10.1 -R
[  5]   0.00-10.02  sec   540 MBytes   452 Mbits/sec    0         sender
[  5]   0.00-10.01  sec   537 MBytes   450 Mbits/sec              receiver

---
v1->v2:
- rebase on net-next, once the fixes for FDMA and MTU were accepted
- drop patch 2, which changes the MTU as is not needed anymore
- allow to run xdp programs on frames bigger than 4KB

Horatiu Vultur (4):
  net: lan966x: Add define IFH_LEN_BYTES
  net: lan966x: Split function lan966x_fdma_rx_get_frame
  net: lan966x: Add basic XDP support
  net: lan96x: Use page_pool API

 .../net/ethernet/microchip/lan966x/Kconfig    |   1 +
 .../net/ethernet/microchip/lan966x/Makefile   |   3 +-
 .../ethernet/microchip/lan966x/lan966x_fdma.c | 166 ++++++++++++------
 .../ethernet/microchip/lan966x/lan966x_ifh.h  |   1 +
 .../ethernet/microchip/lan966x/lan966x_main.c |   7 +-
 .../ethernet/microchip/lan966x/lan966x_main.h |  25 +++
 .../ethernet/microchip/lan966x/lan966x_xdp.c  |  81 +++++++++
 7 files changed, 224 insertions(+), 60 deletions(-)
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_xdp.c

-- 
2.38.0

