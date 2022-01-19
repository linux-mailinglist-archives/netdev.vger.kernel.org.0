Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24BED4937EB
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 11:04:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353437AbiASKEY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 05:04:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352594AbiASKEW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 05:04:22 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEC95C06161C
        for <netdev@vger.kernel.org>; Wed, 19 Jan 2022 02:04:21 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id 128so2074189pfe.12
        for <netdev@vger.kernel.org>; Wed, 19 Jan 2022 02:04:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WnGH7bBzUjG7H82yVnKfdVHGADQN8CNYwcunX2fHdZM=;
        b=W3lthLt7KSjV6eGJoJZFraXD2mhnxHSUF5EpSGGP4ZvOwDZxTe7FPDF9lNwudvmfRE
         XgsaarnIDJuSJrex7VYazWGqu/6WMi6IKpCLprB6MoVf8R5ppUNSpo8eFpnPhai2ZrEa
         9Pqp59CCZYX2yVraXYnJiSwpjvwW6+hP7rhpN1SN3mdqhRgD9vOsCfCmszHcO6okgQEp
         W6k35ZKE+Wu+377dqBjHqWWugK53txmCSUAXVpEMtjehDyji/lYCLpn7mEkNBKEL6FTk
         yzpYtpWL5gWUh+MpVV5R47Q5hhtC8G2Ez46IbzxA7epiK6Ei5mGTAjumN/lq9JwZWzRh
         lZuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WnGH7bBzUjG7H82yVnKfdVHGADQN8CNYwcunX2fHdZM=;
        b=TO4gvV2JZmO8Jf709m2d2R1Ejae4Wu8TwSFIHJNlsZ1wptEKILJT4wF6+dqULJry2A
         nqmS3o8zhHeVITUkijoWnxpNi4PwLWeK7ZoKoZlQNQnH0yQkvYE9OrdmJJsaVpBgD5vk
         rwGjJXvToDvFxErh6Le6o12w+b+eyqKgtMT9YO6G/eJ9gVDnTIu30SnRI9nv7knhkiab
         jAJ++5Goghp53a9w2QoI4roeVEWD7u3b2Wc5U1yWLSyXs+i8QDEyXC8JdLmzXZRcFLWQ
         bsX/OPAZVxAmFb0GubE8Yq+tNyqRY87HX6mrvtxwQqBaBKA1BQGAHgzWJCCbGn5vze4f
         jCXQ==
X-Gm-Message-State: AOAM5309dabSqaycNliA3nlaiDGzo7DMKTzXH7AUFHxMc7pOIPO6adMd
        8O5Ruu85yd3a0EnBRPrcYpg=
X-Google-Smtp-Source: ABdhPJzDxZLuU7yfkb8PyTx0d7/wdOHGFDg0jkF5VsogjUt7fR3PrSW4Wu/cTazV8HkEsq88P71LmQ==
X-Received: by 2002:a63:b144:: with SMTP id g4mr26854527pgp.571.1642586661309;
        Wed, 19 Jan 2022 02:04:21 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:a634:e286:f865:178a])
        by smtp.gmail.com with ESMTPSA id a20sm11695323pfv.122.2022.01.19.02.04.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jan 2022 02:04:21 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     David Ahern <dsahern@kernel.org>, netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v2 net 2/2] ipv4: add net_hash_mix() dispersion to fib_info_laddrhash keys
Date:   Wed, 19 Jan 2022 02:04:13 -0800
Message-Id: <20220119100413.4077866-3-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.1.703.g22d0c6ccf7-goog
In-Reply-To: <20220119100413.4077866-1-eric.dumazet@gmail.com>
References: <20220119100413.4077866-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

net/ipv4/fib_semantics.c uses a hash table (fib_info_laddrhash)
in which fib_sync_down_addr() can locate fib_info
based on IPv4 local address.

This hash table is resized based on total number of
hashed fib_info, but the hash function is only
using the local address.

For hosts having many active network namespaces,
all fib_info for loopback devices (IPv4 address 127.0.0.1)
are hashed into a single bucket, making netns dismantles
very slow.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/fib_semantics.c | 29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index 9813949da10493de36b9db797b6a5d94fd9bd3b1..b4589861b84c6bc4daa7149e078ad63749c7622f 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -52,6 +52,7 @@ static DEFINE_SPINLOCK(fib_info_lock);
 static struct hlist_head *fib_info_hash;
 static struct hlist_head *fib_info_laddrhash;
 static unsigned int fib_info_hash_size;
+static unsigned int fib_info_hash_bits;
 static unsigned int fib_info_cnt;
 
 #define DEVINDEX_HASHBITS 8
@@ -1247,13 +1248,13 @@ int fib_check_nh(struct net *net, struct fib_nh *nh, u32 table, u8 scope,
 	return err;
 }
 
-static inline unsigned int fib_laddr_hashfn(__be32 val)
+static struct hlist_head *
+fib_info_laddrhash_bucket(const struct net *net, __be32 val)
 {
-	unsigned int mask = (fib_info_hash_size - 1);
+	u32 slot = hash_32(net_hash_mix(net) ^ (__force u32)val,
+			   fib_info_hash_bits);
 
-	return ((__force u32)val ^
-		((__force u32)val >> 7) ^
-		((__force u32)val >> 14)) & mask;
+	return &fib_info_laddrhash[slot];
 }
 
 static struct hlist_head *fib_info_hash_alloc(int bytes)
@@ -1289,6 +1290,7 @@ static void fib_info_hash_move(struct hlist_head *new_info_hash,
 	old_info_hash = fib_info_hash;
 	old_laddrhash = fib_info_laddrhash;
 	fib_info_hash_size = new_size;
+	fib_info_hash_bits = ilog2(new_size);
 
 	for (i = 0; i < old_size; i++) {
 		struct hlist_head *head = &fib_info_hash[i];
@@ -1306,21 +1308,20 @@ static void fib_info_hash_move(struct hlist_head *new_info_hash,
 	}
 	fib_info_hash = new_info_hash;
 
+	fib_info_laddrhash = new_laddrhash;
 	for (i = 0; i < old_size; i++) {
-		struct hlist_head *lhead = &fib_info_laddrhash[i];
+		struct hlist_head *lhead = &old_laddrhash[i];
 		struct hlist_node *n;
 		struct fib_info *fi;
 
 		hlist_for_each_entry_safe(fi, n, lhead, fib_lhash) {
 			struct hlist_head *ldest;
-			unsigned int new_hash;
 
-			new_hash = fib_laddr_hashfn(fi->fib_prefsrc);
-			ldest = &new_laddrhash[new_hash];
+			ldest = fib_info_laddrhash_bucket(fi->fib_net,
+							  fi->fib_prefsrc);
 			hlist_add_head(&fi->fib_lhash, ldest);
 		}
 	}
-	fib_info_laddrhash = new_laddrhash;
 
 	spin_unlock_bh(&fib_info_lock);
 
@@ -1605,7 +1606,7 @@ struct fib_info *fib_create_info(struct fib_config *cfg,
 	if (fi->fib_prefsrc) {
 		struct hlist_head *head;
 
-		head = &fib_info_laddrhash[fib_laddr_hashfn(fi->fib_prefsrc)];
+		head = fib_info_laddrhash_bucket(net, fi->fib_prefsrc);
 		hlist_add_head(&fi->fib_lhash, head);
 	}
 	if (fi->nh) {
@@ -1877,16 +1878,16 @@ int fib_dump_info(struct sk_buff *skb, u32 portid, u32 seq, int event,
  */
 int fib_sync_down_addr(struct net_device *dev, __be32 local)
 {
-	int ret = 0;
-	unsigned int hash = fib_laddr_hashfn(local);
-	struct hlist_head *head = &fib_info_laddrhash[hash];
 	int tb_id = l3mdev_fib_table(dev) ? : RT_TABLE_MAIN;
 	struct net *net = dev_net(dev);
+	struct hlist_head *head;
 	struct fib_info *fi;
+	int ret = 0;
 
 	if (!fib_info_laddrhash || local == 0)
 		return 0;
 
+	head = fib_info_laddrhash_bucket(net, local);
 	hlist_for_each_entry(fi, head, fib_lhash) {
 		if (!net_eq(fi->fib_net, net) ||
 		    fi->fib_tb_id != tb_id)
-- 
2.34.1.703.g22d0c6ccf7-goog

