Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7481739394D
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 01:31:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236485AbhE0Xd1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 19:33:27 -0400
Received: from mga18.intel.com ([134.134.136.126]:8585 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235371AbhE0XdU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 May 2021 19:33:20 -0400
IronPort-SDR: H3+HAAmy+0VWum8IsZYTzoLSdMIomxenVHj2Hz1n3OytUc/qhc8bxgBe7Y6hn3qy880BISJHEP
 D2zP8NUzjpmg==
X-IronPort-AV: E=McAfee;i="6200,9189,9997"; a="190227179"
X-IronPort-AV: E=Sophos;i="5.83,228,1616482800"; 
   d="scan'208";a="190227179"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2021 16:31:45 -0700
IronPort-SDR: kH00Y9shY11yaf6vp9N3dNmq0fzho3qCBxEzQkqscO5w238UO3/42SQDRfqrzkmquSTFN1npzy
 q3Xnhq181D8A==
X-IronPort-AV: E=Sophos;i="5.83,228,1616482800"; 
   d="scan'208";a="477700331"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.84.136])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2021 16:31:45 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net 1/4] mptcp: fix sk_forward_memory corruption on retransmission
Date:   Thu, 27 May 2021 16:31:37 -0700
Message-Id: <20210527233140.182728-2-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210527233140.182728-1-mathew.j.martineau@linux.intel.com>
References: <20210527233140.182728-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

MPTCP sk_forward_memory handling is a bit special, as such field
is protected by the msk socket spin_lock, instead of the plain
socket lock.

Currently we have a code path updating such field without handling
the relevant lock:

__mptcp_retrans() -> __mptcp_clean_una_wakeup()

Several helpers in __mptcp_clean_una_wakeup() will update
sk_forward_alloc, possibly causing such field corruption, as reported
by Matthieu.

Address the issue providing and using a new variant of blamed function
which explicitly acquires the msk spin lock.

Fixes: 64b9cea7a0af ("mptcp: fix spurious retransmissions")
Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/172
Reported-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Tested-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/protocol.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 2bc199549a88..5edc686faff1 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -947,6 +947,10 @@ static void __mptcp_update_wmem(struct sock *sk)
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
 
+#ifdef CONFIG_LOCKDEP
+	WARN_ON_ONCE(!lockdep_is_held(&sk->sk_lock.slock));
+#endif
+
 	if (!msk->wmem_reserved)
 		return;
 
@@ -1085,10 +1089,20 @@ static void __mptcp_clean_una(struct sock *sk)
 
 static void __mptcp_clean_una_wakeup(struct sock *sk)
 {
+#ifdef CONFIG_LOCKDEP
+	WARN_ON_ONCE(!lockdep_is_held(&sk->sk_lock.slock));
+#endif
 	__mptcp_clean_una(sk);
 	mptcp_write_space(sk);
 }
 
+static void mptcp_clean_una_wakeup(struct sock *sk)
+{
+	mptcp_data_lock(sk);
+	__mptcp_clean_una_wakeup(sk);
+	mptcp_data_unlock(sk);
+}
+
 static void mptcp_enter_memory_pressure(struct sock *sk)
 {
 	struct mptcp_subflow_context *subflow;
@@ -2299,7 +2313,7 @@ static void __mptcp_retrans(struct sock *sk)
 	struct sock *ssk;
 	int ret;
 
-	__mptcp_clean_una_wakeup(sk);
+	mptcp_clean_una_wakeup(sk);
 	dfrag = mptcp_rtx_head(sk);
 	if (!dfrag) {
 		if (mptcp_data_fin_enabled(msk)) {
-- 
2.31.1

