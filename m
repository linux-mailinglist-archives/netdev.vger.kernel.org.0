Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F33F54D1DDA
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 17:55:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347586AbiCHQ4D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 11:56:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345576AbiCHQ4C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 11:56:02 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 190964ECF9;
        Tue,  8 Mar 2022 08:55:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1646758505; x=1678294505;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=6C2mZ4cPAPhBiwzAinOa3KOV00eNAxZd7Qi1+RwReUs=;
  b=aTubupD8D5HKsnE67ZLaQjaNN214lw3UGfxIuKW46Kzoldvkayl5bQPS
   GwlpMF5/vtbsGBQ6/zEc14f5pPDBP6n//ezAwHuBgw3rPXQjDS3mjTwYv
   NEA1yseutes3wTD6HsG3RWqXxKH2AMkcj2hJ1h49Rv7HxpQHcSCPo0a3G
   IkRXPCe8L7+2MbxcwjMXjaRBSf2dfNEKxc2faUAD43wL+MAZm6JQTcqNo
   LQgFXAOfYaIsGmzIu40Oz3DkH2GAO7HxXOrRMVud89VOgNxgTofoL3uke
   hAfNCWB0DKw+XkstiD3iPdKperjpaDlefceJ4b3JngwIZod2/mgMPn+LS
   w==;
X-IronPort-AV: E=Sophos;i="5.90,165,1643698800"; 
   d="scan'208";a="88232263"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 08 Mar 2022 09:55:05 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 8 Mar 2022 09:55:05 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Tue, 8 Mar 2022 09:55:03 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next] net: lan966x: Improve the CPU TX bitrate.
Date:   Tue, 8 Mar 2022 17:57:27 +0100
Message-ID: <20220308165727.4088656-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,T_SCC_BODY_TEXT_LINE,
        T_SPF_PERMERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace 'readx_poll_timeout_atomic' with a simple while loop + timeout
when checking if it is possible to write to the HW the next word of the
frame.
Doing this will improve the TX bitrate by 65%. The measurements were
done using iperf3.

Before:
[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-10.03  sec  55.2 MBytes  46.2 Mbits/sec    0 sender
[  5]   0.00-10.04  sec  53.8 MBytes  45.0 Mbits/sec      receiver

After:
[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-10.02  sec  91.4 MBytes  76.6 Mbits/sec    0 sender
[  5]   0.00-10.03  sec  90.2 MBytes  75.5 Mbits/sec      receiver

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 .../ethernet/microchip/lan966x/lan966x_main.c | 20 ++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
index 81c01665d01e..f6cef29b9d36 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
@@ -176,18 +176,20 @@ static int lan966x_port_stop(struct net_device *dev)
 	return 0;
 }
 
-static int lan966x_port_inj_status(struct lan966x *lan966x)
-{
-	return lan_rd(lan966x, QS_INJ_STATUS);
-}
-
 static int lan966x_port_inj_ready(struct lan966x *lan966x, u8 grp)
 {
-	u32 val;
+	unsigned long time = jiffies + usecs_to_jiffies(READL_TIMEOUT_US);
+	int ret = 0;
 
-	return readx_poll_timeout_atomic(lan966x_port_inj_status, lan966x, val,
-					 QS_INJ_STATUS_FIFO_RDY_GET(val) & BIT(grp),
-					 READL_SLEEP_US, READL_TIMEOUT_US);
+	while (!(lan_rd(lan966x, QS_INJ_STATUS) &
+		 QS_INJ_STATUS_FIFO_RDY_SET(BIT(grp)))) {
+		if (time_after(jiffies, time)) {
+			ret = -ETIMEDOUT;
+			break;
+		}
+	}
+
+	return ret;
 }
 
 static int lan966x_port_ifh_xmit(struct sk_buff *skb,
-- 
2.33.0

