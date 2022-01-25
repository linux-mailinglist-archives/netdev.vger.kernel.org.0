Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27EE949B077
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 10:44:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1574875AbiAYJgy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 04:36:54 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:29899 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1574001AbiAYJbM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 04:31:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1643103072; x=1674639072;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TwRXqsdN5NwhMAaToE0UUM4xyI6wxFimLWovsxkc6CA=;
  b=Yx0ULF1UuvdYTWat0yEv4vkWFauup2rBxPicQwPTAvdhog2sNLHx/d3z
   WQEqnH/5MgYTohVHjnV95TzIvQ+9IsY97YUBQG7jbnUocwW+xMj/OAhlA
   4kROyIgdReFRofBHZSl/5iYEe4W7P2bb1oEYElAwI+bgtmj9kc3EEbIm7
   1KG7qtPyckYAmuvtaQSxP2LPWcsFSRhVHLreZRXGKcCx4ShWwkG5oU/9S
   laLWfIQTCBQYxWUSUfslasb13lA8+X6FQG3QoIjlZxs99BmEHCsw2VPSB
   cLh4JkJYKYdgn3flZqYCXxyxVrPw8r8gi77qErCkBcHX3VFuiaJS3Qipb
   g==;
IronPort-SDR: H4u0nSMx4H4rq2IpcEqMpdGysto/ZzTyAUWL5FD5oVSGPCBd3gtfLQYXvkbJTZfePPyGPCRn4d
 V4Wqc52NJDN5lDeTYnxoFb2bK2Sv4h1HX0zMXHXtKkhOIXUZaYGRU3TXsmwKwgyYIQq3mvAvCr
 NXyi7k+MOEP3ZQ8J6UjtB4bHP6SxVVN2HSAJh5ppusOTvbe611jdpxTa7q7ToNQSLErGh5qcqm
 VhSwpPZ+zB+1BkiLJjzm6S9w7+AxTTOWTiTtc5DGHb7mBCzr0c/M0Nm54M6SZExqwjUaK/peLn
 vgsvQeNQseP23hZRhjfMXniB
X-IronPort-AV: E=Sophos;i="5.88,314,1635231600"; 
   d="scan'208";a="146508633"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 25 Jan 2022 02:31:06 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 25 Jan 2022 02:31:05 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Tue, 25 Jan 2022 02:31:04 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <f.fainelli@gmail.com>,
        <vivien.didelot@gmail.com>, <vladimir.oltean@nxp.com>,
        <andrew@lunn.ch>, Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net 1/2] net: lan966x: Fix sleep in atomic context when injecting frames
Date:   Tue, 25 Jan 2022 10:30:23 +0100
Message-ID: <20220125093024.121072-2-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220125093024.121072-1-horatiu.vultur@microchip.com>
References: <20220125093024.121072-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On lan966x, when injecting a frame it was polling the register
QS_INJ_STATUS to see if it can continue with the injection of the frame.
The problem was that it was using readx_poll_timeout which could sleep
in atomic context.
This patch fixes this issue by using readx_poll_timeout_atomic.

Fixes: d28d6d2e37d10d ("net: lan966x: add port module support")
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 drivers/net/ethernet/microchip/lan966x/lan966x_main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
index 0835be02f62b..42461af80ecb 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
@@ -183,9 +183,9 @@ static int lan966x_port_inj_ready(struct lan966x *lan966x, u8 grp)
 {
 	u32 val;
 
-	return readx_poll_timeout(lan966x_port_inj_status, lan966x, val,
-				  QS_INJ_STATUS_FIFO_RDY_GET(val) & BIT(grp),
-				  READL_SLEEP_US, READL_TIMEOUT_US);
+	return readx_poll_timeout_atomic(lan966x_port_inj_status, lan966x, val,
+					 QS_INJ_STATUS_FIFO_RDY_GET(val) & BIT(grp),
+					 READL_SLEEP_US, READL_TIMEOUT_US);
 }
 
 static int lan966x_port_ifh_xmit(struct sk_buff *skb,
-- 
2.33.0

