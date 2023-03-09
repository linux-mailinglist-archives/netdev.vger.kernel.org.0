Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E4666B27F6
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 15:55:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231799AbjCIOzJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 09:55:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232020AbjCIOyF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 09:54:05 -0500
Received: from mail-oa1-x2a.google.com (mail-oa1-x2a.google.com [IPv6:2001:4860:4864:20::2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 169B3F31E8
        for <netdev@vger.kernel.org>; Thu,  9 Mar 2023 06:51:29 -0800 (PST)
Received: by mail-oa1-x2a.google.com with SMTP id 586e51a60fabf-176b48a9a05so2609002fac.0
        for <netdev@vger.kernel.org>; Thu, 09 Mar 2023 06:51:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google; t=1678373488;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Hmy3PkPHQ2u3OS0v9qWvPRQmIDrYZcauNq0B9Zz8Ptw=;
        b=75S4M1/anGft2wOuhmMfIB2P5gXujxapU5TSo4ZG6/cMhcGqvW3htpmJHpBs8faCf8
         W4TXN3jKZ7vKY46xq/Ohqw0jSxPPZTD8w70DIs3L4p0fhlcZj4v4LYNBKkFBU1mIlYiA
         CB/CwRmr8041sLXRxpxhIV2l3YdAExY4pOTQYpZA/k6zymLu3myyjK/Jml2Zj+caFWoG
         jUX6HUTKv6LRJGCEQRlwJX5jIoaWxoM34y6OEmrbyr7CupjCRi/R7n+YQhC3wtERhr1c
         1+gUKRo+U4UjkGLTZMeT6WtWFAr1CC+l9MgiwsDtNvO1MRp4AKnYAywf0JMcmZrhf/IU
         rogw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678373488;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Hmy3PkPHQ2u3OS0v9qWvPRQmIDrYZcauNq0B9Zz8Ptw=;
        b=fRh3uRH8vdErOqkVbJCzWKY5LDmfn887HVIu667NZH9Loyjg2dwRLT/FYs4RSWX6R/
         kAKBNWHfEpkwygx3KQMIUQ0jpHVg3v5u70SDNNFqDQWC+g0vgBBvUbfq5+/TRR9lmNBs
         9QVMYsj+fZeDeT7aRO2g4IJZygLLrkr6eObFz2Ysat/H3YKVxSbpHnions3TIkSdxTmZ
         vebJyHp1Pvxy8ick8mAEUejz0GZo4rhYyN/iyFmlEcHH/BCn72QcBLQd7tt34VICX8Y7
         wYKpKTi3L60fm1pPhfckTtV7CYecv6U1s38xgUZhjUHyJEz5t+BG37YfihQxfQ0lsxPt
         AxzA==
X-Gm-Message-State: AO0yUKV9XgbL68rXSQjudwO/2/LBI3py8NdjqEKjs8/hYERvUNF8OghF
        E3POJH3CEpCkBf5pfpdEN154ioIGRAQcefjy9UGT0w==
X-Google-Smtp-Source: AK7set/Q93gXpFgSkUWy+boYAiBLU/suM/9YdzeWXiBdvjgFNz3JrdgnlUBcu4Cy6bJL/cS+yvNOfA==
X-Received: by 2002:a05:6870:63a7:b0:163:58e8:77e5 with SMTP id t39-20020a05687063a700b0016358e877e5mr13797510oap.52.1678373487398;
        Thu, 09 Mar 2023 06:51:27 -0800 (PST)
Received: from vdi08.nix.tessares.net (static.219.156.76.144.clients.your-server.de. [144.76.156.219])
        by smtp.gmail.com with ESMTPSA id ax39-20020a05687c022700b0016b0369f08fsm7351116oac.15.2023.03.09.06.51.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 06:51:27 -0800 (PST)
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Date:   Thu, 09 Mar 2023 15:50:04 +0100
Subject: [PATCH net v2 8/8] mptcp: fix lockdep false positive in
 mptcp_pm_nl_create_listen_socket()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230227-upstream-net-20230227-mptcp-fixes-v2-8-47c2e95eada9@tessares.net>
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
        stable@vger.kernel.org, Christoph Paasch <cpaasch@apple.com>
X-Mailer: b4 0.12.1
X-Developer-Signature: v=1; a=openpgp-sha256; l=2460;
 i=matthieu.baerts@tessares.net; h=from:subject:message-id;
 bh=hqAM0Pg1CL8N6FLTp05rrsEa/m98vr/X4KK/h6eveNg=;
 b=owEBbQKS/ZANAwAIAfa3gk9CaaBzAcsmYgBkCfIhlczjyma02ViYKD6MJ5M1VuWVHNyx+4BGF
 d/hvmQ7fwqJAjMEAAEIAB0WIQToy4X3aHcFem4n93r2t4JPQmmgcwUCZAnyIQAKCRD2t4JPQmmg
 c31kEACurErU6ZCLhi48hHRrQ9GNdmdYCPgJTdZYIMLZ7iV3AAq4Z2knWKWnK7+hx2YiFszPJ/P
 hYvLL71GwNTWFGKHmnhR+aGBx1ZREpAS65kS8/p5vnBRiTwFI1q7LnFDDNa80czfsBCFpR0XXgf
 2fZjQRKIl/Dhw7FBdCZ2wezTqAPmGmQdRQxRtzofrlhdK2wpqerqMeqRPKLiggC3ftK7nsdcpG+
 uWC/9v4WamN0SsjGPdmbgnS5i8L+Fdcr03Ynfa+5YYRYcpaMjsCFMryP+J4+ku7OnUaKV8+W4/P
 G2odQbe8ZsjFUiWPwp5Af1f9Zjd4A1oNYxl+IiL1pm7oTFICdecr1YvLlG7/HmodFaU4JRsGj/y
 XiiJps3ZdQqQneTAeEKdI459qkvYklb+7HpOUR3y8Gsj3zQzvC76nR/W8iuvDa1BeKVWAWoSMp5
 Yy+IbUKK5ZMf7WFtnXoPBIkLfHjmi9XXRgA/o4o1/ADAE9aGzCs4aMxv6oxYHfzb33AT2cHb0SJ
 N7xXmEJujU/9pTGfCGukRGZxFehB5IPqNiRB+rqAB57yXmq7svmCpxp2uzHGAtgVRfNvjGRkIxT
 MusvZ77L+pYpvPpoTrOHS5RVypXW/W5l9cuyUFA+nPnYepl2BcEd5HQvPc1+U/TG85cWI/2t8SZ
 Y0EKjBYvBQ+BYkw==
X-Developer-Key: i=matthieu.baerts@tessares.net; a=openpgp;
 fpr=E8CB85F76877057A6E27F77AF6B7824F4269A073
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

Christoph reports a lockdep splat in the mptcp_subflow_create_socket()
error path, when such function is invoked by
mptcp_pm_nl_create_listen_socket().

Such code path acquires two separates, nested socket lock, with the
internal lock operation lacking the "nested" annotation. Adding that
in sock_release() for mptcp's sake only could be confusing.

Instead just add a new lockclass to the in-kernel msk socket,
re-initializing the lockdep infra after the socket creation.

Fixes: ad2171009d96 ("mptcp: fix locking for in-kernel listener creation")
Cc: stable@vger.kernel.org
Reported-by: Christoph Paasch <cpaasch@apple.com>
Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/354
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Tested-by: Christoph Paasch <cpaasch@apple.com>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
 net/mptcp/pm_netlink.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index 56628b52d100..5c8dea49626c 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -997,9 +997,13 @@ static int mptcp_pm_nl_append_new_local_addr(struct pm_nl_pernet *pernet,
 	return ret;
 }
 
+static struct lock_class_key mptcp_slock_keys[2];
+static struct lock_class_key mptcp_keys[2];
+
 static int mptcp_pm_nl_create_listen_socket(struct sock *sk,
 					    struct mptcp_pm_addr_entry *entry)
 {
+	bool is_ipv6 = sk->sk_family == AF_INET6;
 	int addrlen = sizeof(struct sockaddr_in);
 	struct sockaddr_storage addr;
 	struct socket *ssock;
@@ -1016,6 +1020,18 @@ static int mptcp_pm_nl_create_listen_socket(struct sock *sk,
 	if (!newsk)
 		return -EINVAL;
 
+	/* The subflow socket lock is acquired in a nested to the msk one
+	 * in several places, even by the TCP stack, and this msk is a kernel
+	 * socket: lockdep complains. Instead of propagating the _nested
+	 * modifiers in several places, re-init the lock class for the msk
+	 * socket to an mptcp specific one.
+	 */
+	sock_lock_init_class_and_name(newsk,
+				      is_ipv6 ? "mlock-AF_INET6" : "mlock-AF_INET",
+				      &mptcp_slock_keys[is_ipv6],
+				      is_ipv6 ? "msk_lock-AF_INET6" : "msk_lock-AF_INET",
+				      &mptcp_keys[is_ipv6]);
+
 	lock_sock(newsk);
 	ssock = __mptcp_nmpc_socket(mptcp_sk(newsk));
 	release_sock(newsk);

-- 
2.39.2

