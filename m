Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A5811E4D06
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 20:23:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389115AbgE0SW7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 14:22:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728533AbgE0SWm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 14:22:42 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0493DC08C5C1;
        Wed, 27 May 2020 11:22:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=Wd08dyMU5IfAW7gVOq/7rRtlHhJfaMVGF9qWpfUzCOA=; b=Ie6/rg5bR8eSBhC+ZfYTuqVzDQ
        wFlWqj76OgmH2ne3EYdRucg1jsZk7Q0aq/zKtGzmpjFGksZ8hcX8qee77RxASBSCj8nj0jGs9qkFJ
        9Y0bndl/5zNtIHQkdz4GRRSTakK3rFfVgHL7h1t6G6NEiFW8HKe4fNxgilroawymheQoAJFbx6E1L
        UU58LJPVuUFqCdn1ZovZObfmtO0ZjCuBG1zzzK/cBX9DyNRH14rxXl71CKM/vs4m36UJEAJPoGx4T
        l2HSjzJC/oUVuoX2Wi6oCh92HUORDf/wAoYJdVhrPkRc/m8pJ9mWS0YnjbzvLStlA7zK8i/SmRQ6Z
        Oxj/UBKg==;
Received: from p4fdb0aaa.dip0.t-ipconnect.de ([79.219.10.170] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1je0hG-00087Z-5W; Wed, 27 May 2020 18:22:34 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Christine Caulfield <ccaulfie@redhat.com>,
        David Teigland <teigland@redhat.com>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        linux-kernel@vger.kernel.org, cluster-devel@redhat.com,
        netdev@vger.kernel.org
Subject: [PATCH 1/2] dlm: use the tcp version of accept_from_sock for sctp as well
Date:   Wed, 27 May 2020 20:22:28 +0200
Message-Id: <20200527182229.517794-2-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200527182229.517794-1-hch@lst.de>
References: <20200527182229.517794-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The only difference between a few missing fixes applied to the SCTP
one is that TCP uses ->getpeername to get the remote address, while
SCTP uses kernel_getsockopt(.. SCTP_PRIMARY_ADDR).  But given that
getpeername is defined to return the primary address for sctp, there
doesn't seem to be any reason for the different way of quering the
peername, or all the code duplication.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/dlm/lowcomms.c | 123 ++--------------------------------------------
 1 file changed, 3 insertions(+), 120 deletions(-)

diff --git a/fs/dlm/lowcomms.c b/fs/dlm/lowcomms.c
index cdfaf4f0e11a0..f13dad0fd9ef3 100644
--- a/fs/dlm/lowcomms.c
+++ b/fs/dlm/lowcomms.c
@@ -724,7 +724,7 @@ static int receive_from_sock(struct connection *con)
 }
 
 /* Listening socket is busy, accept a connection */
-static int tcp_accept_from_sock(struct connection *con)
+static int accept_from_sock(struct connection *con)
 {
 	int result;
 	struct sockaddr_storage peeraddr;
@@ -852,123 +852,6 @@ static int tcp_accept_from_sock(struct connection *con)
 	return result;
 }
 
-static int sctp_accept_from_sock(struct connection *con)
-{
-	/* Check that the new node is in the lockspace */
-	struct sctp_prim prim;
-	int nodeid;
-	int prim_len, ret;
-	int addr_len;
-	struct connection *newcon;
-	struct connection *addcon;
-	struct socket *newsock;
-
-	mutex_lock(&connections_lock);
-	if (!dlm_allow_conn) {
-		mutex_unlock(&connections_lock);
-		return -1;
-	}
-	mutex_unlock(&connections_lock);
-
-	mutex_lock_nested(&con->sock_mutex, 0);
-
-	ret = kernel_accept(con->sock, &newsock, O_NONBLOCK);
-	if (ret < 0)
-		goto accept_err;
-
-	memset(&prim, 0, sizeof(struct sctp_prim));
-	prim_len = sizeof(struct sctp_prim);
-
-	ret = kernel_getsockopt(newsock, IPPROTO_SCTP, SCTP_PRIMARY_ADDR,
-				(char *)&prim, &prim_len);
-	if (ret < 0) {
-		log_print("getsockopt/sctp_primary_addr failed: %d", ret);
-		goto accept_err;
-	}
-
-	make_sockaddr(&prim.ssp_addr, 0, &addr_len);
-	ret = addr_to_nodeid(&prim.ssp_addr, &nodeid);
-	if (ret) {
-		unsigned char *b = (unsigned char *)&prim.ssp_addr;
-
-		log_print("reject connect from unknown addr");
-		print_hex_dump_bytes("ss: ", DUMP_PREFIX_NONE,
-				     b, sizeof(struct sockaddr_storage));
-		goto accept_err;
-	}
-
-	newcon = nodeid2con(nodeid, GFP_NOFS);
-	if (!newcon) {
-		ret = -ENOMEM;
-		goto accept_err;
-	}
-
-	mutex_lock_nested(&newcon->sock_mutex, 1);
-
-	if (newcon->sock) {
-		struct connection *othercon = newcon->othercon;
-
-		if (!othercon) {
-			othercon = kmem_cache_zalloc(con_cache, GFP_NOFS);
-			if (!othercon) {
-				log_print("failed to allocate incoming socket");
-				mutex_unlock(&newcon->sock_mutex);
-				ret = -ENOMEM;
-				goto accept_err;
-			}
-			othercon->nodeid = nodeid;
-			othercon->rx_action = receive_from_sock;
-			mutex_init(&othercon->sock_mutex);
-			INIT_LIST_HEAD(&othercon->writequeue);
-			spin_lock_init(&othercon->writequeue_lock);
-			INIT_WORK(&othercon->swork, process_send_sockets);
-			INIT_WORK(&othercon->rwork, process_recv_sockets);
-			set_bit(CF_IS_OTHERCON, &othercon->flags);
-		}
-		mutex_lock_nested(&othercon->sock_mutex, 2);
-		if (!othercon->sock) {
-			newcon->othercon = othercon;
-			add_sock(newsock, othercon);
-			addcon = othercon;
-			mutex_unlock(&othercon->sock_mutex);
-		} else {
-			printk("Extra connection from node %d attempted\n", nodeid);
-			ret = -EAGAIN;
-			mutex_unlock(&othercon->sock_mutex);
-			mutex_unlock(&newcon->sock_mutex);
-			goto accept_err;
-		}
-	} else {
-		newcon->rx_action = receive_from_sock;
-		add_sock(newsock, newcon);
-		addcon = newcon;
-	}
-
-	log_print("connected to %d", nodeid);
-
-	mutex_unlock(&newcon->sock_mutex);
-
-	/*
-	 * Add it to the active queue in case we got data
-	 * between processing the accept adding the socket
-	 * to the read_sockets list
-	 */
-	if (!test_and_set_bit(CF_READ_PENDING, &addcon->flags))
-		queue_work(recv_workqueue, &addcon->rwork);
-	mutex_unlock(&con->sock_mutex);
-
-	return 0;
-
-accept_err:
-	mutex_unlock(&con->sock_mutex);
-	if (newsock)
-		sock_release(newsock);
-	if (ret != -EAGAIN)
-		log_print("error accepting connection from node: %d", ret);
-
-	return ret;
-}
-
 static void free_entry(struct writequeue_entry *e)
 {
 	__free_page(e->page);
@@ -1253,7 +1136,7 @@ static struct socket *tcp_create_listen_sock(struct connection *con,
 	write_lock_bh(&sock->sk->sk_callback_lock);
 	sock->sk->sk_user_data = con;
 	save_listen_callbacks(sock);
-	con->rx_action = tcp_accept_from_sock;
+	con->rx_action = accept_from_sock;
 	con->connect_action = tcp_connect_to_sock;
 	write_unlock_bh(&sock->sk->sk_callback_lock);
 
@@ -1340,7 +1223,7 @@ static int sctp_listen_for_all(void)
 	save_listen_callbacks(sock);
 	con->sock = sock;
 	con->sock->sk->sk_data_ready = lowcomms_data_ready;
-	con->rx_action = sctp_accept_from_sock;
+	con->rx_action = accept_from_sock;
 	con->connect_action = sctp_connect_to_sock;
 
 	write_unlock_bh(&sock->sk->sk_callback_lock);
-- 
2.26.2

