Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A3D637BD3
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 20:06:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730398AbfFFSGi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 14:06:38 -0400
Received: from sed198n136.SEDSystems.ca ([198.169.180.136]:36408 "EHLO
        sed198n136.sedsystems.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730352AbfFFSGi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 14:06:38 -0400
Received: from barney.sedsystems.ca (barney [198.169.180.121])
        by sed198n136.sedsystems.ca  with ESMTP id x56I6QHD012438
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 6 Jun 2019 12:06:26 -0600 (CST)
Received: from SED.RFC1918.192.168.sedsystems.ca (eng1n65.eng.sedsystems.ca [172.21.1.65])
        by barney.sedsystems.ca (8.14.7/8.14.4) with ESMTP id x56I6Pu2001518
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Thu, 6 Jun 2019 12:06:25 -0600
From:   Robert Hancock <hancock@sedsystems.ca>
To:     netdev@vger.kernel.org
Cc:     linux@armlinux.org.uk, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, Robert Hancock <hancock@sedsystems.ca>
Subject: [PATCH net-next] net: sfp: Stop SFP polling and interrupt handling during shutdown
Date:   Thu,  6 Jun 2019 12:06:17 -0600
Message-Id: <1559844377-17188-1-git-send-email-hancock@sedsystems.ca>
X-Mailer: git-send-email 1.8.3.1
X-Scanned-By: MIMEDefang 2.64 on 198.169.180.136
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SFP device polling can cause problems during the shutdown process if the
parent devices of the network controller have been shut down already.
This problem was seen on the iMX6 platform with PCIe devices, where
accessing the device after the bus is shut down causes a hang.

Stop all delayed work in the SFP driver during the shutdown process, and
set a flag which causes any further state checks or state machine events
(possibly triggered by previous GPIO IRQs) to be skipped.

Signed-off-by: Robert Hancock <hancock@sedsystems.ca>
---

This is an updated version of a previous patch "net: sfp: Stop SFP polling
during shutdown" with the addition of stopping handling of GPIO-triggered
interrupts as well, as pointed out by Russell King.

 drivers/net/phy/sfp.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index 554acc8..5fdf573 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -191,6 +191,7 @@ struct sfp {
 	struct delayed_work poll;
 	struct delayed_work timeout;
 	struct mutex sm_mutex;
+	bool shutdown;
 	unsigned char sm_mod_state;
 	unsigned char sm_dev_state;
 	unsigned short sm_state;
@@ -1466,6 +1467,11 @@ static void sfp_sm_mod_remove(struct sfp *sfp)
 static void sfp_sm_event(struct sfp *sfp, unsigned int event)
 {
 	mutex_lock(&sfp->sm_mutex);
+	if (unlikely(sfp->shutdown)) {
+		/* Do not handle any more state machine events. */
+		mutex_unlock(&sfp->sm_mutex);
+		return;
+	}
 
 	dev_dbg(sfp->dev, "SM: enter %s:%s:%s event %s\n",
 		mod_state_to_str(sfp->sm_mod_state),
@@ -1704,6 +1710,13 @@ static void sfp_check_state(struct sfp *sfp)
 {
 	unsigned int state, i, changed;
 
+	mutex_lock(&sfp->sm_mutex);
+	if (unlikely(sfp->shutdown)) {
+		/* No more state checks */
+		mutex_unlock(&sfp->sm_mutex);
+		return;
+	}
+
 	state = sfp_get_state(sfp);
 	changed = state ^ sfp->state;
 	changed &= SFP_F_PRESENT | SFP_F_LOS | SFP_F_TX_FAULT;
@@ -1715,6 +1728,7 @@ static void sfp_check_state(struct sfp *sfp)
 
 	state |= sfp->state & (SFP_F_TX_DISABLE | SFP_F_RATE_SELECT);
 	sfp->state = state;
+	mutex_unlock(&sfp->sm_mutex);
 
 	rtnl_lock();
 	if (changed & SFP_F_PRESENT)
@@ -1928,9 +1942,22 @@ static int sfp_remove(struct platform_device *pdev)
 	return 0;
 }
 
+static void sfp_shutdown(struct platform_device *pdev)
+{
+	struct sfp *sfp = platform_get_drvdata(pdev);
+
+	mutex_lock(&sfp->sm_mutex);
+	sfp->shutdown = true;
+	mutex_unlock(&sfp->sm_mutex);
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

