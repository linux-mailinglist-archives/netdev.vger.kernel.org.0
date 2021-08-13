Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F5B23EBE33
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 00:16:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235210AbhHMWQb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 18:16:31 -0400
Received: from mga11.intel.com ([192.55.52.93]:29030 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235032AbhHMWQX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Aug 2021 18:16:23 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10075"; a="212520900"
X-IronPort-AV: E=Sophos;i="5.84,320,1620716400"; 
   d="scan'208";a="212520900"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2021 15:15:55 -0700
X-IronPort-AV: E=Sophos;i="5.84,320,1620716400"; 
   d="scan'208";a="504320455"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.69.245])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2021 15:15:54 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 4/8] mptcp: cleanup sysctl data and helpers
Date:   Fri, 13 Aug 2021 15:15:44 -0700
Message-Id: <20210813221548.111990-5-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210813221548.111990-1-mathew.j.martineau@linux.intel.com>
References: <20210813221548.111990-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

Reorder the data in mptcp_pernet to avoid wasting space
with no reasons and constify the access helpers.

No functional changes intended.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/ctrl.c     | 12 ++++++------
 net/mptcp/protocol.h |  8 ++++----
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/net/mptcp/ctrl.c b/net/mptcp/ctrl.c
index 7d738bd06f2c..63bba9d8e289 100644
--- a/net/mptcp/ctrl.c
+++ b/net/mptcp/ctrl.c
@@ -21,33 +21,33 @@ struct mptcp_pernet {
 	struct ctl_table_header *ctl_table_hdr;
 #endif
 
-	u8 mptcp_enabled;
 	unsigned int add_addr_timeout;
+	u8 mptcp_enabled;
 	u8 checksum_enabled;
 	u8 allow_join_initial_addr_port;
 };
 
-static struct mptcp_pernet *mptcp_get_pernet(struct net *net)
+static struct mptcp_pernet *mptcp_get_pernet(const struct net *net)
 {
 	return net_generic(net, mptcp_pernet_id);
 }
 
-int mptcp_is_enabled(struct net *net)
+int mptcp_is_enabled(const struct net *net)
 {
 	return mptcp_get_pernet(net)->mptcp_enabled;
 }
 
-unsigned int mptcp_get_add_addr_timeout(struct net *net)
+unsigned int mptcp_get_add_addr_timeout(const struct net *net)
 {
 	return mptcp_get_pernet(net)->add_addr_timeout;
 }
 
-int mptcp_is_checksum_enabled(struct net *net)
+int mptcp_is_checksum_enabled(const struct net *net)
 {
 	return mptcp_get_pernet(net)->checksum_enabled;
 }
 
-int mptcp_allow_join_id0(struct net *net)
+int mptcp_allow_join_id0(const struct net *net)
 {
 	return mptcp_get_pernet(net)->allow_join_initial_addr_port;
 }
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 6f55784a2efd..43ff6c5baddc 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -556,10 +556,10 @@ static inline void mptcp_subflow_delegated_done(struct mptcp_subflow_context *su
 	clear_bit(MPTCP_DELEGATE_SEND, &subflow->delegated_status);
 }
 
-int mptcp_is_enabled(struct net *net);
-unsigned int mptcp_get_add_addr_timeout(struct net *net);
-int mptcp_is_checksum_enabled(struct net *net);
-int mptcp_allow_join_id0(struct net *net);
+int mptcp_is_enabled(const struct net *net);
+unsigned int mptcp_get_add_addr_timeout(const struct net *net);
+int mptcp_is_checksum_enabled(const struct net *net);
+int mptcp_allow_join_id0(const struct net *net);
 void mptcp_subflow_fully_established(struct mptcp_subflow_context *subflow,
 				     struct mptcp_options_received *mp_opt);
 bool __mptcp_retransmit_pending_data(struct sock *sk);
-- 
2.32.0

