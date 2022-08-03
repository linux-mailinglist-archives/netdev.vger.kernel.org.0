Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AA3B588606
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 05:24:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237561AbiHCDXv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 23:23:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237568AbiHCDXp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 23:23:45 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DD0551A05;
        Tue,  2 Aug 2022 20:23:40 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id b133so15334110pfb.6;
        Tue, 02 Aug 2022 20:23:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hQ/MHL3AvHE6awMttMKHegw9J9rY4eAGNJ5s9dewrd8=;
        b=CHPXie25jR2yWr9q5odc83pPNnA80K0CM8v9EuqtArCTlfixskGUqP5vwCjZClW/QS
         GfR6JSopZS+FH/bzKW/g2bL5z0clGf/22+e0F9Z2eQIb74nGjanx4AKahht+Ouu0OBs8
         dEpg+ur6KU8Zv4ZEbgF5JBzpT5hQSWG5GI4aNsCzR3R3D8As8ne+iLXa7mFAWZVgvsAJ
         wqfm3DWlOnODenQn0n0wb/6L3PtnZ3UlOwLj8XXo8VEpl4x1sG30qi+POOPaD63ADxlO
         pXzI5WrL1kXH41AkH6Hq+k2ych93SEJr9RlfaUy8OwlODbzsOImZKh415RlHhdYM0Fpi
         Yvdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hQ/MHL3AvHE6awMttMKHegw9J9rY4eAGNJ5s9dewrd8=;
        b=Yvj0SDBoRKXLXFHyzEP43d15g25MrMqrMPCwad12Fu4qUtF7c+BgKVqV/d1QzY6z48
         kK+owOrrYpbMfwVe/gdGMGT3b1kEuRFCbrPuRwhlHJXtn8oybRNZRGF6IY3q1nFuLLnw
         VwnljDNqYrxBlEobFCi4rKdjG+fCLxwX0EZIrMLyOxiJxAXJDQwJbB4cRnVdqilkwq8l
         kHblXFdpYr5KDVcBc759KHPyHXWdzQjVbqKgZDFeKYm325V+fEiI+7ufwGIplT4MthjC
         iGVVGpiGPc6u8ZLjcUfPRWoNpGQa7tYwec/ZNawn4rryB8qXild8VM5po9yN57st14YO
         gdow==
X-Gm-Message-State: AJIora9/5LHZ8+uYLnFiC0G/1fA1HzgPLX/24wNhkQdQW720acjxoJF1
        QZ/mmUr/6LppxfIg1fYRSn0=
X-Google-Smtp-Source: AGRyM1sCSz0Ss42sowkoQjXeEl16MwPxdyBbyTUiA1CDxjKiO/EnKpC5aN4upe+iDII6riEw+RVOMw==
X-Received: by 2002:a63:f502:0:b0:415:ee58:b22b with SMTP id w2-20020a63f502000000b00415ee58b22bmr19076904pgh.349.1659497019088;
        Tue, 02 Aug 2022 20:23:39 -0700 (PDT)
Received: from biggie.. ([103.230.148.189])
        by smtp.gmail.com with ESMTPSA id b9-20020a170902d50900b0016dbdf7b97bsm458620plg.266.2022.08.02.20.23.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Aug 2022 20:23:38 -0700 (PDT)
From:   Gautam Menghani <gautammenghani201@gmail.com>
To:     steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, shuah@kernel.org
Cc:     Gautam Menghani <gautammenghani201@gmail.com>,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org
Subject: [PATCH v2] selftests/net: Refactor xfrm_fill_key() to use array of structs
Date:   Wed,  3 Aug 2022 08:53:12 +0530
Message-Id: <20220803032312.3939-1-gautammenghani201@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A TODO in net/ipsec.c asks to refactor the code in xfrm_fill_key() to
use set/map to avoid manually comparing each algorithm with the "name" 
parameter passed to the function as an argument. This patch refactors 
the code to create an array of structs where each struct contains the 
algorithm name and its corresponding key length.

Signed-off-by: Gautam Menghani <gautammenghani201@gmail.com>
---
changes in v2:
1. Fix the compilation warnings for struct and variable declaration

 tools/testing/selftests/net/ipsec.c | 108 +++++++++++++---------------
 1 file changed, 49 insertions(+), 59 deletions(-)

diff --git a/tools/testing/selftests/net/ipsec.c b/tools/testing/selftests/net/ipsec.c
index cc10c10c5ed9..4a0eeb5b71d2 100644
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
@@ -75,6 +77,46 @@ const unsigned int ping_timeout		= 300;
 const unsigned int ping_count		= 100;
 const unsigned int ping_success		= 80;
 
+struct xfrm_key_entry {
+	char algo_name[35];
+	int key_len;
+};
+
+struct xfrm_key_entry xfrm_key_entries[XFRM_ALGO_NR_KEYS];
+
+static void init_xfrm_algo_keys(void)
+{
+	xfrm_key_entries[0] = (struct xfrm_key_entry) {"digest_null", 0};
+	xfrm_key_entries[1] = (struct xfrm_key_entry) {"ecb(cipher_null)", 0};
+	xfrm_key_entries[2] = (struct xfrm_key_entry) {"cbc(des)", 64};
+	xfrm_key_entries[3] = (struct xfrm_key_entry) {"hmac(md5)", 128};
+	xfrm_key_entries[4] = (struct xfrm_key_entry) {"cmac(aes)", 128};
+	xfrm_key_entries[5] = (struct xfrm_key_entry) {"xcbc(aes)", 128};
+	xfrm_key_entries[6] = (struct xfrm_key_entry) {"cbc(cast5)", 128};
+	xfrm_key_entries[7] = (struct xfrm_key_entry) {"cbc(serpent)", 128};
+	xfrm_key_entries[8] = (struct xfrm_key_entry) {"hmac(sha1)", 160};
+	xfrm_key_entries[9] = (struct xfrm_key_entry) {"hmac(rmd160)", 160};
+	xfrm_key_entries[10] = (struct xfrm_key_entry) {"cbc(des3_ede)", 192};
+	xfrm_key_entries[11] = (struct xfrm_key_entry) {"hmac(sha256)", 256};
+	xfrm_key_entries[12] = (struct xfrm_key_entry) {"cbc(aes)", 256};
+	xfrm_key_entries[13] = (struct xfrm_key_entry) {"cbc(camellia)", 256};
+	xfrm_key_entries[14] = (struct xfrm_key_entry) {"cbc(twofish)", 256};
+	xfrm_key_entries[15] = (struct xfrm_key_entry) {"rfc3686(ctr(aes))", 288};
+	xfrm_key_entries[16] = (struct xfrm_key_entry) {"hmac(sha384)", 384};
+	xfrm_key_entries[17] = (struct xfrm_key_entry) {"cbc(blowfish)", 448};
+	xfrm_key_entries[18] = (struct xfrm_key_entry) {"hmac(sha512)", 512};
+	xfrm_key_entries[19] = (struct xfrm_key_entry) {"rfc4106(gcm(aes))-128", 160};
+	xfrm_key_entries[20] = (struct xfrm_key_entry) {"rfc4543(gcm(aes))-128", 160};
+	xfrm_key_entries[21] = (struct xfrm_key_entry) {"rfc4309(ccm(aes))-128", 152};
+	xfrm_key_entries[22] = (struct xfrm_key_entry) {"rfc4106(gcm(aes))-192", 224};
+	xfrm_key_entries[23] = (struct xfrm_key_entry) {"rfc4543(gcm(aes))-192", 224};
+	xfrm_key_entries[24] = (struct xfrm_key_entry) {"rfc4309(ccm(aes))-192", 216};
+	xfrm_key_entries[25] = (struct xfrm_key_entry) {"rfc4106(gcm(aes))-256", 288};
+	xfrm_key_entries[26] = (struct xfrm_key_entry) {"rfc4543(gcm(aes))-256", 288};
+	xfrm_key_entries[27] = (struct xfrm_key_entry) {"rfc4309(ccm(aes))-256", 280};
+	xfrm_key_entries[28] = (struct xfrm_key_entry) {"rfc7539(chacha20,poly1305)-128", 0};
+}
+
 static void randomize_buffer(void *buf, size_t buflen)
 {
 	int *p = (int *)buf;
@@ -767,65 +809,12 @@ static int do_ping(int cmd_fd, char *buf, size_t buf_len, struct in_addr from,
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
@@ -2305,6 +2294,7 @@ int main(int argc, char **argv)
 		}
 	}
 
+	init_xfrm_algo_keys();
 	srand(time(NULL));
 	page_size = sysconf(_SC_PAGESIZE);
 	if (page_size < 1)
-- 
2.34.1

