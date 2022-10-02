Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 777575F21F1
	for <lists+netdev@lfdr.de>; Sun,  2 Oct 2022 10:17:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbiJBIR2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Oct 2022 04:17:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiJBIR1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Oct 2022 04:17:27 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B25F43F1E6
        for <netdev@vger.kernel.org>; Sun,  2 Oct 2022 01:17:25 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 97E792053B;
        Sun,  2 Oct 2022 10:17:23 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id hCGffe_jueCk; Sun,  2 Oct 2022 10:17:22 +0200 (CEST)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id EE6EA20519;
        Sun,  2 Oct 2022 10:17:22 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout2.secunet.com (Postfix) with ESMTP id DB4B1800050;
        Sun,  2 Oct 2022 10:17:22 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 2 Oct 2022 10:17:22 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Sun, 2 Oct
 2022 10:17:22 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id DCEB0318071E; Sun,  2 Oct 2022 10:17:21 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 01/24] selftests/net: Refactor xfrm_fill_key() to use array of structs
Date:   Sun, 2 Oct 2022 10:16:49 +0200
Message-ID: <20221002081712.757515-2-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221002081712.757515-1-steffen.klassert@secunet.com>
References: <20221002081712.757515-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Gautam Menghani <gautammenghani201@gmail.com>

A TODO in net/ipsec.c asks to refactor the code in xfrm_fill_key() to
use set/map to avoid manually comparing each algorithm with the "name"
parameter passed to the function as an argument. This patch refactors
the code to create an array of structs where each struct contains the
algorithm name and its corresponding key length.

Signed-off-by: Gautam Menghani <gautammenghani201@gmail.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 tools/testing/selftests/net/ipsec.c | 104 ++++++++++++----------------
 1 file changed, 45 insertions(+), 59 deletions(-)

diff --git a/tools/testing/selftests/net/ipsec.c b/tools/testing/selftests/net/ipsec.c
index cc10c10c5ed9..9a8229abfa02 100644
--- a/tools/testing/selftests/net/ipsec.c
+++ b/tools/testing/selftests/net/ipsec.c
@@ -58,6 +58,8 @@
 #define VETH_FMT	"ktst-%d"
 #define VETH_LEN	12
 
+#define XFRM_ALGO_NR_KEYS 29
+
 static int nsfd_parent	= -1;
 static int nsfd_childa	= -1;
 static int nsfd_childb	= -1;
@@ -75,6 +77,43 @@ const unsigned int ping_timeout		= 300;
 const unsigned int ping_count		= 100;
 const unsigned int ping_success		= 80;
 
+struct xfrm_key_entry {
+	char algo_name[35];
+	int key_len;
+};
+
+struct xfrm_key_entry xfrm_key_entries[] = {
+	{"digest_null", 0},
+	{"ecb(cipher_null)", 0},
+	{"cbc(des)", 64},
+	{"hmac(md5)", 128},
+	{"cmac(aes)", 128},
+	{"xcbc(aes)", 128},
+	{"cbc(cast5)", 128},
+	{"cbc(serpent)", 128},
+	{"hmac(sha1)", 160},
+	{"hmac(rmd160)", 160},
+	{"cbc(des3_ede)", 192},
+	{"hmac(sha256)", 256},
+	{"cbc(aes)", 256},
+	{"cbc(camellia)", 256},
+	{"cbc(twofish)", 256},
+	{"rfc3686(ctr(aes))", 288},
+	{"hmac(sha384)", 384},
+	{"cbc(blowfish)", 448},
+	{"hmac(sha512)", 512},
+	{"rfc4106(gcm(aes))-128", 160},
+	{"rfc4543(gcm(aes))-128", 160},
+	{"rfc4309(ccm(aes))-128", 152},
+	{"rfc4106(gcm(aes))-192", 224},
+	{"rfc4543(gcm(aes))-192", 224},
+	{"rfc4309(ccm(aes))-192", 216},
+	{"rfc4106(gcm(aes))-256", 288},
+	{"rfc4543(gcm(aes))-256", 288},
+	{"rfc4309(ccm(aes))-256", 280},
+	{"rfc7539(chacha20,poly1305)-128", 0}
+};
+
 static void randomize_buffer(void *buf, size_t buflen)
 {
 	int *p = (int *)buf;
@@ -767,65 +806,12 @@ static int do_ping(int cmd_fd, char *buf, size_t buf_len, struct in_addr from,
 static int xfrm_fill_key(char *name, char *buf,
 		size_t buf_len, unsigned int *key_len)
 {
-	/* TODO: use set/map instead */
-	if (strncmp(name, "digest_null", ALGO_LEN) == 0)
-		*key_len = 0;
-	else if (strncmp(name, "ecb(cipher_null)", ALGO_LEN) == 0)
-		*key_len = 0;
-	else if (strncmp(name, "cbc(des)", ALGO_LEN) == 0)
-		*key_len = 64;
-	else if (strncmp(name, "hmac(md5)", ALGO_LEN) == 0)
-		*key_len = 128;
-	else if (strncmp(name, "cmac(aes)", ALGO_LEN) == 0)
-		*key_len = 128;
-	else if (strncmp(name, "xcbc(aes)", ALGO_LEN) == 0)
-		*key_len = 128;
-	else if (strncmp(name, "cbc(cast5)", ALGO_LEN) == 0)
-		*key_len = 128;
-	else if (strncmp(name, "cbc(serpent)", ALGO_LEN) == 0)
-		*key_len = 128;
-	else if (strncmp(name, "hmac(sha1)", ALGO_LEN) == 0)
-		*key_len = 160;
-	else if (strncmp(name, "hmac(rmd160)", ALGO_LEN) == 0)
-		*key_len = 160;
-	else if (strncmp(name, "cbc(des3_ede)", ALGO_LEN) == 0)
-		*key_len = 192;
-	else if (strncmp(name, "hmac(sha256)", ALGO_LEN) == 0)
-		*key_len = 256;
-	else if (strncmp(name, "cbc(aes)", ALGO_LEN) == 0)
-		*key_len = 256;
-	else if (strncmp(name, "cbc(camellia)", ALGO_LEN) == 0)
-		*key_len = 256;
-	else if (strncmp(name, "cbc(twofish)", ALGO_LEN) == 0)
-		*key_len = 256;
-	else if (strncmp(name, "rfc3686(ctr(aes))", ALGO_LEN) == 0)
-		*key_len = 288;
-	else if (strncmp(name, "hmac(sha384)", ALGO_LEN) == 0)
-		*key_len = 384;
-	else if (strncmp(name, "cbc(blowfish)", ALGO_LEN) == 0)
-		*key_len = 448;
-	else if (strncmp(name, "hmac(sha512)", ALGO_LEN) == 0)
-		*key_len = 512;
-	else if (strncmp(name, "rfc4106(gcm(aes))-128", ALGO_LEN) == 0)
-		*key_len = 160;
-	else if (strncmp(name, "rfc4543(gcm(aes))-128", ALGO_LEN) == 0)
-		*key_len = 160;
-	else if (strncmp(name, "rfc4309(ccm(aes))-128", ALGO_LEN) == 0)
-		*key_len = 152;
-	else if (strncmp(name, "rfc4106(gcm(aes))-192", ALGO_LEN) == 0)
-		*key_len = 224;
-	else if (strncmp(name, "rfc4543(gcm(aes))-192", ALGO_LEN) == 0)
-		*key_len = 224;
-	else if (strncmp(name, "rfc4309(ccm(aes))-192", ALGO_LEN) == 0)
-		*key_len = 216;
-	else if (strncmp(name, "rfc4106(gcm(aes))-256", ALGO_LEN) == 0)
-		*key_len = 288;
-	else if (strncmp(name, "rfc4543(gcm(aes))-256", ALGO_LEN) == 0)
-		*key_len = 288;
-	else if (strncmp(name, "rfc4309(ccm(aes))-256", ALGO_LEN) == 0)
-		*key_len = 280;
-	else if (strncmp(name, "rfc7539(chacha20,poly1305)-128", ALGO_LEN) == 0)
-		*key_len = 0;
+	int i;
+
+	for (i = 0; i < XFRM_ALGO_NR_KEYS; i++) {
+		if (strncmp(name, xfrm_key_entries[i].algo_name, ALGO_LEN) == 0)
+			*key_len = xfrm_key_entries[i].key_len;
+	}
 
 	if (*key_len > buf_len) {
 		printk("Can't pack a key - too big for buffer");
-- 
2.25.1

