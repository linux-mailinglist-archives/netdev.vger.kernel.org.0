Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0583D4924CA
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 12:31:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240034AbiARLbD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 06:31:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240106AbiARLa6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 06:30:58 -0500
Received: from bhuna.collabora.co.uk (bhuna.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e3e3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B756C06161C;
        Tue, 18 Jan 2022 03:30:58 -0800 (PST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: usama.anjum)
        with ESMTPSA id D840D1F43E9D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1642505457;
        bh=dpLad+4CdJOaMlTWmTiAawK1sEdubzbwv8rkOkH0hpM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EWk48EtaaPvtMZ6NV+gyXS9Eo6lBlAQ2vge/1BuKuobi8Pp1fJxCHAWAWcakXF6U/
         5fjTQd3jAAwsXK51uiAPDKasPaNsqbuE1zsmlkNHW55Dq1A+7FTDZZudZUlt3JLL9x
         Z2CFjQXSnfcpM51B7QrKwS/OQWzDBHZZW7jo243Cz1gXCoKwR2Ov11/izrwuYfUMf2
         V94JNSMORMu7lwZe+bdZHz4p/cWoNbzhZgosq6SGA0JJmQ4myZ8sIPVyMZHe8yKOBJ
         9j85yAnraTQ0GR7ZOTae5N1NEkBSA+VKK+gvvzi8zILKYRhg/yDSABZmXoixlYetES
         fP0UdH6ebqsrQ==
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
Subject: [PATCH 02/10] selftests: Add and export a kernel uapi headers path
Date:   Tue, 18 Jan 2022 16:29:01 +0500
Message-Id: <20220118112909.1885705-3-usama.anjum@collabora.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220118112909.1885705-1-usama.anjum@collabora.com>
References: <20220118112909.1885705-1-usama.anjum@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kernel uapi headers can be present at different paths depending upon
how the build was invoked. It becomes impossible for the tests to
include the correct headers directory. Set and export KHDR_INCLUDES
variable to make it possible for sub make files to include the header
files.

Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
---
 tools/testing/selftests/Makefile | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index a7b63860b7bc..21f983dfd047 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -129,8 +129,11 @@ ifneq ($(KBUILD_OUTPUT),)
   # $(realpath ...) resolves symlinks
   abs_objtree := $(realpath $(abs_objtree))
   BUILD := $(abs_objtree)/kselftest
+  KHDR_INCLUDES := -I${abs_objtree}/usr/include
 else
   BUILD := $(CURDIR)
+  abs_srctree := $(shell cd $(top_srcdir) && pwd)
+  KHDR_INCLUDES := -I${abs_srctree}/usr/include
   DEFAULT_INSTALL_HDR_PATH := 1
 endif
 
@@ -139,6 +142,7 @@ include $(top_srcdir)/scripts/subarch.include
 ARCH           ?= $(SUBARCH)
 export KSFT_KHDR_INSTALL_DONE := 1
 export BUILD
+export KHDR_INCLUDES
 
 # set default goal to all, so make without a target runs all, even when
 # all isn't the first target in the file.
-- 
2.30.2

