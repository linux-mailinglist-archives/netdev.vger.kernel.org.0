Return-Path: <netdev+bounces-4358-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 03A6F70C2D5
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 17:58:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CB1BB1C20B3E
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 15:58:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17E7C154AA;
	Mon, 22 May 2023 15:58:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07C5F14AB3
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 15:58:14 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42798B3
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 08:58:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
	Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
	:Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
	Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=ACbFlJxVJN2RlR0ive3SrvviXhTP8XJYvV0ieJtYqkc=; b=xXsPZ0zVSRF3V+koRCvInxxwRg
	A6lsSchldT8J6coq0SJfvUR96jI1pMPrPex6z52y+dzrnhbuRadoXnjHcaAOs8B+KrMQA+hwN5Fg6
	CHZbVColy/mfu0Abf9mv98Slpq7UZ6BGSOkfZoIqSKepQy9WTHTLEYlRF+8EcEF2LnXdwIK31KJUF
	hl3V2iE/5nj1t4/ksHEfylTf24s+f5ydJpQ6nmERir96S05DnPMlaRIKxOds7nD9OFjkxERlD3MNn
	YLOOOv6l0ULGR1ulBrY4ziCdGLBlFeb9V8MaQqs7nlism4aRA4Nt28pgHY+DGn4JcJU0ewIp3h1gk
	iaoySnVA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:33634 helo=rmk-PC.armlinux.org.uk)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <rmk@armlinux.org.uk>)
	id 1q17vE-00076T-VJ; Mon, 22 May 2023 16:58:08 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <rmk@rmk-PC.armlinux.org.uk>)
	id 1q17vE-007Baz-8c; Mon, 22 May 2023 16:58:08 +0100
From: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To: Andrew Lunn <andrew@lunn.ch>,
	Heiner Kallweit <hkallweit1@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org
Subject: [PATCH net-next] net: phy: avoid kernel warning dump when stopping an
 errored PHY
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1q17vE-007Baz-8c@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date: Mon, 22 May 2023 16:58:08 +0100
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

When taking a network interface down (or removing a SFP module) after
the PHY has encountered an error, phy_stop() complains incorrectly
that it was called from HALTED state.

The reason this is incorrect is that the network driver will have
called phy_start() when the interface was brought up, and the fact
that the PHY has a problem bears no relationship to the administrative
state of the interface. Taking the interface administratively down
(which calls phy_stop()) is always the right thing to do after a
successful phy_start() call, whether or not the PHY has encountered
an error.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phy.c | 11 +++++++----
 include/linux/phy.h   |  7 +++++--
 2 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index 0c0df38cd1ab..bdf00b2b2c1d 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -52,6 +52,7 @@ static const char *phy_state_to_str(enum phy_state st)
 	PHY_STATE_STR(NOLINK)
 	PHY_STATE_STR(CABLETEST)
 	PHY_STATE_STR(HALTED)
+	PHY_STATE_STR(ERROR)
 	}
 
 	return NULL;
@@ -1184,7 +1185,7 @@ void phy_stop_machine(struct phy_device *phydev)
 static void phy_process_error(struct phy_device *phydev)
 {
 	mutex_lock(&phydev->lock);
-	phydev->state = PHY_HALTED;
+	phydev->state = PHY_ERROR;
 	mutex_unlock(&phydev->lock);
 
 	phy_trigger_machine(phydev);
@@ -1198,10 +1199,10 @@ static void phy_error_precise(struct phy_device *phydev,
 }
 
 /**
- * phy_error - enter HALTED state for this PHY device
+ * phy_error - enter ERROR state for this PHY device
  * @phydev: target phy_device struct
  *
- * Moves the PHY to the HALTED state in response to a read
+ * Moves the PHY to the ERROR state in response to a read
  * or write error, and tells the controller the link is down.
  * Must not be called from interrupt context, or while the
  * phydev->lock is held.
@@ -1326,7 +1327,8 @@ void phy_stop(struct phy_device *phydev)
 	struct net_device *dev = phydev->attached_dev;
 	enum phy_state old_state;
 
-	if (!phy_is_started(phydev) && phydev->state != PHY_DOWN) {
+	if (!phy_is_started(phydev) && phydev->state != PHY_DOWN &&
+	    phydev->state != PHY_ERROR) {
 		WARN(1, "called from state %s\n",
 		     phy_state_to_str(phydev->state));
 		return;
@@ -1443,6 +1445,7 @@ void phy_state_machine(struct work_struct *work)
 		}
 		break;
 	case PHY_HALTED:
+	case PHY_ERROR:
 		if (phydev->link) {
 			phydev->link = 0;
 			phy_link_down(phydev);
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 2da87a36200d..7addde5d14c0 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -497,14 +497,17 @@ struct phy_device *mdiobus_scan_c22(struct mii_bus *bus, int addr);
  * Once complete, move to UP to restart the PHY.
  * - phy_stop aborts the running test and moves to @PHY_HALTED
  *
- * @PHY_HALTED: PHY is up, but no polling or interrupts are done. Or
- * PHY is in an error state.
+ * @PHY_HALTED: PHY is up, but no polling or interrupts are done.
  * - phy_start moves to @PHY_UP
+ *
+ * @PHY_ERROR: PHY is up, but is in an error state.
+ * - phy_stop moves to @PHY_HALTED
  */
 enum phy_state {
 	PHY_DOWN = 0,
 	PHY_READY,
 	PHY_HALTED,
+	PHY_ERROR,
 	PHY_UP,
 	PHY_RUNNING,
 	PHY_NOLINK,
-- 
2.30.2


