Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CBBD59F2D7
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 06:51:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234151AbiHXEup (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 00:50:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234979AbiHXEuc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 00:50:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E3D9857CF
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 21:50:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 939C9B820D8
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 04:50:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20642C4347C;
        Wed, 24 Aug 2022 04:50:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661316628;
        bh=JJx0bWaNGJaLXSDtojQ/AcDL2aFFKhv9Q5BrKIIKN5o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kxbAPSItsummQ6Ji38WmkpsPBrOHIIwL3vV16j5bbyhm7+6b3OLrEtjNNrn8n+ieQ
         XIcgyBr+arhc//jg5e/9YNFEqBni4E1Lgekupg6ifo3y144fguh4iG2NRiTXTFFHlR
         F0v2s7XZhvIU1TNmeEXQUEblgpaj9cWUHoy9idOiZCk8ttkabOtLOLbd7Z1+FfLfA2
         CnLoIsM7vf+VZnlfROh6CUAkluusFFiZVCHWKryCBRVLxTHo3lp+GfdPSeUTHRzWQM
         EG59GYgsTPV0L0WQS1hkGJwXiQpl2UjWE8aLJLEhhznEhu7sGl5ZmeZCjWOmw/bVXc
         IHPZk9vVrX1aQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        mkubecek@suse.cz, johannes@sipsolutions.net,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 1/6] netlink: add support for ext_ack missing attributes
Date:   Tue, 23 Aug 2022 21:50:19 -0700
Message-Id: <20220824045024.1107161-2-kuba@kernel.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220824045024.1107161-1-kuba@kernel.org>
References: <20220824045024.1107161-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is currently no way to report via extack in a structured way
that an attribute is missing. This leads to families resorting to
string messages.

Add a pair of attributes - @offset and @type for machine-readable
way of reporting missing attributes. The @offset points to the
nest which should have contained the attribute, @type is the
expected nla_type. The offset may point to a struct nlattr
header or a fixed metadata header like struct genlmsghdr.

User space should be able to figure out which attribute enum
(AKA attribute space AKA attribute set) the nest pointed to by
@offset is using.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 Documentation/userspace-api/netlink/intro.rst |  7 +++++--
 include/linux/netlink.h                       | 13 +++++++++++++
 include/uapi/linux/netlink.h                  |  4 ++++
 net/netlink/af_netlink.c                      | 12 ++++++++++++
 4 files changed, 34 insertions(+), 2 deletions(-)

diff --git a/Documentation/userspace-api/netlink/intro.rst b/Documentation/userspace-api/netlink/intro.rst
index 94337f79e077..8f1220756412 100644
--- a/Documentation/userspace-api/netlink/intro.rst
+++ b/Documentation/userspace-api/netlink/intro.rst
@@ -359,8 +359,8 @@ compatibility this feature has to be explicitly enabled by setting
 the ``NETLINK_EXT_ACK`` setsockopt() to ``1``.
 
 Types of extended ack attributes are defined in enum nlmsgerr_attrs.
-The two most commonly used attributes are ``NLMSGERR_ATTR_MSG``
-and ``NLMSGERR_ATTR_OFFS``.
+The most commonly used attributes are ``NLMSGERR_ATTR_MSG``,
+``NLMSGERR_ATTR_OFFS`` and ``NLMSGERR_ATTR_MISS_*``.
 
 ``NLMSGERR_ATTR_MSG`` carries a message in English describing
 the encountered problem. These messages are far more detailed
@@ -368,6 +368,9 @@ than what can be expressed thru standard UNIX error codes.
 
 ``NLMSGERR_ATTR_OFFS`` points to the attribute which caused the problem.
 
+``NLMSGERR_ATTR_MISS_TYPE`` and ``NLMSGERR_ATTR_MISS_NEST``
+inform about a missing attribute.
+
 Extended ACKs can be reported on errors as well as in case of success.
 The latter should be treated as a warning.
 
diff --git a/include/linux/netlink.h b/include/linux/netlink.h
index bda1c385cffb..24f9fece7599 100644
--- a/include/linux/netlink.h
+++ b/include/linux/netlink.h
@@ -71,6 +71,8 @@ netlink_kernel_create(struct net *net, int unit, struct netlink_kernel_cfg *cfg)
  *	%NL_SET_ERR_MSG
  * @bad_attr: attribute with error
  * @policy: policy for a bad attribute
+ * @miss_nest: nest which was missing an attribute
+ * @miss_type: type which was missing in @miss_nest
  * @cookie: cookie data to return to userspace (for success)
  * @cookie_len: actual cookie data length
  */
@@ -78,6 +80,8 @@ struct netlink_ext_ack {
 	const char *_msg;
 	const struct nlattr *bad_attr;
 	const struct nla_policy *policy;
+	const void *miss_nest;
+	u16 miss_type;
 	u8 cookie[NETLINK_MAX_COOKIE_LEN];
 	u8 cookie_len;
 };
@@ -126,6 +130,15 @@ struct netlink_ext_ack {
 #define NL_SET_ERR_MSG_ATTR(extack, attr, msg)		\
 	NL_SET_ERR_MSG_ATTR_POL(extack, attr, NULL, msg)
 
+#define NL_SET_ERR_ATTR_MISS(extack, nest, type)  do {	\
+	struct netlink_ext_ack *__extack = (extack);	\
+							\
+	if (__extack) {					\
+		__extack->miss_nest = (nest);		\
+		__extack->miss_type = (type);		\
+	}						\
+} while (0)
+
 static inline void nl_set_extack_cookie_u64(struct netlink_ext_ack *extack,
 					    u64 cookie)
 {
diff --git a/include/uapi/linux/netlink.h b/include/uapi/linux/netlink.h
index e0ab261ceca2..25d6d0764737 100644
--- a/include/uapi/linux/netlink.h
+++ b/include/uapi/linux/netlink.h
@@ -140,6 +140,8 @@ struct nlmsgerr {
  *	be used - in the success case - to identify a created
  *	object or operation or similar (binary)
  * @NLMSGERR_ATTR_POLICY: policy for a rejected attribute
+ * @NLMSGERR_ATTR_MISS_TYPE: type of a missing required attribute
+ * @NLMSGERR_ATTR_MISS_NEST: start of the payload where attr was missing
  * @__NLMSGERR_ATTR_MAX: number of attributes
  * @NLMSGERR_ATTR_MAX: highest attribute number
  */
@@ -149,6 +151,8 @@ enum nlmsgerr_attrs {
 	NLMSGERR_ATTR_OFFS,
 	NLMSGERR_ATTR_COOKIE,
 	NLMSGERR_ATTR_POLICY,
+	NLMSGERR_ATTR_MISS_TYPE,
+	NLMSGERR_ATTR_MISS_NEST,
 
 	__NLMSGERR_ATTR_MAX,
 	NLMSGERR_ATTR_MAX = __NLMSGERR_ATTR_MAX - 1
diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 0cd91f813a3b..b00301e29d56 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -2429,6 +2429,8 @@ void netlink_ack(struct sk_buff *in_skb, struct nlmsghdr *nlh, int err,
 		tlvlen += nla_total_size(extack->cookie_len);
 	if (err && nlk_has_extack && extack && extack->policy)
 		tlvlen += netlink_policy_dump_attr_size_estimate(extack->policy);
+	if (err && nlk_has_extack && extack && extack->miss_nest)
+		tlvlen += nla_total_size(sizeof(u32)) * 2;
 
 	if (tlvlen)
 		flags |= NLM_F_ACK_TLVS;
@@ -2458,6 +2460,16 @@ void netlink_ack(struct sk_buff *in_skb, struct nlmsghdr *nlh, int err,
 			WARN_ON(nla_put_u32(skb, NLMSGERR_ATTR_OFFS,
 					    (u8 *)extack->bad_attr -
 					    (u8 *)nlh));
+		if (err && extack->miss_nest &&
+		    !WARN_ON((u8 *)extack->miss_nest < in_skb->data ||
+			     (u8 *)extack->miss_nest > in_skb->data +
+						       in_skb->len)) {
+			WARN_ON(nla_put_u32(skb, NLMSGERR_ATTR_MISS_TYPE,
+					    extack->miss_type));
+			WARN_ON(nla_put_u32(skb, NLMSGERR_ATTR_MISS_NEST,
+					    (u8 *)extack->miss_nest -
+					    (u8 *)nlh));
+		}
 		if (extack->cookie_len)
 			WARN_ON(nla_put(skb, NLMSGERR_ATTR_COOKIE,
 					extack->cookie_len, extack->cookie));
-- 
2.37.2

