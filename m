Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A42084F8F15
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 09:07:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbiDHHDB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 03:03:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbiDHHC7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 03:02:59 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E01E6B53D;
        Fri,  8 Apr 2022 00:00:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1649401255; x=1680937255;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=s2SHzgXPNkhGn4FjSnU3OOm/P7t9aDy3XNrOcD+cnvo=;
  b=m9pAcIqQ1A7vENZgX7WmSF7i5UtIKybHcYlRF8WWehl1PGSeHWw7zvwH
   WXEO9JxY271gj+SX0xz7Hhw2YlxCAqjcD5KMJcTvpTI31+F6W+yINOlxx
   OJ92GkJLq7QPWoV24RNs9qLdGDCUe2sd6iump4nSFygCsMpO7284lvVZ0
   vF7S2eH13hYU93AQ92C1cxQjRRGB18mluuBbaiY3OSV7x3rHjeF+KFmrn
   N+cidiaMz8mXRqleJ/u6fXuOmc41BfWIwsAZ0OFVdwTECgG/QO360QHCd
   reQqqB3VB07a8cvq55Ih3GACT/sFuoFqAiTBoZnl5HAZuD7ZXoqUzyvvK
   A==;
X-IronPort-AV: E=Sophos;i="5.90,244,1643698800"; 
   d="scan'208";a="91728871"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 08 Apr 2022 00:00:54 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 8 Apr 2022 00:00:54 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Fri, 8 Apr 2022 00:00:52 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <michael@walle.cc>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v4 0/4] net: lan966x: Add support for FDMA
Date:   Fri, 8 Apr 2022 09:03:53 +0200
Message-ID: <20220408070357.559899-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently when injecting or extracting a frame from CPU, the frame
is given to the HW each word at a time. There is another way to
inject/extract frames from CPU using FDMA(Frame Direct Memory Access).
In this way the entire frame is given to the HW. This improves both
RX and TX bitrate.

Tested-by: Michael Walle <michael@walle.cc> # on kontron-kswitch-d10

v3->v4:
- fix race conditions when changing the MTU
- build skbs once frames are received and not before
- use NAPI_POLL_WEIGHT instead of FDMA_WEIGHT

v2->v3:
- move skb_tx_timestamp before the IFH is inserted, because in case of PHY
  timestamping, the PHY should not see the IFH.
- use lower/upper_32_bits()
- reimplement the RX path in case of memory pressure.
- use devm_request_irq instead of devm_request_threaded_irq
- add various checks for return values.

v1->v2:
- fix typo in commit message in last patch
- remove first patch as the changes are already there
- make sure that there is space in skb to put the FCS
- move skb_tx_timestamp closer to the handover of the frame to the HW

Horatiu Vultur (4):
  net: lan966x: Add registers that are used for FDMA.
  net: lan966x: Expose functions that are needed by FDMA
  net: lan966x: Add FDMA functionality
  net: lan966x: Update FDMA to change MTU.

 .../net/ethernet/microchip/lan966x/Makefile   |   2 +-
 .../ethernet/microchip/lan966x/lan966x_fdma.c | 842 ++++++++++++++++++
 .../ethernet/microchip/lan966x/lan966x_main.c |  59 +-
 .../ethernet/microchip/lan966x/lan966x_main.h | 117 +++
 .../ethernet/microchip/lan966x/lan966x_port.c |   3 +
 .../ethernet/microchip/lan966x/lan966x_regs.h | 106 +++
 6 files changed, 1117 insertions(+), 12 deletions(-)
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c

-- 
2.33.0

