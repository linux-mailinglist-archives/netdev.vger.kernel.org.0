Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC6FE89BD0
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 12:45:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728014AbfHLKpv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 06:45:51 -0400
Received: from inva021.nxp.com ([92.121.34.21]:36752 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727992AbfHLKpv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Aug 2019 06:45:51 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id ACAE42000CE;
        Mon, 12 Aug 2019 12:45:49 +0200 (CEST)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 0AB0120064E;
        Mon, 12 Aug 2019 12:45:47 +0200 (CEST)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id 58BC74030E;
        Mon, 12 Aug 2019 18:45:43 +0800 (SGT)
From:   Yangbo Lu <yangbo.lu@nxp.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
Cc:     Yangbo Lu <yangbo.lu@nxp.com>
Subject: [PATCH 3/3] ocelot_ace: fix action of trap
Date:   Mon, 12 Aug 2019 18:48:27 +0800
Message-Id: <20190812104827.5935-4-yangbo.lu@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190812104827.5935-1-yangbo.lu@nxp.com>
References: <20190812104827.5935-1-yangbo.lu@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The trap action should be copying the frame to CPU and
dropping it for forwarding, but current setting was just
copying frame to CPU.

Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot_ace.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_ace.c b/drivers/net/ethernet/mscc/ocelot_ace.c
index 91250f3..59ad590 100644
--- a/drivers/net/ethernet/mscc/ocelot_ace.c
+++ b/drivers/net/ethernet/mscc/ocelot_ace.c
@@ -317,9 +317,9 @@ static void is2_action_set(struct vcap_data *data,
 		break;
 	case OCELOT_ACL_ACTION_TRAP:
 		VCAP_ACT_SET(PORT_MASK, 0x0);
-		VCAP_ACT_SET(MASK_MODE, 0x0);
-		VCAP_ACT_SET(POLICE_ENA, 0x0);
-		VCAP_ACT_SET(POLICE_IDX, 0x0);
+		VCAP_ACT_SET(MASK_MODE, 0x1);
+		VCAP_ACT_SET(POLICE_ENA, 0x1);
+		VCAP_ACT_SET(POLICE_IDX, OCELOT_POLICER_DISCARD);
 		VCAP_ACT_SET(CPU_QU_NUM, 0x0);
 		VCAP_ACT_SET(CPU_COPY_ENA, 0x1);
 		break;
-- 
2.7.4

