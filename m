Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6E4D696242
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 12:20:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232139AbjBNLUH convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 14 Feb 2023 06:20:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231442AbjBNLUG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 06:20:06 -0500
Received: from us-smtp-delivery-44.mimecast.com (unknown [207.211.30.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 825E3BDEF
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 03:20:05 -0800 (PST)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-651-L-YJ208QNV6HWN_AQVUleA-1; Tue, 14 Feb 2023 06:19:46 -0500
X-MC-Unique: L-YJ208QNV6HWN_AQVUleA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2C5B2800B24;
        Tue, 14 Feb 2023 11:19:45 +0000 (UTC)
Received: from hog.localdomain (ovpn-195-113.brq.redhat.com [10.40.195.113])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D5B9A40C945A;
        Tue, 14 Feb 2023 11:19:42 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     Sabrina Dubroca <sd@queasysnail.net>,
        Vadim Fedorenko <vfedorenko@novek.ru>,
        Frantisek Krenzelok <fkrenzel@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Apoorv Kothari <apoorvko@amazon.com>,
        Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org,
        Gal Pressman <gal@nvidia.com>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH net-next v2 4/5] selftests: tls: add key_generation argument to tls_crypto_info_init
Date:   Tue, 14 Feb 2023 12:17:41 +0100
Message-Id: <798855c710dcbead2a9d32edb61a64cb0054fe60.1676052788.git.sd@queasysnail.net>
In-Reply-To: <cover.1676052788.git.sd@queasysnail.net>
References: <cover.1676052788.git.sd@queasysnail.net>
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

