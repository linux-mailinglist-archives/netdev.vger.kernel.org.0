Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E5403F7EF1
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 01:18:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233455AbhHYXSY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 19:18:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231535AbhHYXSX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 19:18:23 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE533C061757
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 16:17:36 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id t42so973303pfg.12
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 16:17:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mGCUvJpcs02KtrbH5sh+HKmH+Xo5D6CWLG3Hh/77W7c=;
        b=KWVkPzGCnO7Bm0MiuiEa8OCmY+a+qr0DoYKzeCX/flAJLkksrXbRf1NZtWrgNlWLil
         K0CKpt7ePor2kbLfeHqxHCiDYKaUhXU5fF+ODr8TzgMpfnOCKEqD6lP2q+4yB61qF1T4
         nl5kfpmoGFeJ8587Of7Na0gzcY9NH5wvjDV6qMpyBLqH1lLmVDpW5MsfLVuVgHE6bLP6
         s5O5vH0AGKuCR5EqaaACgE3dlTj+eLgysrraKyntjTDkwGJ0EgteZxWkT750iZDN8tWM
         f4712X2+1eVAYN2JILJOw5PKf8V4fmfK2n4G17TFMazYWhS9LF3oYF4r8p5cHfTGqsLe
         B5sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mGCUvJpcs02KtrbH5sh+HKmH+Xo5D6CWLG3Hh/77W7c=;
        b=B2MwRaCj/rCQEoeZM6cfl3Us/5roqDeEtg9B6770MOSA+0dgPIR2BWj9oKbRTPKjSw
         Fe8tNuzZTYM1PY7ekF0lyodePA9TfEmUtzYlWbmdr8ncSLk1R35kXIZAtLtaYBUr2v4q
         txRgHXoQydV0ZV6NdvOjPXclu5pbALQRNZyM3+9Te4AcbT/tYy1jVsckGL69akrIF22L
         mjgBjtxptoGfqb+ABVfukuLgkiIM0D+G4yTuRcbuWO8bMPDXkRRIkwE89JpbhwsjtqkR
         IdU269BvXfGoaHlIlOzn9EfY5cd538m9TA0pjoBgkHS/+PqEwa/bY17VAnFmoChQ3F/5
         mkhw==
X-Gm-Message-State: AOAM5307dMUiAdRKz2DWLa1U9kQz34257uT6nvbMBWi5dpuAAZQD3O9z
        uhn8Wpmupm3wmRDnTod3o08=
X-Google-Smtp-Source: ABdhPJzwvTrz1uvQlm7L64UzorkvuphkINVKV6cB522KIJWFtcPKVQ3lCGo4OqF35tmwW3aBzf2M9w==
X-Received: by 2002:a63:515f:: with SMTP id r31mr564738pgl.41.1629933455539;
        Wed, 25 Aug 2021 16:17:35 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:d4a1:c5c4:fef5:2e3e])
        by smtp.gmail.com with ESMTPSA id mv1sm6625035pjb.29.2021.08.25.16.17.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Aug 2021 16:17:35 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Willy Tarreau <w@1wt.eu>, Keyu Man <kman001@ucr.edu>,
        Wei Wang <weiwan@google.com>, Martin KaFai Lau <kafai@fb.com>
Subject: [PATCH net 1/2] ipv6: use siphash in rt6_exception_hash()
Date:   Wed, 25 Aug 2021 16:17:28 -0700
Message-Id: <20210825231729.401676-2-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.33.0.rc2.250.ged5fa647cd-goog
In-Reply-To: <20210825231729.401676-1-eric.dumazet@gmail.com>
References: <20210825231729.401676-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

A group of security researchers brought to our attention
the weakness of hash function used in rt6_exception_hash()

Lets use siphash instead of Jenkins Hash, to considerably
reduce security risks.

Following patch deals with IPv4.

Fixes: 35732d01fe31 ("ipv6: introduce a hash table to store dst cache")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: Keyu Man <kman001@ucr.edu>
Cc: Wei Wang <weiwan@google.com>
Cc: Martin KaFai Lau <kafai@fb.com>
---
 net/ipv6/route.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index b6ddf23d38330ded88509b8507998ce82a72799b..c5e8ecb96426bda619fe242351e40dcf6ff68bcf 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -41,6 +41,7 @@
 #include <linux/nsproxy.h>
 #include <linux/slab.h>
 #include <linux/jhash.h>
+#include <linux/siphash.h>
 #include <net/net_namespace.h>
 #include <net/snmp.h>
 #include <net/ipv6.h>
@@ -1484,17 +1485,24 @@ static void rt6_exception_remove_oldest(struct rt6_exception_bucket *bucket)
 static u32 rt6_exception_hash(const struct in6_addr *dst,
 			      const struct in6_addr *src)
 {
-	static u32 seed __read_mostly;
-	u32 val;
+	static siphash_key_t rt6_exception_key __read_mostly;
+	struct {
+		struct in6_addr dst;
+		struct in6_addr src;
+	} __aligned(SIPHASH_ALIGNMENT) combined = {
+		.dst = *dst,
+	};
+	u64 val;
 
-	net_get_random_once(&seed, sizeof(seed));
-	val = jhash2((const u32 *)dst, sizeof(*dst)/sizeof(u32), seed);
+	net_get_random_once(&rt6_exception_key, sizeof(rt6_exception_key));
 
 #ifdef CONFIG_IPV6_SUBTREES
 	if (src)
-		val = jhash2((const u32 *)src, sizeof(*src)/sizeof(u32), val);
+		combined.src = *src;
 #endif
-	return hash_32(val, FIB6_EXCEPTION_BUCKET_SIZE_SHIFT);
+	val = siphash(&combined, sizeof(combined), &rt6_exception_key);
+
+	return hash_64(val, FIB6_EXCEPTION_BUCKET_SIZE_SHIFT);
 }
 
 /* Helper function to find the cached rt in the hash table
-- 
2.33.0.rc2.250.ged5fa647cd-goog

