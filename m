Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CF93694D80
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 17:55:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230353AbjBMQzV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 11:55:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229977AbjBMQzS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 11:55:18 -0500
Received: from relay1-d.mail.gandi.net (relay1-d.mail.gandi.net [217.70.183.193])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEE2D1E5CA;
        Mon, 13 Feb 2023 08:54:36 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id B632D24000C;
        Mon, 13 Feb 2023 16:54:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1676307267;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1Rr687/4/EsEsD4W31jyRusTeG5lpNTR5Q6FhRygF1w=;
        b=Yj1CptIP2Pb9000uc5hcUnnkozFLeOkOVkJE/jQ2QTONphRypsGGTygsLxL6FAR3MylQQ7
        5b4YLS1beX+MiFd7VT/xq4pd53kZjHxYXHO8crZZ2rqDgeyeP6a3o31CrxdGWfyIqX4BIa
        M29ZMyxm86TbBo3HHj2hAwHiWSiEmU+4hc3UG+RiBdQaY9epz3P7eEqvkTBT4lzbAwp01C
        hwDTuB4m1AvbLQ5e22t5cMRud3iLYRe2Sn2xmAosohn7XsFVP4Jm0+eF6Xww1P03IrVssx
        IjS3hUl7cxXDaNrqkEnDrT+KfpBUb8xrSw03ZXM/jbWUfMoy6psM4xsrmC1/vA==
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
Subject: [PATCH wpan 6/6] ieee802154: Drop device trackers
Date:   Mon, 13 Feb 2023 17:54:14 +0100
Message-Id: <20230213165414.1168401-7-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230213165414.1168401-1-miquel.raynal@bootlin.com>
References: <20230213165414.1168401-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
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

Fixes: 45755ce4bf46 ("ieee802154: Add support for user scanning requests")
Fixes: 7ed3b259eca1 ("ieee802154: Add support for user beaconing requests")
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

