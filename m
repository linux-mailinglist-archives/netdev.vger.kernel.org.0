Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 989514937EA
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 11:04:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353433AbiASKEU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 05:04:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352594AbiASKEU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 05:04:20 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C545EC061574
        for <netdev@vger.kernel.org>; Wed, 19 Jan 2022 02:04:19 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id s15so2125156pfw.1
        for <netdev@vger.kernel.org>; Wed, 19 Jan 2022 02:04:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=b1bj2taFyxGUc5k665U6Q4VTbJD5tAHU3fwgwPzDJy4=;
        b=IVHtKWX1kgUL+9FzM12ftJgJVk0Fi9RX0X1z7BlIK8KrEbH+izsXgUObp3LRZVazpG
         HRbaQ8AtMEt6JshDxbSN+yGwMPZATuGXPtgdzkzInVJLjfNVu9xw3N13FONGkuO0YCBQ
         60hx6Qt1PpNdZoc9K334o/Uz9XRujJEbRSARUv19PMqRI2RQd6x0vDClVjPZh/qFKqBn
         7qFNLM6VoQUQ3dU+BgQ47Ls3JEo2eDweyk3yqBg6tF1Vy96oiWeNi+39BC0au3dt74SN
         QTpgwaNwxwyrvG3ncZbIP5rm1hiOgVdZUON83X4tK1Ka/lesM/T1kudS72STWegT94DV
         0g7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=b1bj2taFyxGUc5k665U6Q4VTbJD5tAHU3fwgwPzDJy4=;
        b=qJOiCsYFoETdJdEu///cVR5rudnRwR/AXwC7ffVgHOqPse/Xl/P5jYJMPpgd1PqCfP
         BXIloTcQYjhN9G8UdAloJY9xwV915jsiqK0n7MVMNNn3KWteYvImBLetKCR4iyysC9Io
         lirkTlHhothm2hvBT1eeR9NmcN4mImWYYsU8H4gEhnJDq2CGoUAoC2vbAQd44DrGhX/W
         kvIUVRnnmt26XPhoz2IlMX1+RZYvSZ7QJXtnr+4xw+ZT+7pSuQ1uSj+89Iftjr4PfM3d
         Lyhma3ebU+GvdyIuthPB4v0B7YUKBSjcjWlDVmOymIW7CAmPwGcAetNv5Pl/52lv294F
         q9cw==
X-Gm-Message-State: AOAM531T0OkMZkp55zUoed1E3GW10//TDLPFGhL8d49CUB8k/MhWmMr4
        Jw4VipuHxAsVGj1ph50mknZ2Yqm3Z4KCag==
X-Google-Smtp-Source: ABdhPJwQ8d3zEHfLp6Gxp6ZZrrqgiagZ4QzMaMI2D8nQy5+FPI1BVpwpH56Mb2lkK4SwbS/BFsMUMQ==
X-Received: by 2002:a63:9f0a:: with SMTP id g10mr26211479pge.387.1642586659325;
        Wed, 19 Jan 2022 02:04:19 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:a634:e286:f865:178a])
        by smtp.gmail.com with ESMTPSA id a20sm11695323pfv.122.2022.01.19.02.04.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jan 2022 02:04:18 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     David Ahern <dsahern@kernel.org>, netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v2 net 1/2] ipv4: avoid quadratic behavior in netns dismantle
Date:   Wed, 19 Jan 2022 02:04:12 -0800
Message-Id: <20220119100413.4077866-2-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.1.703.g22d0c6ccf7-goog
In-Reply-To: <20220119100413.4077866-1-eric.dumazet@gmail.com>
References: <20220119100413.4077866-1-eric.dumazet@gmail.com>
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
Reviewed-by: David Ahern <dsahern@kernel.org>
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

