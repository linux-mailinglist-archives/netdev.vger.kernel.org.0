Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B415530319D
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 03:14:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731459AbhAYTCx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 14:02:53 -0500
Received: from mga05.intel.com ([192.55.52.43]:23609 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731417AbhAYTBO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Jan 2021 14:01:14 -0500
IronPort-SDR: kf9ZFMQnVnCmKlWnsmpHFRw+EXnBPek7LdIwyNQzX5qii74F+HP2c+Zvc6xguSbPkkXGzor4eI
 gsOjCBTJ/5sA==
X-IronPort-AV: E=McAfee;i="6000,8403,9875"; a="264604205"
X-IronPort-AV: E=Sophos;i="5.79,374,1602572400"; 
   d="scan'208";a="264604205"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2021 10:59:26 -0800
IronPort-SDR: I9Mrl6edG6iqIdJPM/QsjB3VQm0QGaWJR9J+lfKZYbJ2VD/i6+GNwuBGP4uWZ9eYlU41UE0VuR
 bOeeeWP1Kq6A==
X-IronPort-AV: E=Sophos;i="5.79,374,1602572400"; 
   d="scan'208";a="361637470"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.254.126.22])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2021 10:59:25 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Matthieu Baerts <matthieu.baerts@tessares.net>,
        davem@davemloft.net, kuba@kernel.org, mptcp@lists.01.org,
        Geliang Tang <geliangtang@gmail.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 1/5] mptcp: support MPJoin with IPv4 mapped in v6 sk
Date:   Mon, 25 Jan 2021 10:59:00 -0800
Message-Id: <20210125185904.6997-2-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125185904.6997-1-mathew.j.martineau@linux.intel.com>
References: <20210125185904.6997-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matthieu Baerts <matthieu.baerts@tessares.net>

With an IPv4 mapped in v6 socket, we were trying to call inet6_bind()
with an IPv4 address resulting in a -EINVAL error because the given
addr_len -- size of the address structure -- was too short.

We now make sure to use address structures for the same family as the
MPTCP socket for both the bind() and the connect(). It means we convert
v4 addresses to v4 mapped in v6 or the opposite if needed.

Fixes: ec3edaa7ca6c ("mptcp: Add handling of outgoing MP_JOIN requests")
Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/122
Co-developed-by: Geliang Tang <geliangtang@gmail.com>
Signed-off-by: Geliang Tang <geliangtang@gmail.com>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/subflow.c | 24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 721059916c96..586156281e5a 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -1085,21 +1085,31 @@ void mptcpv6_handle_mapped(struct sock *sk, bool mapped)
 #endif
 
 static void mptcp_info2sockaddr(const struct mptcp_addr_info *info,
-				struct sockaddr_storage *addr)
+				struct sockaddr_storage *addr,
+				unsigned short family)
 {
 	memset(addr, 0, sizeof(*addr));
-	addr->ss_family = info->family;
+	addr->ss_family = family;
 	if (addr->ss_family == AF_INET) {
 		struct sockaddr_in *in_addr = (struct sockaddr_in *)addr;
 
-		in_addr->sin_addr = info->addr;
+		if (info->family == AF_INET)
+			in_addr->sin_addr = info->addr;
+#if IS_ENABLED(CONFIG_MPTCP_IPV6)
+		else if (ipv6_addr_v4mapped(&info->addr6))
+			in_addr->sin_addr.s_addr = info->addr6.s6_addr32[3];
+#endif
 		in_addr->sin_port = info->port;
 	}
 #if IS_ENABLED(CONFIG_MPTCP_IPV6)
 	else if (addr->ss_family == AF_INET6) {
 		struct sockaddr_in6 *in6_addr = (struct sockaddr_in6 *)addr;
 
-		in6_addr->sin6_addr = info->addr6;
+		if (info->family == AF_INET)
+			ipv6_addr_set_v4mapped(info->addr.s_addr,
+					       &in6_addr->sin6_addr);
+		else
+			in6_addr->sin6_addr = info->addr6;
 		in6_addr->sin6_port = info->port;
 	}
 #endif
@@ -1143,11 +1153,11 @@ int __mptcp_subflow_connect(struct sock *sk, const struct mptcp_addr_info *loc,
 	subflow->remote_key = msk->remote_key;
 	subflow->local_key = msk->local_key;
 	subflow->token = msk->token;
-	mptcp_info2sockaddr(loc, &addr);
+	mptcp_info2sockaddr(loc, &addr, ssk->sk_family);
 
 	addrlen = sizeof(struct sockaddr_in);
 #if IS_ENABLED(CONFIG_MPTCP_IPV6)
-	if (loc->family == AF_INET6)
+	if (addr.ss_family == AF_INET6)
 		addrlen = sizeof(struct sockaddr_in6);
 #endif
 	ssk->sk_bound_dev_if = loc->ifindex;
@@ -1163,7 +1173,7 @@ int __mptcp_subflow_connect(struct sock *sk, const struct mptcp_addr_info *loc,
 	subflow->remote_id = remote_id;
 	subflow->request_join = 1;
 	subflow->request_bkup = !!(loc->flags & MPTCP_PM_ADDR_FLAG_BACKUP);
-	mptcp_info2sockaddr(remote, &addr);
+	mptcp_info2sockaddr(remote, &addr, ssk->sk_family);
 
 	mptcp_add_pending_subflow(msk, subflow);
 	err = kernel_connect(sf, (struct sockaddr *)&addr, addrlen, O_NONBLOCK);
-- 
2.30.0

