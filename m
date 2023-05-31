Return-Path: <netdev+bounces-6909-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BE95F718A4A
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 21:38:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5E1E428157A
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 19:38:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7010F34CDF;
	Wed, 31 May 2023 19:37:20 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 638A82098E;
	Wed, 31 May 2023 19:37:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB5B8C433A7;
	Wed, 31 May 2023 19:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685561838;
	bh=Yuc+8vL6g2z70pfEizKVvsSEp4rll6sEz7sy25zJhlA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=tmwo2tmWuVdq5iWjNLsnXALC7Njvyy1lQUtig4TFRbfl/r1UiXW8Q+71NanrFVPtS
	 7ANOa1QU+T4viT1+HMZQLplqQekgyDVEwRe7LSWINJmovft31HY4q7cE/6dP+FQdjY
	 zbLMXwH96KApXpNBXJCruNYtPd+YT6hfZ8uOT63AnAPT36qqppbpR623AaCfMZoR3U
	 cz8xKUfV/Eig6XxryTYOeqD7+tdn7tmdFVzhxQ1Aa0ToU0U9FfL9HpmwTTpxOhdKwe
	 9jcBnxeiQKTYWOB1v3Ca2Pa5fCVWPWxXNpJNEIOV0+XVG9JadfnFjQp2Y/Og1Yg71h
	 IBNtkswgYASrA==
From: Mat Martineau <martineau@kernel.org>
Date: Wed, 31 May 2023 12:37:06 -0700
Subject: [PATCH net 4/6] mptcp: fix data race around msk->first access
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230531-send-net-20230531-v1-4-47750c420571@kernel.org>
References: <20230531-send-net-20230531-v1-0-47750c420571@kernel.org>
In-Reply-To: <20230531-send-net-20230531-v1-0-47750c420571@kernel.org>
To: Matthieu Baerts <matthieu.baerts@tessares.net>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Geliang Tang <geliang.tang@suse.com>
Cc: netdev@vger.kernel.org, mptcp@lists.linux.dev, 
 Mat Martineau <martineau@kernel.org>
X-Mailer: b4 0.12.2

From: Paolo Abeni <pabeni@redhat.com>

The first subflow socket is accessed outside the msk socket lock
by mptcp_subflow_fail(), we need to annotate each write access
with WRITE_ONCE, but a few spots still lacks it.

Fixes: 76a13b315709 ("mptcp: invoke MP_FAIL response when needed")
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <martineau@kernel.org>
---
 net/mptcp/protocol.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 2ecd0117ab1b..a7dd7d8c9af2 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -90,7 +90,7 @@ static int __mptcp_socket_create(struct mptcp_sock *msk)
 	if (err)
 		return err;
 
-	msk->first = ssock->sk;
+	WRITE_ONCE(msk->first, ssock->sk);
 	WRITE_ONCE(msk->subflow, ssock);
 	subflow = mptcp_subflow_ctx(ssock->sk);
 	list_add(&subflow->node, &msk->conn_list);
@@ -2419,7 +2419,7 @@ static void __mptcp_close_ssk(struct sock *sk, struct sock *ssk,
 	sock_put(ssk);
 
 	if (ssk == msk->first)
-		msk->first = NULL;
+		WRITE_ONCE(msk->first, NULL);
 
 out:
 	if (ssk == msk->last_snd)
@@ -2720,7 +2720,7 @@ static int __mptcp_init_sock(struct sock *sk)
 	WRITE_ONCE(msk->rmem_released, 0);
 	msk->timer_ival = TCP_RTO_MIN;
 
-	msk->first = NULL;
+	WRITE_ONCE(msk->first, NULL);
 	inet_csk(sk)->icsk_sync_mss = mptcp_sync_mss;
 	WRITE_ONCE(msk->csum_enabled, mptcp_is_checksum_enabled(sock_net(sk)));
 	WRITE_ONCE(msk->allow_infinite_fallback, true);

-- 
2.40.1


