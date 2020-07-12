Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7C2921CAC2
	for <lists+netdev@lfdr.de>; Sun, 12 Jul 2020 19:36:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729373AbgGLRfz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jul 2020 13:35:55 -0400
Received: from smtp11.smtpout.orange.fr ([80.12.242.133]:50523 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729363AbgGLRfy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jul 2020 13:35:54 -0400
Received: from localhost.localdomain ([93.22.148.52])
        by mwinf5d89 with ME
        id 2Hbs23007183tQl03Hbsju; Sun, 12 Jul 2020 19:35:53 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sun, 12 Jul 2020 19:35:53 +0200
X-ME-IP: 93.22.148.52
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     johannes@sipsolutions.net, davem@davemloft.net, kuba@kernel.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH 2/2] nl80211: Simplify error handling path in 'nl80211_trigger_scan()'
Date:   Sun, 12 Jul 2020 19:35:51 +0200
Message-Id: <20200712173551.274448-1-christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Re-write the end of 'nl80211_trigger_scan()' with a more standard, easy to
understand and future proof version.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 net/wireless/nl80211.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index a671ee5f5da7..898e5f53f263 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -7993,15 +7993,18 @@ static int nl80211_trigger_scan(struct sk_buff *skb, struct genl_info *info)
 	rdev->scan_req = request;
 	err = rdev_scan(rdev, request);
 
-	if (!err) {
-		nl80211_send_scan_start(rdev, wdev);
-		if (wdev->netdev)
-			dev_hold(wdev->netdev);
-	} else {
+	if (err)
+		goto out_free;
+
+	nl80211_send_scan_start(rdev, wdev);
+	if (wdev->netdev)
+		dev_hold(wdev->netdev);
+
+	return 0;
+
  out_free:
-		rdev->scan_req = NULL;
-		kfree(request);
-	}
+	rdev->scan_req = NULL;
+	kfree(request);
 
 	return err;
 }
-- 
2.25.1

