Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 980844F1565
	for <lists+netdev@lfdr.de>; Mon,  4 Apr 2022 15:04:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348276AbiDDNF5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Apr 2022 09:05:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348531AbiDDNF4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Apr 2022 09:05:56 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 100C13E0DC;
        Mon,  4 Apr 2022 06:03:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1649077439; x=1680613439;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=hrpKSkodB356RKyALCaZlNpvnQeQ0qk1xOGGXXvqqzY=;
  b=qznQAuP+wdE1+1zXl37nEfFsweLBIqhSQS9zAW5UpbMMG3dnQCSDY54e
   Fgp9Wu5t6xhlwXHO62dYNe5Y9feueEJ8SLtWu9jolh00e8ZisqWGzG/TP
   RftKl+GwrjtuVuMuGAZeC54Pe16WCXW96x3liftYpxpBMHmunZMF8wSVt
   N1A4ABnzcoLQYh/SDUHOlVBoVoZvr6Otx9arVxX8Obwl4jnxeQB6ikfAl
   7/3E5hIgM1gv3xIL3Yfe+BoG3rNIstRc8gNQePilXM1DOZVYgMHPa7oay
   sDNtI40BSYZjgxzQlfDWX/vxnVnil1SUfS0HTSEak8VYkhkkCzc6sXN3t
   Q==;
X-IronPort-AV: E=Sophos;i="5.90,234,1643698800"; 
   d="scan'208";a="154281256"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Apr 2022 06:03:57 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 4 Apr 2022 06:03:57 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Mon, 4 Apr 2022 06:03:55 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <michael@walle.cc>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v3 0/4] net: lan966x: Add support for FDMA
Date:   Mon, 4 Apr 2022 15:06:51 +0200
Message-ID: <20220404130655.4004204-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
 .../ethernet/microchip/lan966x/lan966x_fdma.c | 783 ++++++++++++++++++
 .../ethernet/microchip/lan966x/lan966x_main.c |  49 +-
 .../ethernet/microchip/lan966x/lan966x_main.h | 121 +++
 .../ethernet/microchip/lan966x/lan966x_port.c |   3 +
 .../ethernet/microchip/lan966x/lan966x_regs.h | 106 +++
 6 files changed, 1052 insertions(+), 12 deletions(-)
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c

-- 
2.33.0

