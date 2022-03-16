Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 393AE4DAF98
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 13:24:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355637AbiCPM0H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 08:26:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355659AbiCPM0G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 08:26:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A73DF4D9D1;
        Wed, 16 Mar 2022 05:24:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 35ACBB81AE4;
        Wed, 16 Mar 2022 12:24:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D55B6C340E9;
        Wed, 16 Mar 2022 12:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647433489;
        bh=5dSI2Vb07oF19cImCiHaEFsIdyzJFr+m3f7S16flnS8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aOWBF80J2Jw1aJVgipMGQy2wkRkhslV1XC/JRAtHKHvpas1hSDUN/U3eLzG7qxLiX
         l9C+cmSQzokSiBAMaoAbNdCFJD5fw6m//qcCx10ovyLDwWNRZ0m/dGrcNnoidkYD0c
         n6hYqsbifn3b2rh2CAUX6ZcazCXGVrJqi+zd23xjG9I+xHaat/UNOiArvmQ39E14sH
         +abunun5WS10lecjwQBFGIM9Q7B7ii7aX3iTj5KiRvnyv3mpDnSHBxlpfJyq/uWU6o
         wCdZ/flnd1D4sYCK7PwIMP7hskdOTOqV/BUQaHJ+KqTCcLQFVMtTYjBx2qQ3ieGgBq
         dGJm+cx77hVVg==
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
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCHv3 bpf-next 02/13] kallsyms: Skip the name search for empty string
Date:   Wed, 16 Mar 2022 13:24:08 +0100
Message-Id: <20220316122419.933957-3-jolsa@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220316122419.933957-1-jolsa@kernel.org>
References: <20220316122419.933957-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When kallsyms_lookup_name is called with empty string,
it will do futile search for it through all the symbols.

Skipping the search for empty string.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 kernel/kallsyms.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
index 951c93216fc4..79f2eb617a62 100644
--- a/kernel/kallsyms.c
+++ b/kernel/kallsyms.c
@@ -212,6 +212,10 @@ unsigned long kallsyms_lookup_name(const char *name)
 	unsigned long i;
 	unsigned int off;
 
+	/* Skip the search for empty string. */
+	if (!*name)
+		return 0;
+
 	for (i = 0, off = 0; i < kallsyms_num_syms; i++) {
 		off = kallsyms_expand_symbol(off, namebuf, ARRAY_SIZE(namebuf));
 
-- 
2.35.1

