Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58EBC2EFC78
	for <lists+netdev@lfdr.de>; Sat,  9 Jan 2021 01:54:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726432AbhAIAwi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 19:52:38 -0500
Received: from mga03.intel.com ([134.134.136.65]:32283 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726077AbhAIAwh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Jan 2021 19:52:37 -0500
IronPort-SDR: s4llfa5MrvdQtLQaFpHn46HiFeFw5IQgNYbaWzakn+m3Pz7xtRBJGhxHlTY/V3E8tT8B7uJUG/
 0jPG/dFYlscQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9858"; a="177771954"
X-IronPort-AV: E=Sophos;i="5.79,333,1602572400"; 
   d="scan'208";a="177771954"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2021 16:48:09 -0800
IronPort-SDR: EPpn8NpJ6qPTERx0XuVAc/fXULwFc9kQzSe058WYudRkuALO7ugrys1nSojLI9iG3WwRm9yPVE
 02Q/+ZlXHeLQ==
X-IronPort-AV: E=Sophos;i="5.79,333,1602572400"; 
   d="scan'208";a="423124500"
Received: from mjmartin-nuc02.amr.corp.intel.com ([10.251.4.171])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2021 16:48:09 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliangtang@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, mptcp@lists.01.org,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 3/8] mptcp: add the outgoing MP_PRIO support
Date:   Fri,  8 Jan 2021 16:47:57 -0800
Message-Id: <20210109004802.341602-4-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210109004802.341602-1-mathew.j.martineau@linux.intel.com>
References: <20210109004802.341602-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliangtang@gmail.com>

This patch added the outgoing MP_PRIO logic:

In mptcp_pm_nl_mp_prio_send_ack, find the related subflow and subsocket
according to the input parameter addr. Save the input priority value to
suflow's backup, then set subflow's send_mp_prio flag to true, and save
the input priority value to suflow's request_bkup. Finally, send out a
pure ACK on the related subsocket.

In mptcp_established_options_mp_prio, check whether the subflow's
send_mp_prio is set. If it is, this is the packet for sending MP_PRIO.
So save subflow->request_bkup value to mptcp_out_options's backup, and
change the option type to OPTION_MPTCP_PRIO.

In mptcp_write_options, clear the send_mp_prio flag and send out the
MP_PRIO suboption with mptcp_out_options's backup value.

Signed-off-by: Geliang Tang <geliangtang@gmail.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/options.c    | 40 ++++++++++++++++++++++++++++++++++++++++
 net/mptcp/pm_netlink.c | 33 +++++++++++++++++++++++++++++++++
 net/mptcp/protocol.h   |  6 ++++++
 3 files changed, 79 insertions(+)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index e0d21c0607e5..ef50a8628d77 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -679,6 +679,28 @@ static bool mptcp_established_options_rm_addr(struct sock *sk,
 	return true;
 }
 
+static bool mptcp_established_options_mp_prio(struct sock *sk,
+					      unsigned int *size,
+					      unsigned int remaining,
+					      struct mptcp_out_options *opts)
+{
+	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(sk);
+
+	if (!subflow->send_mp_prio)
+		return false;
+
+	if (remaining < TCPOLEN_MPTCP_PRIO)
+		return false;
+
+	*size = TCPOLEN_MPTCP_PRIO;
+	opts->suboptions |= OPTION_MPTCP_PRIO;
+	opts->backup = subflow->request_bkup;
+
+	pr_debug("prio=%d", opts->backup);
+
+	return true;
+}
+
 bool mptcp_established_options(struct sock *sk, struct sk_buff *skb,
 			       unsigned int *size, unsigned int remaining,
 			       struct mptcp_out_options *opts)
@@ -721,6 +743,12 @@ bool mptcp_established_options(struct sock *sk, struct sk_buff *skb,
 		ret = true;
 	}
 
+	if (mptcp_established_options_mp_prio(sk, &opt_size, remaining, opts)) {
+		*size += opt_size;
+		remaining -= opt_size;
+		ret = true;
+	}
+
 	return ret;
 }
 
@@ -1168,6 +1196,18 @@ void mptcp_write_options(__be32 *ptr, const struct tcp_sock *tp,
 				      0, opts->rm_id);
 	}
 
+	if (OPTION_MPTCP_PRIO & opts->suboptions) {
+		const struct sock *ssk = (const struct sock *)tp;
+		struct mptcp_subflow_context *subflow;
+
+		subflow = mptcp_subflow_ctx(ssk);
+		subflow->send_mp_prio = 0;
+
+		*ptr++ = mptcp_option(MPTCPOPT_MP_PRIO,
+				      TCPOLEN_MPTCP_PRIO,
+				      opts->backup, TCPOPT_NOP);
+	}
+
 	if (OPTION_MPTCP_MPJ_SYN & opts->suboptions) {
 		*ptr++ = mptcp_option(MPTCPOPT_MP_JOIN,
 				      TCPOLEN_MPTCP_MPJ_SYN,
diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index 7fe7be4eef7e..bf0d13c85a68 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -442,6 +442,39 @@ void mptcp_pm_nl_add_addr_send_ack(struct mptcp_sock *msk)
 	}
 }
 
+int mptcp_pm_nl_mp_prio_send_ack(struct mptcp_sock *msk,
+				 struct mptcp_addr_info *addr,
+				 u8 bkup)
+{
+	struct mptcp_subflow_context *subflow;
+
+	pr_debug("bkup=%d", bkup);
+
+	mptcp_for_each_subflow(msk, subflow) {
+		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
+		struct mptcp_addr_info local;
+
+		local_address((struct sock_common *)ssk, &local);
+		if (!addresses_equal(&local, addr, addr->port))
+			continue;
+
+		subflow->backup = bkup;
+		subflow->send_mp_prio = 1;
+		subflow->request_bkup = bkup;
+
+		spin_unlock_bh(&msk->pm.lock);
+		pr_debug("send ack for mp_prio");
+		lock_sock(ssk);
+		tcp_send_ack(ssk);
+		release_sock(ssk);
+		spin_lock_bh(&msk->pm.lock);
+
+		return 0;
+	}
+
+	return -EINVAL;
+}
+
 void mptcp_pm_nl_rm_addr_received(struct mptcp_sock *msk)
 {
 	struct mptcp_subflow_context *subflow, *tmp;
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index d67de793d363..21763e00d990 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -24,6 +24,7 @@
 #define OPTION_MPTCP_ADD_ADDR6	BIT(7)
 #define OPTION_MPTCP_RM_ADDR	BIT(8)
 #define OPTION_MPTCP_FASTCLOSE	BIT(9)
+#define OPTION_MPTCP_PRIO	BIT(10)
 
 /* MPTCP option subtypes */
 #define MPTCPOPT_MP_CAPABLE	0
@@ -59,6 +60,7 @@
 #define TCPOLEN_MPTCP_ADD_ADDR6_BASE_PORT	24
 #define TCPOLEN_MPTCP_PORT_LEN		4
 #define TCPOLEN_MPTCP_RM_ADDR_BASE	4
+#define TCPOLEN_MPTCP_PRIO		4
 #define TCPOLEN_MPTCP_FASTCLOSE		12
 
 /* MPTCP MP_JOIN flags */
@@ -396,6 +398,7 @@ struct mptcp_subflow_context {
 		map_valid : 1,
 		mpc_map : 1,
 		backup : 1,
+		send_mp_prio : 1,
 		rx_eof : 1,
 		can_ack : 1,        /* only after processing the remote a key */
 		disposable : 1;	    /* ctx can be free at ulp release time */
@@ -550,6 +553,9 @@ void mptcp_pm_add_addr_received(struct mptcp_sock *msk,
 				const struct mptcp_addr_info *addr);
 void mptcp_pm_add_addr_send_ack(struct mptcp_sock *msk);
 void mptcp_pm_rm_addr_received(struct mptcp_sock *msk, u8 rm_id);
+int mptcp_pm_nl_mp_prio_send_ack(struct mptcp_sock *msk,
+				 struct mptcp_addr_info *addr,
+				 u8 bkup);
 void mptcp_pm_free_anno_list(struct mptcp_sock *msk);
 struct mptcp_pm_add_entry *
 mptcp_pm_del_add_timer(struct mptcp_sock *msk,
-- 
2.30.0

