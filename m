Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 073AE2511C6
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 07:55:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728933AbgHYFzE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 01:55:04 -0400
Received: from lelv0143.ext.ti.com ([198.47.23.248]:57226 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726090AbgHYFzE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 01:55:04 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 07P5sofs048261;
        Tue, 25 Aug 2020 00:54:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1598334890;
        bh=duyqkgdZLKCTlkGLaMdgAkkMB3mW9knGedMzsy1T14E=;
        h=From:To:CC:Subject:Date;
        b=tOVdYnP+frzvJARr/LTTrYvwaapkKNRW883MplcBvowCq6km/wckDDt6wJBsYJ0t+
         KrGPt8o9OAN+MLi0/aC/46wJm2NZmvH5BzAa6vq1Q9gDUU/ue67NjwTZJFmS2HRvvc
         LoIoSV2XZ94Nz79g1MUxKy/X1QdeenvSyq+LGIME=
Received: from DLEE113.ent.ti.com (dlee113.ent.ti.com [157.170.170.24])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id 07P5so1X001719;
        Tue, 25 Aug 2020 00:54:50 -0500
Received: from DLEE102.ent.ti.com (157.170.170.32) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Tue, 25
 Aug 2020 00:54:49 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE102.ent.ti.com
 (157.170.170.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Tue, 25 Aug 2020 00:54:49 -0500
Received: from a0230074-Latitude-E7470.dhcp.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 07P5silM040890;
        Tue, 25 Aug 2020 00:54:45 -0500
From:   Faiz Abbas <faiz_abbas@ti.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-can@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <mkl@pengutronix.de>,
        <wg@grandegger.com>, <sriram.dash@samsung.com>, <dmurphy@ti.com>,
        <faiz_abbas@ti.com>
Subject: [PATCH v2] can: m_can: Set device to software init mode before closing
Date:   Tue, 25 Aug 2020 11:24:42 +0530
Message-ID: <20200825055442.16994-1-faiz_abbas@ti.com>
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

changes since v1: Rebased to latest mainline

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

