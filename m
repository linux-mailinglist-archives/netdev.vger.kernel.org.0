Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84754521566
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 14:26:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241783AbiEJMaf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 08:30:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241315AbiEJMae (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 08:30:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 091B32A3BCC;
        Tue, 10 May 2022 05:26:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6ADA360BC7;
        Tue, 10 May 2022 12:26:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4299C385D1;
        Tue, 10 May 2022 12:26:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652185595;
        bh=o6pr4aEKnsuBWeR6c+TMqGIX3kzbG/HCwBHVhWAiShk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AMe/u5kBsK4EBGCkAW7+zHByhyYMrGWf/Ay65sArsNnhPnyNFrBKBqchudJXyp9GT
         /0z5oAXpD1jvUyhdc+QFGutH+0jLPLld8rg57L2epSB8269F0UexyPuvFogy+DwDWG
         Olez/OuFc83MrkeKhx9ynX4N+N9jUjfUJWy8zMQAWphdsBb5rwINUvTCYjDbL8dVTd
         s1xmrOcAOVhfpCUvGTvR109NCDlVkD2KrggPaD66HP93WV0RuOpZjEUIGaN7bSzi7X
         7rcqqsIf0L5+S4nIgvWm2SSn8zyAzfiVxSvpL9oboEL6+6VF3CPT1yJoZA79wMZ7lH
         EPQfCtpCNYkag==
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCHv6 bpf-next 1/5] kallsyms: Make kallsyms_on_each_symbol generally available
Date:   Tue, 10 May 2022 14:26:12 +0200
Message-Id: <20220510122616.2652285-2-jolsa@kernel.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220510122616.2652285-1-jolsa@kernel.org>
References: <20220510122616.2652285-1-jolsa@kernel.org>
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

Making kallsyms_on_each_symbol generally available, so it can be
used outside CONFIG_LIVEPATCH option in following changes.

Rather than adding another ifdef option let's make the function
generally available (when CONFIG_KALLSYMS option is defined).

Cc: Christoph Hellwig <hch@lst.de>
Reviewed-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 include/linux/kallsyms.h | 7 ++++++-
 kernel/kallsyms.c        | 2 --
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/include/linux/kallsyms.h b/include/linux/kallsyms.h
index ce1bd2fbf23e..ad39636e0c3f 100644
--- a/include/linux/kallsyms.h
+++ b/include/linux/kallsyms.h
@@ -65,11 +65,11 @@ static inline void *dereference_symbol_descriptor(void *ptr)
 	return ptr;
 }
 
+#ifdef CONFIG_KALLSYMS
 int kallsyms_on_each_symbol(int (*fn)(void *, const char *, struct module *,
 				      unsigned long),
 			    void *data);
 
-#ifdef CONFIG_KALLSYMS
 /* Lookup the address for a symbol. Returns 0 if not found. */
 unsigned long kallsyms_lookup_name(const char *name);
 
@@ -163,6 +163,11 @@ static inline bool kallsyms_show_value(const struct cred *cred)
 	return false;
 }
 
+static inline int kallsyms_on_each_symbol(int (*fn)(void *, const char *, struct module *,
+					  unsigned long), void *data)
+{
+	return -EOPNOTSUPP;
+}
 #endif /*CONFIG_KALLSYMS*/
 
 static inline void print_ip_sym(const char *loglvl, unsigned long ip)
diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
index 79f2eb617a62..fdfd308bebc4 100644
--- a/kernel/kallsyms.c
+++ b/kernel/kallsyms.c
@@ -228,7 +228,6 @@ unsigned long kallsyms_lookup_name(const char *name)
 	return module_kallsyms_lookup_name(name);
 }
 
-#ifdef CONFIG_LIVEPATCH
 /*
  * Iterate over all symbols in vmlinux.  For symbols from modules use
  * module_kallsyms_on_each_symbol instead.
@@ -251,7 +250,6 @@ int kallsyms_on_each_symbol(int (*fn)(void *, const char *, struct module *,
 	}
 	return 0;
 }
-#endif /* CONFIG_LIVEPATCH */
 
 static unsigned long get_symbol_pos(unsigned long addr,
 				    unsigned long *symbolsize,
-- 
2.35.3

