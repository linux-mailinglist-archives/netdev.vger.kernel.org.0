Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 301F64924D0
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 12:31:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239965AbiARLbM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 06:31:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240169AbiARLbI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 06:31:08 -0500
Received: from bhuna.collabora.co.uk (bhuna.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e3e3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DFEBC06173E;
        Tue, 18 Jan 2022 03:31:08 -0800 (PST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: usama.anjum)
        with ESMTPSA id 1CCBC1F43EA4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1642505467;
        bh=FL5woJicBxOM7EavfZYCVa1miYOdVihihV/Qs6cofek=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n0xKX4Vham5LQD/c8ClU/yBO1aOldvHQE5JKZOsXG09nJx5UgKM5qjXBKNxsMPFr8
         YhzC0SOXspS1MLKYueeppaldTe3ugKtpXzLpaxorkCr0mp+ki8oYYzQ9xLcdf0JoI0
         caYNp4KihbxmlIoufOwYzRfQw8/JumGCgRixD5dXFOz9AJQ94JaQTUx3QH2GtrqRTE
         Aexm0+zrNSktNBMszHRKO3muSZdJRTF0ikaDnvPaHFswDxkytRhCUew90kYxKoXEam
         I5W/gr/6JXZMdY0cD+ajO2yurpEjPGB5Vwtq7qphiwSuX6BDDxNI4EXADHzagWY7r+
         v027n9eOAKUog==
From:   Muhammad Usama Anjum <usama.anjum@collabora.com>
To:     Shuah Khan <shuah@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Darren Hart <dvhart@infradead.org>,
        Davidlohr Bueso <dave@stgolabs.net>,
        =?UTF-8?q?Andr=C3=A9=20Almeida?= <andrealmeid@collabora.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        chiminghao <chi.minghao@zte.com.cn>,
        linux-kselftest@vger.kernel.org (open list:KERNEL SELFTEST FRAMEWORK),
        linux-kernel@vger.kernel.org (open list),
        kvm@vger.kernel.org (open list:KERNEL VIRTUAL MACHINE (KVM)),
        linux-security-module@vger.kernel.org (open list:LANDLOCK SECURITY
        MODULE), netdev@vger.kernel.org (open list:NETWORKING [GENERAL]),
        mptcp@lists.linux.dev (open list:NETWORKING [MPTCP]),
        linux-mm@kvack.org (open list:MEMORY MANAGEMENT)
Cc:     Muhammad Usama Anjum <usama.anjum@collabora.com>,
        kernel@collabora.com
Subject: [PATCH 03/10] selftests: Correct the headers install path
Date:   Tue, 18 Jan 2022 16:29:02 +0500
Message-Id: <20220118112909.1885705-4-usama.anjum@collabora.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220118112909.1885705-1-usama.anjum@collabora.com>
References: <20220118112909.1885705-1-usama.anjum@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

uapi headers should be installed at the top of the object tree,
"<obj_tree>/usr/include". There is no need for kernel headers to
be present at kselftest build directory, "<obj_tree>/kselftest/usr/
include" as well. This duplication can be avoided by correctly
specifying the INSTALL_HDR_PATH.

Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
---
 tools/testing/selftests/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index 21f983dfd047..80e5498eab92 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -167,7 +167,7 @@ khdr:
 ifeq (1,$(DEFAULT_INSTALL_HDR_PATH))
 	$(MAKE) --no-builtin-rules ARCH=$(ARCH) -C $(top_srcdir) headers_install
 else
-	$(MAKE) --no-builtin-rules INSTALL_HDR_PATH=$$BUILD/usr \
+	$(MAKE) --no-builtin-rules INSTALL_HDR_PATH=$(abs_objtree)/usr \
 		ARCH=$(ARCH) -C $(top_srcdir) headers_install
 endif
 
-- 
2.30.2

