Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3AD6A42BD0
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 18:07:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502075AbfFLQHt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 12:07:49 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:49410 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406284AbfFLQHs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Jun 2019 12:07:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=mdWzdwZ08gpe8St1HT7UtUqsdux2j7W4IZnYAMlCApM=; b=1mr3084EfJvpo3ajxixGmZfYhT
        yn45NdRIO+GOawB151DaK8PEkQkDKU2MO/mikHhTwnS56FCN6vFkztJZ3kBe/xJUeaGADGNBar8TH
        pt3nOLSuSuHbLUR9mszb0NGdoJMfzcFRbAcUi3wVKfSka5vngGlgpl2gpYHAEVpfnlyg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hb5lD-00069u-Fw; Wed, 12 Jun 2019 18:06:03 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     netdev <netdev@vger.kernel.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Raju.Lakkaraju@microchip.com, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH RFC 13/13] net: phy: Put interface into oper testing during cable test
Date:   Wed, 12 Jun 2019 18:05:34 +0200
Message-Id: <20190612160534.23533-14-andrew@lunn.ch>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190612160534.23533-1-andrew@lunn.ch>
References: <20190612160534.23533-1-andrew@lunn.ch>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since running a cable test is disruptive, put the interface into
operative state testing while the test is running.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/phy/phy.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index 9a210927aec0..f3fa73974af3 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -585,6 +585,7 @@ int phy_start_cable_test(struct phy_device *phydev,
 			 struct netlink_ext_ack *extack, u32 seq,
 			 int options)
 {
+	struct net_device *dev = phydev->attached_dev;
 	int err = -ENOMEM;
 	int ret;
 
@@ -627,8 +628,10 @@ int phy_start_cable_test(struct phy_device *phydev,
 	/* Mark the carrier down until the test is complete */
 	phy_link_down(phydev, true);
 
+	netif_testing_on(dev);
 	err = phydev->drv->cable_test_start(phydev, options);
 	if (err) {
+		netif_testing_off(dev);
 		phy_link_up(phydev);
 		goto out_free;
 	}
@@ -988,6 +991,8 @@ EXPORT_SYMBOL(phy_request_interrupt);
  */
 void phy_stop(struct phy_device *phydev)
 {
+	struct net_device *dev = phydev->attached_dev;
+
 	if (!phy_is_started(phydev)) {
 		WARN(1, "called from state %s\n",
 		     phy_state_to_str(phydev->state));
@@ -996,8 +1001,10 @@ void phy_stop(struct phy_device *phydev)
 
 	mutex_lock(&phydev->lock);
 
-	if (phydev->state == PHY_CABLETEST)
+	if (phydev->state == PHY_CABLETEST) {
 		phy_cable_test_abort(phydev);
+		netif_testing_off(dev);
+	};
 
 	if (phy_interrupt_is_valid(phydev))
 		phy_disable_interrupts(phydev);
@@ -1068,6 +1075,7 @@ void phy_state_machine(struct work_struct *work)
 	struct delayed_work *dwork = to_delayed_work(work);
 	struct phy_device *phydev =
 			container_of(dwork, struct phy_device, state_queue);
+	struct net_device *dev = phydev->attached_dev;
 	bool needs_aneg = false, do_suspend = false;
 	enum phy_state old_state;
 	bool finished = false;
@@ -1108,6 +1116,7 @@ void phy_state_machine(struct work_struct *work)
 		err = phydev->drv->cable_test_get_status(phydev, &finished);
 		if (err) {
 			phy_cable_test_abort(phydev);
+			netif_testing_off(dev);
 			needs_aneg = true;
 			phydev->state = PHY_UP;
 			break;
@@ -1115,6 +1124,7 @@ void phy_state_machine(struct work_struct *work)
 
 		if (finished) {
 			phy_cable_test_finished(phydev);
+			netif_testing_off(dev);
 			needs_aneg = true;
 			phydev->state = PHY_UP;
 		}
-- 
2.20.1

