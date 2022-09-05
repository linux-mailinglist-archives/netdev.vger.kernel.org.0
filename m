Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 085845ACF92
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 12:10:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236497AbiIEKKC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 06:10:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236706AbiIEKJz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 06:09:55 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6A491402E;
        Mon,  5 Sep 2022 03:09:53 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1oV93A-0003hz-6Q; Mon, 05 Sep 2022 12:09:52 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     netfilter-devel@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH net-next 1/2] netlink: introduce NLA_POLICY_MAX_BE
Date:   Mon,  5 Sep 2022 12:09:36 +0200
Message-Id: <20220905100937.11459-2-fw@strlen.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220905100937.11459-1-fw@strlen.de>
References: <20220905100937.11459-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

netlink allows to specify allowed ranges for integer types.
Unfortunately, nfnetlink passes integers in big endian, so the existing
NLA_POLICY_MAX() cannot be used.

At the moment, nfnetlink users, such as nf_tables, need to resort to
programmatic checking via helpers such as nft_parse_u32_check().

This is both cumbersome and error prone.  This adds NLA_POLICY_MAX_BE
which adds range check support for BE16, BE32 and BE64 integers.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netlink.h |  9 +++++++++
 lib/nlattr.c          | 31 +++++++++++++++++++++++++++----
 2 files changed, 36 insertions(+), 4 deletions(-)

diff --git a/include/net/netlink.h b/include/net/netlink.h
index e658d18afa67..4418b1981e31 100644
--- a/include/net/netlink.h
+++ b/include/net/netlink.h
@@ -325,6 +325,7 @@ struct nla_policy {
 		struct netlink_range_validation_signed *range_signed;
 		struct {
 			s16 min, max;
+			u8 network_byte_order:1;
 		};
 		int (*validate)(const struct nlattr *attr,
 				struct netlink_ext_ack *extack);
@@ -418,6 +419,14 @@ struct nla_policy {
 	.type = NLA_ENSURE_INT_OR_BINARY_TYPE(tp),	\
 	.validation_type = NLA_VALIDATE_MAX,		\
 	.max = _max,					\
+	.network_byte_order = 0,			\
+}
+
+#define NLA_POLICY_MAX_BE(tp, _max) {			\
+	.type = NLA_ENSURE_UINT_TYPE(tp),		\
+	.validation_type = NLA_VALIDATE_MAX,		\
+	.max = _max,					\
+	.network_byte_order = 1,			\
 }
 
 #define NLA_POLICY_MASK(tp, _mask) {			\
diff --git a/lib/nlattr.c b/lib/nlattr.c
index 86029ad5ead4..40f22b177d69 100644
--- a/lib/nlattr.c
+++ b/lib/nlattr.c
@@ -159,6 +159,31 @@ void nla_get_range_unsigned(const struct nla_policy *pt,
 	}
 }
 
+static u64 nla_get_attr_bo(const struct nla_policy *pt,
+			   const struct nlattr *nla)
+{
+	switch (pt->type) {
+	case NLA_U16:
+		if (pt->network_byte_order)
+			return ntohs(nla_get_be16(nla));
+
+		return nla_get_u16(nla);
+	case NLA_U32:
+		if (pt->network_byte_order)
+			return ntohl(nla_get_be32(nla));
+
+		return nla_get_u32(nla);
+	case NLA_U64:
+		if (pt->network_byte_order)
+			return be64_to_cpu(nla_get_be64(nla));
+
+		return nla_get_u64(nla);
+	}
+
+	WARN_ON_ONCE(1);
+	return 0;
+}
+
 static int nla_validate_range_unsigned(const struct nla_policy *pt,
 				       const struct nlattr *nla,
 				       struct netlink_ext_ack *extack,
@@ -172,12 +197,10 @@ static int nla_validate_range_unsigned(const struct nla_policy *pt,
 		value = nla_get_u8(nla);
 		break;
 	case NLA_U16:
-		value = nla_get_u16(nla);
-		break;
 	case NLA_U32:
-		value = nla_get_u32(nla);
-		break;
 	case NLA_U64:
+		value = nla_get_attr_bo(pt, nla);
+		break;
 	case NLA_MSECS:
 		value = nla_get_u64(nla);
 		break;
-- 
2.35.1

