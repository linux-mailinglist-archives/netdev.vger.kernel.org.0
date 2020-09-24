Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1859B276546
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 02:41:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726632AbgIXAlV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 20:41:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726466AbgIXAlV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 20:41:21 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A005C0613CE;
        Wed, 23 Sep 2020 17:41:19 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id bw23so686469pjb.2;
        Wed, 23 Sep 2020 17:41:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=vTJMIFxDOIU7wqnMWdIC+M4ZbcMyOe0P1cQikjjtIn4=;
        b=hSZja3OAsUUxZyB9Sk0ayT5HHHFNU6l24HQahtt32Pp0m74U9vMgRvVu//ryucKKJP
         Fb0soNDD5BJBOcuvId5hAIIwrjzeDqVe4+FMnjWX6+IudMBK6INtRiE+ylWUAAWIDBuk
         fWKR9C1goWD42/jBS7CAQV08LWWAwvx2YLoPjaA0TW1aZmzUVed2UpBmZAq2LL+J6GDp
         2NxasnqyxVgO799GDFuZjVv/UaNhByrUkKBNIUElOgwK7mRa/p21OS/smwG5Q5OBjS7I
         pzgE7ueCWSm2MfZHRjDEsQRqWQdR+xw//Lnr0fp2zVvFYQxETjm9RJdjZj68e3MdT7Kf
         qXWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=vTJMIFxDOIU7wqnMWdIC+M4ZbcMyOe0P1cQikjjtIn4=;
        b=ks3AtzxiXU83jTNScOJJl0UMHJ/x2Nx5QlXmcbRwZyUewzSfTlZNUwgYzwruEZo4U1
         GSduZ/LBJXCxmMksJnG9JYAzfyaG/C595dWkjXfd5FtEBPJdPy91gzJYE0n9rHUjP7sl
         wqxA4iWmI3gIATkfgkiNf4tOYKDSBiexKw3IdDfsuVsWMxWkNfWPKVAR3YRyZB8yZXy/
         Nh6Z8KUQMUtUBoUQGY+VpMamO4S/mj5KcrImi/miGK8JwfYiU0zLeZp8gD8iL9j7HrKk
         6o5bdoe49AWPDJF544b45Atcnm9gXNCVuEc3r5Akn+Mar34w77svl2BftDL5svQcUs3V
         Cm2A==
X-Gm-Message-State: AOAM530awF69c+XV0G9v7RbV4Mthk/bT0PDkjhQ0GmXetdhnFexFr6iq
        pEQ7oSECFWRGR1dHkM/qq+k=
X-Google-Smtp-Source: ABdhPJy6lpM5/qrkXqZDShfpd8qwFPyDbRUy99rRszuqTygP6C53sbvG77yFh3quBUZzLlL6ZQ1law==
X-Received: by 2002:a17:902:b410:b029:d1:920c:c22b with SMTP id x16-20020a170902b410b02900d1920cc22bmr2212867plr.28.1600908079000;
        Wed, 23 Sep 2020 17:41:19 -0700 (PDT)
Received: from localhost ([43.224.245.180])
        by smtp.gmail.com with ESMTPSA id q21sm875659pgt.48.2020.09.23.17.41.17
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 23 Sep 2020 17:41:18 -0700 (PDT)
From:   Geliang Tang <geliangtang@gmail.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Geliang Tang <geliangtang@gmail.com>, netdev@vger.kernel.org,
        mptcp@lists.01.org, linux-kernel@vger.kernel.org
Subject: [MPTCP][PATCH net-next 04/16] mptcp: send out ADD_ADDR with echo flag
Date:   Thu, 24 Sep 2020 08:29:50 +0800
Message-Id: <f9b7f06f71698c2e78366da929a7fef173d01856.1600853093.git.geliangtang@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1600853093.git.geliangtang@gmail.com>
References: <cover.1600853093.git.geliangtang@gmail.com>
In-Reply-To: <bf7aca2bee20de148728e30343734628aee6d779.1600853093.git.geliangtang@gmail.com>
References: <cover.1600853093.git.geliangtang@gmail.com> <bfecdd638bb74a02de1c3f1c84239911e304fcc3.1600853093.git.geliangtang@gmail.com> <e3c9ab612d773465ddf78cef0482208c73a0ca07.1600853093.git.geliangtang@gmail.com> <bf7aca2bee20de148728e30343734628aee6d779.1600853093.git.geliangtang@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the ADD_ADDR suboption has been received, we need to send out the same
ADD_ADDR suboption with echo-flag=1, and no HMAC.

Suggested-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Geliang Tang <geliangtang@gmail.com>
---
 net/mptcp/options.c    | 27 ++++++++++++++++-----------
 net/mptcp/pm.c         | 18 +++++++++---------
 net/mptcp/pm_netlink.c |  4 +++-
 net/mptcp/protocol.h   |  6 ++++--
 4 files changed, 32 insertions(+), 23 deletions(-)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index a52a05effac9..a41996e6c6d7 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -242,7 +242,7 @@ static void mptcp_parse_option(const struct sk_buff *skb,
 		mp_opt->add_addr = 1;
 		mp_opt->port = 0;
 		mp_opt->addr_id = *ptr++;
-		pr_debug("ADD_ADDR: id=%d", mp_opt->addr_id);
+		pr_debug("ADD_ADDR: id=%d, echo=%d", mp_opt->addr_id, mp_opt->echo);
 		if (mp_opt->family == MPTCP_ADDR_IPVERSION_4) {
 			memcpy((u8 *)&mp_opt->addr.s_addr, (u8 *)ptr, 4);
 			ptr += 4;
@@ -579,10 +579,11 @@ static bool mptcp_established_options_add_addr(struct sock *sk,
 	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(sk);
 	struct mptcp_sock *msk = mptcp_sk(subflow->conn);
 	struct mptcp_addr_info saddr;
+	bool echo;
 	int len;
 
 	if (!mptcp_pm_should_add_signal(msk) ||
-	    !(mptcp_pm_add_addr_signal(msk, remaining, &saddr)))
+	    !(mptcp_pm_add_addr_signal(msk, remaining, &saddr, &echo)))
 		return false;
 
 	len = mptcp_add_addr_len(saddr.family);
@@ -594,22 +595,26 @@ static bool mptcp_established_options_add_addr(struct sock *sk,
 	if (saddr.family == AF_INET) {
 		opts->suboptions |= OPTION_MPTCP_ADD_ADDR;
 		opts->addr = saddr.addr;
-		opts->ahmac = add_addr_generate_hmac(msk->local_key,
-						     msk->remote_key,
-						     opts->addr_id,
-						     &opts->addr);
+		if (!echo) {
+			opts->ahmac = add_addr_generate_hmac(msk->local_key,
+							     msk->remote_key,
+							     opts->addr_id,
+							     &opts->addr);
+		}
 	}
 #if IS_ENABLED(CONFIG_MPTCP_IPV6)
 	else if (saddr.family == AF_INET6) {
 		opts->suboptions |= OPTION_MPTCP_ADD_ADDR6;
 		opts->addr6 = saddr.addr6;
-		opts->ahmac = add_addr6_generate_hmac(msk->local_key,
-						      msk->remote_key,
-						      opts->addr_id,
-						      &opts->addr6);
+		if (!echo) {
+			opts->ahmac = add_addr6_generate_hmac(msk->local_key,
+							      msk->remote_key,
+							      opts->addr_id,
+							      &opts->addr6);
+		}
 	}
 #endif
-	pr_debug("addr_id=%d, ahmac=%llu", opts->addr_id, opts->ahmac);
+	pr_debug("addr_id=%d, ahmac=%llu, echo=%d", opts->addr_id, opts->ahmac, echo);
 
 	return true;
 }
diff --git a/net/mptcp/pm.c b/net/mptcp/pm.c
index 558462d87eb3..39a76620d0a5 100644
--- a/net/mptcp/pm.c
+++ b/net/mptcp/pm.c
@@ -13,11 +13,13 @@
 /* path manager command handlers */
 
 int mptcp_pm_announce_addr(struct mptcp_sock *msk,
-			   const struct mptcp_addr_info *addr)
+			   const struct mptcp_addr_info *addr,
+			   bool echo)
 {
 	pr_debug("msk=%p, local_id=%d", msk, addr->id);
 
 	msk->pm.local = *addr;
+	WRITE_ONCE(msk->pm.add_addr_echo, echo);
 	WRITE_ONCE(msk->pm.add_addr_signal, true);
 	return 0;
 }
@@ -135,15 +137,11 @@ void mptcp_pm_add_addr_received(struct mptcp_sock *msk,
 	pr_debug("msk=%p remote_id=%d accept=%d", msk, addr->id,
 		 READ_ONCE(pm->accept_addr));
 
-	/* avoid acquiring the lock if there is no room for fouther addresses */
-	if (!READ_ONCE(pm->accept_addr))
-		return;
-
 	spin_lock_bh(&pm->lock);
 
-	/* be sure there is something to signal re-checking under PM lock */
-	if (READ_ONCE(pm->accept_addr) &&
-	    mptcp_pm_schedule_work(msk, MPTCP_PM_ADD_ADDR_RECEIVED))
+	if (!READ_ONCE(pm->accept_addr))
+		mptcp_pm_announce_addr(msk, addr, true);
+	else if (mptcp_pm_schedule_work(msk, MPTCP_PM_ADD_ADDR_RECEIVED))
 		pm->remote = *addr;
 
 	spin_unlock_bh(&pm->lock);
@@ -164,7 +162,7 @@ void mptcp_pm_rm_addr_received(struct mptcp_sock *msk, u8 rm_id)
 /* path manager helpers */
 
 bool mptcp_pm_add_addr_signal(struct mptcp_sock *msk, unsigned int remaining,
-			      struct mptcp_addr_info *saddr)
+			      struct mptcp_addr_info *saddr, bool *echo)
 {
 	int ret = false;
 
@@ -178,6 +176,7 @@ bool mptcp_pm_add_addr_signal(struct mptcp_sock *msk, unsigned int remaining,
 		goto out_unlock;
 
 	*saddr = msk->pm.local;
+	*echo = READ_ONCE(msk->pm.add_addr_echo);
 	WRITE_ONCE(msk->pm.add_addr_signal, false);
 	ret = true;
 
@@ -226,6 +225,7 @@ void mptcp_pm_data_init(struct mptcp_sock *msk)
 	WRITE_ONCE(msk->pm.rm_addr_signal, false);
 	WRITE_ONCE(msk->pm.accept_addr, false);
 	WRITE_ONCE(msk->pm.accept_subflow, false);
+	WRITE_ONCE(msk->pm.add_addr_echo, false);
 	msk->pm.status = 0;
 
 	spin_lock_init(&msk->pm.lock);
diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index 4124bc581308..f6f96bc2046b 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -198,7 +198,7 @@ static void mptcp_pm_create_subflow_or_signal_addr(struct mptcp_sock *msk)
 
 		if (local) {
 			msk->pm.add_addr_signaled++;
-			mptcp_pm_announce_addr(msk, &local->addr);
+			mptcp_pm_announce_addr(msk, &local->addr, false);
 		} else {
 			/* pick failed, avoid fourther attempts later */
 			msk->pm.local_addr_used = msk->pm.add_addr_signal_max;
@@ -266,6 +266,8 @@ void mptcp_pm_nl_add_addr_received(struct mptcp_sock *msk)
 	spin_unlock_bh(&msk->pm.lock);
 	__mptcp_subflow_connect((struct sock *)msk, &local, &remote);
 	spin_lock_bh(&msk->pm.lock);
+
+	mptcp_pm_announce_addr(msk, &remote, true);
 }
 
 void mptcp_pm_nl_rm_addr_received(struct mptcp_sock *msk)
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 837e01057544..ba253a6947b0 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -169,6 +169,7 @@ struct mptcp_pm_data {
 	bool		work_pending;
 	bool		accept_addr;
 	bool		accept_subflow;
+	bool		add_addr_echo;
 	u8		add_addr_signaled;
 	u8		add_addr_accepted;
 	u8		local_addr_used;
@@ -442,7 +443,8 @@ void mptcp_pm_add_addr_received(struct mptcp_sock *msk,
 void mptcp_pm_rm_addr_received(struct mptcp_sock *msk, u8 rm_id);
 
 int mptcp_pm_announce_addr(struct mptcp_sock *msk,
-			   const struct mptcp_addr_info *addr);
+			   const struct mptcp_addr_info *addr,
+			   bool echo);
 int mptcp_pm_remove_addr(struct mptcp_sock *msk, u8 local_id);
 int mptcp_pm_remove_subflow(struct mptcp_sock *msk, u8 remote_id);
 
@@ -464,7 +466,7 @@ static inline unsigned int mptcp_add_addr_len(int family)
 }
 
 bool mptcp_pm_add_addr_signal(struct mptcp_sock *msk, unsigned int remaining,
-			      struct mptcp_addr_info *saddr);
+			      struct mptcp_addr_info *saddr, bool *echo);
 bool mptcp_pm_rm_addr_signal(struct mptcp_sock *msk, unsigned int remaining,
 			     u8 *rm_id);
 int mptcp_pm_get_local_id(struct mptcp_sock *msk, struct sock_common *skc);
-- 
2.17.1

