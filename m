Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B823F1FCA86
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 12:10:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726573AbgFQKKP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 06:10:15 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:37994 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726341AbgFQKKK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 06:10:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592388609;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/Vrz7J6LIz4peN/Lmj6SaaESCXCYg97vjA3X5SZPWmA=;
        b=ezsDxr/gaoDw/YlAo96TyzuIiikT06IwC59/B1na7mBhAwUyjn/ubMqzGZi4X5uwsNTZ1T
        t27hocYik8aBsC2QbljtrL61gjDVkdm6ANWnpEw30iE9G9i59Ol5XZDomUSGQgn4dNq8Ij
        tmfnGIg9LNeTVNRARfPtmKBFRlQi+cE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-512-mRp2IVO4O2ux6y3bx7fcdA-1; Wed, 17 Jun 2020 06:10:07 -0400
X-MC-Unique: mRp2IVO4O2ux6y3bx7fcdA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B0CB7873430;
        Wed, 17 Jun 2020 10:10:06 +0000 (UTC)
Received: from linux.fritz.box.com (ovpn-112-237.ams2.redhat.com [10.36.112.237])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 080807931D;
        Wed, 17 Jun 2020 10:10:04 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, mptcp@lists.01.org
Subject: [PATCH net 2/2] mptcp: drop MP_JOIN request sock on syn cookies
Date:   Wed, 17 Jun 2020 12:08:57 +0200
Message-Id: <3aff0acec0b89a55fdae02194036f34be56b545c.1592388398.git.pabeni@redhat.com>
In-Reply-To: <cover.1592388398.git.pabeni@redhat.com>
References: <cover.1592388398.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently any MPTCP socket using syn cookies will fallback to
TCP at 3rd ack time. In case of MP_JOIN requests, the RFC mandate
closing the child and sockets, but the existing error paths
do not handle the syncookie scenario correctly.

Address the issue always forcing the child shutdown in case of
MP_JOIN fallback.

Fixes: ae2dd7164943 ("mptcp: handle tcp fallback when using syn cookies")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/mptcp/subflow.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 4068bdb2523b..3838a0b3a21f 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -431,22 +431,25 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
 	struct mptcp_subflow_context *listener = mptcp_subflow_ctx(sk);
 	struct mptcp_subflow_request_sock *subflow_req;
 	struct mptcp_options_received mp_opt;
-	bool fallback_is_fatal = false;
+	bool fallback, fallback_is_fatal;
 	struct sock *new_msk = NULL;
-	bool fallback = false;
 	struct sock *child;
 
 	pr_debug("listener=%p, req=%p, conn=%p", listener, req, listener->conn);
 
-	/* we need later a valid 'mp_capable' value even when options are not
-	 * parsed
+	/* After child creation we must look for 'mp_capable' even when options
+	 * are not parsed
 	 */
 	mp_opt.mp_capable = 0;
-	if (tcp_rsk(req)->is_mptcp == 0)
+
+	/* hopefully temporary handling for MP_JOIN+syncookie */
+	subflow_req = mptcp_subflow_rsk(req);
+	fallback_is_fatal = subflow_req->mp_join;
+	fallback = !tcp_rsk(req)->is_mptcp;
+	if (fallback)
 		goto create_child;
 
 	/* if the sk is MP_CAPABLE, we try to fetch the client key */
-	subflow_req = mptcp_subflow_rsk(req);
 	if (subflow_req->mp_capable) {
 		if (TCP_SKB_CB(skb)->seq != subflow_req->ssn_offset + 1) {
 			/* here we can receive and accept an in-window,
@@ -467,12 +470,11 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
 		if (!new_msk)
 			fallback = true;
 	} else if (subflow_req->mp_join) {
-		fallback_is_fatal = true;
 		mptcp_get_options(skb, &mp_opt);
 		if (!mp_opt.mp_join ||
 		    !subflow_hmac_valid(req, &mp_opt)) {
 			SUBFLOW_REQ_INC_STATS(req, MPTCP_MIB_JOINACKMAC);
-			return NULL;
+			fallback = true;
 		}
 	}
 
-- 
2.26.2

