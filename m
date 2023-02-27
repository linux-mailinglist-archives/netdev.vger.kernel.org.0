Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B11616A47EC
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 18:30:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229971AbjB0RaC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 12:30:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229806AbjB0RaA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 12:30:00 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 061121DBA8
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 09:29:58 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id j2so7042428wrh.9
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 09:29:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CkrVR8IpelSR7zXBF4SBBe4tWOQsLGXK04CO9kW0/yg=;
        b=Yn/px1am7cbKSlGsDURXtIvwA23GniZ6Ac9vJqqJAkyPAUvr190mJbn6mnsF9kDWyV
         2tpRDmMYD7s2f+TABsDUn2EbMwYu4/RQk5SbfjUCv9ksW0HY9xcTjbi35nT4tlA9zdSM
         MXqDBbLK7PoPkbXQ70VSEZtvsABshbcM0NWuGmAp0Y5hlPJ3l6KERe+lns2Ty0bXkc8U
         zfDTqC2fxsipgCFC9g5PQ0vfTqs4pzuziQln2/PTwtS8irmqdNLmyJMdSKRDAj+OL3jt
         VA60oFXs1gXx5bGmIDKJ8LxtxWVaSJuw0CudHHLVq6Ci9Kv+4rLZNKF2pYcl2MAVd/+C
         Sg4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CkrVR8IpelSR7zXBF4SBBe4tWOQsLGXK04CO9kW0/yg=;
        b=GadKb9hWMAXzJV3K66u73nm26IdvjDAYbcba0Wbh3YquB64NDC5zedFcnqzHLLRmZX
         IOVgwAEwttYS/g0/TF/H/HO2CcysrEuVpmuEGe1u0uuJQ+J1VkRg2c/oo5w8+8cN/a9r
         bg1uJtcZuTzm79aFR3lDuSIi2sUuYfI77znDjJGehMcjYNgBs94S+CVjQjuBKxZE6lMz
         auBcdoxW+AM4knQpgiuOvltshnbiaX68NLPnvWyr+AIGnnYqmjruc+jtTpA/7Wm7O8IR
         gf7wjrx0LAI7MWWKRBBOXqaK4rZuAFl9rsjaIlJb6l5lBaMSqfkiVOgwLKLkuJ6ebdwd
         9/KA==
X-Gm-Message-State: AO0yUKVQ62N6OYkgZ3+Ulyf8/pb7/cnxH2w1vCuHbTccgeAW0E1TuD6d
        c1lFWOix6kuJ2R0XT6F0qWDd6w==
X-Google-Smtp-Source: AK7set/JnWk1UyaRb1YKMa1DF4RW4nfkaEQh89lVtdGl+srvgLKb0mXKKO11wQjPgt2FhCH9F4fm0w==
X-Received: by 2002:a05:6000:1084:b0:2c9:9b81:11de with SMTP id y4-20020a056000108400b002c99b8111demr6415376wrw.20.1677518996458;
        Mon, 27 Feb 2023 09:29:56 -0800 (PST)
Received: from vdi08.nix.tessares.net (static.219.156.76.144.clients.your-server.de. [144.76.156.219])
        by smtp.gmail.com with ESMTPSA id t1-20020a5d6a41000000b002c70a68111asm7763689wrw.83.2023.02.27.09.29.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Feb 2023 09:29:56 -0800 (PST)
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Date:   Mon, 27 Feb 2023 18:29:24 +0100
Subject: [PATCH net 1/7] mptcp: fix possible deadlock in
 subflow_error_report
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230227-upstream-net-20230227-mptcp-fixes-v1-1-070e30ae4a8e@tessares.net>
References: <20230227-upstream-net-20230227-mptcp-fixes-v1-0-070e30ae4a8e@tessares.net>
In-Reply-To: <20230227-upstream-net-20230227-mptcp-fixes-v1-0-070e30ae4a8e@tessares.net>
To:     mptcp@lists.linux.dev, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Menglong Dong <imagedong@tencent.com>,
        Mengen Sun <mengensun@tencent.com>,
        Shuah Khan <shuah@kernel.org>, Florian Westphal <fw@strlen.de>,
        Jiang Biao <benbjiang@tencent.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        stable@vger.kernel.org, Christoph Paasch <cpaasch@apple.com>
X-Mailer: b4 0.12.1
X-Developer-Signature: v=1; a=openpgp-sha256; l=1773;
 i=matthieu.baerts@tessares.net; h=from:subject:message-id;
 bh=TTLxtOJXIxhAzU2Ans9CXrgkFiujzShJkR9NjXQn9rY=;
 b=owEBbQKS/ZANAwAIAfa3gk9CaaBzAcsmYgBj/OiRE3F5ay5kGiWIfxQsUKE7LlPzVFaNd5SKZ
 U2P3p8ptlqJAjMEAAEIAB0WIQToy4X3aHcFem4n93r2t4JPQmmgcwUCY/zokQAKCRD2t4JPQmmg
 c6BZEADuXb8S+o9AGKfBIncaTRHfx1t03EFWmhpNgaijVxi0IPqa4aUg4ANgX/8mhldc4Nro56n
 rQigc6Wn1isU5dlU2rLUKWj0dHqJEmI1WbIXJJ5hNeetC7nvkMNyOmMGmGzgzfi7PiyH7p8eKVy
 w9n8DiNdkVESgusKCCzN7ZQK9cPGShpKXMlGmj0P8lOsfxwX5H2Q4gaHVEASeQBDNWrpQPG/vjy
 NQFH3Gfy85TNeFchETPh1jgh4vXIRPTIvlCyShQkWqb+RA05VtlUrjRF81paOCAk1eK7xRAyqZE
 WhngO9R8v3oItScnxxzc0UK6LXx+sVK3fyrw0a99MU8RjqSQo8VSB8ns6mePLrUnSilBXj6qHi7
 gyqCB1GIM3C3/TMzVomsPuo2SZY82K+aSNsrPC1SiXQMYUC6MHWtjF1fhqPISpatgQV+Tzsf12B
 eLIxipvrqVW1ChvdhXqMOXKGdPvCkKGBMKWYI9X56ZOpxK1ubxAGzlp1qqvMcy5TS0jZ1jfS8pr
 C8ZiZD5hS0Kxe790PbfT8xmB7kVwb5+LXYyyBJn7R5RvjGDc3A1FfsjZlesKBFupO2+//voOBrx
 GNZYCk/tY1Wk7AhmHqWXeM7JVPlNKtA3fqvaBPgaic2sn/+AJ/FSf0G601WRv40r3Oj3zXHdC5v
 L/YGb2wt2idFWaA==
X-Developer-Key: i=matthieu.baerts@tessares.net; a=openpgp;
 fpr=E8CB85F76877057A6E27F77AF6B7824F4269A073
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

Christoph reported a possible deadlock while the TCP stack
destroys an unaccepted subflow due to an incoming reset: the
MPTCP socket error path tries to acquire the msk-level socket
lock while TCP still owns the listener socket accept queue
spinlock, and the reverse dependency already exists in the
TCP stack.

Note that the above is actually a lockdep false positive, as
the chain involves two separate sockets. A different per-socket
lockdep key will address the issue, but such a change will be
quite invasive.

Instead, we can simply stop earlier the socket error handling
for orphaned or unaccepted subflows, breaking the critical
lockdep chain. Error handling in such a scenario is a no-op.

Fixes: 15cc10453398 ("mptcp: deliver ssk errors to msk")
Cc: stable@vger.kernel.org
Reported-and-tested-by: Christoph Paasch <cpaasch@apple.com>
Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/355
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
 net/mptcp/subflow.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 4ae1a7304cf0..5070dc33675d 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -1432,6 +1432,13 @@ static void subflow_error_report(struct sock *ssk)
 {
 	struct sock *sk = mptcp_subflow_ctx(ssk)->conn;
 
+	/* bail early if this is a no-op, so that we avoid introducing a
+	 * problematic lockdep dependency between TCP accept queue lock
+	 * and msk socket spinlock
+	 */
+	if (!sk->sk_socket)
+		return;
+
 	mptcp_data_lock(sk);
 	if (!sock_owned_by_user(sk))
 		__mptcp_error_report(sk);

-- 
2.38.1

