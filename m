Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88AC14F7F8E
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 14:53:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245505AbiDGMzH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 08:55:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245481AbiDGMzF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 08:55:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AFD6228D1C;
        Thu,  7 Apr 2022 05:53:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ED00EB8276A;
        Thu,  7 Apr 2022 12:53:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA9D7C385A0;
        Thu,  7 Apr 2022 12:52:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649335982;
        bh=Bdy0vhB9JZ2Rbc9AmJ6TuuVktLJMhhrVK6hP2CeREHM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=klrfsbLa32MG+Vk73LSydFpVIG8HpHOFcYOo5fJsg+sdCxezdw+pZE3WyXVcBxI66
         cBGZup9o67SZqnA9bC5CBOs9opbEl24JPwrpTpul3AMz2LC4KtwbW2G7Yn56TBbhpO
         Niseu5FWIeEIz8DfUcG+IbkxbbVpsjyvGF3SL36VkCNsGMzjF3dmTD15NxmTtuhZ3f
         aJGY5q9eZc6xUQZigppWhJDSg8h1cHXYPKF47ZqcoDMDyuHJ+dNm3+GFIa4VCSMUMm
         EexqfwnmlEEeSpoPCWrFjLBmB7MAQlQzbP97RXLJH2oPz0RWqRP/JLNavveDMgzdjl
         4QOevvYRraygQ==
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
Subject: [RFC bpf-next 2/4] fprobe: Resolve symbols with kallsyms_lookup_names
Date:   Thu,  7 Apr 2022 14:52:22 +0200
Message-Id: <20220407125224.310255-3-jolsa@kernel.org>
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

Using kallsyms_lookup_names to speed up symbols lookup
in register_fprobe_syms API.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 kernel/kallsyms.c     |  2 +-
 kernel/trace/fprobe.c | 23 ++---------------------
 2 files changed, 3 insertions(+), 22 deletions(-)

diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
index a3738ddf9e87..7d89da375c23 100644
--- a/kernel/kallsyms.c
+++ b/kernel/kallsyms.c
@@ -230,7 +230,7 @@ unsigned long kallsyms_lookup_name(const char *name)
 	return module_kallsyms_lookup_name(name);
 }
 
-#ifdef CONFIG_LIVEPATCH
+#if defined(CONFIG_LIVEPATCH) || defined(CONFIG_FPROBE)
 /*
  * Iterate over all symbols in vmlinux.  For symbols from modules use
  * module_kallsyms_on_each_symbol instead.
diff --git a/kernel/trace/fprobe.c b/kernel/trace/fprobe.c
index 89d9f994ebb0..d466803dc2b2 100644
--- a/kernel/trace/fprobe.c
+++ b/kernel/trace/fprobe.c
@@ -88,36 +88,17 @@ NOKPROBE_SYMBOL(fprobe_exit_handler);
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
+	if (!kallsyms_lookup_names(syms, num, addrs))
+		return addrs;
 
-		/* Convert symbol address to ftrace location. */
-		if (!kallsyms_lookup_size_offset(addr, &size, NULL) || !size)
-			goto error;
-
-		addr = ftrace_location_range(addr, addr + size - 1);
-		if (!addr) /* No dynamic ftrace there. */
-			goto error;
-
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

