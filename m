Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAE8D66DF39
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 14:47:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230346AbjAQNrl convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 17 Jan 2023 08:47:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229876AbjAQNr2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 08:47:28 -0500
Received: from us-smtp-delivery-44.mimecast.com (us-smtp-delivery-44.mimecast.com [205.139.111.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D333D34C0B
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 05:47:26 -0800 (PST)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-632-JGSK0115Pnewh397dyyDeQ-1; Tue, 17 Jan 2023 08:47:23 -0500
X-MC-Unique: JGSK0115Pnewh397dyyDeQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 75B3F1C0A586;
        Tue, 17 Jan 2023 13:47:22 +0000 (UTC)
Received: from hog.localdomain (unknown [10.39.192.162])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C9DF84085720;
        Tue, 17 Jan 2023 13:47:21 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     Frantisek Krenzelok <fkrenzel@redhat.com>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH net-next 1/5] tls: remove tls_context argument from tls_set_sw_offload
Date:   Tue, 17 Jan 2023 14:45:27 +0100
Message-Id: <d42dbd07c7f7a9a2ec465fde1badf16a2304b996.1673952268.git.sd@queasysnail.net>
In-Reply-To: <cover.1673952268.git.sd@queasysnail.net>
References: <cover.1673952268.git.sd@queasysnail.net>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=WINDOWS-1252; x-default=true
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It's not really needed since we end up refetching it as tls_ctx. We
can also remove the NULL check, since we have already dereferenced ctx
in do_tls_setsockopt_conf.

Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Tested-by: Frantisek Krenzelok <fkrenzel@redhat.com>
---
 net/tls/tls.h        |  2 +-
 net/tls/tls_device.c |  2 +-
 net/tls/tls_main.c   |  4 ++--
 net/tls/tls_sw.c     | 11 +++--------
 4 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/net/tls/tls.h b/net/tls/tls.h
index 0e840a0c3437..34d0fe814600 100644
--- a/net/tls/tls.h
+++ b/net/tls/tls.h
@@ -90,7 +90,7 @@ int tls_sk_attach(struct sock *sk, int optname, char __user *optval,
 		  unsigned int optlen);
 void tls_err_abort(struct sock *sk, int err);
 
-int tls_set_sw_offload(struct sock *sk, struct tls_context *ctx, int tx);
+int tls_set_sw_offload(struct sock *sk, int tx);
 void tls_update_rx_zc_capable(struct tls_context *tls_ctx);
 void tls_sw_strparser_arm(struct sock *sk, struct tls_context *ctx);
 void tls_sw_strparser_done(struct tls_context *tls_ctx);
diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index 6c593788dc25..c149f36b42ee 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -1291,7 +1291,7 @@ int tls_set_device_offload_rx(struct sock *sk, struct tls_context *ctx)
 	context->resync_nh_reset = 1;
 
 	ctx->priv_ctx_rx = context;
-	rc = tls_set_sw_offload(sk, ctx, 0);
+	rc = tls_set_sw_offload(sk, 0);
 	if (rc)
 		goto release_ctx;
 
diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
index 3735cb00905d..fb1da1780f50 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -772,7 +772,7 @@ static int do_tls_setsockopt_conf(struct sock *sk, sockptr_t optval,
 			TLS_INC_STATS(sock_net(sk), LINUX_MIB_TLSTXDEVICE);
 			TLS_INC_STATS(sock_net(sk), LINUX_MIB_TLSCURRTXDEVICE);
 		} else {
-			rc = tls_set_sw_offload(sk, ctx, 1);
+			rc = tls_set_sw_offload(sk, 1);
 			if (rc)
 				goto err_crypto_info;
 			TLS_INC_STATS(sock_net(sk), LINUX_MIB_TLSTXSW);
@@ -786,7 +786,7 @@ static int do_tls_setsockopt_conf(struct sock *sk, sockptr_t optval,
 			TLS_INC_STATS(sock_net(sk), LINUX_MIB_TLSRXDEVICE);
 			TLS_INC_STATS(sock_net(sk), LINUX_MIB_TLSCURRRXDEVICE);
 		} else {
-			rc = tls_set_sw_offload(sk, ctx, 0);
+			rc = tls_set_sw_offload(sk, 0);
 			if (rc)
 				goto err_crypto_info;
 			TLS_INC_STATS(sock_net(sk), LINUX_MIB_TLSRXSW);
diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 9ed978634125..238562f9081b 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -2462,10 +2462,10 @@ void tls_update_rx_zc_capable(struct tls_context *tls_ctx)
 		tls_ctx->prot_info.version != TLS_1_3_VERSION;
 }
 
-int tls_set_sw_offload(struct sock *sk, struct tls_context *ctx, int tx)
+int tls_set_sw_offload(struct sock *sk, int tx)
 {
-	struct tls_context *tls_ctx = tls_get_ctx(sk);
-	struct tls_prot_info *prot = &tls_ctx->prot_info;
+	struct tls_context *ctx = tls_get_ctx(sk);
+	struct tls_prot_info *prot = &ctx->prot_info;
 	struct tls_crypto_info *crypto_info;
 	struct tls_sw_context_tx *sw_ctx_tx = NULL;
 	struct tls_sw_context_rx *sw_ctx_rx = NULL;
@@ -2477,11 +2477,6 @@ int tls_set_sw_offload(struct sock *sk, struct tls_context *ctx, int tx)
 	size_t keysize;
 	int rc = 0;
 
-	if (!ctx) {
-		rc = -EINVAL;
-		goto out;
-	}
-
 	if (tx) {
 		if (!ctx->priv_ctx_tx) {
 			sw_ctx_tx = kzalloc(sizeof(*sw_ctx_tx), GFP_KERNEL);
-- 
2.38.1

