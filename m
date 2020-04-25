Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FDDB1B8860
	for <lists+netdev@lfdr.de>; Sat, 25 Apr 2020 20:06:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726197AbgDYSGm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Apr 2020 14:06:42 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:34904 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726145AbgDYSGl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Apr 2020 14:06:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=YyrOjnV6WZRPOgAYp5wSBBYL9vKY7pqbeR23ImErlN8=; b=Yy4JyHmmQD0zykA8iXnkC8fdNf
        bd8bwjf3/VCnILAQ1YZj+gTCAHNnGMQAnsfRw/MDiP6CrASOoabLNt/Oq6aNY9a8fCRN4JTHWyWHl
        cGQ6ZhKGambffyvA3q6kyRoYB7v8XHRrA60hkHATSmTumcyTskUW1CH3lY05yPFs22Yw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jSPCG-004mi6-EI; Sat, 25 Apr 2020 20:06:36 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Chris Healy <cphealy@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next v1 9/9] net: phy: Put interface into oper testing during cable test
Date:   Sat, 25 Apr 2020 20:06:21 +0200
Message-Id: <20200425180621.1140452-10-andrew@lunn.ch>
X-Mailer: git-send-email 2.26.0.rc2
In-Reply-To: <20200425180621.1140452-1-andrew@lunn.ch>
References: <20200425180621.1140452-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
index 88275d971f14..ddd8550dc08d 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -485,6 +485,7 @@ static void phy_cable_test_abort(struct phy_device *phydev)
 int phy_start_cable_test(struct phy_device *phydev,
 			 struct netlink_ext_ack *extack)
 {
+	struct net_device *dev = phydev->attached_dev;
 	int err = -ENOMEM;
 
 	if (!(phydev->drv &&
@@ -511,8 +512,10 @@ int phy_start_cable_test(struct phy_device *phydev,
 	/* Mark the carrier down until the test is complete */
 	phy_link_down(phydev, true);
 
+	netif_testing_on(dev);
 	err = phydev->drv->cable_test_start(phydev);
 	if (err) {
+		netif_testing_off(dev);
 		phy_link_up(phydev);
 		goto out_free;
 	}
@@ -865,6 +868,8 @@ EXPORT_SYMBOL(phy_free_interrupt);
  */
 void phy_stop(struct phy_device *phydev)
 {
+	struct net_device *dev = phydev->attached_dev;
+
 	if (!phy_is_started(phydev)) {
 		WARN(1, "called from state %s\n",
 		     phy_state_to_str(phydev->state));
@@ -873,8 +878,10 @@ void phy_stop(struct phy_device *phydev)
 
 	mutex_lock(&phydev->lock);
 
-	if (phydev->state == PHY_CABLETEST)
+	if (phydev->state == PHY_CABLETEST) {
 		phy_cable_test_abort(phydev);
+		 netif_testing_off(dev);
+	}
 
 	if (phydev->sfp_bus)
 		sfp_upstream_stop(phydev->sfp_bus);
@@ -936,6 +943,7 @@ void phy_state_machine(struct work_struct *work)
 	struct delayed_work *dwork = to_delayed_work(work);
 	struct phy_device *phydev =
 			container_of(dwork, struct phy_device, state_queue);
+	struct net_device *dev = phydev->attached_dev;
 	bool needs_aneg = false, do_suspend = false;
 	enum phy_state old_state;
 	bool finished = false;
@@ -961,6 +969,7 @@ void phy_state_machine(struct work_struct *work)
 		err = phydev->drv->cable_test_get_status(phydev, &finished);
 		if (err) {
 			phy_cable_test_abort(phydev);
+			netif_testing_off(dev);
 			needs_aneg = true;
 			phydev->state = PHY_UP;
 			break;
@@ -968,6 +977,7 @@ void phy_state_machine(struct work_struct *work)
 
 		if (finished) {
 			ethnl_cable_test_finished(phydev);
+			netif_testing_off(dev);
 			needs_aneg = true;
 			phydev->state = PHY_UP;
 		}
-- 
2.26.1

