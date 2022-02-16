Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 979C94B93E7
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 23:38:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237138AbiBPWjG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 17:39:06 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234060AbiBPWjF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 17:39:05 -0500
Received: from bhuna.collabora.co.uk (bhuna.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e3e3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43DAA2727A5;
        Wed, 16 Feb 2022 14:38:52 -0800 (PST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: usama.anjum)
        with ESMTPSA id E90CA1F454C3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1645051130;
        bh=JujOLCBXFwYy6Z0/MeUsA4c2OP7r607nAXXWYIS6xM8=;
        h=From:To:Cc:Subject:Date:From;
        b=ckvLK6sQGVqorvgizmHJbpQqBTarzzsUvrZ4dCHUMPNon0isDpxZ/EE5N+uJER/oz
         WIrb7TKDhZqEVnfdVBoWTfTnu22qBojDUkE1+d6RIB8IipjMXNEam2PTf+Gw+/85IR
         otlj51/1TJROr0mijhI506ntcWVN/e8FHD5CVyGYE5w9CumxdlP0T9aKEvEcBuJsfV
         i5ocqetg2wO3ojsUjC/EVWB/URp3FuSy/P83/LdlmVUjrlz9tabxGjp3/3S782+u5l
         UmBvyLp3YqwF4hLnsIGG4BrTriVsu/GPFPY7ytwdDJbBfRjdu/S8WJ5WTHHElNHjMX
         o5g9yEvjhIzdQ==
From:   Muhammad Usama Anjum <usama.anjum@collabora.com>
To:     Shuah Khan <shuah@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>
Cc:     Muhammad Usama Anjum <usama.anjum@collabora.com>,
        kernel@collabora.com, kernelci@groups.io,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH V2] selftests: Fix build when $(O) points to a relative path
Date:   Thu, 17 Feb 2022 03:38:17 +0500
Message-Id: <20220216223817.1386745-1-usama.anjum@collabora.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Build of bpf and tc-testing selftests fails when the relative path of
the build directory is specified.

make -C tools/testing/selftests O=build0
make[1]: Entering directory '/linux_mainline/tools/testing/selftests/bpf'
../../../scripts/Makefile.include:4: *** O=build0 does not exist.  Stop.
make[1]: Entering directory '/linux_mainline/tools/testing/selftests/tc-testing'
../../../scripts/Makefile.include:4: *** O=build0 does not exist.  Stop.

Makefiles of bpf and tc-testing include scripts/Makefile.include file.
This file has sanity checking inside it which checks the output path.
The output path is not relative to the bpf or tc-testing. The sanity
check fails. Expand the output path to get rid of this error. The fix is
the same as mentioned in commit 150a27328b68 ("bpf, preload: Fix build
when $(O) points to a relative path").

Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
---
Changes in V2:
Add more explaination to the commit message.
Support make install as well.
---
 tools/testing/selftests/Makefile | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index 4eda7c7c15694..6a5c25fcc9cfc 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -178,6 +178,7 @@ all: khdr
 		BUILD_TARGET=$$BUILD/$$TARGET;			\
 		mkdir $$BUILD_TARGET  -p;			\
 		$(MAKE) OUTPUT=$$BUILD_TARGET -C $$TARGET	\
+				O=$(abs_objtree)		\
 				$(if $(FORCE_TARGETS),|| exit);	\
 		ret=$$((ret * $$?));				\
 	done; exit $$ret;
@@ -185,7 +186,8 @@ all: khdr
 run_tests: all
 	@for TARGET in $(TARGETS); do \
 		BUILD_TARGET=$$BUILD/$$TARGET;	\
-		$(MAKE) OUTPUT=$$BUILD_TARGET -C $$TARGET run_tests;\
+		$(MAKE) OUTPUT=$$BUILD_TARGET -C $$TARGET run_tests \
+				O=$(abs_objtree);		    \
 	done;
 
 hotplug:
@@ -236,6 +238,7 @@ ifdef INSTALL_PATH
 	for TARGET in $(TARGETS); do \
 		BUILD_TARGET=$$BUILD/$$TARGET;	\
 		$(MAKE) OUTPUT=$$BUILD_TARGET -C $$TARGET INSTALL_PATH=$(INSTALL_PATH)/$$TARGET install \
+				O=$(abs_objtree)		\
 				$(if $(FORCE_TARGETS),|| exit);	\
 		ret=$$((ret * $$?));		\
 	done; exit $$ret;
-- 
2.30.2

