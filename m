Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A353118510A
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 22:24:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727579AbgCMVYM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 17:24:12 -0400
Received: from mail-il1-f194.google.com ([209.85.166.194]:32912 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727563AbgCMVYI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 17:24:08 -0400
Received: by mail-il1-f194.google.com with SMTP id k29so10532193ilg.0
        for <netdev@vger.kernel.org>; Fri, 13 Mar 2020 14:24:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nh1n7M+VPSrWcMXPYIV91GLW2l6TAX14rIs4m1q72Xw=;
        b=Efks9xuN/oML/BqvA8mL5/SGY7ASxmBkfpBAscYoHao8obdSNy14z5ctKJ/W9oel+D
         Y/vAz9m+Efw7hAsy6BcaEKiS4tQFLBGtQGmLVLAm2ZFhf8eGvlu38VJ8OF6T30m5TzyH
         SAu2lauGOxX81iwxVtgjsYUKlVbdYx57cgbj4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nh1n7M+VPSrWcMXPYIV91GLW2l6TAX14rIs4m1q72Xw=;
        b=sYz4JwtctJeQojLt6RrhkiaYRqTGtl7ZmwRN8DmOBYfrRVBexXUX//b0VkWN3ha0o8
         Q6Z79+2rYGui8QgIGp28oQmDTHhkKoKt75J8/eRgnwKsFeBR81sXeaTH8Bn8sp1MHGHg
         iMC2gePtOQMDOL+Sje2ruPP7vPwby1D4T31piUb5tAEgfPTGaIv74AWqDYlxWnpOXOpK
         C0yvCUqBxqlIxIk+3pDCsunLlgEKueyGNSw1RUZqpRiJGYenD2Br15Mj8DEdtLvcluA4
         k9SOosAJX5ulyaGqod9fSitPC/OrApk84BNPEtZ8/NKmwdKVXpCOrkLy4o2aQTDKtBZE
         sN3Q==
X-Gm-Message-State: ANhLgQ2ofReha5keKVbgRP2+mgp8BvRO7PQoFaKF4EUVao8H4723m4p5
        27BpOV/MfktLQNu8dr5dE/Xt0Q==
X-Google-Smtp-Source: ADFU+vuNMKlTjRy366EcWR9ptiTfmLmVzeHxrmdb75AGQiAghLVYgPBSaZofsKRoLtZ4NCp+pGIgbw==
X-Received: by 2002:a92:5fc5:: with SMTP id i66mr15532167ill.303.1584134646641;
        Fri, 13 Mar 2020 14:24:06 -0700 (PDT)
Received: from shuah-t480s.internal (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id y8sm6824029iot.14.2020.03.13.14.24.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2020 14:24:05 -0700 (PDT)
From:   Shuah Khan <skhan@linuxfoundation.org>
To:     shuah@kernel.org, keescook@chromium.org, luto@amacapital.net,
        wad@chromium.org, daniel@iogearbox.net, kafai@fb.com, yhs@fb.com,
        andriin@fb.com, gregkh@linuxfoundation.org, tglx@linutronix.de
Cc:     Shuah Khan <skhan@linuxfoundation.org>, khilman@baylibre.com,
        mpe@ellerman.id.au, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH v3] selftests: Fix seccomp to support relocatable build (O=objdir)
Date:   Fri, 13 Mar 2020 15:24:04 -0600
Message-Id: <20200313212404.24552-1-skhan@linuxfoundation.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix seccomp relocatable builds. This is a simple fix to use the right
lib.mk variable TEST_GEN_PROGS with dependency on kselftest_harness.h
header, and defining LDFLAGS for pthread lib.

Removes custom clean rule which is no longer necessary with the use of
TEST_GEN_PROGS. 

Uses $(OUTPUT) defined in lib.mk to handle build relocation.

The following use-cases work with this change:

In seccomp directory:
make all and make clean

From top level from main Makefile:
make kselftest-install O=objdir ARCH=arm64 HOSTCC=gcc \
 CROSS_COMPILE=aarch64-linux-gnu- TARGETS=seccomp

Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
---

Changes since v2:
-- Using TEST_GEN_PROGS is sufficient to generate objects.
   Addresses review comments from Kees Cook.

 tools/testing/selftests/seccomp/Makefile | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/seccomp/Makefile b/tools/testing/selftests/seccomp/Makefile
index 1760b3e39730..a0388fd2c3f2 100644
--- a/tools/testing/selftests/seccomp/Makefile
+++ b/tools/testing/selftests/seccomp/Makefile
@@ -1,17 +1,15 @@
 # SPDX-License-Identifier: GPL-2.0
-all:
-
-include ../lib.mk
+CFLAGS += -Wl,-no-as-needed -Wall
+LDFLAGS += -lpthread
 
 .PHONY: all clean
 
-BINARIES := seccomp_bpf seccomp_benchmark
-CFLAGS += -Wl,-no-as-needed -Wall
+include ../lib.mk
+
+# OUTPUT set by lib.mk
+TEST_GEN_PROGS := $(OUTPUT)/seccomp_bpf $(OUTPUT)/seccomp_benchmark
 
-seccomp_bpf: seccomp_bpf.c ../kselftest_harness.h
-	$(CC) $(CFLAGS) $(LDFLAGS) $< -lpthread -o $@
+$(TEST_GEN_PROGS): ../kselftest_harness.h
 
-TEST_PROGS += $(BINARIES)
-EXTRA_CLEAN := $(BINARIES)
+all: $(TEST_GEN_PROGS)
 
-all: $(BINARIES)
-- 
2.20.1

