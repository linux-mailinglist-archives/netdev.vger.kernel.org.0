Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2776031523
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 21:18:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727215AbfEaTSd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 15:18:33 -0400
Received: from sed198n136.SEDSystems.ca ([198.169.180.136]:24432 "EHLO
        sed198n136.sedsystems.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727122AbfEaTSc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 15:18:32 -0400
Received: from barney.sedsystems.ca (barney [198.169.180.121])
        by sed198n136.sedsystems.ca  with ESMTP id x4VJIB9a032123
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 31 May 2019 13:18:11 -0600 (CST)
Received: from SED.RFC1918.192.168.sedsystems.ca (eng1n65.eng.sedsystems.ca [172.21.1.65])
        by barney.sedsystems.ca (8.14.7/8.14.4) with ESMTP id x4VJI9W7010639
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Fri, 31 May 2019 13:18:11 -0600
From:   Robert Hancock <hancock@sedsystems.ca>
To:     netdev@vger.kernel.org
Cc:     linux@armlinux.org.uk, Robert Hancock <hancock@sedsystems.ca>
Subject: [PATCH net-next] net: sfp: Stop SFP polling during shutdown
Date:   Fri, 31 May 2019 13:18:02 -0600
Message-Id: <1559330285-30246-2-git-send-email-hancock@sedsystems.ca>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1559330285-30246-1-git-send-email-hancock@sedsystems.ca>
References: <1559330285-30246-1-git-send-email-hancock@sedsystems.ca>
X-Scanned-By: MIMEDefang 2.64 on 198.169.180.136
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SFP device polling can cause problems during the shutdown process if the
parent devices of the network controller have been shut down already.
This problem was seen on the iMX6 platform with PCIe devices, where
accessing the device after the bus is shut down causes a hang.

Stop all delayed work in the SFP driver during the shutdown process to
avoid this problem.

Signed-off-by: Robert Hancock <hancock@sedsystems.ca>
---
 drivers/net/phy/sfp.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index 554acc8..6b6c83d 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -1928,9 +1928,18 @@ static int sfp_remove(struct platform_device *pdev)
 	return 0;
 }
 
+static void sfp_shutdown(struct platform_device *pdev)
+{
+	struct sfp *sfp = platform_get_drvdata(pdev);
+
+	cancel_delayed_work_sync(&sfp->poll);
+	cancel_delayed_work_sync(&sfp->timeout);
+}
+
 static struct platform_driver sfp_driver = {
 	.probe = sfp_probe,
 	.remove = sfp_remove,
+	.shutdown = sfp_shutdown,
 	.driver = {
 		.name = "sfp",
 		.of_match_table = sfp_of_match,
-- 
1.8.3.1

