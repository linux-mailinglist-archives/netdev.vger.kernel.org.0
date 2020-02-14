Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 610D315D88E
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 14:34:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729259AbgBNNeV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 08:34:21 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:42097 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729247AbgBNNeU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Feb 2020 08:34:20 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 01a2a69f;
        Fri, 14 Feb 2020 13:32:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:in-reply-to:references:mime-version
        :content-transfer-encoding; s=mail; bh=sONytuj6JKe3PxDCbaRsVGTWW
        Eg=; b=AEV0/i0c/mdTqB1eLbYvGraDOpfRTMhyW/AEr3XI7KBHk2EA/TO3GyoNv
        fpacA39L9AkOINhwWVbdya5RocgYFHdkYIv9yQHPRhu4k184jkFwfZSLWbtgTxxb
        0atlM7ViD1Fx2ql+W/sqm6WAn8UcwruAMbHAs9qQQmKluSyvCIX+F4R03L6HZRtA
        SkkWviNC/vq2CjT2FDYDN4KSzTVOF+97a6zRhlu/I1tOSvLiCWq+7uD1dPHibd3B
        EHoHQyY6ZTgAZMai3NYNqUmUYV4SXdGTlJvpsOYJ/oRb5XY9/TGipA4R6/7yi86y
        fpkcqqCTlpQAN9mGX3IVt/B5s0kjA==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id bf96d84b (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Fri, 14 Feb 2020 13:32:11 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Matt Dunwoodie <ncon@noconroy.net>
Subject: [PATCH net 2/3] wireguard: receive: reset last_under_load to zero
Date:   Fri, 14 Feb 2020 14:34:03 +0100
Message-Id: <20200214133404.30643-3-Jason@zx2c4.com>
In-Reply-To: <20200214133404.30643-1-Jason@zx2c4.com>
References: <20200214133404.30643-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a small optimization that prevents more expensive comparisons
from happening when they are no longer necessary, by clearing the
last_under_load variable whenever we wind up in a state where we were
under load but we no longer are.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Suggested-by: Matt Dunwoodie <ncon@noconroy.net>
---
 drivers/net/wireguard/receive.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireguard/receive.c b/drivers/net/wireguard/receive.c
index 9c6bab9c981f..4a153894cee2 100644
--- a/drivers/net/wireguard/receive.c
+++ b/drivers/net/wireguard/receive.c
@@ -118,10 +118,13 @@ static void wg_receive_handshake_packet(struct wg_device *wg,
 
 	under_load = skb_queue_len(&wg->incoming_handshakes) >=
 		     MAX_QUEUED_INCOMING_HANDSHAKES / 8;
-	if (under_load)
+	if (under_load) {
 		last_under_load = ktime_get_coarse_boottime_ns();
-	else if (last_under_load)
+	} else if (last_under_load) {
 		under_load = !wg_birthdate_has_expired(last_under_load, 1);
+		if (!under_load)
+			last_under_load = 0;
+	}
 	mac_state = wg_cookie_validate_packet(&wg->cookie_checker, skb,
 					      under_load);
 	if ((under_load && mac_state == VALID_MAC_WITH_COOKIE) ||
-- 
2.25.0

