Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FBCB14887B
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 15:29:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391368AbgAXO3Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 09:29:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:42384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405143AbgAXOU7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Jan 2020 09:20:59 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D07BD20661;
        Fri, 24 Jan 2020 14:20:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579875658;
        bh=rOC8U+f1daTPhWJ4bxWs0HkmJ05pAb0NOy3PkAdNkRg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Oeh33EDKwFPowxcFShGOdKdqL4X0/JSJg7bifuH9S7+qH1gPHIEs6M6nDGUDkA3DR
         bcQkIJ8H5PYcV41UwmibqS1t17CMbAa6JY7gZsE73qCR1Y8qSabrXi1uD49YP7wbEJ
         Kf21FVROrT4klv2KkhDknJ8B+sWa22G5WgPD4YBQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jouni Malinen <j@w1.fi>, Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 39/56] mac80211: Fix TKIP replay protection immediately after key setup
Date:   Fri, 24 Jan 2020 09:19:55 -0500
Message-Id: <20200124142012.29752-39-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200124142012.29752-1-sashal@kernel.org>
References: <20200124142012.29752-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jouni Malinen <j@w1.fi>

[ Upstream commit 6f601265215a421f425ba3a4850a35861d024643 ]

TKIP replay protection was skipped for the very first frame received
after a new key is configured. While this is potentially needed to avoid
dropping a frame in some cases, this does leave a window for replay
attacks with group-addressed frames at the station side. Any earlier
frame sent by the AP using the same key would be accepted as a valid
frame and the internal RSC would then be updated to the TSC from that
frame. This would allow multiple previously transmitted group-addressed
frames to be replayed until the next valid new group-addressed frame
from the AP is received by the station.

Fix this by limiting the no-replay-protection exception to apply only
for the case where TSC=0, i.e., when this is for the very first frame
protected using the new key, and the local RSC had not been set to a
higher value when configuring the key (which may happen with GTK).

Signed-off-by: Jouni Malinen <j@w1.fi>
Link: https://lore.kernel.org/r/20200107153545.10934-1-j@w1.fi
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/tkip.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/tkip.c b/net/mac80211/tkip.c
index b3622823bad23..ebd66e8f46b3f 100644
--- a/net/mac80211/tkip.c
+++ b/net/mac80211/tkip.c
@@ -266,9 +266,21 @@ int ieee80211_tkip_decrypt_data(struct crypto_cipher *tfm,
 	if ((keyid >> 6) != key->conf.keyidx)
 		return TKIP_DECRYPT_INVALID_KEYIDX;
 
-	if (rx_ctx->ctx.state != TKIP_STATE_NOT_INIT &&
-	    (iv32 < rx_ctx->iv32 ||
-	     (iv32 == rx_ctx->iv32 && iv16 <= rx_ctx->iv16)))
+	/* Reject replays if the received TSC is smaller than or equal to the
+	 * last received value in a valid message, but with an exception for
+	 * the case where a new key has been set and no valid frame using that
+	 * key has yet received and the local RSC was initialized to 0. This
+	 * exception allows the very first frame sent by the transmitter to be
+	 * accepted even if that transmitter were to use TSC 0 (IEEE 802.11
+	 * described TSC to be initialized to 1 whenever a new key is taken into
+	 * use).
+	 */
+	if (iv32 < rx_ctx->iv32 ||
+	    (iv32 == rx_ctx->iv32 &&
+	     (iv16 < rx_ctx->iv16 ||
+	      (iv16 == rx_ctx->iv16 &&
+	       (rx_ctx->iv32 || rx_ctx->iv16 ||
+		rx_ctx->ctx.state != TKIP_STATE_NOT_INIT)))))
 		return TKIP_DECRYPT_REPLAY;
 
 	if (only_iv) {
-- 
2.20.1

