Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C189DC94F8
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 01:39:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729259AbfJBXht (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 19:37:49 -0400
Received: from mga04.intel.com ([192.55.52.120]:16479 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729166AbfJBXhl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Oct 2019 19:37:41 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Oct 2019 16:37:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,250,1566889200"; 
   d="scan'208";a="366862628"
Received: from mjmartin-nuc02.mjmartin-nuc02 (HELO mjmartin-nuc02.sea.intel.com) ([10.251.30.230])
  by orsmga005.jf.intel.com with ESMTP; 02 Oct 2019 16:37:23 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org, edumazet@google.com
Cc:     Peter Krystad <peter.krystad@linux.intel.com>, cpaasch@apple.com,
        fw@strlen.de, pabeni@redhat.com, dcaratti@redhat.com,
        matthieu.baerts@tessares.net
Subject: [RFC PATCH v2 33/45] mptcp: Implement path manager interface commands
Date:   Wed,  2 Oct 2019 16:36:43 -0700
Message-Id: <20191002233655.24323-34-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191002233655.24323-1-mathew.j.martineau@linux.intel.com>
References: <20191002233655.24323-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peter Krystad <peter.krystad@linux.intel.com>

Use the addr_signal flag to indicate to the subflow layer
that a local address may be announced, and call subflow_connect()
to initiate a secondary subflow.

Signed-off-by: Peter Krystad <peter.krystad@linux.intel.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/mptcp/pm.c | 63 +++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 60 insertions(+), 3 deletions(-)

diff --git a/net/mptcp/pm.c b/net/mptcp/pm.c
index 933dd805c9b2..7c7c00f9f7e8 100644
--- a/net/mptcp/pm.c
+++ b/net/mptcp/pm.c
@@ -13,17 +13,74 @@
 int pm_announce_addr(u32 token, sa_family_t family, u8 local_id,
 		     struct in_addr *addr)
 {
-	return -ENOTSUPP;
+	struct mptcp_sock *msk = mptcp_token_get_sock(token);
+	int err = 0;
+
+	if (!msk)
+		return -EINVAL;
+
+	if (msk->pm.local_valid) {
+		err = -EBADR;
+		goto announce_put;
+	}
+
+	pr_debug("msk=%p, local_id=%d, addr=%x", msk, local_id, addr->s_addr);
+	msk->pm.local_valid = 1;
+	msk->pm.local_id = local_id;
+	msk->pm.local_family = family;
+	msk->pm.local_addr.s_addr = addr->s_addr;
+	msk->addr_signal = 1;
+
+announce_put:
+	sock_put((struct sock *)msk);
+	return err;
 }
 
 int pm_remove_addr(u32 token, u8 local_id)
 {
-	return -ENOTSUPP;
+	struct mptcp_sock *msk = mptcp_token_get_sock(token);
+
+	if (!msk)
+		return -EINVAL;
+
+	pr_debug("msk=%p", msk);
+	msk->pm.local_valid = 0;
+
+	sock_put((struct sock *)msk);
+	return 0;
 }
 
 int pm_create_subflow(u32 token, u8 remote_id)
 {
-	return -ENOTSUPP;
+	struct mptcp_sock *msk = mptcp_token_get_sock(token);
+	struct sockaddr_in remote;
+	struct sockaddr_in local;
+	int err;
+
+	if (!msk)
+		return -EINVAL;
+
+	pr_debug("msk=%p", msk);
+
+	if (!msk->pm.remote_valid || remote_id != msk->pm.remote_id) {
+		err = -EBADR;
+		goto create_put;
+	}
+
+	local.sin_family = AF_INET;
+	local.sin_port = 0;
+	local.sin_addr.s_addr = htonl(INADDR_ANY);
+
+	remote.sin_family = msk->pm.remote_family;
+	remote.sin_port = htons(msk->dport);
+	remote.sin_addr.s_addr = msk->pm.remote_addr.s_addr;
+
+	err = mptcp_subflow_connect((struct sock *)msk, &local, &remote,
+				    remote_id);
+
+create_put:
+	sock_put((struct sock *)msk);
+	return err;
 }
 
 int pm_remove_subflow(u32 token, u8 remote_id)
-- 
2.23.0

