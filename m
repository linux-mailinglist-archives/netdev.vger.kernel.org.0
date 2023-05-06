Return-Path: <netdev+bounces-658-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 25BCE6F8D35
	for <lists+netdev@lfdr.de>; Sat,  6 May 2023 02:46:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D3B16281114
	for <lists+netdev@lfdr.de>; Sat,  6 May 2023 00:46:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E765EC3;
	Sat,  6 May 2023 00:46:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2B60621;
	Sat,  6 May 2023 00:46:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C029C433D2;
	Sat,  6 May 2023 00:46:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683333972;
	bh=ZCsRoT7DHUOwvfQisN/eN6hX0iIyuVSFHVTheC00DTg=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=tQD4kOrTbm/O7IjFXyDmg60ok8lWzT1hSnaGwm5uziMlIu/iAnXTrrAMv40lPjiX8
	 7KzSoEBvayGQUabAtsyPeJWx8CE6sp3i79jJBtWj89tbP3Xyi98z/ukHh34Kx0oizE
	 gu2YO/rxDYOEfdpIwEBdFwMhufJKAeNHPzq+cdDeHhEPksrcEcT3c0LXPBLCX0Dlyj
	 HWnsquRlRZ0IJtYZlDvZGtyJVNMKqISgeWki/yDRCj5gpiR3pYomQQ6ek8NlyOe3N0
	 UxTWZChgXM8Jswqd4E+PNgxEQH/xWY9jAwqIfQuzA86jn4aatJPL/Pey8jPNhRIzpL
	 AttIEAWKG3FqA==
Subject: [PATCH v2 2/6] net/handshake: Fix handshake_dup() ref counting
From: Chuck Lever <cel@kernel.org>
To: kernel-tls-handshake@lists.linux.dev
Cc: netdev@vger.kernel.org, dan.carpenter@linaro.org
Date: Fri, 05 May 2023 20:46:01 -0400
Message-ID: 
 <168333395123.7813.7077088598355438510.stgit@oracle-102.nfsv4bat.org>
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

If get_unused_fd_flags() fails, we ended up calling fput(sock->file)
twice.

Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Fixes: 3b3009ea8abb ("net/handshake: Create a NETLINK service for handling handshake requests")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 net/handshake/netlink.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/handshake/netlink.c b/net/handshake/netlink.c
index 7ec8a76c3c8a..032d96152e2f 100644
--- a/net/handshake/netlink.c
+++ b/net/handshake/netlink.c
@@ -101,10 +101,8 @@ static int handshake_dup(struct socket *sock)
 
 	file = get_file(sock->file);
 	newfd = get_unused_fd_flags(O_CLOEXEC);
-	if (newfd < 0) {
-		fput(file);
+	if (newfd < 0)
 		return newfd;
-	}
 
 	fd_install(newfd, file);
 	return newfd;



