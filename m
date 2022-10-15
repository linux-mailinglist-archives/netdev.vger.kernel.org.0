Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A34E15FFA26
	for <lists+netdev@lfdr.de>; Sat, 15 Oct 2022 15:06:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229824AbiJONGY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Oct 2022 09:06:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbiJONGW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Oct 2022 09:06:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 976AD41D22;
        Sat, 15 Oct 2022 06:06:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2C77260D2D;
        Sat, 15 Oct 2022 13:06:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1618EC433D6;
        Sat, 15 Oct 2022 13:06:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665839180;
        bh=Ji/vrbmpLGWke/L0oUj7MVZ9WkCpinOLZYa5hj5TGxk=;
        h=From:To:Cc:Subject:Date:From;
        b=HffXtRlhVNxupMmrL3DzDgSKRHYGZ4vSrLsfz3KvFL/qIQwELcoBH++qGB/rkfVk9
         S3VTQkIJwj3qwJy3MCAy6bag0PCiXxYWCSS8dgaPuIin7zHnVJIWKl5tVrsgUx++Ew
         uiK/mjTFk4Z/4q88Qu4kzRGfhddyqpX6hIKWPFRGk/ztgOEhrCpwrzoYI2cxfZrJ+6
         M3fNzKJ8pwNhXuMe/Cq9FFn/OSwkfvcD8HdWMETQh2nhOLza8n3MDc2ygHDbc7iREU
         DNFg2MX1qa9pyO6B06hTt59czXGQxe+9DC3qPD6d37XuzPRdkuQgPybKidNvLXaDIe
         mpaIeVmnjdFWw==
From:   guoren@kernel.org
To:     andriy.shevchenko@linux.intel.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux@rasmusvillemoes.dk, yury.norov@gmail.com,
        caraitto@google.com, willemb@google.com, jonolson@google.com,
        amritha.nambiar@intel.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Guo Ren <guoren@linux.alibaba.com>, Guo Ren <guoren@kernel.org>
Subject: [PATCH] Revert "cpumask: fix checking valid cpu range"
Date:   Sat, 15 Oct 2022 09:05:48 -0400
Message-Id: <20221015130548.3634468-1-guoren@kernel.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guo Ren <guoren@linux.alibaba.com>

This reverts commit 78e5a3399421ad79fc024e6d78e2deb7809d26af.

------------[ cut here ]------------
WARNING: CPU: 3 PID: 1 at include/linux/cpumask.h:110 cpumask_next_wrap+0x5c/0x80

Let's back this out and retry with a larger clean up in -next.

Fixes: 78e5a3399421 ("cpumask: fix checking valid cpu range")
Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
Signed-off-by: Guo Ren <guoren@kernel.org>
Cc: Jakub Kicinski <kuba@kernel.org>
---
 include/linux/cpumask.h | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
index 2f065ad97541..c2aa0aa26b45 100644
--- a/include/linux/cpumask.h
+++ b/include/linux/cpumask.h
@@ -174,8 +174,9 @@ static inline unsigned int cpumask_last(const struct cpumask *srcp)
 static inline
 unsigned int cpumask_next(int n, const struct cpumask *srcp)
 {
-	/* n is a prior cpu */
-	cpumask_check(n + 1);
+	/* -1 is a legal arg here. */
+	if (n != -1)
+		cpumask_check(n);
 	return find_next_bit(cpumask_bits(srcp), nr_cpumask_bits, n + 1);
 }
 
@@ -188,8 +189,9 @@ unsigned int cpumask_next(int n, const struct cpumask *srcp)
  */
 static inline unsigned int cpumask_next_zero(int n, const struct cpumask *srcp)
 {
-	/* n is a prior cpu */
-	cpumask_check(n + 1);
+	/* -1 is a legal arg here. */
+	if (n != -1)
+		cpumask_check(n);
 	return find_next_zero_bit(cpumask_bits(srcp), nr_cpumask_bits, n+1);
 }
 
@@ -229,8 +231,9 @@ static inline
 unsigned int cpumask_next_and(int n, const struct cpumask *src1p,
 		     const struct cpumask *src2p)
 {
-	/* n is a prior cpu */
-	cpumask_check(n + 1);
+	/* -1 is a legal arg here. */
+	if (n != -1)
+		cpumask_check(n);
 	return find_next_and_bit(cpumask_bits(src1p), cpumask_bits(src2p),
 		nr_cpumask_bits, n + 1);
 }
@@ -260,8 +263,8 @@ static inline
 unsigned int cpumask_next_wrap(int n, const struct cpumask *mask, int start, bool wrap)
 {
 	cpumask_check(start);
-	/* n is a prior cpu */
-	cpumask_check(n + 1);
+	if (n != -1)
+		cpumask_check(n);
 
 	/*
 	 * Return the first available CPU when wrapping, or when starting before cpu0,
-- 
2.36.1

