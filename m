Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B29B2DBFBE
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 12:50:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725965AbgLPLu0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 06:50:26 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39449 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725806AbgLPLuZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 06:50:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608119338;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oZymnfnkQoDkdLEP/PpajDTJn5dj9lcyFPXOS9Y0740=;
        b=CY/+hNZkKUaCxq59rMix4easoUXnIO3CAB/Fnxl/FLAa2ZETwARa9YjPbDbH+EmsKImM0/
        m0fWgv9iGtqIm0dssrp8B2OvOmnP1VV77qwKnCJbTX/8TiLn7QaLFjoia1qv71i/zxNJM+
        54Yy4uIDYeVlklZ8O0dA5MQ14MwrKi4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-275-AAIfeIRSNxGvQ43_9tDqIA-1; Wed, 16 Dec 2020 06:48:56 -0500
X-MC-Unique: AAIfeIRSNxGvQ43_9tDqIA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7A869102CB67;
        Wed, 16 Dec 2020 11:48:53 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-112-143.ams2.redhat.com [10.36.112.143])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3810060CC3;
        Wed, 16 Dec 2020 11:48:52 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, mptcp@lists.01.org
Subject: [PATCH net 3/4] mptcp: push pending frames when subflow has free space
Date:   Wed, 16 Dec 2020 12:48:34 +0100
Message-Id: <96d38017eb3b407449776e9ae788a4418496e55e.1608114076.git.pabeni@redhat.com>
In-Reply-To: <cover.1608114076.git.pabeni@redhat.com>
References: <cover.1608114076.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When multiple subflows are active, we can receive a
window update on subflow with no write space available.
MPTCP will try to push frames on such subflow and will
fail. Pending frames will be pushed only after receiving
a window update on a subflow with some wspace available.

Overall the above could lead to suboptimal aggregate
bandwidth usage.

Instead, we should try to push pending frames as soon as
the subflow reaches both conditions mentioned above.

We can finally enable self-tests with asymmetric links,
as the above makes them finally pass.

Fixes: 6f8a612a33e4 ("mptcp: keep track of advertised windows right edge")
Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/mptcp/options.c                               | 13 ++++++++-----
 net/mptcp/protocol.c                              |  2 +-
 net/mptcp/protocol.h                              |  2 +-
 tools/testing/selftests/net/mptcp/simult_flows.sh |  6 +++---
 4 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index c5328f407aab..1fbd305ebd92 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -873,10 +873,13 @@ static void ack_update_msk(struct mptcp_sock *msk,
 
 	new_wnd_end = new_snd_una + tcp_sk(ssk)->snd_wnd;
 
-	if (after64(new_wnd_end, msk->wnd_end)) {
+	if (after64(new_wnd_end, msk->wnd_end))
 		msk->wnd_end = new_wnd_end;
-		__mptcp_wnd_updated(sk, ssk);
-	}
+
+	/* this assumes mptcp_incoming_options() is invoked after tcp_ack() */
+	if (after64(msk->wnd_end, READ_ONCE(msk->snd_nxt)) &&
+	    sk_stream_memory_free(ssk))
+		__mptcp_check_push(sk, ssk);
 
 	if (after64(new_snd_una, old_snd_una)) {
 		msk->snd_una = new_snd_una;
@@ -942,8 +945,8 @@ void mptcp_incoming_options(struct sock *sk, struct sk_buff *skb)
 		 * helpers are cheap.
 		 */
 		mptcp_data_lock(subflow->conn);
-		if (mptcp_send_head(subflow->conn))
-			__mptcp_wnd_updated(subflow->conn, sk);
+		if (sk_stream_memory_free(sk))
+			__mptcp_check_push(subflow->conn, sk);
 		__mptcp_data_acked(subflow->conn);
 		mptcp_data_unlock(subflow->conn);
 		return;
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 64c0c54c80e8..b53a91801a6c 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2915,7 +2915,7 @@ void __mptcp_data_acked(struct sock *sk)
 		mptcp_schedule_work(sk);
 }
 
-void __mptcp_wnd_updated(struct sock *sk, struct sock *ssk)
+void __mptcp_check_push(struct sock *sk, struct sock *ssk)
 {
 	if (!mptcp_send_head(sk))
 		return;
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 7cf9d110b85f..d67de793d363 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -503,7 +503,7 @@ void mptcp_rcv_space_init(struct mptcp_sock *msk, const struct sock *ssk);
 void mptcp_data_ready(struct sock *sk, struct sock *ssk);
 bool mptcp_finish_join(struct sock *sk);
 bool mptcp_schedule_work(struct sock *sk);
-void __mptcp_wnd_updated(struct sock *sk, struct sock *ssk);
+void __mptcp_check_push(struct sock *sk, struct sock *ssk);
 void __mptcp_data_acked(struct sock *sk);
 void mptcp_subflow_eof(struct sock *sk);
 bool mptcp_update_rcv_data_fin(struct mptcp_sock *msk, u64 data_fin_seq, bool use_64bit);
diff --git a/tools/testing/selftests/net/mptcp/simult_flows.sh b/tools/testing/selftests/net/mptcp/simult_flows.sh
index 2f649b431456..f039ee57eb3c 100755
--- a/tools/testing/selftests/net/mptcp/simult_flows.sh
+++ b/tools/testing/selftests/net/mptcp/simult_flows.sh
@@ -287,7 +287,7 @@ run_test 10 10 0 0 "balanced bwidth"
 run_test 10 10 1 50 "balanced bwidth with unbalanced delay"
 
 # we still need some additional infrastructure to pass the following test-cases
-# run_test 30 10 0 0 "unbalanced bwidth"
-# run_test 30 10 1 50 "unbalanced bwidth with unbalanced delay"
-# run_test 30 10 50 1 "unbalanced bwidth with opposed, unbalanced delay"
+run_test 30 10 0 0 "unbalanced bwidth"
+run_test 30 10 1 50 "unbalanced bwidth with unbalanced delay"
+run_test 30 10 50 1 "unbalanced bwidth with opposed, unbalanced delay"
 exit $ret
-- 
2.26.2

