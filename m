Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05EBE54C74C
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 13:22:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343941AbiFOLWN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 07:22:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245341AbiFOLWC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 07:22:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EC5345522;
        Wed, 15 Jun 2022 04:21:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3BA4361764;
        Wed, 15 Jun 2022 11:21:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 684AFC34115;
        Wed, 15 Jun 2022 11:21:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655292118;
        bh=cJTxSqeBvt+JJkPbIdLUDtBvVOBvVbK0lR/sV13qNIs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MnHg00evDfTS/JPd6z38T2J8wFuLxZicf/k9Plm6Mqk4hDt5pyKpa76NGggXtIDg/
         we4GS7UKLjkMFDLeSpPvjhCWMHcJeb8frwXyWcmOuNDucioj+gsSkNDSgW+6vrh9Rn
         B+eRkymwTgwGDruzSdx2Ro7bEhev34FEQIyH6e7feJGBh49wUhbwtPo8QJyXRd+vBT
         Bi3IfMIwnQsn0sD06eM/OV0xdYQBS/yjy4VTK+MCaXD56ayU+O+NcnYhPL2f54o0lo
         zar+kv+mQ5jsqHr3szvrN+Ga1gfk2pGxXHZt5zJcvQHjMoUA+xBo3TtWa5YUoC5CZX
         kiDi1ODVDlyjQ==
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>
Subject: [PATCHv3 bpf 3/4] bpf: Force cookies array to follow symbols sorting
Date:   Wed, 15 Jun 2022 13:21:17 +0200
Message-Id: <20220615112118.497303-4-jolsa@kernel.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220615112118.497303-1-jolsa@kernel.org>
References: <20220615112118.497303-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When user specifies symbols and cookies for kprobe_multi link
interface it's very likely the cookies will be misplaced and
returned to wrong functions (via get_attach_cookie helper).

The reason is that to resolve the provided functions we sort
them before passing them to ftrace_lookup_symbols, but we do
not do the same sort on the cookie values.

Fixing this by using sort_r function with custom swap callback
that swaps cookie values as well.

Fixes: 0236fec57a15 ("bpf: Resolve symbols with ftrace_lookup_symbols for kprobe multi link")
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 kernel/trace/bpf_trace.c | 60 ++++++++++++++++++++++++++++++----------
 1 file changed, 45 insertions(+), 15 deletions(-)

diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 7a13e6ac6327..88589d74a892 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -2423,7 +2423,7 @@ kprobe_multi_link_handler(struct fprobe *fp, unsigned long entry_ip,
 	kprobe_multi_link_prog_run(link, entry_ip, regs);
 }
 
-static int symbols_cmp(const void *a, const void *b)
+static int symbols_cmp_r(const void *a, const void *b, const void *priv)
 {
 	const char **str_a = (const char **) a;
 	const char **str_b = (const char **) b;
@@ -2431,6 +2431,28 @@ static int symbols_cmp(const void *a, const void *b)
 	return strcmp(*str_a, *str_b);
 }
 
+struct multi_symbols_sort {
+	const char **funcs;
+	u64 *cookies;
+};
+
+static void symbols_swap_r(void *a, void *b, int size, const void *priv)
+{
+	const struct multi_symbols_sort *data = priv;
+	const char **name_a = a, **name_b = b;
+
+	swap(*name_a, *name_b);
+
+	/* If defined, swap also related cookies. */
+	if (data->cookies) {
+		u64 *cookie_a, *cookie_b;
+
+		cookie_a = data->cookies + (name_a - data->funcs);
+		cookie_b = data->cookies + (name_b - data->funcs);
+		swap(*cookie_a, *cookie_b);
+	}
+}
+
 int bpf_kprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *prog)
 {
 	struct bpf_kprobe_multi_link *link = NULL;
@@ -2468,38 +2490,46 @@ int bpf_kprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *pr
 	if (!addrs)
 		return -ENOMEM;
 
+	ucookies = u64_to_user_ptr(attr->link_create.kprobe_multi.cookies);
+	if (ucookies) {
+		cookies = kvmalloc_array(cnt, sizeof(*addrs), GFP_KERNEL);
+		if (!cookies) {
+			err = -ENOMEM;
+			goto error;
+		}
+		if (copy_from_user(cookies, ucookies, size)) {
+			err = -EFAULT;
+			goto error;
+		}
+	}
+
 	if (uaddrs) {
 		if (copy_from_user(addrs, uaddrs, size)) {
 			err = -EFAULT;
 			goto error;
 		}
 	} else {
+		struct multi_symbols_sort data = {
+			.cookies = cookies,
+		};
 		struct user_syms us;
 
 		err = copy_user_syms(&us, usyms, cnt);
 		if (err)
 			goto error;
 
-		sort(us.syms, cnt, sizeof(*us.syms), symbols_cmp, NULL);
+		if (cookies)
+			data.funcs = us.syms;
+
+		sort_r(us.syms, cnt, sizeof(*us.syms), symbols_cmp_r,
+		       symbols_swap_r, &data);
+
 		err = ftrace_lookup_symbols(us.syms, cnt, addrs);
 		free_user_syms(&us);
 		if (err)
 			goto error;
 	}
 
-	ucookies = u64_to_user_ptr(attr->link_create.kprobe_multi.cookies);
-	if (ucookies) {
-		cookies = kvmalloc_array(cnt, sizeof(*addrs), GFP_KERNEL);
-		if (!cookies) {
-			err = -ENOMEM;
-			goto error;
-		}
-		if (copy_from_user(cookies, ucookies, size)) {
-			err = -EFAULT;
-			goto error;
-		}
-	}
-
 	link = kzalloc(sizeof(*link), GFP_KERNEL);
 	if (!link) {
 		err = -ENOMEM;
-- 
2.35.3

