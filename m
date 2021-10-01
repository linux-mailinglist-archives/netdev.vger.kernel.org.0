Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B15541EB86
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 13:13:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230461AbhJALPR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 07:15:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353764AbhJALLM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 07:11:12 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E51AEC061775
        for <netdev@vger.kernel.org>; Fri,  1 Oct 2021 04:09:27 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id h15so13256788wrc.3
        for <netdev@vger.kernel.org>; Fri, 01 Oct 2021 04:09:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8rYjsR4oYd2+H7CLxA0fXvPayzXRNWUpXQT+e/NARbQ=;
        b=krTuO5kqPS+qD451lBCB2vBx3VrUOQ3vz1e67XjKCgjDYp9AG9lrn7atxstiwA8ALL
         vbot1WMOKe6bCmQfJQeqLhjTLxJl5tAlEMBnOOskAnoQZ1YMMVwdCvkqKPvnkQbyN8bS
         Mzk3RRvQKDYG7oW2XLPBINwNIWCzEUndKZhNIDupH6+mkpR5l5jYc6mX9CAoFxANAUdp
         cxQf7Uhq7LxUPohpa8+5s9C/8tQhShya5wAjyv/tmoJSimrqEdd2Y4nablCqVLHGJor1
         rjqdvtwg8fkncs76702DjXn1fUc9gJFTML50tNewfpI/vnzse4vvOrhOYY5qnSITakY4
         fHpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8rYjsR4oYd2+H7CLxA0fXvPayzXRNWUpXQT+e/NARbQ=;
        b=zmonlnFl6/o8gKGNYqaT9NzyGR72xFHtcG9LnpslKZRKIXqMepqv9Pj5oMPg9i5wsI
         4zpkV/7sIy62wErWWAcV5v7+MC30PDexMDGxTnmCQZ6Rt7f/WLZq0KmCpGBMoT+z6MNL
         jUlTZhpJRolrsHO9QLtJAh9jNEQ4eVwGYw1yr4LaBHNfII2ILZWbtc5AhDT6xOW05+BM
         0qfJjTwJ17weuaM82lihtRBSoEE8kgknpeARxoXGPlWSoepDmHXYrcD5nUfSvqg58cJP
         VHfG4ghyO5oQ0IvoT6UQybnMJss9rfC2Aqz4WZ8w7Quj5iEFjTBk2Vum9GydOJfLwqDQ
         AL8Q==
X-Gm-Message-State: AOAM532cMcKJbXbCDq573WBk5TddudZMLotAMler9z0GeMNkAjVIIAy7
        T0jZNOUOY7ZuJ5KNEwGF/Lw6og==
X-Google-Smtp-Source: ABdhPJxX3LUK4zAsaabsblX0aFNjMTIQolN4Ao9mX+MCeWgmV/JEz3mlSzOfQzmdOYVTC/XS1vvK7A==
X-Received: by 2002:adf:a2c8:: with SMTP id t8mr8874355wra.215.1633086566508;
        Fri, 01 Oct 2021 04:09:26 -0700 (PDT)
Received: from localhost.localdomain ([149.86.91.69])
        by smtp.gmail.com with ESMTPSA id v17sm5903271wro.34.2021.10.01.04.09.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Oct 2021 04:09:26 -0700 (PDT)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next v2 5/9] bpf: preload: install libbpf headers when building
Date:   Fri,  1 Oct 2021 12:08:52 +0100
Message-Id: <20211001110856.14730-6-quentin@isovalent.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211001110856.14730-1-quentin@isovalent.com>
References: <20211001110856.14730-1-quentin@isovalent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

API headers from libbpf should not be accessed directly from the
library's source directory. Instead, they should be exported with "make
install_headers". Let's make sure that bpf/preload/Makefile installs the
headers properly when building.

Note that we declare an additional dependency for iterators/iterators.o:
having $(LIBBPF_A) as a dependency to "$(obj)/bpf_preload_umd" is not
sufficient, as it makes it required only at the linking step. But we
need libbpf to be compiled, and in particular its headers to be
exported, before we attempt to compile iterators.o. The issue would not
occur before this commit, because libbpf's headers were not exported and
were always available under tools/lib/bpf.

Signed-off-by: Quentin Monnet <quentin@isovalent.com>
---
 kernel/bpf/preload/Makefile | 25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

diff --git a/kernel/bpf/preload/Makefile b/kernel/bpf/preload/Makefile
index 1951332dd15f..e6a94278b935 100644
--- a/kernel/bpf/preload/Makefile
+++ b/kernel/bpf/preload/Makefile
@@ -1,21 +1,36 @@
 # SPDX-License-Identifier: GPL-2.0
 
 LIBBPF_SRCS = $(srctree)/tools/lib/bpf/
-LIBBPF_A = $(obj)/libbpf.a
-LIBBPF_OUT = $(abspath $(obj))
+LIBBPF_OUT = $(abspath $(obj))/libbpf
+LIBBPF_A = $(LIBBPF_OUT)/libbpf.a
+LIBBPF_DESTDIR = $(LIBBPF_OUT)
+LIBBPF_INCLUDE = $(LIBBPF_DESTDIR)/include
 
 # Although not in use by libbpf's Makefile, set $(O) so that the "dummy" test
 # in tools/scripts/Makefile.include always succeeds when building the kernel
 # with $(O) pointing to a relative path, as in "make O=build bindeb-pkg".
-$(LIBBPF_A):
-	$(Q)$(MAKE) -C $(LIBBPF_SRCS) O=$(LIBBPF_OUT)/ OUTPUT=$(LIBBPF_OUT)/ $(LIBBPF_OUT)/libbpf.a
+$(LIBBPF_A): | $(LIBBPF_OUT) $(LIBBPF_INCLUDE)
+	$(Q)$(MAKE) -C $(LIBBPF_SRCS) O=$(LIBBPF_OUT)/ OUTPUT=$(LIBBPF_OUT)/   \
+		DESTDIR=$(LIBBPF_DESTDIR) prefix=			       \
+		$(LIBBPF_OUT)/libbpf.a install_headers
+
+libbpf-hdrs: $(LIBBPF_A)
+
+.PHONY: libbpf-hdrs
+
+$(LIBBPF_OUT) $(LIBBPF_INCLUDE):
+	$(call msg,MKDIR,$@)
+	$(Q)mkdir -p $@
 
 userccflags += -I $(srctree)/tools/include/ -I $(srctree)/tools/include/uapi \
-	-I $(srctree)/tools/lib/ -Wno-unused-result
+	-I $(LIBBPF_INCLUDE) -Wno-unused-result
 
 userprogs := bpf_preload_umd
 
 clean-files := $(userprogs) bpf_helper_defs.h FEATURE-DUMP.libbpf staticobjs/ feature/
+clean-files += $(LIBBPF_OUT) $(LIBBPF_DESTDIR)
+
+$(obj)/iterators/iterators.o: libbpf-hdrs
 
 bpf_preload_umd-objs := iterators/iterators.o
 bpf_preload_umd-userldlibs := $(LIBBPF_A) -lelf -lz
-- 
2.30.2

