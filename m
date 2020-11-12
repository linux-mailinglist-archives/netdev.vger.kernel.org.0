Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 166B12B0B82
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 18:47:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726325AbgKLRrA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 12:47:00 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55880 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726249AbgKLRq7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 12:46:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605203218;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=g746v45QtIiUtPG/RYV2C5jq8Llc2K+0tGb8OpMPaFA=;
        b=VNVGBo9up8leTxN3ScvDq3KlLmjHFzYG9tqX8vhExwn7c+mw+IWkbQMuZtYWZ6tXYk3XSp
        fAinAC6h0wRFcwAAwBEirBQU36Ve27cR7+or+q8eeoLGrtFgf2J2JBiJ+0y+vxK9lUs7bO
        82bTo5NtG2o/K0D1lDB2ZHKL6Ue0qb8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-357-05dvp34dMH6Bj0SnrEZ2wQ-1; Thu, 12 Nov 2020 12:46:54 -0500
X-MC-Unique: 05dvp34dMH6Bj0SnrEZ2wQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 927271018F6F;
        Thu, 12 Nov 2020 17:46:53 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-112-208.ams2.redhat.com [10.36.112.208])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0581A5578C;
        Thu, 12 Nov 2020 17:46:47 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>, mptcp@lists.01.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 06/13] mptcp: add accounting for pending data
Date:   Thu, 12 Nov 2020 18:45:26 +0100
Message-Id: <653b54ab33745d31c601ca0cd0754d181170838f.1605199807.git.pabeni@redhat.com>
In-Reply-To: <cover.1605199807.git.pabeni@redhat.com>
References: <cover.1605199807.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
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
index 691fdb2071cf..0c07bed2bd28 100644
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

