Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABF67A2BD3
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 02:51:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728098AbfH3Av3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 20:51:29 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:43631 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727639AbfH3Auu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 20:50:50 -0400
Received: by mail-lj1-f193.google.com with SMTP id h15so4785690ljg.10
        for <netdev@vger.kernel.org>; Thu, 29 Aug 2019 17:50:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=XM+El1wyypVfaXfQc7FxTfECR5DYv9zUGiXmgC/VC5g=;
        b=OmaVkDBxJbEbiNuH6B/lkHNi7X3Ced5VCYrN4v0FOemALIxV7B1RR9GTxi+wIA+o7S
         SBNyfehZvn7LwSQMr71oX1EDAOy9VvdgFs/9kHugoMQYd2qS/DSS2mvw8yXRcG/xHDV5
         0mJnXZcKmURGOdcozYB23tdigAAVVt6MHRP2J5RqtdSKEIJwvommRUF3YZCu8WcJ+ZRQ
         9xYKzJ+pyiAczzLTKz6YMx84NzIkCgZakeJ1s58kckrg9aSB/Vdpg5FlpqJZCT257v3w
         UK5VqvNfJ4lXH3Sy/1qHZ5bEXEsMC6tIogRp0+fgccQf0ld0ru8mbbg+8L8dATJfDqle
         zUkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=XM+El1wyypVfaXfQc7FxTfECR5DYv9zUGiXmgC/VC5g=;
        b=JIVFoBSBURh3O7fRCJXts75J5+ovSoFxkptnh7OtrhZk8fHpyOUSUj+dBIrb91lPiV
         4Wh0k0i81e9leAA/p1mAB9Qkfq1xkR/7lvJSChcKMRfplptHQFgH1r5d5wMKnHoouJui
         TYTOhLYhb2ZlscLDwPutQLA3cvARqW0h8ivAslR8ab0n5hqm/tAkiAPek07P4gXU6JBU
         O3iwjOGC/WUxr00233iWFPHbqHHaeFYV6STY5RuPKWnt4HKY+U30lOkye7kU6fLC9NaT
         7Oc/EqIRfMsyNoKWMK8Hjgo0PrnKD6WS101d5Imd1T1vhwpGd7XFDnbheqSd5TC/v/+j
         9Q1w==
X-Gm-Message-State: APjAAAXh73NALWOXC8pp9wUfIKJaqXMk/fTLwpQ3CL0KyCPmfttqRq09
        XJrX7VTvfA/qU0mzobBbm41gfQ==
X-Google-Smtp-Source: APXvYqzmBCVvXKFOXoBDuj58+fjrCfnA51PDqBxjQDtiM9x+Qz3HalHYI72Y8f2Nsv+B0cm1QW0ySg==
X-Received: by 2002:a2e:85d4:: with SMTP id h20mr7058874ljj.134.1567126248121;
        Thu, 29 Aug 2019 17:50:48 -0700 (PDT)
Received: from localhost.localdomain (168-200-94-178.pool.ukrtel.net. [178.94.200.168])
        by smtp.gmail.com with ESMTPSA id f19sm628149lfk.43.2019.08.29.17.50.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Aug 2019 17:50:47 -0700 (PDT)
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     linux@armlinux.org.uk, ast@kernel.org, daniel@iogearbox.net,
        yhs@fb.com, davem@davemloft.net, jakub.kicinski@netronome.com,
        hawk@kernel.org, john.fastabend@gmail.com
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Subject: [PATCH RFC bpf-next 05/10] samples: bpf: Makefile: use vars from KBUILD_CFLAGS to handle linux headers
Date:   Fri, 30 Aug 2019 03:50:32 +0300
Message-Id: <20190830005037.24004-6-ivan.khoronzhuk@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190830005037.24004-1-ivan.khoronzhuk@linaro.org>
References: <20190830005037.24004-1-ivan.khoronzhuk@linaro.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The kernel headers are reused from samples bpf, and autoconf.h is not
enough to reflect complete configuration for clang. One of such
configurations is __LINUX_ARM_ARCH__ min version used as instruction
set selector. In another case an error like "SMP is not
supported" for arm and others errors are issued and final object is
not correct.
---
 samples/bpf/Makefile | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index cdd742c05200..9232efa2b1b3 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -186,6 +186,13 @@ HOSTLDLIBS_map_perf_test	+= -lrt
 HOSTLDLIBS_test_overhead	+= -lrt
 HOSTLDLIBS_xdpsock		+= -pthread
 
+# Strip all expet -D options needed to handle linux headers
+# for arm it's __LINUX_ARM_ARCH__ and potentially others fork vars
+D_OPTIONS = $(shell echo "$(KBUILD_CFLAGS) " | sed 's/[[:blank:]]/\n/g' | \
+	sed '/^-D/!d' | tr '\n' ' ')
+
+CLANG_EXTRA_CFLAGS += $(D_OPTIONS)
+
 # Allows pointing LLC/CLANG to a LLVM backend with bpf support, redefine on cmdline:
 #  make samples/bpf/ LLC=~/git/llvm/build/bin/llc CLANG=~/git/llvm/build/bin/clang
 LLC ?= llc
-- 
2.17.1

