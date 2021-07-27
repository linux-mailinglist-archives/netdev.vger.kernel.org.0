Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4702A3D7FDF
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 22:59:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233081AbhG0U7W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 16:59:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232762AbhG0U7N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 16:59:13 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE775C0617BB
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 13:59:09 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id q2so1799299plr.11
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 13:59:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RbUTIPyfuQU3KvEwbLJbeU9iwD29PEErUjBhpe3f1nk=;
        b=GtYyBBbtPxLFI/WfuLaMvDoXxWyPmC0zNQzNuCkFG4NF0Vg9BHEps6UBdbqkXeNeF3
         TCLGbDASIg/2n9k5Rj/pRUe4EsWyA1ECIuxw4qfKiy8940LxdncMbz9exdPrnZjqZaTH
         WwI9EGrUEd5BHZVFi1kSv8N0o7CeawloSKwTs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RbUTIPyfuQU3KvEwbLJbeU9iwD29PEErUjBhpe3f1nk=;
        b=R97aVFDBX37ll0bz2FuMwEPtlNHR1r4fuRxbzSq26JFYzM44762TKv7LxaJfGC8bt/
         mHQs9TEHU+H3D6/1lmv6le7OsvujhghCQBKM3bi1jgcQtoTbfhJK9XF+jlvG7dTNZUef
         EWmM22Oi4pnkPn68qzi/BECYrq2B6LrHY60rdtb9rZ0IkWAO0C613iQXiwkF+M4mQSMv
         JEZiBcnaHZden2T46bWY0plerjCBbdVjvaPoV6g09IRaarjHWkQngt1R52jdG2jlf1NK
         dUXLGCgVL+S0C1bWfZ8NNKeRyTLF3dmE+sTbFAyX9Tj+E+CBRiCnqVawb6rTy1NiXyo5
         Mt9w==
X-Gm-Message-State: AOAM5314R4QGCPyG0hq5StZbItvkyqIWUlBx5e53Z30bkegs60RTfzQU
        0r+tcMSSm7RCQBZIuoJwyYv+eQ==
X-Google-Smtp-Source: ABdhPJy7+ciBuOtNN7d83O4Zu0WNd8ovLzhIYFckNLYZmMMBqTt0NJ7ydcv6U7b3s5X1OqBXomDXgw==
X-Received: by 2002:a63:4b20:: with SMTP id y32mr25282843pga.382.1627419549553;
        Tue, 27 Jul 2021 13:59:09 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id n12sm5264202pgr.2.2021.07.27.13.59.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 13:59:08 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     linux-hardening@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Keith Packard <keithpac@amazon.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-staging@lists.linux.dev, linux-block@vger.kernel.org,
        linux-kbuild@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: [PATCH 14/64] libertas_tf: Use struct_group() for memcpy() region
Date:   Tue, 27 Jul 2021 13:58:05 -0700
Message-Id: <20210727205855.411487-15-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210727205855.411487-1-keescook@chromium.org>
References: <20210727205855.411487-1-keescook@chromium.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2474; h=from:subject; bh=aN5SRWSO0jhRLPZQ+xEXk4KxeSHDMCg25qp77Fv8hh8=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBhAHODeg0TURmPLYxq0mwE2hFWy/0AYNHuIKbeAQlp DWoEAlmJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYQBzgwAKCRCJcvTf3G3AJjDjEA CAOGWMwUe/TqhcNNpZ+tmgfq8Zfq/oBEgyGg6BbrnIuZqsMJLAnXFi1FFsi5XiWdBd9wW2z+pWLDsZ Qk5cK3uqkczBfKd+ThpeYFCNe/sGC223YyA78nUC5LdHCnah148wC6VuU4iYiPf187zVu1aljWgPkP QgNCXG2oB9NqtBh3pf0JmaHSqgeAqqpxLaVaFEmJDH7QkNmA17wGfU899KFpdb3HVZ8CkncDMoZhn1 DPXzHpS9vXg9vY+WPSF5Taeau8VEyUmFL+4Pc4A2M2LVWkpNBJCyJaADuQQg6QJdEmd9Qr6GMczp8B kuQcY9rOtl7uJhxsUbV+WyMYzIHXeJTGYueZa//yzwGhHGliQt3xlVGVyKk9A3pnvgh3jDJN8uYVaj b/rYpFLFcaBGhaT1yXcgkFAyKZpXO8Vh/Pi/2cwO1Z5UW4BAcnj54ZvKyiY4BZaN4jeZ47sDe9ccuy Y2ISwX8AwsLUH5I50e1AM5SHgOwd6aFVQVGJ0mAJspEUB2gl2BWkH9f+9sQ4HHmBKVKFcOmb1P4Ax/ PyqbaIoRlAj521CKzVKPR5wMiaW+0R2VneaPhPljqaAoY8fgIovvOjTe7GjzsFwSiv1CtakSIvU3Td UV1MTQ9MpUR6nFelPgLKjEpZMPkFtJ/MjnG8kchV6cXWqyz8+t5IN5yp45VQ==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for FORTIFY_SOURCE performing compile-time and run-time
field array bounds checking for memcpy(), memmove(), and memset(),
avoid intentionally writing across neighboring fields.

Use struct_group() in struct txpd around members tx_dest_addr_high
and tx_dest_addr_low so they can be referenced together. This will
allow memcpy() and sizeof() to more easily reason about sizes, improve
readability, and avoid future warnings about writing beyond the end
of tx_dest_addr_high.

"pahole" shows no size nor member offset changes to struct txpd.
"objdump -d" shows no object code changes.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/net/wireless/marvell/libertas_tf/libertas_tf.h | 10 ++++++----
 drivers/net/wireless/marvell/libertas_tf/main.c        |  3 ++-
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/marvell/libertas_tf/libertas_tf.h b/drivers/net/wireless/marvell/libertas_tf/libertas_tf.h
index 5d726545d987..b2af2ddb6bc4 100644
--- a/drivers/net/wireless/marvell/libertas_tf/libertas_tf.h
+++ b/drivers/net/wireless/marvell/libertas_tf/libertas_tf.h
@@ -268,10 +268,12 @@ struct txpd {
 	__le32 tx_packet_location;
 	/* Tx packet length */
 	__le16 tx_packet_length;
-	/* First 2 byte of destination MAC address */
-	u8 tx_dest_addr_high[2];
-	/* Last 4 byte of destination MAC address */
-	u8 tx_dest_addr_low[4];
+	struct_group(tx_dest_addr,
+		/* First 2 byte of destination MAC address */
+		u8 tx_dest_addr_high[2];
+		/* Last 4 byte of destination MAC address */
+		u8 tx_dest_addr_low[4];
+	);
 	/* Pkt Priority */
 	u8 priority;
 	/* Pkt Trasnit Power control */
diff --git a/drivers/net/wireless/marvell/libertas_tf/main.c b/drivers/net/wireless/marvell/libertas_tf/main.c
index 71492211904b..02a1e1f547d8 100644
--- a/drivers/net/wireless/marvell/libertas_tf/main.c
+++ b/drivers/net/wireless/marvell/libertas_tf/main.c
@@ -232,7 +232,8 @@ static void lbtf_tx_work(struct work_struct *work)
 			     ieee80211_get_tx_rate(priv->hw, info)->hw_value);
 
 	/* copy destination address from 802.11 header */
-	memcpy(txpd->tx_dest_addr_high, skb->data + sizeof(struct txpd) + 4,
+	BUILD_BUG_ON(sizeof(txpd->tx_dest_addr) != ETH_ALEN);
+	memcpy(&txpd->tx_dest_addr, skb->data + sizeof(struct txpd) + 4,
 		ETH_ALEN);
 	txpd->tx_packet_length = cpu_to_le16(len);
 	txpd->tx_packet_location = cpu_to_le32(sizeof(struct txpd));
-- 
2.30.2

