Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 961DBE5D75
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 15:37:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726362AbfJZNQD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Oct 2019 09:16:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:37402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726162AbfJZNQD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Oct 2019 09:16:03 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A219B2070B;
        Sat, 26 Oct 2019 13:16:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572095762;
        bh=Qx5Mwi+ZX7G4BJNl1HaOQ3XGU6C1kwNJVmzWlWuN+8U=;
        h=From:To:Cc:Subject:Date:From;
        b=IfUMJKm1yyQAa1pYDb3Wx4BbSGBd6FbBzVBiADMeLCWzSCLdeBHN0My1xoOf5kHHF
         hHJ8Wami0zaHUfwPEMlhQd16mNTbSF2aCmkkvZBspU8Bm5hJmifS4k7pf4RgaxI6/4
         YyLq4FvVfig89qBuzKZgfbjYHssInKXU+4DRxIgs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shuah Khan <skhan@linuxfoundation.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 01/99] tools: bpf: Use !building_out_of_srctree to determine srctree
Date:   Sat, 26 Oct 2019 09:14:22 -0400
Message-Id: <20191026131600.2507-1-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shuah Khan <skhan@linuxfoundation.org>

[ Upstream commit 55d554f5d14071f7c2c5dbd88d0a2eb695c97d16 ]

make TARGETS=bpf kselftest fails with:

Makefile:127: tools/build/Makefile.include: No such file or directory

When the bpf tool make is invoked from tools Makefile, srctree is
cleared and the current logic check for srctree equals to empty
string to determine srctree location from CURDIR.

When the build in invoked from selftests/bpf Makefile, the srctree
is set to "." and the same logic used for srctree equals to empty is
needed to determine srctree.

Check building_out_of_srctree undefined as the condition for both
cases to fix "make TARGETS=bpf kselftest" build failure.

Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Song Liu <songliubraving@fb.com>
Link: https://lore.kernel.org/bpf/20190927011344.4695-1-skhan@linuxfoundation.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/Makefile     | 6 +++++-
 tools/lib/bpf/Makefile | 6 +++++-
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/tools/bpf/Makefile b/tools/bpf/Makefile
index 53b60ad452f5d..93a84965345dc 100644
--- a/tools/bpf/Makefile
+++ b/tools/bpf/Makefile
@@ -12,7 +12,11 @@ INSTALL ?= install
 CFLAGS += -Wall -O2
 CFLAGS += -D__EXPORTED_HEADERS__ -I$(srctree)/include/uapi -I$(srctree)/include
 
-ifeq ($(srctree),)
+# This will work when bpf is built in tools env. where srctree
+# isn't set and when invoked from selftests build, where srctree
+# is set to ".". building_out_of_srctree is undefined for in srctree
+# builds
+ifndef building_out_of_srctree
 srctree := $(patsubst %/,%,$(dir $(CURDIR)))
 srctree := $(patsubst %/,%,$(dir $(srctree)))
 endif
diff --git a/tools/lib/bpf/Makefile b/tools/lib/bpf/Makefile
index 9312066a1ae38..f23e5e285541d 100644
--- a/tools/lib/bpf/Makefile
+++ b/tools/lib/bpf/Makefile
@@ -7,7 +7,11 @@ BPF_EXTRAVERSION = 4
 
 MAKEFLAGS += --no-print-directory
 
-ifeq ($(srctree),)
+# This will work when bpf is built in tools env. where srctree
+# isn't set and when invoked from selftests build, where srctree
+# is a ".". building_out_of_srctree is undefined for in srctree
+# builds
+ifndef building_out_of_srctree
 srctree := $(patsubst %/,%,$(dir $(CURDIR)))
 srctree := $(patsubst %/,%,$(dir $(srctree)))
 srctree := $(patsubst %/,%,$(dir $(srctree)))
-- 
2.20.1

