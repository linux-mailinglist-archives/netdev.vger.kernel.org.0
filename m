Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E28945E4E6
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 03:39:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358072AbhKZChf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 21:37:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:47780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1357668AbhKZCfc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Nov 2021 21:35:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B8557611C2;
        Fri, 26 Nov 2021 02:32:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637893934;
        bh=LLaNTuYp6X0PdsP29TQBaA7+g4WHxWDJStntUYVy4Cg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=My0+f6hj37IN6DGFBU/n5Gv8uRb6jco398bZOMKLmbwrHl+w1S31eR77Ihl12NCxc
         YW95x73xAbZMlMoS/g/V75C7UgxCilRWb0vQkSnY1JDzVaT59MWzGneDPrWOIdUpqe
         ZkJ/gUhg6VRhfK2VFRAM1ig3tStExhBb21ztfHUUnMVA3velz20WA9+ksYxOfgd9K8
         T1PG5vVc4+/AZg0t5yMctI/VO72Vfe3B5p2xEhY9wSJH4UZTdXpCsdKytZFvoWaBob
         WFOJq2HdGKR5k2eGz/EU2QCMkaM/tr9MlK9vIw/DLdxyu79ejR7JXfHOBATCF6rFSt
         BaIrx4qg9qy+g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wen Gu <guwen@linux.alibaba.com>,
        Tony Lu <tonylu@linux.alibaba.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, kgraul@linux.ibm.com,
        kuba@kernel.org, linux-s390@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 10/39] net/smc: Transfer remaining wait queue entries during fallback
Date:   Thu, 25 Nov 2021 21:31:27 -0500
Message-Id: <20211126023156.441292-10-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211126023156.441292-1-sashal@kernel.org>
References: <20211126023156.441292-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wen Gu <guwen@linux.alibaba.com>

[ Upstream commit 2153bd1e3d3dbf6a3403572084ef6ed31c53c5f0 ]

The SMC fallback is incomplete currently. There may be some
wait queue entries remaining in smc socket->wq, which should
be removed to clcsocket->wq during the fallback.

For example, in nginx/wrk benchmark, this issue causes an
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

The reason for this all-zeros result is that when wrk used SMC
to replace TCP, it added an eppoll_entry into smc socket->wq
and expected to be notified if epoll events like EPOLL_IN/
EPOLL_OUT occurred on the smc socket.

However, once a fallback occurred, wrk switches to use clcsocket.
Now it is clcsocket->wq instead of smc socket->wq which will
be woken up. The eppoll_entry remaining in smc socket->wq does
not work anymore and wrk stops the test.

This patch fixes this issue by removing remaining wait queue
entries from smc socket->wq to clcsocket->wq during the fallback.

Link: https://www.spinics.net/lists/netdev/msg779769.html
Signed-off-by: Wen Gu <guwen@linux.alibaba.com>
Reviewed-by: Tony Lu <tonylu@linux.alibaba.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/af_smc.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 32c1c7ce856d3..c6df2245c9a40 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -548,6 +548,10 @@ static void smc_stat_fallback(struct smc_sock *smc)
 
 static void smc_switch_to_fallback(struct smc_sock *smc, int reason_code)
 {
+	wait_queue_head_t *smc_wait = sk_sleep(&smc->sk);
+	wait_queue_head_t *clc_wait = sk_sleep(smc->clcsock->sk);
+	unsigned long flags;
+
 	smc->use_fallback = true;
 	smc->fallback_rsn = reason_code;
 	smc_stat_fallback(smc);
@@ -556,6 +560,16 @@ static void smc_switch_to_fallback(struct smc_sock *smc, int reason_code)
 		smc->clcsock->file->private_data = smc->clcsock;
 		smc->clcsock->wq.fasync_list =
 			smc->sk.sk_socket->wq.fasync_list;
+
+		/* There may be some entries remaining in
+		 * smc socket->wq, which should be removed
+		 * to clcsocket->wq during the fallback.
+		 */
+		spin_lock_irqsave(&smc_wait->lock, flags);
+		spin_lock(&clc_wait->lock);
+		list_splice_init(&smc_wait->head, &clc_wait->head);
+		spin_unlock(&clc_wait->lock);
+		spin_unlock_irqrestore(&smc_wait->lock, flags);
 	}
 }
 
-- 
2.33.0

