Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA8D56E9A77
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 19:17:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231319AbjDTRRi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 13:17:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231372AbjDTRRg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 13:17:36 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C093E5A
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 10:17:33 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id ffacd0b85a97d-2efbaad9d76so747179f8f.0
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 10:17:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google; t=1682011052; x=1684603052;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gRL8pGglolyXOkbwgIqaFgdKVP8NWg5fpDPt81rXDSg=;
        b=Qd44b6WuTGyA23YYZHTyxEunwHx23NDL5/Gy8s6XgnLpt/TJivBTZ9WJPsBh60sfRE
         87T/7ZF5jJTVwtbCqoFvd/o1ck8PAjPMrj8vobuAyDB5M9KnCkZd0wdClqp/dyDAcYje
         /2rvd16v9065+a4Nt3vjxt/q5ksxg2uxO1ygW2aLOkfzVKOeyfWX6BrWz0Wu6GU72hJd
         Yyp7oyuXjNFo0VjpIhVNWZN+VlbO365jwH8ssagb54L+8EKbUSawrhNXDRtuo1mwimQi
         c10c13tQCj9J0JSzUR7YwGMYNOqiDId5B4bXN9+RnrHjpq7uE93DOxB3CHRSiKhFfdNO
         48rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682011052; x=1684603052;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gRL8pGglolyXOkbwgIqaFgdKVP8NWg5fpDPt81rXDSg=;
        b=QcdZH4ZhKKZ7KtLfAOTroBkZawgsfZ3GF5inpKp9iqhXKaNR1FID3lLSOgaWKRfn9/
         FvxMrtbc2BJhcw0kN2lC7IJDqJXvHqSMxqSsbA0/2cLKvvpVbM35lA5D1GmfF/gHZEEG
         FTP/ZnPo1Omxm/EahR6dPVxa1RTHj/ngRn4ks+n2e7UpX9taKb+2Dj5gk7lf9QT2Wxzj
         KHTmmc8H168vZx+gS9nN9GbR4S8llKMhaGi9bMiWKCEN9UN8vfCnTsFrJQKZmGhdJ2JZ
         tx9EmC2bT7jqcerGFTO+4O4cmptWrKkL6hqOVdGuJQ6B+/OmjM6boU/YlTcGHA6JSEva
         43qQ==
X-Gm-Message-State: AAQBX9d1e+GJA2fGwrWbqe7bZdU2exEFIHkqIK3SGoMtMXWhAbiJ+zAe
        dwTX3mBPS/o4W2y1lZ1oI4ha1w==
X-Google-Smtp-Source: AKy350YqxKZQSVBQSjLNwWfqQXvKAzK9suraPc8Gs17wvHkW0+jS8p08g0RkZ0jdCwWbKX1opvbcug==
X-Received: by 2002:a5d:5189:0:b0:2ef:b977:ee3a with SMTP id k9-20020a5d5189000000b002efb977ee3amr1609430wrv.34.1682011051882;
        Thu, 20 Apr 2023 10:17:31 -0700 (PDT)
Received: from vdi08.nix.tessares.net (static.219.156.76.144.clients.your-server.de. [144.76.156.219])
        by smtp.gmail.com with ESMTPSA id h18-20020a5d6892000000b002f9bfac5baesm2450752wru.47.2023.04.20.10.17.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Apr 2023 10:17:31 -0700 (PDT)
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Date:   Thu, 20 Apr 2023 19:17:13 +0200
Subject: [PATCH LSM v2 1/2] security, lsm: Introduce
 security_mptcp_add_subflow()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230419-upstream-lsm-next-20230419-mptcp-sublows-user-ctx-v2-1-e7a3c8c15676@tessares.net>
References: <20230419-upstream-lsm-next-20230419-mptcp-sublows-user-ctx-v2-0-e7a3c8c15676@tessares.net>
In-Reply-To: <20230419-upstream-lsm-next-20230419-mptcp-sublows-user-ctx-v2-0-e7a3c8c15676@tessares.net>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=4586;
 i=matthieu.baerts@tessares.net; h=from:subject:message-id;
 bh=YJE7RC55Uv/u4jgySpwmLcvolb9ggSyqIvA9KWs2hPY=;
 b=owEBbQKS/ZANAwAIAfa3gk9CaaBzAcsmYgBkQXOp7ip5WUe4+9UBeLEGoybS3qxGZHNMF5IKh
 IoL0Pt1LsCJAjMEAAEIAB0WIQToy4X3aHcFem4n93r2t4JPQmmgcwUCZEFzqQAKCRD2t4JPQmmg
 czFzEADczukxdMa3dyKa0v13FXh0GHVYweaiV5/sTviV4z4RRTglSnhxXaVJe57XHUYZtobmTFk
 sHkIJbihJXg+KkP1CRhK+shxCfA6TS+9KqSM9b8UK8mg3XugFcfHC2VU5hc+avF/qORkGScaYxe
 pgpackfWj3pJe3abTQzAmQNnlMi4G6+h1nCvSrJ82MJddrHWWQ1wC2zGG0/BlmW1qqGWS7aVtCx
 Gb9UBT6UiHyGeOp1LnIpmXV0/eQwVZEnGzqa518frUpRAoyfEhUHQFrJCjuIC59kzdCaHnbVKJg
 /08j3iSL1OLqMqNw+Y7cJaFuwz5eTU7KR+Do3odS2jEIdDP5hMmqzhggipMiQO3NyEQ/aE50RGc
 Z/Y/q/ezAGwPr9mAW0PCdQvhU5SzIkeqDpv7sRWwF2BEJpEjATiCwQeWds5kK05MiirYVmt8329
 WSBso8vEMjcODRT6yWNXohD6QB80+4cYIjdhKc38T3kvUlLfA7w6Dw7hFlOquf5rk3FajUecnDC
 TnI+YZiMMG0/n7225SK+5D3xgCuXVeSsPx8McGlzSpJiw8ufr+RkvPGOZPgg3QUTBJ6UMSTSLTP
 c3cP2WoZjImjY6cEay6hoU2Smvq/U/KnTPbIovcH5+0VBRANbwwpceedOqI28Gat8oUeInRmoiu
 7RGJf7uXgY3scFA==
X-Developer-Key: i=matthieu.baerts@tessares.net; a=openpgp;
 fpr=E8CB85F76877057A6E27F77AF6B7824F4269A073
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

MPTCP can create subflows in kernel context, and later indirectly
expose them to user-space, via the owning MPTCP socket.

As discussed in the reported link, the above causes unexpected failures
for server, MPTCP-enabled applications.

Let's introduce a new LSM hook to allow the security module to relabel
the subflow according to the owning user-space process, via the MPTCP
socket owning the subflow.

Note that the new hook requires both the MPTCP socket and the new
subflow. This could allow future extensions, e.g. explicitly validating
the MPTCP <-> subflow linkage.

Link: https://lore.kernel.org/mptcp/CAHC9VhTNh-YwiyTds=P1e3rixEDqbRTFj22bpya=+qJqfcaMfg@mail.gmail.com/
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Acked-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
v2:
 - Address Paul's comments:
   - clarification around "the owning process" in the commit message
   - making it clear the hook has to be called after the sk init part
   - consistent capitalization of "MPTCP"
---
 include/linux/lsm_hook_defs.h |  1 +
 include/linux/security.h      |  6 ++++++
 net/mptcp/subflow.c           |  6 ++++++
 security/security.c           | 17 +++++++++++++++++
 4 files changed, 30 insertions(+)

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
index f4170efcddda..a12e44925942 100644
--- a/security/security.c
+++ b/security/security.c
@@ -4667,6 +4667,23 @@ int security_sctp_assoc_established(struct sctp_association *asoc,
 }
 EXPORT_SYMBOL(security_sctp_assoc_established);
 
+/**
+ * security_mptcp_add_subflow() - Inherit the LSM label from the MPTCP socket
+ * @sk: the owning MPTCP socket
+ * @ssk: the new subflow
+ *
+ * Update the labeling for the given MPTCP subflow, to match the one of the
+ * owning MPTCP socket. This hook has to be called after the socket creation and
+ * initialization via the security_socket_create() and
+ * security_socket_post_create() LSM hooks.
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

