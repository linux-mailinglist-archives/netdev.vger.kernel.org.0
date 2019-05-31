Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BA7C3151E
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 21:16:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727161AbfEaTQL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 15:16:11 -0400
Received: from sed198n136.SEDSystems.ca ([198.169.180.136]:44724 "EHLO
        sed198n136.sedsystems.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726807AbfEaTQL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 15:16:11 -0400
Received: from barney.sedsystems.ca (barney [198.169.180.121])
        by sed198n136.sedsystems.ca  with ESMTP id x4VJGAqE005235
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 31 May 2019 13:16:10 -0600 (CST)
Received: from SED.RFC1918.192.168.sedsystems.ca (eng1n65.eng.sedsystems.ca [172.21.1.65])
        by barney.sedsystems.ca (8.14.7/8.14.4) with ESMTP id x4VJG6dn007508
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Fri, 31 May 2019 13:16:10 -0600
From:   Robert Hancock <hancock@sedsystems.ca>
To:     netdev@vger.kernel.org
Cc:     Robert Hancock <hancock@sedsystems.ca>
Subject: [PATCH net-next] net: phy: Ensure scheduled work is cancelled during removal
Date:   Fri, 31 May 2019 13:15:50 -0600
Message-Id: <1559330150-30099-2-git-send-email-hancock@sedsystems.ca>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1559330150-30099-1-git-send-email-hancock@sedsystems.ca>
References: <1559330150-30099-1-git-send-email-hancock@sedsystems.ca>
X-Scanned-By: MIMEDefang 2.64 on 198.169.180.136
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is possible that scheduled work started by the PHY driver is still
outstanding when phy_device_remove is called if the PHY was initially
started but never connected, and therefore phy_disconnect is never
called. phy_stop does not guarantee that the scheduled work is stopped
because it is called under rtnl_lock. This can cause an oops due to
use-after-free if the delayed work fires after freeing the PHY device.

Ensure that the state_queue work is cancelled in both phy_device_remove
and phy_remove paths.

Signed-off-by: Robert Hancock <hancock@sedsystems.ca>
---
 drivers/net/phy/phy_device.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 2c879ba..1c90b33 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -877,6 +877,8 @@ int phy_device_register(struct phy_device *phydev)
  */
 void phy_device_remove(struct phy_device *phydev)
 {
+	cancel_delayed_work_sync(&phydev->state_queue);
+
 	device_del(&phydev->mdio.dev);
 
 	/* Assert the reset signal */
-- 
1.8.3.1

