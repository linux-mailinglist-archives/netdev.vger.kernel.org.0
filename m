Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCE1E4DB8C3
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 20:22:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357992AbiCPTWD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 15:22:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357917AbiCPTVq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 15:21:46 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CC376A00C;
        Wed, 16 Mar 2022 12:20:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=mAEBdlB3OIVWW6VHbg2SecqMSqz6buQ0aUi+Rw762/Y=; b=QU8xTqKmgiaf0d2RYK0H55UDCG
        aLJvbEgjnyUe31XqnajbeerGSgezvbj7E6vzKNEkthY9gGqTCGwCgSKs/P6N/RAY4zpEqVLmXvKbP
        uiSRzPcbdU7p3lSpluXCtlaLUMBZuaHvqoH09vYAF9WublfayTlpUU/qLQX/IDYXeABeZH5o+zC2W
        8kZMfKNRXr6lT1/BQuMttKB9AK/4vNhr0ZbmY9ozWZm9W0S5VvcJ8UryNdPz0mWnabak/ruaUP3LR
        RSlCpaIl4OEVlR7bIZCUxDmvaJ/Q+Xkkx2o2F4c2Wa2eoa9/E3ikl20nvmBdUIbACnjGJJLK415O7
        7YK7glNg==;
Received: from [2601:1c0:6280:3f0::aa0b] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nUZCA-00EArp-3R; Wed, 16 Mar 2022 19:20:30 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     linux-kernel@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, Amit Shah <amit@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Eli Cohen <eli@mellanox.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Felipe Balbi <felipe.balbi@linux.intel.com>,
        =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Krzysztof Opasiak <k.opasiak@samsung.com>,
        Igor Kotrasinski <i.kotrasinsk@samsung.com>,
        Valentina Manea <valentina.manea.m@gmail.com>,
        Shuah Khan <shuah@kernel.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
        Joachim Fritschi <jfritschi@freenet.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@kernel.org>,
        Karol Herbst <karolherbst@gmail.com>,
        Pekka Paalanen <ppaalanen@gmail.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-block@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-usb@vger.kernel.org, nouveau@lists.freedesktop.org,
        virtualization@lists.linux-foundation.org, x86@kernel.org
Subject: [PATCH 8/9] x86/crypto: eliminate anonymous module_init & module_exit
Date:   Wed, 16 Mar 2022 12:20:09 -0700
Message-Id: <20220316192010.19001-9-rdunlap@infradead.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220316192010.19001-1-rdunlap@infradead.org>
References: <20220316192010.19001-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eliminate anonymous module_init() and module_exit(), which can lead to
confusion or ambiguity when reading System.map, crashes/oops/bugs,
or an initcall_debug log.

Give each of these init and exit functions unique driver-specific
names to eliminate the anonymous names.

Example 1: (System.map)
 ffffffff832fc78c t init
 ffffffff832fc79e t init
 ffffffff832fc8f8 t init

Example 2: (initcall_debug log)
 calling  init+0x0/0x12 @ 1
 initcall init+0x0/0x12 returned 0 after 15 usecs
 calling  init+0x0/0x60 @ 1
 initcall init+0x0/0x60 returned 0 after 2 usecs
 calling  init+0x0/0x9a @ 1
 initcall init+0x0/0x9a returned 0 after 74 usecs

Fixes: 64b94ceae8c1 ("crypto: blowfish - add x86_64 assembly implementation")
Fixes: 676a38046f4f ("crypto: camellia-x86_64 - module init/exit functions should be static")
Fixes: 0b95ec56ae19 ("crypto: camellia - add assembler implementation for x86_64")
Fixes: 56d76c96a9f3 ("crypto: serpent - add AVX2/x86_64 assembler implementation of serpent cipher")
Fixes: b9f535ffe38f ("[CRYPTO] twofish: i586 assembly version")
Fixes: ff0a70fe0536 ("crypto: twofish-x86_64-3way - module init/exit functions should be static")
Fixes: 8280daad436e ("crypto: twofish - add 3-way parallel x86_64 assembler implemention")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: Joachim Fritschi <jfritschi@freenet.de>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org
Cc: x86@kernel.org
---
 arch/x86/crypto/blowfish_glue.c     |    8 ++++----
 arch/x86/crypto/camellia_glue.c     |    8 ++++----
 arch/x86/crypto/serpent_avx2_glue.c |    8 ++++----
 arch/x86/crypto/twofish_glue.c      |    8 ++++----
 arch/x86/crypto/twofish_glue_3way.c |    8 ++++----
 5 files changed, 20 insertions(+), 20 deletions(-)

--- lnx-517-rc8.orig/arch/x86/crypto/blowfish_glue.c
+++ lnx-517-rc8/arch/x86/crypto/blowfish_glue.c
@@ -315,7 +315,7 @@ static int force;
 module_param(force, int, 0);
 MODULE_PARM_DESC(force, "Force module load, ignore CPU blacklist");
 
-static int __init init(void)
+static int __init blowfish_init(void)
 {
 	int err;
 
@@ -339,15 +339,15 @@ static int __init init(void)
 	return err;
 }
 
-static void __exit fini(void)
+static void __exit blowfish_fini(void)
 {
 	crypto_unregister_alg(&bf_cipher_alg);
 	crypto_unregister_skciphers(bf_skcipher_algs,
 				    ARRAY_SIZE(bf_skcipher_algs));
 }
 
-module_init(init);
-module_exit(fini);
+module_init(blowfish_init);
+module_exit(blowfish_fini);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Blowfish Cipher Algorithm, asm optimized");
--- lnx-517-rc8.orig/arch/x86/crypto/camellia_glue.c
+++ lnx-517-rc8/arch/x86/crypto/camellia_glue.c
@@ -1377,7 +1377,7 @@ static int force;
 module_param(force, int, 0);
 MODULE_PARM_DESC(force, "Force module load, ignore CPU blacklist");
 
-static int __init init(void)
+static int __init camellia_init(void)
 {
 	int err;
 
@@ -1401,15 +1401,15 @@ static int __init init(void)
 	return err;
 }
 
-static void __exit fini(void)
+static void __exit camellia_fini(void)
 {
 	crypto_unregister_alg(&camellia_cipher_alg);
 	crypto_unregister_skciphers(camellia_skcipher_algs,
 				    ARRAY_SIZE(camellia_skcipher_algs));
 }
 
-module_init(init);
-module_exit(fini);
+module_init(camellia_init);
+module_exit(camellia_fini);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Camellia Cipher Algorithm, asm optimized");
--- lnx-517-rc8.orig/arch/x86/crypto/serpent_avx2_glue.c
+++ lnx-517-rc8/arch/x86/crypto/serpent_avx2_glue.c
@@ -96,7 +96,7 @@ static struct skcipher_alg serpent_algs[
 
 static struct simd_skcipher_alg *serpent_simd_algs[ARRAY_SIZE(serpent_algs)];
 
-static int __init init(void)
+static int __init serpent_avx2_init(void)
 {
 	const char *feature_name;
 
@@ -115,14 +115,14 @@ static int __init init(void)
 					      serpent_simd_algs);
 }
 
-static void __exit fini(void)
+static void __exit serpent_avx2_fini(void)
 {
 	simd_unregister_skciphers(serpent_algs, ARRAY_SIZE(serpent_algs),
 				  serpent_simd_algs);
 }
 
-module_init(init);
-module_exit(fini);
+module_init(serpent_avx2_init);
+module_exit(serpent_avx2_fini);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Serpent Cipher Algorithm, AVX2 optimized");
--- lnx-517-rc8.orig/arch/x86/crypto/twofish_glue.c
+++ lnx-517-rc8/arch/x86/crypto/twofish_glue.c
@@ -81,18 +81,18 @@ static struct crypto_alg alg = {
 	}
 };
 
-static int __init init(void)
+static int __init twofish_glue_init(void)
 {
 	return crypto_register_alg(&alg);
 }
 
-static void __exit fini(void)
+static void __exit twofish_glue_fini(void)
 {
 	crypto_unregister_alg(&alg);
 }
 
-module_init(init);
-module_exit(fini);
+module_init(twofish_glue_init);
+module_exit(twofish_glue_fini);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION ("Twofish Cipher Algorithm, asm optimized");
--- lnx-517-rc8.orig/arch/x86/crypto/twofish_glue_3way.c
+++ lnx-517-rc8/arch/x86/crypto/twofish_glue_3way.c
@@ -140,7 +140,7 @@ static int force;
 module_param(force, int, 0);
 MODULE_PARM_DESC(force, "Force module load, ignore CPU blacklist");
 
-static int __init init(void)
+static int __init twofish_3way_init(void)
 {
 	if (!force && is_blacklisted_cpu()) {
 		printk(KERN_INFO
@@ -154,13 +154,13 @@ static int __init init(void)
 					 ARRAY_SIZE(tf_skciphers));
 }
 
-static void __exit fini(void)
+static void __exit twofish_3way_fini(void)
 {
 	crypto_unregister_skciphers(tf_skciphers, ARRAY_SIZE(tf_skciphers));
 }
 
-module_init(init);
-module_exit(fini);
+module_init(twofish_3way_init);
+module_exit(twofish_3way_fini);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Twofish Cipher Algorithm, 3-way parallel asm optimized");
