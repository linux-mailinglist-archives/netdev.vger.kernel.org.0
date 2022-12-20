Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9203652009
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 13:00:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233438AbiLTL77 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 06:59:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233336AbiLTL7n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 06:59:43 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7753917E13;
        Tue, 20 Dec 2022 03:59:42 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id fy4so12214434pjb.0;
        Tue, 20 Dec 2022 03:59:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0ChfKO2eeBoMULr5ewcllVR5YsnxKeW8Y85F/urf2ac=;
        b=lCsRlQYDOx2sddcCaiYgxCKvCzigmio9/pLm2MwR43zRRkivbD1iQ1Y0Suuu+j2hHi
         PAgPg3fPTZ0Pt8unFbCCHo3xfRq8SVMAwQsx9exDb7II71o8OqiWuVJMzEv5CcNrgYb/
         msoLmj9pDELBOGMeKkLJklWIKL9p7JjW07zmeRVU/nbYzRzuEjwuaOaNaH1AzRJrndPb
         GDElWpPbVHuKOy8lU6syu7umesa8p/aOiTbfLXwxttSVQvTF8iBuiR09Zsv6nfiURDIy
         lcTr9C0emMQWax4LSy3bqDho4754z6TDdnDB9JtQXqmkP1+/kVsLE25WDuUiJ4lXlIcC
         Js1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0ChfKO2eeBoMULr5ewcllVR5YsnxKeW8Y85F/urf2ac=;
        b=VB1cbljceNQcvO0Jy3n2XsXUf50UL6mFVKLAbENBlaTVOaAgEmU5FurSf1wAazIYrG
         VOioBBWzII1XLubyIWp1yPng5V5S1k1Sw3pci2u82vRhB+xXhLMC9SDRg4NsqscS1ZRq
         oJNPWVxX6v4g4cIP6K0IU33j7MdHkzrbXuom0+ClRHruULrG56258HTCQR2gQMfVqt/Y
         0jJpi70x/uboGx7vSr9pg+6ycLwqQARa3EGQFP9bxkO6MwaPjceul+ib263rF8h9snl0
         MtqbgiSGHUmtycdjjYhiQMfS3XaOMkYcYkf8R6Wet65274HerJw1zxdZGvuZ7Z2N1O9x
         mtGQ==
X-Gm-Message-State: AFqh2krtP1zKTs9/zcSMBOZ163tSTo04ttX35eEOm/tt2AV63Tb40cZZ
        RcWMXSpAVaVN4ZzGMPI9WA==
X-Google-Smtp-Source: AMrXdXvnmaib6VFB94aIo/5L34sh7JlfjZcfF3Ure3MXIMQ7dAt7O2L8mVmlKnXGA0jcBLJOAq/Ryg==
X-Received: by 2002:a17:90a:d910:b0:213:9bf5:6a10 with SMTP id c16-20020a17090ad91000b002139bf56a10mr13005905pjv.49.1671537582074;
        Tue, 20 Dec 2022 03:59:42 -0800 (PST)
Received: from WDIR.. ([182.209.58.25])
        by smtp.gmail.com with ESMTPSA id z10-20020a17090a170a00b00219752c8ea3sm10982482pjd.48.2022.12.20.03.59.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Dec 2022 03:59:41 -0800 (PST)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Yonghong Song <yhs@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org
Subject: [bpf-next v2 4/5] samples/bpf: fix tracex2 by using BPF_KSYSCALL macro
Date:   Tue, 20 Dec 2022 20:59:27 +0900
Message-Id: <20221220115928.11979-5-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221220115928.11979-1-danieltimlee@gmail.com>
References: <20221220115928.11979-1-danieltimlee@gmail.com>
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
    struct pt_regs *regs = LINUX_HAS_SYSCALL_WRAPPER                    \
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

