Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A2312B4037
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 10:51:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728700AbgKPJsn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 04:48:43 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:39295 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728682AbgKPJsn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 04:48:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605520121;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2eE/ohZEGIoYvNPv3iXA9QdxTBXKAMFVsZ8fUBh8Ecs=;
        b=YgwYT9PgDx+YxlJLdCOZiaC2hXpWnHd2B0T4hlsSHif4oplzBkoz5ym3M9t7sFQc/vbll/
        JUgjsw716+jgz3VkTQV5/aNKy3oFR8Ipp2vo2yNVnv/8hu3tbTCOfwZ+IEUOtnmp1VRWO0
        z2FYI30X8tS41Tr8HoSkQ3o0xivSJ4g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-304-KAe5fV6JPMS5G9hj9xQ_ag-1; Mon, 16 Nov 2020 04:48:39 -0500
X-MC-Unique: KAe5fV6JPMS5G9hj9xQ_ag-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 32BF48030A6;
        Mon, 16 Nov 2020 09:48:38 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-114-64.ams2.redhat.com [10.36.114.64])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0B8F51002C22;
        Mon, 16 Nov 2020 09:48:36 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>, mptcp@lists.01.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v3 06/13] mptcp: add accounting for pending data
Date:   Mon, 16 Nov 2020 10:48:07 +0100
Message-Id: <3531d4900675f330ce4520e10f995e0eb1906400.1605458224.git.pabeni@redhat.com>
In-Reply-To: <cover.1605458224.git.pabeni@redhat.com>
References: <cover.1605458224.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Preparation patch to track the data pending in the msk
write queue. No functional change introduced here

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/mptcp/protocol.c |  1 +
 net/mptcp/protocol.h | 38 +++++++++++++++++++++++++++++++++++---
 2 files changed, 36 insertions(+), 3 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 4ed9b1cc3b1e..40c4227ae9fe 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1859,6 +1859,7 @@ static int __mptcp_init_sock(struct sock *sk)
 	__set_bit(MPTCP_SEND_SPACE, &msk->flags);
 	INIT_WORK(&msk->work, mptcp_worker);
 	msk->out_of_order_queue = RB_ROOT;
+	msk->first_pending = NULL;
 
 	msk->first = NULL;
 	inet_csk(sk)->icsk_sync_mss = mptcp_sync_mss;
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 5211564a533f..ec17f9c367c5 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -187,9 +187,10 @@ struct mptcp_pm_data {
 struct mptcp_data_frag {
 	struct list_head list;
 	u64 data_seq;
-	int data_len;
-	int offset;
-	int overhead;
+	u16 data_len;
+	u16 offset;
+	u16 overhead;
+	u16 already_sent;
 	struct page *page;
 };
 
@@ -219,6 +220,7 @@ struct mptcp_sock {
 	struct rb_root  out_of_order_queue;
 	struct list_head conn_list;
 	struct list_head rtx_queue;
+	struct mptcp_data_frag *first_pending;
 	struct list_head join_list;
 	struct skb_ext	*cached_ext;	/* for the next sendmsg */
 	struct socket	*subflow; /* outgoing connect/listener/!mp_capable */
@@ -240,6 +242,36 @@ static inline struct mptcp_sock *mptcp_sk(const struct sock *sk)
 	return (struct mptcp_sock *)sk;
 }
 
+static inline struct mptcp_data_frag *mptcp_send_head(const struct sock *sk)
+{
+	const struct mptcp_sock *msk = mptcp_sk(sk);
+
+	return READ_ONCE(msk->first_pending);
+}
+
+static inline struct mptcp_data_frag *mptcp_send_next(struct sock *sk)
+{
+	struct mptcp_sock *msk = mptcp_sk(sk);
+	struct mptcp_data_frag *cur;
+
+	cur = msk->first_pending;
+	return list_is_last(&cur->list, &msk->rtx_queue) ? NULL :
+						     list_next_entry(cur, list);
+}
+
+static inline struct mptcp_data_frag *mptcp_pending_tail(const struct sock *sk)
+{
+	struct mptcp_sock *msk = mptcp_sk(sk);
+
+	if (!msk->first_pending)
+		return NULL;
+
+	if (WARN_ON_ONCE(list_empty(&msk->rtx_queue)))
+		return NULL;
+
+	return list_last_entry(&msk->rtx_queue, struct mptcp_data_frag, list);
+}
+
 static inline struct mptcp_data_frag *mptcp_rtx_tail(const struct sock *sk)
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
-- 
2.26.2

