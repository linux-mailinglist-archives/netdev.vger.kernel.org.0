Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8964205855
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 19:13:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733126AbgFWRN2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 13:13:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732408AbgFWRNZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 13:13:25 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B4ACC061573;
        Tue, 23 Jun 2020 10:13:25 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id s18so24612631ioe.2;
        Tue, 23 Jun 2020 10:13:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:user-agent:mime-version
         :content-transfer-encoding;
        bh=gav8ijUBF61wP1+X8OQ02YRSM92QldsTlZ+CycghqWQ=;
        b=cdzV+ETP07I33HudSyeKrDtsRTaXJVyKI6vcuiVFuqW6RbsOyMreTaswG5KebPHMO0
         vyyhfzNfTH4k/xeIqEkZKWpIOtTLJ8XX+KUq4H0G8l6B9kMh3tUiTpGYaeCuCjtNNHCz
         Csqk9sdFVrALNuRa9trFy8cNUMHSfOceduV4w2k7adIFgmh8o2rqxes1Ixc+yzgXnMLd
         KtslowaXpmf5KdRKd96ZSUqoYcFH+YT59KplCA6rdIu1U/z5VkZNNJ58N0A4WLFmF6Lq
         Tey7yiCB6HjFKKvSF8SlMw2X9N6cwzAGBrykZDepGtDDzfdzGvn+EbDncRqXKOiaMvHy
         f/rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=gav8ijUBF61wP1+X8OQ02YRSM92QldsTlZ+CycghqWQ=;
        b=PGhRxok5sBr/haXEu5ZjAAnTnbp6x2TuDL2C1cZ7PygT66kOH6/IiNoXDv9mZVSnG7
         9cAFyGlILZz1W1mSIre2IBvfXb5VrFi4Z0sgs+srmMngb812CGeQFHS8S1VG5qhJFHY5
         zc6rDoQFeqmIln3Rf0gpTnCe0Ab5dhmakhfxI9gnAVXrBRM0IXaDx8RHmVCVFsQM8kPN
         463lhqwkh00iITulfHbmMvBUczP8CAXJy3VlOs4hEB659/TVpaDnoEh2jrBSSgHC4VLk
         RJayKbadVYLR5ZgxL8nQpt7pCb0P8hoJj8Uez7uHaCintE1V9rOfOm0OucuvybxOkNCO
         cqGQ==
X-Gm-Message-State: AOAM532j7ix0ihDXCteb0p1pEyLWySaXE81tZaCpOjVqympcf32+XLuF
        kQT9aM6cIx0BsiQJgD/ZG6M=
X-Google-Smtp-Source: ABdhPJysdFzYXvC1j93G3qEsquf7FXPHR9CcklrrqqoU1stw2CZaEvMVlbtS1FupazdvvJ6WmJLCpA==
X-Received: by 2002:a6b:f40a:: with SMTP id i10mr26246091iog.155.1592932404992;
        Tue, 23 Jun 2020 10:13:24 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id u15sm4107579iog.18.2020.06.23.10.13.18
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 23 Jun 2020 10:13:24 -0700 (PDT)
Subject: [bpf PATCH] bpf: do not allow btf_ctx_access with __int128 types
From:   John Fastabend <john.fastabend@gmail.com>
To:     jolsa@kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        john.fastabend@gmail.com
Date:   Tue, 23 Jun 2020 10:13:12 -0700
Message-ID: <159293239241.32225.12338844121877017327.stgit@john-Precision-5820-Tower>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To ensure btf_ctx_access() is safe the verifier checks that the BTF
arg type is an int, enum, or pointer. When the function does the
BTF arg lookup it uses the calculation 'arg = off / 8'  using the
fact that registers are 8B. This requires that the first arg is
in the first reg, the second in the second, and so on. However,
for __int128 the arg will consume two registers by default LLVM
implementation. So this will cause the arg layout assumed by the
'arg = off / 8' calculation to be incorrect.

Because __int128 is uncommon this patch applies the easiest fix and
will force int types to be sizeof(u64) or smaller so that they will
fit in a single register.

Fixes: 9e15db66136a1 ("bpf: Implement accurate raw_tp context access via BTF")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 include/linux/btf.h |    5 +++++
 kernel/bpf/btf.c    |    4 ++--
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/include/linux/btf.h b/include/linux/btf.h
index 5c1ea99..35642f6 100644
--- a/include/linux/btf.h
+++ b/include/linux/btf.h
@@ -82,6 +82,11 @@ static inline bool btf_type_is_int(const struct btf_type *t)
 	return BTF_INFO_KIND(t->info) == BTF_KIND_INT;
 }
 
+static inline bool btf_type_is_small_int(const struct btf_type *t)
+{
+	return btf_type_is_int(t) && (t->size <= sizeof(u64));
+}
+
 static inline bool btf_type_is_enum(const struct btf_type *t)
 {
 	return BTF_INFO_KIND(t->info) == BTF_KIND_ENUM;
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 58c9af1..9a1a98d 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -3746,7 +3746,7 @@ bool btf_ctx_access(int off, int size, enum bpf_access_type type,
 				return false;
 
 			t = btf_type_skip_modifiers(btf, t->type, NULL);
-			if (!btf_type_is_int(t)) {
+			if (!btf_type_is_small_int(t)) {
 				bpf_log(log,
 					"ret type %s not allowed for fmod_ret\n",
 					btf_kind_str[BTF_INFO_KIND(t->info)]);
@@ -3768,7 +3768,7 @@ bool btf_ctx_access(int off, int size, enum bpf_access_type type,
 	/* skip modifiers */
 	while (btf_type_is_modifier(t))
 		t = btf_type_by_id(btf, t->type);
-	if (btf_type_is_int(t) || btf_type_is_enum(t))
+	if (btf_type_is_small_int(t) || btf_type_is_enum(t))
 		/* accessing a scalar */
 		return true;
 	if (!btf_type_is_ptr(t)) {

