Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDC3966DF3B
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 14:48:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230282AbjAQNsE convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 17 Jan 2023 08:48:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230099AbjAQNrn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 08:47:43 -0500
Received: from us-smtp-delivery-44.mimecast.com (unknown [207.211.30.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3DDA21A2E
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 05:47:41 -0800 (PST)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-357-9w1e4Z78MoWA_yRcXEbZPw-1; Tue, 17 Jan 2023 08:47:25 -0500
X-MC-Unique: 9w1e4Z78MoWA_yRcXEbZPw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 545B238145A1;
        Tue, 17 Jan 2023 13:47:25 +0000 (UTC)
Received: from hog.localdomain (unknown [10.39.192.162])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AB1D44085720;
        Tue, 17 Jan 2023 13:47:24 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     Frantisek Krenzelok <fkrenzel@redhat.com>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH net-next 4/5] selftests: tls: add key_generation argument to tls_crypto_info_init
Date:   Tue, 17 Jan 2023 14:45:30 +0100
Message-Id: <e6266c875cd43cb503f666c1234580beb9fa7b20.1673952268.git.sd@queasysnail.net>
In-Reply-To: <cover.1673952268.git.sd@queasysnail.net>
References: <cover.1673952268.git.sd@queasysnail.net>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=WINDOWS-1252; x-default=true
X-Spam-Status: No, score=-0.5 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_VALIDITY_RPBL,RDNS_NONE,SPF_HELO_NONE,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This allows us to generate different keys, so that we can test that
rekey is using the correct one.

Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
---
 tools/testing/selftests/net/tls.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/net/tls.c b/tools/testing/selftests/net/tls.c
index 2cbb12736596..5f3adb28fee1 100644
--- a/tools/testing/selftests/net/tls.c
+++ b/tools/testing/selftests/net/tls.c
@@ -38,9 +38,11 @@ struct tls_crypto_info_keys {
 };
 
 static void tls_crypto_info_init(uint16_t tls_version, uint16_t cipher_type,
-				 struct tls_crypto_info_keys *tls12)
+				 struct tls_crypto_info_keys *tls12,
+				 char key_generation)
 {
-	memset(tls12, 0, sizeof(*tls12));
+	memset(tls12, key_generation, sizeof(*tls12));
+	memset(tls12, 0, sizeof(struct tls_crypto_info));
 
 	switch (cipher_type) {
 	case TLS_CIPHER_CHACHA20_POLY1305:
@@ -312,7 +314,7 @@ FIXTURE_SETUP(tls)
 	int ret;
 
 	tls_crypto_info_init(variant->tls_version, variant->cipher_type,
-			     &tls12);
+			     &tls12, 0);
 
 	ulp_sock_pair(_metadata, &self->fd, &self->cfd, &self->notls);
 
@@ -1071,7 +1073,7 @@ TEST_F(tls, bidir)
 		struct tls_crypto_info_keys tls12;
 
 		tls_crypto_info_init(variant->tls_version, variant->cipher_type,
-				     &tls12);
+				     &tls12, 0);
 
 		ret = setsockopt(self->fd, SOL_TLS, TLS_RX, &tls12,
 				 tls12.len);
@@ -1479,7 +1481,7 @@ FIXTURE_SETUP(tls_err)
 	int ret;
 
 	tls_crypto_info_init(variant->tls_version, TLS_CIPHER_AES_GCM_128,
-			     &tls12);
+			     &tls12, 0);
 
 	ulp_sock_pair(_metadata, &self->fd, &self->cfd, &self->notls);
 	ulp_sock_pair(_metadata, &self->fd2, &self->cfd2, &self->notls);
@@ -1771,7 +1773,7 @@ TEST(tls_v6ops) {
 	int sfd, ret, fd;
 	socklen_t len, len2;
 
-	tls_crypto_info_init(TLS_1_2_VERSION, TLS_CIPHER_AES_GCM_128, &tls12);
+	tls_crypto_info_init(TLS_1_2_VERSION, TLS_CIPHER_AES_GCM_128, &tls12, 0);
 
 	addr.sin6_family = AF_INET6;
 	addr.sin6_addr = in6addr_any;
-- 
2.38.1

