Return-Path: <netdev+bounces-1880-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A21716FF668
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 17:48:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BF8C11C20FD1
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 15:47:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96A28647;
	Thu, 11 May 2023 15:47:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F4AF629;
	Thu, 11 May 2023 15:47:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEEA8C433EF;
	Thu, 11 May 2023 15:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683820077;
	bh=JVa+JmJ7EbX6WyEkf+ieofnkzomPLGEGHh0oRL/kXEg=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=m7RUIAXAtCsmslFTbm44U3iaMhCa3yMJE8VGnxw3xgolOPucfNSxMCydkegZAhxlq
	 +vY6SielVKCv9eQEF1fk8Zvt0I6pvcbq0StBBKj9vkRMoxfWu2G3nNvGdMi6nDsL3D
	 +uZme6JYvQNSIOo3l59ieIM3073KHc4IK1i+opA6JcL8aHPbl7xpcsqphCyArnyYBN
	 JLoBNzJ2CovaApaFl/GEVrqJm2CBJ2P2YcOWAPe50m0n/3+zweBgzYwJfVMc6CMyTV
	 bXQ9u4vn3q9FgmX9Y+JoDVORBSXwZ0Ecld0foFDTirMkuDu+eDkkGXeKcOgqr2tTBS
	 D9+ZGncdjZ22Q==
Subject: [PATCH v3 2/6] net/handshake: Fix handshake_dup() ref counting
From: Chuck Lever <cel@kernel.org>
To: netdev@vger.kernel.org
Cc: kernel-tls-handshake@lists.linux.dev, dan.carpenter@linaro.org,
 chuck.lever@oracle.com
Date: Thu, 11 May 2023 11:47:40 -0400
Message-ID: 
 <168382005054.84244.14487543591680880365.stgit@91.116.238.104.host.secureserver.net>
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

If get_unused_fd_flags() fails, we ended up calling fput(sock->file)
twice.

Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Suggested-by: Paolo Abeni <pabeni@redhat.com>
Fixes: 3b3009ea8abb ("net/handshake: Create a NETLINK service for handling handshake requests")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 net/handshake/netlink.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/handshake/netlink.c b/net/handshake/netlink.c
index 7ec8a76c3c8a..f5dc170689d9 100644
--- a/net/handshake/netlink.c
+++ b/net/handshake/netlink.c
@@ -139,15 +139,16 @@ int handshake_nl_accept_doit(struct sk_buff *skb, struct genl_info *info)
 		goto out_complete;
 	}
 	err = req->hr_proto->hp_accept(req, info, fd);
-	if (err)
+	if (err) {
+		fput(sock->file);
 		goto out_complete;
+	}
 
 	trace_handshake_cmd_accept(net, req, req->hr_sk, fd);
 	return 0;
 
 out_complete:
 	handshake_complete(req, -EIO, NULL);
-	fput(sock->file);
 out_status:
 	trace_handshake_cmd_accept_err(net, req, NULL, err);
 	return err;



