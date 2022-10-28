Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67E8D610E39
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 12:16:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230097AbiJ1KQV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 06:16:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230005AbiJ1KQT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 06:16:19 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF9BA3AB03;
        Fri, 28 Oct 2022 03:16:17 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1ooMPN-0006Rh-6d; Fri, 28 Oct 2022 12:16:13 +0200
Date:   Fri, 28 Oct 2022 12:16:13 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Florian Westphal <fw@strlen.de>,
        Johannes Berg <johannes@sipsolutions.net>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next 1/2] netlink: introduce NLA_POLICY_MAX_BE
Message-ID: <20221028101613.GC1915@breakpoint.cc>
References: <20220905100937.11459-1-fw@strlen.de>
 <20220905100937.11459-2-fw@strlen.de>
 <20221027133109.590bd74f@kernel.org>
 <2f528f1a320c55fdc7f3be55095c1f0eacee1032.camel@sipsolutions.net>
 <20221027233500.GA1915@breakpoint.cc>
 <20221027193931.2adce94d@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221027193931.2adce94d@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> wrote:
> On Fri, 28 Oct 2022 01:35:00 +0200 Florian Westphal wrote:
> > > In fact we could easily just have three extra types NLA_BE16, NLA_BE32
> > > and NLA_BE64 types without even stealing a bit?  
> > 
> > Sure, I can make a patch if there is consensus that new types are the
> > way to go.
> 
> The NLA_BE* idea seems appealing, but if the implementation gets
> tedious either way works for me.

Doesn't look too bad.  I plan to do a formal submission once I'm back
home.

diff --git a/include/net/netlink.h b/include/net/netlink.h
index 4418b1981e31..a843c8eb75cc 100644
--- a/include/net/netlink.h
+++ b/include/net/netlink.h
@@ -181,6 +181,8 @@ enum {
 	NLA_S64,
 	NLA_BITFIELD32,
 	NLA_REJECT,
+	NLA_BE16,
+	NLA_BE32,
 	__NLA_TYPE_MAX,
 };
 
@@ -231,6 +233,7 @@ enum nla_policy_validation {
  *    NLA_U32, NLA_U64,
  *    NLA_S8, NLA_S16,
  *    NLA_S32, NLA_S64,
+ *    NLA_BE16, NLA_BE32,
  *    NLA_MSECS            Leaving the length field zero will verify the
  *                         given type fits, using it verifies minimum length
  *                         just like "All other"
@@ -261,6 +264,8 @@ enum nla_policy_validation {
  *    NLA_U16,
  *    NLA_U32,
  *    NLA_U64,
+ *    NLA_BE16,
+ *    NLA_BE32,
  *    NLA_S8,
  *    NLA_S16,
  *    NLA_S32,
@@ -325,7 +330,6 @@ struct nla_policy {
 		struct netlink_range_validation_signed *range_signed;
 		struct {
 			s16 min, max;
-			u8 network_byte_order:1;
 		};
 		int (*validate)(const struct nlattr *attr,
 				struct netlink_ext_ack *extack);
@@ -369,6 +373,8 @@ struct nla_policy {
 	(tp == NLA_U8 || tp == NLA_U16 || tp == NLA_U32 || tp == NLA_U64)
 #define __NLA_IS_SINT_TYPE(tp)						\
 	(tp == NLA_S8 || tp == NLA_S16 || tp == NLA_S32 || tp == NLA_S64)
+#define __NLA_IS_BEINT_TYPE(tp)						\
+	(tp == NLA_BE16 || tp == NLA_BE32)
 
 #define __NLA_ENSURE(condition) BUILD_BUG_ON_ZERO(!(condition))
 #define NLA_ENSURE_UINT_TYPE(tp)			\
@@ -382,6 +388,7 @@ struct nla_policy {
 #define NLA_ENSURE_INT_OR_BINARY_TYPE(tp)		\
 	(__NLA_ENSURE(__NLA_IS_UINT_TYPE(tp) ||		\
 		      __NLA_IS_SINT_TYPE(tp) ||		\
+		      __NLA_IS_BEINT_TYPE(tp) ||	\
 		      tp == NLA_MSECS ||		\
 		      tp == NLA_BINARY) + tp)
 #define NLA_ENSURE_NO_VALIDATION_PTR(tp)		\
@@ -389,6 +396,8 @@ struct nla_policy {
 		      tp != NLA_REJECT &&		\
 		      tp != NLA_NESTED &&		\
 		      tp != NLA_NESTED_ARRAY) + tp)
+#define NLA_ENSURE_BEINT_TYPE(tp)			\
+	(__NLA_ENSURE(__NLA_IS_BEINT_TYPE(tp)) + tp)
 
 #define NLA_POLICY_RANGE(tp, _min, _max) {		\
 	.type = NLA_ENSURE_INT_OR_BINARY_TYPE(tp),	\
@@ -419,14 +428,6 @@ struct nla_policy {
 	.type = NLA_ENSURE_INT_OR_BINARY_TYPE(tp),	\
 	.validation_type = NLA_VALIDATE_MAX,		\
 	.max = _max,					\
-	.network_byte_order = 0,			\
-}
-
-#define NLA_POLICY_MAX_BE(tp, _max) {			\
-	.type = NLA_ENSURE_UINT_TYPE(tp),		\
-	.validation_type = NLA_VALIDATE_MAX,		\
-	.max = _max,					\
-	.network_byte_order = 1,			\
 }
 
 #define NLA_POLICY_MASK(tp, _mask) {			\
diff --git a/lib/nlattr.c b/lib/nlattr.c
index 40f22b177d69..b67a53e29b8f 100644
--- a/lib/nlattr.c
+++ b/lib/nlattr.c
@@ -124,10 +124,12 @@ void nla_get_range_unsigned(const struct nla_policy *pt,
 		range->max = U8_MAX;
 		break;
 	case NLA_U16:
+	case NLA_BE16:
 	case NLA_BINARY:
 		range->max = U16_MAX;
 		break;
 	case NLA_U32:
+	case NLA_BE32:
 		range->max = U32_MAX;
 		break;
 	case NLA_U64:
@@ -159,31 +161,6 @@ void nla_get_range_unsigned(const struct nla_policy *pt,
 	}
 }
 
-static u64 nla_get_attr_bo(const struct nla_policy *pt,
-			   const struct nlattr *nla)
-{
-	switch (pt->type) {
-	case NLA_U16:
-		if (pt->network_byte_order)
-			return ntohs(nla_get_be16(nla));
-
-		return nla_get_u16(nla);
-	case NLA_U32:
-		if (pt->network_byte_order)
-			return ntohl(nla_get_be32(nla));
-
-		return nla_get_u32(nla);
-	case NLA_U64:
-		if (pt->network_byte_order)
-			return be64_to_cpu(nla_get_be64(nla));
-
-		return nla_get_u64(nla);
-	}
-
-	WARN_ON_ONCE(1);
-	return 0;
-}
-
 static int nla_validate_range_unsigned(const struct nla_policy *pt,
 				       const struct nlattr *nla,
 				       struct netlink_ext_ack *extack,
@@ -197,9 +174,13 @@ static int nla_validate_range_unsigned(const struct nla_policy *pt,
 		value = nla_get_u8(nla);
 		break;
 	case NLA_U16:
+		value = nla_get_u16(nla);
+		break;
 	case NLA_U32:
+		value = nla_get_u32(nla);
+		break;
 	case NLA_U64:
-		value = nla_get_attr_bo(pt, nla);
+		value = nla_get_u64(nla);
 		break;
 	case NLA_MSECS:
 		value = nla_get_u64(nla);
@@ -207,6 +188,12 @@ static int nla_validate_range_unsigned(const struct nla_policy *pt,
 	case NLA_BINARY:
 		value = nla_len(nla);
 		break;
+	case NLA_BE16:
+		value = ntohs(nla_get_be16(nla));
+		break;
+	case NLA_BE32:
+		value = ntohl(nla_get_be32(nla));
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -334,6 +321,8 @@ static int nla_validate_int_range(const struct nla_policy *pt,
 	case NLA_U64:
 	case NLA_MSECS:
 	case NLA_BINARY:
+	case NLA_BE16:
+	case NLA_BE32:
 		return nla_validate_range_unsigned(pt, nla, extack, validate);
 	case NLA_S8:
 	case NLA_S16:
diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index 088244f9d838..4edd899aeb9b 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -173,10 +173,10 @@ static const struct nla_policy nft_payload_policy[NFTA_PAYLOAD_MAX + 1] = {
 	[NFTA_PAYLOAD_SREG]		= { .type = NLA_U32 },
 	[NFTA_PAYLOAD_DREG]		= { .type = NLA_U32 },
 	[NFTA_PAYLOAD_BASE]		= { .type = NLA_U32 },
-	[NFTA_PAYLOAD_OFFSET]		= NLA_POLICY_MAX_BE(NLA_U32, 255),
-	[NFTA_PAYLOAD_LEN]		= NLA_POLICY_MAX_BE(NLA_U32, 255),
+	[NFTA_PAYLOAD_OFFSET]		= NLA_POLICY_MAX(NLA_BE32, 255),
+	[NFTA_PAYLOAD_LEN]		= NLA_POLICY_MAX(NLA_BE32, 255),
 	[NFTA_PAYLOAD_CSUM_TYPE]	= { .type = NLA_U32 },
-	[NFTA_PAYLOAD_CSUM_OFFSET]	= NLA_POLICY_MAX_BE(NLA_U32, 255),
+	[NFTA_PAYLOAD_CSUM_OFFSET]	= NLA_POLICY_MAX(NLA_BE32, 255),
 	[NFTA_PAYLOAD_CSUM_FLAGS]	= { .type = NLA_U32 },
 };
 
