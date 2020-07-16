Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60599221B38
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 06:25:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725950AbgGPEXc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 00:23:32 -0400
Received: from lelv0143.ext.ti.com ([198.47.23.248]:40140 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725268AbgGPEXc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 00:23:32 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 06G4NHh4053064;
        Wed, 15 Jul 2020 23:23:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1594873398;
        bh=n1xpmpifzwr3iQTyJflXTGpcVwdiIXOkn+SYdcnsPJE=;
        h=From:To:CC:Subject:Date;
        b=HaDnXEiqCTLzixwGCVji1pobk/61gBgshlHgKrVWrz1GsMBvwtbuKsBV8MhKLC3lf
         OkNHMPMdgx5DO/xNiW2ZGI8ir0oIseMoLNWttvMFUp3jQBuBSMB2lVJsZUmpt2fIog
         /F33Qc30IeDvWrdqRdfDzBX4oAkcIg9ub5Anjkrs=
Received: from DFLE113.ent.ti.com (dfle113.ent.ti.com [10.64.6.34])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 06G4NHXk084956
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 15 Jul 2020 23:23:17 -0500
Received: from DFLE100.ent.ti.com (10.64.6.21) by DFLE113.ent.ti.com
 (10.64.6.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Wed, 15
 Jul 2020 23:23:17 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE100.ent.ti.com
 (10.64.6.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Wed, 15 Jul 2020 23:23:17 -0500
Received: from a0230074-Latitude-E7470.ent.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 06G4NCZq007189;
        Wed, 15 Jul 2020 23:23:13 -0500
From:   Faiz Abbas <faiz_abbas@ti.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-can@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <mkl@pengutronix.de>,
        <wg@grandegger.com>, <sriram.dash@samsung.com>, <dmurphy@ti.com>,
        <faiz_abbas@ti.com>
Subject: [PATCH] can: m_can: Set device to software init mode before closing
Date:   Thu, 16 Jul 2020 09:53:12 +0530
Message-ID: <20200716042312.26989-1-faiz_abbas@ti.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There might be some requests pending in the buffer when the
interface close sequence occurs. In some devices, these
pending requests might lead to the module not shutting down
properly when m_can_clk_stop() is called.

Therefore, move the device to init state before potentially
powering it down.

Signed-off-by: Faiz Abbas <faiz_abbas@ti.com>
---
 drivers/net/can/m_can/m_can.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index 02c5795b7393..d0c458f7f6e1 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -1414,6 +1414,9 @@ static void m_can_stop(struct net_device *dev)
 	/* disable all interrupts */
 	m_can_disable_all_interrupts(cdev);
 
+	/* Set init mode to disengage from the network */
+	m_can_config_endisable(cdev, true);
+
 	/* set the state as STOPPED */
 	cdev->can.state = CAN_STATE_STOPPED;
 }
-- 
2.17.1

