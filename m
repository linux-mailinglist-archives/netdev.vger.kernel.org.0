Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B957662FCF4
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 19:46:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235438AbiKRSqT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 13:46:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242538AbiKRSqQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 13:46:16 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B37108FB02
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 10:46:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668797175; x=1700333175;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=W4JEU4Lb4cxuCiSU7pc8DfutGIIeuWjfS0GfiBOJA8E=;
  b=KUzLZkaB3zrXcctIZtEyYBdqVW/oF1XxuYOOp8sQqSTrglKZe124tnaP
   np3Oo91ilW2DHMGMx6yJhyXg2ZpIW9a3Zisgk86Dp1mCpLEhMy2MeENfJ
   HggaIzRWTQRd54x1F8CTmIEJQN5NX6gjlggdKt55rcGmvV3HbO6lsI9QG
   YjtaIykgwkgreWHmkslqZVlmSZULSbSRzfn3KeL61YPOkEM/efy9L0FLo
   p5ZJgpCytwSCukPwFFIRBOlVpV3hWU+Pm5F9g1eq9y95QixKhAvT458zx
   19ZFQIOVWb7EkYEnV33ZaFHlK0mrhV2aPmLgEGN0oYYWUa228PwF4DeNG
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10535"; a="375342843"
X-IronPort-AV: E=Sophos;i="5.96,175,1665471600"; 
   d="scan'208";a="375342843"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2022 10:46:14 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10535"; a="746102229"
X-IronPort-AV: E=Sophos;i="5.96,175,1665471600"; 
   d="scan'208";a="746102229"
Received: from mjenkins-mobl.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.47.242])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2022 10:46:14 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        kuba@kernel.org, edumazet@google.com, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 2/2] mptcp: more detailed error reporting on endpoint creation
Date:   Fri, 18 Nov 2022 10:46:08 -0800
Message-Id: <20221118184608.187932-3-mathew.j.martineau@linux.intel.com>
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

Endpoint creation can fail for a number of reasons; in case of failure
append the error number to the extended ack message, using a newly
introduced generic helper.

Additionally let mptcp_pm_nl_append_new_local_addr() report different
error reasons.

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 include/net/genetlink.h |  3 +++
 net/mptcp/pm_netlink.c  | 24 +++++++++++++-----------
 2 files changed, 16 insertions(+), 11 deletions(-)

diff --git a/include/net/genetlink.h b/include/net/genetlink.h
index d21210709f84..ed4622dd4828 100644
--- a/include/net/genetlink.h
+++ b/include/net/genetlink.h
@@ -125,6 +125,9 @@ static inline void genl_info_net_set(struct genl_info *info, struct net *net)
 
 #define GENL_SET_ERR_MSG(info, msg) NL_SET_ERR_MSG((info)->extack, msg)
 
+#define GENL_SET_ERR_MSG_FMT(info, msg, args...) \
+	NL_SET_ERR_MSG_FMT((info)->extack, msg, ##args)
+
 /* Report that a root attribute is missing */
 #define GENL_REQ_ATTR_CHECK(info, attr) ({				\
 	struct genl_info *__info = (info);				\
diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index fdf2ee29f762..d66fbd558263 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -912,10 +912,14 @@ static int mptcp_pm_nl_append_new_local_addr(struct pm_nl_pernet *pernet,
 	 */
 	if (pernet->next_id == MPTCP_PM_MAX_ADDR_ID)
 		pernet->next_id = 1;
-	if (pernet->addrs >= MPTCP_PM_ADDR_MAX)
+	if (pernet->addrs >= MPTCP_PM_ADDR_MAX) {
+		ret = -ERANGE;
 		goto out;
-	if (test_bit(entry->addr.id, pernet->id_bitmap))
+	}
+	if (test_bit(entry->addr.id, pernet->id_bitmap)) {
+		ret = -EBUSY;
 		goto out;
+	}
 
 	/* do not insert duplicate address, differentiate on port only
 	 * singled addresses
@@ -929,8 +933,10 @@ static int mptcp_pm_nl_append_new_local_addr(struct pm_nl_pernet *pernet,
 			 * endpoint is an implicit one and the user-space
 			 * did not provide an endpoint id
 			 */
-			if (!(cur->flags & MPTCP_PM_ADDR_FLAG_IMPLICIT))
+			if (!(cur->flags & MPTCP_PM_ADDR_FLAG_IMPLICIT)) {
+				ret = -EEXIST;
 				goto out;
+			}
 			if (entry->addr.id)
 				goto out;
 
@@ -1016,16 +1022,12 @@ static int mptcp_pm_nl_create_listen_socket(struct sock *sk,
 		addrlen = sizeof(struct sockaddr_in6);
 #endif
 	err = kernel_bind(ssock, (struct sockaddr *)&addr, addrlen);
-	if (err) {
-		pr_warn("kernel_bind error, err=%d", err);
+	if (err)
 		return err;
-	}
 
 	err = kernel_listen(ssock, backlog);
-	if (err) {
-		pr_warn("kernel_listen error, err=%d", err);
+	if (err)
 		return err;
-	}
 
 	return 0;
 }
@@ -1329,13 +1331,13 @@ static int mptcp_nl_cmd_add_addr(struct sk_buff *skb, struct genl_info *info)
 	if (entry->addr.port) {
 		ret = mptcp_pm_nl_create_listen_socket(skb->sk, entry);
 		if (ret) {
-			GENL_SET_ERR_MSG(info, "create listen socket error");
+			GENL_SET_ERR_MSG_FMT(info, "create listen socket error: %d", ret);
 			goto out_free;
 		}
 	}
 	ret = mptcp_pm_nl_append_new_local_addr(pernet, entry);
 	if (ret < 0) {
-		GENL_SET_ERR_MSG(info, "too many addresses or duplicate one");
+		GENL_SET_ERR_MSG_FMT(info, "too many addresses or duplicate one: %d", ret);
 		goto out_free;
 	}
 
-- 
2.38.1

