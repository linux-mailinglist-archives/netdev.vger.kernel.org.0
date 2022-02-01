Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B3734A669D
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 21:57:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242579AbiBAU5I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 15:57:08 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:58366 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242629AbiBAU5A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 15:57:00 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CC4E661758;
        Tue,  1 Feb 2022 20:56:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93922C340ED;
        Tue,  1 Feb 2022 20:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643749019;
        bh=CwHDLZ6vHdCkuPxLcNdA4DZY55blACA3PpaAT6fvdR0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LPBCFS2iAC7DwE4t4GmDcNwo/6DQ20kEVsITV5Vk9ezupwTHTzkKtyShei1F1v218
         1eL3dltEzwn5v/KbaSdZB2UG01bSTBnftZrZozBM4QofUdJTCHkFNoxMXJp0GyIVR9
         epGGdgLbZqIjqmdNwzm5kcxNy3yeE+zu5Gl1V5w4aYhsilxHsaivMHl68paXE1xgxR
         KUifrK+Q8wmh4kudaJJh0sWqjbh+znE5G7xHtU7a4TAJ27hcgJGZHpa5Gp5BGK5z8i
         H0QU4OvNPjKeF9Mua90M+NoUBq74Heln09M2x902yQwgL1KK+ZwSaAHyJV6QgZfhnD
         Z9pGJr+/DPwcg==
From:   Nathan Chancellor <nathan@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
        Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH bpf-next 2/5] kbuild: Add CONFIG_PAHOLE_VERSION
Date:   Tue,  1 Feb 2022 13:56:21 -0700
Message-Id: <20220201205624.652313-3-nathan@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220201205624.652313-1-nathan@kernel.org>
References: <20220201205624.652313-1-nathan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are a few different places where pahole's version is turned into a
three digit form with the exact same command. Move this command into
scripts/pahole-version.sh to reduce the amount of duplication across the
tree.

Create CONFIG_PAHOLE_VERSION so the version code can be used in Kconfig
to enable and disable configuration options based on the pahole version,
which is already done in a couple of places.

Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 MAINTAINERS               |  1 +
 init/Kconfig              |  4 ++++
 scripts/pahole-version.sh | 13 +++++++++++++
 3 files changed, 18 insertions(+)
 create mode 100755 scripts/pahole-version.sh

diff --git a/MAINTAINERS b/MAINTAINERS
index 0d422452c8ff..d8a66d50f224 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3524,6 +3524,7 @@ F:	net/sched/cls_bpf.c
 F:	samples/bpf/
 F:	scripts/bpf_doc.py
 F:	scripts/pahole-flags.sh
+F:	scripts/pahole-version.sh
 F:	tools/bpf/
 F:	tools/lib/bpf/
 F:	tools/testing/selftests/bpf/
diff --git a/init/Kconfig b/init/Kconfig
index e9119bf54b1f..7328d4f25370 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -86,6 +86,10 @@ config CC_HAS_ASM_INLINE
 config CC_HAS_NO_PROFILE_FN_ATTR
 	def_bool $(success,echo '__attribute__((no_profile_instrument_function)) int x();' | $(CC) -x c - -c -o /dev/null -Werror)
 
+config PAHOLE_VERSION
+	int
+	default $(shell,$(srctree)/scripts/pahole-version.sh $(PAHOLE))
+
 config CONSTRUCTORS
 	bool
 
diff --git a/scripts/pahole-version.sh b/scripts/pahole-version.sh
new file mode 100755
index 000000000000..f8a32ab93ad1
--- /dev/null
+++ b/scripts/pahole-version.sh
@@ -0,0 +1,13 @@
+#!/bin/sh
+# SPDX-License-Identifier: GPL-2.0
+#
+# Usage: $ ./pahole-version.sh pahole
+#
+# Prints pahole's version in a 3-digit form, such as 119 for v1.19.
+
+if [ ! -x "$(command -v "$@")" ]; then
+	echo 0
+	exit 1
+fi
+
+"$@" --version | sed -E 's/v([0-9]+)\.([0-9]+)/\1\2/'
-- 
2.35.1

