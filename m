Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A23DE2CA5D8
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 15:39:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389363AbgLAOiE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 09:38:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:55796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388116AbgLAOiD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Dec 2020 09:38:03 -0500
Received: from localhost (searspoint.nvidia.com [216.228.112.21])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 115B920757;
        Tue,  1 Dec 2020 14:37:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606833442;
        bh=wZROcP5CZTMECo5kQllBGtqQbcBo45uTKS8WHm8zLhs=;
        h=From:To:Cc:Subject:Date:From;
        b=Ddf6bVZ2M0dNM1TuN3TRYlCdVBWt/Tc0MZMlZOyYvHzYiTUSUWnff82UoBikvuR9S
         ePAZE17dddi/GOBrCAtRBr/FxnKksZhBpZVsYCror0JBsuvUUU1WjHVtZpaRG8Idhi
         roXPI87pVn0xiyHMy8FliP8MO70XUeyJH6y7yVZk=
From:   Leon Romanovsky <leon@kernel.org>
To:     Masahiro Yamada <masahiroy@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>
Cc:     Leon Romanovsky <leonro@nvidia.com>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, Edward Srouji <edwards@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>, bpf@vger.kernel.org,
        kernel-team@fb.com, netdev@vger.kernel.org
Subject: [PATCH bpf-next] kbuild: Restore ability to build out-of-tree modules
Date:   Tue,  1 Dec 2020 16:37:00 +0200
Message-Id: <20201201143700.719828-1-leon@kernel.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

The out-of-tree modules are built without vmlinux target and request
to recompile that target unconditionally causes to the following
compilation error.

[root@server kernel]# make
<..>
make -f ./scripts/Makefile.modpost
make -f ./scripts/Makefile.modfinal
make[3]: *** No rule to make target 'vmlinux', needed by '/my_temp/out-of-tree-module/kernel/test.ko'.  Stop.
make[2]: *** [scripts/Makefile.modpost:117: __modpost] Error 2
make[1]: *** [Makefile:1703: modules] Error 2
make[1]: Leaving directory '/usr/src/kernels/5.10.0-rc5_for_upstream_base_2020_11_29_11_34'
make: *** [Makefile:80: modules] Error 2

As a solution separate between build paths that has vmlinux target and paths without.

Fixes: 5f9ae91f7c0d ("kbuild: Build kernel module BTFs if BTF is enabled and pahole supports it")
Reported-by: Edward Srouji <edwards@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
Not proficient enough in Makefile, but it fixes the issue.
---
 scripts/Makefile.modfinal | 5 +++++
 scripts/Makefile.modpost  | 4 ++++
 2 files changed, 9 insertions(+)

diff --git a/scripts/Makefile.modfinal b/scripts/Makefile.modfinal
index 02b892421f7a..8a7d0604e7d0 100644
--- a/scripts/Makefile.modfinal
+++ b/scripts/Makefile.modfinal
@@ -48,9 +48,14 @@ if_changed_except = $(if $(call newer_prereqs_except,$(2))$(cmd-check),      \
 	$(cmd);                                                              \
 	printf '%s\n' 'cmd_$@ := $(make-cmd)' > $(dot-target).cmd, @:)

+ifdef MODPOST_VMLINUX
 # Re-generate module BTFs if either module's .ko or vmlinux changed
 $(modules): %.ko: %.o %.mod.o scripts/module.lds vmlinux FORCE
 	+$(call if_changed_except,ld_ko_o,vmlinux)
+else
+$(modules): %.ko: %.o %.mod.o scripts/module.lds FORCE
+	+$(call if_changed_except,ld_ko_o)
+endif
 ifdef CONFIG_DEBUG_INFO_BTF_MODULES
 	+$(if $(newer-prereqs),$(call cmd,btf_ko))
 endif
diff --git a/scripts/Makefile.modpost b/scripts/Makefile.modpost
index f54b6ac37ac2..f5aa5b422ad7 100644
--- a/scripts/Makefile.modpost
+++ b/scripts/Makefile.modpost
@@ -114,8 +114,12 @@ targets += $(output-symdump)

 __modpost: $(output-symdump)
 ifneq ($(KBUILD_MODPOST_NOFINAL),1)
+ifdef MODPOST_VMLINUX
+	$(Q)$(MAKE) -f $(srctree)/scripts/Makefile.modfinal MODPOST_VMLINUX=1
+else
 	$(Q)$(MAKE) -f $(srctree)/scripts/Makefile.modfinal
 endif
+endif

 PHONY += FORCE
 FORCE:
--
2.28.0

