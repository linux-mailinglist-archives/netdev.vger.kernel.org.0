Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABAAF224EB3
	for <lists+netdev@lfdr.de>; Sun, 19 Jul 2020 04:17:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726642AbgGSCRD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jul 2020 22:17:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726284AbgGSCRC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jul 2020 22:17:02 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34527C0619D2;
        Sat, 18 Jul 2020 19:17:02 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id a14so7312572pfi.2;
        Sat, 18 Jul 2020 19:17:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UKQ+jPswJ6aZORF426luVyMBU9cUsZPqYFTvseLkrPI=;
        b=QeMfzKUCa0/I88fPw+UuWyRXoioRZxeXygfFm1O+FLeceu4YmcQaBO6Nnbkdng42vJ
         HjhFN5fnT+u6IDZIoL4SVRiQHOTmSV9OlTjL7ZwdL5Z1s7OTNNZZcUNLi4K5iwEG0Z3d
         /oJ7K8TEBUh6tLTvav+KJf9l/NQ6e5YV6JlHUgvgVqNWPpldvpISXt5+nCRRkIV1uU7J
         M+DCZLXvgIcDIZCKuaXNVfJxI0uN8E4JQ1vkNPp9VvXHxSVwtmPPKJzAS5GYPWNtvpWf
         VPl/aLdOftDeqryXvU4Xyhm/67mZ9GLl0mRoJZ3ErR8D+pRVZqEsnIVVTuNs5jZFgijN
         uRWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UKQ+jPswJ6aZORF426luVyMBU9cUsZPqYFTvseLkrPI=;
        b=Nhoy5e/BAsI1XLDV9KrK3L0mqcp8fSovcOzR4GvBTUis+DRfRFEHcAUI4KvnIe+qFq
         /RIyfberdS293uiSh66KlwkDNDhhyJziBsC+fXgHMTwsukimYlUbFd1f0o2cT6HOhnyZ
         QOJOWVDqCqkCTsIGr+5AZDHvLkAKlcznDdNjg15ehWrc3UdFSdj9J284hmbJLaAQGQQy
         1bM/nKmm7swZFk/7IRfeCj8EqUcnxBJok/rCltQuv+bsTd8/oZzO7eN2kYTg7zN8j4VI
         +6yuQO+uM4vgdlnVgBDkGOYchw45JoFOc/ys/nooXDLi6b0W3djL60NDo7OPqWIcn6B9
         pgKg==
X-Gm-Message-State: AOAM531elS4IFxuNA+b0rO2oGQ6MVatu/XapkLS0kF9G0O4z7eejyQUP
        moKecmFhD/p8y+mgZtRvhFw=
X-Google-Smtp-Source: ABdhPJxcDyCKYGRJbb5Nov+ZCut8MmvgE/EK7YwVMfVfP0yOwvZUclmD9gj5wL+f/Lxyh4Z8Xahgng==
X-Received: by 2002:a62:7e51:: with SMTP id z78mr14046172pfc.3.1595125021805;
        Sat, 18 Jul 2020 19:17:01 -0700 (PDT)
Received: from octofox.hsd1.ca.comcast.net ([2601:641:400:e00:19b7:f650:7bbe:a7fb])
        by smtp.gmail.com with ESMTPSA id a68sm6891159pje.35.2020.07.18.19.17.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Jul 2020 19:17:01 -0700 (PDT)
From:   Max Filippov <jcmvbkbc@gmail.com>
To:     linux-xtensa@linux-xtensa.org
Cc:     Chris Zankel <chris@zankel.net>, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, Max Filippov <jcmvbkbc@gmail.com>
Subject: [PATCH 1/3] xtensa: expose syscall through user_pt_regs
Date:   Sat, 18 Jul 2020 19:16:52 -0700
Message-Id: <20200719021654.25922-2-jcmvbkbc@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200719021654.25922-1-jcmvbkbc@gmail.com>
References: <20200719021654.25922-1-jcmvbkbc@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use one of the reserved slots in struct user_pt_regs to return syscall
number in the GPR regset. Update syscall number from the GPR regset only
when it's non-zero.

Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
---
 arch/xtensa/include/uapi/asm/ptrace.h | 3 ++-
 arch/xtensa/kernel/ptrace.c           | 4 ++++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/xtensa/include/uapi/asm/ptrace.h b/arch/xtensa/include/uapi/asm/ptrace.h
index 2ec0f9100a06..50db3e0a6341 100644
--- a/arch/xtensa/include/uapi/asm/ptrace.h
+++ b/arch/xtensa/include/uapi/asm/ptrace.h
@@ -50,7 +50,8 @@ struct user_pt_regs {
 	__u32 windowstart;
 	__u32 windowbase;
 	__u32 threadptr;
-	__u32 reserved[7 + 48];
+	__u32 syscall;
+	__u32 reserved[6 + 48];
 	__u32 a[64];
 };
 
diff --git a/arch/xtensa/kernel/ptrace.c b/arch/xtensa/kernel/ptrace.c
index 0278d7dfb4d6..437b4297948d 100644
--- a/arch/xtensa/kernel/ptrace.c
+++ b/arch/xtensa/kernel/ptrace.c
@@ -52,6 +52,7 @@ static int gpr_get(struct task_struct *target,
 		.threadptr = regs->threadptr,
 		.windowbase = regs->windowbase,
 		.windowstart = regs->windowstart,
+		.syscall = regs->syscall,
 	};
 
 	memcpy(newregs.a,
@@ -91,6 +92,9 @@ static int gpr_set(struct task_struct *target,
 	regs->sar = newregs.sar;
 	regs->threadptr = newregs.threadptr;
 
+	if (newregs.syscall)
+		regs->syscall = newregs.syscall;
+
 	if (newregs.windowbase != regs->windowbase ||
 	    newregs.windowstart != regs->windowstart) {
 		u32 rotws, wmask;
-- 
2.20.1

