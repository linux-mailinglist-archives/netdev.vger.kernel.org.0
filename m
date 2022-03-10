Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B495F4D42BD
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 09:39:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240418AbiCJIkw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 03:40:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230179AbiCJIkv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 03:40:51 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11B34136ED1;
        Thu, 10 Mar 2022 00:39:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1646901587; x=1678437587;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=NCJAmap5YXI9l6Z+GDL5+JaEtIVVUsg+cezq3a0cE00=;
  b=zzzgUKoTndfK1kvorz5DY8c75r8ubStwyP/rjpDdtu4wFs6gwu2GqC9X
   1f4O++PWW/hU2MszJyyREnSQiZG38wwPFcPnjM8hPXLYpkbt8wLdQasg0
   3oI/ypTAzOarbG40I9CiLAqrOUAvLUnmgfPf0iHgA4X+EGQKrW2ncOWjf
   9GKh79iGF7WYeUv2NHnq3uuEDA5GHN+xTaAIY5i8l4uKFvsS62qtTtxCH
   fL4FSEDbwKynLG/sjIXN75IuJGpHlLAJNeapHN18y9iZEw6hlKltiNSMv
   FOec11hCUF9FYHDf3vDawaXHIFZQh3D91S3YoKpLl27+djBTeT+PYJlLi
   A==;
X-IronPort-AV: E=Sophos;i="5.90,169,1643698800"; 
   d="scan'208";a="88479619"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 10 Mar 2022 01:39:46 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Thu, 10 Mar 2022 01:39:46 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Thu, 10 Mar 2022 01:39:44 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <david.laight@aculab.com>, <andrew@lunn.ch>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v2] net: lan966x: Improve the CPU TX bitrate.
Date:   Thu, 10 Mar 2022 09:40:05 +0100
Message-ID: <20220310084005.262551-1-horatiu.vultur@microchip.com>
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

When doing manual injection of the frame, it is required to check if the
TX FIFO is ready to accept the next word of the frame. For this we are
using 'readx_poll_timeout_atomic', the only problem is that before it
actually checks the status, is determining the time when to finish polling
the status. Which seems to be an expensive operation.
Therefore check the status of the TX FIFO before calling
'readx_poll_timeout_atomic'.
Doing this will improve the TX bitrate by ~70%. Because 99% the FIFO is
ready by that time. The measurements were done using iperf3.

Before:
[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-10.03  sec  55.2 MBytes  46.2 Mbits/sec    0 sender
[  5]   0.00-10.04  sec  53.8 MBytes  45.0 Mbits/sec      receiver

After:
[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-10.10  sec  95.0 MBytes  78.9 Mbits/sec    0 sender
[  5]   0.00-10.11  sec  95.0 MBytes  78.8 Mbits/sec      receiver

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
v1->v2
- check for TX FIFO status before calling readx_poll_timeout_atomic
---
 drivers/net/ethernet/microchip/lan966x/lan966x_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
index 81c01665d01e..e1bcb28039dc 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
@@ -185,6 +185,9 @@ static int lan966x_port_inj_ready(struct lan966x *lan966x, u8 grp)
 {
 	u32 val;
 
+	if (lan_rd(lan966x, QS_INJ_STATUS) & QS_INJ_STATUS_FIFO_RDY_SET(BIT(grp)))
+		return 0;
+
 	return readx_poll_timeout_atomic(lan966x_port_inj_status, lan966x, val,
 					 QS_INJ_STATUS_FIFO_RDY_GET(val) & BIT(grp),
 					 READL_SLEEP_US, READL_TIMEOUT_US);
-- 
2.33.0

