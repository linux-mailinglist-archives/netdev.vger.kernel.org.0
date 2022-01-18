Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3256492FA9
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 21:47:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245114AbiARUqz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 15:46:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233264AbiARUqy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 15:46:54 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69E30C061574
        for <netdev@vger.kernel.org>; Tue, 18 Jan 2022 12:46:54 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id i17so415884pfk.11
        for <netdev@vger.kernel.org>; Tue, 18 Jan 2022 12:46:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VdJo11ympIHswpxStbh7x3K+g2KKhczLwPvc0Taj6fI=;
        b=i7EFSxHkm/heHuY5j54deWHh4AxnOsiUtFqPxc2dWRd1BKAi7FZ8LnAXnOTNTbaz6L
         h5meq95yG5o6al5kzCn5MeHDFO8qzz/mxrDuW+TK5PZow7JdO2Dp4nA1GJKl/rQ7N928
         aclAFPdHV8uivL+mUPwp890nzmVrhwVz/gQKeZZlTBLw2M2LSjYoV/D4r9QOKnl6Mj0R
         srVjIVli9kYz2nvO4SBhi/L+IZ8busvZ1yaaexA/alt/iCEGak+a24vWpXcCnIpVg63t
         JZ1XQCsoDYEE3lt8M5xEsHOGokVVILTR73kws5j4EXbWCIxcL8PKSaLiCBgS2ZyLHpEw
         ygfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VdJo11ympIHswpxStbh7x3K+g2KKhczLwPvc0Taj6fI=;
        b=BXgIai/PfIbvGyJjFLfJgP0leTymqqsWZK2IH6cgoiKpYBc8FJtm+2+Z+GaI36rSA/
         mVsGzNdiLlPPZLV5PWTuqkct6W6Y90TxI6KGFzQueM3ztp+/505cGKZqwsyi8S0E/grg
         rky7C0+q3KqX00BGqvgwQqeR5BhkRLejr+IBRJGn+FHWFADBi3sDFW+XNA4ofBls6ZzC
         y2Y7cPuOyevH4UMa3h7pYM+64OnAt/Vh6nzvVjKlyaE8MpMFMvY6yDVwk7aAGs1kHb6k
         UIumwnUkJ6zrz0MMXwRwa4mJgew1dkrNjIOII3xdyr5ju60tFvgP7jBrtqd9o9ciBuP0
         yn5Q==
X-Gm-Message-State: AOAM532K9TQpB4L1ubNlLK+YxmzW+3+fnlo7BFOER3XitA9pQvAVWjwc
        lwJMmMGcPlnSX8NHzLCHvqU=
X-Google-Smtp-Source: ABdhPJxMTE6ll5Sz8lRvXG/k1O3S8v2ttFavA6H6KFc9YwZTCa7swsYc8xS6krvsWNKrF36GRPR00Q==
X-Received: by 2002:a63:6909:: with SMTP id e9mr13527776pgc.240.1642538813962;
        Tue, 18 Jan 2022 12:46:53 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:a634:e286:f865:178a])
        by smtp.gmail.com with ESMTPSA id x29sm18908915pfh.175.2022.01.18.12.46.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jan 2022 12:46:53 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     David Ahern <dsahern@kernel.org>, netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net 2/2] ipv4: add net_hash_mix() dispersion to fib_info_laddrhash keys
Date:   Tue, 18 Jan 2022 12:46:46 -0800
Message-Id: <20220118204646.3977185-3-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.1.703.g22d0c6ccf7-goog
In-Reply-To: <20220118204646.3977185-1-eric.dumazet@gmail.com>
References: <20220118204646.3977185-1-eric.dumazet@gmail.com>
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
 net/ipv4/fib_semantics.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index 9813949da10493de36b9db797b6a5d94fd9bd3b1..7971889fc0fe3690e47931c39e6a8f8e0fb1d31f 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -52,6 +52,7 @@ static DEFINE_SPINLOCK(fib_info_lock);
 static struct hlist_head *fib_info_hash;
 static struct hlist_head *fib_info_laddrhash;
 static unsigned int fib_info_hash_size;
+static unsigned int fib_info_hash_bits;
 static unsigned int fib_info_cnt;
 
 #define DEVINDEX_HASHBITS 8
@@ -1247,13 +1248,9 @@ int fib_check_nh(struct net *net, struct fib_nh *nh, u32 table, u8 scope,
 	return err;
 }
 
-static inline unsigned int fib_laddr_hashfn(__be32 val)
+static inline unsigned int fib_laddr_hashfn(const struct net *net, __be32 val)
 {
-	unsigned int mask = (fib_info_hash_size - 1);
-
-	return ((__force u32)val ^
-		((__force u32)val >> 7) ^
-		((__force u32)val >> 14)) & mask;
+	return hash_32(net_hash_mix(net) ^ (__force u32)val, fib_info_hash_bits);
 }
 
 static struct hlist_head *fib_info_hash_alloc(int bytes)
@@ -1289,6 +1286,7 @@ static void fib_info_hash_move(struct hlist_head *new_info_hash,
 	old_info_hash = fib_info_hash;
 	old_laddrhash = fib_info_laddrhash;
 	fib_info_hash_size = new_size;
+	fib_info_hash_bits = ilog2(new_size);
 
 	for (i = 0; i < old_size; i++) {
 		struct hlist_head *head = &fib_info_hash[i];
@@ -1315,7 +1313,7 @@ static void fib_info_hash_move(struct hlist_head *new_info_hash,
 			struct hlist_head *ldest;
 			unsigned int new_hash;
 
-			new_hash = fib_laddr_hashfn(fi->fib_prefsrc);
+			new_hash = fib_laddr_hashfn(fi->fib_net, fi->fib_prefsrc);
 			ldest = &new_laddrhash[new_hash];
 			hlist_add_head(&fi->fib_lhash, ldest);
 		}
@@ -1605,7 +1603,7 @@ struct fib_info *fib_create_info(struct fib_config *cfg,
 	if (fi->fib_prefsrc) {
 		struct hlist_head *head;
 
-		head = &fib_info_laddrhash[fib_laddr_hashfn(fi->fib_prefsrc)];
+		head = &fib_info_laddrhash[fib_laddr_hashfn(net, fi->fib_prefsrc)];
 		hlist_add_head(&fi->fib_lhash, head);
 	}
 	if (fi->nh) {
@@ -1877,16 +1875,16 @@ int fib_dump_info(struct sk_buff *skb, u32 portid, u32 seq, int event,
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
 
+	head = &fib_info_laddrhash[fib_laddr_hashfn(net, local)];
 	hlist_for_each_entry(fi, head, fib_lhash) {
 		if (!net_eq(fi->fib_net, net) ||
 		    fi->fib_tb_id != tb_id)
-- 
2.34.1.703.g22d0c6ccf7-goog

