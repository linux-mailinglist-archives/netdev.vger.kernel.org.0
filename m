Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C18766E1DF9
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 10:21:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230110AbjDNIVD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 04:21:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230096AbjDNIVB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 04:21:01 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84F3830C4;
        Fri, 14 Apr 2023 01:20:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1681460457; x=1712996457;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=rtLuS5HdkkGf6K1pvoN/8HXKoYmlRrjzY3AWTl9DpU8=;
  b=vZxv27T7W4bK5nlitQzwDF5X6zK27TwiWKgxlWMNOLsG/qLXZTwxnEWl
   wXJI79CKFFCRfHTyYxqvwVMoOGMwnyhoGoXYdJPLu5fEG+cKW3k+6z1t9
   RVx2ao1QDSOimY105W7iYKPhSsTCu1FIq5Rg686/KPMPVPh3fseJzPrHB
   Ey2nkShEbben+2y0tRDqBVFboH+AgEcz0MaUBrIjrvHkXMWRQ3rBvh4Nl
   wC/sI14BnJ4ILhPLRQN6RKSNofGhq9Fnvfl66HApgmByfkDGwRN0ugELD
   rrm06xzF65n0MUgsSQGGJXTniw3eBbqKa2V2pMYdsPxnEklz22He6YT9D
   w==;
X-IronPort-AV: E=Sophos;i="5.99,195,1677567600"; 
   d="scan'208,223";a="210429983"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 14 Apr 2023 01:20:55 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 14 Apr 2023 01:20:52 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.21 via Frontend Transport; Fri, 14 Apr 2023 01:20:51 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <UNGLinuxDriver@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next] net: lan966x: Fix lan966x_ifh_get
Date:   Fri, 14 Apr 2023 10:20:47 +0200
Message-ID: <20230414082047.1320947-1-horatiu.vultur@microchip.com>
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
then the return value became 0xffffffff... . To fix this, make sure to
clear all the other bits before returning the value.

Fixes: fd7627833ddf ("net: lan966x: Stop using packing library")
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 drivers/net/ethernet/microchip/lan966x/lan966x_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
index 80e2ea7e6ce8a..508e494dcc342 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
@@ -608,6 +608,7 @@ static u64 lan966x_ifh_get(u8 *ifh, size_t pos, size_t length)
 			val |= (1 << i);
 	}
 
+	val &= GENMASK(length, 0);
 	return val;
 }
 
-- 
2.38.0

