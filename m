Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1831D4F464C
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 01:11:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386991AbiDEO21 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 10:28:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347302AbiDEOV2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 10:21:28 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3683759A6F;
        Tue,  5 Apr 2022 06:09:26 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id r66so2155543pgr.3;
        Tue, 05 Apr 2022 06:09:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CCF1afPoawtHj0JOT1YQhvzf/ufI9/Oj+shVoKXn1Y8=;
        b=fZLMgfdtHl+NM3WmcMNrwWJPDKgRQt2/1OM07KtMCrcmk2U2vmIpJBjscRNQAcklge
         RuBehxhNk/sFgRQ/ja43GuH+Plx5oh3u/OiQ5wETBNtWNVWY+2DN9ijhri17gBzNdKTy
         MVb9nvuzayns4tOL0GFFORhcDfseJQFVnPSQ9k7vYAC5RSesEQqC2tgDRRb0xR2bHjrf
         Malb7fC47ISfHqvEZ+CZDlPNPFRMKkZKdttRzrFoAFOeS0YPm1CNf1hxEuzEKtisUvls
         fq9JWFXhzkkmfaWmHXIHY7cDAVUexFXXryUdluZC868pnTX7J2fMbS4m87wjj36Q8/xj
         e0Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CCF1afPoawtHj0JOT1YQhvzf/ufI9/Oj+shVoKXn1Y8=;
        b=n8AKa5I4lvLgqsGh7unM/4K5AaA5/3nqYvFKhFQ5+PH5Ln6fxkz3Q79ProBahA6xMc
         ByzotV5hvL6t8B+E9RiUniXytAkwY7jIENFsCS6wSUflj1BSFVGnyyo5M0ZQ+y9Tqp/Y
         iuv2gtqpeJJN7VLNvVzlxPSSq7Y3BR8y0znbyZYIyQkPtk1GEk3SRFOa2msi8BBQODBf
         f2eFqO4Lni0AfW4paA57IQuPFkXXchgU1zyheL/qGajvs6rrGRf7yg1EowTpEpL3NNDq
         XmaScyFfpsjgRvZb5DB1g+rPmIwOhLrJ6kOrbnnrXGdCoZ1mIJUwfuOdhApy4Qo8loAd
         Dz4A==
X-Gm-Message-State: AOAM5327GPGq0HpgOUNJwATszqrsqzV8CljDK4kZwOOFU42cPCp5N+ac
        FX/tf+OOdPLyz0buR/okfKk=
X-Google-Smtp-Source: ABdhPJy0gv5QTBC2xRp/kRNuSuV/7NhyZvy59r7ywNFTqEeprnQIDvH98c+dZzkcvN3HTsksVxmQqQ==
X-Received: by 2002:a62:6d47:0:b0:4fe:15fa:301d with SMTP id i68-20020a626d47000000b004fe15fa301dmr3531643pfc.29.1649164165715;
        Tue, 05 Apr 2022 06:09:25 -0700 (PDT)
Received: from vultr.guest ([2001:19f0:6001:5271:5400:3ff:feef:3aee])
        by smtp.gmail.com with ESMTPSA id s135-20020a63778d000000b0038259e54389sm13147257pgc.19.2022.04.05.06.09.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Apr 2022 06:09:24 -0700 (PDT)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     andrii@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, shuah@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH bpf-next v3 08/27] bpf: selftests: Set libbpf 1.0 API mode explicitly in test_lpm_map
Date:   Tue,  5 Apr 2022 13:08:39 +0000
Message-Id: <20220405130858.12165-9-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220405130858.12165-1-laoar.shao@gmail.com>
References: <20220405130858.12165-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Let's set libbpf 1.0 API mode explicitly, then we can get rid of the
included bpf_rlimit.h.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 tools/testing/selftests/bpf/test_lpm_map.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/test_lpm_map.c b/tools/testing/selftests/bpf/test_lpm_map.c
index aa294612e0a7..789c9748d241 100644
--- a/tools/testing/selftests/bpf/test_lpm_map.c
+++ b/tools/testing/selftests/bpf/test_lpm_map.c
@@ -26,7 +26,6 @@
 #include <bpf/bpf.h>
 
 #include "bpf_util.h"
-#include "bpf_rlimit.h"
 
 struct tlpm_node {
 	struct tlpm_node *next;
@@ -791,6 +790,9 @@ int main(void)
 	/* we want predictable, pseudo random tests */
 	srand(0xf00ba1);
 
+	/* Use libbpf 1.0 API mode */
+	libbpf_set_strict_mode(LIBBPF_STRICT_ALL);
+
 	test_lpm_basic();
 	test_lpm_order();
 
-- 
2.17.1

