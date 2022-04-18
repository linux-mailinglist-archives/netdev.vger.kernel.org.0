Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59D2B5054A0
	for <lists+netdev@lfdr.de>; Mon, 18 Apr 2022 15:22:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241320AbiDRNLx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 09:11:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242816AbiDRNJ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 09:09:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9512369C6;
        Mon, 18 Apr 2022 05:49:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C2E87B80EDB;
        Mon, 18 Apr 2022 12:48:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 005B7C385A1;
        Mon, 18 Apr 2022 12:48:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650286138;
        bh=l5dooTjbgCNig025z/CpTFdhYCb1guxzIXi8auXSJ1I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hGZlpXTtzMxkqwRnpBxWwuPLvnGxRVMlX30XmdfK4s5DDoy4MeBWTXsxtuBxaoEWH
         mJSpRi1BCInVFtuCO9qofR4+zv4imTIvfHyi0yYgKojUwiPYXB9GD7Di/zCJBDJRyK
         vN3oMA1gHMjtL0zuyhh3n2NGJcSWc0TQ98zBUaLSE4cr63h/rMPBYXd5JrYbhNCO5C
         GE9LcDw5GUXzaJPtmvlTk664jj7fO4+X3gVKajpRXZTUAIzhI4w5OPR+87Q96NwZuK
         DpKvjLvmQFiGdc+YtZRrz+gv5LzHcZY6QPa2bF0E7rboV0zTxmcmpKtbOzQzjEntjn
         HW8Y2h9Kng27A==
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
Subject: [PATCHv2 bpf-next 2/4] fprobe: Resolve symbols with kallsyms_lookup_names
Date:   Mon, 18 Apr 2022 14:48:32 +0200
Message-Id: <20220418124834.829064-3-jolsa@kernel.org>
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

Using kallsyms_lookup_names to speed up symbols lookup
in register_fprobe_syms API.

This requires syms array to be alphabetically sorted.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 kernel/trace/fprobe.c | 32 ++++++++++++--------------------
 1 file changed, 12 insertions(+), 20 deletions(-)

diff --git a/kernel/trace/fprobe.c b/kernel/trace/fprobe.c
index 89d9f994ebb0..6419501a0036 100644
--- a/kernel/trace/fprobe.c
+++ b/kernel/trace/fprobe.c
@@ -85,39 +85,31 @@ static void fprobe_exit_handler(struct rethook_node *rh, void *data,
 }
 NOKPROBE_SYMBOL(fprobe_exit_handler);
 
+static int symbols_cmp(const void *a, const void *b)
+{
+	const char **str_a = (const char **) a;
+	const char **str_b = (const char **) b;
+
+	return strcmp(*str_a, *str_b);
+}
+
 /* Convert ftrace location address from symbols */
 static unsigned long *get_ftrace_locations(const char **syms, int num)
 {
-	unsigned long addr, size;
 	unsigned long *addrs;
-	int i;
 
 	/* Convert symbols to symbol address */
 	addrs = kcalloc(num, sizeof(*addrs), GFP_KERNEL);
 	if (!addrs)
 		return ERR_PTR(-ENOMEM);
 
-	for (i = 0; i < num; i++) {
-		addr = kallsyms_lookup_name(syms[i]);
-		if (!addr)	/* Maybe wrong symbol */
-			goto error;
-
-		/* Convert symbol address to ftrace location. */
-		if (!kallsyms_lookup_size_offset(addr, &size, NULL) || !size)
-			goto error;
+	/* kallsyms_lookup_names expects sorted symbols */
+	sort(syms, num, sizeof(*syms), symbols_cmp, NULL);
 
-		addr = ftrace_location_range(addr, addr + size - 1);
-		if (!addr) /* No dynamic ftrace there. */
-			goto error;
+	if (!kallsyms_lookup_names(syms, num, addrs))
+		return addrs;
 
-		addrs[i] = addr;
-	}
-
-	return addrs;
-
-error:
 	kfree(addrs);
-
 	return ERR_PTR(-ENOENT);
 }
 
-- 
2.35.1

