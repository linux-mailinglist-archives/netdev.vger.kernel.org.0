Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8D0A1DBEEA
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 21:58:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728477AbgETT5S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 15:57:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727072AbgETT5L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 15:57:11 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B312DC061A0E;
        Wed, 20 May 2020 12:57:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=hQ5xlf3eDEluCGjsxj+C4BI+ynMqXY9lrfFEhRpm7gQ=; b=NIBwzQnRZgnGgHHXlbhPamtmOU
        +vsFX/lcXimPHAjUAsKLVt+hoB84TqpMGEGh3oeMscowmOEE+YpEa5HGGdB6gGIjmyxl3O0Hty0th
        fbDehqAeeNv4wqxD2A7WfF9wNqrGlbgEP/qoMCKPBiuYXyqFDXHH6BoMkqPwVCVoMc8/8q5eaMAIf
        3W68LSde19d80CdFbCogOrz1kDyXS0bt0UHOK1zWx8sGOuz0vkcrjUx8oqP/TuEix2YmpyJ2K7UKK
        81mG2/qrgHBYLMdyCwqvv7WTKWk5G+qcaCGNOSf08QCFfyHqPz+rOZzfleOrf0cqQhAf+eezP0MY4
        /bWWFzfg==;
Received: from [2001:4bb8:188:1506:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jbUpe-0003YI-PV; Wed, 20 May 2020 19:56:51 +0000
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
Subject: [PATCH 31/33] sctp: add sctp_sock_set_nodelay
Date:   Wed, 20 May 2020 21:55:07 +0200
Message-Id: <20200520195509.2215098-32-hch@lst.de>
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

Add a helper to directly set the SCTP_NODELAY sockopt from kernel space
without going through a fake uaccess.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/dlm/lowcomms.c       | 10 ++--------
 include/net/sctp/sctp.h |  7 +++++++
 2 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/fs/dlm/lowcomms.c b/fs/dlm/lowcomms.c
index 69333728d871b..9f1c3cdc9d653 100644
--- a/fs/dlm/lowcomms.c
+++ b/fs/dlm/lowcomms.c
@@ -914,7 +914,6 @@ static int sctp_bind_addrs(struct connection *con, uint16_t port)
 static void sctp_connect_to_sock(struct connection *con)
 {
 	struct sockaddr_storage daddr;
-	int one = 1;
 	int result;
 	int addr_len;
 	struct socket *sock;
@@ -961,8 +960,7 @@ static void sctp_connect_to_sock(struct connection *con)
 	log_print("connecting to %d", con->nodeid);
 
 	/* Turn off Nagle's algorithm */
-	kernel_setsockopt(sock, SOL_SCTP, SCTP_NODELAY, (char *)&one,
-			  sizeof(one));
+	sctp_sock_set_nodelay(sock->sk);
 
 	/*
 	 * Make sock->ops->connect() function return in specified time,
@@ -1176,7 +1174,6 @@ static int sctp_listen_for_all(void)
 	struct socket *sock = NULL;
 	int result = -EINVAL;
 	struct connection *con = nodeid2con(0, GFP_NOFS);
-	int one = 1;
 
 	if (!con)
 		return -ENOMEM;
@@ -1191,10 +1188,7 @@ static int sctp_listen_for_all(void)
 	}
 
 	sock_set_rcvbuf(sock->sk, NEEDED_RMEM);
-	result = kernel_setsockopt(sock, SOL_SCTP, SCTP_NODELAY, (char *)&one,
-				   sizeof(one));
-	if (result < 0)
-		log_print("Could not set SCTP NODELAY error %d\n", result);
+	sctp_sock_set_nodelay(sock->sk);
 
 	write_lock_bh(&sock->sk->sk_callback_lock);
 	/* Init con struct */
diff --git a/include/net/sctp/sctp.h b/include/net/sctp/sctp.h
index 3ab5c6bbb90bd..f8bcb75bb0448 100644
--- a/include/net/sctp/sctp.h
+++ b/include/net/sctp/sctp.h
@@ -615,4 +615,11 @@ static inline bool sctp_newsk_ready(const struct sock *sk)
 	return sock_flag(sk, SOCK_DEAD) || sk->sk_socket;
 }
 
+static inline void sctp_sock_set_nodelay(struct sock *sk)
+{
+	lock_sock(sk);
+	sctp_sk(sk)->nodelay = true;
+	release_sock(sk);
+}
+
 #endif /* __net_sctp_h__ */
-- 
2.26.2

