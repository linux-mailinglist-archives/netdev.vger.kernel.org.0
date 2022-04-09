Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 592634FAA32
	for <lists+netdev@lfdr.de>; Sat,  9 Apr 2022 20:39:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243005AbiDISlI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Apr 2022 14:41:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242998AbiDISlH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Apr 2022 14:41:07 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC2BF29B7C7;
        Sat,  9 Apr 2022 11:38:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1649529539; x=1681065539;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dVgtckquqWlgW80YtAs9y0siWvgrgYUEyaZIjS8N8pM=;
  b=PFuVUT0rxI8Y7rNrA9PasmhZJzb4QMo2saoE4spnnwQBxI7ecVNQso/f
   DF8L/eECiygk46zew1HzGvd7y4icTThWXMZJWhgYvWhTYd3j/V7FsGXqV
   ZN9+1/QaWBeuyOX21HZvqkMWnmY5JPk9SgrPuvqvt+InWaR4nQIsJkJIB
   vUTvZNuPVPGMTfEsAm1o8OFihiYLVRq+crdOElAzmnyEOZSuBRSDLpfoS
   EJI9EIPOrciNp0DnqLrS3LMzl9GqU4AhbJzHAvNqRJiPpXvhsCf5p2mKd
   D3BWHjIcL9BeZHiv86DtD/enr33tim5hWgpZ1DJ2eTkNyOtVgJM+3RQ6O
   w==;
X-IronPort-AV: E=Sophos;i="5.90,248,1643698800"; 
   d="scan'208";a="169060529"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 Apr 2022 11:38:59 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Sat, 9 Apr 2022 11:38:59 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Sat, 9 Apr 2022 11:38:57 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <pabeni@redhat.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net 1/4] net: lan966x: Update lan966x_ptp_get_nominal_value
Date:   Sat, 9 Apr 2022 20:41:40 +0200
Message-ID: <20220409184143.1204786-2-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220409184143.1204786-1-horatiu.vultur@microchip.com>
References: <20220409184143.1204786-1-horatiu.vultur@microchip.com>
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

The clk_per_cfg register represents the value added to the system clock
for each clock cycle. The issue is that the default value is wrong,
meaning that in case the DUT was a grandmaster then everone in the
network was too slow. In case there was a grandmaster, then there is no
issue because the DUT will configure clk_per_cfg register based on the
master frequency.

Fixes: d096459494a887 ("net: lan966x: Add support for ptp clocks")
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c b/drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c
index ae782778d6dd..0a1041da4384 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c
@@ -29,10 +29,10 @@ enum {
 
 static u64 lan966x_ptp_get_nominal_value(void)
 {
-	u64 res = 0x304d2df1;
-
-	res <<= 32;
-	return res;
+	/* This is the default value that for each system clock, the time of day
+	 * is increased. It has the format 5.59 nanosecond.
+	 */
+	return 0x304d4873ecade305;
 }
 
 int lan966x_ptp_hwtstamp_set(struct lan966x_port *port, struct ifreq *ifr)
-- 
2.33.0

