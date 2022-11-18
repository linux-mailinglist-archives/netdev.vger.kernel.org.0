Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D9BB62FCF3
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 19:46:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242594AbiKRSqR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 13:46:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235438AbiKRSqQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 13:46:16 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D5748F3FD
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 10:46:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668797175; x=1700333175;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=C/N7njNkgP481j3Xh1uyhGw0c8vyZaLSJFZeI2cSHso=;
  b=msD8CNgidkPej2QBQDFv7uI490TXJoMH+sW27z5N3psmqenUHlEJqUrs
   SdI6fYWKDRKvJ9CHN8efv97/KGmXHUNu0sFhxTZ/yDeyVhLbuEhhTkowI
   BN3TJJh8JRTLdPa9/f5j0TAgKkUdFsiV91BHI2FR7t5Pm2h/LtztEOoYe
   CdPoQCnG++iSMqL4As63PEwid7Ns2DHcYx/cF+3etBeDm22Z+uXDBsmOq
   cmYL+NsnXAX8TMn9peFGvIBuOtiVnCWN6R3Gc43XDSG/mLjd3F4s4IX6Y
   xPCxiIv4HRQlRNiXAvrJg5Dp67t5Sdbw/MItSoRZ9/INCzxd5IGIHM6h/
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10535"; a="375342842"
X-IronPort-AV: E=Sophos;i="5.96,175,1665471600"; 
   d="scan'208";a="375342842"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2022 10:46:14 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10535"; a="746102227"
X-IronPort-AV: E=Sophos;i="5.96,175,1665471600"; 
   d="scan'208";a="746102227"
Received: from mjenkins-mobl.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.47.242])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2022 10:46:13 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        kuba@kernel.org, edumazet@google.com, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 1/2] mptcp: deduplicate error paths on endpoint creation
Date:   Fri, 18 Nov 2022 10:46:07 -0800
Message-Id: <20221118184608.187932-2-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221118184608.187932-1-mathew.j.martineau@linux.intel.com>
References: <20221118184608.187932-1-mathew.j.martineau@linux.intel.com>
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

From: Paolo Abeni <pabeni@redhat.com>

When endpoint creation fails, we need to free the newly allocated
entry and eventually destroy the paired mptcp listener socket.

Consolidate such action in a single point let all the errors path
reach it.

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/pm_netlink.c | 35 +++++++++++++----------------------
 1 file changed, 13 insertions(+), 22 deletions(-)

diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index 9813ed0fde9b..fdf2ee29f762 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -1003,16 +1003,12 @@ static int mptcp_pm_nl_create_listen_socket(struct sock *sk,
 		return err;
 
 	msk = mptcp_sk(entry->lsk->sk);
-	if (!msk) {
-		err = -EINVAL;
-		goto out;
-	}
+	if (!msk)
+		return -EINVAL;
 
 	ssock = __mptcp_nmpc_socket(msk);
-	if (!ssock) {
-		err = -EINVAL;
-		goto out;
-	}
+	if (!ssock)
+		return -EINVAL;
 
 	mptcp_info2sockaddr(&entry->addr, &addr, entry->addr.family);
 #if IS_ENABLED(CONFIG_MPTCP_IPV6)
@@ -1022,20 +1018,16 @@ static int mptcp_pm_nl_create_listen_socket(struct sock *sk,
 	err = kernel_bind(ssock, (struct sockaddr *)&addr, addrlen);
 	if (err) {
 		pr_warn("kernel_bind error, err=%d", err);
-		goto out;
+		return err;
 	}
 
 	err = kernel_listen(ssock, backlog);
 	if (err) {
 		pr_warn("kernel_listen error, err=%d", err);
-		goto out;
+		return err;
 	}
 
 	return 0;
-
-out:
-	sock_release(entry->lsk);
-	return err;
 }
 
 int mptcp_pm_nl_get_local_id(struct mptcp_sock *msk, struct sock_common *skc)
@@ -1327,7 +1319,7 @@ static int mptcp_nl_cmd_add_addr(struct sk_buff *skb, struct genl_info *info)
 		return -EINVAL;
 	}
 
-	entry = kmalloc(sizeof(*entry), GFP_KERNEL_ACCOUNT);
+	entry = kzalloc(sizeof(*entry), GFP_KERNEL_ACCOUNT);
 	if (!entry) {
 		GENL_SET_ERR_MSG(info, "can't allocate addr");
 		return -ENOMEM;
@@ -1338,22 +1330,21 @@ static int mptcp_nl_cmd_add_addr(struct sk_buff *skb, struct genl_info *info)
 		ret = mptcp_pm_nl_create_listen_socket(skb->sk, entry);
 		if (ret) {
 			GENL_SET_ERR_MSG(info, "create listen socket error");
-			kfree(entry);
-			return ret;
+			goto out_free;
 		}
 	}
 	ret = mptcp_pm_nl_append_new_local_addr(pernet, entry);
 	if (ret < 0) {
 		GENL_SET_ERR_MSG(info, "too many addresses or duplicate one");
-		if (entry->lsk)
-			sock_release(entry->lsk);
-		kfree(entry);
-		return ret;
+		goto out_free;
 	}
 
 	mptcp_nl_add_subflow_or_signal_addr(sock_net(skb->sk));
-
 	return 0;
+
+out_free:
+	__mptcp_pm_release_addr_entry(entry);
+	return ret;
 }
 
 int mptcp_pm_get_flags_and_ifindex_by_id(struct mptcp_sock *msk, unsigned int id,
-- 
2.38.1

