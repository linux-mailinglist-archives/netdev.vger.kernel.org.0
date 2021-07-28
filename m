Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AFFF3D93EC
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 19:06:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231191AbhG1RGF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 13:06:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231245AbhG1RFp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 13:05:45 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A9E6C0617A5
        for <netdev@vger.kernel.org>; Wed, 28 Jul 2021 10:05:42 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id x14so4165477edr.12
        for <netdev@vger.kernel.org>; Wed, 28 Jul 2021 10:05:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=anyfinetworks-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RRL0VLp6qutZXrZd4cRKeYTVqt51qEo+4j74ZFYX/gc=;
        b=KRfqerB4VTDxxbA3y6UzEebVUH0ALRUnLBb3IjTdzlb2dtDlof8ZjWQUf7+xVeZDOP
         TtaWQ+fntm89vMX06hrbgCd0IcGVvDItsvRthw8CxsAjQWmp0IKG3YH9rbTyMiYuoMN4
         o9a655OWi10lrM2U1wdtz9EgSH6ddQvwa40jvo59XqtkL0L8ElFqip1aowa4Cdk5ZSmk
         qohiTk2mka5LOo/rz0zXHAyxiabNqx7Srxr9DhI/JChErvpDIoFH4Kz5UT5taK3s16ZH
         bURl9a9Ps22Whw4c0u87lZ0jakDZOm82veT8hizsJUAg9pZ8+NOJPTFs/4k6V1UAkAID
         tK5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RRL0VLp6qutZXrZd4cRKeYTVqt51qEo+4j74ZFYX/gc=;
        b=KogN8gLnPUoSE5YIgU23yte2F/zSgSV/+GawOAPYTrx93vmkQ6uIZJA0QynnJaF5sm
         mj31vSUU0pbeFC2iW9+N1iEvSxjpwxa362K27xxWtOJTcOScZh22l3XN/j+exQ8gfPG1
         /9Yt/1IDAvUWeEjDwdT617ylszbXskytDwWD4I3BN7L9pZ2llLR0X3P0e94jFmkEr50G
         R64LaKEgWuccCwqiIcHUC0ld+dqN15S2dEWjgiuwgKqCp3TkkiiQRS2TXU4pQe0ow68F
         Ik8b8DI2OAzOTUiwJA8dgGKSYLhI2TN/4C9FLNBggNtz88JTIBXeyKiMlXthAvSD15xo
         L2lQ==
X-Gm-Message-State: AOAM533eEkxXjK4eWKZShpnzUdqCx271/PMgEMZcIEfqnpD6D6TtsXE6
        V3o0C+1Pv9aPRyD1ktogkD5gvSsmzZHsu7lYMqk=
X-Google-Smtp-Source: ABdhPJzEl6xuRN5mlrhZ5qK3Q+xJly8EfAb/H8Lwegn+sSFyypw9tAcur2O0cxMRQw+fZWuUoEEVpw==
X-Received: by 2002:a50:fe10:: with SMTP id f16mr965092edt.85.1627491940668;
        Wed, 28 Jul 2021 10:05:40 -0700 (PDT)
Received: from anpc2.lan (static-213-115-136-2.sme.telenor.se. [213.115.136.2])
        by smtp.gmail.com with ESMTPSA id bd24sm139349edb.56.2021.07.28.10.05.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 10:05:40 -0700 (PDT)
From:   Johan Almbladh <johan.almbladh@anyfinetworks.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        Tony.Ambardar@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>
Subject: [PATCH 10/14] bpf/tests: Add branch conversion JIT test
Date:   Wed, 28 Jul 2021 19:04:58 +0200
Message-Id: <20210728170502.351010-11-johan.almbladh@anyfinetworks.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210728170502.351010-1-johan.almbladh@anyfinetworks.com>
References: <20210728170502.351010-1-johan.almbladh@anyfinetworks.com>
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
 lib/test_bpf.c | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/lib/test_bpf.c b/lib/test_bpf.c
index 8b94902702ed..55914b6236aa 100644
--- a/lib/test_bpf.c
+++ b/lib/test_bpf.c
@@ -461,6 +461,36 @@ static int bpf_fill_stxdw(struct bpf_test *self)
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
@@ -6892,6 +6922,14 @@ static struct bpf_test tests[] = {
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

