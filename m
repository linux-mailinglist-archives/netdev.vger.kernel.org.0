Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7C014F5626
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 08:22:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230312AbiDFGIn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 02:08:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2361726AbiDFEb7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 00:31:59 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB40B264F68;
        Tue,  5 Apr 2022 17:36:30 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id n9so574315plc.4;
        Tue, 05 Apr 2022 17:36:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FGwusd761ZZmZCn6Lx1iBjIKmRJjAIBS+Tn3Y7KvQk4=;
        b=ogCxh//SGlbIZda9y8AAuQpajUpqX7pWroQr5OGfPAfgwVA0OEonu5uJ7pLurDzlQU
         VC1fBekbyF/svKWuIsGA1yIhxv389X+jGpjtGjQND8Udf8NVpTQPkACELsMUOpUeqJIu
         NgSRZv144GI3Ry/Oh+Vbn6mSlXbjwdr2MeHrsxzErbIdWd42brCBDooAI1lsyDROZ8xZ
         w1mnsPBhRr/Z74YzIPsPuCI73vOKEr+DVuZfS3qzuZyslX+oz8We8AryP44s8oMswyT9
         J5PsX7xHBWmHLwiwMBDikCzMRAp/OJPTy/acb1t27gu/3W7eolYvRwgt/81kxjTF1Gqr
         xSHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FGwusd761ZZmZCn6Lx1iBjIKmRJjAIBS+Tn3Y7KvQk4=;
        b=5v4ORP3y7qbj94znYIL8nA0zQlvhRAubAUVcCaHzX1n9VYDLX0Qm1XrKj0GEVwritc
         U7Voupq4WeXjnxSFL5JkGdqDod0AzQmmfmEhs8xJODiSsDR9ZC2NKY1th9vb+iJXwZ0t
         safN6fjY3eyBEHnDvsBsWrycknsI9ZxVKfgczVXY0tIO/ilov60FD1waXpcC+LLudsBv
         kIMIYXbFqgzADfmMR06p/AwCjaNl2tEm4syyBF5E71p3xZpJBes6V0Arz+z0EnWx+lBv
         8UUK0jlBojaZaf1d2OX1fjPdW9L2Av3/MO42qTJQ+p2j8015LLoNvNJPtWFNeFaCzw+l
         BEKA==
X-Gm-Message-State: AOAM531RepU54F0BAQ6/FgHfkyxm3CAB5UZdy7/LIX79GJZwyioXzCQy
        m7jr208jbUQOKVWWmNEkVMa9QicVgT3rtbeD
X-Google-Smtp-Source: ABdhPJzhqcBz/L8csTyTr7EEuoSCzaq9l0LNoKzELJvL4PkwN+jL3oaMn7PW7LlTGSzU9vU5JdDqZw==
X-Received: by 2002:a17:902:8644:b0:153:9f01:2090 with SMTP id y4-20020a170902864400b001539f012090mr5925967plt.101.1649205390463;
        Tue, 05 Apr 2022 17:36:30 -0700 (PDT)
Received: from localhost.localdomain ([223.212.58.71])
        by smtp.gmail.com with ESMTPSA id t15-20020a63b70f000000b00381510608e9sm14387946pgf.14.2022.04.05.17.36.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Apr 2022 17:36:29 -0700 (PDT)
From:   Yuntao Wang <ytcoode@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>, bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yuntao Wang <ytcoode@gmail.com>
Subject: [PATCH bpf-next v3] selftests/bpf: Fix issues in parse_num_list()
Date:   Wed,  6 Apr 2022 08:36:22 +0800
Message-Id: <20220406003622.73539-1-ytcoode@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <CAEf4BzbSbMMoZM-3fkhZnbxk0bu5ySDO782WGbgcKUzs-u6N_Q@mail.gmail.com>
References: <CAEf4BzbSbMMoZM-3fkhZnbxk0bu5ySDO782WGbgcKUzs-u6N_Q@mail.gmail.com>
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

The function does not check that parsing_end is false after parsing
argument. Thus, if the final part of the argument is something like '4-',
which is invalid, parse_num_list() will discard it instead of returning
-EINVAL.

Before:

 $ ./test_progs -n 2,4-
 #2 atomic_bounds:OK
 Summary: 1/0 PASSED, 0 SKIPPED, 0 FAILED

After:

 $ ./test_progs -n 2,4-
 Failed to parse test numbers.

Signed-off-by: Yuntao Wang <ytcoode@gmail.com>
---
v1 -> v2: add more details to commit message
v2 -> v3: remove the first part of the patch

 tools/testing/selftests/bpf/testing_helpers.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/testing_helpers.c b/tools/testing/selftests/bpf/testing_helpers.c
index 795b6798ccee..87867f7a78c3 100644
--- a/tools/testing/selftests/bpf/testing_helpers.c
+++ b/tools/testing/selftests/bpf/testing_helpers.c
@@ -60,7 +60,7 @@ int parse_num_list(const char *s, bool **num_set, int *num_set_len)
 			set[i] = true;
 	}
 
-	if (!set)
+	if (!set || parsing_end)
 		return -EINVAL;
 
 	*num_set = set;
-- 
2.35.1

