Return-Path: <netdev+bounces-661-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8BDA86F8D38
	for <lists+netdev@lfdr.de>; Sat,  6 May 2023 02:47:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 47D22281158
	for <lists+netdev@lfdr.de>; Sat,  6 May 2023 00:47:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96B5BEC3;
	Sat,  6 May 2023 00:47:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03B4F621;
	Sat,  6 May 2023 00:47:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 953D6C433D2;
	Sat,  6 May 2023 00:47:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683334044;
	bh=aDpweWMjQuVTT5Ut+AsOxd7z3mNVCL1824CEVBYrfIk=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=iNgUaQt/LdgF0Y6X2ljGI7Pdm62MeJUdIytZRAg7pLkodTYqjA5kafePIB37cOuuw
	 gNOoSiSV/aCmYWgnJ/rWtOSe+xMgUoiYOZ4gOe6LGgdT6msnyX1Y1LjZtop+VApGRv
	 arxUlPFBnbyysPUUNuqQCmP43qrU5lIy6QQbzuyninhy4qibi9/5/IaRvVjNJnn3Mn
	 ZXAoqXxa2HMAlMZM+Z9rXBmoIiWCqFgCK5WTqkEh6tBE2F/XPcNi8AZw7Lpkz5zIii
	 ODog0dQVIIR3+xyPP7iPshLXBB2jkbD3JxYu4PptWs7SsZnGlaYhzyWmMxP5s8gfSq
	 JP36JSDFXxEjA==
Subject: [PATCH v2 5/6] net/handshake: Unpin sock->file if a handshake is
 cancelled
From: Chuck Lever <cel@kernel.org>
To: kernel-tls-handshake@lists.linux.dev
Cc: netdev@vger.kernel.org, dan.carpenter@linaro.org
Date: Fri, 05 May 2023 20:47:13 -0400
Message-ID: 
 <168333403089.7813.511134747683134976.stgit@oracle-102.nfsv4bat.org>
In-Reply-To: 
 <168333373851.7813.11884763481187785511.stgit@oracle-102.nfsv4bat.org>
References: 
 <168333373851.7813.11884763481187785511.stgit@oracle-102.nfsv4bat.org>
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
 



