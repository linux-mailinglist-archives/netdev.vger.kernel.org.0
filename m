Return-Path: <netdev+bounces-5226-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 48B3471053D
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 07:17:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0F4AE1C20DE2
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 05:17:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54F085C9C;
	Thu, 25 May 2023 05:17:49 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F21CE5233
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 05:17:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46C2AC433D2;
	Thu, 25 May 2023 05:17:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684991867;
	bh=JdVXXBeCa7S3wWrSG3vNSQXOjTlVEQdup9qFaFXDjQw=;
	h=From:To:Cc:Subject:Date:From;
	b=kBfFIGDNEB/VtFg3L1wuophtaCAd3wLzMH/EBIGLnx8nFi48XDczh7cy4dv9FS/4i
	 KjYuvW+RVeAmFbR1OBN/CTrq+nL3cfAbNu6lbSEzcI4eADy76UT4Aj+z5x8iHiwEDA
	 HD3/nh5vaBl3HIxlTmzcSSXrvzU7RuEySZId4uDF1ah2qa3gAbBXlAzj8r2REzKsXI
	 3Fpd/gQJSMhaW2TDNI6Y6VB2L0mGOeWvHL6bJtudM5AWFs3oP3DRPvmcTYWIEmFlKR
	 oTyKJ7POdDkyiyC+EQ0TDDIIczkhwkQEM4c9W4+kvvR9SKeN+QQYH4jo4+ZPP2Yvam
	 zSbHRJ1p8GgDw==
From: Jakub Kicinski <kuba@kernel.org>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org,
	edumazet@google.com,
	pabeni@redhat.com,
	borisp@nvidia.com,
	john.fastabend@gmail.com,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net] tls: improve lockless access safety of tls_err_abort()
Date: Wed, 24 May 2023 22:17:41 -0700
Message-Id: <20230525051741.2223624-1-kuba@kernel.org>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Most protos' poll() methods insert a memory barrier between
writes to sk_err and sk_error_report(). This dates back to
commit a4d258036ed9 ("tcp: Fix race in tcp_poll").

I guess we should do the same thing in TLS, tcp_poll() does
not hold the socket lock.

Fixes: 3c4d7559159b ("tls: kernel TLS support")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/tls/tls_strp.c | 4 +++-
 net/tls/tls_sw.c   | 4 +++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/tls/tls_strp.c b/net/tls/tls_strp.c
index 955ac3e0bf4d..1f7696b060d5 100644
--- a/net/tls/tls_strp.c
+++ b/net/tls/tls_strp.c
@@ -20,7 +20,9 @@ static void tls_strp_abort_strp(struct tls_strparser *strp, int err)
 	strp->stopped = 1;
 
 	/* Report an error on the lower socket */
-	strp->sk->sk_err = -err;
+	WRITE_ONCE(strp->sk->sk_err, -err);
+	/* Paired with smp_rmb() in tcp_poll() */
+	smp_wmb();
 	sk_error_report(strp->sk);
 }
 
diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 635b8bf6b937..eaf08777abdc 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -70,7 +70,9 @@ noinline void tls_err_abort(struct sock *sk, int err)
 {
 	WARN_ON_ONCE(err >= 0);
 	/* sk->sk_err should contain a positive error code. */
-	sk->sk_err = -err;
+	WRITE_ONCE(sk->sk_err, -err);
+	/* Paired with smp_rmb() in tcp_poll() */
+	smp_wmb();
 	sk_error_report(sk);
 }
 
-- 
2.40.1


