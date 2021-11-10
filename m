Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 613E844C194
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 13:51:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231675AbhKJMxt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 07:53:49 -0500
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:56920 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231210AbhKJMxs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Nov 2021 07:53:48 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=guwen@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0UvuzFxJ_1636548651;
Received: from e02h04404.eu6sqa(mailfrom:guwen@linux.alibaba.com fp:SMTPD_---0UvuzFxJ_1636548651)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 10 Nov 2021 20:50:58 +0800
From:   Wen Gu <guwen@linux.alibaba.com>
To:     kgraul@linux.ibm.com, tonylu@linux.alibaba.com
Cc:     davem@davemloft.net, kuba@kernel.org, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        dust.li@linux.alibaba.com, xuanzhuo@linux.alibaba.com,
        guwen@linux.alibaba.com
Subject: [RFC PATCH net v2 1/2] net/smc: Fix socket wait queue mismatch issue caused by fallback
Date:   Wed, 10 Nov 2021 20:50:50 +0800
Message-Id: <1636548651-44649-2-git-send-email-guwen@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1636548651-44649-1-git-send-email-guwen@linux.alibaba.com>
References: <1636548651-44649-1-git-send-email-guwen@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There may be a mismatch of socket wait queue caused by SMC fallback.

When user applications used SMC to replace TCP, they might add
an eppoll_entry into smc socket->wq and expect to be notified if
epoll events like EPOLL_IN/EPOLL_OUT occurred on the smc socket.

However, once a fallback occurred, user applications start to use
clcsocket. So it is clcsocket->wq instead of smc socket->wq which
is woken up when there is data to be processed or sending space
available. Thus the eppoll_entry which was added into smc socket->wq
before fallback does not work anymore.

[if not fallback]
   application
        ^
      (poll)
        |
  smc socket->wq            clcsocket->wq
(has eppoll_entry)                .
        .                         .
        .                         .
smc socket->sk->sk_wq    clcsocket->sk->sk_wq
        ^                         ^
        | (data flow)             |(tcp handshake in rendezvous)
        |                         |
|-------------------------------------------|
|   sk_data_ready / sk_write_space ..       |
|-------------------------------------------|

[if fallback]
   application <------------------|
                        (can't poll anything)
                                  |
  smc socket->wq            clcsocket->wq
(has eppoll_entry)                .
        .                         .
        .                         .
smc socket->sk->sk_wq    clcsocket->sk->sk_wq
                                  ^
                                  |(data flow)
                                  |
|-------------------------------------------|
|   sk_data_ready / sk_write_space ..       |
|-------------------------------------------|

For example, in nginx/wrk benchmark, this issue will cause an
all-zeros test result:

server: nginx -g 'daemon off;'
client: smc_run wrk -c 1 -t 1 -d 5 http://11.200.15.93/index.html

  Running 5s test @ http://11.200.15.93/index.html
     1 threads and 1 connections
     Thread Stats   Avg      Stdev     Max   ± Stdev
     	Latency     0.00us    0.00us   0.00us    -nan%
	Req/Sec     0.00      0.00     0.00      -nan%
	0 requests in 5.00s, 0.00B read
     Requests/sec:      0.00
     Transfer/sec:       0.00B

The main idea of this patch is that since wait queue is switched
from smc socket->wq to clcsocket->wq after fallback, disabling the
eppoll_entry in smc socket->wq, maybe we can try to use clcsocket->wq
from the beginning.

So this patch set smc socket->sk->sk_wq to clcsocket->wq when smc
socket is created and reset clcsocket->sk->sk_wq to clcsocket->wq
once fallback occurrs, making clcsocket->wq the constant wait queue
that user applications use. Thus the user application can be
notified by the eppoll_entry in clcsocket->wq no matter whether
a fallback occurrs.

After this patch:

[if not fallback]
   application <------------------|
                                (poll)
                                  |
  smc socket->wq            clcsocket->wq
        .                 (has eppoll_entry)
            `   .                 .
                    `   . .   `
                  .   `    `   .
               `                  `
smc socket->sk->sk_wq    clcsocket->sk->sk_wq
        ^                         ^
        |(data flow)              |(tcp handshake in rendezvous)
        |                         |
|-------------------------------------------|
|   sk_data_ready / sk_write_space ..       |
|-------------------------------------------|

[if fallback]
   application <------------------|
                                (poll)
                                  |
  smc socket->wq            clcsocket->wq
        .                 (has eppoll_entry)
            `   .                 .
                    `   .         .
                           `   .  .
                                  `
smc socket->sk->sk_wq    clcsocket->sk->sk_wq
                                  ^
                                  |(data flow)
                                  |
|-------------------------------------------|
|   sk_data_ready / sk_write_space ..       |
|-------------------------------------------|

Link: https://lore.kernel.org/all/db9acf73-abef-209e-6ec2-8ada92e2cfbc@linux.ibm.com/
Signed-off-by: Wen Gu <guwen@linux.alibaba.com>
Reviewed-by: Tony Lu <tonylu@linux.alibaba.com>
---
v1 -> v2
- Add the complete description about the intention of initial patch.
---
 net/smc/af_smc.c | 56 ++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 54 insertions(+), 2 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 0cf7ed2..fe5a2cd 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -566,6 +566,20 @@ static void smc_switch_to_fallback(struct smc_sock *smc, int reason_code)
 	smc->fallback_rsn = reason_code;
 	smc_stat_fallback(smc);
 	trace_smc_switch_to_fallback(smc, reason_code);
+
+	/* We swapped sk->sk_wq of clcsocket and smc socket in smc_create()
+	 * to prevent mismatch of wait queue caused by fallback.
+	 *
+	 * If fallback really occurred, user application starts to use clcsocket.
+	 * Accordingly, clcsocket->sk->sk_wq should be reset to clcsocket->wq
+	 * in order that user application still uses the same wait queue as what
+	 * was used before fallback.
+	 *
+	 * After fallback, the relation between socket->wq and socket->sk->sk_wq is:
+	 * - clcsocket->sk->sk_wq  -->  clcsocket->wq
+	 * - smcsocket->sk->sk_wq  -->  clcsocket->wq
+	 */
+	rcu_assign_pointer(smc->clcsock->sk->sk_wq, &smc->clcsock->wq);
 	if (smc->sk.sk_socket && smc->sk.sk_socket->file) {
 		smc->clcsock->file = smc->sk.sk_socket->file;
 		smc->clcsock->file->private_data = smc->clcsock;
@@ -2174,6 +2188,12 @@ static int smc_accept(struct socket *sock, struct socket *new_sock,
 	if (rc)
 		goto out;
 
+	/* The new accepted smc sock sets sk->sk_wq to clcsocket->wq like what
+	 * smc_create() did when the fallback does not occur.
+	 */
+	if (!smc_sk(nsk)->use_fallback)
+		rcu_assign_pointer(nsk->sk_wq, &smc_sk(nsk)->clcsock->wq);
+
 	if (lsmc->sockopt_defer_accept && !(flags & O_NONBLOCK)) {
 		/* wait till data arrives on the socket */
 		timeo = msecs_to_jiffies(lsmc->sockopt_defer_accept *
@@ -2310,8 +2330,15 @@ static __poll_t smc_poll(struct file *file, struct socket *sock,
 		mask = smc->clcsock->ops->poll(file, smc->clcsock, wait);
 		sk->sk_err = smc->clcsock->sk->sk_err;
 	} else {
-		if (sk->sk_state != SMC_CLOSED)
-			sock_poll_wait(file, sock, wait);
+		if (sk->sk_state != SMC_CLOSED) {
+			/* SMC always uses clcsocket->wq for the call to
+			 * sock_poll_wait(), which is the same wait queue
+			 * as what smc socket->sk->sk_wq points to before
+			 * fallback or what clcsocket->sk->sk_wq points to
+			 * after fallback.
+			 */
+			sock_poll_wait(file, smc->clcsock, wait);
+		}
 		if (sk->sk_err)
 			mask |= EPOLLERR;
 		if ((sk->sk_shutdown == SHUTDOWN_MASK) ||
@@ -2707,6 +2734,31 @@ static int smc_create(struct net *net, struct socket *sock, int protocol,
 	smc->sk.sk_sndbuf = max(smc->clcsock->sk->sk_sndbuf, SMC_BUF_MIN_SIZE);
 	smc->sk.sk_rcvbuf = max(smc->clcsock->sk->sk_rcvbuf, SMC_BUF_MIN_SIZE);
 
+	/* To ensure that user applications consistently use the same wait queue
+	 * before and after fallback, we set smc socket->sk->sk_wq to clcsocket->wq
+	 * here and reset clcsocket->sk->sk_wq to clcsocket->wq in
+	 * smc_switch_to_fallback() if fallback occurrs, making clcsocket->wq the
+	 * constant wait queue which user applications use.
+	 *
+	 * here:
+	 * - Set smc socket->sk->sk_wq to clcsocket->wq
+	 *   So that the sk_data_ready()/sk_write_space.. will wake up clcsocket->wq
+	 *   and user applications will be notified of epoll events if they added
+	 *   eppoll_entry into clcsocket->wq through smc_poll().
+	 *
+	 * - Set clcsocket->sk->sk_wq to smc socket->wq
+	 *   Since clcsocket->wq is occupied by smcsocket->sk->sk_wq, clcsocket->
+	 *   sk->sk_wq have to use another wait queue (smc socket->wq) during TCP
+	 *   handshake or CLC messages transmission in rendezvous.
+	 *
+	 * So the relation between socket->wq and socket->sk->sk_wq before fallback is:
+	 *
+	 * - smc socket->sk->sk_wq --> clcsocket->wq
+	 * - clcsocket->sk->sk_wq  --> smc socket->wq
+	 */
+	rcu_assign_pointer(sk->sk_wq, &smc->clcsock->wq);
+	rcu_assign_pointer(smc->clcsock->sk->sk_wq, &smc->sk.sk_socket->wq);
+
 out:
 	return rc;
 }
-- 
1.8.3.1

