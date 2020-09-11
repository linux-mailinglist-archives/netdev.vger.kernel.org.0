Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC2D12664A3
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 18:43:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726459AbgIKQnL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 12:43:11 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:47389 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725962AbgIKPJ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 11:09:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599836966;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9UfEnhJe7Uj1BPlxjeuT1Gg9Oe2f5+ZByLidMiwRDq0=;
        b=WGUMGTkLv7NX9wTUF5O/Ou63KrLZzU00Clc3XPuRdDATNPvzdJUqrB9wvyep0c8F+FGr6V
        mRyfpavs/VsF9kS9hMvOYlywpOV5eoTUYy3inm3CmsmDSh4SmrCFwJqfdzZiHrIX5lSh9b
        uOhHlgpgm9edGg4AEqm6SIuuQ5fs6GA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-427-zkN9l0FUN42AigoxOMmHBQ-1; Fri, 11 Sep 2020 09:52:40 -0400
X-MC-Unique: zkN9l0FUN42AigoxOMmHBQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0D267AF215;
        Fri, 11 Sep 2020 13:52:38 +0000 (UTC)
Received: from linux.fritz.box.com (ovpn-114-214.ams2.redhat.com [10.36.114.214])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D8D375C22B;
        Fri, 11 Sep 2020 13:52:36 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, mptcp@lists.01.org
Subject: [PATCH net-next 07/13] mptcp: cleanup mptcp_subflow_discard_data()
Date:   Fri, 11 Sep 2020 15:52:02 +0200
Message-Id: <279e0dc27ff2e6c778120b3133b7d3b912a20135.1599832097.git.pabeni@redhat.com>
In-Reply-To: <cover.1599832097.git.pabeni@redhat.com>
References: <cover.1599832097.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is no need to use the tcp_read_sock(), we can
simply drop the skb. Additionally try to look at the
next buffer for in order data.

This both simplifies the code and avoid unneeded indirect
calls.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/mptcp/protocol.h |  1 -
 net/mptcp/subflow.c  | 58 +++++++++++---------------------------------
 2 files changed, 14 insertions(+), 45 deletions(-)

diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index e20154a33fa7..26f5f81f3f4c 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -355,7 +355,6 @@ int mptcp_is_enabled(struct net *net);
 void mptcp_subflow_fully_established(struct mptcp_subflow_context *subflow,
 				     struct mptcp_options_received *mp_opt);
 bool mptcp_subflow_data_available(struct sock *sk);
-int mptcp_subflow_discard_data(struct sock *sk, unsigned limit);
 void __init mptcp_subflow_init(void);
 
 /* called with sk socket lock held */
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 1f048a5bf120..c4c174749865 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -805,50 +805,22 @@ static enum mapping_status get_mapping_status(struct sock *ssk,
 	return MAPPING_OK;
 }
 
-static int subflow_read_actor(read_descriptor_t *desc,
-			      struct sk_buff *skb,
-			      unsigned int offset, size_t len)
+static void mptcp_subflow_discard_data(struct sock *ssk, struct sk_buff *skb,
+				       unsigned limit)
 {
-	size_t copy_len = min(desc->count, len);
-
-	desc->count -= copy_len;
+	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(ssk);
+	bool fin = TCP_SKB_CB(skb)->tcp_flags & TCPHDR_FIN;
+	u32 incr;
 
-	pr_debug("flushed %zu bytes, %zu left", copy_len, desc->count);
-	return copy_len;
-}
+	incr = limit >= skb->len ? skb->len + fin : limit;
 
-int mptcp_subflow_discard_data(struct sock *ssk, unsigned limit)
-{
-	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(ssk);
-	u32 map_remaining;
-	size_t delta;
-
-	map_remaining = subflow->map_data_len -
-			mptcp_subflow_get_map_offset(subflow);
-	delta = min_t(size_t, limit, map_remaining);
-
-	/* discard mapped data */
-	pr_debug("discarding %zu bytes, current map len=%d", delta,
-		 map_remaining);
-	if (delta) {
-		read_descriptor_t desc = {
-			.count = delta,
-		};
-		int ret;
-
-		ret = tcp_read_sock(ssk, &desc, subflow_read_actor);
-		if (ret < 0) {
-			ssk->sk_err = -ret;
-			return ret;
-		}
-		if (ret < delta)
-			return 0;
-		if (delta == map_remaining) {
-			subflow->data_avail = 0;
-			subflow->map_valid = 0;
-		}
-	}
-	return 0;
+	pr_debug("discarding=%d len=%d seq=%d", incr, skb->len,
+		 subflow->map_subflow_seq);
+	tcp_sk(ssk)->copied_seq += incr;
+	if (!before(tcp_sk(ssk)->copied_seq, TCP_SKB_CB(skb)->end_seq))
+		sk_eat_skb(ssk, skb);
+	if (mptcp_subflow_get_map_offset(subflow) >= subflow->map_data_len)
+		subflow->map_valid = 0;
 }
 
 static bool subflow_check_data_avail(struct sock *ssk)
@@ -923,9 +895,7 @@ static bool subflow_check_data_avail(struct sock *ssk)
 		/* only accept in-sequence mapping. Old values are spurious
 		 * retransmission
 		 */
-		if (mptcp_subflow_discard_data(ssk, old_ack - ack_seq))
-			goto fatal;
-		return false;
+		mptcp_subflow_discard_data(ssk, skb, old_ack - ack_seq);
 	}
 	return true;
 
-- 
2.26.2

