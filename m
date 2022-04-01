Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEBC54EF9FF
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 20:39:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351305AbiDASk7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 14:40:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351295AbiDASk6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 14:40:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BDAE173B20;
        Fri,  1 Apr 2022 11:39:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 989A761230;
        Fri,  1 Apr 2022 18:39:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DEB4C34111;
        Fri,  1 Apr 2022 18:39:05 +0000 (UTC)
Date:   Fri, 1 Apr 2022 14:39:03 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Beau Belgrave <beaub@linux.microsoft.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        linux-trace-devel <linux-trace-devel@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Michal Marek <michal.lkml@markovi.net>,
        ndesaulniers <ndesaulniers@google.com>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH] tracing: Move user_events.h temporarily out of include/uapi
Message-ID: <20220401143903.188384f3@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

While user_events API is under development and has been marked for broken
to not let the API become fixed, move the header file out of the uapi
directory. This is to prevent it from being installed, then later changed,
and then have an old distro user space update with a new kernel, where
applications see the user_events being available, but the old header is in
place, and then they get compiled incorrectly.

Also, surround the include with CONFIG_COMPILE_TEST to the current
location, but when the BROKEN tag is taken off, it will use the uapi
directory, and fail to compile. This is a good way to remind us to move
the header back.

Link: https://lore.kernel.org/all/20220330155835.5e1f6669@gandalf.local.home
Link: https://lkml.kernel.org/r/20220330201755.29319-1-mathieu.desnoyers@efficios.com

Suggested-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 include/{uapi => }/linux/user_events.h | 0
 kernel/trace/trace_events_user.c       | 5 +++++
 2 files changed, 5 insertions(+)
 rename include/{uapi => }/linux/user_events.h (100%)

diff --git a/include/uapi/linux/user_events.h b/include/linux/user_events.h
similarity index 100%
rename from include/uapi/linux/user_events.h
rename to include/linux/user_events.h
diff --git a/kernel/trace/trace_events_user.c b/kernel/trace/trace_events_user.c
index 846c27bc7aef..706e1686b5eb 100644
--- a/kernel/trace/trace_events_user.c
+++ b/kernel/trace/trace_events_user.c
@@ -18,7 +18,12 @@
 #include <linux/tracefs.h>
 #include <linux/types.h>
 #include <linux/uaccess.h>
+/* Reminder to move to uapi when everything works */
+#ifdef CONFIG_COMPILE_TEST
+#include <linux/user_events.h>
+#else
 #include <uapi/linux/user_events.h>
+#endif
 #include "trace.h"
 #include "trace_dynevent.h"
 
-- 
2.35.1

