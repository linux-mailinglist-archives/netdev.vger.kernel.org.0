Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 435F713DE24
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 15:55:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726559AbgAPOzn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 09:55:43 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:35466 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726160AbgAPOzm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 09:55:42 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1is6Ye-00063Q-UB; Thu, 16 Jan 2020 15:55:40 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH net-next] netlink: make getters tolerate NULL nla arg
Date:   Thu, 16 Jan 2020 15:55:22 +0100
Message-Id: <20200116145522.28803-1-fw@strlen.de>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

One recurring bug pattern triggered by syzbot is NULL dereference in
netlink code paths due to a missing "tb[NL_ARG_FOO] != NULL" test.

At least some of these missing checks would not have crashed the kernel if
the various nla_get_XXX helpers would return 0 in case of missing arg.

Make the helpers return 0 instead of crashing when a null nla is provided.
Even with allyesconfig the .text increase is only about 350 bytes.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netlink.h | 53 ++++++++++++++++++++-----------------------
 1 file changed, 25 insertions(+), 28 deletions(-)

diff --git a/include/net/netlink.h b/include/net/netlink.h
index 56c365dc6dc7..95da479da113 100644
--- a/include/net/netlink.h
+++ b/include/net/netlink.h
@@ -1471,7 +1471,7 @@ static inline int nla_put_in6_addr(struct sk_buff *skb, int attrtype,
  */
 static inline u32 nla_get_u32(const struct nlattr *nla)
 {
-	return *(u32 *) nla_data(nla);
+	return nla ? *(u32 *) nla_data(nla) : 0u;
 }
 
 /**
@@ -1480,7 +1480,7 @@ static inline u32 nla_get_u32(const struct nlattr *nla)
  */
 static inline __be32 nla_get_be32(const struct nlattr *nla)
 {
-	return *(__be32 *) nla_data(nla);
+	return (__be32)nla_get_u32(nla);
 }
 
 /**
@@ -1489,7 +1489,7 @@ static inline __be32 nla_get_be32(const struct nlattr *nla)
  */
 static inline __le32 nla_get_le32(const struct nlattr *nla)
 {
-	return *(__le32 *) nla_data(nla);
+	return (__le32)nla_get_u32(nla);
 }
 
 /**
@@ -1498,7 +1498,7 @@ static inline __le32 nla_get_le32(const struct nlattr *nla)
  */
 static inline u16 nla_get_u16(const struct nlattr *nla)
 {
-	return *(u16 *) nla_data(nla);
+	return nla ? *(u16 *) nla_data(nla) : 0u;
 }
 
 /**
@@ -1507,7 +1507,7 @@ static inline u16 nla_get_u16(const struct nlattr *nla)
  */
 static inline __be16 nla_get_be16(const struct nlattr *nla)
 {
-	return *(__be16 *) nla_data(nla);
+	return (__be16)nla_get_u16(nla);
 }
 
 /**
@@ -1516,7 +1516,7 @@ static inline __be16 nla_get_be16(const struct nlattr *nla)
  */
 static inline __le16 nla_get_le16(const struct nlattr *nla)
 {
-	return *(__le16 *) nla_data(nla);
+	return (__le16)nla_get_u16(nla);
 }
 
 /**
@@ -1525,7 +1525,7 @@ static inline __le16 nla_get_le16(const struct nlattr *nla)
  */
 static inline u8 nla_get_u8(const struct nlattr *nla)
 {
-	return *(u8 *) nla_data(nla);
+	return nla ? *(u8 *) nla_data(nla) : 0u;
 }
 
 /**
@@ -1534,9 +1534,10 @@ static inline u8 nla_get_u8(const struct nlattr *nla)
  */
 static inline u64 nla_get_u64(const struct nlattr *nla)
 {
-	u64 tmp;
+	u64 tmp = 0;
 
-	nla_memcpy(&tmp, nla, sizeof(tmp));
+	if (nla)
+		nla_memcpy(&tmp, nla, sizeof(tmp));
 
 	return tmp;
 }
@@ -1547,11 +1548,7 @@ static inline u64 nla_get_u64(const struct nlattr *nla)
  */
 static inline __be64 nla_get_be64(const struct nlattr *nla)
 {
-	__be64 tmp;
-
-	nla_memcpy(&tmp, nla, sizeof(tmp));
-
-	return tmp;
+	return (__be64)nla_get_u64(nla);
 }
 
 /**
@@ -1560,7 +1557,7 @@ static inline __be64 nla_get_be64(const struct nlattr *nla)
  */
 static inline __le64 nla_get_le64(const struct nlattr *nla)
 {
-	return *(__le64 *) nla_data(nla);
+	return (__le64)nla_get_u64(nla);
 }
 
 /**
@@ -1569,7 +1566,7 @@ static inline __le64 nla_get_le64(const struct nlattr *nla)
  */
 static inline s32 nla_get_s32(const struct nlattr *nla)
 {
-	return *(s32 *) nla_data(nla);
+	return (s32)nla_get_u32(nla);
 }
 
 /**
@@ -1578,7 +1575,7 @@ static inline s32 nla_get_s32(const struct nlattr *nla)
  */
 static inline s16 nla_get_s16(const struct nlattr *nla)
 {
-	return *(s16 *) nla_data(nla);
+	return (s16)nla_get_u16(nla);
 }
 
 /**
@@ -1587,7 +1584,7 @@ static inline s16 nla_get_s16(const struct nlattr *nla)
  */
 static inline s8 nla_get_s8(const struct nlattr *nla)
 {
-	return *(s8 *) nla_data(nla);
+	return (s8)nla_get_u8(nla);
 }
 
 /**
@@ -1596,11 +1593,7 @@ static inline s8 nla_get_s8(const struct nlattr *nla)
  */
 static inline s64 nla_get_s64(const struct nlattr *nla)
 {
-	s64 tmp;
-
-	nla_memcpy(&tmp, nla, sizeof(tmp));
-
-	return tmp;
+	return (s64)nla_get_u64(nla);
 }
 
 /**
@@ -1631,7 +1624,7 @@ static inline unsigned long nla_get_msecs(const struct nlattr *nla)
  */
 static inline __be32 nla_get_in_addr(const struct nlattr *nla)
 {
-	return *(__be32 *) nla_data(nla);
+	return nla_get_be32(nla);
 }
 
 /**
@@ -1640,9 +1633,11 @@ static inline __be32 nla_get_in_addr(const struct nlattr *nla)
  */
 static inline struct in6_addr nla_get_in6_addr(const struct nlattr *nla)
 {
-	struct in6_addr tmp;
+	struct in6_addr tmp = { 0 };
+
+	if (nla)
+		nla_memcpy(&tmp, nla, sizeof(tmp));
 
-	nla_memcpy(&tmp, nla, sizeof(tmp));
 	return tmp;
 }
 
@@ -1652,9 +1647,11 @@ static inline struct in6_addr nla_get_in6_addr(const struct nlattr *nla)
  */
 static inline struct nla_bitfield32 nla_get_bitfield32(const struct nlattr *nla)
 {
-	struct nla_bitfield32 tmp;
+	struct nla_bitfield32 tmp = { 0 };
+
+	if (nla)
+		nla_memcpy(&tmp, nla, sizeof(tmp));
 
-	nla_memcpy(&tmp, nla, sizeof(tmp));
 	return tmp;
 }
 
-- 
2.24.1

