Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 939544ECDB9
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 22:08:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231571AbiC3UA0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 16:00:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231429AbiC3UAZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 16:00:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F89D1DA77;
        Wed, 30 Mar 2022 12:58:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CFAD1B81E41;
        Wed, 30 Mar 2022 19:58:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7417EC340EC;
        Wed, 30 Mar 2022 19:58:36 +0000 (UTC)
Date:   Wed, 30 Mar 2022 15:58:35 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     Beau Belgrave <beaub@linux.microsoft.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        linux-trace-devel <linux-trace-devel@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH v2] tracing: Set user_events to BROKEN
Message-ID: <20220330155835.5e1f6669@gandalf.local.home>
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

After being merged, user_events become more visible to a wider audience
that have concerns with the current API. It is too late to fix this for
this release, but instead of a full revert, just mark it as BROKEN (which
prevents it from being selected in make config). Then we can work finding
a better API. If that fails, then it will need to be completely reverted.

Link: https://lore.kernel.org/all/2059213643.196683.1648499088753.JavaMail.zimbra@efficios.com/

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
Changes since v1: https://lore.kernel.org/all/20220329222514.51af6c07@gandalf.local.home/
 - Add depends on COMPILE_TEST too (Linus Torvalds)

 Hopefully, no distro is idiotic enough to enable COMPILE_TEST in their
 builds to get this feature.

 kernel/trace/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 16a52a71732d..f83d29adb375 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -741,6 +741,7 @@ config USER_EVENTS
 	bool "User trace events"
 	select TRACING
 	select DYNAMIC_EVENTS
+	depends on BROKEN || COMPILE_TEST # API needs to be straighten out
 	help
 	  User trace events are user-defined trace events that
 	  can be used like an existing kernel trace event.  User trace
-- 
2.35.1
