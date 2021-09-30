Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C70AB41D8E3
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 13:34:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350558AbhI3Lf4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 07:35:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350526AbhI3Lft (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 07:35:49 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B60BCC06176A
        for <netdev@vger.kernel.org>; Thu, 30 Sep 2021 04:34:06 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id d6so9463297wrc.11
        for <netdev@vger.kernel.org>; Thu, 30 Sep 2021 04:34:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1ohEWFIw0gYyuvZVDbecSO6WgVKzNHomVIL1cNaawDg=;
        b=WEsEGhEQqVOOewcHHyRFPeKT3TjHWlIQr+5FqUZWKsIfYMVffw984mqie3NjFS0lf7
         xqiP9IRd5AMR7Eopq8rn9FkbxQjb9g9iIZ5sSl6d6S/JzXvlTkn8gx/zdHPmddSAM942
         6iGWb+2YvJp81Sf/nK+ufWJrTSepIL67HVQFDs8RoI8xgBpyjC/TavILbFjNcfuEJYkG
         RjhFApP+GRQfNp3xqv2eImPofM+dm6rLKjiJRuzrrBBIe6gezq9HLymZqNstDSRIAOqY
         rcgodN41D90zmFpkI5iKO28w6uXH00CeeBv8hyvvHiVR/urXhJ94la9gjBS8W5R66jDs
         vLqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1ohEWFIw0gYyuvZVDbecSO6WgVKzNHomVIL1cNaawDg=;
        b=wOR8KTWwtKEZRCB5sJRBrGhduutUzo7vl7JzvDggkcF+aTjv1CjjJyLO6y04qwSHue
         jLWcxq4Q/mw8qBuTXAu4I7eWf1eanBWHcQsaG/yo/RHQ41idrE9K2huntHtjeRga2R6z
         u7/540miWJh4AHwKhFatl+ZZB2NQ4JNPu4s7g+SdCbVvUIC9xqTJd4u7QJ8djWa54aVh
         hqEslJiVs4ALVQR482Yit7JRdcGu9d0ordSOW5TXf4+WwmyRPyALYdl26Kw7xdpn04St
         6FPQrllGEgw8oNVvvEUSzCiNgkroK095587DBM0vrzVz0J9iFRnWkV7WlXpmUbJSOEks
         nr0g==
X-Gm-Message-State: AOAM5318SLFhyynBrluV1tvBpi5PHC574hJ5SZZVhnzy9tCiOsgyrNcz
        M0h7AAzQQ/koyVq6x9Eq3VUc7g==
X-Google-Smtp-Source: ABdhPJy5H8pfNbZf1zrQx5LnMdoExDVflbxGTPvim2lQeZWrmAUzltCSz25M/39ZHLfP7slISCCkWQ==
X-Received: by 2002:a5d:648f:: with SMTP id o15mr5618877wri.338.1633001645407;
        Thu, 30 Sep 2021 04:34:05 -0700 (PDT)
Received: from localhost.localdomain ([149.86.91.95])
        by smtp.gmail.com with ESMTPSA id v10sm2904660wrm.71.2021.09.30.04.34.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Sep 2021 04:34:04 -0700 (PDT)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next 5/9] bpf: preload: install libbpf headers when building
Date:   Thu, 30 Sep 2021 12:33:02 +0100
Message-Id: <20210930113306.14950-6-quentin@isovalent.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210930113306.14950-1-quentin@isovalent.com>
References: <20210930113306.14950-1-quentin@isovalent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

API headers from libbpf should not be accessed directly from the
library's source directory. Instead, they should be exported with "make
install_headers". Let's make sure that bpf/preload/Makefile installs the
headers properly when building.

Signed-off-by: Quentin Monnet <quentin@isovalent.com>
---
 kernel/bpf/preload/Makefile | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/kernel/bpf/preload/Makefile b/kernel/bpf/preload/Makefile
index 1951332dd15f..b04d8e61e5ad 100644
--- a/kernel/bpf/preload/Makefile
+++ b/kernel/bpf/preload/Makefile
@@ -1,21 +1,30 @@
 # SPDX-License-Identifier: GPL-2.0
 
 LIBBPF_SRCS = $(srctree)/tools/lib/bpf/
-LIBBPF_A = $(obj)/libbpf.a
-LIBBPF_OUT = $(abspath $(obj))
+LIBBPF_A = $(obj)/libbpf/libbpf.a
+LIBBPF_OUT = $(abspath $(obj))/libbpf
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
+$(LIBBPF_OUT) $(LIBBPF_INCLUDE):
+	$(call msg,MKDIR,$@)
+	$(Q)mkdir -p $@
 
 userccflags += -I $(srctree)/tools/include/ -I $(srctree)/tools/include/uapi \
-	-I $(srctree)/tools/lib/ -Wno-unused-result
+	-I $(LIBBPF_INCLUDE) -Wno-unused-result
 
 userprogs := bpf_preload_umd
 
 clean-files := $(userprogs) bpf_helper_defs.h FEATURE-DUMP.libbpf staticobjs/ feature/
+clean-files += $(LIBBPF_OUT) $(LIBBPF_DESTDIR)
 
 bpf_preload_umd-objs := iterators/iterators.o
 bpf_preload_umd-userldlibs := $(LIBBPF_A) -lelf -lz
-- 
2.30.2

