Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28D3A525904
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 02:41:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232110AbiEMAlX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 20:41:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231351AbiEMAlW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 20:41:22 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47A2E5EDDB
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 17:41:21 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id x23-20020a170902b41700b0015ea144789fso3499260plr.13
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 17:41:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=PLHfkBps8/NN/F93wiTb1I9xCzDthCPlSjntIH72rDE=;
        b=I8afDsMFlizjC2WkKw9nEOj2vMJgklTATaw1Hsa/SWTOmJqlD7HHRMFbRFXtiK5hKb
         eWR68srOtf34zMu8hRlFofRBQy/Kzvf9bIK5KmrMoPCtMhuNUIreuIDMCS0+HR7A97qA
         4norc+7XY3Ry8c2YsW8H6ig1JhvGZVoetaN6esBwKE9GsFTgHy0aQb6TWGqWqT5+iagi
         u0NOcqhn2xj8lDeq6QVIGMfypdzYQUXj/zwLC7cAmZdjvcQbS1bZDx2o2Swcm1uJ7M+H
         MVP3texpB2djiZrBiw8E2Hcwgk3Wb3yQENmoEoJRD1eEtwku11QHqpbk9WVB9zxfdH3a
         fmmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=PLHfkBps8/NN/F93wiTb1I9xCzDthCPlSjntIH72rDE=;
        b=tyv1w0g6HEOFPAuqUeWB5O6XTYi663onP8Fx7CyhJFxUXK76BPfzMSpSosnkIynU+K
         VXhV4UFqKQhbG0hfoh24j+BV+SYjFFRcduF2JW56Cj2zCO6QPDvauZQoZuhPabBNoY0g
         mhuXE0Fx1ot4g6JxqfKctfGMfTl3HORW2zj2EqX4g2xML4nNNH9MGfIY7Qg8KBRTTpU2
         mR+LpwGctOFcBQVeUOJmqewG0DWmbjFnrGzOtWZ6JL/4YuOsZkvMLjkk0SknHfzirT+T
         rp0m/QVph1eZItSyXYYAYShzqsou1OEdIXnwgFMG+hkqcCjgRAPGkKKthlU8XWNx94J/
         LOuQ==
X-Gm-Message-State: AOAM530UtH3WoYmH67o7g1v9I0NoBj/cOZTKPDm8dq14n9F0T+6Gt7jy
        FP7po/v/meR1+Hv1c26dn2m+4OAwnyHCFrfW
X-Google-Smtp-Source: ABdhPJyNqg86E2DPDFz9cP8m9RIs4OnDIdJI8SHawkmDOi6DsBWOzE4x5CksBx4CuyRBczY8XM/fFtpwNsdQ7jWf
X-Received: from yosry.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2327])
 (user=yosryahmed job=sendgmr) by 2002:a17:90b:4b42:b0:1dc:15f8:821b with SMTP
 id mi2-20020a17090b4b4200b001dc15f8821bmr13529101pjb.131.1652402480734; Thu,
 12 May 2022 17:41:20 -0700 (PDT)
Date:   Fri, 13 May 2022 00:41:17 +0000
Message-Id: <20220513004117.364577-1-yosryahmed@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.0.550.gb090851708-goog
Subject: [PATCH bpf-next] selftests/bpf: fix building bpf selftests statically
From:   Yosry Ahmed <yosryahmed@google.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yosry Ahmed <yosryahmed@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

bpf selftests can no longer be built with CFLAGS=-static with
liburandom_read.so and its dependent target.

Filter out -static for liburandom_read.so and its dependent target.

Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
---
 tools/testing/selftests/bpf/Makefile | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 6bbc03161544..4eaefc187d5b 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -168,14 +168,17 @@ $(OUTPUT)/%:%.c
 	$(call msg,BINARY,,$@)
 	$(Q)$(LINK.c) $^ $(LDLIBS) -o $@
 
+# If the tests are being built statically, exclude dynamic libraries defined
+# in this Makefile and their dependencies.
+DYNAMIC_CFLAGS := $(filter-out -static,$(CFLAGS))
 $(OUTPUT)/liburandom_read.so: urandom_read_lib1.c urandom_read_lib2.c
 	$(call msg,LIB,,$@)
-	$(Q)$(CC) $(CFLAGS) -fPIC $(LDFLAGS) $^ $(LDLIBS) --shared -o $@
+	$(Q)$(CC) $(DYNAMIC_CFLAGS) -fPIC $(LDFLAGS) $^ $(LDLIBS) --shared -o $@
 
 $(OUTPUT)/urandom_read: urandom_read.c urandom_read_aux.c $(OUTPUT)/liburandom_read.so
 	$(call msg,BINARY,,$@)
-	$(Q)$(CC) $(CFLAGS) $(LDFLAGS) $(filter %.c,$^)			       \
-		  liburandom_read.so $(LDLIBS)	       			       \
+	$(Q)$(CC) $(DYNAMIC_CFLAGS) $(LDFLAGS) $(filter %.c,$^)			\
+		  liburandom_read.so $(LDLIBS)					\
 		  -Wl,-rpath=. -Wl,--build-id=sha1 -o $@
 
 $(OUTPUT)/bpf_testmod.ko: $(VMLINUX_BTF) $(wildcard bpf_testmod/Makefile bpf_testmod/*.[ch])
-- 
2.36.0.550.gb090851708-goog

