Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A95D551243A
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 23:04:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236763AbiD0VHR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 17:07:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233639AbiD0VHQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 17:07:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD1ECBF43;
        Wed, 27 Apr 2022 14:04:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 468C461D94;
        Wed, 27 Apr 2022 21:04:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 867E6C385A9;
        Wed, 27 Apr 2022 21:03:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651093441;
        bh=syZvsfkXqWjSBvMqPMOPO0J8VKUuLeAVtPJLh94JYZo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ks5R5o4rby5MKu2lFnaXpPgnj3to+HEWAZHDiKBD4OIbHi7tKvaS7RVYc412pRSm8
         /FXTBnXDCJbZMoxpSAsK2fxcqQR7HTlOVOELVHtJe/a7pzJRrLf8UEUHbClE9guWYf
         j5BbGjDfQ/ANf6QD0z8xkBdPmy4gc2MrWGlP82TOtqkbcCLmwriPy9dnwP8UuoJYPC
         kW5wQPl3a8nW8+YsP/ykndZU5PkFPgSjgZQVM69E+MFUedCTA0j9yEOeFmmidButBo
         2IN6a+Ok+L0oMtLvGoJ14+BAq+LM5ry0XJLz35JaqK8x7N49JIP0AYAdtsZ3S4InoI
         DCmSbNfOcNSLQ==
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
Subject: [PATCHv3 bpf-next 1/5] kallsyms: Fully export kallsyms_on_each_symbol function
Date:   Wed, 27 Apr 2022 23:03:41 +0200
Message-Id: <20220427210345.455611-2-jolsa@kernel.org>
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

Fully exporting kallsyms_on_each_symbol function, so it can be used
in following changes.

Rather than adding another ifdef option let's export the function
completely (when CONFIG_KALLSYMS option is defined).

Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 include/linux/kallsyms.h | 5 +++++
 kernel/kallsyms.c        | 2 --
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/include/linux/kallsyms.h b/include/linux/kallsyms.h
index ce1bd2fbf23e..d423f3cffa6d 100644
--- a/include/linux/kallsyms.h
+++ b/include/linux/kallsyms.h
@@ -163,6 +163,11 @@ static inline bool kallsyms_show_value(const struct cred *cred)
 	return false;
 }
 
+static inline int kallsyms_on_each_symbol(int (*fn)(void *, const char *, struct module *, unsigned long),
+					  void *data)
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
2.35.1

