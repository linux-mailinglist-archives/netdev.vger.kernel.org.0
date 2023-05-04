Return-Path: <netdev+bounces-293-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C9AA6F6EE0
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 17:25:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9D1F61C2118E
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 15:25:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C20A079D3;
	Thu,  4 May 2023 15:25:44 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 514C8FC04;
	Thu,  4 May 2023 15:25:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD333C433EF;
	Thu,  4 May 2023 15:25:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683213943;
	bh=54ETPiT81oUrVet9tQSEV7zfyqNgqW6pD9IyJ9CtNZg=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=u57/Hx6mjmIqJCe9LJVhacwTj7GwB+MdJ/qO7qC9BSc9121Vq9RmsXHD8cOKkpYg1
	 66Td4bPLK4txXpG0kr5ruA0pOlC4x/YWW3X8zZ13bzilMs9YQqxnb5NGU8NQmBHvO9
	 jN4gSYe7Vj45QfC34/Ff3f/1ovxjQISrT6LPE5JB3kvqOE8ndFX8/swwRlnJlDGIaK
	 SLawAp2/FT+T66egDGis2ltYA0BxiEOXw+NYTgOEov5soEnr4L52SLA+AIJzmeWapi
	 zRPGXdYjWLQm1YWhAR8PrKb4VbnjCwgMTGszJZ208CIllpXcC55KD4qOfyDSU/e8Gd
	 s+KQ0bSz8ZT1A==
Subject: [PATCH 3/5] net/handshake: Fix uninitialized local variable
From: Chuck Lever <cel@kernel.org>
To: kernel-tls-handshake@lists.linux.dev
Cc: netdev@vger.kernel.org, dan.carpenter@linaro.org
Date: Thu, 04 May 2023 11:25:32 -0400
Message-ID: 
 <168321392193.16695.5713194659624553982.stgit@oracle-102.nfsv4bat.org>
In-Reply-To: 
 <168321371754.16695.4217960864733718685.stgit@oracle-102.nfsv4bat.org>
References: 
 <168321371754.16695.4217960864733718685.stgit@oracle-102.nfsv4bat.org>
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
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 net/handshake/netlink.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/handshake/netlink.c b/net/handshake/netlink.c
index 3508bc3e661d..8c2d13190314 100644
--- a/net/handshake/netlink.c
+++ b/net/handshake/netlink.c
@@ -152,8 +152,8 @@ int handshake_nl_accept_doit(struct sk_buff *skb, struct genl_info *info)
 int handshake_nl_done_doit(struct sk_buff *skb, struct genl_info *info)
 {
 	struct net *net = sock_net(skb->sk);
+	struct handshake_req *req = NULL;
 	struct socket *sock = NULL;
-	struct handshake_req *req;
 	int fd, status, err;
 
 	if (GENL_REQ_ATTR_CHECK(info, HANDSHAKE_A_DONE_SOCKFD))



