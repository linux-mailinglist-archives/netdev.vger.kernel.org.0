Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7FD936A371
	for <lists+netdev@lfdr.de>; Sun, 25 Apr 2021 00:17:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230210AbhDXWRp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Apr 2021 18:17:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229730AbhDXWRm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Apr 2021 18:17:42 -0400
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 243B4C061574;
        Sat, 24 Apr 2021 15:17:02 -0700 (PDT)
Received: by mail-qt1-x82a.google.com with SMTP id u8so38921543qtq.12;
        Sat, 24 Apr 2021 15:17:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HQHroiY1imSgCq9jOEwzvyvDcHUhWnRty0vg2BtbJsg=;
        b=D4yztm5iazarzBHH/iiinWS8TGHyfHcPBhBrLoNMUb4v1VHQg4C8+3xA88elVsY34Y
         51GH3VMouGqMpc9g7GW6cpJg/uVIYQ2La3hXTvYTrvSQdwcBsrNn6wLFypk09tUPWxnA
         y/Yda2xhOdA+BqqDk+Yqu2WFeMfPeFDjzyBC7nxuqfZ3tgICR+twRGwxBI54GcXaJpgT
         SixOvjX7/b9hgoXoFfjEAPqX6KYeAXibRiVGU1lVQpnrSn8hjMVQSJ2BpdfQWZOYInRg
         YkMejkv5yzsGXEKJqR/O2e5y48PReQKyiQxyfRcXeeanuuYlOag6Ew7u0wN7/HPji/8K
         hMjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HQHroiY1imSgCq9jOEwzvyvDcHUhWnRty0vg2BtbJsg=;
        b=UqXtWgCU2PfAJecxUsszO6pVt1BQwx8KamJiFz2pj2Qq2dUIdMn5ufKDBGV/YLe721
         jbNLLkUemPmTifWkS7HvzmxkLJcw0e1dRNQZhp2n/dqapZnTc/7IPQCFxtz8JCkNCwdk
         POBg/bPDFIAq4n41411NLYfNq3IFmg6kW0ntfGp8j7HT/eMtD2p54vTKIukQ8qGKsiN5
         3ppeDLkmYYQzY6mODky3IIskb7e8Vn6StuTWG4LQvxehNDldRhTjmLIrvUAlkaaHBlKK
         uuO4/YnbTWgXzC2rjGUPWDrXG+TYNgS2T2RZ08qJEAWf0x6RY2tDtLwFyryer2sQqI1O
         WL+A==
X-Gm-Message-State: AOAM530nDLn8ncmV85C1Qs2TjuZxcBF0KPufi2yySEU2hZRpFtEPYyLo
        6RwaK0ZE9c55Q0gL+SWECRQ=
X-Google-Smtp-Source: ABdhPJzh4sjZHOPAifUecywP85IuMnkSllo82CH6kktCMI1YcrKgFDXyu9v4ztaykHcQmkILJr2EBw==
X-Received: by 2002:ac8:7453:: with SMTP id h19mr1754006qtr.89.1619302621242;
        Sat, 24 Apr 2021 15:17:01 -0700 (PDT)
Received: from localhost.localdomain ([179.218.4.27])
        by smtp.gmail.com with ESMTPSA id k11sm1070764qth.34.2021.04.24.15.16.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Apr 2021 15:17:00 -0700 (PDT)
From:   Pedro Tammela <pctammela@gmail.com>
X-Google-Original-From: Pedro Tammela <pctammela@mojatatu.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH bpf-next] libbpf: handle ENOTSUPP errno in libbpf_strerror()
Date:   Sat, 24 Apr 2021 19:16:48 -0300
Message-Id: <20210424221648.809525-1-pctammela@mojatatu.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 'bpf()' syscall is leaking the ENOTSUPP errno that is internal to the kernel[1].
More recent code is already using the correct EOPNOTSUPP, but changing
older return codes is not possible due to dependency concerns, so handle ENOTSUPP
in libbpf_strerror().

[1] https://lore.kernel.org/netdev/20200511165319.2251678-1-kuba@kernel.org/

Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
---
 tools/lib/bpf/libbpf_errno.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/tools/lib/bpf/libbpf_errno.c b/tools/lib/bpf/libbpf_errno.c
index 0afb51f7a919..7de8bbc34a37 100644
--- a/tools/lib/bpf/libbpf_errno.c
+++ b/tools/lib/bpf/libbpf_errno.c
@@ -13,6 +13,9 @@
 
 #include "libbpf.h"
 
+/* This errno is internal to the kernel but leaks in the bpf() syscall. */
+#define ENOTSUPP 524
+
 /* make sure libbpf doesn't use kernel-only integer typedefs */
 #pragma GCC poison u8 u16 u32 u64 s8 s16 s32 s64
 
@@ -43,6 +46,12 @@ int libbpf_strerror(int err, char *buf, size_t size)
 
 	err = err > 0 ? err : -err;
 
+	if (err == ENOTSUPP) {
+		snprintf(buf, size, "Operation not supported");
+		buf[size - 1] = '\0';
+		return 0;
+	}
+
 	if (err < __LIBBPF_ERRNO__START) {
 		int ret;
 
-- 
2.25.1

