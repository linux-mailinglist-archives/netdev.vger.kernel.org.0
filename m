Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5ECED6CDC57
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 16:22:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231393AbjC2OWo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 10:22:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231315AbjC2OUl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 10:20:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D860661B8
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 07:16:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680099366;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7fCBjYGLxHqikc/tNao5Lfq+HewWC5ZgTjyFTAyeW0Q=;
        b=ccrb4F9kQU5F4JRMK1q+wVJB2/67CR/0xNjY1G0nv6YKHi/Jpwyvp6if5GfisJqQ9HJ0+I
        47M6ho3DuZaoi9CpEsBgT6YkMLvzrmP+z+82+nfZPT2/KVvEyo0kfngXNijl+svdAmCdmv
        dVp5VlyeDWruqI3fgRujGnuCBmXlwlc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-114-46eAsXOAN6OrZ73_2qvGIA-1; Wed, 29 Mar 2023 10:16:03 -0400
X-MC-Unique: 46eAsXOAN6OrZ73_2qvGIA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5E15C8030D4;
        Wed, 29 Mar 2023 14:16:01 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1928E202701F;
        Wed, 29 Mar 2023 14:15:59 +0000 (UTC)
From:   David Howells <dhowells@redhat.com>
To:     Matthew Wilcox <willy@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     David Howells <dhowells@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, Jeff Layton <jlayton@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        Chuck Lever III <chuck.lever@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Karsten Graul <kgraul@linux.ibm.com>,
        Wenjia Zhang <wenjia@linux.ibm.com>,
        Jan Karcher <jaka@linux.ibm.com>, linux-s390@vger.kernel.org
Subject: [RFC PATCH v2 44/48] smc: Drop smc_sendpage() in favour of smc_sendmsg() + MSG_SPLICE_PAGES
Date:   Wed, 29 Mar 2023 15:13:50 +0100
Message-Id: <20230329141354.516864-45-dhowells@redhat.com>
In-Reply-To: <20230329141354.516864-1-dhowells@redhat.com>
References: <20230329141354.516864-1-dhowells@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Drop the smc_sendpage() code as smc_sendmsg() just passes the call down to
the underlying TCP socket and smc_tx_sendpage() is just a wrapper around
its sendmsg implementation.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Karsten Graul <kgraul@linux.ibm.com>
cc: Wenjia Zhang <wenjia@linux.ibm.com>
cc: Jan Karcher <jaka@linux.ibm.com>
cc: "David S. Miller" <davem@davemloft.net>
cc: Eric Dumazet <edumazet@google.com>
cc: Jakub Kicinski <kuba@kernel.org>
cc: Paolo Abeni <pabeni@redhat.com>
cc: Jens Axboe <axboe@kernel.dk>
cc: Matthew Wilcox <willy@infradead.org>
cc: linux-s390@vger.kernel.org
cc: netdev@vger.kernel.org
---
 net/smc/af_smc.c    | 29 -----------------------------
 net/smc/smc_stats.c |  2 +-
 net/smc/smc_stats.h |  1 -
 net/smc/smc_tx.c    | 16 ----------------
 net/smc/smc_tx.h    |  2 --
 5 files changed, 1 insertion(+), 49 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index a4cccdfdc00a..d4113c8a7cda 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -3125,34 +3125,6 @@ static int smc_ioctl(struct socket *sock, unsigned int cmd,
 	return put_user(answ, (int __user *)arg);
 }
 
-static ssize_t smc_sendpage(struct socket *sock, struct page *page,
-			    int offset, size_t size, int flags)
-{
-	struct sock *sk = sock->sk;
-	struct smc_sock *smc;
-	int rc = -EPIPE;
-
-	smc = smc_sk(sk);
-	lock_sock(sk);
-	if (sk->sk_state != SMC_ACTIVE) {
-		release_sock(sk);
-		goto out;
-	}
-	release_sock(sk);
-	if (smc->use_fallback) {
-		rc = kernel_sendpage(smc->clcsock, page, offset,
-				     size, flags);
-	} else {
-		lock_sock(sk);
-		rc = smc_tx_sendpage(smc, page, offset, size, flags);
-		release_sock(sk);
-		SMC_STAT_INC(smc, sendpage_cnt);
-	}
-
-out:
-	return rc;
-}
-
 /* Map the affected portions of the rmbe into an spd, note the number of bytes
  * to splice in conn->splice_pending, and press 'go'. Delays consumer cursor
  * updates till whenever a respective page has been fully processed.
@@ -3224,7 +3196,6 @@ static const struct proto_ops smc_sock_ops = {
 	.sendmsg	= smc_sendmsg,
 	.recvmsg	= smc_recvmsg,
 	.mmap		= sock_no_mmap,
-	.sendpage	= smc_sendpage,
 	.splice_read	= smc_splice_read,
 };
 
diff --git a/net/smc/smc_stats.c b/net/smc/smc_stats.c
index e80e34f7ac15..ca14c0f3a07d 100644
--- a/net/smc/smc_stats.c
+++ b/net/smc/smc_stats.c
@@ -227,7 +227,7 @@ static int smc_nl_fill_stats_tech_data(struct sk_buff *skb,
 			      SMC_NLA_STATS_PAD))
 		goto errattr;
 	if (nla_put_u64_64bit(skb, SMC_NLA_STATS_T_SENDPAGE_CNT,
-			      smc_tech->sendpage_cnt,
+			      0,
 			      SMC_NLA_STATS_PAD))
 		goto errattr;
 	if (nla_put_u64_64bit(skb, SMC_NLA_STATS_T_CORK_CNT,
diff --git a/net/smc/smc_stats.h b/net/smc/smc_stats.h
index 84b7ecd8c05c..b60fe1eb37ab 100644
--- a/net/smc/smc_stats.h
+++ b/net/smc/smc_stats.h
@@ -71,7 +71,6 @@ struct smc_stats_tech {
 	u64			clnt_v2_succ_cnt;
 	u64			srv_v1_succ_cnt;
 	u64			srv_v2_succ_cnt;
-	u64			sendpage_cnt;
 	u64			urg_data_cnt;
 	u64			splice_cnt;
 	u64			cork_cnt;
diff --git a/net/smc/smc_tx.c b/net/smc/smc_tx.c
index f4b6a71ac488..d31ce8209fa2 100644
--- a/net/smc/smc_tx.c
+++ b/net/smc/smc_tx.c
@@ -298,22 +298,6 @@ int smc_tx_sendmsg(struct smc_sock *smc, struct msghdr *msg, size_t len)
 	return rc;
 }
 
-int smc_tx_sendpage(struct smc_sock *smc, struct page *page, int offset,
-		    size_t size, int flags)
-{
-	struct msghdr msg = {.msg_flags = flags};
-	char *kaddr = kmap(page);
-	struct kvec iov;
-	int rc;
-
-	iov.iov_base = kaddr + offset;
-	iov.iov_len = size;
-	iov_iter_kvec(&msg.msg_iter, ITER_SOURCE, &iov, 1, size);
-	rc = smc_tx_sendmsg(smc, &msg, size);
-	kunmap(page);
-	return rc;
-}
-
 /***************************** sndbuf consumer *******************************/
 
 /* sndbuf consumer: actual data transfer of one target chunk with ISM write */
diff --git a/net/smc/smc_tx.h b/net/smc/smc_tx.h
index 34b578498b1f..a59f370b8b43 100644
--- a/net/smc/smc_tx.h
+++ b/net/smc/smc_tx.h
@@ -31,8 +31,6 @@ void smc_tx_pending(struct smc_connection *conn);
 void smc_tx_work(struct work_struct *work);
 void smc_tx_init(struct smc_sock *smc);
 int smc_tx_sendmsg(struct smc_sock *smc, struct msghdr *msg, size_t len);
-int smc_tx_sendpage(struct smc_sock *smc, struct page *page, int offset,
-		    size_t size, int flags);
 int smc_tx_sndbuf_nonempty(struct smc_connection *conn);
 void smc_tx_sndbuf_nonfull(struct smc_sock *smc);
 void smc_tx_consumer_update(struct smc_connection *conn, bool force);

