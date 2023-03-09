Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 674FF6B27D5
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 15:53:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232062AbjCIOxA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 09:53:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232064AbjCIOw0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 09:52:26 -0500
Received: from mail-oa1-x2a.google.com (mail-oa1-x2a.google.com [IPv6:2001:4860:4864:20::2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB465DDF05
        for <netdev@vger.kernel.org>; Thu,  9 Mar 2023 06:50:30 -0800 (PST)
Received: by mail-oa1-x2a.google.com with SMTP id 586e51a60fabf-176d93cd0daso2550165fac.4
        for <netdev@vger.kernel.org>; Thu, 09 Mar 2023 06:50:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google; t=1678373427;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Yrosoov8wMW4bQ0IPE1nmhR+l/Rp0kl9JcSqtQe1jpE=;
        b=76O9ecj625aE035fR+jJca0HDYqsNoDQVIobeO4uYZKvNAy2QgeMNl8bYcvhqNILq4
         KaUmQ1TBTkHrALfRRzpIlPVR897HxDLP+c4ZUMAG0+krNEo9aO35Fc/SDyMNFYbgcmjR
         dyyiweHsCh5H+XQBoj9eyoAp1WBdALG9g2x8W1PfGSQUHRq1AzP4TbqUc7Hxz11aJep8
         R68ROACrf9mCnVCZ4EUjBc6ZYI//dy2CiaYlhrAjoXEelqFlklz/obHl0RXBMox38Gk+
         dk6iRleuEAyI2ocfY1JU50FMoplFBfBhu3LSV9FcyyyVzWIOQ87t+mSNBttpVkMJQwOv
         iwzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678373427;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Yrosoov8wMW4bQ0IPE1nmhR+l/Rp0kl9JcSqtQe1jpE=;
        b=V0FP4AawO0a0ZPVDsbyESibNKYync9RNtceZZtxzBnei9GdGyCPm/gkR/QWM294buv
         xwALB2IdFR+W/+VCHa4gvjtXbZWehjHmvI1mQ2BQKWIn/rSPyIB9vE3h1d1TZETFSbPQ
         0VeE9DvImu6YlfRTNuqAdHYQJq/tnMVLvLfBWtzMYvSrzXvYv22ia2NQ+Yc4vvoNSlki
         cpCVravgzsbr8z7HY6reU+IDEnngvg6YaF3RBYH0lf4R6jwKCyMVY9K9Vvag4+rYAJEW
         BXOofUpcNdDaT6/mz5LET3nAJOYZS7pNw/XvtA2KYjAzkSDAPgvccnqGF++s/8h0DRN1
         N+hA==
X-Gm-Message-State: AO0yUKVUhYCzW3xiDLl8uh4lrkk/k6wdEq3y2q0EuxKO90AaleHQJCBY
        1THjIb/UqKrPURNUaxhfmDy5kQ==
X-Google-Smtp-Source: AK7set9RwNdSia6Xh6JDQSoe/HTY0sLEIPEodV0I3z7HfordCWZxGxPJMIKJbfhs028daaLmaSeE8A==
X-Received: by 2002:a05:6870:65a2:b0:176:271d:2e22 with SMTP id fp34-20020a05687065a200b00176271d2e22mr2852112oab.19.1678373427133;
        Thu, 09 Mar 2023 06:50:27 -0800 (PST)
Received: from vdi08.nix.tessares.net (static.219.156.76.144.clients.your-server.de. [144.76.156.219])
        by smtp.gmail.com with ESMTPSA id ax39-20020a05687c022700b0016b0369f08fsm7351116oac.15.2023.03.09.06.50.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 06:50:26 -0800 (PST)
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Date:   Thu, 09 Mar 2023 15:49:57 +0100
Subject: [PATCH net v2 1/8] mptcp: fix possible deadlock in
 subflow_error_report
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230227-upstream-net-20230227-mptcp-fixes-v2-1-47c2e95eada9@tessares.net>
References: <20230227-upstream-net-20230227-mptcp-fixes-v2-0-47c2e95eada9@tessares.net>
In-Reply-To: <20230227-upstream-net-20230227-mptcp-fixes-v2-0-47c2e95eada9@tessares.net>
To:     mptcp@lists.linux.dev, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <martineau@kernel.org>,
        Jiang Biao <benbjiang@tencent.com>,
        Menglong Dong <imagedong@tencent.com>,
        Mengen Sun <mengensun@tencent.com>,
        Shuah Khan <shuah@kernel.org>, Florian Westphal <fw@strlen.de>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Christoph Paasch <cpaasch@apple.com>, stable@vger.kernel.org
X-Mailer: b4 0.12.1
X-Developer-Signature: v=1; a=openpgp-sha256; l=1773;
 i=matthieu.baerts@tessares.net; h=from:subject:message-id;
 bh=hldf995oDj7E8lQxC4BW/Zq3Mra/hurDbKe3yAogNH0=;
 b=owEBbQKS/ZANAwAIAfa3gk9CaaBzAcsmYgBkCfIhTQvT//R9yYrZy+DQCBgpgC83QuOSWPCRI
 UqPZe1dcRiJAjMEAAEIAB0WIQToy4X3aHcFem4n93r2t4JPQmmgcwUCZAnyIQAKCRD2t4JPQmmg
 c3YXEACUmPPmO+kb+DzJ09sg4PSISe1YOWwSv/mfrMCBc61sXOCGf7ZOllBXYfuF0aEqMJv+EkS
 7D7ElqKu505tvkp5UWykx+9kUtKboXrxB1gkoJeDuXaRxs/f5Ed/u7u+AFwtR8JV1OUHpB889g5
 K2IuPvpPRLBySAx0/I625uSqqty+rN7R84G7w5DCT3yThX6ViQJn9Lby1w4rcVVA9S35+vDgL6U
 iAFXIjTYVbspATWOY42glSHljqgPe/zBTTbvcwuxnof+RAGcVZnVz3kqztMduVOsN83A+Z0w7qF
 zP23RmPdN579J9ZtLex3LgkRy31y02XZxyx4OziSNYlsgGeWu5eebTQ5FuoWhLuvDCx1i08hUyw
 QxSKb5DL/VBkQF4kIuz9JdybvOvQvTk1rvvIqL9hu5EagFfRPDjNsbwZgReKw2F4LNtLRlwjCmq
 xzRMKvZuTDstc9vn3800vHJWeS4dXlgLvBUtwjJMaQpv/mgWKgxomaEoCp2hTpP+fz0TeZaZ7dM
 8lHSQQSVa1Re/N7vVfzLwO6SlS7ytLcw1Z4kHtCn3RxMvws201IwAIlAqN7/sv/0sxov4Wl3SPa
 sD/Lbs6h4ZCBuJUg2B9J+1sSnbnBRsPnUeFp6aA/ebjRDtD5TjWVUdHP+4a5a8+6rBh+XlXCJeB
 /4wzJXDSTjabKIA==
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

Reported-and-tested-by: Christoph Paasch <cpaasch@apple.com>
Fixes: 15cc10453398 ("mptcp: deliver ssk errors to msk")
Cc: stable@vger.kernel.org
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
2.39.2

