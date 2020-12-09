Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73A2E2D4F23
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 00:56:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731801AbgLIX4p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 18:56:45 -0500
Received: from mga06.intel.com ([134.134.136.31]:19420 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731302AbgLIX4b (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Dec 2020 18:56:31 -0500
IronPort-SDR: sBDl9ubSe0CznjQkEf5lT4qKA8Gog4k3OUPjvah577HrG4arm2p3W4e33772WfoFdBCK2KW2g+
 9CDDmASKT/7g==
X-IronPort-AV: E=McAfee;i="6000,8403,9830"; a="235763092"
X-IronPort-AV: E=Sophos;i="5.78,407,1599548400"; 
   d="scan'208";a="235763092"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2020 15:51:39 -0800
IronPort-SDR: zzRA5psvTt4IJKuR4eg6jStBAtiMFAKr1hc4wpTx63/6GephtgNpwG21WgWqEvK5uB8wzDWrlb
 qQO4/kmto/pA==
X-IronPort-AV: E=Sophos;i="5.78,407,1599548400"; 
   d="scan'208";a="318582188"
Received: from mjmartin-nuc02.amr.corp.intel.com ([10.254.111.12])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2020 15:51:38 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliangtang@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, mptcp@lists.01.org,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 05/11] mptcp: add the outgoing ADD_ADDR port support
Date:   Wed,  9 Dec 2020 15:51:22 -0800
Message-Id: <20201209235128.175473-6-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201209235128.175473-1-mathew.j.martineau@linux.intel.com>
References: <20201209235128.175473-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliangtang@gmail.com>

This patch added a new add_addr_signal type named MPTCP_ADD_ADDR_PORT,
to identify it is an address with port to be added.

It also added a new parameter 'port' for both mptcp_add_addr_len and
mptcp_pm_add_addr_signal.

In mptcp_established_options_add_addr, we check whether the announced
address is added with port. If it is, we put this port number to
mptcp_out_options's port field.

Signed-off-by: Geliang Tang <geliangtang@gmail.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/options.c  | 10 +++++++---
 net/mptcp/pm.c       |  5 +++--
 net/mptcp/protocol.h | 12 ++++++++++--
 3 files changed, 20 insertions(+), 7 deletions(-)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index 51f560a26890..9d3b49254d38 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -587,6 +587,7 @@ static bool mptcp_established_options_add_addr(struct sock *sk, struct sk_buff *
 	unsigned int opt_size = *size;
 	struct mptcp_addr_info saddr;
 	bool echo;
+	bool port;
 	int len;
 
 	if (mptcp_pm_should_add_signal_ipv6(msk) &&
@@ -598,10 +599,10 @@ static bool mptcp_established_options_add_addr(struct sock *sk, struct sk_buff *
 	}
 
 	if (!mptcp_pm_should_add_signal(msk) ||
-	    !(mptcp_pm_add_addr_signal(msk, remaining, &saddr, &echo)))
+	    !(mptcp_pm_add_addr_signal(msk, remaining, &saddr, &echo, &port)))
 		return false;
 
-	len = mptcp_add_addr_len(saddr.family, echo);
+	len = mptcp_add_addr_len(saddr.family, echo, port);
 	if (remaining < len)
 		return false;
 
@@ -609,6 +610,8 @@ static bool mptcp_established_options_add_addr(struct sock *sk, struct sk_buff *
 	if (drop_other_suboptions)
 		*size -= opt_size;
 	opts->addr_id = saddr.id;
+	if (port)
+		opts->port = ntohs(saddr.port);
 	if (saddr.family == AF_INET) {
 		opts->suboptions |= OPTION_MPTCP_ADD_ADDR;
 		opts->addr = saddr.addr;
@@ -631,7 +634,8 @@ static bool mptcp_established_options_add_addr(struct sock *sk, struct sk_buff *
 		}
 	}
 #endif
-	pr_debug("addr_id=%d, ahmac=%llu, echo=%d", opts->addr_id, opts->ahmac, echo);
+	pr_debug("addr_id=%d, ahmac=%llu, echo=%d, port=%d",
+		 opts->addr_id, opts->ahmac, echo, opts->port);
 
 	return true;
 }
diff --git a/net/mptcp/pm.c b/net/mptcp/pm.c
index 74ccc76a11cd..2c517046e2b5 100644
--- a/net/mptcp/pm.c
+++ b/net/mptcp/pm.c
@@ -194,7 +194,7 @@ void mptcp_pm_rm_addr_received(struct mptcp_sock *msk, u8 rm_id)
 /* path manager helpers */
 
 bool mptcp_pm_add_addr_signal(struct mptcp_sock *msk, unsigned int remaining,
-			      struct mptcp_addr_info *saddr, bool *echo)
+			      struct mptcp_addr_info *saddr, bool *echo, bool *port)
 {
 	int ret = false;
 
@@ -205,8 +205,9 @@ bool mptcp_pm_add_addr_signal(struct mptcp_sock *msk, unsigned int remaining,
 		goto out_unlock;
 
 	*echo = mptcp_pm_should_add_signal_echo(msk);
+	*port = mptcp_pm_should_add_signal_port(msk);
 
-	if (remaining < mptcp_add_addr_len(msk->pm.local.family, *echo))
+	if (remaining < mptcp_add_addr_len(msk->pm.local.family, *echo, *port))
 		goto out_unlock;
 
 	*saddr = msk->pm.local;
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 5c45aabf4c6a..8e8f1f770a8e 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -173,6 +173,7 @@ enum mptcp_add_addr_status {
 	MPTCP_ADD_ADDR_SIGNAL,
 	MPTCP_ADD_ADDR_ECHO,
 	MPTCP_ADD_ADDR_IPV6,
+	MPTCP_ADD_ADDR_PORT,
 };
 
 struct mptcp_pm_data {
@@ -571,12 +572,17 @@ static inline bool mptcp_pm_should_add_signal_ipv6(struct mptcp_sock *msk)
 	return READ_ONCE(msk->pm.add_addr_signal) & BIT(MPTCP_ADD_ADDR_IPV6);
 }
 
+static inline bool mptcp_pm_should_add_signal_port(struct mptcp_sock *msk)
+{
+	return READ_ONCE(msk->pm.add_addr_signal) & BIT(MPTCP_ADD_ADDR_PORT);
+}
+
 static inline bool mptcp_pm_should_rm_signal(struct mptcp_sock *msk)
 {
 	return READ_ONCE(msk->pm.rm_addr_signal);
 }
 
-static inline unsigned int mptcp_add_addr_len(int family, bool echo)
+static inline unsigned int mptcp_add_addr_len(int family, bool echo, bool port)
 {
 	u8 len = TCPOLEN_MPTCP_ADD_ADDR_BASE;
 
@@ -584,12 +590,14 @@ static inline unsigned int mptcp_add_addr_len(int family, bool echo)
 		len = TCPOLEN_MPTCP_ADD_ADDR6_BASE;
 	if (!echo)
 		len += MPTCPOPT_THMAC_LEN;
+	if (port)
+		len += TCPOLEN_MPTCP_PORT_LEN;
 
 	return len;
 }
 
 bool mptcp_pm_add_addr_signal(struct mptcp_sock *msk, unsigned int remaining,
-			      struct mptcp_addr_info *saddr, bool *echo);
+			      struct mptcp_addr_info *saddr, bool *echo, bool *port);
 bool mptcp_pm_rm_addr_signal(struct mptcp_sock *msk, unsigned int remaining,
 			     u8 *rm_id);
 int mptcp_pm_get_local_id(struct mptcp_sock *msk, struct sock_common *skc);
-- 
2.29.2

