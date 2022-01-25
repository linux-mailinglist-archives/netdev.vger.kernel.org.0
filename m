Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69E1349B350
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 12:56:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386501AbiAYLw0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 06:52:26 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:9895 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355313AbiAYLrC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 06:47:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1643111222; x=1674647222;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xiWmJDXPO/D1w7Ju122vw1nvViDOQdNF7I3VbzCdrLs=;
  b=Y6TMqxtUPlYafTns07VspD7epH8ZmnGnHLHJ4lLy8yXOGlUrZw0cJXKr
   +kHmPjX8rBe/mi4V1HSDM9YJgb/VlU7vUHSetNUf5p232aEnEz9enD2/R
   DP5V5i4RBMSx5WqD/MuUzE1ExH4sFia6aBP7BIx0Iihy94JMyVNCjSQgD
   e0rNo2Zjs9pqfO2O2OCVkeUMxOVHU+YJUr2WoX7lIbCqMDiBLdKA9n4u2
   dzx395SYKaFb0bH6yrJzM0G3h6GX/P98M8sl3wzB6OFtriMwU8/xmT2g2
   TCDYpk7zaIzkHBca2qAywVN55Zfmkrv6P7pJFJ4uQkZFdWT6DZ3WP9V+H
   A==;
IronPort-SDR: QDLHEJUEW07O3b4Zo/oGQC1s+iqqQGv8lEXzpkl16U2m8JWeom6JR0qR4DLz2leccAk3aqqWS0
 mFxc8dwpS5D0BbBnAPeUS6XfIyqj9Xjg/U4fkx88lIVFHW6EeRrQs9EQewDkYiGmLz4cJgCS29
 97umIrd0AMPrVqISlJPRuv+WDIzliD/i19XN5INkhL07e5o69LUo5GOPj6ErERbtW/qI3EovMm
 KUdiuVp8KI/fWPZZ7pREk2aTTlwd92tr+fC72TEonnxuF21Wh+meAiv3SYnWzrPHT1QHZah+95
 s9kz6Mte2SnudOZf2hbAh/YO
X-IronPort-AV: E=Sophos;i="5.88,314,1635231600"; 
   d="scan'208";a="151350167"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 25 Jan 2022 04:47:02 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 25 Jan 2022 04:47:01 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Tue, 25 Jan 2022 04:46:59 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <f.fainelli@gmail.com>,
        <vivien.didelot@gmail.com>, <vladimir.oltean@nxp.com>,
        <andrew@lunn.ch>, Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net v2 2/2] net: lan966x: Fix sleep in atomic context when updating MAC table
Date:   Tue, 25 Jan 2022 12:48:16 +0100
Message-ID: <20220125114816.187124-3-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220125114816.187124-1-horatiu.vultur@microchip.com>
References: <20220125114816.187124-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The function lan966x_mac_wait_for_completion is used to poll the status
of the MAC table using the function readx_poll_timeout. The problem with
this function is that is called also from atomic context. Therefore
update the function to use readx_poll_timeout_atomic.

Fixes: e18aba8941b40b ("net: lan966x: add mactable support")
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 drivers/net/ethernet/microchip/lan966x/lan966x_mac.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_mac.c b/drivers/net/ethernet/microchip/lan966x/lan966x_mac.c
index ca5f1177963d..ce5970bdcc6a 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_mac.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_mac.c
@@ -40,11 +40,12 @@ static int lan966x_mac_wait_for_completion(struct lan966x *lan966x)
 {
 	u32 val;
 
-	return readx_poll_timeout(lan966x_mac_get_status,
-		lan966x, val,
-		(ANA_MACACCESS_MAC_TABLE_CMD_GET(val)) ==
-		MACACCESS_CMD_IDLE,
-		TABLE_UPDATE_SLEEP_US, TABLE_UPDATE_TIMEOUT_US);
+	return readx_poll_timeout_atomic(lan966x_mac_get_status,
+					 lan966x, val,
+					 (ANA_MACACCESS_MAC_TABLE_CMD_GET(val)) ==
+					 MACACCESS_CMD_IDLE,
+					 TABLE_UPDATE_SLEEP_US,
+					 TABLE_UPDATE_TIMEOUT_US);
 }
 
 static void lan966x_mac_select(struct lan966x *lan966x,
-- 
2.33.0

