Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FC71276532
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 02:36:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726718AbgIXAgt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 20:36:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726466AbgIXAgs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 20:36:48 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAE05C0613CE;
        Wed, 23 Sep 2020 17:36:48 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id x123so752016pfc.7;
        Wed, 23 Sep 2020 17:36:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=ORdayEcB6Jwr1V/XibOxOCaVamwqt11GBumuX4Saw/U=;
        b=UZJn47/rMq9wo1hqsl9HCElkQ0fKK/lBzBTpIg3UtOZbrxYNxi9VGJ8vT+Ml1V4RSK
         QfcM9RqCwErgCWBjNn22WzQgxFXQoMyoAoATsncfa3tEmAPrPrSXmNuUKV5CdC9aC29J
         sJ1GfLP6hLwYZgsMPPKKVsI3NzNdFzfO5Dvgp4fhdMejvip817CEhoachFKZI/YVRFrr
         CEnRTY+KP04cElZIoK6+9kxUX4TB33ynRHbVEm0hXRGk8fg0V+zkQQKnm2zO4xo5r8SZ
         cASScoFqq/k/n7fznaYl8JLPXvRX7/Mois+BUUa3HO1kqLHyS48bsnohjdYKfvExUof+
         1dYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=ORdayEcB6Jwr1V/XibOxOCaVamwqt11GBumuX4Saw/U=;
        b=qtsHzwgOB8G5BX4eEX4z1gLGIcJiKL1wYCITqcBOJhgLz5EBFTjfVnD58O76DwAmfw
         YxXNDcPgPThlcsB/jGi7rMCoX0IoFHWnqp0imjb5YVn/Qqi3ltAeyDFVowwT4FJZOxii
         xpbOGPTo9ZOB6+Iag63xC/BPYiaLJYRkiTUFfxwOulB4HFQxA2g9yV276Tc+90lLX2Ad
         a4CqMeD3w9oRS8q/5xXNXyHa+NcgcqH8nfWMX4MUw3rPUYudRCV2iqa5bZU69T8oaDk4
         FH52DC/lx05VKuG1qMJzWlpOAMNZ7fMmr6zlLq3TABqX7Nk6re4MCkE4pwS5h894o7aG
         rlXQ==
X-Gm-Message-State: AOAM5336Zx6P4kaHaBNFX71bY9USHGuaOtLpohGF3ZaDN6zerxTGSeR1
        9mGqGg1sd4rXgzTrg6x8y2A=
X-Google-Smtp-Source: ABdhPJwtM1iWkXGgvrWLTX5IUNyf4wVbDIZ4+iy9hJrdoLwKv82XPYIFQOzWjYT2sC6YSuQwjsjn5g==
X-Received: by 2002:a05:6a00:1b:b029:13e:d13d:a101 with SMTP id h27-20020a056a00001bb029013ed13da101mr2119332pfk.29.1600907808354;
        Wed, 23 Sep 2020 17:36:48 -0700 (PDT)
Received: from localhost ([43.224.245.180])
        by smtp.gmail.com with ESMTPSA id b203sm712076pfb.205.2020.09.23.17.36.47
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 23 Sep 2020 17:36:47 -0700 (PDT)
From:   Geliang Tang <geliangtang@gmail.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Geliang Tang <geliangtang@gmail.com>, netdev@vger.kernel.org,
        mptcp@lists.01.org, linux-kernel@vger.kernel.org
Subject: [MPTCP][PATCH net-next 02/16] mptcp: add the outgoing RM_ADDR support
Date:   Thu, 24 Sep 2020 08:29:48 +0800
Message-Id: <e3c9ab612d773465ddf78cef0482208c73a0ca07.1600853093.git.geliangtang@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1600853093.git.geliangtang@gmail.com>
References: <cover.1600853093.git.geliangtang@gmail.com>
In-Reply-To: <bfecdd638bb74a02de1c3f1c84239911e304fcc3.1600853093.git.geliangtang@gmail.com>
References: <cover.1600853093.git.geliangtang@gmail.com> <bfecdd638bb74a02de1c3f1c84239911e304fcc3.1600853093.git.geliangtang@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch added a new signal named rm_addr_signal in PM. On outgoing path,
we called mptcp_pm_should_rm_signal to check if rm_addr_signal has been
set. If it has been, we sent out the RM_ADDR option.

Suggested-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Suggested-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Geliang Tang <geliangtang@gmail.com>
---
 net/mptcp/options.c  | 29 +++++++++++++++++++++++++++++
 net/mptcp/pm.c       | 25 +++++++++++++++++++++++++
 net/mptcp/protocol.h |  9 +++++++++
 3 files changed, 63 insertions(+)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index ee0cb0546324..bbc124876417 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -614,6 +614,31 @@ static bool mptcp_established_options_add_addr(struct sock *sk,
 	return true;
 }
 
+static bool mptcp_established_options_rm_addr(struct sock *sk,
+					      unsigned int *size,
+					      unsigned int remaining,
+					      struct mptcp_out_options *opts)
+{
+	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(sk);
+	struct mptcp_sock *msk = mptcp_sk(subflow->conn);
+	u8 rm_id;
+
+	if (!mptcp_pm_should_rm_signal(msk) ||
+	    !(mptcp_pm_rm_addr_signal(msk, remaining, &rm_id)))
+		return false;
+
+	if (remaining < TCPOLEN_MPTCP_RM_ADDR_BASE)
+		return false;
+
+	*size = TCPOLEN_MPTCP_RM_ADDR_BASE;
+	opts->suboptions |= OPTION_MPTCP_RM_ADDR;
+	opts->rm_id = rm_id;
+
+	pr_debug("rm_id=%d", opts->rm_id);
+
+	return true;
+}
+
 bool mptcp_established_options(struct sock *sk, struct sk_buff *skb,
 			       unsigned int *size, unsigned int remaining,
 			       struct mptcp_out_options *opts)
@@ -644,6 +669,10 @@ bool mptcp_established_options(struct sock *sk, struct sk_buff *skb,
 		*size += opt_size;
 		remaining -= opt_size;
 		ret = true;
+	} else if (mptcp_established_options_rm_addr(sk, &opt_size, remaining, opts)) {
+		*size += opt_size;
+		remaining -= opt_size;
+		ret = true;
 	}
 
 	return ret;
diff --git a/net/mptcp/pm.c b/net/mptcp/pm.c
index ce12b8b26ad2..81b07ae213b9 100644
--- a/net/mptcp/pm.c
+++ b/net/mptcp/pm.c
@@ -174,6 +174,29 @@ bool mptcp_pm_add_addr_signal(struct mptcp_sock *msk, unsigned int remaining,
 	return ret;
 }
 
+bool mptcp_pm_rm_addr_signal(struct mptcp_sock *msk, unsigned int remaining,
+			     u8 *rm_id)
+{
+	int ret = false;
+
+	spin_lock_bh(&msk->pm.lock);
+
+	/* double check after the lock is acquired */
+	if (!mptcp_pm_should_rm_signal(msk))
+		goto out_unlock;
+
+	if (remaining < TCPOLEN_MPTCP_RM_ADDR_BASE)
+		goto out_unlock;
+
+	*rm_id = msk->pm.rm_id;
+	WRITE_ONCE(msk->pm.rm_addr_signal, false);
+	ret = true;
+
+out_unlock:
+	spin_unlock_bh(&msk->pm.lock);
+	return ret;
+}
+
 int mptcp_pm_get_local_id(struct mptcp_sock *msk, struct sock_common *skc)
 {
 	return mptcp_pm_nl_get_local_id(msk, skc);
@@ -185,8 +208,10 @@ void mptcp_pm_data_init(struct mptcp_sock *msk)
 	msk->pm.add_addr_accepted = 0;
 	msk->pm.local_addr_used = 0;
 	msk->pm.subflows = 0;
+	msk->pm.rm_id = 0;
 	WRITE_ONCE(msk->pm.work_pending, false);
 	WRITE_ONCE(msk->pm.add_addr_signal, false);
+	WRITE_ONCE(msk->pm.rm_addr_signal, false);
 	WRITE_ONCE(msk->pm.accept_addr, false);
 	WRITE_ONCE(msk->pm.accept_subflow, false);
 	msk->pm.status = 0;
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 91adc9a19757..8929b0c7660a 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -163,6 +163,7 @@ struct mptcp_pm_data {
 	spinlock_t	lock;		/*protects the whole PM data */
 
 	bool		add_addr_signal;
+	bool		rm_addr_signal;
 	bool		server_side;
 	bool		work_pending;
 	bool		accept_addr;
@@ -176,6 +177,7 @@ struct mptcp_pm_data {
 	u8		local_addr_max;
 	u8		subflows_max;
 	u8		status;
+	u8		rm_id;
 };
 
 struct mptcp_data_frag {
@@ -443,6 +445,11 @@ static inline bool mptcp_pm_should_add_signal(struct mptcp_sock *msk)
 	return READ_ONCE(msk->pm.add_addr_signal);
 }
 
+static inline bool mptcp_pm_should_rm_signal(struct mptcp_sock *msk)
+{
+	return READ_ONCE(msk->pm.rm_addr_signal);
+}
+
 static inline unsigned int mptcp_add_addr_len(int family)
 {
 	if (family == AF_INET)
@@ -452,6 +459,8 @@ static inline unsigned int mptcp_add_addr_len(int family)
 
 bool mptcp_pm_add_addr_signal(struct mptcp_sock *msk, unsigned int remaining,
 			      struct mptcp_addr_info *saddr);
+bool mptcp_pm_rm_addr_signal(struct mptcp_sock *msk, unsigned int remaining,
+			     u8 *rm_id);
 int mptcp_pm_get_local_id(struct mptcp_sock *msk, struct sock_common *skc);
 
 void __init mptcp_pm_nl_init(void);
-- 
2.17.1

