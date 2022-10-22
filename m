Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DB0B608354
	for <lists+netdev@lfdr.de>; Sat, 22 Oct 2022 03:45:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230024AbiJVBou (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 21:44:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229947AbiJVBoh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 21:44:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBDE1386B9;
        Fri, 21 Oct 2022 18:44:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7582C61FB9;
        Sat, 22 Oct 2022 01:44:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8EB2C43141;
        Sat, 22 Oct 2022 01:44:32 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="RYModmzz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1666403065;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6V7n7WLPPuhmK3sEMGuUnn+DVRADTUodeMZgVjm6mzw=;
        b=RYModmzzec1OgskkcQmS88KlPnl8bEDxVs4NFDzK61wcmW5QvikH5xeZo68AnjN6PonqCT
        u/znWy0ao8IKhXHXs/gq7RjG6sZSoZ1g/F1NTIf3MbxHxZ33HyaUZgMQA9GjldEfSrFsFn
        1AU24c29vQR9f+tA0s5hbhp1IEc7HeQ=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id bec1a5aa (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Sat, 22 Oct 2022 01:44:25 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     linux-kernel@vger.kernel.org
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
Subject: [PATCH v1 4/5] treewide: use get_random_u32_{above,below}() instead of manual loop
Date:   Fri, 21 Oct 2022 21:44:02 -0400
Message-Id: <20221022014403.3881893-5-Jason@zx2c4.com>
In-Reply-To: <20221022014403.3881893-1-Jason@zx2c4.com>
References: <20221022014403.3881893-1-Jason@zx2c4.com>
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
      ...
-     I = get_random_u32();
      ...
-   } while (I > E);
+   I = get_random_u32_below(E + 1);

@@
expression E;
identifier I;
@@
-   do {
      ...
-     I = get_random_u32();
      ...
-   } while (I >= E);
+   I = get_random_u32_below(E);

@@
expression E;
identifier I;
@@
-   do {
      ...
-     I = get_random_u32();
      ...
-   } while (I < E);
+   I = get_random_u32_above(E - 1);

@@
expression E;
identifier I;
@@
-   do {
      ...
-     I = get_random_u32();
      ...
-   } while (I <= E);
+   I = get_random_u32_above(E);

@@
identifier I;
@@
-   do {
      ...
-     I = get_random_u32();
      ...
-   } while (!I);
+   I = get_random_u32_above(0);

@@
identifier I;
@@
-   do {
      ...
-     I = get_random_u32();
      ...
-   } while (I == 0);
+   I = get_random_u32_above(0);

@@
expression E;
identifier I;
@@
- E + 1 + get_random_u32_below(U32_MAX - E)
+ get_random_u32_above(E)

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
index f185f57c34e7..9cfed7fd8740 100644
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

