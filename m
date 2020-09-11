Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 495DF2664F8
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 18:49:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726415AbgIKQtH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 12:49:07 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:28573 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726357AbgIKPH1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 11:07:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599836805;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ICSY1QRLeJJ+vdJorZoI5d+577Qg9NkPqylXQ4Ams6g=;
        b=h6DK38yF0cVHGRVds3Jj8jtj0XMZaRrJPjlumqBvKEh8n5uVrD9f+yIQL7VGMKe2Kf8+f/
        ULPH/QA/uYrRdX3fYpPYAMtYFmarXXKWLeGkj37c4Sv/Fjwx68ZCvHlRIPrAkbFnqjJtjC
        K8e9qzPXRbfXEJDZ732BCyQpgFYgJjs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-356-TgrN9LPkPn-zNwAvP2qI-w-1; Fri, 11 Sep 2020 09:52:34 -0400
X-MC-Unique: TgrN9LPkPn-zNwAvP2qI-w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 601D41017DC4;
        Fri, 11 Sep 2020 13:52:33 +0000 (UTC)
Received: from linux.fritz.box.com (ovpn-114-214.ams2.redhat.com [10.36.114.214])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 300DB5C1BD;
        Fri, 11 Sep 2020 13:52:32 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, mptcp@lists.01.org
Subject: [PATCH net-next 04/13] mptcp: basic sndbuf autotuning
Date:   Fri, 11 Sep 2020 15:51:59 +0200
Message-Id: <a8a7249149ce30e5e7f6a494ef94d19ed271bf70.1599832097.git.pabeni@redhat.com>
In-Reply-To: <cover.1599832097.git.pabeni@redhat.com>
References: <cover.1599832097.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Let the msk sendbuf track the size of the larger subflow's
send window, so that we ensure mptcp_sendmsg() does not
exceed MPTCP-level send window.

The update is performed just before try to send any data.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/mptcp/protocol.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 95573c6f7762..4f12a8ce0ddd 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -856,7 +856,8 @@ static void mptcp_nospace(struct mptcp_sock *msk)
 	}
 }
 
-static struct sock *mptcp_subflow_get_send(struct mptcp_sock *msk)
+static struct sock *mptcp_subflow_get_send(struct mptcp_sock *msk,
+					   u32 *sndbuf)
 {
 	struct mptcp_subflow_context *subflow;
 	struct sock *sk = (struct sock *)msk;
@@ -865,6 +866,7 @@ static struct sock *mptcp_subflow_get_send(struct mptcp_sock *msk)
 
 	sock_owned_by_me(sk);
 
+	*sndbuf = 0;
 	if (!mptcp_ext_cache_refill(msk))
 		return NULL;
 
@@ -877,6 +879,7 @@ static struct sock *mptcp_subflow_get_send(struct mptcp_sock *msk)
 			return NULL;
 		}
 
+		*sndbuf = max(tcp_sk(ssk)->snd_wnd, *sndbuf);
 		if (subflow->backup) {
 			if (!backup)
 				backup = ssk;
@@ -903,6 +906,7 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	struct page_frag *pfrag;
 	size_t copied = 0;
 	struct sock *ssk;
+	u32 sndbuf;
 	bool tx_ok;
 	long timeo;
 
@@ -929,7 +933,7 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	}
 
 	__mptcp_flush_join_list(msk);
-	ssk = mptcp_subflow_get_send(msk);
+	ssk = mptcp_subflow_get_send(msk, &sndbuf);
 	while (!sk_stream_memory_free(sk) ||
 	       !ssk ||
 	       !mptcp_page_frag_refill(ssk, pfrag)) {
@@ -953,13 +957,18 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 
 		mptcp_clean_una(sk);
 
-		ssk = mptcp_subflow_get_send(msk);
+		ssk = mptcp_subflow_get_send(msk, &sndbuf);
 		if (list_empty(&msk->conn_list)) {
 			ret = -ENOTCONN;
 			goto out;
 		}
 	}
 
+	/* do auto tuning */
+	if (!(sk->sk_userlocks & SOCK_SNDBUF_LOCK) &&
+	    sndbuf > READ_ONCE(sk->sk_sndbuf))
+		WRITE_ONCE(sk->sk_sndbuf, sndbuf);
+
 	pr_debug("conn_list->subflow=%p", ssk);
 
 	lock_sock(ssk);
@@ -1547,7 +1556,7 @@ static int mptcp_init_sock(struct sock *sk)
 
 	sk_sockets_allocated_inc(sk);
 	sk->sk_rcvbuf = sock_net(sk)->ipv4.sysctl_tcp_rmem[1];
-	sk->sk_sndbuf = sock_net(sk)->ipv4.sysctl_tcp_wmem[2];
+	sk->sk_sndbuf = sock_net(sk)->ipv4.sysctl_tcp_wmem[1];
 
 	return 0;
 }
-- 
2.26.2

