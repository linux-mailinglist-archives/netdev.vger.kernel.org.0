Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED829C94EA
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 01:37:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729051AbfJBXhd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 19:37:33 -0400
Received: from mga04.intel.com ([192.55.52.120]:16453 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728985AbfJBXhX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Oct 2019 19:37:23 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Oct 2019 16:37:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,250,1566889200"; 
   d="scan'208";a="366862608"
Received: from mjmartin-nuc02.mjmartin-nuc02 (HELO mjmartin-nuc02.sea.intel.com) ([10.251.30.230])
  by orsmga005.jf.intel.com with ESMTP; 02 Oct 2019 16:37:21 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org, edumazet@google.com
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        cpaasch@apple.com, fw@strlen.de, pabeni@redhat.com,
        peter.krystad@linux.intel.com, dcaratti@redhat.com,
        matthieu.baerts@tessares.net
Subject: [RFC PATCH v2 19/45] tcp: Export low-level TCP functions
Date:   Wed,  2 Oct 2019 16:36:29 -0700
Message-Id: <20191002233655.24323-20-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191002233655.24323-1-mathew.j.martineau@linux.intel.com>
References: <20191002233655.24323-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

MPTCP will make use of tcp_send_mss() and tcp_push() when sending
data to specific TCP subflows.

Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 include/net/tcp.h | 3 +++
 net/ipv4/tcp.c    | 6 +++---
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index ddc098b33999..3994e6b0db27 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -330,6 +330,9 @@ int tcp_sendpage_locked(struct sock *sk, struct page *page, int offset,
 			size_t size, int flags);
 ssize_t do_tcp_sendpages(struct sock *sk, struct page *page, int offset,
 		 size_t size, int flags);
+int tcp_send_mss(struct sock *sk, int *size_goal, int flags);
+void tcp_push(struct sock *sk, int flags, int mss_now, int nonagle,
+	      int size_goal);
 void tcp_release_cb(struct sock *sk);
 void tcp_wfree(struct sk_buff *skb);
 void tcp_write_timer_handler(struct sock *sk);
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 5893d08cb204..5450e91dd82c 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -691,8 +691,8 @@ static bool tcp_should_autocork(struct sock *sk, struct sk_buff *skb,
 	       refcount_read(&sk->sk_wmem_alloc) > skb->truesize;
 }
 
-static void tcp_push(struct sock *sk, int flags, int mss_now,
-		     int nonagle, int size_goal)
+void tcp_push(struct sock *sk, int flags, int mss_now,
+	      int nonagle, int size_goal)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 	struct sk_buff *skb;
@@ -926,7 +926,7 @@ static unsigned int tcp_xmit_size_goal(struct sock *sk, u32 mss_now,
 	return max(size_goal, mss_now);
 }
 
-static int tcp_send_mss(struct sock *sk, int *size_goal, int flags)
+int tcp_send_mss(struct sock *sk, int *size_goal, int flags)
 {
 	int mss_now;
 
-- 
2.23.0

