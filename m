Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 620443A249
	for <lists+netdev@lfdr.de>; Sun,  9 Jun 2019 00:22:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727853AbfFHWW0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jun 2019 18:22:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:44500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727821AbfFHWWY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 8 Jun 2019 18:22:24 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E1186217D9;
        Sat,  8 Jun 2019 21:53:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560030827;
        bh=LGGVM8LX+/Js48o6UBv60RJ+x62/vQDFI7muJijfHIs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BI1rEQUTDu0CVvEx41Fk6q3eGOQxXgMWGnI6YAyWDyAbya9PJPBNTLO8h83BqqOeM
         85OpPN/fgQ07y8wve3SADpN4JA0J10F0cP4vTC3phs/B5xnz1IgWMoYSh/hcAugLMN
         tMvc3oQ4TPUs/ffD3RvWPAWo/DDB66J4TLSkdxaE=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     idosch@mellanox.com, kafai@fb.com, weiwan@google.com,
        sbrivio@redhat.com, David Ahern <dsahern@gmail.com>
Subject: [PATCH v4 net-next 12/20] ipv4: Optimization for fib_info lookup with nexthops
Date:   Sat,  8 Jun 2019 14:53:33 -0700
Message-Id: <20190608215341.26592-13-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190608215341.26592-1-dsahern@kernel.org>
References: <20190608215341.26592-1-dsahern@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Be optimistic about re-using a fib_info when nexthop id is given and
the route does not use metrics. Avoids a memory allocation which in
most cases is expected to be freed anyways.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 net/ipv4/fib_semantics.c | 71 ++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 65 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index 2c24d8e3b126..0de895cd0621 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -325,14 +325,32 @@ static inline unsigned int fib_devindex_hashfn(unsigned int val)
 		(val >> (DEVINDEX_HASHBITS * 2))) & mask;
 }
 
-static inline unsigned int fib_info_hashfn(const struct fib_info *fi)
+static unsigned int fib_info_hashfn_1(int init_val, u8 protocol, u8 scope,
+				      u32 prefsrc, u32 priority)
+{
+	unsigned int val = init_val;
+
+	val ^= (protocol << 8) | scope;
+	val ^= prefsrc;
+	val ^= priority;
+
+	return val;
+}
+
+static unsigned int fib_info_hashfn_result(unsigned int val)
 {
 	unsigned int mask = (fib_info_hash_size - 1);
-	unsigned int val = fi->fib_nhs;
 
-	val ^= (fi->fib_protocol << 8) | fi->fib_scope;
-	val ^= (__force u32)fi->fib_prefsrc;
-	val ^= fi->fib_priority;
+	return (val ^ (val >> 7) ^ (val >> 12)) & mask;
+}
+
+static inline unsigned int fib_info_hashfn(struct fib_info *fi)
+{
+	unsigned int val;
+
+	val = fib_info_hashfn_1(fi->fib_nhs, fi->fib_protocol,
+				fi->fib_scope, (__force u32)fi->fib_prefsrc,
+				fi->fib_priority);
 
 	if (fi->nh) {
 		val ^= fib_devindex_hashfn(fi->nh->id);
@@ -342,7 +360,40 @@ static inline unsigned int fib_info_hashfn(const struct fib_info *fi)
 		} endfor_nexthops(fi)
 	}
 
-	return (val ^ (val >> 7) ^ (val >> 12)) & mask;
+	return fib_info_hashfn_result(val);
+}
+
+/* no metrics, only nexthop id */
+static struct fib_info *fib_find_info_nh(struct net *net,
+					 const struct fib_config *cfg)
+{
+	struct hlist_head *head;
+	struct fib_info *fi;
+	unsigned int hash;
+
+	hash = fib_info_hashfn_1(fib_devindex_hashfn(cfg->fc_nh_id),
+				 cfg->fc_protocol, cfg->fc_scope,
+				 (__force u32)cfg->fc_prefsrc,
+				 cfg->fc_priority);
+	hash = fib_info_hashfn_result(hash);
+	head = &fib_info_hash[hash];
+
+	hlist_for_each_entry(fi, head, fib_hash) {
+		if (!net_eq(fi->fib_net, net))
+			continue;
+		if (!fi->nh || fi->nh->id != cfg->fc_nh_id)
+			continue;
+		if (cfg->fc_protocol == fi->fib_protocol &&
+		    cfg->fc_scope == fi->fib_scope &&
+		    cfg->fc_prefsrc == fi->fib_prefsrc &&
+		    cfg->fc_priority == fi->fib_priority &&
+		    cfg->fc_type == fi->fib_type &&
+		    cfg->fc_table == fi->fib_tb_id &&
+		    !((cfg->fc_flags ^ fi->fib_flags) & ~RTNH_COMPARE_MASK))
+			return fi;
+	}
+
+	return NULL;
 }
 
 static struct fib_info *fib_find_info(struct fib_info *nfi)
@@ -1309,6 +1360,14 @@ struct fib_info *fib_create_info(struct fib_config *cfg,
 	}
 
 	if (cfg->fc_nh_id) {
+		if (!cfg->fc_mx) {
+			fi = fib_find_info_nh(net, cfg);
+			if (fi) {
+				fi->fib_treeref++;
+				return fi;
+			}
+		}
+
 		nh = nexthop_find_by_id(net, cfg->fc_nh_id);
 		if (!nh) {
 			NL_SET_ERR_MSG(extack, "Nexthop id does not exist");
-- 
2.11.0

