Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1186C586010
	for <lists+netdev@lfdr.de>; Sun, 31 Jul 2022 19:03:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237392AbiGaRDb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jul 2022 13:03:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229879AbiGaRDa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jul 2022 13:03:30 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DC7CAE66;
        Sun, 31 Jul 2022 10:03:29 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id w7so8493160ply.12;
        Sun, 31 Jul 2022 10:03:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fzm9FXVK1++mZC5DB3xf/VNAMRJCgD5SmSkZkONamI0=;
        b=aD4/ICKma9H8QGUrQNpPLRVjC7JOnDZvzrZC711tHOJMI0j6ULUnb4avuLqcZVJjiW
         RXjeo7h1MUi1cnRBVfLLE6CqrgHSUP9NIa3ZsbIRLnHGBPgO4wnj0IzHvOd+iPWsd4hp
         cz4jC4j3CbHjJrTP9sdRD+xSvDwGS7RJEV+DxRO68kFY5xdURGfv0to3k6F4w4EtrgGB
         EJqhubxy9DF0KRzW03aZnEfNxib7JCRHRMb1ZIKncFrU9V56uSULZchCGksx8/V5zBap
         uRpsr3HgojQXXEqtl6Cs3nngyp6MOm7OvQr5F55PX1bvSoHwF80vLS5S/eGfBz0Oofpk
         jpfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fzm9FXVK1++mZC5DB3xf/VNAMRJCgD5SmSkZkONamI0=;
        b=CZhY19Nd7bAK4PIJCMNfaBwonu8gz9OCVMTtzEP/Xbty2JuX0Ke0D7y6G7YnCMBOgV
         pqfJEcTOMYkC6Jb3IxudqD6jJ+2LYAY2G4kSHZ6nzawTKWIZT+x1hmYNHMOrgrwNoYTO
         eQ0WnIBBElWkQ3OMSGMS94E19kymDnEdpgiUpWSn4KgI95ximoMPY6gqY4ItfigzeHTE
         0+C9hTgaTtbaP32va22rP5Amy0SJ/bwAEQaFYAzIeUEZh5YAGVlF8Eo6riPsyvZ/3f2O
         BRi6NCqrzmhQ6+5dvm9HuEY6IpWOkGacGDMHqqZSgOXDsGqjcnWrCPeYyyFIk6R3LH0a
         csmw==
X-Gm-Message-State: ACgBeo1A+6PYzZzhwgAn5C7HkaJlbc0wziy/ydeI1kYFeFMnJ6HwpyVZ
        zfy1GOI6wzdEMfF++5k0oHs=
X-Google-Smtp-Source: AA6agR6ozNq7hqX3YWd831P1TBQPEOX1taSgzIAWgLLhtINpn05+TgL/DsK5AN7Evp1hd6lyV+IkwA==
X-Received: by 2002:a17:90a:fe10:b0:1f3:1de7:fe1b with SMTP id ck16-20020a17090afe1000b001f31de7fe1bmr15093843pjb.189.1659287008532;
        Sun, 31 Jul 2022 10:03:28 -0700 (PDT)
Received: from biggie.. ([103.230.148.186])
        by smtp.gmail.com with ESMTPSA id u5-20020a17090a4bc500b001ef7c7564fdsm9696745pjl.21.2022.07.31.10.03.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Jul 2022 10:03:28 -0700 (PDT)
From:   Gautam Menghani <gautammenghani201@gmail.com>
To:     steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, shuah@kernel.org
Cc:     Gautam Menghani <gautammenghani201@gmail.com>,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org
Subject: [PATCH] selftests/net: Refactor xfrm_fill_key() to use array of structs
Date:   Sun, 31 Jul 2022 22:33:16 +0530
Message-Id: <20220731170316.71542-1-gautammenghani201@gmail.com>
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
 tools/testing/selftests/net/ipsec.c | 108 +++++++++++++---------------
 1 file changed, 49 insertions(+), 59 deletions(-)

diff --git a/tools/testing/selftests/net/ipsec.c b/tools/testing/selftests/net/ipsec.c
index cc10c10c5ed9..82d3f9256b84 100644
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
 
+static struct xfrm_key_entry {
+	char algo_name[35];
+	int key_len;
+};
+
+static struct xfrm_key_entry xfrm_key_entries[XFRM_ALGO_NR_KEYS];
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
+	int i = 0;
+
+	for (int i = 0; i < XFRM_ALGO_NR_KEYS; i++) {
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

