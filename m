Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22B1C12B7CE
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 18:51:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727549AbfL0RnS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Dec 2019 12:43:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:40660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728167AbfL0RnQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Dec 2019 12:43:16 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F5B024654;
        Fri, 27 Dec 2019 17:43:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577468596;
        bh=gfIGQp34RVhSZnYCRMgdzjv+nUlxz9OyufQbnXilM/g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r1VPxnSe1OUI1O7HkaE0N3xnMJpRRzeeGSgzQ88gBL3MzYp1ZwqWOTbuAVIFP74Ap
         lXc/BA1KfQWJPqy5kuFli5Eaelyjhen2r6WndBWRnx2PiYa+QzUxj6eZX+QjWrg7JK
         E80BLzk5USgWqWEqCefva2FUtq9hvj9/4sVD02DY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ursula Braun <ubraun@linux.ibm.com>,
        syzbot+96d3f9ff6a86d37e44c8@syzkaller.appspotmail.com,
        Karsten Graul <kgraul@linux.ibm.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Sasha Levin <sashal@kernel.org>, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 117/187] net/smc: add fallback check to connect()
Date:   Fri, 27 Dec 2019 12:39:45 -0500
Message-Id: <20191227174055.4923-117-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191227174055.4923-1-sashal@kernel.org>
References: <20191227174055.4923-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ursula Braun <ubraun@linux.ibm.com>

[ Upstream commit 86434744fedf0cfe07a9eee3f4632c0e25c1d136 ]

FASTOPEN setsockopt() or sendmsg() may switch the SMC socket to fallback
mode. Once fallback mode is active, the native TCP socket functions are
called. Nevertheless there is a small race window, when FASTOPEN
setsockopt/sendmsg runs in parallel to a connect(), and switch the
socket into fallback mode before connect() takes the sock lock.
Make sure the SMC-specific connect setup is omitted in this case.

This way a syzbot-reported refcount problem is fixed, triggered by
different threads running non-blocking connect() and FASTOPEN_KEY
setsockopt.

Reported-by: syzbot+96d3f9ff6a86d37e44c8@syzkaller.appspotmail.com
Fixes: 6d6dd528d5af ("net/smc: fix refcount non-blocking connect() -part 2")
Signed-off-by: Ursula Braun <ubraun@linux.ibm.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/af_smc.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 737b49909a7a..6a6d3b2aa5a9 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -854,6 +854,8 @@ static int smc_connect(struct socket *sock, struct sockaddr *addr,
 		goto out;
 
 	sock_hold(&smc->sk); /* sock put in passive closing */
+	if (smc->use_fallback)
+		goto out;
 	if (flags & O_NONBLOCK) {
 		if (schedule_work(&smc->connect_work))
 			smc->connect_nonblock = 1;
@@ -1716,8 +1718,6 @@ static int smc_setsockopt(struct socket *sock, int level, int optname,
 		sk->sk_err = smc->clcsock->sk->sk_err;
 		sk->sk_error_report(sk);
 	}
-	if (rc)
-		return rc;
 
 	if (optlen < sizeof(int))
 		return -EINVAL;
@@ -1725,6 +1725,8 @@ static int smc_setsockopt(struct socket *sock, int level, int optname,
 		return -EFAULT;
 
 	lock_sock(sk);
+	if (rc || smc->use_fallback)
+		goto out;
 	switch (optname) {
 	case TCP_ULP:
 	case TCP_FASTOPEN:
@@ -1736,15 +1738,14 @@ static int smc_setsockopt(struct socket *sock, int level, int optname,
 			smc_switch_to_fallback(smc);
 			smc->fallback_rsn = SMC_CLC_DECL_OPTUNSUPP;
 		} else {
-			if (!smc->use_fallback)
-				rc = -EINVAL;
+			rc = -EINVAL;
 		}
 		break;
 	case TCP_NODELAY:
 		if (sk->sk_state != SMC_INIT &&
 		    sk->sk_state != SMC_LISTEN &&
 		    sk->sk_state != SMC_CLOSED) {
-			if (val && !smc->use_fallback)
+			if (val)
 				mod_delayed_work(system_wq, &smc->conn.tx_work,
 						 0);
 		}
@@ -1753,7 +1754,7 @@ static int smc_setsockopt(struct socket *sock, int level, int optname,
 		if (sk->sk_state != SMC_INIT &&
 		    sk->sk_state != SMC_LISTEN &&
 		    sk->sk_state != SMC_CLOSED) {
-			if (!val && !smc->use_fallback)
+			if (!val)
 				mod_delayed_work(system_wq, &smc->conn.tx_work,
 						 0);
 		}
@@ -1764,6 +1765,7 @@ static int smc_setsockopt(struct socket *sock, int level, int optname,
 	default:
 		break;
 	}
+out:
 	release_sock(sk);
 
 	return rc;
-- 
2.20.1

