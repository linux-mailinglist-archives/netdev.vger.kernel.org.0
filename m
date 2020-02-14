Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 381AA15FA07
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 23:57:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728088AbgBNW5h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 17:57:37 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:36023 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728076AbgBNW5g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Feb 2020 17:57:36 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 8c605827;
        Fri, 14 Feb 2020 22:55:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:in-reply-to:references:mime-version
        :content-transfer-encoding; s=mail; bh=sONytuj6JKe3PxDCbaRsVGTWW
        Eg=; b=lsO7SAOfLt2UkY4oIEmfep7dcPxw4z0xRJgZkY1OCryitVZocYtxN4Ap7
        g4vhne3zd8z0ThgNmc0CHP0iONhlswvOVUWiKXGacYkOqYy0TMrNRK/1jJ3yerKB
        /GhmufV1Vh/+cck0BHbtVICCaCcXby3Zf0x0O35ILrgqKmTnNFn3gofqr6Sc6+Ct
        ME9Ia4FOVDLrQFlYR2t2bqGP81I3skdjkRTx9OlRRaoiQ/7LzLrfSQR+utYBtZdi
        LQEnekTtVynUhxzPEYhdkkeLvy62Dnkh0BaFrhmwFh44wJVfk5uz84V+ZXOspQ92
        xZNlQpBFZ3gRFDEqyVnI4W45AOdTg==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 46716945 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Fri, 14 Feb 2020 22:55:24 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Matt Dunwoodie <ncon@noconroy.net>
Subject: [PATCH v3 net 2/4] wireguard: receive: reset last_under_load to zero
Date:   Fri, 14 Feb 2020 23:57:21 +0100
Message-Id: <20200214225723.63646-3-Jason@zx2c4.com>
In-Reply-To: <20200214225723.63646-1-Jason@zx2c4.com>
References: <20200214225723.63646-1-Jason@zx2c4.com>
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

