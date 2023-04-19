Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91AE06E808A
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 19:45:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232633AbjDSRoj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 13:44:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232727AbjDSRoh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 13:44:37 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C32A72B4
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 10:44:33 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id ffacd0b85a97d-2efac435608so3171527f8f.3
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 10:44:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google; t=1681926271; x=1684518271;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9RbIwTqRb0BDbnwq8YaxJ333m+AcgTDfn8Ja+ySsZ+Q=;
        b=suVtm7MgYycUt3Fu5QA/59FP2JJaRuXf2BK9rn6LghytcioCuAsQFkuUW9VBzDJbEd
         lNI0Qv3RB4pAw72J+1UNm/9PtDOpay6XEXbcjO0t/hdiGOY4LHikTS2caNfv4zW00JK7
         V48Rv2ApL6wcDb7haKa/uYEB0k97ppGi8Byu/9zB4YtCCTtLQngt+B3A6YyYKCtioRD2
         SLnR6hpmQ76QmjZYHgOPabUWd0X1NONEGJVtXp0EJPTQmD75iwIzXchHwcdNXwEYv24X
         1vvl+p8QK3Avo70JGjdVK/NzUx8OCDQqG+bxKYw0m3vXawWCSzfQofZ3unIeIyXgTykW
         M+pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681926271; x=1684518271;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9RbIwTqRb0BDbnwq8YaxJ333m+AcgTDfn8Ja+ySsZ+Q=;
        b=kpDot5Momhk/e5Hy/PPj9gAQ/UuAxHm00M6dJeuvwKUtZWrpWILHZi9f4bTmkZbK1U
         Po/j/bG1COwnGZKtjviBOUvrqvf8ch3FHGGTLnh/5SLI842Da2TxHxmmK0X+3HqGQZ81
         +PBSnjcByZZf//wGRN9wXvv4oP8rqpz0By7MEtkAXemL0+IvwQPw7b5Te8BYBB2cW0Pb
         my5yJ12rbIHNQXAitZAHh/PQ1eN07ICnXDDB0NxhIt2VExBgo2ScEs6RfxQT93IEsJsb
         6U27E6ytwQiADtzAG+O/aljmNXbhDuZOCJaEYzCdpP6X1gtd/enxG439MtbHoLGfvu+Z
         c8Ig==
X-Gm-Message-State: AAQBX9e9zaCZ/I6fJqvrD9ATKxTi8W3rdnRrjg//Ey/4zqoC8eEz42O7
        mc3FhgBnp0Jv0SNUnz80uC+l5A==
X-Google-Smtp-Source: AKy350ZsBR/rG8NHy6xl33yYUblYRCRtrbFQZIKTbB2C9q68PjffYkmfWsDbBim4BfUCGaEc+2Fraw==
X-Received: by 2002:adf:e688:0:b0:2fb:f93f:b96 with SMTP id r8-20020adfe688000000b002fbf93f0b96mr5159967wrm.31.1681926271574;
        Wed, 19 Apr 2023 10:44:31 -0700 (PDT)
Received: from vdi08.nix.tessares.net (static.219.156.76.144.clients.your-server.de. [144.76.156.219])
        by smtp.gmail.com with ESMTPSA id o18-20020a5d4092000000b002fe87e0706bsm3027879wrp.97.2023.04.19.10.44.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 10:44:31 -0700 (PDT)
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Date:   Wed, 19 Apr 2023 19:44:04 +0200
Subject: [PATCH LSM 1/2] security, lsm: Introduce
 security_mptcp_add_subflow()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230419-upstream-lsm-next-20230419-mptcp-sublows-user-ctx-v1-1-9d4064cb0075@tessares.net>
References: <20230419-upstream-lsm-next-20230419-mptcp-sublows-user-ctx-v1-0-9d4064cb0075@tessares.net>
In-Reply-To: <20230419-upstream-lsm-next-20230419-mptcp-sublows-user-ctx-v1-0-9d4064cb0075@tessares.net>
To:     Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        Eric Paris <eparis@parisplace.org>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Ondrej Mosnacek <omosnace@redhat.com>, mptcp@lists.linux.dev,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        Matthieu Baerts <matthieu.baerts@tessares.net>
X-Mailer: b4 0.12.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=4147;
 i=matthieu.baerts@tessares.net; h=from:subject:message-id;
 bh=ImEO6jhjyTkNStj63VHfS9Fa8J/JaMOk/HAY9HrkSs8=;
 b=owEBbQKS/ZANAwAIAfa3gk9CaaBzAcsmYgBkQCh9B3Q/tK29huTRfn80vFL4Qelr+A0+fhoMw
 1w1X6DnbVGJAjMEAAEIAB0WIQToy4X3aHcFem4n93r2t4JPQmmgcwUCZEAofQAKCRD2t4JPQmmg
 c1ToD/4op14xnZbmNIFBWh1PT+MnRYeBRoLHSUX4MyRze6NzRUnFd3wdNDqBEq9+dorFoeg6ydC
 mpLldYd+FDZq1ngzAkg0ZvgVgFEA+WcpqjYk4iegbkQY+4xKW0cu8NY336bbR1ecvQ1m9k+OpvU
 sV72MtDizAw11irqLp0leoPgd1xuUyu/Adm9GZ8gcFv9RNWw61nNm5rmYM1TaLZesBySHyqLKEX
 XbC050oI2AOrlMroQx5OU0O/aIuyUWclATrS2q7EcgbD/paYmiXvSK4mn/AiFLBkBJsuo+t/kGD
 gQKiyZNqWSh+/jQ5KS4m1QsQAqUuRqbEbFjZZPZvEfK114xuKCwVdUNllin3QEm32JHTYWFeN4H
 A86k2I5H4pIcMIHBxMvRcIOo4jpoTyohVgvNWgetgcwH1KC4YtaN6s8iwNSXe9dVBcMyAiA9wjV
 ceY6wH1Mrsrbt/p/YrJec0hxpUuCH8oFZRHMaVV98N36SSLcfLUr6PpsFLIOww6531pJb52/fId
 DH1AE7jeDQ4EHkqiTZ1Gjs37/IkS1pFBGs9mTGjlloCcrAU0HpKvFSDDZfuog7F1lhrgkgwG6pQ
 UXhls5pgeB86jNIgGEPlK+hubj6LRu72BGpgTk6BCaTsa/3fCOiepTPi/iTzwfUl5tghbPZZwJb
 bmTxgWmL+QlF3Ug==
X-Developer-Key: i=matthieu.baerts@tessares.net; a=openpgp;
 fpr=E8CB85F76877057A6E27F77AF6B7824F4269A073
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

MPTCP can create subflows in kernel context, and later indirectly
expose them to user-space, via the owning mptcp socket.

As discussed in the reported link, the above causes unexpected failures
for server, MPTCP-enabled applications.

Let's introduce a new LSM hook to allow the security module to relabel
the subflow according to the owing process.

Note that the new hook requires both the mptcp socket and the new
subflow. This could allow future extensions, e.g. explicitly validating
the mptcp <-> subflow linkage.

Link: https://lore.kernel.org/mptcp/CAHC9VhTNh-YwiyTds=P1e3rixEDqbRTFj22bpya=+qJqfcaMfg@mail.gmail.com/
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Acked-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
 include/linux/lsm_hook_defs.h |  1 +
 include/linux/security.h      |  6 ++++++
 net/mptcp/subflow.c           |  6 ++++++
 security/security.c           | 15 +++++++++++++++
 4 files changed, 28 insertions(+)

diff --git a/include/linux/lsm_hook_defs.h b/include/linux/lsm_hook_defs.h
index 6bb55e61e8e8..7308a1a7599b 100644
--- a/include/linux/lsm_hook_defs.h
+++ b/include/linux/lsm_hook_defs.h
@@ -343,6 +343,7 @@ LSM_HOOK(void, LSM_RET_VOID, sctp_sk_clone, struct sctp_association *asoc,
 	 struct sock *sk, struct sock *newsk)
 LSM_HOOK(int, 0, sctp_assoc_established, struct sctp_association *asoc,
 	 struct sk_buff *skb)
+LSM_HOOK(int, 0, mptcp_add_subflow, struct sock *sk, struct sock *ssk)
 #endif /* CONFIG_SECURITY_NETWORK */
 
 #ifdef CONFIG_SECURITY_INFINIBAND
diff --git a/include/linux/security.h b/include/linux/security.h
index cd23221ce9e6..80a0b37a9f26 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -1465,6 +1465,7 @@ void security_sctp_sk_clone(struct sctp_association *asoc, struct sock *sk,
 			    struct sock *newsk);
 int security_sctp_assoc_established(struct sctp_association *asoc,
 				    struct sk_buff *skb);
+int security_mptcp_add_subflow(struct sock *sk, struct sock *ssk);
 
 #else	/* CONFIG_SECURITY_NETWORK */
 static inline int security_unix_stream_connect(struct sock *sock,
@@ -1692,6 +1693,11 @@ static inline int security_sctp_assoc_established(struct sctp_association *asoc,
 {
 	return 0;
 }
+
+static inline int security_mptcp_add_subflow(struct sock *sk, struct sock *ssk)
+{
+	return 0;
+}
 #endif	/* CONFIG_SECURITY_NETWORK */
 
 #ifdef CONFIG_SECURITY_INFINIBAND
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 4ae1a7304cf0..d361749cabff 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -1692,6 +1692,10 @@ int mptcp_subflow_create_socket(struct sock *sk, unsigned short family,
 
 	lock_sock_nested(sf->sk, SINGLE_DEPTH_NESTING);
 
+	err = security_mptcp_add_subflow(sk, sf->sk);
+	if (err)
+		goto release_ssk;
+
 	/* the newly created socket has to be in the same cgroup as its parent */
 	mptcp_attach_cgroup(sk, sf->sk);
 
@@ -1704,6 +1708,8 @@ int mptcp_subflow_create_socket(struct sock *sk, unsigned short family,
 	get_net_track(net, &sf->sk->ns_tracker, GFP_KERNEL);
 	sock_inuse_add(net, 1);
 	err = tcp_set_ulp(sf->sk, "mptcp");
+
+release_ssk:
 	release_sock(sf->sk);
 
 	if (err) {
diff --git a/security/security.c b/security/security.c
index f4170efcddda..24cf2644a4b9 100644
--- a/security/security.c
+++ b/security/security.c
@@ -4667,6 +4667,21 @@ int security_sctp_assoc_established(struct sctp_association *asoc,
 }
 EXPORT_SYMBOL(security_sctp_assoc_established);
 
+/**
+ * security_mptcp_add_subflow() - Inherit the LSM label from the MPTCP socket
+ * @sk: the owning MPTCP socket
+ * @ssk: the new subflow
+ *
+ * Update the labeling for the given MPTCP subflow, to match the one of the
+ * owning MPTCP socket.
+ *
+ * Return: Returns 0 on success or a negative error code on failure.
+ */
+int security_mptcp_add_subflow(struct sock *sk, struct sock *ssk)
+{
+	return call_int_hook(mptcp_add_subflow, 0, sk, ssk);
+}
+
 #endif	/* CONFIG_SECURITY_NETWORK */
 
 #ifdef CONFIG_SECURITY_INFINIBAND

-- 
2.39.2

