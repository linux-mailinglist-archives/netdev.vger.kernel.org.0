Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3587B39AE98
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 01:24:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229938AbhFCX0c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 19:26:32 -0400
Received: from mga05.intel.com ([192.55.52.43]:8110 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229902AbhFCX03 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 19:26:29 -0400
IronPort-SDR: DzpimDr6n5zpWtntKT9dZB/anJdUmZfDEfeflVU8WEGUNWozqTjjgNmaWREuE1Kqs50g+F6j1w
 R8eWsk2A5IKg==
X-IronPort-AV: E=McAfee;i="6200,9189,10004"; a="289807801"
X-IronPort-AV: E=Sophos;i="5.83,246,1616482800"; 
   d="scan'208";a="289807801"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2021 16:24:43 -0700
IronPort-SDR: GWsK+IqdEMkXfBkX/e+4LnC7QvWFRuP5PCgycUMpe9gw1RPsNThKX5+tnxxLPxKdJGXoVrDhEZ
 /bSZ7a6C+Tvg==
X-IronPort-AV: E=Sophos;i="5.83,246,1616482800"; 
   d="scan'208";a="483669044"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.251.3.143])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2021 16:24:43 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>, davem@davemloft.net,
        kuba@kernel.org, edumazet@google.com, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev, Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 5/7] tcp: export timestamp helpers for mptcp
Date:   Thu,  3 Jun 2021 16:24:31 -0700
Message-Id: <20210603232433.260703-6-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210603232433.260703-1-mathew.j.martineau@linux.intel.com>
References: <20210603232433.260703-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

MPTCP is builtin, so no need to add EXPORT_SYMBOL()s.

It will be used to support SO_TIMESTAMP(NS) ancillary
messages in the mptcp receive path.

Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 include/net/tcp.h |  4 ++++
 net/ipv4/tcp.c    | 10 ++++------
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index d05193cb0d99..e668f1bf780d 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -412,6 +412,10 @@ int tcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int nonblock,
 		int flags, int *addr_len);
 int tcp_set_rcvlowat(struct sock *sk, int val);
 int tcp_set_window_clamp(struct sock *sk, int val);
+void tcp_update_recv_tstamps(struct sk_buff *skb,
+			     struct scm_timestamping_internal *tss);
+void tcp_recv_timestamp(struct msghdr *msg, const struct sock *sk,
+			struct scm_timestamping_internal *tss);
 void tcp_data_ready(struct sock *sk);
 #ifdef CONFIG_MMU
 int tcp_mmap(struct file *file, struct socket *sock,
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index f1c1f9e3de72..0e3f0e0e5b51 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1738,8 +1738,8 @@ int tcp_set_rcvlowat(struct sock *sk, int val)
 }
 EXPORT_SYMBOL(tcp_set_rcvlowat);
 
-static void tcp_update_recv_tstamps(struct sk_buff *skb,
-				    struct scm_timestamping_internal *tss)
+void tcp_update_recv_tstamps(struct sk_buff *skb,
+			     struct scm_timestamping_internal *tss)
 {
 	if (skb->tstamp)
 		tss->ts[0] = ktime_to_timespec64(skb->tstamp);
@@ -2024,8 +2024,6 @@ static int tcp_zerocopy_vm_insert_batch(struct vm_area_struct *vma,
 }
 
 #define TCP_VALID_ZC_MSG_FLAGS   (TCP_CMSG_TS)
-static void tcp_recv_timestamp(struct msghdr *msg, const struct sock *sk,
-			       struct scm_timestamping_internal *tss);
 static void tcp_zc_finalize_rx_tstamp(struct sock *sk,
 				      struct tcp_zerocopy_receive *zc,
 				      struct scm_timestamping_internal *tss)
@@ -2197,8 +2195,8 @@ static int tcp_zerocopy_receive(struct sock *sk,
 #endif
 
 /* Similar to __sock_recv_timestamp, but does not require an skb */
-static void tcp_recv_timestamp(struct msghdr *msg, const struct sock *sk,
-			       struct scm_timestamping_internal *tss)
+void tcp_recv_timestamp(struct msghdr *msg, const struct sock *sk,
+			struct scm_timestamping_internal *tss)
 {
 	int new_tstamp = sock_flag(sk, SOCK_TSTAMP_NEW);
 	bool has_timestamping = false;
-- 
2.31.1

