Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A50F94EBF88
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 13:05:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343502AbiC3LHL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 07:07:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343490AbiC3LHK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 07:07:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89BDCBC80;
        Wed, 30 Mar 2022 04:05:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 73E2AB81BC1;
        Wed, 30 Mar 2022 11:05:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D86BC340F2;
        Wed, 30 Mar 2022 11:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648638321;
        bh=mzw5GB4F/8hbvfnhA4i+A4Z4haC4e6zVkzrfHcj0Aco=;
        h=From:To:Cc:Subject:Date:From;
        b=ulpZ1ak6zfVfsIekorftkORWKmQO+JErManDDmrK2O0/w3mH9mb6ARH2asrb+Ck+u
         6DrfF4ICRJPJzVtqBVlOFe6PqUuYA2Hab0YVO7Ya/mbTaMHQmkQR2QJrFAV1XUSrwj
         S6FuuMidErHmFeS4qIqteVA1CcBOCqFMcWhvbzsEJBIvgakdBwupaDTwuu9zQrg0Yc
         xqldfbSGMhmz5qt65UPppT2CHPZdIjGWTzt2TErFcAoiDoFEPSVZWhqgwMUzPuo3px
         SAYd9NZ6D4VavYbTa+c+Xp6LwJBwL/xz/z3BMX0xpegkszd1TWuoxU5aJ/6nbFRVvw
         lX20gG7Y6uYqg==
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: [PATCH] bpf: Fix sparse warnings in kprobe_multi_resolve_syms
Date:   Wed, 30 Mar 2022 13:05:10 +0200
Message-Id: <20220330110510.398558-1-jolsa@kernel.org>
X-Mailer: git-send-email 2.35.1
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

Adding missing __user tags to fix sparse warnings:

kernel/trace/bpf_trace.c:2370:34: warning: incorrect type in argument 2 (different address spaces)
kernel/trace/bpf_trace.c:2370:34:    expected void const [noderef] __user *from
kernel/trace/bpf_trace.c:2370:34:    got void const *usyms
kernel/trace/bpf_trace.c:2376:51: warning: incorrect type in argument 2 (different address spaces)
kernel/trace/bpf_trace.c:2376:51:    expected char const [noderef] __user *src
kernel/trace/bpf_trace.c:2376:51:    got char const *
kernel/trace/bpf_trace.c:2443:49: warning: incorrect type in argument 1 (different address spaces)
kernel/trace/bpf_trace.c:2443:49:    expected void const *usyms
kernel/trace/bpf_trace.c:2443:49:    got void [noderef] __user *[assigned] usyms

Reported-by: Alexei Starovoitov <ast@kernel.org>
Fixes: 0dcac2725406 ("bpf: Add multi kprobe link")
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 kernel/trace/bpf_trace.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 7fa2ebc07f60..d8553f46caa2 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -2349,11 +2349,11 @@ kprobe_multi_link_handler(struct fprobe *fp, unsigned long entry_ip,
 }
 
 static int
-kprobe_multi_resolve_syms(const void *usyms, u32 cnt,
+kprobe_multi_resolve_syms(const void __user *usyms, u32 cnt,
 			  unsigned long *addrs)
 {
 	unsigned long addr, size;
-	const char **syms;
+	const char __user **syms;
 	int err = -ENOMEM;
 	unsigned int i;
 	char *func;
-- 
2.35.1

