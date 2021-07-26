Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 418E13D555E
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 10:23:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232808AbhGZHio (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 03:38:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233010AbhGZHiK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 03:38:10 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EE78C0617A1
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 01:18:38 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id n2so9426665eda.10
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 01:18:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=anyfinetworks-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BV0g4jcYTdScS9hJerOKHAsgtkMy07OGBzUAP0n2p64=;
        b=aW/lXBZrFQHBhwkFKP3ZMvi1P5h4ej9+5LCQkS5k800xgGjswPZoBSMJyvUtu36w02
         Fmlou3m0sqdi1vtFTlFWpN4fUwLrzwneNabL6peuDPfWtQWMeOmU8eDTU0QBdCkLqlnX
         Zcnv/Qt4K9MiuNvT3Je935oDIbhS3K4MX8DodDFRsf7cFD5f5qkQCgdlm3ivqDyayCJp
         M1A7cn9nAn231XA5QXJ7o0dBi6imhqTAS5+VmrpHf/NoSp0dqfCWlfPuu3E5yB1Ri6oW
         C0LLsWV2pKOxyFIn5hc2MBbka4ko3Mao8g+wRRYUMoY51PRvYSzFLBgaB67qJLrqtMJB
         ilDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BV0g4jcYTdScS9hJerOKHAsgtkMy07OGBzUAP0n2p64=;
        b=kaD2VbOXSGI4iLwmi654/XyeATu8/FldGrOChoqBkL/Sx/L7261hvN3v8auxChxdHy
         TMz3m8N6yNNJpuPys9wdVv1FjYXEe1G/66Nhx0LCZ86MKjot8XBGeQfM4vnvrQYYwZdP
         6TQTP/5tXZQbt088FrIB2t+dH9tKHDNtprt3sqna11pkBg5hDnvf5F/rTK6NFNFkyPOJ
         +t7rjqfhlDwdHT1L4+RLfNZQShOFZVxJjHKvPZ5HLdjDbzUySrIlL/0iu2csi0XgU0If
         O6hXUEgom3uTBOXmQAqCkjdsF6QnCxGBptknHB5LWLPovKwcf54caaVjQfusoSahRFp6
         wkxQ==
X-Gm-Message-State: AOAM5305q3/MP5NF9GPhomLzrWJeg68ib3kjbh3+5skP6+KxkTdpT0+Z
        vsLHHlucQEun5raPaXOwLO1w1w==
X-Google-Smtp-Source: ABdhPJwP3tEa6vzq+cQMjIWt5ViIjLFx9wrUdfc6/JIs80boPCfImYZSQ5Ebz48NS/ksshV+dzs4hA==
X-Received: by 2002:a05:6402:1242:: with SMTP id l2mr19784204edw.97.1627287517274;
        Mon, 26 Jul 2021 01:18:37 -0700 (PDT)
Received: from anpc2.lan (static-213-115-136-2.sme.telenor.se. [213.115.136.2])
        by smtp.gmail.com with ESMTPSA id q9sm13937539ejf.70.2021.07.26.01.18.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jul 2021 01:18:36 -0700 (PDT)
From:   Johan Almbladh <johan.almbladh@anyfinetworks.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        Tony.Ambardar@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>
Subject: [RFC PATCH 09/14] bpf/tests: add word-order tests for load/store of double words
Date:   Mon, 26 Jul 2021 10:17:33 +0200
Message-Id: <20210726081738.1833704-10-johan.almbladh@anyfinetworks.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210726081738.1833704-1-johan.almbladh@anyfinetworks.com>
References: <20210726081738.1833704-1-johan.almbladh@anyfinetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A double word (64-bit) load/store may be implemented as two successive
32-bit operations, one for each word. Check that the order of those
operations is consistent with the machine endianness.

Signed-off-by: Johan Almbladh <johan.almbladh@anyfinetworks.com>
---
 lib/test_bpf.c | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/lib/test_bpf.c b/lib/test_bpf.c
index 1115e39630ce..8b94902702ed 100644
--- a/lib/test_bpf.c
+++ b/lib/test_bpf.c
@@ -5417,6 +5417,42 @@ static struct bpf_test tests[] = {
 		{ { 0, 0xffffffff } },
 		.stack_depth = 40,
 	},
+	{
+		"STX_MEM_DW: Store double word: first word in memory",
+		.u.insns_int = {
+			BPF_LD_IMM64(R0, 0),
+			BPF_LD_IMM64(R1, 0x0123456789abcdefLL),
+			BPF_STX_MEM(BPF_DW, R10, R1, -40),
+			BPF_LDX_MEM(BPF_W, R0, R10, -40),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+#ifdef __BIG_ENDIAN
+		{ { 0, 0x01234567 } },
+#else
+		{ { 0, 0x89abcdef } },
+#endif
+		.stack_depth = 40,
+	},
+	{
+		"STX_MEM_DW: Store double word: second word in memory",
+		.u.insns_int = {
+			BPF_LD_IMM64(R0, 0),
+			BPF_LD_IMM64(R1, 0x0123456789abcdefLL),
+			BPF_STX_MEM(BPF_DW, R10, R1, -40),
+			BPF_LDX_MEM(BPF_W, R0, R10, -36),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+#ifdef __BIG_ENDIAN
+		{ { 0, 0x89abcdef } },
+#else
+		{ { 0, 0x01234567 } },
+#endif
+		.stack_depth = 40,
+	},
 	/* BPF_STX | BPF_ATOMIC | BPF_W/DW */
 	{
 		"STX_XADD_W: Test: 0x12 + 0x10 = 0x22",
-- 
2.25.1

