Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F02BC161DF8
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 00:43:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726070AbgBQXnn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 18:43:43 -0500
Received: from mout-p-201.mailbox.org ([80.241.56.171]:15784 "EHLO
        mout-p-201.mailbox.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726002AbgBQXnn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 18:43:43 -0500
X-Greylist: delayed 469 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 Feb 2020 18:43:42 EST
Received: from smtp2.mailbox.org (smtp2.mailbox.org [80.241.60.241])
        (using TLSv1.2 with cipher ECDHE-RSA-CHACHA20-POLY1305 (256/256 bits))
        (No client certificate requested)
        by mout-p-201.mailbox.org (Postfix) with ESMTPS id 48M0jN0pm5zQj5W;
        Tue, 18 Feb 2020 00:35:52 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp2.mailbox.org ([80.241.60.241])
        by spamfilter03.heinlein-hosting.de (spamfilter03.heinlein-hosting.de [80.241.56.117]) (amavisd-new, port 10030)
        with ESMTP id EebsR1Q1XS90; Tue, 18 Feb 2020 00:35:49 +0100 (CET)
From:   Hauke Mehrtens <hauke@hauke-m.de>
To:     davem@davemloft.net, linux@rempel-privat.de
Cc:     netdev@vger.kernel.org, jcliburn@gmail.com, chris.snook@gmail.com,
        Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 3/3] ag71xx: Run ag71xx_link_adjust() only when needed
Date:   Tue, 18 Feb 2020 00:35:18 +0100
Message-Id: <20200217233518.3159-3-hauke@hauke-m.de>
In-Reply-To: <20200217233518.3159-1-hauke@hauke-m.de>
References: <20200217233518.3159-1-hauke@hauke-m.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

My system printed this line every second:
  ag71xx 19000000.eth eth0: Link is Up - 1Gbps/Full - flow control off
The function ag71xx_phy_link_adjust() was called by the PHY layer every
second even when nothing changed.

With this patch the old status is stored and the real the
ag71xx_link_adjust() function is only called when something really
changed. This way the update and also this print is only done once any
more.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
Fixes: d51b6ce441d3 ("net: ethernet: add ag71xx driver")
---
 drivers/net/ethernet/atheros/ag71xx.c | 24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/atheros/ag71xx.c b/drivers/net/ethernet/atheros/ag71xx.c
index 7d3fec009030..12eaf6d2518d 100644
--- a/drivers/net/ethernet/atheros/ag71xx.c
+++ b/drivers/net/ethernet/atheros/ag71xx.c
@@ -307,6 +307,10 @@ struct ag71xx {
 	u32 msg_enable;
 	const struct ag71xx_dcfg *dcfg;
 
+	unsigned int		link;
+	unsigned int		speed;
+	int			duplex;
+
 	/* From this point onwards we're not looking at per-packet fields. */
 	void __iomem *mac_base;
 
@@ -854,6 +858,7 @@ static void ag71xx_link_adjust(struct ag71xx *ag, bool update)
 
 	if (!phydev->link && update) {
 		ag71xx_hw_stop(ag);
+		phy_print_status(phydev);
 		return;
 	}
 
@@ -907,8 +912,25 @@ static void ag71xx_link_adjust(struct ag71xx *ag, bool update)
 static void ag71xx_phy_link_adjust(struct net_device *ndev)
 {
 	struct ag71xx *ag = netdev_priv(ndev);
+	struct phy_device *phydev = ndev->phydev;
+	int status_change = 0;
+
+	if (phydev->link) {
+		if (ag->duplex != phydev->duplex ||
+		    ag->speed != phydev->speed) {
+			status_change = 1;
+		}
+	}
+
+	if (phydev->link != ag->link)
+		status_change = 1;
+
+	ag->link = phydev->link;
+	ag->duplex = phydev->duplex;
+	ag->speed = phydev->speed;
 
-	ag71xx_link_adjust(ag, true);
+	if (status_change)
+		ag71xx_link_adjust(ag, true);
 }
 
 static int ag71xx_phy_connect(struct ag71xx *ag)
-- 
2.20.1

