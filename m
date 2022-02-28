Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2CCB4C60B6
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 02:58:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232371AbiB1B7W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Feb 2022 20:59:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231145AbiB1B7V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Feb 2022 20:59:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5461F3DA6C
        for <netdev@vger.kernel.org>; Sun, 27 Feb 2022 17:58:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E341160A1C
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 01:58:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8016C340F4;
        Mon, 28 Feb 2022 01:58:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646013523;
        bh=cnMDROwtdnWKeHZKno1E44nU7eeC80jeDaNRA4Q9EXg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D9whhtQK9czwduCKJxQeQ4+d0fubi4vNQaQCVwJEyhLgO1DKArgWuX6cJYkfsmtg+
         8jbBGSgVZDaHlWEzWB0/mkxHhp4tlcjmefpLoD5LSXo5GxVMYkPfVYh1N0k79T/5Of
         YO3DGBOGYAK5X3AHavqjc9xPeZUr+2lzLEjLr75QwGRKsHvLx8j0eg6+ArttUEN/xt
         uKYDvWeo2KXcdiQWMyxsW9OaCAN+xEX9dgx24CsoM/2dwveha6p40mCajBDtGHHuHr
         lXsd7R4bZ5Iag1R1n9cV1ERQabovQjVMh5arG2wPi1jsvfeoFC2MwNoe/HD1gPJ8qR
         xQULocTgzvi5A==
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, David Ahern <dsahern@kernel.org>
Subject: [PATCH iproute2-next 1/3] bpf_glue: Remove use of bpf_load_program from libbpf
Date:   Sun, 27 Feb 2022 18:58:38 -0700
Message-Id: <20220228015840.1413-2-dsahern@kernel.org>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
In-Reply-To: <20220228015840.1413-1-dsahern@kernel.org>
References: <20220228015840.1413-1-dsahern@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

bpf_load_program is deprecated starting in v0.7. The preferred
bpf_prog_load requires bpf_prog_load_opts from v0.6. This creates an
ugly scenario for iproute2 to work across libbpf versions from v0.1
and up.

Since bpf_program_load is only used to load the builtin vrf program,
just remove the libbpf call and use the legacy code.

Signed-off-by: David Ahern <dsahern@kernel.org>
---
 lib/bpf_glue.c   | 12 ------------
 lib/bpf_legacy.c |  7 +++++++
 2 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/lib/bpf_glue.c b/lib/bpf_glue.c
index 70d001840f7b..cc3015487c68 100644
--- a/lib/bpf_glue.c
+++ b/lib/bpf_glue.c
@@ -11,18 +11,6 @@
 #include <bpf/bpf.h>
 #endif
 
-int bpf_program_load(enum bpf_prog_type type, const struct bpf_insn *insns,
-		     size_t size_insns, const char *license, char *log,
-		     size_t size_log)
-{
-#ifdef HAVE_LIBBPF
-	return bpf_load_program(type, insns, size_insns / sizeof(struct bpf_insn),
-				license, 0, log, size_log);
-#else
-	return bpf_prog_load_dev(type, insns, size_insns, license, 0, log, size_log);
-#endif
-}
-
 int bpf_program_attach(int prog_fd, int target_fd, enum bpf_attach_type type)
 {
 #ifdef HAVE_LIBBPF
diff --git a/lib/bpf_legacy.c b/lib/bpf_legacy.c
index 6e3891c9f1f1..3779ae90cc1c 100644
--- a/lib/bpf_legacy.c
+++ b/lib/bpf_legacy.c
@@ -1126,6 +1126,13 @@ int bpf_prog_load_dev(enum bpf_prog_type type, const struct bpf_insn *insns,
 	return bpf(BPF_PROG_LOAD, &attr, sizeof(attr));
 }
 
+int bpf_program_load(enum bpf_prog_type type, const struct bpf_insn *insns,
+		     size_t size_insns, const char *license, char *log,
+		     size_t size_log)
+{
+	return bpf_prog_load_dev(type, insns, size_insns, license, 0, log, size_log);
+}
+
 #ifdef HAVE_ELF
 struct bpf_elf_prog {
 	enum bpf_prog_type	type;
-- 
2.24.3 (Apple Git-128)

