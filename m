Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E94232686BD
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 10:03:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726199AbgINIDO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 04:03:14 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:24030 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726185AbgINIB5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 04:01:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600070515;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=P6RFEizugWaLAVgXhU5WmJ2jWQXy4ECB+4kljefa604=;
        b=L7xdrixVePffGTggOE8/e1KVU7YdyLx1gHQkpvJI6kbFEKoawQN5eCKGzTZHJCt/tfaemA
        DcxqO2gh14zCNZyHm75HVkOtHg9nYhACjIXasB6gFj26+MbZfzo6xB5AP3n0GfiaPmv4T4
        WB2gFvRAe0SIc0tOnrgO+7ZCrr3LE/c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-371-v5OEeaRkOsCsIzy6A7_dNA-1; Mon, 14 Sep 2020 04:01:53 -0400
X-MC-Unique: v5OEeaRkOsCsIzy6A7_dNA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BFFDF10BBEE3;
        Mon, 14 Sep 2020 08:01:51 +0000 (UTC)
Received: from linux.fritz.box.com (ovpn-112-96.ams2.redhat.com [10.36.112.96])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 78C8C19C66;
        Mon, 14 Sep 2020 08:01:50 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, mptcp@lists.01.org
Subject: [PATCH net-next v2 09/13] mptcp: move address attribute into mptcp_addr_info
Date:   Mon, 14 Sep 2020 10:01:15 +0200
Message-Id: <16790a7f9e2919325d3f2e684597337c5e0833d9.1599854632.git.pabeni@redhat.com>
In-Reply-To: <cover.1599854632.git.pabeni@redhat.com>
References: <cover.1599854632.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

So that can be accessed easily from the subflow creation
helper. No functional change intended.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/mptcp/pm_netlink.c | 39 ++++++++++++++++++++-------------------
 net/mptcp/protocol.h   |  5 +++--
 net/mptcp/subflow.c    |  5 ++---
 3 files changed, 25 insertions(+), 24 deletions(-)

diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index 2c208d2e65cd..6947f4fee6b9 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -23,8 +23,6 @@ static int pm_nl_pernet_id;
 
 struct mptcp_pm_addr_entry {
 	struct list_head	list;
-	unsigned int		flags;
-	int			ifindex;
 	struct mptcp_addr_info	addr;
 	struct rcu_head		rcu;
 };
@@ -119,7 +117,7 @@ select_local_address(const struct pm_nl_pernet *pernet,
 	rcu_read_lock();
 	spin_lock_bh(&msk->join_list_lock);
 	list_for_each_entry_rcu(entry, &pernet->local_addr_list, list) {
-		if (!(entry->flags & MPTCP_PM_ADDR_FLAG_SUBFLOW))
+		if (!(entry->addr.flags & MPTCP_PM_ADDR_FLAG_SUBFLOW))
 			continue;
 
 		/* avoid any address already in use by subflows and
@@ -150,7 +148,7 @@ select_signal_address(struct pm_nl_pernet *pernet, unsigned int pos)
 	 * can lead to additional addresses not being announced.
 	 */
 	list_for_each_entry_rcu(entry, &pernet->local_addr_list, list) {
-		if (!(entry->flags & MPTCP_PM_ADDR_FLAG_SIGNAL))
+		if (!(entry->addr.flags & MPTCP_PM_ADDR_FLAG_SIGNAL))
 			continue;
 		if (i++ == pos) {
 			ret = entry;
@@ -210,8 +208,7 @@ static void mptcp_pm_create_subflow_or_signal_addr(struct mptcp_sock *msk)
 			msk->pm.subflows++;
 			check_work_pending(msk);
 			spin_unlock_bh(&msk->pm.lock);
-			__mptcp_subflow_connect(sk, local->ifindex,
-						&local->addr, &remote);
+			__mptcp_subflow_connect(sk, &local->addr, &remote);
 			spin_lock_bh(&msk->pm.lock);
 			return;
 		}
@@ -257,13 +254,13 @@ void mptcp_pm_nl_add_addr_received(struct mptcp_sock *msk)
 	local.family = remote.family;
 
 	spin_unlock_bh(&msk->pm.lock);
-	__mptcp_subflow_connect((struct sock *)msk, 0, &local, &remote);
+	__mptcp_subflow_connect((struct sock *)msk, &local, &remote);
 	spin_lock_bh(&msk->pm.lock);
 }
 
 static bool address_use_port(struct mptcp_pm_addr_entry *entry)
 {
-	return (entry->flags &
+	return (entry->addr.flags &
 		(MPTCP_PM_ADDR_FLAG_SIGNAL | MPTCP_PM_ADDR_FLAG_SUBFLOW)) ==
 		MPTCP_PM_ADDR_FLAG_SIGNAL;
 }
@@ -293,9 +290,9 @@ static int mptcp_pm_nl_append_new_local_addr(struct pm_nl_pernet *pernet,
 			goto out;
 	}
 
-	if (entry->flags & MPTCP_PM_ADDR_FLAG_SIGNAL)
+	if (entry->addr.flags & MPTCP_PM_ADDR_FLAG_SIGNAL)
 		pernet->add_addr_signal_max++;
-	if (entry->flags & MPTCP_PM_ADDR_FLAG_SUBFLOW)
+	if (entry->addr.flags & MPTCP_PM_ADDR_FLAG_SUBFLOW)
 		pernet->local_addr_max++;
 
 	entry->addr.id = pernet->next_id++;
@@ -345,8 +342,9 @@ int mptcp_pm_nl_get_local_id(struct mptcp_sock *msk, struct sock_common *skc)
 	if (!entry)
 		return -ENOMEM;
 
-	entry->flags = 0;
 	entry->addr = skc_local;
+	entry->addr.ifindex = 0;
+	entry->addr.flags = 0;
 	ret = mptcp_pm_nl_append_new_local_addr(pernet, entry);
 	if (ret < 0)
 		kfree(entry);
@@ -460,14 +458,17 @@ static int mptcp_pm_parse_addr(struct nlattr *attr, struct genl_info *info,
 		entry->addr.addr.s_addr = nla_get_in_addr(tb[addr_addr]);
 
 skip_family:
-	if (tb[MPTCP_PM_ADDR_ATTR_IF_IDX])
-		entry->ifindex = nla_get_s32(tb[MPTCP_PM_ADDR_ATTR_IF_IDX]);
+	if (tb[MPTCP_PM_ADDR_ATTR_IF_IDX]) {
+		u32 val = nla_get_s32(tb[MPTCP_PM_ADDR_ATTR_IF_IDX]);
+
+		entry->addr.ifindex = val;
+	}
 
 	if (tb[MPTCP_PM_ADDR_ATTR_ID])
 		entry->addr.id = nla_get_u8(tb[MPTCP_PM_ADDR_ATTR_ID]);
 
 	if (tb[MPTCP_PM_ADDR_ATTR_FLAGS])
-		entry->flags = nla_get_u32(tb[MPTCP_PM_ADDR_ATTR_FLAGS]);
+		entry->addr.flags = nla_get_u32(tb[MPTCP_PM_ADDR_ATTR_FLAGS]);
 
 	return 0;
 }
@@ -535,9 +536,9 @@ static int mptcp_nl_cmd_del_addr(struct sk_buff *skb, struct genl_info *info)
 		ret = -EINVAL;
 		goto out;
 	}
-	if (entry->flags & MPTCP_PM_ADDR_FLAG_SIGNAL)
+	if (entry->addr.flags & MPTCP_PM_ADDR_FLAG_SIGNAL)
 		pernet->add_addr_signal_max--;
-	if (entry->flags & MPTCP_PM_ADDR_FLAG_SUBFLOW)
+	if (entry->addr.flags & MPTCP_PM_ADDR_FLAG_SUBFLOW)
 		pernet->local_addr_max--;
 
 	pernet->addrs--;
@@ -593,10 +594,10 @@ static int mptcp_nl_fill_addr(struct sk_buff *skb,
 		goto nla_put_failure;
 	if (nla_put_u8(skb, MPTCP_PM_ADDR_ATTR_ID, addr->id))
 		goto nla_put_failure;
-	if (nla_put_u32(skb, MPTCP_PM_ADDR_ATTR_FLAGS, entry->flags))
+	if (nla_put_u32(skb, MPTCP_PM_ADDR_ATTR_FLAGS, entry->addr.flags))
 		goto nla_put_failure;
-	if (entry->ifindex &&
-	    nla_put_s32(skb, MPTCP_PM_ADDR_ATTR_IF_IDX, entry->ifindex))
+	if (entry->addr.ifindex &&
+	    nla_put_s32(skb, MPTCP_PM_ADDR_ATTR_IF_IDX, entry->addr.ifindex))
 		goto nla_put_failure;
 
 	if (addr->family == AF_INET &&
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 26f5f81f3f4c..cfa5e1b9521b 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -140,6 +140,8 @@ struct mptcp_addr_info {
 	sa_family_t		family;
 	__be16			port;
 	u8			id;
+	u8			flags;
+	int			ifindex;
 	union {
 		struct in_addr addr;
 #if IS_ENABLED(CONFIG_MPTCP_IPV6)
@@ -358,8 +360,7 @@ bool mptcp_subflow_data_available(struct sock *sk);
 void __init mptcp_subflow_init(void);
 
 /* called with sk socket lock held */
-int __mptcp_subflow_connect(struct sock *sk, int ifindex,
-			    const struct mptcp_addr_info *loc,
+int __mptcp_subflow_connect(struct sock *sk, const struct mptcp_addr_info *loc,
 			    const struct mptcp_addr_info *remote);
 int mptcp_subflow_create_socket(struct sock *sk, struct socket **new_sock);
 
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 8c9418d1901b..ae3eeb9bb191 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -1035,8 +1035,7 @@ static void mptcp_info2sockaddr(const struct mptcp_addr_info *info,
 #endif
 }
 
-int __mptcp_subflow_connect(struct sock *sk, int ifindex,
-			    const struct mptcp_addr_info *loc,
+int __mptcp_subflow_connect(struct sock *sk, const struct mptcp_addr_info *loc,
 			    const struct mptcp_addr_info *remote)
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
@@ -1080,7 +1079,7 @@ int __mptcp_subflow_connect(struct sock *sk, int ifindex,
 	if (loc->family == AF_INET6)
 		addrlen = sizeof(struct sockaddr_in6);
 #endif
-	ssk->sk_bound_dev_if = ifindex;
+	ssk->sk_bound_dev_if = loc->ifindex;
 	err = kernel_bind(sf, (struct sockaddr *)&addr, addrlen);
 	if (err)
 		goto failed;
-- 
2.26.2

