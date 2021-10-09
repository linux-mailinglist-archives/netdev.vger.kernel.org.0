Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72CD1427D81
	for <lists+netdev@lfdr.de>; Sat,  9 Oct 2021 23:04:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230469AbhJIVF4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Oct 2021 17:05:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230327AbhJIVFv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Oct 2021 17:05:51 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69E9AC061762
        for <netdev@vger.kernel.org>; Sat,  9 Oct 2021 14:03:54 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id r7so41304263wrc.10
        for <netdev@vger.kernel.org>; Sat, 09 Oct 2021 14:03:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ctY+yofXF/zlJ0MXeGIFlVWxptmFvqmULcdipUPLWuE=;
        b=VYOkRzyceu8W7fkPjPVmT8TrIJC4m4iBYOlyYd3MHaeF0v2tgZIgtrw89kN63OxtPF
         vWEp84ENlhmyGJYV5ejgNFtEKTiCG7o2/BENzj8w0YHEsVJD3fKOX6U7iHc7w5DPAH9D
         y10CfMK2HU/sZLs+6LtTKJeYdwizD9UsfXBvG7pJbJuaLtV2lg2fI8RvzGrXctREimlU
         458XBVssAVJ04kY3O1KTaT/mCHkPdiVlcMdx8GOK+bAsWtRV5RH1QC020Xmix3R+PwMg
         nPpfulfQOIlxH9LJnNk64xt7g1Yx7MJdUy9BFZ3PvtINRRLk0LiN1UiNREss42F0H4cn
         Oixw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ctY+yofXF/zlJ0MXeGIFlVWxptmFvqmULcdipUPLWuE=;
        b=7lFIOjdVYtX7XXpwV6HRbt9R+k5BfBllVspeQWISqwn4n4AM/7TW5hw1aGj0ZScIlg
         U9EOWSssq9v+FhNvqvSS/i9ZNSWLrhp/THyV5TKWsGE31ZRmXgbxJIWYgjwR8DFxxXA3
         6h020OFS8mWi1oAt7qj050nSuN93WZQ9VN6W1Kk6j8ptGa7Nw/ulKuk6KYckxiVFT42t
         +xZoYD9VfpRum/ZhKOTgNFQHBMOYZ4jqI6f/aVAv0joT3OhrI4fGSTB7b09JMiWGZWJ2
         Q64KbhxkgjOclGfxKLaAfy+O4in594Bc/t9NwH1VOEUiBfE+71lDFHA8NFC8waxZDDr8
         C5cA==
X-Gm-Message-State: AOAM530NA5HmJu1VlHU1UoXZZffdtmkW2C9FfExfLLjn6eExJW8k/afv
        xv9C6PdAPgfC5jVCXnoCgdROfA==
X-Google-Smtp-Source: ABdhPJzrF5HgIrfkd8iqvhuZD9Hs0omTZKPedqCb15KPZ2mCLTW74DaZ4j1ZGTil3q7nIXXCMxKhXQ==
X-Received: by 2002:a1c:7f56:: with SMTP id a83mr12241308wmd.20.1633813433041;
        Sat, 09 Oct 2021 14:03:53 -0700 (PDT)
Received: from localhost.localdomain ([149.86.83.130])
        by smtp.gmail.com with ESMTPSA id k128sm3102516wme.41.2021.10.09.14.03.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Oct 2021 14:03:52 -0700 (PDT)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next 3/3] bpftool: turn check on zlib from a phony target into a conditional error
Date:   Sat,  9 Oct 2021 22:03:41 +0100
Message-Id: <20211009210341.6291-4-quentin@isovalent.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211009210341.6291-1-quentin@isovalent.com>
References: <20211009210341.6291-1-quentin@isovalent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

One of bpftool's object files depends on zlib. To make sure we do not
attempt to build that object when the library is not available, commit
d66fa3c70e59 ("tools: bpftool: add feature check for zlib") introduced a
feature check to detect whether zlib is present.

This check comes as a rule for which the target ("zdep") is a
nonexistent file (phony target), which means that the Makefile always
attempts to rebuild it. It is mostly harmless. However, one side effect
is that, on running again once bpftool is already built, make considers
that "something" (the recipe for zdep) was executed, and does not print
the usual message "make: Nothing to be done for 'all'", which is a
user-friendly indicator that the build went fine.

Before, with some level of debugging information:

    $ make --debug=m
    [...]
    Reading makefiles...

    Auto-detecting system features:
    ...                        libbfd: [ on  ]
    ...        disassembler-four-args: [ on  ]
    ...                          zlib: [ on  ]
    ...                        libcap: [ on  ]
    ...               clang-bpf-co-re: [ on  ]

    Updating makefiles....
    Updating goal targets....
     File 'all' does not exist.
           File 'zdep' does not exist.
          Must remake target 'zdep'.
     File 'all' does not exist.
    Must remake target 'all'.
    Successfully remade target file 'all'.

After the patch:

    $ make --debug=m
    [...]

    Auto-detecting system features:
    ...                        libbfd: [ on  ]
    ...        disassembler-four-args: [ on  ]
    ...                          zlib: [ on  ]
    ...                        libcap: [ on  ]
    ...               clang-bpf-co-re: [ on  ]

    Updating makefiles....
    Updating goal targets....
     File 'all' does not exist.
    Must remake target 'all'.
    Successfully remade target file 'all'.
    make: Nothing to be done for 'all'.

(Note the last line, which is not part of make's debug information.)

Signed-off-by: Quentin Monnet <quentin@isovalent.com>
---
 tools/bpf/bpftool/Makefile | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/tools/bpf/bpftool/Makefile b/tools/bpf/bpftool/Makefile
index 4acec74f459b..2174e21aa57b 100644
--- a/tools/bpf/bpftool/Makefile
+++ b/tools/bpf/bpftool/Makefile
@@ -199,7 +199,10 @@ $(BOOTSTRAP_OUTPUT)disasm.o: $(srctree)/kernel/bpf/disasm.c
 $(OUTPUT)disasm.o: $(srctree)/kernel/bpf/disasm.c
 	$(QUIET_CC)$(CC) $(CFLAGS) -c -MMD -o $@ $<
 
-$(OUTPUT)feature.o: | zdep
+$(OUTPUT)feature.o:
+ifneq ($(feature-zlib), 1)
+	$(error "No zlib found")
+endif
 
 $(BPFTOOL_BOOTSTRAP): $(BOOTSTRAP_OBJS) $(LIBBPF_BOOTSTRAP)
 	$(QUIET_LINK)$(HOSTCC) $(CFLAGS) $(LDFLAGS) -o $@ $(BOOTSTRAP_OBJS) \
@@ -255,10 +258,7 @@ doc-uninstall:
 
 FORCE:
 
-zdep:
-	@if [ "$(feature-zlib)" != "1" ]; then echo "No zlib found"; exit 1 ; fi
-
 .SECONDARY:
-.PHONY: all FORCE clean install-bin install uninstall zdep
+.PHONY: all FORCE clean install-bin install uninstall
 .PHONY: doc doc-clean doc-install doc-uninstall
 .DEFAULT_GOAL := all
-- 
2.30.2

