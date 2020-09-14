Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF6422686C2
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 10:04:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726169AbgINIDi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 04:03:38 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:23416 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726183AbgINIBw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 04:01:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600070511;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kIMFlGpN1mKpAOzIPYK4DjVND6tX/IshyT7nXyNyzgU=;
        b=G3TuMTBt5bMhmOY1+c4ildZIYgys03wZuDr5DkMWVFFn9wTwB6FpAl8EN4AXVCyhuqKlm/
        MTjbyYltyg3LXzljhtS0mDTtbncYIZ7H7vWkRhE1Fe87sYKLRh3rk7XWQB1L1Pc4cE7ygi
        04j+s0JBkAOydxidbG9zsdEhHFGsYCM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-588-Gmj3rpPsNsCxCvd1lQKTVA-1; Mon, 14 Sep 2020 04:01:49 -0400
X-MC-Unique: Gmj3rpPsNsCxCvd1lQKTVA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 67616185A0F7;
        Mon, 14 Sep 2020 08:01:48 +0000 (UTC)
Received: from linux.fritz.box.com (ovpn-112-96.ams2.redhat.com [10.36.112.96])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 299B119C66;
        Mon, 14 Sep 2020 08:01:46 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, mptcp@lists.01.org
Subject: [PATCH net-next v2 07/13] mptcp: cleanup mptcp_subflow_discard_data()
Date:   Mon, 14 Sep 2020 10:01:13 +0200
Message-Id: <f62a0071f94505b78dd32140b685cd938560008e.1599854632.git.pabeni@redhat.com>
In-Reply-To: <cover.1599854632.git.pabeni@redhat.com>
References: <cover.1599854632.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
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
index 0a602acf1f3d..26f5f81f3f4c 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -355,7 +355,6 @@ int mptcp_is_enabled(struct net *net);
 void mptcp_subflow_fully_established(struct mptcp_subflow_context *subflow,
 				     struct mptcp_options_received *mp_opt);
 bool mptcp_subflow_data_available(struct sock *sk);
-int mptcp_subflow_discard_data(struct sock *sk, unsigned int limit);
 void __init mptcp_subflow_init(void);
 
 /* called with sk socket lock held */
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 0b1d73a69daf..6eb2fc0a8ebb 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -805,50 +805,22 @@ static enum mapping_status get_mapping_status(struct sock *ssk,
 	return MAPPING_OK;
 }
 
-static int subflow_read_actor(read_descriptor_t *desc,
-			      struct sk_buff *skb,
-			      unsigned int offset, size_t len)
+static void mptcp_subflow_discard_data(struct sock *ssk, struct sk_buff *skb,
+				       unsigned int limit)
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
 
-int mptcp_subflow_discard_data(struct sock *ssk, unsigned int limit)
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

