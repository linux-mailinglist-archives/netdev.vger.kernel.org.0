Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 756CF4AA3D5
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 23:59:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239679AbiBDW7k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 17:59:40 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:44814 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233443AbiBDW7j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 17:59:39 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: usama.anjum)
        with ESMTPSA id 8B0DF1F4705B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1644015578;
        bh=J0wycOSxzaDqvcAyKwCYXObRCBOWXbIMVDr84hTsOEk=;
        h=From:To:Cc:Subject:Date:From;
        b=goLaU8BCbkBFs6Zt1lY7YiPBKr8TOOMHjPbzSaGP7IIBlhK2nTiWOcpawtEo959Zh
         rbjvKkXvuM1aHIFtK/cxvWDMSPCl+e34l10SRYEboOjAGQtiGKhzTQEgIp4pMKR3Bz
         5qMdKR8UsHYMXZMTnhDEOYvYkUirgctWi9uLn2eNZfvcE1E8QdiFqUTCehzP30jrUH
         PC4VvH/c0uy3PDH/R2FFij+WIvz5XSh6i5/7byNWOKOUdDq3/0UbTm8Jweme242wno
         iVp/PyA3wD3vvoCbc9atJwuKkgCVpjkMaXuUEsXDLw+hyWpRk+xfR4tvChaxd1elFH
         wAm6ZlifjslMw==
From:   Muhammad Usama Anjum <usama.anjum@collabora.com>
To:     Shuah Khan <shuah@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>
Cc:     Muhammad Usama Anjum <usama.anjum@collabora.com>,
        kernel@collabora.com, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH] selftests: Fix build when $(O) points to a relative path
Date:   Sat,  5 Feb 2022 03:58:17 +0500
Message-Id: <20220204225817.3918648-1-usama.anjum@collabora.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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

The fix is same as mentioned in commit 150a27328b68 ("bpf, preload: Fix
build when $(O) points to a relative path").

Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
---
 tools/testing/selftests/Makefile | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index 4eda7c7c15694..aa0faf132c35a 100644
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
-- 
2.30.2

