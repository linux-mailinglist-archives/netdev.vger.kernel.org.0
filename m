Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 140A73DFC8C
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 10:14:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236204AbhHDIOQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 04:14:16 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:54750 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236243AbhHDIOO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Aug 2021 04:14:14 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id C0411221B5;
        Wed,  4 Aug 2021 08:14:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1628064840; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=8keho363Sl2gUx4aN/xeXttCB1j0pnXy2aa4KQk3nRM=;
        b=wPyEEXFXSSLesVtRLQGtfXXzmJN2Z3mDLpd8xT2x6uaUOoUTzyck+ifeUjhyanzcbcHIOy
        glsUMfwk9uOCmkNSw99WPGeYN6usUt0L+JuiQw09g6nTUiXYZcNqtcEfzsSt2OBe7yGnre
        TEKxS/qfMLhOJlrLKFGWZDb/NH90y3Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1628064840;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=8keho363Sl2gUx4aN/xeXttCB1j0pnXy2aa4KQk3nRM=;
        b=JUgqddh4j6SPOHYkwbkbzhRr4EaqgolGBClh9M0980M5lk8xPI/nX1VgeTFp/zfNUHwd/1
        w5L0R8WB1eXUpoBw==
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id A2AAA13790;
        Wed,  4 Aug 2021 08:14:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id ZdW2JkhMCmGgVQAAGKfGzw
        (envelope-from <iivanov@suse.de>); Wed, 04 Aug 2021 08:14:00 +0000
From:   "Ivan T. Ivanov" <iivanov@suse.de>
To:     Woojung Huh <woojung.huh@microchip.com>
Cc:     UNGLinuxDriver@microchip.com,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Ivan T. Ivanov" <iivanov@suse.de>
Subject: [PATCH] net: usb: lan78xx: don't modify phy_device state concurrently
Date:   Wed,  4 Aug 2021 11:13:39 +0300
Message-Id: <20210804081339.19909-1-iivanov@suse.de>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently phy_device state could be left in inconsistent state shown
by following alert message[1]. This is because phy_read_status could
be called concurrently from lan78xx_delayedwork, phy_state_machine and
__ethtool_get_link. Fix this by making sure that phy_device state is
updated atomically.

[1] lan78xx 1-1.1.1:1.0 eth0: No phy led trigger registered for speed(-1)

Signed-off-by: Ivan T. Ivanov <iivanov@suse.de>
---
 drivers/net/usb/lan78xx.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index b27229d34425..0c964d0bd2d6 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -1154,7 +1154,7 @@ static int lan78xx_link_reset(struct lan78xx_net *dev)
 {
 	struct phy_device *phydev = dev->net->phydev;
 	struct ethtool_link_ksettings ecmd;
-	int ladv, radv, ret;
+	int ladv, radv, ret, link;
 	u32 buf;
 
 	/* clear LAN78xx interrupt status */
@@ -1162,9 +1162,12 @@ static int lan78xx_link_reset(struct lan78xx_net *dev)
 	if (unlikely(ret < 0))
 		return -EIO;
 
+	mutex_lock(&phydev->lock);
 	phy_read_status(phydev);
+	link = phydev->link;
+	mutex_unlock(&phydev->lock);
 
-	if (!phydev->link && dev->link_on) {
+	if (!link && dev->link_on) {
 		dev->link_on = false;
 
 		/* reset MAC */
@@ -1177,7 +1180,7 @@ static int lan78xx_link_reset(struct lan78xx_net *dev)
 			return -EIO;
 
 		del_timer(&dev->stat_monitor);
-	} else if (phydev->link && !dev->link_on) {
+	} else if (link && !dev->link_on) {
 		dev->link_on = true;
 
 		phy_ethtool_ksettings_get(phydev, &ecmd);
@@ -1464,9 +1467,14 @@ static int lan78xx_set_eee(struct net_device *net, struct ethtool_eee *edata)
 
 static u32 lan78xx_get_link(struct net_device *net)
 {
+	u32 link;
+
+	mutex_lock(&net->phydev->lock);
 	phy_read_status(net->phydev);
+	link = net->phydev->link;
+	mutex_unlock(&net->phydev->lock);
 
-	return net->phydev->link;
+	return link;
 }
 
 static void lan78xx_get_drvinfo(struct net_device *net,
-- 
2.32.0

