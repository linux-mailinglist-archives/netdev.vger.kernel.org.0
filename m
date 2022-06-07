Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 406F454037A
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 18:11:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344918AbiFGQLa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 12:11:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344889AbiFGQLZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 12:11:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E657F5070;
        Tue,  7 Jun 2022 09:11:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ED366617C5;
        Tue,  7 Jun 2022 16:11:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F0F5C385A5;
        Tue,  7 Jun 2022 16:11:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654618277;
        bh=fMhk/18pmmnDcqEOb0reql1pDujGd2QhKD4ugwhr/VY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dhwnhMMITGHny83aSk9t14jqUCSH9AmezMjMuVRFdJbPy93LeAgL9+b2f6UnraR1B
         U4o4bENjO40cbgbXiG51dStQZKs6cmjnkMHpN0FJ26Ml5meLWwaElejmeYT9OAAN5I
         ESsERD8FX0Wtohk2iWlLwNrdqB38Hg2Z99zNEG8hjhSTMIvZaZZJeu6Bic7OduibRR
         u959e5smm26vQilkM9Ae24fovWn46VY/mtAWi3goUDtRDEfeZ+9doZYgAMBSypzumr
         8mSVmCbH3K+4/EkJa5OnTZKL8TuP6GGyfp+3O97St1vOxNLEzMhK9+hO49EjIu/y65
         TsTfnT8UpHsug==
From:   "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Masami Hiramatsu <mhiramat@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH bpf v2 2/2] rethook: Reject getting a rethook if RCU is not watching
Date:   Wed,  8 Jun 2022 01:11:12 +0900
Message-Id: <165461827269.280167.7379263615545598958.stgit@devnote2>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <165461825202.280167.12903689442217921817.stgit@devnote2>
References: <165461825202.280167.12903689442217921817.stgit@devnote2>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
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

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

Since the rethook_recycle() will involve the call_rcu() for reclaiming
the rethook_instance, the rethook must be set up at the RCU available
context (non idle). This rethook_recycle() in the rethook trampoline
handler is inevitable, thus the RCU available check must be done before
setting the rethook trampoline.

This adds a rcu_is_watching() check in the rethook_try_get() so that
it will return NULL if it is called when !rcu_is_watching().

Fixes: 54ecbe6f1ed5 ("rethook: Add a generic return hook")
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
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

