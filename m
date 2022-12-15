Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 699A864DA8B
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 12:40:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230135AbiLOLkA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 06:40:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229991AbiLOLjw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 06:39:52 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C6A8DF39;
        Thu, 15 Dec 2022 03:39:51 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id 130so6498746pfu.8;
        Thu, 15 Dec 2022 03:39:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0ChfKO2eeBoMULr5ewcllVR5YsnxKeW8Y85F/urf2ac=;
        b=e/Y+2rVeHXDKt9O8Wx/6DflmFtL0LREic6nM3+5xkCdLLthHERyyR/Z29M6tbg6BtM
         KN4Ki1Lkc7KXw7Oz1/bAff+jBcN9YUIGXIAiXIPHYoBSojaTNTqUGl0Vhayd0rUK8zce
         U1+kSf3nxOgLbA3m4XuKfwL+LpedGoRDdmsMRE2JRFKu/u2C6ke8SrRCK8vO58pk+99q
         k1khFm+fe0OEuCSaD5RuIdF4Qpl1uekXxghB9nB8Axwx87BSV6de0CpSNiOYV1OSTFqv
         Q5vzRoe2X6mYtqLsasT5uhr3ZIAx72JrjwBUOWY8TaMkpbbisDtG1UX334KId6m3Vbz3
         JQAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0ChfKO2eeBoMULr5ewcllVR5YsnxKeW8Y85F/urf2ac=;
        b=XN5hL/ixf/gOPn4rbjIraJrxG+B/g1FC0zBKoIhndXt8+T5CG1Lc0kxSlwxfyyCdhL
         IreJ6xG4LhhmgroHfuaxAX4o7iuoIWkGJe7hd+248SzM/fo4/LTp0ACIHTspjDhow+Q9
         g3VGOAxZ//iWke2sapG/G00hWckxXRnP2sJSjaBHyBU8tinsEnwa9sldJT/e8sQ7zcAx
         4z5JlnhZQ5b9yEr0k9QugH3U9rJPY/0R3gTE5bIupXwJ/jeMiO8qR0fxPEjFPdq4Dvo8
         jfg0O65eAyrkYptkNjQU7DuEfuO6jlese60p/1piuuApgZpk7l6fvcXG7THuMy9b9/Cf
         ZKCA==
X-Gm-Message-State: ANoB5pkwz1Ep+3Hv4SJJMlznkOQEJ37LKeXz1OgWw+9QvDrGUaGACQXA
        qkvc1RscjN3uw7it+l7kZA==
X-Google-Smtp-Source: AA0mqf71maOgQmAvxcIiWTnYWiZ7ofyksf15hry1jADArQrKSbv63Gv/E1U5y0F2LpzjRuaHDuCwFQ==
X-Received: by 2002:a05:6a00:1687:b0:56b:f566:600f with SMTP id k7-20020a056a00168700b0056bf566600fmr37179673pfc.12.1671104390895;
        Thu, 15 Dec 2022 03:39:50 -0800 (PST)
Received: from WDIR.. ([182.209.58.25])
        by smtp.gmail.com with ESMTPSA id g30-20020aa79dde000000b00574d38f4d37sm1553440pfq.45.2022.12.15.03.39.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Dec 2022 03:39:50 -0800 (PST)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Yonghong Song <yhs@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org
Subject: [bpf-next 4/5] samples: bpf: fix tracex2 by using BPF_KSYSCALL macro
Date:   Thu, 15 Dec 2022 20:39:36 +0900
Message-Id: <20221215113937.113936-5-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221215113937.113936-1-danieltimlee@gmail.com>
References: <20221215113937.113936-1-danieltimlee@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, there is a problem with tracex2, as it doesn't print the
histogram properly and the results are misleading. (all results report
as 0)

The problem is caused by a change in arguments of the function to which
the kprobe connects. This tracex2 bpf program uses kprobe (attached
to __x64_sys_write) to figure out the size of the write system call. In
order to achieve this, the third argument 'count' must be intact.

The following is a prototype of the sys_write variant. (checked with
pfunct)

    ~/git/linux$ pfunct -P fs/read_write.o | grep sys_write
    ssize_t ksys_write(unsigned int fd, const char  * buf, size_t count);
    long int __x64_sys_write(const struct pt_regs  * regs);
    ... cross compile with s390x ...
    long int __s390_sys_write(struct pt_regs * regs);

Since the nature of SYSCALL_WRAPPER function wraps the argument once,
additional process of argument extraction is required to properly parse
the argument.

    #define BPF_KSYSCALL(name, args...)
    ... snip ...
    struct pt_regs *regs = LINUX_HAS_SYSCALL_WRAPPER        \
			   ? (struct pt_regs *)PT_REGS_PARM1(ctx)       \
			   : ctx;                                       \

In order to fix this problem, the BPF_SYSCALL macro has been used. This
reduces the hassle of parsing arguments from pt_regs. Since the macro
uses the CORE version of argument extraction, additional portability
comes too.

Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
---
 samples/bpf/tracex2.bpf.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/samples/bpf/tracex2.bpf.c b/samples/bpf/tracex2.bpf.c
index a712eefc742e..0a5c75b367be 100644
--- a/samples/bpf/tracex2.bpf.c
+++ b/samples/bpf/tracex2.bpf.c
@@ -8,6 +8,7 @@
 #include <linux/version.h>
 #include <bpf/bpf_helpers.h>
 #include <bpf/bpf_tracing.h>
+#include <bpf/bpf_core_read.h>
 
 struct {
 	__uint(type, BPF_MAP_TYPE_HASH);
@@ -76,14 +77,13 @@ struct {
 } my_hist_map SEC(".maps");
 
 SEC("ksyscall/write")
-int bpf_prog3(struct pt_regs *ctx)
+int BPF_KSYSCALL(bpf_prog3, unsigned int fd, const char *buf, size_t count)
 {
-	long write_size = PT_REGS_PARM3(ctx);
 	long init_val = 1;
 	long *value;
 	struct hist_key key;
 
-	key.index = log2l(write_size);
+	key.index = log2l(count);
 	key.pid_tgid = bpf_get_current_pid_tgid();
 	key.uid_gid = bpf_get_current_uid_gid();
 	bpf_get_current_comm(&key.comm, sizeof(key.comm));
-- 
2.34.1

