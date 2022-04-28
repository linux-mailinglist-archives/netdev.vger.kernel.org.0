Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EB5E513C7E
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 22:15:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351669AbiD1UPt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 16:15:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351675AbiD1UPq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 16:15:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CB52BF953;
        Thu, 28 Apr 2022 13:12:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E3697B83025;
        Thu, 28 Apr 2022 20:12:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC7F7C385A9;
        Thu, 28 Apr 2022 20:12:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651176743;
        bh=yLdMRkQj4wpHAGTn9X8WvbNIB2gNomm0DQat/BHFt5M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qvte3OBdcL5j3h280muHWouj15ATKEQNdHFAkeIu4zov3zXjRjTAOCXyZF+ga1PGz
         bKnAeE09Gm3OOUXDWwuSWiRaJ23cpaZIeNRGj5Fs2JomttOqCOihhdfaoGIDUXJI53
         PIPwE7Xq7atdulrVNCAMAEkZZOPNtuwyFC2+0frGt7CjuVGyIypoOst1+jt4qjCxiN
         HkCYyry2GRASHphziLakFiREYGua7A3QYgJbhGWsBgTYrIohDIWoO3uxyQ8mZX3x/m
         xJOquZM2gDnPOY481XrtZ3FHaC52+qkp9bMnlA+yob6ClwHqdOxOP8VG5zuidUR/Hr
         IHOiPtPSnohBw==
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
Subject: [PATCHv4 bpf-next 1/5] kallsyms: Fully export kallsyms_on_each_symbol function
Date:   Thu, 28 Apr 2022 22:12:03 +0200
Message-Id: <20220428201207.954552-2-jolsa@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220428201207.954552-1-jolsa@kernel.org>
References: <20220428201207.954552-1-jolsa@kernel.org>
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
 include/linux/kallsyms.h | 7 ++++++-
 kernel/kallsyms.c        | 2 --
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/include/linux/kallsyms.h b/include/linux/kallsyms.h
index ce1bd2fbf23e..89f063651192 100644
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

