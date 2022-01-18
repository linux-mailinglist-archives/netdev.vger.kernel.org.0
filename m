Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 660C4492FA8
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 21:47:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237715AbiARUqx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 15:46:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233264AbiARUqw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 15:46:52 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97942C061574
        for <netdev@vger.kernel.org>; Tue, 18 Jan 2022 12:46:52 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id o64so434756pjo.2
        for <netdev@vger.kernel.org>; Tue, 18 Jan 2022 12:46:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9cD3FDfxrj/skXxlxNL4vcIXldfKRv/pEQt3KawlK+s=;
        b=qSM+vNoxD0LWjwScR1tvOfOjxazOqsQYvoRKZSM+cyzNE13+4LQGK5VF3ny/hOMR8q
         Vtiq+BinGo/coxFrZK50bKKzmD+fwODeW9nr3+JzFiB3MUlPv/KtumEXwrPT42UsJEel
         v9R2ejdL8/rjX2+69ElZBtL5E432Tvn1VkeMh9E/cNl+fZ3V5ei2LXdg/fYsrLCpBGcG
         7t7LCIa1roq87bg2FVF6RPavFFWkD+Y9lCecQ+3y8TyBbOS0KJvKhaA3y/7msRpeqfWG
         j7Du015rO34Q3yRGucvcebptX/mNWtICfdS18nX2umsKAnNKIUMy5N3Gy77PjD9467bO
         dAZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9cD3FDfxrj/skXxlxNL4vcIXldfKRv/pEQt3KawlK+s=;
        b=t0KOjm8QI11nHBbh2hOcCqrs/LGAiMBzrOj4aFYA007soQrziqsmzk6RIovI+HhpVh
         X6TLGX0XbywxCh4QtMRZRR+w5FcqZA7XtkH6rlwOPRoyH3d0fkZFFy9zY6lGhGWkmogd
         GggfIb4GwrNH3Ob7pYniP4/GEb0v2WDxxN+CWr+KjZSTI/IAog5VbEf7vUAcYs7v7kI9
         jlJwH/vLBnrOJ0E9mTZefx/72+R3fPrs/+qHAU5BY5gbQCpEFAAf7M2zMOsjdnYURv+h
         08Jrh3agX2fnaX64nR0xt274o49vvHqpCxDDIUExt7StRyYTvVgPnHRhNHY2+khJ8kaf
         2/Fg==
X-Gm-Message-State: AOAM530pU7mtO6aJoQoSAmFJijppv1Eytx64JP5HdZL7njCMjPTeVVOa
        edoRG91q9fSKM34lKt8wzbpYATT5hWJUJA==
X-Google-Smtp-Source: ABdhPJwK+DFWjcP9R5NmupK7Eg9auUUwHtb07bQUWvsEVqbZ+pJYfigREV0rfMO5hnB46uN/SGAD2w==
X-Received: by 2002:a17:902:7617:b0:149:9c02:f260 with SMTP id k23-20020a170902761700b001499c02f260mr28997882pll.30.1642538812143;
        Tue, 18 Jan 2022 12:46:52 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:a634:e286:f865:178a])
        by smtp.gmail.com with ESMTPSA id x29sm18908915pfh.175.2022.01.18.12.46.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jan 2022 12:46:51 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     David Ahern <dsahern@kernel.org>, netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net 1/2] ipv4: avoid quadratic behavior in netns dismantle
Date:   Tue, 18 Jan 2022 12:46:45 -0800
Message-Id: <20220118204646.3977185-2-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.1.703.g22d0c6ccf7-goog
In-Reply-To: <20220118204646.3977185-1-eric.dumazet@gmail.com>
References: <20220118204646.3977185-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

net/ipv4/fib_semantics.c uses an hash table of 256 slots,
keyed by device ifindexes: fib_info_devhash[DEVINDEX_HASHSIZE]

Problem is that with network namespaces, devices tend
to use the same ifindex.

lo device for instance has a fixed ifindex of one,
for all network namespaces.

This means that hosts with thousands of netns spend
a lot of time looking at some hash buckets with thousands
of elements, notably at netns dismantle.

Simply add a per netns perturbation (net_hash_mix())
to spread elements more uniformely.

Also change fib_devindex_hashfn() to use more entropy.

Fixes: aa79e66eee5d ("net: Make ifindex generation per-net namespace")
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/fib_semantics.c | 36 +++++++++++++++++-------------------
 1 file changed, 17 insertions(+), 19 deletions(-)

diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index 45619c005b8dddd7ccd5c7029efa4ed69b6ce1de..9813949da10493de36b9db797b6a5d94fd9bd3b1 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -29,6 +29,7 @@
 #include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/netlink.h>
+#include <linux/hash.h>
 
 #include <net/arp.h>
 #include <net/ip.h>
@@ -319,11 +320,15 @@ static inline int nh_comp(struct fib_info *fi, struct fib_info *ofi)
 
 static inline unsigned int fib_devindex_hashfn(unsigned int val)
 {
-	unsigned int mask = DEVINDEX_HASHSIZE - 1;
+	return hash_32(val, DEVINDEX_HASHBITS);
+}
 
-	return (val ^
-		(val >> DEVINDEX_HASHBITS) ^
-		(val >> (DEVINDEX_HASHBITS * 2))) & mask;
+static struct hlist_head *
+fib_info_devhash_bucket(const struct net_device *dev)
+{
+	u32 val = net_hash_mix(dev_net(dev)) ^ dev->ifindex;
+
+	return &fib_info_devhash[fib_devindex_hashfn(val)];
 }
 
 static unsigned int fib_info_hashfn_1(int init_val, u8 protocol, u8 scope,
@@ -433,12 +438,11 @@ int ip_fib_check_default(__be32 gw, struct net_device *dev)
 {
 	struct hlist_head *head;
 	struct fib_nh *nh;
-	unsigned int hash;
 
 	spin_lock(&fib_info_lock);
 
-	hash = fib_devindex_hashfn(dev->ifindex);
-	head = &fib_info_devhash[hash];
+	head = fib_info_devhash_bucket(dev);
+
 	hlist_for_each_entry(nh, head, nh_hash) {
 		if (nh->fib_nh_dev == dev &&
 		    nh->fib_nh_gw4 == gw &&
@@ -1609,12 +1613,10 @@ struct fib_info *fib_create_info(struct fib_config *cfg,
 	} else {
 		change_nexthops(fi) {
 			struct hlist_head *head;
-			unsigned int hash;
 
 			if (!nexthop_nh->fib_nh_dev)
 				continue;
-			hash = fib_devindex_hashfn(nexthop_nh->fib_nh_dev->ifindex);
-			head = &fib_info_devhash[hash];
+			head = fib_info_devhash_bucket(nexthop_nh->fib_nh_dev);
 			hlist_add_head(&nexthop_nh->nh_hash, head);
 		} endfor_nexthops(fi)
 	}
@@ -1966,8 +1968,7 @@ void fib_nhc_update_mtu(struct fib_nh_common *nhc, u32 new, u32 orig)
 
 void fib_sync_mtu(struct net_device *dev, u32 orig_mtu)
 {
-	unsigned int hash = fib_devindex_hashfn(dev->ifindex);
-	struct hlist_head *head = &fib_info_devhash[hash];
+	struct hlist_head *head = fib_info_devhash_bucket(dev);
 	struct fib_nh *nh;
 
 	hlist_for_each_entry(nh, head, nh_hash) {
@@ -1986,12 +1987,11 @@ void fib_sync_mtu(struct net_device *dev, u32 orig_mtu)
  */
 int fib_sync_down_dev(struct net_device *dev, unsigned long event, bool force)
 {
-	int ret = 0;
-	int scope = RT_SCOPE_NOWHERE;
+	struct hlist_head *head = fib_info_devhash_bucket(dev);
 	struct fib_info *prev_fi = NULL;
-	unsigned int hash = fib_devindex_hashfn(dev->ifindex);
-	struct hlist_head *head = &fib_info_devhash[hash];
+	int scope = RT_SCOPE_NOWHERE;
 	struct fib_nh *nh;
+	int ret = 0;
 
 	if (force)
 		scope = -1;
@@ -2136,7 +2136,6 @@ static void fib_select_default(const struct flowi4 *flp, struct fib_result *res)
 int fib_sync_up(struct net_device *dev, unsigned char nh_flags)
 {
 	struct fib_info *prev_fi;
-	unsigned int hash;
 	struct hlist_head *head;
 	struct fib_nh *nh;
 	int ret;
@@ -2152,8 +2151,7 @@ int fib_sync_up(struct net_device *dev, unsigned char nh_flags)
 	}
 
 	prev_fi = NULL;
-	hash = fib_devindex_hashfn(dev->ifindex);
-	head = &fib_info_devhash[hash];
+	head = fib_info_devhash_bucket(dev);
 	ret = 0;
 
 	hlist_for_each_entry(nh, head, nh_hash) {
-- 
2.34.1.703.g22d0c6ccf7-goog

