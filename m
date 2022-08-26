Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 104AE5A1F4E
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 05:11:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244015AbiHZDJr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 23:09:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234380AbiHZDJl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 23:09:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3394CD51A;
        Thu, 25 Aug 2022 20:09:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3A8B16143F;
        Fri, 26 Aug 2022 03:09:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AA33C43470;
        Fri, 26 Aug 2022 03:09:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661483379;
        bh=Z+ZeJTP++Z8+pSCIFCnXEUYJf5IEFjtw9J5eTda3zhM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sp0d0myzQJ/EXWebz6kgVMRi+xNoXPfM6nHDcv/Qt0nRffEC6LduOMh7RDPgYGJzS
         Ms30GE2RMsGIW5u3O1pJ0K0ZaiVfrhaYWjpsFTjdhNBiG8DyfX6bCB6r9dB/Wufcrj
         4VPuPZJFy3AJjGtyEi09hk17MOwuiZWovqtMNUhnlTP0WN+Py+r/twXEjXEX223g36
         hakGIvWptSy3d5n3Wc9WEY7jKXDShrADQubI+zPLsh8j7OeAOoGJ/HuIEP6nDsXeFh
         grnAutQJVi46Z9c4O+1x989oIFKxh7mBFo99xoXz/jCi3uN8klaQ/JNBTJ3LGdfpBK
         trcPq12H0zbhg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        mkubecek@suse.cz, johannes@sipsolutions.net, idosch@idosch.org,
        dsahern@gmail.com, stephen@networkplumber.org,
        Jakub Kicinski <kuba@kernel.org>, corbet@lwn.net,
        jacob.e.keller@intel.com, fw@strlen.de, razor@blackwall.org,
        linux-doc@vger.kernel.org
Subject: [PATCH net-next v3 2/6] netlink: add support for ext_ack missing attributes
Date:   Thu, 25 Aug 2022 20:09:31 -0700
Message-Id: <20220826030935.2165661-3-kuba@kernel.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220826030935.2165661-1-kuba@kernel.org>
References: <20220826030935.2165661-1-kuba@kernel.org>
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
expected nla_type. The offset will be skipped if the attribute
is missing at the message level rather than inside a nest.

User space should be able to figure out which attribute enum
(AKA attribute space AKA attribute set) the nest pointed to by
@offset is using.

Reviewed-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
--
v2: use missing nest as indication of root attrs (Johannes)
v3: add % before NULL in kdoc
    make miss_nest a struct nlattr rather than void
---
CC: corbet@lwn.net
CC: jacob.e.keller@intel.com
CC: fw@strlen.de
CC: razor@blackwall.org
CC: linux-doc@vger.kernel.org
---
 Documentation/userspace-api/netlink/intro.rst |  7 +++++--
 include/linux/netlink.h                       | 13 +++++++++++++
 include/uapi/linux/netlink.h                  |  6 ++++++
 net/netlink/af_netlink.c                      | 12 ++++++++++++
 4 files changed, 36 insertions(+), 2 deletions(-)

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
index bda1c385cffb..1619221c415c 100644
--- a/include/linux/netlink.h
+++ b/include/linux/netlink.h
@@ -71,6 +71,8 @@ netlink_kernel_create(struct net *net, int unit, struct netlink_kernel_cfg *cfg)
  *	%NL_SET_ERR_MSG
  * @bad_attr: attribute with error
  * @policy: policy for a bad attribute
+ * @miss_type: attribute type which was missing
+ * @miss_nest: nest missing an attribute (%NULL if missing top level attr)
  * @cookie: cookie data to return to userspace (for success)
  * @cookie_len: actual cookie data length
  */
@@ -78,6 +80,8 @@ struct netlink_ext_ack {
 	const char *_msg;
 	const struct nlattr *bad_attr;
 	const struct nla_policy *policy;
+	const struct nlattr *miss_nest;
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
index e0ab261ceca2..e0689dbd2cde 100644
--- a/include/uapi/linux/netlink.h
+++ b/include/uapi/linux/netlink.h
@@ -140,6 +140,10 @@ struct nlmsgerr {
  *	be used - in the success case - to identify a created
  *	object or operation or similar (binary)
  * @NLMSGERR_ATTR_POLICY: policy for a rejected attribute
+ * @NLMSGERR_ATTR_MISS_TYPE: type of a missing required attribute,
+ *	%NLMSGERR_ATTR_MISS_NEST will not be present if the attribute was
+ *	missing at the message level
+ * @NLMSGERR_ATTR_MISS_NEST: offset of the nest where attribute was missing
  * @__NLMSGERR_ATTR_MAX: number of attributes
  * @NLMSGERR_ATTR_MAX: highest attribute number
  */
@@ -149,6 +153,8 @@ enum nlmsgerr_attrs {
 	NLMSGERR_ATTR_OFFS,
 	NLMSGERR_ATTR_COOKIE,
 	NLMSGERR_ATTR_POLICY,
+	NLMSGERR_ATTR_MISS_TYPE,
+	NLMSGERR_ATTR_MISS_NEST,
 
 	__NLMSGERR_ATTR_MAX,
 	NLMSGERR_ATTR_MAX = __NLMSGERR_ATTR_MAX - 1
diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 7eae157c1625..f89ba302ac6e 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -2423,6 +2423,10 @@ netlink_ack_tlv_len(struct netlink_sock *nlk, int err,
 		tlvlen += nla_total_size(sizeof(u32));
 	if (extack->policy)
 		tlvlen += netlink_policy_dump_attr_size_estimate(extack->policy);
+	if (extack->miss_type)
+		tlvlen += nla_total_size(sizeof(u32));
+	if (extack->miss_nest)
+		tlvlen += nla_total_size(sizeof(u32));
 
 	return tlvlen;
 }
@@ -2449,6 +2453,14 @@ netlink_ack_tlv_fill(struct sk_buff *in_skb, struct sk_buff *skb,
 	if (extack->policy)
 		netlink_policy_dump_write_attr(skb, extack->policy,
 					       NLMSGERR_ATTR_POLICY);
+	if (extack->miss_type)
+		WARN_ON(nla_put_u32(skb, NLMSGERR_ATTR_MISS_TYPE,
+				    extack->miss_type));
+	if (extack->miss_nest &&
+	    !WARN_ON((u8 *)extack->miss_nest < in_skb->data ||
+		     (u8 *)extack->miss_nest > in_skb->data + in_skb->len))
+		WARN_ON(nla_put_u32(skb, NLMSGERR_ATTR_MISS_NEST,
+				    (u8 *)extack->miss_nest - (u8 *)nlh));
 }
 
 void netlink_ack(struct sk_buff *in_skb, struct nlmsghdr *nlh, int err,
-- 
2.37.2

