Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 563254ED134
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 03:11:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229936AbiCaBNK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 21:13:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiCaBNI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 21:13:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DE3F66219;
        Wed, 30 Mar 2022 18:11:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AFE0261913;
        Thu, 31 Mar 2022 01:11:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFCD1C340EC;
        Thu, 31 Mar 2022 01:11:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648689082;
        bh=5PYpOIJrSlk843pvlKov9NA4xUiFlfgoqdLPw5drRJU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D1RexhaZ7Swoie5pabKjjxUJh/a/C+/pv41nWrcJS6Vw8t96VNCbNb4div1uJhZ5A
         bA+d4CZ7w5qXS0PH/fGTmYrgwt4lp8bNdEm91VZASsPeCqKlmda2hxxZnY/H9xeVqg
         burmtRI05m/PTNwomXxlBteqiuuf7EEz2s1CFpyU1vCbxNkn/Wr11Eqz/d3UMdU7Rb
         ymv0KiIjmVwJmWKiLz+r8d+69K7eOaRbT4+YbBBmYJvKrmva2Py/VIZtcrxxUFH6NR
         J28nWQjFbMhP1t5J2ofYKUz3fWK76lTYpmjwX27b8ibQFobMjUymWDoOkh1sRjrTdo
         cLFW+U3eFHzdQ==
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     davem@davemloft.net, daniel@iogearbox.net, peterz@infradead.org,
        mhiramat@kernel.org, kuba@kernel.org, andrii@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH bpf] rethook: Fix to use WRITE_ONCE() for rethook::handler
Date:   Thu, 31 Mar 2022 10:11:17 +0900
Message-Id: <164868907688.21983.1606862921419988152.stgit@devnote2>
X-Mailer: git-send-email 2.25.1
In-Reply-To:  <CAADnVQJvzYn3Yw4-exrvUUTFijq0yEJruLkxfzutEgJUVtUj3g@mail.gmail.com>
References:  <CAADnVQJvzYn3Yw4-exrvUUTFijq0yEJruLkxfzutEgJUVtUj3g@mail.gmail.com>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
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

Since the function pointered by rethook::handler never be removed when
the rethook is alive, it doesn't need to use rcu_assign_pointer() to
update it. Just use WRITE_ONCE().

Reported-by: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
---
 kernel/trace/rethook.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/rethook.c b/kernel/trace/rethook.c
index ab463a4d2b23..b56833700d23 100644
--- a/kernel/trace/rethook.c
+++ b/kernel/trace/rethook.c
@@ -65,7 +65,7 @@ static void rethook_free_rcu(struct rcu_head *head)
  */
 void rethook_free(struct rethook *rh)
 {
-	rcu_assign_pointer(rh->handler, NULL);
+	WRITE_ONCE(rh->handler, NULL);
 
 	call_rcu(&rh->rcu, rethook_free_rcu);
 }

