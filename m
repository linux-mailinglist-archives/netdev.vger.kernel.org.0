Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8201E60834E
	for <lists+netdev@lfdr.de>; Sat, 22 Oct 2022 03:45:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbiJVBop (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 21:44:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229945AbiJVBoh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 21:44:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86A933204F;
        Fri, 21 Oct 2022 18:44:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 227AE61FB1;
        Sat, 22 Oct 2022 01:44:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FC1BC43143;
        Sat, 22 Oct 2022 01:44:31 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="GMIwnwq1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1666403063;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pgAGvtfWFBepSErNnmOiCogblep8pK7WSNMDWQtrNSg=;
        b=GMIwnwq1awcpUW/3bcqRLII9Ls9FFpGfdnmMIcvGbiEtdgTfYCtyHBxD9yKHQ7iLoU7MWe
        oedm6GH5CEx+hIfF88+NdonBLSB3Qlk4BllZXEvDgVRGj4TJT9CbyQxCoDz8OaY8tqxGTj
        zGaJgSvm0ym+4US4UBRtlbzQYNmOeTE=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id e102b3b6 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Sat, 22 Oct 2022 01:44:23 +0000 (UTC)
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
Subject: [PATCH v1 3/5] random: add helpers for random numbers with given floor or range
Date:   Fri, 21 Oct 2022 21:44:01 -0400
Message-Id: <20221022014403.3881893-4-Jason@zx2c4.com>
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

Now that we have get_random_u32_below(), it's trivial to make inline
helpers to compute get_random_u32_above() and get_random_u32_between(),
which will help clean up open coded loops and manual computations
throughout the tree.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 include/linux/random.h | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/include/linux/random.h b/include/linux/random.h
index 3a82c0a8bc46..92188a74e50e 100644
--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -91,6 +91,30 @@ static inline u32 get_random_u32_below(u32 ceil)
 	}
 }
 
+/*
+ * Returns a random integer in the interval (floor, U32_MAX], with uniform
+ * distribution, suitable for all uses. Fastest when floor is a constant, but
+ * still fast for variable floor as well.
+ */
+static inline u32 get_random_u32_above(u32 floor)
+{
+	BUILD_BUG_ON_MSG(__builtin_constant_p(floor) && floor == U32_MAX,
+			 "get_random_u32_above() must take floor < U32_MAX");
+	return floor + 1 + get_random_u32_below(U32_MAX - floor);
+}
+
+/*
+ * Returns a random integer in the interval [floor, ceil), with uniform
+ * distribution, suitable for all uses. Fastest when floor and ceil are
+ * constant, but still fast for variable floor and ceil as well.
+ */
+static inline u32 get_random_u32_between(u32 floor, u32 ceil)
+{
+	BUILD_BUG_ON_MSG(__builtin_constant_p(floor) && __builtin_constant_p(ceil) &&
+			 floor >= ceil, "get_random_u32_above() must take floor < ceil");
+	return floor + get_random_u32_below(ceil - floor);
+}
+
 /*
  * On 64-bit architectures, protect against non-terminated C string overflows
  * by zeroing out the first byte of the canary; this leaves 56 bits of entropy.
-- 
2.38.1

