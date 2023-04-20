Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82C436E9A7D
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 19:18:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231366AbjDTRR4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 13:17:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231395AbjDTRRh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 13:17:37 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF1503AA6
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 10:17:34 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id 5b1f17b1804b1-3f17fdb520dso8527045e9.3
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 10:17:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google; t=1682011053; x=1684603053;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+nrvmT5OFHwrUqAXKS0/0TYRQBrcHO6JC66d8fanswI=;
        b=j6tO4jp0xdrqmgQ1bZh0uIYvt+VU7nmbselWXWzhCAG2keXa2wYyDXA833zsdXXGYm
         uM43dk+2T7psZL6i3mzw7/RqjSnaZ7Mn/TVT/OccjDcbrWg9DUmS6QdLcDZiHSm+vpw6
         PqBRRoRHiL9K4sVOoszbD0jj/js0/K/xR8xmWyLBfqGcVbpiiWP4tzKkScIeNh9XDCEh
         b/CNb7KZOj2x0jlDmdCVW9YaLcjGn7TLlo1cODhUADXSM/U0Cf+CSxl82YcsEMKt9MAr
         W4a37xXtmIA3uQz7rPKx/P2Nwu/rYaZ7e5paqNIMoKpcYnDn8/A/qpFphzghANYIolQb
         ShUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682011053; x=1684603053;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+nrvmT5OFHwrUqAXKS0/0TYRQBrcHO6JC66d8fanswI=;
        b=Gmt3bgippW/LzSwaxCRA/8/loUoyGYlI79U2GhV4MFW7gKux7jDfAm9W292zD7Oxd1
         GNCS1983SUs9hFTjWLRmLFUJkVepyrDC8nBLWFyEw6mzU29t3NHKzJ641j9KlkXBVcxr
         g73FDllz/X6JMeXYb3HQjNe5913d8WBYuOhlwZ2gm7/rpnhAeC9o3mUS9lwP/iKj5HH+
         iqgd9bFWi1c5XJZ0RgIJDvvp8UZRRJ1DNiXVhCRCQCWCIxgv9WEVP6TM9GMMzi7e/9pu
         QxZYAQwnsnFnVzIgQKhWrM0hCOqWUl3AlJcTWdDcsj/EgSScuMEDNW1X5PyHseuHXEpZ
         rEXQ==
X-Gm-Message-State: AAQBX9fv0dQ1g9qpJCG9PEiP8ndYre3iMGaburFv7kj5iYA89an6pDVX
        cZaC1dqHkZydj9SQZq5x3OqXxg==
X-Google-Smtp-Source: AKy350YDPqDs+oNhq4+CzO2Ado1avKObxaMZvo+mr7qJp0MQdpGCb5Af8m8SdwPIdw95c0kV5psKeQ==
X-Received: by 2002:adf:f88a:0:b0:2f2:79ce:4836 with SMTP id u10-20020adff88a000000b002f279ce4836mr2114862wrp.60.1682011053092;
        Thu, 20 Apr 2023 10:17:33 -0700 (PDT)
Received: from vdi08.nix.tessares.net (static.219.156.76.144.clients.your-server.de. [144.76.156.219])
        by smtp.gmail.com with ESMTPSA id h18-20020a5d6892000000b002f9bfac5baesm2450752wru.47.2023.04.20.10.17.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Apr 2023 10:17:32 -0700 (PDT)
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Date:   Thu, 20 Apr 2023 19:17:14 +0200
Subject: [PATCH LSM v2 2/2] selinux: Implement mptcp_add_subflow hook
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230419-upstream-lsm-next-20230419-mptcp-sublows-user-ctx-v2-2-e7a3c8c15676@tessares.net>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3129;
 i=matthieu.baerts@tessares.net; h=from:subject:message-id;
 bh=WLhdu7VM8rRQHFyxZs5IsD7KrHV+7/B+Pjyz5LAXc28=;
 b=owEBbQKS/ZANAwAIAfa3gk9CaaBzAcsmYgBkQXOpmi1k2/KgRY8NOtTX9iCZ7MkaYNHhEgOGn
 ii8nlJrcKCJAjMEAAEIAB0WIQToy4X3aHcFem4n93r2t4JPQmmgcwUCZEFzqQAKCRD2t4JPQmmg
 czKpEADSd17bfsUVbQ+uwJhsBgw8gyj6F3CtxsSF5KcOpGnw3lyvx9DHDX3ZY0GpnEx6uEm8Hc3
 TNVAFrZsnmASC8q2zSQmdzynSgXyktDuWkGJvFyQupfT4LRGVgiSj7/j/d2l3X9xfjhRwROizxA
 KZ7ptNIATPin22KviVmh9csEgsLTEgHmazsEI88uXKHTiKYQik0xYGxhJSM+FnDF3MaPSKP5oIV
 dXtzacqLcPJvvLRnMXxmoYW/XtTSOB3S7cnknl/gP4Bzl4k6AsZsvyZJpQLBYIbY3kyK9CxKO/U
 trvZGfaJMCgOyAeLjJIoF1tPjwG92qQIG78maTIRG4G2WF1iVufCf0zPR/lpnNPYhbVtUS+a8Q7
 Pb1xpbh3+bJ4pJ2pMImtO6S+YClntJq2rgxJ23gnQXiRzJhUHUdPwZINwkbYBBN+dNcTvXmu752
 6hp81pkoLZ9RP7vFt0I3fCH31NiTBsr3l8NOhpLlqXIQqpQIquubMPFVaIgvWlXLsANN4E1kLE5
 oRHd4w+ASJI9zkmMdhEbkmpptsmHNiCScdbWgePbEhV8ObL7Zh2IbDsx0Rd1YIKbZaZ3SPcB5kd
 CFve8+sUXHE394KCAMiiMogopfITRpL7JyGtny7xhDB/nU65Q/3IvEw8VhbGGLtBCxr4XAa/KWN
 YgTynBW3b4sRIgg==
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

Newly added subflows should inherit the LSM label from the associated
MPTCP socket regardless of the current context.

This patch implements the above copying sid and class from the MPTCP
socket context, deleting the existing subflow label, if any, and then
re-creating the correct one.

The new helper reuses the selinux_netlbl_sk_security_free() function,
and the latter can end-up being called multiple times with the same
argument; we additionally need to make it idempotent.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Acked-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
v2:
 - Address Paul's comments:
   - use "MPTCP socket" instead of "msk" in the commit message
   - "updated" context instead of "current" one in the comment
---
 security/selinux/hooks.c    | 16 ++++++++++++++++
 security/selinux/netlabel.c |  8 ++++++--
 2 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 9a5bdfc21314..67e6cd18ad59 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -5476,6 +5476,21 @@ static void selinux_sctp_sk_clone(struct sctp_association *asoc, struct sock *sk
 	selinux_netlbl_sctp_sk_clone(sk, newsk);
 }
 
+static int selinux_mptcp_add_subflow(struct sock *sk, struct sock *ssk)
+{
+	struct sk_security_struct *ssksec = ssk->sk_security;
+	struct sk_security_struct *sksec = sk->sk_security;
+
+	ssksec->sclass = sksec->sclass;
+	ssksec->sid = sksec->sid;
+
+	/* replace the existing subflow label deleting the existing one
+	 * and re-recreating a new label using the updated context
+	 */
+	selinux_netlbl_sk_security_free(ssksec);
+	return selinux_netlbl_socket_post_create(ssk, ssk->sk_family);
+}
+
 static int selinux_inet_conn_request(const struct sock *sk, struct sk_buff *skb,
 				     struct request_sock *req)
 {
@@ -7216,6 +7231,7 @@ static struct security_hook_list selinux_hooks[] __lsm_ro_after_init = {
 	LSM_HOOK_INIT(sctp_sk_clone, selinux_sctp_sk_clone),
 	LSM_HOOK_INIT(sctp_bind_connect, selinux_sctp_bind_connect),
 	LSM_HOOK_INIT(sctp_assoc_established, selinux_sctp_assoc_established),
+	LSM_HOOK_INIT(mptcp_add_subflow, selinux_mptcp_add_subflow),
 	LSM_HOOK_INIT(inet_conn_request, selinux_inet_conn_request),
 	LSM_HOOK_INIT(inet_csk_clone, selinux_inet_csk_clone),
 	LSM_HOOK_INIT(inet_conn_established, selinux_inet_conn_established),
diff --git a/security/selinux/netlabel.c b/security/selinux/netlabel.c
index 1321f15799e2..33187e38def7 100644
--- a/security/selinux/netlabel.c
+++ b/security/selinux/netlabel.c
@@ -155,8 +155,12 @@ void selinux_netlbl_err(struct sk_buff *skb, u16 family, int error, int gateway)
  */
 void selinux_netlbl_sk_security_free(struct sk_security_struct *sksec)
 {
-	if (sksec->nlbl_secattr != NULL)
-		netlbl_secattr_free(sksec->nlbl_secattr);
+	if (!sksec->nlbl_secattr)
+		return;
+
+	netlbl_secattr_free(sksec->nlbl_secattr);
+	sksec->nlbl_secattr = NULL;
+	sksec->nlbl_state = NLBL_UNSET;
 }
 
 /**

-- 
2.39.2

