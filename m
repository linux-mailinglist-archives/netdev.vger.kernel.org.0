Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E6524986D4
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 18:31:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244623AbiAXRbV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 12:31:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244616AbiAXRbU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 12:31:20 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D876C06173B
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 09:31:20 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id t18so16224459plg.9
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 09:31:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dYmnCb8flfLtVurwoEfe6YOmpBvqZJPUP7EFV7+bqKo=;
        b=N4+bsvzOGbzN0oJE28pNox/A2OKJr2pf4Sn9NRl1J58aL38GGk+WldS5d6aQbnA5Ox
         rswYKVN/rkXD+e/oEleXE0BlEBPF3LNgpKNQKMrjguLgtYAV+4mwDfCqSHGr5uWuhHwQ
         pHpVBBACE/sVZbOunnAF7Y11WH/LDigy+16wkO6Ep5LeLfXVzcpY6/dsSCALlHPtMS2x
         HqQ51OAYvf9daxx0gl5R5RXbprzQSC6dzxMVwUkIGVDX7Nzfcbn11zQhFgOFJw/8KsQi
         Qvk/CKb28oJZrZItdSQM/34fbv+4QqqnlGei1AXojzgFhDMRpGCgn5mvGlzBpBsaE+v1
         HdXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dYmnCb8flfLtVurwoEfe6YOmpBvqZJPUP7EFV7+bqKo=;
        b=8Dlq4AKwb8EcSLiBS50XxWLSKd+4OPilme7vkz5sGRSoTmlrY0Hw5lKW8sx+mPHD36
         fLnwVWOaYu8/18QKOROdZeEArgOO6j1ZfuTNeBC229Nebhp+TTEXPBxKLLNq/yTamx2H
         b0m5KR5YOp/C0xeRutFpnojP2CMXu3/ncO7twhZ5LU7NDIFjswtWq+g+sjvPz2xrT7HD
         CnP07HqPkxU/vA+upB3uXNVEJImgNgZfMRg+8su9eLpbPnarpcVNsSLliZA7Ms/Qki1g
         Z4CnxCvwbikSN1hEiwhru+JOpXUDxpViX/9Dt/exronxHK12Fy6ZEs+L0phKOTEZOfsj
         hkFQ==
X-Gm-Message-State: AOAM530f6TTENM/b+AvJ4pYG669xBQ8f4/PTKHGevY+vw+/uGtOGIG6k
        vcQWbHW0sGzjfe+4wPbB9IuU76xUeoU=
X-Google-Smtp-Source: ABdhPJxsZ5+PvzXM1LWNY4DOG9gKa/8UNG93V1L5d6PZ6tJ0uXBXtwrNoLsB9sCIwJoV4dIVLEW4ow==
X-Received: by 2002:a17:90b:3905:: with SMTP id ob5mr2920315pjb.179.1643045479991;
        Mon, 24 Jan 2022 09:31:19 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:e903:2adf:9289:9a45])
        by smtp.gmail.com with ESMTPSA id c5sm11700076pfc.12.2022.01.24.09.31.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 09:31:19 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next] ipv4: get rid of fib_info_hash_{alloc|free}
Date:   Mon, 24 Jan 2022 09:31:15 -0800
Message-Id: <20220124173115.3061285-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Use kvzalloc()/kvfree() instead of hand coded functions.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/fib_semantics.c | 44 ++++++++++------------------------------
 1 file changed, 11 insertions(+), 33 deletions(-)

diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index b4589861b84c6bc4daa7149e078ad63749c7622f..4c5399450682fba6536dbab37d195be77f521503 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -1257,34 +1257,13 @@ fib_info_laddrhash_bucket(const struct net *net, __be32 val)
 	return &fib_info_laddrhash[slot];
 }
 
-static struct hlist_head *fib_info_hash_alloc(int bytes)
-{
-	if (bytes <= PAGE_SIZE)
-		return kzalloc(bytes, GFP_KERNEL);
-	else
-		return (struct hlist_head *)
-			__get_free_pages(GFP_KERNEL | __GFP_ZERO,
-					 get_order(bytes));
-}
-
-static void fib_info_hash_free(struct hlist_head *hash, int bytes)
-{
-	if (!hash)
-		return;
-
-	if (bytes <= PAGE_SIZE)
-		kfree(hash);
-	else
-		free_pages((unsigned long) hash, get_order(bytes));
-}
-
 static void fib_info_hash_move(struct hlist_head *new_info_hash,
 			       struct hlist_head *new_laddrhash,
 			       unsigned int new_size)
 {
 	struct hlist_head *old_info_hash, *old_laddrhash;
 	unsigned int old_size = fib_info_hash_size;
-	unsigned int i, bytes;
+	unsigned int i;
 
 	spin_lock_bh(&fib_info_lock);
 	old_info_hash = fib_info_hash;
@@ -1325,9 +1304,8 @@ static void fib_info_hash_move(struct hlist_head *new_info_hash,
 
 	spin_unlock_bh(&fib_info_lock);
 
-	bytes = old_size * sizeof(struct hlist_head *);
-	fib_info_hash_free(old_info_hash, bytes);
-	fib_info_hash_free(old_laddrhash, bytes);
+	kvfree(old_info_hash);
+	kvfree(old_laddrhash);
 }
 
 __be32 fib_info_update_nhc_saddr(struct net *net, struct fib_nh_common *nhc,
@@ -1444,19 +1422,19 @@ struct fib_info *fib_create_info(struct fib_config *cfg,
 		unsigned int new_size = fib_info_hash_size << 1;
 		struct hlist_head *new_info_hash;
 		struct hlist_head *new_laddrhash;
-		unsigned int bytes;
+		size_t bytes;
 
 		if (!new_size)
 			new_size = 16;
-		bytes = new_size * sizeof(struct hlist_head *);
-		new_info_hash = fib_info_hash_alloc(bytes);
-		new_laddrhash = fib_info_hash_alloc(bytes);
+		bytes = (size_t)new_size * sizeof(struct hlist_head *);
+		new_info_hash = kvzalloc(bytes, GFP_KERNEL);
+		new_laddrhash = kvzalloc(bytes, GFP_KERNEL);
 		if (!new_info_hash || !new_laddrhash) {
-			fib_info_hash_free(new_info_hash, bytes);
-			fib_info_hash_free(new_laddrhash, bytes);
-		} else
+			kvfree(new_info_hash);
+			kvfree(new_laddrhash);
+		} else {
 			fib_info_hash_move(new_info_hash, new_laddrhash, new_size);
-
+		}
 		if (!fib_info_hash_size)
 			goto failure;
 	}
-- 
2.35.0.rc0.227.g00780c9af4-goog

