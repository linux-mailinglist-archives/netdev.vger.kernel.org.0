Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D87C3648B9D
	for <lists+netdev@lfdr.de>; Sat, 10 Dec 2022 01:28:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229722AbiLJA2X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 19:28:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229886AbiLJA2V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 19:28:21 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34A3E3B9EF;
        Fri,  9 Dec 2022 16:28:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670632099; x=1702168099;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=N0y/i3Do5VdhnNWP0yR27HhYOVVlZRnZa+T/mnGs7dk=;
  b=Qpn4XWzKDWgjvoA0zwAf9F8ofUehhELs5nIGs85yS+Z7LhE3ZcneO00k
   MrPQikTnBRv3SF1zRvRxSItAasg9OgneaFmNyq61XBljaakj5/Q7iokvq
   SH/q9BN2SuX7I3QHLCt9oSkq+duRHhGeGW4K5CSu6seO7dxClA64WTgnI
   ftrsRR9eqzoh6HdFeJOK3+OVrSJr1Th3tb7b8GpQKr7kzHn/HNRu2nSFx
   aXRpfwpI6TLW81vHQegcPCkoHX2+gL6cYrvOBT+iiWABke8cuPVqSRSh9
   gbY+z4LRn0EFKr6aGTskm0imcMy2BxOSsZOUCAIYDAq5P9Qo0gm6DoBCG
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10556"; a="381879116"
X-IronPort-AV: E=Sophos;i="5.96,232,1665471600"; 
   d="scan'208";a="381879116"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2022 16:28:17 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10556"; a="649728872"
X-IronPort-AV: E=Sophos;i="5.96,232,1665471600"; 
   d="scan'208";a="649728872"
Received: from hthiagar-mobl1.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.231.121])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2022 16:28:17 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Wei Yongjun <weiyongjun1@huawei.com>, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        fw@strlen.de, kishen.maloor@intel.com, dcaratti@redhat.com,
        matthieu.baerts@tessares.net, mptcp@lists.linux.dev,
        stable@vger.kernel.org,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net 1/4] mptcp: netlink: fix some error return code
Date:   Fri,  9 Dec 2022 16:28:07 -0800
Message-Id: <20221210002810.289674-2-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221210002810.289674-1-mathew.j.martineau@linux.intel.com>
References: <20221210002810.289674-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

Fix to return negative error code -EINVAL from some error handling
case instead of 0, as done elsewhere in those functions.

Fixes: 9ab4807c84a4 ("mptcp: netlink: Add MPTCP_PM_CMD_ANNOUNCE")
Fixes: 702c2f646d42 ("mptcp: netlink: allow userspace-driven subflow establishment")
Cc: stable@vger.kernel.org
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/pm_userspace.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/mptcp/pm_userspace.c b/net/mptcp/pm_userspace.c
index 9e82250cbb70..0430415357ba 100644
--- a/net/mptcp/pm_userspace.c
+++ b/net/mptcp/pm_userspace.c
@@ -156,6 +156,7 @@ int mptcp_nl_cmd_announce(struct sk_buff *skb, struct genl_info *info)
 
 	if (addr_val.addr.id == 0 || !(addr_val.flags & MPTCP_PM_ADDR_FLAG_SIGNAL)) {
 		GENL_SET_ERR_MSG(info, "invalid addr id or flags");
+		err = -EINVAL;
 		goto announce_err;
 	}
 
@@ -282,6 +283,7 @@ int mptcp_nl_cmd_sf_create(struct sk_buff *skb, struct genl_info *info)
 
 	if (addr_l.id == 0) {
 		NL_SET_ERR_MSG_ATTR(info->extack, laddr, "missing local addr id");
+		err = -EINVAL;
 		goto create_err;
 	}
 
@@ -395,11 +397,13 @@ int mptcp_nl_cmd_sf_destroy(struct sk_buff *skb, struct genl_info *info)
 
 	if (addr_l.family != addr_r.family) {
 		GENL_SET_ERR_MSG(info, "address families do not match");
+		err = -EINVAL;
 		goto destroy_err;
 	}
 
 	if (!addr_l.port || !addr_r.port) {
 		GENL_SET_ERR_MSG(info, "missing local or remote port");
+		err = -EINVAL;
 		goto destroy_err;
 	}
 
-- 
2.38.1

