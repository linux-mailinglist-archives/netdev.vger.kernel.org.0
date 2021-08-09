Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4B963E426D
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 11:19:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234365AbhHIJTf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 05:19:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234373AbhHIJTN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 05:19:13 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 591EAC061798
        for <netdev@vger.kernel.org>; Mon,  9 Aug 2021 02:18:53 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id cf5so23533725edb.2
        for <netdev@vger.kernel.org>; Mon, 09 Aug 2021 02:18:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=anyfinetworks-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NEuJ/ph9W8GsGRnb9nvqKcUj76sJQox9oSzfTRyPjpw=;
        b=TTEcmc8GkqewKQ3bVCoKXg303GoLO/eFp1IxP8Sl0jPZXz8X9e5XyJm5WNz7L9Gd+c
         nFl23sLoZj9ks8Yhscp4u6WtEdIBW1zbPV5eY2Emo0hFQWdCmAee7YfabWFxZ3kZRBlW
         QkoC9ijojYKer6N5efGhFUJHtcD94WGpovpWfeEVKa6otLSjmDGckmLa3ab6mvBs0fb4
         IBwgIKaIsSnn3Nom5qt22K4/baO3GzF58jCZF+O5SIIPIijQ3BchKA9t1s6ZPX5Du5S1
         +uMxtd0YQmd65b52rtGdDZ4JTWlNbT6a5k9aZYzvTi2F0lNK6uTPWNLV0hlPZH87ZoKC
         8JYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NEuJ/ph9W8GsGRnb9nvqKcUj76sJQox9oSzfTRyPjpw=;
        b=kMuu2LmGR6pY1zqiESi0TTBW813Yz1gqhUiql/Yh8Sb1A1kCUYMeWFjE+mhE4XYsCv
         Udc0xTH91PLwY87pTxMqjHgfatEsLOPa+zzKJG0u0Pu74wtE60SrYPa7Yll4boJoahTw
         SUunCYTyDX8ngBQ2MPybQKY/K/mtpD5tgYiGjJ1oR0qeK2JZVaAfxTOa7rj2JiIvdQpL
         J4ehFZ/YHustutfAEAKEPWDyqMwJxcyqkVliAwDXoyXVQLKXIvPV7uXrksOMLXi8VyTS
         mowWe+PxdrPmTD73YtKi9jxbmNf9zYe3dwaFUcjhsKtsexzRUdt0XyxHxyxx9FZHxEk4
         TY0g==
X-Gm-Message-State: AOAM531J7xa10uAp5Bs2kwE4pWKklPnTXQVoZyOcuhSfFGpRJwGMn3PU
        dNUaLqm0Yny1+WUychTVQZrr+A==
X-Google-Smtp-Source: ABdhPJxZyVP97t66CKLgRUvA0QBKfHw395GUl/7PZHjK1WIHMKslNeQm93tMsoJuAlX6olcimjGTQQ==
X-Received: by 2002:aa7:d3cf:: with SMTP id o15mr6411672edr.98.1628500732017;
        Mon, 09 Aug 2021 02:18:52 -0700 (PDT)
Received: from anpc2.lan (static-213-115-136-2.sme.telenor.se. [213.115.136.2])
        by smtp.gmail.com with ESMTPSA id dg24sm1234250edb.6.2021.08.09.02.18.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 02:18:51 -0700 (PDT)
From:   Johan Almbladh <johan.almbladh@anyfinetworks.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        Tony.Ambardar@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>
Subject: [PATCH bpf-next v2 10/14] bpf/tests: Add branch conversion JIT test
Date:   Mon,  9 Aug 2021 11:18:25 +0200
Message-Id: <20210809091829.810076-11-johan.almbladh@anyfinetworks.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210809091829.810076-1-johan.almbladh@anyfinetworks.com>
References: <20210809091829.810076-1-johan.almbladh@anyfinetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some JITs may need to convert a conditional jump instruction to
to short PC-relative branch and a long unconditional jump, if the
PC-relative offset exceeds offset field width in the CPU instruction.
This test triggers such branch conversion on the 32-bit MIPS JIT.

Signed-off-by: Johan Almbladh <johan.almbladh@anyfinetworks.com>
---
 lib/test_bpf.c | 43 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/lib/test_bpf.c b/lib/test_bpf.c
index 402c199cc119..896d37f4f4b3 100644
--- a/lib/test_bpf.c
+++ b/lib/test_bpf.c
@@ -461,6 +461,41 @@ static int bpf_fill_stxdw(struct bpf_test *self)
 	return __bpf_fill_stxdw(self, BPF_DW);
 }
 
+static int bpf_fill_long_jmp(struct bpf_test *self)
+{
+	unsigned int len = BPF_MAXINSNS;
+	struct bpf_insn *insn;
+	int i;
+
+	insn = kmalloc_array(len, sizeof(*insn), GFP_KERNEL);
+	if (!insn)
+		return -ENOMEM;
+
+	insn[0] = BPF_ALU64_IMM(BPF_MOV, R0, 1);
+	insn[1] = BPF_JMP_IMM(BPF_JEQ, R0, 1, len - 2 - 1);
+
+	/*
+	 * Fill with a complex 64-bit operation that expands to a lot of
+	 * instructions on 32-bit JITs. The large jump offset can then
+	 * overflow the conditional branch field size, triggering a branch
+	 * conversion mechanism in some JITs.
+	 *
+	 * Note: BPF_MAXINSNS of ALU64 MUL is enough to trigger such branch
+	 * conversion on the 32-bit MIPS JIT. For other JITs, the instruction
+	 * count and/or operation may need to be modified to trigger the
+	 * branch conversion.
+	 */
+	for (i = 2; i < len - 1; i++)
+		insn[i] = BPF_ALU64_IMM(BPF_MUL, R0, (i << 16) + i);
+
+	insn[len - 1] = BPF_EXIT_INSN();
+
+	self->u.ptr.insns = insn;
+	self->u.ptr.len = len;
+
+	return 0;
+}
+
 static struct bpf_test tests[] = {
 	{
 		"TAX",
@@ -6895,6 +6930,14 @@ static struct bpf_test tests[] = {
 		{ },
 		{ { 0, 1 } },
 	},
+	{	/* Mainly checking JIT here. */
+		"BPF_MAXINSNS: Very long conditional jump",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_long_jmp,
+	},
 	{
 		"JMP_JA: Jump, gap, jump, ...",
 		{ },
-- 
2.25.1

