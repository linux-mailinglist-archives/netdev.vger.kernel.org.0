Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABB8056CB97
	for <lists+netdev@lfdr.de>; Sat,  9 Jul 2022 23:22:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229560AbiGIVV3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jul 2022 17:21:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbiGIVV1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Jul 2022 17:21:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A8E0193F9;
        Sat,  9 Jul 2022 14:21:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0A6EFB8070D;
        Sat,  9 Jul 2022 21:21:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0F4FC341CB;
        Sat,  9 Jul 2022 21:21:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657401683;
        bh=n8WKt81pbmhSn6c89y74zD8lGXuy8bG9cCPrZIq1vCs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fngNrnaWCPZtgtYGOuDhSkDCZh4Zizp1wfLiLTp/PWXA3Kk6m2BfI7cGAjs6/0knA
         2pFOp97W43HFn7+8f4vrOcYf6ZcVmUzP6qoKuJl5joqhfB4SaUhlWZRJW/IS9MCEBb
         mvakqsf3Y851H304Gz743NN4+bHBLikm2RG/OhF+BaEipxqxAPAeZt8IFkIzOCzq4S
         DRNg7v2HX5AbA3s0YffjmkSUWc7RYQCGU31+RJluWpcUq8zxQFfGoy8KebZ1ynBGY9
         1wzhn6rmm73nmEu0N8NBJIKdBgNubu2GvzgtQUSLRdzBB+WRBDG2pepP0JVbZ6F8Qw
         3tMaGkI2XVCjQ==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        "Jason A . Donenfeld " <Jason@zx2c4.com>
Subject: [PATCH 1/2] crypto: move lib/sha1.c into lib/crypto/
Date:   Sat,  9 Jul 2022 14:18:48 -0700
Message-Id: <20220709211849.210850-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220709211849.210850-1-ebiggers@kernel.org>
References: <20220709211849.210850-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

SHA-1 is a crypto algorithm (or at least was intended to be -- it's not
considered secure anymore), so move it out of the top-level library
directory and into lib/crypto/.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 lib/Makefile            | 2 +-
 lib/crypto/Makefile     | 2 ++
 lib/{ => crypto}/sha1.c | 0
 3 files changed, 3 insertions(+), 1 deletion(-)
 rename lib/{ => crypto}/sha1.c (100%)

diff --git a/lib/Makefile b/lib/Makefile
index f99bf61f8bbc67..67482f5ec0e899 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -29,7 +29,7 @@ endif
 
 lib-y := ctype.o string.o vsprintf.o cmdline.o \
 	 rbtree.o radix-tree.o timerqueue.o xarray.o \
-	 idr.o extable.o sha1.o irq_regs.o argv_split.o \
+	 idr.o extable.o irq_regs.o argv_split.o \
 	 flex_proportions.o ratelimit.o show_mem.o \
 	 is_single_threaded.o plist.o decompress.o kobject_uevent.o \
 	 earlycpio.o seq_buf.o siphash.o dec_and_lock.o \
diff --git a/lib/crypto/Makefile b/lib/crypto/Makefile
index 26be2bbe09c59e..d28111ba54fcb2 100644
--- a/lib/crypto/Makefile
+++ b/lib/crypto/Makefile
@@ -34,6 +34,8 @@ libpoly1305-y					:= poly1305-donna32.o
 libpoly1305-$(CONFIG_ARCH_SUPPORTS_INT128)	:= poly1305-donna64.o
 libpoly1305-y					+= poly1305.o
 
+obj-y						+= sha1.o
+
 obj-$(CONFIG_CRYPTO_LIB_SHA256)			+= libsha256.o
 libsha256-y					:= sha256.o
 
diff --git a/lib/sha1.c b/lib/crypto/sha1.c
similarity index 100%
rename from lib/sha1.c
rename to lib/crypto/sha1.c
-- 
2.37.0

