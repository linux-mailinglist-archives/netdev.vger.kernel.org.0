Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6851C39AE96
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 01:24:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229917AbhFCX0a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 19:26:30 -0400
Received: from mga05.intel.com ([192.55.52.43]:8110 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229764AbhFCX01 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 19:26:27 -0400
IronPort-SDR: +otSa43aIal6NbUoH6Mr4NnCUKddhjViPwn0ZGKuFuclolcdgrH1Smk5PTWdi8BX2KVFvAM8a5
 AjCe0TB825jA==
X-IronPort-AV: E=McAfee;i="6200,9189,10004"; a="289807786"
X-IronPort-AV: E=Sophos;i="5.83,246,1616482800"; 
   d="scan'208";a="289807786"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2021 16:24:42 -0700
IronPort-SDR: LToPQtRYLmCsgz5bKN3ke5AHCud8k2ArPL+NVSG/Ch/k7yjI1oRyQ9xpuCjxWiNEmh2E7R7/Ts
 A3YGCVELZkfQ==
X-IronPort-AV: E=Sophos;i="5.83,246,1616482800"; 
   d="scan'208";a="483669039"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.251.3.143])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2021 16:24:41 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev, Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 1/7] sock: expose so_timestamp options for mptcp
Date:   Thu,  3 Jun 2021 16:24:27 -0700
Message-Id: <20210603232433.260703-2-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210603232433.260703-1-mathew.j.martineau@linux.intel.com>
References: <20210603232433.260703-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

This exports SO_TIMESTAMP_* function for re-use by MPTCP.

Without this there is too much copy & paste needed to support
this from mptcp setsockopt path.

Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 include/net/sock.h |  1 +
 net/core/sock.c    | 26 +++++++++++++++++++-------
 2 files changed, 20 insertions(+), 7 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 0e962d8bc73b..7e0116b1a73f 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2743,6 +2743,7 @@ static inline bool sk_dev_equal_l3scope(struct sock *sk, int dif)
 void sock_def_readable(struct sock *sk);
 
 int sock_bindtoindex(struct sock *sk, int ifindex, bool lock_sk);
+void sock_set_timestamp(struct sock *sk, int optname, bool valbool);
 void sock_enable_timestamps(struct sock *sk);
 void sock_no_linger(struct sock *sk);
 void sock_set_keepalive(struct sock *sk);
diff --git a/net/core/sock.c b/net/core/sock.c
index 958614ea16ed..5b85dd37b562 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -776,6 +776,24 @@ void sock_enable_timestamps(struct sock *sk)
 }
 EXPORT_SYMBOL(sock_enable_timestamps);
 
+void sock_set_timestamp(struct sock *sk, int optname, bool valbool)
+{
+	switch (optname) {
+	case SO_TIMESTAMP_OLD:
+		__sock_set_timestamps(sk, valbool, false, false);
+		break;
+	case SO_TIMESTAMP_NEW:
+		__sock_set_timestamps(sk, valbool, true, false);
+		break;
+	case SO_TIMESTAMPNS_OLD:
+		__sock_set_timestamps(sk, valbool, false, true);
+		break;
+	case SO_TIMESTAMPNS_NEW:
+		__sock_set_timestamps(sk, valbool, true, true);
+		break;
+	}
+}
+
 void sock_set_keepalive(struct sock *sk)
 {
 	lock_sock(sk);
@@ -989,16 +1007,10 @@ int sock_setsockopt(struct socket *sock, int level, int optname,
 		break;
 
 	case SO_TIMESTAMP_OLD:
-		__sock_set_timestamps(sk, valbool, false, false);
-		break;
 	case SO_TIMESTAMP_NEW:
-		__sock_set_timestamps(sk, valbool, true, false);
-		break;
 	case SO_TIMESTAMPNS_OLD:
-		__sock_set_timestamps(sk, valbool, false, true);
-		break;
 	case SO_TIMESTAMPNS_NEW:
-		__sock_set_timestamps(sk, valbool, true, true);
+		sock_set_timestamp(sk, valbool, optname);
 		break;
 	case SO_TIMESTAMPING_NEW:
 	case SO_TIMESTAMPING_OLD:
-- 
2.31.1

