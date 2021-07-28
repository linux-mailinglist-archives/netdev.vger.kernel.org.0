Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E983C3D93E7
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 19:06:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231315AbhG1RGB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 13:06:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231213AbhG1RFp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 13:05:45 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22DE8C061765
        for <netdev@vger.kernel.org>; Wed, 28 Jul 2021 10:05:43 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id hp25so5690827ejc.11
        for <netdev@vger.kernel.org>; Wed, 28 Jul 2021 10:05:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=anyfinetworks-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Y/3mORpxkuB6AYmO7nTlUm+T8wNLmTVSEafeQ3TI9HU=;
        b=zTu9BEJ85uqBUflZ6s237uQXXVTvtcUIoDa4B7I+Xpk/GkZZKhT3HedOepeMz44QsV
         FLvpDFG9Jnp5Bj+TsAGeQiKHYCxnAPiJGaxjZL/l8EHLHv/vYopX+lL4YQ0sLOXR0GBi
         5nrNdrsMX4qmfBbXq0tQpcaK6eyaxvWeIi244jQTk2YRv2eDjzeATP8Uu2Do22+bPd0V
         qh5w2lQsYrpo1KRcBEP0I16JDnTPVI1y91d3icXSOLxTnf3bO3Nt+IICNp1XW0XMyaUr
         yARW8shycR6cDdVHbX3WBYLsvD3oN5qOwu4KWMH/bcH2qqjTz9NeDocsEHQPVwAy1PwU
         Togw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Y/3mORpxkuB6AYmO7nTlUm+T8wNLmTVSEafeQ3TI9HU=;
        b=HXtgXnxQUibunujqCMZzsenxTEA5jxef6nFSKuUvco0D9cRLVXzeWqCVBTascxx32r
         omnVaZnlswcM8R4xjMH4A/UAZjCQHPqYUPzPjBxfhn+sVoAt8Zpbbq0/cXZgF+x/JmR4
         uZt4hTvj/l6EJ8lk0yQH6QETwOc0t1DAIKbYdnISLXHXBWADy+gDtT4S0qadSDIOl14Y
         CTBZnOOGNGmieibvS5kI0mVwzTZUT3agLZhxB9MPI9utypxq0kXii9O8FjKVpL64dv3R
         ou+XqjDp6v9ujNd9STylKjNPtWr2xwEfoPvE8w0nD4x8c/n2VnvZYRoTAaQ5XOo5e/fW
         zyTw==
X-Gm-Message-State: AOAM530Ij8MAOAxBbQEplpYvTq5zxypcpe6dJoSHLH556uBTo1oXFGlv
        tTwqbe7tQLrtQ1yHHGVOqTwj3g==
X-Google-Smtp-Source: ABdhPJwW0hs5zOM54rAu+DDEexNEk6cdseE/NOgpp6cQ95uX4fbZGbYENYE9CSAxlsGjaurpjeYekA==
X-Received: by 2002:a17:906:b0d4:: with SMTP id bk20mr406826ejb.535.1627491941786;
        Wed, 28 Jul 2021 10:05:41 -0700 (PDT)
Received: from anpc2.lan (static-213-115-136-2.sme.telenor.se. [213.115.136.2])
        by smtp.gmail.com with ESMTPSA id bd24sm139349edb.56.2021.07.28.10.05.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 10:05:41 -0700 (PDT)
From:   Johan Almbladh <johan.almbladh@anyfinetworks.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        Tony.Ambardar@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>
Subject: [PATCH 11/14] bpf/tests: Add test for 32-bit context pointer argument passing
Date:   Wed, 28 Jul 2021 19:04:59 +0200
Message-Id: <20210728170502.351010-12-johan.almbladh@anyfinetworks.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210728170502.351010-1-johan.almbladh@anyfinetworks.com>
References: <20210728170502.351010-1-johan.almbladh@anyfinetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On a 32-bit architecture, the context pointer should occupy the low
half of R0, and the other half should be zero.

Signed-off-by: Johan Almbladh <johan.almbladh@anyfinetworks.com>
---
 lib/test_bpf.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/lib/test_bpf.c b/lib/test_bpf.c
index 55914b6236aa..314af6eaeb92 100644
--- a/lib/test_bpf.c
+++ b/lib/test_bpf.c
@@ -2084,6 +2084,22 @@ static struct bpf_test tests[] = {
 #undef NUMER
 #undef DENOM
 	},
+#ifdef CONFIG_32BIT
+	{
+		"INT: 32-bit context pointer word order and zero-extension",
+		.u.insns_int = {
+			BPF_ALU32_IMM(BPF_MOV, R0, 0),
+			BPF_JMP32_IMM(BPF_JEQ, R1, 0, 3),
+			BPF_ALU64_IMM(BPF_RSH, R1, 32),
+			BPF_JMP32_IMM(BPF_JNE, R1, 0, 1),
+			BPF_ALU32_IMM(BPF_MOV, R0, 1),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, 1 } }
+	},
+#endif
 	{
 		"check: missing ret",
 		.u.insns = {
-- 
2.25.1

