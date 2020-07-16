Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B37B2225E8
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 16:39:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728955AbgGPOjm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 10:39:42 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58247 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728949AbgGPOji (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 10:39:38 -0400
Received: from mail-il1-f198.google.com ([209.85.166.198])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <seth.forshee@canonical.com>)
        id 1jw52u-0006uh-7M
        for netdev@vger.kernel.org; Thu, 16 Jul 2020 14:39:36 +0000
Received: by mail-il1-f198.google.com with SMTP id c1so3848040ilr.0
        for <netdev@vger.kernel.org>; Thu, 16 Jul 2020 07:39:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=R6Vp2q7Z0AYp/kVnpoBWr500ikgjJpj3Qnu3Hl9IZkg=;
        b=lzMMiLlDUICBTRP6c61+xgTuPxZryigMRgQ9v++sazdfamCpakFSYtD2goqMg6t8o7
         oEZ3VCE87/ezxgL26Aael+bcAtxOncgDWIZ0+k+IzqK4gMr68oeQDayJwAU3hUIUVhuU
         IfZfQyll5ttz/mWM8/hvcZXouM/6mK/aKvcpZYcbcQ1Gv4tOk7B2qZLXv1RhR4I6W0NP
         6kL2mzzafZ7Pi18Dlt1XwBghLAX33TS5BDwylGlwGqE07y6ZExNFdR9VupBEv3mC+yC9
         CTdpI2SnMhQPHlxVrbrwSuq0Vtio8r2J9gG2/koJJAbkBLChITgr47d9qXewZJ5N3LfK
         XoVw==
X-Gm-Message-State: AOAM532Q16UNZbCVlOhOde7iJnUgTBt4WBt4dmNLlkniTtEeq1T7MGK9
        GyMtrb4aZlZkgffHHwJreEB5/VveW7pYUpBO0PIi8naqshYZslrQy1iIPTfxdv+GA1IwvR15+Jm
        JKcK2wwzD75pweVRh/FN1LKyLC9P39FYnag==
X-Received: by 2002:a92:aac8:: with SMTP id p69mr5123516ill.26.1594910373226;
        Thu, 16 Jul 2020 07:39:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyBPP1hBjN4dv0mJH0CucnCvELVhUU8DEtOkN3QnRH7+kA6uRArkIsCl5a4LLp7dyeEYbWQWw==
X-Received: by 2002:a92:aac8:: with SMTP id p69mr5123478ill.26.1594910372525;
        Thu, 16 Jul 2020 07:39:32 -0700 (PDT)
Received: from localhost ([2605:a601:ac0f:820:90fa:132a:bf3e:99a1])
        by smtp.gmail.com with ESMTPSA id j19sm2779760ile.36.2020.07.16.07.39.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2020 07:39:31 -0700 (PDT)
From:   Seth Forshee <seth.forshee@canonical.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Ilya Leoshkevich <iii@linux.ibm.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Revert "test_bpf: flag tests that cannot be jited on s390"
Date:   Thu, 16 Jul 2020 09:39:31 -0500
Message-Id: <20200716143931.330122-1-seth.forshee@canonical.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit 3203c9010060806ff88c9989aeab4dc8d9a474dc.

The s390 bpf JIT previously had a restriction on the maximum
program size, which required some tests in test_bpf to be flagged
as expected failures. The program size limitation has been removed,
and the tests now pass, so these tests should no longer be flagged.

Fixes: d1242b10ff03 ("s390/bpf: Remove JITed image size limitations")
Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 lib/test_bpf.c | 20 --------------------
 1 file changed, 20 deletions(-)

diff --git a/lib/test_bpf.c b/lib/test_bpf.c
index a5fddf9ebcb7..ca7d635bccd9 100644
--- a/lib/test_bpf.c
+++ b/lib/test_bpf.c
@@ -5275,31 +5275,21 @@ static struct bpf_test tests[] = {
 	{	/* Mainly checking JIT here. */
 		"BPF_MAXINSNS: Ctx heavy transformations",
 		{ },
-#if defined(CONFIG_BPF_JIT_ALWAYS_ON) && defined(CONFIG_S390)
-		CLASSIC | FLAG_EXPECTED_FAIL,
-#else
 		CLASSIC,
-#endif
 		{ },
 		{
 			{  1, SKB_VLAN_PRESENT },
 			{ 10, SKB_VLAN_PRESENT }
 		},
 		.fill_helper = bpf_fill_maxinsns6,
-		.expected_errcode = -ENOTSUPP,
 	},
 	{	/* Mainly checking JIT here. */
 		"BPF_MAXINSNS: Call heavy transformations",
 		{ },
-#if defined(CONFIG_BPF_JIT_ALWAYS_ON) && defined(CONFIG_S390)
-		CLASSIC | FLAG_NO_DATA | FLAG_EXPECTED_FAIL,
-#else
 		CLASSIC | FLAG_NO_DATA,
-#endif
 		{ },
 		{ { 1, 0 }, { 10, 0 } },
 		.fill_helper = bpf_fill_maxinsns7,
-		.expected_errcode = -ENOTSUPP,
 	},
 	{	/* Mainly checking JIT here. */
 		"BPF_MAXINSNS: Jump heavy test",
@@ -5350,28 +5340,18 @@ static struct bpf_test tests[] = {
 	{
 		"BPF_MAXINSNS: exec all MSH",
 		{ },
-#if defined(CONFIG_BPF_JIT_ALWAYS_ON) && defined(CONFIG_S390)
-		CLASSIC | FLAG_EXPECTED_FAIL,
-#else
 		CLASSIC,
-#endif
 		{ 0xfa, 0xfb, 0xfc, 0xfd, },
 		{ { 4, 0xababab83 } },
 		.fill_helper = bpf_fill_maxinsns13,
-		.expected_errcode = -ENOTSUPP,
 	},
 	{
 		"BPF_MAXINSNS: ld_abs+get_processor_id",
 		{ },
-#if defined(CONFIG_BPF_JIT_ALWAYS_ON) && defined(CONFIG_S390)
-		CLASSIC | FLAG_EXPECTED_FAIL,
-#else
 		CLASSIC,
-#endif
 		{ },
 		{ { 1, 0xbee } },
 		.fill_helper = bpf_fill_ld_abs_get_processor_id,
-		.expected_errcode = -ENOTSUPP,
 	},
 	/*
 	 * LD_IND / LD_ABS on fragmented SKBs
-- 
2.27.0

