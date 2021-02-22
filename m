Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F9CB321B18
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 16:18:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231276AbhBVPPl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 10:15:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230205AbhBVPOv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Feb 2021 10:14:51 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2672BC061222
        for <netdev@vger.kernel.org>; Mon, 22 Feb 2021 07:12:58 -0800 (PST)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lECtF-0007dv-15; Mon, 22 Feb 2021 16:12:49 +0100
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lECtE-00075k-HH; Mon, 22 Feb 2021 16:12:48 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     mkl@pengutronix.de, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Robin van der Gracht <robin@protonic.nl>,
        Johannes Berg <johannes@sipsolutions.net>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        linux-wireless@vger.kernel.org
Subject: [PATCH net v1 3/3] [RFC] mac80211: ieee80211_store_ack_skb(): make use of skb_clone_sk_optional()
Date:   Mon, 22 Feb 2021 16:12:47 +0100
Message-Id: <20210222151247.24534-4-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210222151247.24534-1-o.rempel@pengutronix.de>
References: <20210222151247.24534-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This code is trying to clone the skb with optional skb->sk. But this
will fail to clone the skb if socket was closed just after the skb was
pushed into the networking stack.

Fixes: a7528198add8 ("mac80211: support control port TX status reporting")
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 net/mac80211/tx.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 5d06de61047a..c0dd326db10d 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2439,11 +2439,7 @@ static u16 ieee80211_store_ack_skb(struct ieee80211_local *local,
 	struct sk_buff *ack_skb;
 	u16 info_id = 0;
 
-	if (skb->sk)
-		ack_skb = skb_clone_sk(skb);
-	else
-		ack_skb = skb_clone(skb, GFP_ATOMIC);
-
+	ack_skb = skb_clone_sk_optional(skb);
 	if (ack_skb) {
 		unsigned long flags;
 		int id;
-- 
2.29.2

