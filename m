Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24AE421A091
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 15:13:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726852AbgGINNI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 09:13:08 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:20344 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726768AbgGINNH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 09:13:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594300386;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=g88G6SOPze+ERSqiV35fwTWqfVFJiYKD24rvObvqW/I=;
        b=XR3krtb6TQUS3Mr8C1OY4/guUMKqPjSUG9S7/0Z/3SrMHTtigMd5g1f4y43vk7dgrX0Oi5
        CEYE+YM/xXQJJNnrEDH1/TTfR/kD6kqJ5cG3vZ8KX7MZd8jtdBWfAxJD5TZPhVAxR7DQBI
        1RPew+C4E7Nn8SKBNAvNkB6zTorlKAI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-356-6yGNn8GQPTGIe-Oq0jlHtQ-1; Thu, 09 Jul 2020 09:13:02 -0400
X-MC-Unique: 6yGNn8GQPTGIe-Oq0jlHtQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0676119200C3;
        Thu,  9 Jul 2020 13:13:01 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-113-239.ams2.redhat.com [10.36.113.239])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D1CE02DE76;
        Thu,  9 Jul 2020 13:12:59 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, mptcp@lists.01.org
Subject: [PATCH net-next 2/4] mptcp: add msk interations helper
Date:   Thu,  9 Jul 2020 15:12:40 +0200
Message-Id: <8ba0e08df6dfc0d41ec19c11c47f0e66696d8f07.1594292774.git.pabeni@redhat.com>
In-Reply-To: <cover.1594292774.git.pabeni@redhat.com>
References: <cover.1594292774.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

mptcp_token_iter_next() allow traversing all the MPTCP
sockets inside the token container belonging to the given
network namespace with a quite standard iterator semantic.

That will be used by the next patch, but keep the API generic,
as we plan to use this later for PM's sake.

Additionally export mptcp_token_get_sock(), as it also
will be used by the diag module.

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/mptcp/protocol.h |  2 ++
 net/mptcp/token.c    | 61 +++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 62 insertions(+), 1 deletion(-)

diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 39bfec3f1586..e5baaef5ec89 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -391,6 +391,8 @@ int mptcp_token_new_connect(struct sock *sk);
 void mptcp_token_accept(struct mptcp_subflow_request_sock *r,
 			struct mptcp_sock *msk);
 struct mptcp_sock *mptcp_token_get_sock(u32 token);
+struct mptcp_sock *mptcp_token_iter_next(const struct net *net, long *s_slot,
+					 long *s_num);
 void mptcp_token_destroy(struct mptcp_sock *msk);
 
 void mptcp_crypto_key_sha(u64 key, u32 *token, u64 *idsn);
diff --git a/net/mptcp/token.c b/net/mptcp/token.c
index 66a4990bd897..7d8106026081 100644
--- a/net/mptcp/token.c
+++ b/net/mptcp/token.c
@@ -238,6 +238,66 @@ struct mptcp_sock *mptcp_token_get_sock(u32 token)
 	rcu_read_unlock();
 	return msk;
 }
+EXPORT_SYMBOL_GPL(mptcp_token_get_sock);
+
+/**
+ * mptcp_token_iter_next - iterate over the token container from given pos
+ * @net: namespace to be iterated
+ * @s_slot: start slot number
+ * @s_num: start number inside the given lock
+ *
+ * This function returns the first mptcp connection structure found inside the
+ * token container starting from the specified position, or NULL.
+ *
+ * On successful iteration, the iterator is move to the next position and the
+ * the acquires a reference to the returned socket.
+ */
+struct mptcp_sock *mptcp_token_iter_next(const struct net *net, long *s_slot,
+					 long *s_num)
+{
+	struct mptcp_sock *ret = NULL;
+	struct hlist_nulls_node *pos;
+	int slot, num;
+
+	for (slot = *s_slot; slot <= token_mask; *s_num = 0, slot++) {
+		struct token_bucket *bucket = &token_hash[slot];
+		struct sock *sk;
+
+		num = 0;
+
+		if (hlist_nulls_empty(&bucket->msk_chain))
+			continue;
+
+		rcu_read_lock();
+		sk_nulls_for_each_rcu(sk, pos, &bucket->msk_chain) {
+			++num;
+			if (!net_eq(sock_net(sk), net))
+				continue;
+
+			if (num <= *s_num)
+				continue;
+
+			if (!refcount_inc_not_zero(&sk->sk_refcnt))
+				continue;
+
+			if (!net_eq(sock_net(sk), net)) {
+				sock_put(sk);
+				continue;
+			}
+
+			ret = mptcp_sk(sk);
+			rcu_read_unlock();
+			goto out;
+		}
+		rcu_read_unlock();
+	}
+
+out:
+	*s_slot = slot;
+	*s_num = num;
+	return ret;
+}
+EXPORT_SYMBOL_GPL(mptcp_token_iter_next);
 
 /**
  * mptcp_token_destroy_request - remove mptcp connection/token
@@ -312,7 +372,6 @@ void __init mptcp_token_init(void)
 EXPORT_SYMBOL_GPL(mptcp_token_new_request);
 EXPORT_SYMBOL_GPL(mptcp_token_new_connect);
 EXPORT_SYMBOL_GPL(mptcp_token_accept);
-EXPORT_SYMBOL_GPL(mptcp_token_get_sock);
 EXPORT_SYMBOL_GPL(mptcp_token_destroy_request);
 EXPORT_SYMBOL_GPL(mptcp_token_destroy);
 #endif
-- 
2.26.2

