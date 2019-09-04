Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED066A94F5
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 23:23:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730404AbfIDVXJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 17:23:09 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:45650 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730269AbfIDVXJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Sep 2019 17:23:09 -0400
Received: by mail-lj1-f193.google.com with SMTP id l1so153018lji.12
        for <netdev@vger.kernel.org>; Wed, 04 Sep 2019 14:23:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=XM+El1wyypVfaXfQc7FxTfECR5DYv9zUGiXmgC/VC5g=;
        b=Qrn6kZhSPCRIfWPLbZQrXvK6lt7Iv2mnBJ9fLUFe1bB8d3A93TcSi0pQ7aJIbrRhRF
         VqBxOcqXvHmwM6B4nLPwZFInG3Lbs0ucLsOPQ7EWJ2SK5XqHUKTssZhdnQhNplsuEwSY
         x5Svyb5v24/nMZRgCDOGvj1X2TKa9ghB3bZt/+JUncKf7znkKi7UrsFYe2VfXlLM1Pw6
         NdwK4iRuxsJnwFPInX7J5KfhCI19YZdPS/RrG1yxKH0/a/oOXRnDwEqfffdjpoAtOtZK
         I3CsCCXI734MGwDY9NZOTAFvNZ0ReU4TmWIEZK55u9m5rg9WFEW+C4nVp1ngSBNzeEKQ
         AHEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=XM+El1wyypVfaXfQc7FxTfECR5DYv9zUGiXmgC/VC5g=;
        b=cKZfQEdF7Sac+TyWN3SC4lZHBp32t9aAdrxYOe+YPP7RqajKlDSkk4R3AbjivoPWG0
         T1UMRnupGvzXCNcjpBzwtisDPdTC9RXx4dUlsBLLzLFU2GzJhDhJmPvDywMytr13JMBj
         rbxejg5qWqUw7aaNnM93UhRpWx53f2aTXvm1yFAgddW+lHlHdOz+bh/tJNbP5xwqSOWG
         UjZdrccBqoWi3SRNdDFJPmbVZK5tgsd6ui1PwYshrS408Lg1AN+skfEPvgASGIqsxlcS
         oOs0Tuz2WAQ8AU77kMEvkc7gY48QXTaPdbnTuVqKaWEP5x28w5STB1P32s2E6+7FPxEJ
         usow==
X-Gm-Message-State: APjAAAXBAJS//NbzAR9IjxKfdbtag1PFjQV/eGCviiYiIrNWnB36X5Gl
        6Uz3TNXHHPKrjvMOToTqva8l0Q==
X-Google-Smtp-Source: APXvYqwIOnqTkM1LhhufRjTOuTPHB2CyE/gtuygYAHmjcLBABKdvZsgxu+PbqoUb8CLszPPiRIjm+w==
X-Received: by 2002:a2e:9a82:: with SMTP id p2mr24383354lji.64.1567632187076;
        Wed, 04 Sep 2019 14:23:07 -0700 (PDT)
Received: from localhost.localdomain (168-200-94-178.pool.ukrtel.net. [178.94.200.168])
        by smtp.gmail.com with ESMTPSA id s8sm3540836ljd.94.2019.09.04.14.23.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Sep 2019 14:23:06 -0700 (PDT)
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     ast@kernel.org, daniel@iogearbox.net, yhs@fb.com,
        davem@davemloft.net, jakub.kicinski@netronome.com, hawk@kernel.org,
        john.fastabend@gmail.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, clang-built-linux@googlegroups.com,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Subject: [PATCH bpf-next 5/8] samples: bpf: Makefile: use vars from KBUILD_CFLAGS to handle linux headers
Date:   Thu,  5 Sep 2019 00:22:09 +0300
Message-Id: <20190904212212.13052-6-ivan.khoronzhuk@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190904212212.13052-1-ivan.khoronzhuk@linaro.org>
References: <20190904212212.13052-1-ivan.khoronzhuk@linaro.org>
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

