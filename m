Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 174404AC271
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 16:07:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357095AbiBGPFk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 10:05:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442521AbiBGOwZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 09:52:25 -0500
Received: from mail-ua1-x930.google.com (mail-ua1-x930.google.com [IPv6:2607:f8b0:4864:20::930])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BAA1C0401C2
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 06:52:25 -0800 (PST)
Received: by mail-ua1-x930.google.com with SMTP id g18so13049861uak.5
        for <netdev@vger.kernel.org>; Mon, 07 Feb 2022 06:52:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kinvolk.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Mtx2YBw2ZJ4lWpSF8NYCcRXkDCZX1esZEmumdIEB7tc=;
        b=U9paWWLNk2naINhsgRGAFDCSxBYYkUqv8/GYR8vpcrB6Pp9fyJC1JBpm3S5vT4qBpf
         op5bIGf2ej/q6x+AFkX/k6bpdkpG97moFbU8uwTTdRNN+jJqFBGjzbdi61KH/0BrZR/R
         8ZfQCc9wP8nl5sV1yXdgl/5f4qQjC0+Lnz5fo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Mtx2YBw2ZJ4lWpSF8NYCcRXkDCZX1esZEmumdIEB7tc=;
        b=AC7+aFkoTTPK0sDJU6yj9JakAMUXsqAAWgYR51llS8ymjaf2df30k8ojpH2cZP1mqP
         f5H3MPVqphiO/8pedqv7h4kxfPh7zaPujOYyJt3OcGjyMzqNfALDI75rr76olHRIGm/E
         11WPqaPbnUr1IAtm7SXo7eK6qRY/QYSsB37oZ6AtFgRsWykFQkZhVvg7xoISU9om+pRT
         zwJU9oSqEH2m2eAwk+mFooniRPLjqgc8WnYuBJBIFw3dzn8q+tucwDCWnm60Rgco7kNw
         u9loUdG6uDa+L1cGLfIZ+U6QaKz2N0UMih82F1G3ICng5Kg6UglU6ohBM5Va2z3er9x4
         4XQA==
X-Gm-Message-State: AOAM532xFRoTx6jQWpZLmQuGDNsBZfkhaaPgxDnqr9PNa5Gp0zjpvJCE
        0TrIkgue+O5bFeLsGAiYnOrqDqKytkMGScP4cvrAIaEG46XgjfwgPCQCzSn1I7dYUPvIgKIflSx
        n81tad2Tpid2hj9bUkd9WB3T+TvOHSTFMHA8/fWCAYe90VmU+9qjrNnW2u18trgCegqemjQ==
X-Google-Smtp-Source: ABdhPJzeQG9FgL2MZ4q9NP9LpbIoI173m00Efi+GPRo9FgOW6LMbiyuUzW1kbiJEpnKsjaRQxlBjHA==
X-Received: by 2002:a67:f8d7:: with SMTP id c23mr4266012vsp.35.1644245541813;
        Mon, 07 Feb 2022 06:52:21 -0800 (PST)
Received: from localhost.localdomain ([181.136.110.101])
        by smtp.gmail.com with ESMTPSA id r14sm581347vke.20.2022.02.07.06.52.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 06:52:21 -0800 (PST)
From:   =?UTF-8?q?Mauricio=20V=C3=A1squez?= <mauricio@kinvolk.io>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next v2 3/3] selftests/bpf: Fix strict mode calculation
Date:   Mon,  7 Feb 2022 09:50:52 -0500
Message-Id: <20220207145052.124421-4-mauricio@kinvolk.io>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220207145052.124421-1-mauricio@kinvolk.io>
References: <20220207145052.124421-1-mauricio@kinvolk.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"(__LIBBPF_STRICT_LAST - 1) & ~LIBBPF_STRICT_MAP_DEFINITIONS" is wrong
as it is equal to 0 (LIBBPF_STRICT_NONE). Let's use
"LIBBPF_STRICT_ALL & ~LIBBPF_STRICT_MAP_DEFINITIONS" now that the
previous commit makes it possible in libbpf.

Fixes: 93b8952d223a ("libbpf: deprecate legacy BPF map definitions")

Signed-off-by: Mauricio Vásquez <mauricio@kinvolk.io>
---
 tools/testing/selftests/bpf/prog_tests/btf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/btf.c b/tools/testing/selftests/bpf/prog_tests/btf.c
index 14f9b6136794..4b93789acd86 100644
--- a/tools/testing/selftests/bpf/prog_tests/btf.c
+++ b/tools/testing/selftests/bpf/prog_tests/btf.c
@@ -4561,7 +4561,7 @@ static void do_test_file(unsigned int test_num)
 	btf_ext__free(btf_ext);
 
 	/* temporary disable LIBBPF_STRICT_MAP_DEFINITIONS to test legacy maps */
-	libbpf_set_strict_mode((__LIBBPF_STRICT_LAST - 1) & ~LIBBPF_STRICT_MAP_DEFINITIONS);
+	libbpf_set_strict_mode(LIBBPF_STRICT_ALL & ~LIBBPF_STRICT_MAP_DEFINITIONS);
 	obj = bpf_object__open(test->file);
 	err = libbpf_get_error(obj);
 	if (CHECK(err, "obj: %d", err))
-- 
2.25.1

