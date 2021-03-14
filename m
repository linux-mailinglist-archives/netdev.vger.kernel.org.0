Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBF7A33A729
	for <lists+netdev@lfdr.de>; Sun, 14 Mar 2021 18:39:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234014AbhCNRjX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Mar 2021 13:39:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233389AbhCNRjH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Mar 2021 13:39:07 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A04F6C061574;
        Sun, 14 Mar 2021 10:39:06 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id e18so4540120wrt.6;
        Sun, 14 Mar 2021 10:39:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hNWBwhuI0AHRidi+s+MGosFzATRCjrsmhXasCqbT4Qs=;
        b=iVXLmI/61VGGXXeP4l0wjwakPsQAXIZnV48xiGf+O2mXJsGnlzi/V40Yi0KsMkiHzf
         XFbOW+NmlFo+3RwefqGTOXojiqBp8jCQDEn6ubJ7beJfxrv8s0Ue/PEACfZOoX2cVn9R
         3vS3/wcrNeR13F/Eq2BwW7D0RaGCt1fazTAEjCY55ygfmWETNdopYxDQt9gDORsmmpdQ
         pzeeR5RF0Xj4LP658ogLnxjTovVT2phOOF6tgM1ReHv7Eo++SQsOV6pTWREI2T1WVE7j
         E+Jr2a3tXWunMQyTrTH6jyrWdeFCccCeD6wiV8aUBwMR11wNtdnoLBGISx+u1h2dt7tn
         rwEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hNWBwhuI0AHRidi+s+MGosFzATRCjrsmhXasCqbT4Qs=;
        b=a6a2u+qvo7vLijGuUZmjjYYum8X0IGu04HCLKh+/LsUW7fCir32/Z58brymQhvEKkp
         o1h5R3lPN0y5Uy6O9dCL2ooY0XMMHyauK2JHNwcjt/VfcIv1lfSqqxISOCy4nI1kgbBK
         Fy1USV/plQj+lzR/cYd/uaHXVICSOmC4ze+gQ+vVuW+h4Ex9n7e2KelENfpviKZfm3Nd
         z5NXLjyN3qIDu8EC8MZCEvl08HzTFScliXDdBB8E1GS58XLLY2TKTBssBUHT4jLA+C2c
         ur6TlWabyZO9UF9L17ESWOC9P515VfF0T6d6WjEsSWYReVTSCXD7m8swiVAIxfz6/2gw
         7wDQ==
X-Gm-Message-State: AOAM530Rz2Vd3A8bEBSIcktYiVL9y7/jOSwmVQzrbjXBiyBo/htKQWmw
        A+dSGrvmCYj6eH2ebTpS3jg=
X-Google-Smtp-Source: ABdhPJxQjMUriIN2tpZfCxlT3J2V/hpCqxd4Ris5EcHo5BpayhIvf0qnrKnU613nLBekw1JXmCQ5LQ==
X-Received: by 2002:adf:9f54:: with SMTP id f20mr23912737wrg.362.1615743545258;
        Sun, 14 Mar 2021 10:39:05 -0700 (PDT)
Received: from localhost.localdomain (228-193-142-46.pool.kielnet.net. [46.142.193.228])
        by smtp.gmail.com with ESMTPSA id u63sm9935158wmg.24.2021.03.14.10.39.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Mar 2021 10:39:04 -0700 (PDT)
From:   Pedro Tammela <pctammela@gmail.com>
Cc:     Pedro Tammela <pctammela@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: [PATCH] libbpf: avoid inline hint definition from 'linux/stddef.h'
Date:   Sun, 14 Mar 2021 18:38:38 +0100
Message-Id: <20210314173839.457768-1-pctammela@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Linux headers might pull 'linux/stddef.h' which defines
'__always_inline' as the following:

   #ifndef __always_inline
   #define __always_inline __inline__
   #endif

This becomes an issue if the program picks up the 'linux/stddef.h'
definition as the macro now just hints inline to clang.

This change now enforces the proper definition for BPF programs
regardless of the include order.

Signed-off-by: Pedro Tammela <pctammela@gmail.com>
---
 tools/lib/bpf/bpf_helpers.h | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/tools/lib/bpf/bpf_helpers.h b/tools/lib/bpf/bpf_helpers.h
index ae6c975e0b87..5fa483c0b508 100644
--- a/tools/lib/bpf/bpf_helpers.h
+++ b/tools/lib/bpf/bpf_helpers.h
@@ -29,9 +29,12 @@
  */
 #define SEC(NAME) __attribute__((section(NAME), used))
 
-#ifndef __always_inline
+/*
+ * Avoid 'linux/stddef.h' definition of '__always_inline'.
+ */
+#undef __always_inline
 #define __always_inline inline __attribute__((always_inline))
-#endif
+
 #ifndef __noinline
 #define __noinline __attribute__((noinline))
 #endif
-- 
2.25.1

