Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94E1443E1EF
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 15:20:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230334AbhJ1NXX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 09:23:23 -0400
Received: from mail-lf1-f44.google.com ([209.85.167.44]:39434 "EHLO
        mail-lf1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230297AbhJ1NXT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 09:23:19 -0400
Received: by mail-lf1-f44.google.com with SMTP id l13so13543454lfg.6;
        Thu, 28 Oct 2021 06:20:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3PZBfQ2VLBVQ+FScckJP/YM1qLVydE5D6300dI/9Uj0=;
        b=QBfiqgL3IW/1dpypqwxWlwp60lKS2nH5uBq/vcTEz58FNxxQqz3PjZbF4o/PfqUA7t
         f+NtGG7Gb7zVCgjxOfGwB18gJIoDWyV2mFvvkTv0p2/oCbRptHv49JgwHv+t90OSlvk5
         UwlPIM0NnQcmkM6rY1eJijZZkneU+EVgC4l7g5kSRbyu+raLesFSy1DhD8F43vzfRj/T
         geqYvK5/ZZ8wr0rjaGKX8O9lo/GIw+0EWB+4ucvANaO3XkfQ29n8ILGsKAuDSi4YjfXf
         JRkXipFwQBYYsEHVMG8akuW5pxqgivjwukmb/SevbwCqoLn2hS+5OAtODvAXdahPiE20
         7lFw==
X-Gm-Message-State: AOAM530ltxcgQWrhgua0wZkaizyLwk4Zh6g0D+X+hN6ZleguKwThcm3x
        pVW4QzwpHfUkhOPHhGIV6lc=
X-Google-Smtp-Source: ABdhPJxfNRrAhW5xushlBQeEd0Em0sopu17I+MiQ1/8I8I+S67KskkgZ+epYCfCrm5NfnUNj6YVqHA==
X-Received: by 2002:a05:6512:2309:: with SMTP id o9mr4155941lfu.124.1635427251319;
        Thu, 28 Oct 2021 06:20:51 -0700 (PDT)
Received: from kladdkakan.. ([185.213.154.234])
        by smtp.gmail.com with ESMTPSA id o9sm309616lfk.292.2021.10.28.06.20.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Oct 2021 06:20:50 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        linux-riscv@lists.infradead.org
Subject: [PATCH bpf-next 4/4] selftests/bpf: Fix broken riscv build
Date:   Thu, 28 Oct 2021 15:20:41 +0200
Message-Id: <20211028132041.516820-5-bjorn@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211028132041.516820-1-bjorn@kernel.org>
References: <20211028132041.516820-1-bjorn@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is closely related to commit 6016df8fe874 ("selftests/bpf:
Fix broken riscv build"). When clang includes the system include
directories, but targeting BPF program, __BITS_PER_LONG defaults to
32, unless explicitly set. Workaround this problem, by explicitly
setting __BITS_PER_LONG to __riscv_xlen.

Signed-off-by: Björn Töpel <bjorn@kernel.org>
---
 tools/testing/selftests/bpf/Makefile | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index ac47cf9760fc..d739e62d0f90 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -277,7 +277,8 @@ $(RESOLVE_BTFIDS): $(HOST_BPFOBJ) | $(HOST_BUILD_DIR)/resolve_btfids	\
 define get_sys_includes
 $(shell $(1) -v -E - </dev/null 2>&1 \
 	| sed -n '/<...> search starts here:/,/End of search list./{ s| \(/.*\)|-idirafter \1|p }') \
-$(shell $(1) -dM -E - </dev/null | grep '#define __riscv_xlen ' | sed 's/#define /-D/' | sed 's/ /=/')
+$(shell $(1) -dM -E - </dev/null | grep '__riscv_xlen ' | awk '{printf("-D__riscv_xlen=%d -D__BITS_PER_LONG=%d", $$3, $$3)}')
+
 endef
 
 # Determine target endianness.
-- 
2.32.0

