Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CD9C647AE6
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 01:44:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229756AbiLIAok (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 19:44:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229692AbiLIAoj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 19:44:39 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08ECB51332
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 16:44:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670546678; x=1702082678;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=msV/M1wz+UVrq7h8FdkC4OUJp8FGohM+zY3ESmWi5ts=;
  b=Xk5ZFfp+Lm3GQcHr8A66NdXZetU3tOYTiUYYTo1OCwUrUPIGxra06U2r
   WFdlT4GFhtXM9A3lRoNCQbl3rMzXTGtu2RtmsVcpYD78PFOlfyiDz4K8s
   d9ajxuJgKWZDjCRE+vT6DxMNnabAa8yiJNuY0qFcPbgNyiC1aUvy2CJmr
   A4sNE79fsrS9qmT9tdYqPDB+hdss07BklSVjGzSSPQPkcsirjYJ3c9jz0
   1JxmF6qY45SJBioriSVK5Tue+Z1WkFNisc6H95y8ARDvzl1PxFBsc8jca
   lZGJF8P2H3afIWfH9LeswdZ1Homp7ADh7V9ljJiD0x4FPTft3T8Mvi2Fv
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="317367581"
X-IronPort-AV: E=Sophos;i="5.96,228,1665471600"; 
   d="scan'208";a="317367581"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 16:44:37 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="736027002"
X-IronPort-AV: E=Sophos;i="5.96,228,1665471600"; 
   d="scan'208";a="736027002"
Received: from mchombea-mobl1.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.102.119])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 16:44:37 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliang.tang@suse.com>, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        matthieu.baerts@tessares.net, mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 1/2] mptcp: use nlmsg_free instead of kfree_skb
Date:   Thu,  8 Dec 2022 16:44:30 -0800
Message-Id: <20221209004431.143701-2-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221209004431.143701-1-mathew.j.martineau@linux.intel.com>
References: <20221209004431.143701-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliang.tang@suse.com>

Use nlmsg_free() instead of kfree_skb() in pm_netlink.c.

The SKB's have been created by nlmsg_new(). The proper cleaning way
should then be done with nlmsg_free().

For the moment, nlmsg_free() is simply calling kfree_skb() so we don't
change the behaviour here.

Suggested-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Geliang Tang <geliang.tang@suse.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/pm_netlink.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index eef69d0e44ec..08c65f3e70a3 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -2094,7 +2094,7 @@ void mptcp_event_addr_removed(const struct mptcp_sock *msk, uint8_t id)
 	return;
 
 nla_put_failure:
-	kfree_skb(skb);
+	nlmsg_free(skb);
 }
 
 void mptcp_event_addr_announced(const struct sock *ssk,
@@ -2151,7 +2151,7 @@ void mptcp_event_addr_announced(const struct sock *ssk,
 	return;
 
 nla_put_failure:
-	kfree_skb(skb);
+	nlmsg_free(skb);
 }
 
 void mptcp_event_pm_listener(const struct sock *ssk,
@@ -2203,7 +2203,7 @@ void mptcp_event_pm_listener(const struct sock *ssk,
 	return;
 
 nla_put_failure:
-	kfree_skb(skb);
+	nlmsg_free(skb);
 }
 
 void mptcp_event(enum mptcp_event_type type, const struct mptcp_sock *msk,
@@ -2261,7 +2261,7 @@ void mptcp_event(enum mptcp_event_type type, const struct mptcp_sock *msk,
 	return;
 
 nla_put_failure:
-	kfree_skb(skb);
+	nlmsg_free(skb);
 }
 
 static const struct genl_small_ops mptcp_pm_ops[] = {
-- 
2.38.1

