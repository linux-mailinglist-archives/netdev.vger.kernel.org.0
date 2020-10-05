Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 503F5284263
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 00:08:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727081AbgJEWH7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 18:07:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:48228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727033AbgJEWHx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Oct 2020 18:07:53 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 387E020FC3;
        Mon,  5 Oct 2020 22:07:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601935672;
        bh=WQnKXSKPLIKDnuzCLIldEZZmDCVZwO9gzQXmmU0z9dY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qGABpLH0bznL0QJnNS6bqhOsGJjQIFmgSjA1ZyYyPpSoPiKRBvbshhdV3Ch1ZtpPS
         eHsNbRND7VAcea9cPFKj6rWPTE9eqJ+1bpiL/Y7qt3WqdU39UZLC+lAZforCeId79a
         SlrdGtwC1j87JnZfiKYFz1OP4i1S6pZQUdf31tD0=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kernel-team@fb.com,
        johannes@sipsolutions.net, jiri@resnulli.us, andrew@lunn.ch,
        mkubecek@suse.cz, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 7/7] ethtool: specify which header flags are supported per command
Date:   Mon,  5 Oct 2020 15:07:39 -0700
Message-Id: <20201005220739.2581920-8-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201005220739.2581920-1-kuba@kernel.org>
References: <20201005220739.2581920-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Perform header flags validation through the policy.

Only pause command supports ETHTOOL_FLAG_STATS. Create a separate
policy to be able to express that in policy dumps to user space.

Note that even though the core will validate the header policy,
it cannot record multiple layers of attributes and we have to
re-parse header sub-attrs. When doing so we could skip attribute
validation, or use most permissive policy. Opt for the former.

We will no longer return the extack cookie for flags but since
we only added first new flag in this release it's not expected
that any user space had a chance to make use of it.

v2: - remove the re-validation in ethnl_parse_header_dev_get()

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/ethtool/netlink.c | 29 +++++++++++++++++++----------
 net/ethtool/netlink.h |  1 +
 net/ethtool/pause.c   |  2 +-
 3 files changed, 21 insertions(+), 11 deletions(-)

diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index 57b5bbb7f48f..066608488af8 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -9,11 +9,24 @@ static struct genl_family ethtool_genl_family;
 static bool ethnl_ok __read_mostly;
 static u32 ethnl_bcast_seq;
 
+#define ETHTOOL_FLAGS_BASIC (ETHTOOL_FLAG_COMPACT_BITSETS |	\
+			     ETHTOOL_FLAG_OMIT_REPLY)
+#define ETHTOOL_FLAGS_STATS (ETHTOOL_FLAGS_BASIC | ETHTOOL_FLAG_STATS)
+
 const struct nla_policy ethnl_header_policy[] = {
 	[ETHTOOL_A_HEADER_DEV_INDEX]	= { .type = NLA_U32 },
 	[ETHTOOL_A_HEADER_DEV_NAME]	= { .type = NLA_NUL_STRING,
 					    .len = ALTIFNAMSIZ - 1 },
-	[ETHTOOL_A_HEADER_FLAGS]	= { .type = NLA_U32 },
+	[ETHTOOL_A_HEADER_FLAGS]	= NLA_POLICY_MASK(NLA_U32,
+							  ETHTOOL_FLAGS_BASIC),
+};
+
+const struct nla_policy ethnl_header_policy_stats[] = {
+	[ETHTOOL_A_HEADER_DEV_INDEX]	= { .type = NLA_U32 },
+	[ETHTOOL_A_HEADER_DEV_NAME]	= { .type = NLA_NUL_STRING,
+					    .len = ALTIFNAMSIZ - 1 },
+	[ETHTOOL_A_HEADER_FLAGS]	= NLA_POLICY_MASK(NLA_U32,
+							  ETHTOOL_FLAGS_STATS),
 };
 
 /**
@@ -46,19 +59,15 @@ int ethnl_parse_header_dev_get(struct ethnl_req_info *req_info,
 		NL_SET_ERR_MSG(extack, "request header missing");
 		return -EINVAL;
 	}
+	/* No validation here, command policy should have a nested policy set
+	 * for the header, therefore validation should have already been done.
+	 */
 	ret = nla_parse_nested(tb, ARRAY_SIZE(ethnl_header_policy) - 1, header,
-			       ethnl_header_policy, extack);
+			       NULL, extack);
 	if (ret < 0)
 		return ret;
-	if (tb[ETHTOOL_A_HEADER_FLAGS]) {
+	if (tb[ETHTOOL_A_HEADER_FLAGS])
 		flags = nla_get_u32(tb[ETHTOOL_A_HEADER_FLAGS]);
-		if (flags & ~ETHTOOL_FLAG_ALL) {
-			NL_SET_ERR_MSG_ATTR(extack, tb[ETHTOOL_A_HEADER_FLAGS],
-					    "unrecognized request flags");
-			nl_set_extack_cookie_u32(extack, ETHTOOL_FLAG_ALL);
-			return -EOPNOTSUPP;
-		}
-	}
 
 	devname_attr = tb[ETHTOOL_A_HEADER_DEV_NAME];
 	if (tb[ETHTOOL_A_HEADER_DEV_INDEX]) {
diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
index 281d793d4557..3f5719786b0f 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -346,6 +346,7 @@ extern const struct ethnl_request_ops ethnl_eee_request_ops;
 extern const struct ethnl_request_ops ethnl_tsinfo_request_ops;
 
 extern const struct nla_policy ethnl_header_policy[ETHTOOL_A_HEADER_FLAGS + 1];
+extern const struct nla_policy ethnl_header_policy_stats[ETHTOOL_A_HEADER_FLAGS + 1];
 extern const struct nla_policy ethnl_strset_get_policy[ETHTOOL_A_STRSET_STRINGSETS + 1];
 extern const struct nla_policy ethnl_linkinfo_get_policy[ETHTOOL_A_LINKINFO_HEADER + 1];
 extern const struct nla_policy ethnl_linkinfo_set_policy[ETHTOOL_A_LINKINFO_TP_MDIX_CTRL + 1];
diff --git a/net/ethtool/pause.c b/net/ethtool/pause.c
index bf4013afd8b2..09998dc5c185 100644
--- a/net/ethtool/pause.c
+++ b/net/ethtool/pause.c
@@ -18,7 +18,7 @@ struct pause_reply_data {
 
 const struct nla_policy ethnl_pause_get_policy[] = {
 	[ETHTOOL_A_PAUSE_HEADER]		=
-		NLA_POLICY_NESTED(ethnl_header_policy),
+		NLA_POLICY_NESTED(ethnl_header_policy_stats),
 };
 
 static void ethtool_stats_init(u64 *stats, unsigned int n)
-- 
2.26.2

