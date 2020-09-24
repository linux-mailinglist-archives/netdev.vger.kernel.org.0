Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 535DD27653C
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 02:39:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726734AbgIXAjE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 20:39:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726466AbgIXAjE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 20:39:04 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 478E0C0613CE;
        Wed, 23 Sep 2020 17:39:04 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id y14so766039pgf.12;
        Wed, 23 Sep 2020 17:39:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=zcmnEPq+YTalL7s+yxxifbO2I4SU9mxShMOziACbhrU=;
        b=CDI6DgVvdZITW/kHdY3bqx/ylC9XVOxejYxAGekPfcsWLUd9rOOhSrqcaIg9gvk6eC
         yR3s0vtKNvgBWALxKgJpeNPlSfh1UxkfDXlDp4csHhyngzCCaaQ8YiwEcYSSMzz8S1Th
         iawszw9zZncWOyfCPndgql6dG2bljBQRtgEg7Icagj+4xO0bf+YNlwwIr5lsd4Be0C+z
         Da5/ERSNUH6d9mbDPbSVpmBp0oS/W5Ziw4TuAT9qGOSKd8FBwq5gZqhQUHC7iZPsVgIm
         LzwJb0eIJBki9z2VVJwlvkqWm/3qy5Q4WVxqXu6Mj3oifR9de9JYIZfcFipBSwU8KLRW
         MeSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=zcmnEPq+YTalL7s+yxxifbO2I4SU9mxShMOziACbhrU=;
        b=l/SoSEg7BlSuhumJrLqF/AynP/sTLJ3xFuzv3shHBzrBYbGWku+d9MPCGWtOYZhz2P
         DE/qa2NwpTdi7t2HcL5zsw86fDn0fPsdKzfH3f732IKaYtxtckDFyB632eupraHNdCum
         tWmKlEOhaiEUWmxhAwBITDFucY9Olg6Oqbq6TShj9V9OCz2GCwrjrtwH+EW0Hr8jhVrn
         rR03/mdyRbgXXYwwrOkKM+0jhNFq7ZbE+EJWtzUBLwgELi+NGlocYQSMZ+AoF/8fWkLU
         nMY5W8Yv+adm0O9wE7PZLMPv0hp/qjXGKYzdkaT9eSpdoNOhmz5/ud2/bub6/E12H9nC
         2VbQ==
X-Gm-Message-State: AOAM531zgpaFVQH3ROz3CF3y3FhBbSe2KtdDgOhCNmDTslwTufUkSCmj
        L3/9f+WrUKhuSgfQceiOTbs=
X-Google-Smtp-Source: ABdhPJy5kJhNviR72dA9ytVfXRwvJ26FP9vT0W597nnn5TVIH5bAaFUQcGUy3ETYVc2s9XjvCPtUCg==
X-Received: by 2002:a05:6a00:1481:b029:142:2501:35d7 with SMTP id v1-20020a056a001481b0290142250135d7mr2211221pfu.55.1600907943791;
        Wed, 23 Sep 2020 17:39:03 -0700 (PDT)
Received: from localhost ([43.224.245.180])
        by smtp.gmail.com with ESMTPSA id v8sm900479pgg.58.2020.09.23.17.39.02
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 23 Sep 2020 17:39:03 -0700 (PDT)
From:   Geliang Tang <geliangtang@gmail.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Geliang Tang <geliangtang@gmail.com>, netdev@vger.kernel.org,
        mptcp@lists.01.org, linux-kernel@vger.kernel.org
Subject: [MPTCP][PATCH net-next 03/16] mptcp: add the incoming RM_ADDR support
Date:   Thu, 24 Sep 2020 08:29:49 +0800
Message-Id: <bf7aca2bee20de148728e30343734628aee6d779.1600853093.git.geliangtang@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1600853093.git.geliangtang@gmail.com>
References: <cover.1600853093.git.geliangtang@gmail.com>
In-Reply-To: <e3c9ab612d773465ddf78cef0482208c73a0ca07.1600853093.git.geliangtang@gmail.com>
References: <cover.1600853093.git.geliangtang@gmail.com> <bfecdd638bb74a02de1c3f1c84239911e304fcc3.1600853093.git.geliangtang@gmail.com> <e3c9ab612d773465ddf78cef0482208c73a0ca07.1600853093.git.geliangtang@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch added the RM_ADDR option parsing logic:

We parsed the incoming options to find if the rm_addr option is received,
and called mptcp_pm_rm_addr_received to schedule PM work to a new status,
named MPTCP_PM_RM_ADDR_RECEIVED.

PM work got this status, and called mptcp_pm_nl_rm_addr_received to handle
it.

In mptcp_pm_nl_rm_addr_received, we closed the subflow matching the rm_id,
and updated PM counter.

Suggested-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Suggested-by: Paolo Abeni <pabeni@redhat.com>
Suggested-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Geliang Tang <geliangtang@gmail.com>
---
 net/mptcp/options.c    |  5 +++++
 net/mptcp/pm.c         | 12 ++++++++++++
 net/mptcp/pm_netlink.c | 34 ++++++++++++++++++++++++++++++++++
 net/mptcp/protocol.c   | 12 ++++++++----
 net/mptcp/protocol.h   |  7 +++++++
 5 files changed, 66 insertions(+), 4 deletions(-)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index bbc124876417..a52a05effac9 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -888,6 +888,11 @@ void mptcp_incoming_options(struct sock *sk, struct sk_buff *skb,
 		mp_opt.add_addr = 0;
 	}
 
+	if (mp_opt.rm_addr) {
+		mptcp_pm_rm_addr_received(msk, mp_opt.rm_id);
+		mp_opt.rm_addr = 0;
+	}
+
 	if (!mp_opt.dss)
 		return;
 
diff --git a/net/mptcp/pm.c b/net/mptcp/pm.c
index 81b07ae213b9..558462d87eb3 100644
--- a/net/mptcp/pm.c
+++ b/net/mptcp/pm.c
@@ -149,6 +149,18 @@ void mptcp_pm_add_addr_received(struct mptcp_sock *msk,
 	spin_unlock_bh(&pm->lock);
 }
 
+void mptcp_pm_rm_addr_received(struct mptcp_sock *msk, u8 rm_id)
+{
+	struct mptcp_pm_data *pm = &msk->pm;
+
+	pr_debug("msk=%p remote_id=%d", msk, rm_id);
+
+	spin_lock_bh(&pm->lock);
+	mptcp_pm_schedule_work(msk, MPTCP_PM_RM_ADDR_RECEIVED);
+	pm->rm_id = rm_id;
+	spin_unlock_bh(&pm->lock);
+}
+
 /* path manager helpers */
 
 bool mptcp_pm_add_addr_signal(struct mptcp_sock *msk, unsigned int remaining,
diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index b4a9624d7bf2..4124bc581308 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -268,6 +268,40 @@ void mptcp_pm_nl_add_addr_received(struct mptcp_sock *msk)
 	spin_lock_bh(&msk->pm.lock);
 }
 
+void mptcp_pm_nl_rm_addr_received(struct mptcp_sock *msk)
+{
+	struct mptcp_subflow_context *subflow, *tmp;
+	struct sock *sk = (struct sock *)msk;
+
+	pr_debug("address rm_id %d", msk->pm.rm_id);
+
+	if (!msk->pm.rm_id)
+		return;
+
+	if (list_empty(&msk->conn_list))
+		return;
+
+	list_for_each_entry_safe(subflow, tmp, &msk->conn_list, node) {
+		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
+		int how = RCV_SHUTDOWN | SEND_SHUTDOWN;
+		long timeout = 0;
+
+		if (msk->pm.rm_id != subflow->remote_id)
+			continue;
+
+		spin_unlock_bh(&msk->pm.lock);
+		mptcp_subflow_shutdown(sk, ssk, how);
+		__mptcp_close_ssk(sk, ssk, subflow, timeout);
+		spin_lock_bh(&msk->pm.lock);
+
+		msk->pm.add_addr_accepted--;
+		msk->pm.subflows--;
+		WRITE_ONCE(msk->pm.accept_addr, true);
+
+		break;
+	}
+}
+
 static bool address_use_port(struct mptcp_pm_addr_entry *entry)
 {
 	return (entry->addr.flags &
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 386cd4e60250..26b9233f247c 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1652,9 +1652,9 @@ static struct sock *mptcp_subflow_get_retrans(const struct mptcp_sock *msk)
  * so we need to use tcp_close() after detaching them from the mptcp
  * parent socket.
  */
-static void __mptcp_close_ssk(struct sock *sk, struct sock *ssk,
-			      struct mptcp_subflow_context *subflow,
-			      long timeout)
+void __mptcp_close_ssk(struct sock *sk, struct sock *ssk,
+		       struct mptcp_subflow_context *subflow,
+		       long timeout)
 {
 	struct socket *sock = READ_ONCE(ssk->sk_socket);
 
@@ -1685,6 +1685,10 @@ static void pm_work(struct mptcp_sock *msk)
 		pm->status &= ~BIT(MPTCP_PM_ADD_ADDR_RECEIVED);
 		mptcp_pm_nl_add_addr_received(msk);
 	}
+	if (pm->status & BIT(MPTCP_PM_RM_ADDR_RECEIVED)) {
+		pm->status &= ~BIT(MPTCP_PM_RM_ADDR_RECEIVED);
+		mptcp_pm_nl_rm_addr_received(msk);
+	}
 	if (pm->status & BIT(MPTCP_PM_ESTABLISHED)) {
 		pm->status &= ~BIT(MPTCP_PM_ESTABLISHED);
 		mptcp_pm_nl_fully_established(msk);
@@ -1846,7 +1850,7 @@ static void mptcp_cancel_work(struct sock *sk)
 		sock_put(sk);
 }
 
-static void mptcp_subflow_shutdown(struct sock *sk, struct sock *ssk, int how)
+void mptcp_subflow_shutdown(struct sock *sk, struct sock *ssk, int how)
 {
 	lock_sock(ssk);
 
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 8929b0c7660a..837e01057544 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -152,6 +152,7 @@ struct mptcp_addr_info {
 
 enum mptcp_pm_status {
 	MPTCP_PM_ADD_ADDR_RECEIVED,
+	MPTCP_PM_RM_ADDR_RECEIVED,
 	MPTCP_PM_ESTABLISHED,
 	MPTCP_PM_SUBFLOW_ESTABLISHED,
 };
@@ -362,6 +363,10 @@ void mptcp_subflow_fully_established(struct mptcp_subflow_context *subflow,
 				     struct mptcp_options_received *mp_opt);
 bool mptcp_subflow_data_available(struct sock *sk);
 void __init mptcp_subflow_init(void);
+void mptcp_subflow_shutdown(struct sock *sk, struct sock *ssk, int how);
+void __mptcp_close_ssk(struct sock *sk, struct sock *ssk,
+		       struct mptcp_subflow_context *subflow,
+		       long timeout);
 
 /* called with sk socket lock held */
 int __mptcp_subflow_connect(struct sock *sk, const struct mptcp_addr_info *loc,
@@ -434,6 +439,7 @@ void mptcp_pm_subflow_established(struct mptcp_sock *msk,
 void mptcp_pm_subflow_closed(struct mptcp_sock *msk, u8 id);
 void mptcp_pm_add_addr_received(struct mptcp_sock *msk,
 				const struct mptcp_addr_info *addr);
+void mptcp_pm_rm_addr_received(struct mptcp_sock *msk, u8 rm_id);
 
 int mptcp_pm_announce_addr(struct mptcp_sock *msk,
 			   const struct mptcp_addr_info *addr);
@@ -468,6 +474,7 @@ void mptcp_pm_nl_data_init(struct mptcp_sock *msk);
 void mptcp_pm_nl_fully_established(struct mptcp_sock *msk);
 void mptcp_pm_nl_subflow_established(struct mptcp_sock *msk);
 void mptcp_pm_nl_add_addr_received(struct mptcp_sock *msk);
+void mptcp_pm_nl_rm_addr_received(struct mptcp_sock *msk);
 int mptcp_pm_nl_get_local_id(struct mptcp_sock *msk, struct sock_common *skc);
 
 static inline struct mptcp_ext *mptcp_get_ext(struct sk_buff *skb)
-- 
2.17.1

