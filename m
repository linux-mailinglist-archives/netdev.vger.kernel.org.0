Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12D781358A9
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 12:58:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730348AbgAIL6s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 06:58:48 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:33618 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730264AbgAIL6r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 06:58:47 -0500
Received: by mail-wm1-f68.google.com with SMTP id d139so1891774wmd.0
        for <netdev@vger.kernel.org>; Thu, 09 Jan 2020 03:58:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1rlOVVzlIiRtFZks5/lLiUWPWerO848tJVKJUJDT+zo=;
        b=rk3alyznkOGmxU582kJxzO103S5dGuzlXwxudH2eHL4WS6/WCCkXg3TP+YrCAyChxF
         MHeftt7vdb+6pNDiBFb31TUxoKd78u49VkIbzbpqtRlnVNY0oMJ5Hxy81bvvgvUrSHYg
         k0U9/48D5/Ms1pRxZlC1J0br2Ut8/dkuu/1L4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1rlOVVzlIiRtFZks5/lLiUWPWerO848tJVKJUJDT+zo=;
        b=BNrjmuQsAiZfS2G/nQxgMkt1xZIUVP77NLJfN0SH/pt6Z1lii84SDo+smbklCl1EtT
         bSRYYZDv73/6deugeLgiKWy4fdbuDol4TWFC9WQgC+PVEg9XYxjBrMOll+OFhKmS3NJW
         p/Z2s/XwSyl54GH+hxD/AJXf85wBOFu8CxvYih0AhwKkp4zTLgdaDp0NtIl6T+eTlh0j
         PqCNpF70LcSyQrLwLvBhHBK8sg0W506MVeF+79cPU8tqKLgv1KskxyuOAu1DbazkjBGt
         QnN2bCZqIELGC/JghsemuW/xzHRpRs72GQ86diNzoaz9S0JjuaKF0A77PRlCkNgDSHYu
         N7CQ==
X-Gm-Message-State: APjAAAX1FTXdbJihNF/0enlYHW7qSHVdrTkBZNssDrRrXeWNTzju3oHs
        W9rFcMmep+iuNDQL2ms95Jl4pA==
X-Google-Smtp-Source: APXvYqyutNBniQQekS7aBd1mEWMPCgClEf647St5Ra0WHTPMf39/lT/e28kz3s4Dt8NwvdrM/7R+1Q==
X-Received: by 2002:a7b:c30b:: with SMTP id k11mr4540527wmj.36.1578571125126;
        Thu, 09 Jan 2020 03:58:45 -0800 (PST)
Received: from localhost.localdomain ([2a06:98c0:1000:8250:cd2c:908b:e15b:9937])
        by smtp.gmail.com with ESMTPSA id z124sm2728120wmc.20.2020.01.09.03.58.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jan 2020 03:58:44 -0800 (PST)
From:   Lorenz Bauer <lmb@cloudflare.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Joe Stringer <joe@isovalent.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     kernel-team@cloudflare.com, edumazet@google.com
Subject: [PATCH bpf 1/1] net: bpf: don't leak time wait and request sockets
Date:   Thu,  9 Jan 2020 11:57:48 +0000
Message-Id: <20200109115749.12283-2-lmb@cloudflare.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200109115749.12283-1-lmb@cloudflare.com>
References: <20200109115749.12283-1-lmb@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It's possible to leak time wait and request sockets via the following
BPF pseudo code:
 
  sk = bpf_skc_lookup_tcp(...)
  if (sk)
    bpf_sk_release(sk)

If sk->sk_state is TCP_NEW_SYN_RECV or TCP_TIME_WAIT the refcount taken
by bpf_skc_lookup_tcp is not undone by bpf_sk_release. This is because
sk_flags is re-used for other data in both kinds of sockets. The check

  !sock_flag(sk, SOCK_RCU_FREE)

therefore returns a bogus result.

Introduce a helper to account for this complication, and call it from
the necessary places.

Fixes: edbf8c01de5a ("bpf: add skc_lookup_tcp helper")
Fixes: f7355a6c0497 ("bpf: Check sk_fullsock() before returning from bpf_sk_lookup()")
Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
---
 net/core/filter.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 42fd17c48c5f..d98dc4526d82 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -5266,6 +5266,14 @@ __bpf_skc_lookup(struct sk_buff *skb, struct bpf_sock_tuple *tuple, u32 len,
 	return sk;
 }
 
+static void __bpf_sk_release(struct sock *sk)
+{
+	/* time wait and request socks don't have sk_flags. */
+	if (sk->sk_state == TCP_TIME_WAIT || sk->sk_state == TCP_NEW_SYN_RECV ||
+	    !sock_flag(sk, SOCK_RCU_FREE))
+		sock_gen_put(sk);
+}
+
 static struct sock *
 __bpf_sk_lookup(struct sk_buff *skb, struct bpf_sock_tuple *tuple, u32 len,
 		struct net *caller_net, u32 ifindex, u8 proto, u64 netns_id,
@@ -5277,8 +5285,7 @@ __bpf_sk_lookup(struct sk_buff *skb, struct bpf_sock_tuple *tuple, u32 len,
 	if (sk) {
 		sk = sk_to_full_sk(sk);
 		if (!sk_fullsock(sk)) {
-			if (!sock_flag(sk, SOCK_RCU_FREE))
-				sock_gen_put(sk);
+			__bpf_sk_release(sk);
 			return NULL;
 		}
 	}
@@ -5315,8 +5322,7 @@ bpf_sk_lookup(struct sk_buff *skb, struct bpf_sock_tuple *tuple, u32 len,
 	if (sk) {
 		sk = sk_to_full_sk(sk);
 		if (!sk_fullsock(sk)) {
-			if (!sock_flag(sk, SOCK_RCU_FREE))
-				sock_gen_put(sk);
+			__bpf_sk_release(sk);
 			return NULL;
 		}
 	}
@@ -5383,8 +5389,7 @@ static const struct bpf_func_proto bpf_sk_lookup_udp_proto = {
 
 BPF_CALL_1(bpf_sk_release, struct sock *, sk)
 {
-	if (!sock_flag(sk, SOCK_RCU_FREE))
-		sock_gen_put(sk);
+	__bpf_sk_release(sk);
 	return 0;
 }
 
-- 
2.20.1

