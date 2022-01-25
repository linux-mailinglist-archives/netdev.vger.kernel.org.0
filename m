Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22A4C49B07A
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 10:44:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1574878AbiAYJg5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 04:36:57 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:29910 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1574013AbiAYJbM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 04:31:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1643103072; x=1674639072;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6d9Z6Xs1Va0nHp2gobIYn7AV7Zr46kgwR57Go3VeHQQ=;
  b=kgZPWMHZbifkG/Na3Tffj3e0V3/yhjcsDS67SgTaITMXexE3Hzk2xeaT
   hu4VWpomhU3TMlVoRJ5I2yaoQw2MbaNm6IEtzJd1PTZo+ngt9yeWMs+5D
   juAiVOu4H362VZ2/bSs12SVxQx7aLLKw53IwCPh/cS+FXlT1NEnzaSL3n
   kEd82WIuG3Az+HiUqqleP1U4Znp6PtzNJQxKIT3w1v2qMHIU/jYdNlnZ4
   SHx+dRc4pqKEmCNJr0qGKDBHE7Kar3oqKhEpt8XOc+uF0IcT1Rni+b7+5
   r5xMNO5a0dh+r8XWexZoPev01UIu5Tsy1h5597SjoTvqbTfHSt39iiOEs
   Q==;
IronPort-SDR: odpmaaF1/rK3h50/A9LtHIYXGjATpnll7Nyj1XWjPGWAxWBGp84zB9C7syOcxsxAGgWB6eWDw9
 Htz7KvPXyyrZVpqyqWg4JpugLlcdgDDmJ7cqKdB1RVR+j9bKndtQevojBEq71abv0XGFlAjWIJ
 q8bhiZIB0E8MRTv6orDsf+u/zd2R1I38MgAYwhzv8fvEgPuESuqsLtCesrAOsIWJMQMYdvAqqJ
 EeEP2UJWMFKcbf95PLUovMJkAyAPfMfBuQjRhDUtWt2xkCE1m2SeW+2R+sgM+zhqyecp7TIU4N
 eNYp+ngXyRkQW/tKzGnSSsTa
X-IronPort-AV: E=Sophos;i="5.88,314,1635231600"; 
   d="scan'208";a="146508644"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 25 Jan 2022 02:31:08 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 25 Jan 2022 02:31:08 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Tue, 25 Jan 2022 02:31:06 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <f.fainelli@gmail.com>,
        <vivien.didelot@gmail.com>, <vladimir.oltean@nxp.com>,
        <andrew@lunn.ch>, Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net 2/2] net: lan966x: Fix sleep in atomic context when updating MAC table
Date:   Tue, 25 Jan 2022 10:30:24 +0100
Message-ID: <20220125093024.121072-3-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220125093024.121072-1-horatiu.vultur@microchip.com>
References: <20220125093024.121072-1-horatiu.vultur@microchip.com>
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

Fixes: f8f233c510bda0 ("net: lan966x: add mactable support")
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

