Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6B063100A4
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 00:29:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230106AbhBDX1X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 18:27:23 -0500
Received: from mga02.intel.com ([134.134.136.20]:57600 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230152AbhBDX1I (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Feb 2021 18:27:08 -0500
IronPort-SDR: vPJ0rznlnDm16wmZSdxmEnJdBoy6WQAasb3hLWJCh8b9bkjV/BneePGVj1ZeNzvzo3/TlwsNcV
 4CLXYQzkBw+Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9885"; a="168462976"
X-IronPort-AV: E=Sophos;i="5.81,153,1610438400"; 
   d="scan'208";a="168462976"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2021 15:23:37 -0800
IronPort-SDR: HIUb5L6ElQMAa5KXGgCP5zuq/M0tFCOXgV3Xl0cp1IOfJOnyPwCHlY+l+cwVc4U0o3oTawLvO5
 ZbZSAVWY66Aw==
X-IronPort-AV: E=Sophos;i="5.81,153,1610438400"; 
   d="scan'208";a="415560537"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.255.231.23])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2021 15:23:37 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>, davem@davemloft.net,
        kuba@kernel.org, mptcp@lists.01.org, matthieu.baerts@tessares.net,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 2/2] mptcp: pm: add lockdep assertions
Date:   Thu,  4 Feb 2021 15:23:30 -0800
Message-Id: <20210204232330.202441-3-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210204232330.202441-1-mathew.j.martineau@linux.intel.com>
References: <20210204232330.202441-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Add a few assertions to make sure functions are called with the needed
locks held.
Two functions gain might_sleep annotations because they contain
conditional calls to functions that sleep.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/pm.c         |  2 ++
 net/mptcp/pm_netlink.c | 13 +++++++++++++
 net/mptcp/protocol.c   |  4 ++++
 net/mptcp/protocol.h   |  5 +++++
 4 files changed, 24 insertions(+)

diff --git a/net/mptcp/pm.c b/net/mptcp/pm.c
index 3a22e73220b9..1a25003fd8e3 100644
--- a/net/mptcp/pm.c
+++ b/net/mptcp/pm.c
@@ -20,6 +20,8 @@ int mptcp_pm_announce_addr(struct mptcp_sock *msk,
 
 	pr_debug("msk=%p, local_id=%d", msk, addr->id);
 
+	lockdep_assert_held(&msk->pm.lock);
+
 	if (add_addr) {
 		pr_warn("addr_signal error, add_addr=%d", add_addr);
 		return -EINVAL;
diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index e7b1abb4f0c2..23780a13b934 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -145,6 +145,8 @@ select_local_address(const struct pm_nl_pernet *pernet,
 	struct mptcp_pm_addr_entry *entry, *ret = NULL;
 	struct sock *sk = (struct sock *)msk;
 
+	msk_owned_by_me(msk);
+
 	rcu_read_lock();
 	__mptcp_flush_join_list(msk);
 	list_for_each_entry_rcu(entry, &pernet->local_addr_list, list) {
@@ -246,6 +248,8 @@ lookup_anno_list_by_saddr(struct mptcp_sock *msk,
 {
 	struct mptcp_pm_add_entry *entry;
 
+	lockdep_assert_held(&msk->pm.lock);
+
 	list_for_each_entry(entry, &msk->pm.anno_list, list) {
 		if (addresses_equal(&entry->addr, addr, true))
 			return entry;
@@ -342,6 +346,8 @@ static bool mptcp_pm_alloc_anno_list(struct mptcp_sock *msk,
 	struct sock *sk = (struct sock *)msk;
 	struct net *net = sock_net(sk);
 
+	lockdep_assert_held(&msk->pm.lock);
+
 	if (lookup_anno_list_by_saddr(msk, &entry->addr))
 		return false;
 
@@ -496,6 +502,9 @@ void mptcp_pm_nl_add_addr_send_ack(struct mptcp_sock *msk)
 {
 	struct mptcp_subflow_context *subflow;
 
+	msk_owned_by_me(msk);
+	lockdep_assert_held(&msk->pm.lock);
+
 	if (!mptcp_pm_should_add_signal(msk))
 		return;
 
@@ -566,6 +575,8 @@ void mptcp_pm_nl_rm_addr_received(struct mptcp_sock *msk)
 
 	pr_debug("address rm_id %d", msk->pm.rm_id);
 
+	msk_owned_by_me(msk);
+
 	if (!msk->pm.rm_id)
 		return;
 
@@ -601,6 +612,8 @@ void mptcp_pm_nl_rm_subflow_received(struct mptcp_sock *msk, u8 rm_id)
 
 	pr_debug("subflow rm_id %d", rm_id);
 
+	msk_owned_by_me(msk);
+
 	if (!rm_id)
 		return;
 
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 1405e146dd7c..b9f16a1535d2 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2187,6 +2187,8 @@ static void __mptcp_close_subflow(struct mptcp_sock *msk)
 {
 	struct mptcp_subflow_context *subflow, *tmp;
 
+	might_sleep();
+
 	list_for_each_entry_safe(subflow, tmp, &msk->conn_list, node) {
 		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
 
@@ -2529,6 +2531,8 @@ static void __mptcp_destroy_sock(struct sock *sk)
 
 	pr_debug("msk=%p", msk);
 
+	might_sleep();
+
 	/* dispose the ancillatory tcp socket, if any */
 	if (msk->subflow) {
 		iput(SOCK_INODE(msk->subflow));
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 1cc7948a1826..73a923d02aad 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -288,6 +288,11 @@ struct mptcp_sock {
 #define mptcp_for_each_subflow(__msk, __subflow)			\
 	list_for_each_entry(__subflow, &((__msk)->conn_list), node)
 
+static inline void msk_owned_by_me(const struct mptcp_sock *msk)
+{
+	sock_owned_by_me((const struct sock *)msk);
+}
+
 static inline struct mptcp_sock *mptcp_sk(const struct sock *sk)
 {
 	return (struct mptcp_sock *)sk;
-- 
2.30.0

