Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BD64495719
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 00:52:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378237AbiATXvn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 18:51:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231502AbiATXvn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 18:51:43 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3362C061574
        for <netdev@vger.kernel.org>; Thu, 20 Jan 2022 15:51:42 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id m11so35444319edi.13
        for <netdev@vger.kernel.org>; Thu, 20 Jan 2022 15:51:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sxkq5kKrhJF/s8UYShrHhVwewBi5SFfV6LDh6mELfoQ=;
        b=c8Axc67NFaxRgUCIh9eChUz+xNjIOBs4FLXBpjItVrc5Sq5lGek9j3pHgXJfqPi1uB
         0sxLv/nqFT3cpT7nLC6qxSUTcCPFBy69aire2bbd3luKLW1Wzx6u0QbGIv9a6UjChpDB
         4/FLwdZROSGCLio4Jbsl0nBVzlngvvVH0at3O6W2GuPVnzrfqRYdJEgTs4kfYKbfO2GR
         h9Os10SyZLxFijpDidx6pZRf7+cdoxokdazpJs79jPgGsjGR/vrhvYpgDtvTji6Gw+Jh
         7Z3anvw9rC591xLGVoNJDHxzeZZ5Auz+TodeDHRdNe1v7OVMwydLgQ9gDz1hnc2zCEFv
         903A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sxkq5kKrhJF/s8UYShrHhVwewBi5SFfV6LDh6mELfoQ=;
        b=VKoXAirvYI8oYGj9BC2HAKkdii/nCHCdhjwsT1N3LheMXEIgT2yab7ActOMKsBU46k
         VkkRM70HvI85w9/DC7UrOCa9oHoMW/DAYOqYi2njlI2IWugrmdD3NmdpVD3OEXL+jqqn
         cLj1yqbxwzCzBxCpwL0+fTxeNsYZysySg9mZD5f2M8UlipO5+rcnb8vWRkzCqpOiiuMn
         0tB9GJQxvZEszlGyhk6j9rPf1wFENGamnd0/unkzsdBHjL1VLSyGRLJYRNnbb8APuniu
         6mGZTQjIWEPShzoqQMUYCk4DWguJLE1FfAsadFgQ/z11cvHrCDdpqde2eukmVZI18oL4
         J8eg==
X-Gm-Message-State: AOAM532QDVlbFnzRwS0xj2f+qoLbU7HCWeNyCwGiHmXcWZtalJIp/3CP
        zr1V2Xjk9Z9FmhTvufV1nw==
X-Google-Smtp-Source: ABdhPJwtKBrShbYMIiZC4pQkqZ6+Ah9P6bkvxEoUdh5ou64ueHy3m3JjE/z5yzeN6ZuyF+ixnSRR/Q==
X-Received: by 2002:a17:906:3485:: with SMTP id g5mr1161724ejb.293.1642722701218;
        Thu, 20 Jan 2022 15:51:41 -0800 (PST)
Received: from localhost.localdomain ([2a02:2a8:1:20::49c6])
        by smtp.gmail.com with ESMTPSA id p29sm1907436edi.11.2022.01.20.15.51.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jan 2022 15:51:40 -0800 (PST)
From:   Tomas Hlavacek <tmshlvck@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>
Cc:     netdev@vger.kernel.org, Tomas Hlavacek <tmshlvck@gmail.com>
Subject: [RFC PATCH] ipv4: fix fnhe dump record multiplication
Date:   Fri, 21 Jan 2022 00:50:29 +0100
Message-Id: <20220120235028.9040-1-tmshlvck@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the multiplication of the FNHE records during dump: Check in
fnhe_dump_bucket() that the dumped record destination address falls
within the key (prefix, prefixlen) of the FIB leaf that is being dumped.

FNHE table records can be dumped multiple times to netlink on RTM_GETROUTE
command with NLM_F_DUMP flag - either to "ip route show cache" or to any
routing daemon. The multiplication is substantial under specific
conditions - it can produce over 120M netlink messages in one dump.
It happens if there is one shared struct fib_nh linked through
struct fib_info (->fib_nh) from many leafs in FIB over struct fib_alias.

This situation can be triggered by importing a full BGP table over GRE
tunnel. In this case there are ~800k routes that translates to ~120k leafs
in FIB that all ulimately links the same next-hop (the other end of
the GRE tunnel). The GRE tunnel creates one FNHE record for each
destination IP that is routed to the tunnel because of PMTU. In my case
I had around 1000 PMTU records after a few minutes in a lab connected to
the public internet so the FNHE dump produced 120M records that easily
stalled BIRD routing daemon as described here:
http://trubka.network.cz/pipermail/bird-users/2022-January/015897.html
(There is a work-around already committed to BIRD that removes unnecessary
dumps of FNHE.)

Signed-off-by: Tomas Hlavacek <tmshlvck@gmail.com>
---
 include/net/route.h |  3 ++-
 net/ipv4/fib_trie.c |  3 ++-
 net/ipv4/route.c    | 25 ++++++++++++++++++++++---
 3 files changed, 26 insertions(+), 5 deletions(-)

diff --git a/include/net/route.h b/include/net/route.h
index 2e6c0e153e3a..066eab9c5d99 100644
--- a/include/net/route.h
+++ b/include/net/route.h
@@ -244,7 +244,8 @@ void rt_del_uncached_list(struct rtable *rt);
 
 int fib_dump_info_fnhe(struct sk_buff *skb, struct netlink_callback *cb,
 		       u32 table_id, struct fib_info *fi,
-		       int *fa_index, int fa_start, unsigned int flags);
+		       int *fa_index, int fa_start, unsigned int flags,
+		       __be32 prefix, unsigned char prefixlen);
 
 static inline void ip_rt_put(struct rtable *rt)
 {
diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
index 8060524f4256..7a42db70f46d 100644
--- a/net/ipv4/fib_trie.c
+++ b/net/ipv4/fib_trie.c
@@ -2313,7 +2313,8 @@ static int fn_trie_dump_leaf(struct key_vector *l, struct fib_table *tb,
 
 		if (filter->dump_exceptions) {
 			err = fib_dump_info_fnhe(skb, cb, tb->tb_id, fi,
-						 &i_fa, s_fa, flags);
+						 &i_fa, s_fa, flags, xkey,
+						 (KEYLENGTH - fa->fa_slen));
 			if (err < 0)
 				goto stop;
 		}
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 0b4103b1e622..bc882c85228d 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -3049,10 +3049,25 @@ static int rt_fill_info(struct net *net, __be32 dst, __be32 src,
 	return -EMSGSIZE;
 }
 
+static int fnhe_daddr_check(__be32 daddr, struct net *net, u32 table_id,
+			    __be32 prefix, unsigned char prefixlen)
+{
+	struct flowi4 fl4 = { .daddr = daddr };
+	struct fib_table *tb = fib_get_table(net, table_id);
+	struct fib_result res;
+	int err = fib_table_lookup(tb, &fl4, &res, FIB_LOOKUP_NOREF);
+
+	if (!err && res.prefix == prefix && res.prefixlen == prefixlen)
+		return 1;
+
+	return 0;
+}
+
 static int fnhe_dump_bucket(struct net *net, struct sk_buff *skb,
 			    struct netlink_callback *cb, u32 table_id,
 			    struct fnhe_hash_bucket *bucket, int genid,
-			    int *fa_index, int fa_start, unsigned int flags)
+			    int *fa_index, int fa_start, unsigned int flags,
+			    __be32 prefix, unsigned char prefixlen)
 {
 	int i;
 
@@ -3067,6 +3082,9 @@ static int fnhe_dump_bucket(struct net *net, struct sk_buff *skb,
 			if (*fa_index < fa_start)
 				goto next;
 
+			if (!fnhe_daddr_check(fnhe->fnhe_daddr, net, table_id, prefix, prefixlen))
+				goto next;
+
 			if (fnhe->fnhe_genid != genid)
 				goto next;
 
@@ -3096,7 +3114,8 @@ static int fnhe_dump_bucket(struct net *net, struct sk_buff *skb,
 
 int fib_dump_info_fnhe(struct sk_buff *skb, struct netlink_callback *cb,
 		       u32 table_id, struct fib_info *fi,
-		       int *fa_index, int fa_start, unsigned int flags)
+		       int *fa_index, int fa_start, unsigned int flags,
+		       __be32 prefix, unsigned char prefixlen)
 {
 	struct net *net = sock_net(cb->skb->sk);
 	int nhsel, genid = fnhe_genid(net);
@@ -3115,7 +3134,7 @@ int fib_dump_info_fnhe(struct sk_buff *skb, struct netlink_callback *cb,
 		if (bucket)
 			err = fnhe_dump_bucket(net, skb, cb, table_id, bucket,
 					       genid, fa_index, fa_start,
-					       flags);
+					       flags, prefix, prefixlen);
 		rcu_read_unlock();
 		if (err)
 			return err;
-- 
2.25.1

