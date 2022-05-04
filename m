Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0827B519586
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 04:39:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344066AbiEDCms (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 22:42:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245604AbiEDCmp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 22:42:45 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 327DF1F63C
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 19:39:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651631950; x=1683167950;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mKsIE68GbBhuzYCRN1lC3xNvECjStEdhe9VlJFA8TM0=;
  b=hf7tbklD6KXOOUuECeUrOxMyNg232V10RxDwwFpeHLTb/qdmuEdm5S0c
   gQxi2+pNVujwizaiYuYTd4lDGxKdKXPJqkiyCk9lrRhb9v6fCKlQNJXKr
   Zjhz1//vTzQtGoVGRYZcLuQeNfBqN2G1De+XbQ+FwwNaO0WZlp6Dyy3a2
   maknIdSuYpP6jw59XKSfP/2AFgFpZ9NGq6Bl9gpzB9TTzuxRv7y0AZfm9
   ST1a764Tbzqixhmh5bIedlSEuZqn3eVJ5limEHTFLTKfmkQxgVbnHf9Cr
   WR1wQdSsxGMBhnZqmm9/tWsKqScQfOfAGp7GFmGfU4jHMUB0RrWr1B41M
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10336"; a="267799836"
X-IronPort-AV: E=Sophos;i="5.91,196,1647327600"; 
   d="scan'208";a="267799836"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 May 2022 19:39:07 -0700
X-IronPort-AV: E=Sophos;i="5.91,196,1647327600"; 
   d="scan'208";a="584493371"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.251.20.240])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 May 2022 19:39:07 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        matthieu.baerts@tessares.net, mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 03/13] mptcp: netlink: split mptcp_pm_parse_addr into two functions
Date:   Tue,  3 May 2022 19:38:51 -0700
Message-Id: <20220504023901.277012-4-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504023901.277012-1-mathew.j.martineau@linux.intel.com>
References: <20220504023901.277012-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Next patch will need to parse MPTCP_PM_ATTR_ADDR attributes and
fill an mptcp_addr_info structure from a different genl command
callback.

To avoid copy-paste, split the existing function to a helper
that does the common part and then call the helper from the
(renamed)mptcp_pm_parse_entry function.

Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/pm_netlink.c | 60 +++++++++++++++++++++++++++---------------
 1 file changed, 39 insertions(+), 21 deletions(-)

diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index 79f5e7197a06..7d9bed536966 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -1142,11 +1142,12 @@ static int mptcp_pm_family_to_addr(int family)
 	return MPTCP_PM_ADDR_ATTR_ADDR4;
 }
 
-static int mptcp_pm_parse_addr(struct nlattr *attr, struct genl_info *info,
-			       bool require_family,
-			       struct mptcp_pm_addr_entry *entry)
+static int mptcp_pm_parse_pm_addr_attr(struct nlattr *tb[],
+				       const struct nlattr *attr,
+				       struct genl_info *info,
+				       struct mptcp_addr_info *addr,
+				       bool require_family)
 {
-	struct nlattr *tb[MPTCP_PM_ADDR_ATTR_MAX + 1];
 	int err, addr_addr;
 
 	if (!attr) {
@@ -1160,27 +1161,29 @@ static int mptcp_pm_parse_addr(struct nlattr *attr, struct genl_info *info,
 	if (err)
 		return err;
 
-	memset(entry, 0, sizeof(*entry));
+	if (tb[MPTCP_PM_ADDR_ATTR_ID])
+		addr->id = nla_get_u8(tb[MPTCP_PM_ADDR_ATTR_ID]);
+
 	if (!tb[MPTCP_PM_ADDR_ATTR_FAMILY]) {
 		if (!require_family)
-			goto skip_family;
+			return err;
 
 		NL_SET_ERR_MSG_ATTR(info->extack, attr,
 				    "missing family");
 		return -EINVAL;
 	}
 
-	entry->addr.family = nla_get_u16(tb[MPTCP_PM_ADDR_ATTR_FAMILY]);
-	if (entry->addr.family != AF_INET
+	addr->family = nla_get_u16(tb[MPTCP_PM_ADDR_ATTR_FAMILY]);
+	if (addr->family != AF_INET
 #if IS_ENABLED(CONFIG_MPTCP_IPV6)
-	    && entry->addr.family != AF_INET6
+	    && addr->family != AF_INET6
 #endif
 	    ) {
 		NL_SET_ERR_MSG_ATTR(info->extack, attr,
 				    "unknown address family");
 		return -EINVAL;
 	}
-	addr_addr = mptcp_pm_family_to_addr(entry->addr.family);
+	addr_addr = mptcp_pm_family_to_addr(addr->family);
 	if (!tb[addr_addr]) {
 		NL_SET_ERR_MSG_ATTR(info->extack, attr,
 				    "missing address data");
@@ -1188,22 +1191,37 @@ static int mptcp_pm_parse_addr(struct nlattr *attr, struct genl_info *info,
 	}
 
 #if IS_ENABLED(CONFIG_MPTCP_IPV6)
-	if (entry->addr.family == AF_INET6)
-		entry->addr.addr6 = nla_get_in6_addr(tb[addr_addr]);
+	if (addr->family == AF_INET6)
+		addr->addr6 = nla_get_in6_addr(tb[addr_addr]);
 	else
 #endif
-		entry->addr.addr.s_addr = nla_get_in_addr(tb[addr_addr]);
+		addr->addr.s_addr = nla_get_in_addr(tb[addr_addr]);
+
+	if (tb[MPTCP_PM_ADDR_ATTR_PORT])
+		addr->port = htons(nla_get_u16(tb[MPTCP_PM_ADDR_ATTR_PORT]));
+
+	return err;
+}
+
+static int mptcp_pm_parse_entry(struct nlattr *attr, struct genl_info *info,
+				bool require_family,
+				struct mptcp_pm_addr_entry *entry)
+{
+	struct nlattr *tb[MPTCP_PM_ADDR_ATTR_MAX + 1];
+	int err;
+
+	memset(entry, 0, sizeof(*entry));
+
+	err = mptcp_pm_parse_pm_addr_attr(tb, attr, info, &entry->addr, require_family);
+	if (err)
+		return err;
 
-skip_family:
 	if (tb[MPTCP_PM_ADDR_ATTR_IF_IDX]) {
 		u32 val = nla_get_s32(tb[MPTCP_PM_ADDR_ATTR_IF_IDX]);
 
 		entry->ifindex = val;
 	}
 
-	if (tb[MPTCP_PM_ADDR_ATTR_ID])
-		entry->addr.id = nla_get_u8(tb[MPTCP_PM_ADDR_ATTR_ID]);
-
 	if (tb[MPTCP_PM_ADDR_ATTR_FLAGS])
 		entry->flags = nla_get_u32(tb[MPTCP_PM_ADDR_ATTR_FLAGS]);
 
@@ -1251,7 +1269,7 @@ static int mptcp_nl_cmd_add_addr(struct sk_buff *skb, struct genl_info *info)
 	struct mptcp_pm_addr_entry addr, *entry;
 	int ret;
 
-	ret = mptcp_pm_parse_addr(attr, info, true, &addr);
+	ret = mptcp_pm_parse_entry(attr, info, true, &addr);
 	if (ret < 0)
 		return ret;
 
@@ -1445,7 +1463,7 @@ static int mptcp_nl_cmd_del_addr(struct sk_buff *skb, struct genl_info *info)
 	unsigned int addr_max;
 	int ret;
 
-	ret = mptcp_pm_parse_addr(attr, info, false, &addr);
+	ret = mptcp_pm_parse_entry(attr, info, false, &addr);
 	if (ret < 0)
 		return ret;
 
@@ -1619,7 +1637,7 @@ static int mptcp_nl_cmd_get_addr(struct sk_buff *skb, struct genl_info *info)
 	void *reply;
 	int ret;
 
-	ret = mptcp_pm_parse_addr(attr, info, false, &addr);
+	ret = mptcp_pm_parse_entry(attr, info, false, &addr);
 	if (ret < 0)
 		return ret;
 
@@ -1830,7 +1848,7 @@ static int mptcp_nl_cmd_set_flags(struct sk_buff *skb, struct genl_info *info)
 	u8 bkup = 0, lookup_by_id = 0;
 	int ret;
 
-	ret = mptcp_pm_parse_addr(attr, info, false, &addr);
+	ret = mptcp_pm_parse_entry(attr, info, false, &addr);
 	if (ret < 0)
 		return ret;
 
-- 
2.36.0

