Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E0F2425C81
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 21:45:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241291AbhJGTq5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 15:46:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241231AbhJGTqt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 15:46:49 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB333C06176A
        for <netdev@vger.kernel.org>; Thu,  7 Oct 2021 12:44:52 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id t8so22601790wri.1
        for <netdev@vger.kernel.org>; Thu, 07 Oct 2021 12:44:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+KwuZrvKj/nWbZxwowX3C1brtAZLHPAx17W+Fp0yX54=;
        b=6OhC5VeQI45lNxk40ykwOkdJzdusOv0ml1vSveYKxtXMeO4TZV/S5MgmWa2QHjqMF4
         Om3JIa0qqQvGMeuGAVrLYS1jKwYx6i/CT414wFp86b8TLmwUBCBwr3AvkNIrfHZSpsGN
         U2aMGK1a3rfxZDBj1EBIi1l0nfo3ONlQjj0jcqSyodm5Z6ILmyKY6HY5K7+7mogIc5Q0
         UXhK6GJ+2yWMsyAGRBGs5c0CcEx91hlB3laKtC/30dfmIWC9iMIkUjYgFhyjuHFtn/73
         +GT0d1Ow2C8qE3CqkAOlcJ56+Z6CZUTzdCt5xnsN2o/hFXAwmyGewd7QLJIa8DGa4q4f
         X6CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+KwuZrvKj/nWbZxwowX3C1brtAZLHPAx17W+Fp0yX54=;
        b=F2KUbl619W0mKYfgFUjdZh8/o3I3hsyp08+B6ZLEXPYyNua/BaVuORzU5ZBTRnpOpw
         ySa4znwbtoZTXIMtxeNwGsH4K+RvXFEG62WlY1w2H8LSsMpwLlXcDsDdae2fV3h5E67l
         wsx0KqANivP69uYUttqITOHpDay8SMGN2xKmW77Q4/aL9HDpilLbu072i+29uoYCPgHG
         GarOg2qM3D6WYy45oXM2Q/rjI9/biWpJAN/dVpmcK+RzY01rN/GBI6ZgvMzCRbtxlDCa
         EGlV+U37h6Wu9gLzRYiXGw5jUesyMYM8rqtM2YsgFAcMSzHne8lv2aLG3UCYndFXQ94h
         re8A==
X-Gm-Message-State: AOAM532sE4VPfk9TJkBUzbX9ySGwSqtt6YJPOnj7JdxxkSFxgAQ4MVpm
        0ycYVPILt+ABUFSUYxsRDyytRTNB7lJ3cgzACns=
X-Google-Smtp-Source: ABdhPJzOedJonbjOi4wTULe7rp4mepUjUTH66EyU7qosjmJItOB/D2GJ+1NtDD8b02+51Gvnk6iviQ==
X-Received: by 2002:a05:600c:a05:: with SMTP id z5mr6600316wmp.73.1633635891367;
        Thu, 07 Oct 2021 12:44:51 -0700 (PDT)
Received: from localhost.localdomain ([149.86.87.165])
        by smtp.gmail.com with ESMTPSA id u2sm259747wrr.35.2021.10.07.12.44.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 12:44:51 -0700 (PDT)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next v4 06/12] bpf: preload: install libbpf headers when building
Date:   Thu,  7 Oct 2021 20:44:32 +0100
Message-Id: <20211007194438.34443-7-quentin@isovalent.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211007194438.34443-1-quentin@isovalent.com>
References: <20211007194438.34443-1-quentin@isovalent.com>
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
index 1951332dd15f..469d35e890eb 100644
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
+$(LIBBPF_A): | $(LIBBPF_OUT)
+	$(Q)$(MAKE) -C $(LIBBPF_SRCS) O=$(LIBBPF_OUT)/ OUTPUT=$(LIBBPF_OUT)/   \
+		DESTDIR=$(LIBBPF_DESTDIR) prefix=			       \
+		$(LIBBPF_OUT)/libbpf.a install_headers
+
+libbpf_hdrs: $(LIBBPF_A)
+
+.PHONY: libbpf_hdrs
+
+$(LIBBPF_OUT):
+	$(call msg,MKDIR,$@)
+	$(Q)mkdir -p $@
 
 userccflags += -I $(srctree)/tools/include/ -I $(srctree)/tools/include/uapi \
-	-I $(srctree)/tools/lib/ -Wno-unused-result
+	-I $(LIBBPF_INCLUDE) -Wno-unused-result
 
 userprogs := bpf_preload_umd
 
 clean-files := $(userprogs) bpf_helper_defs.h FEATURE-DUMP.libbpf staticobjs/ feature/
+clean-files += $(LIBBPF_OUT) $(LIBBPF_DESTDIR)
+
+$(obj)/iterators/iterators.o: | libbpf_hdrs
 
 bpf_preload_umd-objs := iterators/iterators.o
 bpf_preload_umd-userldlibs := $(LIBBPF_A) -lelf -lz
-- 
2.30.2

