Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22AD53BE2E9
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 08:03:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230288AbhGGGGV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 02:06:21 -0400
Received: from foss.arm.com ([217.140.110.172]:57232 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230203AbhGGGGV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Jul 2021 02:06:21 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 06BE7ED1;
        Tue,  6 Jul 2021 23:03:41 -0700 (PDT)
Received: from net-arm-thunderx2-02.shanghai.arm.com (net-arm-thunderx2-02.shanghai.arm.com [10.169.208.211])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 2493F3F5A1;
        Tue,  6 Jul 2021 23:03:36 -0700 (PDT)
From:   Jianlin Lv <Jianlin.Lv@arm.com>
To:     bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Jianlin.Lv@arm.com, iecedge@gmail.com
Subject: [PATCH bpf-next] bpf: runqslower: fixed make install issue
Date:   Wed,  7 Jul 2021 14:03:28 +0800
Message-Id: <20210707060328.3133074-1-Jianlin.Lv@arm.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

runqslower did not define install target, resulting in an installation
tool/bpf error:
	$ make -C tools/bpf/ install

	make[1]: Entering directory './tools/bpf/runqslower'
	make[1]: *** No rule to make target 'install'.  Stop.

Add install target for runqslower.

Signed-off-by: Jianlin Lv <Jianlin.Lv@arm.com>
---
 tools/bpf/runqslower/Makefile | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/tools/bpf/runqslower/Makefile b/tools/bpf/runqslower/Makefile
index 3818ec511fd2..7dd0ae982459 100644
--- a/tools/bpf/runqslower/Makefile
+++ b/tools/bpf/runqslower/Makefile
@@ -1,6 +1,8 @@
 # SPDX-License-Identifier: (LGPL-2.1 OR BSD-2-Clause)
 include ../../scripts/Makefile.include
 
+prefix ?= /usr/local
+
 OUTPUT ?= $(abspath .output)/
 
 BPFTOOL_OUTPUT := $(OUTPUT)bpftool/
@@ -31,9 +33,11 @@ MAKEFLAGS += --no-print-directory
 submake_extras := feature_display=0
 endif
 
+INSTALL ?= install
+
 .DELETE_ON_ERROR:
 
-.PHONY: all clean runqslower
+.PHONY: all clean runqslower install
 all: runqslower
 
 runqslower: $(OUTPUT)/runqslower
@@ -46,6 +50,11 @@ clean:
 	$(Q)$(RM) $(OUTPUT)runqslower
 	$(Q)$(RM) -r .output
 
+install: $(OUTPUT)/runqslower
+	$(call QUIET_INSTALL, runqslower)
+	$(Q)$(INSTALL) -m 0755 -d $(DESTDIR)$(prefix)/sbin
+	$(Q)$(INSTALL) $(OUTPUT)runqslower $(DESTDIR)$(prefix)/sbin/runqslower
+
 $(OUTPUT)/runqslower: $(OUTPUT)/runqslower.o $(BPFOBJ)
 	$(QUIET_LINK)$(CC) $(CFLAGS) $^ -lelf -lz -o $@
 
-- 
2.25.1

