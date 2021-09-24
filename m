Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE27F417CE3
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 23:12:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348572AbhIXVO3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 17:14:29 -0400
Received: from mga04.intel.com ([192.55.52.120]:53073 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347064AbhIXVOV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Sep 2021 17:14:21 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10117"; a="222280917"
X-IronPort-AV: E=Sophos;i="5.85,321,1624345200"; 
   d="scan'208";a="222280917"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2021 14:12:46 -0700
X-IronPort-AV: E=Sophos;i="5.85,321,1624345200"; 
   d="scan'208";a="704320285"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.52.210])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2021 14:12:45 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 3/5] mptcp: use lockdep_assert_held_once() instead of open-coding it
Date:   Fri, 24 Sep 2021 14:12:36 -0700
Message-Id: <20210924211238.162509-4-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924211238.162509-1-mathew.j.martineau@linux.intel.com>
References: <20210924211238.162509-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

We have a few more places where the mptcp code duplicates
lockdep_assert_held_once(). Let's use the existing macro and
avoid a bunch of compiler's conditional.

Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/protocol.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 3d1757b8ef69..87ee409d68ab 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -956,9 +956,7 @@ static void __mptcp_update_wmem(struct sock *sk)
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
 
-#ifdef CONFIG_LOCKDEP
-	WARN_ON_ONCE(!lockdep_is_held(&sk->sk_lock.slock));
-#endif
+	lockdep_assert_held_once(&sk->sk_lock.slock);
 
 	if (!msk->wmem_reserved)
 		return;
@@ -1117,9 +1115,8 @@ static void __mptcp_clean_una(struct sock *sk)
 
 static void __mptcp_clean_una_wakeup(struct sock *sk)
 {
-#ifdef CONFIG_LOCKDEP
-	WARN_ON_ONCE(!lockdep_is_held(&sk->sk_lock.slock));
-#endif
+	lockdep_assert_held_once(&sk->sk_lock.slock);
+
 	__mptcp_clean_una(sk);
 	mptcp_write_space(sk);
 }
-- 
2.33.0

