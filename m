Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DFA72765AA
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 03:08:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726865AbgIXBIS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 21:08:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726466AbgIXBIR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 21:08:17 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 501FFC0613CE;
        Wed, 23 Sep 2020 18:08:17 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id d13so828872pgl.6;
        Wed, 23 Sep 2020 18:08:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=D44zEIzkJpGFZZHwFr0DZrJnGZo5Lqy+h+Ivlhe8vL8=;
        b=UPLyAaVJzCX4A5plAF0MuUyw+wfWz+m0IwbUEUq19QwoE7QOsvllmxML77tovPIkYL
         g/Se4U/xP2rdovEIkRUTOu0WN8uo2Hckhm/Ufgmm/uW3F3hljekH0lskKOJ1kxzcixe5
         1X139BTlnptzmw1/BD8pItELiEJpGYjP0ZcZdmDCueJgJjh58tT7gCdd9y4ZWJ3M9aKu
         WhC5C40TljFO2/iCmO4Ajc2aqygN26gltVmd1YRADnMzX6jIjSxOO1u9xvcZZRnG9gzd
         Ko7As07bS/4eWr87AFUp4aNHysT45YwOMteQS3qrD2zSfOqETYOjmUX2h4lhXl0E1Awa
         SJ4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=D44zEIzkJpGFZZHwFr0DZrJnGZo5Lqy+h+Ivlhe8vL8=;
        b=M6P33/Xxq7ooba9XXirW21fpYRIlnkTbqDb6WJCzTMebMQHHWULxA31USYutxRSxiB
         cuDYgzdhL0p6IZCxFzTY3ttxmXjkjiX/CRLQu0+i17Qj4EznGmZypodh+nRGsROSx3cr
         X1kVy8S5iRNbIIC9pUuNF2XDIWFi95J2f4+rSWt2jOb6UQHHHvhOKfvbuSpyGeClGXSj
         ZEWlaLmAJ0QgQlAtsBD9SnOyNOeZm+3lyVrjpfkWbCswgjUGF9KZIIJZDrNpsAkiOQ3j
         euzro2docqiBLVHGMv2abR6qZ4yqrPMdH3f0UtZttJQ903xmID0S1kvx9GfMf5VmBBFw
         Mc9Q==
X-Gm-Message-State: AOAM533a21rehhztqb6PA/Sh4fIep/RnoPq9ldfO8RmlbnBHvaTs41hw
        0hyrMP0B/rSz/lTkksOmAXs=
X-Google-Smtp-Source: ABdhPJxNVVu5rHR7b34jG+uQyoEy2O8dv8zadxyQWxfDDdrH0jyltgSBvfCy/Nq83S8t3Fc+UPQpDg==
X-Received: by 2002:a62:545:0:b029:142:2501:35db with SMTP id 66-20020a6205450000b0290142250135dbmr2254828pff.59.1600909696874;
        Wed, 23 Sep 2020 18:08:16 -0700 (PDT)
Received: from localhost ([43.224.245.180])
        by smtp.gmail.com with ESMTPSA id h31sm871129pgh.71.2020.09.23.18.08.15
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 23 Sep 2020 18:08:16 -0700 (PDT)
From:   Geliang Tang <geliangtang@gmail.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Geliang Tang <geliangtang@gmail.com>, netdev@vger.kernel.org,
        mptcp@lists.01.org, linux-kernel@vger.kernel.org
Subject: [MPTCP][PATCH net-next 16/16] mptcp: retransmit ADD_ADDR when timeout
Date:   Thu, 24 Sep 2020 08:30:02 +0800
Message-Id: <8d5db133c22f03ed112b13fdc2a36ed4168295d8.1600853093.git.geliangtang@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1600853093.git.geliangtang@gmail.com>
References: <cover.1600853093.git.geliangtang@gmail.com>
In-Reply-To: <31247220b62d6759de9eb91b841be449714b9d69.1600853093.git.geliangtang@gmail.com>
References: <cover.1600853093.git.geliangtang@gmail.com> <bfecdd638bb74a02de1c3f1c84239911e304fcc3.1600853093.git.geliangtang@gmail.com>
 <e3c9ab612d773465ddf78cef0482208c73a0ca07.1600853093.git.geliangtang@gmail.com>
 <bf7aca2bee20de148728e30343734628aee6d779.1600853093.git.geliangtang@gmail.com>
 <f9b7f06f71698c2e78366da929a7fef173d01856.1600853093.git.geliangtang@gmail.com>
 <430dd4f9c241ae990a5cfa6809276b36993ce91b.1600853093.git.geliangtang@gmail.com>
 <7b0898eff793dde434464b5fac2629739d9546fd.1600853093.git.geliangtang@gmail.com>
 <98bcc56283c482c294bd6ae9ce1476821ddc6837.1600853093.git.geliangtang@gmail.com>
 <37f2befac450fb46367f62446a4bb2c9d0a5986a.1600853093.git.geliangtang@gmail.com>
 <5018fd495529e058ea866e8d8edbe0bb98ec733a.1600853093.git.geliangtang@gmail.com>
 <644420f22ba6f0b9f9f3509c081d8d639ff4bbf3.1600853093.git.geliangtang@gmail.com>
 <fcebccadfa3127e0f55103cc7ee4cd00841e2ea0.1600853093.git.geliangtang@gmail.com>
 <aa4ffb8cb7f8c135e5704eb11cfce7cb0bf7ecd4.1600853093.git.geliangtang@gmail.com>
 <e0f074f2764382c6aa1e901f3003455261a33da3.1600853093.git.geliangtang@gmail.com>
 <26617b54898c115de8d916633b8e42055ed5c678.1600853093.git.geliangtang@gmail.com>
 <31247220b62d6759de9eb91b841be449714b9d69.1600853093.git.geliangtang@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch implemented the retransmition of ADD_ADDR when no ADD_ADDR echo
is received. It added a timer with the announced address. When timeout
occurs, ADD_ADDR will be retransmitted.

Suggested-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Suggested-by: Paolo Abeni <pabeni@redhat.com>
Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Geliang Tang <geliangtang@gmail.com>
---
 net/mptcp/options.c    |   1 +
 net/mptcp/pm_netlink.c | 109 ++++++++++++++++++++++++++++++++++-------
 net/mptcp/protocol.h   |   3 ++
 3 files changed, 96 insertions(+), 17 deletions(-)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index 171039cbe9c4..14a290fae767 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -893,6 +893,7 @@ void mptcp_incoming_options(struct sock *sk, struct sk_buff *skb,
 			mptcp_pm_add_addr_received(msk, &addr);
 			MPTCP_INC_STATS(sock_net(sk), MPTCP_MIB_ADDADDR);
 		} else {
+			mptcp_pm_del_add_timer(msk, &addr);
 			MPTCP_INC_STATS(sock_net(sk), MPTCP_MIB_ECHOADD);
 		}
 		mp_opt.add_addr = 0;
diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index 701972b55a45..5a0e4d11bcc3 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -31,6 +31,9 @@ struct mptcp_pm_addr_entry {
 struct mptcp_pm_add_entry {
 	struct list_head	list;
 	struct mptcp_addr_info	addr;
+	struct timer_list	add_timer;
+	struct mptcp_sock	*sock;
+	u8			retrans_times;
 };
 
 struct pm_nl_pernet {
@@ -46,6 +49,7 @@ struct pm_nl_pernet {
 };
 
 #define MPTCP_PM_ADDR_MAX	8
+#define ADD_ADDR_RETRANS_MAX	3
 
 static bool addresses_equal(const struct mptcp_addr_info *a,
 			    struct mptcp_addr_info *b, bool use_port)
@@ -183,23 +187,83 @@ static void check_work_pending(struct mptcp_sock *msk)
 		WRITE_ONCE(msk->pm.work_pending, false);
 }
 
-static bool lookup_anno_list_by_saddr(struct mptcp_sock *msk,
-				      struct mptcp_addr_info *addr)
+static struct mptcp_pm_add_entry *
+lookup_anno_list_by_saddr(struct mptcp_sock *msk,
+			  struct mptcp_addr_info *addr)
 {
 	struct mptcp_pm_add_entry *entry;
 
 	list_for_each_entry(entry, &msk->pm.anno_list, list) {
 		if (addresses_equal(&entry->addr, addr, false))
-			return true;
+			return entry;
 	}
 
-	return false;
+	return NULL;
+}
+
+static void mptcp_pm_add_timer(struct timer_list *timer)
+{
+	struct mptcp_pm_add_entry *entry = from_timer(entry, timer, add_timer);
+	struct mptcp_sock *msk = entry->sock;
+	struct sock *sk = (struct sock *)msk;
+
+	pr_debug("msk=%p", msk);
+
+	if (!msk)
+		return;
+
+	if (inet_sk_state_load(sk) == TCP_CLOSE)
+		return;
+
+	if (!entry->addr.id)
+		return;
+
+	if (mptcp_pm_should_add_signal(msk)) {
+		sk_reset_timer(sk, timer, jiffies + TCP_RTO_MAX / 8);
+		goto out;
+	}
+
+	spin_lock_bh(&msk->pm.lock);
+
+	if (!mptcp_pm_should_add_signal(msk)) {
+		pr_debug("retransmit ADD_ADDR id=%d", entry->addr.id);
+		mptcp_pm_announce_addr(msk, &entry->addr, false);
+		entry->retrans_times++;
+	}
+
+	if (entry->retrans_times < ADD_ADDR_RETRANS_MAX)
+		sk_reset_timer(sk, timer, jiffies + TCP_RTO_MAX);
+
+	spin_unlock_bh(&msk->pm.lock);
+
+out:
+	__sock_put(sk);
+}
+
+struct mptcp_pm_add_entry *
+mptcp_pm_del_add_timer(struct mptcp_sock *msk,
+		       struct mptcp_addr_info *addr)
+{
+	struct mptcp_pm_add_entry *entry;
+	struct sock *sk = (struct sock *)msk;
+
+	spin_lock_bh(&msk->pm.lock);
+	entry = lookup_anno_list_by_saddr(msk, addr);
+	if (entry)
+		entry->retrans_times = ADD_ADDR_RETRANS_MAX;
+	spin_unlock_bh(&msk->pm.lock);
+
+	if (entry)
+		sk_stop_timer_sync(sk, &entry->add_timer);
+
+	return entry;
 }
 
 static bool mptcp_pm_alloc_anno_list(struct mptcp_sock *msk,
 				     struct mptcp_pm_addr_entry *entry)
 {
 	struct mptcp_pm_add_entry *add_entry = NULL;
+	struct sock *sk = (struct sock *)msk;
 
 	if (lookup_anno_list_by_saddr(msk, &entry->addr))
 		return false;
@@ -210,21 +274,32 @@ static bool mptcp_pm_alloc_anno_list(struct mptcp_sock *msk,
 
 	list_add(&add_entry->list, &msk->pm.anno_list);
 
+	add_entry->addr = entry->addr;
+	add_entry->sock = msk;
+	add_entry->retrans_times = 0;
+
+	timer_setup(&add_entry->add_timer, mptcp_pm_add_timer, 0);
+	sk_reset_timer(sk, &add_entry->add_timer, jiffies + TCP_RTO_MAX);
+
 	return true;
 }
 
 void mptcp_pm_free_anno_list(struct mptcp_sock *msk)
 {
 	struct mptcp_pm_add_entry *entry, *tmp;
+	struct sock *sk = (struct sock *)msk;
+	LIST_HEAD(free_list);
 
 	pr_debug("msk=%p", msk);
 
 	spin_lock_bh(&msk->pm.lock);
-	list_for_each_entry_safe(entry, tmp, &msk->pm.anno_list, list) {
-		list_del(&entry->list);
+	list_splice_init(&msk->pm.anno_list, &free_list);
+	spin_unlock_bh(&msk->pm.lock);
+
+	list_for_each_entry_safe(entry, tmp, &free_list, list) {
+		sk_stop_timer_sync(sk, &entry->add_timer);
 		kfree(entry);
 	}
-	spin_unlock_bh(&msk->pm.lock);
 }
 
 static void mptcp_pm_create_subflow_or_signal_addr(struct mptcp_sock *msk)
@@ -659,14 +734,13 @@ __lookup_addr_by_id(struct pm_nl_pernet *pernet, unsigned int id)
 static bool remove_anno_list_by_saddr(struct mptcp_sock *msk,
 				      struct mptcp_addr_info *addr)
 {
-	struct mptcp_pm_add_entry *entry, *tmp;
+	struct mptcp_pm_add_entry *entry;
 
-	list_for_each_entry_safe(entry, tmp, &msk->pm.anno_list, list) {
-		if (addresses_equal(&entry->addr, addr, false)) {
-			list_del(&entry->list);
-			kfree(entry);
-			return true;
-		}
+	entry = mptcp_pm_del_add_timer(msk, addr);
+	if (entry) {
+		list_del(&entry->list);
+		kfree(entry);
+		return true;
 	}
 
 	return false;
@@ -678,11 +752,12 @@ static bool mptcp_pm_remove_anno_addr(struct mptcp_sock *msk,
 {
 	bool ret;
 
-	spin_lock_bh(&msk->pm.lock);
 	ret = remove_anno_list_by_saddr(msk, addr);
-	if (ret || force)
+	if (ret || force) {
+		spin_lock_bh(&msk->pm.lock);
 		mptcp_pm_remove_addr(msk, addr->id);
-	spin_unlock_bh(&msk->pm.lock);
+		spin_unlock_bh(&msk->pm.lock);
+	}
 	return ret;
 }
 
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index db1e5de2fee7..7cfe52aeb2b8 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -444,6 +444,9 @@ void mptcp_pm_add_addr_received(struct mptcp_sock *msk,
 				const struct mptcp_addr_info *addr);
 void mptcp_pm_rm_addr_received(struct mptcp_sock *msk, u8 rm_id);
 void mptcp_pm_free_anno_list(struct mptcp_sock *msk);
+struct mptcp_pm_add_entry *
+mptcp_pm_del_add_timer(struct mptcp_sock *msk,
+		       struct mptcp_addr_info *addr);
 
 int mptcp_pm_announce_addr(struct mptcp_sock *msk,
 			   const struct mptcp_addr_info *addr,
-- 
2.17.1

