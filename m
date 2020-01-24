Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BE5F1489A6
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 15:37:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389449AbgAXOTO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 09:19:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:39384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391388AbgAXOTN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Jan 2020 09:19:13 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 05F32208C4;
        Fri, 24 Jan 2020 14:19:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579875552;
        bh=rT2aUdahCJJgRHdhNyAEat9JFF7mmfvmHnL3jd5FgYI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BL/2K3TsF14oYQkcyjI+s7a8+zrwpTNuH5YHUFqyTS+hHuNOzVtDcm23BZD1HSKrd
         lNmN6MAdP75l5ZOE9Pgm908yMi7yxanKitRK+O5R/n6MSXLiwgL9+ieJJ54DblB7OS
         MAyzEVU7tSqafJUIyjWQHJDOmxpn4yPjgfhr+Ykw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lorenz Bauer <lmb@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 047/107] net: bpf: Don't leak time wait and request sockets
Date:   Fri, 24 Jan 2020 09:17:17 -0500
Message-Id: <20200124141817.28793-47-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200124141817.28793-1-sashal@kernel.org>
References: <20200124141817.28793-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lorenz Bauer <lmb@cloudflare.com>

[ Upstream commit 2e012c74823629d9db27963c79caa3f5b2010746 ]

It's possible to leak time wait and request sockets via the following
BPF pseudo code:
 
  sk = bpf_skc_lookup_tcp(...)
  if (sk)
    bpf_sk_release(sk)

If sk->sk_state is TCP_NEW_SYN_RECV or TCP_TIME_WAIT the refcount taken
by bpf_skc_lookup_tcp is not undone by bpf_sk_release. This is because
sk_flags is re-used for other data in both kinds of sockets. The check

  !sock_flag(sk, SOCK_RCU_FREE)

therefore returns a bogus result. Check that sk_flags is valid by calling
sk_fullsock. Skip checking SOCK_RCU_FREE if we already know that sk is
not a full socket.

Fixes: edbf8c01de5a ("bpf: add skc_lookup_tcp helper")
Fixes: f7355a6c0497 ("bpf: Check sk_fullsock() before returning from bpf_sk_lookup()")
Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Martin KaFai Lau <kafai@fb.com>
Link: https://lore.kernel.org/bpf/20200110132336.26099-1-lmb@cloudflare.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/filter.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 2f76461c120d2..3cbf06a466f7d 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -5305,8 +5305,7 @@ __bpf_sk_lookup(struct sk_buff *skb, struct bpf_sock_tuple *tuple, u32 len,
 	if (sk) {
 		sk = sk_to_full_sk(sk);
 		if (!sk_fullsock(sk)) {
-			if (!sock_flag(sk, SOCK_RCU_FREE))
-				sock_gen_put(sk);
+			sock_gen_put(sk);
 			return NULL;
 		}
 	}
@@ -5343,8 +5342,7 @@ bpf_sk_lookup(struct sk_buff *skb, struct bpf_sock_tuple *tuple, u32 len,
 	if (sk) {
 		sk = sk_to_full_sk(sk);
 		if (!sk_fullsock(sk)) {
-			if (!sock_flag(sk, SOCK_RCU_FREE))
-				sock_gen_put(sk);
+			sock_gen_put(sk);
 			return NULL;
 		}
 	}
@@ -5411,7 +5409,8 @@ static const struct bpf_func_proto bpf_sk_lookup_udp_proto = {
 
 BPF_CALL_1(bpf_sk_release, struct sock *, sk)
 {
-	if (!sock_flag(sk, SOCK_RCU_FREE))
+	/* Only full sockets have sk->sk_flags. */
+	if (!sk_fullsock(sk) || !sock_flag(sk, SOCK_RCU_FREE))
 		sock_gen_put(sk);
 	return 0;
 }
-- 
2.20.1

