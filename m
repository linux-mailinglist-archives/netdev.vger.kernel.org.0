Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF92351E42B
	for <lists+netdev@lfdr.de>; Sat,  7 May 2022 06:47:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1445510AbiEGEut (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 May 2022 00:50:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239457AbiEGEus (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 May 2022 00:50:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C3B469CE8;
        Fri,  6 May 2022 21:46:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 47687B83ABC;
        Sat,  7 May 2022 04:46:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91B7CC385A6;
        Sat,  7 May 2022 04:46:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651898816;
        bh=nCKZYzPsjKkho5w7h4bpzf8tjClGnfHBkruyaF3rEaU=;
        h=From:To:Cc:Subject:Date:From;
        b=UQNMCUEE9Ja6+cJ4Ij5YLK4BK25Gj66eEJ6Idh4yOrzJOGD8jF/SL+efrSzwkrLlr
         VqJMQbcmPmMthgYZUhiq0eqeeETYMhririXF4YHVUWWhiqErr7zkdA44wkJmHDThQQ
         b92EAUZ8QbFVt9mEIyyWV3kVul1W5dsztLAd5afOW4o0flO5D39jsE3ImXP+Usq0zu
         6Al7vGverSspIHzddJCZJTazcsKZvBwRvPCZg9VPxXqVFS+9Wnrs6qFiPbXwLpVAkn
         6rxFF3fpJyQqz9PzGMIVE8Olvb1t6+lIRzrdHJgssWRuNX8smPxBuQOqT3wCoNaK6Q
         AAHlQ9Xqci0lQ==
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Masami Hiramatsu <mhiramat@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH] rethook: Reject getting a rethook if RCU is not watching
Date:   Sat,  7 May 2022 13:46:52 +0900
Message-Id: <165189881197.175864.14757002789194211860.stgit@devnote2>
X-Mailer: git-send-email 2.25.1
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
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

Since the rethook_recycle() will involve the call_rcu() for reclaiming
the rethook_instance, the rethook must be set up at the RCU available
context (non idle). This rethook_recycle() in the rethook trampoline
handler is inevitable, thus the RCU available check must be done before
setting the rethook trampoline.

This adds a rcu_is_watching() check in the rethook_try_get() so that
it will return NULL if it is called when !rcu_is_watching().

Fixes: 54ecbe6f1ed5 ("rethook: Add a generic return hook")
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
---
 kernel/trace/rethook.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/kernel/trace/rethook.c b/kernel/trace/rethook.c
index b56833700d23..c69d82273ce7 100644
--- a/kernel/trace/rethook.c
+++ b/kernel/trace/rethook.c
@@ -154,6 +154,15 @@ struct rethook_node *rethook_try_get(struct rethook *rh)
 	if (unlikely(!handler))
 		return NULL;
 
+	/*
+	 * This expects the caller will set up a rethook on a function entry.
+	 * When the function returns, the rethook will eventually be reclaimed
+	 * or released in the rethook_recycle() with call_rcu().
+	 * This means the caller must be run in the RCU-availabe context.
+	 */
+	if (unlikely(!rcu_is_watching()))
+		return NULL;
+
 	fn = freelist_try_get(&rh->pool);
 	if (!fn)
 		return NULL;

