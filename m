Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C28182EFC76
	for <lists+netdev@lfdr.de>; Sat,  9 Jan 2021 01:52:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726490AbhAIAvX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 19:51:23 -0500
Received: from mga03.intel.com ([134.134.136.65]:32288 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726364AbhAIAvX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Jan 2021 19:51:23 -0500
IronPort-SDR: ynXZ7LPwytI3FhRO3NHQ6vB9ZVZRvSQ+KfhQW2qexTVKDmrkcbT2Db/5GjP8M5NzyJfzYqUwE8
 q5ySN5/OfJHg==
X-IronPort-AV: E=McAfee;i="6000,8403,9858"; a="177771956"
X-IronPort-AV: E=Sophos;i="5.79,333,1602572400"; 
   d="scan'208";a="177771956"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2021 16:48:09 -0800
IronPort-SDR: Bk9Ib0IK/F7geuSPsu0/85R5NmCwLQVF3hAIeRAF28qPBAb+NEDjc4PgAgbbbtvUStYlUzXicP
 U2KBL8JOgaKw==
X-IronPort-AV: E=Sophos;i="5.79,333,1602572400"; 
   d="scan'208";a="423124502"
Received: from mjmartin-nuc02.amr.corp.intel.com ([10.251.4.171])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2021 16:48:09 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliangtang@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, mptcp@lists.01.org,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 5/8] mptcp: add set_flags command in PM netlink
Date:   Fri,  8 Jan 2021 16:47:59 -0800
Message-Id: <20210109004802.341602-6-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210109004802.341602-1-mathew.j.martineau@linux.intel.com>
References: <20210109004802.341602-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliangtang@gmail.com>

This patch added a new command MPTCP_PM_CMD_SET_FLAGS in PM netlink:

In mptcp_nl_cmd_set_flags, parse the input address, get the backup value
according to whether the address's FLAG_BACKUP flag is set from the
user-space. Then check whether this address had been added in the local
address list. If it had been, then call mptcp_nl_addr_backup to deal with
this address.

In mptcp_nl_addr_backup, traverse all the existing msk sockets to find
the relevant sockets, and call mptcp_pm_nl_mp_prio_send_ack to send out
a MP_PRIO ACK packet.

Finally in mptcp_nl_cmd_set_flags, set or clear the address's FLAG_BACKUP
flag.

Signed-off-by: Geliang Tang <geliangtang@gmail.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 include/uapi/linux/mptcp.h |  1 +
 net/mptcp/pm_netlink.c     | 65 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 66 insertions(+)

diff --git a/include/uapi/linux/mptcp.h b/include/uapi/linux/mptcp.h
index 9762660df741..3674a451a18c 100644
--- a/include/uapi/linux/mptcp.h
+++ b/include/uapi/linux/mptcp.h
@@ -82,6 +82,7 @@ enum {
 	MPTCP_PM_CMD_FLUSH_ADDRS,
 	MPTCP_PM_CMD_SET_LIMITS,
 	MPTCP_PM_CMD_GET_LIMITS,
+	MPTCP_PM_CMD_SET_FLAGS,
 
 	__MPTCP_PM_CMD_AFTER_LAST
 };
diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index bf0d13c85a68..8f80099f1657 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -1164,6 +1164,66 @@ mptcp_nl_cmd_get_limits(struct sk_buff *skb, struct genl_info *info)
 	return -EMSGSIZE;
 }
 
+static int mptcp_nl_addr_backup(struct net *net,
+				struct mptcp_addr_info *addr,
+				u8 bkup)
+{
+	long s_slot = 0, s_num = 0;
+	struct mptcp_sock *msk;
+	int ret = -EINVAL;
+
+	while ((msk = mptcp_token_iter_next(net, &s_slot, &s_num)) != NULL) {
+		struct sock *sk = (struct sock *)msk;
+
+		if (list_empty(&msk->conn_list))
+			goto next;
+
+		lock_sock(sk);
+		spin_lock_bh(&msk->pm.lock);
+		ret = mptcp_pm_nl_mp_prio_send_ack(msk, addr, bkup);
+		spin_unlock_bh(&msk->pm.lock);
+		release_sock(sk);
+
+next:
+		sock_put(sk);
+		cond_resched();
+	}
+
+	return ret;
+}
+
+static int mptcp_nl_cmd_set_flags(struct sk_buff *skb, struct genl_info *info)
+{
+	struct nlattr *attr = info->attrs[MPTCP_PM_ATTR_ADDR];
+	struct pm_nl_pernet *pernet = genl_info_pm_nl(info);
+	struct mptcp_pm_addr_entry addr, *entry;
+	struct net *net = sock_net(skb->sk);
+	u8 bkup = 0;
+	int ret;
+
+	ret = mptcp_pm_parse_addr(attr, info, true, &addr);
+	if (ret < 0)
+		return ret;
+
+	if (addr.addr.flags & MPTCP_PM_ADDR_FLAG_BACKUP)
+		bkup = 1;
+
+	list_for_each_entry(entry, &pernet->local_addr_list, list) {
+		if (addresses_equal(&entry->addr, &addr.addr, true)) {
+			ret = mptcp_nl_addr_backup(net, &entry->addr, bkup);
+			if (ret)
+				return ret;
+
+			if (bkup)
+				entry->addr.flags |= MPTCP_PM_ADDR_FLAG_BACKUP;
+			else
+				entry->addr.flags &= ~MPTCP_PM_ADDR_FLAG_BACKUP;
+		}
+	}
+
+	return 0;
+}
+
 static const struct genl_small_ops mptcp_pm_ops[] = {
 	{
 		.cmd    = MPTCP_PM_CMD_ADD_ADDR,
@@ -1194,6 +1254,11 @@ static const struct genl_small_ops mptcp_pm_ops[] = {
 		.cmd    = MPTCP_PM_CMD_GET_LIMITS,
 		.doit   = mptcp_nl_cmd_get_limits,
 	},
+	{
+		.cmd    = MPTCP_PM_CMD_SET_FLAGS,
+		.doit   = mptcp_nl_cmd_set_flags,
+		.flags  = GENL_ADMIN_PERM,
+	},
 };
 
 static struct genl_family mptcp_genl_family __ro_after_init = {
-- 
2.30.0

