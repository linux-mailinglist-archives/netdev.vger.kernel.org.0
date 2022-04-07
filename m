Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2573D4F7F90
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 14:53:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245523AbiDGMz2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 08:55:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245522AbiDGMzZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 08:55:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFBFA259B78;
        Thu,  7 Apr 2022 05:53:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 91E80B82762;
        Thu,  7 Apr 2022 12:53:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1CFAC385A4;
        Thu,  7 Apr 2022 12:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649335994;
        bh=fUlOg+eV0hgirN13ZBDx1VtaVDLRtjWEM/8pa4q0EIU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NCJSN+sZKR/lnVJn7SaGKRiJmcjHrPqZ++AeOQsspqgvlUInvzrIY42t/5H0eJtmj
         N/dVf3Dv+UQQ3LFXT2J8QXwlvCxv+0uviZsjFkLUtAPy4ECYIUew9VipbJACEnQN+P
         QgtfogYOk4nY3QSWUWJF2FrbHlQ2AgdBi/S+3NNm5KzQeQT5GdCDZxNzmdpkn0WiAt
         5WGPrSPBWiI5wgNr+WGAnE+BkIn4BX5gfFQsAxH5SnzZUPE11TO8uMg6kpja5AMFUj
         XiG3iClF+2WhWPHkLYsVbVy7uyTlS3v9YmsTVGHXgqqpT+e65HjxDSANV8H9wRi7r7
         w1F6sbeNMoxiA==
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: [RFC bpf-next 3/4] bpf: Resolve symbols with kallsyms_lookup_names for kprobe multi link
Date:   Thu,  7 Apr 2022 14:52:23 +0200
Message-Id: <20220407125224.310255-4-jolsa@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220407125224.310255-1-jolsa@kernel.org>
References: <20220407125224.310255-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Using kallsyms_lookup_names function to speed up symbols lookup in
kprobe multi link attachment and replacing with it the current
kprobe_multi_resolve_syms function.

This speeds up bpftrace kprobe attachment:

  # perf stat -r 5 -e cycles ./src/bpftrace -e 'kprobe:x* {  } i:ms:1 { exit(); }'
  ...
  6.5681 +- 0.0225 seconds time elapsed  ( +-  0.34% )

After:

  # perf stat -r 5 -e cycles ./src/bpftrace -e 'kprobe:x* {  } i:ms:1 { exit(); }'
  ...
  0.5661 +- 0.0275 seconds time elapsed  ( +-  4.85% )

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 kernel/trace/bpf_trace.c | 123 +++++++++++++++++++++++----------------
 1 file changed, 73 insertions(+), 50 deletions(-)

diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index b26f3da943de..2602957225ba 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -2226,6 +2226,72 @@ struct bpf_kprobe_multi_run_ctx {
 	unsigned long entry_ip;
 };
 
+struct user_syms {
+	const char **syms;
+	char *buf;
+};
+
+static int copy_user_syms(struct user_syms *us, void __user *usyms, u32 cnt)
+{
+	const char __user **usyms_copy = NULL;
+	const char **syms = NULL;
+	char *buf = NULL, *p;
+	int err = -EFAULT;
+	unsigned int i;
+	size_t size;
+
+	size = cnt * sizeof(*usyms_copy);
+
+	usyms_copy = kvmalloc(size, GFP_KERNEL);
+	if (!usyms_copy)
+		return -ENOMEM;
+
+	if (copy_from_user(usyms_copy, usyms, size))
+		goto error;
+
+	err = -ENOMEM;
+	syms = kvmalloc(size, GFP_KERNEL);
+	if (!syms)
+		goto error;
+
+	/* TODO this potentially allocates lot of memory (~6MB in my tests
+	 * with attaching ~40k functions). I haven't seen this to fail yet,
+	 * but it could be changed to allocate memory gradually if needed.
+	 */
+	size = cnt * KSYM_NAME_LEN;
+	buf = kvmalloc(size, GFP_KERNEL);
+	if (!buf)
+		goto error;
+
+	for (p = buf, i = 0; i < cnt; i++) {
+		err = strncpy_from_user(p, usyms_copy[i], KSYM_NAME_LEN);
+		if (err == KSYM_NAME_LEN)
+			err = -E2BIG;
+		if (err < 0)
+			goto error;
+		syms[i] = p;
+		p += err + 1;
+	}
+
+	err = 0;
+	us->syms = syms;
+	us->buf = buf;
+
+error:
+	kvfree(usyms_copy);
+	if (err) {
+		kvfree(syms);
+		kvfree(buf);
+	}
+	return err;
+}
+
+static void free_user_syms(struct user_syms *us)
+{
+	kvfree(us->syms);
+	kvfree(us->buf);
+}
+
 static void bpf_kprobe_multi_link_release(struct bpf_link *link)
 {
 	struct bpf_kprobe_multi_link *kmulti_link;
@@ -2346,55 +2412,6 @@ kprobe_multi_link_handler(struct fprobe *fp, unsigned long entry_ip,
 	kprobe_multi_link_prog_run(link, entry_ip, regs);
 }
 
-static int
-kprobe_multi_resolve_syms(const void __user *usyms, u32 cnt,
-			  unsigned long *addrs)
-{
-	unsigned long addr, size;
-	const char __user **syms;
-	int err = -ENOMEM;
-	unsigned int i;
-	char *func;
-
-	size = cnt * sizeof(*syms);
-	syms = kvzalloc(size, GFP_KERNEL);
-	if (!syms)
-		return -ENOMEM;
-
-	func = kmalloc(KSYM_NAME_LEN, GFP_KERNEL);
-	if (!func)
-		goto error;
-
-	if (copy_from_user(syms, usyms, size)) {
-		err = -EFAULT;
-		goto error;
-	}
-
-	for (i = 0; i < cnt; i++) {
-		err = strncpy_from_user(func, syms[i], KSYM_NAME_LEN);
-		if (err == KSYM_NAME_LEN)
-			err = -E2BIG;
-		if (err < 0)
-			goto error;
-		err = -EINVAL;
-		addr = kallsyms_lookup_name(func);
-		if (!addr)
-			goto error;
-		if (!kallsyms_lookup_size_offset(addr, &size, NULL))
-			goto error;
-		addr = ftrace_location_range(addr, addr + size - 1);
-		if (!addr)
-			goto error;
-		addrs[i] = addr;
-	}
-
-	err = 0;
-error:
-	kvfree(syms);
-	kfree(func);
-	return err;
-}
-
 int bpf_kprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *prog)
 {
 	struct bpf_kprobe_multi_link *link = NULL;
@@ -2438,7 +2455,13 @@ int bpf_kprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *pr
 			goto error;
 		}
 	} else {
-		err = kprobe_multi_resolve_syms(usyms, cnt, addrs);
+		struct user_syms us;
+
+		err = copy_user_syms(&us, usyms, cnt);
+		if (err)
+			goto error;
+		err = kallsyms_lookup_names(us.syms, cnt, addrs);
+		free_user_syms(&us);
 		if (err)
 			goto error;
 	}
-- 
2.35.1

