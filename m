Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6C263F5557
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 03:06:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235011AbhHXBGo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 21:06:44 -0400
Received: from mga18.intel.com ([134.134.136.126]:62118 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234572AbhHXBGd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Aug 2021 21:06:33 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10085"; a="204346749"
X-IronPort-AV: E=Sophos;i="5.84,346,1620716400"; 
   d="scan'208";a="204346749"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2021 18:05:49 -0700
X-IronPort-AV: E=Sophos;i="5.84,346,1620716400"; 
   d="scan'208";a="515224396"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.11.16])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2021 18:05:48 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Yonglong Li <liyonglong@chinatelecom.cn>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev, Geliang Tang <geliangtang@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 1/6] mptcp: move drop_other_suboptions check under pm lock
Date:   Mon, 23 Aug 2021 18:05:39 -0700
Message-Id: <20210824010544.68600-2-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210824010544.68600-1-mathew.j.martineau@linux.intel.com>
References: <20210824010544.68600-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yonglong Li <liyonglong@chinatelecom.cn>

This patch moved the drop_other_suboptions check from
mptcp_established_options_add_addr() into mptcp_pm_add_addr_signal(), do
it under the PM lock to avoid the race between this check and
mptcp_pm_add_addr_signal().

For this, added a new parameter for mptcp_pm_add_addr_signal() to get
the drop_other_suboptions value. And drop the other suboptions after the
option length check if drop_other_suboptions is true.

Additionally, always drop the other suboption for TCP pure ack:
that makes both the code simpler and the MPTCP behaviour more
consistent.

Co-developed-by: Geliang Tang <geliangtang@gmail.com>
Signed-off-by: Geliang Tang <geliangtang@gmail.com>
Co-developed-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Yonglong Li <liyonglong@chinatelecom.cn>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/options.c  | 28 ++++++++++++++--------------
 net/mptcp/pm.c       | 15 +++++++++++++--
 net/mptcp/protocol.h |  6 ++++--
 3 files changed, 31 insertions(+), 18 deletions(-)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index bebb759f470e..4c37f4b215ee 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -667,29 +667,29 @@ static bool mptcp_established_options_add_addr(struct sock *sk, struct sk_buff *
 	bool port;
 	int len;
 
-	if ((mptcp_pm_should_add_signal_ipv6(msk) ||
-	     mptcp_pm_should_add_signal_port(msk) ||
-	     mptcp_pm_should_add_signal_echo(msk)) &&
-	    skb && skb_is_tcp_pure_ack(skb)) {
-		pr_debug("drop other suboptions");
-		opts->suboptions = 0;
-		opts->ext_copy.use_ack = 0;
-		opts->ext_copy.use_map = 0;
-		remaining += opt_size;
-		drop_other_suboptions = true;
-	}
-
+	/* add addr will strip the existing options, be sure to avoid breaking
+	 * MPC/MPJ handshakes
+	 */
 	if (!mptcp_pm_should_add_signal(msk) ||
-	    !(mptcp_pm_add_addr_signal(msk, remaining, &opts->addr, &echo, &port)))
+	    (opts->suboptions & (OPTION_MPTCP_MPJ_ACK | OPTION_MPTCP_MPC_ACK)) ||
+	    !mptcp_pm_add_addr_signal(msk, skb, opt_size, remaining, &opts->addr,
+		    &echo, &port, &drop_other_suboptions))
 		return false;
 
+	if (drop_other_suboptions)
+		remaining += opt_size;
 	len = mptcp_add_addr_len(opts->addr.family, echo, port);
 	if (remaining < len)
 		return false;
 
 	*size = len;
-	if (drop_other_suboptions)
+	if (drop_other_suboptions) {
+		pr_debug("drop other suboptions");
+		opts->suboptions = 0;
+		opts->ext_copy.use_ack = 0;
+		opts->ext_copy.use_map = 0;
 		*size -= opt_size;
+	}
 	opts->suboptions |= OPTION_MPTCP_ADD_ADDR;
 	if (!echo) {
 		opts->ahmac = add_addr_generate_hmac(msk->local_key,
diff --git a/net/mptcp/pm.c b/net/mptcp/pm.c
index 0ed3e565f8f8..24e2f6f6178b 100644
--- a/net/mptcp/pm.c
+++ b/net/mptcp/pm.c
@@ -251,8 +251,10 @@ void mptcp_pm_mp_prio_received(struct sock *sk, u8 bkup)
 
 /* path manager helpers */
 
-bool mptcp_pm_add_addr_signal(struct mptcp_sock *msk, unsigned int remaining,
-			      struct mptcp_addr_info *saddr, bool *echo, bool *port)
+bool mptcp_pm_add_addr_signal(struct mptcp_sock *msk, struct sk_buff *skb,
+			      unsigned int opt_size, unsigned int remaining,
+			      struct mptcp_addr_info *saddr, bool *echo,
+			      bool *port, bool *drop_other_suboptions)
 {
 	int ret = false;
 
@@ -262,6 +264,15 @@ bool mptcp_pm_add_addr_signal(struct mptcp_sock *msk, unsigned int remaining,
 	if (!mptcp_pm_should_add_signal(msk))
 		goto out_unlock;
 
+	/* always drop every other options for pure ack ADD_ADDR; this is a
+	 * plain dup-ack from TCP perspective. The other MPTCP-relevant info,
+	 * if any, will be carried by the 'original' TCP ack
+	 */
+	if (skb && skb_is_tcp_pure_ack(skb)) {
+		remaining += opt_size;
+		*drop_other_suboptions = true;
+	}
+
 	*echo = mptcp_pm_should_add_signal_echo(msk);
 	*port = mptcp_pm_should_add_signal_port(msk);
 
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index bc1bfd7ac9c1..40bc9d31e1fa 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -794,8 +794,10 @@ static inline int mptcp_rm_addr_len(const struct mptcp_rm_list *rm_list)
 	return TCPOLEN_MPTCP_RM_ADDR_BASE + roundup(rm_list->nr - 1, 4) + 1;
 }
 
-bool mptcp_pm_add_addr_signal(struct mptcp_sock *msk, unsigned int remaining,
-			      struct mptcp_addr_info *saddr, bool *echo, bool *port);
+bool mptcp_pm_add_addr_signal(struct mptcp_sock *msk, struct sk_buff *skb,
+			      unsigned int opt_size, unsigned int remaining,
+			      struct mptcp_addr_info *saddr, bool *echo,
+			      bool *port, bool *drop_other_suboptions);
 bool mptcp_pm_rm_addr_signal(struct mptcp_sock *msk, unsigned int remaining,
 			     struct mptcp_rm_list *rm_list);
 int mptcp_pm_get_local_id(struct mptcp_sock *msk, struct sock_common *skc);
-- 
2.33.0

