Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05D2C4F230A
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 08:24:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229743AbiDEG0X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 02:26:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230160AbiDEG0P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 02:26:15 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 517474A92A;
        Mon,  4 Apr 2022 23:24:18 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id s72so10238751pgc.5;
        Mon, 04 Apr 2022 23:24:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9GUsruz6B3w0Axl0o2TPf4NxgMV+fUjNMWSxDhpnwE8=;
        b=kVw8v4DyjMgH+aNdq/nchSpZw6WHAqn438+UkLwGZ1juVV658kSv0NVvXIdehhlVQG
         TIuLuwWL7NCSZxtTgEhMkbcLQf+Qdaul+Vv7jnHwlDbtgVkfOu6DuWutqKwc9RREKf9F
         HYmvSKqMt5/ARgJ6DuOtP+iT97mxtyR9ixAbLx46iTGz8algErtdg62diwC0sN3ZWEZu
         JhPBGzWzkam+AoklAMySwt8yWgfpBrjWAU1JRHgL1sQgjcT4g7DU8lnOqYRpFwRDvitn
         x+lsfgUMwStNHqroYc+kTDTdbu7rA9e4VbShxBrdniBojgzF4gnu0MtBVkhXWZclU98j
         fH6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9GUsruz6B3w0Axl0o2TPf4NxgMV+fUjNMWSxDhpnwE8=;
        b=NVPhI9/YB+NEukBCP2fE0vhxgcnwE15oxJxuDYqdiPPRlEI+fXPwjJrU3+n6DjdV3g
         KICLbPlnYLQMFDtazHI2uhOcD7m8Ef7xgKOAUdzpvVlMUKuOdFyd+wD3YAMbjew/M/LS
         bGhcXucPuVQ5IkJMwok3sZZOe5vXS9yBhOnpM49jJWxkh/ZhVRNNtj9b9bNedQ41IxTB
         enztIttirBZo73Ef+v4+nmt4lZiGiEsdfCeA5zfkOYMM3Ldo+ijzOfymYTmE12Vn8bsG
         0aj8QquI3rwjMHIWvycNNZhZqPyaAmJY+8vr5LVjRIFG1CfE2JULer9mCFF+uXVMFZJo
         03qg==
X-Gm-Message-State: AOAM530nZg849OKhBki/GwRG/sKBFjoifD15owo+6SsTBO7YFOGqd+Jr
        aHdfwDz2EDHx4HcfHwZ/NSo=
X-Google-Smtp-Source: ABdhPJyf1l3yMGL89HwXg1EBY31BDpOMFFbLWzIYD4wq4gW9quqbQ68QcgKekzs+tI1kgrp01uCsrQ==
X-Received: by 2002:a63:b555:0:b0:398:4ca1:4be0 with SMTP id u21-20020a63b555000000b003984ca14be0mr1605561pgo.294.1649139857737;
        Mon, 04 Apr 2022 23:24:17 -0700 (PDT)
Received: from localhost.localdomain ([223.212.58.71])
        by smtp.gmail.com with ESMTPSA id c11-20020a056a000acb00b004f35ee129bbsm15627030pfl.140.2022.04.04.23.24.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Apr 2022 23:24:17 -0700 (PDT)
From:   Yuntao Wang <ytcoode@gmail.com>
To:     andrii.nakryiko@gmail.com
Cc:     andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, john.fastabend@gmail.com, kafai@fb.com,
        kpsingh@kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        shuah@kernel.org, songliubraving@fb.com, yhs@fb.com,
        ytcoode@gmail.com
Subject: [PATCH bpf-next v2] selftests/bpf: Fix issues in parse_num_list()
Date:   Tue,  5 Apr 2022 14:24:03 +0800
Message-Id: <20220405062403.22591-1-ytcoode@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <CAEf4BzZrc=wr4FLkWkOSEeprzybA8JTipsnr_U1kYA0785WkTw@mail.gmail.com>
References: <CAEf4BzZrc=wr4FLkWkOSEeprzybA8JTipsnr_U1kYA0785WkTw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are some issues in parse_num_list():

First, the end variable is assigned twice when parsing_end is true, it is
unnecessary.

Second, the function does not check that parsing_end is false after parsing
argument. Thus, if the final part of the argument is something like '4-',
parse_num_list() will discard it instead of returning -EINVAL.

Clean up parse_num_list() and fix these issues.

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

 tools/testing/selftests/bpf/testing_helpers.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/bpf/testing_helpers.c b/tools/testing/selftests/bpf/testing_helpers.c
index 795b6798ccee..82f0e2d99c23 100644
--- a/tools/testing/selftests/bpf/testing_helpers.c
+++ b/tools/testing/selftests/bpf/testing_helpers.c
@@ -20,16 +20,16 @@ int parse_num_list(const char *s, bool **num_set, int *num_set_len)
 		if (errno)
 			return -errno;
 
-		if (parsing_end)
-			end = num;
-		else
+		if (!parsing_end) {
 			start = num;
+			if (*next == '-') {
+				s = next + 1;
+				parsing_end = true;
+				continue;
+			}
+		}
 
-		if (!parsing_end && *next == '-') {
-			s = next + 1;
-			parsing_end = true;
-			continue;
-		} else if (*next == ',') {
+		if (*next == ',') {
 			parsing_end = false;
 			s = next + 1;
 			end = num;
@@ -60,7 +60,7 @@ int parse_num_list(const char *s, bool **num_set, int *num_set_len)
 			set[i] = true;
 	}
 
-	if (!set)
+	if (!set || parsing_end)
 		return -EINVAL;
 
 	*num_set = set;
-- 
2.35.1

