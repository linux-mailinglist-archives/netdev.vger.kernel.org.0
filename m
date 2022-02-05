Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 773194AA4D6
	for <lists+netdev@lfdr.de>; Sat,  5 Feb 2022 01:03:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378609AbiBEADo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 19:03:44 -0500
Received: from mga17.intel.com ([192.55.52.151]:46958 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1378410AbiBEADn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Feb 2022 19:03:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644019423; x=1675555423;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=o+myu+kqVEbCshCjSRLhWyKSxrNCK7EbwezO18pNPxo=;
  b=l7LhLhVIWhRhoNr25kv0Ye24mIe0LZUeTK5Ljyr9qjl42QSjnsxRwZA3
   TkboDQj7zi4z+RuZUDfBZCa8aPaUlGyulnDEaMdqeMgGGnetBSflTd8Ma
   iujkuexaL5mQGQys45aXOYhd5IDHxH3pMXcFLIf753IARJ5I9Z8DZhEDp
   7xu+fOSaPiOKZOHDoEyZZl13OMfm+rm+9IqmJrxUPRqAEDjvQPhXHIPNo
   hLQHeXT3hVluD2r2XuQ9KZy5COvEKJ+zvABTZH9SyHikXQ1SQSWFlnFRf
   vGqc1xoG1wl6WizIavaKU28Sg0WtK6ulkqNTZupXs6ua2/U+N5xuMsaJY
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10248"; a="229115081"
X-IronPort-AV: E=Sophos;i="5.88,344,1635231600"; 
   d="scan'208";a="229115081"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2022 16:03:43 -0800
X-IronPort-AV: E=Sophos;i="5.88,344,1635231600"; 
   d="scan'208";a="770097513"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.231.200])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2022 16:03:43 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliang.tang@suse.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 1/9] mptcp: allow to use port and non-signal in set_flags
Date:   Fri,  4 Feb 2022 16:03:29 -0800
Message-Id: <20220205000337.187292-2-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220205000337.187292-1-mathew.j.martineau@linux.intel.com>
References: <20220205000337.187292-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliang.tang@suse.com>

It's illegal to use both port and non-signal flags for adding address.
But it's legal to use both of them for setting flags, which always uses
non-signal flags, backup or fullmesh.

This patch moves this non-signal flag with port check from
mptcp_pm_parse_addr() to mptcp_nl_cmd_add_addr(). Do the check only when
adding addresses, not setting flags or deleting addresses.

Signed-off-by: Geliang Tang <geliang.tang@suse.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/pm_netlink.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index d47795748ad7..5464c2d268bd 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -1174,14 +1174,8 @@ static int mptcp_pm_parse_addr(struct nlattr *attr, struct genl_info *info,
 	if (tb[MPTCP_PM_ADDR_ATTR_FLAGS])
 		entry->flags = nla_get_u32(tb[MPTCP_PM_ADDR_ATTR_FLAGS]);
 
-	if (tb[MPTCP_PM_ADDR_ATTR_PORT]) {
-		if (!(entry->flags & MPTCP_PM_ADDR_FLAG_SIGNAL)) {
-			NL_SET_ERR_MSG_ATTR(info->extack, attr,
-					    "flags must have signal when using port");
-			return -EINVAL;
-		}
+	if (tb[MPTCP_PM_ADDR_ATTR_PORT])
 		entry->addr.port = htons(nla_get_u16(tb[MPTCP_PM_ADDR_ATTR_PORT]));
-	}
 
 	return 0;
 }
@@ -1227,6 +1221,11 @@ static int mptcp_nl_cmd_add_addr(struct sk_buff *skb, struct genl_info *info)
 	if (ret < 0)
 		return ret;
 
+	if (addr.addr.port && !(addr.flags & MPTCP_PM_ADDR_FLAG_SIGNAL)) {
+		GENL_SET_ERR_MSG(info, "flags must have signal when using port");
+		return -EINVAL;
+	}
+
 	entry = kmalloc(sizeof(*entry), GFP_KERNEL);
 	if (!entry) {
 		GENL_SET_ERR_MSG(info, "can't allocate addr");
-- 
2.35.1

