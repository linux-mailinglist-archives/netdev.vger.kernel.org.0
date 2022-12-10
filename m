Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 965FD648B9E
	for <lists+netdev@lfdr.de>; Sat, 10 Dec 2022 01:28:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229899AbiLJA2X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 19:28:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229888AbiLJA2V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 19:28:21 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8492C3B9DA;
        Fri,  9 Dec 2022 16:28:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670632099; x=1702168099;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=392xy3qeqV/0GjxZ+l2BKrtd7OV9XUwT6YiWL1F55gU=;
  b=PzvtAQHGEB2BGMLBJ17gRCqg5+ijqMcVcBsvTXr9Evj8qxKbJXGEAeVc
   bE89RZXSaJk/dH6v2LaHV9nKhQaAfOIUrfOsPV142FCysLHigmDTHe9pW
   tdlVEdNNFuFmg+6X4bpnOnHhDAGl3ZZB/pfZoZDnf6uUF0AMapAkqsKI+
   zpXqbob10JHZ+TggeG9uKdeS5twtyq72cvtg94fU5i3s61kP9HQCrc+Pc
   xZehKlvLsop0Jk5mtGFPqgFNoOd5R2BacsA1Glm5quk0l9+UbmC+7WFUn
   HA4VQznfDPskja+3Wp1XqTO6yx0xXxAos/qLqyCqiC3b2C53UGCIlWEGl
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10556"; a="381879123"
X-IronPort-AV: E=Sophos;i="5.96,232,1665471600"; 
   d="scan'208";a="381879123"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2022 16:28:18 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10556"; a="649728876"
X-IronPort-AV: E=Sophos;i="5.96,232,1665471600"; 
   d="scan'208";a="649728876"
Received: from hthiagar-mobl1.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.231.121])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2022 16:28:17 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Matthieu Baerts <matthieu.baerts@tessares.net>,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, fw@strlen.de, kishen.maloor@intel.com,
        dcaratti@redhat.com, mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        stable@vger.kernel.org
Subject: [PATCH net 2/4] mptcp: remove MPTCP 'ifdef' in TCP SYN cookies
Date:   Fri,  9 Dec 2022 16:28:08 -0800
Message-Id: <20221210002810.289674-3-mathew.j.martineau@linux.intel.com>
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

From: Matthieu Baerts <matthieu.baerts@tessares.net>

To ease the maintenance, it is often recommended to avoid having #ifdef
preprocessor conditions.

Here the section related to CONFIG_MPTCP was quite short but the next
commit needs to add more code around. It is then cleaner to move
specific MPTCP code to functions located in net/mptcp directory.

Now that mptcp_subflow_request_sock_ops structure can be static, it can
also be marked as "read only after init".

Suggested-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc: stable@vger.kernel.org
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 include/net/mptcp.h   | 12 ++++++++++--
 net/ipv4/syncookies.c |  7 +++----
 net/mptcp/subflow.c   | 12 +++++++++++-
 3 files changed, 24 insertions(+), 7 deletions(-)

diff --git a/include/net/mptcp.h b/include/net/mptcp.h
index 412479ebf5ad..3c5c68618fcc 100644
--- a/include/net/mptcp.h
+++ b/include/net/mptcp.h
@@ -97,8 +97,6 @@ struct mptcp_out_options {
 };
 
 #ifdef CONFIG_MPTCP
-extern struct request_sock_ops mptcp_subflow_request_sock_ops;
-
 void mptcp_init(void);
 
 static inline bool sk_is_mptcp(const struct sock *sk)
@@ -188,6 +186,9 @@ void mptcp_seq_show(struct seq_file *seq);
 int mptcp_subflow_init_cookie_req(struct request_sock *req,
 				  const struct sock *sk_listener,
 				  struct sk_buff *skb);
+struct request_sock *mptcp_subflow_reqsk_alloc(const struct request_sock_ops *ops,
+					       struct sock *sk_listener,
+					       bool attach_listener);
 
 __be32 mptcp_get_reset_option(const struct sk_buff *skb);
 
@@ -274,6 +275,13 @@ static inline int mptcp_subflow_init_cookie_req(struct request_sock *req,
 	return 0; /* TCP fallback */
 }
 
+static inline struct request_sock *mptcp_subflow_reqsk_alloc(const struct request_sock_ops *ops,
+							     struct sock *sk_listener,
+							     bool attach_listener)
+{
+	return NULL;
+}
+
 static inline __be32 mptcp_reset_option(const struct sk_buff *skb)  { return htonl(0u); }
 #endif /* CONFIG_MPTCP */
 
diff --git a/net/ipv4/syncookies.c b/net/ipv4/syncookies.c
index 942d2dfa1115..26fb97d1d4d9 100644
--- a/net/ipv4/syncookies.c
+++ b/net/ipv4/syncookies.c
@@ -288,12 +288,11 @@ struct request_sock *cookie_tcp_reqsk_alloc(const struct request_sock_ops *ops,
 	struct tcp_request_sock *treq;
 	struct request_sock *req;
 
-#ifdef CONFIG_MPTCP
 	if (sk_is_mptcp(sk))
-		ops = &mptcp_subflow_request_sock_ops;
-#endif
+		req = mptcp_subflow_reqsk_alloc(ops, sk, false);
+	else
+		req = inet_reqsk_alloc(ops, sk, false);
 
-	req = inet_reqsk_alloc(ops, sk, false);
 	if (!req)
 		return NULL;
 
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 2159b5f9988f..3f670f2d5c5c 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -529,7 +529,7 @@ static int subflow_v6_rebuild_header(struct sock *sk)
 }
 #endif
 
-struct request_sock_ops mptcp_subflow_request_sock_ops;
+static struct request_sock_ops mptcp_subflow_request_sock_ops __ro_after_init;
 static struct tcp_request_sock_ops subflow_request_sock_ipv4_ops __ro_after_init;
 
 static int subflow_v4_conn_request(struct sock *sk, struct sk_buff *skb)
@@ -582,6 +582,16 @@ static int subflow_v6_conn_request(struct sock *sk, struct sk_buff *skb)
 }
 #endif
 
+struct request_sock *mptcp_subflow_reqsk_alloc(const struct request_sock_ops *ops,
+					       struct sock *sk_listener,
+					       bool attach_listener)
+{
+	ops = &mptcp_subflow_request_sock_ops;
+
+	return inet_reqsk_alloc(ops, sk_listener, attach_listener);
+}
+EXPORT_SYMBOL(mptcp_subflow_reqsk_alloc);
+
 /* validate hmac received in third ACK */
 static bool subflow_hmac_valid(const struct request_sock *req,
 			       const struct mptcp_options_received *mp_opt)
-- 
2.38.1

