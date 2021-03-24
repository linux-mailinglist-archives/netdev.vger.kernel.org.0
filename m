Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38B20348432
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 22:54:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234619AbhCXVyL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 17:54:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234623AbhCXVxo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 17:53:44 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD3FEC06174A
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 14:53:43 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id lr1-20020a17090b4b81b02900ea0a3f38c1so3277601pjb.0
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 14:53:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RrVT9gcCwvitGP7p/xTBm9pfpsNRvO8uBvkhXaMT/Cc=;
        b=soKmFZ5POD6vsfvv9eeXFsgvIBglwosB1E1fm5hSew8Y9OWGjXHQTI91+un3Ou4/Oq
         +uyIWquuotHobjTVAa6ulqDybnQHApo5EUeMgj6wLUIrC5jR8FQFw/bOU8l12g81zgZj
         +7/LR+WdURBID0dAlU51Cq1Mz39lU+7RsXTkDrW36IzDVUiq05Cw2yqSpoAiGGwGC0Ba
         IB2fJZo8TVVlmn9NviLoHHegQDlDcVfnQMxqRyd5JxAKUIOgkFNivOfvLL7+JNFrJijp
         IebaxJbQTgfyRpcOrdpXSDWEnw5jm09KzW5wrBCYiGP2LlF3aA7WCr0vn1JuwbYRgJfE
         osMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RrVT9gcCwvitGP7p/xTBm9pfpsNRvO8uBvkhXaMT/Cc=;
        b=d9dvpB/DtZkgY0Agg/2zzKfltnVOl4CRsGGPcFO/QpWN8u6co0FlW2ESe4A+c1GeXH
         r5rqiYlqAKtqY0y2gjxVMo71s9QnAm8+Cf/T/wQxid8TX6ctekJp9/v4dSTu3nu1SLwC
         lY5YoQrXQ9FzREHyeh7i+a3WDn7LweGDz0ujkqcwJZQTREky5qOVzL5XQzyANDB6Jfef
         Kc1G1sutZEL4mpdJuQzkrFJ7If+PSgJ9/g+JTEJXcdLPi46op4KT0ly2ayb9vhDWchnL
         PM55ECPiQ+8/WlkVok1FX04C4PkgMTmzySEpFWJgrgN/52BxRWVSFNl7us+D/NpxWWX8
         YRig==
X-Gm-Message-State: AOAM530qUKgsSBaIgLPnkUODP38l45rDRfb6UeYEzM1g0ouXZEkov2bC
        dzVFWL9LxwaPEtq0a0i4ISE=
X-Google-Smtp-Source: ABdhPJwgyVurPPCRpCMLZZkej8Xq7Q5ZpZmutqp7Anz6lFcXXBBHTbgLOndF4NwVmyRFlrEwwJOXMQ==
X-Received: by 2002:a17:90b:116:: with SMTP id p22mr5359845pjz.161.1616622823415;
        Wed, 24 Mar 2021 14:53:43 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:c4c8:29f1:3d1:8904])
        by smtp.gmail.com with ESMTPSA id l22sm3731803pfd.145.2021.03.24.14.53.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Mar 2021 14:53:42 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Amit Klein <aksecurity@gmail.com>, Willy Tarreau <w@1wt.eu>
Subject: [PATCH net-next] inet: use bigger hash table for IP ID generation
Date:   Wed, 24 Mar 2021 14:53:37 -0700
Message-Id: <20210324215337.3201983-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.31.0.291.g576ba9dcdaf-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

In commit 73f156a6e8c1 ("inetpeer: get rid of ip_id_count")
I used a very small hash table that could be abused
by patient attackers to reveal sensitive information.

Switch to a dynamic sizing, depending on RAM size.

Typical big hosts will now use 128x more storage (2 MB)
to get a similar increase in security and reduction
of hash collisions.

As a bonus, use of alloc_large_system_hash() spreads
allocated memory among all NUMA nodes.

Fixes: 73f156a6e8c1 ("inetpeer: get rid of ip_id_count")
Reported-by: Amit Klein <aksecurity@gmail.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Willy Tarreau <w@1wt.eu>
---
 net/ipv4/route.c | 42 ++++++++++++++++++++++++++++--------------
 1 file changed, 28 insertions(+), 14 deletions(-)

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 0470442ff61d6ddb5e233a7398c6c4da7f24accf..ea916df1bbf5e794285f18e30db2209c96817db9 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -66,6 +66,7 @@
 #include <linux/types.h>
 #include <linux/kernel.h>
 #include <linux/mm.h>
+#include <linux/memblock.h>
 #include <linux/string.h>
 #include <linux/socket.h>
 #include <linux/sockios.h>
@@ -452,8 +453,10 @@ static void ipv4_confirm_neigh(const struct dst_entry *dst, const void *daddr)
 	__ipv4_confirm_neigh(dev, *(__force u32 *)pkey);
 }
 
-#define IP_IDENTS_SZ 2048u
-
+/* Hash tables of size 2048..262144 depending on RAM size.
+ * Each bucket uses 8 bytes.
+ */
+static u32 ip_idents_mask __read_mostly;
 static atomic_t *ip_idents __read_mostly;
 static u32 *ip_tstamps __read_mostly;
 
@@ -463,12 +466,16 @@ static u32 *ip_tstamps __read_mostly;
  */
 u32 ip_idents_reserve(u32 hash, int segs)
 {
-	u32 *p_tstamp = ip_tstamps + hash % IP_IDENTS_SZ;
-	atomic_t *p_id = ip_idents + hash % IP_IDENTS_SZ;
-	u32 old = READ_ONCE(*p_tstamp);
-	u32 now = (u32)jiffies;
+	u32 bucket, old, now = (u32)jiffies;
+	atomic_t *p_id;
+	u32 *p_tstamp;
 	u32 delta = 0;
 
+	bucket = hash & ip_idents_mask;
+	p_tstamp = ip_tstamps + bucket;
+	p_id = ip_idents + bucket;
+	old = READ_ONCE(*p_tstamp);
+
 	if (old != now && cmpxchg(p_tstamp, old, now) == old)
 		delta = prandom_u32_max(now - old);
 
@@ -3557,18 +3564,25 @@ struct ip_rt_acct __percpu *ip_rt_acct __read_mostly;
 
 int __init ip_rt_init(void)
 {
+	void *idents_hash;
 	int cpu;
 
-	ip_idents = kmalloc_array(IP_IDENTS_SZ, sizeof(*ip_idents),
-				  GFP_KERNEL);
-	if (!ip_idents)
-		panic("IP: failed to allocate ip_idents\n");
+	/* For modern hosts, this will use 2 MB of memory */
+	idents_hash = alloc_large_system_hash("IP idents",
+					      sizeof(*ip_idents) + sizeof(*ip_tstamps),
+					      0,
+					      16, /* one bucket per 64 KB */
+					      HASH_ZERO,
+					      NULL,
+					      &ip_idents_mask,
+					      2048,
+					      256*1024);
 
-	prandom_bytes(ip_idents, IP_IDENTS_SZ * sizeof(*ip_idents));
+	ip_idents = idents_hash;
 
-	ip_tstamps = kcalloc(IP_IDENTS_SZ, sizeof(*ip_tstamps), GFP_KERNEL);
-	if (!ip_tstamps)
-		panic("IP: failed to allocate ip_tstamps\n");
+	prandom_bytes(ip_idents, (ip_idents_mask + 1) * sizeof(*ip_idents));
+
+	ip_tstamps = idents_hash + (ip_idents_mask + 1) * sizeof(*ip_idents);
 
 	for_each_possible_cpu(cpu) {
 		struct uncached_list *ul = &per_cpu(rt_uncached_list, cpu);
-- 
2.31.0.291.g576ba9dcdaf-goog

