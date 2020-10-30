Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A95162A1115
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 23:45:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726136AbgJ3WpU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 18:45:20 -0400
Received: from mga11.intel.com ([192.55.52.93]:45959 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726107AbgJ3WpP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Oct 2020 18:45:15 -0400
IronPort-SDR: 9TQoV+1H4LV8qYetLO+afrwes4x1EQ64f4QaNA9WD7Z8K+9H5ZgHiuIuezVHoeZRldd8Gb3Fvk
 uWSs2+E7cy1w==
X-IronPort-AV: E=McAfee;i="6000,8403,9790"; a="165177401"
X-IronPort-AV: E=Sophos;i="5.77,434,1596524400"; 
   d="scan'208";a="165177401"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2020 15:45:14 -0700
IronPort-SDR: WGBqc34Orx9fY4yHrfopmMb8cAmEPQWB1R9poj0ae6hBznj/tRq6nRMbbFCEIf5KJ3L/1ARELC
 +EMp+4FC/euw==
X-IronPort-AV: E=Sophos;i="5.77,434,1596524400"; 
   d="scan'208";a="361983942"
Received: from mjmartin-nuc02.amr.corp.intel.com ([10.254.102.227])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2020 15:45:13 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliangtang@gmail.com>, mptcp@lists.01.org,
        kuba@kernel.org, davem@davemloft.net,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net-next 5/6] mptcp: add a new sysctl add_addr_timeout
Date:   Fri, 30 Oct 2020 15:45:05 -0700
Message-Id: <20201030224506.108377-6-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201030224506.108377-1-mathew.j.martineau@linux.intel.com>
References: <20201030224506.108377-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliangtang@gmail.com>

This patch added a new sysctl, named add_addr_timeout, to control the
timeout value (in seconds) of the ADD_ADDR retransmission.

Suggested-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Suggested-by: Paolo Abeni <pabeni@redhat.com>
Acked-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Geliang Tang <geliangtang@gmail.com>
---
 net/mptcp/ctrl.c       | 14 ++++++++++++++
 net/mptcp/pm_netlink.c |  8 ++++++--
 net/mptcp/protocol.h   |  1 +
 3 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/net/mptcp/ctrl.c b/net/mptcp/ctrl.c
index 54b888f94009..96ba616f59bf 100644
--- a/net/mptcp/ctrl.c
+++ b/net/mptcp/ctrl.c
@@ -18,6 +18,7 @@ struct mptcp_pernet {
 	struct ctl_table_header *ctl_table_hdr;
 
 	int mptcp_enabled;
+	unsigned int add_addr_timeout;
 };
 
 static struct mptcp_pernet *mptcp_get_pernet(struct net *net)
@@ -30,6 +31,11 @@ int mptcp_is_enabled(struct net *net)
 	return mptcp_get_pernet(net)->mptcp_enabled;
 }
 
+unsigned int mptcp_get_add_addr_timeout(struct net *net)
+{
+	return mptcp_get_pernet(net)->add_addr_timeout;
+}
+
 static struct ctl_table mptcp_sysctl_table[] = {
 	{
 		.procname = "enabled",
@@ -40,12 +46,19 @@ static struct ctl_table mptcp_sysctl_table[] = {
 		 */
 		.proc_handler = proc_dointvec,
 	},
+	{
+		.procname = "add_addr_timeout",
+		.maxlen = sizeof(unsigned int),
+		.mode = 0644,
+		.proc_handler = proc_dointvec_jiffies,
+	},
 	{}
 };
 
 static void mptcp_pernet_set_defaults(struct mptcp_pernet *pernet)
 {
 	pernet->mptcp_enabled = 1;
+	pernet->add_addr_timeout = TCP_RTO_MAX;
 }
 
 static int mptcp_pernet_new_table(struct net *net, struct mptcp_pernet *pernet)
@@ -61,6 +74,7 @@ static int mptcp_pernet_new_table(struct net *net, struct mptcp_pernet *pernet)
 	}
 
 	table[0].data = &pernet->mptcp_enabled;
+	table[1].data = &pernet->add_addr_timeout;
 
 	hdr = register_net_sysctl(net, MPTCP_SYSCTL_PATH, table);
 	if (!hdr)
diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index 0d6f3d912891..ed60538df7b2 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -206,6 +206,7 @@ static void mptcp_pm_add_timer(struct timer_list *timer)
 	struct mptcp_pm_add_entry *entry = from_timer(entry, timer, add_timer);
 	struct mptcp_sock *msk = entry->sock;
 	struct sock *sk = (struct sock *)msk;
+	struct net *net = sock_net(sk);
 
 	pr_debug("msk=%p", msk);
 
@@ -232,7 +233,8 @@ static void mptcp_pm_add_timer(struct timer_list *timer)
 	}
 
 	if (entry->retrans_times < ADD_ADDR_RETRANS_MAX)
-		sk_reset_timer(sk, timer, jiffies + TCP_RTO_MAX);
+		sk_reset_timer(sk, timer,
+			       jiffies + mptcp_get_add_addr_timeout(net));
 
 	spin_unlock_bh(&msk->pm.lock);
 
@@ -264,6 +266,7 @@ static bool mptcp_pm_alloc_anno_list(struct mptcp_sock *msk,
 {
 	struct mptcp_pm_add_entry *add_entry = NULL;
 	struct sock *sk = (struct sock *)msk;
+	struct net *net = sock_net(sk);
 
 	if (lookup_anno_list_by_saddr(msk, &entry->addr))
 		return false;
@@ -279,7 +282,8 @@ static bool mptcp_pm_alloc_anno_list(struct mptcp_sock *msk,
 	add_entry->retrans_times = 0;
 
 	timer_setup(&add_entry->add_timer, mptcp_pm_add_timer, 0);
-	sk_reset_timer(sk, &add_entry->add_timer, jiffies + TCP_RTO_MAX);
+	sk_reset_timer(sk, &add_entry->add_timer,
+		       jiffies + mptcp_get_add_addr_timeout(net));
 
 	return true;
 }
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 13ab89dc1914..278c88c405e8 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -362,6 +362,7 @@ mptcp_subflow_get_mapped_dsn(const struct mptcp_subflow_context *subflow)
 }
 
 int mptcp_is_enabled(struct net *net);
+unsigned int mptcp_get_add_addr_timeout(struct net *net);
 void mptcp_subflow_fully_established(struct mptcp_subflow_context *subflow,
 				     struct mptcp_options_received *mp_opt);
 bool mptcp_subflow_data_available(struct sock *sk);
-- 
2.29.2

