Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D6711DBED8
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 21:58:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728432AbgETT5G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 15:57:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728391AbgETT5D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 15:57:03 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3214C061A0E;
        Wed, 20 May 2020 12:57:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=TVWRZ+dDVbUkqjKFRCRZsKcY4V10hWh4MQUOMOhQzp0=; b=W6xMYpJmfq6e+cBhu3IXfq0F7J
        1awdkKkfctWpBz5liyupxCbX8YQv1Na/qQpO67S0j1a98bLcoWpj0HYWvfze27JPSxvaxsSstQ5zM
        gSz/cEH8aI0rEBIJSkT8oIjFYvRLAiC/z7iqRkR4T6zgaqQL5iXdfhmthyv5brhymQRJCH7QW0bSB
        genBzBLGGBpLQNKVa2162RYrKcJtleKqRNH0WMivQwOPrnxblf87/mKRzd/lQwww7Lp/vVOajbEN0
        d0L/Gd/BfyH8AMusu7b0uVltVijFIVDzMqCKov0Aha/7TOPvsv22qZQOhSMnZGGinxDpB/cfKYCkj
        PG+1mJmg==;
Received: from [2001:4bb8:188:1506:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jbUpQ-0003Tx-Ac; Wed, 20 May 2020 19:56:48 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>, drbd-dev@lists.linbit.com,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-nvme@lists.infradead.org, target-devel@vger.kernel.org,
        linux-afs@lists.infradead.org, linux-cifs@vger.kernel.org,
        cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com,
        netdev@vger.kernel.org, linux-sctp@vger.kernel.org,
        ceph-devel@vger.kernel.org, rds-devel@oss.oracle.com,
        linux-nfs@vger.kernel.org
Subject: [PATCH 30/33] tipc: call tsk_set_importance from tipc_topsrv_create_listener
Date:   Wed, 20 May 2020 21:55:06 +0200
Message-Id: <20200520195509.2215098-31-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200520195509.2215098-1-hch@lst.de>
References: <20200520195509.2215098-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Avoid using kernel_setsockopt for the TIPC_IMPORTANCE option when we can
just use the internal helper.  The only change needed is to pass a struct
sock instead of tipc_sock, which is private to socket.c

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 net/tipc/socket.c | 18 +++++++++---------
 net/tipc/socket.h |  2 ++
 net/tipc/topsrv.c |  6 +++---
 3 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/net/tipc/socket.c b/net/tipc/socket.c
index e370ad0edd768..28c57d4544c53 100644
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -191,17 +191,17 @@ static int tsk_importance(struct tipc_sock *tsk)
 	return msg_importance(&tsk->phdr);
 }
 
-static int tsk_set_importance(struct tipc_sock *tsk, int imp)
+static struct tipc_sock *tipc_sk(const struct sock *sk)
 {
-	if (imp > TIPC_CRITICAL_IMPORTANCE)
-		return -EINVAL;
-	msg_set_importance(&tsk->phdr, (u32)imp);
-	return 0;
+	return container_of(sk, struct tipc_sock, sk);
 }
 
-static struct tipc_sock *tipc_sk(const struct sock *sk)
+int tsk_set_importance(struct sock *sk, int imp)
 {
-	return container_of(sk, struct tipc_sock, sk);
+	if (imp > TIPC_CRITICAL_IMPORTANCE)
+		return -EINVAL;
+	msg_set_importance(&tipc_sk(sk)->phdr, (u32)imp);
+	return 0;
 }
 
 static bool tsk_conn_cong(struct tipc_sock *tsk)
@@ -2681,7 +2681,7 @@ static int tipc_accept(struct socket *sock, struct socket *new_sock, int flags,
 	/* Connect new socket to it's peer */
 	tipc_sk_finish_conn(new_tsock, msg_origport(msg), msg_orignode(msg));
 
-	tsk_set_importance(new_tsock, msg_importance(msg));
+	tsk_set_importance(new_sk, msg_importance(msg));
 	if (msg_named(msg)) {
 		new_tsock->conn_type = msg_nametype(msg);
 		new_tsock->conn_instance = msg_nameinst(msg);
@@ -3099,7 +3099,7 @@ static int tipc_setsockopt(struct socket *sock, int lvl, int opt,
 
 	switch (opt) {
 	case TIPC_IMPORTANCE:
-		res = tsk_set_importance(tsk, value);
+		res = tsk_set_importance(sk, value);
 		break;
 	case TIPC_SRC_DROPPABLE:
 		if (sock->type != SOCK_STREAM)
diff --git a/net/tipc/socket.h b/net/tipc/socket.h
index 235b9679acee4..b11575afc66fe 100644
--- a/net/tipc/socket.h
+++ b/net/tipc/socket.h
@@ -75,4 +75,6 @@ u32 tipc_sock_get_portid(struct sock *sk);
 bool tipc_sk_overlimit1(struct sock *sk, struct sk_buff *skb);
 bool tipc_sk_overlimit2(struct sock *sk, struct sk_buff *skb);
 
+int tsk_set_importance(struct sock *sk, int imp);
+
 #endif
diff --git a/net/tipc/topsrv.c b/net/tipc/topsrv.c
index 446af7bbd13e6..1489cfb941d8e 100644
--- a/net/tipc/topsrv.c
+++ b/net/tipc/topsrv.c
@@ -497,7 +497,6 @@ static void tipc_topsrv_listener_data_ready(struct sock *sk)
 
 static int tipc_topsrv_create_listener(struct tipc_topsrv *srv)
 {
-	int imp = TIPC_CRITICAL_IMPORTANCE;
 	struct socket *lsock = NULL;
 	struct sockaddr_tipc saddr;
 	struct sock *sk;
@@ -514,8 +513,9 @@ static int tipc_topsrv_create_listener(struct tipc_topsrv *srv)
 	sk->sk_user_data = srv;
 	write_unlock_bh(&sk->sk_callback_lock);
 
-	rc = kernel_setsockopt(lsock, SOL_TIPC, TIPC_IMPORTANCE,
-			       (char *)&imp, sizeof(imp));
+	lock_sock(sk);
+	rc = tsk_set_importance(sk, TIPC_CRITICAL_IMPORTANCE);
+	release_sock(sk);
 	if (rc < 0)
 		goto err;
 
-- 
2.26.2

