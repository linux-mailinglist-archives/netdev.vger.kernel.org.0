Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94CEE512444
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 23:04:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237114AbiD0VII (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 17:08:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237034AbiD0VHs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 17:07:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F87B5469D;
        Wed, 27 Apr 2022 14:04:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 161F261D92;
        Wed, 27 Apr 2022 21:04:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 901FAC385A7;
        Wed, 27 Apr 2022 21:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651093472;
        bh=+LByHrrtf81CwdaFC5DHRS/xfMmBXs2eEoWjFB8FU1Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JJF32/fiY26jTfo/FK05J6ZxCPw/xMV2k3xlhlc95AAqdlM0rZXA6eiA4M8ogKOLD
         CX2fxqIn7+8BYP2aWtFVHxUiS5FbGmY7IAmbWTIfMV/YLcapUF0e0HwpzqTYPLcnX8
         DDiNUj/TZ2nNyTWHLcugq9phMe70X13CJWa5wJmYMcN0FWN9lOTKLGK9cJxTvkVN8g
         l8pyUaqqJ+aNAriIG6LS+VCIaw9Q75CbLo5xmqGyQ8ku/Wb410yatGjeCS1pmI/bHh
         m6OHMOqJEEGtMjszTTxk1sTVj1UruPJD03bcXNkSA9VFQ4I1yK4PDEGcvhR7uY8l5I
         QL8kjQ3G4Gm/Q==
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
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCHv3 bpf-next 4/5] bpf: Resolve symbols with ftrace_lookup_symbols for kprobe multi link
Date:   Wed, 27 Apr 2022 23:03:44 +0200
Message-Id: <20220427210345.455611-5-jolsa@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220427210345.455611-1-jolsa@kernel.org>
References: <20220427210345.455611-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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

Acked-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 kernel/trace/bpf_trace.c | 112 +++++++++++++++++++++++----------------
 1 file changed, 66 insertions(+), 46 deletions(-)

diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index f15b826f9899..7fd11c17558d 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -2229,6 +2229,59 @@ struct bpf_kprobe_multi_run_ctx {
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
+	int err = -ENOMEM;
+	unsigned int i;
+
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
+	us->syms = syms;
+	us->buf = buf;
+	return 0;
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
@@ -2349,53 +2402,12 @@ kprobe_multi_link_handler(struct fprobe *fp, unsigned long entry_ip,
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
+	const char **str_a = (const char **) a;
+	const char **str_b = (const char **) b;
 
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
+	return strcmp(*str_a, *str_b);
 }
 
 int bpf_kprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *prog)
@@ -2441,7 +2453,15 @@ int bpf_kprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *pr
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
+		err = ftrace_lookup_symbols(us.syms, cnt, addrs);
+		free_user_syms(&us);
 		if (err)
 			goto error;
 	}
-- 
2.35.1

