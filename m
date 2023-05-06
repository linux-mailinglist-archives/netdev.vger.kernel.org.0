Return-Path: <netdev+bounces-659-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F4886F8D36
	for <lists+netdev@lfdr.de>; Sat,  6 May 2023 02:46:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2EC5828114A
	for <lists+netdev@lfdr.de>; Sat,  6 May 2023 00:46:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFD9A10E6;
	Sat,  6 May 2023 00:46:40 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45FE8621;
	Sat,  6 May 2023 00:46:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBACFC433D2;
	Sat,  6 May 2023 00:46:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683333999;
	bh=ZAkmkq+aTuI735T8ACAAM8XAarYEEBTyx4dDrbx31Dw=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=Mzr38cLgXUf12dbjt0u17y+VFctVaOG7X2UywqBiWKYD91YT/9xo0f37E9NaoGOut
	 4H9Fz2SOTEHbCK+m2g7mlwWrMMuGsgnD5vFF30ROb9jXKXJnnDMvIneLrrcw+psyQa
	 0teR8mO/O5u0H6nFbDpNs/+1fnvtRSw+SIUXXmVqreVMq9x15XkpMRme5+MxdM1qTd
	 DWL+QrpJjQvsj3T7bPDI6SLTPp9P4AAKc4uvMqnrsq8iz8sR8xekBu0t168rm9aGh6
	 ThgOzD9snIgIPIEMgLCsqNE2BlhfEvcZF/0ecRjRtPlUz8rK3hs8sIJVpKujcILPL6
	 M2TxtpCk3V8OQ==
Subject: [PATCH v2 3/6] net/handshake: Fix uninitialized local variable
From: Chuck Lever <cel@kernel.org>
To: kernel-tls-handshake@lists.linux.dev
Cc: netdev@vger.kernel.org, dan.carpenter@linaro.org
Date: Fri, 05 May 2023 20:46:27 -0400
Message-ID: 
 <168333397774.7813.3273700580854407784.stgit@oracle-102.nfsv4bat.org>
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
index 032d96152e2f..11cc275d726a 100644
--- a/net/handshake/netlink.c
+++ b/net/handshake/netlink.c
@@ -154,8 +154,8 @@ int handshake_nl_accept_doit(struct sk_buff *skb, struct genl_info *info)
 int handshake_nl_done_doit(struct sk_buff *skb, struct genl_info *info)
 {
 	struct net *net = sock_net(skb->sk);
+	struct handshake_req *req = NULL;
 	struct socket *sock = NULL;
-	struct handshake_req *req;
 	int fd, status, err;
 
 	if (GENL_REQ_ATTR_CHECK(info, HANDSHAKE_A_DONE_SOCKFD))



