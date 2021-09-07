Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C7E44030F9
	for <lists+netdev@lfdr.de>; Wed,  8 Sep 2021 00:25:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349276AbhIGWZV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 18:25:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348378AbhIGWZG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Sep 2021 18:25:06 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7383FC061575
        for <netdev@vger.kernel.org>; Tue,  7 Sep 2021 15:23:59 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id mf2so6006ejb.9
        for <netdev@vger.kernel.org>; Tue, 07 Sep 2021 15:23:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=anyfinetworks-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=J0f5jVcksFy4YRNLGjbRBcdH4KEBNN3Q3Q2xThuDCKg=;
        b=ekvGOWm3GywuqTBDsN+csbEfHchz/0qck+uoAYdjfpl5Jb6PrWM/Zd5f0yOmXqWpBV
         umZaa3A167yiRtGpY8il28GEfgRp/dfP38AZSdKabuR8pVS88LhXj5jhMQXHnXTXmCcp
         3UOSTazWf+GQg25BJX43pl3HXk0EYE68C/TblA3mluGOPHAw8x6f7LocIuGZXsIIKOSR
         +0Uq78702T44TUUnJn0ycuerXV5f3+f4tk0IdonzIwLxYuuuSYJkTpZqa9CwFwIwpxb+
         BzfMzQw3iDvyXWJ41let5Xg8HR6rloNHJh9U0OgShp7EBhNt4S+yJePq85LRQladHPRl
         uKaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=J0f5jVcksFy4YRNLGjbRBcdH4KEBNN3Q3Q2xThuDCKg=;
        b=iQk4bR8/IrAcW94JqndTQGavuRSO3hYcHwOtoExh3RZiCW5q4SE2T0BwmI5Kmi+S6Q
         IGrWSy7/6hSleh35/J7NuHFRUCcuYnim+Ve6WLWjg818hIjFOl6dxkc5lAOs3RMehzgl
         MFst9VRVs/ozCZanLbvCc844pWKKA85Kl+pplmzv9dy5nA3dQOy1QwNOSV9NDIfo7rZk
         lp0KoK10NX+J2jmq2JpahZLkKJ50CZGX0z/WsLKQ0qKZjhKkz4WjA//O9gPA0LjO938K
         rFNn6xkM59rFa6W49h3bvW8EM10F/wRRGdBOQyf4ny7lL5YP3hd393sYtuNwoUWTt7wK
         KFvQ==
X-Gm-Message-State: AOAM531cL59QdH8Pd0qA9rJHcLdgWgINaTqz5eL8+nl7pM0iDF72v1dd
        3IfX7IvCLhHogF5pqkVpdU6V/w==
X-Google-Smtp-Source: ABdhPJzNmGCsAC9sTJgFBSmx2JMy4diEccCwiWEDSuMsgshA9CWAMyxOceSXGCSGXrQi3G+5Oxi6vw==
X-Received: by 2002:a17:907:aa4:: with SMTP id bz4mr629006ejc.97.1631053438120;
        Tue, 07 Sep 2021 15:23:58 -0700 (PDT)
Received: from anpc2.lan (static-213-115-136-2.sme.telenor.se. [213.115.136.2])
        by smtp.gmail.com with ESMTPSA id gb24sm71772ejc.53.2021.09.07.15.23.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Sep 2021 15:23:57 -0700 (PDT)
From:   Johan Almbladh <johan.almbladh@anyfinetworks.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, iii@linux.ibm.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>
Subject: [PATCH bpf-next v2 09/13] bpf/tests: Add JMP tests with small offsets
Date:   Wed,  8 Sep 2021 00:23:35 +0200
Message-Id: <20210907222339.4130924-10-johan.almbladh@anyfinetworks.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210907222339.4130924-1-johan.almbladh@anyfinetworks.com>
References: <20210907222339.4130924-1-johan.almbladh@anyfinetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds a set of tests for JMP to verify that the JITed jump
offset is calculated correctly. We pretend that the verifier has inserted
any zero extensions to make the jump-over operations JIT to one
instruction each, in order to control the exact JITed jump offset.

Signed-off-by: Johan Almbladh <johan.almbladh@anyfinetworks.com>
---
 lib/test_bpf.c | 71 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 71 insertions(+)

diff --git a/lib/test_bpf.c b/lib/test_bpf.c
index 26f7c244c78a..7286cf347b95 100644
--- a/lib/test_bpf.c
+++ b/lib/test_bpf.c
@@ -10709,6 +10709,77 @@ static struct bpf_test tests[] = {
 		.fill_helper = bpf_fill_jmp32_jsle_reg,
 		.nr_testruns = NR_PATTERN_RUNS,
 	},
+	/* Short relative jumps */
+	{
+		"Short relative jump: offset=0",
+		.u.insns_int = {
+			BPF_ALU64_IMM(BPF_MOV, R0, 0),
+			BPF_JMP_IMM(BPF_JEQ, R0, 0, 0),
+			BPF_EXIT_INSN(),
+			BPF_ALU32_IMM(BPF_MOV, R0, -1),
+		},
+		INTERNAL | FLAG_NO_DATA | FLAG_VERIFIER_ZEXT,
+		{ },
+		{ { 0, 0 } },
+	},
+	{
+		"Short relative jump: offset=1",
+		.u.insns_int = {
+			BPF_ALU64_IMM(BPF_MOV, R0, 0),
+			BPF_JMP_IMM(BPF_JEQ, R0, 0, 1),
+			BPF_ALU32_IMM(BPF_ADD, R0, 1),
+			BPF_EXIT_INSN(),
+			BPF_ALU32_IMM(BPF_MOV, R0, -1),
+		},
+		INTERNAL | FLAG_NO_DATA | FLAG_VERIFIER_ZEXT,
+		{ },
+		{ { 0, 0 } },
+	},
+	{
+		"Short relative jump: offset=2",
+		.u.insns_int = {
+			BPF_ALU64_IMM(BPF_MOV, R0, 0),
+			BPF_JMP_IMM(BPF_JEQ, R0, 0, 2),
+			BPF_ALU32_IMM(BPF_ADD, R0, 1),
+			BPF_ALU32_IMM(BPF_ADD, R0, 1),
+			BPF_EXIT_INSN(),
+			BPF_ALU32_IMM(BPF_MOV, R0, -1),
+		},
+		INTERNAL | FLAG_NO_DATA | FLAG_VERIFIER_ZEXT,
+		{ },
+		{ { 0, 0 } },
+	},
+	{
+		"Short relative jump: offset=3",
+		.u.insns_int = {
+			BPF_ALU64_IMM(BPF_MOV, R0, 0),
+			BPF_JMP_IMM(BPF_JEQ, R0, 0, 3),
+			BPF_ALU32_IMM(BPF_ADD, R0, 1),
+			BPF_ALU32_IMM(BPF_ADD, R0, 1),
+			BPF_ALU32_IMM(BPF_ADD, R0, 1),
+			BPF_EXIT_INSN(),
+			BPF_ALU32_IMM(BPF_MOV, R0, -1),
+		},
+		INTERNAL | FLAG_NO_DATA | FLAG_VERIFIER_ZEXT,
+		{ },
+		{ { 0, 0 } },
+	},
+	{
+		"Short relative jump: offset=4",
+		.u.insns_int = {
+			BPF_ALU64_IMM(BPF_MOV, R0, 0),
+			BPF_JMP_IMM(BPF_JEQ, R0, 0, 4),
+			BPF_ALU32_IMM(BPF_ADD, R0, 1),
+			BPF_ALU32_IMM(BPF_ADD, R0, 1),
+			BPF_ALU32_IMM(BPF_ADD, R0, 1),
+			BPF_ALU32_IMM(BPF_ADD, R0, 1),
+			BPF_EXIT_INSN(),
+			BPF_ALU32_IMM(BPF_MOV, R0, -1),
+		},
+		INTERNAL | FLAG_NO_DATA | FLAG_VERIFIER_ZEXT,
+		{ },
+		{ { 0, 0 } },
+	},
 	/* Staggered jump sequences, immediate */
 	{
 		"Staggered jumps: JMP_JA",
-- 
2.25.1

