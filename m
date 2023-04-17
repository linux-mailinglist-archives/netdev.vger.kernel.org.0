Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 912486E40D5
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 09:27:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230211AbjDQH1V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 03:27:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230342AbjDQH1F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 03:27:05 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22C34423B;
        Mon, 17 Apr 2023 00:26:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1681716407; x=1713252407;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=jRW6cL+cIiKb2Ng2FGwD0jd41pvkdwoEaHwYjvdHuow=;
  b=iz7mtkQle6pOkEIwFsj8gZ+gRKttmiPbE8anBJnA4Nc6yFDoaQYqOlBX
   ZHqCuEydYe51nnHeHHbCgkkiOXAk4oNGTRx4gNSIKSZv3H9bCW0uY9Djl
   ef5RYYY4bGFwuNy+O2jvUaCRoik5Rm4dkmSU3NH0QFw6QjgFCwSlxe570
   A292+cdpdRH0Dcj/znygbRA0kfnph0EgbLZvtQsyESGsg9L0jRdosIUme
   gfO3mLL/Vw3ndcIBbBq6QF6HgrdM1SF2JgGyAbQIF/CclGNpgilWi0VZk
   Rino57rCx/5m+fqH5YM9t+GAcSU+oj/xa4q731rpLRXEEIiVwW3dlMrKk
   A==;
X-IronPort-AV: E=Sophos;i="5.99,203,1677567600"; 
   d="scan'208,223";a="210729526"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Apr 2023 00:26:46 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 17 Apr 2023 00:26:45 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2507.21 via Frontend Transport; Mon, 17 Apr 2023 00:26:43 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <UNGLinuxDriver@microchip.com>,
        <aleksander.lobakin@intel.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v2] net: lan966x: Fix lan966x_ifh_get
Date:   Mon, 17 Apr 2023 09:26:41 +0200
Message-ID: <20230417072641.1656960-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From time to time, it was observed that the nanosecond part of the
received timestamp, which is extracted from the IFH, it was actually
bigger than 1 second. So then when actually calculating the full
received timestamp, based on the nanosecond part from IFH and the second
part which is read from HW, it was actually wrong.

The issue seems to be inside the function lan966x_ifh_get, which
extracts information from an IFH(which is an byte array) and returns the
value in a u64. When extracting the timestamp value from the IFH, which
starts at bit 192 and have the size of 32 bits, then if the most
significant bit was set in the timestamp, then this bit was extended
then the return value became 0xffffffff... . And the reason of this is
because constants without any postfix are treated as signed longs and
that is the reason why '1 << 31' becomes 0xffffffff80000000.
This is fixed by adding the postfix 'ULL' to 1.

Fixes: fd7627833ddf ("net: lan966x: Stop using packing library")
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>

---
v1->v2:
- use postfix ULL when setting the bit in the val instead of masking in
  the end the val.
---
 drivers/net/ethernet/microchip/lan966x/lan966x_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
index 80e2ea7e6ce8a..5f01b21acdd1b 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
@@ -605,7 +605,7 @@ static u64 lan966x_ifh_get(u8 *ifh, size_t pos, size_t length)
 			v = ifh[IFH_LEN_BYTES - (j / 8) - 1];
 
 		if (v & (1 << k))
-			val |= (1 << i);
+			val |= (1ULL << i);
 	}
 
 	return val;
-- 
2.38.0

