Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5033427D7F
	for <lists+netdev@lfdr.de>; Sat,  9 Oct 2021 23:04:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231161AbhJIVFx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Oct 2021 17:05:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230456AbhJIVFv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Oct 2021 17:05:51 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96687C061762
        for <netdev@vger.kernel.org>; Sat,  9 Oct 2021 14:03:53 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id e12so41342658wra.4
        for <netdev@vger.kernel.org>; Sat, 09 Oct 2021 14:03:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tIexbe7G0YKMe1CwdKXK5X9VCycFErTnEJUFWFOr7tk=;
        b=29JsiVqzyMgyMHqnJIHvomcrEghh6Xp0mZP92qjUUz1tBZNvdHvJ4IvK7ev0T1OdON
         Rqsl+BUkAok2GsYh6gxtRE3PBsAE6ACvdNZRTTNlCSjiH0NNqZqsmDrwvoSKtdGRxbm6
         hbSoFC+1SM7POJMkp/CL3sVdQSUUc0c1+9Al4Hn7Xfxg4wx9U839AlQYdgg02CdzXAQy
         3MCB6QtWWE1MKxPmvi2fVfE6BNuu83B4q5i5p5fUQUUKmJJOIfL4t2wCwIP0MZA7gKXj
         bd9BxcI+3Y7V6ArNfF8g1OOM8CzOBRwDndEUflHrExcoXLk0lgMZAn1rCjNT3GTAYadT
         CEVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tIexbe7G0YKMe1CwdKXK5X9VCycFErTnEJUFWFOr7tk=;
        b=btshQ2ITzxiAqrqCaio2S/UAOo18HfLuh2eA3i07s0R2AGa+eOON0aEjRyatlMso9Y
         uIGqBmN0wvqbbCIkiLzTTuQI7114ed7Onl1MUceBroAxD2hokeFVV0C/c1q2k4JsN2Gb
         HWVsTVBEMaDsM5xcZoIbUWuUblMLZCBApxFhDCTlYBVZDRyrecZYyRi70kzM5VJ5+S/G
         vD8tKviuj8Md/iufewlVl9DOWIYuAiQiqFgYro1jPbv+s2RFWkWiYydlo+fq56g1lWWR
         m4I8PAWa/9/YerKGfHdSjJageU4fktGXjYwNZmt0443gFDy7VR4lI2ksZFPXP4wb5NGP
         s3Qw==
X-Gm-Message-State: AOAM531W7WrpNY92H7Ja7KoaivB+aGfIkQj80l6kxBqtE/8TDkUl6pAK
        LD1XG+4HthO7wagZ+6imq1nA3A==
X-Google-Smtp-Source: ABdhPJzLAeAwCpeyveL4h9rYhm3L3FXh7tJgRLbN63rKGYYBLuslUuzV8reb4oYn8Tv+4sGmY1YZEA==
X-Received: by 2002:a7b:c441:: with SMTP id l1mr11373264wmi.69.1633813432190;
        Sat, 09 Oct 2021 14:03:52 -0700 (PDT)
Received: from localhost.localdomain ([149.86.83.130])
        by smtp.gmail.com with ESMTPSA id k128sm3102516wme.41.2021.10.09.14.03.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Oct 2021 14:03:51 -0700 (PDT)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next 2/3] bpftool: do not FORCE-build libbpf
Date:   Sat,  9 Oct 2021 22:03:40 +0100
Message-Id: <20211009210341.6291-3-quentin@isovalent.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211009210341.6291-1-quentin@isovalent.com>
References: <20211009210341.6291-1-quentin@isovalent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In bpftool's Makefile, libbpf has a FORCE dependency, to make sure we
rebuild it in case its source files changed. Let's instead make the
rebuild depend on the source files directly, through a call to the
"$(wildcard ...)" function. This avoids descending into libbpf's
directory if there is nothing to update.

Do the same for the bootstrap libbpf version.

This results in a slightly faster operation and less verbose output when
running make a second time in bpftool's directory.

Before:

    Auto-detecting system features:
    ...                        libbfd: [ on  ]
    ...        disassembler-four-args: [ on  ]
    ...                          zlib: [ on  ]
    ...                        libcap: [ on  ]
    ...               clang-bpf-co-re: [ on  ]

    make[1]: Entering directory '/root/dev/linux/tools/lib/bpf'
    make[1]: Entering directory '/root/dev/linux/tools/lib/bpf'
    make[1]: Nothing to be done for 'install_headers'.
    make[1]: Leaving directory '/root/dev/linux/tools/lib/bpf'
    make[1]: Leaving directory '/root/dev/linux/tools/lib/bpf'

After:

    Auto-detecting system features:
    ...                        libbfd: [ on  ]
    ...        disassembler-four-args: [ on  ]
    ...                          zlib: [ on  ]
    ...                        libcap: [ on  ]
    ...               clang-bpf-co-re: [ on  ]

Other ways to clean up the output could be to pass the "-s" option, or
to redirect the output to >/dev/null, when calling make recursively to
descend into libbpf's directory. However, this would suppress some
useful output if something goes wrong during the build. A better
alternative would be to pass "--no-print-directory" to the recursive
make, but that would still leave us with some noise for
"install_headers". Skipping the descent into libbpf's directory if no
source file has changed works best, and seems the most logical option
overall.

Reported-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Quentin Monnet <quentin@isovalent.com>
---
 tools/bpf/bpftool/Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/bpf/bpftool/Makefile b/tools/bpf/bpftool/Makefile
index 2c510293f32b..4acec74f459b 100644
--- a/tools/bpf/bpftool/Makefile
+++ b/tools/bpf/bpftool/Makefile
@@ -43,7 +43,7 @@ endif
 $(LIBBPF_OUTPUT) $(BOOTSTRAP_OUTPUT) $(LIBBPF_BOOTSTRAP_OUTPUT):
 	$(QUIET_MKDIR)mkdir -p $@
 
-$(LIBBPF): FORCE | $(LIBBPF_OUTPUT)
+$(LIBBPF): $(wildcard $(BPF_DIR)/*.[ch] $(BPF_DIR)/Makefile) | $(LIBBPF_OUTPUT)
 	$(Q)$(MAKE) -C $(BPF_DIR) OUTPUT=$(LIBBPF_OUTPUT) \
 		DESTDIR=$(LIBBPF_DESTDIR) prefix= $(LIBBPF) install_headers
 
@@ -51,7 +51,7 @@ $(LIBBPF_INTERNAL_HDRS): $(LIBBPF_HDRS_DIR)/%.h: $(BPF_DIR)/%.h $(LIBBPF)
 	$(call QUIET_INSTALL, $@)
 	$(Q)install -m 644 -t $(LIBBPF_HDRS_DIR) $<
 
-$(LIBBPF_BOOTSTRAP): FORCE | $(LIBBPF_BOOTSTRAP_OUTPUT)
+$(LIBBPF_BOOTSTRAP): $(wildcard $(BPF_DIR)/*.[ch] $(BPF_DIR)/Makefile) | $(LIBBPF_BOOTSTRAP_OUTPUT)
 	$(Q)$(MAKE) -C $(BPF_DIR) OUTPUT=$(LIBBPF_BOOTSTRAP_OUTPUT) \
 		ARCH= CC=$(HOSTCC) LD=$(HOSTLD) $@
 
-- 
2.30.2

