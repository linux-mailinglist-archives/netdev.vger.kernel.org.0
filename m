Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2AA83D5560
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 10:23:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233194AbhGZHiv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 03:38:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232783AbhGZHiL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 03:38:11 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 949A6C0613D5
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 01:18:40 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id gt31so15015526ejc.12
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 01:18:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=anyfinetworks-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Y/3mORpxkuB6AYmO7nTlUm+T8wNLmTVSEafeQ3TI9HU=;
        b=EFvWIrJE9buKJTtSmYumCJi3hFL4WZmcPxtCdFjdk5lMga9XOXZSnauRqVtE548LOA
         Lb0VxpPl9RohHkR4FjN1FYj+8Nf5ybpd7mwKbfvCR6t9JWPIwvf6iKnyEq1dhysyFa4S
         oOUPfiHHlS3tS4RhbqwU3GfXK0BKniOZ3MaBPMfb9jJE3/mag1KEGPiqt4lcJw6kVcBO
         O6viSgdfPuAwNw9nAx/5LrcEmuUjOb9JXD6r8PbIEBoK7fn/KQoZheP2kkjKjocfGS3o
         86FVVFhfQjxucN6od5ll//wJtt9A1nO1CWcBNTtk3R8bQ1rxuOgjdDcYdP2sIlW6Djf3
         6gVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Y/3mORpxkuB6AYmO7nTlUm+T8wNLmTVSEafeQ3TI9HU=;
        b=aiAXTA4hgPt2aELF8T4NnsG82CHOr+SG4alAhMkiwRnWeV/Zj46FMt4lBDKlVMQg8A
         zd3CtI+zwRhj0HG9TMn53nctAX2hi0bIPJJinhAI8Eb6FSq6HBZOIyFMtdZjtcq6BdGB
         YatIxr6nvOJERRxu9CTBI030j+tx9fLhvVC/vFlRCaj0lC452eOLJWKiqf/19dzsYRZm
         nVg1VkkLENlaakBh7BdEg08jOsGJHakLBfeXKgZVl5irBbZ2bi4S/5IpQkZBHvSsJSyR
         1AMyiMSKQHWeFKXctDGqvJbSkvnsIHJGAbQeZF7VFWVKHQsK+z35+LkboGi/aPus/zjZ
         zKfA==
X-Gm-Message-State: AOAM533UgNgkU0ete7WXW84Idd+mKwbqy/hgRAoE3XkkI/4o0trP7DXi
        s037L6oxsqXGCyshf0n1Ds/i0A==
X-Google-Smtp-Source: ABdhPJxXWdghP9RHL8bsAIg3jvfVJ7efL+iEYI85sKehCFcC79s1Z7VaNWf/kzxm6S53XxURP48wzw==
X-Received: by 2002:a17:906:ae4d:: with SMTP id lf13mr16053726ejb.355.1627287519177;
        Mon, 26 Jul 2021 01:18:39 -0700 (PDT)
Received: from anpc2.lan (static-213-115-136-2.sme.telenor.se. [213.115.136.2])
        by smtp.gmail.com with ESMTPSA id q9sm13937539ejf.70.2021.07.26.01.18.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jul 2021 01:18:38 -0700 (PDT)
From:   Johan Almbladh <johan.almbladh@anyfinetworks.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        Tony.Ambardar@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>
Subject: [RFC PATCH 11/14] bpf/tests: add test for 32-bit context pointer argument passing
Date:   Mon, 26 Jul 2021 10:17:35 +0200
Message-Id: <20210726081738.1833704-12-johan.almbladh@anyfinetworks.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210726081738.1833704-1-johan.almbladh@anyfinetworks.com>
References: <20210726081738.1833704-1-johan.almbladh@anyfinetworks.com>
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

