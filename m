Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 486F143E5D4
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 18:11:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230271AbhJ1QNk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 12:13:40 -0400
Received: from mail-lj1-f177.google.com ([209.85.208.177]:44566 "EHLO
        mail-lj1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230264AbhJ1QNj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 12:13:39 -0400
Received: by mail-lj1-f177.google.com with SMTP id s19so11565550ljj.11;
        Thu, 28 Oct 2021 09:11:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=j6s4f8YcjDD+CpjBx7PKIl2wBVCSaaLbyqkYVC2ZnxY=;
        b=kcTrugjEqx9lZeq89EKg3LdIQUTSvMjO5UUxKKvcMNEwsHz1RU4hQ5gmQbtzJa1tvY
         qzVplb4ZMd9LoRS4GdJPtAw2/4OynQDr90Mvlvg7E6Y32c5/wGKLHzXupfWJ1Uc3375p
         wkAIQRmYGFYojO+YX7wTgTXUuT/JnRaMA+C9N/38gg02nlyotinYHBC0VQ5NtYu4n9dB
         tKI3bOHh3OP2cS6QMIhMsYfLb1ZfjTOWIewsslNG5rl6xd5yr73/7KQXzHZE2jY7CmMK
         MQO0iMo63lSHP7UVWeuYy+2VylA+ZukmOcP/Pn/Qbc0eYuFDhfkr5Ck4HTC5LW960U6n
         J0DQ==
X-Gm-Message-State: AOAM531OUQ9EDF9mZlIZ4YxlTe2kdECh7Ag2+qEQyRbkUKSIB04t5eME
        LSEHtigrniCn+6gQlHQ/TrM=
X-Google-Smtp-Source: ABdhPJw9RfKTCTjLi4ZdAxhCHFhQ9JTLQ3uevQ/FREeI82pyLvcRUqHuDKshzgx3UPpTSz84y1xMrQ==
X-Received: by 2002:a2e:a48c:: with SMTP id h12mr5583843lji.221.1635437471276;
        Thu, 28 Oct 2021 09:11:11 -0700 (PDT)
Received: from kladdkakan.. ([193.138.218.162])
        by smtp.gmail.com with ESMTPSA id o17sm49680lfo.176.2021.10.28.09.11.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Oct 2021 09:11:10 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        luke.r.nels@gmail.com, xi.wang@gmail.com,
        linux-riscv@lists.infradead.org
Subject: [PATCH bpf-next v2 4/4] selftests/bpf: Fix broken riscv build
Date:   Thu, 28 Oct 2021 18:10:57 +0200
Message-Id: <20211028161057.520552-5-bjorn@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211028161057.520552-1-bjorn@kernel.org>
References: <20211028161057.520552-1-bjorn@kernel.org>
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
 tools/testing/selftests/bpf/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index ac47cf9760fc..88e2a975352b 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -277,7 +277,7 @@ $(RESOLVE_BTFIDS): $(HOST_BPFOBJ) | $(HOST_BUILD_DIR)/resolve_btfids	\
 define get_sys_includes
 $(shell $(1) -v -E - </dev/null 2>&1 \
 	| sed -n '/<...> search starts here:/,/End of search list./{ s| \(/.*\)|-idirafter \1|p }') \
-$(shell $(1) -dM -E - </dev/null | grep '#define __riscv_xlen ' | sed 's/#define /-D/' | sed 's/ /=/')
+$(shell $(1) -dM -E - </dev/null | grep '__riscv_xlen ' | awk '{printf("-D__riscv_xlen=%d -D__BITS_PER_LONG=%d", $$3, $$3)}')
 endef
 
 # Determine target endianness.
-- 
2.32.0

