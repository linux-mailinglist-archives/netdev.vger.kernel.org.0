Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3A616E808E
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 19:45:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233222AbjDSRon (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 13:44:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233173AbjDSRok (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 13:44:40 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49D8F7A81
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 10:44:34 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id 5b1f17b1804b1-3f1728c2a57so552025e9.0
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 10:44:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google; t=1681926273; x=1684518273;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ROUAJ3vebc3B58gonFIlZLfyJgCy1SquuVeVRDPgo4k=;
        b=rV1SY1HjqfZJWS95ixllED1SyOQI0mACYJ32SA6LKdtge1H/PSycfXoER6k3XdUuR/
         K3nM9X6KUTRx04ctCucbjxNvHDcesjAfCQMxwcAW8YbNOYkp8zLOHdAnAjPWfUDHfayd
         JGY8gduOocq1g+el6OYLsGZnf3WAAxRDecfE9i0dOjPJPEo8tbvC6eR24yuTju7IZSKD
         3aehtu4ijyGcOwRmPHv79DHEwf1jW+AB2xHRnzOMzBsyCKb2IdWqmIvhWV03ScMtIXDm
         pjVhOlKnEHciMSa36NihrFnbbMC/fASgJggdRQJ02QX5ZwfkfGlvq+7GPX0cEoiRTn0H
         e6pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681926273; x=1684518273;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ROUAJ3vebc3B58gonFIlZLfyJgCy1SquuVeVRDPgo4k=;
        b=hUe6NcDNiecs25kEOMR8RoYrcuiWdaAKta13pn30IgrSHHD2K2vJMywJs9PfD3L2vs
         00ox4I2RllMmNSkqYpaX2NK7NIElTQ6ylg31w7NJA+gdywR+69NlZHjwwFhHWpWU2y7r
         smQ3NroUwmohQS7qWXIRwhgshKnOspD9eU7hOG9vaNkwPv2rUQrIGH+hm3DJWiSRqAzI
         FlToKQVzIWuaSgZkpUi5eCJMz7GwPkIs0OAnD+Itd9+quR9ciDiaaGuMKBOvO+vABqi1
         +x6U5+1PnXHTHxjSGZqbn4t96qsty3MLX+HTbGc6545XTkA8vl7gEFrKGB65cNlqmj58
         il1w==
X-Gm-Message-State: AAQBX9cLr7SAAe93vPyDV07NnoQWgNUrGEa+c0SvGWliNa4je6WgOkbp
        Q5uIItkrLYigDkPJvCGrT/e2sw==
X-Google-Smtp-Source: AKy350b03Y5l3VuqIxjLj42ubMpzPeiZCCz96qX/fps7NotRYfqZdIH7jpaBCeK2CQIwst/c0gJ4Lw==
X-Received: by 2002:a05:6000:1c8:b0:2ff:4904:c377 with SMTP id t8-20020a05600001c800b002ff4904c377mr1806523wrx.25.1681926272692;
        Wed, 19 Apr 2023 10:44:32 -0700 (PDT)
Received: from vdi08.nix.tessares.net (static.219.156.76.144.clients.your-server.de. [144.76.156.219])
        by smtp.gmail.com with ESMTPSA id o18-20020a5d4092000000b002fe87e0706bsm3027879wrp.97.2023.04.19.10.44.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 10:44:32 -0700 (PDT)
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Date:   Wed, 19 Apr 2023 19:44:05 +0200
Subject: [PATCH LSM 2/2] selinux: Implement mptcp_add_subflow hook
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230419-upstream-lsm-next-20230419-mptcp-sublows-user-ctx-v1-2-9d4064cb0075@tessares.net>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2936;
 i=matthieu.baerts@tessares.net; h=from:subject:message-id;
 bh=mqr2BGqHqewUUPR1OCVjrPaTiiM4zt6T6l/x3JibBwM=;
 b=owEBbQKS/ZANAwAIAfa3gk9CaaBzAcsmYgBkQCh9Ojvp++qr8MSZ7mbE4nq4WiFrlXM05/A7K
 yVFNIdEH6iJAjMEAAEIAB0WIQToy4X3aHcFem4n93r2t4JPQmmgcwUCZEAofQAKCRD2t4JPQmmg
 c9LJD/4s7Mgv6rEvplVwimrhxteV4tT/cc+JAKks+NedETm2aWSdjhgSwxJaxoS4sdYz4HOu8x6
 wG+Gt3I6TOCxlYGI+2AGOpJ7dDN0XJO+hmOsIo7LY+el7LC64eSLZgSeq4kN3pKFT48zS5bdjjE
 fRMekhhhIp9+foseeTlMcY+Swdghpg2EphVcY4zJSNaJ3rxai900o8F5ey2MTO9VIW98pPhAQ+J
 aKUOSviER5SnJ+QlTvxXGdlHAr05NpOCv/NzFzpAhDuiEu8fXqO61br7PHDG2wF7CP0bOJ8X1cy
 uw9PcQhaqPMIo+rZx7QdD9xjPYndmrNS3XX3DmM2fnTkomvg0EJ+givdU8oiYgYY/Bx+0riSGBf
 k8WJUe23qyfvKoluqcO6KjsgmS7kVU2hYB9jGiGgEWb9FxryGSZMRLn9ysV+Lg0OtO8A0l1RBEx
 iuCin6uQxQMZsCtUDOsjteDr7lq+DcfgreakHSfRPqvPlcE/gurYM9LGtI9fltkryVy7f6kBHTB
 cURGSeQDof0R858t1Z5S0AKQ1vmLtHoBMIcKCwwcWlWiSL1xu3ptTFyiuXjNn+y6X0155MvM7WU
 EXer4DIlV5ZGy4vmWOWUbS2LHdlI+pPnpR6XB1P3SLhnaCaX3SLOVcxcDBzehO0Kg0IvI8/wnHt
 Iw+9Ay7f8DP3vdg==
X-Developer-Key: i=matthieu.baerts@tessares.net; a=openpgp;
 fpr=E8CB85F76877057A6E27F77AF6B7824F4269A073
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

Newly added subflows should inherit the LSM label from the associated
msk socket regarless current context.

This patch implements the above copying sid and class from the msk
context, deleting the existing subflow label, if any, and then
re-creating a new one.

The new helper reuses the selinux_netlbl_sk_security_free() function,
and the latter can end-up being called multiple times with the same
argument; we additionally need to make it idempotent.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Acked-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
 security/selinux/hooks.c    | 16 ++++++++++++++++
 security/selinux/netlabel.c |  8 ++++++--
 2 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 9a5bdfc21314..53cfc1cb67d2 100644
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
+	 * and re-recrating a new label using the current context
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

