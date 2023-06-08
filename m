Return-Path: <netdev+bounces-9375-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CBE6A728A0A
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 23:14:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 775D2281771
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 21:14:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 509A434D85;
	Thu,  8 Jun 2023 21:12:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7438731F1A
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 21:12:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC8BBC433B0;
	Thu,  8 Jun 2023 21:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686258730;
	bh=5V+K+CXMn3CYKrnw5jUizVXFYYfCOTmFP0Pps/1mKtQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uRdrxCBoTkVk57ZrG4cy2B+9x5FwvHsvxJ5DD+r+dhdbvrB2y6m9cUV7MGVak50Ux
	 sXv9O6jYlh/ealQUpYWdEARvRjbLO55ZSOjZ3E+UuB58+8rXVPN5H4hcjOnAJc342S
	 CjfVlTwLC+rQPumgSTENigLXKZoYRwUjYwnyP0BpevVuAGGQy8eBdFXQJ2Qz7bJV9U
	 VWNgnjNdgJBfC2fUp/kgjx2SEy18ea19qPQmHctm4sw+05YURYwuc7xjAX1dN4toWf
	 zym53oqJfbdKeEAFD9JF32I77SUgC6mMvxMTgHvueA3JkHoC2eu636akpJsVwCCd0L
	 udCCxbHA1j7qQ==
From: Jakub Kicinski <kuba@kernel.org>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org,
	edumazet@google.com,
	pabeni@redhat.com,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 08/12] tools: ynl: regen: stop generating common notification handlers
Date: Thu,  8 Jun 2023 14:11:56 -0700
Message-Id: <20230608211200.1247213-9-kuba@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230608211200.1247213-1-kuba@kernel.org>
References: <20230608211200.1247213-1-kuba@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Remove unused notification handlers.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 tools/net/ynl/generated/handshake-user.c | 45 -----------------------
 tools/net/ynl/generated/handshake-user.h |  3 --
 tools/net/ynl/generated/netdev-user.c    | 47 ------------------------
 tools/net/ynl/generated/netdev-user.h    |  3 --
 4 files changed, 98 deletions(-)

diff --git a/tools/net/ynl/generated/handshake-user.c b/tools/net/ynl/generated/handshake-user.c
index 3a0392b3355e..7c67765daf90 100644
--- a/tools/net/ynl/generated/handshake-user.c
+++ b/tools/net/ynl/generated/handshake-user.c
@@ -315,51 +315,6 @@ int handshake_done(struct ynl_sock *ys, struct handshake_done_req *req)
 	return 0;
 }
 
-/* --------------- Common notification parsing --------------- */
-struct ynl_ntf_base_type *handshake_ntf_parse(struct ynl_sock *ys)
-{
-	struct ynl_parse_arg yarg = { .ys = ys, };
-	struct ynl_ntf_base_type *rsp;
-	struct genlmsghdr *genlh;
-	struct nlmsghdr *nlh;
-	mnl_cb_t parse;
-	int len, err;
-
-	len = mnl_socket_recvfrom(ys->sock, ys->rx_buf, MNL_SOCKET_BUFFER_SIZE);
-	if (len < (ssize_t)(sizeof(*nlh) + sizeof(*genlh)))
-		return NULL;
-
-	nlh = (struct nlmsghdr *)ys->rx_buf;
-	genlh = mnl_nlmsg_get_payload(nlh);
-
-	switch (genlh->cmd) {
-	case HANDSHAKE_CMD_READY:
-		rsp = calloc(1, sizeof(struct handshake_accept_ntf));
-		parse = handshake_accept_rsp_parse;
-		yarg.rsp_policy = &handshake_accept_nest;
-		rsp->free = (void *)handshake_accept_ntf_free;
-		break;
-	default:
-		ynl_error_unknown_notification(ys, genlh->cmd);
-		return NULL;
-	}
-
-	yarg.data = rsp->data;
-
-	err = mnl_cb_run2(ys->rx_buf, len, 0, 0, parse, &yarg,
-			 ynl_cb_array, NLMSG_MIN_TYPE);
-	if (err < 0)
-		goto err_free;
-
-	rsp->family = nlh->nlmsg_type;
-	rsp->cmd = genlh->cmd;
-	return rsp;
-
-err_free:
-	free(rsp);
-	return NULL;
-}
-
 static const struct ynl_ntf_info handshake_ntf_info[] =  {
 	[HANDSHAKE_CMD_READY] =  {
 		.alloc_sz	= sizeof(struct handshake_accept_ntf),
diff --git a/tools/net/ynl/generated/handshake-user.h b/tools/net/ynl/generated/handshake-user.h
index 38e0844f2efd..47646bb91cea 100644
--- a/tools/net/ynl/generated/handshake-user.h
+++ b/tools/net/ynl/generated/handshake-user.h
@@ -142,7 +142,4 @@ __handshake_done_req_set_remote_auth(struct handshake_done_req *req,
  */
 int handshake_done(struct ynl_sock *ys, struct handshake_done_req *req);
 
-/* --------------- Common notification parsing --------------- */
-struct ynl_ntf_base_type *handshake_ntf_parse(struct ynl_sock *ys);
-
 #endif /* _LINUX_HANDSHAKE_GEN_H */
diff --git a/tools/net/ynl/generated/netdev-user.c b/tools/net/ynl/generated/netdev-user.c
index 12069784637e..4eb8aefef0cd 100644
--- a/tools/net/ynl/generated/netdev-user.c
+++ b/tools/net/ynl/generated/netdev-user.c
@@ -172,53 +172,6 @@ void netdev_dev_get_ntf_free(struct netdev_dev_get_ntf *rsp)
 	free(rsp);
 }
 
-/* --------------- Common notification parsing --------------- */
-struct ynl_ntf_base_type *netdev_ntf_parse(struct ynl_sock *ys)
-{
-	struct ynl_parse_arg yarg = { .ys = ys, };
-	struct ynl_ntf_base_type *rsp;
-	struct genlmsghdr *genlh;
-	struct nlmsghdr *nlh;
-	mnl_cb_t parse;
-	int len, err;
-
-	len = mnl_socket_recvfrom(ys->sock, ys->rx_buf, MNL_SOCKET_BUFFER_SIZE);
-	if (len < (ssize_t)(sizeof(*nlh) + sizeof(*genlh)))
-		return NULL;
-
-	nlh = (struct nlmsghdr *)ys->rx_buf;
-	genlh = mnl_nlmsg_get_payload(nlh);
-
-	switch (genlh->cmd) {
-	case NETDEV_CMD_DEV_ADD_NTF:
-	case NETDEV_CMD_DEV_DEL_NTF:
-	case NETDEV_CMD_DEV_CHANGE_NTF:
-		rsp = calloc(1, sizeof(struct netdev_dev_get_ntf));
-		parse = netdev_dev_get_rsp_parse;
-		yarg.rsp_policy = &netdev_dev_nest;
-		rsp->free = (void *)netdev_dev_get_ntf_free;
-		break;
-	default:
-		ynl_error_unknown_notification(ys, genlh->cmd);
-		return NULL;
-	}
-
-	yarg.data = rsp->data;
-
-	err = mnl_cb_run2(ys->rx_buf, len, 0, 0, parse, &yarg,
-			 ynl_cb_array, NLMSG_MIN_TYPE);
-	if (err < 0)
-		goto err_free;
-
-	rsp->family = nlh->nlmsg_type;
-	rsp->cmd = genlh->cmd;
-	return rsp;
-
-err_free:
-	free(rsp);
-	return NULL;
-}
-
 static const struct ynl_ntf_info netdev_ntf_info[] =  {
 	[NETDEV_CMD_DEV_ADD_NTF] =  {
 		.alloc_sz	= sizeof(struct netdev_dev_get_ntf),
diff --git a/tools/net/ynl/generated/netdev-user.h b/tools/net/ynl/generated/netdev-user.h
index d146bc4b2112..5554dc69bb9c 100644
--- a/tools/net/ynl/generated/netdev-user.h
+++ b/tools/net/ynl/generated/netdev-user.h
@@ -82,7 +82,4 @@ struct netdev_dev_get_ntf {
 
 void netdev_dev_get_ntf_free(struct netdev_dev_get_ntf *rsp);
 
-/* --------------- Common notification parsing --------------- */
-struct ynl_ntf_base_type *netdev_ntf_parse(struct ynl_sock *ys);
-
 #endif /* _LINUX_NETDEV_GEN_H */
-- 
2.40.1


