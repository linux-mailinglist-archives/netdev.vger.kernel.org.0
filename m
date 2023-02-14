Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20C54696570
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 14:53:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232909AbjBNNx2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 08:53:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232835AbjBNNxZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 08:53:25 -0500
Received: from relay2-d.mail.gandi.net (relay2-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::222])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 908DDBBB7;
        Tue, 14 Feb 2023 05:52:45 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id A48734000C;
        Tue, 14 Feb 2023 13:50:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1676382650;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CcuShHB1zdhnbtr+ZTsj61SfctwJHwgVzJ4W6JrCCSk=;
        b=i6RBl051xkrZAZI0X13N/6Rj4+bInR3ODFV+Q5RtEEje0K2PvKjyDE7wSec8MZcZYd44Tf
        HmgYx3NUmbNI9HI9hkkJkN7t1PYi5XFrmLxzKNjuvpMKg4CPUuUJYc5+SAbiU1w8SwY4WI
        x3tBCaQ9TGewou3aNOd8mY7fVd1Yz0sd6MMiWJ1Wq62e6d0v3g8kUb6xJRKSYpxjbShJC1
        uCGR2XiDaTdoP4SHPuFl821KGYBI/bsZJ1TOlt6Dr6UC8b1jw7729MwdxMsN6+E3koezOl
        P10McB8UY1jyRI4MnZ2ApeWeVu+zhVwznHhOkbElyfqD/Cg5qbBxXDUhCyODUA==
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Guilhem Imberton <guilhem.imberton@qorvo.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH wpan v2 6/6] ieee802154: Drop device trackers
Date:   Tue, 14 Feb 2023 14:50:35 +0100
Message-Id: <20230214135035.1202471-7-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230214135035.1202471-1-miquel.raynal@bootlin.com>
References: <20230214135035.1202471-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to prevent a device from disappearing when a background job was
started, dev_hold() and dev_put() calls were made. During the
stabilization phase of the scan/beacon features, it was later decided
that removing the device while a background job was ongoing was a valid use
case, and we should instead stop the background job and then remove the
device, rather than prevent the device from being removed. This is what
is currently done, which means manually reference counting the device
during background jobs is no longer needed.

Fixes: ed3557c947e1 ("ieee802154: Add support for user scanning requests")
Fixes: 9bc114504b07 ("ieee802154: Add support for user beaconing requests")
Reported-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 net/ieee802154/nl802154.c | 24 ++++--------------------
 1 file changed, 4 insertions(+), 20 deletions(-)

diff --git a/net/ieee802154/nl802154.c b/net/ieee802154/nl802154.c
index 8ee7d2ef55ee..88380606af2c 100644
--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -1453,20 +1453,14 @@ static int nl802154_trigger_scan(struct sk_buff *skb, struct genl_info *info)
 	else
 		request->duration = IEEE802154_MAX_SCAN_DURATION;
 
-	if (wpan_dev->netdev)
-		dev_hold(wpan_dev->netdev);
-
 	err = rdev_trigger_scan(rdev, request);
 	if (err) {
 		pr_err("Failure starting scanning (%d)\n", err);
-		goto free_device;
+		goto free_request;
 	}
 
 	return 0;
 
-free_device:
-	if (wpan_dev->netdev)
-		dev_put(wpan_dev->netdev);
 free_request:
 	kfree(request);
 
@@ -1555,9 +1549,6 @@ int nl802154_scan_done(struct wpan_phy *wpan_phy, struct wpan_dev *wpan_dev,
 	if (err == -ESRCH)
 		err = 0;
 
-	if (wpan_dev->netdev)
-		dev_put(wpan_dev->netdev);
-
 	return err;
 }
 EXPORT_SYMBOL_GPL(nl802154_scan_done);
@@ -1605,21 +1596,15 @@ nl802154_send_beacons(struct sk_buff *skb, struct genl_info *info)
 	else
 		request->interval = IEEE802154_MAX_SCAN_DURATION;
 
-	if (wpan_dev->netdev)
-		dev_hold(wpan_dev->netdev);
-
 	err = rdev_send_beacons(rdev, request);
 	if (err) {
 		pr_err("Failure starting sending beacons (%d)\n", err);
-		goto free_device;
+		goto free_request;
 	}
 
 	return 0;
 
-free_device:
-	if (wpan_dev->netdev)
-		dev_put(wpan_dev->netdev);
-
+free_request:
 	kfree(request);
 
 	return err;
@@ -1627,8 +1612,7 @@ nl802154_send_beacons(struct sk_buff *skb, struct genl_info *info)
 
 void nl802154_beaconing_done(struct wpan_dev *wpan_dev)
 {
-	if (wpan_dev->netdev)
-		dev_put(wpan_dev->netdev);
+	/* NOP */
 }
 EXPORT_SYMBOL_GPL(nl802154_beaconing_done);
 
-- 
2.34.1

