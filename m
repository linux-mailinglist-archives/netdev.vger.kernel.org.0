Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A45F1D0809
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 08:33:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732024AbgEMG2x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 02:28:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730668AbgEMG2s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 02:28:48 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED09BC061A0E;
        Tue, 12 May 2020 23:28:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=VriKupxRYsJlL2uxVcilvd0cTKLGSfORdeySMsHEWM0=; b=sR5EMxLZAt8B7bA1KxAxjuv6wd
        og2rytl6Jc0A+7hlcV8EXWIPDvh8UgyAUErFODUlIipxvuEJxEu+x0A+pFk4I9pySnf1f6T/pJsTu
        KUB2RdqvTmiJkfhDXGEnvLdf2lvs3k6LXxLu8DoXiOA5hsxN5fm073OAF4CTNSLl0Ep1EftErwAfc
        ruLPqbJ9CiN7AAnc5ZtNGwBAsO1fO1kYiDgavZXz4LAWVgsG1wmLD7Lx1Aqs0ZTJ+3mTtyrj5sjE6
        Cyq8JY7tvf4boI1g+6bKr+ilMXPAkaVbj0N5rx+PLXDX6Fpi6bbyIG6W385vcDxJrl4RMddG0+l3X
        3F/wY21g==;
Received: from [2001:4bb8:180:9d3f:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jYksL-00054q-LC; Wed, 13 May 2020 06:28:18 +0000
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
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-nvme@lists.infradead.org,
        target-devel@vger.kernel.org, linux-afs@lists.infradead.org,
        linux-cifs@vger.kernel.org, cluster-devel@redhat.com,
        ocfs2-devel@oss.oracle.com, netdev@vger.kernel.org,
        linux-sctp@vger.kernel.org, ceph-devel@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-nfs@vger.kernel.org
Subject: [PATCH 28/33] sctp: add sctp_sock_set_nodelay
Date:   Wed, 13 May 2020 08:26:43 +0200
Message-Id: <20200513062649.2100053-29-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200513062649.2100053-1-hch@lst.de>
References: <20200513062649.2100053-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a helper to directly set the SCTP_NODELAY sockopt from kernel space
without going through a fake uaccess.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/dlm/lowcomms.c       | 10 ++--------
 include/net/sctp/sctp.h |  1 +
 net/sctp/socket.c       |  8 ++++++++
 3 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/fs/dlm/lowcomms.c b/fs/dlm/lowcomms.c
index e4939d770df53..6fa45365666a8 100644
--- a/fs/dlm/lowcomms.c
+++ b/fs/dlm/lowcomms.c
@@ -1034,7 +1034,6 @@ static int sctp_bind_addrs(struct connection *con, uint16_t port)
 static void sctp_connect_to_sock(struct connection *con)
 {
 	struct sockaddr_storage daddr;
-	int one = 1;
 	int result;
 	int addr_len;
 	struct socket *sock;
@@ -1081,8 +1080,7 @@ static void sctp_connect_to_sock(struct connection *con)
 	log_print("connecting to %d", con->nodeid);
 
 	/* Turn off Nagle's algorithm */
-	kernel_setsockopt(sock, SOL_SCTP, SCTP_NODELAY, (char *)&one,
-			  sizeof(one));
+	sctp_sock_set_nodelay(sock->sk, true);
 
 	/*
 	 * Make sock->ops->connect() function return in specified time,
@@ -1296,7 +1294,6 @@ static int sctp_listen_for_all(void)
 	struct socket *sock = NULL;
 	int result = -EINVAL;
 	struct connection *con = nodeid2con(0, GFP_NOFS);
-	int one = 1;
 
 	if (!con)
 		return -ENOMEM;
@@ -1311,10 +1308,7 @@ static int sctp_listen_for_all(void)
 	}
 
 	sock_set_rcvbuf(sock->sk, NEEDED_RMEM);
-	result = kernel_setsockopt(sock, SOL_SCTP, SCTP_NODELAY, (char *)&one,
-				   sizeof(one));
-	if (result < 0)
-		log_print("Could not set SCTP NODELAY error %d\n", result);
+	sctp_sock_set_nodelay(sock->sk, true);
 
 	write_lock_bh(&sock->sk->sk_callback_lock);
 	/* Init con struct */
diff --git a/include/net/sctp/sctp.h b/include/net/sctp/sctp.h
index f702b14d768ba..b505fa082f254 100644
--- a/include/net/sctp/sctp.h
+++ b/include/net/sctp/sctp.h
@@ -617,5 +617,6 @@ static inline bool sctp_newsk_ready(const struct sock *sk)
 
 int sctp_setsockopt_bindx(struct sock *sk, struct sockaddr *kaddrs,
 		int addrs_size, int op);
+void sctp_sock_set_nodelay(struct sock *sk, bool val);
 
 #endif /* __net_sctp_h__ */
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 30c981d9f6158..64c395f7a86d5 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -3066,6 +3066,14 @@ static int sctp_setsockopt_nodelay(struct sock *sk, char __user *optval,
 	return 0;
 }
 
+void sctp_sock_set_nodelay(struct sock *sk, bool val)
+{
+	lock_sock(sk);
+	sctp_sk(sk)->nodelay = val;
+	release_sock(sk);
+}
+EXPORT_SYMBOL(sctp_sock_set_nodelay);
+
 /*
  *
  * 7.1.1 SCTP_RTOINFO
-- 
2.26.2

