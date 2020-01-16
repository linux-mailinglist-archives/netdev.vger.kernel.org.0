Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69DE113F8B8
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 20:20:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731292AbgAPQxz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 11:53:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:37938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731221AbgAPQxv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 11:53:51 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DB9912464B;
        Thu, 16 Jan 2020 16:53:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193630;
        bh=64x82PQuv5pebgDgHhtSr+hFf0pKyR4SaaHfSStuJYU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Piat3vyyqytUa/5WiJyI56c9wyzuGNQd5XuC9KHUahU7brCcjE6jtcoAr8r0Gte8D
         Ysb0g/gPC5++4a+oY76TFmVPaKnL00V9bk5Fyk+CHAECwUcYJ3RjK7ToQRlbqJCdJ/
         2BQ4dlqr+T5ybTNMQSYa40hTrbIgWZhoiT/LHKbo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 164/205] bpf: skmsg, fix potential psock NULL pointer dereference
Date:   Thu, 16 Jan 2020 11:42:19 -0500
Message-Id: <20200116164300.6705-164-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116164300.6705-1-sashal@kernel.org>
References: <20200116164300.6705-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: John Fastabend <john.fastabend@gmail.com>

[ Upstream commit 8163999db445021f2651a8a47b5632483e8722ea ]

Report from Dan Carpenter,

 net/core/skmsg.c:792 sk_psock_write_space()
 error: we previously assumed 'psock' could be null (see line 790)

 net/core/skmsg.c
   789 psock = sk_psock(sk);
   790 if (likely(psock && sk_psock_test_state(psock, SK_PSOCK_TX_ENABLED)))
 Check for NULL
   791 schedule_work(&psock->work);
   792 write_space = psock->saved_write_space;
                     ^^^^^^^^^^^^^^^^^^^^^^^^
   793          rcu_read_unlock();
   794          write_space(sk);

Ensure psock dereference on line 792 only occurs if psock is not null.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Fixes: 604326b41a6f ("bpf, sockmap: convert to generic sk_msg interface")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/skmsg.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 0675d022584e..ded2d5227678 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -793,15 +793,18 @@ static void sk_psock_strp_data_ready(struct sock *sk)
 static void sk_psock_write_space(struct sock *sk)
 {
 	struct sk_psock *psock;
-	void (*write_space)(struct sock *sk);
+	void (*write_space)(struct sock *sk) = NULL;
 
 	rcu_read_lock();
 	psock = sk_psock(sk);
-	if (likely(psock && sk_psock_test_state(psock, SK_PSOCK_TX_ENABLED)))
-		schedule_work(&psock->work);
-	write_space = psock->saved_write_space;
+	if (likely(psock)) {
+		if (sk_psock_test_state(psock, SK_PSOCK_TX_ENABLED))
+			schedule_work(&psock->work);
+		write_space = psock->saved_write_space;
+	}
 	rcu_read_unlock();
-	write_space(sk);
+	if (write_space)
+		write_space(sk);
 }
 
 int sk_psock_init_strp(struct sock *sk, struct sk_psock *psock)
-- 
2.20.1

