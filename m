Return-Path: <netdev+bounces-11725-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 76B2B7340E2
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 14:16:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A7F531C20D28
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 12:16:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59695C8D6;
	Sat, 17 Jun 2023 12:12:48 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 487DAD505
	for <netdev@vger.kernel.org>; Sat, 17 Jun 2023 12:12:48 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2E9026A2
	for <netdev@vger.kernel.org>; Sat, 17 Jun 2023 05:12:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1687003966;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iAUCq6AQpwiSNlqp6e2886GYsbEpCz4tvlCIXkUtiq4=;
	b=ErpKp3gXFTvoP9d88RFCVx/aQmvtLBxuSLFBcwlBbDh5vlptWu2H7ogxjkCbtR5HX1hofF
	SCooKm9G6PoD4arln8IpxTLSGn6Ahv3psd9wowAZRZhoRplfZ9yzNnJZswvnsq/vCn/qkA
	z27Qezk8vI0of4ox3yc9ivsGWSDe41s=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-473-tTtJZPH1Nh6NXzEdHxJjJw-1; Sat, 17 Jun 2023 08:12:42 -0400
X-MC-Unique: tTtJZPH1Nh6NXzEdHxJjJw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E86F780123E;
	Sat, 17 Jun 2023 12:12:40 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.42.28.51])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B3492C1603B;
	Sat, 17 Jun 2023 12:12:38 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: netdev@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>,
	Alexander Duyck <alexander.duyck@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	David Ahern <dsahern@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Jens Axboe <axboe@kernel.dk>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Karsten Graul <kgraul@linux.ibm.com>,
	Wenjia Zhang <wenjia@linux.ibm.com>,
	Jan Karcher <jaka@linux.ibm.com>,
	"D. Wythe" <alibuda@linux.alibaba.com>,
	Tony Lu <tonylu@linux.alibaba.com>,
	Wen Gu <guwen@linux.alibaba.com>,
	linux-s390@vger.kernel.org
Subject: [PATCH net-next v2 11/17] smc: Drop smc_sendpage() in favour of smc_sendmsg() + MSG_SPLICE_PAGES
Date: Sat, 17 Jun 2023 13:11:40 +0100
Message-ID: <20230617121146.716077-12-dhowells@redhat.com>
In-Reply-To: <20230617121146.716077-1-dhowells@redhat.com>
References: <20230617121146.716077-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Drop the smc_sendpage() code as smc_sendmsg() just passes the call down to
the underlying TCP socket and smc_tx_sendpage() is just a wrapper around
its sendmsg implementation.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Karsten Graul <kgraul@linux.ibm.com>
cc: Wenjia Zhang <wenjia@linux.ibm.com>
cc: Jan Karcher <jaka@linux.ibm.com>
cc: "D. Wythe" <alibuda@linux.alibaba.com>
cc: Tony Lu <tonylu@linux.alibaba.com>
cc: Wen Gu <guwen@linux.alibaba.com>
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
 net/smc/smc_tx.c    | 22 +---------------------
 net/smc/smc_tx.h    |  2 --
 5 files changed, 2 insertions(+), 54 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 538e9c6ec8c9..a7f887d91d89 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -3133,34 +3133,6 @@ static int smc_ioctl(struct socket *sock, unsigned int cmd,
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
@@ -3232,7 +3204,6 @@ static const struct proto_ops smc_sock_ops = {
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
index 9b9e0a190734..5147207808e5 100644
--- a/net/smc/smc_tx.c
+++ b/net/smc/smc_tx.c
@@ -167,8 +167,7 @@ static bool smc_tx_should_cork(struct smc_sock *smc, struct msghdr *msg)
 	 * sndbuf_space is still available. The applications
 	 * should known how/when to uncork it.
 	 */
-	if ((msg->msg_flags & MSG_MORE ||
-	     smc_tx_is_corked(smc)) &&
+	if ((msg->msg_flags & MSG_MORE || smc_tx_is_corked(smc)) &&
 	    atomic_read(&conn->sndbuf_space))
 		return true;
 
@@ -297,25 +296,6 @@ int smc_tx_sendmsg(struct smc_sock *smc, struct msghdr *msg, size_t len)
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
-	if (flags & MSG_SENDPAGE_NOTLAST)
-		msg.msg_flags |= MSG_MORE;
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


