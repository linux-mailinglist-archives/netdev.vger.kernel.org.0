Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5509D5CEBE
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 13:50:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726831AbfGBLtw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 07:49:52 -0400
Received: from mx2.suse.de ([195.135.220.15]:38322 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725767AbfGBLtv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jul 2019 07:49:51 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 6E180B05E;
        Tue,  2 Jul 2019 11:49:49 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 1FBBFE0159; Tue,  2 Jul 2019 13:49:49 +0200 (CEST)
Message-Id: <d0c23ac629c4a0343acc9f09484e078962c55402.1562067622.git.mkubecek@suse.cz>
In-Reply-To: <cover.1562067622.git.mkubecek@suse.cz>
References: <cover.1562067622.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH net-next v6 02/15] netlink: rename nl80211_validate_nested()
 to nla_validate_nested()
To:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jiri Pirko <jiri@resnulli.us>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Date:   Tue,  2 Jul 2019 13:49:49 +0200 (CEST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Function nl80211_validate_nested() is not specific to nl80211, it's
a counterpart to nla_validate_nested_deprecated() with strict validation.
For consistency with other validation and parse functions, rename it to
nla_validate_nested().

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 include/net/netlink.h  | 8 ++++----
 net/wireless/nl80211.c | 3 +--
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/include/net/netlink.h b/include/net/netlink.h
index e4650e5b64a1..edb36bf29261 100644
--- a/include/net/netlink.h
+++ b/include/net/netlink.h
@@ -1736,7 +1736,7 @@ static inline void nla_nest_cancel(struct sk_buff *skb, struct nlattr *start)
 }
 
 /**
- * nla_validate_nested - Validate a stream of nested attributes
+ * __nla_validate_nested - Validate a stream of nested attributes
  * @start: container attribute
  * @maxtype: maximum attribute type to be expected
  * @policy: validation policy
@@ -1759,9 +1759,9 @@ static inline int __nla_validate_nested(const struct nlattr *start, int maxtype,
 }
 
 static inline int
-nl80211_validate_nested(const struct nlattr *start, int maxtype,
-			const struct nla_policy *policy,
-			struct netlink_ext_ack *extack)
+nla_validate_nested(const struct nlattr *start, int maxtype,
+		    const struct nla_policy *policy,
+		    struct netlink_ext_ack *extack)
 {
 	return __nla_validate_nested(start, maxtype, policy,
 				     NL_VALIDATE_STRICT, extack);
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index fc83dd179c1a..ac371d40530d 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -12707,8 +12707,7 @@ static int nl80211_vendor_check_policy(const struct wiphy_vendor_command *vcmd,
 		return -EINVAL;
 	}
 
-	return nl80211_validate_nested(attr, vcmd->maxattr, vcmd->policy,
-				       extack);
+	return nla_validate_nested(attr, vcmd->maxattr, vcmd->policy, extack);
 }
 
 static int nl80211_vendor_cmd(struct sk_buff *skb, struct genl_info *info)
-- 
2.22.0

