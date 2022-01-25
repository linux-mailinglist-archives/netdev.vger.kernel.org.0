Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FA5A49B34F
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 12:56:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386120AbiAYLwZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 06:52:25 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:25108 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383319AbiAYLrB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 06:47:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1643111223; x=1674647223;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tBS1oooINcoPPhFdV7Fig+rpHjigLCk1Y9KbxXjmWA8=;
  b=0R6vhUg7qsvwXHqFQv+LfYlJndPMLDdSQWmVPogGToNCEfYcljfl7myi
   TnLGsWAncpwCZTxxZB2WZt/NPjDr+b26P0d1fsEbG9qd5s29ckFrUpgJO
   bJXlv/7W/AYxL75vG3FPISNnswxXHgsR6PdY05JVpMVb/hP50LhsgRQEJ
   HeS3vwlVxZaad/CsqTk9hf0DMQWZA2n6m1a5mG4b3l3Nte5HkehA/aR42
   q7rzI58fGNIOUR+max9vwD27xpdobnDxltquDKLtjuycA9+wTp/BEGB1P
   kpV4FSPazlwXLuaVcPbUwKzJ+vPWJLR3pbCMxD5moXVVcNselInmaEg27
   Q==;
IronPort-SDR: qbw5lq8OIUtHc8/H6w53g1M+DT/GsXROUCyRH+HCG1Idx2+FZacxIoHQhYh4x5rRcK4mBJvIFG
 l16sVqLSJ9sl2bHngpZLYAXamMe88SKzndS0IGomYfmWXY5T/JNxRKPhdVmyZHlyU01YQvzKRB
 HOCG7tPne0HtYctVBxc4FInr+gUrQ6Zlr/u3DyToj2JPuWmCItjGuQze8sPF2QhZ0pypqERh7D
 kH/uhCAUROC0I0Wr/7Z1QVuKKx57yrMkz6WzasnHoXpdxlahSAmldraogdmyEu+0kTvMvofMxa
 E5LQqQPScHYZtdPOMFu0wMz1
X-IronPort-AV: E=Sophos;i="5.88,314,1635231600"; 
   d="scan'208";a="150799843"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 25 Jan 2022 04:47:01 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 25 Jan 2022 04:46:59 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Tue, 25 Jan 2022 04:46:57 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <f.fainelli@gmail.com>,
        <vivien.didelot@gmail.com>, <vladimir.oltean@nxp.com>,
        <andrew@lunn.ch>, Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net v2 1/2] net: lan966x: Fix sleep in atomic context when injecting frames
Date:   Tue, 25 Jan 2022 12:48:15 +0100
Message-ID: <20220125114816.187124-2-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220125114816.187124-1-horatiu.vultur@microchip.com>
References: <20220125114816.187124-1-horatiu.vultur@microchip.com>
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
index 4e31239316e8..e62758bcb998 100644
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

