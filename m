Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8590E4E945A
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 13:26:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241001AbiC1L1r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 07:27:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241029AbiC1L0T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 07:26:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF43860DF;
        Mon, 28 Mar 2022 04:23:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 437E0B81072;
        Mon, 28 Mar 2022 11:23:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D94A8C340F3;
        Mon, 28 Mar 2022 11:23:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648466609;
        bh=A/hAMMRh3XJNdD9x1AAtbacK618VtXEYBp3Ix1ZXMfo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UxjltfWH0myQA4zj1M/htqy76iLly77Hpe9cjblBeLQofx0Z2jSXxP0TOi3pgXSZq
         DcsqqFN2SmLDgVMJF5j2x5Z3ZNv1XwAGQSVfbAhTVs2C5Q9b7H2TpWxSbxVNVcZo3N
         kVEovffO4G8EOPKTxarOTUX2jRVZ9TQ2Nw3DKQu1tFt8VPp/JUSpFHp6ja9Gs3TnFt
         e9iH1QeBH9CTzeehax7bBEDc9LsfWIWJVHAdVnLEomX5O5nNoAohoTED6DgZyVY7Eo
         1csnqaZiuqx2DRIWiF3/5KTUldGHyvNQQR3lFhQXDWvAJzL7D/fXC/ziOiyEGHiuIL
         MGR6VKsHyS1hQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Paul Menzel <pmenzel@molgen.mpg.de>,
        Matt Brown <matthew.brown.dev@gmail.com>,
        Song Liu <song@kernel.org>, Sasha Levin <sashal@kernel.org>,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 15/21] lib/raid6/test/Makefile: Use $(pound) instead of \# for Make 4.3
Date:   Mon, 28 Mar 2022 07:22:48 -0400
Message-Id: <20220328112254.1556286-15-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220328112254.1556286-1-sashal@kernel.org>
References: <20220328112254.1556286-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Menzel <pmenzel@molgen.mpg.de>

[ Upstream commit 633174a7046ec3b4572bec24ef98e6ee89bce14b ]

Buidling raid6test on Ubuntu 21.10 (ppc64le) with GNU Make 4.3 shows the
errors below:

    $ cd lib/raid6/test/
    $ make
    <stdin>:1:1: error: stray ‘\’ in program
    <stdin>:1:2: error: stray ‘#’ in program
    <stdin>:1:11: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ \
        before ‘<’ token

    [...]

The errors come from the HAS_ALTIVEC test, which fails, and the POWER
optimized versions are not built. That’s also reason nobody noticed on the
other architectures.

GNU Make 4.3 does not remove the backslash anymore. From the 4.3 release
announcment:

> * WARNING: Backward-incompatibility!
>   Number signs (#) appearing inside a macro reference or function invocation
>   no longer introduce comments and should not be escaped with backslashes:
>   thus a call such as:
>     foo := $(shell echo '#')
>   is legal.  Previously the number sign needed to be escaped, for example:
>     foo := $(shell echo '\#')
>   Now this latter will resolve to "\#".  If you want to write makefiles
>   portable to both versions, assign the number sign to a variable:
>     H := \#
>     foo := $(shell echo '$H')
>   This was claimed to be fixed in 3.81, but wasn't, for some reason.
>   To detect this change search for 'nocomment' in the .FEATURES variable.

So, do the same as commit 9564a8cf422d ("Kbuild: fix # escaping in .cmd
files for future Make") and commit 929bef467771 ("bpf: Use $(pound) instead
of \# in Makefiles") and define and use a $(pound) variable.

Reference for the change in make:
https://git.savannah.gnu.org/cgit/make.git/commit/?id=c6966b323811c37acedff05b57

Cc: Matt Brown <matthew.brown.dev@gmail.com>
Signed-off-by: Paul Menzel <pmenzel@molgen.mpg.de>
Signed-off-by: Song Liu <song@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/raid6/test/Makefile | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/lib/raid6/test/Makefile b/lib/raid6/test/Makefile
index a4c7cd74cff5..4fb7700a741b 100644
--- a/lib/raid6/test/Makefile
+++ b/lib/raid6/test/Makefile
@@ -4,6 +4,8 @@
 # from userspace.
 #
 
+pound := \#
+
 CC	 = gcc
 OPTFLAGS = -O2			# Adjust as desired
 CFLAGS	 = -I.. -I ../../../include -g $(OPTFLAGS)
@@ -42,7 +44,7 @@ else ifeq ($(HAS_NEON),yes)
         OBJS   += neon.o neon1.o neon2.o neon4.o neon8.o recov_neon.o recov_neon_inner.o
         CFLAGS += -DCONFIG_KERNEL_MODE_NEON=1
 else
-        HAS_ALTIVEC := $(shell printf '\#include <altivec.h>\nvector int a;\n' |\
+        HAS_ALTIVEC := $(shell printf '$(pound)include <altivec.h>\nvector int a;\n' |\
                          gcc -c -x c - >/dev/null && rm ./-.o && echo yes)
         ifeq ($(HAS_ALTIVEC),yes)
                 CFLAGS += -I../../../arch/powerpc/include
-- 
2.34.1

