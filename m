Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEC865054AF
	for <lists+netdev@lfdr.de>; Mon, 18 Apr 2022 15:22:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232643AbiDRNMC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 09:12:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243231AbiDRNJ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 09:09:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2770637A07;
        Mon, 18 Apr 2022 05:49:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 91DA2B80EE7;
        Mon, 18 Apr 2022 12:49:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C345BC385A1;
        Mon, 18 Apr 2022 12:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650286148;
        bh=wT4/WeIwjYBzff+W5ZOYqpym7Y597fnbp/CAYefVOIE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sgjn8gsRszB6q4ey1OP/i5SzwAo5b60Dtcb7gpMpCZZV82QYAPyEcXKZZjZK9rlgV
         K+fUMDnTzqiaFrYyAQujbrgYQEbGEL5zcUuPsVq8jILIGkxMThZ7smJUyZk0nRWBbP
         S/8NhCSCWiDX3AEzy/gNF0Sssb4JXfkNT3QxVcNuSXp0rJ00pl9+6bO1qreOrUlvtu
         AO5dCuXrj+yCkWKa6wPqmi0shzqXCycS76wM/mni9vqxhF/NgjuFFOTlLtw3vRLa3r
         z8fngrW8+fpq823RjavNKC0GzI2nNryfYc5zP+3DeAg0GixTPx3UOou6Av3SN6G6AN
         f+fU2Ns2C7FVA==
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
Subject: [PATCHv2 bpf-next 3/4] bpf: Resolve symbols with kallsyms_lookup_names for kprobe multi link
Date:   Mon, 18 Apr 2022 14:48:33 +0200
Message-Id: <20220418124834.829064-4-jolsa@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220418124834.829064-1-jolsa@kernel.org>
References: <20220418124834.829064-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
 kernel/trace/bpf_trace.c | 113 +++++++++++++++++++++++----------------
 1 file changed, 67 insertions(+), 46 deletions(-)

diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index b26f3da943de..f49cdc46a21f 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -2226,6 +2226,60 @@ struct bpf_kprobe_multi_run_ctx {
 	unsigned long entry_ip;
 };
 
+struct user_syms {
+	const char **syms;
+	char *buf;
+};
+
+static int copy_user_syms(struct user_syms *us, unsigned long __user *usyms, u32 cnt)
+{
+	unsigned long __user usymbol;
+	const char **syms = NULL;
+	char *buf = NULL, *p;
+	int err = -EFAULT;
+	unsigned int i;
+
+	err = -ENOMEM;
+	syms = kvmalloc(cnt * sizeof(*syms), GFP_KERNEL);
+	if (!syms)
+		goto error;
+
+	buf = kvmalloc(cnt * KSYM_NAME_LEN, GFP_KERNEL);
+	if (!buf)
+		goto error;
+
+	for (p = buf, i = 0; i < cnt; i++) {
+		if (__get_user(usymbol, usyms + i)) {
+			err = -EFAULT;
+			goto error;
+		}
+		err = strncpy_from_user(p, (const char __user *) usymbol, KSYM_NAME_LEN);
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
@@ -2346,53 +2400,12 @@ kprobe_multi_link_handler(struct fprobe *fp, unsigned long entry_ip,
 	kprobe_multi_link_prog_run(link, entry_ip, regs);
 }
 
-static int
-kprobe_multi_resolve_syms(const void __user *usyms, u32 cnt,
-			  unsigned long *addrs)
+static int symbols_cmp(const void *a, const void *b)
 {
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
+	const char **str_a = (const char **) a;
+	const char **str_b = (const char **) b;
 
-	err = 0;
-error:
-	kvfree(syms);
-	kfree(func);
-	return err;
+	return strcmp(*str_a, *str_b);
 }
 
 int bpf_kprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *prog)
@@ -2438,7 +2451,15 @@ int bpf_kprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *pr
 			goto error;
 		}
 	} else {
-		err = kprobe_multi_resolve_syms(usyms, cnt, addrs);
+		struct user_syms us;
+
+		err = copy_user_syms(&us, usyms, cnt);
+		if (err)
+			goto error;
+
+		sort(us.syms, cnt, sizeof(*us.syms), symbols_cmp, NULL);
+		err = kallsyms_lookup_names(us.syms, cnt, addrs);
+		free_user_syms(&us);
 		if (err)
 			goto error;
 	}
-- 
2.35.1

