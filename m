Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E7764A37FB
	for <lists+netdev@lfdr.de>; Sun, 30 Jan 2022 19:03:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355787AbiA3SDQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jan 2022 13:03:16 -0500
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:38818 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236867AbiA3SDM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Jan 2022 13:03:12 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0V3BCr7L_1643565787;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0V3BCr7L_1643565787)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 31 Jan 2022 02:03:08 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     kgraul@linux.ibm.com, kuba@kernel.org, davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [PATCH net-next 3/3] net/smc: Cork when sendpage with MSG_SENDPAGE_NOTLAST flag
Date:   Mon, 31 Jan 2022 02:02:57 +0800
Message-Id: <20220130180256.28303-4-tonylu@linux.alibaba.com>
X-Mailer: git-send-email 2.35.0
In-Reply-To: <20220130180256.28303-1-tonylu@linux.alibaba.com>
References: <20220130180256.28303-1-tonylu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This introduces a new corked flag, MSG_SENDPAGE_NOTLAST, which is
involved in syscall sendfile() [1], it indicates this is not the last
page. So we can cork the data until the page is not specify this flag.
It has the same effect as MSG_MORE, but existed in sendfile() only.

This patch adds a option MSG_SENDPAGE_NOTLAST for corking data, try to
cork more data before sending when using sendfile(), which acts like
TCP's behaviour. Also, this reimplements the default sendpage to inform
that it is supported to some extent.

[1] https://man7.org/linux/man-pages/man2/sendfile.2.html

Signed-off-by: Tony Lu <tonylu@linux.alibaba.com>
---
 net/smc/af_smc.c |  4 +++-
 net/smc/smc_tx.c | 19 ++++++++++++++++++-
 net/smc/smc_tx.h |  2 ++
 3 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index ef021ec6b361..8b78010afe01 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -2729,8 +2729,10 @@ static ssize_t smc_sendpage(struct socket *sock, struct page *page,
 		rc = kernel_sendpage(smc->clcsock, page, offset,
 				     size, flags);
 	} else {
+		lock_sock(sk);
+		rc = smc_tx_sendpage(smc, page, offset, size, flags);
+		release_sock(sk);
 		SMC_STAT_INC(smc, sendpage_cnt);
-		rc = sock_no_sendpage(sock, page, offset, size, flags);
 	}
 
 out:
diff --git a/net/smc/smc_tx.c b/net/smc/smc_tx.c
index 9cec62cae7cb..a96ce162825e 100644
--- a/net/smc/smc_tx.c
+++ b/net/smc/smc_tx.c
@@ -235,7 +235,8 @@ int smc_tx_sendmsg(struct smc_sock *smc, struct msghdr *msg, size_t len)
 		 */
 		if ((msg->msg_flags & MSG_OOB) && !send_remaining)
 			conn->urg_tx_pend = true;
-		if ((msg->msg_flags & MSG_MORE || smc_tx_is_corked(smc)) &&
+		if ((msg->msg_flags & MSG_MORE || smc_tx_is_corked(smc) ||
+		     msg->msg_flags & MSG_SENDPAGE_NOTLAST) &&
 		    (atomic_read(&conn->sndbuf_space)))
 			/* for a corked socket defer the RDMA writes if
 			 * sndbuf_space is still available. The applications
@@ -257,6 +258,22 @@ int smc_tx_sendmsg(struct smc_sock *smc, struct msghdr *msg, size_t len)
 	return rc;
 }
 
+int smc_tx_sendpage(struct smc_sock *smc, struct page *page, int offset,
+		    size_t size, int flags)
+{
+	struct msghdr msg = {.msg_flags = flags};
+	char *kaddr = kmap(page);
+	struct kvec iov;
+	int rc;
+
+	iov.iov_base = kaddr + offset;
+	iov.iov_len = size;
+	iov_iter_kvec(&msg.msg_iter, WRITE, &iov, 1, size);
+	rc = smc_tx_sendmsg(smc, &msg, size);
+	kunmap(page);
+	return rc;
+}
+
 /***************************** sndbuf consumer *******************************/
 
 /* sndbuf consumer: actual data transfer of one target chunk with ISM write */
diff --git a/net/smc/smc_tx.h b/net/smc/smc_tx.h
index a59f370b8b43..34b578498b1f 100644
--- a/net/smc/smc_tx.h
+++ b/net/smc/smc_tx.h
@@ -31,6 +31,8 @@ void smc_tx_pending(struct smc_connection *conn);
 void smc_tx_work(struct work_struct *work);
 void smc_tx_init(struct smc_sock *smc);
 int smc_tx_sendmsg(struct smc_sock *smc, struct msghdr *msg, size_t len);
+int smc_tx_sendpage(struct smc_sock *smc, struct page *page, int offset,
+		    size_t size, int flags);
 int smc_tx_sndbuf_nonempty(struct smc_connection *conn);
 void smc_tx_sndbuf_nonfull(struct smc_sock *smc);
 void smc_tx_consumer_update(struct smc_connection *conn, bool force);
-- 
2.32.0.3.g01195cf9f

