Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 153EE6285EA
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 17:47:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238025AbiKNQrU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 11:47:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238100AbiKNQrK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 11:47:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D825A2F028;
        Mon, 14 Nov 2022 08:47:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 74137612DF;
        Mon, 14 Nov 2022 16:47:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 883ECC433C1;
        Mon, 14 Nov 2022 16:47:05 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="IZwW/pXt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1668444425;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GUOLjwe2IeIpzWXOEF9lexW8mdcNzGTdZsyQ38BdoPo=;
        b=IZwW/pXtgQjRmiQ0PtVQPt2pepd0WzFJDYnD9391y9kx/P1IoPzFa7R23Ul6Y1I6NyMf54
        720Ds0WvTdN9pJBmGYz6ky6KfVM3twh/wLmfzS137SqlUCUm/EnhwjnExPBVNyJaC0r/yz
        hUqcqQRMMcMIQm2imAIC1tMqnYFTlUk=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 04ea1518 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Mon, 14 Nov 2022 16:47:04 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     linux-kernel@vger.kernel.org, patches@lists.linux.dev
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Kees Cook <keescook@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Heiko Carstens <hca@linux.ibm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        =?UTF-8?q?Christoph=20B=C3=B6hmwalder?= 
        <christoph.boehmwalder@linbit.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Richard Weinberger <richard@nod.at>,
        "Darrick J . Wong" <djwong@kernel.org>,
        SeongJae Park <sj@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Helge Deller <deller@gmx.de>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-block@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-media@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, loongarch@lists.linux.dev,
        linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-mmc@vger.kernel.org, linux-parisc@vger.kernel.org
Subject: [PATCH v2 2/3] treewide: use get_random_u32_{above,below}() instead of manual loop
Date:   Mon, 14 Nov 2022 17:45:57 +0100
Message-Id: <20221114164558.1180362-3-Jason@zx2c4.com>
In-Reply-To: <20221114164558.1180362-1-Jason@zx2c4.com>
References: <20221114164558.1180362-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These cases were done with this Coccinelle:

@@
expression E;
identifier I;
@@
-   do {
      ... when != I
-     I = get_random_u32();
      ... when != I
-   } while (I > E);
+   I = get_random_u32_below(E + 1);

@@
expression E;
identifier I;
@@
-   do {
      ... when != I
-     I = get_random_u32();
      ... when != I
-   } while (I >= E);
+   I = get_random_u32_below(E);

@@
expression E;
identifier I;
@@
-   do {
      ... when != I
-     I = get_random_u32();
      ... when != I
-   } while (I < E);
+   I = get_random_u32_above(E - 1);

@@
expression E;
identifier I;
@@
-   do {
      ... when != I
-     I = get_random_u32();
      ... when != I
-   } while (I <= E);
+   I = get_random_u32_above(E);

@@
identifier I;
@@
-   do {
      ... when != I
-     I = get_random_u32();
      ... when != I
-   } while (!I);
+   I = get_random_u32_above(0);

@@
identifier I;
@@
-   do {
      ... when != I
-     I = get_random_u32();
      ... when != I
-   } while (I == 0);
+   I = get_random_u32_above(0);

@@
expression E;
@@
- E + 1 + get_random_u32_below(U32_MAX - E)
+ get_random_u32_above(E)

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 fs/ext4/mmp.c            | 8 +-------
 lib/test_fprobe.c        | 5 +----
 lib/test_kprobes.c       | 5 +----
 net/ipv6/output_core.c   | 8 +-------
 net/vmw_vsock/af_vsock.c | 3 +--
 5 files changed, 5 insertions(+), 24 deletions(-)

diff --git a/fs/ext4/mmp.c b/fs/ext4/mmp.c
index 588cb09c5291..4681fff6665f 100644
--- a/fs/ext4/mmp.c
+++ b/fs/ext4/mmp.c
@@ -262,13 +262,7 @@ void ext4_stop_mmpd(struct ext4_sb_info *sbi)
  */
 static unsigned int mmp_new_seq(void)
 {
-	u32 new_seq;
-
-	do {
-		new_seq = get_random_u32();
-	} while (new_seq > EXT4_MMP_SEQ_MAX);
-
-	return new_seq;
+	return get_random_u32_below(EXT4_MMP_SEQ_MAX + 1);
 }
 
 /*
diff --git a/lib/test_fprobe.c b/lib/test_fprobe.c
index e0381b3ec410..1fb56cf5e5ce 100644
--- a/lib/test_fprobe.c
+++ b/lib/test_fprobe.c
@@ -144,10 +144,7 @@ static unsigned long get_ftrace_location(void *func)
 
 static int fprobe_test_init(struct kunit *test)
 {
-	do {
-		rand1 = get_random_u32();
-	} while (rand1 <= div_factor);
-
+	rand1 = get_random_u32_above(div_factor);
 	target = fprobe_selftest_target;
 	target2 = fprobe_selftest_target2;
 	target_ip = get_ftrace_location(target);
diff --git a/lib/test_kprobes.c b/lib/test_kprobes.c
index eeb1d728d974..1c95e5719802 100644
--- a/lib/test_kprobes.c
+++ b/lib/test_kprobes.c
@@ -339,10 +339,7 @@ static int kprobes_test_init(struct kunit *test)
 	stacktrace_target = kprobe_stacktrace_target;
 	internal_target = kprobe_stacktrace_internal_target;
 	stacktrace_driver = kprobe_stacktrace_driver;
-
-	do {
-		rand1 = get_random_u32();
-	} while (rand1 <= div_factor);
+	rand1 = get_random_u32_above(div_factor);
 	return 0;
 }
 
diff --git a/net/ipv6/output_core.c b/net/ipv6/output_core.c
index 2685c3f15e9d..b5205311f372 100644
--- a/net/ipv6/output_core.c
+++ b/net/ipv6/output_core.c
@@ -15,13 +15,7 @@ static u32 __ipv6_select_ident(struct net *net,
 			       const struct in6_addr *dst,
 			       const struct in6_addr *src)
 {
-	u32 id;
-
-	do {
-		id = get_random_u32();
-	} while (!id);
-
-	return id;
+	return get_random_u32_above(0);
 }
 
 /* This function exists only for tap drivers that must support broken
diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index ff38c5a4d174..d593d5b6d4b1 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -626,8 +626,7 @@ static int __vsock_bind_connectible(struct vsock_sock *vsk,
 	struct sockaddr_vm new_addr;
 
 	if (!port)
-		port = LAST_RESERVED_PORT + 1 +
-			get_random_u32_below(U32_MAX - LAST_RESERVED_PORT);
+		port = get_random_u32_above(LAST_RESERVED_PORT);
 
 	vsock_addr_init(&new_addr, addr->svm_cid, addr->svm_port);
 
-- 
2.38.1

