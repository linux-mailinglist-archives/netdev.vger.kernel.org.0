Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 584471CC29C
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 18:29:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728237AbgEIQ3Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 12:29:16 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50918 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726214AbgEIQ3P (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 May 2020 12:29:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=y8WrBDCDpC/HTli4Cc2EZDrTMMb2e3/CK/gr9C1ti7E=; b=wano6lKaCoiNrKbudsjOOk0pBP
        pM+LSTfVX3xKSQ67D5wmL+0YztxDCbEWWsVUlThy8VUtMOA7dp4UMGY5XDkhJQAo4L7GlRaUM9RDH
        r8FEzdiXC1D0Q2nKtWI5w5+4Bak+atpEhTEZq1LWJbiAIo2kmafmhkh3MbUtEaNAajF8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jXSLc-001WHk-88; Sat, 09 May 2020 18:29:08 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Chris Healy <cphealy@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>, michael@walle.cc,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next v3 09/10] net: phy: Put interface into oper testing during cable test
Date:   Sat,  9 May 2020 18:28:50 +0200
Message-Id: <20200509162851.362346-10-andrew@lunn.ch>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200509162851.362346-1-andrew@lunn.ch>
References: <20200509162851.362346-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since running a cable test is disruptive, put the interface into
operative state testing while the test is running.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Michal Kubecek <mkubecek@suse.cz>
---
 drivers/net/phy/phy.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index afdc1c2146ee..9bdc924eea83 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -492,6 +492,7 @@ static void phy_abort_cable_test(struct phy_device *phydev)
 int phy_start_cable_test(struct phy_device *phydev,
 			 struct netlink_ext_ack *extack)
 {
+	struct net_device *dev = phydev->attached_dev;
 	int err = -ENOMEM;
 
 	if (!(phydev->drv &&
@@ -525,8 +526,10 @@ int phy_start_cable_test(struct phy_device *phydev,
 	/* Mark the carrier down until the test is complete */
 	phy_link_down(phydev, true);
 
+	netif_testing_on(dev);
 	err = phydev->drv->cable_test_start(phydev);
 	if (err) {
+		netif_testing_off(dev);
 		phy_link_up(phydev);
 		goto out_free;
 	}
@@ -879,6 +882,8 @@ EXPORT_SYMBOL(phy_free_interrupt);
  */
 void phy_stop(struct phy_device *phydev)
 {
+	struct net_device *dev = phydev->attached_dev;
+
 	if (!phy_is_started(phydev)) {
 		WARN(1, "called from state %s\n",
 		     phy_state_to_str(phydev->state));
@@ -887,8 +892,10 @@ void phy_stop(struct phy_device *phydev)
 
 	mutex_lock(&phydev->lock);
 
-	if (phydev->state == PHY_CABLETEST)
+	if (phydev->state == PHY_CABLETEST) {
 		phy_abort_cable_test(phydev);
+		netif_testing_off(dev);
+	}
 
 	if (phydev->sfp_bus)
 		sfp_upstream_stop(phydev->sfp_bus);
@@ -950,6 +957,7 @@ void phy_state_machine(struct work_struct *work)
 	struct delayed_work *dwork = to_delayed_work(work);
 	struct phy_device *phydev =
 			container_of(dwork, struct phy_device, state_queue);
+	struct net_device *dev = phydev->attached_dev;
 	bool needs_aneg = false, do_suspend = false;
 	enum phy_state old_state;
 	bool finished = false;
@@ -975,6 +983,7 @@ void phy_state_machine(struct work_struct *work)
 		err = phydev->drv->cable_test_get_status(phydev, &finished);
 		if (err) {
 			phy_abort_cable_test(phydev);
+			netif_testing_off(dev);
 			needs_aneg = true;
 			phydev->state = PHY_UP;
 			break;
@@ -982,6 +991,7 @@ void phy_state_machine(struct work_struct *work)
 
 		if (finished) {
 			ethnl_cable_test_finished(phydev);
+			netif_testing_off(dev);
 			needs_aneg = true;
 			phydev->state = PHY_UP;
 		}
-- 
2.26.2

