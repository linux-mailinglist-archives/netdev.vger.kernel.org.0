Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 332B834F557
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 02:10:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232763AbhCaAJl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 20:09:41 -0400
Received: from mga05.intel.com ([192.55.52.43]:14825 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232550AbhCaAJE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Mar 2021 20:09:04 -0400
IronPort-SDR: IoFz9yTpiZ+BIPrM3khXrhl3lrQRQilEO95Q2QyzHxB8v7QKgCvaXTaSV6GoKKEHcZWxUfe4GA
 F6OTkFNn/TNg==
X-IronPort-AV: E=McAfee;i="6000,8403,9939"; a="277058941"
X-IronPort-AV: E=Sophos;i="5.81,291,1610438400"; 
   d="scan'208";a="277058941"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2021 17:09:02 -0700
IronPort-SDR: d+YndaaNTIY/LqsdCnMPcsmJAhJCtRCg+mAVXq/mApndMUeXop524xsD9lhiEmTNxN7HFfpSki
 LJK+WLQNVKSQ==
X-IronPort-AV: E=Sophos;i="5.81,291,1610438400"; 
   d="scan'208";a="378682558"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.251.25.43])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2021 17:09:02 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliangtang@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev, Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 3/6] mptcp: remove id 0 address
Date:   Tue, 30 Mar 2021 17:08:53 -0700
Message-Id: <20210331000856.117636-4-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210331000856.117636-1-mathew.j.martineau@linux.intel.com>
References: <20210331000856.117636-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliangtang@gmail.com>

This patch added a new function mptcp_nl_remove_id_zero_address to
remove the id 0 address.

In this function, traverse all the existing msk sockets to find the
msk matched the input IP address. Then fill the removing list with
id 0, and pass it to mptcp_pm_remove_addr and mptcp_pm_remove_subflow.

Suggested-by: Paolo Abeni <pabeni@redhat.com>
Suggested-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Geliang Tang <geliangtang@gmail.com>
---
 net/mptcp/pm_netlink.c | 43 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index e00397f2abf1..cadafafa1049 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -1156,6 +1156,41 @@ static void mptcp_pm_free_addr_entry(struct mptcp_pm_addr_entry *entry)
 	}
 }
 
+static int mptcp_nl_remove_id_zero_address(struct net *net,
+					   struct mptcp_addr_info *addr)
+{
+	struct mptcp_rm_list list = { .nr = 0 };
+	long s_slot = 0, s_num = 0;
+	struct mptcp_sock *msk;
+
+	list.ids[list.nr++] = 0;
+
+	while ((msk = mptcp_token_iter_next(net, &s_slot, &s_num)) != NULL) {
+		struct sock *sk = (struct sock *)msk;
+		struct mptcp_addr_info msk_local;
+
+		if (list_empty(&msk->conn_list))
+			goto next;
+
+		local_address((struct sock_common *)msk, &msk_local);
+		if (!addresses_equal(&msk_local, addr, addr->port))
+			goto next;
+
+		lock_sock(sk);
+		spin_lock_bh(&msk->pm.lock);
+		mptcp_pm_remove_addr(msk, &list);
+		mptcp_pm_nl_rm_subflow_received(msk, &list);
+		spin_unlock_bh(&msk->pm.lock);
+		release_sock(sk);
+
+next:
+		sock_put(sk);
+		cond_resched();
+	}
+
+	return 0;
+}
+
 static int mptcp_nl_cmd_del_addr(struct sk_buff *skb, struct genl_info *info)
 {
 	struct nlattr *attr = info->attrs[MPTCP_PM_ATTR_ADDR];
@@ -1168,6 +1203,14 @@ static int mptcp_nl_cmd_del_addr(struct sk_buff *skb, struct genl_info *info)
 	if (ret < 0)
 		return ret;
 
+	/* the zero id address is special: the first address used by the msk
+	 * always gets such an id, so different subflows can have different zero
+	 * id addresses. Additionally zero id is not accounted for in id_bitmap.
+	 * Let's use an 'mptcp_rm_list' instead of the common remove code.
+	 */
+	if (addr.addr.id == 0)
+		return mptcp_nl_remove_id_zero_address(sock_net(skb->sk), &addr.addr);
+
 	spin_lock_bh(&pernet->lock);
 	entry = __lookup_addr_by_id(pernet, addr.addr.id);
 	if (!entry) {
-- 
2.31.1

