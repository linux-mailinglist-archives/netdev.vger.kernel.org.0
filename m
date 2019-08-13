Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0C258AC04
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 02:38:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726557AbfHMAin (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 20:38:43 -0400
Received: from lekensteyn.nl ([178.21.112.251]:44991 "EHLO lekensteyn.nl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726200AbfHMAim (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Aug 2019 20:38:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lekensteyn.nl; s=s2048-2015-q1;
        h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:Cc:To:From; bh=ONKDn6aMI9lJO/Tg9ivj+IvjyVhldVXDlzxa/+6/nwA=;
        b=ciGHFGjsC7qnZMLdiBjHYqSU9xq28rmQDxN3nrBjPNHhVPEJQApdWpGuUZDplUu+oxAlKbBzqbXpmxQIxXrWl71Ayo4R9ofChfBsRHVPnPqh2LyipMQ7ImSDxPnEuc7Bov/yDC4mxcQyet4xL8uleYhezQoDHkanBpV9unjs4ZYHEQoZot2pi/8L+pUWLwsynhljz6m4o7cE/ODKDgPm9yG01FuisI4ixVV0bsLOG5tpmmUGlUBlQZ01AOHfQjEH/FrEUfvhJAMs3PfaDe+V+HSRbcBKN4ngh151uS4SN905j44K/GZm7vC1+wVZmWpB/OqGux0g7HeKHV1SOHfEgw==;
Received: by lekensteyn.nl with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.84_2)
        (envelope-from <peter@lekensteyn.nl>)
        id 1hxKpe-0004yD-VU; Tue, 13 Aug 2019 02:38:35 +0200
From:   Peter Wu <peter@lekensteyn.nl>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Stanislav Fomichev <sdf@google.com>,
        Alexei Starovoitov <ast@kernel.org>, netdev@vger.kernel.org,
        Quentin Monnet <quentin.monnet@netronome.com>
Subject: [PATCH] tools: bpftool: add feature check for zlib
Date:   Tue, 13 Aug 2019 01:38:32 +0100
Message-Id: <20190813003833.22042-1-peter@lekensteyn.nl>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -0.0 (/)
X-Spam-Status: No, hits=-0.0 required=5.0 tests=NO_RELAYS=-0.001 autolearn=unavailable autolearn_force=no
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

bpftool requires libelf, and zlib for decompressing /proc/config.gz.
zlib is a transitive dependency via libelf, and became mandatory since
elfutils 0.165 (Jan 2016). The feature check of libelf is already done
in the elfdep target of tools/lib/bpf/Makefile, pulled in by bpftool via
a dependency on libbpf.a. Add a similar feature check for zlib.

Suggested-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Peter Wu <peter@lekensteyn.nl>
---
Hi,

This is a follow-up for an earlier "tools: bpftool: fix reading from
/proc/config.gz" patch. It applies Jakub and Daniel suggestions from:
https://lkml.kernel.org/r/6154af6c-4f24-4b0a-25c2-a8a1d6c9948f@iogearbox.net
https://lkml.kernel.org/r/20190809140956.24369b00@cakuba.netronome.com

Feel free to massage the commit message and patch as you see fit.

Kind regards,
Peter
---
 tools/bpf/bpftool/Makefile | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/tools/bpf/bpftool/Makefile b/tools/bpf/bpftool/Makefile
index 078bd0dcfba5..4c9d1ffc3fc7 100644
--- a/tools/bpf/bpftool/Makefile
+++ b/tools/bpf/bpftool/Makefile
@@ -58,8 +58,8 @@ INSTALL ?= install
 RM ?= rm -f
 
 FEATURE_USER = .bpftool
-FEATURE_TESTS = libbfd disassembler-four-args reallocarray
-FEATURE_DISPLAY = libbfd disassembler-four-args
+FEATURE_TESTS = libbfd disassembler-four-args reallocarray zlib
+FEATURE_DISPLAY = libbfd disassembler-four-args zlib
 
 check_feat := 1
 NON_CHECK_FEAT_TARGETS := clean uninstall doc doc-clean doc-install doc-uninstall
@@ -111,6 +111,8 @@ OBJS = $(patsubst %.c,$(OUTPUT)%.o,$(SRCS)) $(OUTPUT)disasm.o
 $(OUTPUT)disasm.o: $(srctree)/kernel/bpf/disasm.c
 	$(QUIET_CC)$(COMPILE.c) -MMD -o $@ $<
 
+$(OUTPUT)feature.o: | zdep
+
 $(OUTPUT)bpftool: $(OBJS) $(LIBBPF)
 	$(QUIET_LINK)$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $^ $(LIBS)
 
@@ -149,6 +151,9 @@ doc-uninstall:
 
 FORCE:
 
-.PHONY: all FORCE clean install uninstall
+zdep:
+	@if [ "$(feature-zlib)" != "1" ]; then echo "No zlib found"; exit 1 ; fi
+
+.PHONY: all FORCE clean install uninstall zdep
 .PHONY: doc doc-clean doc-install doc-uninstall
 .DEFAULT_GOAL := all
-- 
2.22.0

