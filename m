Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0289331A917
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 01:56:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232476AbhBMAyh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 19:54:37 -0500
Received: from mga04.intel.com ([192.55.52.120]:36183 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229918AbhBMAxx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Feb 2021 19:53:53 -0500
IronPort-SDR: 8DYer8QNfl0T4eRUUKZXJcMeFDjMvOqXaGnbXwTNB/BTxedJhcpzREDH2TI+mTbT2WpI2uvRqH
 VU8Pjb/5c+0A==
X-IronPort-AV: E=McAfee;i="6000,8403,9893"; a="179941024"
X-IronPort-AV: E=Sophos;i="5.81,175,1610438400"; 
   d="scan'208";a="179941024"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2021 16:52:07 -0800
IronPort-SDR: il0pNr3o0wQV0H3LdidWjQc0GQoz3fiZ8XYAxbnNQT9CFyq3GdhvHzMb22sS3pKnKVICaF486o
 4f0cN6cNdrmA==
X-IronPort-AV: E=Sophos;i="5.81,175,1610438400"; 
   d="scan'208";a="437771512"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.254.85.171])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2021 16:52:07 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliangtang@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, mptcp@lists.01.org, matthieu.baerts@tessares.net,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next] mptcp: add local addr info in mptcp_info
Date:   Fri, 12 Feb 2021 16:52:02 -0800
Message-Id: <20210213005202.381848-1-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliangtang@gmail.com>

Add mptcpi_local_addr_used and mptcpi_local_addr_max in struct mptcp_info.

Signed-off-by: Geliang Tang <geliangtang@gmail.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 include/uapi/linux/mptcp.h | 2 ++
 net/mptcp/mptcp_diag.c     | 2 ++
 net/mptcp/pm_netlink.c     | 3 ++-
 net/mptcp/protocol.h       | 1 +
 4 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/mptcp.h b/include/uapi/linux/mptcp.h
index 3674a451a18c..f54a082563ec 100644
--- a/include/uapi/linux/mptcp.h
+++ b/include/uapi/linux/mptcp.h
@@ -102,5 +102,7 @@ struct mptcp_info {
 	__u64	mptcpi_write_seq;
 	__u64	mptcpi_snd_una;
 	__u64	mptcpi_rcv_nxt;
+	__u8	mptcpi_local_addr_used;
+	__u8	mptcpi_local_addr_max;
 };
 
diff --git a/net/mptcp/mptcp_diag.c b/net/mptcp/mptcp_diag.c
index 00ed742f48a4..f16d9b5ee978 100644
--- a/net/mptcp/mptcp_diag.c
+++ b/net/mptcp/mptcp_diag.c
@@ -128,11 +128,13 @@ static void mptcp_diag_get_info(struct sock *sk, struct inet_diag_msg *r,
 	info->mptcpi_subflows = READ_ONCE(msk->pm.subflows);
 	info->mptcpi_add_addr_signal = READ_ONCE(msk->pm.add_addr_signaled);
 	info->mptcpi_add_addr_accepted = READ_ONCE(msk->pm.add_addr_accepted);
+	info->mptcpi_local_addr_used = READ_ONCE(msk->pm.local_addr_used);
 	info->mptcpi_subflows_max = mptcp_pm_get_subflows_max(msk);
 	val = mptcp_pm_get_add_addr_signal_max(msk);
 	info->mptcpi_add_addr_signal_max = val;
 	val = mptcp_pm_get_add_addr_accept_max(msk);
 	info->mptcpi_add_addr_accepted_max = val;
+	info->mptcpi_local_addr_max = mptcp_pm_get_local_addr_max(msk);
 	if (test_bit(MPTCP_FALLBACK_DONE, &msk->flags))
 		flags |= MPTCP_INFO_FLAG_FALLBACK;
 	if (READ_ONCE(msk->can_ack))
diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index 23780a13b934..99fc51fb2872 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -226,13 +226,14 @@ unsigned int mptcp_pm_get_subflows_max(struct mptcp_sock *msk)
 }
 EXPORT_SYMBOL_GPL(mptcp_pm_get_subflows_max);
 
-static unsigned int mptcp_pm_get_local_addr_max(struct mptcp_sock *msk)
+unsigned int mptcp_pm_get_local_addr_max(struct mptcp_sock *msk)
 {
 	struct pm_nl_pernet *pernet;
 
 	pernet = net_generic(sock_net((struct sock *)msk), pm_nl_pernet_id);
 	return READ_ONCE(pernet->local_addr_max);
 }
+EXPORT_SYMBOL_GPL(mptcp_pm_get_local_addr_max);
 
 static void check_work_pending(struct mptcp_sock *msk)
 {
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 73a923d02aad..08562b19ddc3 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -723,6 +723,7 @@ int mptcp_pm_nl_get_local_id(struct mptcp_sock *msk, struct sock_common *skc);
 unsigned int mptcp_pm_get_add_addr_signal_max(struct mptcp_sock *msk);
 unsigned int mptcp_pm_get_add_addr_accept_max(struct mptcp_sock *msk);
 unsigned int mptcp_pm_get_subflows_max(struct mptcp_sock *msk);
+unsigned int mptcp_pm_get_local_addr_max(struct mptcp_sock *msk);
 
 static inline struct mptcp_ext *mptcp_get_ext(struct sk_buff *skb)
 {

base-commit: c3ff3b02e99c691197a05556ef45f5c3dd2ed3d6
-- 
2.30.1

