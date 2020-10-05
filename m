Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F640283BCB
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 17:58:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728912AbgJEP6R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 11:58:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:56924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728861AbgJEP6K (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Oct 2020 11:58:10 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4E03D212CC;
        Mon,  5 Oct 2020 15:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601913488;
        bh=wPbUNIPCYKMciklekBnLyw9B0K8GkwzLZxVJsP2hOPE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i/0eINU1vpN+M7EcEhfd3jy0PrKBRRf+IE34mSND9B7X+mMbB7OSP1IXS0IopHswh
         AUFp2O4Z98eA2Gy2gnxgE3Eoz4avfiFVfUrWd328aCkJBhz+Y4MgX3Xb7KzaAwf4b3
         qvnk0Yu4tZQXlWJsZcTg0DTmlnWMkSrx68lvtYng=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kernel-team@fb.com,
        johannes@sipsolutions.net, jiri@resnulli.us, andrew@lunn.ch,
        mkubecek@suse.cz, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 6/6] ethtool: specify which header flags are supported per command
Date:   Mon,  5 Oct 2020 08:57:53 -0700
Message-Id: <20201005155753.2333882-7-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201005155753.2333882-1-kuba@kernel.org>
References: <20201005155753.2333882-1-kuba@kernel.org>
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
validation, or use most permissive policy.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/ethtool/netlink.c | 31 +++++++++++++++++++++----------
 net/ethtool/netlink.h |  1 +
 net/ethtool/pause.c   |  2 +-
 3 files changed, 23 insertions(+), 11 deletions(-)

diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index e78ff7ce2a7d..b972789d6b8d 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -9,12 +9,26 @@ static struct genl_family ethtool_genl_family;
 static bool ethnl_ok __read_mostly;
 static u32 ethnl_bcast_seq;
 
+#define ETHTOOL_FLAGS_BASIC (ETHTOOL_FLAG_COMPACT_BITSETS |	\
+			     ETHTOOL_FLAG_OMIT_REPLY)
+#define ETHTOOL_FLAGS_STATS (ETHTOOL_FLAGS_BASIC | ETHTOOL_FLAG_STATS)
+
 const struct nla_policy ethnl_header_policy[ETHTOOL_A_HEADER_MAX + 1] = {
 	[ETHTOOL_A_HEADER_UNSPEC]	= { .type = NLA_REJECT },
 	[ETHTOOL_A_HEADER_DEV_INDEX]	= { .type = NLA_U32 },
 	[ETHTOOL_A_HEADER_DEV_NAME]	= { .type = NLA_NUL_STRING,
 					    .len = ALTIFNAMSIZ - 1 },
-	[ETHTOOL_A_HEADER_FLAGS]	= { .type = NLA_U32 },
+	[ETHTOOL_A_HEADER_FLAGS]	= NLA_POLICY_MASK(NLA_U32,
+							  ETHTOOL_FLAGS_BASIC),
+};
+
+const struct nla_policy ethnl_header_policy_stats[ETHTOOL_A_HEADER_MAX + 1] = {
+	[ETHTOOL_A_HEADER_UNSPEC]	= { .type = NLA_REJECT },
+	[ETHTOOL_A_HEADER_DEV_INDEX]	= { .type = NLA_U32 },
+	[ETHTOOL_A_HEADER_DEV_NAME]	= { .type = NLA_NUL_STRING,
+					    .len = ALTIFNAMSIZ - 1 },
+	[ETHTOOL_A_HEADER_FLAGS]	= NLA_POLICY_MASK(NLA_U32,
+							  ETHTOOL_FLAGS_STATS),
 };
 
 /**
@@ -47,19 +61,16 @@ int ethnl_parse_header_dev_get(struct ethnl_req_info *req_info,
 		NL_SET_ERR_MSG(extack, "request header missing");
 		return -EINVAL;
 	}
+	/* Use most permissive header policy here, ops should specify their
+	 * actual header policy via NLA_POLICY_NESTED(), and the real
+	 * validation will happen in genetlink code.
+	 */
 	ret = nla_parse_nested(tb, ETHTOOL_A_HEADER_MAX, header,
-			       ethnl_header_policy, extack);
+			       ethnl_header_policy_stats, extack);
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
index 4fcd2e8b259b..f04d94e5fa77 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -348,6 +348,7 @@ extern const struct ethnl_request_ops ethnl_eee_request_ops;
 extern const struct ethnl_request_ops ethnl_tsinfo_request_ops;
 
 extern const struct nla_policy ethnl_header_policy[ETHTOOL_A_HEADER_MAX + 1];
+extern const struct nla_policy ethnl_header_policy_stats[ETHTOOL_A_HEADER_MAX + 1];
 extern const struct nla_policy ethnl_strset_get_policy[ETHTOOL_A_STRSET_MAX + 1];
 extern const struct nla_policy ethnl_linkinfo_get_policy[ETHTOOL_A_LINKINFO_MAX + 1];
 extern const struct nla_policy ethnl_linkinfo_set_policy[ETHTOOL_A_LINKINFO_MAX + 1];
diff --git a/net/ethtool/pause.c b/net/ethtool/pause.c
index a7fbe0e4dca6..a5c2abddc992 100644
--- a/net/ethtool/pause.c
+++ b/net/ethtool/pause.c
@@ -19,7 +19,7 @@ struct pause_reply_data {
 const struct nla_policy ethnl_pause_get_policy[ETHTOOL_A_PAUSE_MAX + 1] = {
 	[ETHTOOL_A_PAUSE_UNSPEC]		= { .type = NLA_REJECT },
 	[ETHTOOL_A_PAUSE_HEADER]		=
-		NLA_POLICY_NESTED(ethnl_header_policy),
+		NLA_POLICY_NESTED(ethnl_header_policy_stats),
 	[ETHTOOL_A_PAUSE_AUTONEG]		= { .type = NLA_REJECT },
 	[ETHTOOL_A_PAUSE_RX]			= { .type = NLA_REJECT },
 	[ETHTOOL_A_PAUSE_TX]			= { .type = NLA_REJECT },
-- 
2.26.2

