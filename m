Return-Path: <netdev+bounces-1881-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0DF5F6FF66A
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 17:48:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2A68E1C20FB0
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 15:48:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FA4E647;
	Thu, 11 May 2023 15:48:32 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41D1E629;
	Thu, 11 May 2023 15:48:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1669C433D2;
	Thu, 11 May 2023 15:48:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683820110;
	bh=OyfApSLop6wGi6tJ8cu+P/1B7e3GxDFUSaByQ7EXDLw=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=R/XqmjXRLQajaFnliWz27lzQ3o9Dg78ZTVTVLvCTvpsOoPhYsDmolFJj9yoSyPPzJ
	 k/DKeY/EgFr4lGXEla0XuOsAneuiBpLqbfjpSbl1UpPI1eK4awRaluz97TWgaFavSr
	 oAgq2tJpyQONFPoLHXUfQFgNAS24VpGNc7IQPPhDbJTMzJWjS9jGoV7z5ia7aJtLnm
	 xDZsHHzfJJKHcqo8w9nfb+S6a3B1wpdwtL6Cq1kI+3sQq10kSLfW2NYl0ZokbrnZVG
	 P/AgmkD2WeWX9/VpXhxkhU8s1sBOW/sNIh06cqiV9iXBV6LlV/JI6Ns7aa8iUrebFW
	 KLKyKRsACUm6Q==
Subject: [PATCH v3 3/6] net/handshake: Fix uninitialized local variable
From: Chuck Lever <cel@kernel.org>
To: netdev@vger.kernel.org
Cc: kernel-tls-handshake@lists.linux.dev, dan.carpenter@linaro.org,
 chuck.lever@oracle.com
Date: Thu, 11 May 2023 11:48:13 -0400
Message-ID: 
 <168382008303.84244.4050103332725966411.stgit@91.116.238.104.host.secureserver.net>
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

trace_handshake_cmd_done_err() simply records the pointer in @req,
so initializing it to NULL is sufficient and safe.

Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Fixes: 3b3009ea8abb ("net/handshake: Create a NETLINK service for handling handshake requests")
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 net/handshake/netlink.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/handshake/netlink.c b/net/handshake/netlink.c
index f5dc170689d9..16a4bde648ba 100644
--- a/net/handshake/netlink.c
+++ b/net/handshake/netlink.c
@@ -157,8 +157,8 @@ int handshake_nl_accept_doit(struct sk_buff *skb, struct genl_info *info)
 int handshake_nl_done_doit(struct sk_buff *skb, struct genl_info *info)
 {
 	struct net *net = sock_net(skb->sk);
+	struct handshake_req *req = NULL;
 	struct socket *sock = NULL;
-	struct handshake_req *req;
 	int fd, status, err;
 
 	if (GENL_REQ_ATTR_CHECK(info, HANDSHAKE_A_DONE_SOCKFD))



