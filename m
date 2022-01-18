Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52EBC4924D8
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 12:32:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240153AbiARLbz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 06:31:55 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:35870 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240630AbiARLbg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 06:31:36 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: usama.anjum)
        with ESMTPSA id C6F5A1F43EC0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1642505494;
        bh=f/au3CsQPO/GIa/zBleGlWIysQfk59tmnzMqq6fix88=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EoT+wn7pIb/F+auwrxvGpdTzbp0SSH2JL8xkak1SS8HMmCuYsT+Am7cIkV5Msc4Q/
         U+u+NcYne87dY5LS9UYjqmQyaUxhANeFXA/yPruEpAebNQK+vG2A0Kly+8HsA8R50b
         BR606G/NT9v0oZ8Ox7bpmRMBgvHxLU6uO3Obgs8N+tgB5F0HkzR5aXujTAaZIlqLop
         tawMy3Yb/ojfzAe21P0fmQda0wV59wgLQX68h0tPMGSlJ4oLh1HBJN7UFHMwW0snTb
         tkRKBRzN2qwb/MjfmqbSDme+oUImqsFukIY6lIayF0/iSaNrzP0sZ3PFr4xsfY+HDQ
         XQlLxY9KjF6gg==
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
Subject: [PATCH 06/10] selftests: landlock: Add the uapi headers include variable
Date:   Tue, 18 Jan 2022 16:29:05 +0500
Message-Id: <20220118112909.1885705-7-usama.anjum@collabora.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220118112909.1885705-1-usama.anjum@collabora.com>
References: <20220118112909.1885705-1-usama.anjum@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Out of tree build of this test fails if relative path of the output
directory is specified. Remove the un-needed include paths and use
KHDR_INCLUDES to correctly reach the headers.

Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
---
 tools/testing/selftests/landlock/Makefile | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/landlock/Makefile b/tools/testing/selftests/landlock/Makefile
index a99596ca9882..44c724b38a37 100644
--- a/tools/testing/selftests/landlock/Makefile
+++ b/tools/testing/selftests/landlock/Makefile
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 
-CFLAGS += -Wall -O2
+CFLAGS += -Wall -O2 $(KHDR_INCLUDES)
 
 src_test := $(wildcard *_test.c)
 
@@ -12,13 +12,8 @@ KSFT_KHDR_INSTALL := 1
 OVERRIDE_TARGETS := 1
 include ../lib.mk
 
-khdr_dir = $(top_srcdir)/usr/include
-
-$(khdr_dir)/linux/landlock.h: khdr
-	@:
-
 $(OUTPUT)/true: true.c
 	$(LINK.c) $< $(LDLIBS) -o $@ -static
 
-$(OUTPUT)/%_test: %_test.c $(khdr_dir)/linux/landlock.h ../kselftest_harness.h common.h
-	$(LINK.c) $< $(LDLIBS) -o $@ -lcap -I$(khdr_dir)
+$(OUTPUT)/%_test: %_test.c ../kselftest_harness.h common.h
+	$(LINK.c) $< $(LDLIBS) -o $@ -lcap
-- 
2.30.2

