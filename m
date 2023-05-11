Return-Path: <netdev+bounces-1883-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 40A716FF66C
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 17:49:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 91C29281820
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 15:49:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8ECC7652;
	Thu, 11 May 2023 15:49:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59C08629;
	Thu, 11 May 2023 15:49:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16A22C433EF;
	Thu, 11 May 2023 15:49:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683820175;
	bh=aDpweWMjQuVTT5Ut+AsOxd7z3mNVCL1824CEVBYrfIk=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=POELqaBU67S4V/9ZEm2qIRr2g/9pB6uTShcirfYrKZdEweGrzMR5TKNnJmyJJoexK
	 74z0WF7E3SWN+i7qdwW6HupV9DT+3VFMERaP64r/PoJtHTAt7d1rtKAPj160m+JfMm
	 vB7KSQK77UL1EEwLiC8e1xnytDaEbXlux4JdYsfQdJdGCfq8o7DRY8c4sw2oY6mINw
	 CRREmJwHyMHdUAgYrexCvzeSEVG42xte0hf9TkypysLyp+y03S1O9kGfJCrOdAfJ4F
	 +P/jy9+/amSzwu+vp+YX2CeoIsIvaa8aTlKOUbdmBk5CHWEfJkuV5Y92vnPj2qBICc
	 bn9GtrWyVeiTg==
Subject: [PATCH v3 5/6] net/handshake: Unpin sock->file if a handshake is
 cancelled
From: Chuck Lever <cel@kernel.org>
To: netdev@vger.kernel.org
Cc: kernel-tls-handshake@lists.linux.dev, dan.carpenter@linaro.org,
 chuck.lever@oracle.com
Date: Thu, 11 May 2023 11:49:17 -0400
Message-ID: 
 <168382014752.84244.8085186506163091822.stgit@91.116.238.104.host.secureserver.net>
In-Reply-To: 
 <168381978252.84244.1933636428135211300.stgit@91.116.238.104.host.secureserver.net>
References: 
 <168381978252.84244.1933636428135211300.stgit@91.116.238.104.host.secureserver.net>
User-Agent: StGit/1.5
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Chuck Lever <chuck.lever@oracle.com>

If user space never calls DONE, sock->file's reference count remains
elevated. Enable sock->file to be freed eventually in this case.

Reported-by: Jakub Kacinski <kuba@kernel.org>
Fixes: 3b3009ea8abb ("net/handshake: Create a NETLINK service for handling handshake requests")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 net/handshake/handshake.h |    1 +
 net/handshake/request.c   |    4 ++++
 2 files changed, 5 insertions(+)

diff --git a/net/handshake/handshake.h b/net/handshake/handshake.h
index 4dac965c99df..8aeaadca844f 100644
--- a/net/handshake/handshake.h
+++ b/net/handshake/handshake.h
@@ -31,6 +31,7 @@ struct handshake_req {
 	struct list_head		hr_list;
 	struct rhash_head		hr_rhash;
 	unsigned long			hr_flags;
+	struct file			*hr_file;
 	const struct handshake_proto	*hr_proto;
 	struct sock			*hr_sk;
 	void				(*hr_odestruct)(struct sock *sk);
diff --git a/net/handshake/request.c b/net/handshake/request.c
index 94d5cef3e048..d78d41abb3d9 100644
--- a/net/handshake/request.c
+++ b/net/handshake/request.c
@@ -239,6 +239,7 @@ int handshake_req_submit(struct socket *sock, struct handshake_req *req,
 	}
 	req->hr_odestruct = req->hr_sk->sk_destruct;
 	req->hr_sk->sk_destruct = handshake_sk_destruct;
+	req->hr_file = sock->file;
 
 	ret = -EOPNOTSUPP;
 	net = sock_net(req->hr_sk);
@@ -334,6 +335,9 @@ bool handshake_req_cancel(struct sock *sk)
 		return false;
 	}
 
+	/* Request accepted and waiting for DONE */
+	fput(req->hr_file);
+
 out_true:
 	trace_handshake_cancel(net, req, sk);
 



