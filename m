Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CB9B139D90
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 00:42:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729026AbgAMXmv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 18:42:51 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:55677 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727382AbgAMXmv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Jan 2020 18:42:51 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id b87a15e6;
        Mon, 13 Jan 2020 22:42:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:in-reply-to:references:mime-version
        :content-transfer-encoding; s=mail; bh=yFTEYuAAUFsA3SagGCmWoojHL
        KY=; b=3LkTUaiy1c1c1A2NnOTRthpnHw+VaXxjPgbX8i7ESFlbyVcrYVTHaEfB1
        UmvAAkPa5Ma88WTOb409EOciJW9E8F3Lt9PLtKlYmIMNluOvtlameM61uju6uEl8
        vBUn45M3/Uy2X4c4+AHatSms293Bx/t0ikfm66YZOsHCetHbcaNwy3kSwlU1Oflw
        Mi3lcITXslF9PCNe9QiO/7DH8y8ICcsr0lXid/vDbzJq1q1mSV0RA1UvjKJosa3U
        4js4iJEsbT47SyRg1wS+32voNMrmFT3Z+iTJJU2g9Zy4Dk5VbHA0H7+yTZLRyQRK
        qWr8tBg2FdkV6/Y2DXaUuEP6H9GCA==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id d8bf47ce (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Mon, 13 Jan 2020 22:42:50 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     davem@davemloft.net, johannes@sipsolutions.net,
        netdev@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH net-next 1/8] net: skbuff: disambiguate argument and member for skb_list_walk_safe helper
Date:   Mon, 13 Jan 2020 18:42:26 -0500
Message-Id: <20200113234233.33886-2-Jason@zx2c4.com>
In-Reply-To: <20200113234233.33886-1-Jason@zx2c4.com>
References: <20200113234233.33886-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This worked before, because we made all callers name their next pointer
"next". But in trying to be more "drop-in" ready, the silliness here is
revealed. This commit fixes the problem by making the macro argument and
the member use different names.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 include/linux/skbuff.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 016b3c4ab99a..aaf73b34f72f 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1479,9 +1479,9 @@ static inline void skb_mark_not_on_list(struct sk_buff *skb)
 }
 
 /* Iterate through singly-linked GSO fragments of an skb. */
-#define skb_list_walk_safe(first, skb, next)                                   \
-	for ((skb) = (first), (next) = (skb) ? (skb)->next : NULL; (skb);      \
-	     (skb) = (next), (next) = (skb) ? (skb)->next : NULL)
+#define skb_list_walk_safe(first, skb, next_skb)                               \
+	for ((skb) = (first), (next_skb) = (skb) ? (skb)->next : NULL; (skb);  \
+	     (skb) = (next_skb), (next_skb) = (skb) ? (skb)->next : NULL)
 
 static inline void skb_list_del_init(struct sk_buff *skb)
 {
-- 
2.24.1

