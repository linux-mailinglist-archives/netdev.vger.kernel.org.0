Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA7C096F1F
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 03:57:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727115AbfHUB5A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 21:57:00 -0400
Received: from inva021.nxp.com ([92.121.34.21]:50722 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726533AbfHUB47 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Aug 2019 21:56:59 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 4801220008E;
        Wed, 21 Aug 2019 03:56:58 +0200 (CEST)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id C75962004C4;
        Wed, 21 Aug 2019 03:56:54 +0200 (CEST)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id 2BD67402FF;
        Wed, 21 Aug 2019 09:56:50 +0800 (SGT)
From:   Yangbo Lu <yangbo.lu@nxp.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        "Allan W . Nielsen" <allan.nielsen@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     Yangbo Lu <yangbo.lu@nxp.com>
Subject: [v4] ocelot_ace: fix action of trap
Date:   Wed, 21 Aug 2019 09:59:12 +0800
Message-Id: <20190821015912.43151-1-yangbo.lu@nxp.com>
X-Mailer: git-send-email 2.17.1
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The trap action should be copying the frame to CPU and
dropping it for forwarding, but current setting was just
copying frame to CPU.

Fixes: b596229448dd ("net: mscc: ocelot: Add support for tcam")
Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
Acked-by: Allan W. Nielsen <allan.nielsen@microchip.com>
---
Changes for v4:
	- Added ACK and Fixes info in commit message.
Changes for v3:
	- Set MASK_MODE to 1 for dropping forwarding.
	- Dropped other patches of patch-set.
Changes for v2:
	- None.
---
 drivers/net/ethernet/mscc/ocelot_ace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_ace.c b/drivers/net/ethernet/mscc/ocelot_ace.c
index 39aca1a..86fc6e6 100644
--- a/drivers/net/ethernet/mscc/ocelot_ace.c
+++ b/drivers/net/ethernet/mscc/ocelot_ace.c
@@ -317,7 +317,7 @@ static void is2_action_set(struct vcap_data *data,
 		break;
 	case OCELOT_ACL_ACTION_TRAP:
 		VCAP_ACT_SET(PORT_MASK, 0x0);
-		VCAP_ACT_SET(MASK_MODE, 0x0);
+		VCAP_ACT_SET(MASK_MODE, 0x1);
 		VCAP_ACT_SET(POLICE_ENA, 0x0);
 		VCAP_ACT_SET(POLICE_IDX, 0x0);
 		VCAP_ACT_SET(CPU_QU_NUM, 0x0);
-- 
2.7.4

